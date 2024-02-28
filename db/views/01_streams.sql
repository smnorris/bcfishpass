-- access - view of stream data plus downstream barrier info
create materialized view bcfishpass.streams_access_vw as
select
   s.segmented_stream_id,
   b.barriers_anthropogenic_dnstr,
   b.barriers_pscis_dnstr,          
   b.barriers_dams_dnstr,
   b.barriers_dams_hydro_dnstr,
   -- querying for barriers dnstr has to be on empty arrays rather than null - nulls are
   -- present in watershed groups where species does not occur
   case
     when b.barriers_bt_dnstr is not null then b.barriers_bt_dnstr
     when b.barriers_bt_dnstr is null and wsg_bt.watershed_group_code is not null then array[]::text[]
     when b.barriers_bt_dnstr is null and wsg_bt.watershed_group_code is null then null
   end as barriers_bt_dnstr,
   case
     when b.barriers_ch_cm_co_pk_sk_dnstr is not null then b.barriers_ch_cm_co_pk_sk_dnstr
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and wsg_salmon.watershed_group_code is not null then array[]::text[]
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and wsg_salmon.watershed_group_code is null then null
   end as barriers_ch_cm_co_pk_sk_dnstr,
   case
     when b.barriers_ct_dv_rb_dnstr is not null then b.barriers_ct_dv_rb_dnstr
     when b.barriers_ct_dv_rb_dnstr is null and wsg_ct_dv_rb.watershed_group_code is not null then array[]::text[]
     when b.barriers_ct_dv_rb_dnstr is null and wsg_ct_dv_rb.watershed_group_code is null then null
   end as barriers_ct_dv_rb_dnstr,
   case
     when b.barriers_st_dnstr is not null then b.barriers_st_dnstr
     when b.barriers_st_dnstr is null and wsg_st.watershed_group_code is not null then array[]::text[]
     when b.barriers_st_dnstr is null and wsg_st.watershed_group_code is null then null
   end as barriers_st_dnstr,
   case
     when b.barriers_wct_dnstr is not null then b.barriers_wct_dnstr
     when b.barriers_wct_dnstr is null and wsg_wct.watershed_group_code is not null then array[]::text[]
     when b.barriers_wct_dnstr is null and wsg_wct.watershed_group_code is null then null
   end as barriers_wct_dnstr,
   coalesce(ou.obsrvtn_event_upstr, array[]::bigint[]) as obsrvtn_event_upstr,
   coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[]) as obsrvtn_species_codes_upstr,
   coalesce(od.species_codes_dnstr, array[]::text[]) as species_codes_dnstr,

   -- include per-species/species groupings boolean 'observed' accessible columns
   case when 'BT' = any(ou.obsrvtn_species_codes_upstr) then true else false end as obsrvtn_upstr_bt,
   case when 'CH' = any(ou.obsrvtn_species_codes_upstr) then true else false end as obsrvtn_upstr_ch,
   case when 'CM' = any(ou.obsrvtn_species_codes_upstr) then true else false end as obsrvtn_upstr_cm,
   case when 'CO' = any(ou.obsrvtn_species_codes_upstr) then true else false end as obsrvtn_upstr_co,
   case when 'PK' = any(ou.obsrvtn_species_codes_upstr) then true else false end as obsrvtn_upstr_pk,
   case when 'SK' = any(ou.obsrvtn_species_codes_upstr) then true else false end as obsrvtn_upstr_sk,
   case when 'ST' = any(ou.obsrvtn_species_codes_upstr) then true else false end as obsrvtn_upstr_st,
   case when 'WCT' = any(ou.obsrvtn_species_codes_upstr) then true else false end as obsrvtn_upstr_wct,
   case when ou.obsrvtn_species_codes_upstr && array['CH','CM','CO','PK','SK'] then true else false end as obsrvtn_upstr_salmon,

   cd.crossings_dnstr,
   case
     when x.aggregated_crossings_id is not null then true
     else false
   end as remediated_dnstr_ind,
   case
     when array[b.barriers_anthropogenic_dnstr[1]] && b.barriers_dams_dnstr then true   -- is the next downstream anth barrier a dam?
     else false
   end as dam_dnstr_ind,
   case
     when array[b.barriers_anthropogenic_dnstr[1]] && b.barriers_dams_hydro_dnstr then true -- is the next downstream anth barrier a hydro dam?
     else false
   end as dam_hydro_dnstr_ind
