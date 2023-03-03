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

## Add a new species scenario

1. In root model folder, edit `data/wsg_species_precence.csv` to include column for given species, noting watershed groups where it occurs
2. add a new `sql/model_access_<spp>.sql` file defining barriers to the species, and what things may cancel barriers (observations, known habitat - see existing files)
3. update `sql/observations.sql` as required to ensure observations for species of interest are captured in model
4. update `sql/access.sql` to set output column to empty array where no barriers exist downstream
5. update `sql/streams_model_access.sql` to pull output column into streams table

Note that while steps 4 and 5 will potentially be automatically picked up by the model at some point if development continues - but steps 1/2/3 will always be required if adding a new species of interest. 