-- create table for ranked list

CREATE FUNCTION bcfishpass.create_rank_table(schema_name text, wcrp text)
    RETURNS VOID
    LANGUAGE plpgsql AS
$func$
BEGIN

    EXECUTE format('
        CREATE TABLE IS NOT EXISTS %I.%I
        (
            aggregated_crossings_id text,
            crossing_source text,
            crossing_feature_type text,
            pscis_status text,
            crossing_type_code text,
            barrier_status text,
            pscis_road_name text,
            pscis_assessment_comment text,
            pscis_assessment_date date,
            utm_zone integer,
            utm_easting integer,
            utm_northing integer,
            blue_line_key integer,
            watershed_group_code integer,
            gnis_stream_name text,
            barriers_anthropogenic_dnstr text,
            barriers_anthropogenic_habitat_wcrp_upstr text,
            barriers_anthropogenic_habitat_wcrp_upstr_count integer,
            all_spawning_km double precision,
            all_spawning_belowupstrbarriers_km double precision,
            all_rearing_km double precision,
            all_rearing_belowupstrbarriers_km double precision,
            all_spawningrearing_km double precision,
            all_spawningrearing_belowupstrbarriers_km double precision,
            set_id numeric,
            total_hab_gain_set numeric,
            num_barriers_set integer,
            avg_gain_per_barrier numeric,
            dnstr_set_ids character varying[],
            rank_avg_gain_per_barrier numeric,
            rank_avg_gain_tiered numeric,
            tier_combined character varying,
            geom geometry
        )',
        schema_name,
        'ranked_barriers_' || wcrp
    );

END
$func$