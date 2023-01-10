-- ---------------------------------
-- first, report on status at point
-- ---------------------------------
WITH at_point AS
(
  SELECT
    a.:point_id,
    coalesce(s.gradient, s2.gradient) as gradient,
    s.barriers_bt_dnstr,
    s.barriers_ch_cm_co_pk_sk_dnstr,
    s.barriers_st_dnstr,
    s.barriers_wct_dnstr
  FROM bcfishpass.:point_table a
  left outer join bcfishpass.streams s
  ON a.linear_feature_id = s.linear_feature_id
  AND a.downstream_route_measure > s.downstream_route_measure - .001
  AND a.downstream_route_measure + .001 < s.upstream_route_measure
  AND a.watershed_group_code = s.watershed_group_code
  INNER JOIN whse_basemapping.fwa_stream_networks_sp s2
  ON a.linear_feature_id = s2.linear_feature_id
  AND a.downstream_route_measure > s2.downstream_route_measure - .001
  AND a.downstream_route_measure + .001 < s2.upstream_route_measure
  AND a.watershed_group_code = s2.watershed_group_code
  WHERE a.watershed_group_code = :'wsg'
  --AND a.blue_line_key = a.watershed_key             -- do not update points in side channels
  ORDER BY a.:point_id
)

UPDATE bcfishpass.:point_table p
SET
  gradient = u.gradient,
  barriers_bt_dnstr = u.barriers_bt_dnstr,
  barriers_ch_cm_co_pk_sk_dnstr = u.barriers_ch_cm_co_pk_sk_dnstr,
  barriers_st_dnstr = u.barriers_st_dnstr,
  barriers_wct_dnstr = u.barriers_wct_dnstr
FROM at_point u
WHERE p.:point_id = u.:point_id;


-- ---------------------------------
-- next, report on upstream linear stats
-- ---------------------------------
with upstr as materialized
(
  select
    a.:point_id,
    s.linear_feature_id,
    s.gradient,
    s.edge_type,
    s.waterbody_key,
    s.barriers_bt_dnstr,
    s.barriers_ch_cm_co_pk_sk_dnstr,
    s.barriers_st_dnstr,
    s.barriers_wct_dnstr,
    s.model_spawning_ch,
    s.model_spawning_co,
    s.model_spawning_sk,
    s.model_spawning_st,
    s.model_spawning_wct,
    s.model_spawning_bt,
    s.model_spawning_cm,
    s.model_spawning_pk,
    s.model_rearing_ch,
    s.model_rearing_co,
    s.model_rearing_sk,
    s.model_rearing_st,
    s.model_rearing_wct,
    s.model_rearing_bt,
    s.geom
  from bcfishpass.:point_table a
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
  where a.watershed_group_code = :'wsg'
),

report AS
(SELECT
  s.:point_id,

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
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_bt_dnstr IS NULL) / 1000)::numeric), 2), 0) AS bt_network_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_bt_dnstr IS NULL AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS bt_stream_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.barriers_bt_dnstr IS NULL) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS bt_slopeclass03_waterbodies_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.barriers_bt_dnstr IS NULL) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS bt_slopeclass03_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_bt_dnstr IS NULL AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as bt_slopeclass05_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_bt_dnstr IS NULL AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as bt_slopeclass08_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_bt_dnstr IS NULL AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as bt_slopeclass15_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_bt_dnstr IS NULL AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as bt_slopeclass22_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_bt_dnstr IS NULL AND (s.gradient >= .22 AND s.gradient < .3)) / 1000))::numeric, 2), 0) as bt_slopeclass30_km,

-- ch/co/sk salmon model
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_ch_cm_co_pk_sk_dnstr IS NULL) / 1000)::numeric), 2), 0) AS ch_co_sk_network_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_ch_cm_co_pk_sk_dnstr IS NULL AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS ch_co_sk_stream_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.barriers_ch_cm_co_pk_sk_dnstr IS NULL) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS ch_co_sk_slopeclass03_waterbodies_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.barriers_ch_cm_co_pk_sk_dnstr IS NULL) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS ch_co_sk_slopeclass03_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_ch_cm_co_pk_sk_dnstr IS NULL AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as ch_co_sk_slopeclass05_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_ch_cm_co_pk_sk_dnstr IS NULL AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as ch_co_sk_slopeclass08_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_ch_cm_co_pk_sk_dnstr IS NULL AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as ch_co_sk_slopeclass15_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_ch_cm_co_pk_sk_dnstr IS NULL AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as ch_co_sk_slopeclass22_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_ch_cm_co_pk_sk_dnstr IS NULL AND (s.gradient >= .22 AND s.gradient < .3)) / 1000))::numeric, 2), 0) as ch_co_sk_slopeclass30_km,

-- steelhead
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_st_dnstr IS NULL) / 1000)::numeric), 2), 0) AS st_network_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_st_dnstr IS NULL AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS st_stream_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.barriers_st_dnstr IS NULL) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS st_slopeclass03_waterbodies_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.barriers_st_dnstr IS NULL) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS st_slopeclass03_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_st_dnstr IS NULL AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as st_slopeclass05_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_st_dnstr IS NULL AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as st_slopeclass08_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_st_dnstr IS NULL AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as st_slopeclass15_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_st_dnstr IS NULL AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as st_slopeclass22_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_st_dnstr IS NULL AND (s.gradient >= .22 AND s.gradient < .30)) / 1000))::numeric, 2), 0) as st_slopeclass30_km,

