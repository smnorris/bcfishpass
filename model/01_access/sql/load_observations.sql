begin; 

  truncate bcfishpass.observations; 

  with wsg_spp as
  (
  select
    watershed_group_code, string_to_array(array_to_string(array[bt, ch, cm, co, ct, dv, gr, pk, rb, sk, st, wct], ','),',') as species_codes
  from (
    select
      p.watershed_group_code,
      case when p.bt is true then 'BT' else NULL end as bt,
      case when p.ch is true then 'CH' else NULL end as ch,
      case when p.cm is true then 'CM' else NULL end as cm,
      case when p.co is true then 'CO' else NULL end as co,
      case when p.ct is true then 'CT' else NULL end as ct,
      case when p.dv is true then 'DV' else NULL end as dv,
      case when p.gr is true then 'GR' else NULL end as gr,
      case when p.pk is true then 'PK' else NULL end as pk,
      case when p.rb is true then 'RB' else NULL end as rb,
      case when p.sk is true then 'SK' else NULL end as sk,
      case when p.st is true then 'ST' else NULL end as st,
      case when p.wct is true then 'WCT' else NULL end as wct
    from bcfishpass.wsg_species_presence p
    ) as f
  ),

  -- simplify CT species codes
  species_code_remap as (
    select distinct
      species_code,
      case
        when species_code = 'CCT' then 'CT'
        when species_code = 'ACT' then 'CT'
        when species_code = 'CT/RB' then 'CT'
        else species_code
      end as species_code_remap
    from bcfishobs.observations e
  )

  -- filter on species code and watershed group
  insert into bcfishpass.observations (
   observation_key,
   fish_observation_point_id,
   species_code,
   agency_id,
   point_type_code,
   observation_date,
   agency_name,
   source,
   source_ref,
   utm_zone,
   utm_easting,
   utm_northing,
   activity_code,
   activity,
   life_stage_code,
   life_stage,
   species_name,
   waterbody_identifier,
   waterbody_type,
   gazetted_name,
   new_watershed_code,
   trimmed_watershed_code,
   acat_report_url,
   feature_code,
   linear_feature_id,
   wscode,
   localcode,
   blue_line_key,
   watershed_group_code,
   downstream_route_measure,
   match_type,
   distance_to_stream,
   geom
)
  select
   o.observation_key,
   o.fish_observation_point_id,
   r.species_code_remap as species_code,
   o.agency_id,
   o.point_type_code,
   o.observation_date,
   o.agency_name,
   o.source,
   o.source_ref,
   o.utm_zone,
   o.utm_easting,
   o.utm_northing,
   o.activity_code,
   o.activity,
   o.life_stage_code,
   o.life_stage,
   o.species_name,
   o.waterbody_identifier,
   o.waterbody_type,
   o.gazetted_name,
   o.new_watershed_code,
   o.trimmed_watershed_code,
   o.acat_report_url,
   o.feature_code,
   o.linear_feature_id,
   o.wscode,
   o.localcode,
   o.blue_line_key,
   o.watershed_group_code,
   o.downstream_route_measure,
   o.match_type,
   o.distance_to_stream,
   o.geom
  from bcfishobs.observations o
  inner join wsg_spp on o.watershed_group_code = wsg_spp.watershed_group_code
  inner join species_code_remap r on o.species_code = r.species_code
  and array[o.species_code]::text[] && wsg_spp.species_codes
  -- exclude observations identified by QA as invalid (for fish passage modelling purposes)
  -- *note* - records at locations of ongoing releases are retained
  left outer join bcfishpass.observation_exclusions x on o.observation_key = x.observation_key
  and coalesce(x.exclude, false) is false;

commit;  