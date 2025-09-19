INSERT INTO bcfishpass.streams_upstr_observations
(
  segmented_stream_id,
  observation_key_upstr,
  obsrvtn_species_codes_upstr
)
SELECT
    segmented_stream_id,
    array_agg(DISTINCT (upstr_id)) FILTER (WHERE upstr_id IS NOT NULL) AS observation_key_upstr,
    array_agg(DISTINCT (species_code)) FILTER (WHERE species_code IS NOT NULL) as obsrvtn_species_codes_upstr
  FROM (
    SELECT DISTINCT
      a.segmented_stream_id,
      b.observation_key as upstr_id,
      b.species_code
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
        b.wscode,
        b.localcode,
        False,
        1
      )
      AND a.watershed_group_code = b.watershed_group_code
      WHERE a.watershed_group_code = :'wsg'
  ) as f
  GROUP BY segmented_stream_id
