# BC Fish Passage model

Model access/passability and spawning/rearing habitat.

Two parameters files are provided for control of where and how to run the model:

- `parameters/param_watersheds.csv` - define which watersheds to process, which habitat model to use, and which species are present in the watershed
- `parameters/param_habitat.csv` - define spawing/rearing habitat based on gradient and either discharge or channel width


For changes to what features are included as barriers you will currently have to edit the various queries: `sql/barriers_*.sql`