-- LOAD CROSSINGS
-- --------------------------------
-- insert PSCIS crossings first, they take precedence
-- PSCIS on modelled crossings first, to get the road tenure info from model
-- --------------------------------
insert into bcfishpass.crossings
(
    aggregated_crossings_id,
    stream_crossing_id,
    modelled_crossing_id,
    crossing_source,
    pscis_status,
    crossing_type_code,
    crossing_subtype_code,
    modelled_crossing_type_source,
    barrier_status,
    pscis_road_name,
    pscis_stream_name,
    pscis_assessment_comment,
    pscis_assessment_date,
    pscis_final_score,
    transport_line_structured_name_1,
    transport_line_type_description,
    transport_line_surface_description,
    ften_forest_file_id,
    ften_file_type_description,
    ften_client_number,
    ften_client_name,
    ften_life_cycle_status_code,
    rail_track_name,
    rail_owner_name,
    rail_operator_english_name,
    ogc_proponent,
    utm_zone,
    utm_easting,
    utm_northing,
    linear_feature_id,
    blue_line_key,
    watershed_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    gnis_stream_name,
    stream_order,
    stream_magnitude,
    geom
)

select
    e.stream_crossing_id::text,
    e.stream_crossing_id,
    e.modelled_crossing_id,
    'PSCIS' AS crossing_source,
    e.pscis_status,
    e.current_crossing_type_code as crossing_type_code,
    e.current_crossing_subtype_code as crossing_subtype_code,
    case
      when mf.structure = 'OBS' THEN array['MANUAL FIX']   -- note modelled crossings that have been manually identified as OBS
      else m.modelled_crossing_type_source
    end AS modelled_crossing_type_source,
    case
      when f.user_barrier_status is not NULL THEN f.user_barrier_status
      else  e.current_barrier_result_code
    end as barrier_status,

    a.road_name as pscis_road_name,
    a.stream_name as pscis_stream_name,
    a.assessment_comment as pscis_assessment_comment,
    a.assessment_date as pscis_assessment_date,
    a.final_score as pscis_final_score,

    dra.structured_name_1 as transport_line_structured_name_1,
    dratype.description as transport_line_type_description,
    drasurface.description as transport_line_surface_description,

    ften.forest_file_id as ften_forest_file_id,
    ften.file_type_description as ften_file_type_description,
    ften.client_number as ften_client_number,
    ften.client_name as ften_client_name,
    ften.life_cycle_status_code as ften_life_cycle_status_code,

    rail.track_name as rail_track_name,
    rail.owner_name AS rail_owner_name,
    rail.operator_english_name as rail_operator_english_name,

    coalesce(ogc1.proponent, ogc2.proponent) as ogc_proponent,

    substring(to_char(utmzone(e.geom),'999999') from 6 for 2)::int as utm_zone,
    st_x(st_transform(e.geom, utmzone(e.geom)))::int as utm_easting,
    st_y(st_transform(e.geom, utmzone(e.geom)))::int as utm_northing,
    e.linear_feature_id,
    e.blue_line_key,
    s.watershed_key,
    e.downstream_route_measure,
    e.wscode_ltree,
    e.localcode_ltree,
    e.watershed_group_code,
    s.gnis_name as gnis_stream_name,
    s.stream_order,
    s.stream_magnitude,
    (st_dump(st_locatealong(s.geom, e.downstream_route_measure))).geom as geom
