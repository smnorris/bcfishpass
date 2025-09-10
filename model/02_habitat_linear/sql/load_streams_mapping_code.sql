begin;
  truncate bcfishpass.streams_mapping_code;

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
    inner join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
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
    inner join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
  )

  insert into bcfishpass.streams_mapping_code (
    segmented_stream_id ,
    mapping_code_bt     ,
    mapping_code_ch     ,
    mapping_code_cm     ,
    mapping_code_co     ,
    mapping_code_pk     ,
    mapping_code_sk     ,
    mapping_code_st     ,
    mapping_code_wct    ,
    mapping_code_salmon 
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
  inner join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
  inner join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id;

commit;