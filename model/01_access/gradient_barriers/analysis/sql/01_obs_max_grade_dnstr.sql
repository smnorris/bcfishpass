DROP TABLE IF EXISTS obs_max_grade_dnstr;

CREATE TABLE obs_max_grade_dnstr AS
  SELECT DISTINCT ON (a.observation_key)
    a.observation_key,
    a.species_code,
    a.watershed_group_code,
    s.stream_order,
    round(st_z(a.geom)) as elevation,
    g.gradient_barrier_id max_gradient_id,
    g.gradient_class as max_gradient
  FROM bcfishobs.observations a
  INNER JOIN bcfishpass.wsg_species_presence sp
  ON a.watershed_group_code = sp.watershed_group_code
  INNER JOIN whse_basemapping.fwa_streams s
  ON a.linear_feature_id = s.linear_feature_id
  LEFT OUTER JOIN bcfishpass.gradient_barriers g
  ON FWA_Downstream(
      a.blue_line_key,
      a.downstream_route_measure,
      a.wscode,
      a.localcode,
      g.blue_line_key,
      g.downstream_route_measure,
      g.wscode_ltree,
      g.localcode_ltree,
      False
  )
  WHERE sp.ch is true or sp.cm is true or sp.co is true or sp.pk is true or sp.sk is true or sp.st is true
  ORDER BY
    a.observation_key,
    g.gradient_class desc,
    g.wscode_ltree desc,
    g.downstream_route_measure desc;

ALTER TABLE obs_max_grade_dnstr ADD primary key (observation_key);