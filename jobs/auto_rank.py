"""
@date: June 2024
@author: Andrew Pozzuoli

This python script generates sets for barriers in a wcrp
and ranks them by a combination of immediate and longterm gain.
This populates the wcrp_ranked_barriers table with whichever wcrp is specified.
"""

import os
import argparse
import psycopg2 as pg2
from urllib.parse import urlparse

import sys


def makeParser():
    p = argparse.ArgumentParser(description="Rank barriers in a WCRP")
    p.add_argument(
        "wcrp",
        nargs='*',
        type=str,
        help="WCRP that will be processed. Can be any in list form but, default is set to all."
    )
    return p


def buildCondition(wcrp):
    """
    Builds the where clause to pass into the
    query as the condition

    :wcrp: the wcrp that is having its barriers ranked
    """

    if wcrp == "eagle":
        condition = """
            --Eagle River
            FWA_Upstream(
            356364536,
            2901,
            2901,
            '100.190442.999098.995997.725308'::ltree,
            '100.190442.999098.995997.725308'::ltree,
            c.blue_line_key,
            c.downstream_route_measure,
            c.wscode_ltree,
            c.localcode_ltree
            )
            """
        wcrp_schema = "tho_shu"
    elif wcrp == "bessette":
        condition = """
            -- Bessette Creek
            FWA_Upstream(
            356349528,
            0,
            0,
            '100.190442.999098.995997.730848.543292'::ltree,
            '100.190442.999098.995997.730848.543292'::ltree,
            c.blue_line_key,
            c.downstream_route_measure,
            c.wscode_ltree,
            c.localcode_ltree
            )
            """
        wcrp_schema = "tho_shu"
    elif wcrp == "bela_atna_necl":
        condition = """
            (c."watershed_group_code" IN ('BELA','ATNA')
                OR
                FWA_Upstream( -- Subset of NECL watershed  
                360884575, 
                63,
                63, 
                '910.275583.004276'::ltree, 
                '910.275583.004276'::ltree,
                c.blue_line_key, 
                c.downstream_route_measure, 
                c.wscode_ltree, 
                c.localcode_ltree
                )
                OR
                FWA_Upstream( -- Subset of NECL watershed  
                360215254, 
                58,
                58, 
                '910.275583.004276'::ltree, 
                '910.275583.004276.020918'::ltree,
                c.blue_line_key, 
                c.downstream_route_measure, 
                c.wscode_ltree, 
                c.localcode_ltree
                )
            )
            """
        wcrp_schema = wcrp
    # elif wcrp == "elkr":
    #     condition = """
    #         c."watershed_group_code" IN ('ELKR')
    #         -- do not include flathead in ELKR
    #         and c.wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree is false
    #         """
    #     wcrp_schema = wcrp
    elif wcrp == "elkr_upstr":
        condition = """
            c."watershed_group_code" IN ('ELKR')
            AND 
            FWA_Upstream(
                356570562, 
                22910, 
                22910, 
                '300.625474.584724'::ltree, 
                '300.625474.584724.100997'::ltree, 
                c.blue_line_key, 
                c.downstream_route_measure, 
                c.wscode_ltree, 
                c.localcode_ltree
            ) -- only above Elko Dam
        """
        wcrp_schema = "elkr"
    elif wcrp == "elkr_dnstr":
        condition = """
            c."watershed_group_code" IN ('ELKR')
            AND
            wscode_ltree <@ '300.625474.584724'::ltree  -- on the elk system and not above elko dam
            AND 
            NOT FWA_Upstream(
                356570562, 
                22910, 
                22910, 
                '300.625474.584724'::ltree, 
                '300.625474.584724.100997'::ltree, 
                c.blue_line_key, 
                c.downstream_route_measure, 
                c.wscode_ltree, 
                c.localcode_ltree
            )
        """
        wcrp_schema = "elkr"
    elif wcrp == "bowr_ques_carr":
        condition = """
            c."watershed_group_code" IN ('BOWR', 'QUES', 'CARR', 'COTR')
            """
        wcrp_schema = "bowr_ques_carr"
    elif wcrp == "tuzistol_tah":
        condition = """
            c."watershed_group_code" IN ('TAKL', 'MIDR', 'UTRE', 'LTRE', 'STUL', 'STUR','CHUK','DRIR','FINA','FIRE','INGR','LOMI','MESO','MSKE',
'NATR','PARA','SUST','TOOD','UOMI','USKE')
        """
        wcrp_schema = "tuzistol_tah"

    elif wcrp == "ulkatcho":
        condition = """
            c."watershed_group_code" IN ('UDEN', 'LDEN')
            """
        wcrp_schema = "ulkatcho"
    else:
        # In all other cases, just the watershed group code
        condition = f"""
            c."watershed_group_code" IN ('{wcrp.upper()}')
            """
        if wcrp == 'bonp':
            wcrp_schema = 'tho_shu'
        else:
            wcrp_schema = wcrp
    
    return condition, wcrp_schema


