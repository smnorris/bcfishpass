-- access - view of stream data plus downstream barrier info
-- modified to include "access" columns with codes 0/1/2 (inaccessible/modelled/observed)
Drop materialized view bcfishpass.streams_access_vw2 cascade;


create materialized view bcfishpass.streams_access_vw2 as
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
     when b.barriers_bt_dnstr is null and 'BT' != any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 1
     when b.barriers_bt_dnstr is not null and wsg_bt.watershed_group_code is not null then 0
   end as access_bt,
   case
     when wsg_salmon.watershed_group_code is null then -1
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'CH' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'CH' != any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 1
     when b.barriers_ch_cm_co_pk_sk_dnstr is not null and wsg_salmon.watershed_group_code is not null then 0
   end as access_ch,
   case
     when wsg_salmon.watershed_group_code is null then -1
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'CM' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'CM' != any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 1
     when b.barriers_ch_cm_co_pk_sk_dnstr is not null and wsg_salmon.watershed_group_code is not null then 0
   end as access_cm,
   case
     when wsg_salmon.watershed_group_code is null then -1
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'CO' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'CO' != any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 1
     when b.barriers_ch_cm_co_pk_sk_dnstr is not null and wsg_salmon.watershed_group_code is not null then 0
   end as access_co,
   case
     when wsg_salmon.watershed_group_code is null then -1
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'PK' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'PK' != any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 1
     when b.barriers_ch_cm_co_pk_sk_dnstr is not null and wsg_salmon.watershed_group_code is not null then 0
   end as access_pk,
   case
     when wsg_salmon.watershed_group_code is null then -1
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'SK' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
     when b.barriers_ch_cm_co_pk_sk_dnstr is null and 'SK' != any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 1
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
     when b.barriers_st_dnstr is null and 'SK' != any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 1
     when b.barriers_st_dnstr is not null and wsg_st.watershed_group_code is not null then 0
   end as access_st,
   case
     when wsg_wct.watershed_group_code is null then -1
     when b.barriers_wct_dnstr is null and 'WCT' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
     when b.barriers_wct_dnstr is null and 'WCT' != any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 1
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

--create unique index on bcfishpass.streams_access_vw (segmented_stream_id);

-- dependencies to alter
-- materialized view bcfishpass.streams_habitat_linear_vw depends on materialized view bcfishpass.streams_habitat_known_vw
-- materialized view bcfishpass.streams_mapping_code_vw depends on materialized view bcfishpass.streams_habitat_linear_vw
-- view bcfishpass.wcrp_habitat_connectivity_status_vw depends on materialized view bcfishpass.streams_habitat_linear_vw
-- view bcfishpass.streams_vw depends on materialized view bcfishpass.streams_habitat_known_vw
-- view bcfishpass.streams_bt_vw depends on materialized view bcfishpass.streams_habitat_known_vw
-- view bcfishpass.streams_ch_vw depends on materialized view bcfishpass.streams_habitat_known_vw
-- view bcfishpass.streams_cm_vw depends on materialized view bcfishpass.streams_habitat_known_vw
-- view bcfishpass.streams_co_vw depends on materialized view bcfishpass.streams_habitat_known_vw
-- view bcfishpass.streams_pk_vw depends on materialized view bcfishpass.streams_habitat_known_vw
-- view bcfishpass.streams_salmon_vw depends on materialized view bcfishpass.streams_habitat_known_vw
-- view bcfishpass.streams_sk_vw depends on materialized view bcfishpass.streams_habitat_known_vw
-- view bcfishpass.streams_st_vw depends on materialized view bcfishpass.streams_habitat_known_vw
-- view bcfishpass.streams_wct_vw depends on materialized view bcfishpass.streams_habitat_known_vw
-- HINT:  Use DROP ... CASCADE to drop the dependent objects too
-- drop materialized view bcfishpass.streams_habitat_known_vw cascade;


