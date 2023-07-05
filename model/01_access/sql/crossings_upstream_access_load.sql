-- ---------------------------------
-- report on upstream linear stats
-- ---------------------------------
WITH at_point AS
(
  SELECT
    a.aggregated_crossings_id,
    a.watershed_group_code,
    coalesce(s.gradient, s2.gradient) as gradient,
    s.barriers_bt_dnstr,
    s.barriers_ch_cm_co_pk_sk_dnstr,
    s.barriers_ct_dv_rb_dnstr,
    s.barriers_st_dnstr,
    s.barriers_wct_dnstr
  FROM bcfishpass.crossings a
  left outer join bcfishpass.streams s
  ON a.blue_line_key = s.blue_line_key
  AND a.downstream_route_measure > s.downstream_route_measure - .001
  AND a.downstream_route_measure + .001 < s.upstream_route_measure
  --AND round(s.downstream_route_measure::numeric, 4) <= round(a.downstream_route_measure::numeric, 4)
  --AND round(s.upstream_route_measure::numeric, 4) > round(a.downstream_route_measure::numeric, 4)
  AND a.watershed_group_code = s.watershed_group_code
  INNER JOIN whse_basemapping.fwa_stream_networks_sp s2
  ON a.blue_line_key = s2.blue_line_key
  AND a.downstream_route_measure > s2.downstream_route_measure - .001
  AND a.downstream_route_measure + .001 < s2.upstream_route_measure
  --AND round(s2.downstream_route_measure::numeric, 4) <= round(a.downstream_route_measure::numeric, 4)
  --AND round(s2.upstream_route_measure::numeric, 4) > round(a.downstream_route_measure::numeric, 4)
  AND a.watershed_group_code = s2.watershed_group_code
  WHERE a.watershed_group_code = :'wsg'
  ORDER BY aggregated_crossings_id
),

upstr_length as materialized
(
  select
    a.aggregated_crossings_id,
    a.watershed_group_code,
    s.linear_feature_id,
    s.gradient,
    s.edge_type,
    s.waterbody_key,
    case when s.barriers_bt_dnstr = array[]::text[] then true else false end as access_bt,
    case when s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] then true else false end as access_ch_cm_co_pk_sk,
    case when s.barriers_ct_dv_rb_dnstr = array[]::text[] then true else false end as access_ct_dv_rb,
    case when s.barriers_st_dnstr = array[]::text[] then true else false end as access_st,
    case when s.barriers_wct_dnstr = array[]::text[] then true else false end as access_wct,
    s.geom
  from bcfishpass.crossings a
  LEFT OUTER JOIN bcfishpass.streams s
  ON FWA_Upstream(
      a.blue_line_key,
      a.downstream_route_measure,
      a.wscode_ltree,
      a.localcode_ltree,
      s.blue_line_key,
      s.downstream_route_measure,
      s.wscode_ltree,
      s.localcode_ltree,
      True,
      1
     )
  where a.blue_line_key = a.watershed_key  -- do not compute for points on side channels
  and a.watershed_group_code = :'wsg'
  ORDER BY a.aggregated_crossings_id
),

upstr_area as materialized
(
  SELECT DISTINCT
    a.aggregated_crossings_id,
    s.waterbody_key,
    case when s.barriers_bt_dnstr = array[]::text[] then true else false end as access_bt,
    case when s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] then true else false end as access_ch_cm_co_pk_sk,
    case when s.barriers_ct_dv_rb_dnstr = array[]::text[] then true else false end as access_ct_dv_rb,
    case when s.barriers_st_dnstr = array[]::text[] then true else false end as access_st,
    case when s.barriers_wct_dnstr = array[]::text[] then true else false end as access_wct,
    ST_Area(lake.geom) as area_lake,
    ST_Area(manmade.geom) as area_manmade,
    ST_Area(wetland.geom) as area_wetland
  FROM bcfishpass.crossings a
  LEFT OUTER JOIN bcfishpass.streams s
  ON FWA_Upstream(
      a.blue_line_key,
      a.downstream_route_measure,
      a.wscode_ltree,
      a.localcode_ltree,
      s.blue_line_key,
      s.downstream_route_measure,
      s.wscode_ltree,
      s.localcode_ltree,
      True,
      1
     )
  LEFT OUTER JOIN whse_basemapping.fwa_lakes_poly lake ON s.waterbody_key = lake.waterbody_key
  LEFT OUTER JOIN whse_basemapping.fwa_manmade_waterbodies_poly manmade ON s.waterbody_key = manmade.waterbody_key
  LEFT OUTER JOIN whse_basemapping.fwa_wetlands_poly wetland ON s.waterbody_key = wetland.waterbody_key
  WHERE a.watershed_group_code = :'wsg'
  ORDER BY a.aggregated_crossings_id
),

upstr_length_sum as
(
  SELECT
    s.aggregated_crossings_id,
  -- totals
    COALESCE(ROUND((SUM(ST_Length(s.geom)::numeric) / 1000), 2), 0) AS total_network_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))) / 1000)::numeric, 2), 0) AS total_stream_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
      WHERE (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS total_slopeclass03_waterbodies_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
      WHERE (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS total_slopeclass03_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .03 AND s.gradient < .05) / 1000))::numeric, 2), 0) as total_slopeclass05_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .05 AND s.gradient < .08) / 1000))::numeric, 2), 0) as total_slopeclass08_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .08 AND s.gradient < .15) / 1000))::numeric, 2), 0) as total_slopeclass15_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .15 AND s.gradient < .22) / 1000))::numeric, 2), 0) as total_slopeclass22_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .22 AND s.gradient < .30) / 1000))::numeric, 2), 0) as total_slopeclass30_km,

  -- bull trout model
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_bt is true) / 1000)::numeric), 2), 0) AS bt_network_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_bt is true AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS bt_stream_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
      WHERE (s.access_bt is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS bt_slopeclass03_waterbodies_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
      WHERE (s.access_bt is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS bt_slopeclass03_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_bt is true AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as bt_slopeclass05_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_bt is true AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as bt_slopeclass08_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_bt is true AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as bt_slopeclass15_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_bt is true AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as bt_slopeclass22_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_bt is true AND (s.gradient >= .22 AND s.gradient < .3)) / 1000))::numeric, 2), 0) as bt_slopeclass30_km,

  -- salmon model
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_ch_cm_co_pk_sk is true) / 1000)::numeric), 2), 0) AS ch_cm_co_pk_sk_network_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_ch_cm_co_pk_sk is true AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS ch_cm_co_pk_sk_stream_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
      WHERE (s.access_ch_cm_co_pk_sk is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS ch_cm_co_pk_sk_slopeclass03_waterbodies_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
      WHERE (s.access_ch_cm_co_pk_sk is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS ch_cm_co_pk_sk_slopeclass03_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_ch_cm_co_pk_sk is true AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as ch_cm_co_pk_sk_slopeclass05_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_ch_cm_co_pk_sk is true AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as ch_cm_co_pk_sk_slopeclass08_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_ch_cm_co_pk_sk is true AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as ch_cm_co_pk_sk_slopeclass15_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_ch_cm_co_pk_sk is true AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as ch_cm_co_pk_sk_slopeclass22_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_ch_cm_co_pk_sk is true AND (s.gradient >= .22 AND s.gradient < .3)) / 1000))::numeric, 2), 0) as ch_cm_co_pk_sk_slopeclass30_km,

  -- resident ct/dv/rb
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_ct_dv_rb is true) / 1000)::numeric), 2), 0) AS ct_dv_rb_network_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_ct_dv_rb is true AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS ct_dv_rb_stream_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
      WHERE (s.access_ct_dv_rb is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS ct_dv_rb_slopeclass03_waterbodies_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
      WHERE (s.access_ct_dv_rb is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS ct_dv_rb_slopeclass03_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_ct_dv_rb is true AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as ct_dv_rb_slopeclass05_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_ct_dv_rb is true AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as ct_dv_rb_slopeclass08_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_ct_dv_rb is true AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as ct_dv_rb_slopeclass15_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_ct_dv_rb is true AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as ct_dv_rb_slopeclass22_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_ct_dv_rb is true AND (s.gradient >= .22 AND s.gradient < .30)) / 1000))::numeric, 2), 0) as ct_dv_rb_slopeclass30_km,

  -- steelhead
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_st is true) / 1000)::numeric), 2), 0) AS st_network_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_st is true AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS st_stream_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
      WHERE (s.access_st is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS st_slopeclass03_waterbodies_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
      WHERE (s.access_st is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS st_slopeclass03_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_st is true AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as st_slopeclass05_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_st is true AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as st_slopeclass08_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_st is true AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as st_slopeclass15_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_st is true AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as st_slopeclass22_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_st is true AND (s.gradient >= .22 AND s.gradient < .30)) / 1000))::numeric, 2), 0) as st_slopeclass30_km,

  -- wct
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_wct is true) / 1000)::numeric), 2), 0) AS wct_network_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_wct is true AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS wct_stream_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
      WHERE (s.access_wct is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS wct_slopeclass03_waterbodies_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
      WHERE (s.access_wct is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS wct_slopeclass03_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_wct is true AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as wct_slopeclass05_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_wct is true AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as wct_slopeclass08_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_wct is true AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as wct_slopeclass15_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_wct is true AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as wct_slopeclass22_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_wct is true AND (s.gradient >= .22 AND s.gradient < .30)) / 1000))::numeric, 2), 0) as wct_slopeclass30_km
  FROM upstr_length s
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb ON s.waterbody_key = wb.waterbody_key
  GROUP BY s.aggregated_crossings_id
),

