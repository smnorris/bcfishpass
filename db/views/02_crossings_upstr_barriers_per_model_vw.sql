drop materialized view if exists bcfishpass.crossings_upstr_barriers_per_model_vw cascade;

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