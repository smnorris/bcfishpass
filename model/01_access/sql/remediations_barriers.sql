-- create a table of all remediations and anthropogenic barriers
-- to enable quick identification of streams where the next feature downstream
-- is a remediation (regardless of any other anthropogenic barriers downstream of the remediation)

select bcfishpass.create_barrier_table('remediations');
truncate bcfishpass.barriers_remediations;

insert into bcfishpass.barriers_remediations (
  barriers_remediations_id,
  barrier_type,
  barrier_name,
  linear_feature_id,
  blue_line_key,
  watershed_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code
)
select
  barriers_anthropogenic_id as barriers_remediations_id,
  'barriers_anthropogenic' as barrier_type,
  null as barrier_name,
  linear_feature_id,
  blue_line_key,
  watershed_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code
from bcfishpass.barriers_anthropogenic
union all  
select
  aggregated_crossings_id as barriers_remediations_id,
  'remediation' as barrier_type,
  null as barrier_name,
  linear_feature_id,
 blue_line_key,
 watershed_key,
 downstream_route_measure,
 wscode_ltree,
 localcode_ltree,
 watershed_group_code
from bcfishpass.crossings
where 
  pscis_status = 'REMEDIATED' and
  barrier_status = 'PASSABLE';