upstr_area_sum as
(
  SELECT
    aggregated_crossings_id,
    ROUND(((SUM(COALESCE(uwb.area_lake, 0)) + SUM(COALESCE(uwb.area_manmade,0))) / 10000)::numeric, 2) AS total_lakereservoir_ha,
    ROUND((SUM(COALESCE(uwb.area_wetland, 0)) / 10000)::numeric, 2) AS total_wetland_ha,

    ROUND(((SUM(COALESCE(uwb.area_lake, 0)) FILTER (WHERE uwb.access_bt is true) + SUM(COALESCE(uwb.area_manmade, 0)) FILTER (WHERE uwb.access_bt is true)) / 10000)::numeric, 2) AS bt_lakereservoir_ha,
    ROUND(((SUM(COALESCE(uwb.area_wetland, 0)) FILTER (WHERE uwb.access_bt is true)) / 10000)::numeric, 2) AS bt_wetland_ha,

    ROUND(((SUM(COALESCE(uwb.area_lake, 0)) FILTER (WHERE uwb.access_ch_cm_co_pk_sk is true) + SUM(COALESCE(uwb.area_manmade, 0)) FILTER (WHERE uwb.access_ch_cm_co_pk_sk is true)) / 10000)::numeric, 2) AS ch_cm_co_pk_sk_lakereservoir_ha,
    ROUND(((SUM(COALESCE(uwb.area_wetland, 0)) FILTER (WHERE uwb.access_ch_cm_co_pk_sk is true)) / 10000)::numeric, 2) AS ch_cm_co_pk_sk_wetland_ha,

    ROUND(((SUM(COALESCE(uwb.area_lake, 0)) FILTER (WHERE uwb.access_ct_dv_rb is true) + SUM(COALESCE(uwb.area_manmade, 0)) FILTER (WHERE uwb.access_ct_dv_rb is true)) / 10000)::numeric, 2) AS ct_dv_rb_lakereservoir_ha,
    ROUND(((SUM(COALESCE(uwb.area_wetland, 0)) FILTER (WHERE uwb.access_ct_dv_rb is true)) / 10000)::numeric, 2) AS ct_dv_rb_wetland_ha,


    ROUND(((SUM(COALESCE(uwb.area_lake, 0)) FILTER (WHERE uwb.access_st is true) + SUM(COALESCE(uwb.area_manmade, 0)) FILTER (WHERE uwb.access_st is true)) / 10000)::numeric, 2) AS st_lakereservoir_ha,
    ROUND(((SUM(COALESCE(uwb.area_wetland, 0)) FILTER (WHERE uwb.access_st is true)) / 10000)::numeric, 2) AS st_wetland_ha,
    ROUND(((SUM(COALESCE(uwb.area_lake, 0)) FILTER (WHERE uwb.access_wct is true) + SUM(COALESCE(uwb.area_manmade,0)) FILTER (WHERE uwb.access_wct is true)) / 10000)::numeric, 2) AS wct_lakereservoir_ha,
    ROUND(((SUM(COALESCE(uwb.area_wetland, 0)) FILTER (WHERE uwb.access_wct is true)) / 10000)::numeric, 2) AS wct_wetland_ha
  FROM upstr_area uwb
  WHERE waterbody_key IS NOT NULL
  GROUP BY aggregated_crossings_id
)

insert into bcfishpass.crossings_upstream_access
(
  aggregated_crossings_id,
  watershed_group_code,
  gradient,
  total_network_km,
  total_stream_km,
  total_lakereservoir_ha,
  total_wetland_ha,
  total_slopeclass03_waterbodies_km,
  total_slopeclass03_km,
  total_slopeclass05_km,
  total_slopeclass08_km,
  total_slopeclass15_km,
  total_slopeclass22_km,
  total_slopeclass30_km,
  barriers_bt_dnstr,
  bt_network_km,
  bt_stream_km,
  bt_lakereservoir_ha,
  bt_wetland_ha,
  bt_slopeclass03_waterbodies_km,
  bt_slopeclass03_km,
  bt_slopeclass05_km,
  bt_slopeclass08_km,
  bt_slopeclass15_km,
  bt_slopeclass22_km,
  bt_slopeclass30_km,
  barriers_ch_cm_co_pk_sk_dnstr,
  ch_cm_co_pk_sk_network_km,
  ch_cm_co_pk_sk_stream_km,
  ch_cm_co_pk_sk_lakereservoir_ha,
  ch_cm_co_pk_sk_wetland_ha,
  ch_cm_co_pk_sk_slopeclass03_waterbodies_km,
  ch_cm_co_pk_sk_slopeclass03_km,
  ch_cm_co_pk_sk_slopeclass05_km,
  ch_cm_co_pk_sk_slopeclass08_km,
  ch_cm_co_pk_sk_slopeclass15_km,
  ch_cm_co_pk_sk_slopeclass22_km,
  ch_cm_co_pk_sk_slopeclass30_km,
  barriers_ct_dv_rb_dnstr,
  ct_dv_rb_network_km,
  ct_dv_rb_stream_km,
  ct_dv_rb_lakereservoir_ha,
  ct_dv_rb_wetland_ha,
  ct_dv_rb_slopeclass03_waterbodies_km,
  ct_dv_rb_slopeclass03_km,
  ct_dv_rb_slopeclass05_km,
  ct_dv_rb_slopeclass08_km,
  ct_dv_rb_slopeclass15_km,
  ct_dv_rb_slopeclass22_km,
  ct_dv_rb_slopeclass30_km,
  barriers_st_dnstr,
  st_network_km,
  st_stream_km,
  st_lakereservoir_ha,
  st_wetland_ha,
  st_slopeclass03_waterbodies_km,
  st_slopeclass03_km,
  st_slopeclass05_km,
  st_slopeclass08_km,
  st_slopeclass15_km,
  st_slopeclass22_km,
  st_slopeclass30_km,
  barriers_wct_dnstr,
  wct_network_km,
  wct_stream_km,
  wct_lakereservoir_ha,
  wct_wetland_ha,
  wct_slopeclass03_waterbodies_km,
  wct_slopeclass03_km,
  wct_slopeclass05_km,
  wct_slopeclass08_km,
  wct_slopeclass15_km,
  wct_slopeclass22_km,
  wct_slopeclass30_km
)

