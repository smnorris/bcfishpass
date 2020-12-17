from pathlib import Path
import multiprocessing
from functools import partial

import click
from psycopg2 import sql
import pgdata


def execute_parallel(sql, wsg):
    """Execute sql for specified wsg using a non-pooled, non-parallel conn
    """
    # specify multiprocessing when creating to disable connection pooling
    db = pgdata.connect(multiprocessing=True)
    conn = db.engine.raw_connection()
    cur = conn.cursor()
    # Turn off parallel execution for this connection, because we are
    # handling the parallelization ourselves
    cur.execute("SET max_parallel_workers_per_gather = 0")
    cur.execute(sql, (wsg,))
    conn.commit()
    cur.close()
    conn.close()


def read_file(path_string):
    p = Path(path_string)
    with open(p, mode='r') as f:
        return f.read()


def create_indexes(table):
    """create usual fwa indexes
    """
    db = pgdata.connect()
    schema, table = db.parse_table_name(table)
    db.execute(f"""CREATE INDEX ON {schema}.{table} (linear_feature_id);
    CREATE INDEX ON {schema}.{table} (blue_line_key);
    CREATE INDEX ON {schema}.{table} (watershed_group_code);
    CREATE INDEX ON {schema}.{table} USING GIST (wscode_ltree);
    CREATE INDEX ON {schema}.{table} USING BTREE (wscode_ltree);
    CREATE INDEX ON {schema}.{table} USING GIST (localcode_ltree);
    CREATE INDEX ON {schema}.{table} USING BTREE (localcode_ltree);
    CREATE INDEX ON {schema}.{table} USING GIST (geom);
    """)


@click.group()
def cli():
    pass


@cli.command()
@click.argument("table_a")
@click.argument("id_a")
@click.argument("table_b")
@click.argument("id_b")
@click.argument("downstream_ids_col")
@click.option("--include_equivalent_measure", default=False, is_flag=True)
def add_downstream_ids(table_a, id_a, table_b, id_b, downstream_ids_col, include_equivalent_measure):
    """note downstream ids
    """
    db = pgdata.connect()
    schema_a, table_a = db.parse_table_name(table_a)
    schema_b, table_b = db.parse_table_name(table_b)
    # ensure that any existing values get removed
    db.execute(f"ALTER TABLE {schema_a}.{table_a} DROP COLUMN IF EXISTS {downstream_ids_col}")
    temp_table = table_a + "_tmp"
    db[f"{schema_a}.{temp_table}"].drop()
    db.execute(f"CREATE TABLE {schema_a}.{temp_table} (LIKE {schema_a}.{table_a})")
    db.execute(f"ALTER TABLE {schema_a}.{temp_table} ADD COLUMN {downstream_ids_col} integer[]")
    groups = sorted([g[0] for g in db.query(f"SELECT DISTINCT watershed_group_CODE from {schema_a}.{table_a}")])
    # todo - is this really the best way to specify which query to use?
    if include_equivalent_measure:
        q = "sql/00_add_downstream_and_equivalent_ids.sql"
    else:
        q = "sql/00_add_downstream_ids.sql"
    query = sql.SQL(read_file(q)).format(
        schema_a=sql.Identifier(schema_a),
        schema_b=sql.Identifier(schema_b),
        temp_table=sql.Identifier(temp_table),
        table_a=sql.Identifier(table_a),
        table_b=sql.Identifier(table_b),
        id_a=sql.Identifier(id_a),
        id_b=sql.Identifier(id_b),
        dnstr_ids_col=sql.Identifier(downstream_ids_col)
    )
    # run each group in parallel
    func = partial(execute_parallel, query)
    n_processes = multiprocessing.cpu_count() - 1
    pool = multiprocessing.Pool(processes=n_processes)
    pool.map(func, groups)
    pool.close()
    pool.join()
    # drop source table, rename new table, re-create indexes
    db[f"{schema_a}.{table_a}"].drop()
    db.execute(f"ALTER TABLE {schema_a}.{temp_table} RENAME TO {table_a}")
    create_indexes(f"{schema_a}.{table_a}")
    db.execute(f"ALTER TABLE {schema_a}.{table_a} ADD PRIMARY KEY ({id_a})")
    # make sure the table gets analyzed before running this again
    conn = db.engine.raw_connection()
    conn.set_isolation_level(0)
    cur = conn.cursor()
    cur.execute(f"VACUUM ANALYZE {schema_a}.{table_a}")
    # downstream ids are stored as intarray, we could index them
    #db.execute(f"CREATE INDEX ON {schema_a}.{table_a} USING GIST ({downstream_ids_col} gist__int_ops);")


