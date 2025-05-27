-- Drop views containing access/habitat class columns
-- The drops cascade to several other relations, rebuild them all


BEGIN;

Drop materialized view IF EXISTS bcfishpass.streams_access_vw cascade;

-- access - view of stream data plus downstream barrier info
-- modified to include "access" columns with codes 0/1/2 (inaccessible/modelled/observed)

create materialized view bcfishpass.streams_access_vw as
select
   s.segmented_stream_id,
   b.barriers_anthropogenic_dnstr,
   b.barriers_pscis_dnstr,          
   b.barriers_dams_dnstr,
   b.barriers_dams_hydro_dnstr,
   -- retain arrays of downstream barrier ids
   -- note that querying for barriers dnstr has to be on empty arrays rather than null - nulls are
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

   -- translate downstream barrier presence/absence and upstream observation presence/absence 
   -- into an access model code 0=inaccessible 1=modelled 2=observed
   case
     when wsg_bt.watershed_group_code is null then -1
     when b.barriers_bt_dnstr is null and 'BT' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
     when b.barriers_bt_dnstr is null and 'BT' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) is false then 1
     when b.barriers_bt_dnstr is not null and wsg_bt.watershed_group_code is not null then 0
   end as access_bt,
   case
     when wsg_salmon.watershed_group_code is null then -1
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'CH' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'CH' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) is false then 1
     when b.barriers_ch_cm_co_pk_sk_dnstr is not null and wsg_salmon.watershed_group_code is not null then 0
   end as access_ch,
   case
     when wsg_salmon.watershed_group_code is null then -1
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'CM' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'CM' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) is false then 1
     when b.barriers_ch_cm_co_pk_sk_dnstr is not null and wsg_salmon.watershed_group_code is not null then 0
   end as access_cm,
   case
     when wsg_salmon.watershed_group_code is null then -1
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'CO' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'CO' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) is false then 1
     when b.barriers_ch_cm_co_pk_sk_dnstr is not null and wsg_salmon.watershed_group_code is not null then 0
   end as access_co,
   case
     when wsg_salmon.watershed_group_code is null then -1
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'PK' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'PK' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) is false then 1
     when b.barriers_ch_cm_co_pk_sk_dnstr is not null and wsg_salmon.watershed_group_code is not null then 0
   end as access_pk,
   case
     when wsg_salmon.watershed_group_code is null then -1
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'SK' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'SK' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) is false then 1
     when b.barriers_ch_cm_co_pk_sk_dnstr is not null and wsg_salmon.watershed_group_code is not null then 0
   end as access_sk,
   case
     when wsg_salmon.watershed_group_code is null then -1
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[]) && array['CH','CM','CO','PK','SK'] then 2
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[]) && array['CH','CM','CO','PK','SK'] is false then 1
     when b.barriers_ch_cm_co_pk_sk_dnstr is not null and wsg_salmon.watershed_group_code is not null then 0
   end as access_salmon,
   case
     when wsg_ct_dv_rb.watershed_group_code is null then -1
     when b.barriers_ct_dv_rb_dnstr is null and coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[]) && array['CT','DV','RB'] then 2
     when b.barriers_ct_dv_rb_dnstr is null and coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[]) && array['CT','DV','RB'] is false then 1
     when b.barriers_ct_dv_rb_dnstr is not null and wsg_ct_dv_rb.watershed_group_code is not null then 0
   end as access_ct_dv_rb,
   case
     when wsg_st.watershed_group_code is null then -1
     when b.barriers_st_dnstr is null and 'SK' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
     when b.barriers_st_dnstr is null and 'SK' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) is false then 1
     when b.barriers_st_dnstr is not null and wsg_st.watershed_group_code is not null then 0
   end as access_st,
   case
     when wsg_wct.watershed_group_code is null then -1
     when b.barriers_wct_dnstr is null and 'WCT' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
     when b.barriers_wct_dnstr is null and 'WCT' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) is false then 1
     when b.barriers_wct_dnstr is not null and wsg_wct.watershed_group_code is not null then 0
   end as access_wct,

   coalesce(ou.obsrvtn_event_upstr, array[]::bigint[]) as obsrvtn_event_upstr,
   coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[]) as obsrvtn_species_codes_upstr,
   coalesce(od.species_codes_dnstr, array[]::text[]) as species_codes_dnstr,

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

-- combine all modelled habitat tables and observed habitat table into a single spawning/rearing view
-- habitat columns have values:
-- 0 non habitat
-- 1 modelled habitat
-- 2 modelled and observed habitat
-- 3 observed habitat
drop materialized view IF EXISTS bcfishpass.streams_habitat_linear_vw;
create materialized view bcfishpass.streams_habitat_linear_vw as
select
  s.segmented_stream_id,
  case
    when coalesce(bt.spawning, false) is true and coalesce(u.spawning_bt, false) is false then 1
    when coalesce(bt.spawning, false) is true and coalesce(u.spawning_bt, false) is true then 2
    when coalesce(bt.spawning, false) is false and coalesce(u.spawning_bt, false) is true then 3
    else 0
  end as spawning_bt,
  case
    when coalesce(ch.spawning, false) is true and coalesce(u.spawning_ch, false) is false then 1
    when coalesce(ch.spawning, false) is true and coalesce(u.spawning_ch, false) is true then 2
    when coalesce(ch.spawning, false) is false and coalesce(u.spawning_ch, false) is true then 3
    else 0
  end as spawning_ch,
  case
    when coalesce(cm.spawning, false) is true and coalesce(u.spawning_cm, false) is false then 1
    when coalesce(cm.spawning, false) is true and coalesce(u.spawning_cm, false) is true then 2
    when coalesce(cm.spawning, false) is false and coalesce(u.spawning_cm, false) is true then 3
    else 0
  end as spawning_cm,
  case
    when coalesce(co.spawning, false) is true and coalesce(u.spawning_co, false) is false then 1
    when coalesce(co.spawning, false) is true and coalesce(u.spawning_co, false) is true then 2
    when coalesce(co.spawning, false) is false and coalesce(u.spawning_co, false) is true then 3
    else 0
  end as spawning_co,
  case
    when coalesce(pk.spawning, false) is true and coalesce(u.spawning_pk, false) is false then 1
    when coalesce(pk.spawning, false) is true and coalesce(u.spawning_pk, false) is true then 2
    when coalesce(pk.spawning, false) is false and coalesce(u.spawning_pk, false) is true then 3
    else 0
  end as spawning_pk,
  case
    when coalesce(sk.spawning, false) is true and coalesce(u.spawning_sk, false) is false then 1
    when coalesce(sk.spawning, false) is true and coalesce(u.spawning_sk, false) is true then 2
    when coalesce(sk.spawning, false) is false and coalesce(u.spawning_sk, false) is true then 3
    else 0
  end as spawning_sk,
  case
    when coalesce(st.spawning, false) is true and coalesce(u.spawning_st, false) is false then 1
    when coalesce(st.spawning, false) is true and coalesce(u.spawning_st, false) is true then 2
    when coalesce(st.spawning, false) is false and coalesce(u.spawning_st, false) is true then 3
    else 0
  end as spawning_st,
  case
    when coalesce(wct.spawning, false) is true and coalesce(u.spawning_wct, false) is false then 1
    when coalesce(wct.spawning, false) is true and coalesce(u.spawning_wct, false) is true then 2
    when coalesce(wct.spawning, false) is false and coalesce(u.spawning_wct, false) is true then 3
    else 0
  end as spawning_wct,

  case
    when coalesce(bt.rearing, false) is true and coalesce(u.rearing_bt, false) is false then 1
    when coalesce(bt.rearing, false) is true and coalesce(u.rearing_bt, false) is true then 2
    when coalesce(bt.rearing, false) is false and coalesce(u.rearing_bt, false) is true then 3
    else 0
  end as rearing_bt,
  case
    when coalesce(ch.rearing, false) is true and coalesce(u.rearing_ch, false) is false then 1
    when coalesce(ch.rearing, false) is true and coalesce(u.rearing_ch, false) is true then 2
    when coalesce(ch.rearing, false) is false and coalesce(u.rearing_ch, false) is true then 3
    else 0
  end as rearing_ch,
  case
    when coalesce(co.rearing, false) is true and coalesce(u.rearing_co, false) is false then 1
    when coalesce(co.rearing, false) is true and coalesce(u.rearing_co, false) is true then 2
    when coalesce(co.rearing, false) is false and coalesce(u.rearing_co, false) is true then 3
    else 0
  end as rearing_co,
  case
    when coalesce(sk.rearing, false) is true and coalesce(u.rearing_sk, false) is false then 1
    when coalesce(sk.rearing, false) is true and coalesce(u.rearing_sk, false) is true then 2
    when coalesce(sk.rearing, false) is false and coalesce(u.rearing_sk, false) is true then 3
    else 0
  end as rearing_sk,
  case
    when coalesce(st.rearing, false) is true and coalesce(u.rearing_st, false) is false then 1
    when coalesce(st.rearing, false) is true and coalesce(u.rearing_st, false) is true then 2
    when coalesce(st.rearing, false) is false and coalesce(u.rearing_st, false) is true then 3
    else 0
  end as rearing_st,
  case
    when coalesce(wct.rearing, false) is true and coalesce(u.rearing_wct, false) is false then 1
    when coalesce(wct.rearing, false) is true and coalesce(u.rearing_wct, false) is true then 2
    when coalesce(wct.rearing, false) is false and coalesce(u.rearing_wct, false) is true then 3
    else 0
  end as rearing_wct
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

