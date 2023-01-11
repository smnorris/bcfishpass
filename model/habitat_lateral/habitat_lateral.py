import os
import logging

import click
import geopandas
import numpy
import rasterio
from rasterio import features
from rasterio.windows import from_bounds
import skimage.morphology as morphology
import sqlalchemy
from sqlalchemy import create_engine

LOG = logging.getLogger(__name__)

LATERAL_SOURCES = {
    # watershed group of interest
    "study_area": """select 
    geom 
    from whse_basemapping.fwa_watershed_groups_poly wsg
    where wsg.watershed_group_code = %(wsg)s
    """,
    # -----------------------
    # official cwb floodplain
    # -----------------------
    "floodplain": """select
    case
    when ST_CoveredBy(a.geom, wsg.geom) then st_multi(a.geom)
    else st_multi(st_intersection(a.geom, wsg.geom)) end as geom
    from whse_basemapping.cwb_floodplains_bc_area_svw a
    inner join whse_basemapping.fwa_watershed_groups_poly wsg
    on st_intersects(a.geom, wsg.geom)
    where wsg.watershed_group_code = %(wsg)s
    """,
    # -----------------------
    # waterbodies
    # lakes/rivers/wetlands/reservoirs buffered by 30m
    # -----------------------
    "waterbodies": """select
      st_multi(st_buffer(wb.geom, 30)) as geom
    from whse_basemapping.fwa_lakes_poly as wb
    where watershed_group_code = %(wsg)s
    union all
    select
      st_multi(st_buffer(wb.geom, 30)) as geom
    from whse_basemapping.fwa_rivers_poly as wb
    where watershed_group_code = %(wsg)s
    union all
    select
      st_multi(st_buffer(wb.geom, 30)) as geom
    from whse_basemapping.fwa_wetlands_poly as wb
    where watershed_group_code = %(wsg)s
    union all
    select
      st_multi(st_buffer(wb.geom, 30)) as geom
    from whse_basemapping.fwa_manmade_waterbodies_poly as wb
    where watershed_group_code = %(wsg)s
    """,
    # -----------------------
    # sidechannels
    # 1st order side channels on major systems, buffered by 60m
    # -----------------------
    "sidechannels": """select
      st_multi((st_dump(st_union(st_buffer(s.geom, 60)))).geom) as geom
    from bcfishpass.streams s
    where
      s.watershed_group_code = %(wsg)s and
      s.edge_type in (1000,1100,2000,2300) and
      (
        s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] or
        s.barriers_st_dnstr = array[]::text[]
      ) and
      s.stream_order_parent > 5 and
      s.gradient <= .01 and
      s.blue_line_key != s.watershed_key and
      s.stream_order = 1""",
    # -----------------------
    # spawning_rearing
    # streams modelled as potential spawn/rear, buffered by 30m
    # -----------------------
    "spawning_rearing": """select
      st_multi((st_dump(st_union(st_buffer(s.geom, 30)))).geom) as geom
    from bcfishpass.streams s
    where
    s.watershed_group_code = %(wsg)s and
     (
      (
        (
          barriers_st_dnstr = array[]::text[] or
          barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
        )
        and stream_order >= 7
      )
      or
      (
        (
        model_spawning_ch is true or
        model_spawning_co is true or
        model_spawning_sk is true or
        model_spawning_st is true or
        model_spawning_pk is true or
        model_spawning_cm is true or
        model_rearing_ch is true or
        model_rearing_co is true or
        model_rearing_sk is true or
        model_rearing_st is true
        )
      )
    );""",
    # -----------------------
    # accessible
    # all accessible/potentially accessible streams buffered by 20m plus channel width
    # -----------------------
    "accessible": """select
  st_multi(
    (st_dump(
      st_union(
        st_buffer(s.geom, coalesce(s.channel_width, 0) + 20)
      )
    )).geom
  ) as geom
from bcfishpass.streams s
where
  watershed_group_code = %(wsg)s and
  edge_type in (1000,1100,2000,2300) and
  (
    barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] or
    barriers_st_dsnstr = array[]::text[]
  );""",
    # -----------------------
    # rail
    # rail lines buffered by 30m
    # -----------------------
    "rail": """select
      st_multi(st_buffer(r.geom, 25)) as geom
    from whse_basemapping.gba_railway_tracks_sp r
    inner join whse_basemapping.fwa_watershed_groups_poly wsg
    on st_intersects(r.geom, wsg.geom)
    where wsg.watershed_group_code = %(wsg)s""",
    # -----------------------
    # rail_bridges
    # buffered by 30m for breaching rail raster
    # -----------------------
    "rail_bridges": """select
      st_multi(st_buffer(geom, 30)) as geom
    from bcfishpass.crossings
    where crossing_feature_type = 'RAIL'
    and barrier_status NOT IN ('POTENTIAL','BARRIER')
    and crossing_type_code != 'CBS'
    and watershed_group_code = %(wsg)s""",
    # -----------------------
    # accessible_below_rail
    # accessible streams below railways
    # -----------------------
    "accessible_below_rail": """
    with xings as
    (
      select c.*
    from bcfishpass.crossings c
    left outer join bcfishpass.streams s
      ON c.linear_feature_id = s.linear_feature_id
      AND c.downstream_route_measure > s.downstream_route_measure - .001
      AND c.downstream_route_measure + .001 < s.upstream_route_measure
      AND c.watershed_group_code = s.watershed_group_code
    where
      c.crossing_feature_type = 'RAIL' and
      (s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] or s.barriers_st_dnstr = array[]::text[]
      (
        c.barrier_status in ('BARRIER', 'POTENTIAL') -- typical barriers
        or c.crossing_type_code = 'CBS'              -- for floodplain connectivity, any CBS can be a barrier
      ) and
      c.blue_line_key = c.watershed_key                -- do not include barriers on side channels
    )

    select
      -- raster generated by these polys is what gets cut by rail raster,
      -- use flat endcap to ensure that the cut is done properly
      st_multi((st_dump(st_union(st_buffer(s.geom, 30, 'endcap=flat join=round')))).geom) as geom
    from bcfishpass.streams s
    left outer join xings b
    on FWA_Downstream(
          s.blue_line_key,
          s.downstream_route_measure,
          s.wscode_ltree,
          s.localcode_ltree,
          b.blue_line_key,
          b.downstream_route_measure,
          b.wscode_ltree,
          b.localcode_ltree,
          true,
          1
        )
    where
    s.watershed_group_code = %(wsg)s and
    (s.barriers_st_dnstr = array[]::text[]
    --and
    --(
    --  (
    --    s.model_spawning_ch is true or
    --    s.model_spawning_co is true or
    --    s.model_spawning_sk is true or
    --    s.model_spawning_st is true or
    --    s.model_spawning_pk is true or
    --    s.model_spawning_cm is true or
    --    s.model_rearing_ch is true or
    --    s.model_rearing_co is true or
    --    s.model_rearing_sk is true or
    --    s.model_rearing_st is true
    --  )
    --  or s.stream_order >= 7
    --)
    and b.aggregated_crossings_id is null

    -- Do not include streams above barriers in side channels
    -- along bulkley river. These are not possible to model with existing
    -- wscode based upstream/downstream FWA queries. A spatial recursive connectivity
    -- query would likely do the job.
    and s.segmented_stream_id not in
      ('360221853.179537',
        '360221853.427070',
        '360532191.0',
        '360532191.24216',
        '360648877.0',
        '360648877.16211',
        '360648877.173000',
        '360648877.665000',
        '360648877.697000'
      )
    and s.blue_line_key not in (
      360869846,
      360840276,
      360237077,
      360236038,
      360222808,
      360235811,
      360746107
      )
    and s.wscode_ltree <@ '400.431358.785328'::ltree is false;
    """,
}


