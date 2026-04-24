import json
import os
import textwrap
import click
import psycopg2.extras
from pathlib import Path
import yaml
import psycopg2


def load_config():
    base = Path(__file__).parent.parent
    return yaml.safe_load(open(base / "plan_config.yaml"))


def get_species_columns(prefix, target_species):
    """Return list of column expressions for given prefix and target species."""
    return [f"h.{prefix}_{s.lower()}" for s in target_species]


def build_query(plan):
    target_species = plan["target_species"]
    filter_clause = plan["filter_clause"]
    plan_code = plan["plan_code"]

    spawning_cols = get_species_columns("spawning", target_species)
    rearing_cols = get_species_columns("rearing", target_species)
    spawning_expr = ", ".join(spawning_cols)
    rearing_expr = ", ".join(rearing_cols)
    spawning_rearing_expr = ", ".join(spawning_cols + rearing_cols)

    def total_species_sums(accessible=False):
        condition = "and a.barriers_anthropogenic_dnstr IS NULL" if accessible else ""
        prefix = "accessible" if accessible else "total"
        indent = "            "
        lines = []
        all_species = ["ch", "co", "sk", "st", "wct"]
        for sp in all_species:
            if sp.upper() in target_species:
                lines.append(f"{indent}sum(st_length(s.geom)) filter (where h.spawning_{sp} > 0 {condition}) as {prefix}_spawning_{sp}")
            else:
                lines.append(f"{indent}null as {prefix}_spawning_{sp}")
        for sp in all_species:
            if sp.upper() in target_species:
                lines.append(f"{indent}sum(st_length(s.geom)) filter (where h.rearing_{sp} > 0 {condition}) as {prefix}_rearing_{sp}")
            else:
                lines.append(f"{indent}null as {prefix}_rearing_{sp}")
        for sp in all_species:
            if sp.upper() in target_species:
                lines.append(f"{indent}sum(st_length(s.geom)) filter (where greatest(h.spawning_{sp}, h.rearing_{sp}) > 0 {condition}) as {prefix}_spawningrearing_{sp}")
            else:
                lines.append(f"{indent}null as {prefix}_spawningrearing_{sp}")
        lines.append(f"{indent}sum(st_length(s.geom)) filter (where greatest({spawning_expr}) > 0 {condition}) as {prefix}_spawning_all")
        lines.append(f"{indent}sum(st_length(s.geom)) filter (where greatest({rearing_expr}) > 0 {condition}) as {prefix}_rearing_all")
        lines.append(f"{indent}sum(st_length(s.geom)) filter (where greatest({spawning_rearing_expr}) > 0 {condition}) as {prefix}_spawningrearing_all")
        return ",\n".join(lines)

    query = textwrap.dedent(f"""
        SELECT
            (SELECT max(model_run_id) FROM bcfishpass.log) as model_run_id,
            '{plan_code}' as wcrp,
            s.watershed_group_code,
{total_species_sums(accessible=False)},
{total_species_sums(accessible=True)}
        FROM bcfishpass.streams s
        INNER JOIN bcfishpass.streams_habitat_linear h USING (segmented_stream_id)
        INNER JOIN bcfishpass.streams_access a USING (segmented_stream_id)
        WHERE {filter_clause.replace(chr(10), chr(10) + "        ")}
        GROUP BY s.watershed_group_code
    """)
    return query


def process_plan(cur, plan):
    query = build_query(plan)
    insert = textwrap.dedent(f"""
        INSERT INTO bcfishpass.log_wcrp_habitat_connectivity (
            model_run_id,
            wcrp,
            watershed_group_code,
            total_spawning_ch,
            total_spawning_co,
            total_spawning_sk,
            total_spawning_st,
            total_spawning_wct,
            total_rearing_ch,
            total_rearing_co,
            total_rearing_sk,
            total_rearing_st,
            total_rearing_wct,
            total_spawningrearing_ch,
            total_spawningrearing_co,
            total_spawningrearing_sk,
            total_spawningrearing_st,
            total_spawningrearing_wct,
            total_spawning_all,
            total_rearing_all,
            total_spawningrearing_all,
            accessible_spawning_ch,
            accessible_spawning_co,
            accessible_spawning_sk,
            accessible_spawning_st,
            accessible_spawning_wct,
            accessible_rearing_ch,
            accessible_rearing_co,
            accessible_rearing_sk,
            accessible_rearing_st,
            accessible_rearing_wct,
            accessible_spawningrearing_ch,
            accessible_spawningrearing_co,
            accessible_spawningrearing_sk,
            accessible_spawningrearing_st,
            accessible_spawningrearing_wct,
            accessible_spawning_all,
            accessible_rearing_all,
            accessible_spawningrearing_all
        )
        {query}
    """)
    cur.execute(insert)
    print(f"Inserted {cur.rowcount} row(s) for plan '{plan['plan_code']}'")


@click.group()
def cli():
    """WCRP habitat connectivity loader/dumper"""
    pass


@cli.command()
@click.option("--dry-run", is_flag=True, help="Print SQL to stdout instead of executing.")
def load(dry_run):
    """Load all plans to the habitat connectivity log table."""
    plans = load_config()

    if dry_run:
        for plan in plans:
            click.echo(build_query(plan))
        return

    conn = psycopg2.connect(os.environ["DATABASE_URL"])
    cur = psycopg2.extras.RealDictCursor(conn)

    for plan in plans:
        process_plan(cur, plan)

    conn.commit()
    cur.close()
    conn.close()


@cli.command()
@click.argument("wcrp", required=False)
def dump(wcrp):
    """Dump habitat connectivity results for most recent model run as JSON. Optionally filter by PLAN_CODE."""
    config = load_config()

    if wcrp is not None:
        plans = [p for p in config if p["plan_code"] == wcrp]
        if not plans:
            raise click.BadParameter(f"No plan found with plan_code '{wcrp}'", param_hint="WCRP")
    else:
        plans = config

    conn = psycopg2.connect(os.environ["DATABASE_URL"])
    cur = psycopg2.extras.RealDictCursor(conn)

    results = []
    for plan in plans:
        cols = ", ".join(
            ["wcrp", "watershed_group_code"]
            + [f"total_{c}" for c in plan["connectivity_status_types"]]
            + [f"accessible_{c}" for c in plan["connectivity_status_types"]]
            + [f"disconnected_{c}" for c in plan["connectivity_status_types"]]
            + [f"pct_accessible_{c}" for c in plan["connectivity_status_types"]]
        )
        cur.execute(textwrap.dedent(f"""
            SELECT {cols}
            FROM bcfishpass.wcrp_habitat_connectivity_status_vw
            WHERE wcrp = '{plan["plan_code"]}'
        """))
        results.extend([dict(row) for row in cur.fetchall()])

    click.echo(json.dumps(results, indent=2, default=str))

    cur.close()
    conn.close()


if __name__ == "__main__":
    cli()