-- combine all modelled habitat tables and observed habitat table into a single spawning/rearing view
-- habitat columns have values:
-- 0 non habitat
-- 1 modelled habitat
-- 2 modelled and observed habitat
-- 3 observed habitat
drop materialized view bcfishpass.streams_habitat_linear_vw2;
create materialized view bcfishpass.streams_habitat_linear_vw2 as
select
  s.segmented_stream_id,
  case
    when bt.spawning is true and coalesce(u.spawning_bt, false) is false then 1
    when bt.spawning is true and coalesce(u.spawning_bt, false) is true then 2
    when bt.spawning is false and coalesce(u.spawning_bt, false) is true then 3
    else 0
  end as spawning_bt,
  case
    when ch.spawning is true and coalesce(u.spawning_ch, false) is false then 1
    when ch.spawning is true and coalesce(u.spawning_ch, false) is true then 2
    when ch.spawning is false and coalesce(u.spawning_ch, false) is true then 3
    else 0
  end as spawning_ch,
  case
    when cm.spawning is true and coalesce(u.spawning_cm, false) is false then 1
    when cm.spawning is true and coalesce(u.spawning_cm, false) is true then 2
    when cm.spawning is false and coalesce(u.spawning_cm, false) is true then 3
    else 0
  end as spawning_cm,
  case
    when co.spawning is true and coalesce(u.spawning_co, false) is false then 1
    when co.spawning is true and coalesce(u.spawning_co, false) is true then 2
    when co.spawning is false and coalesce(u.spawning_co, false) is true then 3
    else 0
  end as spawning_co,
  case
    when pk.spawning is true and coalesce(u.spawning_pk, false) is false then 1
    when pk.spawning is true and coalesce(u.spawning_pk, false) is true then 2
    when pk.spawning is false and coalesce(u.spawning_pk, false) is true then 3
    else 0
  end as spawning_pk,
  case
    when sk.spawning is true and coalesce(u.spawning_sk, false) is false then 1
    when sk.spawning is true and coalesce(u.spawning_sk, false) is true then 2
    when sk.spawning is false and coalesce(u.spawning_sk, false) is true then 3
    else 0
  end as spawning_sk,
  case
    when st.spawning is true and coalesce(u.spawning_st, false) is false then 1
    when st.spawning is true and coalesce(u.spawning_st, false) is true then 2
    when st.spawning is false and coalesce(u.spawning_st, false) is true then 3
    else 0
  end as spawning_st,
  case
    when wct.spawning is true and coalesce(u.spawning_wct, false) is false then 1
    when wct.spawning is true and coalesce(u.spawning_wct, false) is true then 2
    when wct.spawning is false and coalesce(u.spawning_wct, false) is true then 3
    else 0
  end as spawning_wct,

  case
    when bt.rearing is true and coalesce(u.rearing_bt, false) is false then 1
    when bt.rearing is true and coalesce(u.rearing_bt, false) is true then 2
    when bt.rearing is false and coalesce(u.rearing_bt, false) is true then 3
    else 0
  end as rearing_bt,
  case
    when ch.rearing is true and coalesce(u.rearing_ch, false) is false then 1
    when ch.rearing is true and coalesce(u.rearing_ch, false) is true then 2
    when ch.rearing is false and coalesce(u.rearing_ch, false) is true then 3
    else 0
  end as rearing_ch,
  case
    when co.rearing is true and coalesce(u.rearing_co, false) is false then 1
    when co.rearing is true and coalesce(u.rearing_co, false) is true then 2
    when co.rearing is false and coalesce(u.rearing_co, false) is true then 3
    else 0
  end as rearing_co,
  case
    when sk.rearing is true and coalesce(u.rearing_sk, false) is false then 1
    when sk.rearing is true and coalesce(u.rearing_sk, false) is true then 2
    when sk.rearing is false and coalesce(u.rearing_sk, false) is true then 3
    else 0
  end as rearing_sk,
  case
    when st.rearing is true and coalesce(u.rearing_st, false) is false then 1
    when st.rearing is true and coalesce(u.rearing_st, false) is true then 2
    when st.rearing is false and coalesce(u.rearing_st, false) is true then 3
    else 0
  end as rearing_st,
  case
    when wct.rearing is true and coalesce(u.rearing_wct, false) is false then 1
    when wct.rearing is true and coalesce(u.rearing_wct, false) is true then 2
    when wct.rearing is false and coalesce(u.rearing_wct, false) is true then 3
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

--create unique index on bcfishpass.streams_habitat_linear_vw (segmented_stream_id);


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

create materialized view bcfishpass.streams_mapping_code_vw2 as

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
inner join bcfishpass.streams_access_vw2 a on s.segmented_stream_id = a.segmented_stream_id
inner join bcfishpass.streams_habitat_linear_vw2 h on s.segmented_stream_id = h.segmented_stream_id;

--create unique index on bcfishpass.streams_mapping_code_vw2 (segmented_stream_id);


-- final output spatial streams view
drop view bcfishpass.streams_vw2;
create view bcfishpass.streams_vw2 as
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
  a.access_bt,
  a.access_ch,
  a.access_cm,
  a.access_co,
  a.access_pk,
  a.access_sk,
  a.access_st,
  a.access_wct,
  a.access_salmon,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
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
left outer join bcfishpass.streams_access_vw2 a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear_vw2 h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code_vw m on s.segmented_stream_id = m.segmented_stream_id