-- wct
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_wct_dnstr IS NULL) / 1000)::numeric), 2), 0) AS wct_network_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_wct_dnstr IS NULL AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS wct_stream_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.barriers_wct_dnstr IS NULL) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS wct_slopeclass03_waterbodies_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.barriers_wct_dnstr IS NULL) AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS wct_slopeclass03_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_wct_dnstr IS NULL AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as wct_slopeclass05_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_wct_dnstr IS NULL AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as wct_slopeclass08_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_wct_dnstr IS NULL AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as wct_slopeclass15_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_wct_dnstr IS NULL AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as wct_slopeclass22_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_wct_dnstr IS NULL AND (s.gradient >= .22 AND s.gradient < .30)) / 1000))::numeric, 2), 0) as wct_slopeclass30_km,

-- habitat models
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_spawning_ch IS TRUE) / 1000))::numeric, 2), 0) AS ch_spawning_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_rearing_ch IS TRUE) / 1000))::numeric, 2), 0) AS ch_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_spawning_co IS TRUE) / 1000))::numeric, 2), 0) AS co_spawning_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_rearing_co IS TRUE) / 1000))::numeric, 2), 0) AS co_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_spawning_sk IS TRUE) / 1000))::numeric, 2), 0) AS sk_spawning_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_rearing_sk IS TRUE) / 1000))::numeric, 2), 0) AS sk_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_spawning_st IS TRUE) / 1000))::numeric, 2), 0) AS st_spawning_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_rearing_st IS TRUE) / 1000))::numeric, 2), 0) AS st_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_spawning_wct IS TRUE) / 1000))::numeric, 2), 0) AS wct_spawning_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_rearing_wct IS TRUE) / 1000))::numeric, 2), 0) AS wct_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_spawning_bt IS TRUE) / 1000))::numeric, 2), 0) AS bt_spawning_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_rearing_bt IS TRUE) / 1000))::numeric, 2), 0) AS bt_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_spawning_cm IS TRUE) / 1000))::numeric, 2), 0) AS cm_spawning_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_spawning_pk IS TRUE) / 1000))::numeric, 2), 0) AS pk_spawning_km ,

  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_spawning_ch IS TRUE OR
                                                        s.model_spawning_co IS TRUE OR
                                                        s.model_spawning_sk IS TRUE OR
                                                        s.model_spawning_st IS TRUE OR
                                                        s.model_spawning_wct IS TRUE OR
                                                        s.model_spawning_bt IS TRUE OR
                                                        s.model_spawning_cm IS TRUE OR
                                                        s.model_spawning_pk IS TRUE 
                                                  ) / 1000))::numeric, 2), 0)  AS all_spawning_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_rearing_ch IS TRUE OR
                                                        s.model_rearing_co IS TRUE OR
                                                        s.model_rearing_sk IS TRUE OR
                                                        s.model_rearing_st IS TRUE OR
                                                        s.model_rearing_wct IS TRUE OR
                                                        s.model_rearing_bt IS TRUE 
                                                  ) / 1000))::numeric, 2), 0) AS all_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_spawning_ch IS TRUE OR
                                                        s.model_spawning_co IS TRUE OR
                                                        s.model_spawning_sk IS TRUE OR
                                                        s.model_spawning_st IS TRUE OR
                                                        s.model_spawning_wct IS TRUE OR
                                                        s.model_spawning_bt IS TRUE OR
                                                        s.model_spawning_cm IS TRUE OR
                                                        s.model_spawning_pk IS TRUE OR
                                                        s.model_rearing_ch IS TRUE OR
                                                        s.model_rearing_co IS TRUE OR
                                                        s.model_rearing_sk IS TRUE OR
                                                        s.model_rearing_st IS TRUE OR
                                                        s.model_rearing_wct IS TRUE OR
                                                        s.model_rearing_bt IS TRUE 
                                                  ) / 1000))::numeric, 2), 0) AS all_spawningrearing_km

FROM upstr s
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb ON s.waterbody_key = wb.waterbody_key
GROUP BY s.:point_id
)

