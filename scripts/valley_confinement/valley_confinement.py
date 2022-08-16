"""
Valley Confinement

https://www.fs.fed.us/rm/boise/AWAE/projects/valley_confinement/downloads/VCA_Toolbox.zip
https://github.com/bluegeo/bluegeo/blob/master/bluegeo/water.py

Copyright 2020 Blue Geosimulation

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in the
Software without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so, subject to the
following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"""

import os
import logging
import subprocess

import numpy
import geopandas
from sqlalchemy import create_engine
import rasterio
from rasterio import features
from rasterio.enums import Resampling
from skimage.graph import MCP_Geometric
from scipy.ndimage import distance_transform_edt
from scipy.interpolate import griddata
from skimage.filters.rank import majority
import skimage.morphology as morphology

import bcdata


LOG = logging.getLogger(__name__)


def cost_surface(sources, cost):
    """
    Generate a cost surface from two rasterio dataset reader objects
    """
    # read the raster data
    src = sources.read(1)
    cst = cost.read(1)

    # remove nodata, filling with infinity
    src = src != sources.meta["nodata"]
    _cst = cst
    m = _cst != cost.meta["nodata"]
    _cst[~m] = numpy.inf
    _cst[src] = 0

    # Compute cost network
    mcp = MCP_Geometric(_cst, sampling=(cost.res[1], cost.res[0]))
    cost_network, traceback = mcp.find_costs(numpy.array(numpy.where(src)).T)
    # Prepare output
    out = cst.astype("float32")
    cost_network[
        numpy.isnan(cost_network) | numpy.isinf(cost_network) | ~m
    ] = cost.meta["nodata"]
    out[:] = cost_network

    return out


def prep_inputs(bounds, data_path, con, minimum_drainage_area):
    """Download/extract and prep source data (dem, slope, streams, precip)"""
    LOG.info("Downloading and resampling DEM to 10m")
    with bcdata.get_dem(
        bounds, os.path.join(data_path, "dem.tif"), as_rasterio=True
    ) as dataset:
        upscale_factor = 2.5  # upscale 25m DEM to 10m
        height = int(dataset.height * upscale_factor)
        width = int(dataset.width * upscale_factor)
        dem_data = dataset.read(
            out_shape=(dataset.count, height, width), resampling=Resampling.bilinear
        )
        # scale image transform
        transform = dataset.transform * dataset.transform.scale(
            (dataset.width / dem_data.shape[-1]), (dataset.height / dem_data.shape[-2])
        )
    # overwrite downloaded dem file with 10m file
    with rasterio.open(
        os.path.join(data_path, "dem.tif"),
        "w",
        driver="GTiff",
        dtype=rasterio.int32,
        count=1,
        height=height,
        width=width,
        crs=dataset.crs,
        transform=transform,
        nodata=dataset.nodata,
    ) as dst:
        dst.write(dem_data)
    # reload to get updated metadata
    with rasterio.open(os.path.join(data_path, "dem.tif")) as d:
        dem_meta = d.meta
        DEM = d.read(1)

    # load streams from fwa, extracting contributing area and parent order
    LOG.info("Extracting streams and writing to raster")
    sql = """SELECT
      s.linear_feature_id,
      round(ua.upstream_area_ha::numeric) as upstream_area_ha,
      p.stream_order_parent,
      s.gradient,
      s.geom
    FROM bcfishpass.streams s
    LEFT OUTER JOIN whse_basemapping.fwa_streams_watersheds_lut l
    ON s.linear_feature_id = l.linear_feature_id
    INNER JOIN whse_basemapping.fwa_watersheds_upstream_area ua
    ON l.watershed_feature_id = ua.watershed_feature_id
    LEFT OUTER JOIN whse_basemapping.fwa_stream_order_parent p
    ON s.blue_line_key = p.blue_line_key
    where s.geom && ST_MakeEnvelope(%(xmin)s,%(ymin)s,%(xmax)s,%(ymax)s)
    and s.gradient < .3
    and
    (access_model_ch_co_sk is not null or
    access_model_st is not null or
    access_model_wct is not null or
    access_model_pk is not null or
    access_model_cm is not null or
    access_model_bt is not null or
    access_model_gr is not null or
    access_model_rb is not null or
    spawning_model_ch is not null)
    """
    stream_features = geopandas.read_postgis(
        sql,
        con,
        params={
            "xmin": bounds[0],
            "ymin": bounds[1],
            "xmax": bounds[2],
            "ymax": bounds[3],
        },
    )

    # retain streams:
    # - with contributing area greater than minimum_drainage_area parameter
    # - OR having a parent order > 4 or null (to retain small streams draining to ocean or major channels)
    stream_features = stream_features[
        (stream_features["upstream_area_ha"] >= minimum_drainage_area)
        | (stream_features["stream_order_parent"] >= 4)
        | (stream_features["stream_order_parent"].isna())
    ]

    # rasterize the streams, with cumulative drainage as raster value
    A = features.rasterize(
        (
            (geom, value)
            for geom, value in zip(
                stream_features.geometry, stream_features.upstream_area_ha
            )
        ),
        out_shape=DEM.shape,
        transform=dem_meta["transform"],
        all_touched=False,
        dtype=numpy.int32,
        fill=0,
    )
    # set areas of DEM nodata to nodata
    A[DEM == dem_meta["nodata"]] = 0

    # write streams raster to file
    with rasterio.open(
        os.path.join(data_path, "streams.tif"),
        "w",
        driver="GTiff",
        dtype=rasterio.int32,
        count=1,
        width=dem_meta["width"],
        height=dem_meta["height"],
        crs=dem_meta["crs"],
        transform=dem_meta["transform"],
        nodata=0,
    ) as dst:
        dst.write(A, indexes=1)

    # load precip per fundamental watershed
    LOG.info("Extracting watersheds/precip and writing to raster")
    sql = """select
      a.watershed_feature_id,
      b.map,
      (st_dump(a.geom)).geom as geom
    from whse_basemapping.fwa_watersheds_poly a
    inner join bcfishpass.mean_annual_precip b
    on a.wscode_ltree = b.wscode_ltree and a.localcode_ltree = b.localcode_ltree
    where a.geom && ST_MakeEnvelope(%(xmin)s,%(ymin)s,%(xmax)s,%(ymax)s)
    """
    precip_features = geopandas.read_postgis(
        sql,
        con,
        params={
            "xmin": bounds[0],
            "ymin": bounds[1],
            "xmax": bounds[2],
            "ymax": bounds[3],
        },
    )
    A = features.rasterize(
        (
            (geom, value)
            for geom, value in zip(precip_features.geometry, precip_features.map)
        ),
        out_shape=DEM.shape,
        transform=dem_meta["transform"],
        all_touched=False,
        dtype=numpy.int32,
        fill=-9999,
    )

    # set areas of DEM nodata to nodata
    A[DEM == dem_meta["nodata"]] = -9999

    # write to file
    with rasterio.open(
        os.path.join(data_path, "precip.tif"),
        "w",
        driver="GTiff",
        dtype=rasterio.int32,
        count=1,
        width=dem_meta["width"],
        height=dem_meta["height"],
        crs=dem_meta["crs"],
        transform=dem_meta["transform"],
        nodata=-9999,
    ) as dst:
        dst.write(A, indexes=1)

    # generate slope raster
    LOG.info("Generating slope raster")
    subprocess.run(
        [
            "gdaldem",
            "slope",
            "-p",
            os.path.join(data_path, "dem.tif"),
            os.path.join(data_path, "slope.tif"),
        ]
    )


