-- ---------------------------------
-- report on upstream linear stats
-- ---------------------------------

-- create temp tables to avoid memory issues on systems with limited resources
create temporary table temp_upstr_length as
select
  a.aggregated_crossings_id,
  a.watershed_group_code,
  s.linear_feature_id,
  s.gradient,
  s.edge_type,
  s.waterbody_key,
  case when ac.barriers_bt_dnstr = array[]::text[] then true else false end as access_bt,
  case when ac.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] then true else false end as access_ch_cm_co_pk_sk,
  case when ac.barriers_ct_dv_rb_dnstr = array[]::text[] then true else false end as access_ct_dv_rb,
  case when ac.barriers_st_dnstr = array[]::text[] then true else false end as access_st,
  case when ac.barriers_wct_dnstr = array[]::text[] then true else false end as access_wct,
  st_length(s.geom) as length
from bcfishpass.crossings a
left outer join bcfishpass.streams s
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
left outer join bcfishpass.streams_access_vw ac on s.segmented_stream_id = ac.segmented_stream_id
where a.blue_line_key = a.watershed_key  -- do not compute for points on side channels
and a.watershed_group_code = :'wsg'
order by a.aggregated_crossings_id;

create temporary table temp_upstr_area as
SELECT DISTINCT
  a.aggregated_crossings_id,
  s.waterbody_key,
  case when ac.barriers_bt_dnstr = array[]::text[] then true else false end as access_bt,
  case when ac.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] then true else false end as access_ch_cm_co_pk_sk,
  case when ac.barriers_ct_dv_rb_dnstr = array[]::text[] then true else false end as access_ct_dv_rb,
  case when ac.barriers_st_dnstr = array[]::text[] then true else false end as access_st,
  case when ac.barriers_wct_dnstr = array[]::text[] then true else false end as access_wct,
  ST_Area(lake.geom) as area_lake,
  ST_Area(manmade.geom) as area_manmade,
  ST_Area(wetland.geom) as area_wetland
FROM bcfishpass.crossings a
left outer join bcfishpass.streams s
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
left outer join bcfishpass.streams_access_vw ac on s.segmented_stream_id = ac.segmented_stream_id
left outer join whse_basemapping.fwa_lakes_poly lake ON s.waterbody_key = lake.waterbody_key
left outer join whse_basemapping.fwa_manmade_waterbodies_poly manmade ON s.waterbody_key = manmade.waterbody_key
left outer join whse_basemapping.fwa_wetlands_poly wetland ON s.waterbody_key = wetland.waterbody_key
WHERE a.watershed_group_code = :'wsg'
order by a.aggregated_crossings_id;


WITH at_point AS
(
  SELECT
    a.aggregated_crossings_id,
    a.watershed_group_code,
    coalesce(s.gradient, s2.gradient) as gradient,
    ac.barriers_bt_dnstr,
    ac.barriers_ch_cm_co_pk_sk_dnstr,
    ac.barriers_ct_dv_rb_dnstr,
    ac.barriers_st_dnstr,
    ac.barriers_wct_dnstr
  FROM bcfishpass.crossings a
  left outer join bcfishpass.streams s
  ON a.linear_feature_id = s.linear_feature_id
  AND a.downstream_route_measure > s.downstream_route_measure - .001
  AND a.downstream_route_measure + .001 < s.upstream_route_measure
  -- ON a.blue_line_key = s.blue_line_key
  --AND round(s.downstream_route_measure::numeric, 4) <= round(a.downstream_route_measure::numeric, 4)
  --AND round(s.upstream_route_measure::numeric, 4) > round(a.downstream_route_measure::numeric, 4)
  AND a.watershed_group_code = s.watershed_group_code
  left outer join whse_basemapping.fwa_stream_networks_sp s2
  ON a.linear_feature_id = s2.linear_feature_id
  AND a.downstream_route_measure > s2.downstream_route_measure - .001
  AND a.downstream_route_measure + .001 < s2.upstream_route_measure
  -- ON a.blue_line_key = s.blue_line_key
  --AND round(s2.downstream_route_measure::numeric, 4) <= round(a.downstream_route_measure::numeric, 4)
  --AND round(s2.upstream_route_measure::numeric, 4) > round(a.downstream_route_measure::numeric, 4)
  AND a.watershed_group_code = s2.watershed_group_code
  left outer join bcfishpass.streams_access_vw ac on s.segmented_stream_id = ac.segmented_stream_id
  WHERE a.watershed_group_code = :'wsg'
  order by aggregated_crossings_id
),

