-- report on habitat upstream, per species
drop table if exists bcfishpass.crossings_upstream_habitat cascade;

create table bcfishpass.crossings_upstream_habitat (
  aggregated_crossings_id               text primary key,
  watershed_group_code                  character varying (4),
  bt_spawning_km                        double precision DEFAULT 0,
  bt_rearing_km                         double precision DEFAULT 0,
  bt_spawning_belowupstrbarriers_km     double precision DEFAULT 0,
  bt_rearing_belowupstrbarriers_km      double precision DEFAULT 0,
  ch_spawning_km                        double precision DEFAULT 0,
  ch_rearing_km                         double precision DEFAULT 0,
  ch_spawning_belowupstrbarriers_km     double precision DEFAULT 0,
  ch_rearing_belowupstrbarriers_km      double precision DEFAULT 0,
  cm_spawning_km                        double precision DEFAULT 0,
  cm_spawning_belowupstrbarriers_km     double precision DEFAULT 0,
  co_spawning_km                        double precision DEFAULT 0,
  co_rearing_km                         double precision DEFAULT 0,
  co_rearing_ha                         double precision DEFAULT 0,
  co_spawning_belowupstrbarriers_km     double precision DEFAULT 0,
  co_rearing_belowupstrbarriers_km      double precision DEFAULT 0,
  co_rearing_belowupstrbarriers_ha      double precision DEFAULT 0,
  pk_spawning_km                        double precision DEFAULT 0,
  pk_spawning_belowupstrbarriers_km     double precision DEFAULT 0,
  sk_spawning_km                        double precision DEFAULT 0,
  sk_rearing_km                         double precision DEFAULT 0,
  sk_rearing_ha                         double precision DEFAULT 0,
  sk_spawning_belowupstrbarriers_km     double precision DEFAULT 0,
  sk_rearing_belowupstrbarriers_km      double precision DEFAULT 0,
  sk_rearing_belowupstrbarriers_ha      double precision DEFAULT 0,
  st_spawning_km                        double precision DEFAULT 0,
  st_rearing_km                         double precision DEFAULT 0,
  st_spawning_belowupstrbarriers_km     double precision DEFAULT 0,
  st_rearing_belowupstrbarriers_km      double precision DEFAULT 0,
  wct_spawning_km                       double precision DEFAULT 0,
  wct_rearing_km                        double precision DEFAULT 0,
  wct_spawning_belowupstrbarriers_km    double precision DEFAULT 0,
  wct_rearing_belowupstrbarriers_km     double precision DEFAULT 0
);


-- wcrp 'all species' upstream habitat reporting
--  - barriers only
--  - currently ch/co/sk/st/wct where they exist in watersheds of interest
--  - apply 1.5x multiplier to co rearing in wetlands and all sk rearing
drop table if exists bcfishpass.crossings_upstream_habitat_wcrp cascade;

create table bcfishpass.crossings_upstream_habitat_wcrp (
  aggregated_crossings_id               text primary key,
  watershed_group_code                  character varying (4),
  all_spawning_km                       double precision DEFAULT 0,
  co_rearing_km                         double precision DEFAULT 0,
  sk_rearing_km                         double precision DEFAULT 0,
  all_rearing_km                        double precision DEFAULT 0,
  all_spawningrearing_km                double precision DEFAULT 0,
  all_spawning_belowupstrbarriers_km    double precision DEFAULT 0,
  all_rearing_belowupstrbarriers_km     double precision DEFAULT 0,
  all_spawningrearing_belowupstrbarriers_km    double precision DEFAULT 0
);