from bcfishpass.pscis e
left outer join bcfishpass.user_pscis_barrier_status f
on e.stream_crossing_id = f.stream_crossing_id
left outer join whse_fish.pscis_assessment_svw a
on e.stream_crossing_id = a.stream_crossing_id
left outer join bcfishpass.modelled_stream_crossings m
on e.modelled_crossing_id = m.modelled_crossing_id
left outer join bcfishpass.user_modelled_crossing_fixes mf
on m.modelled_crossing_id = mf.modelled_crossing_id
left outer join whse_basemapping.gba_railway_tracks_sp rail
on m.railway_track_id = rail.railway_track_id
left outer join whse_basemapping.transport_line dra
on m.transport_line_id = dra.transport_line_id
left outer join whse_forest_tenure.ften_road_section_lines_svw ften
on m.ften_road_section_lines_id = ften.objectid  -- note the id supplied by WFS is the link, may be unstable?
left outer join whse_mineral_tenure.og_road_segment_permit_sp ogc1
on m.og_road_segment_permit_id = ogc1.og_road_segment_permit_id
left outer join whse_mineral_tenure.og_petrlm_dev_rds_pre06_pub_sp ogc2
on m.og_petrlm_dev_rd_pre06_pub_id = ogc2.og_petrlm_dev_rd_pre06_pub_id
left outer join whse_basemapping.transport_line_type_code dratype
on dra.transport_line_type_code = dratype.transport_line_type_code
left outer join whse_basemapping.transport_line_surface_code drasurface
on dra.transport_line_surface_code = drasurface.transport_line_surface_code
inner join whse_basemapping.fwa_stream_networks_sp s
ON e.linear_feature_id = s.linear_feature_id
where e.modelled_crossing_id is not NULL   -- only PSCIS crossings that have been linked to a modelled crossing
and e.watershed_group_code = :'wsg'
order by e.stream_crossing_id
on conflict do nothing;


-- --------------------------------
-- Now PSCIS records NOT linked to modelled crossings.
-- This generally means they are not on a mapped stream - they may still be on a mapped road - try and get that info
-- don't bother trying to link to OGC roads.
-- --------------------------------
WITH rail AS
(
  select
    pt.stream_crossing_id,
    nn.*
  from bcfishpass.pscis as pt
  cross join lateral
  (select

     NULL as transport_line_structured_name_1,
     NULL as transport_line_type_description,
     NULL as transport_line_surface_description,
     NULL as ften_forest_file_id,
     NULL as ften_file_type_description,
     NULL AS ften_client_number,
     NULL AS ften_client_name,
     NULL AS ften_life_cycle_status_code,
     track_name as rail_track_name,
     owner_name as rail_owner_name,
     operator_english_name as rail_operator_english_name,
     ST_Distance(rd.geom, pt.geom) as distance_to_road
   from whse_basemapping.gba_railway_tracks_sp AS rd
   order by rd.geom <-> pt.geom
   limit 1) as nn
  inner join whse_basemapping.fwa_watershed_groups_poly wsg
  ON st_intersects(pt.geom, wsg.geom)
  and nn.distance_to_road < 25
  where pt.modelled_crossing_id IS NULL
),

dra as
(
  select
    pt.stream_crossing_id,
    nn.*
  from bcfishpass.pscis as pt
  cross join lateral
  (select

     structured_name_1,
     transport_line_type_code,
     transport_line_surface_code,
     ST_Distance(rd.geom, pt.geom) as distance_to_road
   from whse_basemapping.transport_line AS rd
   order by rd.geom <-> pt.geom
   limit 1) as nn
  inner join whse_basemapping.fwa_watershed_groups_poly wsg
  ON st_intersects(pt.geom, wsg.geom)
  and nn.distance_to_road < 30
  where pt.modelled_crossing_id IS NULL
),

ften as (
  select
    pt.stream_crossing_id,
    nn.*
  from bcfishpass.pscis as pt
  cross join lateral
  (select
     forest_file_id,
     file_type_description,
     client_number,
     client_name,
     life_cycle_status_code,
     ST_Distance(rd.geom, pt.geom) as distance_to_road
   from whse_forest_tenure.ften_road_section_lines_svw AS rd
   where life_cycle_status_code NOT IN ('PENDING')
   order by rd.geom <-> pt.geom
   limit 1) as nn
  inner join whse_basemapping.fwa_watershed_groups_poly wsg
  ON st_intersects(pt.geom, wsg.geom)
  and nn.distance_to_road < 30
  where pt.modelled_crossing_id IS NULL
),

