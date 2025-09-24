-- reference CABD dams to FWA stream network
begin;
  
  truncate bcfishpass.dams;

  with cabd as (
    select
      d.cabd_id as dam_id,
      blk.blue_line_key,
      st_transform(d.geom, 3005) as geom
    from cabd.dams d
    -- exclude any dam noted in user exclusion table
    left outer join bcfishpass.user_cabd_dams_exclusions x on d.cabd_id = x.cabd_id
    left outer join bcfishpass.user_cabd_blkey_xref blk on d.cabd_id = blk.cabd_id
    where x.cabd_id is null
  ),

  matched AS
  (
    select
      pt.dam_id,
      str.linear_feature_id,
      str.blue_line_key,
      str.wscode_ltree,
      str.localcode_ltree,
      str.watershed_group_code,
      str.geom,
      st_distance(str.geom, pt.geom) as distance_to_stream,
      st_interpolatepoint(str.geom, pt.geom) as downstream_route_measure
    from cabd pt
    cross join lateral (
      select
        linear_feature_id,
        blue_line_key,
        wscode_ltree,
        localcode_ltree,
        watershed_group_code,
        geom
      from whse_basemapping.fwa_stream_networks_sp str
      where str.localcode_ltree is not null
      and pt.blue_line_key is null
      and not str.wscode_ltree <@ '999'
      order by str.geom <-> pt.geom
      limit 1
    ) as str
    where st_distance(str.geom, pt.geom) <= 65

    union all

    select distinct on (dam_id) -- distinct on in case two segments are equidistant
      pt.dam_id,
      str.linear_feature_id,
      str.blue_line_key,
      str.wscode_ltree,
      str.localcode_ltree,
      str.watershed_group_code,
      str.geom,
      st_distance(str.geom, pt.geom) as distance_to_stream,
      st_interpolatepoint(str.geom, pt.geom) as downstream_route_measure
    from cabd pt
    cross join lateral (
      select
        linear_feature_id,
        blue_line_key,
        wscode_ltree,
        localcode_ltree,
        watershed_group_code,
        geom
      from whse_basemapping.fwa_stream_networks_sp str
      where pt.blue_line_key = str.blue_line_key
      and pt.blue_line_key is not null
      and str.localcode_ltree is not null
      and not str.wscode_ltree <@ '999'
      order by str.geom <-> pt.geom
      limit 1
    ) as str
    order by dam_id, distance_to_stream, linear_feature_id -- order by linear_feature_id so results are consistent in cases of equidistant features
  ),

    -- ensure only one feature returned, and interpolate the geom on the stream
  cabd_pts as
  (
    select distinct on (n.dam_id)
      n.dam_id,
      n.linear_feature_id,
      n.blue_line_key,
      n.downstream_route_measure,
      n.wscode_ltree,
      n.localcode_ltree,
      n.distance_to_stream,
      n.watershed_group_code,
      cabd.dam_name_en,
      cabd.height_m,
      cabd.owner,
      cabd.dam_use,
      cabd.operating_status,
      cabd.passability_status_code,

      ((st_dump(ST_Force2D(st_locatealong(n.geom, n.downstream_route_measure)))).geom)::geometry(Point, 3005) AS geom
    FROM matched n
    inner join cabd.dams cabd on n.dam_id = cabd.cabd_id
    order by dam_id, distance_to_stream
  ),

  -- placeholders for major USA dams not present in CABD are stored in user_barriers_anthropogenic
  usa as 
  (
    select
      (a.user_barrier_anthropogenic_id + 1200000000)::text as dam_id,
      s.linear_feature_id,
      a.blue_line_key,
      a.downstream_route_measure,
      s.wscode_ltree,
      s.localcode_ltree,
      0 as distance_to_stream,
      s.watershed_group_code,
      a.barrier_name,
      st_force2d((st_dump(st_locatealong(s.geom, a.downstream_route_measure))).geom) as geom
    from bcfishpass.user_barriers_anthropogenic a
    inner join whse_basemapping.fwa_stream_networks_sp s
    on a.blue_line_key = s.blue_line_key
    AND ROUND(a.downstream_route_measure::numeric) >= ROUND(s.downstream_route_measure::numeric)
    AND ROUND(a.downstream_route_measure::numeric) < ROUND(s.upstream_route_measure::numeric)
    where a.barrier_type = 'DAM'
  )

  insert into bcfishpass.dams (
    dam_id,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    distance_to_stream,
    watershed_group_code,
    dam_name_en,
    height_m,
    owner,
    dam_use,
    operating_status,
    passability_status_code,
    geom
  )

  select * from cabd_pts
  union all
  select
    dam_id,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    distance_to_stream,
    watershed_group_code,
    barrier_name as dam_name_en,
    null as height_m,
    null as owner,
    null as dam_use,
    null as operating_status,
    null as passability_status_code,
    geom
  from usa;  

commit;