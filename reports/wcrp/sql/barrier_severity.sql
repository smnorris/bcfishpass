DROP FUNCTION bcfishpass.barrier_severity(text,text);

CREATE FUNCTION bcfishpass.barrier_severity(watershed_group TEXT, barrier_type TEXT)
--watershed_group: watershed group codes from db e.g. HORS, BULK, etc.
--barrier_type: eg. DAM, RAIL, etc. or if you wish to choose all within watershed ... ALL
    RETURNS TABLE(
        watershed TEXT,
        structure_type TEXT,
        n_assessed_barrier bigint,
        n_assess_total bigint,
        pct_assessed_barrier numeric
    )
    LANGUAGE 'plpgsql'
    IMMUTABLE PARALLEL SAFE 

AS $$

DECLARE
   v_water   text := watershed_group;
   v_feat  text := barrier_type;

BEGIN

IF (v_feat = 'ALL')

    then RETURN query

    WITH totals AS
    (
    SELECT
    watershed_group_code,
    crossing_feature_type,
    count(*) as n_total
    FROM bcfishpass.crossings
    WHERE watershed_group_code IN ('BULK','LNIC','HORS','ELKR')
	AND watershed_group_code = v_water
    --AND crossing_feature_type = v_feat
    -- do not include flathead in ELKR
    AND wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree IS FALSE
    AND (stream_crossing_id IS NOT NULL OR dam_id IS NOT NULL)
    AND (access_model_ch_co_sk IS NOT NULL
        OR
        access_model_st IS NOT NULL
        OR
        access_model_wct IS NOT NULL
        )
    GROUP BY watershed_group_code, crossing_feature_type
    ORDER BY watershed_group_code, crossing_feature_type
    ),

    barrier_potential AS
    (
    SELECT
    watershed_group_code,
    crossing_feature_type,
    count(*) as n_barrier
    FROM bcfishpass.crossings
    WHERE watershed_group_code IN ('BULK','LNIC','HORS','ELKR')
    AND watershed_group_code = v_water
    --AND crossing_feature_type = v_feat
    AND wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree IS FALSE
    AND (stream_crossing_id IS NOT NULL OR dam_id IS NOT NULL)
    AND barrier_status in ('BARRIER', 'POTENTIAL')
    AND (access_model_ch_co_sk IS NOT NULL
        OR
        access_model_st IS NOT NULL
        OR
        access_model_wct IS NOT NULL
        )
    GROUP BY watershed_group_code, crossing_feature_type
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
    watershed_group_code,
    crossing_feature_type,
    count(*) as n_total
    FROM bcfishpass.crossings
    WHERE watershed_group_code IN ('BULK','LNIC','HORS','ELKR')
	AND watershed_group_code = v_water
    AND crossing_feature_type = v_feat
    -- do not include flathead in ELKR
    AND wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree IS FALSE
    AND (stream_crossing_id IS NOT NULL OR dam_id IS NOT NULL)
    AND (access_model_ch_co_sk IS NOT NULL
        OR
        access_model_st IS NOT NULL
        OR
        access_model_wct IS NOT NULL
        )
    GROUP BY watershed_group_code, crossing_feature_type
    ORDER BY watershed_group_code, crossing_feature_type
    ),

    barrier_potential AS
    (
    SELECT
    watershed_group_code,
    crossing_feature_type,
    count(*) as n_barrier
    FROM bcfishpass.crossings
    WHERE watershed_group_code IN ('BULK','LNIC','HORS','ELKR')
    AND watershed_group_code = v_water
    AND crossing_feature_type = v_feat
    AND wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree IS FALSE
    AND (stream_crossing_id IS NOT NULL OR dam_id IS NOT NULL)
    AND barrier_status in ('BARRIER', 'POTENTIAL')
    AND (access_model_ch_co_sk IS NOT NULL
        OR
        access_model_st IS NOT NULL
        OR
        access_model_wct IS NOT NULL
        )
    GROUP BY watershed_group_code, crossing_feature_type
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

ALTER FUNCTION bcfishpass.barrier_severity(text,text)
    OWNER TO tomasm;

COMMENT ON FUNCTION bcfishpass.barrier_severity IS 
'Provided is a watershed name and a crossing feature type according to the structure of bcbarriers.
The output is a percentage of the sum of the crossing feature within the watershed relative to the
sum of all crossing feature types in the watershed. ';