-- combine DRA and FTEN into a road lookup
roads AS
(
  select
    coalesce(a.stream_crossing_id, b.stream_crossing_id) as stream_crossing_id,
    a.structured_name_1 as transport_line_structured_name_1,
    dratype.description AS transport_line_type_description,
    drasurface.description AS transport_line_surface_description,
    b.forest_file_id AS ften_forest_file_id,
    b.file_type_description AS ften_file_type_description,
    b.client_number AS ften_client_number,
    b.client_name AS ften_client_name,
    b.life_cycle_status_code AS ften_life_cycle_status_code,
    NULL as rail_owner_name,
    NULL as rail_track_name,
    NULL as rail_operator_english_name,
    coalesce(a.distance_to_road, b.distance_to_road) as distance_to_road
  from dra a full outer join ften b ON a.stream_crossing_id = b.stream_crossing_id
  left outer join whse_basemapping.transport_line_type_code dratype
  on a.transport_line_type_code = dratype.transport_line_type_code
  left outer join whse_basemapping.transport_line_surface_code drasurface
  on a.transport_line_surface_code = drasurface.transport_line_surface_code
),

road_and_rail AS
(
  select * from rail
  union all
  select * from roads
)

insert into bcfishpass.crossings
(
    aggregated_crossings_id,
    stream_crossing_id,
    crossing_source,
    pscis_status,
    crossing_type_code,
    crossing_subtype_code,
    barrier_status,
    pscis_road_name,
    pscis_stream_name,
    pscis_assessment_comment,
    pscis_assessment_date,
    pscis_final_score,
    transport_line_structured_name_1,
    transport_line_type_description,
    transport_line_surface_description,

    ften_forest_file_id,
    ften_file_type_description,
    ften_client_number,
    ften_client_name,
    ften_life_cycle_status_code,

    rail_track_name,
    rail_owner_name,
    rail_operator_english_name,

    utm_zone,
    utm_easting,
    utm_northing,
    linear_feature_id,
    blue_line_key,
    watershed_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    gnis_stream_name,
    stream_order,
    stream_magnitude,
    geom
)

select distinct ON (e.stream_crossing_id)
    e.stream_crossing_id::text,
    e.stream_crossing_id,
    'PSCIS' AS crossing_source,
    e.pscis_status,
    e.current_crossing_type_code as crossing_type_code,
    e.current_crossing_subtype_code as crossing_subtype_code,
    case
      when f.user_barrier_status is not NULL THEN f.user_barrier_status
      else  e.current_barrier_result_code
    end as barrier_status,
    a.road_name as pscis_road_name,
    a.stream_name as pscis_stream_name,
    a.assessment_comment as pscis_assessment_comment,
    a.assessment_date as pscis_assessment_date,
    a.final_score as pscis_final_score,
    r.transport_line_structured_name_1,
    r.transport_line_type_description,
    r.transport_line_surface_description,
    r.ften_forest_file_id,
    r.ften_file_type_description,
    r.ften_client_number,
    r.ften_client_name,
    r.ften_life_cycle_status_code,
    r.rail_track_name,
    r.rail_owner_name,
    r.rail_operator_english_name,
    substring(to_char(utmzone(e.geom),'999999') from 6 for 2)::int as utm_zone,
    st_x(st_transform(e.geom, utmzone(e.geom)))::int as utm_easting,
    st_y(st_transform(e.geom, utmzone(e.geom)))::int as utm_northing,
    e.linear_feature_id,
    e.blue_line_key,
    s.watershed_key,
    e.downstream_route_measure,
    e.wscode_ltree,
    e.localcode_ltree,
    e.watershed_group_code,
    s.gnis_name as gnis_stream_name,
    s.stream_order,
    s.stream_magnitude,
    (st_dump(st_locatealong(s.geom, e.downstream_route_measure))).geom as geom
from bcfishpass.pscis e
left outer join road_and_rail r
on r.stream_crossing_id = e.stream_crossing_id
left outer join whse_fish.pscis_assessment_svw a
on e.stream_crossing_id = a.stream_crossing_id
left outer join bcfishpass.user_pscis_barrier_status f
on e.stream_crossing_id = f.stream_crossing_id
inner join whse_basemapping.fwa_stream_networks_sp s
ON e.linear_feature_id = s.linear_feature_id
where e.modelled_crossing_id IS NULL
and e.watershed_group_code = :'wsg'
order by e.stream_crossing_id, distance_to_road asc
on conflict do nothing;

