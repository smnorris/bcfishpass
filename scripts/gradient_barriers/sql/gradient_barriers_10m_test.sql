-- test segmenting individual stream segments (>11m long) 
-- into 10m segments and finding grade of each segment
-- Nobel 2015 (LGL/DFO) identified 10m segments of >= 100% as gradient barriers

-- only ~53 segments are indientified in VICT group
-- This method/threshold seems very high to me (interpolating elevations along the stream
-- is bound to have a smoothing effect, and the source elevations are from the BC 25m DEM)

with streams as
(
 select
  s.linear_feature_id,
  s.downstream_route_measure,
  s.upstream_route_measure,
  s.geom
  from whse_basemapping.fwa_stream_networks_sp s
  where watershed_group_code = 'VICT'
  and blue_line_key = watershed_key
  and edge_type != 6010
  and st_length(geom) > 11
  order by downstream_route_measure
  ),

segment_measures as
(
select
  s.linear_feature_id,
  s.downstream_route_measure,
  s.upstream_route_measure,
  s.geom,
  ceil((s.upstream_route_measure - downstream_route_measure) / 10)::integer - 1 as n,
  generate_series(0, ceil((s.upstream_route_measure - downstream_route_measure) / 10)::integer - 1) as id,
  downstream_route_measure + (generate_series(0, ceil((s.upstream_route_measure - downstream_route_measure) / 10)::integer - 1) * 10)  as meas_a,
  least(upstream_route_measure, downstream_route_measure + (generate_series(0, ceil((s.upstream_route_measure - downstream_route_measure) / 10)::integer - 1) * 10) + 10)  as meas_b
from streams s),

slopes as
(select
  s.linear_feature_id,
  n,
  meas_a,
  meas_b,
  st_z((st_dump((st_locatealong(geom, meas_a)))).geom) as z_a,
  st_z((st_dump((st_locatealong(geom, meas_b)))).geom) as z_b,
  (st_z((st_dump((st_locatealong(geom, meas_b)))).geom) - st_z((st_dump((st_locatealong(geom, meas_a)))).geom)) / 10 as gradient
from segment_measures s
where meas_b - meas_a = 10
)

select * from slopes order by gradient desc;