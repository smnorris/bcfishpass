from pathlib import Path
import json
import jsonschema
import psycopg2
import yaml

base = Path(__file__).parent.parent 	
config = yaml.safe_load(open(base / 'plan_config.yaml'))
schema = json.load(open(base / 'plan_config.schema.json'))

# is schema valid json?
jsonschema.validate(config, schema)

# does the provided query return any stream data?
conn = psycopg2.connect(os.environ['DATABASE_URL'])
cur = conn.cursor()

errors = []
for plan in config:
    sql = f"EXPLAIN SELECT * FROM whse_basemapping.fwa_stream_networks_sp WHERE {plan['filter_clause']}"
    try:
        cur.execute(sql)
    except psycopg2.Error as e:
        errors.append(f"{plan['plan_code']}: {e}")

if errors:
    for e in errors:
        print(e)
    sys.exit(1)