from bcfishpass.streams s
left outer join bcfishpass.streams_dnstr_barriers b on s.segmented_stream_id = b.segmented_stream_id
left outer join bcfishpass.streams_upstr_observations ou on s.segmented_stream_id = ou.segmented_stream_id
left outer join bcfishpass.streams_dnstr_species od on s.segmented_stream_id = od.segmented_stream_id
left outer join bcfishpass.streams_dnstr_crossings cd on s.segmented_stream_id = cd.segmented_stream_id
left outer join bcfishpass.streams_dnstr_barriers_remediations r on s.segmented_stream_id = r.segmented_stream_id
left outer join bcfishpass.wsg_species_presence wsg_bt on s.watershed_group_code = wsg_bt.watershed_group_code and wsg_bt.bt is true
left outer join bcfishpass.wsg_species_presence wsg_salmon on s.watershed_group_code = wsg_salmon.watershed_group_code and (wsg_salmon.ch is true or wsg_salmon.cm is true or wsg_salmon.co is true or wsg_salmon.pk is true or wsg_salmon.sk is true)
left outer join bcfishpass.wsg_species_presence wsg_ct_dv_rb on s.watershed_group_code = wsg_ct_dv_rb.watershed_group_code and (wsg_ct_dv_rb.ct is true or wsg_ct_dv_rb.dv is true or wsg_ct_dv_rb.rb is true)
left outer join bcfishpass.wsg_species_presence wsg_st on s.watershed_group_code = wsg_st.watershed_group_code and wsg_st.st is true
left outer join bcfishpass.wsg_species_presence wsg_wct on s.watershed_group_code = wsg_wct.watershed_group_code and wsg_wct.wct is true
left outer join bcfishpass.crossings x on r.remediations_barriers_dnstr[1] = x.aggregated_crossings_id and x.pscis_status = 'REMEDIATED' and x.pscis_status = 'PASSABLE';

create unique index on bcfishpass.streams_access_vw (segmented_stream_id);

-- view of known/observed spawning / rearing locations (from CWF/FISS/PSE) for easy ref
CREATE materialized view bcfishpass.streams_habitat_known_vw AS
WITH manual_habitat_class AS
(
    SELECT distinct
      blue_line_key,
      downstream_route_measure,
      upstream_route_measure,
      CASE
        WHEN h.species_code = 'BT' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_bt,
      CASE
        WHEN h.species_code = 'CH' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_ch,
      CASE
        WHEN h.species_code = 'CM' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_cm,
      CASE
        WHEN h.species_code = 'CO' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_co,
      CASE
        WHEN h.species_code = 'PK' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_pk,
      CASE
        WHEN h.species_code = 'SK' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_sk,
      CASE
        WHEN h.species_code = 'ST' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_st,
      CASE
        WHEN h.species_code = 'WCT' AND h.habitat_type = 'spawning' THEN h.habitat_ind
      END AS spawning_wct,
      CASE
        WHEN h.species_code = 'BT' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_bt,
      CASE
        WHEN h.species_code = 'CH' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_ch,
      CASE
        WHEN h.species_code = 'CM' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_cm,
      CASE
        WHEN h.species_code = 'CO' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_co,
      CASE
        WHEN h.species_code = 'SK' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_sk,
      CASE
        WHEN h.species_code = 'ST' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_st,
      CASE
        WHEN h.species_code = 'WCT' AND h.habitat_type = 'rearing' THEN h.habitat_ind
      END AS rearing_wct,
      h.reviewer_name,
      h.source,
      h.notes
    FROM bcfishpass.user_habitat_classification h
)

SELECT
  s.segmented_stream_id,
  -- use bool_or to collapse separate spawning/rearing records for one stream segment into a single row
  bool_or(h.spawning_bt) as spawning_bt,
  bool_or(h.spawning_ch) as spawning_ch,
  bool_or(h.spawning_cm) as spawning_cm,
  bool_or(h.spawning_co) as spawning_co,
  bool_or(h.spawning_pk) as spawning_pk,
  bool_or(h.spawning_sk) as spawning_sk,
  bool_or(h.spawning_st) as spawning_st,
  bool_or(h.spawning_wct) as spawning_wct,
  bool_or(h.rearing_bt) as rearing_bt,
  bool_or(h.rearing_ch) as rearing_ch,
  bool_or(h.rearing_co) as rearing_co,
  bool_or(h.rearing_sk) as rearing_sk,
  bool_or(h.rearing_st) as rearing_st,
  bool_or(h.rearing_wct) as rearing_wct
