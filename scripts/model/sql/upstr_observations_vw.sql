CREATE MATERIALIZED VIEW IF NOT EXISTS bcfishpass.upstr_observations_vw AS
SELECT
    blue_line_key,
    downstream_route_measure,
    array_agg(upstr_id) FILTER (WHERE upstr_id IS NOT NULL) AS upstr_obsrvtn_pnt_distinct,
    array_agg(DISTINCT (species_code)) FILTER (WHERE species_code IS NOT NULL) as upstr_obsrvtn_species_codes
  FROM (
    SELECT DISTINCT
      a.blue_line_key,
      a.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      b.downstream_route_measure as meas_b,
      b.fish_obsrvtn_pnt_distinct_id as upstr_id,
      unnest(species_codes) as species_code
    FROM
      bcfishpass.segmented_streams a
    INNER JOIN bcfishpass.observations b ON
    FWA_Upstream(
      a.blue_line_key,
      a.downstream_route_measure,
      a.wscode_ltree,
      a.localcode_ltree,
      b.blue_line_key,
      b.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      False,
      1
    )
    AND a.watershed_group_code = b.watershed_group_code
  ) as f
  GROUP BY blue_line_key, downstream_route_measure
WITH NO DATA;

CREATE INDEX ON bcfishpass.upstr_observations_vw (blue_line_key, downstream_route_measure);