def runQuery(condition, wcrp, wcrp_schema, conn):
    """
    Runs the set of queries to rank barriers

    :condition: where clause for the wcrp
    """

    with conn.cursor() as cursor:

        q_make_table = f"""
            DROP TABLE IF EXISTS bcfishpass.ranked_barriers;

            select 
            cv.aggregated_crossings_id
            ,cv.crossing_source
            ,cv.crossing_feature_type
            ,cv.pscis_status
            ,cv.crossing_type_code
            ,cv.crossing_subtype_code
            ,cv.barrier_status
            ,cv.pscis_road_name
            ,cv.pscis_stream_name
            ,cv.pscis_assessment_comment
            ,cv.pscis_assessment_date
            ,cv.utm_zone
            ,cv.utm_easting
            ,cv.utm_northing
            ,cv.blue_line_key
            ,cv.watershed_group_code
            ,cv.gnis_stream_name
            ,cv.barriers_anthropogenic_dnstr
            ,cv.barriers_anthropogenic_dnstr_count
            ,cv.barriers_anthropogenic_habitat_wcrp_upstr
            ,case 
				when cv.barriers_anthropogenic_habitat_wcrp_upstr_count IS NULL THEN 0
				else cv.barriers_anthropogenic_habitat_wcrp_upstr_count
			end
            ,cv.all_spawning_km
            ,cv.all_spawning_belowupstrbarriers_km
            ,cv.all_rearing_km
            ,cv.all_rearing_belowupstrbarriers_km
            ,abs(cv.all_spawningrearing_km) as all_spawningrearing_km
            ,abs(cv.all_spawningrearing_belowupstrbarriers_km) as all_spawningrearing_belowupstrbarriers_km
            ,cv.geom
            into bcfishpass.ranked_barriers
            from bcfishpass.crossings_wcrp_vw cv
            join bcfishpass.crossings c 
                on c.aggregated_crossings_id = cv.aggregated_crossings_id
            left join wcrp_{wcrp_schema}.combined_tracking_table_{wcrp_schema} tt
		        on tt.barrier_id = cv.aggregated_crossings_id
            where (cv.barrier_status != 'PASSABLE'
            AND cv.all_spawningrearing_belowupstrbarriers_km  IS NOT NULL
            AND cv.all_spawningrearing_km  != 0
            AND NOT (cv.crossing_subtype_code IS NOT NULL AND cv.crossing_subtype_code = 'FORD' AND cv.barrier_status NOT IN ('BARRIER', 'POTENTIAL'))
            AND (tt.structure_list_status not in ('Excluded structure')
		        OR tt.structure_list_status is null)
            AND {condition})
            OR (tt.structure_list_status = 'Rehabilitated barrier' AND cv.barrier_status = 'PASSABLE'
            AND cv.all_spawningrearing_belowupstrbarriers_km  IS NOT NULL
            AND cv.all_spawningrearing_km  != 0
            AND NOT (cv.crossing_subtype_code IS NOT NULL AND cv.crossing_subtype_code = 'FORD' AND cv.barrier_status NOT IN ('BARRIER', 'POTENTIAL'))
            AND (tt.structure_list_status not in ('Excluded structure')
		        OR tt.structure_list_status is null)
            AND {condition});

            ALTER TABLE IF EXISTS bcfishpass.ranked_barriers
                RENAME COLUMN aggregated_crossings_id TO id;
            ALTER TABLE IF EXISTS bcfishpass.ranked_barriers
                ADD COLUMN set_id numeric;
            ALTER TABLE IF EXISTS bcfishpass.ranked_barriers
                ALTER COLUMN id SET NOT NULL;
            ALTER TABLE IF EXISTS bcfishpass.ranked_barriers
                ADD PRIMARY KEY (id);

            """
        cursor.execute(q_make_table)
        
        q_group_barriers = f"""
            -- Index for speeding up queries
            DROP INDEX IF EXISTS rank_idx;
            DROP INDEX IF EXISTS rank_idx_set_id;
            DROP INDEX IF EXISTS rank_idx_id;	
                
            CREATE INDEX rank_idx ON bcfishpass.ranked_barriers (blue_line_key);
            CREATE INDEX rank_idx_set_id ON bcfishpass.ranked_barriers (set_id);
            CREATE INDEX rank_idx_id ON bcfishpass.ranked_barriers (id);


            -- Group all barriers by blue line key
            WITH mainstems AS (
                SELECT DISTINCT blue_line_key, row_number() OVER () AS set_id
                FROM bcfishpass.ranked_barriers
            )
            UPDATE bcfishpass.ranked_barriers a SET set_id = m.set_id FROM mainstems m WHERE m.blue_line_key = a.blue_line_key;
                
            -- Loop to find set that yields maximum average habitat gain per barrier
            -- Find average gain for just barrier 1, then 1+2, then 1+2+3, etc. Whichever gives the most average gain becomes a set.
            -- For example, if 1+2 become a set then the iteration continues starting at 3.
            DO $$
            DECLARE
                continue_loop BOOLEAN := TRUE;
                i INT := 1;
                grp_offset INT := (SELECT COUNT(*)*10 FROM bcfishpass.ranked_barriers); -- Assign set ids and add this large number. The loop will contiue until all barriers have been assigned a set id higher than this offset
            BEGIN
                WHILE continue_loop LOOP
                    
                    i := i + 1;
                
                    perform id, set_id
                    from bcfishpass.ranked_barriers
                    where set_id < grp_offset
                    LIMIT 1;

                    IF NOT FOUND THEN
                        continue_loop := FALSE;
                    ELSE
                        with avgVals as ( -- Cumulative average gain per barrier for ungrouped barriers with the same blue line key 
                            select id, blue_line_key, set_id, barriers_anthropogenic_habitat_wcrp_upstr_count, all_spawningrearing_belowupstrbarriers_km 
                                ,AVG(all_spawningrearing_belowupstrbarriers_km ) OVER(PARTITION BY set_id ORDER BY barriers_anthropogenic_habitat_wcrp_upstr_count DESC) as average
                                ,ROW_NUMBER() OVER(PARTITION BY set_id ORDER BY barriers_anthropogenic_habitat_wcrp_upstr_count DESC) as row_num
                            from bcfishpass.ranked_barriers
                            where set_id < grp_offset
                        ),
                        max_grp_gain as ( -- get max gain per barrier from cumulative averages
                            select 
                                set_id
                                ,max(average) as best_gain
                            from avgVals
                            group by set_id
                        ),
                        part as ( -- Partition point in avgVals such that all barriers up to that point should be grouped
                            select mx.*, av.row_num 
                            from max_grp_gain mx
                            join avgVals av on mx.best_gain = av.average
                        ),
                        new_grps as ( -- Assign set ids to barriers that should be grouped
                            select distinct av.id
                                ,CASE 
                                    WHEN av.row_num <= part.row_num THEN (av.set_id*grp_offset) + i
                                    ELSE av.set_id
                                END as new_set_id
                            from avgVals av
                            join part on av.set_id = part.set_id
                        )
                        -- Update barrier set ids based on new_grps
                        update bcfishpass.ranked_barriers
                        set set_id = new_grps.new_set_id
                        from new_grps
                        where bcfishpass.ranked_barriers.id = new_grps.id
                        AND new_grps.new_set_id > grp_offset;

                    END IF;
                END LOOP;
            END $$;
            """

        cursor.execute(q_group_barriers)

        q_calc_group_gains = """ 
            ----------------- CALCULATE GROUP GAINS -------------------------	
                
            alter table bcfishpass.ranked_barriers add column total_hab_gain_set numeric;
            alter table bcfishpass.ranked_barriers add column num_barriers_set integer;
            alter table bcfishpass.ranked_barriers add column avg_gain_per_barrier numeric;

            with temp as (
                SELECT sum(all_spawningrearing_belowupstrbarriers_km ) AS sum, set_id
                from bcfishpass.ranked_barriers
                group by set_id
            )

            update bcfishpass.ranked_barriers a SET total_hab_gain_set = t.sum FROM temp t WHERE t.set_id = a.set_id;
            update bcfishpass.ranked_barriers SET total_hab_gain_set = all_spawningrearing_belowupstrbarriers_km  WHERE set_id IS NULL;

            with temp as (
                SELECT count(*) AS cnt, set_id
                from bcfishpass.ranked_barriers
                group by set_id
            )


            update bcfishpass.ranked_barriers a SET num_barriers_set = t.cnt FROM temp t WHERE t.set_id = a.set_id;
            update bcfishpass.ranked_barriers SET num_barriers_set = 1 WHERE set_id IS NULL;

            update bcfishpass.ranked_barriers SET avg_gain_per_barrier = total_hab_gain_set / num_barriers_set;
            """
        cursor.execute(q_calc_group_gains)

        q_downstr_sets = """
            ---------------GET DOWNSTREAM GROUP IDs----------------------------

            ALTER TABLE bcfishpass.ranked_barriers ADD dnstr_set_ids varchar[];

            WITH downstr_barriers AS (
                SELECT rb.id, rb.set_id
                    ,UNNEST(string_to_array(barriers_anthropogenic_dnstr, ';')) AS barriers_anthropogenic_dnstr
                FROM bcfishpass.ranked_barriers rb
            ),
            downstr_group AS (
                SELECT db_.id, db_.set_id as current_group, db_.barriers_anthropogenic_dnstr
                    ,rb.set_id
                FROM downstr_barriers AS db_
                JOIN bcfishpass.ranked_barriers rb
                    ON rb.id = db_.barriers_anthropogenic_dnstr
                WHERE db_.set_id != rb.set_id
            ), 
            dg_arrays AS (
                SELECT dg.id, ARRAY_AGG(DISTINCT dg.set_id)::varchar[] as dnstr_set_ids
                FROM downstr_group dg
                GROUP BY dg.id
            )
            UPDATE bcfishpass.ranked_barriers
            SET dnstr_set_ids = dg_arrays.dnstr_set_ids
            FROM dg_arrays
            WHERE bcfishpass.ranked_barriers.id = dg_arrays.id;
            """
        cursor.execute(q_downstr_sets)

        q_assign_rank = """
            ----------------- ASSIGN RANK ID  -------------------------	

            -- Rank based on average gain per barrier in a group
            ALTER TABLE bcfishpass.ranked_barriers ADD rank_avg_gain_per_barrier numeric;

            WITH ranks AS
            (
                select set_id, avg_gain_per_barrier
                    ,DENSE_RANK() OVER(order by avg_gain_per_barrier DESC) as rank_id
                from bcfishpass.ranked_barriers
            )
            update bcfishpass.ranked_barriers 
            SET rank_avg_gain_per_barrier = ranks.rank_id
            FROM ranks
            WHERE bcfishpass.ranked_barriers.set_id = ranks.set_id;

            -- Rank based on first sorting the barriers into tiers by number of downstream barriers then by avg gain per barrier within those tiers (immediate gain)
            -- Also, barrier sets with less than 500 m of average gain per barrier are ranked below all barriers with more than 500 m of average gain
            ALTER TABLE bcfishpass.ranked_barriers 
            ADD rank_avg_gain_tiered numeric;

            WITH sorted AS (
                SELECT id, set_id, barriers_anthropogenic_dnstr_count, total_hab_gain_set, avg_gain_per_barrier
                    ,ROW_NUMBER() OVER(ORDER BY barriers_anthropogenic_dnstr_count, avg_gain_per_barrier DESC) as row_num
                FROM bcfishpass.ranked_barriers
                WHERE avg_gain_per_barrier >= 0.5
                UNION ALL
                SELECT id, set_id, barriers_anthropogenic_dnstr_count, total_hab_gain_set, avg_gain_per_barrier
                    ,(SELECT MAX(row_num) FROM (
                        SELECT ROW_NUMBER() OVER(ORDER BY barriers_anthropogenic_dnstr_count, avg_gain_per_barrier DESC) as row_num
                        FROM bcfishpass.ranked_barriers
                        WHERE avg_gain_per_barrier >= 0.5
                    ) AS subquery) + ROW_NUMBER() OVER(ORDER BY barriers_anthropogenic_dnstr_count, avg_gain_per_barrier DESC) as row_num 
                FROM bcfishpass.ranked_barriers
                WHERE avg_gain_per_barrier < 0.5
            ),
            ranks AS (
                SELECT id, barriers_anthropogenic_dnstr_count, avg_gain_per_barrier
                    ,FIRST_VALUE(row_num) OVER(PARTITION BY set_id ORDER BY barriers_anthropogenic_dnstr_count) as ranks
                    ,FIRST_VALUE(barriers_anthropogenic_dnstr_count) OVER (PARTITION BY set_id ORDER BY barriers_anthropogenic_dnstr_count) as tier
                FROM sorted
                ORDER BY set_id, barriers_anthropogenic_dnstr_count, avg_gain_per_barrier DESC
            )
            UPDATE bcfishpass.ranked_barriers 
            SET rank_avg_gain_tiered = ranks.ranks
            FROM ranks
            WHERE bcfishpass.ranked_barriers.id = ranks.id;

            -- Rank based on total habitat upstream (potential gain)
            ALTER TABLE bcfishpass.ranked_barriers 
            ADD rank_total_upstr_hab numeric;

            WITH sorted AS (
                SELECT id, set_id, barriers_anthropogenic_dnstr_count, all_spawningrearing_km, total_hab_gain_set, avg_gain_per_barrier
                    ,ROW_NUMBER() OVER(ORDER BY all_spawningrearing_km DESC) as row_num
                FROM bcfishpass.ranked_barriers
            ),
            ranks AS (
                SELECT id, set_id, barriers_anthropogenic_dnstr_count, total_hab_gain_set, avg_gain_per_barrier
                    ,FIRST_VALUE(row_num) OVER(PARTITION BY set_id ORDER BY row_num) as relative_rank
                FROM sorted
                ORDER BY set_id, barriers_anthropogenic_dnstr_count, avg_gain_per_barrier DESC
            ),
            densify AS (
                SELECT id, set_id, total_hab_gain_set, avg_gain_per_barrier
                    ,DENSE_RANK() OVER(ORDER BY relative_rank) as ranks
                FROM ranks
            )
            UPDATE bcfishpass.ranked_barriers 
            SET rank_total_upstr_hab = densify.ranks
            FROM densify
            WHERE bcfishpass.ranked_barriers.id = densify.id;

            -- Composite Rank of potential and immediate gain
            ALTER TABLE bcfishpass.ranked_barriers 
            ADD rank_combined numeric,
            ADD tier_combined varchar;

            WITH ranks AS (
                SELECT id, set_id, all_spawningrearing_km, total_hab_gain_set, avg_gain_per_barrier
                    ,rank_avg_gain_tiered
                    ,rank_total_upstr_hab
                    ,rank_avg_gain_per_barrier
                    ,DENSE_RANK() OVER(ORDER BY rank_avg_gain_tiered + rank_total_upstr_hab, set_id ASC) as rank_composite
                FROM bcfishpass.ranked_barriers
                ORDER BY rank_composite ASC
            )
            UPDATE bcfishpass.ranked_barriers
            SET rank_combined = r.rank_composite
            ,tier_combined = case
                    when r.rank_composite <= 10 then 'A'
                    when r.rank_composite <= 20 then 'B'
                    when r.rank_composite <= 30 then 'C'
                    else 'D'
                end
            FROM ranks r
            WHERE bcfishpass.ranked_barriers.id = r.id;

            ALTER TABLE bcfishpass.ranked_barriers
            RENAME COLUMN id to aggregated_crossings_id;
            """
        cursor.execute(q_assign_rank)

        q_pop_table = f"""
            ---- Insert values into wcrp_ranked_barriers table

            DELETE 
            FROM bcfishpass.wcrp_ranked_barriers r
            USING bcfishpass.crossings c
	        WHERE r.aggregated_crossings_id = c.aggregated_crossings_id
            AND {condition};

            INSERT INTO bcfishpass.wcrp_ranked_barriers
            SELECT 
                 aggregated_crossings_id
                ,set_id
                ,total_hab_gain_set
                ,num_barriers_set
                ,avg_gain_per_barrier
                ,dnstr_set_ids
                ,rank_avg_gain_per_barrier
                ,rank_avg_gain_tiered
                ,rank_total_upstr_hab
                ,rank_combined
                ,tier_combined
            FROM bcfishpass.ranked_barriers;

            DROP TABLE bcfishpass.ranked_barriers;
            """
        cursor.execute(q_pop_table)

        q_wcrp_rank_table = f"""
            -- Create a table to join crossings_wcrp_vw and wcrp_ranked_barriers fields in wcrp schema

            TRUNCATE TABLE wcrp_{wcrp_schema}.ranked_barriers_{wcrp};

            INSERT INTO wcrp_{wcrp_schema}.ranked_barriers_{wcrp} 
            select 
            cv.aggregated_crossings_id
            ,cv.crossing_source
            ,cv.crossing_feature_type
            ,cv.pscis_status
            ,cv.crossing_type_code
            ,cv.crossing_subtype_code
            ,cv.barrier_status
            ,cv.pscis_road_name
            ,cv.pscis_stream_name
            ,cv.pscis_assessment_comment
            ,cv.pscis_assessment_date
            ,cv.utm_zone
            ,cv.utm_easting
            ,cv.utm_northing
            ,cv.blue_line_key
            ,cv.watershed_group_code
            ,cv.gnis_stream_name
            ,cv.barriers_anthropogenic_dnstr
            ,cv.barriers_anthropogenic_dnstr_count
            ,cv.barriers_anthropogenic_habitat_wcrp_upstr
            ,cv.barriers_anthropogenic_habitat_wcrp_upstr_count
            ,cv.all_spawning_km
            ,cv.all_spawning_belowupstrbarriers_km
            ,cv.all_rearing_km
            ,cv.all_rearing_belowupstrbarriers_km
            ,cv.all_spawningrearing_km
            ,cv.all_spawningrearing_belowupstrbarriers_km
            ,r.set_id
            ,r.total_hab_gain_set
            ,r.num_barriers_set
            ,r.avg_gain_per_barrier
            ,r.dnstr_set_ids
            ,r.rank_avg_gain_per_barrier
            ,r.rank_avg_gain_tiered
            ,r.rank_combined
            ,r.tier_combined
            ,cv.geom
            from bcfishpass.wcrp_ranked_barriers r
            join bcfishpass.crossings_wcrp_vw cv
                on r.aggregated_crossings_id = cv.aggregated_crossings_id
            join bcfishpass.crossings c
                on c.aggregated_crossings_id = cv.aggregated_crossings_id
            where {condition}
            order by rank_combined;
        """ 
        cursor.execute(q_wcrp_rank_table)
    conn.commit()


def main():
    parser = makeParser()
    args = parser.parse_args()
    wcrp_list = [
        "bela_atna_necl",
        "bessette",
        "bonp",
        "bowr_ques_carr",
        "bulk",
        "eagle",
        "elkr_dnstr",
        "elkr_upstr",
        "hors",
        "lnic",
        "morr",
        "tuzistol_tah",
        "ulkatcho",
    ]
    wcrp_process = args.wcrp if args.wcrp else wcrp_list #define wcrps to process whether specific or all

    p = urlparse(os.environ["DATABASE_URL"])
    pg_conn_dict = {
        'dbname': p.path[1:],
        'user': p.username,
        'password': p.password,
        'port': p.port,
        'host': p.hostname
    }
    conn = pg2.connect(**pg_conn_dict)

    for wcrp in wcrp_process:
        print(f"Ranking barriers for WCRP: {wcrp}...")
        condition, wcrp_schema = buildCondition(wcrp)
        runQuery(condition, wcrp, wcrp_schema, conn)
        print("Done!")


if __name__ == "__main__":
    main()
