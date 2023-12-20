-- compare records in table a and table b,
-- and record in output table (as an array) all ids from b that are downstream of given id for table a
CREATE OR REPLACE FUNCTION bcfishpass.load_dnstr(
  table_a text, 
  table_a_id text, 
  table_b text, 
  table_b_id text, 
  out_table text, 
  dnstr_id text, 
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
      array_agg(downstream_id) filter (where downstream_id is not null) as %6$s
    from
        (select
            a.%2$s,
            b.%4$s as downstream_id
        from
            %1$s a
        inner join %3$s b on
        fwa_downstream(
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
    group by %2$s

    on conflict ($2$s)
    do update set %6$s = EXCLUDED.%6$s;',
table_a,
table_a_id,
table_b,
table_b_id,
out_table,
dnstr_id,
include_equivalents,
wsg);

END
$func$;