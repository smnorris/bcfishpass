SELECT
    watershed_group_code,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_wct = 'ACCESSIBLE') / 1000)::numeric), 2), 0) AS accessible_wct,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_wct = 'POTENTIALLY ACCESSIBLE') / 1000)::numeric), 2), 0) AS potentially_accessible_wct,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_wct = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM') / 1000)::numeric), 2), 0) AS pscisbarrier_wct,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.access_model_wct LIKE 'ACCESSIBLE - REMEDIATED') / 1000)::numeric), 2), 0) AS remediated_wct
FROM bcfishpass.streams s
GROUP BY watershed_group_code;