begin; 
  truncate bcfishpass.streams_access;

  insert into bcfishpass.streams_access (
    segmented_stream_id,
    barriers_anthropogenic_dnstr,
    barriers_pscis_dnstr,
    barriers_dams_dnstr,
    barriers_dams_hydro_dnstr,
    barriers_bt_dnstr,
    barriers_ch_dnstr,
    barriers_cm_dnstr,
    barriers_co_dnstr,
    barriers_pk_dnstr,
    barriers_sk_dnstr,
    barriers_ct_dv_rb_dnstr,
    barriers_st_dnstr,
    barriers_wct_dnstr,
    access_bt,
    access_ch,
    access_cm,
    access_co,
    access_pk,
    access_sk,
    access_salmon,
    access_ct_dv_rb,
    access_st,
    access_wct,
    observation_key_upstr,
    obsrvtn_species_codes_upstr,
    species_codes_dnstr,
    crossings_dnstr,
    remediated_dnstr_ind,
    dam_dnstr_ind,
    dam_hydro_dnstr_ind
  )
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
       when b.barriers_ch_dnstr is not null then b.barriers_ch_dnstr
       when b.barriers_ch_dnstr is null and wsg_ch.watershed_group_code is not null then array[]::text[]
       when b.barriers_ch_dnstr is null and wsg_ch.watershed_group_code is null then null
     end as barriers_ch_dnstr,
     case
       when b.barriers_cm_dnstr is not null then b.barriers_cm_dnstr
       when b.barriers_cm_dnstr is null and wsg_cm.watershed_group_code is not null then array[]::text[]
       when b.barriers_cm_dnstr is null and wsg_cm.watershed_group_code is null then null
     end as barriers_cm_dnstr,
     case
       when b.barriers_co_dnstr is not null then b.barriers_co_dnstr
       when b.barriers_co_dnstr is null and wsg_co.watershed_group_code is not null then array[]::text[]
       when b.barriers_co_dnstr is null and wsg_co.watershed_group_code is null then null
     end as barriers_co_dnstr,
     case
       when b.barriers_pk_dnstr is not null then b.barriers_pk_dnstr
       when b.barriers_pk_dnstr is null and wsg_pk.watershed_group_code is not null then array[]::text[]
       when b.barriers_pk_dnstr is null and wsg_pk.watershed_group_code is null then null
     end as barriers_pk_dnstr,
     case
       when b.barriers_sk_dnstr is not null then b.barriers_sk_dnstr
       when b.barriers_sk_dnstr is null and wsg_sk.watershed_group_code is not null then array[]::text[]
       when b.barriers_sk_dnstr is null and wsg_sk.watershed_group_code is null then null
     end as barriers_sk_dnstr,
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
       when wsg_bt.watershed_group_code is null then -9
       when b.barriers_bt_dnstr is null and 'BT' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
       when b.barriers_bt_dnstr is null and 'BT' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) is false then 1
       when b.barriers_bt_dnstr is not null and wsg_bt.watershed_group_code is not null then 0
     end as access_bt,
     case
       when (
       wsg_ch.watershed_group_code is null AND
       wsg_cm.watershed_group_code is null AND
       wsg_co.watershed_group_code is null AND
       wsg_pk.watershed_group_code is null AND
       wsg_sk.watershed_group_code is null
       ) then -9
       when b.barriers_ch_dnstr is null and 'CH' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
       when b.barriers_ch_dnstr is null and 'CH' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) is false then 1
       when b.barriers_ch_dnstr is not null AND (
       wsg_ch.watershed_group_code is not null OR
       wsg_cm.watershed_group_code is not null OR
       wsg_co.watershed_group_code is not null OR
       wsg_pk.watershed_group_code is not null OR
       wsg_sk.watershed_group_code is not null
       ) then 0
     end as access_ch,
     case
       when (
       wsg_ch.watershed_group_code is null AND
       wsg_cm.watershed_group_code is null AND
       wsg_co.watershed_group_code is null AND
       wsg_pk.watershed_group_code is null AND
       wsg_sk.watershed_group_code is null
       ) then -9
       when b.barriers_cm_dnstr is null and 'CM' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
       when b.barriers_cm_dnstr is null and 'CM' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) is false then 1
       when b.barriers_cm_dnstr is not null AND (
       wsg_ch.watershed_group_code is not null OR
       wsg_cm.watershed_group_code is not null OR
       wsg_co.watershed_group_code is not null OR
       wsg_pk.watershed_group_code is not null OR
       wsg_sk.watershed_group_code is not null
       ) then 0
     end as access_cm,
     case
       when (
       wsg_ch.watershed_group_code is null AND
       wsg_cm.watershed_group_code is null AND
       wsg_co.watershed_group_code is null AND
       wsg_pk.watershed_group_code is null AND
       wsg_sk.watershed_group_code is null
       ) then -9
       when b.barriers_co_dnstr is null and 'CO' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
       when b.barriers_co_dnstr is null and 'CO' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) is false then 1
       when b.barriers_co_dnstr is not null AND
       (
       wsg_ch.watershed_group_code is not null OR
       wsg_cm.watershed_group_code is not null OR
       wsg_co.watershed_group_code is not null OR
       wsg_pk.watershed_group_code is not null OR
       wsg_sk.watershed_group_code is not null
       ) then 0
     end as access_co,
     case
       when (
       wsg_ch.watershed_group_code is null AND
       wsg_cm.watershed_group_code is null AND
       wsg_co.watershed_group_code is null AND
       wsg_pk.watershed_group_code is null AND
       wsg_sk.watershed_group_code is null
       ) then -9
       when b.barriers_pk_dnstr is null and 'PK' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
       when b.barriers_pk_dnstr is null and 'PK' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) is false then 1
       when b.barriers_pk_dnstr is not null AND
       (
       wsg_ch.watershed_group_code is not null OR
       wsg_cm.watershed_group_code is not null OR
       wsg_co.watershed_group_code is not null OR
       wsg_pk.watershed_group_code is not null OR
       wsg_sk.watershed_group_code is not null
       ) then 0
     end as access_pk,
     case
       when (
       wsg_ch.watershed_group_code is null AND
       wsg_cm.watershed_group_code is null AND
       wsg_co.watershed_group_code is null AND
       wsg_pk.watershed_group_code is null AND
       wsg_sk.watershed_group_code is null
       ) then -9
       when b.barriers_sk_dnstr is null and 'SK' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
       when b.barriers_sk_dnstr is null and 'SK' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) is false then 1
       when b.barriers_sk_dnstr is not null and
       (
       wsg_ch.watershed_group_code is not null OR
       wsg_cm.watershed_group_code is not null OR
       wsg_co.watershed_group_code is not null OR
       wsg_pk.watershed_group_code is not null OR
       wsg_sk.watershed_group_code is not null
       ) then 0
     end as access_sk,
     case
       when (
       wsg_ch.watershed_group_code is null AND
       wsg_cm.watershed_group_code is null AND
       wsg_co.watershed_group_code is null AND
       wsg_pk.watershed_group_code is null AND
       wsg_sk.watershed_group_code is null
       ) then -9
       when (
        (b.barriers_ch_dnstr is null AND wsg_ch.watershed_group_code is not null) OR
        (b.barriers_cm_dnstr is null AND wsg_cm.watershed_group_code is not null) OR
        (b.barriers_co_dnstr is null AND wsg_co.watershed_group_code is not null) OR
        (b.barriers_pk_dnstr is null AND wsg_pk.watershed_group_code is not null) OR
        (b.barriers_sk_dnstr is null AND wsg_sk.watershed_group_code is not null)
       )
        and coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[]) && array['CH','CM','CO','PK','SK'] then 2
       when (
        (b.barriers_ch_dnstr is null AND wsg_ch.watershed_group_code is not null) OR
        (b.barriers_cm_dnstr is null AND wsg_cm.watershed_group_code is not null) OR
        (b.barriers_co_dnstr is null AND wsg_co.watershed_group_code is not null) OR
        (b.barriers_pk_dnstr is null AND wsg_pk.watershed_group_code is not null) OR
        (b.barriers_sk_dnstr is null AND wsg_sk.watershed_group_code is not null)
       ) and coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[]) && array['CH','CM','CO','PK','SK'] is false then 1
       when (
        coalesce(
          b.barriers_ch_dnstr,
          b.barriers_cm_dnstr,
          b.barriers_co_dnstr,
          b.barriers_pk_dnstr,
          b.barriers_sk_dnstr) is not null
       ) and (
       wsg_ch.watershed_group_code is not null OR
       wsg_cm.watershed_group_code is not null OR
       wsg_co.watershed_group_code is not null OR
       wsg_pk.watershed_group_code is not null OR
       wsg_sk.watershed_group_code is not null
       )
       then 0
     end as access_salmon,
     case
       when wsg_ct_dv_rb.watershed_group_code is null then -9
       when b.barriers_ct_dv_rb_dnstr is null and coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[]) && array['CT','DV','RB'] then 2
       when b.barriers_ct_dv_rb_dnstr is null and coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[]) && array['CT','DV','RB'] is false then 1
       when b.barriers_ct_dv_rb_dnstr is not null and wsg_ct_dv_rb.watershed_group_code is not null then 0
     end as access_ct_dv_rb,
     case
       when wsg_st.watershed_group_code is null then -9
       when b.barriers_st_dnstr is null and 'SK' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
       when b.barriers_st_dnstr is null and 'SK' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) is false then 1
       when b.barriers_st_dnstr is not null and wsg_st.watershed_group_code is not null then 0
     end as access_st,
     case
       when wsg_wct.watershed_group_code is null then -9
       when b.barriers_wct_dnstr is null and 'WCT' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) then 2
       when b.barriers_wct_dnstr is null and 'WCT' = any(coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[])) is false then 1
       when b.barriers_wct_dnstr is not null and wsg_wct.watershed_group_code is not null then 0
     end as access_wct,

     coalesce(ou.observation_key_upstr, array[]::text[]) as observation_key_upstr,
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
  left outer join bcfishpass.wsg_species_presence wsg_ch on s.watershed_group_code = wsg_ch.watershed_group_code and wsg_ch.ch is true
  left outer join bcfishpass.wsg_species_presence wsg_cm on s.watershed_group_code = wsg_cm.watershed_group_code and wsg_cm.cm is true
  left outer join bcfishpass.wsg_species_presence wsg_co on s.watershed_group_code = wsg_co.watershed_group_code and wsg_co.co is true
  left outer join bcfishpass.wsg_species_presence wsg_pk on s.watershed_group_code = wsg_pk.watershed_group_code and wsg_pk.pk is true
  left outer join bcfishpass.wsg_species_presence wsg_sk on s.watershed_group_code = wsg_sk.watershed_group_code and wsg_sk.sk is true
  left outer join bcfishpass.wsg_species_presence wsg_ct_dv_rb on s.watershed_group_code = wsg_ct_dv_rb.watershed_group_code and (wsg_ct_dv_rb.ct is true or wsg_ct_dv_rb.dv is true or wsg_ct_dv_rb.rb is true)
  left outer join bcfishpass.wsg_species_presence wsg_st on s.watershed_group_code = wsg_st.watershed_group_code and wsg_st.st is true
  left outer join bcfishpass.wsg_species_presence wsg_wct on s.watershed_group_code = wsg_wct.watershed_group_code and wsg_wct.wct is true
  left outer join bcfishpass.crossings x on r.remediations_barriers_dnstr[1] = x.aggregated_crossings_id and x.pscis_status = 'REMEDIATED' and x.pscis_status = 'PASSABLE';

commit;  