select
  p.aggregated_crossings_id,
  p.watershed_group_code,
  p.gradient,
  a.total_network_km,
  a.total_stream_km,
  coalesce(b.total_lakereservoir_ha, 0) as total_lakereservoir_ha,
  coalesce(b.total_wetland_ha, 0) as total_wetland_ha,
  a.total_slopeclass03_waterbodies_km,
  a.total_slopeclass03_km,
  a.total_slopeclass05_km,
  a.total_slopeclass08_km,
  a.total_slopeclass15_km,
  a.total_slopeclass22_km,
  a.total_slopeclass30_km,
  p.barriers_bt_dnstr,
  a.bt_network_km,
  a.bt_stream_km,
  coalesce(b.bt_lakereservoir_ha, 0) as bt_lakereservoir_ha,
  coalesce(b.bt_wetland_ha, 0) as bt_wetland_ha,
  a.bt_slopeclass03_waterbodies_km,
  a.bt_slopeclass03_km,
  a.bt_slopeclass05_km,
  a.bt_slopeclass08_km,
  a.bt_slopeclass15_km,
  a.bt_slopeclass22_km,
  a.bt_slopeclass30_km,
  p.barriers_ch_cm_co_pk_sk_dnstr,
  a.ch_cm_co_pk_sk_network_km,
  a.ch_cm_co_pk_sk_stream_km,
  coalesce(b.ch_cm_co_pk_sk_lakereservoir_ha, 0) as ch_cm_co_pk_sk_lakereservoir_ha,
  coalesce(b.ch_cm_co_pk_sk_wetland_ha, 0) as ch_cm_co_pk_sk_wetland_ha,
  a.ch_cm_co_pk_sk_slopeclass03_waterbodies_km,
  a.ch_cm_co_pk_sk_slopeclass03_km,
  a.ch_cm_co_pk_sk_slopeclass05_km,
  a.ch_cm_co_pk_sk_slopeclass08_km,
  a.ch_cm_co_pk_sk_slopeclass15_km,
  a.ch_cm_co_pk_sk_slopeclass22_km,
  a.ch_cm_co_pk_sk_slopeclass30_km,
  p.barriers_ct_dv_rb_dnstr,
  a.ct_dv_rb_network_km,
  a.ct_dv_rb_stream_km,
  coalesce(b.ct_dv_rb_lakereservoir_ha, 0) as ct_dv_rb_lakereservoir_ha,
  coalesce(b.ct_dv_rb_wetland_ha, 0) as ct_dv_rb_wetland_ha,
  a.ct_dv_rb_slopeclass03_waterbodies_km,
  a.ct_dv_rb_slopeclass03_km,
  a.ct_dv_rb_slopeclass05_km,
  a.ct_dv_rb_slopeclass08_km,
  a.ct_dv_rb_slopeclass15_km,
  a.ct_dv_rb_slopeclass22_km,
  a.ct_dv_rb_slopeclass30_km,
  p.barriers_st_dnstr,
  a.st_network_km,
  a.st_stream_km,
  coalesce(b.st_lakereservoir_ha, 0) as st_lakereservoir_ha,
  coalesce(b.st_wetland_ha, 0) as st_wetland_ha,
  a.st_slopeclass03_waterbodies_km,
  a.st_slopeclass03_km,
  a.st_slopeclass05_km,
  a.st_slopeclass08_km,
  a.st_slopeclass15_km,
  a.st_slopeclass22_km,
  a.st_slopeclass30_km,
  p.barriers_wct_dnstr,
  a.wct_network_km,
  a.wct_stream_km,
  coalesce(b.wct_lakereservoir_ha, 0) as wct_lakereservoir_ha,
  coalesce(b.wct_wetland_ha, 0) as wct_wetland_ha,
  a.wct_slopeclass03_waterbodies_km,
  a.wct_slopeclass03_km,
  a.wct_slopeclass05_km,
  a.wct_slopeclass08_km,
  a.wct_slopeclass15_km,
  a.wct_slopeclass22_km,
  a.wct_slopeclass30_km
from at_point p
left outer join upstr_length_sum a on p.aggregated_crossings_id = a.aggregated_crossings_id
left outer join upstr_area_sum b on a.aggregated_crossings_id = b.aggregated_crossings_id;


