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
import sys
import configparser
from math import trunc

import click
import numpy
import pandas
import geopandas
from sqlalchemy import create_engine
import rasterio
from rasterio import features
from rasterio.enums import Resampling
from rasterio.windows import from_bounds
from skimage.graph import MCP_Geometric
from scipy.ndimage import distance_transform_edt
from scipy.interpolate import griddata
from skimage.filters.rank import majority
import skimage.morphology as morphology
from skimage.feature import peak_local_max
from skimage.segmentation import watershed
from scipy.ndimage import label as ndi_label
from cligj import verbose_opt, quiet_opt

import bcdata


LOG = logging.getLogger(__name__)


def align(bounds):
    """
    Adjust input bounds to align with BC DEM
    """
    ll = [((trunc(b / 100) * 100) - 12.5) for b in bounds[:2]]
    ur = [(((trunc(b / 100) + 1) * 100) + 87.5) for b in bounds[2:]]
    return (ll[0], ll[1], ur[0], ur[1])


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


def label_map(a):
    shape = a.shape
    a = a.ravel()
    indices = numpy.argsort(a)
    bins = numpy.bincount(a)
    indices = numpy.split(indices, numpy.cumsum(bins[bins > 0][:-1]))
    return dict(
        list(zip(numpy.unique(a), [numpy.unravel_index(ind, shape) for ind in indices]))
    )


def get_dem(bounds, data_path, dem_path):
    """For given bounds, clip DEM from provided dem_path, or request BC DEM from DataBC
    """
    if dem_path:
        LOG.info("Clipping DEM to extent")
        bounds = align(bounds)
        with rasterio.open(dem_path) as src:
            bounds_window = src.window(*bounds)
            out_window = bounds_window.round_lengths()
            height = int(out_window.height)
            width = int(out_window.width)
            out_kwargs = src.profile
            out_kwargs.update({
                'height': height,
                'width': width,
                'transform': src.window_transform(out_window)})
            with rasterio.open(os.path.join(data_path, "dem.tif"), "w", **out_kwargs) as out:
                out.write(
                    src.read(
                        window=out_window,
                        out_shape=(src.count, height, width),
                        boundless=True,
                        masked=True,
                    )
                )

    else:
        LOG.info("Downloading DEM")
        dataset = bcdata.get_dem(
            bounds, os.path.join(data_path, "dem.tif"), as_rasterio=True, align=True)
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


