with obsrvtn as (
  select distinct
    a.segmented_stream_id,
    b.watershed_group_code,
    b.wscode_ltree,
    b.localcode_ltree,
    b.downstream_route_measure as meas_b,
    unnest(species_codes) as species_code
  from
    bcfishpass.streams a
  inner join bcfishpass.observations b on
    fwa_downstream(
      a.blue_line_key,
      a.downstream_route_measure,
      a.wscode_ltree,
      a.localcode_ltree,
      b.blue_line_key,
      b.downstream_route_measure,
      b.wscode_ltree,
      b.localcode_ltree,
      true,
      1
    )
    and a.watershed_group_code = b.watershed_group_code
    where b.watershed_group_code = :'wsg'
),

habitat as (
  select 
    s.blue_line_key, 
    s.downstream_route_measure, 
    s.wscode_ltree,
    s.localcode_ltree,
    s.watershed_group_code,
    h.species_code
  from bcfishpass.user_habitat_classification h
  inner join whse_basemapping.fwa_stream_networks_sp s
  ON s.blue_line_key = h.blue_line_key
  and round(s.downstream_route_measure::numeric) >= round(h.downstream_route_measure::numeric)
  and round(s.upstream_route_measure::numeric) <= round(h.upstream_route_measure::numeric)
  where h.habitat_ind is true
  and s.watershed_group_code = :'wsg'
),

hab_dnstr as 
(
  SELECT DISTINCT
      a.segmented_stream_id,
      b.watershed_group_code,
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