-- set belowupstrbarriers columns, defaulting to full amount
UPDATE bcfishpass.crossings_upstream_access p
SET
  total_belowupstrbarriers_network_km = total_network_km,
  total_belowupstrbarriers_stream_km = total_stream_km,
  total_belowupstrbarriers_lakereservoir_ha = total_lakereservoir_ha,
  total_belowupstrbarriers_wetland_ha = total_wetland_ha,
  total_belowupstrbarriers_slopeclass03_waterbodies_km = total_slopeclass03_waterbodies_km,
  total_belowupstrbarriers_slopeclass03_km = total_slopeclass03_km,
  total_belowupstrbarriers_slopeclass05_km = total_slopeclass05_km,
  total_belowupstrbarriers_slopeclass08_km = total_slopeclass08_km,
  total_belowupstrbarriers_slopeclass15_km = total_slopeclass15_km,
  total_belowupstrbarriers_slopeclass22_km = total_slopeclass22_km,
  total_belowupstrbarriers_slopeclass30_km = total_slopeclass30_km,

  bt_belowupstrbarriers_network_km = bt_network_km,
  bt_belowupstrbarriers_stream_km = bt_stream_km,
  bt_belowupstrbarriers_lakereservoir_ha = bt_lakereservoir_ha,
  bt_belowupstrbarriers_wetland_ha = bt_wetland_ha,
  bt_belowupstrbarriers_slopeclass03_km = bt_slopeclass03_km,
  bt_belowupstrbarriers_slopeclass05_km = bt_slopeclass05_km,
  bt_belowupstrbarriers_slopeclass08_km = bt_slopeclass08_km,
  bt_belowupstrbarriers_slopeclass15_km = bt_slopeclass15_km,
  bt_belowupstrbarriers_slopeclass22_km = bt_slopeclass22_km,
  bt_belowupstrbarriers_slopeclass30_km = bt_slopeclass30_km,

  ch_cm_co_pk_sk_belowupstrbarriers_network_km = ch_cm_co_pk_sk_network_km,
  ch_cm_co_pk_sk_belowupstrbarriers_stream_km = ch_cm_co_pk_sk_stream_km,
  ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha = ch_cm_co_pk_sk_lakereservoir_ha,
  ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha = ch_cm_co_pk_sk_wetland_ha,
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km = ch_cm_co_pk_sk_slopeclass03_waterbodies_km,
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km = ch_cm_co_pk_sk_slopeclass03_km,
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km = ch_cm_co_pk_sk_slopeclass05_km,
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km = ch_cm_co_pk_sk_slopeclass08_km,
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km = ch_cm_co_pk_sk_slopeclass15_km,
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km = ch_cm_co_pk_sk_slopeclass22_km,
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km = ch_cm_co_pk_sk_slopeclass30_km,

  ct_dv_rb_belowupstrbarriers_network_km = ct_dv_rb_network_km,
  ct_dv_rb_belowupstrbarriers_stream_km = ct_dv_rb_stream_km,
  ct_dv_rb_belowupstrbarriers_lakereservoir_ha = ct_dv_rb_lakereservoir_ha,
  ct_dv_rb_belowupstrbarriers_wetland_ha = ct_dv_rb_wetland_ha,
  ct_dv_rb_belowupstrbarriers_slopeclass03_waterbodies_km = ct_dv_rb_slopeclass03_waterbodies_km,
  ct_dv_rb_belowupstrbarriers_slopeclass03_km = ct_dv_rb_slopeclass03_km,
  ct_dv_rb_belowupstrbarriers_slopeclass05_km = ct_dv_rb_slopeclass05_km,
  ct_dv_rb_belowupstrbarriers_slopeclass08_km = ct_dv_rb_slopeclass08_km,
  ct_dv_rb_belowupstrbarriers_slopeclass15_km = ct_dv_rb_slopeclass15_km,
  ct_dv_rb_belowupstrbarriers_slopeclass22_km = ct_dv_rb_slopeclass22_km,
  ct_dv_rb_belowupstrbarriers_slopeclass30_km = ct_dv_rb_slopeclass30_km,

  st_belowupstrbarriers_network_km = st_network_km,
  st_belowupstrbarriers_stream_km = st_stream_km,
  st_belowupstrbarriers_lakereservoir_ha = st_lakereservoir_ha,
  st_belowupstrbarriers_wetland_ha = st_wetland_ha,
  st_belowupstrbarriers_slopeclass03_km = st_slopeclass03_km,
  st_belowupstrbarriers_slopeclass05_km = st_slopeclass05_km,
  st_belowupstrbarriers_slopeclass08_km = st_slopeclass08_km,
  st_belowupstrbarriers_slopeclass15_km = st_slopeclass15_km,
  st_belowupstrbarriers_slopeclass22_km = st_slopeclass22_km,
  st_belowupstrbarriers_slopeclass30_km = st_slopeclass30_km,

  wct_belowupstrbarriers_network_km = wct_network_km,
  wct_belowupstrbarriers_stream_km = wct_stream_km,
  wct_belowupstrbarriers_lakereservoir_ha = wct_lakereservoir_ha,
  wct_belowupstrbarriers_wetland_ha = wct_wetland_ha,
  wct_belowupstrbarriers_slopeclass03_km = wct_slopeclass03_km,
  wct_belowupstrbarriers_slopeclass05_km = wct_slopeclass05_km,
  wct_belowupstrbarriers_slopeclass08_km = wct_slopeclass08_km,
  wct_belowupstrbarriers_slopeclass15_km = wct_slopeclass15_km,
  wct_belowupstrbarriers_slopeclass22_km = wct_slopeclass22_km,
  wct_belowupstrbarriers_slopeclass30_km = wct_slopeclass30_km
WHERE watershed_group_code = :'wsg';


-- reset belowupstrbarriers columns for barriers with other barriers upstream
with barriers as
(
  select a.*, c.barriers_anthropogenic_dnstr
  from bcfishpass.crossings_upstream_access a
  inner join bcfishpass.barriers_anthropogenic b
  on a.aggregated_crossings_id = b.barriers_anthropogenic_id
  inner join bcfishpass.crossings c
  on b.barriers_anthropogenic_id = c.aggregated_crossings_id
),