FROM bcfishpass.streams s
INNER JOIN manual_habitat_class h
ON s.blue_line_key = h.blue_line_key
-- note that this join works because streams are already segmented at the endpoints
AND ROUND(s.downstream_route_measure::numeric) >= ROUND(h.downstream_route_measure::numeric)
AND ROUND(s.upstream_route_measure::numeric) <= ROUND(h.upstream_route_measure::numeric)
GROUP BY segmented_stream_id
ORDER BY segmented_stream_id;

create unique index on bcfishpass.streams_habitat_known_vw (segmented_stream_id);

-- combine various modelled habitat tables into single modelled habitat view
create materialized view bcfishpass.streams_habitat_linear_vw as
select
  s.segmented_stream_id,
  coalesce(u.spawning_bt, bt.spawning, false) as spawning_bt,
  coalesce(u.spawning_ch, ch.spawning, false) as spawning_ch,
  coalesce(u.spawning_cm, cm.spawning, false) as spawning_cm,
  coalesce(u.spawning_co, co.spawning, false) as spawning_co,
  coalesce(u.spawning_pk, pk.spawning, false) as spawning_pk,
  coalesce(u.spawning_sk, sk.spawning, false) as spawning_sk,
  coalesce(u.spawning_st, st.spawning, false) as spawning_st,
  coalesce(u.spawning_wct, wct.spawning, false) as spawning_wct,
  coalesce(u.rearing_bt, bt.rearing, false) as rearing_bt,
  coalesce(u.rearing_ch, ch.rearing, false) as rearing_ch,
  coalesce(u.rearing_co, co.rearing, false) as rearing_co,
  coalesce(u.rearing_sk, sk.rearing, false) as rearing_sk,
  coalesce(u.rearing_st, st.rearing, false) as rearing_st,
  coalesce(u.rearing_wct, wct.rearing, false) as rearing_wct
from bcfishpass.streams s
left outer join bcfishpass.habitat_linear_bt bt on s.segmented_stream_id = bt.segmented_stream_id
left outer join bcfishpass.habitat_linear_ch ch on s.segmented_stream_id = ch.segmented_stream_id
left outer join bcfishpass.habitat_linear_cm cm on s.segmented_stream_id = cm.segmented_stream_id
left outer join bcfishpass.habitat_linear_co co on s.segmented_stream_id = co.segmented_stream_id
left outer join bcfishpass.habitat_linear_pk pk on s.segmented_stream_id = pk.segmented_stream_id
left outer join bcfishpass.habitat_linear_sk sk on s.segmented_stream_id = sk.segmented_stream_id
left outer join bcfishpass.habitat_linear_st st on s.segmented_stream_id = st.segmented_stream_id
left outer join bcfishpass.habitat_linear_wct wct on s.segmented_stream_id = wct.segmented_stream_id
left outer join bcfishpass.streams_habitat_known_vw u on s.segmented_stream_id = u.segmented_stream_id;

create unique index on bcfishpass.streams_habitat_linear_vw (segmented_stream_id);

-- generate codes for easy categorical mapping

-- Code a 3 part array dumped to ; separated string:

-- First item is habitat type:
-- ACCESS - stream is potentially accessible, not spawning or rearing
-- SPAWN  - potential spawning (or spawning and rearing)
-- REAR   - potential rearing (not spawning)

-- Second item of array is the feature type of the next barrier (or crossing, if a remediation) downstream:
-- REMEDIATED - a remediation
-- DAM        - a dam that is classed as a barrier
-- ASSESSED   - PSCIS assessed barrier
-- MODELLED   - road/rail/trail stream crossing

-- Third item of array is only present if the stream is intermittent
-- INTERMITTENT
-- (note - consider adding a non-intermittent code for easier classification?)

create materialized view bcfishpass.streams_mapping_code_vw as

