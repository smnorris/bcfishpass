-- compare records in table a and table b,
-- and record in output table (as an array) all ids from b that are downstream of given id for table a
CREATE FUNCTION bcfishpass.load_upstr(
  table_a text, 
  table_a_id text, 
  table_b text, 
  table_b_id text, 
  out_table text, 
  upstr_id text, 
  include_equivalents text, 
  wsg text
)

  RETURNS VOID
  LANGUAGE plpgsql AS
$func$

BEGIN

  EXECUTE format('

    insert into %5$s
    (%2$s, %6$s)

    select
      %2$s,
      array_agg(upstream_id) filter (where upstream_id is not null) as %6$s
    from
        (select
            a.%2$s,
            b.%4$s as upstream_id
        from
            %1$s a
        inner join %3$s b on
        fwa_upstream(
            a.blue_line_key,
            a.downstream_route_measure,
            a.wscode_ltree,
            a.localcode_ltree,
            b.blue_line_key,
            b.downstream_route_measure,
            b.wscode_ltree,
            b.localcode_ltree,
            %7$s,
            1
        )
        where a.watershed_group_code = %8$L
        order by
          a.%2$s,
          b.wscode_ltree desc,
          b.localcode_ltree desc,
          b.downstream_route_measure desc
        ) as d
    group by %2$s;',
table_a,
table_a_id,
table_b,
table_b_id,
out_table,
upstr_id,
include_equivalents,
wsg);

END
$func$;