@cli.command()
@click.argument("table_a")
@click.argument("id_a")
@click.argument("table_b")
@click.argument("id_b")
@click.argument("upstream_ids_col")
def add_upstream_ids(table_a, id_a, table_b, id_b, upstream_ids_col):
    """note upstream ids
    """
    db = pgdata.connect()
    schema_a, table_a = db.parse_table_name(table_a)
    schema_b, table_b = db.parse_table_name(table_b)
    # ensure that any existing values get removed
    db.execute(f"ALTER TABLE {schema_a}.{table_a} DROP COLUMN IF EXISTS {upstream_ids_col}")
    temp_table = table_a + "_tmp"
    db[f"{schema_a}.{temp_table}"].drop()
    db.execute(f"CREATE TABLE {schema_a}.{temp_table} (LIKE {schema_a}.{table_a})")
    db.execute(f"ALTER TABLE {schema_a}.{temp_table} ADD COLUMN {upstream_ids_col} integer[]")
    groups = sorted([g[0] for g in db.query(f"SELECT DISTINCT watershed_group_code from {schema_a}.{table_a}")])
    query = sql.SQL(read_file("sql/00_add_upstream_ids.sql")).format(
        schema_a=sql.Identifier(schema_a),
        schema_b=sql.Identifier(schema_b),
        temp_table=sql.Identifier(temp_table),
        table_a=sql.Identifier(table_a),
        table_b=sql.Identifier(table_b),
        id_a=sql.Identifier(id_a),
        id_b=sql.Identifier(id_b),
        upstr_ids_col=sql.Identifier(upstream_ids_col)
    )
    # run each group in parallel
    func = partial(execute_parallel, query)
    n_processes = multiprocessing.cpu_count() - 1
    pool = multiprocessing.Pool(processes=n_processes)
    pool.map(func, groups)
    pool.close()
    pool.join()
    # drop source table, rename new table, re-create indexes
    db[f"{schema_a}.{table_a}"].drop()
    db.execute(f"ALTER TABLE {schema_a}.{temp_table} RENAME TO {table_a}")
    create_indexes(f"{schema_a}.{table_a}")
    db.execute(f"ALTER TABLE {schema_a}.{table_a} ADD PRIMARY KEY ({id_a})")
    conn = db.engine.raw_connection()
    conn.set_isolation_level(0)
    cur = conn.cursor()
    cur.execute(f"VACUUM ANALYZE {schema_a}.{table_a}")


@cli.command()
@click.argument("stream_table")
@click.argument("point_table")
def segment_streams(stream_table, point_table):
    """
    Break streams at points.

    Break lines in stream_table at each location specified in point_table
    Points are defined as blue_line_key / route measure (not geom).
    Each table must have the standard FWA columns.
    """
    db = pgdata.connect()
    stream_schema, stream_table = db.parse_table_name(stream_table)
    point_schema, point_table = db.parse_table_name(point_table)
    groups = [g[0] for g in db.query(f"SELECT DISTINCT watershed_group_CODE FROM bcfishpass.streams")]
    query = sql.SQL(read_file("sql/00_segment_streams.sql")).format(
        stream_schema=sql.Identifier(stream_schema),
        stream_table=sql.Identifier(stream_table),
        point_schema=sql.Identifier(point_schema),
        point_table=sql.Identifier(point_table)
    )
    func = partial(execute_parallel, query)
    n_processes = multiprocessing.cpu_count() - 1
    pool = multiprocessing.Pool(processes=n_processes)
    pool.map(func, groups)
    pool.close()
    pool.join()


@cli.command()
@click.argument("point_table")
@click.argument("point_id")
@click.argument("dnstr_barriers_id")
def report(point_table, point_id, dnstr_barriers_id):
    db = pgdata.connect()
    point_schema, point_table = db.parse_table_name(point_table)
    query = sql.SQL(read_file("sql/00_report.sql")).format(
        point_schema=sql.Identifier(point_schema),
        point_table=sql.Identifier(point_table),
        point_id=sql.Identifier(point_id),
        dnstr_barriers_id=sql.Identifier(dnstr_barriers_id)
    )
    conn = db.engine.raw_connection()
    cur = conn.cursor()
    cur.execute(query)
    conn.commit()


if __name__ == "__main__":
    cli()
