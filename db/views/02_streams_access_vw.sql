-- view of stream data plus downstream barrier info
drop view if exists bcfishpass.streams_access_vw;
create view bcfishpass.streams_access_vw as
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