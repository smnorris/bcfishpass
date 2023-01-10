alter table bcfishpass.crossings add column if not exists crossings_dnstr text[];
alter table bcfishpass.crossings add column if not exists barriers_anthropogenic_dnstr text[];
alter table bcfishpass.crossings add column if not exists barriers_anthropogenic_upstr text[];

drop table if exists bcfishpass.crossings_index_tmp;
create table bcfishpass.crossings_index_tmp (like bcfishpass.crossings including all);

insert into bcfishpass.crossings_index_tmp (
 aggregated_crossings_id            ,
 stream_crossing_id                 ,
 dam_id                             ,
 user_barrier_anthropogenic_id      ,
 modelled_crossing_id               ,
 crossing_source                    ,
 crossing_feature_type              ,
 pscis_status                       ,
 crossing_type_code                 ,
 crossing_subtype_code              ,
 modelled_crossing_type_source      ,
 barrier_status                     ,
 pscis_road_name                    ,
 pscis_stream_name                  ,
 pscis_assessment_comment           ,
 pscis_assessment_date              ,
 pscis_final_score                  ,
 transport_line_structured_name_1   ,
 transport_line_type_description    ,
 transport_line_surface_description ,
 ften_forest_file_id                ,
 ften_file_type_description         ,
 ften_client_number                 ,
 ften_client_name                   ,
 ften_life_cycle_status_code        ,
 rail_track_name                    ,
 rail_owner_name                    ,
 rail_operator_english_name         ,
 ogc_proponent                      ,
 dam_name                           ,
 dam_height                         ,
 dam_owner                          ,
 dam_use                            ,
 dam_operating_status               ,
 utm_zone                           ,
 utm_easting                        ,
 utm_northing                       ,
 dbm_mof_50k_grid                   ,
 linear_feature_id                  ,
 blue_line_key                      ,
 watershed_key                      ,
 downstream_route_measure           ,
 wscode_ltree                       ,
 localcode_ltree                    ,
 watershed_group_code               ,
 gnis_stream_name                   ,
 stream_order                       ,
 stream_magnitude                   ,
 observedspp_dnstr                  ,
 observedspp_upstr                  ,
 geom                               ,
 crossings_dnstr                    ,
 barriers_anthropogenic_dnstr       ,
 barriers_anthropogenic_upstr       
)

select
 c.aggregated_crossings_id            ,
 c.stream_crossing_id                 ,
 c.dam_id                             ,
 c.user_barrier_anthropogenic_id      ,
 c.modelled_crossing_id               ,
 c.crossing_source                    ,
 c.crossing_feature_type              ,
 c.pscis_status                       ,
 c.crossing_type_code                 ,
 c.crossing_subtype_code              ,
 c.modelled_crossing_type_source      ,
 c.barrier_status                     ,
 c.pscis_road_name                    ,
 c.pscis_stream_name                  ,
 c.pscis_assessment_comment           ,
 c.pscis_assessment_date              ,
 c.pscis_final_score                  ,
 c.transport_line_structured_name_1   ,
 c.transport_line_type_description    ,
 c.transport_line_surface_description ,
 c.ften_forest_file_id                ,
 c.ften_file_type_description         ,
 c.ften_client_number                 ,
 c.ften_client_name                   ,
 c.ften_life_cycle_status_code        ,
 c.rail_track_name                    ,
 c.rail_owner_name                    ,
 c.rail_operator_english_name         ,
 c.ogc_proponent                      ,
 c.dam_name                           ,
 c.dam_height                         ,
 c.dam_owner                          ,
 c.dam_use                            ,
 c.dam_operating_status               ,
 c.utm_zone                           ,
 c.utm_easting                        ,
 c.utm_northing                       ,
 c.dbm_mof_50k_grid                   ,
 c.linear_feature_id                  ,
 c.blue_line_key                      ,
 c.watershed_key                      ,
 c.downstream_route_measure           ,
 c.wscode_ltree                       ,
 c.localcode_ltree                    ,
 c.watershed_group_code               ,
 c.gnis_stream_name                   ,
 c.stream_order                       ,
 c.stream_magnitude                   ,
 c.observedspp_dnstr                  ,
 c.observedspp_upstr                  ,
 c.geom                               ,
 cd.features_dnstr                    ,
 ad.features_dnstr       ,
 au.features_upstr       
from bcfishpass.crossings c
left outer join bcfishpass.crossings_dnstr_crossings cd
on c.aggregated_crossings_id = cd.aggregated_crossings_id
left outer join bcfishpass.crossings_dnstr_barriers_anthropogenic ad
on c.aggregated_crossings_id = ad.aggregated_crossings_id
left outer join bcfishpass.crossings_upstr_barriers_anthropogenic au
on c.aggregated_crossings_id = au.aggregated_crossings_id;

-- do the switch
drop table bcfishpass.crossings;
alter table bcfishpass.crossings_index_tmp rename to crossings;

-- drop lookups
drop table bcfishpass.crossings_dnstr_crossings;
drop table bcfishpass.crossings_dnstr_barriers_anthropogenic;
drop table bcfishpass.crossings_upstr_barriers_anthropogenic;


-- do same for barriers anthropogenic
alter table bcfishpass.barriers_anthropogenic add column if not exists barriers_anthropogenic_dnstr text[];
drop table if exists bcfishpass.barriers_anthropogenic_index_tmp;
create table bcfishpass.barriers_anthropogenic_index_tmp (like bcfishpass.barriers_anthropogenic including all);

insert into bcfishpass.barriers_anthropogenic_index_tmp (
  barriers_anthropogenic_id,
  barrier_type,
  barrier_name,
  linear_feature_id,
  blue_line_key,
  watershed_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  geom,
  barriers_anthropogenic_dnstr
)
select 
  a.barriers_anthropogenic_id,
  a.barrier_type,
  a.barrier_name,
  a.linear_feature_id,
  a.blue_line_key,
  a.watershed_key,
  a.downstream_route_measure,
  a.wscode_ltree,
  a.localcode_ltree,
  a.watershed_group_code,
  geom,
  d.features_dnstr as barriers_anthropogenic_dnstr
from bcfishpass.barriers_anthropogenic a
left outer join bcfishpass.barriers_anthropogenic_dnstr_barriers_anthropogenic d
on a.barriers_anthropogenic_id = d.barriers_anthropogenic_id;

-- do the switch
drop table bcfishpass.barriers_anthropogenic;
alter table bcfishpass.barriers_anthropogenic_index_tmp rename to barriers_anthropogenic;

drop table bcfishpass.barriers_anthropogenic_dnstr_barriers_anthropogenic;
