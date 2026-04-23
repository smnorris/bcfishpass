from pathlib import Path
import json
import jsonschema
import yaml

base = Path(__file__).parent.parent 	
config = yaml.safe_load(open(base / 'plan_config.yaml'))
schema = json.load(open(base / 'plan_config.schema.json'))

jsonschema.validate(config, schema)