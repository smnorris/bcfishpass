-- insert all data from table a into temp_table, plus a column
-- noting which ids from table b are downstream of records in table a
-- use for points - do not include events of equivalent measures
INSERT INTO {schema_a}.{temp_table}

WITH src AS
(
  SELECT *
  FROM {schema_a}.{table_a}
  WHERE watershed_group_code = %s
),

downstream AS
(
    SELECT
      {id_a},
      array_agg(downstream_id) FILTER (WHERE downstream_id IS NOT NULL) AS downstream_ids
    FROM
        (SELECT
            a.{id_a},
            b.{id_b} as downstream_id
        FROM
            src a
        INNER JOIN {schema_b}.{table_b} b ON
        FWA_Downstream(
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
  downstream.downstream_ids AS {dnstr_ids_col}
FROM src a
LEFT OUTER JOIN downstream ON a.{id_a} = downstream.{id_a};