UPDATE bcfishpass.:point_table p
SET
  total_network_km = r.total_network_km,
  total_stream_km = r.total_stream_km,
  total_slopeclass03_waterbodies_km = r.total_slopeclass03_waterbodies_km,
  total_slopeclass03_km = r.total_slopeclass03_km,
  total_slopeclass05_km = r.total_slopeclass05_km,
  total_slopeclass08_km = r.total_slopeclass08_km,
  total_slopeclass15_km = r.total_slopeclass15_km,
  total_slopeclass22_km = r.total_slopeclass22_km,
  total_slopeclass30_km = r.total_slopeclass30_km,
  ch_co_sk_network_km = r.ch_co_sk_network_km,
  ch_co_sk_stream_km = r.ch_co_sk_stream_km,
  ch_co_sk_slopeclass03_waterbodies_km = r.ch_co_sk_slopeclass03_waterbodies_km,
  ch_co_sk_slopeclass03_km = r.ch_co_sk_slopeclass03_km,
  ch_co_sk_slopeclass05_km = r.ch_co_sk_slopeclass05_km,
  ch_co_sk_slopeclass08_km = r.ch_co_sk_slopeclass08_km,
  ch_co_sk_slopeclass15_km = r.ch_co_sk_slopeclass15_km,
  ch_co_sk_slopeclass22_km = r.ch_co_sk_slopeclass22_km,
  ch_co_sk_slopeclass30_km = r.ch_co_sk_slopeclass30_km,
  st_network_km = r.st_network_km,
  st_stream_km = r.st_stream_km,
  st_slopeclass03_waterbodies_km = r.st_slopeclass03_waterbodies_km,
  st_slopeclass03_km = r.st_slopeclass03_km,
  st_slopeclass05_km = r.st_slopeclass05_km,
  st_slopeclass08_km = r.st_slopeclass08_km,
  st_slopeclass15_km = r.st_slopeclass15_km,
  st_slopeclass22_km = r.st_slopeclass22_km,
  st_slopeclass30_km = r.st_slopeclass30_km,
  wct_network_km = r.wct_network_km,
  wct_stream_km = r.wct_stream_km,
  wct_slopeclass03_waterbodies_km = r.wct_slopeclass03_waterbodies_km,
  wct_slopeclass03_km = r.wct_slopeclass03_km,
  wct_slopeclass05_km = r.wct_slopeclass05_km,
  wct_slopeclass08_km = r.wct_slopeclass08_km,
  wct_slopeclass15_km = r.wct_slopeclass15_km,
  wct_slopeclass22_km = r.wct_slopeclass22_km,
  wct_slopeclass30_km = r.wct_slopeclass30_km,
  bt_network_km = r.bt_network_km,
  bt_stream_km = r.bt_stream_km,
  bt_slopeclass03_waterbodies_km = r.bt_slopeclass03_waterbodies_km,
  bt_slopeclass03_km = r.bt_slopeclass03_km,
  bt_slopeclass05_km = r.bt_slopeclass05_km,
  bt_slopeclass08_km = r.bt_slopeclass08_km,
  bt_slopeclass15_km = r.bt_slopeclass15_km,
  bt_slopeclass22_km = r.bt_slopeclass22_km,
  bt_slopeclass30_km = r.bt_slopeclass30_km,
  ch_spawning_km = r.ch_spawning_km,
  ch_rearing_km = r.ch_rearing_km,
  co_spawning_km = r.co_spawning_km,
  co_rearing_km = r.co_rearing_km,
  sk_spawning_km = r.sk_spawning_km,
  sk_rearing_km = r.sk_rearing_km,
  st_spawning_km = r.st_spawning_km,
  st_rearing_km = r.st_rearing_km,
  wct_spawning_km = r.wct_spawning_km,
  wct_rearing_km = r.wct_rearing_km,
  bt_spawning_km = r.bt_spawning_km,
  bt_rearing_km = r.bt_rearing_km,
  cm_spawning_km = r.cm_spawning_km,
  
  pk_spawning_km = r.pk_spawning_km,
  
  all_spawning_km = r.all_spawning_km,
  all_rearing_km = r.all_rearing_km,
  all_spawningrearing_km = r.all_spawningrearing_km
FROM report r
WHERE p.:point_id = r.:point_id
AND p.blue_line_key = p.watershed_key; -- do not update points in side channels


-- increase linear total for co and sk rearing by 50% within wetlands/lakes
-- this is just an attempt to give these more importance (as they aren't really linear anyway)
WITH lake_wetland_rearing AS
(
  SELECT
    a.:point_id,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_rearing_co IS TRUE AND wb.waterbody_type = 'W') / 1000))::numeric, 2), 0) AS co_rearing_km_wetland,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_rearing_sk IS TRUE AND wb.waterbody_type IN ('X','L')) / 1000))::numeric, 2), 0) AS sk_rearing_km_lake
  FROM bcfishpass.:point_table a
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
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
  ON s.waterbody_key = wb.waterbody_key
  WHERE a.watershed_group_code = :'wsg'
  GROUP BY a.:point_id
)

UPDATE bcfishpass.:point_table p
SET
  co_rearing_km = co_rearing_km + (r.co_rearing_km_wetland * .5),
  sk_rearing_km = sk_rearing_km + (r.sk_rearing_km_lake * .5),
  all_rearing_km = all_rearing_km + (r.co_rearing_km_wetland * .5) + (r.sk_rearing_km_lake * .5),
  all_spawningrearing_km = all_spawningrearing_km + (r.co_rearing_km_wetland * .5) + (r.sk_rearing_km_lake * .5)
FROM lake_wetland_rearing r
WHERE p.watershed_group_code = :'wsg'
AND p.:point_id = r.:point_id
AND p.blue_line_key = p.watershed_key; -- do not update points in side channels


-- populate upstream area stats
WITH upstr_wb AS MATERIALIZED  -- force this query to materialize so the wbkey filter does not get pushed down and ruin performance
(SELECT DISTINCT
  a.:point_id,
  s.waterbody_key,
  s.barriers_ch_cm_co_pk_sk_dnstr,
  s.barriers_st_dnstr,
  s.barriers_wct_dnstr,
  s.model_rearing_co,
  s.model_rearing_sk,
  ST_Area(lake.geom) as area_lake,
  ST_Area(manmade.geom) as area_manmade,
  ST_Area(wetland.geom) as area_wetland
FROM bcfishpass.:point_table a
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
LEFT OUTER JOIN whse_basemapping.fwa_lakes_poly lake
ON s.waterbody_key = lake.waterbody_key
LEFT OUTER JOIN whse_basemapping.fwa_manmade_waterbodies_poly manmade
ON s.waterbody_key = manmade.waterbody_key
LEFT OUTER JOIN whse_basemapping.fwa_wetlands_poly wetland
ON s.waterbody_key = wetland.waterbody_key
WHERE a.watershed_group_code = :'wsg'
ORDER BY a.:point_id
),

