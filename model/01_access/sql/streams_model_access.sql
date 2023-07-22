--- load access model data into stream table
insert into bcfishpass.streams_model_access (
  linear_feature_id,
  edge_type,
  blue_line_key,
  watershed_key,
  watershed_group_code,
  waterbody_key,
  wscode_ltree,
  localcode_ltree,
  gnis_name,
  stream_order,
  stream_magnitude,
  feature_code,
  upstream_area_ha,
  stream_order_parent,
  stream_order_max,
  map_upstream,
  channel_width,
  mad_m3s,
  geom,
  barriers_anthropogenic_dnstr,
  barriers_pscis_dnstr,
  barriers_dams_dnstr,
  barriers_dams_hydro_dnstr,
  barriers_bt_dnstr,
  barriers_ch_cm_co_pk_sk_dnstr,
  barriers_ct_dv_rb_dnstr,
  barriers_st_dnstr,
  barriers_wct_dnstr,
  obsrvtn_event_upstr,
  obsrvtn_species_codes_upstr,
  species_codes_dnstr,
  crossings_dnstr,
  remediated_dnstr,
  dam_dnstr
)
select
   s.linear_feature_id,
   s.edge_type,
   s.blue_line_key,
   s.watershed_key,
   s.watershed_group_code,
   s.waterbody_key,
   s.wscode_ltree,
   s.localcode_ltree,
   s.gnis_name,
   s.stream_order,
   s.stream_magnitude,
   s.feature_code,
   s.upstream_area_ha,
   s.stream_order_parent,
   s.stream_order_max,
   s.map_upstream,
   s.channel_width,
   s.mad_m3s,
   s.geom,
   ba.barriers_anthropogenic_dnstr,  
   bp.barriers_pscis_dnstr,          
   bd.barriers_dams_dnstr,
   bdh.barriers_dams_hydro_dnstr,
   -- querying for barriers dnstr has to be on empty arrays rather than null - nulls are
   -- present in watershed groups where species does not occur
      case
     when bt.barriers_bt_dnstr = array[]::text[] then bt.barriers_bt_dnstr
     when bt.barriers_bt_dnstr is null and wsg_bt.watershed_group_code is not null then array[]::text[]
   end as barriers_bt_dnstr,
   case
     when salmon.barriers_ch_cm_co_pk_sk_dnstr is not null then salmon.barriers_ch_cm_co_pk_sk_dnstr
     when salmon.barriers_ch_cm_co_pk_sk_dnstr is null and wsg_salmon.watershed_group_code is not null then array[]::text[]
     when salmon.barriers_ch_cm_co_pk_sk_dnstr is null and wsg_salmon.watershed_group_code is null then null
   end as barriers_ch_cm_co_pk_sk_dnstr,
   case
     when ct_dv_rb.barriers_ct_dv_rb_dnstr is not null then ct_dv_rb.barriers_ct_dv_rb_dnstr
     when ct_dv_rb.barriers_ct_dv_rb_dnstr is null and wsg_ct_dv_rb.watershed_group_code is not null then array[]::text[]
     when ct_dv_rb.barriers_ct_dv_rb_dnstr is null and wsg_ct_dv_rb.watershed_group_code is null then null
   end as barriers_ct_dv_rb_dnstr,
   case
     when st.barriers_st_dnstr is not null then st.barriers_st_dnstr
     when st.barriers_st_dnstr is null and wsg_st.watershed_group_code is not null then array[]::text[]
     when st.barriers_st_dnstr is null and wsg_st.watershed_group_code is null then null
   end as barriers_st_dnstr,
   case
     when wct.barriers_wct_dnstr is not null then wct.barriers_wct_dnstr
     when wct.barriers_wct_dnstr is null and wsg_wct.watershed_group_code is not null then array[]::text[]
     when wct.barriers_wct_dnstr is null and wsg_wct.watershed_group_code is null then null
   end as barriers_wct_dnstr,
   coalesce(ou.obsrvtn_event_upstr, array[]::bigint[]) as obsrvtn_event_upstr,
   coalesce(ou.obsrvtn_species_codes_upstr, array[]::text[]) as obsrvtn_species_codes_upstr,
   coalesce(od.species_codes_dnstr, array[]::text[]) as species_codes_dnstr,
   c.crossings_dnstr,
   case
     when x.aggregated_crossings_id is not null then true
     else false
   end as remediated_dnstr,
   case
     when array[ba.barriers_anthropogenic_dnstr[1]] && bd.barriers_dams_dnstr then true
     else false
   end as dam_dnstr
from bcfishpass.streams s
left outer join bcfishpass.streams_barriers_anthropogenic_dnstr ba on s.segmented_stream_id = ba.segmented_stream_id
left outer join bcfishpass.streams_barriers_pscis_dnstr bp on s.segmented_stream_id = bp.segmented_stream_id
left outer join bcfishpass.streams_barriers_dams_dnstr bd on s.segmented_stream_id = bd.segmented_stream_id
left outer join bcfishpass.streams_barriers_dams_hydro_dnstr bdh on s.segmented_stream_id = bdh.segmented_stream_id
left outer join bcfishpass.streams_barriers_bt_dnstr bt on s.segmented_stream_id = bt.segmented_stream_id
left outer join bcfishpass.streams_barriers_ch_cm_co_pk_sk_dnstr salmon on s.segmented_stream_id = salmon.segmented_stream_id
left outer join bcfishpass.streams_barriers_ct_dv_rb_dnstr ct_dv_rb on s.segmented_stream_id = ct_dv_rb.segmented_stream_id
left outer join bcfishpass.streams_barriers_st_dnstr st on s.segmented_stream_id = st.segmented_stream_id
left outer join bcfishpass.streams_barriers_wct_dnstr wct on s.segmented_stream_id = wct.segmented_stream_id
left outer join bcfishpass.streams_observations_upstr ou on s.segmented_stream_id = ou.segmented_stream_id
left outer join bcfishpass.streams_species_dnstr od on s.segmented_stream_id = od.segmented_stream_id
left outer join bcfishpass.streams_crossings_dnstr c on s.segmented_stream_id = c.segmented_stream_id
left outer join bcfishpass.streams_barriers_remediations_dnstr r on s.segmented_stream_id = r.segmented_stream_id
left outer join bcfishpass.wsg_species_presence wsg_bt on s.watershed_group_code = wsg_bt.watershed_group_code and wsg_bt.bt is true
left outer join bcfishpass.wsg_species_presence wsg_salmon on s.watershed_group_code = wsg_salmon.watershed_group_code and (wsg_salmon.ch is true or wsg_salmon.cm is true or wsg_salmon.co is true or wsg_salmon.pk is true or wsg_salmon.sk is true)
left outer join bcfishpass.wsg_species_presence wsg_ct_dv_rb on s.watershed_group_code = wsg_ct_dv_rb.watershed_group_code and (wsg_ct_dv_rb.ct is true or wsg_ct_dv_rb.dv is true or wsg_ct_dv_rb.rb is true)
left outer join bcfishpass.wsg_species_presence wsg_st on s.watershed_group_code = wsg_st.watershed_group_code and wsg_st.st is true
left outer join bcfishpass.wsg_species_presence wsg_wct on s.watershed_group_code = wsg_wct.watershed_group_code and wsg_wct.wct is true
left outer join bcfishpass.crossings x on r.remediations_barriers_dnstr[1] = x.aggregated_crossings_id and x.pscis_status = 'REMEDIATED' and x.pscis_status = 'PASSABLE'
where s.watershed_group_code = :'wsg';