-- --------------------------------
-- cabd dams
-----------------------------------
insert into bcfishpass.crossings
(
    aggregated_crossings_id,
    dam_id,
    crossing_source,
    crossing_type_code,
    crossing_subtype_code,
    barrier_status,
    dam_name,
    dam_height,
    dam_owner,
    dam_use,
    dam_operating_status,
    utm_zone,
    utm_easting,
    utm_northing,
    linear_feature_id,
    blue_line_key,
    watershed_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    gnis_stream_name,
    stream_order,
    stream_magnitude,
    geom
)
select
    d.dam_id as aggregated_crossings_id,
    d.dam_id,
    'CABD' as crossing_source,
    'OTHER' AS crossing_type_code, -- to match up with PSCIS crossing_type_code
    'DAM' AS crossing_subtype_code,
    -- CABD 'Partial Barrier' is coded as 'POTENTIAL'
    case
      when cabd.passability_status_code = 1 THEN 'BARRIER'
      when cabd.passability_status_code = 2 THEN 'POTENTIAL'
      when cabd.passability_status_code = 3 THEN 'PASSABLE'
      when cabd.passability_status_code = 4 THEN 'UNKNOWN'
    end AS barrier_status,

    -- cabd attributes
    cabd.dam_name_en as dam_name,
    cabd.height_m as dam_height,
    cabd.owner as dam_owner,
    cabd.dam_use,
    cabd.operating_status as dam_operating_status,

    substring(to_char(utmzone(d.geom),'999999') from 6 for 2)::int as utm_zone,
    st_x(ST_transform(d.geom, utmzone(d.geom)))::int as utm_easting,
    st_y(st_transform(d.geom, utmzone(d.geom)))::int as utm_northing,
    d.linear_feature_id,
    d.blue_line_key,
    s.watershed_key,
    d.downstream_route_measure,
    d.wscode_ltree,
    d.localcode_ltree,
    d.watershed_group_code,
    s.gnis_name as gnis_stream_name,
    s.stream_order,
    s.stream_magnitude,
    (st_dump(st_locatealong(s.geom, d.downstream_route_measure))).geom as geom
from bcfishpass.dams d
inner join whse_basemapping.fwa_stream_networks_sp s
on d.linear_feature_id = s.linear_feature_id
inner join cabd.dams cabd on d.dam_id = cabd.cabd_id::text
where d.watershed_group_code = :'wsg'
order by dam_id
on conflict do nothing;

-- --------------------------------
-- non-cabd dams (placeholders for USA dams, from user_barriers_anthropogenic)
-----------------------------------
insert into bcfishpass.crossings
(
    aggregated_crossings_id,
    dam_id,
    crossing_source,
    crossing_type_code,
    crossing_subtype_code,
    barrier_status,
    dam_name,
    utm_zone,
    utm_easting,
    utm_northing,
    linear_feature_id,
    blue_line_key,
    watershed_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    gnis_stream_name,
    stream_order,
    stream_magnitude,
    geom
)
select
    d.dam_id as aggregated_crossings_id,
    d.dam_id,
    'MISC BARRIERS' as crossing_source,
    'OTHER' AS crossing_type_code, -- to match up with PSCIS crossing_type_code
    'DAM' AS crossing_subtype_code,
    'BARRIER' AS barrier_status,
    'USA DAM PLACEHOLDER' as dam_name,
    substring(to_char(utmzone(d.geom),'999999') from 6 for 2)::int as utm_zone,
    st_x(ST_transform(d.geom, utmzone(d.geom)))::int as utm_easting,
    st_y(st_transform(d.geom, utmzone(d.geom)))::int as utm_northing,
    d.linear_feature_id,
    d.blue_line_key,
    s.watershed_key,
    d.downstream_route_measure,
    d.wscode_ltree,
    d.localcode_ltree,
    d.watershed_group_code,
    s.gnis_name as gnis_stream_name,
    s.stream_order,
    s.stream_magnitude,
    (st_dump(st_locatealong(s.geom, d.downstream_route_measure))).geom as geom
