DROP FUNCTION postgisftw.wcrp_barrier_severity(text,text);

CREATE FUNCTION postgisftw.wcrp_barrier_severity(watershed_group_code TEXT, barrier_type TEXT default 'ALL')
--watershed_group: watershed group codes from db e.g. HORS, BULK, etc.
--barrier_type: eg. DAM, RAIL, etc. or if you wish to choose all within watershed ... ALL
    RETURNS TABLE(
        watershed_group_cd TEXT,
        structure_type TEXT,
        n_assessed_barrier bigint,
        n_assess_total bigint,
        pct_assessed_barrier numeric
    )
    LANGUAGE 'plpgsql'
    IMMUTABLE PARALLEL SAFE 

AS $$

DECLARE
   v_wsg   text := watershed_group_code;
   v_feat  text := barrier_type;

BEGIN

IF (v_feat = 'ALL')

    then RETURN query

    WITH totals AS
    (
    SELECT
      c.watershed_group_code,
      c.crossing_feature_type,
    count(*) as n_total
    FROM bcfishpass.crossings c
    WHERE c.watershed_group_code IN ('BULK','LNIC','HORS','ELKR')
	AND c.watershed_group_code = v_wsg
    --AND crossing_feature_type = v_feat
    -- do not include flathead in ELKR
    AND c.wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree IS FALSE
    AND (c.stream_crossing_id IS NOT NULL OR c.dam_id IS NOT NULL)
    AND (c.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
        OR
        c.barriers_st_dnstr = array[]::text[]
        OR
        c.barriers_wct_dnstr = array[]::text[]
        )
    GROUP BY c.watershed_group_code, c.crossing_feature_type
    ORDER BY c.watershed_group_code, c.crossing_feature_type
    ),

    barrier_potential AS
    (
    SELECT
      c.watershed_group_code,
      c.crossing_feature_type,
      count(*) as n_barrier
    FROM bcfishpass.crossings c
    WHERE c.watershed_group_code IN ('BULK','LNIC','HORS','ELKR')
    AND c.watershed_group_code = v_wsg
    --AND crossing_feature_type = v_feat
    AND c.wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree IS FALSE
    AND (c.stream_crossing_id IS NOT NULL OR c.dam_id IS NOT NULL)
    AND c.barrier_status in ('BARRIER', 'POTENTIAL')
    AND (c.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
        OR
        c.barriers_st_dnstr = array[]::text[]
        OR
        c.barriers_wct_dnstr = array[]::text[]
        )
    GROUP BY c.watershed_group_code, c.crossing_feature_type
    )

    SELECT
    t.watershed_group_code,
    t.crossing_feature_type,
    COALESCE(b.n_barrier, 0) as n_assessed_barrier,
    t.n_total as n_assessed_total,
    ROUND((COALESCE(b.n_barrier, 0) * 100)::numeric / t.n_total, 1) AS pct_assessed_barrier
    FROM totals t
    LEFT OUTER JOIN barrier_potential b
    ON t.watershed_group_code = b.watershed_group_code
    AND t.crossing_feature_type = b.crossing_feature_type;


ELSE
    RETURN query

    -- Calculate "Barrier Severity" as
-- "the % of each barrier type that are barriers/potential barriers (out of those that have been assessed)"
-- (with further restriction that the barriers be on potentially accessible streams)

    WITH totals AS
    (
    SELECT
      c.watershed_group_code,
      c.crossing_feature_type,
      count(*) as n_total
    FROM bcfishpass.crossings c
    WHERE c.watershed_group_code IN ('BULK','LNIC','HORS','ELKR')
    AND c.watershed_group_code = v_wsg
    AND c.crossing_feature_type = v_feat
    -- do not include flathead in ELKR
    AND c.wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree IS FALSE
    AND (c.stream_crossing_id IS NOT NULL OR c.dam_id IS NOT NULL)
    AND (c.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
        OR
        c.barriers_st_dnstr = array[]::text[]
        OR
        c.barriers_wct_dnstr = array[]::text[]
        )
    GROUP BY c.watershed_group_code, c.crossing_feature_type
    ORDER BY c.watershed_group_code, c.crossing_feature_type
    ),

    barrier_potential AS
    (
    SELECT
      c.watershed_group_code,
      c.crossing_feature_type,
      count(*) as n_barrier
    FROM bcfishpass.crossings c
    WHERE c.watershed_group_code IN ('BULK','LNIC','HORS','ELKR')
    AND c.watershed_group_code = v_wsg
    AND c.crossing_feature_type = v_feat
    AND c.wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree IS FALSE
    AND (c.stream_crossing_id IS NOT NULL OR c.dam_id IS NOT NULL)
    AND c.barrier_status in ('BARRIER', 'POTENTIAL')
    AND (c.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
        OR
        c.barriers_st_dnstr = array[]::text[]
        OR
        c.barriers_wct_dnstr = array[]::text[]
        )
    GROUP BY c.watershed_group_code, c.crossing_feature_type
    )

    SELECT
    t.watershed_group_code,
    t.crossing_feature_type,
    COALESCE(b.n_barrier, 0) as n_assessed_barrier,
    t.n_total as n_assessed_total,
    ROUND((COALESCE(b.n_barrier, 0) * 100)::numeric / t.n_total, 1) AS pct_assessed_barrier
    FROM totals t
    LEFT OUTER JOIN barrier_potential b
    ON t.watershed_group_code = b.watershed_group_code
    AND t.crossing_feature_type = b.crossing_feature_type;

END IF;

END


$$;

COMMENT ON FUNCTION postgisftw.wcrp_barrier_severity IS
'Provided is a watershed name and a crossing feature type according to the structure of bcbarriers.
The output is a percentage of the sum of the crossing feature within the watershed relative to the
sum of all crossing feature types in the watershed. ';

REVOKE EXECUTE ON FUNCTION postgisftw.wcrp_barrier_severity FROM public;
