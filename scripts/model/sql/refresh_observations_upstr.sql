DELETE FROM bcfishpass.observations_upstr WHERE watershed_group_code = :'wsg';

INSERT INTO bcfishpass.observations_upstr
(
  blue_line_key,
  downstream_route_measure,
  watershed_group_code,
  obsrvtn_pnt_distinct_upstr,
  obsrvtn_species_codes_upstr
)
SELECT
    blue_line_key,
    downstream_route_measure,
    watershed_group_code,
    array_agg(upstr_id) FILTER (WHERE upstr_id IS NOT NULL) AS obsrvtn_pnt_distinct_upstr,
    array_agg(DISTINCT (species_code)) FILTER (WHERE species_code IS NOT NULL) as obsrvtn_species_codes_upstr
  FROM (
    SELECT DISTINCT
      a.blue_line_key,
      a.downstream_route_measure,
      b.watershed_group_code,
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
      WHERE b.watershed_group_code = :'wsg'
  ) as f
  GROUP BY blue_line_key, downstream_route_measure, watershed_group_code