report AS
(SELECT
  :point_id,
  ROUND(((
    SUM(COALESCE(uwb.area_lake, 0)) + SUM(COALESCE(uwb.area_manmade,0))) / 10000)::numeric, 2
  ) AS total_lakereservoir_ha,
  ROUND((SUM(COALESCE(uwb.area_wetland, 0)) / 10000)::numeric, 2) AS total_wetland_ha,
  ROUND(((SUM(COALESCE(uwb.area_lake, 0)) FILTER (WHERE uwb.barriers_ch_cm_co_pk_sk_dnstr IS NULL) +
          SUM(COALESCE(uwb.area_manmade, 0)) FILTER (WHERE uwb.barriers_ch_cm_co_pk_sk_dnstr IS NULL)) / 10000)::numeric, 2) AS ch_co_sk_lakereservoir_ha,
  ROUND(((SUM(COALESCE(uwb.area_wetland, 0)) FILTER (WHERE uwb.barriers_ch_cm_co_pk_sk_dnstr IS NULL)) / 10000)::numeric, 2) AS ch_co_sk_wetland_ha,

  ROUND(((SUM(COALESCE(uwb.area_lake, 0)) FILTER (WHERE uwb.barriers_st_dnstr IS NULL) +
          SUM(COALESCE(uwb.area_manmade, 0)) FILTER (WHERE uwb.barriers_st_dnstr IS NULL)) / 10000)::numeric, 2) AS st_lakereservoir_ha,
  ROUND(((SUM(COALESCE(uwb.area_wetland, 0)) FILTER (WHERE uwb.barriers_st_dnstr IS NULL)) / 10000)::numeric, 2) AS st_wetland_ha,
  ROUND(((SUM(COALESCE(uwb.area_lake, 0)) FILTER (WHERE uwb.barriers_wct_dnstr IS NULL) +
          SUM(COALESCE(uwb.area_manmade,0)) FILTER (WHERE uwb.barriers_wct_dnstr IS NULL)) / 10000)::numeric, 2) AS wct_lakereservoir_ha,
  ROUND(((SUM(COALESCE(uwb.area_wetland, 0)) FILTER (WHERE uwb.barriers_wct_dnstr IS NULL)) / 10000)::numeric, 2) AS wct_wetland_ha,
  ROUND(((SUM(COALESCE(uwb.area_wetland, 0)) FILTER (WHERE uwb.model_rearing_co = True)) / 10000)::numeric, 2) AS co_rearing_ha,
  ROUND(((SUM(COALESCE(uwb.area_lake, 0)) FILTER (WHERE uwb.model_rearing_sk = True) +
          SUM(COALESCE(uwb.area_manmade, 0)) FILTER (WHERE uwb.model_rearing_sk = True)) / 10000)::numeric, 2) AS sk_rearing_ha
FROM upstr_wb uwb
WHERE waterbody_key IS NOT NULL
GROUP BY :point_id
)

UPDATE bcfishpass.:point_table p
SET
  total_lakereservoir_ha = r.total_lakereservoir_ha,
  total_wetland_ha = r.total_wetland_ha,
  ch_co_sk_lakereservoir_ha = r.ch_co_sk_lakereservoir_ha,
  ch_co_sk_wetland_ha = r.ch_co_sk_wetland_ha,
  st_lakereservoir_ha = r.st_lakereservoir_ha,
  st_wetland_ha = r.st_wetland_ha,
  wct_lakereservoir_ha = r.wct_lakereservoir_ha,
  wct_wetland_ha = r.wct_wetland_ha,
  co_rearing_ha = r.co_rearing_ha,
  sk_rearing_ha = r.sk_rearing_ha
FROM report r
WHERE p.:point_id = r.:point_id
AND p.blue_line_key = p.watershed_key;  -- do not update points on side channels



-- Calculate and populate upstream length/area stats for below addtional upstream barriers
-- (this is the total at the given point as already calculated, minus the total on all points immediately upstream of the point)
-- NOTE - this has to be re-run separately for bcfishpass.crossings because it includes a mixture of passable/barriers,
-- and not all tables we run this report on will have the barrier_status column
-- see 00_report_crossings_obs_belowupstrbarriers.sql

