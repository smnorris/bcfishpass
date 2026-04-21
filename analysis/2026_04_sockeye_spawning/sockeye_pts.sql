-- create table temp.sockeye_pts, holding sockeye observations and most upstream points on known sockeye spawning/rearing streams that are:
--  + upstream of a potential rearing lake
--  + not *within* a potential rearing lake

DROP TABLE IF EXISTS temp.sockeye_pts;

CREATE TABLE temp.sockeye_pts AS 


-- observations downstream of lakes of interest, but not in the lakes
with obs as (
  SELECT DISTINCT
    o.observation_key,
    o.wscode as wscode_ltree,
    o.localcode as localcode_ltree,
    o.blue_line_key,
    o.downstream_route_measure,
    st_force2d(o.geom)::geometry(point) as geom
  FROM bcfishpass.observations o
  INNER JOIN whse_basemapping.fwa_stream_networks_sp s ON o.linear_feature_id = s.linear_feature_id
  INNER JOIN temp.sockeye_lakes lk ON FWA_Upstream(
    lk.blue_line_key,
    lk.downstream_route_measure,
    lk.wscode_ltree,
    lk.localcode_ltree,
    o.blue_line_key,
    o.downstream_route_measure,
    o.wscode,
    o.localcode
    )
  WHERE o.species_code = 'SK'
  AND s.waterbody_key NOT IN (select distinct waterbody_key from temp.sockeye_lakes)
),

-- upstream ends of known habitat, not in lakes of interest (and not side channels)
hab_pts as (
  select distinct on (blue_line_key)
    segmented_stream_id as observation_id,
    wscode as wscode_ltree,
    localcode as localcode_ltree,
    blue_line_key,
    (upstream_route_measure - .1) as downstream_route_measure, -- nudge endpoint down slightly to avoid precision issues
    st_endpoint(geom) as geom
  from bcfishpass.streams_sk_vw
  where (spawning > 1 or rearing > 1) -- known spawning or rearing
  AND coalesce(waterbody_key, 0) NOT IN (select distinct waterbody_key from temp.sockeye_lakes)
  -- and watershed_key = blue_line_key
  order by blue_line_key, wscode desc, localcode desc, upstream_route_measure desc
),

-- subset of habitat points that are upstream of lakes of interest
hab_pts_upstr_lakes AS (
  select distinct
    o.observation_id,
    o.wscode_ltree,
    o.localcode_ltree,
    o.blue_line_key,
    o.downstream_route_measure,
    st_force2d(o.geom)::geometry(point) as geom
  from hab_pts o
  INNER JOIN temp.sockeye_lakes lk ON FWA_Upstream(
      lk.blue_line_key,
      lk.downstream_route_measure,
      lk.wscode_ltree,
      lk.localcode_ltree,
      o.blue_line_key,
      o.downstream_route_measure,
      o.wscode_ltree,
      o.localcode_ltree
      )
)

select *, 'observation' as src from obs
union all 
select *, 'known_habitat' as src from hab_pts_upstr_lakes;