SELECT
    watershed_group_code,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) / 1000)::numeric), 2), 0) AS streamnetwork_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]) / 1000)::numeric), 2), 0) AS pa_total_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and s.barriers_anthropogenic_dnstr is null) / 1000)::numeric), 2), 0) AS pa_nobarrier_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and s.barriers_anthropogenic_dnstr is not null and s.barriers_pscis_dnstr is null) / 1000)::numeric), 2), 0) AS pa_potentialbarrier_km,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and s.barriers_pscis_dnstr is not null) / 1000)::numeric), 2), 0) AS pa_knownbarrier_km
FROM bcfishpass.streams s
GROUP BY watershed_group_code
ORDER BY watershed_group_code;