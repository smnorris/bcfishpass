-- n of crossings and barriers per watershed group, by crossing type as:
--   - total
--   - accessible (per model)
--   - with spawning rearing habitat upstream (per model)

CREATE FUNCTION bcfishpass.wsg_crossings_summary()
RETURNS table (
  watershed_group_code                  text,
  crossing_feature_type                 text,
  n_crossings_total                     integer,
  n_passable_total                      integer,
  n_barriers_total                      integer,
  n_potential_total                     integer,
  n_unknown_total                       integer,
  n_barriers_accessible_bt              integer,
  n_potential_accessible_bt             integer,
  n_unknown_accessible_bt               integer,
  n_barriers_accessible_ch_cm_co_pk_sk  integer,
  n_potential_accessible_ch_cm_co_pk_sk integer,
  n_unknown_accessible_ch_cm_co_pk_sk   integer,
  n_barriers_accessible_st              integer,
  n_potential_accessible_st             integer,
  n_unknown_accessible_st               integer,
  n_barriers_accessible_wct             integer,
  n_potential_accessible_wct            integer,
  n_unknown_accessible_wct              integer,
  n_barriers_habitat_bt                 integer,
  n_potential_habitat_bt                integer,
  n_unknown_habitat_bt                  integer,
  n_barriers_habitat_ch                 integer,
  n_potential_habitat_ch                integer,
  n_unknown_habitat_ch                  integer,
  n_barriers_habitat_cm                 integer,
  n_potential_habitat_cm                integer,
  n_unknown_habitat_cm                  integer,
  n_barriers_habitat_co                 integer,
  n_potential_habitat_co                integer,
  n_unknown_habitat_co                  integer,
  n_barriers_habitat_pk                 integer,
  n_potential_habitat_pk                integer,
  n_unknown_habitat_pk                  integer,
  n_barriers_habitat_sk                 integer,
  n_potential_habitat_sk                integer,
  n_unknown_habitat_sk                  integer,
  n_barriers_habitat_salmon             integer,
  n_potential_habitat_salmon            integer,
  n_unknown_habitat_salmon              integer,
  n_barriers_habitat_st                 integer,
  n_potential_habitat_st                integer,
  n_unknown_habitat_st                  integer,
  n_barriers_habitat_wct                integer,
  n_potential_habitat_wct               integer,
  n_unknown_habitat_wct                 integer
)
AS $$

