--- load habitat model data into stream table
with habitat as (
  select
    s.segmented_stream_id,
    case
      when s.remediated_dnstr_ind is true then 'REMEDIATED'          -- remediated crossing is downstream (with no additional barriers in between)
      when s.dam_dnstr_ind is true then 'DAM'                        -- a dam is the next barrier downstream
      when
        s.barriers_anthropogenic_dnstr is not null and           -- a pscis barrier is downstream
        s.barriers_pscis_dnstr is not null and
        s.dam_dnstr_ind is false
      then 'ASSESSED'
      when
        s.barriers_anthropogenic_dnstr is not null and           -- a modelled barrier is downstream
        s.barriers_pscis_dnstr is null and
        s.dam_dnstr_ind is false
      then 'MODELLED'
      when s.barriers_anthropogenic_dnstr is null then 'NONE'    -- no barriers exist downstream

    end as mapping_code_barrier,
    case
      when s.feature_code = 'GA24850150' then 'INTERMITTENT'
      else NULL
    end as mapping_code_intermittent,
    coalesce(u.spawning_bt, bt.spawning, false) as model_spawning_bt,
    coalesce(u.spawning_ch, ch.spawning, false) as model_spawning_ch,
    coalesce(u.spawning_cm, cm.spawning, false) as model_spawning_cm,
    coalesce(u.spawning_co, co.spawning, false) as model_spawning_co,
    coalesce(u.spawning_pk, pk.spawning, false) as model_spawning_pk,
    coalesce(u.spawning_sk, sk.spawning, false) as model_spawning_sk,
    coalesce(u.spawning_st, st.spawning, false) as model_spawning_st,
    coalesce(u.spawning_wct, wct.spawning, false) as model_spawning_wct,
    coalesce(u.rearing_bt, bt.rearing, false) as model_rearing_bt,
    coalesce(u.rearing_ch, ch.rearing, false) as model_rearing_ch,
    coalesce(u.rearing_co, co.rearing, false) as model_rearing_co,
    coalesce(u.rearing_sk, sk.rearing, false) as model_rearing_sk,
    coalesce(u.rearing_st, st.rearing, false) as model_rearing_st,
    coalesce(u.rearing_wct, wct.rearing, false) as model_rearing_wct
  from bcfishpass.streams s
  left outer join bcfishpass.habitat_bt bt on s.segmented_stream_id = bt.segmented_stream_id
  left outer join bcfishpass.habitat_ch ch on s.segmented_stream_id = ch.segmented_stream_id
  left outer join bcfishpass.habitat_cm cm on s.segmented_stream_id = cm.segmented_stream_id
  left outer join bcfishpass.habitat_co co on s.segmented_stream_id = co.segmented_stream_id
  left outer join bcfishpass.habitat_pk pk on s.segmented_stream_id = pk.segmented_stream_id
  left outer join bcfishpass.habitat_sk sk on s.segmented_stream_id = sk.segmented_stream_id
  left outer join bcfishpass.habitat_st st on s.segmented_stream_id = st.segmented_stream_id
  left outer join bcfishpass.habitat_wct wct on s.segmented_stream_id = wct.segmented_stream_id
  left outer join bcfishpass.streams_habitat_known_vw u on s.segmented_stream_id = u.segmented_stream_id
  where s.watershed_group_code = :'wsg'
)