from bcfishpass.dams d
inner join whse_basemapping.fwa_stream_networks_sp s on d.linear_feature_id = s.linear_feature_id
inner join bcfishpass.user_barriers_anthropogenic ba
  on d.blue_line_key = ba.blue_line_key
  and d.downstream_route_measure = ba.downstream_route_measure
where d.watershed_group_code = :'wsg'
order by dam_id
on conflict do nothing;


-- --------------------------------
-- other misc anthropogenic barriers
-- --------------------------------

-- misc barriers are blue_line_key/measure only - generate geom & get wscodes etc
WITH misc_barriers AS
(
  select
    (b.user_barrier_anthropogenic_id + 1200000000)::text as aggregated_crossings_id,
    b.user_barrier_anthropogenic_id,
    b.blue_line_key,
    s.watershed_key,
    b.downstream_route_measure,
    b.barrier_type,
    s.linear_feature_id,
    s.wscode_ltree,
    s.localcode_ltree,
    s.watershed_group_code,
    s.gnis_name as gnis_stream_name,
    s.stream_order,
    s.stream_magnitude,
    st_force2d((st_dump(st_locatealong(s.geom, b.downstream_route_measure))).geom) as geom
  from bcfishpass.user_barriers_anthropogenic b
  inner join whse_basemapping.fwa_stream_networks_sp s
  ON b.blue_line_key = s.blue_line_key
  and b.downstream_route_measure > s.downstream_route_measure - .001
  and b.downstream_route_measure + .001 < s.upstream_route_measure
  where b.barrier_type != 'DAM'
)

insert into bcfishpass.crossings
(
    aggregated_crossings_id,
    user_barrier_anthropogenic_id,
    crossing_source,
    crossing_type_code,
    crossing_subtype_code,
    barrier_status,
    utm_zone,
    utm_easting,
    utm_northing,
    linear_feature_id,
    blue_line_key,
    watershed_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    gnis_stream_name,
    stream_order,
    stream_magnitude,
    geom
)
select
    b.aggregated_crossings_id,
    b.user_barrier_anthropogenic_id,
    'MISC BARRIERS' as crossing_source,
    'OTHER' AS crossing_type_code, -- to match up with PSCIS crossing_type_code
    b.barrier_type AS crossing_subtype_code,
    'BARRIER' AS barrier_status,
    substring(to_char(utmzone(b.geom),'999999') from 6 for 2)::int as utm_zone,
    st_x(st_transform(b.geom, utmzone(b.geom)))::int as utm_easting,
    st_y(st_transform(b.geom, utmzone(b.geom)))::int as utm_northing,
    b.linear_feature_id,
    b.blue_line_key,
    b.watershed_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    b.watershed_group_code,
    b.gnis_stream_name,
    b.stream_order,
    b.stream_magnitude,
    (st_dump(st_locatealong(s.geom, b.downstream_route_measure))).geom as geom
from misc_barriers b
inner join whse_basemapping.fwa_stream_networks_sp s on b.linear_feature_id = s.linear_feature_id
where b.watershed_group_code = :'wsg'
order by user_barrier_anthropogenic_id
on conflict do nothing;


-- --------------------------------
-- insert modelled crossings
-- --------------------------------
insert into bcfishpass.crossings
(
    aggregated_crossings_id,
    modelled_crossing_id,
    crossing_source,
    modelled_crossing_type_source,
    crossing_type_code,
    barrier_status,

    transport_line_structured_name_1,
    transport_line_type_description,
    transport_line_surface_description,
    ften_forest_file_id,
    ften_file_type_description,
    ften_client_number,
    ften_client_name,
    ften_life_cycle_status_code,
    rail_track_name,
    rail_owner_name,
    rail_operator_english_name,
    ogc_proponent,
    utm_zone,
    utm_easting,
    utm_northing,
    linear_feature_id,
    blue_line_key,
    watershed_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    watershed_group_code,
    gnis_stream_name,
    stream_order,
    stream_magnitude,
    geom
)