above_upstream_barriers as
(
  SELECT
    a.aggregated_crossings_id,
    SUM(b.total_network_km) as total_network_km,
    SUM(b.total_stream_km) as total_stream_km,
    SUM(b.total_lakereservoir_ha) as total_lakereservoir_ha,
    SUM(b.total_wetland_ha) as total_wetland_ha,
    SUM(b.total_slopeclass03_waterbodies_km) as total_slopeclass03_waterbodies_km,
    SUM(b.total_slopeclass03_km) as total_slopeclass03_km,
    SUM(b.total_slopeclass05_km) as total_slopeclass05_km,
    SUM(b.total_slopeclass08_km) as total_slopeclass08_km,
    SUM(b.total_slopeclass15_km) as total_slopeclass15_km,
    SUM(b.total_slopeclass22_km) as total_slopeclass22_km,
    SUM(b.total_slopeclass30_km) as total_slopeclass30_km,
    SUM(b.bt_network_km) as bt_network_km,
    SUM(b.bt_stream_km) as bt_stream_km,
    SUM(b.bt_lakereservoir_ha) as bt_lakereservoir_ha,
    SUM(b.bt_wetland_ha) as bt_wetland_ha,
    SUM(b.bt_slopeclass03_waterbodies_km) as bt_slopeclass03_waterbodies_km,
    SUM(b.bt_slopeclass03_km) as bt_slopeclass03_km,
    SUM(b.bt_slopeclass05_km) as bt_slopeclass05_km,
    SUM(b.bt_slopeclass08_km) as bt_slopeclass08_km,
    SUM(b.bt_slopeclass15_km) as bt_slopeclass15_km,
    SUM(b.bt_slopeclass22_km) as bt_slopeclass22_km,
    SUM(b.bt_slopeclass30_km) as bt_slopeclass30_km,
    SUM(b.ch_cm_co_pk_sk_network_km) as ch_cm_co_pk_sk_network_km,
    SUM(b.ch_cm_co_pk_sk_stream_km) as ch_cm_co_pk_sk_stream_km,
    SUM(b.ch_cm_co_pk_sk_lakereservoir_ha) as ch_cm_co_pk_sk_lakereservoir_ha,
    SUM(b.ch_cm_co_pk_sk_wetland_ha) as ch_cm_co_pk_sk_wetland_ha,
    SUM(b.ch_cm_co_pk_sk_slopeclass03_waterbodies_km) as ch_cm_co_pk_sk_slopeclass03_waterbodies_km,
    SUM(b.ch_cm_co_pk_sk_slopeclass03_km) as ch_cm_co_pk_sk_slopeclass03_km,
    SUM(b.ch_cm_co_pk_sk_slopeclass05_km) as ch_cm_co_pk_sk_slopeclass05_km,
    SUM(b.ch_cm_co_pk_sk_slopeclass08_km) as ch_cm_co_pk_sk_slopeclass08_km,
    SUM(b.ch_cm_co_pk_sk_slopeclass15_km) as ch_cm_co_pk_sk_slopeclass15_km,
    SUM(b.ch_cm_co_pk_sk_slopeclass22_km) as ch_cm_co_pk_sk_slopeclass22_km,
    SUM(b.ch_cm_co_pk_sk_slopeclass30_km) as ch_cm_co_pk_sk_slopeclass30_km,
    SUM(b.ct_dv_rb_network_km) as ct_dv_rb_network_km,
    SUM(b.ct_dv_rb_stream_km) as ct_dv_rb_stream_km,
    SUM(b.ct_dv_rb_lakereservoir_ha) as ct_dv_rb_lakereservoir_ha,
    SUM(b.ct_dv_rb_wetland_ha) as ct_dv_rb_wetland_ha,
    SUM(b.ct_dv_rb_slopeclass03_waterbodies_km) as ct_dv_rb_slopeclass03_waterbodies_km,
    SUM(b.ct_dv_rb_slopeclass03_km) as ct_dv_rb_slopeclass03_km,
    SUM(b.ct_dv_rb_slopeclass05_km) as ct_dv_rb_slopeclass05_km,
    SUM(b.ct_dv_rb_slopeclass08_km) as ct_dv_rb_slopeclass08_km,
    SUM(b.ct_dv_rb_slopeclass15_km) as ct_dv_rb_slopeclass15_km,
    SUM(b.ct_dv_rb_slopeclass22_km) as ct_dv_rb_slopeclass22_km,
    SUM(b.ct_dv_rb_slopeclass30_km) as ct_dv_rb_slopeclass30_km,
    SUM(b.st_network_km) as st_network_km,
    SUM(b.st_stream_km) as st_stream_km,
    SUM(b.st_lakereservoir_ha) as st_lakereservoir_ha,
    SUM(b.st_wetland_ha) as st_wetland_ha,
    SUM(b.st_slopeclass03_km) as st_slopeclass03_km,
    SUM(b.st_slopeclass05_km) as st_slopeclass05_km,
    SUM(b.st_slopeclass08_km) as st_slopeclass08_km,
    SUM(b.st_slopeclass15_km) as st_slopeclass15_km,
    SUM(b.st_slopeclass22_km) as st_slopeclass22_km,
    SUM(b.st_slopeclass30_km) as st_slopeclass30_km,
    SUM(b.wct_network_km) as wct_network_km,
    SUM(b.wct_stream_km) as wct_stream_km,
    SUM(b.wct_lakereservoir_ha) as wct_lakereservoir_ha,
    SUM(b.wct_wetland_ha) as wct_wetland_ha,
    SUM(b.wct_slopeclass03_km) as wct_slopeclass03_km,
    SUM(b.wct_slopeclass05_km) as wct_slopeclass05_km,
    SUM(b.wct_slopeclass08_km) as wct_slopeclass08_km,
    SUM(b.wct_slopeclass15_km) as wct_slopeclass15_km,
    SUM(b.wct_slopeclass22_km) as wct_slopeclass22_km,
    SUM(b.wct_slopeclass30_km) as wct_slopeclass30_km
  FROM bcfishpass.crossings_upstream_access a
  INNER JOIN barriers b
  ON a.aggregated_crossings_id = b.barriers_anthropogenic_dnstr[1]
  WHERE a.watershed_group_code = :'wsg'
  group by a.aggregated_crossings_id
)

