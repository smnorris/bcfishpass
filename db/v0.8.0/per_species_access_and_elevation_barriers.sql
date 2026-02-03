-- support salmon species specific access models

-- dnstr barriers table
ALTER TABLE bcfishpass.streams_dnstr_barriers
ADD COLUMN barriers_ch_dnstr text[];

ALTER TABLE bcfishpass.streams_dnstr_barriers
ADD COLUMN barriers_cm_dnstr text[];

ALTER TABLE bcfishpass.streams_dnstr_barriers
ADD COLUMN barriers_co_dnstr text[];

ALTER TABLE bcfishpass.streams_dnstr_barriers
ADD COLUMN barriers_pk_dnstr text[];

ALTER TABLE bcfishpass.streams_dnstr_barriers
ADD COLUMN barriers_sk_dnstr text[];

-- access table
ALTER TABLE bcfishpass.streams_access
ADD COLUMN barriers_ch_dnstr text[];

ALTER TABLE bcfishpass.streams_access
ADD COLUMN barriers_cm_dnstr text[];

ALTER TABLE bcfishpass.streams_access
ADD COLUMN barriers_co_dnstr text[];

ALTER TABLE bcfishpass.streams_access
ADD COLUMN barriers_pk_dnstr text[];

ALTER TABLE bcfishpass.streams_access
ADD COLUMN barriers_sk_dnstr text[];

-- output stream views
DROP VIEW bcfishpass.streams_ch_vw;
DROP VIEW bcfishpass.streams_cm_vw;
DROP VIEW bcfishpass.streams_co_vw;
DROP VIEW bcfishpass.streams_pk_vw;
DROP VIEW bcfishpass.streams_salmon_vw;
DROP VIEW bcfishpass.streams_sk_vw;
DROP VIEW bcfishpass.streams_vw;


