-- find watershed groups with updates to be loaded and processed
CREATE OR REPLACE FUNCTION bcfishpass.wsg_to_refresh(load_table text, target_table text)
  RETURNS setof character varying (4)
  LANGUAGE plpgsql AS
$func$

BEGIN

  RETURN QUERY EXECUTE format(
      'with latest as
      (
        select
          blue_line_key,
          downstream_route_measure,
          watershed_group_code
        from bcfishpass.%I
      ),

      current as
      (
        select 
          blue_line_key, 
          downstream_route_measure, 
          watershed_group_code
        from bcfishpass.%I
      ),

      new_recs as
      (
      select 
        l.blue_line_key,
        l.downstream_route_measure,
        l.watershed_group_code
      from latest l 
      left outer join current e
      on l.blue_line_key = e.blue_line_key
      and l.downstream_route_measure = e.downstream_route_measure
      where e.blue_line_key is null
      ),

      deleted_recs as
      (
      select 
        e.blue_line_key,
        e.downstream_route_measure,
        e.watershed_group_code
      from current e
      left outer join latest l
      on e.blue_line_key = l.blue_line_key
      and e.downstream_route_measure = l.downstream_route_measure
      where l.blue_line_key is null
      )

      select distinct watershed_group_code::character varying (4)
      from 
      (
        select watershed_group_code from new_recs 
        union all
        select watershed_group_code from deleted_recs
      ) as updates;',
    load_table,
    target_table);

END
$func$;