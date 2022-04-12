import os

import geopandas
import numpy
import rasterio
from rasterio import features
from skimage.filters.rank import majority
import skimage.morphology as morphology
from sqlalchemy import create_engine

def load_pg(shape, transform):
    """load slope and rasterize data from postgis layers"""
    data = {}

    con = create_engine(os.environ.get("DATABASE_URL"))
    studyarea_polys = geopandas.GeoDataFrame.from_postgis(
        "select * from bcfishpass.lateral_studyarea", con
    )
    class1_polys = geopandas.GeoDataFrame.from_postgis(
        "select * from bcfishpass.lateral_poly where habitat_class = 1", con
    )
    class2_polys = geopandas.GeoDataFrame.from_postgis(
        "select * from bcfishpass.lateral_poly where habitat_class = 2", con
    )
    class3_polys = geopandas.GeoDataFrame.from_postgis(
        "select * from bcfishpass.lateral_poly where habitat_class = 3", con
    )
    potentialhabitat_polys = geopandas.GeoDataFrame.from_postgis(
        "select * from bcfishpass.lateral_poly where habitat_class = 4", con
    )
    accessiblehabitat_polys = geopandas.GeoDataFrame.from_postgis(
        "select * from bcfishpass.lateral_poly where habitat_class = 5", con
    )
    rail_polys = geopandas.GeoDataFrame.from_postgis(
        "select st_buffer(geom, 25) as geom from whse_basemapping.gba_railway_tracks_sp", con)

    rail_bridge_polys = geopandas.GeoDataFrame.from_postgis(
        (
            "select st_buffer(geom, 30) as geom from "
            "bcfishpass.crossings where crossing_feature_type = 'RAIL' "
            "and barrier_status NOT IN ('POTENTIAL','BARRIER')"
        ), con
    )
    btm_urban_polys = geopandas.GeoDataFrame.from_postgis(
        (
            "select geom from "
            "whse_basemapping.btm_present_land_use_v1_svw "
            "where present_land_use_label = 'Urban'"
        ), con
    )

    data["studyarea"] = features.rasterize(
        ((geom, 1) for geom in studyarea_polys.geometry),
        out_shape=shape,
        transform=transform,
        all_touched=False,
        dtype=numpy.uint8,
    )

    data["mask"] = data["studyarea"] == 0
    data["studyarea_mask"] = data["studyarea"] != 0

    data["class1"] = features.rasterize(
        ((geom, 1) for geom in class1_polys.geometry),
        out_shape=shape,
        transform=transform,
        all_touched=False,
        dtype=numpy.uint8,
    )
    data["class2"] = features.rasterize(
        ((geom, 2) for geom in class2_polys.geometry),
        out_shape=shape,
        transform=transform,
        all_touched=False,
        dtype=numpy.uint8,
    )
    data["class3"] = features.rasterize(
        ((geom, 3) for geom in class3_polys.geometry),
        out_shape=shape,
        transform=transform,
        all_touched=False,
        dtype=numpy.uint8,
    )
    data["potentialhabitat"] = features.rasterize(
        ((geom, 1) for geom in potentialhabitat_polys.geometry),
        out_shape=shape,
        transform=transform,
        all_touched=False,
        dtype=numpy.uint8,
    )
    data["accessiblehabitat"] = features.rasterize(
        ((geom, 1) for geom in accessiblehabitat_polys.geometry),
        out_shape=shape,
        transform=transform,
        all_touched=False,
        dtype=numpy.uint8,
    )
    data["rail"] = features.rasterize(
        ((geom, 1) for geom in rail_polys.geometry),
        out_shape=shape,
        transform=transform,
        all_touched=False,
        dtype=numpy.uint8,
    )
    data["rail_bridges"] = features.rasterize(
        ((geom, 1) for geom in rail_bridge_polys.geometry),
        out_shape=shape,
        transform=transform,
        all_touched=False,
        dtype=numpy.uint8,
    )
    data["btm_urban"] = features.rasterize(
        ((geom, 1) for geom in btm_urban_polys.geometry),
        out_shape=shape,
        transform=transform,
        all_touched=False,
        dtype=numpy.uint8,
    )
    return data

