SELECT
    watershed_group_code,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]) / 1000)::numeric), 2), 0) AS potentially_accessible_ch_cm_co_pk_sk,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and s.barriers_anthropogenic_dnstr is null) / 1000)::numeric), 2), 0) AS accessible_ch_cm_co_pk_sk,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and s.barriers_anthropogenic_dnstr is not null and s.barriers_pscis_dnstr is null) / 1000)::numeric), 2), 0) AS potentially_inaccessible_ch_cm_co_pk_sk,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and s.barriers_pscis_dnstr is not null) / 1000)::numeric), 2), 0) AS confirmed_inaccessible_ch_cm_co_pk_sk
FROM bcfishpass.streams s
GROUP BY watershed_group_code
ORDER BY watershed_group_code;