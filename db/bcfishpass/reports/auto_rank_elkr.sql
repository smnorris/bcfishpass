----------------------------------------------------------------------------------------------
-- @Date: April 25, 2024
-- @Author: Andrew Pozzuoli
-- Updated for automatic group id and ranking

-- this set of queries will generate a set of all barriers and their
-- downstream barriers, along with a set_id

----------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS bcfishpass.ranked_barriers;

select 
aggregated_crossings_id
,crossing_source
,crossing_feature_type
,pscis_status
,crossing_type_code
,crossing_subtype_code
,barrier_status
,pscis_road_name
,pscis_stream_name
,pscis_assessment_comment
,pscis_assessment_date
,utm_zone
,utm_easting
,utm_northing
,blue_line_key
,watershed_group_code
,gnis_stream_name
,barriers_anthropogenic_dnstr
,barriers_anthropogenic_dnstr_count
,barriers_anthropogenic_ch_cm_co_pk_sk_upstr
,barriers_anthropogenic_ch_cm_co_pk_sk_upstr_count
,all_spawning_km
,all_spawning_belowupstrbarriers_km
,all_rearing_km
,all_rearing_belowupstrbarriers_km
,all_spawningrearing_km
,all_spawningrearing_belowupstrbarriers_km
,geom
into bcfishpass.ranked_barriers
from bcfishpass.crossings_wcrp_vw
where barrier_status != 'PASSABLE'
AND all_spawningrearing_belowupstrbarriers_km  IS NOT NULL
AND all_spawningrearing_belowupstrbarriers_km  != 0
AND 
"watershed_group_code" IN ('ELKR')
AND barriers_ch_cm_co_pk_sk_dnstr = '';

ALTER TABLE IF EXISTS bcfishpass.ranked_barriers
    RENAME COLUMN aggregated_crossings_id TO id;
ALTER TABLE IF EXISTS bcfishpass.ranked_barriers
    ADD COLUMN set_id numeric;
ALTER TABLE IF EXISTS bcfishpass.ranked_barriers
    ALTER COLUMN id SET NOT NULL;
ALTER TABLE IF EXISTS bcfishpass.ranked_barriers
    ADD PRIMARY KEY (id);


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
				select id, blue_line_key, set_id, barriers_anthropogenic_ch_cm_co_pk_sk_upstr_count, all_spawningrearing_belowupstrbarriers_km 
					,AVG(all_spawningrearing_belowupstrbarriers_km ) OVER(PARTITION BY set_id ORDER BY barriers_anthropogenic_ch_cm_co_pk_sk_upstr_count DESC) as average
					,ROW_NUMBER() OVER(PARTITION BY set_id ORDER BY barriers_anthropogenic_ch_cm_co_pk_sk_upstr_count DESC) as row_num
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


---- Insert values into wcrp_ranked_barriers table

DELETE FROM bcfishpass.wcrp_ranked_barriers 
WHERE "watershed_group_code" IN ('ELKR');

INSERT INTO bcfishpass.wcrp_ranked_barriers
SELECT *
FROM bcfishpass.ranked_barriers;

DROP TABLE bcfishpass.ranked_barriers;