insert into bcfishpass.streams_model_habitat (
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
  dam_dnstr_ind,
  dam_hydro_dnstr_ind,
  remediated_dnstr_ind,
  model_spawning_bt,
  model_spawning_ch,
  model_spawning_cm,
  model_spawning_co,
  model_spawning_pk,
  model_spawning_sk,
  model_spawning_st,
  model_spawning_wct,
  model_rearing_bt,
  model_rearing_ch,
  model_rearing_co,
  model_rearing_sk,
  model_rearing_st,
  model_rearing_wct,
  mapping_code_bt,
  mapping_code_ch,
  mapping_code_cm,
  mapping_code_co,
  mapping_code_pk,
  mapping_code_sk,
  mapping_code_st,
  mapping_code_wct,
  mapping_code_salmon,
  geom
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
  s.barriers_anthropogenic_dnstr,
  s.barriers_pscis_dnstr,
  s.barriers_dams_dnstr,
  s.barriers_dams_hydro_dnstr,
  s.barriers_bt_dnstr,
  s.barriers_ch_cm_co_pk_sk_dnstr,
  s.barriers_ct_dv_rb_dnstr,
  s.barriers_st_dnstr,
  s.barriers_wct_dnstr,
  s.obsrvtn_event_upstr,
  s.obsrvtn_species_codes_upstr,
  s.species_codes_dnstr,
  s.crossings_dnstr,
  s.dam_dnstr_ind,
  s.dam_hydro_dnstr_ind,
  s.remediated_dnstr_ind,
  h.model_spawning_bt,
  h.model_spawning_ch,
  h.model_spawning_cm,
  h.model_spawning_co,
  h.model_spawning_pk,
  h.model_spawning_sk,
  h.model_spawning_st,
  h.model_spawning_wct,
  h.model_rearing_bt,
  h.model_rearing_ch,
  h.model_rearing_co,
  h.model_rearing_sk,
  h.model_rearing_st,
  h.model_rearing_wct,
  -- per-species mapping codes for easy symbolization
  array_to_string(array[
  case
    when
      s.barriers_bt_dnstr = array[]::text[] and
      h.model_spawning_bt is false and
      h.model_rearing_bt is false
    then 'ACCESS'
    when h.model_spawning_bt is true
    then 'SPAWN'
    when
      h.model_spawning_bt is false and
      h.model_rearing_bt is true
    then 'REAR'
  end,
  case
    when s.barriers_bt_dnstr = array[]::text[]
    then h.mapping_code_barrier
  else null end,
  case
    when s.barriers_bt_dnstr = array[]::text[]
    then h.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_bt,

  array_to_string(array[
  case
    when
      s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      h.model_spawning_ch is false and
      h.model_rearing_ch is false
    then 'ACCESS'
    when h.model_spawning_ch is true
    then 'SPAWN'
    when
      h.model_spawning_ch is false and
      h.model_rearing_ch is true
    then 'REAR'
  end,
  case
    when s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then h.mapping_code_barrier
  else null end,
  case
    when s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then h.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_ch,

  array_to_string(array[
  case
    when
      s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      h.model_spawning_cm is false
    then 'ACCESS'
    when h.model_spawning_cm is true
    then 'SPAWN'
  end,
  case
    when s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then h.mapping_code_barrier
  else null end,
  case
    when s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then h.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_cm,

  array_to_string(array[
  case
    when
      s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      h.model_spawning_co is false and
      h.model_rearing_co is false
    then 'ACCESS'
    when h.model_spawning_co is true
    then 'SPAWN'
    when
      h.model_spawning_co is false and
      h.model_rearing_co is true
    then 'REAR'
  end,
  case
    when s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then h.mapping_code_barrier
  else null end,
  case
    when s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then h.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_co,

  array_to_string(array[
  case
    when
      s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      h.model_spawning_pk is false
    then 'ACCESS'
    when h.model_spawning_pk is true
    then 'SPAWN'
  end,
  case
    when s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then h.mapping_code_barrier
  else null end,
  case
    when s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then h.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_pk,

  array_to_string(array[
  case
    when
      s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      h.model_spawning_sk is false and
      h.model_rearing_sk is false
    then 'ACCESS'
    when h.model_spawning_sk is true
    then 'SPAWN'
    when
      h.model_spawning_sk is false and
      h.model_rearing_sk is true
    then 'REAR'
  end,
  case
    when s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then h.mapping_code_barrier
  else null end,
  case
    when s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then h.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_sk,

  array_to_string(array[
  case
    when
      s.barriers_st_dnstr = array[]::text[] and
      h.model_spawning_st is false and
      h.model_rearing_st is false
    then 'ACCESS'
    when h.model_spawning_st is true
    then 'SPAWN'
    when
      h.model_spawning_st is false and
      h.model_rearing_st is true
    then 'REAR'
  end,
  case
    when s.barriers_st_dnstr = array[]::text[]
    then h.mapping_code_barrier
  else null end,
  case
    when s.barriers_st_dnstr = array[]::text[]
    then h.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_st,

  array_to_string(array[
  case
    when
      s.barriers_wct_dnstr = array[]::text[] and
      h.model_spawning_wct is false and
      h.model_rearing_wct is false
    then 'ACCESS'
    when h.model_spawning_wct is true
    then 'SPAWN'
    when
      h.model_spawning_wct is false and
      h.model_rearing_wct is true
    then 'REAR'
  end,
  case
    when s.barriers_wct_dnstr = array[]::text[]
    then h.mapping_code_barrier
  else null end,
  case
    when s.barriers_wct_dnstr = array[]::text[]
    then h.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_wct,
  array_to_string(array[
  -- combined salmon mapping code
  case
    when
      barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and
      h.model_spawning_ch is false and
      h.model_spawning_cm is false and
      h.model_spawning_co is false and
      h.model_spawning_pk is false and
      h.model_spawning_sk is false and
      h.model_rearing_ch is false and
      h.model_rearing_co is false and
      h.model_rearing_sk is false
    then 'ACCESS'
    -- potential spawning
    when
      h.model_spawning_ch is true or
      h.model_spawning_cm is true or
      h.model_spawning_co is true or
      h.model_spawning_pk is true or
      h.model_spawning_sk is true
    then 'SPAWN'
    -- potential rearing (and not spawning)
    when
      h.model_spawning_ch is false and
      h.model_spawning_cm is false and
      h.model_spawning_co is false and
      h.model_spawning_pk is false and
      h.model_spawning_sk is false and
      (
        h.model_rearing_ch is true or
        h.model_rearing_co is true or
        h.model_rearing_sk is true
      )
    then 'REAR'
  end,
   case
    when s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then h.mapping_code_barrier
  else null end,
  case
    when s.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
    then h.mapping_code_intermittent
  else null end
  ], ';') as mapping_code_salmon,
  geom
from bcfishpass.streams s
inner join habitat h on s.segmented_stream_id = h.segmented_stream_id