def filter_connected(in_array, habitat_array):
    """Return portions of in_array that are connected to habitat_array cells = 1
    """
    # label
    labels = morphology.label(in_array, connectivity=1)

    # find labels intersecting habitat
    mask = habitat_array == 1
    habitat_labels = labels[mask]
    connected_mask = numpy.isin(labels, numpy.unique(habitat_labels))
    # return only areas with labels that intersect habitat
    return numpy.where(connected_mask == 1, in_array, 0)


data = {}

# load slope
with rasterio.open(
    r"/Users/snorris/Projects/repo/bcfishpass/scripts/lateral/data/slope.tif"
) as src:
    data["slope"] = src.read(1)
    shape = src.shape
    transform = src.transform

# add sources from postgres
data = data | load_pg(shape, transform)

# process slope
# be fairly generous and include everything 5pct and below
# (5pct is our spawning slope threshold, and our dem is fairly coarse at 25m)

# apply mask
data["slope"][data["mask"]] = 255

# convert to integer
data["slope"] = data["slope"].astype(numpy.uint8)

# extract slope 4pct and less
data["slope_low"] = numpy.where(
    data["slope"] <= 4, 1, 0
)

# extract slope 10pct and more
data["slope_high"] = numpy.where(
    data["slope"] >= 10, 1, 0
)

# build basic 'potential lateral habitat'

# initialize with everything as zero
data["lateral"] = numpy.where(
    data["studyarea"] == 1, 0, 0
)

# load slope<=5pct, floodplain, waterbodies, code everything as 1
data["lateral"] = numpy.where(
    ((data["studyarea"] == 1) & ((data["slope_low"] == 1) | (data["class1"] == 1) | (data["class3"] == 3))), 1, data["lateral"]
)

# remove small holes from above
data["lateral"] = morphology.remove_small_holes(
    data["lateral"], 4, connectivity=1
)

# remove areas not connected to habitat
data["lateral_connected"] = filter_connected(data["lateral"], data["potentialhabitat"])

# add stream buffers
data["lateral_connected"] = numpy.where(
    data["class2"] == 2, 1, data["lateral_connected"]
)

# another pass, filtering out any very steep areas
data["lateral_connected"] = numpy.where(
    data["slope_high"] == 1, 0, data["lateral_connected"]
)

# and urban/built up areas
# esa class 50, 'Built-up' or BTM 'Urban'
with rasterio.open(
    r"/Users/snorris/Projects/repo/bcfishpass/scripts/lateral/data/esa_bc.tif"
) as src:
    data["esa"] = src.read(1)

data["lateral_connected"] = numpy.where(
    ((data["esa"] == 50) | (data["btm_urban"] == 1)) & (data["studyarea"] == 1), 0, data["lateral_connected"]
)

# remove areas not connected to habitat again, to remove orphan stream buffers
data["lateral_connected"] = filter_connected(data["lateral_connected"], data["potentialhabitat"])

# set everything outside of study area to 255
data["lateral_connected"] = numpy.where(
    data["studyarea"] == 1, data["lateral_connected"], 255
)

# find areas isolated by rail

# remove bridges from rail raster
data["rail"] = numpy.where(data["rail_bridges"] == 1, 0, data["rail"])

# remove rail areas from lateral
data["lateral_rail"] = numpy.where(data["rail"], 0, data["lateral_connected"])

# remove disconnected areas
# note that the 'accessiblehabitat' needs to be refined, this is cut by road barriers
data["lateral_minus_rail"] = filter_connected(data["lateral_rail"], data["accessiblehabitat"])

# create output raster - 1=potential, non-isolated, 2=potential, isolated by rail
data["lateral_output"] = numpy.where(
    data["lateral_connected"] == 1,
    2,
    data["lateral_connected"]
)
data["lateral_output"] = numpy.where(
    data["lateral_minus_rail"] == 1,
    1,
    data["lateral_output"]
)

# write output(s) to file
#qa_dumps = [d for d in data.keys() if type(data[d]) == numpy.ndarray]
qa_dumps = ["lateral_output"]
# read slope to get crs / width / height etc
with rasterio.open(r"/Users/snorris/Projects/repo/bcfishpass/scripts/lateral/data/slope.tif") as src:
    for i, raster in enumerate(qa_dumps):
        out_qa_tif = raster + ".tif"
        with rasterio.open(
            out_qa_tif,
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
            dst.write(data[raster].astype(numpy.uint8), indexes=1)