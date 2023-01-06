# Script for adding downstream_ids / upstream_ids to points tables
# (a bit too slow for processing the streams table),
# plus running dynamic sql for generating point report.

import os
from urllib.parse import urlparse
from pathlib import Path
import multiprocessing
from functools import partial
import logging

import click
import psycopg2
from psycopg2 import sql

log = logging.getLogger(__name__)


class Database(object):
    """wrapper around a psycopg connection"""

    def __init__(self, url=os.environ.get("DATABASE_URL")):
        self.url = url
        u = urlparse(url)
        db, user, password, host, port = (
            u.path[1:],
            u.username,
            u.password,
            u.hostname,
            u.port,
        )
        self.database = db
        self.user = user
        self.password = password
        self.host = host
        self.port = u.port
        self.ogr_string = f"PG:host={host} user={user} dbname={db} port={port}"
        if self.password:
            self.ogr_string = self.ogr_string + f" password={password}"
        self.conn = psycopg2.connect(url)
        self.conn.autocommit = True
        # make sure postgis is available
        try:
            self.query("SELECT postgis_full_version()")
        except psycopg2.errors.UndefinedFunction:
            log.error("Cannot find PostGIS, is extension added to database %s ?", url)
            raise psycopg2.errors.UndefinedFunction

    @property
    def schemas(self):
        """List all non-system schemas in db"""
        sql = """SELECT schema_name FROM information_schema.schemata
                 ORDER BY schema_name"""
        schemas = self.query(sql)
        return [s[0] for s in schemas if s[0][:3] != "pg_"]

    @property
    def tables(self):
        """List all non-system tables in the db"""
        tables = []
        for schema in self.schemas:
            tables = tables + [schema + "." + t for t in self.tables_in_schema(schema)]
        return tables

    def parse_table_name(self, table):
        """Parse schema qualified table name"""
        if "." in table:
            schema, table = table.split(".")
        else:
            schema = None
        return (schema, table)

    def tables_in_schema(self, schema):
        """Get a listing of all tables in given schema"""
        sql = """SELECT table_name
                 FROM information_schema.tables
                 WHERE table_schema = %s"""
        return [t[0] for t in self.query(sql, (schema,))]

    def query(self, sql, params=None):
        """Execute sql and return all results"""
        with self.conn:
            with self.conn.cursor() as curs:
                curs.execute(sql, params)
                result = curs.fetchall()
        return result

    def execute(self, sql, params=None):
        """Execute sql and return only whether the query was successful"""
        with self.conn:
            with self.conn.cursor() as curs:
                result = curs.execute(sql, params)
        return result

    def execute_many(self, sql, params):
        """Execute many sql"""
        with self.conn:
            with self.conn.cursor() as curs:
                curs.executemany(sql, params)

    def get_type(self, schema, table, column):
        """Return type for given schema/table/column"""
        return self.query("""select data_type from information_schema.columns
                      where table_schema = {schema}
                      and table_name = {table}
                      and column_name = {column}""")[0]


def execute_parallel(sql, wsg):
    """Execute sql for specified wsg using a non-pooled, non-parallel conn
    """
    db = Database()
    # Turn off parallel execution for this connection, because we are
    # handling the parallelization ourselves
    db.execute("SET max_parallel_workers_per_gather = 0")
    db.execute(sql, (wsg,))


def read_file(path_string):
    p = Path(path_string)
    with open(p, mode="r") as f:
        return f.read()