-- default to total upstream
UPDATE bcfishpass.:point_table p
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
  ch_co_sk_belowupstrbarriers_network_km = ch_co_sk_network_km,
  ch_co_sk_belowupstrbarriers_stream_km = ch_co_sk_stream_km,
  ch_co_sk_belowupstrbarriers_lakereservoir_ha = ch_co_sk_lakereservoir_ha,
  ch_co_sk_belowupstrbarriers_wetland_ha = ch_co_sk_wetland_ha,
  ch_co_sk_belowupstrbarriers_slopeclass03_waterbodies_km = ch_co_sk_slopeclass03_waterbodies_km,
  ch_co_sk_belowupstrbarriers_slopeclass03_km = ch_co_sk_slopeclass03_km,
  ch_co_sk_belowupstrbarriers_slopeclass05_km = ch_co_sk_slopeclass05_km,
  ch_co_sk_belowupstrbarriers_slopeclass08_km = ch_co_sk_slopeclass08_km,
  ch_co_sk_belowupstrbarriers_slopeclass15_km = ch_co_sk_slopeclass15_km,
  ch_co_sk_belowupstrbarriers_slopeclass22_km = ch_co_sk_slopeclass22_km,
  ch_co_sk_belowupstrbarriers_slopeclass30_km = ch_co_sk_slopeclass30_km,

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
  wct_belowupstrbarriers_slopeclass30_km = wct_slopeclass30_km,
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

  ch_spawning_belowupstrbarriers_km = ch_spawning_km,
  ch_rearing_belowupstrbarriers_km = ch_rearing_km,
  co_spawning_belowupstrbarriers_km = co_spawning_km,
  co_rearing_belowupstrbarriers_km = co_rearing_km,
  sk_spawning_belowupstrbarriers_km = sk_spawning_km,
  sk_rearing_belowupstrbarriers_km = sk_rearing_km,
  st_spawning_belowupstrbarriers_km = st_spawning_km,
  st_rearing_belowupstrbarriers_km = st_rearing_km,
  wct_spawning_belowupstrbarriers_km = wct_spawning_km,
  wct_rearing_belowupstrbarriers_km = wct_rearing_km,
  bt_spawning_belowupstrbarriers_km = bt_spawning_km,
  bt_rearing_belowupstrbarriers_km = bt_rearing_km,
  cm_spawning_belowupstrbarriers_km = cm_spawning_km,
  
  pk_spawning_belowupstrbarriers_km = pk_spawning_km,
  
  all_spawning_belowupstrbarriers_km = all_spawning_km,
  all_rearing_belowupstrbarriers_km = all_rearing_km,
  all_spawningrearing_belowupstrbarriers_km = all_spawningrearing_km
WHERE watershed_group_code = :'wsg' 
AND blue_line_key = watershed_key; -- do not include points in side channels

