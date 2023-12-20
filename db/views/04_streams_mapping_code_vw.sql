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


drop view if exists bcfishpass.streams_mapping_code_vw;

create view bcfishpass.streams_mapping_code_vw as

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
  left outer join bcfishpass.streams_access_vw a on s.segmented_stream_id = a.segmented_stream_id
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
left outer join bcfishpass.streams_access_vw a on a.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear_vw h on a.segmented_stream_id = h.segmented_stream_id