upstr_length_sum as
(
  SELECT
    s.aggregated_crossings_id,
  -- totals
    COALESCE(ROUND((SUM(s.length::numeric) / 1000), 2), 0) AS total_network_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))) / 1000)::numeric, 2), 0) AS total_stream_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (
      WHERE (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS total_slopeclass03_waterbodies_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (
      WHERE (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS total_slopeclass03_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.gradient >= .03 AND s.gradient < .05) / 1000))::numeric, 2), 0) as total_slopeclass05_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.gradient >= .05 AND s.gradient < .08) / 1000))::numeric, 2), 0) as total_slopeclass08_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.gradient >= .08 AND s.gradient < .15) / 1000))::numeric, 2), 0) as total_slopeclass15_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.gradient >= .15 AND s.gradient < .22) / 1000))::numeric, 2), 0) as total_slopeclass22_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.gradient >= .22 AND s.gradient < .30) / 1000))::numeric, 2), 0) as total_slopeclass30_km,

  -- bull trout model
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_bt is true) / 1000)::numeric), 2), 0) AS bt_network_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_bt is true AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS bt_stream_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (
      WHERE (s.access_bt is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS bt_slopeclass03_waterbodies_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (
      WHERE (s.access_bt is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS bt_slopeclass03_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_bt is true AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as bt_slopeclass05_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_bt is true AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as bt_slopeclass08_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_bt is true AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as bt_slopeclass15_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_bt is true AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as bt_slopeclass22_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_bt is true AND (s.gradient >= .22 AND s.gradient < .3)) / 1000))::numeric, 2), 0) as bt_slopeclass30_km,

  -- salmon model
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_ch_cm_co_pk_sk is true) / 1000)::numeric), 2), 0) AS ch_cm_co_pk_sk_network_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_ch_cm_co_pk_sk is true AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS ch_cm_co_pk_sk_stream_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (
      WHERE (s.access_ch_cm_co_pk_sk is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS ch_cm_co_pk_sk_slopeclass03_waterbodies_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (
      WHERE (s.access_ch_cm_co_pk_sk is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS ch_cm_co_pk_sk_slopeclass03_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_ch_cm_co_pk_sk is true AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as ch_cm_co_pk_sk_slopeclass05_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_ch_cm_co_pk_sk is true AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as ch_cm_co_pk_sk_slopeclass08_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_ch_cm_co_pk_sk is true AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as ch_cm_co_pk_sk_slopeclass15_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_ch_cm_co_pk_sk is true AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as ch_cm_co_pk_sk_slopeclass22_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_ch_cm_co_pk_sk is true AND (s.gradient >= .22 AND s.gradient < .3)) / 1000))::numeric, 2), 0) as ch_cm_co_pk_sk_slopeclass30_km,

  -- resident ct/dv/rb
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_ct_dv_rb is true) / 1000)::numeric), 2), 0) AS ct_dv_rb_network_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_ct_dv_rb is true AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS ct_dv_rb_stream_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (
      WHERE (s.access_ct_dv_rb is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS ct_dv_rb_slopeclass03_waterbodies_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (
      WHERE (s.access_ct_dv_rb is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS ct_dv_rb_slopeclass03_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_ct_dv_rb is true AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as ct_dv_rb_slopeclass05_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_ct_dv_rb is true AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as ct_dv_rb_slopeclass08_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_ct_dv_rb is true AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as ct_dv_rb_slopeclass15_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_ct_dv_rb is true AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as ct_dv_rb_slopeclass22_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_ct_dv_rb is true AND (s.gradient >= .22 AND s.gradient < .30)) / 1000))::numeric, 2), 0) as ct_dv_rb_slopeclass30_km,

  -- steelhead
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_st is true) / 1000)::numeric), 2), 0) AS st_network_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_st is true AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS st_stream_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (
      WHERE (s.access_st is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS st_slopeclass03_waterbodies_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (
      WHERE (s.access_st is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS st_slopeclass03_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_st is true AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as st_slopeclass05_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_st is true AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as st_slopeclass08_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_st is true AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as st_slopeclass15_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_st is true AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as st_slopeclass22_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_st is true AND (s.gradient >= .22 AND s.gradient < .30)) / 1000))::numeric, 2), 0) as st_slopeclass30_km,

  -- wct
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_wct is true) / 1000)::numeric), 2), 0) AS wct_network_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_wct is true AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS wct_stream_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (
      WHERE (s.access_wct is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS wct_slopeclass03_waterbodies_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (
      WHERE (s.access_wct is true) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
    )) / 1000)::numeric, 2), 0) AS wct_slopeclass03_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_wct is true AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as wct_slopeclass05_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_wct is true AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as wct_slopeclass08_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_wct is true AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as wct_slopeclass15_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_wct is true AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as wct_slopeclass22_km,
    COALESCE(ROUND(((SUM(s.length) FILTER (WHERE s.access_wct is true AND (s.gradient >= .22 AND s.gradient < .30)) / 1000))::numeric, 2), 0) as wct_slopeclass30_km
  FROM temp_upstr_length s
  left outer join whse_basemapping.fwa_waterbodies wb ON s.waterbody_key = wb.waterbody_key
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
  FROM temp_upstr_area uwb
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

