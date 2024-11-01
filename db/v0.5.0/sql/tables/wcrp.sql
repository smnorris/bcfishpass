-- --------------
-- WCRP WATERSHED GROUPS
--
-- watersheds and target species for CWF reporting
-- --------------
create table bcfishpass.wcrp_watersheds
(
  watershed_group_code varchar(4),
  ch boolean,
  cm boolean,
  co boolean,
  pk boolean,
  sk boolean,
  st boolean,
  wct boolean,
  notes text,
  wcrp varchar(32)
);


-- --------------
-- WCRP specific upstream habitat reporting  (for columns where it differs from bcfishpass.crossings_upstream_habitat)
--  - 'all species' is target species as defined in wcrp_watersheds
--  - apply 1.5x multiplier to co rearing in wetlands and to all sk rearing
-- --------------
create table bcfishpass.crossings_upstream_habitat_wcrp (
  aggregated_crossings_id               text primary key,
  watershed_group_code                  character varying (4),
  co_rearing_km                         double precision DEFAULT 0,
  co_rearing_belowupstrbarriers_km      double precision DEFAULT 0,
  sk_rearing_km                         double precision DEFAULT 0,
  sk_rearing_belowupstrbarriers_km      double precision DEFAULT 0,
  all_spawning_km                        double precision DEFAULT 0,
  all_spawning_belowupstrbarriers_km     double precision DEFAULT 0,
  all_rearing_km                        double precision DEFAULT 0,
  all_rearing_belowupstrbarriers_km     double precision DEFAULT 0,
  all_spawningrearing_km                double precision DEFAULT 0,
  all_spawningrearing_belowupstrbarriers_km    double precision DEFAULT 0
);


-- --------------
-- WCRP TRACKING TABLES
--
-- allow tracking of crossings/barriers beyond what PSCIS offers
-- --------------

create table bcfishpass.wcrp_confirmed_barriers (
  aggregated_crossings_id text primary key,
  internal_name text,
  watercourse_name text,
  road_name text,
  easting integer,
  northing integer,
  zone integer,
  barrier_type text,
  barrier_owner text,
  assessment_step_completed text CHECK (assessment_step_completed IN (
    'Informal assessment',
    'Barrier assessment',
    'Habitat confirmation',
    'Detailed habitat investigation'
    )
  ),
  partial_passability_notes text,
  upstream_habitat_quality text,
  constructability text,
  estimated_cost integer,
  cost_benefit_ratio integer,
  priority text CHECK (priority IN ('High','Medium','Low')),
  next_steps text CHECK (next_steps IN (
    'Engage with barrier owner',
    'Bring barrier to regulator',
    'Commission engineering designs',
    'Remove',
    'Replace',
    'Leave until end of life cycle',
    'identify barrier owner',
    'Engage in public consultation',
    'Fundraise'
    )
  ),
  next_steps_timeline text,
  next_steps_lead text,
  next_steps_others_involved text,
  reason text,
  comments text
);

create table bcfishpass.wcrp_data_deficient_structures (
  aggregated_crossings_id text primary key,
  internal_name text,
  watercourse_name text,
  road_name text,
  easting integer,
  northing integer,
  zone integer,
  structure_type text,
  assessment_step_completed text CHECK (assessment_step_completed IN (
    'Informal assessment',
    'Barrier assessment',
    'Habitat confirmation',
    'Detailed habitat investigation'
    )
  ),
  structure_owner text,
  next_steps text CHECK (next_steps IN (
    'Barrier assessment',
    'Habitat confirmation',
    'Detailed habitat investigation',
    'Other',
    'Passage study')
  ),
  next_steps_lead text,
  comments text
);

create table bcfishpass.wcrp_excluded_structures (
  aggregated_crossings_id text primary key,
  internal_name text,
  watercourse_name text,
  road_name text,
  easting integer,
  northing integer,
  zone integer,
  exclusion_reason text CHECK (exclusion_reason IN ('Passable', 'No structure','No key upstream habitat','No structure/key upstream habitat')),
  exclusion_method text CHECK (exclusion_method IN ('Imagery review','Field assessment','Local knowledge','Informal assessment')),
  comments text,
  supporting_links text
);

create table bcfishpass.wcrp_rehabilitiated_structures (
  aggregated_crossing_id text primary key,
  internal_name text,
  watercourse_name text,
  road_name text,
  easting integer,
  northing integer,
  zone integer,
  rehabilitation_type text CHECK (rehabilitation_type IN ('Removal','Replacement - OBS','Replacement - CBS','Decommissioning')),
  rehabilitated_by text,
  rehabilitation_date date,
  rehabilitation_cost_estimate integer,
  rehabilitation_cost_actual integer,
  comments text,
  supporting_links text
);

create table bcfishpass.wcrp_ranked_barriers (
	aggregated_crossings_id text primary key,
	set_id numeric,
	total_hab_gain_set numeric,
	num_barriers_set integer,
	avg_gain_per_barrier numeric,
	dnstr_set_ids character varying[],
	rank_avg_gain_per_barrier numeric,
	rank_avg_gain_tiered numeric,
	rank_total_upstr_hab numeric,
	rank_combined numeric, 
	tier_combined character varying
);