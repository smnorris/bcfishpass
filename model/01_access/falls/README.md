# Falls

Download waterfall data from various sources, match to FWA stream network, identify barriers.

## Sources

- FISS obstacles, [BC Data Catalogue](https://catalogue.data.gov.bc.ca/dataset/provincial-obstacles-to-fish-passage)
- FISS obstacles, [unpublished](https://www.hillcrestgeo.ca/outgoing/public/whse_fish)
- FWA obstructions, [BC Data Catalogue](https://catalogue.data.gov.bc.ca/dataset/freshwater-atlas-obstructions)
- Additional user compiled falls, [falls_other.csv](/data/falls/falls_other.csv)
- User modification of fall barrier status, [falls_barrier_ind.csv](/data/falls/falls_barrier_ind.csv)


## Barrier status logic

A fall is automatically identified as a barrier if one of these conditions is met:

- data source is a FISS obstacles / FISS obstacles unpublished *AND* height >= 5m
- data source is FWA obstructions (this data source does not include a height)
- data source is `falls_other.csv` and `barrier_ind = True`

See below for manually modifying the barrier status of individual falls with `falls_barrier_ind.csv`


## Processing

1. Add records/edit `falls_other.csv` as required
2. Download input data, match to FWA streams, combine into a single falls table:

        ./falls.sh

## Output table

`bcfishpass.falls` contains all known falls features (only the subset of falls with `barrier_ind IS TRUE` are used for connectivity modelling).
Note that there is no ID used as a primary key. The `blue_line_key`/`downstream_route_measure` columns are used as the primary key instead (the source FISS obstacles table does not include a stable primary key so tracking these falls is easiest via their position on the network).
```
                           Table "bcfishpass.falls"
          Column          |         Type         | Collation | Nullable | Default
--------------------------+----------------------+-----------+----------+---------
 source                   | text                 |           |          |
 height                   | double precision     |           |          |
 barrier_ind              | boolean              |           |          |
 reviewer                 | text                 |           |          |
 notes                    | text                 |           |          |
 distance_to_stream       | double precision     |           |          |
 linear_feature_id        | bigint               |           |          |
 blue_line_key            | integer              |           | not null |
 downstream_route_measure | double precision     |           | not null |
 wscode_ltree             | ltree                |           |          |
 localcode_ltree          | ltree                |           |          |
 watershed_group_code     | text                 |           |          |
 geom                     | geometry(Point,3005) |           |          |
Indexes:
    "falls_pkey" PRIMARY KEY, btree (blue_line_key, downstream_route_measure)
    "falls_blue_line_key_idx" btree (blue_line_key)
    "falls_geom_idx" gist (geom)
    "falls_linear_feature_id_idx" btree (linear_feature_id)
    "falls_localcode_ltree_idx" gist (localcode_ltree)
    "falls_localcode_ltree_idx1" btree (localcode_ltree)
    "falls_wscode_ltree_idx" gist (wscode_ltree)
    "falls_wscode_ltree_idx1" btree (wscode_ltree)
```

## Edit barrrier status

When the barrier status of a falls neeeds to be updated, add to `falls_barrier_ind.csv` as required.
A falls is identified in this table by its position on the network (`blue_line_key`/`downstream_route_measure` combination).
For example, to remove an invalid falls, add a record like this:

| blue_line_key | downstream_route_measure | barrier_ind | watershed_group_code | reviewer | notes
| --------     | -------- | -------- | -------- | -------- | -------- |
| 356252974     | 0                        | F           | HORS                 | NJO      | Does not exist |

Or, if a falls that defaults to passable has been found to be a barrier:

| blue_line_key | downstream_route_measure | barrier_ind | watershed_group_code | reviewer | notes
| --------     | -------- | -------- | -------- | -------- | -------- |
|123456789|525|T|AGRP|SN|Barrier confirmed by local source A.Fish.|