def load_rasters(db, watershed_group_code, data_path="data"):
    """Load various boolean rasters for watershed of interest,
    returns tuple of two dicts: (meta, rasters)

    """
    LOG.info("Loading data")

    rasters = {}

    # load slope raster and note shape/transform/bounds to be used for the analysis
    with rasterio.open(os.path.join(data_path, "slope.tif")) as src:
        rasters["slope"] = src.read(1).astype(numpy.uint8)
        meta = src.meta
        meta["shape"] = src.shape
        meta["bounds"] = src.bounds

    # load vca output
    with rasterio.open(os.path.join(data_path, "valleys.tif")) as src:
        rasters["vca"] = src.read(1).astype(numpy.uint8)

    # create boolean rasters from postgres vector data as defined in lateral_sources.sql
    
    for source in LATERAL_SOURCES:
        polys = geopandas.GeoDataFrame.from_postgis(
            LATERAL_SOURCES[source],
            db,
            params={"wsg": watershed_group_code},
        )
        # if features are renturned, create boolean raster
        if not polys.empty:
            rasters[source] = features.rasterize(
                ((geom, 1) for geom in polys.geometry),
                out_shape=meta["shape"],
                transform=meta["transform"],
                all_touched=False,
                dtype=numpy.uint8,
            )
        else:
            rasters[source] = numpy.zeros(meta["shape"]).astype(numpy.uint8)

    # load ESA data, using window to save memory
    with rasterio.open(r"data/esa_bc.tif") as src:
        rasters["urban_esa"] = src.read(
            1,
            window=from_bounds(
                meta["bounds"][0],
                meta["bounds"][1],
                meta["bounds"][2],
                meta["bounds"][3],
                src.transform,
            ),
        )
    # extract only urban (50) areas
    rasters["urban_esa"] = numpy.where(rasters["urban_esa"] == 50, 1, 0)

    return (meta, rasters)


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
@click.argument("watershed_group_code", type=click.STRING)
@click.option("--out_file", "-o", default="lateral.tif")
@click.option(
    "--data_path",
    "-d",
    type=click.Path(exists=True),
    default="data",
    help="Path to temp/intermediate rasters",
)
@click.option(
    "--write_tempfiles",
    "-w",
    is_flag=True,
    show_default=True,
    default=False,
    help="Write temp rasters to --data_path",
)
def lateral(watershed_group_code, out_file, data_path, write_tempfiles):
    """
    For given watershed group, find areas that may be lateral/
    off channel habitat areas
    """
    # connect to db
    db = create_engine(os.environ.get("DATABASE_URL"))

    # create various lateral habitat sources in the database
    with open("sql/lateral_sources.sql") as file:
        query = sqlalchemy.text(file.read())
        db.execute(query, wsg=watershed_group_code)

    # load the source data as rasters
    meta, rasters = load_rasters(db, watershed_group_code, data_path)

    # initialize output surface
    LOG.info("Creating initial surface")
    rasters["lateral1"] = numpy.zeros(meta["shape"]).astype(numpy.uint8)

    LOG.info("Adding 20-30m stream buffers")
    rasters["lateral2"] = numpy.where(
        (rasters["accessible"] == 1) | (rasters["spawning_rearing"] == 1),
        1,
        rasters["lateral1"],
    )

    LOG.info(
        "Removing steep areas (>=5%) from stream buffers, except for railway embankments"
    )
    # extract slope 5pct and more
    rasters["slope_high"] = numpy.where(rasters["slope"] >= 5, 1, 0).astype(numpy.uint8)
    # remove rail embankments from steep slope raster
    rasters["slope_high"] = numpy.where(rasters["rail"] != 1, rasters["slope_high"], 0)
    # filter steep areas out from the stream buffers
    rasters["lateral3"] = numpy.where(
        rasters["slope_high"] == 1, 0, rasters["lateral2"]
    )

    LOG.info("Adding CWB floodplain polys")
    rasters["lateral4"] = numpy.where(
        rasters["floodplain"] == 1, 1, rasters["lateral3"]
    )

    LOG.info("Adding unconfined valleys")
    rasters["lateral5"] = numpy.where(rasters["vca"] == 1, 1, rasters["lateral4"])

    LOG.info("Removing urban areas")
    rasters["lateral6"] = numpy.where(
        (rasters["urban_esa"] == 1),
        0,
        rasters["lateral5"],
    )

    LOG.info("Adding FWA waterbodies and sidechannels to large rivers")
    rasters["lateral7"] = numpy.where(
        (rasters["waterbodies"] == 1) | (rasters["sidechannels"] == 1),
        1,
        rasters["lateral6"],
    )

    #LOG.info("Removing areas not connected to potentially accessible streams")
    #rasters["lateral8"] = filter_connected(rasters["lateral7"], rasters["accessible"])

    LOG.info("Removing areas not connected to stream modelled as potentially spawning/rearing")
    rasters["lateral8"] = filter_connected(rasters["lateral7"], rasters["spawning_rearing"])

    # fill small holes
    rasters["lateral_potential"] = morphology.remove_small_holes(
        rasters["lateral8"], 4, connectivity=1
    ).astype(numpy.uint8)

    # --------------------------
    # find areas isolated by rail
    # --------------------------
    LOG.info("Finding potential lateral habitat disconnected by railways")
    # remove bridges from rail raster
    rasters["rail_breached"] = numpy.where(
        rasters["rail_bridges"] == 1, 0, rasters["rail"]
    )

    # remove rail area from output raster
    rasters["lateral_minusrail"] = numpy.where(
        rasters["rail_breached"], 0, rasters["lateral_potential"]
    )

    # remove disconnected areas
    rasters["lateral_minusrail2"] = filter_connected(
        rasters["lateral_minusrail"], rasters["accessible_below_rail"]
    )

    # create output raster with values:
    # 1=connected lateral habitat
    # 2=lateral habitat disconnected by rail
    rasters["lateral"] = numpy.where(rasters["lateral_potential"] == 1, 2, 0)
    rasters["lateral"] = numpy.where(
        rasters["lateral_minusrail2"] == 1, 1, rasters["lateral"]
    )

    # extract areas disconnected by rail and remove rail
    rasters["lateral_disconnected"] = numpy.where(
        rasters["rail"] == 1, 0, numpy.where(rasters["lateral"] == 2, 1, 0)
    ).astype(numpy.uint8)

    # cut to study area
    rasters["lateral_disconnected"] = numpy.where(
        rasters["study_area"] == 1, rasters["lateral_disconnected"], 255
    )

    # --------------------------
    # write output raster(s) to file
    # --------------------------
    LOG.info("Writing output raster(s)")

    # double check output is cut to study area
    rasters["lateral"] = numpy.where(
        rasters["study_area"] == 1, rasters["lateral"], 255
    )
    # write output raster
    with rasterio.open(
        out_file,
        "w",
        driver="GTiff",
        dtype=rasterio.uint8,
        count=1,
        width=meta["width"],
        height=meta["height"],
        crs=meta["crs"],
        transform=meta["transform"],
        nodata=255,
    ) as dst:
        dst.write(rasters["lateral"].astype(numpy.uint8), indexes=1)

    # write tempfiles if so directed
    if write_tempfiles:
        dumps = [
            d
            for d in rasters.keys()
            if type(rasters[d]) == numpy.ndarray
            and rasters[d].shape == meta["shape"]
            and d not in ["lateral", "slope", "vca"]
        ]
        for key in dumps:
            # ensure dump is cut to study area
            rasters[key] = numpy.where(rasters["study_area"] == 1, rasters[key], 255)
            with rasterio.open(
                os.path.join(data_path, key + ".tif"),
                "w",
                driver="GTiff",
                dtype=rasterio.uint8,
                count=1,
                width=meta["width"],
                height=meta["height"],
                crs=meta["crs"],
                transform=meta["transform"],
                nodata=255,
            ) as dst:
                dst.write(rasters[key].astype(numpy.uint8), indexes=1)


if __name__ == "__main__":
    lateral()
