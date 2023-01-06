# Access model

Model stream accessibility for a given species (or species grouping). 

## Method description

1. Load various natural barrier inputs into standardized per-barrier-type tables: (`sql/barriers_*.sql`)
2. Collect barriers from 1. into per-species/species group tables, holding all non-anthropogenic barriers for the given species (`sql/model_barriers_<spp>`)
3. index barriers downstream, retain only the most downstream (to make processing far simpler)
4. segment streams at all barriers and at known/potential anthropogenic barriers (plus remediations for analysis/convenience)
5. analyze upstream-downstream connectivity of barriers for given species

## Process

Presuming that all required tables are present:

    make
