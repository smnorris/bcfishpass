-- for publication to DataBC Catalouge
-- freshwater_fish_habitat_accessibility_MODEL.gpkg.zip

drop materialized view if exists bcfishpass.freshwater_fish_habitat_accessibility_model_salmon_vw;

create materialized view bcfishpass.freshwater_fish_habitat_accessibility_model_salmon_vw as

with observations as
(
  select 
    segmented_stream_id,
    array_agg(fish_observation_point_id) FILTER (WHERE fish_observation_point_id IS NOT NULL) AS obsrvtn_ids_upstr,
    array_agg(observation_date) FILTER (WHERE fish_observation_point_id IS NOT NULL) AS obsrvtn_dates_upstr,
    array_agg(DISTINCT (species_code)) FILTER (WHERE fish_observation_point_id IS NOT NULL) as obsrvtn_species_codes_upstr
  from (
  select distinct
    s.segmented_stream_id,  
    o.species_code,
    o.fish_observation_point_id,
    o.observation_date
  from bcfishpass.streams s
  left outer join bcfishpass.observations_vw o
  on FWA_Upstream(
          s.blue_line_key,
          s.downstream_route_measure,
          s.wscode_ltree,
          s.localcode_ltree,
          o.blue_line_key,
          o.downstream_route_measure,
          o.wscode_ltree,
          o.localcode_ltree,
          False,
          1
        )
  and s.watershed_group_code = o.watershed_group_code
  where o.species_code in ('CH','CM','CO','PK','SK')
  and s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
  ) as f
  group by segmented_stream_id
)

