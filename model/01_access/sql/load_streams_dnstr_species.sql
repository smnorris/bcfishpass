WITH obs AS (
  select * from bcfishpass.observations
  where watershed_group_code = :'wsg'
  ),

obs_min AS (
  SELECT DISTINCT
    o1.observation_key,
    o1.species_code,
    o1.blue_line_key,
    o1.downstream_route_measure,
    o1.wscode,
    o1.localcode
  from obs o1
  left outer join obs o2
  on fwa_downstream(
        o1.blue_line_key,
        o1.downstream_route_measure,
        o1.wscode,
        o1.localcode,
        o2.blue_line_key,
        o2.downstream_route_measure,
        o2.wscode,
        o2.localcode,
        false,
        1
      )
  and o1.species_code = o2.species_code
  where o2.observation_key is null
),

obsrvtn as (
  select distinct
    a.segmented_stream_id,
    b.wscode,
    b.localcode,
    b.downstream_route_measure as meas_b,
    b.species_code
  from
    bcfishpass.streams a
  inner join obs_min b on
    fwa_downstream(
      a.blue_line_key,
      a.downstream_route_measure,
      a.wscode_ltree,
      a.localcode_ltree,
      b.blue_line_key,
      b.downstream_route_measure,
      b.wscode,
      b.localcode,
      true,
      1
    )
  where a.watershed_group_code = :'wsg'
),

habitat as (
  select
    s.segmented_stream_id,
    s.blue_line_key,
    s.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    s.watershed_group_code,
    h.species_code
  from bcfishpass.user_habitat_classification h
  inner join bcfishpass.streams s
  ON s.blue_line_key = h.blue_line_key
  and round(s.downstream_route_measure::numeric) = round(h.downstream_route_measure::numeric)
  where h.habitat_ind is true
  and s.watershed_group_code = :'wsg'
),

hab_dnstr as
(
  SELECT DISTINCT
      a.segmented_stream_id,
      b.wscode_ltree,
      b.localcode_ltree,
      b.downstream_route_measure as meas_b,
      species_code
    FROM
      bcfishpass.streams a
    INNER JOIN habitat b ON
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
)


INSERT INTO bcfishpass.streams_dnstr_species
(
  segmented_stream_id,
  species_codes_dnstr
)
SELECT
    segmented_stream_id,
    array_agg(DISTINCT (species_code)) FILTER (WHERE species_code IS NOT NULL) as species_codes_dnstr
FROM (select * from obsrvtn 
      union all
      select * from hab_dnstr
     ) as f
group by segmented_stream_id;