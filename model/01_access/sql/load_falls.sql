-- load CABD falls
begin; 

  truncate bcfishpass.falls;

  with cabd as (
    select
      w.cabd_id as falls_id,
      blk.blue_line_key,
      st_transform(w.geom, 3005) as geom
    from cabd.waterfalls w
    left outer join bcfishpass.cabd_exclusions x on w.cabd_id = x.cabd_id  -- exlude any falls noted in exclusion table
    left outer join bcfishpass.cabd_blkey_xref blk on w.cabd_id = blk.cabd_id  -- get blkey from xref if present
    where x.cabd_id is null
  ),

  matched AS
  (
    select
      pt.falls_id,
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
      and not str.wscode_ltree <@ '999'
      order by str.geom <-> pt.geom
      limit 1
    ) as str
    where
      st_distance(str.geom, pt.geom) <= 65 and
      pt.blue_line_key is null

    union all

    select distinct on (falls_id) -- distinct on in case two segments are equidistant
      pt.falls_id,
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
    order by falls_id, distance_to_stream
  ),

  cabd_pts as (
    select distinct on (n.falls_id)
      n.falls_id,
      n.linear_feature_id,
      n.blue_line_key,
      n.downstream_route_measure,
      n.wscode_ltree,
      n.localcode_ltree,
      n.distance_to_stream,
      n.watershed_group_code,
      cabd.fall_name_en as falls_name,
      cabd.fall_height_m as height_m,
      case
        when coalesce(u.passability_status_code, cabd.passability_status_code) = 1 then true
        else false
      end as barrier_ind,
      ((st_dump(ST_Force2D(st_locatealong(n.geom, n.downstream_route_measure)))).geom)::geometry(Point, 3005) AS geom
    FROM matched n
    inner join cabd.waterfalls cabd on n.falls_id = cabd.cabd_id
    left outer join bcfishpass.cabd_passability_status_updates u on n.falls_id = u.cabd_id
    order by falls_id, distance_to_stream
  )


  insert into bcfishpass.falls (
    falls_id,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    distance_to_stream,
    watershed_group_code,
    falls_name,
    height_m,
    barrier_ind,
    geom
  )

  select * from cabd_pts

  union all

  select
    ((((p.blue_line_key::bigint + 1) - 354087611) * 10000000) + round(p.downstream_route_measure::bigint))::text as falls_id,
    s.linear_feature_id,
    p.blue_line_key,
    p.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    0 as distance_to_stream,
    s.watershed_group_code,
    p.name as falls_name,
    p.height as height_m,
    p.barrier_ind,
    (ST_Dump(ST_Force2D(ST_locateAlong(s.geom, p.downstream_route_measure)))).geom as geom
  from bcfishpass.cabd_additions p
  INNER JOIN whse_basemapping.fwa_stream_networks_sp s
  ON p.blue_line_key = s.blue_line_key AND
  p.downstream_route_measure > s.downstream_route_measure - .001 AND
  p.downstream_route_measure + .001 < s.upstream_route_measure
  WHERE p.feature_type = 'waterfalls';

commit;