select
  watershed_group_code,
  crossing_feature_type,
  count(*) as n_crossings_total,
  count(*) filter (where barrier_status = 'PASSABLE') as n_passable_total, -- just report on passable for totals, we are more interested in barriers
  count(*) filter (where barrier_status = 'BARRIER') as n_barriers_total,
  count(*) filter (where barrier_status = 'POTENTIAL') as n_potential_total,
  count(*) filter (where barrier_status = 'UNKNOWN') as n_unknown_total,

  -- crossings on potentially accessible streams
  count(*) filter (where barrier_status = 'BARRIER' and barriers_bt_dnstr = '') as n_barriers_accessible_bt,
  count(*) filter (where barrier_status = 'POTENTIAL' and barriers_bt_dnstr = '') as n_potential_accessible_bt,
  count(*) filter (where barrier_status = 'UNKNOWN' and barriers_bt_dnstr = '') as n_unknown_accessible_bt,

  count(*) filter (where barrier_status = 'BARRIER' and barriers_ch_cm_co_pk_sk_dnstr = '') as n_barriers_accessible_ch_cm_co_pk_sk,
  count(*) filter (where barrier_status = 'POTENTIAL' and barriers_ch_cm_co_pk_sk_dnstr = '') as n_potential_accessible_ch_cm_co_pk_sk,
  count(*) filter (where barrier_status = 'UNKNOWN' and barriers_ch_cm_co_pk_sk_dnstr = '') as n_unknown_accessible_ch_cm_co_pk_sk,

  count(*) filter (where barrier_status = 'BARRIER' and barriers_st_dnstr = '') as n_barriers_accessible_st,
  count(*) filter (where barrier_status = 'POTENTIAL' and barriers_st_dnstr = '') as n_potential_accessible_st,
  count(*) filter (where barrier_status = 'UNKNOWN' and barriers_st_dnstr = '') as n_unknown_accessible_st,

  count(*) filter (where barrier_status = 'BARRIER' and barriers_wct_dnstr = '') as n_barriers_accessible_wct,
  count(*) filter (where barrier_status = 'POTENTIAL' and barriers_wct_dnstr = '') as n_potential_accessible_wct,
  count(*) filter (where barrier_status = 'UNKNOWN' and barriers_wct_dnstr = '') as n_unknown_accessible_wct,

  -- crossings with modelled/known habitat upstream
  count(*) filter (where barrier_status = 'BARRIER' and (
    bt_spawning_km > 0 or
    bt_rearing_km > 0)
   ) as n_barriers_habitat_bt,
  count(*) filter (where barrier_status = 'POTENTIAL' and (
    bt_spawning_km > 0 or
    bt_rearing_km > 0)
   ) as n_potential_habitat_bt,
  count(*) filter (where barrier_status = 'UNKNOWN' and (
    bt_spawning_km > 0 or
    bt_rearing_km > 0)
   ) as n_unknown_habitat_bt,

  count(*) filter (where barrier_status = 'BARRIER' and (
    ch_spawning_km > 0 or
    ch_rearing_km > 0)
   ) as n_barriers_habitat_ch,
  count(*) filter (where barrier_status = 'POTENTIAL' and (
    ch_spawning_km > 0 or
    ch_rearing_km > 0)
   ) as n_potential_habitat_ch,
  count(*) filter (where barrier_status = 'UNKNOWN' and (
    ch_spawning_km > 0 or
    ch_rearing_km > 0)
   ) as n_unknown_habitat_ch,

  count(*) filter (where barrier_status = 'BARRIER' and cm_spawning_km > 0) as n_barriers_habitat_cm,
  count(*) filter (where barrier_status = 'POTENTIAL' and cm_spawning_km > 0) as n_potential_habitat_cm,
  count(*) filter (where barrier_status = 'UNKNOWN' and cm_spawning_km > 0) as n_unknown_habitat_cm,

  count(*) filter (where barrier_status = 'BARRIER' and (
    co_spawning_km > 0 or
    co_rearing_km > 0)
   ) as n_barriers_habitat_co,
  count(*) filter (where barrier_status = 'POTENTIAL' and (
    co_spawning_km > 0 or
    co_rearing_km > 0)
   ) as n_potential_habitat_co,
  count(*) filter (where barrier_status = 'UNKNOWN' and (
    co_spawning_km > 0 or
    co_rearing_km > 0)
   ) as n_unknown_habitat_co,

  count(*) filter (where barrier_status = 'BARRIER' and pk_spawning_km > 0) as n_barriers_habitat_pk,
  count(*) filter (where barrier_status = 'POTENTIAL' and pk_spawning_km > 0) as n_potential_habitat_pk,
  count(*) filter (where barrier_status = 'UNKNOWN' and pk_spawning_km > 0) as n_unknown_habitat_pk,

  count(*) filter (where barrier_status = 'BARRIER' and (
    sk_spawning_km > 0 or
    sk_rearing_km > 0)
   ) as n_barriers_habitat_sk,
  count(*) filter (where barrier_status = 'POTENTIAL' and (
    sk_spawning_km > 0 or
    sk_rearing_km > 0)
   ) as n_potential_habitat_sk,
  count(*) filter (where barrier_status = 'UNKNOWN' and (
    sk_spawning_km > 0 or
    sk_rearing_km > 0)
   ) as n_unknown_habitat_sk,

  count(*) filter (where barrier_status = 'BARRIER' and (
    ch_spawning_km > 0 or 
    ch_rearing_km > 0 or 
    cm_spawning_km > 0 or 
    co_spawning_km > 0 or 
    co_rearing_km > 0 or 
    pk_spawning_km > 0 or 
    sk_spawning_km > 0 or 
    sk_rearing_km > 0)
   ) as n_barriers_habitat_salmon,
  count(*) filter (where barrier_status = 'POTENTIAL' and (
    ch_spawning_km > 0 or 
    ch_rearing_km > 0 or 
    cm_spawning_km > 0 or 
    co_spawning_km > 0 or 
    co_rearing_km > 0 or 
    pk_spawning_km > 0 or 
    sk_spawning_km > 0 or 
    sk_rearing_km > 0)
   ) as n_potential_habitat_salmon,
  count(*) filter (where barrier_status = 'UNKNOWN' and (
    ch_spawning_km > 0 or 
    ch_rearing_km > 0 or 
    cm_spawning_km > 0 or 
    co_spawning_km > 0 or 
    co_rearing_km > 0 or 
    pk_spawning_km > 0 or 
    sk_spawning_km > 0 or 
    sk_rearing_km > 0)
   ) as n_unknown_habitat_salmon,

  count(*) filter (where barrier_status = 'BARRIER' and (
    st_spawning_km > 0 or
    st_rearing_km > 0)
   ) as n_barriers_habitat_st,
  count(*) filter (where barrier_status = 'POTENTIAL' and (
    st_spawning_km > 0 or
    st_rearing_km > 0)
   ) as n_potential_habitat_st,
  count(*) filter (where barrier_status = 'UNKNOWN' and (
    st_spawning_km > 0 or
    st_rearing_km > 0)
   ) as n_unknown_habitat_st,

  count(*) filter (where barrier_status = 'BARRIER' and (
    wct_spawning_km > 0 or
    wct_rearing_km > 0)
   ) as n_barriers_habitat_wct,
  count(*) filter (where barrier_status = 'POTENTIAL' and (
    wct_spawning_km > 0 or
    wct_rearing_km > 0)
   ) as n_potential_habitat_wct,
  count(*) filter (where barrier_status = 'UNKNOWN' and (
    wct_spawning_km > 0 or
    wct_rearing_km > 0)
   ) as n_unknown_habitat_wct

from bcfishpass.crossings_vw
group by watershed_group_code, crossing_feature_type;

$$ LANGUAGE SQL;