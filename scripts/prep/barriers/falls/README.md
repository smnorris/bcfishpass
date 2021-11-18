# Falls

Download waterfall data from various sources, match to FWA stream network, identify barriers.

## Sources

- FISS obstacles, [BC Data Catalogue](https://catalogue.data.gov.bc.ca/dataset/provincial-obstacles-to-fish-passage)
- FISS obstacles, [unpublished](https://www.hillcrestgeo.ca/outgoing/public/whse_fish)
- FWA obstructions, [BC Data Catalogue](https://catalogue.data.gov.bc.ca/dataset/freshwater-atlas-obstructions)
- Additional user compiled falls, [falls_other.csv](data/falls_other.csv)
- User modification of fall barrier status, [falls_barrier_ind.csv](../../../data/falls_other.csv)


## Barrier status logic

A fall is identified as a barrier if one of these conditions is met:

- data source is a FISS obstacles / FISS obstacles unpublished *AND* height >= 5m
- data source is FWA obstructions (this data source does not include a height)
- `barrier_ind = True`  for the given falls in `falls_other.csv`
- `barrier_ind = True`  for the given falls in `falls_barrier_ind.csv`

Overriding the above logic, a fall is automatically identified as passable if there are FISS known fish observations (anadramous species) upstream of the falls.


## Processing

1. Add records/edit `falls_other.csv` as required
2. Add records/edit `falls_barrier_ind.csv` as required
3. Process the input data, create `bcfishpass.falls`, note observations upstream:

        ./falls.sh


## Review and QA

Falls that would otherwise be considered barriers should be reviewed if there are few observations upstream.
Review barrier status of these falls with this query, identify any falls that are likely to be invalid, then add them to the `falls_barrier_ind.csv` with `barrier_ind = F`

```
SELECT
  f.blue_line_key,
  f.downstream_route_measure,
  f.source,
  f.height,
  b.barrier_ind
FROM bcfishpass.falls f
LEFT OUTER JOIN bcfishpass.falls_barrier_ind b
ON f.blue_line_key = b.blue_line_key
AND f.downstream_route_measure = b.downstream_route_measure
WHERE f.barrier_ind is False
AND (
    (source = 'FISS' AND height >= 5) OR
    source = 'FWA'
)
AND b.barrier_ind IS NULL
AND upstr_observed_anad_count <=2;
```


## Output table

`bcfishpass.falls` contains all known falls features - only features of `barrier_ind IS TRUE` are used for connectivity modelling.
Note that there is no ID used as a primary key. This is because the FISS Obstacles table does not have a stable primary key - we use `blue_line_key` and `downstream_route_measure` as the primary key.
```
                                                  Table "bcfishpass.falls"
          Column          |         Type         | Collation | Nullable |                      Default
--------------------------+----------------------+-----------+----------+----------------------------------------------------
 source                   | text                 |           |          |
 height                   | double precision     |           |          |
 barrier_ind              | boolean              |           |          |
 reviewer                 | text                 |           |          |
 notes                    | text                 |           |          |
 distance_to_stream       | double precision     |           |          |
 linear_feature_id        | bigint               |           |          |
 blue_line_key            | integer              |           |          |
 downstream_route_measure | double precision     |           |          |
 wscode_ltree             | ltree                |           |          |
 localcode_ltree          | ltree                |           |          |
 watershed_group_code     | text                 |           |          |
 geom                     | geometry(Point,3005) |           |          |
Indexes:
    "falls_pkey" PRIMARY KEY, btree (falls_id)
    "falls_blue_line_key_downstream_route_measure_key" UNIQUE CONSTRAINT, btree (blue_line_key, downstream_route_measure)
    "falls_blue_line_key_idx" btree (blue_line_key)
    "falls_geom_idx" gist (geom)
    "falls_linear_feature_id_idx" btree (linear_feature_id)
    "falls_localcode_ltree_idx" gist (localcode_ltree)
    "falls_localcode_ltree_idx1" btree (localcode_ltree)
    "falls_wscode_ltree_idx" gist (wscode_ltree)
    "falls_wscode_ltree_idx1" btree (wscode_ltree)
```