import os
from pathlib import Path
import logging

import click
import geopandas
import numpy
import rasterio
from rasterio import features
from skimage.filters.rank import majority
import skimage.morphology as morphology
from sqlalchemy import create_engine

LOG = logging.getLogger(__name__)


def load_rasters(shape, transform, temp_path=False):
    """Load input slope raster and additional boolean rasters"""
    LOG.info("Loading data")
    # define key and code values for additional features
    queries = {
        "studyarea": 0,
        "waterbodies": 1,
        "floodplain": 2,
        "sidechannels": 3,
        "linear_habitat": 4,
        "linear_accessible": 5,
        "linear_habitat_below_rail": 6,
        "rail": 7,
        "rail_bridges": 8,
        "urban_btm": 9,
    }
    rasters = {}
    # if provided a temp_path, try and load everything from there
    if temp_path:
        for key in queries.keys():
            temp_raster = os.path.join(temp_path, key + ".tif")
            if os.path.exists(temp_raster):
                with rasterio.open(temp_raster) as src:
                    rasters[key] = src.read(1)

    # initialize database connection
    con = create_engine(os.environ.get("DATABASE_URL"))

    # load all features from lateral_poly table
    for key in queries:
        if key not in rasters.keys():
            LOG.info("Loading " + key)
            query = "select geom from bcfishpass.lateral_poly where code = " + str(
                queries[key]
            )
            polys = geopandas.GeoDataFrame.from_postgis(query, con)
            # rasterize polygon features, creating boolean array
            rasters[key] = features.rasterize(
                ((geom, 1) for geom in polys.geometry),
                out_shape=shape,
                transform=transform,
                all_touched=False,
                dtype=numpy.uint8,
            )

    # load esa land use raster
    with rasterio.open(r"data/esa_bc.tif") as src:
        rasters["urban_esa"] = src.read(1)
    # extract only urban (50) areas
    rasters["urban_esa"] = numpy.where(rasters["urban_esa"] == 50, 1, 0)

    return rasters


def filter_connected(in_array, habitat_array):
    """
    Return portions of in_array that are connected to cells with value 1
    in habitat_array
    """
    # label distinct patches of in_array
    labels = morphology.label(in_array, connectivity=1)

    # find labels that intersect habitat_array
    mask = habitat_array == 1
    habitat_labels = labels[mask]
    connected_mask = numpy.isin(labels, numpy.unique(habitat_labels))

    # return only areas with labels that intersect habitat
    return numpy.where(connected_mask == 1, in_array, 0)


