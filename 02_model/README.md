# BC Fish Passage model

Model access/passability and spawning/rearing habitat.

Parameters defining where and how to run the model are included in two files. Edit these as necessary:

- `parameters_sample/param_watersheds.csv` - define which watersheds to process, which habitat model to use, and which species are present in the watershed
- `parameters_sample/param_habitat.csv` - define spawing/rearing habitat based on gradient and either discharge or channel width

To run the model:

    ./model.sh <path to parameters folder>

For changes to what features are included as barriers you will currently have to edit the various queries: `sql/barriers_*.sql`