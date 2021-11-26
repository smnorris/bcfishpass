-- insert all data from table a into temp_table, plus a column
-- noting which ids from table b are upstream of records in table a

INSERT INTO {schema_a}.{temp_table}

WITH src AS
(
  SELECT *
  FROM {schema_a}.{table_a}
  WHERE watershed_group_code = %s
),

upstream AS
(
    SELECT
      {id_a},
      array_agg(upstream_id) FILTER (WHERE upstream_id IS NOT NULL) AS upstream_ids
    FROM
        (SELECT
            a.{id_a},
            b.{id_b} as upstream_id
        FROM
            src a
        INNER JOIN {schema_b}.{table_b} b ON
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
        ORDER BY
          a.{id_a},
          b.wscode_ltree DESC,
          b.localcode_ltree DESC,
          b.downstream_route_measure DESC
        ) as d
    GROUP BY {id_a}
)

SELECT a.*,
  upstream.upstream_ids AS {upstr_ids_col}
FROM src a
LEFT OUTER JOIN upstream ON a.{id_a} = upstream.{id_a};
