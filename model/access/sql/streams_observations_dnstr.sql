INSERT INTO bcfishpass.streams_observations_dnstr
(
  segmented_stream_id,
  obsrvtn_event_dnstr,
  obsrvtn_species_codes_dnstr
)
SELECT
    segmented_stream_id,
    array_agg(DISTINCT (dnstr_id)) FILTER (WHERE dnstr_id IS NOT NULL) AS obsrvtn_event_upstr,
    array_agg(DISTINCT (species_code)) FILTER (WHERE species_code IS NOT NULL) as obsrvtn_species_codes_dnstr
  FROM (
    SELECT DISTINCT
      a.segmented_stream_id,
      b.watershed_group_code,
      b.wscode_ltree,
      b.localcode_ltree,
      b.downstream_route_measure as meas_b,
      b.fish_obsrvtn_event_id as dnstr_id,
      unnest(species_codes) as species_code
    FROM
      bcfishpass.streams a
    INNER JOIN bcfishpass.observations b ON
      FWA_Downstream(
        a.blue_line_key,
        a.downstream_route_measure,
        a.wscode_ltree,
        a.localcode_ltree,
        b.blue_line_key,
        b.downstream_route_measure,
        b.wscode_ltree,
        b.localcode_ltree,
        True,
        1
      )
      AND a.watershed_group_code = b.watershed_group_code
      WHERE b.watershed_group_code = :'wsg'
  ) as f
  GROUP BY segmented_stream_id, watershed_group_code
