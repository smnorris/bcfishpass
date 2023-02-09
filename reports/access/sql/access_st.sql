SELECT
    watershed_group_code,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_st_dnstr = array[]::text[] and s.barriers_anthropogenic_dnstr is null) / 1000)::numeric), 2), 0) AS accessible_st,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_st_dnstr = array[]::text[] and s.barriers_anthropogenic_dnstr is not null and s.barriers_pscis_dnstr is null) / 1000)::numeric), 2), 0) AS potentially_accessible_st,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_st_dnstr = array[]::text[] and s.barriers_pscis_dnstr is not null) / 1000)::numeric), 2), 0) AS pscisbarrier_st
FROM bcfishpass.streams s
GROUP BY watershed_group_code
ORDER BY watershed_group_code;