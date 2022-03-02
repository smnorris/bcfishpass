WITH obsrvtn_upstr AS
(
  SELECT
    segmented_stream_id,
    watershed_group_code,
    array_agg(DISTINCT (upstr_id)) FILTER (WHERE upstr_id IS NOT NULL) AS obsrvtn_pnt_distinct_upstr,
    array_agg(DISTINCT (species_code)) FILTER (WHERE species_code IS NOT NULL) as obsrvtn_species_codes_upstr
  FROM (
    SELECT DISTINCT
      a.segmented_stream_id,
      b.watershed_group_code,
      b.wscode_ltree,
      b.localcode_ltree,
      b.downstream_route_measure as meas_b,
      b.fish_obsrvtn_pnt_distinct_id as upstr_id,
      unnest(species_codes) as species_code
    FROM
      bcfishpass.streams a
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
  GROUP BY segmented_stream_id, watershed_group_code
)

UPDATE bcfishpass.streams s
SET 
  obsrvtn_pnt_distinct_upstr = ou.obsrvtn_pnt_distinct_upstr,
  obsrvtn_species_codes_upstr = ou.obsrvtn_species_codes_upstr
FROM obsrvtn_upstr ou
WHERE s.segmented_stream_id = ou.segmented_stream_id;