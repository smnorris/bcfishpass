-- downstream observations ***within the same watershed group***
BEGIN;

  truncate bcfishpass.crossings_dnstr_observations;

  insert into bcfishpass.crossings_dnstr_observations (
    aggregated_crossings_id,
    observedspp_dnstr
  )

  select
    aggregated_crossings_id,
    array_agg(DISTINCT species_code ORDER BY species_code) as observedspp_dnstr
  FROM
    (
      select distinct
        a.aggregated_crossings_id,
        fo.species_code
      from bcfishpass.crossings a
      left outer join bcfishpass.observations fo
      on FWA_Downstream(
        a.blue_line_key,
        a.downstream_route_measure,
        a.wscode_ltree,
        a.localcode_ltree,
        fo.blue_line_key,
        fo.downstream_route_measure,
        fo.wscode,
        fo.localcode
     )
    and a.watershed_group_code = fo.watershed_group_code
    where fo.species_code is not null
    order by a.aggregated_crossings_id, species_code
    ) AS f
  group by aggregated_crossings_id;

COMMIT;