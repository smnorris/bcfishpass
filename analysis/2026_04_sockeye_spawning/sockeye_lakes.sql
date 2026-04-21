-- create a table holding lakes of interest

drop table if exists temp.sockeye_lakes;

create table temp.sockeye_lakes as 

with large_lake AS (
  
  -- large lakes (>2km2) accessible to steelhead
  SELECT DISTINCT ON (st.waterbody_key)
    st.waterbody_key,
    st.wscode_ltree,
    st.localcode_ltree,
    st.downstream_route_measure + .01 as downstream_route_measure, -- nudge up just a bit to prevent precision errors
    st.blue_line_key
  FROM bcfishpass.streams s
  INNER JOIN whse_basemapping.fwa_stream_networks_sp st on s.linear_feature_id = st.linear_feature_id
  INNER JOIN bcfishpass.streams_access av on s.segmented_stream_id = av.segmented_stream_id
  INNER JOIN bcfishpass.wsg_species_presence p ON s.watershed_group_code = p.watershed_group_code
  LEFT OUTER JOIN bcfishpass.parameters_habitat_thresholds t ON t.species_code = 'SK'
  LEFT OUTER JOIN whse_basemapping.fwa_lakes_poly lk ON s.waterbody_key = lk.waterbody_key
  LEFT OUTER JOIN whse_basemapping.fwa_manmade_waterbodies_poly res ON s.waterbody_key = res.waterbody_key
  WHERE
    p.sk is true AND
    av.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] AND
    (
      lk.area_ha >= t.rear_lake_ha_min OR  -- lakes
      res.area_ha >= t.rear_lake_ha_min    -- reservoirs
    )
  AND st.fwa_watershed_code NOT LIKE '999-999999%'
  AND st.localcode_ltree IS NOT NULL
  ORDER BY st.waterbody_key, st.wscode_ltree, st.localcode_ltree, st.downstream_route_measure
),

-- DFO SK lakes (lakes only, no results when joining to fwa reservoirs - plus no check on accessibility model)
dfo_lake AS (
  SELECT DISTINCT ON (waterbody_key)
    s.waterbody_key,
    s.wscode_ltree,
    s.localcode_ltree,
    s.downstream_route_measure + .01 as downstream_route_measure, -- nudge up just a bit to prevent precision errors
    s.blue_line_key
  FROM whse_basemapping.fwa_stream_networks_sp s
  INNER JOIN whse_basemapping.fwa_lakes_poly l ON s.waterbody_key = l.waterbody_key
  INNER JOIN bcfishpass.dfo_known_sockeye_lakes dfo ON l.waterbody_poly_id = dfo.waterbody_poly_id
  WHERE s.fwa_watershed_code NOT LIKE '999-999999%'
  AND s.localcode_ltree IS NOT NULL
  ORDER BY s.waterbody_key, s.wscode_ltree, s.localcode_ltree, s.downstream_route_measure
),

all_lake as (
  select * from large_lake
  UNION 
  select * from dfo_lake
)

-- write output, flagging which source the waterbody comes from

select distinct a.*,
  case 
    when large.waterbody_key is not null then true 
    else false 
  end as large_lake,
  case 
    when dfo.waterbody_key is not null then true 
    else false 
  end as dfo_lake,
  coalesce(l.geom, r.geom) as geom
from all_lake a
left join large_lake large on a.waterbody_key = large.waterbody_key
left join dfo_lake dfo on a.waterbody_key = dfo.waterbody_key
left join whse_basemapping.fwa_lakes_poly l on a.waterbody_key = l.waterbody_key
left join whse_basemapping.fwa_manmade_waterbodies_poly r on a.waterbody_key = r.waterbody_key;