def vca(
    data_path,
    slope_threshold,
    max_width,
    cost_threshold,
    flood_factor,
    size_threshold,
    hole_removal_threshold,
):
    # load input rasters
    dem = rasterio.open(os.path.join(data_path, "dem.tif"))
    DEM = dem.read(1)
    precip = rasterio.open(os.path.join(data_path, "precip.tif"))
    P = precip.read(1).astype("float32")
    streams = rasterio.open(os.path.join(data_path, "streams.tif"))
    ST = streams.read(1)
    slope = rasterio.open(os.path.join(data_path, "slope.tif"))
    SL = slope.read(1)

    # initialize mask
    moving_mask = numpy.zeros(shape=precip.shape, dtype="bool")

    # ---------------------
    # slope threshold
    # ---------------------
    if slope_threshold:
        moving_mask[(SL <= slope_threshold)] = 1

    # calculate distance to streams
    distance = distance_transform_edt(
        ST.astype("float32") == 0, [streams.res[0], streams.res[1]]
    )

    # ---------------------
    # max width
    # ---------------------
    # (including precip raster (watersheds) to remove oceean)
    if max_width:
        moving_mask = moving_mask & (distance < (max_width / 2)) & (P > 0)

    # ---------------------
    # slope-distance cost surface
    # ---------------------
    # Calculate a cost surface using slope and streams
    cost = cost_surface(streams, slope)

    # update mask with specified cost threshold
    moving_mask = moving_mask & (cost < cost_threshold)

    # remove edge effects around the cost surface (ocean)
    moving_mask[cost == -9999] = False

    # write intermediate mask for QA
    LOG.info("Writing intermediate data to cost_threshold.tif")
    with rasterio.open(
        "data/cost_threshold.tif",
        "w",
        driver="GTiff",
        dtype=rasterio.int16,
        count=1,
        width=dem.width,
        height=dem.height,
        crs=dem.crs,
        transform=dem.transform,
        nodata=-9999,
    ) as dst:
        dst.write(moving_mask, indexes=1)

    # ---------------------
    # flood processing
    # ---------------------
    # process precip per VCA coefficients
    pcp = P
    pcp[P < 0] = 0
    pcp = pcp**0.355

    # calc bankfull width, depth per VCA coefficents
    # (we could replace width with our own channel width)
    contrib = ST
    contrib[ST < 0] = 0
    bankfwtmp = (contrib**0.280) * 0.196
    bankfull_width = bankfwtmp * pcp
    bankfull_depth = bankfull_width**0.607 * 0.145
    flood_depth = bankfull_depth * flood_factor

    # add dem to flood depth
    flood_depth = flood_depth + DEM

    # set nodata areas to zero
    flood_depth[DEM == dem.nodata] = 0

    # interpolate flood depth outward from the streams using scipy interpolate.griddata
    # create mask from stream raster
    stream_mask = ST != 0
    # set flood depth to -9999 where there is no stream
    flood_depth[~stream_mask] = 0
    # define area to interpolate - within max width / 2 but not at stream itself
    xi = (flood_depth == 0) & (distance < (max_width / 2))

    points = flood_depth != 0  # non-null flood depth values
    values = flood_depth[points]
    points = numpy.where(points)
    points = numpy.vstack([points[0] * dem.res[1], points[1] * dem.res[0]]).T
    xi = numpy.where(xi)
    flood_depth[xi] = griddata(
        points, values, (xi[0] * dem.res[1], xi[1] * dem.res[0]), "linear"
    )

    flood_depth[DEM == dem.nodata] = 0
    flood_depth[numpy.isnan(flood_depth) | numpy.isinf(flood_depth)] = 0

    # subtract dem to get flood depth
    flood_depth = flood_depth - DEM

    # clean it up, setting nodata areas to -9999
    flood_depth[DEM == dem.nodata] = -9999
    flood_depth[flood_depth < 0] = -9999

    # set streams to zero
    flood_depth[stream_mask] = 0

    # set flooded areas to 1
    flood_depth[flood_depth > 0] = 10

    # add flood areas to mask
    moving_mask = moving_mask & (flood_depth > 0)

    LOG.info("Writing flood_depth.tif")
    with rasterio.open(
        "data/flood_depth.tif",
        "w",
        driver="GTiff",
        dtype=rasterio.int16,
        count=1,
        width=dem.width,
        height=dem.height,
        crs=dem.crs,
        transform=dem.transform,
        nodata=-9999,
    ) as dst:
        dst.write(moving_mask, indexes=1)

    # ---------------------
    # remove waterbodies
    # ---------------------
    sql = """select waterbody_key, geom from whse_basemapping.fwa_rivers_poly
    where geom && ST_MakeEnvelope(%(xmin)s,%(ymin)s,%(xmax)s,%(ymax)s)
    union all
    select waterbody_key, geom from whse_basemapping.fwa_lakes_poly
    where geom && ST_MakeEnvelope(%(xmin)s,%(ymin)s,%(xmax)s,%(ymax)s)
    union all
    select waterbody_key, geom from whse_basemapping.fwa_manmade_waterbodies_poly
    where geom && ST_MakeEnvelope(%(xmin)s,%(ymin)s,%(xmax)s,%(ymax)s)
    """
    wb_features = geopandas.read_postgis(
        sql,
        db,
        params={
            "xmin": bounds[0],
            "ymin": bounds[1],
            "xmax": bounds[2],
            "ymax": bounds[3],
        },
    )
    WB = features.rasterize(
        ((geom) for geom in wb_features.geometry),
        out_shape=dem.shape,
        transform=dem.transform,
        all_touched=False,
        dtype=numpy.int16,
        default_value=1,
        fill=0,
    )
    # set areas of DEM nodata to nodata
    WB[DEM == dem.nodata] = -9999

    # remove waterbodies from mask
    moving_mask = moving_mask & (WB != 1)

    # ------------------
    # filter output valleys array
    # ------------------
    valleys = moving_mask

    # closing filter
    valleys = morphology.closing(
        valleys, footprint=morphology.rectangle(nrows=3, ncols=3)
    )

    # fill remaining small holes, remove areas less than size_threshold
    cell_size = int(dem.res[1]) ** 2
    valleys = morphology.remove_small_holes(
        valleys, round(hole_removal_threshold / cell_size), connectivity=2
    )
    valleys = morphology.remove_small_objects(
        valleys, round(size_threshold / cell_size), connectivity=2
    )

    # majority filter
    valleys = majority(valleys.astype("uint8"), morphology.rectangle(nrows=3, ncols=3))

    # write output to file
    with rasterio.open(
        os.path.join(data_path, "valleys.tif"),
        "w",
        driver="GTiff",
        dtype=rasterio.int16,
        count=1,
        width=dem.width,
        height=dem.height,
        crs=dem.crs,
        transform=dem.transform,
        nodata=-9999,
    ) as dst:
        dst.write(valleys, indexes=1)


db_connection_url = "postgresql://postgres@localhost:5432/bcfishpass"
db = create_engine(db_connection_url)

# temp files
workdir = "data"

# parameters
bounds = [1107333, 399214, 1182103, 468390]
slope_threshold = 9
cost_threshold = 2500
max_width = 2000
flood_factor = 6
size_threshold = 5000  # .5ha
hole_removal_threshold = 2500  # .25ha

prep_inputs(bounds, workdir, db, minimum_drainage_area=1000)
vca(
    workdir,
    slope_threshold,
    max_width,
    cost_threshold,
    flood_factor,
    size_threshold,
    hole_removal_threshold,
)
