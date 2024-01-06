
-- report on linear km of stream:

-- - total stream
-- - potentially accessible stream
-- - potentially accessible stream with known observation of related spp present upstream
-- - potentially accessible stream not isolated by dam or a known pscis barrier (accessible_a)
-- - potentially accessible stream not isolated by all anthropogenic barriers (observed and modelled) (accessible_b)
-- - spawning or rearing habitat
-- - spawning or rearing habitat not isolated by dam or a known pscis barrier (accessible_a)
-- - spawning or rearing habitat not isolated by all anthropogenic barriers (observed and modelled) (accessible_b)

DROP FUNCTION IF EXISTS bcfishpass.wsg_linear_summary();
CREATE FUNCTION bcfishpass.wsg_linear_summary() 
RETURNS table (
 watershed_group_code                                     text,
 length_total                                             numeric,
 length_potentiallyaccessible_bt                          numeric,
 length_potentiallyaccessible_bt_observed                 numeric,
 length_potentiallyaccessible_bt_accessible_a             numeric,
 length_potentiallyaccessible_bt_accessible_b             numeric,
 length_obsrvd_spawning_rearing_bt                        numeric,
 length_obsrvd_spawning_rearing_bt_accessible_a           numeric,
 length_obsrvd_spawning_rearing_bt_accessible_b           numeric,
 length_spawning_rearing_bt                               numeric,
 length_spawning_rearing_bt_accessible_a                  numeric,
 length_spawning_rearing_bt_accessible_b                  numeric,
 length_potentiallyaccessible_ch_cm_co_pk_sk              numeric,
 length_potentiallyaccessible_ch_cm_co_pk_sk_observed     numeric,
 length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_a numeric,
 length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_b numeric,
 length_obsrvd_spawning_rearing_ch                        numeric,
 length_obsrvd_spawning_rearing_ch_accessible_a           numeric,
 length_obsrvd_spawning_rearing_ch_accessible_b           numeric,
 length_spawning_rearing_ch                               numeric,
 length_spawning_rearing_ch_accessible_a                  numeric,
 length_spawning_rearing_ch_accessible_b                  numeric,
 length_obsrvd_spawning_rearing_cm                        numeric,
 length_obsrvd_spawning_rearing_cm_accessible_a           numeric,
 length_obsrvd_spawning_rearing_cm_accessible_b           numeric,
 length_spawning_rearing_cm                               numeric,
 length_spawning_rearing_cm_accessible_a                  numeric,
 length_spawning_rearing_cm_accessible_b                  numeric,
 length_obsrvd_spawning_rearing_co                        numeric,
 length_obsrvd_spawning_rearing_co_accessible_a           numeric,
 length_obsrvd_spawning_rearing_co_accessible_b           numeric,
 length_spawning_rearing_co                               numeric,
 length_spawning_rearing_co_accessible_a                  numeric,
 length_spawning_rearing_co_accessible_b                  numeric,
 length_obsrvd_spawning_rearing_pk                        numeric,
 length_obsrvd_spawning_rearing_pk_accessible_a           numeric,
 length_obsrvd_spawning_rearing_pk_accessible_b           numeric,
 length_spawning_rearing_pk                               numeric,
 length_spawning_rearing_pk_accessible_a                  numeric,
 length_spawning_rearing_pk_accessible_b                  numeric,
 length_obsrvd_spawning_rearing_sk                        numeric,
 length_obsrvd_spawning_rearing_sk_accessible_a           numeric,
 length_obsrvd_spawning_rearing_sk_accessible_b           numeric,
 length_spawning_rearing_sk                               numeric,
 length_spawning_rearing_sk_accessible_a                  numeric,
 length_spawning_rearing_sk_accessible_b                  numeric,
 length_potentiallyaccessible_st                          numeric,
 length_potentiallyaccessible_st_observed                 numeric,
 length_potentiallyaccessible_st_accessible_a             numeric,
 length_potentiallyaccessible_st_accessible_b             numeric,
 length_obsrvd_spawning_rearing_st                        numeric,
 length_obsrvd_spawning_rearing_st_accessible_a           numeric,
 length_obsrvd_spawning_rearing_st_accessible_b           numeric,
 length_spawning_rearing_st                               numeric,
 length_spawning_rearing_st_accessible_a                  numeric,
 length_spawning_rearing_st_accessible_b                  numeric,
 length_potentiallyaccessible_wct                         numeric,
 length_potentiallyaccessible_wct_observed                numeric,
 length_potentiallyaccessible_wct_accessible_a            numeric,
 length_potentiallyaccessible_wct_accessible_b            numeric,
 length_obsrvd_spawning_rearing_wct                       numeric,
 length_obsrvd_spawning_rearing_wct_accessible_a          numeric,
 length_obsrvd_spawning_rearing_wct_accessible_b          numeric,
 length_spawning_rearing_wct                              numeric,
 length_spawning_rearing_wct_accessible_a                 numeric,
 length_spawning_rearing_wct_accessible_b                 numeric
 )
