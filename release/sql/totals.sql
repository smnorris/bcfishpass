with totals as (
  select
    watershed_group_code,  
    COALESCE(ROUND((SUM(ST_Length(s.geom)::numeric) / 1000), 2), 0) AS total_network_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_ch_co_sk IS NOT NULL) / 1000)::numeric), 2), 0) AS ch_co_sk_network_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_st IS NOT NULL) / 1000)::numeric), 2), 0) AS st_network_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_wct IS NOT NULL) / 1000)::numeric), 2), 0) AS wct_network_km,
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
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_spawning_cm IS TRUE) / 1000))::numeric, 2), 0) AS cm_spawning_km ,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_spawning_pk IS TRUE) / 1000))::numeric, 2), 0) AS pk_spawning_km ,
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
                                                          s.model_rearing_wct IS TRUE
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
                                                          s.model_rearing_wct IS TRUE 
                                                    ) / 1000))::numeric, 2), 0) AS all_spawningrearing_km
  from bcfishpass.streams s
  group by watershed_group_code
)

insert into bcfishpass.totals
select
  date_trunc('minute', now()) as date_processed,
  *
from totals order by watershed_group_code;