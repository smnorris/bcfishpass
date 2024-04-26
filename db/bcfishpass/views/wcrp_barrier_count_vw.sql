create view bcfishpass.wcrp_barrier_count_vw as
with model_status as (
select 
   c.aggregated_crossings_id,
   case 
   when 
    h.ch_spawning_km > 0 or h.ch_rearing_km > 0 or 
    h.co_spawning_km > 0 or h.co_rearing_km > 0 or 
    h.sk_spawning_km > 0 or h.sk_rearing_km > 0 or
    h.st_spawning_km > 0 or h.st_rearing_km > 0 or
    h.wct_spawning_km > 0 or h.wct_rearing_km > 0
   then 'HABITAT'
   when 
    cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0 or 
    cardinality(a.barriers_st_dnstr) = 0 or
    cardinality(a.barriers_wct_dnstr) = 0
   then 'ACCESSIBLE'
   else 'NATURAL_BARRIER'
   end as model_status
FROM bcfishpass.crossings c
left outer join bcfishpass.crossings_upstream_access a
on c.aggregated_crossings_id = a.aggregated_crossings_id 
left outer join bcfishpass.crossings_upstream_habitat h
on c.aggregated_crossings_id = h.aggregated_crossings_id 
)

SELECT
    c.watershed_group_code,
    ms.model_status,
    ft.crossing_feature_type,
    count(*) filter (where c.barrier_status = 'PASSABLE') as n_passable,
    count(*) filter (where c.barrier_status = 'BARRIER') as n_barrier,
    count(*) filter (where c.barrier_status = 'POTENTIAL') as n_potential,
    count(*) filter (where c.barrier_status = 'UNKNOWN') as n_unknown,
    count(*) as total
FROM bcfishpass.crossings c
inner join bcfishpass.crossings_feature_type_vw ft
on c.aggregated_crossings_id = ft.aggregated_crossings_id
left outer join model_status ms
on c.aggregated_crossings_id = ms.aggregated_crossings_id 
-- WCRP watersheds only
inner join bcfishpass.wcrp w on c.watershed_group_code = w.watershed_group_code
-- do not include flathead
WHERE c.wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree IS FALSE
GROUP BY c.watershed_group_code, ms.model_status, ft.crossing_feature_type
ORDER BY c.watershed_group_code, ms.model_status, ft.crossing_feature_type;