select 
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.downstream_route_measure,
  s.upstream_route_measure,
  s.watershed_group_code,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.feature_code,
  array_to_string(o.obsrvtn_ids_upstr, ';') as obsrvtn_ids_upstr,
  array_to_string(o.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(s.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(s.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(s.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(s.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  s.remediated_dnstr,
  s.geom
from bcfishpass.streams s
left outer join observations o
on s.segmented_stream_id = o.segmented_stream_id
where barriers_ch_cm_co_pk_sk_dnstr = array[]::text[];


drop materialized view if exists bcfishpass.freshwater_fish_habitat_accessibility_model_steelhead_vw;

create materialized view bcfishpass.freshwater_fish_habitat_accessibility_model_steelhead_vw as
with observations as
(
  select 
    segmented_stream_id,
    array_agg(fish_observation_point_id) FILTER (WHERE fish_observation_point_id IS NOT NULL) AS obsrvtn_ids_upstr,
    array_agg(observation_date) FILTER (WHERE fish_observation_point_id IS NOT NULL) AS obsrvtn_dates_upstr,
    array_agg(DISTINCT (species_code)) FILTER (WHERE fish_observation_point_id IS NOT NULL) as obsrvtn_species_codes_upstr
  from (
  select distinct
    s.segmented_stream_id,  
    o.species_code,
    o.fish_observation_point_id,
    o.observation_date
  from bcfishpass.streams s
  left outer join bcfishpass.observations_vw o
  on FWA_Upstream(
          s.blue_line_key,
          s.downstream_route_measure,
          s.wscode_ltree,
          s.localcode_ltree,
          o.blue_line_key,
          o.downstream_route_measure,
          o.wscode_ltree,
          o.localcode_ltree,
          False,
          1
        )
  and s.watershed_group_code = o.watershed_group_code
  where o.species_code = 'ST' 
  and s.barriers_st_dnstr = array[]::text[]
  ) as f
  group by segmented_stream_id
)

select 
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.upstream_route_measure,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.feature_code,
  array_to_string(o.obsrvtn_ids_upstr, ';') as obsrvtn_ids_upstr,
  array_to_string(o.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(s.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(s.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(s.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(s.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  s.remediated_dnstr,
  s.geom
from bcfishpass.streams s
left outer join observations o
on s.segmented_stream_id = o.segmented_stream_id
where barriers_st_dnstr = array[]::text[];


-- no views required for barrier tables, they can be used directly (only change would be renaming wscode/localcode)

-- dump observations for salmon and steelhead used in this analysis
drop materialized view if exists bcfishpass.freshwater_fish_habitat_accessibility_model_observations_vw;
create materialized view bcfishpass.freshwater_fish_habitat_accessibility_model_observations_vw as
select * from bcfishpass.observations_vw 
where species_code in ('CH','CM','CO','PK','SK','ST');


-- dump crossings 

drop materialized view if exists bcfishpass.freshwater_fish_habitat_accessibility_model_crossings_vw;
create materialized view bcfishpass.freshwater_fish_habitat_accessibility_model_crossings_vw as
select
 aggregated_crossings_id,
 stream_crossing_id,
 dam_id,
 user_barrier_anthropogenic_id,
 modelled_crossing_id,
 crossing_source,
 crossing_feature_type,
 pscis_status,
 crossing_type_code,
 crossing_subtype_code,
 array_to_string(modelled_crossing_type_source, ';') as modelled_crossing_type_source,
 barrier_status,
 pscis_road_name,
 pscis_stream_name,
 pscis_assessment_comment,
 pscis_assessment_date,
 pscis_final_score,
 transport_line_structured_name_1,
 transport_line_type_description,
 transport_line_surface_description,
 ften_forest_file_id,
 ften_file_type_description,
 ften_client_number,
 ften_client_name,
 ften_life_cycle_status_code,
 rail_track_name,
 rail_owner_name,
 rail_operator_english_name,
 ogc_proponent,
 dam_name,
 dam_height,
 dam_owner,
 dam_use,
 dam_operating_status,
 utm_zone,
 utm_easting,
 utm_northing,
 dbm_mof_50k_grid,
 linear_feature_id,
 blue_line_key,
 watershed_key,
 downstream_route_measure,
 wscode_ltree as wscode,
 localcode_ltree as localcode,
 watershed_group_code,
 gnis_stream_name,
 stream_order,
 stream_magnitude,
 array_to_string(observedspp_dnstr, ';') as observedspp_dnstr,
 array_to_string(observedspp_upstr, ';') as observedspp_upstr,
 array_to_string(crossings_dnstr, ';') as crossings_dnstr,
 array_to_string(barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
 array_to_string(barriers_anthropogenic_upstr, ';') as barriers_anthropogenic_upstr,
 barriers_anthropogenic_dnstr_count,
 barriers_anthropogenic_upstr_count,
 gradient,
 total_network_km,
 total_stream_km,
 total_lakereservoir_ha,
 total_wetland_ha,
 total_slopeclass03_waterbodies_km,
 total_slopeclass03_km,
 total_slopeclass05_km,
 total_slopeclass08_km,
 total_slopeclass15_km,
 total_slopeclass22_km,
 total_slopeclass30_km,
 total_belowupstrbarriers_network_km,
 total_belowupstrbarriers_stream_km,
 total_belowupstrbarriers_lakereservoir_ha,
 total_belowupstrbarriers_wetland_ha,
 total_belowupstrbarriers_slopeclass03_waterbodies_km,
 total_belowupstrbarriers_slopeclass03_km,
 total_belowupstrbarriers_slopeclass05_km,
 total_belowupstrbarriers_slopeclass08_km,
 total_belowupstrbarriers_slopeclass15_km,
 total_belowupstrbarriers_slopeclass22_km,
 total_belowupstrbarriers_slopeclass30_km,
 array_to_string(barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
 ch_cm_co_pk_sk_network_km,
 ch_cm_co_pk_sk_stream_km,
 ch_cm_co_pk_sk_lakereservoir_ha,
 ch_cm_co_pk_sk_wetland_ha,
 ch_cm_co_pk_sk_slopeclass03_waterbodies_km,
 ch_cm_co_pk_sk_slopeclass03_km,
 ch_cm_co_pk_sk_slopeclass05_km,
 ch_cm_co_pk_sk_slopeclass08_km,
 ch_cm_co_pk_sk_slopeclass15_km,
 ch_cm_co_pk_sk_slopeclass22_km,
 ch_cm_co_pk_sk_slopeclass30_km,
 ch_cm_co_pk_sk_belowupstrbarriers_network_km,
 ch_cm_co_pk_sk_belowupstrbarriers_stream_km,
 ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha,
 ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha,
 ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km,
 ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km,
 ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km,
 ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km,
 ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km,
 ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km,
 ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km,
 array_to_string(barriers_st_dnstr, ';') as barriers_st_dnstr,
 st_network_km,
 st_stream_km,
 st_lakereservoir_ha,
 st_wetland_ha,
 st_slopeclass03_waterbodies_km,
 st_slopeclass03_km,
 st_slopeclass05_km,
 st_slopeclass08_km,
 st_slopeclass15_km,
 st_slopeclass22_km,
 st_slopeclass30_km,
 st_belowupstrbarriers_network_km,
 st_belowupstrbarriers_stream_km,
 st_belowupstrbarriers_lakereservoir_ha,
 st_belowupstrbarriers_wetland_ha,
 st_belowupstrbarriers_slopeclass03_waterbodies_km,
 st_belowupstrbarriers_slopeclass03_km,
 st_belowupstrbarriers_slopeclass05_km,
 st_belowupstrbarriers_slopeclass08_km,
 st_belowupstrbarriers_slopeclass15_km,
 st_belowupstrbarriers_slopeclass22_km,
 st_belowupstrbarriers_slopeclass30_km,
 geom
 from bcfishpass.crossings;