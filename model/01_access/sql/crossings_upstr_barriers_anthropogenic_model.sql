drop table if exists bcfishpass.crossings_upstr_barriers_anthropogenic_model cascade;

create table bcfishpass.crossings_upstr_barriers_anthropogenic_model (
  aggregated_crossings_id text primary key,
  barriers_anthropogenic_upstr_bt text[],
  barriers_anthropogenic_upstr_ch_cm_co_pk_sk text[]    ,
  barriers_anthropogenic_upstr_ct_dv_rb text[]          ,
  barriers_anthropogenic_upstr_st text[]                ,
  barriers_anthropogenic_upstr_wct text[]
);


insert into bcfishpass.crossings_upstr_barriers_anthropogenic_model (
 aggregated_crossings_id            ,
 barriers_anthropogenic_upstr_bt                ,
 barriers_anthropogenic_upstr_ch_cm_co_pk_sk    ,
 barriers_anthropogenic_upstr_ct_dv_rb          ,
 barriers_anthropogenic_upstr_st                ,
 barriers_anthropogenic_upstr_wct
)

with access_models as (
  select
    a.aggregated_crossings_id,
    s.barriers_bt_dnstr,
    s.barriers_ch_cm_co_pk_sk_dnstr,
    s.barriers_ct_dv_rb_dnstr,
    s.barriers_st_dnstr,
    s.barriers_wct_dnstr
  from bcfishpass.crossings a
  left outer join bcfishpass.streams s
  ON s.blue_line_key = a.blue_line_key
  AND round(s.downstream_route_measure::numeric, 4) <= round(a.downstream_route_measure::numeric, 4)
  AND round(s.upstream_route_measure::numeric, 4) > round(a.downstream_route_measure::numeric, 4)
  AND s.watershed_group_code = a.watershed_group_code
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