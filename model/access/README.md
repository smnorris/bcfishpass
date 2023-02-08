# Access model

Model stream accessibility for a given species (or species grouping). 

## Model method

1. Load various natural barrier records from source tables into standardized per-barrier-type tables: (`sql/barriers_*.sql`)
2. Collect barriers from 1. into per-species/species group tables, holding all non-anthropogenic barriers for the given species (`sql/model_barriers_<spp>`)
3. Optionally, cancel barriers if they are downstream of known observations of the species of interest.
4. Index barriers downstream, retain only the most downstream (to make processing far simpler)
5. Segment streams at barriers (and potential barriers).
6. Identify all stream downstream of known barriers to the given species.

## Process

    make

## Modify

To modify a model for a given species, edit `sql/model_barriers_<spp>.sql` to match the required criteria (for example, modify the maximum gradient barrier threshold)

## Add new species scenarios

To process additional access model(s), add a new query that defines natural barriers for the species (for example, greyling: `sql/model_barriers_gr.sql`)

