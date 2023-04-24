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
  remediations_barriers_dnstr
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
   s.geom,
   ba.barriers_anthropogenic_dnstr,  
   bp.barriers_pscis_dnstr,          
   bd.barriers_dams_dnstr,           
   bdh.barriers_dams_hydro_dnstr,     
   bt.barriers_bt_dnstr,             
   salmon.barriers_ch_cm_co_pk_sk_dnstr, 
   ct_dv_rb.barriers_ct_dv_rb_dnstr,
   st.barriers_st_dnstr,             
   wct.barriers_wct_dnstr,            
   ou.obsrvtn_event_upstr,           
   ou.obsrvtn_species_codes_upstr,
   od.species_codes_dnstr,
   c.crossings_dnstr,
   r.remediations_barriers_dnstr
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
where watershed_group_code = :'wsg';