-- Second item of array depends on the species
--    - for resident spp, this is the feature type of the **next** barrier (or crossing, if a remediation) downstream
--    - for anadromous spp, this is the feature of the most downstream barrier, unless the next crossing  dowstream is a remediation
-- REMEDIATED - a remediation
-- DAM        - a dam that is classed as a barrier
-- ASSESSED   - PSCIS assessed barrier
-- MODELLED   - road/rail/trail stream crossing

-- Third item of array is only present if the stream is intermittent
-- INTERMITTENT
-- (note - consider adding a non-intermittent code for easier classification?)

create materialized view bcfishpass.streams_mapping_code_vw as

with mcbi_r as (
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
),

mcbi_a as (
 select
    s.segmented_stream_id,
    case
      when a.remediated_dnstr_ind is true then 'REMEDIATED'           -- remediated crossing is downstream (with no additional barriers in between)
      when a.barriers_dams_dnstr is not null then 'DAM'               -- a dam barrier is present downstream
      when a.barriers_pscis_dnstr is not null then 'ASSESSED'    -- a pscis barrier is present downstream
      when a.barriers_anthropogenic_dnstr is not null then 'MODELLED' -- a modelled barrier is downstream
      when a.barriers_anthropogenic_dnstr is null then 'NONE'         -- no barriers exist downstream
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
      h.spawning_bt < 1 and
      h.rearing_bt < 1
    then 'ACCESS'
    when h.spawning_bt > 0
    then 'SPAWN'
    when
      h.spawning_bt < 1 and
      h.rearing_bt > 0
    then 'REAR'
  end,
  case
    when a.barriers_bt_dnstr = array[]::text[]
    then mr.mapping_code_barrier
  else null end,
  case
    when a.barriers_bt_dnstr = array[]::text[]
    then mr.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_bt,

  array_to_string(array[
  case
    when
      a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      h.spawning_ch < 1 and
      h.rearing_ch < 1
    then 'ACCESS'
    when h.spawning_ch > 0
    then 'SPAWN'
    when
      h.spawning_ch < 1 and
      h.rearing_ch > 0
    then 'REAR'
  end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then ma.mapping_code_barrier
  else null end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then ma.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_ch,

  array_to_string(array[
  case
    when
      a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      h.spawning_cm < 1
    then 'ACCESS'
    when h.spawning_cm > 0
    then 'SPAWN'
  end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then ma.mapping_code_barrier
  else null end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then ma.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_cm,

  array_to_string(array[
  case
    when
      a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      h.spawning_co < 1 and
      h.rearing_co < 1
    then 'ACCESS'
    when h.spawning_co > 0
    then 'SPAWN'
    when
      h.spawning_co < 1 and
      h.rearing_co > 0
    then 'REAR'
  end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then ma.mapping_code_barrier
  else null end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then ma.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_co,

  array_to_string(array[
  case
    when
      a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      h.spawning_pk < 1
    then 'ACCESS'
    when h.spawning_pk > 0
    then 'SPAWN'
  end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then ma.mapping_code_barrier
  else null end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then ma.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_pk,

  array_to_string(array[
  case
    when
      a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      h.spawning_sk < 1 and
      h.rearing_sk < 1
    then 'ACCESS'
    when h.spawning_sk > 0
    then 'SPAWN'
    when
      h.spawning_sk < 1 and
      h.rearing_sk > 0
    then 'REAR'
  end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then ma.mapping_code_barrier
  else null end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then ma.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_sk,

  array_to_string(array[
  case
    when
      a.barriers_st_dnstr = array[]::text[] and
      h.spawning_st < 1 and
      h.rearing_st < 1
    then 'ACCESS'
    when h.spawning_st > 0
    then 'SPAWN'
    when
      h.spawning_st < 1 and
      h.rearing_st > 0
    then 'REAR'
  end,
  case
    when a.barriers_st_dnstr = array[]::text[]
    then ma.mapping_code_barrier
  else null end,
  case
    when a.barriers_st_dnstr = array[]::text[]
    then ma.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_st,

  array_to_string(array[
  case
    when
      a.barriers_wct_dnstr = array[]::text[] and
      h.spawning_wct < 1 and
      h.rearing_wct < 1
    then 'ACCESS'
    when h.spawning_wct > 0
    then 'SPAWN'
    when
      h.spawning_wct < 1 and
      h.rearing_wct > 0
    then 'REAR'
  end,
  case
    when a.barriers_wct_dnstr = array[]::text[]
    then mr.mapping_code_barrier
  else null end,
  case
    when a.barriers_wct_dnstr = array[]::text[]
    then mr.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_wct,
  array_to_string(array[
  -- combined salmon mapping code
  case
    when
      barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      h.spawning_ch < 1 and
      h.spawning_cm < 1 and
      h.spawning_co < 1 and
      h.spawning_pk < 1 and
      h.spawning_sk < 1 and
      h.rearing_ch < 1 and
      h.rearing_co < 1 and
      h.rearing_sk < 1
    then 'ACCESS'
    -- potential spawning
    when
      h.spawning_ch > 0 or
      h.spawning_cm > 0 or
      h.spawning_co > 0 or
      h.spawning_pk > 0 or
      h.spawning_sk > 0
    then 'SPAWN'
    -- potential rearing (and not spawning)
    when
      h.spawning_ch < 1 and
      h.spawning_cm < 1 and
      h.spawning_co < 1 and
      h.spawning_pk < 1 and
      h.spawning_sk < 1 and
      (
        h.rearing_ch > 0 or
        h.rearing_co > 0 or
        h.rearing_sk > 0
      )
    then 'REAR'
  end,
   case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then ma.mapping_code_barrier
  else null end,
  case
    when a.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then ma.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_salmon
from bcfishpass.streams s
inner join mcbi_r mr on s.segmented_stream_id = mr.segmented_stream_id
inner join mcbi_a ma on s.segmented_stream_id = ma.segmented_stream_id
inner join bcfishpass.streams_access_vw a on s.segmented_stream_id = a.segmented_stream_id
inner join bcfishpass.streams_habitat_linear_vw h on s.segmented_stream_id = h.segmented_stream_id;

create unique index on bcfishpass.streams_mapping_code_vw (segmented_stream_id);


-- final output spatial streams view
CREATE VIEW bcfishpass.streams_vw as
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
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  a.access_bt,
  a.access_ch,
  a.access_cm,
  a.access_co,
  a.access_pk,
  a.access_sk,
  a.access_st,
  a.access_wct,
  a.access_salmon,
  case when a.access_bt = -1 then -1 else h.spawning_bt end as spawning_bt,
  case when a.access_ch = -1 then -1 else h.spawning_ch end as spawning_ch,
  case when a.access_cm = -1 then -1 else h.spawning_cm end as spawning_cm,
  case when a.access_co = -1 then -1 else h.spawning_co end as spawning_co,
  case when a.access_pk = -1 then -1 else h.spawning_pk end as spawning_pk,
  case when a.access_sk = -1 then -1 else h.spawning_sk end as spawning_sk,
  case when a.access_st = -1 then -1 else h.spawning_st end as spawning_st,
  case when a.access_wct = -1 then -1 else h.spawning_wct end as spawning_wct,
  case when a.access_bt = -1 then -1 else h.rearing_bt end as rearing_bt,
  case when a.access_ch = -1 then -1 else h.rearing_ch end as rearing_ch,
  case when a.access_co = -1 then -1 else h.rearing_co end as rearing_co,
  case when a.access_sk = -1 then -1 else h.rearing_sk end as rearing_sk,
  case when a.access_st = -1 then -1 else h.rearing_st end as rearing_st,
  case when a.access_wct = -1 then -1 else h.rearing_wct end as rearing_wct,
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
left outer join bcfishpass.streams_mapping_code_vw m on s.segmented_stream_id = m.segmented_stream_id;


-- per species views
create view bcfishpass.streams_bt_vw as
select
  segmented_stream_id,
  linear_feature_id,
  edge_type,
  blue_line_key,
  watershed_key,
  watershed_group_code,
  downstream_route_measure,
  length_metre,
  waterbody_key,
  gnis_name,
  stream_order,
  stream_magnitude,
  gradient,
  feature_code,
  upstream_route_measure,
  upstream_area_ha,
  stream_order_parent,
  stream_order_max,
  map_upstream,
  channel_width,
  mad_m3s,
  barriers_anthropogenic_dnstr,
  barriers_pscis_dnstr,
  barriers_dams_dnstr,
  barriers_dams_hydro_dnstr,
  barriers_bt_dnstr,
  crossings_dnstr,
  dam_dnstr_ind,
  dam_hydro_dnstr_ind,
  remediated_dnstr_ind,
  obsrvtn_event_upstr,
  obsrvtn_species_codes_upstr,
  species_codes_dnstr,
  access_bt as access,
  spawning_bt as spawning,
  rearing_bt as rearing,
  mapping_code_bt as mapping_code,
  geom
from bcfishpass.streams_vw
where access_bt > 0;


create view bcfishpass.streams_ch_vw as
select
  segmented_stream_id,
  linear_feature_id,
  edge_type,
  blue_line_key,
  watershed_key,
  watershed_group_code,
  downstream_route_measure,
  length_metre,
  waterbody_key,
  gnis_name,
  stream_order,
  stream_magnitude,
  gradient,
  feature_code,
  upstream_route_measure,
  upstream_area_ha,
  stream_order_parent,
  stream_order_max,
  map_upstream,
  channel_width,
  mad_m3s,
  barriers_anthropogenic_dnstr,
  barriers_pscis_dnstr,
  barriers_dams_dnstr,
  barriers_dams_hydro_dnstr,
  barriers_ch_cm_co_pk_sk_dnstr,
  crossings_dnstr,
  dam_dnstr_ind,
  dam_hydro_dnstr_ind,
  remediated_dnstr_ind,
  obsrvtn_event_upstr,
  obsrvtn_species_codes_upstr,
  species_codes_dnstr,
  access_ch as access,
  spawning_ch as spawning,
  rearing_ch as rearing,
  mapping_code_ch as mapping_code,
  geom
from bcfishpass.streams_vw
where access_ch > 0;


create view bcfishpass.streams_cm_vw as
select
  segmented_stream_id,
  linear_feature_id,
  edge_type,
  blue_line_key,
  watershed_key,
  watershed_group_code,
  downstream_route_measure,
  length_metre,
  waterbody_key,
  gnis_name,
  stream_order,
  stream_magnitude,
  gradient,
  feature_code,
  upstream_route_measure,
  upstream_area_ha,
  stream_order_parent,
  stream_order_max,
  map_upstream,
  channel_width,
  mad_m3s,
  barriers_anthropogenic_dnstr,
  barriers_pscis_dnstr,
  barriers_dams_dnstr,
  barriers_dams_hydro_dnstr,
  barriers_ch_cm_co_pk_sk_dnstr,
  crossings_dnstr,
  dam_dnstr_ind,
  dam_hydro_dnstr_ind,
  remediated_dnstr_ind,
  obsrvtn_event_upstr,
  obsrvtn_species_codes_upstr,
  species_codes_dnstr,
  access_cm as access,
  spawning_cm as spawning,
  mapping_code_cm as mapping_code,
  geom
from bcfishpass.streams_vw
where access_cm > 0;

create view bcfishpass.streams_co_vw as
select
  segmented_stream_id,
  linear_feature_id,
  edge_type,
  blue_line_key,
  watershed_key,
  watershed_group_code,
  downstream_route_measure,
  length_metre,
  waterbody_key,
  gnis_name,
  stream_order,
  stream_magnitude,
  gradient,
  feature_code,
  upstream_route_measure,
  upstream_area_ha,
  stream_order_parent,
  stream_order_max,
  map_upstream,
  channel_width,
  mad_m3s,
  barriers_anthropogenic_dnstr,
  barriers_pscis_dnstr,
  barriers_dams_dnstr,
  barriers_dams_hydro_dnstr,
  barriers_ch_cm_co_pk_sk_dnstr,
  crossings_dnstr,
  dam_dnstr_ind,
  dam_hydro_dnstr_ind,
  remediated_dnstr_ind,
  obsrvtn_event_upstr,
  obsrvtn_species_codes_upstr,
  species_codes_dnstr,
  access_co as access,
  spawning_co as spawning,
  rearing_co as rearing,
  mapping_code_co as mapping_code,
  geom
from bcfishpass.streams_vw
where access_co > 0;

create view bcfishpass.streams_pk_vw as
select
  segmented_stream_id,
  linear_feature_id,
  edge_type,
  blue_line_key,
  watershed_key,
  watershed_group_code,
  downstream_route_measure,
  length_metre,
  waterbody_key,
  gnis_name,
  stream_order,
  stream_magnitude,
  gradient,
  feature_code,
  upstream_route_measure,
  upstream_area_ha,
  stream_order_parent,
  stream_order_max,
  map_upstream,
  channel_width,
  mad_m3s,
  barriers_anthropogenic_dnstr,
  barriers_pscis_dnstr,
  barriers_dams_dnstr,
  barriers_dams_hydro_dnstr,
  barriers_ch_cm_co_pk_sk_dnstr,
  crossings_dnstr,
  dam_dnstr_ind,
  dam_hydro_dnstr_ind,
  remediated_dnstr_ind,
  obsrvtn_event_upstr,
  obsrvtn_species_codes_upstr,
  species_codes_dnstr,
  access_pk as access,
  spawning_pk as spawning,
  mapping_code_pk as mapping_code,
  geom
from bcfishpass.streams_vw
where access_pk > 0;


create view bcfishpass.streams_salmon_vw as
select
  segmented_stream_id,
  linear_feature_id,
  edge_type,
  blue_line_key,
  watershed_key,
  watershed_group_code,
  downstream_route_measure,
  length_metre,
  waterbody_key,
  gnis_name,
  stream_order,
  stream_magnitude,
  gradient,
  feature_code,
  upstream_route_measure,
  upstream_area_ha,
  stream_order_parent,
  stream_order_max,
  map_upstream,
  channel_width,
  mad_m3s,
  barriers_anthropogenic_dnstr,
  barriers_pscis_dnstr,
  barriers_dams_dnstr,
  barriers_dams_hydro_dnstr,
  barriers_ch_cm_co_pk_sk_dnstr,
  crossings_dnstr,
  dam_dnstr_ind,
  dam_hydro_dnstr_ind,
  remediated_dnstr_ind,
  obsrvtn_event_upstr,
  obsrvtn_species_codes_upstr,
  species_codes_dnstr,
  access_salmon as access,
  greatest(spawning_ch, spawning_cm, spawning_co, spawning_pk, spawning_sk) as spawning,
  greatest(rearing_ch, rearing_co, rearing_sk) as rearing,
  mapping_code_salmon as mapping_code,
  geom
from bcfishpass.streams_vw
where access_salmon > 0;


create view bcfishpass.streams_sk_vw as
select
  segmented_stream_id,
  linear_feature_id,
  edge_type,
  blue_line_key,
  watershed_key,
  watershed_group_code,
  downstream_route_measure,
  length_metre,
  waterbody_key,
  gnis_name,
  stream_order,
  stream_magnitude,
  gradient,
  feature_code,
  upstream_route_measure,
  upstream_area_ha,
  stream_order_parent,
  stream_order_max,
  map_upstream,
  channel_width,
  mad_m3s,
  barriers_anthropogenic_dnstr,
  barriers_pscis_dnstr,
  barriers_dams_dnstr,
  barriers_dams_hydro_dnstr,
  barriers_ch_cm_co_pk_sk_dnstr,
  crossings_dnstr,
  dam_dnstr_ind,
  dam_hydro_dnstr_ind,
  remediated_dnstr_ind,
  obsrvtn_event_upstr,
  obsrvtn_species_codes_upstr,
  species_codes_dnstr,
  access_sk as access,
  spawning_sk as spawning,
  rearing_sk as rearing,
  mapping_code_sk as mapping_code,
  geom
from bcfishpass.streams_vw
where access_sk > 0;


create view bcfishpass.streams_st_vw as
select
  segmented_stream_id,
  linear_feature_id,
  edge_type,
  blue_line_key,
  watershed_key,
  watershed_group_code,
  downstream_route_measure,
  length_metre,
  waterbody_key,
  gnis_name,
  stream_order,
  stream_magnitude,
  gradient,
  feature_code,
  upstream_route_measure,
  upstream_area_ha,
  stream_order_parent,
  stream_order_max,
  map_upstream,
  channel_width,
  mad_m3s,
  barriers_anthropogenic_dnstr,
  barriers_pscis_dnstr,
  barriers_dams_dnstr,
  barriers_dams_hydro_dnstr,
  barriers_st_dnstr,
  crossings_dnstr,
  dam_dnstr_ind,
  dam_hydro_dnstr_ind,
  remediated_dnstr_ind,
  obsrvtn_event_upstr,
  obsrvtn_species_codes_upstr,
  species_codes_dnstr,
  access_st as access,
  spawning_st as spawning,
  rearing_st as rearing,
  mapping_code_st as mapping_code,
  geom
from bcfishpass.streams_vw
where access_st > 0;


create view bcfishpass.streams_wct_vw as
select
  segmented_stream_id,
  linear_feature_id,
  edge_type,
  blue_line_key,
  watershed_key,
  watershed_group_code,
  downstream_route_measure,
  length_metre,
  waterbody_key,
  gnis_name,
  stream_order,
  stream_magnitude,
  gradient,
  feature_code,
  upstream_route_measure,
  upstream_area_ha,
  stream_order_parent,
  stream_order_max,
  map_upstream,
  channel_width,
  mad_m3s,
  barriers_anthropogenic_dnstr,
  barriers_pscis_dnstr,
  barriers_dams_dnstr,
  barriers_dams_hydro_dnstr,
  barriers_wct_dnstr,
  crossings_dnstr,
  dam_dnstr_ind,
  dam_hydro_dnstr_ind,
  remediated_dnstr_ind,
  obsrvtn_event_upstr,
  obsrvtn_species_codes_upstr,
  species_codes_dnstr,
  access_wct as access,
  spawning_wct as spawning,
  rearing_wct as rearing,
  mapping_code_wct as mapping_code,
  geom
from bcfishpass.streams_vw
where access_wct > 0;



-- CWF WCRP - summarize spawning/rearing/spawning&rearing habitat lengths per group, by accessibility

create view bcfishpass.wcrp_habitat_connectivity_status_vw as
with length_totals as
(
-- all spawning (ch/co/st/sk/wct) - calculation is simple, just add it up
-- ---------------
  SELECT
    s.watershed_group_code,
    'SPAWNING' as habitat_type,
    coalesce(round((SUM(ST_Length(s.geom)) FILTER (
      WHERE
      (h.spawning_ch > 0 and w.ch IS TRUE) OR
      (h.spawning_co > 0 AND w.co IS TRUE) OR
      (h.spawning_st > 0 AND w.st IS TRUE) OR
      (h.spawning_sk > 0 AND w.sk IS TRUE) OR
      (h.spawning_wct > 0 AND w.wct IS TRUE)
    ) / 1000)::numeric, 2), 0) as total_km,

    -- spawning accessible
    coalesce(round((SUM(ST_Length(s.geom)) FILTER (
      WHERE (
        (h.spawning_ch > 0 and w.ch IS TRUE) OR
        (h.spawning_co > 0 AND w.co IS TRUE) OR
        (h.spawning_st > 0 AND w.st IS TRUE) OR
        (h.spawning_sk > 0 AND w.sk IS TRUE) OR
        (h.spawning_wct > 0 AND w.wct IS TRUE)
      )
      AND a.barriers_anthropogenic_dnstr IS NULL
    ) / 1000)::numeric, 2), 0) as accessible_km
  from bcfishpass.streams s
  inner join bcfishpass.streams_habitat_linear_vw h using (segmented_stream_id)
  inner join bcfishpass.streams_access_vw a using (segmented_stream_id)
  inner join bcfishpass.wcrp_watersheds w on s.watershed_group_code = w.watershed_group_code -- WCRP watersheds only
  group by s.watershed_group_code

  UNION ALL

-- REARING length
-- --------------
-- rearing is more complex, add an extra .5 for CO/SK rearing in wetlands/lakes respectively

  SELECT
    s.watershed_group_code,
    'REARING' as habitat_type,
    round(
      (
        (
          coalesce(SUM(ST_Length(geom)) FILTER (
            WHERE
            (h.rearing_ch > 0 AND w.ch IS TRUE) OR
            (h.rearing_st > 0 AND w.st IS TRUE) OR
            (h.rearing_sk > 0 AND w.sk IS TRUE) OR
            (h.rearing_co > 0 AND w.co IS TRUE) OR
            (h.rearing_wct > 0 AND w.wct IS TRUE)
          ), 0) +
          -- add .5 coho rearing in wetlands
          coalesce(SUM(ST_Length(s.geom) * .5) FILTER (WHERE h.rearing_co > 0 AND w.co IS TRUE AND s.edge_type = 1050), 0) +
          -- add .5 sockeye rearing in lakes (all of it)
          coalesce(SUM(ST_Length(s.geom) * .5) FILTER (WHERE h.spawning_sk > 0 AND w.co IS TRUE), 0)
        ) / 1000)::numeric, 2
      ) AS total_km,

    -- rearing accessible
    round(
      (
        (
          coalesce(SUM(ST_Length(geom)) FILTER (
            WHERE (
              (h.rearing_ch > 0 AND w.ch IS TRUE) OR
              (h.rearing_co > 0 AND w.co IS TRUE) OR
              (h.rearing_st > 0 AND w.st IS TRUE) OR
              (h.rearing_sk > 0 AND w.sk IS TRUE) OR
              (h.rearing_wct > 0 AND w.wct IS TRUE)
            )
            AND a.barriers_anthropogenic_dnstr IS NULL
          ), 0) +
          -- add .5 coho rearing in wetlands
          coalesce(SUM(ST_Length(geom) * .5) FILTER (WHERE h.rearing_co > 0 AND w.co IS TRUE AND edge_type = 1050 AND barriers_anthropogenic_dnstr IS NULL), 0) +
          -- add .5 sockeye rearing in lakes (all of it)
          coalesce(SUM(ST_Length(geom) * .5) FILTER (WHERE h.spawning_sk > 0 AND w.sk IS TRUE AND barriers_anthropogenic_dnstr IS NULL), 0)
        ) / 1000)::numeric, 2
    ) AS accessible_km
  from bcfishpass.streams s
  inner join bcfishpass.streams_habitat_linear_vw h using (segmented_stream_id)
  inner join bcfishpass.streams_access_vw a using (segmented_stream_id)
  inner join bcfishpass.wcrp_watersheds w on s.watershed_group_code = w.watershed_group_code -- WCRP watersheds only
  group by s.watershed_group_code

  UNION ALL

  -- spawning or rearing - total km of habitat
  SELECT
    s.watershed_group_code,
    'ALL' as habitat_type,
    round(
    (
      (
        coalesce(SUM(ST_Length(s.geom)) FILTER (
          WHERE
            (h.spawning_ch > 0 AND w.ch IS TRUE) OR
            (h.spawning_co > 0 AND w.co IS TRUE) OR
            (h.spawning_st > 0 AND w.st IS TRUE) OR
            (h.spawning_sk > 0 AND w.sk IS TRUE) OR
            (h.spawning_wct > 0 AND w.wct IS TRUE) OR
            (h.rearing_ch > 0 AND w.ch IS TRUE) OR
            (h.rearing_co > 0 AND w.co IS TRUE) OR
            (h.rearing_st > 0 AND w.st IS TRUE) OR
            (h.rearing_sk > 0 AND w.sk IS TRUE) OR
            (h.rearing_wct > 0 AND w.wct IS TRUE)
          ), 0) +
        -- add .5 coho rearing in wetlands
        coalesce(SUM(ST_Length(s.geom) * .5) FILTER (WHERE h.rearing_co > 0 AND w.co IS TRUE AND s.edge_type = 1050), 0) +
        -- add .5 sockeye rearing in lakes (all of it)
        coalesce(SUM(ST_Length(geom) * .5) FILTER (WHERE h.spawning_sk > 0 AND w.sk IS TRUE), 0)
      ) / 1000)::numeric, 2
    ) AS total_km,

  -- total acccessible km
   round(
    (
      (
        coalesce(SUM(ST_Length(geom)) FILTER (
          WHERE (
            (h.spawning_ch > 0 AND w.ch IS TRUE) OR
            (h.spawning_co > 0 AND w.co IS TRUE) OR
            (h.spawning_st > 0 AND w.st IS TRUE) OR
            (h.spawning_sk > 0 AND w.sk IS TRUE) OR
            (h.spawning_wct > 0 AND w.wct IS TRUE) OR
            (h.rearing_ch > 0 AND w.ch IS TRUE) OR
            (h.rearing_co > 0 AND w.co IS TRUE) OR
            (h.rearing_st > 0 AND w.st IS TRUE) OR
            (h.rearing_sk > 0 AND w.sk IS TRUE) OR
            (h.rearing_wct > 0 AND w.wct IS TRUE)
          )
          AND a.barriers_anthropogenic_dnstr IS NULL), 0) +
        -- add .5 coho rearing in wetlands
        coalesce(SUM(ST_Length(geom) * .5) FILTER (WHERE h.rearing_co > 0 AND edge_type = 1050 AND a.barriers_anthropogenic_dnstr IS NULL), 0) +
        -- add .5 sockeye rearing in lakes (all of it)
        coalesce(SUM(ST_Length(geom) * .5) FILTER (WHERE h.spawning_sk > 0 AND a.barriers_anthropogenic_dnstr IS NULL), 0)
      ) / 1000)::numeric, 2
    ) AS accessible_km
  from bcfishpass.streams s
  inner join bcfishpass.streams_habitat_linear_vw h using (segmented_stream_id)
  inner join bcfishpass.streams_access_vw a using (segmented_stream_id)
  inner join bcfishpass.wcrp_watersheds w on s.watershed_group_code = w.watershed_group_code -- WCRP watersheds only
  group by s.watershed_group_code

  UNION ALL

  -- Upstream of Elko Dam
  SELECT
    s.watershed_group_code,
    'UPSTREAM_ELKO' as habitat_type,
    round(
      (
        (
          coalesce(SUM(ST_Length(s.geom)) FILTER (
            WHERE
              (h.spawning_wct > 0 AND w.wct IS TRUE) OR
              (h.rearing_wct > 0 AND w.wct IS TRUE)
          ), 0)
        ) / 1000)::numeric, 2
      ) AS total_km,

  -- total acccessible km
    round(
      (
        (
          coalesce(SUM(ST_Length(geom)) FILTER (
            WHERE (
              (h.spawning_wct > 0 AND w.wct IS TRUE) OR
              (h.rearing_wct > 0 AND w.wct IS TRUE)
            )
            AND a.barriers_anthropogenic_dnstr = (select barriers_anthropogenic_dnstr
                from bcfishpass.streams s
                inner join bcfishpass.streams_habitat_linear_vw h using (segmented_stream_id)
                inner join bcfishpass.streams_access_vw a using (segmented_stream_id)
                where segmented_stream_id like '356570562.22912000')), 0)
    ) / 1000)::numeric, 2
    ) AS accessible_km
  from bcfishpass.streams s
  inner join bcfishpass.streams_habitat_linear_vw h using (segmented_stream_id)
  inner join bcfishpass.streams_access_vw a using (segmented_stream_id)
  inner join bcfishpass.wcrp_watersheds w on s.watershed_group_code = w.watershed_group_code -- WCRP watersheds only
  where FWA_Upstream(356570562, 22910, 22910, '300.625474.584724'::ltree, '300.625474.584724.100997'::ltree, blue_line_key, downstream_route_measure, wscode_ltree, localcode_ltree) -- only above Elko Dam
  group by s.watershed_group_code

UNION ALL
  -- Downstream of Elko Dam
  SELECT
    s.watershed_group_code,
    'DOWNSTREAM_ELKO' as habitat_type,
    round(
      (
        (
          coalesce(SUM(ST_Length(s.geom)) FILTER (
            WHERE
              (h.spawning_wct > 0 AND w.wct IS TRUE) OR
              (h.rearing_wct > 0 AND w.wct IS TRUE)
          ), 0)
        ) / 1000)::numeric, 2
      ) AS total_km,

  -- total acccessible km
    round(
      (
        (
          coalesce(SUM(ST_Length(geom)) FILTER (
            WHERE (
              (h.spawning_wct > 0 AND w.wct IS TRUE) OR
              (h.rearing_wct > 0 AND w.wct IS TRUE)
            )
      AND a.barriers_anthropogenic_dnstr IS NULL
      AND a.barriers_wct_dnstr = array[]::text[]
      OR a.barriers_anthropogenic_dnstr = (select distinct barriers_anthropogenic_dnstr
                          from bcfishpass.streams s
                          inner join bcfishpass.streams_habitat_linear_vw h using (segmented_stream_id)
                          inner join bcfishpass.streams_access_vw a using (segmented_stream_id)
                          where linear_feature_id = 706872063)), 0)
    ) / 1000)::numeric, 2
    ) AS accessible_km
  from bcfishpass.streams s
  inner join bcfishpass.streams_habitat_linear_vw h using (segmented_stream_id)
  inner join bcfishpass.streams_access_vw a using (segmented_stream_id)
  inner join bcfishpass.wcrp_watersheds w on s.watershed_group_code = w.watershed_group_code -- WCRP watersheds only
  where wscode_ltree <@ '300.625474.584724'::ltree  -- on the elk system and not above elko dam
  AND NOT FWA_Upstream(356570562, 22910, 22910, '300.625474.584724'::ltree, '300.625474.584724.100997'::ltree, blue_line_key, downstream_route_measure, wscode_ltree, localcode_ltree)
  group by s.watershed_group_code
)

select
  watershed_group_code,
  habitat_type,
  total_km,
  accessible_km,
  round((accessible_km / (total_km + .0001)) * 100, 2) as pct_accessible  -- add small amt to avoid division by zero
from length_totals
order by watershed_group_code, habitat_type desc;


-- =================================================================
-- =================================================================
-- recreate unchanged dependent views
-- =================================================================
-- =================================================================

-- counts of anthropogenic barriers upstream per access model
-- (for example, number of barriers on steelhead accessible stream upstream of given barrier)
create materialized view bcfishpass.crossings_upstr_barriers_per_model_vw as

with access_models as (
  select
    c.aggregated_crossings_id,
    a.barriers_bt_dnstr,
    a.barriers_ch_cm_co_pk_sk_dnstr,
    a.barriers_ct_dv_rb_dnstr,
    a.barriers_st_dnstr,
    a.barriers_wct_dnstr
  from bcfishpass.crossings c
  left outer join bcfishpass.streams s ON s.blue_line_key = c.blue_line_key
  AND round(s.downstream_route_measure::numeric, 4) <= round(c.downstream_route_measure::numeric, 4)
  AND round(s.upstream_route_measure::numeric, 4) > round(c.downstream_route_measure::numeric, 4)
  AND s.watershed_group_code = c.watershed_group_code
  left outer join bcfishpass.streams_access_vw a on s.segmented_stream_id = a.segmented_stream_id
),

barriers_unnested as (
  select
    a.aggregated_crossings_id,
    unnest(a.features_upstr) as barrier_upstr
    from bcfishpass.crossings_upstr_barriers_anthropogenic a
),

barriers_upstr as (
  select
    b.aggregated_crossings_id,
    b.barrier_upstr,
    m.barriers_bt_dnstr,
    m.barriers_ch_cm_co_pk_sk_dnstr,
    m.barriers_ct_dv_rb_dnstr,
    m.barriers_st_dnstr,
    m.barriers_wct_dnstr
  from barriers_unnested b
  left outer join access_models m on b.barrier_upstr = m.aggregated_crossings_id
),

barriers_upstr_per_model as (
  select
    c.aggregated_crossings_id,
    array_agg(barrier_upstr) filter (where u.barriers_bt_dnstr = array[]::text[]) as barriers_upstr_bt,
    array_agg(barrier_upstr) filter (where u.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]) as barriers_upstr_ch_cm_co_pk_sk,
    array_agg(barrier_upstr) filter (where u.barriers_ct_dv_rb_dnstr = array[]::text[]) as barriers_upstr_ct_dv_rb,
    array_agg(barrier_upstr) filter (where u.barriers_st_dnstr = array[]::text[]) as barriers_upstr_st,
    array_agg(barrier_upstr) filter (where u.barriers_wct_dnstr = array[]::text[]) as barriers_upstr_wct
  from bcfishpass.crossings c
  inner join barriers_upstr u on c.aggregated_crossings_id = u.aggregated_crossings_id
  group by c.aggregated_crossings_id
)

select
 c.aggregated_crossings_id            ,
 bpm.barriers_upstr_bt                ,
 bpm.barriers_upstr_ch_cm_co_pk_sk    ,
 bpm.barriers_upstr_ct_dv_rb          ,
 bpm.barriers_upstr_st                ,
 bpm.barriers_upstr_wct
from bcfishpass.crossings c
left outer join barriers_upstr_per_model bpm
on c.aggregated_crossings_id = bpm.aggregated_crossings_id;

create unique index on bcfishpass.crossings_upstr_barriers_per_model_vw (aggregated_crossings_id);


-- final output crossings view -
-- join crossings table to streams / access / habitat tables
-- and convert array types to text for easier dumps
create materialized view bcfishpass.crossings_vw as
select
  -- joining to streams based on measure can be error prone due to precision.
  -- Join to streams on linear_feature_id and keep the first result
  -- (since streams are segmented there is often >1 match)
  distinct on (c.aggregated_crossings_id)
  c.aggregated_crossings_id,
  c.stream_crossing_id,
  c.dam_id,
  c.user_barrier_anthropogenic_id,
  c.modelled_crossing_id,
  c.crossing_source,
  cft.crossing_feature_type,
  c.pscis_status,
  c.crossing_type_code,
  c.crossing_subtype_code,
  array_to_string(c.modelled_crossing_type_source, ';') as modelled_crossing_type_source,
  c.barrier_status,
  c.pscis_road_name,
  c.pscis_stream_name,
  c.pscis_assessment_comment,
  c.pscis_assessment_date,
  c.pscis_final_score,
  c.transport_line_structured_name_1,
  c.transport_line_type_description,
  c.transport_line_surface_description,
  c.ften_forest_file_id,
  c.ften_road_section_id,
  c.ften_file_type_description,
  c.ften_client_number,
  c.ften_client_name,
  c.ften_life_cycle_status_code,
  c.ften_map_label,
  c.rail_track_name,
  c.rail_owner_name,
  c.rail_operator_english_name,
  c.ogc_proponent,
  c.dam_name,
  c.dam_height,
  c.dam_owner,
  c.dam_use,
  c.dam_operating_status,
  c.utm_zone,
  c.utm_easting,
  c.utm_northing,
  t.map_tile_display_name as dbm_mof_50k_grid,
  c.linear_feature_id,
  c.blue_line_key,
  c.watershed_key,
  c.downstream_route_measure,
  c.wscode_ltree as wscode,
  c.localcode_ltree as localcode,
  c.watershed_group_code,
  c.gnis_stream_name,
  c.stream_order,
  c.stream_magnitude,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(cdo.observedspp_dnstr, ';') as observedspp_dnstr,
  array_to_string(cuo.observedspp_upstr, ';') as observedspp_upstr,
  array_to_string(cd.features_dnstr, ';') as crossings_dnstr,
  array_to_string(ad.features_dnstr, ';') as barriers_anthropogenic_dnstr,
  coalesce(array_length(ad.features_dnstr, 1), 0) as barriers_anthropogenic_dnstr_count,
  array_to_string(au.features_upstr, ';') as barriers_anthropogenic_upstr,
  coalesce(array_length(au.features_upstr, 1), 0) as barriers_anthropogenic_upstr_count,
  array_to_string(aum.barriers_upstr_bt, ';') as barriers_anthropogenic_bt_upstr,
  coalesce(array_length(aum.barriers_upstr_bt, 1), 0) as barriers_anthropogenic_upstr_bt_count,
  array_to_string(aum.barriers_upstr_ch_cm_co_pk_sk, ';') as barriers_anthropogenic_ch_cm_co_pk_sk_upstr,
  coalesce(array_length(aum.barriers_upstr_ch_cm_co_pk_sk, 1), 0) as barriers_anthropogenic_ch_cm_co_pk_sk_upstr_count,
  array_to_string(aum.barriers_upstr_st, ';') as barriers_anthropogenic_st_upstr,
  coalesce(array_length(aum.barriers_upstr_st, 1), 0) as barriers_anthropogenic_st_upstr_count,
  array_to_string(aum.barriers_upstr_wct, ';') as barriers_anthropogenic_wct_upstr,
  coalesce(array_length(aum.barriers_upstr_wct, 1), 0) as barriers_anthropogenic_wct_upstr_count,
  a.gradient,
  a.total_network_km,
  a.total_stream_km,
  a.total_lakereservoir_ha,
  a.total_wetland_ha,
  a.total_slopeclass03_waterbodies_km,
  a.total_slopeclass03_km,
  a.total_slopeclass05_km,
  a.total_slopeclass08_km,
  a.total_slopeclass15_km,
  a.total_slopeclass22_km,
  a.total_slopeclass30_km,
  a.total_belowupstrbarriers_network_km,
  a.total_belowupstrbarriers_stream_km,
  a.total_belowupstrbarriers_lakereservoir_ha,
  a.total_belowupstrbarriers_wetland_ha,
  a.total_belowupstrbarriers_slopeclass03_waterbodies_km,
  a.total_belowupstrbarriers_slopeclass03_km,
  a.total_belowupstrbarriers_slopeclass05_km,
  a.total_belowupstrbarriers_slopeclass08_km,
  a.total_belowupstrbarriers_slopeclass15_km,
  a.total_belowupstrbarriers_slopeclass22_km,
  a.total_belowupstrbarriers_slopeclass30_km,

  -- access models
  array_to_string(a.barriers_bt_dnstr, ';') as barriers_bt_dnstr,
  a.bt_network_km,
  a.bt_stream_km,
  a.bt_lakereservoir_ha,
  a.bt_wetland_ha,
  a.bt_slopeclass03_waterbodies_km,
  a.bt_slopeclass03_km,
  a.bt_slopeclass05_km,
  a.bt_slopeclass08_km,
  a.bt_slopeclass15_km,
  a.bt_slopeclass22_km,
  a.bt_slopeclass30_km,
  a.bt_belowupstrbarriers_network_km,
  a.bt_belowupstrbarriers_stream_km,
  a.bt_belowupstrbarriers_lakereservoir_ha,
  a.bt_belowupstrbarriers_wetland_ha,
  a.bt_belowupstrbarriers_slopeclass03_waterbodies_km,
  a.bt_belowupstrbarriers_slopeclass03_km,
  a.bt_belowupstrbarriers_slopeclass05_km,
  a.bt_belowupstrbarriers_slopeclass08_km,
  a.bt_belowupstrbarriers_slopeclass15_km,
  a.bt_belowupstrbarriers_slopeclass22_km,
  a.bt_belowupstrbarriers_slopeclass30_km,

  array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
  a.ch_cm_co_pk_sk_network_km,
  a.ch_cm_co_pk_sk_stream_km,
  a.ch_cm_co_pk_sk_lakereservoir_ha,
  a.ch_cm_co_pk_sk_wetland_ha,
  a.ch_cm_co_pk_sk_slopeclass03_waterbodies_km,
  a.ch_cm_co_pk_sk_slopeclass03_km,
  a.ch_cm_co_pk_sk_slopeclass05_km,
  a.ch_cm_co_pk_sk_slopeclass08_km,
  a.ch_cm_co_pk_sk_slopeclass15_km,
  a.ch_cm_co_pk_sk_slopeclass22_km,
  a.ch_cm_co_pk_sk_slopeclass30_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_network_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_stream_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha,
  a.ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km,
  a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km,

  array_to_string(a.barriers_st_dnstr, ';') as barriers_st_dnstr,
  a.st_network_km,
  a.st_stream_km,
  a.st_lakereservoir_ha,
  a.st_wetland_ha,
  a.st_slopeclass03_waterbodies_km,
  a.st_slopeclass03_km,
  a.st_slopeclass05_km,
  a.st_slopeclass08_km,
  a.st_slopeclass15_km,
  a.st_slopeclass22_km,
  a.st_slopeclass30_km,
  a.st_belowupstrbarriers_network_km,
  a.st_belowupstrbarriers_stream_km,
  a.st_belowupstrbarriers_lakereservoir_ha,
  a.st_belowupstrbarriers_wetland_ha,
  a.st_belowupstrbarriers_slopeclass03_waterbodies_km,
  a.st_belowupstrbarriers_slopeclass03_km,
  a.st_belowupstrbarriers_slopeclass05_km,
  a.st_belowupstrbarriers_slopeclass08_km,
  a.st_belowupstrbarriers_slopeclass15_km,
  a.st_belowupstrbarriers_slopeclass22_km,
  a.st_belowupstrbarriers_slopeclass30_km,

  array_to_string(a.barriers_wct_dnstr, ';') as barriers_wct_dnstr,
  a.wct_network_km,
  a.wct_stream_km,
  a.wct_lakereservoir_ha,
  a.wct_wetland_ha,
  a.wct_slopeclass03_waterbodies_km,
  a.wct_slopeclass03_km,
  a.wct_slopeclass05_km,
  a.wct_slopeclass08_km,
  a.wct_slopeclass15_km,
  a.wct_slopeclass22_km,
  a.wct_slopeclass30_km,
  a.wct_belowupstrbarriers_network_km,
  a.wct_belowupstrbarriers_stream_km,
  a.wct_belowupstrbarriers_lakereservoir_ha,
  a.wct_belowupstrbarriers_wetland_ha,
  a.wct_belowupstrbarriers_slopeclass03_waterbodies_km,
  a.wct_belowupstrbarriers_slopeclass03_km,
  a.wct_belowupstrbarriers_slopeclass05_km,
  a.wct_belowupstrbarriers_slopeclass08_km,
  a.wct_belowupstrbarriers_slopeclass15_km,
  a.wct_belowupstrbarriers_slopeclass22_km,
  a.wct_belowupstrbarriers_slopeclass30_km,

  -- habitat models
  h.bt_spawning_km,
  h.bt_rearing_km,
  h.bt_spawning_belowupstrbarriers_km,
  h.bt_rearing_belowupstrbarriers_km,
  h.ch_spawning_km,
  h.ch_rearing_km,
  h.ch_spawning_belowupstrbarriers_km,
  h.ch_rearing_belowupstrbarriers_km,
  h.cm_spawning_km,
  h.cm_spawning_belowupstrbarriers_km,
  h.co_spawning_km,
  h.co_rearing_km,
  h.co_rearing_ha,
  h.co_spawning_belowupstrbarriers_km,
  h.co_rearing_belowupstrbarriers_km,
  h.co_rearing_belowupstrbarriers_ha,
  h.pk_spawning_km,
  h.pk_spawning_belowupstrbarriers_km,
  h.sk_spawning_km,
  h.sk_rearing_km,
  h.sk_rearing_ha,
  h.sk_spawning_belowupstrbarriers_km,
  h.sk_rearing_belowupstrbarriers_km,
  h.sk_rearing_belowupstrbarriers_ha,
  h.st_spawning_km,
  h.st_rearing_km,
  h.st_spawning_belowupstrbarriers_km,
  h.st_rearing_belowupstrbarriers_km,
  h.wct_spawning_km,
  h.wct_rearing_km,
  h.wct_spawning_belowupstrbarriers_km,
  h.wct_rearing_belowupstrbarriers_km,
  c.geom
from bcfishpass.crossings c
inner join bcfishpass.crossings_feature_type_vw cft on c.aggregated_crossings_id = cft.aggregated_crossings_id
left outer join bcfishpass.crossings_dnstr_observations_vw cdo on c.aggregated_crossings_id = cdo.aggregated_crossings_id
left outer join bcfishpass.crossings_upstr_observations_vw cuo on c.aggregated_crossings_id = cuo.aggregated_crossings_id
left outer join bcfishpass.crossings_dnstr_crossings cd on c.aggregated_crossings_id = cd.aggregated_crossings_id
left outer join bcfishpass.crossings_dnstr_barriers_anthropogenic ad on c.aggregated_crossings_id = ad.aggregated_crossings_id
left outer join bcfishpass.crossings_upstr_barriers_anthropogenic au on c.aggregated_crossings_id = au.aggregated_crossings_id
left outer join bcfishpass.crossings_upstr_barriers_per_model_vw aum on c.aggregated_crossings_id = aum.aggregated_crossings_id
left outer join bcfishpass.crossings_upstream_access a on c.aggregated_crossings_id = a.aggregated_crossings_id
left outer join bcfishpass.crossings_upstream_habitat h on c.aggregated_crossings_id = h.aggregated_crossings_id
left outer join bcfishpass.streams s on c.linear_feature_id = s.linear_feature_id
left outer join whse_basemapping.dbm_mof_50k_grid t ON ST_Intersects(c.geom, t.geom)
order by c.aggregated_crossings_id, s.downstream_route_measure;

create unique index on bcfishpass.crossings_vw (aggregated_crossings_id);
create index on bcfishpass.crossings_vw using gist (geom);


create view bcfishpass.freshwater_fish_habitat_accessibility_model_vw as
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
  case
    when access_salmon = 2 then 'OBSERVED'
    when access_salmon = 1 then 'INFERRED'
    when access_salmon = 0 then 'NATURAL_BARRIER'
    else NULL
  end as model_access_salmon,
  case
    when access_st = 2 then 'OBSERVED'
    when access_st = 1 then 'INFERRED'
    when access_st = 0 then 'NATURAL_BARRIER'
    else NULL
  end as model_access_steelhead,
  array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
  array_to_string(a.barriers_st_dnstr, ';') as barriers_st_dnstr,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access_vw a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear_vw h on s.segmented_stream_id = h.segmented_stream_id;

create view bcfishpass.freshwater_fish_habitat_accessibility_model_crossings_vw as
select
 c.aggregated_crossings_id,
 c.stream_crossing_id,
 c.dam_id,
 c.user_barrier_anthropogenic_id,
 c.modelled_crossing_id,
 c.crossing_source,
 c.crossing_feature_type,
 c.pscis_status,
 c.crossing_type_code,
 c.crossing_subtype_code,
 c.modelled_crossing_type_source,
 c.barrier_status,
 c.pscis_road_name,
 c.pscis_stream_name,
 c.pscis_assessment_comment,
 c.pscis_assessment_date,
 c.pscis_final_score,
 c.transport_line_structured_name_1,
 c.transport_line_type_description,
 c.transport_line_surface_description,
 c.ften_forest_file_id,
 c.ften_file_type_description,
 c.ften_client_number,
 c.ften_client_name,
 c.ften_life_cycle_status_code,
 c.rail_track_name,
 c.rail_owner_name,
 c.rail_operator_english_name,
 c.ogc_proponent,
 c.dam_name,
 c.dam_height,
 c.dam_owner,
 c.dam_use,
 c.dam_operating_status,
 c.utm_zone,
 c.utm_easting,
 c.utm_northing,
 c.dbm_mof_50k_grid,
 c.linear_feature_id,
 c.blue_line_key,
 c.watershed_key,
 c.downstream_route_measure,
 c.wscode,
 c.localcode,
 c.watershed_group_code,
 c.gnis_stream_name,
 c.stream_order,
 c.stream_magnitude,
 c.observedspp_dnstr,
 c.observedspp_upstr,
 c.crossings_dnstr,
 c.barriers_anthropogenic_dnstr,
 c.barriers_anthropogenic_dnstr_count,
 c.barriers_anthropogenic_upstr,
 c.barriers_anthropogenic_upstr_count,
 c.barriers_anthropogenic_ch_cm_co_pk_sk_upstr,
 c.barriers_anthropogenic_ch_cm_co_pk_sk_upstr_count,
 c.barriers_anthropogenic_st_upstr,
 c.barriers_anthropogenic_st_upstr_count,
 c.gradient,
 c.total_network_km,
 c.total_stream_km,
 c.total_lakereservoir_ha,
 c.total_wetland_ha,
 c.total_slopeclass03_waterbodies_km,
 c.total_slopeclass03_km,
 c.total_slopeclass05_km,
 c.total_slopeclass08_km,
 c.total_slopeclass15_km,
 c.total_slopeclass22_km,
 c.total_slopeclass30_km,
 c.total_belowupstrbarriers_network_km,
 c.total_belowupstrbarriers_stream_km,
 c.total_belowupstrbarriers_lakereservoir_ha,
 c.total_belowupstrbarriers_wetland_ha,
 c.total_belowupstrbarriers_slopeclass03_waterbodies_km,
 c.total_belowupstrbarriers_slopeclass03_km,
 c.total_belowupstrbarriers_slopeclass05_km,
 c.total_belowupstrbarriers_slopeclass08_km,
 c.total_belowupstrbarriers_slopeclass15_km,
 c.total_belowupstrbarriers_slopeclass22_km,
 c.total_belowupstrbarriers_slopeclass30_km,
 c.barriers_ch_cm_co_pk_sk_dnstr,
 c.ch_cm_co_pk_sk_network_km,
 c.ch_cm_co_pk_sk_stream_km,
 c.ch_cm_co_pk_sk_lakereservoir_ha,
 c.ch_cm_co_pk_sk_wetland_ha,
 c.ch_cm_co_pk_sk_slopeclass03_waterbodies_km,
 c.ch_cm_co_pk_sk_slopeclass03_km,
 c.ch_cm_co_pk_sk_slopeclass05_km,
 c.ch_cm_co_pk_sk_slopeclass08_km,
 c.ch_cm_co_pk_sk_slopeclass15_km,
 c.ch_cm_co_pk_sk_slopeclass22_km,
 c.ch_cm_co_pk_sk_slopeclass30_km,
 c.ch_cm_co_pk_sk_belowupstrbarriers_network_km,
 c.ch_cm_co_pk_sk_belowupstrbarriers_stream_km,
 c.ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha,
 c.ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha,
 c.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km,
 c.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km,
 c.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km,
 c.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km,
 c.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km,
 c.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km,
 c.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km,
 c.barriers_st_dnstr,
 c.st_network_km,
 c.st_stream_km,
 c.st_lakereservoir_ha,
 c.st_wetland_ha,
 c.st_slopeclass03_waterbodies_km,
 c.st_slopeclass03_km,
 c.st_slopeclass05_km,
 c.st_slopeclass08_km,
 c.st_slopeclass15_km,
 c.st_slopeclass22_km,
 c.st_slopeclass30_km,
 c.st_belowupstrbarriers_network_km,
 c.st_belowupstrbarriers_stream_km,
 c.st_belowupstrbarriers_lakereservoir_ha,
 c.st_belowupstrbarriers_wetland_ha,
 c.st_belowupstrbarriers_slopeclass03_waterbodies_km,
 c.st_belowupstrbarriers_slopeclass03_km,
 c.st_belowupstrbarriers_slopeclass05_km,
 c.st_belowupstrbarriers_slopeclass08_km,
 c.st_belowupstrbarriers_slopeclass15_km,
 c.st_belowupstrbarriers_slopeclass22_km,
 c.st_belowupstrbarriers_slopeclass30_km,
 c.geom
 from bcfishpass.crossings_vw c;


create materialized view bcfishpass.fptwg_summary_crossings_vw as
select
  l.assmnt_watershed_id as watershed_feature_id,
  count(*) as n_crossings_total,
  count(*) filter (where crossing_feature_type = 'DAM') as n_dam,
  count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'PASSABLE') as n_dam_passable,
  count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'POTENTIAL') as n_dam_potential,
  count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'UNKNOWN') as n_dam_unknown,
  count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'BARRIER') as n_dam_barrier,
  count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'BARRIER' and barriers_ch_cm_co_pk_sk_dnstr = '') as n_dam_barrier_salmon,
  count(*) filter (where crossing_feature_type = 'DAM' and barrier_status = 'BARRIER' and barriers_st_dnstr = '') as n_dam_barrier_steelhead,
  count(*) filter (where crossing_source = 'PSCIS' and pscis_status = 'ASSESSED') as n_pscisassessment,
  count(*) filter (where crossing_source = 'PSCIS' and pscis_status = 'HABITAT CONFIRMATION') as n_pscisconfirmation,
  count(*) filter (where crossing_source = 'PSCIS' and pscis_status = 'DESIGN') as n_pscisdesign,
  count(*) filter (where crossing_source = 'PSCIS' and pscis_status = 'REMEDIATED') as n_pscisremediation,
  count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'PASSABLE') as n_pscis_passable,
  count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'POTENTIAL') as n_pscis_potential,
  count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'UNKNOWN') as n_pscis_unknown,
  count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'BARRIER') as n_pscis_barrier,
  count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'BARRIER' and barriers_ch_cm_co_pk_sk_dnstr = '') as n_pscis_barrier_salmon,
  count(*) filter (where crossing_source = 'PSCIS' and barrier_status = 'BARRIER' and barriers_st_dnstr = '') as n_pscis_barrier_steelhead,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS') as n_modelledxings,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'PASSABLE') as n_modelledxings_passable,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'POTENTIAL') as n_modelledxings_potential,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'UNKNOWN') as n_modelledxings_unknown,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'BARRIER') as n_modelledxings_barrier,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'BARRIER' and barriers_ch_cm_co_pk_sk_dnstr = '') as n_modelledxings_barrier_salmon,
  count(*) filter (where crossing_source = 'MODELLED CROSSINGS' and barrier_status = 'BARRIER' and barriers_st_dnstr = '') as n_modelledxings_barrier_steelhead,
  count(*) filter (where crossing_source = 'MISC BARRIERS') as n_miscbarriers,
  count(*) filter (where crossing_source = 'MISC BARRIERS' and barrier_status = 'BARRIER' and barriers_ch_cm_co_pk_sk_dnstr = '') as n_miscbarriers_barrier_salmon,
  count(*) filter (where crossing_source = 'MISC BARRIERS' and barrier_status = 'BARRIER' and barriers_st_dnstr = '') as n_miscbarriers_barrier_steelhead
from bcfishpass.crossings_vw c
inner join whse_basemapping.fwa_assessment_watersheds_streams_lut l on c.linear_feature_id = l.linear_feature_id
group by l.assmnt_watershed_id;
create index on bcfishpass.fptwg_summary_crossings_vw (watershed_feature_id);


COMMIT;