def create_indexes(table):
    """create usual fwa indexes
    """
    db = Database()
    schema, table = db.parse_table_name(table)
    db.execute(
        f"""CREATE INDEX ON {schema}.{table} (linear_feature_id);
    CREATE INDEX ON {schema}.{table} (blue_line_key);
    CREATE INDEX ON {schema}.{table} (watershed_group_code);
    CREATE INDEX ON {schema}.{table} USING GIST (wscode_ltree);
    CREATE INDEX ON {schema}.{table} USING BTREE (wscode_ltree);
    CREATE INDEX ON {schema}.{table} USING GIST (localcode_ltree);
    CREATE INDEX ON {schema}.{table} USING BTREE (localcode_ltree);
    CREATE INDEX ON {schema}.{table} USING GIST (geom);
    """
    )


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
def add_downstream_ids(
    table_a, id_a, table_b, id_b, downstream_ids_col, include_equivalent_measure
):
    """note downstream ids
    """
    db = Database()

    schema_a, table_a = db.parse_table_name(table_a)
    schema_b, table_b = db.parse_table_name(table_b)
    # ensure that any existing values get removed
    db.execute(
        f"ALTER TABLE {schema_a}.{table_a} DROP COLUMN IF EXISTS {downstream_ids_col}"
    )
    temp_table = table_a + "_tmp"
    db.execute(f"DROP TABLE IF EXISTS {schema_a}.{temp_table}")
    db.execute(f"CREATE TABLE {schema_a}.{temp_table} (LIKE {schema_a}.{table_a})")
    db.execute(
        f"ALTER TABLE {schema_a}.{temp_table} ADD COLUMN {downstream_ids_col} text[]"
    )
    groups = sorted(
        [
            g[0]
            for g in db.query(
                f"SELECT DISTINCT watershed_group_code from {schema_a}.{table_a}"
            )
        ]
    )
    # todo - is this really the best way to specify which query to use?
    if include_equivalent_measure:
        q = "sql/add_downstream_and_equivalent_ids.sql"
    else:
        q = "sql/add_downstream_ids.sql"
    query = sql.SQL(read_file(q)).format(
        schema_a=sql.Identifier(schema_a),
        schema_b=sql.Identifier(schema_b),
        temp_table=sql.Identifier(temp_table),
        table_a=sql.Identifier(table_a),
        table_b=sql.Identifier(table_b),
        id_a=sql.Identifier(id_a),
        id_b=sql.Identifier(id_b),
        dnstr_ids_col=sql.Identifier(downstream_ids_col),
    )
    # run each group in parallel
    func = partial(execute_parallel, query)
    n_processes = multiprocessing.cpu_count() - 1
    pool = multiprocessing.Pool(processes=n_processes)
    pool.map(func, groups)
    pool.close()
    pool.join()
    # drop source table, rename new table, re-create indexes
    db.execute(f"DROP TABLE IF EXISTS {schema_a}.{table_a}")
    db.execute(f"ALTER TABLE {schema_a}.{temp_table} RENAME TO {table_a}")
    create_indexes(f"{schema_a}.{table_a}")
    db.execute(f"ALTER TABLE {schema_a}.{table_a} ADD PRIMARY KEY ({id_a})")
    # make sure the table gets analyzed before running this again
    db.conn.set_isolation_level(0)
    cur = db.conn.cursor()
    cur.execute(f"VACUUM ANALYZE {schema_a}.{table_a}")


@cli.command()
@click.argument("table_a")
@click.argument("id_a")
@click.argument("table_b")
@click.argument("id_b")
@click.argument("out_table")
@click.argument("downstream_ids_col")
@click.option("--include_equivalent_measure", default=False, is_flag=True)
def add_downstream_ids_2(
    table_a, id_a, table_b, id_b, out_table, downstream_ids_col, include_equivalent_measure
):
    """record aggregated records in table b that are downstream of records in table a
    """
    db = Database()

    schema_a, table_a = db.parse_table_name(table_a)
    schema_b, table_b = db.parse_table_name(table_b)
    # ensure table does not already exist
    db.execute(f"drop table if exists {out_table}")
    id_a_type = db.get_type(schema_a, table_a, id_a)
    db.execute(f"""create table {out_table} (
        {id_a} {id_a_type} primary key, 
        {downstream_ids_col} [text])""")
    
    groups = sorted(
        [
            g[0]
            for g in db.query(
                f"SELECT DISTINCT watershed_group_code from {schema_a}.{table_a}"
            )
        ]
    )
    query = sql.SQL(read_file(q)).format(
        schema_a=sql.Identifier(schema_a),
        schema_b=sql.Identifier(schema_b),
        table_a=sql.Identifier(table_a),
        table_b=sql.Identifier(table_b),
        id_a=sql.Identifier(id_a),
        id_b=sql.Identifier(id_b),
        dnstr_ids_col=sql.Identifier(downstream_ids_col),
    )
    # run each group in parallel
    func = partial(execute_parallel, query)
    n_processes = multiprocessing.cpu_count() - 1
    pool = multiprocessing.Pool(processes=n_processes)
    pool.map(func, groups)
    pool.close()
    pool.join()
    # drop source table, rename new table, re-create indexes
    db.execute(f"DROP TABLE IF EXISTS {schema_a}.{table_a}")
    db.execute(f"ALTER TABLE {schema_a}.{temp_table} RENAME TO {table_a}")
    create_indexes(f"{schema_a}.{table_a}")
    db.execute(f"ALTER TABLE {schema_a}.{table_a} ADD PRIMARY KEY ({id_a})")
    # make sure the table gets analyzed before running this again
    db.conn.set_isolation_level(0)
    cur = db.conn.cursor()
    cur.execute(f"VACUUM ANALYZE {schema_a}.{table_a}")


