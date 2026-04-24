import pytest
from habitat_connectivity import build_query


def make_plan(target_species, filter_clause="watershed_group_code = 'TEST'"):
    return {
        "plan_code": "test",
        "target_species": target_species,
        "filter_clause": filter_clause,
        "connectivity_status_types": [],
    }


def test_sk_rearing_uses_flat_multiplier():
    sql = build_query(make_plan(["SK"]))
    assert "sum(st_length(s.geom) * 1.5) filter (where h.rearing_sk > 0" in sql


def test_sk_spawningrearing_uses_case_not_flat_multiplier():
    sql = build_query(make_plan(["SK"]))
    assert "case when h.rearing_sk > 0 then 1.5 else 1.0 end" in sql
    assert "sum(st_length(s.geom) * 1.5) filter (where greatest(h.spawning_sk" not in sql


def test_co_rearing_uses_edge_type_case():
    sql = build_query(make_plan(["CO"]))
    assert "case when s.edge_type = 1050 then 1.5 else 1.0 end" in sql


def test_co_spawningrearing_checks_rearing_before_multiplier():
    sql = build_query(make_plan(["CO"]))
    assert "case when h.rearing_co > 0 and s.edge_type = 1050 then 1.5 else 1.0 end" in sql


def test_untargeted_species_are_null():
    sql = build_query(make_plan(["CH"]))
    for sp in ["co", "sk", "st", "wct"]:
        assert f"null as total_rearing_{sp}" in sql
        assert f"null as total_spawning_{sp}" in sql
        assert f"null as total_spawningrearing_{sp}" in sql


def test_targeted_species_are_not_null():
    sql = build_query(make_plan(["CH", "CO"]))
    assert "null as total_rearing_ch" not in sql
    assert "null as total_rearing_co" not in sql


def test_sk_rearing_all_uses_additive_bonus():
    sql = build_query(make_plan(["SK"]))
    assert "coalesce(sum(st_length(s.geom) * 0.5) filter (where h.rearing_sk > 0" in sql


def test_accessible_versions_include_barrier_condition():
    sql = build_query(make_plan(["CH"]))
    assert "barriers_anthropogenic_dnstr IS NULL" in sql


def test_no_sk_co_adjustments_when_not_in_target_species():
    sql = build_query(make_plan(["CH", "ST"]))
    assert "1.5" not in sql
    assert "edge_type" not in sql


# -------------------------------------------------------------------
# Integration tests — require a live database with PostGIS
# ---------------------------------------------------------------- ---

import os
import psycopg2
import psycopg2.extras


@pytest.fixture(scope="module")
def db_conn():
    conn = psycopg2.connect(os.environ["DATABASE_URL"])
    yield conn
    conn.close()


