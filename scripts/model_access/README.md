# Access model

Classify stream accessibility for a given species (or species grouping). Access model values:

```
ACCESSIBLE - no known natural barrier downstream, no modelled barrier downstream
ACCESSIBLE - REMEDIATED - no known natural barrier downstream, no modelled barrier downstream, remediated PSCIS crossing downstream
POTENTIALLY ACCESSIBLE - no known natural barriers downstream, potential (modelled crossing) barrier downstream
POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM` - no known natural barriers downstream, but a known PSCIS barrier exists downstream
```

## Method

1. load various inputs into per barrier type tables: (`sql/barriers_*.sql`)
2. collect barriers into per-species/species group tables, holding all non-anthropogenic barriers for the given species (`sql/model_barriers_<spp>`)
3. index barriers downstream, retain only the most downstream (to make processing far simpler)
4. segment streams at all barriers and at known/potential anthropogenic barriers (plus remediations for analysis/convenience)
5. analyze upstream-downstream connectivity of barriers for given species and output access model values

## Instructiosn

Presuming that all required tables are present:

    make

(generally, these scripts will be called from the root bcfishpass Makefile to ensure the various requirements are present)