update bcfishpass.crossings_upstream_access a
SET
  total_belowupstrbarriers_network_km = round((a.total_network_km - b.total_network_km)::numeric, 2),
  total_belowupstrbarriers_stream_km = round((a.total_stream_km - b.total_stream_km)::numeric, 2),
  total_belowupstrbarriers_lakereservoir_ha = round((a.total_lakereservoir_ha - b.total_lakereservoir_ha)::numeric, 2),
  total_belowupstrbarriers_wetland_ha = round((a.total_wetland_ha - b.total_wetland_ha)::numeric, 2),
  total_belowupstrbarriers_slopeclass03_waterbodies_km = round((a.total_slopeclass03_waterbodies_km - b.total_slopeclass03_waterbodies_km)::numeric, 2),
  total_belowupstrbarriers_slopeclass03_km = round((a.total_slopeclass03_km - b.total_slopeclass03_km)::numeric, 2),
  total_belowupstrbarriers_slopeclass05_km = round((a.total_slopeclass05_km - b.total_slopeclass05_km)::numeric, 2),
  total_belowupstrbarriers_slopeclass08_km = round((a.total_slopeclass08_km - b.total_slopeclass08_km)::numeric, 2),
  total_belowupstrbarriers_slopeclass15_km = round((a.total_slopeclass15_km - b.total_slopeclass15_km)::numeric, 2),
  total_belowupstrbarriers_slopeclass22_km = round((a.total_slopeclass22_km - b.total_slopeclass22_km)::numeric, 2),
  total_belowupstrbarriers_slopeclass30_km = round((a.total_slopeclass30_km - b.total_slopeclass30_km)::numeric, 2),
  bt_belowupstrbarriers_network_km = round((a.bt_network_km - b.bt_network_km)::numeric, 2),
  bt_belowupstrbarriers_stream_km = round((a.bt_stream_km - b.bt_stream_km)::numeric, 2),
  bt_belowupstrbarriers_lakereservoir_ha = round((a.bt_lakereservoir_ha - b.bt_lakereservoir_ha)::numeric, 2),
  bt_belowupstrbarriers_wetland_ha = round((a.bt_wetland_ha - b.bt_wetland_ha)::numeric, 2),
  bt_belowupstrbarriers_slopeclass03_waterbodies_km = round((a.bt_slopeclass03_waterbodies_km - b.bt_slopeclass03_waterbodies_km)::numeric, 2),
  bt_belowupstrbarriers_slopeclass03_km = round((a.bt_slopeclass03_km - b.bt_slopeclass03_km)::numeric, 2),
  bt_belowupstrbarriers_slopeclass05_km = round((a.bt_slopeclass05_km - b.bt_slopeclass05_km)::numeric, 2),
  bt_belowupstrbarriers_slopeclass08_km = round((a.bt_slopeclass08_km - b.bt_slopeclass08_km)::numeric, 2),
  bt_belowupstrbarriers_slopeclass15_km = round((a.bt_slopeclass15_km - b.bt_slopeclass15_km)::numeric, 2),
  bt_belowupstrbarriers_slopeclass22_km = round((a.bt_slopeclass22_km - b.bt_slopeclass22_km)::numeric, 2),
  bt_belowupstrbarriers_slopeclass30_km = round((a.bt_slopeclass30_km - b.bt_slopeclass30_km)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_network_km = round((a.ch_cm_co_pk_sk_network_km - b.ch_cm_co_pk_sk_network_km)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_stream_km = round((a.ch_cm_co_pk_sk_stream_km - b.ch_cm_co_pk_sk_stream_km)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha = round((a.ch_cm_co_pk_sk_lakereservoir_ha - b.ch_cm_co_pk_sk_lakereservoir_ha)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha = round((a.ch_cm_co_pk_sk_wetland_ha - b.ch_cm_co_pk_sk_wetland_ha)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km = round((a.ch_cm_co_pk_sk_slopeclass03_waterbodies_km - b.ch_cm_co_pk_sk_slopeclass03_waterbodies_km)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km = round((a.ch_cm_co_pk_sk_slopeclass03_km - b.ch_cm_co_pk_sk_slopeclass03_km)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km = round((a.ch_cm_co_pk_sk_slopeclass05_km - b.ch_cm_co_pk_sk_slopeclass05_km)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km = round((a.ch_cm_co_pk_sk_slopeclass08_km - b.ch_cm_co_pk_sk_slopeclass08_km)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km = round((a.ch_cm_co_pk_sk_slopeclass15_km - b.ch_cm_co_pk_sk_slopeclass15_km)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km = round((a.ch_cm_co_pk_sk_slopeclass22_km - b.ch_cm_co_pk_sk_slopeclass22_km)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km = round((a.ch_cm_co_pk_sk_slopeclass30_km - b.ch_cm_co_pk_sk_slopeclass30_km)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_network_km = round((a.ct_dv_rb_network_km - b.bt_network_km)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_stream_km = round((a.ct_dv_rb_stream_km - b.ct_dv_rb_stream_km)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_lakereservoir_ha = round((a.ct_dv_rb_lakereservoir_ha - b.ct_dv_rb_lakereservoir_ha)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_wetland_ha = round((a.ct_dv_rb_wetland_ha - b.ct_dv_rb_wetland_ha)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_slopeclass03_waterbodies_km = round((a.ct_dv_rb_slopeclass03_waterbodies_km - b.ct_dv_rb_slopeclass03_waterbodies_km)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_slopeclass03_km = round((a.ct_dv_rb_slopeclass03_km - b.ct_dv_rb_slopeclass03_km)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_slopeclass05_km = round((a.ct_dv_rb_slopeclass05_km - b.ct_dv_rb_slopeclass05_km)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_slopeclass08_km = round((a.ct_dv_rb_slopeclass08_km - b.ct_dv_rb_slopeclass08_km)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_slopeclass15_km = round((a.ct_dv_rb_slopeclass15_km - b.ct_dv_rb_slopeclass15_km)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_slopeclass22_km = round((a.ct_dv_rb_slopeclass22_km - b.ct_dv_rb_slopeclass22_km)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_slopeclass30_km = round((a.ct_dv_rb_slopeclass30_km - b.ct_dv_rb_slopeclass30_km)::numeric, 2),
  st_belowupstrbarriers_network_km = round((a.st_network_km - b.st_network_km)::numeric, 2),
  st_belowupstrbarriers_stream_km = round((a.st_stream_km - b.st_stream_km)::numeric, 2),
  st_belowupstrbarriers_lakereservoir_ha = round((a.st_lakereservoir_ha - b.st_lakereservoir_ha)::numeric, 2),
  st_belowupstrbarriers_wetland_ha = round((a.st_wetland_ha - b.st_wetland_ha)::numeric, 2),
  st_belowupstrbarriers_slopeclass03_km = round((a.st_slopeclass03_km - b.st_slopeclass03_km)::numeric, 2),
  st_belowupstrbarriers_slopeclass05_km = round((a.st_slopeclass05_km - b.st_slopeclass05_km)::numeric, 2),
  st_belowupstrbarriers_slopeclass08_km = round((a.st_slopeclass08_km - b.st_slopeclass08_km)::numeric, 2),
  st_belowupstrbarriers_slopeclass15_km = round((a.st_slopeclass15_km - b.st_slopeclass15_km)::numeric, 2),
  st_belowupstrbarriers_slopeclass22_km = round((a.st_slopeclass22_km - b.st_slopeclass22_km)::numeric, 2),
  st_belowupstrbarriers_slopeclass30_km = round((a.st_slopeclass30_km - b.st_slopeclass30_km)::numeric, 2),
  wct_belowupstrbarriers_network_km = round((a.wct_network_km - b.wct_network_km)::numeric, 2),
  wct_belowupstrbarriers_stream_km = round((a.wct_stream_km - b.wct_stream_km)::numeric, 2),
  wct_belowupstrbarriers_lakereservoir_ha = round((a.wct_lakereservoir_ha - b.wct_lakereservoir_ha)::numeric, 2),
  wct_belowupstrbarriers_wetland_ha = round((a.wct_wetland_ha - b.wct_wetland_ha)::numeric, 2),
  wct_belowupstrbarriers_slopeclass03_km = round((a.wct_slopeclass03_km - b.wct_slopeclass03_km)::numeric, 2),
  wct_belowupstrbarriers_slopeclass05_km = round((a.wct_slopeclass05_km - b.wct_slopeclass05_km)::numeric, 2),
  wct_belowupstrbarriers_slopeclass08_km = round((a.wct_slopeclass08_km - b.wct_slopeclass08_km)::numeric, 2),
  wct_belowupstrbarriers_slopeclass15_km = round((a.wct_slopeclass15_km - b.wct_slopeclass15_km)::numeric, 2),
  wct_belowupstrbarriers_slopeclass22_km = round((a.wct_slopeclass22_km - b.wct_slopeclass22_km)::numeric, 2),
  wct_belowupstrbarriers_slopeclass30_km = round((a.wct_slopeclass30_km - b.wct_slopeclass30_km)::numeric, 2)
from above_upstream_barriers b
where a.aggregated_crossings_id = b.aggregated_crossings_id;


-- and calculating belowupstrbarriers for passable features with barriers upstream
with barriers as
(
  select
    a.*,
    c.crossings_dnstr,
    c.barriers_anthropogenic_dnstr
  from bcfishpass.crossings_upstream_access a
  inner join bcfishpass.barriers_anthropogenic b
  on a.aggregated_crossings_id = b.barriers_anthropogenic_id
  inner join bcfishpass.crossings c
  on b.barriers_anthropogenic_id = c.aggregated_crossings_id
),

above_upstream_barriers as
(
  SELECT
    a.aggregated_crossings_id,
    SUM(b.total_network_km) as total_network_km,
    SUM(b.total_stream_km) as total_stream_km,
    SUM(b.total_lakereservoir_ha) as total_lakereservoir_ha,
    SUM(b.total_wetland_ha) as total_wetland_ha,
    SUM(b.total_slopeclass03_waterbodies_km) as total_slopeclass03_waterbodies_km,
    SUM(b.total_slopeclass03_km) as total_slopeclass03_km,
    SUM(b.total_slopeclass05_km) as total_slopeclass05_km,
    SUM(b.total_slopeclass08_km) as total_slopeclass08_km,
    SUM(b.total_slopeclass15_km) as total_slopeclass15_km,
    SUM(b.total_slopeclass22_km) as total_slopeclass22_km,
    SUM(b.total_slopeclass30_km) as total_slopeclass30_km,
    SUM(b.bt_network_km) as bt_network_km,
    SUM(b.bt_stream_km) as bt_stream_km,
    SUM(b.bt_lakereservoir_ha) as bt_lakereservoir_ha,
    SUM(b.bt_wetland_ha) as bt_wetland_ha,
    SUM(b.bt_slopeclass03_waterbodies_km) as bt_slopeclass03_waterbodies_km,
    SUM(b.bt_slopeclass03_km) as bt_slopeclass03_km,
    SUM(b.bt_slopeclass05_km) as bt_slopeclass05_km,
    SUM(b.bt_slopeclass08_km) as bt_slopeclass08_km,
    SUM(b.bt_slopeclass15_km) as bt_slopeclass15_km,
    SUM(b.bt_slopeclass22_km) as bt_slopeclass22_km,
    SUM(b.bt_slopeclass30_km) as bt_slopeclass30_km,
    SUM(b.ch_cm_co_pk_sk_network_km) as ch_cm_co_pk_sk_network_km,
    SUM(b.ch_cm_co_pk_sk_stream_km) as ch_cm_co_pk_sk_stream_km,
    SUM(b.ch_cm_co_pk_sk_lakereservoir_ha) as ch_cm_co_pk_sk_lakereservoir_ha,
    SUM(b.ch_cm_co_pk_sk_wetland_ha) as ch_cm_co_pk_sk_wetland_ha,
    SUM(b.ch_cm_co_pk_sk_slopeclass03_waterbodies_km) as ch_cm_co_pk_sk_slopeclass03_waterbodies_km,
    SUM(b.ch_cm_co_pk_sk_slopeclass03_km) as ch_cm_co_pk_sk_slopeclass03_km,
    SUM(b.ch_cm_co_pk_sk_slopeclass05_km) as ch_cm_co_pk_sk_slopeclass05_km,
    SUM(b.ch_cm_co_pk_sk_slopeclass08_km) as ch_cm_co_pk_sk_slopeclass08_km,
    SUM(b.ch_cm_co_pk_sk_slopeclass15_km) as ch_cm_co_pk_sk_slopeclass15_km,
    SUM(b.ch_cm_co_pk_sk_slopeclass22_km) as ch_cm_co_pk_sk_slopeclass22_km,
    SUM(b.ch_cm_co_pk_sk_slopeclass30_km) as ch_cm_co_pk_sk_slopeclass30_km,
    SUM(b.ct_dv_rb_network_km) as ct_dv_rb_network_km,
    SUM(b.ct_dv_rb_stream_km) as ct_dv_rb_stream_km,
    SUM(b.ct_dv_rb_lakereservoir_ha) as ct_dv_rb_lakereservoir_ha,
    SUM(b.ct_dv_rb_wetland_ha) as ct_dv_rb_wetland_ha,
    SUM(b.ct_dv_rb_slopeclass03_waterbodies_km) as ct_dv_rb_slopeclass03_waterbodies_km,
    SUM(b.ct_dv_rb_slopeclass03_km) as ct_dv_rb_slopeclass03_km,
    SUM(b.ct_dv_rb_slopeclass05_km) as ct_dv_rb_slopeclass05_km,
    SUM(b.ct_dv_rb_slopeclass08_km) as ct_dv_rb_slopeclass08_km,
    SUM(b.ct_dv_rb_slopeclass15_km) as ct_dv_rb_slopeclass15_km,
    SUM(b.ct_dv_rb_slopeclass22_km) as ct_dv_rb_slopeclass22_km,
    SUM(b.ct_dv_rb_slopeclass30_km) as ct_dv_rb_slopeclass30_km,
    SUM(b.st_network_km) as st_network_km,
    SUM(b.st_stream_km) as st_stream_km,
    SUM(b.st_lakereservoir_ha) as st_lakereservoir_ha,
    SUM(b.st_wetland_ha) as st_wetland_ha,
    SUM(b.st_slopeclass03_km) as st_slopeclass03_km,
    SUM(b.st_slopeclass05_km) as st_slopeclass05_km,
    SUM(b.st_slopeclass08_km) as st_slopeclass08_km,
    SUM(b.st_slopeclass15_km) as st_slopeclass15_km,
    SUM(b.st_slopeclass22_km) as st_slopeclass22_km,
    SUM(b.st_slopeclass30_km) as st_slopeclass30_km,
    SUM(b.wct_network_km) as wct_network_km,
    SUM(b.wct_stream_km) as wct_stream_km,
    SUM(b.wct_lakereservoir_ha) as wct_lakereservoir_ha,
    SUM(b.wct_wetland_ha) as wct_wetland_ha,
    SUM(b.wct_slopeclass03_km) as wct_slopeclass03_km,
    SUM(b.wct_slopeclass05_km) as wct_slopeclass05_km,
    SUM(b.wct_slopeclass08_km) as wct_slopeclass08_km,
    SUM(b.wct_slopeclass15_km) as wct_slopeclass15_km,
    SUM(b.wct_slopeclass22_km) as wct_slopeclass22_km,
    SUM(b.wct_slopeclass30_km) as wct_slopeclass30_km
  from bcfishpass.crossings_upstream_access a
  inner join bcfishpass.crossings c on a.aggregated_crossings_id = c.aggregated_crossings_id  -- join to crossings to get barrier status and barriers downstream of given crossing
  left outer join barriers b on
     array[a.aggregated_crossings_id] && b.crossings_dnstr                      -- barriers upstream of given crossing
    and (c.barriers_anthropogenic_dnstr[1] = b.barriers_anthropogenic_dnstr[1]  -- barriers upstream have same downstream barrier id (or no barriers downstream)
        or b.barriers_anthropogenic_dnstr is null
        or b.barriers_anthropogenic_dnstr = array[]::text[]
    )
  where a.watershed_group_code = :'wsg'
  and c.barrier_status in ('PASSABLE','UNKNOWN')                                -- passable features / fords only
  group by a.aggregated_crossings_id
)

update bcfishpass.crossings_upstream_access a
SET
  total_belowupstrbarriers_network_km = round((a.total_network_km - b.total_network_km)::numeric, 2),
  total_belowupstrbarriers_stream_km = round((a.total_stream_km - b.total_stream_km)::numeric, 2),
  total_belowupstrbarriers_lakereservoir_ha = round((a.total_lakereservoir_ha - b.total_lakereservoir_ha)::numeric, 2),
  total_belowupstrbarriers_wetland_ha = round((a.total_wetland_ha - b.total_wetland_ha)::numeric, 2),
  total_belowupstrbarriers_slopeclass03_waterbodies_km = round((a.total_slopeclass03_waterbodies_km - b.total_slopeclass03_waterbodies_km)::numeric, 2),
  total_belowupstrbarriers_slopeclass03_km = round((a.total_slopeclass03_km - b.total_slopeclass03_km)::numeric, 2),
  total_belowupstrbarriers_slopeclass05_km = round((a.total_slopeclass05_km - b.total_slopeclass05_km)::numeric, 2),
  total_belowupstrbarriers_slopeclass08_km = round((a.total_slopeclass08_km - b.total_slopeclass08_km)::numeric, 2),
  total_belowupstrbarriers_slopeclass15_km = round((a.total_slopeclass15_km - b.total_slopeclass15_km)::numeric, 2),
  total_belowupstrbarriers_slopeclass22_km = round((a.total_slopeclass22_km - b.total_slopeclass22_km)::numeric, 2),
  total_belowupstrbarriers_slopeclass30_km = round((a.total_slopeclass30_km - b.total_slopeclass30_km)::numeric, 2),
  bt_belowupstrbarriers_network_km = round((a.bt_network_km - b.bt_network_km)::numeric, 2),
  bt_belowupstrbarriers_stream_km = round((a.bt_stream_km - b.bt_stream_km)::numeric, 2),
  bt_belowupstrbarriers_lakereservoir_ha = round((a.bt_lakereservoir_ha - b.bt_lakereservoir_ha)::numeric, 2),
  bt_belowupstrbarriers_wetland_ha = round((a.bt_wetland_ha - b.bt_wetland_ha)::numeric, 2),
  bt_belowupstrbarriers_slopeclass03_waterbodies_km = round((a.bt_slopeclass03_waterbodies_km - b.bt_slopeclass03_waterbodies_km)::numeric, 2),
  bt_belowupstrbarriers_slopeclass03_km = round((a.bt_slopeclass03_km - b.bt_slopeclass03_km)::numeric, 2),
  bt_belowupstrbarriers_slopeclass05_km = round((a.bt_slopeclass05_km - b.bt_slopeclass05_km)::numeric, 2),
  bt_belowupstrbarriers_slopeclass08_km = round((a.bt_slopeclass08_km - b.bt_slopeclass08_km)::numeric, 2),
  bt_belowupstrbarriers_slopeclass15_km = round((a.bt_slopeclass15_km - b.bt_slopeclass15_km)::numeric, 2),
  bt_belowupstrbarriers_slopeclass22_km = round((a.bt_slopeclass22_km - b.bt_slopeclass22_km)::numeric, 2),
  bt_belowupstrbarriers_slopeclass30_km = round((a.bt_slopeclass30_km - b.bt_slopeclass30_km)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_network_km = round((a.ch_cm_co_pk_sk_network_km - b.ch_cm_co_pk_sk_network_km)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_stream_km = round((a.ch_cm_co_pk_sk_stream_km - b.ch_cm_co_pk_sk_stream_km)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha = round((a.ch_cm_co_pk_sk_lakereservoir_ha - b.ch_cm_co_pk_sk_lakereservoir_ha)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha = round((a.ch_cm_co_pk_sk_wetland_ha - b.ch_cm_co_pk_sk_wetland_ha)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km = round((a.ch_cm_co_pk_sk_slopeclass03_waterbodies_km - b.ch_cm_co_pk_sk_slopeclass03_waterbodies_km)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km = round((a.ch_cm_co_pk_sk_slopeclass03_km - b.ch_cm_co_pk_sk_slopeclass03_km)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km = round((a.ch_cm_co_pk_sk_slopeclass05_km - b.ch_cm_co_pk_sk_slopeclass05_km)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km = round((a.ch_cm_co_pk_sk_slopeclass08_km - b.ch_cm_co_pk_sk_slopeclass08_km)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km = round((a.ch_cm_co_pk_sk_slopeclass15_km - b.ch_cm_co_pk_sk_slopeclass15_km)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km = round((a.ch_cm_co_pk_sk_slopeclass22_km - b.ch_cm_co_pk_sk_slopeclass22_km)::numeric, 2),
  ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km = round((a.ch_cm_co_pk_sk_slopeclass30_km - b.ch_cm_co_pk_sk_slopeclass30_km)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_network_km = round((a.ct_dv_rb_network_km - b.bt_network_km)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_stream_km = round((a.ct_dv_rb_stream_km - b.ct_dv_rb_stream_km)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_lakereservoir_ha = round((a.ct_dv_rb_lakereservoir_ha - b.ct_dv_rb_lakereservoir_ha)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_wetland_ha = round((a.ct_dv_rb_wetland_ha - b.ct_dv_rb_wetland_ha)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_slopeclass03_waterbodies_km = round((a.ct_dv_rb_slopeclass03_waterbodies_km - b.ct_dv_rb_slopeclass03_waterbodies_km)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_slopeclass03_km = round((a.ct_dv_rb_slopeclass03_km - b.ct_dv_rb_slopeclass03_km)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_slopeclass05_km = round((a.ct_dv_rb_slopeclass05_km - b.ct_dv_rb_slopeclass05_km)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_slopeclass08_km = round((a.ct_dv_rb_slopeclass08_km - b.ct_dv_rb_slopeclass08_km)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_slopeclass15_km = round((a.ct_dv_rb_slopeclass15_km - b.ct_dv_rb_slopeclass15_km)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_slopeclass22_km = round((a.ct_dv_rb_slopeclass22_km - b.ct_dv_rb_slopeclass22_km)::numeric, 2),
  ct_dv_rb_belowupstrbarriers_slopeclass30_km = round((a.ct_dv_rb_slopeclass30_km - b.ct_dv_rb_slopeclass30_km)::numeric, 2),
  st_belowupstrbarriers_network_km = round((a.st_network_km - b.st_network_km)::numeric, 2),
  st_belowupstrbarriers_stream_km = round((a.st_stream_km - b.st_stream_km)::numeric, 2),
  st_belowupstrbarriers_lakereservoir_ha = round((a.st_lakereservoir_ha - b.st_lakereservoir_ha)::numeric, 2),
  st_belowupstrbarriers_wetland_ha = round((a.st_wetland_ha - b.st_wetland_ha)::numeric, 2),
  st_belowupstrbarriers_slopeclass03_km = round((a.st_slopeclass03_km - b.st_slopeclass03_km)::numeric, 2),
  st_belowupstrbarriers_slopeclass05_km = round((a.st_slopeclass05_km - b.st_slopeclass05_km)::numeric, 2),
  st_belowupstrbarriers_slopeclass08_km = round((a.st_slopeclass08_km - b.st_slopeclass08_km)::numeric, 2),
  st_belowupstrbarriers_slopeclass15_km = round((a.st_slopeclass15_km - b.st_slopeclass15_km)::numeric, 2),
  st_belowupstrbarriers_slopeclass22_km = round((a.st_slopeclass22_km - b.st_slopeclass22_km)::numeric, 2),
  st_belowupstrbarriers_slopeclass30_km = round((a.st_slopeclass30_km - b.st_slopeclass30_km)::numeric, 2),
  wct_belowupstrbarriers_network_km = round((a.wct_network_km - b.wct_network_km)::numeric, 2),
  wct_belowupstrbarriers_stream_km = round((a.wct_stream_km - b.wct_stream_km)::numeric, 2),
  wct_belowupstrbarriers_lakereservoir_ha = round((a.wct_lakereservoir_ha - b.wct_lakereservoir_ha)::numeric, 2),
  wct_belowupstrbarriers_wetland_ha = round((a.wct_wetland_ha - b.wct_wetland_ha)::numeric, 2),
  wct_belowupstrbarriers_slopeclass03_km = round((a.wct_slopeclass03_km - b.wct_slopeclass03_km)::numeric, 2),
  wct_belowupstrbarriers_slopeclass05_km = round((a.wct_slopeclass05_km - b.wct_slopeclass05_km)::numeric, 2),
  wct_belowupstrbarriers_slopeclass08_km = round((a.wct_slopeclass08_km - b.wct_slopeclass08_km)::numeric, 2),
  wct_belowupstrbarriers_slopeclass15_km = round((a.wct_slopeclass15_km - b.wct_slopeclass15_km)::numeric, 2),
  wct_belowupstrbarriers_slopeclass22_km = round((a.wct_slopeclass22_km - b.wct_slopeclass22_km)::numeric, 2),
  wct_belowupstrbarriers_slopeclass30_km = round((a.wct_slopeclass30_km - b.wct_slopeclass30_km)::numeric, 2)
from above_upstream_barriers b
where a.aggregated_crossings_id = b.aggregated_crossings_id;