with mcbi as (
  select
    s.segmented_stream_id,
    case
      when a.remediated_dnstr_ind is true then 'REMEDIATED'  -- remediated crossing is downstream (with no additional barriers in between)
      when a.dam_dnstr_ind is true then 'DAM'                -- a dam is the next barrier downstream
      when
        a.barriers_anthropogenic_dnstr is not null and       -- a pscis barrier is downstream
        a.barriers_pscis_dnstr is not null and
        a.dam_dnstr_ind is false
      then 'ASSESSED'
      when
        a.barriers_anthropogenic_dnstr is not null and       -- a modelled barrier is downstream
        a.barriers_pscis_dnstr is null and
        a.dam_dnstr_ind is false
      then 'MODELLED'
      when a.barriers_anthropogenic_dnstr is null then 'NONE' -- no barriers exist downstream
    end as mapping_code_barrier,
    case
      when s.feature_code = 'GA24850150' then 'INTERMITTENT'
      else NULL
    end as mapping_code_intermittent
  from bcfishpass.streams s
  inner join bcfishpass.streams_access_vw a on s.segmented_stream_id = a.segmented_stream_id
)

select
  s.segmented_stream_id,
  array_to_string(array[
  case
    when
      a.barriers_bt_dnstr = array[]::text[] and
      h.spawning_bt is false and
      h.rearing_bt is false
    then 'ACCESS'
    when h.spawning_bt is true
    then 'SPAWN'
    when
      h.spawning_bt is false and
      h.rearing_bt is true
    then 'REAR'
  end,
  case
    when a.barriers_bt_dnstr = array[]::text[]
    then m.mapping_code_barrier
  else null end,
  case
    when a.barriers_bt_dnstr = array[]::text[]
    then m.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_bt,

  array_to_string(array[
  case
    when
      a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      h.spawning_ch is false and
      h.rearing_ch is false
    then 'ACCESS'
    when h.spawning_ch is true
    then 'SPAWN'
    when
      h.spawning_ch is false and
      h.rearing_ch is true
    then 'REAR'
  end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then m.mapping_code_barrier
  else null end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then m.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_ch,

  array_to_string(array[
  case
    when
      a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      h.spawning_cm is false
    then 'ACCESS'
    when h.spawning_cm is true
    then 'SPAWN'
  end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then m.mapping_code_barrier
  else null end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then m.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_cm,

  array_to_string(array[
  case
    when
      a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      h.spawning_co is false and
      h.rearing_co is false
    then 'ACCESS'
    when h.spawning_co is true
    then 'SPAWN'
    when
      h.spawning_co is false and
      h.rearing_co is true
    then 'REAR'
  end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then m.mapping_code_barrier
  else null end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then m.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_co,

  array_to_string(array[
  case
    when
      a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      h.spawning_pk is false
    then 'ACCESS'
    when h.spawning_pk is true
    then 'SPAWN'
  end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then m.mapping_code_barrier
  else null end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then m.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_pk,

  array_to_string(array[
  case
    when
      a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      h.spawning_sk is false and
      h.rearing_sk is false
    then 'ACCESS'
    when h.spawning_sk is true
    then 'SPAWN'
    when
      h.spawning_sk is false and
      h.rearing_sk is true
    then 'REAR'
  end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then m.mapping_code_barrier
  else null end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then m.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_sk,

  array_to_string(array[
  case
    when
      a.barriers_st_dnstr = array[]::text[] and
      h.spawning_st is false and
      h.rearing_st is false
    then 'ACCESS'
    when h.spawning_st is true
    then 'SPAWN'
    when
      h.spawning_st is false and
      h.rearing_st is true
    then 'REAR'
  end,
  case
    when a.barriers_st_dnstr = array[]::text[]
    then m.mapping_code_barrier
  else null end,
  case
    when a.barriers_st_dnstr = array[]::text[]
    then m.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_st,

  array_to_string(array[
  case
    when
      a.barriers_wct_dnstr = array[]::text[] and
      h.spawning_wct is false and
      h.rearing_wct is false
    then 'ACCESS'
    when h.spawning_wct is true
    then 'SPAWN'
    when
      h.spawning_wct is false and
      h.rearing_wct is true
    then 'REAR'
  end,
  case
    when a.barriers_wct_dnstr = array[]::text[]
    then m.mapping_code_barrier
  else null end,
  case
    when a.barriers_wct_dnstr = array[]::text[]
    then m.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_wct,
  array_to_string(array[
  -- combined salmon mapping code
  case
    when
      barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      h.spawning_ch is false and
      h.spawning_cm is false and
      h.spawning_co is false and
      h.spawning_pk is false and
      h.spawning_sk is false and
      h.rearing_ch is false and
      h.rearing_co is false and
      h.rearing_sk is false
    then 'ACCESS'
    -- potential spawning
    when
      h.spawning_ch is true or
      h.spawning_cm is true or
      h.spawning_co is true or
      h.spawning_pk is true or
      h.spawning_sk is true
    then 'SPAWN'
    -- potential rearing (and not spawning)
    when
      h.spawning_ch is false and
      h.spawning_cm is false and
      h.spawning_co is false and
      h.spawning_pk is false and
      h.spawning_sk is false and
      (
        h.rearing_ch is true or
        h.rearing_co is true or
        h.rearing_sk is true
      )
    then 'REAR'
  end,
   case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then m.mapping_code_barrier
  else null end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then m.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_salmon
from bcfishpass.streams s
inner join mcbi m on s.segmented_stream_id = m.segmented_stream_id
inner join bcfishpass.streams_access_vw a on s.segmented_stream_id = a.segmented_stream_id
inner join bcfishpass.streams_habitat_linear_vw h on s.segmented_stream_id = h.segmented_stream_id;

create unique index on bcfishpass.streams_mapping_code_vw (segmented_stream_id);


-- final output spatial streams view
drop view if exists bcfishpass.streams_vw;
create view bcfishpass.streams_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.barriers_bt_dnstr, ';') as barriers_bt_dnstr,
  array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
  array_to_string(a.barriers_ct_dv_rb_dnstr, ';') as barriers_ct_dv_rb_dnstr,
  array_to_string(a.barriers_st_dnstr, ';') as barriers_st_dnstr,
  array_to_string(a.barriers_wct_dnstr, ';') as barriers_wct_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  array_to_string(a.obsrvtn_event_upstr, ';') as obsrvtn_event_upstr,
  array_to_string(a.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  a.obsrvtn_upstr_bt,
  a.obsrvtn_upstr_ch,
  a.obsrvtn_upstr_cm,
  a.obsrvtn_upstr_co,
  a.obsrvtn_upstr_pk,
  a.obsrvtn_upstr_sk,
  a.obsrvtn_upstr_st,
  a.obsrvtn_upstr_wct,
  a.obsrvtn_upstr_salmon,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  h.spawning_bt as model_spawning_bt,
  h.spawning_ch as model_spawning_ch,
  h.spawning_cm as model_spawning_cm,
  h.spawning_co as model_spawning_co,
  h.spawning_pk as model_spawning_pk,
  h.spawning_sk as model_spawning_sk,
  h.spawning_st as model_spawning_st,
  h.spawning_wct as model_spawning_wct,
  h.rearing_bt as model_rearing_bt,
  h.rearing_ch as model_rearing_ch,
  h.rearing_co as model_rearing_co,
  h.rearing_sk as model_rearing_sk,
  h.rearing_st as model_rearing_st,
  h.rearing_wct as model_rearing_wct,
  hk.spawning_bt as known_spawning_bt,
  hk.spawning_ch as known_spawning_ch,
  hk.spawning_cm as known_spawning_cm,
  hk.spawning_co as known_spawning_co,
  hk.spawning_pk as known_spawning_pk,
  hk.spawning_sk as known_spawning_sk,
  hk.spawning_st as known_spawning_st,
  hk.spawning_wct as known_spawning_wct,
  hk.rearing_bt as known_rearing_bt,
  hk.rearing_ch as known_rearing_ch,
  hk.rearing_co as known_rearing_co,
  hk.rearing_sk as known_rearing_sk,
  hk.rearing_wct as known_rearing_wct,
  m.mapping_code_bt,
  m.mapping_code_ch,
  m.mapping_code_cm,
  m.mapping_code_co,
  m.mapping_code_pk,
  m.mapping_code_sk,
  m.mapping_code_st,
  m.mapping_code_wct,
  m.mapping_code_salmon,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access_vw a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear_vw h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code_vw m on s.segmented_stream_id = m.segmented_stream_id
left outer join bcfishpass.streams_habitat_known_vw hk on s.segmented_stream_id = hk.segmented_stream_id;