-- then calculate the rest where there is/are anthropogenic crossings upstream
WITH report AS
(SELECT
  a.:point_id,
  ROUND((COALESCE(a.total_network_km, 0) - SUM(COALESCE(b.total_network_km, 0)))::numeric, 2) total_belowupstrbarriers_network_km,
  ROUND((COALESCE(a.total_stream_km, 0) - SUM(COALESCE(b.total_stream_km, 0)))::numeric, 2) total_belowupstrbarriers_stream_km,
  ROUND((COALESCE(a.total_lakereservoir_ha, 0) - SUM(COALESCE(b.total_lakereservoir_ha, 0)))::numeric, 2) total_belowupstrbarriers_lakereservoir_ha,
  ROUND((COALESCE(a.total_wetland_ha, 0) - SUM(COALESCE(b.total_wetland_ha, 0)))::numeric, 2) total_belowupstrbarriers_wetland_ha,
  ROUND((COALESCE(a.total_slopeclass03_waterbodies_km, 0) - SUM(COALESCE(b.total_slopeclass03_waterbodies_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass03_waterbodies_km,
  ROUND((COALESCE(a.total_slopeclass03_km, 0) - SUM(COALESCE(b.total_slopeclass03_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass03_km,
  ROUND((COALESCE(a.total_slopeclass05_km, 0) - SUM(COALESCE(b.total_slopeclass05_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass05_km,
  ROUND((COALESCE(a.total_slopeclass08_km, 0) - SUM(COALESCE(b.total_slopeclass08_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass08_km,
  ROUND((COALESCE(a.total_slopeclass15_km, 0) - SUM(COALESCE(b.total_slopeclass15_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass15_km,
  ROUND((COALESCE(a.total_slopeclass22_km, 0) - SUM(COALESCE(b.total_slopeclass22_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass22_km,
  ROUND((COALESCE(a.total_slopeclass30_km, 0) - SUM(COALESCE(b.total_slopeclass30_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass30_km,
  ROUND((COALESCE(a.ch_co_sk_network_km, 0) - SUM(COALESCE(b.ch_co_sk_network_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_network_km,
  ROUND((COALESCE(a.ch_co_sk_stream_km, 0) - SUM(COALESCE(b.ch_co_sk_stream_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_stream_km,
  ROUND((COALESCE(a.ch_co_sk_lakereservoir_ha, 0) - SUM(COALESCE(b.ch_co_sk_lakereservoir_ha, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_lakereservoir_ha,
  ROUND((COALESCE(a.ch_co_sk_wetland_ha, 0) - SUM(COALESCE(b.ch_co_sk_wetland_ha, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_wetland_ha,
  ROUND((COALESCE(a.ch_co_sk_slopeclass03_waterbodies_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass03_waterbodies_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass03_waterbodies_km,
  ROUND((COALESCE(a.ch_co_sk_slopeclass03_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass03_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass03_km,
  ROUND((COALESCE(a.ch_co_sk_slopeclass05_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass05_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass05_km,
  ROUND((COALESCE(a.ch_co_sk_slopeclass08_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass08_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass08_km,
  ROUND((COALESCE(a.ch_co_sk_slopeclass15_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass15_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass15_km,
  ROUND((COALESCE(a.ch_co_sk_slopeclass22_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass22_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass22_km,
  ROUND((COALESCE(a.ch_co_sk_slopeclass30_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass30_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass30_km,

  ROUND((COALESCE(a.st_network_km, 0) - SUM(COALESCE(b.st_network_km, 0)))::numeric, 2) st_belowupstrbarriers_network_km,
  ROUND((COALESCE(a.st_stream_km, 0) - SUM(COALESCE(b.st_stream_km, 0)))::numeric, 2) st_belowupstrbarriers_stream_km,
  ROUND((COALESCE(a.st_lakereservoir_ha, 0) - SUM(COALESCE(b.st_lakereservoir_ha, 0)))::numeric, 2) st_belowupstrbarriers_lakereservoir_ha,
  ROUND((COALESCE(a.st_wetland_ha, 0) - SUM(COALESCE(b.st_wetland_ha, 0)))::numeric, 2) st_belowupstrbarriers_wetland_ha,
  ROUND((COALESCE(a.st_slopeclass03_km, 0) - SUM(COALESCE(b.st_slopeclass03_km, 0)))::numeric, 2) st_belowupstrbarriers_slopeclass03_km,
  ROUND((COALESCE(a.st_slopeclass05_km, 0) - SUM(COALESCE(b.st_slopeclass05_km, 0)))::numeric, 2) st_belowupstrbarriers_slopeclass05_km,
  ROUND((COALESCE(a.st_slopeclass08_km, 0) - SUM(COALESCE(b.st_slopeclass08_km, 0)))::numeric, 2) st_belowupstrbarriers_slopeclass08_km,
  ROUND((COALESCE(a.st_slopeclass15_km, 0) - SUM(COALESCE(b.st_slopeclass15_km, 0)))::numeric, 2) st_belowupstrbarriers_slopeclass15_km,
  ROUND((COALESCE(a.st_slopeclass22_km, 0) - SUM(COALESCE(b.st_slopeclass22_km, 0)))::numeric, 2) st_belowupstrbarriers_slopeclass22_km,
  ROUND((COALESCE(a.st_slopeclass30_km, 0) - SUM(COALESCE(b.st_slopeclass30_km, 0)))::numeric, 2) st_belowupstrbarriers_slopeclass30_km,
  ROUND((COALESCE(a.wct_network_km, 0) - SUM(COALESCE(b.wct_network_km, 0)))::numeric, 2) wct_belowupstrbarriers_network_km,
  ROUND((COALESCE(a.wct_stream_km, 0) - SUM(COALESCE(b.wct_stream_km, 0)))::numeric, 2) wct_belowupstrbarriers_stream_km,
  ROUND((COALESCE(a.wct_lakereservoir_ha, 0) - SUM(COALESCE(b.wct_lakereservoir_ha, 0)))::numeric, 2) wct_belowupstrbarriers_lakereservoir_ha,
  ROUND((COALESCE(a.wct_wetland_ha, 0) - SUM(COALESCE(b.wct_wetland_ha, 0)))::numeric, 2) wct_belowupstrbarriers_wetland_ha,
  ROUND((COALESCE(a.wct_slopeclass03_km, 0) - SUM(COALESCE(b.wct_slopeclass03_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass03_km,
  ROUND((COALESCE(a.wct_slopeclass05_km, 0) - SUM(COALESCE(b.wct_slopeclass05_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass05_km,
  ROUND((COALESCE(a.wct_slopeclass08_km, 0) - SUM(COALESCE(b.wct_slopeclass08_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass08_km,
  ROUND((COALESCE(a.wct_slopeclass15_km, 0) - SUM(COALESCE(b.wct_slopeclass15_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass15_km,
  ROUND((COALESCE(a.wct_slopeclass22_km, 0) - SUM(COALESCE(b.wct_slopeclass22_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass22_km,
  ROUND((COALESCE(a.wct_slopeclass30_km, 0) - SUM(COALESCE(b.wct_slopeclass30_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass30_km,
  ROUND((COALESCE(a.ch_spawning_km, 0) - SUM(COALESCE(b.ch_spawning_km, 0)))::numeric, 2) ch_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.ch_rearing_km, 0) - SUM(COALESCE(b.ch_rearing_km, 0)))::numeric, 2) ch_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.co_spawning_km, 0) - SUM(COALESCE(b.co_spawning_km, 0)))::numeric, 2) co_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.co_rearing_km, 0) - SUM(COALESCE(b.co_rearing_km, 0)))::numeric, 2) co_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.co_rearing_ha, 0) - SUM(COALESCE(b.co_rearing_ha, 0)))::numeric, 2) co_rearing_belowupstrbarriers_ha,
  ROUND((COALESCE(a.sk_spawning_km, 0) - SUM(COALESCE(b.sk_spawning_km, 0)))::numeric, 2) sk_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.sk_rearing_km, 0) - SUM(COALESCE(b.sk_rearing_km, 0)))::numeric, 2) sk_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.sk_rearing_ha, 0) - SUM(COALESCE(b.sk_rearing_ha, 0)))::numeric, 2) sk_rearing_belowupstrbarriers_ha  ,
  ROUND((COALESCE(a.st_spawning_km, 0) - SUM(COALESCE(b.st_spawning_km, 0)))::numeric, 2) st_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.st_rearing_km, 0) - SUM(COALESCE(b.st_rearing_km, 0)))::numeric, 2) st_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.wct_spawning_km, 0) - SUM(COALESCE(b.wct_spawning_km, 0)))::numeric, 2) wct_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.wct_rearing_km, 0) - SUM(COALESCE(b.wct_rearing_km, 0)))::numeric, 2) wct_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.bt_spawning_km, 0) - SUM(COALESCE(b.bt_spawning_km, 0)))::numeric, 2) bt_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.bt_rearing_km, 0) - SUM(COALESCE(b.bt_rearing_km, 0)))::numeric, 2) bt_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.cm_spawning_km, 0) - SUM(COALESCE(b.cm_spawning_km, 0)))::numeric, 2) cm_spawning_belowupstrbarriers_km  ,
  
  ROUND((COALESCE(a.pk_spawning_km, 0) - SUM(COALESCE(b.pk_spawning_km, 0)))::numeric, 2) pk_spawning_belowupstrbarriers_km  ,
  
  ROUND((COALESCE(a.all_spawning_km, 0) - SUM(COALESCE(b.all_spawning_km, 0)))::numeric, 2) all_spawning_belowupstrbarriers_km,
  ROUND((COALESCE(a.all_rearing_km, 0) - SUM(COALESCE(b.all_rearing_km, 0)))::numeric, 2) all_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.all_spawningrearing_km, 0) - SUM(COALESCE(b.all_spawningrearing_km, 0)))::numeric, 2) all_spawningrearing_belowupstrbarriers_km
FROM bcfishpass.:point_table a
INNER JOIN bcfishpass.:barriers_table b
ON a.:point_id = b.:dnstr_barriers_id[1]
WHERE 
  a.watershed_group_code = :'wsg'
GROUP BY a.:point_id
)

UPDATE bcfishpass.:point_table p
SET
  total_belowupstrbarriers_network_km = r.total_belowupstrbarriers_network_km,
  total_belowupstrbarriers_stream_km = r.total_belowupstrbarriers_stream_km,
  total_belowupstrbarriers_lakereservoir_ha = r.total_belowupstrbarriers_lakereservoir_ha,
  total_belowupstrbarriers_wetland_ha = r.total_belowupstrbarriers_wetland_ha,
  total_belowupstrbarriers_slopeclass03_waterbodies_km = r.total_belowupstrbarriers_slopeclass03_waterbodies_km,
  total_belowupstrbarriers_slopeclass03_km = r.total_belowupstrbarriers_slopeclass03_km,
  total_belowupstrbarriers_slopeclass05_km = r.total_belowupstrbarriers_slopeclass05_km,
  total_belowupstrbarriers_slopeclass08_km = r.total_belowupstrbarriers_slopeclass08_km,
  total_belowupstrbarriers_slopeclass15_km = r.total_belowupstrbarriers_slopeclass15_km,
  total_belowupstrbarriers_slopeclass22_km = r.total_belowupstrbarriers_slopeclass22_km,
  total_belowupstrbarriers_slopeclass30_km = r.total_belowupstrbarriers_slopeclass30_km,
  ch_co_sk_belowupstrbarriers_network_km = r.ch_co_sk_belowupstrbarriers_network_km,
  ch_co_sk_belowupstrbarriers_stream_km = r.ch_co_sk_belowupstrbarriers_stream_km,
  ch_co_sk_belowupstrbarriers_lakereservoir_ha = r.ch_co_sk_belowupstrbarriers_lakereservoir_ha,
  ch_co_sk_belowupstrbarriers_wetland_ha = r.ch_co_sk_belowupstrbarriers_wetland_ha,
  ch_co_sk_belowupstrbarriers_slopeclass03_waterbodies_km = r.ch_co_sk_belowupstrbarriers_slopeclass03_waterbodies_km,
  ch_co_sk_belowupstrbarriers_slopeclass03_km = r.ch_co_sk_belowupstrbarriers_slopeclass03_km,
  ch_co_sk_belowupstrbarriers_slopeclass05_km = r.ch_co_sk_belowupstrbarriers_slopeclass05_km,
  ch_co_sk_belowupstrbarriers_slopeclass08_km = r.ch_co_sk_belowupstrbarriers_slopeclass08_km,
  ch_co_sk_belowupstrbarriers_slopeclass15_km = r.ch_co_sk_belowupstrbarriers_slopeclass15_km,
  ch_co_sk_belowupstrbarriers_slopeclass22_km = r.ch_co_sk_belowupstrbarriers_slopeclass22_km,
  ch_co_sk_belowupstrbarriers_slopeclass30_km = r.ch_co_sk_belowupstrbarriers_slopeclass30_km,

  st_belowupstrbarriers_network_km = r.st_belowupstrbarriers_network_km,
  st_belowupstrbarriers_stream_km = r.st_belowupstrbarriers_stream_km,
  st_belowupstrbarriers_lakereservoir_ha = r.st_belowupstrbarriers_lakereservoir_ha,
  st_belowupstrbarriers_wetland_ha = r.st_belowupstrbarriers_wetland_ha,
  st_belowupstrbarriers_slopeclass03_km = r.st_belowupstrbarriers_slopeclass03_km,
  st_belowupstrbarriers_slopeclass05_km = r.st_belowupstrbarriers_slopeclass05_km,
  st_belowupstrbarriers_slopeclass08_km = r.st_belowupstrbarriers_slopeclass08_km,
  st_belowupstrbarriers_slopeclass15_km = r.st_belowupstrbarriers_slopeclass15_km,
  st_belowupstrbarriers_slopeclass22_km = r.st_belowupstrbarriers_slopeclass22_km,
  st_belowupstrbarriers_slopeclass30_km = r.st_belowupstrbarriers_slopeclass30_km,

  wct_belowupstrbarriers_network_km = r.wct_belowupstrbarriers_network_km,
  wct_belowupstrbarriers_stream_km = r.wct_belowupstrbarriers_stream_km,
  wct_belowupstrbarriers_lakereservoir_ha = r.wct_belowupstrbarriers_lakereservoir_ha,
  wct_belowupstrbarriers_wetland_ha = r.wct_belowupstrbarriers_wetland_ha,
  wct_belowupstrbarriers_slopeclass03_km = r.wct_belowupstrbarriers_slopeclass03_km,
  wct_belowupstrbarriers_slopeclass05_km = r.wct_belowupstrbarriers_slopeclass05_km,
  wct_belowupstrbarriers_slopeclass08_km = r.wct_belowupstrbarriers_slopeclass08_km,
  wct_belowupstrbarriers_slopeclass15_km = r.wct_belowupstrbarriers_slopeclass15_km,
  wct_belowupstrbarriers_slopeclass22_km = r.wct_belowupstrbarriers_slopeclass22_km,
  wct_belowupstrbarriers_slopeclass30_km = r.wct_belowupstrbarriers_slopeclass30_km,

  ch_spawning_belowupstrbarriers_km = r.ch_spawning_belowupstrbarriers_km,
  ch_rearing_belowupstrbarriers_km = r.ch_rearing_belowupstrbarriers_km,
  co_spawning_belowupstrbarriers_km = r.co_spawning_belowupstrbarriers_km,
  co_rearing_belowupstrbarriers_km = r.co_rearing_belowupstrbarriers_km,
  sk_spawning_belowupstrbarriers_km = r.sk_spawning_belowupstrbarriers_km,
  sk_rearing_belowupstrbarriers_km = r.sk_rearing_belowupstrbarriers_km,
  st_spawning_belowupstrbarriers_km = r.st_spawning_belowupstrbarriers_km,
  st_rearing_belowupstrbarriers_km = r.st_rearing_belowupstrbarriers_km,
  wct_spawning_belowupstrbarriers_km = r.wct_spawning_belowupstrbarriers_km,
  wct_rearing_belowupstrbarriers_km = r.wct_rearing_belowupstrbarriers_km,
  bt_spawning_belowupstrbarriers_km = r.bt_spawning_belowupstrbarriers_km,
  bt_rearing_belowupstrbarriers_km = r.bt_rearing_belowupstrbarriers_km,
  pk_spawning_belowupstrbarriers_km = r.pk_spawning_belowupstrbarriers_km,  
  cm_spawning_belowupstrbarriers_km = r.cm_spawning_belowupstrbarriers_km,
  all_spawning_belowupstrbarriers_km = r.all_spawning_belowupstrbarriers_km,
  all_rearing_belowupstrbarriers_km = r.all_rearing_belowupstrbarriers_km,
  all_spawningrearing_belowupstrbarriers_km = r.all_spawningrearing_belowupstrbarriers_km
FROM report r
WHERE p.:point_id = r.:point_id
AND p.blue_line_key = p.watershed_key; -- do not update points in side channels

-- ELK River WCT specific reporting, but run it everywhere
UPDATE bcfishpass.:point_table p
SET wct_betweenbarriers_network_km = ROUND((p.wct_belowupstrbarriers_network_km + b.wct_belowupstrbarriers_network_km)::numeric, 2),
    wct_spawning_betweenbarriers_km = ROUND((p.wct_spawning_belowupstrbarriers_km + b.wct_spawning_belowupstrbarriers_km)::numeric, 2),
    wct_rearing_betweenbarriers_km = ROUND((p.wct_rearing_belowupstrbarriers_km + b.wct_rearing_belowupstrbarriers_km)::numeric, 2),
    wct_spawningrearing_betweenbarriers_km = ROUND((p.all_spawningrearing_belowupstrbarriers_km + b.all_spawningrearing_belowupstrbarriers_km)::numeric, 2)
FROM bcfishpass.:point_table b
WHERE 
  p.:dnstr_barriers_id[1] = b.:point_id AND 
  p.wct_network_km != 0 AND 
  p.watershed_group_code = :'wsg' AND 
  p.blue_line_key = p.watershed_key;

-- separate update for where there are no barriers downstream
UPDATE bcfishpass.:point_table
SET wct_betweenbarriers_network_km = wct_belowupstrbarriers_network_km,
    wct_spawning_betweenbarriers_km = wct_spawning_belowupstrbarriers_km,
    wct_rearing_betweenbarriers_km = wct_rearing_belowupstrbarriers_km,
    wct_spawningrearing_betweenbarriers_km = all_spawningrearing_belowupstrbarriers_km
WHERE 
  :dnstr_barriers_id IS NULL AND 
  wct_network_km != 0 AND 
  watershed_group_code = :'wsg' AND 
  blue_line_key = watershed_key;