SELECT
    watershed_group_code,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_ch_co_sk = 'ACCESSIBLE') / 1000)::numeric), 2), 0) AS accessible_ch_co_sk,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_ch_co_sk = 'POTENTIALLY ACCESSIBLE') / 1000)::numeric), 2), 0) AS potentially_accessible_ch_co_sk,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_ch_co_sk = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM') / 1000)::numeric), 2), 0) AS pscisbarrier_ch_co_sk,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_ch_co_sk LIKE 'ACCESSIBLE - REMEDIATED') / 1000)::numeric), 2), 0) AS remediated_co_ch_sk
FROM bcfishpass.streams s
GROUP BY watershed_group_code
ORDER BY watershed_group_code;