@cli.command()
@click.argument("table_a")
@click.argument("id_a")
@click.argument("table_b")
@click.argument("id_b")
@click.argument("upstream_ids_col")
def add_upstream_ids(table_a, id_a, table_b, id_b, upstream_ids_col):
    """note upstream ids
    """
    db = Database()
    schema_a, table_a = db.parse_table_name(table_a)
    schema_b, table_b = db.parse_table_name(table_b)
    # ensure that any existing values get removed
    db.execute(
        f"ALTER TABLE {schema_a}.{table_a} DROP COLUMN IF EXISTS {upstream_ids_col}"
    )
    temp_table = table_a + "_tmp"
    db.execute(f"DROP TABLE IF EXISTS {schema_a}.{temp_table}")
    db.execute(f"CREATE TABLE {schema_a}.{temp_table} (LIKE {schema_a}.{table_a})")
    db.execute(
        f"ALTER TABLE {schema_a}.{temp_table} ADD COLUMN {upstream_ids_col} text[]"
    )
    groups = sorted(
        [
            g[0]
            for g in db.query(
                f"SELECT DISTINCT watershed_group_code from {schema_a}.{table_a}"
            )
        ]
    )
    query = sql.SQL(read_file("sql/add_upstream_ids.sql")).format(
        schema_a=sql.Identifier(schema_a),
        schema_b=sql.Identifier(schema_b),
        temp_table=sql.Identifier(temp_table),
        table_a=sql.Identifier(table_a),
        table_b=sql.Identifier(table_b),
        id_a=sql.Identifier(id_a),
        id_b=sql.Identifier(id_b),
        upstr_ids_col=sql.Identifier(upstream_ids_col),
    )
    # run each group in parallel
    func = partial(execute_parallel, query)
    n_processes = multiprocessing.cpu_count() - 1
    pool = multiprocessing.Pool(processes=n_processes)
    pool.map(func, groups)
    pool.close()
    pool.join()
    # drop source table, rename new table, re-create indexes
    db.execute(f"DROP TABLE IF EXISTS {schema_a}.{table_a}")
    db.execute(f"ALTER TABLE {schema_a}.{temp_table} RENAME TO {table_a}")
    create_indexes(f"{schema_a}.{table_a}")
    db.execute(f"ALTER TABLE {schema_a}.{table_a} ADD PRIMARY KEY ({id_a})")
    db.conn.set_isolation_level(0)
    cur = db.conn.cursor()
    cur.execute(f"VACUUM ANALYZE {schema_a}.{table_a}")


@cli.command()
@click.argument("point_table")
@click.argument("point_id")
@click.argument("barriers_table")
@click.argument("dnstr_barriers_id")
def report(point_table, point_id, barriers_table, dnstr_barriers_id):
    """run sql/point_report.sql against the specified tables"""
    db = Database()
    point_schema, point_table = db.parse_table_name(point_table)
    barriers_schema, barriers_table = db.parse_table_name(barriers_table)
    for n in range(1, 6):
        print(f"running point_report{n}.sql")
        query = sql.SQL(read_file(f"sql/point_report{n}.sql")).format(
            point_table=sql.Identifier(point_table),
            point_id=sql.Identifier(point_id),
            barriers_table=sql.Identifier(barriers_table),
            dnstr_barriers_id=sql.Identifier(dnstr_barriers_id),
        )
        db.execute(query)


if __name__ == "__main__":
    cli()