def get_streams(db, bounds, minimum_drainage_area, DEM, dem_meta, data_path):
    """write accessible streams within bounds to raster"""
    sql = """SELECT
      s.linear_feature_id,
      round(ua.upstream_area_ha::numeric) as upstream_area_ha,
      s.stream_order_parent,
      s.gradient,
      s.geom
    FROM bcfishpass.streams s
    LEFT OUTER JOIN whse_basemapping.fwa_streams_watersheds_lut l
    ON s.linear_feature_id = l.linear_feature_id
    INNER JOIN whse_basemapping.fwa_watersheds_upstream_area ua
    ON l.watershed_feature_id = ua.watershed_feature_id
    where s.geom && ST_MakeEnvelope(%(xmin)s,%(ymin)s,%(xmax)s,%(ymax)s)
    and s.gradient < .3
    and
    (model_access_ch_co_sk is not null or
    model_access_st is not null or
    model_access_wct is not null or
    model_access_bt is not null or
    model_access_gr is not null or
    model_access_rb is not null)
    """
    stream_features = geopandas.read_postgis(
        sql,
        db,
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


def get_precip(db, bounds, DEM, dem_meta, data_path):
    """get precip per fundamental watershed"""
    sql = """select
      a.watershed_feature_id,
      b.map,
      (st_dump(a.geom)).geom as geom
    from whse_basemapping.fwa_watersheds_poly a
    inner join bcfishpass.mean_annual_precip b
    on a.wscode_ltree = b.wscode_ltree and a.localcode_ltree = b.localcode_ltree
    where a.geom && ST_MakeEnvelope(%(xmin)s,%(ymin)s,%(xmax)s,%(ymax)s)
    and b.map is not null;
    """
    precip_features = geopandas.read_postgis(
        sql,
        db,
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


def valley_confinement(
    watershed_group_code,
    db_url,
    out_file,
    data_path="data",
    minimum_drainage_area=1000,
    slope_threshold=9,
    max_width=2000,
    cost_threshold=2500,
    flood_factor=6,
    size_threshold=5000,
    hole_removal_threshold=2500,
    calculate_width=False,
    write_tempfiles=False,
    dem_path=None
):
    """Define 'unconfined' valleys"""
    db = create_engine(db_url)
    sql = """select st_xmin(geom), st_ymin(geom), st_xmax(geom), st_ymax(geom)
    from whse_basemapping.fwa_watershed_groups_poly
    where watershed_group_code = %(wsg)s"""
    bbox = pandas.read_sql_query(
        sql,
        db,
        params={
            "wsg": watershed_group_code,
        },
    )
    bounds = [
        bbox["st_xmin"][0],
        bbox["st_ymin"][0],
        bbox["st_xmax"][0],
        bbox["st_ymax"][0],
    ]
    LOG.info(f"{watershed_group_code} - Processing extent " + ",".join([str(b) for b in bounds]))

    # ---------------------
    # load input rasters
    # ---------------------
    
    # dem
    if not os.path.exists(os.path.join(data_path, "dem.tif")):
        LOG.info(f"{watershed_group_code} - extracting DEM")
        get_dem(bounds, data_path, dem_path)
    dem = rasterio.open(os.path.join(data_path, "dem.tif"))
    dem_meta = dem.meta
    DEM = dem.read(1)
    
    # precip
    if not os.path.exists(os.path.join(data_path, "precip.tif")):
        LOG.info(f"{watershed_group_code} - rasterizing precip per watershed")
        get_precip(db, bounds, DEM, dem_meta, data_path)
    precip = rasterio.open(os.path.join(data_path, "precip.tif"))
    P = precip.read(1).astype("float32")
    
    # streams
    if not os.path.exists(os.path.join(data_path, "streams.tif")):
        LOG.info(f"{watershed_group_code} - rasterizing streams")
        get_streams(db, bounds, minimum_drainage_area, DEM, dem_meta, data_path)
    streams = rasterio.open(os.path.join(data_path, "streams.tif"))
    ST = streams.read(1)
    
    # slope
    if not os.path.exists(os.path.join(data_path, "slope.tif")):
        LOG.info(f"{watershed_group_code} - deriving slope")
        subprocess.run(
            [
                "gdaldem",
                "slope",
                "-p",
                os.path.join(data_path, "dem.tif"),
                os.path.join(data_path, "slope.tif"),
            ]
        )
    slope = rasterio.open(os.path.join(data_path, "slope.tif"))
    SL = slope.read(1)

    # initialize mask
    LOG.info(f"{watershed_group_code} - initializing and calculating distance to streams")
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
    LOG.info(f"{watershed_group_code} - calculating cost surface")
    cost = cost_surface(streams, slope)

    # update mask with specified cost threshold
    moving_mask = moving_mask & (cost < cost_threshold)

    # remove edge effects around the cost surface (ocean)
    moving_mask[cost == -9999] = False

    # write intermediate mask for QA
    if write_tempfiles:
        LOG.info("Writing cost_threshold.tif")
        with rasterio.open(
            os.path.join(data_path, "cost_threshold.tif"),
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
    LOG.info(f"{watershed_group_code} - flood processing")
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

    if write_tempfiles:
        LOG.info("Writing flood_depth.tif")
        with rasterio.open(
            os.path.join(data_path, "flood_depth.tif"),
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
    LOG.info(f"{watershed_group_code} - removing waterbodies")
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
    LOG.info(f"{watershed_group_code} - cleaning")
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

    # write unconfined valley output to file
    LOG.info(f"Writing {out_file}")
    with rasterio.open(
        out_file,
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

    if calculate_width:
        # calculate the width of the valley
        mask = valleys == 1
        LOG.info(f"{watershed_group_code} - calculating distance_transform")
        # Calculate distance to the bank over all valleys
        distances = distance_transform_edt(mask.astype("float32"), [dem.res[0], dem.res[1]])
        
        if write_tempfiles:
            with rasterio.open(
                os.path.join(data_path, "distance_transform.tif"),
                "w",
                driver="GTiff",
                dtype=rasterio.int32,
                count=1,
                width=dem.width,
                height=dem.height,
                crs=dem.crs,
                transform=dem.transform,
                nodata=-9999,
            ) as dst:
                dst.write(distances, indexes=1)

        # Calculate local maxima
        LOG.info(f"{watershed_group_code} - Calculating local maxima")
        local_maxi = peak_local_max(
            distances, indices=False, footprint=numpy.ones((3, 3)), labels=mask
        )

        LOG.info(f"{watershed_group_code} - Labeling maxima")
        breaks = ndi_label(local_maxi)[0]
        distance_map = {
            brk: dist for brk, dist in zip(breaks[local_maxi], distances[local_maxi])
        }

        LOG.info(f"{watershed_group_code} - Performing Watershed Segmentation")
        labels = watershed(-distances, breaks, mask=mask)

        LOG.info(f"{watershed_group_code} - Assigning distances to labels")
        for label, inds in list(label_map(labels).items()):
            if label == 0:
                continue
            distances[inds] = distance_map[label]

        LOG.info(f"{watershed_group_code} - Doubling dimensions")
        max_distance = numpy.sqrt(dem.res[0] ** 2 + dem.res[1] ** 2) * 2
        distances[distances > max_distance] *= 2

        output = valleys.astype("float32")
        output[:] = distances.astype("float32")

        with rasterio.open(
            os.path.join(data_path, "valley_width.tif"),
            "w",
            driver="GTiff",
            dtype=rasterio.int32,
            count=1,
            width=dem.width,
            height=dem.height,
            crs=dem.crs,
            transform=dem.transform,
            nodata=-9999,
        ) as dst:
            dst.write(output, indexes=1)


class ConfigError(Exception):
    """Configuration key error"""


def read_config(config_file):
    """Read provided config file"""
    LOG.info("Loading config from file: %s", config_file)
    cfg = configparser.ConfigParser()
    cfg.read(config_file)
    valid_keys = [
        "minimum_drainage_area",
        "slope_threshold",
        "cost_threshold",
        "max_width",
        "flood_factor",
        "size_threshold",
        "hole_removal_threshold",
        "calculate_width"
    ]
    # check keys are valid
    for key in cfg["CONFIG"].keys():
        if key not in valid_keys:
            raise ConfigError("Config key {} is invalid".format(key))
    # convert all keys to integer
    config = {key: int(cfg["CONFIG"][key]) for key in cfg["CONFIG"].keys()}
    return config


@click.command()
@click.argument("watershed_group_code", type=click.STRING)
@click.option(
    "--db_url",
    "-db",
    help="bcfishpass database url, defaults to $DATABASE_URL environment variable if set",
    default=os.environ.get("DATABASE_URL"),
)
@click.option(
    "--out_file",
    "-o",
    default="valleys.tif",
    help="Path to write output valley confinement raster",
)
@click.option(
    "--workdir",
    "-d",
    type=click.Path(exists=True),
    default="data",
    help="Path to write output temp rasters",
)
@click.option(
    "--dem",
    type=click.Path(exists=True),
    default=os.environ.get("DEM10M"),
    help="Path to existing 10m DEM",
)
@click.option(
    "--config_file",
    "-cfg",
    type=click.Path(exists=True),
    help="Valley confinement parameter configuration file",
)
@click.option(
    "--write_tempfiles",
    "-w",
    is_flag=True,
    show_default=True,
    default=False,
    help="Write temp rasters to --data_path",
)
@verbose_opt
@quiet_opt
def cli(watershed_group_code, db_url, out_file, workdir, dem, config_file, write_tempfiles, verbose, quiet):
    verbosity = verbose - quiet
    log_level = max(10, 20 - 10 * verbosity)  # default to INFO log level
    logging.basicConfig(
        stream=sys.stderr,
        level=log_level,
        format="%(asctime)s %(name)-12s %(levelname)-8s %(message)s",
    )
    if config_file:
        config = read_config(config_file)
    else:
        config = {}
    valley_confinement(watershed_group_code, db_url, out_file, workdir, dem_path=dem, **config)


if __name__ == "__main__":
    cli()