-- regenerate the various streams views
CREATE VIEW bcfishpass.streams_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.barriers_bt_dnstr, ';') as barriers_bt_dnstr,
  array_to_string(a.barriers_ch_dnstr, ';') as barriers_ch_dnstr,
  array_to_string(a.barriers_cm_dnstr, ';') as barriers_cm_dnstr,
  array_to_string(a.barriers_co_dnstr, ';') as barriers_co_dnstr,
  array_to_string(a.barriers_pk_dnstr, ';') as barriers_pk_dnstr,
  array_to_string(a.barriers_sk_dnstr, ';') as barriers_sk_dnstr,
  array_to_string(a.barriers_ct_dv_rb_dnstr, ';') as barriers_ct_dv_rb_dnstr,
  array_to_string(a.barriers_st_dnstr, ';') as barriers_st_dnstr,
  array_to_string(a.barriers_wct_dnstr, ';') as barriers_wct_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  array_to_string(a.observation_key_upstr, ';') as observation_key_upstr,
  array_to_string(a.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  a.access_bt,
  a.access_ch,
  a.access_cm,
  a.access_co,
  a.access_pk,
  a.access_sk,
  a.access_st,
  a.access_wct,
  a.access_salmon,
  case when a.access_bt = -9 then -9 else h.spawning_bt end as spawning_bt,
  case when a.access_ch = -9 then -9 else h.spawning_ch end as spawning_ch,
  case when a.access_cm = -9 then -9 else h.spawning_cm end as spawning_cm,
  case when a.access_co = -9 then -9 else h.spawning_co end as spawning_co,
  case when a.access_pk = -9 then -9 else h.spawning_pk end as spawning_pk,
  case when a.access_sk = -9 then -9 else h.spawning_sk end as spawning_sk,
  case when a.access_st = -9 then -9 else h.spawning_st end as spawning_st,
  case when a.access_wct = -9 then -9 else h.spawning_wct end as spawning_wct,
  case when a.access_bt = -9 then -9 else h.rearing_bt end as rearing_bt,
  case when a.access_ch = -9 then -9 else h.rearing_ch end as rearing_ch,
  case when a.access_co = -9 then -9 else h.rearing_co end as rearing_co,
  case when a.access_sk = -9 then -9 else h.rearing_sk end as rearing_sk,
  case when a.access_st = -9 then -9 else h.rearing_st end as rearing_st,
  case when a.access_wct = -9 then -9 else h.rearing_wct end as rearing_wct,
  m.mapping_code_bt,
  m.mapping_code_ch,
  m.mapping_code_cm,
  m.mapping_code_co,
  m.mapping_code_pk,
  m.mapping_code_sk,
  m.mapping_code_st,
  m.mapping_code_wct,
  m.mapping_code_salmon,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code m on s.segmented_stream_id = m.segmented_stream_id;



create view bcfishpass.streams_ch_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.barriers_ch_dnstr, ';') as barriers_ch_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  array_to_string(a.observation_key_upstr, ';') as observation_key_upstr,
  array_to_string(a.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  a.access_ch as access,
  case when a.access_ch = -9 then -9 else h.spawning_ch end as spawning,
  case when a.access_ch = -9 then -9 else h.rearing_ch end as rearing,
  m.mapping_code_ch as mapping_code,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code m on s.segmented_stream_id = m.segmented_stream_id
where access_ch > 0;


create view bcfishpass.streams_cm_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.barriers_cm_dnstr, ';') as barriers_cm_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  array_to_string(a.observation_key_upstr, ';') as observation_key_upstr,
  array_to_string(a.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  a.access_cm as access,
  case when a.access_cm = -9 then -9 else h.spawning_cm end as spawning,
  m.mapping_code_cm as mapping_code,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code m on s.segmented_stream_id = m.segmented_stream_id
where access_cm > 0;

create view bcfishpass.streams_co_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.barriers_co_dnstr, ';') as barriers_co_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  array_to_string(a.observation_key_upstr, ';') as observation_key_upstr,
  array_to_string(a.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  a.access_co as access,
  case when a.access_co = -9 then -9 else h.spawning_co end as spawning,
  case when a.access_co = -9 then -9 else h.rearing_co end as rearing,
  m.mapping_code_co as mapping_code,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code m on s.segmented_stream_id = m.segmented_stream_id
where access_co > 0;


create view bcfishpass.streams_pk_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.barriers_pk_dnstr, ';') as barriers_pk_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  array_to_string(a.observation_key_upstr, ';') as observation_key_upstr,
  array_to_string(a.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  a.access_pk,
  case when a.access_pk = -9 then -9 else h.spawning_pk end as spawning,
  m.mapping_code_pk as mapping_code,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code m on s.segmented_stream_id = m.segmented_stream_id
where access_pk > 0;


create view bcfishpass.streams_salmon_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.barriers_ch_dnstr, ';') as barriers_ch_dnstr,
  array_to_string(a.barriers_cm_dnstr, ';') as barriers_cm_dnstr,
  array_to_string(a.barriers_co_dnstr, ';') as barriers_co_dnstr,
  array_to_string(a.barriers_pk_dnstr, ';') as barriers_pk_dnstr,
  array_to_string(a.barriers_sk_dnstr, ';') as barriers_sk_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  array_to_string(a.observation_key_upstr, ';') as observation_key_upstr,
  array_to_string(a.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  a.access_salmon as access,
  greatest(spawning_ch, spawning_cm, spawning_co, spawning_pk, spawning_sk) as spawning,
  greatest(rearing_ch, rearing_co, rearing_sk) as rearing,
  m.mapping_code_salmon as mapping_code,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code m on s.segmented_stream_id = m.segmented_stream_id
where access_salmon > 0;


create view bcfishpass.streams_sk_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.watershed_key,
  s.watershed_group_code,
  s.downstream_route_measure,
  s.length_metre,
  s.waterbody_key,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.feature_code,
  s.upstream_route_measure,
  s.upstream_area_ha,
  s.stream_order_parent,
  s.stream_order_max,
  s.map_upstream,
  s.channel_width,
  s.mad_m3s,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  array_to_string(a.barriers_dams_hydro_dnstr, ';') as barriers_dams_hydro_dnstr,
  array_to_string(a.barriers_sk_dnstr, ';') as barriers_sk_dnstr,
  array_to_string(a.crossings_dnstr, ';') as crossings_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  array_to_string(a.observation_key_upstr, ';') as observation_key_upstr,
  array_to_string(a.obsrvtn_species_codes_upstr, ';') as obsrvtn_species_codes_upstr,
  array_to_string(a.species_codes_dnstr, ';') as species_codes_dnstr,
  a.access_sk as access,
  case when a.access_sk = -9 then -9 else h.spawning_sk end as spawning,
  case when a.access_sk = -9 then -9 else h.rearing_sk end as rearing,
  m.mapping_code_sk as mapping_code,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear h on s.segmented_stream_id = h.segmented_stream_id
left outer join bcfishpass.streams_mapping_code m on s.segmented_stream_id = m.segmented_stream_id
where access_sk > 0;



-- enable constraining access to below set elevation by creating
-- elevation barriers

CREATE TABLE bcfishpass.elevation_barriers (
   elevation_barrier_id bigint GENERATED ALWAYS AS ((((blue_line_key::bigint + 1) - 354087611) * 10000000) + round(downstream_route_measure::bigint)) STORED PRIMARY KEY,
   blue_line_key             integer               ,
   downstream_route_measure  double precision      ,
   wscode_ltree              ltree                 ,
   localcode_ltree           ltree                 ,
   watershed_group_code      character varying(4)  ,
   elevation                integer
 );

create index elevbr_blk_idx on bcfishpass.elevation_barriers (blue_line_key);
create index elevbr_wsgcode_idx on bcfishpass.elevation_barriers (watershed_group_code);
create index elevbr_wscode_gidx on bcfishpass.elevation_barriers using gist (wscode_ltree);
create index elevbr_wscode_bidx on bcfishpass.elevation_barriers using btree (wscode_ltree);
create index elevbr_localcode_gidx on bcfishpass.elevation_barriers using gist (localcode_ltree);
create index elevbr_localcode_bidx on bcfishpass.elevation_barriers using btree (localcode_ltree);