AS $$

with accessible as
(
  select
    s.watershed_group_code,
    sum(st_length(geom)) length_total,    
    
    sum(st_length(geom)) filter (where barriers_bt_dnstr = array[]::text[]) as length_potentiallyaccessible_bt,
    sum(st_length(geom)) filter (where barriers_bt_dnstr = array[]::text[] and 'BT' = any(obsrvtn_species_codes_upstr)) as length_potentiallyaccessible_bt_observed,
    sum(st_length(geom)) filter (where barriers_bt_dnstr = array[]::text[] and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_potentiallyaccessible_bt_accessible_a,
    sum(st_length(geom)) filter (where barriers_bt_dnstr = array[]::text[] and barriers_anthropogenic_dnstr is null) as length_potentiallyaccessible_bt_accessible_b,

    sum(st_length(geom)) filter (where barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]) as length_potentiallyaccessible_ch_cm_co_pk_sk,
    sum(st_length(geom)) filter (where barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and obsrvtn_species_codes_upstr && array['CH','CM','CO','PK','SK']) as length_potentiallyaccessible_ch_cm_co_pk_sk_observed,
    sum(st_length(geom)) filter (where barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_a,
    sum(st_length(geom)) filter (where barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and barriers_anthropogenic_dnstr is null) as length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_b,

    sum(st_length(geom)) filter (where barriers_st_dnstr = array[]::text[]) as length_potentiallyaccessible_st,
    sum(st_length(geom)) filter (where barriers_st_dnstr = array[]::text[] and 'ST' = any(obsrvtn_species_codes_upstr)) as length_potentiallyaccessible_st_observed,
    sum(st_length(geom)) filter (where barriers_st_dnstr = array[]::text[] and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_potentiallyaccessible_st_accessible_a,
    sum(st_length(geom)) filter (where barriers_st_dnstr = array[]::text[] and barriers_anthropogenic_dnstr is null) as length_potentiallyaccessible_st_accessible_b,
    
    sum(st_length(geom)) filter (where barriers_wct_dnstr = array[]::text[]) as length_potentiallyaccessible_wct,
    sum(st_length(geom)) filter (where barriers_wct_dnstr = array[]::text[] and 'WCT' = any(obsrvtn_species_codes_upstr)) as length_potentiallyaccessible_wct_observed,
    sum(st_length(geom)) filter (where barriers_wct_dnstr = array[]::text[] and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_potentiallyaccessible_wct_accessible_a,
    sum(st_length(geom)) filter (where barriers_wct_dnstr = array[]::text[] and barriers_anthropogenic_dnstr is null) as length_potentiallyaccessible_wct_accessible_b
  from bcfishpass.streams_access_vw sv
  inner join bcfishpass.streams s on sv.segmented_stream_id = s.segmented_stream_id
  group by watershed_group_code
),

spawning_rearing_observed as (
  select
    s.watershed_group_code,
    sum(st_length(geom)) filter (where h.spawning_bt is true or h.rearing_bt is true) as length_obsrvd_spawning_rearing_bt,
    sum(st_length(geom)) filter (where (h.spawning_bt is true or h.rearing_bt is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_bt_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_bt is true or h.rearing_bt is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_bt_accessible_b,
    
    sum(st_length(geom)) filter (where h.spawning_ch is true or h.rearing_ch is true) as length_obsrvd_spawning_rearing_ch,
    sum(st_length(geom)) filter (where (h.spawning_ch is true or h.rearing_ch is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_ch_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_ch is true or h.rearing_ch is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_ch_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_cm is true) as length_obsrvd_spawning_rearing_cm,
    sum(st_length(geom)) filter (where (h.spawning_cm is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_cm_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_cm is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_cm_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_co is true or h.rearing_co is true) as length_obsrvd_spawning_rearing_co,
    sum(st_length(geom)) filter (where (h.spawning_co is true or h.rearing_co is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_co_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_co is true or h.rearing_co is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_co_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_pk is true) as length_obsrvd_spawning_rearing_pk,
    sum(st_length(geom)) filter (where (h.spawning_pk is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_pk_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_pk is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_pk_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_sk is true or h.rearing_sk is true) as length_obsrvd_spawning_rearing_sk,
    sum(st_length(geom)) filter (where (h.spawning_sk is true or h.rearing_sk is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_sk_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_sk is true or h.rearing_sk is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_sk_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_st is true or h.rearing_st is true) as length_obsrvd_spawning_rearing_st,
    sum(st_length(geom)) filter (where (h.spawning_st is true or h.rearing_st is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_st_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_st is true or h.rearing_st is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_st_accessible_b,
    
    sum(st_length(geom)) filter (where h.spawning_wct is true or h.rearing_wct is true) as length_obsrvd_spawning_rearing_wct,
    sum(st_length(geom)) filter (where (h.spawning_wct is true or h.rearing_wct is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_wct_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_wct is true or h.rearing_wct is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_wct_accessible_b
  from bcfishpass.streams_access_vw sv
  left outer join bcfishpass.habitat_user_vw h on sv.segmented_stream_id = h.segmented_stream_id
  inner join bcfishpass.streams s on sv.segmented_stream_id = s.segmented_stream_id
  group by watershed_group_code
),

spawning_rearing_modelled as (
  select
    s.watershed_group_code,
    sum(st_length(geom)) filter (where h.spawning_bt is true or h.rearing_bt is true) as length_spawning_rearing_bt,
    sum(st_length(geom)) filter (where (h.spawning_bt is true or h.rearing_bt is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_bt_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_bt is true or h.rearing_bt is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_bt_accessible_b,
    
    sum(st_length(geom)) filter (where h.spawning_ch is true or h.rearing_ch is true) as length_spawning_rearing_ch,
    sum(st_length(geom)) filter (where (h.spawning_ch is true or h.rearing_ch is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_ch_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_ch is true or h.rearing_ch is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_ch_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_cm is true) as length_spawning_rearing_cm,
    sum(st_length(geom)) filter (where (h.spawning_cm is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_cm_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_cm is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_cm_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_co is true or h.rearing_co is true) as length_spawning_rearing_co,
    sum(st_length(geom)) filter (where (h.spawning_co is true or h.rearing_co is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_co_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_co is true or h.rearing_co is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_co_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_pk is true) as length_spawning_rearing_pk,
    sum(st_length(geom)) filter (where (h.spawning_pk is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_pk_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_pk is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_pk_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_sk is true or h.rearing_sk is true) as length_spawning_rearing_sk,
    sum(st_length(geom)) filter (where (h.spawning_sk is true or h.rearing_sk is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_sk_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_sk is true or h.rearing_sk is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_sk_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_st is true or h.rearing_st is true) as length_spawning_rearing_st,
    sum(st_length(geom)) filter (where (h.spawning_st is true or h.rearing_st is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_st_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_st is true or h.rearing_st is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_st_accessible_b,
    
    sum(st_length(geom)) filter (where h.spawning_wct is true or h.rearing_wct is true) as length_spawning_rearing_wct,
    sum(st_length(geom)) filter (where (h.spawning_wct is true or h.rearing_wct is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_wct_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_wct is true or h.rearing_wct is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_wct_accessible_b
  from bcfishpass.streams_access_vw sv
  left outer join bcfishpass.streams_habitat_linear_vw h on sv.segmented_stream_id = h.segmented_stream_id
  inner join bcfishpass.streams s on sv.segmented_stream_id = s.segmented_stream_id
  group by watershed_group_code
)

-- round to nearest km
select
  a.watershed_group_code,
  round((coalesce(a.length_total, 0) / 1000)::numeric, 2) as length_total,
  -- bull trout
  round((coalesce(a.length_potentiallyaccessible_bt, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_bt,
  round((coalesce(a.length_potentiallyaccessible_bt_observed, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_bt_observed,
  round((coalesce(a.length_potentiallyaccessible_bt_accessible_a, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_bt_accessible_a,
  round((coalesce(a.length_potentiallyaccessible_bt_accessible_b, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_bt_accessible_b,
  round((coalesce(o.length_obsrvd_spawning_rearing_bt, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_bt,
  round((coalesce(o.length_obsrvd_spawning_rearing_bt_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_bt_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_bt_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_bt_accessible_b,
  round((coalesce(m.length_spawning_rearing_bt, 0) / 1000)::numeric, 2) as length_spawning_rearing_bt,
  round((coalesce(m.length_spawning_rearing_bt_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_bt_accessible_a,
  round((coalesce(m.length_spawning_rearing_bt_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_bt_accessible_b,

  -- salmon access
  round((coalesce(a.length_potentiallyaccessible_ch_cm_co_pk_sk, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_ch_cm_co_pk_sk,
  round((coalesce(a.length_potentiallyaccessible_ch_cm_co_pk_sk_observed, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_ch_cm_co_pk_sk_observed,
  round((coalesce(a.length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_a, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_a,
  round((coalesce(a.length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_b, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_b,
  
  --ch/cm/co/pk/sk spawning/rearing reported separately
  round((coalesce(o.length_obsrvd_spawning_rearing_ch, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_ch,
  round((coalesce(o.length_obsrvd_spawning_rearing_ch_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_ch_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_ch_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_ch_accessible_b,
  round((coalesce(m.length_spawning_rearing_ch, 0) / 1000)::numeric, 2) as length_spawning_rearing_ch,
  round((coalesce(m.length_spawning_rearing_ch_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_ch_accessible_a,
  round((coalesce(m.length_spawning_rearing_ch_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_ch_accessible_b,

  round((coalesce(o.length_obsrvd_spawning_rearing_cm, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_cm,
  round((coalesce(o.length_obsrvd_spawning_rearing_cm_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_cm_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_cm_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_cm_accessible_b,
  round((coalesce(m.length_spawning_rearing_cm, 0) / 1000)::numeric, 2) as length_spawning_rearing_cm,
  round((coalesce(m.length_spawning_rearing_cm_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_cm_accessible_a,
  round((coalesce(m.length_spawning_rearing_cm_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_cm_accessible_b,

  round((coalesce(o.length_obsrvd_spawning_rearing_co, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_co,
  round((coalesce(o.length_obsrvd_spawning_rearing_co_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_co_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_co_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_co_accessible_b,
  round((coalesce(m.length_spawning_rearing_co, 0) / 1000)::numeric, 2) as length_spawning_rearing_co,
  round((coalesce(m.length_spawning_rearing_co_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_co_accessible_a,
  round((coalesce(m.length_spawning_rearing_co_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_co_accessible_b,

  round((coalesce(o.length_obsrvd_spawning_rearing_pk, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_pk,
  round((coalesce(o.length_obsrvd_spawning_rearing_pk_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_pk_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_pk_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_pk_accessible_b,
  round((coalesce(m.length_spawning_rearing_pk, 0) / 1000)::numeric, 2) as length_spawning_rearing_pk,
  round((coalesce(m.length_spawning_rearing_pk_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_pk_accessible_a,
  round((coalesce(m.length_spawning_rearing_pk_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_pk_accessible_b,

  round((coalesce(o.length_obsrvd_spawning_rearing_sk, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_sk,
  round((coalesce(o.length_obsrvd_spawning_rearing_sk_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_sk_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_sk_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_sk_accessible_b,
  round((coalesce(m.length_spawning_rearing_sk, 0) / 1000)::numeric, 2) as length_spawning_rearing_sk,
  round((coalesce(m.length_spawning_rearing_sk_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_sk_accessible_a,
  round((coalesce(m.length_spawning_rearing_sk_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_sk_accessible_b,

  -- steelhead
  round((coalesce(a.length_potentiallyaccessible_st, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_st,
  round((coalesce(a.length_potentiallyaccessible_st_observed, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_st_observed,
  round((coalesce(a.length_potentiallyaccessible_st_accessible_a, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_st_accessible_a,
  round((coalesce(a.length_potentiallyaccessible_st_accessible_b, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_st_accessible_b,
  round((coalesce(o.length_obsrvd_spawning_rearing_st, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_st,
  round((coalesce(o.length_obsrvd_spawning_rearing_st_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_st_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_st_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_st_accessible_b,
  round((coalesce(m.length_spawning_rearing_st, 0) / 1000)::numeric, 2) as length_spawning_rearing_st,
  round((coalesce(m.length_spawning_rearing_st_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_st_accessible_a,
  round((coalesce(m.length_spawning_rearing_st_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_st_accessible_b,

  -- wct
  round((coalesce(a.length_potentiallyaccessible_wct, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_wct,
  round((coalesce(a.length_potentiallyaccessible_wct_observed, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_wct_observed,
  round((coalesce(a.length_potentiallyaccessible_wct_accessible_a, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_wct_accessible_a,
  round((coalesce(a.length_potentiallyaccessible_wct_accessible_b, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_wct_accessible_b,
  round((coalesce(o.length_obsrvd_spawning_rearing_wct, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_wct,
  round((coalesce(o.length_obsrvd_spawning_rearing_wct_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_wct_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_wct_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_wct_accessible_b,
  round((coalesce(m.length_spawning_rearing_wct, 0) / 1000)::numeric, 2) as length_spawning_rearing_wct,
  round((coalesce(m.length_spawning_rearing_wct_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_wct_accessible_a,
  round((coalesce(m.length_spawning_rearing_wct_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_wct_accessible_b

from accessible a
left outer join spawning_rearing_observed o on a.watershed_group_code = o.watershed_group_code
left outer join spawning_rearing_modelled m  on a.watershed_group_code = m.watershed_group_code
order by a.watershed_group_code;

$$ LANGUAGE SQL; 