@pytest.fixture(scope="module")
def test_tables(db_conn):
    """Create temporary test tables with known fixture data."""
    cur = db_conn.cursor()

    cur.execute("CREATE SCHEMA IF NOT EXISTS test")

    cur.execute("DROP TABLE IF EXISTS test.streams CASCADE")
    cur.execute("DROP TABLE IF EXISTS test.streams_habitat_linear CASCADE")
    cur.execute("DROP TABLE IF EXISTS test.streams_access CASCADE")

    cur.execute("""
        CREATE TABLE test.streams (
            segmented_stream_id  integer PRIMARY KEY,
            watershed_group_code text,
            edge_type            integer,
            geom                 geometry(LineString, 3005)
        )
    """)

    cur.execute("""
        CREATE TABLE test.streams_habitat_linear (
            segmented_stream_id  integer PRIMARY KEY,
            spawning_ch          numeric,
            spawning_co          numeric,
            spawning_sk          numeric,
            rearing_ch           numeric,
            rearing_co           numeric,
            rearing_sk           numeric,
            spawning_st          numeric,
            rearing_st           numeric,
            spawning_wct         numeric,
            rearing_wct          numeric
        )
    """)

    cur.execute("""
        CREATE TABLE test.streams_access (
            segmented_stream_id          integer PRIMARY KEY,
            barriers_anthropogenic_dnstr text[]
        )
    """)

    # Insert fixture rows — each is a 1000m straight line
    # Row 1: CH spawning+rearing, no barrier
    cur.execute("""
        INSERT INTO test.streams VALUES (1, 'TEST', 100,
            ST_MakeLine(ST_Point(0, 0), ST_Point(0, 1000)))
    """)
    cur.execute("INSERT INTO test.streams_habitat_linear VALUES (1, 1,0,0, 1,0,0, 0,0, 0,0)")
    cur.execute("INSERT INTO test.streams_access VALUES (1, NULL)")

    # Row 2: CO rearing, wetland (edge_type=1050), no barrier — expect 1.5x
    cur.execute("""
        INSERT INTO test.streams VALUES (2, 'TEST', 1050,
            ST_MakeLine(ST_Point(1000, 0), ST_Point(1000, 1000)))
    """)
    cur.execute("INSERT INTO test.streams_habitat_linear VALUES (2, 0,0,0, 0,1,0, 0,0, 0,0)")
    cur.execute("INSERT INTO test.streams_access VALUES (2, NULL)")

    # Row 3: CO rearing, non-wetland, no barrier — expect 1.0x
    cur.execute("""
        INSERT INTO test.streams VALUES (3, 'TEST', 100,
            ST_MakeLine(ST_Point(2000, 0), ST_Point(2000, 1000)))
    """)
    cur.execute("INSERT INTO test.streams_habitat_linear VALUES (3, 0,0,0, 0,1,0, 0,0, 0,0)")
    cur.execute("INSERT INTO test.streams_access VALUES (3, NULL)")

    # Row 4: SK rearing, no barrier — expect 1.5x
    cur.execute("""
        INSERT INTO test.streams VALUES (4, 'TEST', 100,
            ST_MakeLine(ST_Point(3000, 0), ST_Point(3000, 1000)))
    """)
    cur.execute("INSERT INTO test.streams_habitat_linear VALUES (4, 0,0,0, 0,0,1, 0,0, 0,0)")
    cur.execute("INSERT INTO test.streams_access VALUES (4, NULL)")

    # Row 5: SK spawning only (no rearing), no barrier — expect 1.0x (no adjustment)
    cur.execute("""
        INSERT INTO test.streams VALUES (5, 'TEST', 100,
            ST_MakeLine(ST_Point(4000, 0), ST_Point(4000, 1000)))
    """)
    cur.execute("INSERT INTO test.streams_habitat_linear VALUES (5, 0,0,1, 0,0,0, 0,0, 0,0)")
    cur.execute("INSERT INTO test.streams_access VALUES (5, NULL)")

    # Row 6: CO rearing, wetland, WITH barrier — excluded from accessible
    cur.execute("""
        INSERT INTO test.streams VALUES (6, 'TEST', 1050,
            ST_MakeLine(ST_Point(5000, 0), ST_Point(5000, 1000)))
    """)
    cur.execute("INSERT INTO test.streams_habitat_linear VALUES (6, 0,0,0, 0,1,0, 0,0, 0,0)")
    cur.execute("INSERT INTO test.streams_access VALUES (6, ARRAY['99'])")

    db_conn.commit()
    yield
    cur.execute("DROP SCHEMA test CASCADE")
    db_conn.commit()
    cur.close()


def test_db_sums(db_conn, test_tables):
    plan = {
        "plan_code": "test",
        "target_species": ["CH", "CO", "SK"],
        "filter_clause": "s.watershed_group_code = 'TEST'",
        "connectivity_status_types": [],
    }

    # Rewrite table references to use test schema
    sql = build_query(plan)
    sql = sql.replace("bcfishpass.streams s", "test.streams s")
    sql = sql.replace("bcfishpass.streams_habitat_linear h", "test.streams_habitat_linear h")
    sql = sql.replace("bcfishpass.streams_access a", "test.streams_access a")
    sql = sql.replace("(SELECT max(model_run_id) FROM bcfishpass.log)", "1")

    cur = psycopg2.extras.RealDictCursor(db_conn)
    cur.execute(sql)
    row = cur.fetchone()

    length = 1000.0  # each line is 1000m

    # CH: 1 row spawning+rearing, no multiplier
    assert float(row["total_spawning_ch"]) == pytest.approx(length)
    assert float(row["total_rearing_ch"]) == pytest.approx(length)
    assert float(row["total_spawningrearing_ch"]) == pytest.approx(length)

    # CO rearing: row 2 (wetland, 1.5x) + row 3 (non-wetland, 1.0x) + row 6 (wetland, 1.5x, has barrier)
    # total = 1000*1.5 + 1000*1.0 + 1000*1.5 = 4000
    assert float(row["total_rearing_co"]) == pytest.approx(4000.0)
    # accessible CO rearing: row 2 (1.5x) + row 3 (1.0x) only, row 6 excluded
    # accessible = 1000*1.5 + 1000*1.0 = 2500
    assert float(row["accessible_rearing_co"]) == pytest.approx(2500.0)

    # SK rearing: row 4 only, 1.5x
    assert float(row["total_rearing_sk"]) == pytest.approx(length * 1.5)
    assert float(row["accessible_rearing_sk"]) == pytest.approx(length * 1.5)

    # SK spawningrearing: row 4 (rearing, 1.5x) + row 5 (spawning only, 1.0x)
    assert float(row["total_spawningrearing_sk"]) == pytest.approx(length * 1.5 + length * 1.0)

    # SK spawning only: row 5
    assert float(row["total_spawning_sk"]) == pytest.approx(length)