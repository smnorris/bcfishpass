select
  watershed_group_code,
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

-- salmon model
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_ch_co_sk LIKE '%ACCESSIBLE%') / 1000)::numeric), 2), 0) AS ch_co_sk_network_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_ch_co_sk LIKE '%ACCESSIBLE%' AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS ch_co_sk_stream_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.model_access_ch_co_sk LIKE '%ACCESSIBLE%') AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS ch_co_sk_slopeclass03_waterbodies_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.model_access_ch_co_sk LIKE '%ACCESSIBLE%') AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS ch_co_sk_slopeclass03_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_ch_co_sk LIKE '%ACCESSIBLE%' AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as ch_co_sk_slopeclass05_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_ch_co_sk LIKE '%ACCESSIBLE%' AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as ch_co_sk_slopeclass08_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_ch_co_sk LIKE '%ACCESSIBLE%' AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as ch_co_sk_slopeclass15_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_ch_co_sk LIKE '%ACCESSIBLE%' AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as ch_co_sk_slopeclass22_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_ch_co_sk LIKE '%ACCESSIBLE%' AND (s.gradient >= .22 AND s.gradient < .3)) / 1000))::numeric, 2), 0) as ch_co_sk_slopeclass30_km,

-- steelhead
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_st LIKE '%ACCESSIBLE%') / 1000)::numeric), 2), 0) AS st_network_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_st LIKE '%ACCESSIBLE%' AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS st_stream_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.model_access_st LIKE '%ACCESSIBLE%') AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS st_slopeclass03_waterbodies_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.model_access_st LIKE '%ACCESSIBLE%') AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS st_slopeclass03_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_st LIKE '%ACCESSIBLE%' AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as st_slopeclass05_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_st LIKE '%ACCESSIBLE%' AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as st_slopeclass08_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_st LIKE '%ACCESSIBLE%' AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as st_slopeclass15_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_st LIKE '%ACCESSIBLE%' AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as st_slopeclass22_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_st LIKE '%ACCESSIBLE%' AND (s.gradient >= .22 AND s.gradient < .30)) / 1000))::numeric, 2), 0) as st_slopeclass30_km,

-- wct
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_wct LIKE '%ACCESSIBLE%') / 1000)::numeric), 2), 0) AS wct_network_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_wct LIKE '%ACCESSIBLE%' AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS wct_stream_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.model_access_wct LIKE '%ACCESSIBLE%') AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS wct_slopeclass03_waterbodies_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.model_access_wct LIKE '%ACCESSIBLE%') AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS wct_slopeclass03_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as wct_slopeclass05_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as wct_slopeclass08_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as wct_slopeclass15_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as wct_slopeclass22_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .22 AND s.gradient < .30)) / 1000))::numeric, 2), 0) as wct_slopeclass30_km,


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
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_rearing_cm IS TRUE) / 1000))::numeric, 2), 0) AS cm_spawning_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_rearing_cm IS TRUE) / 1000))::numeric, 2), 0) AS cm_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_rearing_pk IS TRUE) / 1000))::numeric, 2), 0) AS pk_spawning_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_rearing_pk IS TRUE) / 1000))::numeric, 2), 0) AS pk_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_spawning_ch IS TRUE OR
                                                        s.model_spawning_co IS TRUE OR
                                                        s.model_spawning_sk IS TRUE OR
                                                        s.model_spawning_st IS TRUE OR
                                                        s.model_spawning_wct IS TRUE OR
                                                        s.model_spawning_cm IS TRUE OR
                                                        s.model_spawning_pk IS TRUE 
                                                  ) / 1000))::numeric, 2), 0)  AS all_spawning_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_rearing_ch IS TRUE OR
                                                        s.model_rearing_co IS TRUE OR
                                                        s.model_rearing_sk IS TRUE OR
                                                        s.model_rearing_st IS TRUE OR
                                                        s.model_rearing_wct IS TRUE OR
                                                        s.model_rearing_cm IS TRUE OR
                                                        s.model_rearing_pk IS TRUE
                                                  ) / 1000))::numeric, 2), 0) AS all_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_spawning_ch IS TRUE OR
                                                        s.model_spawning_co IS TRUE OR
                                                        s.model_spawning_sk IS TRUE OR
                                                        s.model_spawning_st IS TRUE OR
                                                        s.model_spawning_wct IS TRUE OR
                                                        s.model_spawning_cm IS TRUE OR
                                                        s.model_spawning_pk IS TRUE OR
                                                        s.model_rearing_ch IS TRUE OR
                                                        s.model_rearing_co IS TRUE OR
                                                        s.model_rearing_sk IS TRUE OR
                                                        s.model_rearing_st IS TRUE OR
                                                        s.model_rearing_wct IS TRUE OR
                                                        s.model_rearing_cm IS TRUE OR
                                                        s.model_rearing_pk is TRUE
                                                  ) / 1000))::numeric, 2), 0) AS all_spawningrearing_km
from bcfishpass.streams s
left outer join whse_basemapping.fwa_waterbodies wb on s.waterbody_key = wb.waterbody_key
group by watershed_group_code;
