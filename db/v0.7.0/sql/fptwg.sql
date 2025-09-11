--
-- additional fptwg assessment watershed summaries
-- these two views are not currently used anywhere (and do not get refreshed)
-- but were requested by fptwg, keep them in the db for now
--
-- count of crossings per assessment watershed, taken directly from source tables

BEGIN;

  CREATE MATERIALIZED VIEW bcfishpass.fptwg_summary_crossings_vw as
  select
    l.assmnt_watershed_id as watershed_feature_id,
    count(*) as n_crossings_total,
    count(*) filter (where crossing_feature_type = 'DAM') as n_dam,
    count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'PASSABLE') as n_dam_passable,
    count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'POTENTIAL') as n_dam_potential,
    count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'UNKNOWN') as n_dam_unknown,
    count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'BARRIER') as n_dam_barrier,
    count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'BARRIER' and cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0) as n_dam_barrier_salmon,
    count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'BARRIER' and cardinality(a.barriers_st_dnstr) = 0) as n_dam_barrier_steelhead,
    count(*) filter (where crossing_source = 'PSCIS' and pscis_status = 'ASSESSED') as n_pscisassessment,
    count(*) filter (where crossing_source = 'PSCIS' and pscis_status = 'HABITAT CONFIRMATION') as n_pscisconfirmation,
    count(*) filter (where crossing_source = 'PSCIS' and pscis_status = 'DESIGN') as n_pscisdesign,
    count(*) filter (where crossing_source = 'PSCIS' and pscis_status = 'REMEDIATED') as n_pscisremediation,
    count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'PASSABLE') as n_pscis_passable,
    count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'POTENTIAL') as n_pscis_potential,
    count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'UNKNOWN') as n_pscis_unknown,
    count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'BARRIER') as n_pscis_barrier,
    count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'BARRIER' and cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0) as n_pscis_barrier_salmon,
    count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'BARRIER' and cardinality(a.barriers_st_dnstr) = 0) as n_pscis_barrier_steelhead,
    count(*) filter (where crossing_source = 'MODELLED CROSSINGS') as n_modelledxings,
    count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'PASSABLE') as n_modelledxings_passable,
    count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'POTENTIAL') as n_modelledxings_potential,
    count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'UNKNOWN') as n_modelledxings_unknown,
    count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'BARRIER') as n_modelledxings_barrier,
    count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'BARRIER' and cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0) as n_modelledxings_barrier_salmon,
    count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'BARRIER' and cardinality(a.barriers_st_dnstr) = 0) as n_modelledxings_barrier_steelhead,
    count(*) filter (where crossing_source = 'MISC BARRIERS') as n_miscbarriers,
    count(*) filter (where crossing_source = 'MISC BARRIERS' and barrier_status = 'BARRIER' and cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0) as n_miscbarriers_barrier_salmon,
    count(*) filter (where crossing_source = 'MISC BARRIERS' and barrier_status = 'BARRIER' and cardinality(a.barriers_st_dnstr) = 0) as n_miscbarriers_barrier_steelhead
  from bcfishpass.crossings c
  left outer join bcfishpass.crossings_upstream_access a on c.aggregated_crossings_id = a.aggregated_crossings_id
  inner join whse_basemapping.fwa_assessment_watersheds_streams_lut l on c.linear_feature_id = l.linear_feature_id
  group by l.assmnt_watershed_id;
  create index on bcfishpass.fptwg_summary_crossings_vw (watershed_feature_id);

  create materialized view bcfishpass.fptwg_summary_observations_vw as
  select
    l.assmnt_watershed_id as watershed_feature_id,
    count(*) as n_fishobservations,
    array_agg(distinct o.species_code order by o.species_code) as speciesobserved,
    array_length(array_agg(distinct o.species_code order by o.species_code), 1) as n_speciesobserved,
    count(*) filter (where o.species_code in ('CH','CM','CO','PK','SK')) as n_salmonobservations,
    count(*) filter (where o.species_code = 'ST') as n_steelheadobservations,
    count(*) filter (where o.species_code in ('ACT', 'ADV', 'CCT', 'CH', 'CM', 'CO', 'EU', 'GSG', 'PK', 'PL', 'RL', 'SK', 'ST', 'WSG')) as n_anadromousobservations
  from bcfishpass.observations o
  inner join whse_basemapping.fwa_assessment_watersheds_streams_lut l on o.linear_feature_id = l.linear_feature_id
  group by l.assmnt_watershed_id;
  create index on bcfishpass.fptwg_summary_observations_vw (watershed_feature_id);

  create materialized view bcfishpass.fptwg_summary_roads_vw as
  with roads as (
    select
      w.watershed_feature_id,
      case when
        c.description IN (
          'Road alleyway',
          'Road arterial major',
          'Road arterial minor',
          'Road collector major',
          'Road collector minor',
          'Road freeway',
          'Road highway major',
          'Road highway minor',
          'Road lane',
          'Road local',
          'Private driveway demographic',
          'Road pedestrian mall',
          'Road runway non-demographic',
          'Road recreation demographic',
          'Road ramp',
          'Road restricted',
          'Road strata',
          'Road service',
          'Road yield lane'
        )
        then 'ROAD, DEMOGRAPHIC'
        when upper(c.description) LIKE 'TRAIL%' then 'TRAIL'
        when c.description is not NULL then 'ROAD, RESOURCE/OTHER'
      end as road_type,
      case
        when st_coveredby(r.geom, w.geom) then r.geom
      else
        st_intersection(r.geom, w.geom)
      end as geom
    from whse_basemapping.fwa_assessment_watersheds_poly w
    inner join whse_basemapping.transport_line r on st_intersects(w.geom, r.geom)
    inner join whse_basemapping.transport_line_type_code c on r.transport_line_type_code = c.transport_line_type_code
    where r.transport_line_type_code NOT IN ('F','FP','FR','T','TR','TS','RP','RWA')      -- exclude trails other than demographic and all ferry/water
    and r.transport_line_surface_code != 'D'                                              -- exclude decomissioned roads
    and coalesce(r.transport_line_structure_code, '') != 'T'                              -- exclude tunnels

    UNION ALL

    select
      w.watershed_feature_id,
      'RAIL' as road_type,
      case
        when st_coveredby(r.geom, w.geom) then r.geom
      else
        st_intersection(r.geom, w.geom)
      end as geom
    from whse_basemapping.fwa_assessment_watersheds_poly w
    inner join whse_basemapping.gba_railway_tracks_sp r on st_intersects(w.geom, r.geom)
    WHERE r.track_classification not in ('Ferry Route', 'Yard', 'Siding')   -- do we want to exclude yard/siding from this linear summary? this is the query for modelled xings
  )

  select
    watershed_feature_id,
    sum(st_length(geom)) filter (where road_type = 'RAIL') as length_rail,
    sum(st_length(geom)) filter (where road_type = 'ROAD, RESOURCE/OTHER') as length_resourceroad,
    sum(st_length(geom)) filter (where road_type = 'ROAD, DEMOGRAPHIC') as length_demographicroad,
    sum(st_length(geom)) filter (where road_type = 'TRAIL') as length_trail
  from roads
  where st_dimension(geom) = 1
  group by watershed_feature_id;
  create index on bcfishpass.fptwg_summary_roads_vw (watershed_feature_id);


COMMIT;