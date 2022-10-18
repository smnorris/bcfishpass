SELECT
    watershed_group_code,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_st = 'ACCESSIBLE') / 1000)::numeric), 2), 0) AS accessible_st,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_st = 'POTENTIALLY ACCESSIBLE') / 1000)::numeric), 2), 0) AS potentially_accessible_st,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_st = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM') / 1000)::numeric), 2), 0) AS pscisbarrier_st,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.model_access_st LIKE 'ACCESSIBLE - REMEDIATED') / 1000)::numeric), 2), 0) AS remediated_st
FROM bcfishpass.streams s
GROUP BY watershed_group_code
ORDER BY watershed_group_code;