select
    (b.modelled_crossing_id + 1000000000)::text as aggregated_crossings_id,
    b.modelled_crossing_id,
    'MODELLED CROSSINGS' as crossing_source,
    case
      when f.structure = 'OBS' THEN array['MANUAL FIX']   -- note modelled crossings that have been manually identified as OBS
      else b.modelled_crossing_type_source
    end AS modelled_crossing_type_source,
    coalesce(f.structure, b.modelled_crossing_type) as crossing_type_code,
    -- POTENTIAL is default for modelled CBS crossings
    -- assign PASSABLE if modelled as OBS or if a data fix indicates it is OBS
    case
      when modelled_crossing_type = 'CBS' and coalesce(f.structure, 'CBS') != 'OBS' THEN 'POTENTIAL'
      when modelled_crossing_type = 'OBS' OR coalesce(f.structure, 'CBS') = 'OBS' THEN 'PASSABLE'
    end AS barrier_status,

    dra.structured_name_1 as transport_line_structured_name_1,
    dratype.description AS transport_line_type_description,
    drasurface.description AS transport_line_surface_description,

    ften.forest_file_id AS ften_forest_file_id,
    ften.file_type_description AS ften_file_type_description,
    ften.client_number AS ften_client_number,
    ften.client_name AS ften_client_name,
    ften.life_cycle_status_code AS ften_life_cycle_status_code,

    rail.track_name AS rail_track_name,
    rail.owner_name AS rail_owner_name,
    rail.operator_english_name AS rail_operator_english_name,

    coalesce(ogc1.proponent, ogc2.proponent) as ogc_proponent,

    substring(to_char(utmzone(b.geom),'999999') from 6 for 2)::int as utm_zone,
    st_x(ST_transform(b.geom, utmzone(b.geom)))::int as utm_easting,
    st_y(st_transform(b.geom, utmzone(b.geom)))::int as utm_northing,
    b.linear_feature_id,
    b.blue_line_key,
    s.watershed_key,
    b.downstream_route_measure,
    b.wscode_ltree,
    b.localcode_ltree,
    b.watershed_group_code,
    s.gnis_name as gnis_stream_name,
    s.stream_order,
    s.stream_magnitude,
    (st_dump(st_locatealong(s.geom, b.downstream_route_measure))).geom as geom
from bcfishpass.modelled_stream_crossings b
inner join whse_basemapping.fwa_stream_networks_sp s
ON b.linear_feature_id = s.linear_feature_id
left outer join bcfishpass.pscis p
on b.modelled_crossing_id = p.modelled_crossing_id
left outer join bcfishpass.user_modelled_crossing_fixes f
on b.modelled_crossing_id = f.modelled_crossing_id
left outer join whse_basemapping.gba_railway_tracks_sp rail
on b.railway_track_id = rail.railway_track_id
left outer join whse_basemapping.transport_line dra
on b.transport_line_id = dra.transport_line_id
left outer join whse_forest_tenure.ften_road_section_lines_svw ften
on b.ften_road_section_lines_id = ften.objectid  -- note the id supplied by WFS is the link, may be unstable?
left outer join whse_mineral_tenure.og_road_segment_permit_sp ogc1
on b.og_road_segment_permit_id = ogc1.og_road_segment_permit_id
left outer join whse_mineral_tenure.og_petrlm_dev_rds_pre06_pub_sp ogc2
on b.og_petrlm_dev_rd_pre06_pub_id = ogc2.og_petrlm_dev_rd_pre06_pub_id
left outer join whse_basemapping.transport_line_type_code dratype
on dra.transport_line_type_code = dratype.transport_line_type_code
left outer join whse_basemapping.transport_line_surface_code drasurface
on dra.transport_line_surface_code = drasurface.transport_line_surface_code
-- where b.blue_line_key = s.watershed_key
where (f.structure IS NULL OR coalesce(f.structure, 'CBS') = 'OBS')  -- don't include crossings that have been determined to be non-existent (f.structure = 'NONE')
and p.stream_crossing_id IS NULL  -- don't include PSCIS crossings
and b.watershed_group_code = :'wsg'
order by modelled_crossing_id
on conflict do nothing;