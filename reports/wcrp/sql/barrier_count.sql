DROP FUNCTION bcfishpass.barrier_count(text,text);

CREATE FUNCTION bcfishpass.barrier_count(watershed_group TEXT, barrier_type TEXT)
--watershed_group: watershed group codes from db e.g. HORS, BULK, etc.
--barrier_type: eg. DAM, RAIL, etc. or if you wish to choose all within watershed ... ALL
    RETURNS TABLE(
        watershed TEXT,
        structure_type TEXT,
        n_passable bigint,
        n_barrier bigint,
        n_potential bigint,
        n_unknown bigint
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

    with barriers as (
        SELECT
            watershed_group_code,
            crossing_feature_type,
            barrier_status,
            count(*) as n_total
        FROM bcfishpass.crossings
        WHERE watershed_group_code IN ('BULK','LNIC','HORS','ELKR')
        -- do not include flathead in ELKR
        AND wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree IS FALSE
        AND (aggregated_crossings_id IS NOT NULL OR dam_id IS NOT NULL)
        AND (access_model_ch_co_sk IS NOT NULL
            OR
            access_model_st IS NOT NULL
            OR
            access_model_wct IS NOT NULL
            )
        AND all_spawningrearing_km > 0
        GROUP BY watershed_group_code, crossing_feature_type, barrier_status
        ORDER BY watershed_group_code, crossing_feature_type
        ),

        divided as (
                    SELECT 
                        watershed_group_code,
                        crossing_feature_type,
                        max(case when barrier_status = 'PASSABLE' then n_total else 0 end) as n_passable,
                        max(case when barrier_status = 'BARRIER' then n_total else 0 end) as n_barrier,
                        max(case when barrier_status = 'POTENTIAL' then n_total else 0 end) as n_potential,
                        max(case when barrier_status = 'UNKNOWN' then n_total else 0 end) as n_unknown
                    FROM barriers
                    WHERE watershed_group_code = v_water
                    --AND crossing_feature_type = v_feat
                    GROUP BY watershed_group_code, crossing_feature_type
                )


        SELECT 
            watershed_group_code,
            crossing_feature_type,
            n_passable,
            n_barrier,
            n_potential,
            n_unknown
        FROM divided;


ELSE
    RETURN query

    with barriers as (
        SELECT
            watershed_group_code,
            crossing_feature_type,
            barrier_status,
            count(*) as n_total
        FROM bcfishpass.crossings
        WHERE watershed_group_code IN ('BULK','LNIC','HORS','ELKR')
        -- do not include flathead in ELKR
        AND wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree IS FALSE
        AND (aggregated_crossings_id IS NOT NULL OR dam_id IS NOT NULL)
        AND (access_model_ch_co_sk IS NOT NULL
            OR
            access_model_st IS NOT NULL
            OR
            access_model_wct IS NOT NULL
            )
        AND all_spawningrearing_km > 0
        GROUP BY watershed_group_code, crossing_feature_type, barrier_status
        ORDER BY watershed_group_code, crossing_feature_type
        ),

        divided as (
                    SELECT 
                        watershed_group_code,
                        crossing_feature_type,
                        max(case when barrier_status = 'PASSABLE' then n_total else 0 end) as n_passable,
                        max(case when barrier_status = 'BARRIER' then n_total else 0 end) as n_barrier,
                        max(case when barrier_status = 'POTENTIAL' then n_total else 0 end) as n_potential,
                        max(case when barrier_status = 'UNKNOWN' then n_total else 0 end) as n_unknown
                    FROM barriers
                    WHERE watershed_group_code = v_water
                    AND crossing_feature_type = v_feat
                    GROUP BY watershed_group_code, crossing_feature_type
                )


        SELECT 
            watershed_group_code,
            crossing_feature_type,
            n_passable,
            n_barrier,
            n_potential,
            n_unknown
        FROM divided;

END IF;

END


$$;

ALTER FUNCTION bcfishpass.barrier_count(text,text)
    OWNER TO tomasm;

COMMENT ON FUNCTION bcfishpass.barrier_count IS 
'Provided is a watershed name and a crossing feature type according to the structure of bcbarriers.
The output is a percentage of the sum of the crossing feature within the watershed relative to the
sum of all crossing feature types in the watershed. ';