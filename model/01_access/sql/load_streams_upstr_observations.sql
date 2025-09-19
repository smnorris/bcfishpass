-- *all* upstream spp must be recorded to ensure proper coding of 'observed' habitat

WITH spp AS (
  SELECT
      segmented_stream_id,
      array_agg(DISTINCT (species_code)) FILTER (WHERE species_code IS NOT NULL) as obsrvtn_species_codes_upstr
  FROM (
    SELECT DISTINCT
      a.segmented_stream_id,
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
      WHERE a.watershed_group_code = :'wsg'
  ) as f
  GROUP BY segmented_stream_id
),

-- a full list of all ids upstream of a given stream is far too verbose when working with rivers
-- like the fraser, just include ids of observations withing the same watershed group
ids AS (
  SELECT
    segmented_stream_id,
    array_agg(DISTINCT (upstr_id)) FILTER (WHERE upstr_id IS NOT NULL) AS observation_key_upstr
  FROM (
    SELECT DISTINCT
      a.segmented_stream_id,
      b.observation_key as upstr_id
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
      ) AND a.watershed_group_code = b.watershed_group_code
    WHERE a.watershed_group_code = :'wsg'
  )
  GROUP BY segmented_stream_id
)

INSERT INTO bcfishpass.streams_upstr_observations
(
  segmented_stream_id,
  observation_key_upstr,
  obsrvtn_species_codes_upstr
)

SELECT
  spp.segmented_stream_id,
  ids.observation_key_upstr,
  spp.obsrvtn_species_codes_upstr
FROM spp
INNER JOIN ids ON spp.segmented_stream_id = ids.segmented_stream_id;