@click.command()
@click.argument("path_to_slope_raster", type=click.Path(exists=True))
@click.option("--out_file", "-o", default="lateral.tif")
@click.option("--temp_path")
def lateral(path_to_slope_raster, out_file, temp_path):
    """Find areas that may be lateral/off channel habitat areas"""
    rasters = {}

    # load slope raster that defines transform/shape of all other rasters
    with rasterio.open(path_to_slope_raster) as src:
        slope = src.read(1).astype(numpy.uint8)
        shape = src.shape
        transform = src.transform

    # add sources from postgres
    rasters = load_rasters(shape, transform, temp_path)

    # set slope to zero for 20m around rail lines (so they do not
    # create exclusions to *potential* lateral habitat)
    #slope = numpy.where(rasters["rail"] == 1, 0, slope)

    # initialize the output surface
    LOG.info("Creating initial surface")
    rasters["lateral1"] = numpy.zeros(shape).astype(numpy.uint8)

    # load slope<=4pct
    rasters["slope_low"] = numpy.where(slope <= 4, 1, 0).astype(numpy.uint8)

    # add slope
    rasters["lateral1"] = numpy.where(
        rasters["slope_low"] == 1,
        1,
        rasters["lateral1"],
    )

    # remove small holes from the initial surface
    rasters["lateral2"] = morphology.remove_small_holes(
        rasters["lateral1"], 4, connectivity=1
    )

    # remove areas not connected to habitat
    rasters["lateral3"] = filter_connected(
        rasters["lateral2"], rasters["linear_habitat"]
    )

    # add stream buffers
    rasters["lateral4"] = numpy.where(
        rasters["linear_accessible"] == 1, 1, rasters["lateral3"]
    )

    # extract slope 10pct and more
    rasters["slope_high"] = numpy.where(
        slope >= 10, 1, 0
    ).astype(numpy.uint8)

    # filter out steep areas
    rasters["lateral5"] = numpy.where(
        rasters["slope_high"] == 1, 0, rasters["lateral4"]
    )

    # add floodplain
    rasters["lateral6"] = numpy.where(
        rasters["floodplain"] == 1, 1, rasters["lateral5"]
    )

    # filter out urban/built up areas
    rasters["lateral7"] = numpy.where(
        (rasters["urban_esa"] == 1) | (rasters["urban_btm"] == 1),
        0,
        rasters["lateral6"]
    )

    # finally, add waterbodies and sidechannels
    rasters["lateral8"] = numpy.where(
        (rasters["waterbodies"] == 1)
        | (rasters["sidechannels"] == 1), 1, rasters["lateral7"]
    )

    # again remove areas not connected to habitat
    rasters["lateral9"] = filter_connected(
        rasters["lateral8"], rasters["linear_habitat"]
    )

    # and fill small holes
    rasters["lateral_potential"] = morphology.remove_small_holes(
        rasters["lateral9"], 4, connectivity=1
    )

    # --------------------------
    # find areas isolated by rail
    # --------------------------
    LOG.info("Finding areas disconnected by railways")
    # remove bridges from rail raster
    rasters["rail_breached"] = numpy.where(
        rasters["rail_bridges"] == 1, 0, rasters["rail"]
    )

    # remove rail area from output raster
    rasters["lateral_minusrail"] = numpy.where(rasters["rail_breached"], 0, rasters["lateral_potential"])

    # remove disconnected areas
    rasters["lateral_minusrail2"] = filter_connected(
        rasters["lateral_minusrail"], rasters["linear_habitat_below_rail"]
    )

    # create output raster with values:
    # 1=connected lateral habitat
    # 2=lateral habitat disconnected by rail
    rasters["lateral"] = numpy.where(rasters["lateral_potential"] == 1, 2, 0)
    rasters["lateral"] = numpy.where(rasters["lateral_minusrail2"] == 1, 1, rasters["lateral"])

    # --------------------------
    # write output(s) to file
    # --------------------------
    # re-read slope to get crs / width / height etc
    LOG.info("Writing output raster(s)")
    with rasterio.open(path_to_slope_raster) as src:
        # double check output is cut to study area
        rasters["lateral"] = numpy.where(
            rasters["studyarea"] == 1, rasters["lateral"], 255
        )
        # write output raster
        with rasterio.open(
            out_file,
            "w",
            driver="GTiff",
            dtype=rasterio.uint8,
            count=1,
            width=src.width,
            height=src.height,
            crs=src.crs,
            transform=src.transform,
            nodata=255,
        ) as dst:
            dst.write(rasters["lateral"].astype(numpy.uint8), indexes=1)

        # write tempfiles if so directed
        if temp_path:
            # create folder to dump temp files
            Path(temp_path).mkdir(parents=True, exist_ok=True)
            dumps = [
                d
                for d in rasters.keys()
                if type(rasters[d]) == numpy.ndarray
                and rasters[d].shape == shape
                and d != "lateral"
            ]
            for key in dumps:
                # ensure dump is cut to study area
                rasters[key] = numpy.where(rasters["studyarea"] == 1, rasters[key], 255)
                with rasterio.open(
                    os.path.join(temp_path, key + ".tif"),
                    "w",
                    driver="GTiff",
                    dtype=rasterio.uint8,
                    count=1,
                    width=src.width,
                    height=src.height,
                    crs=src.crs,
                    transform=src.transform,
                    nodata=255,
                ) as dst:
                    dst.write(rasters[key].astype(numpy.uint8), indexes=1)


if __name__ == "__main__":
    lateral()
