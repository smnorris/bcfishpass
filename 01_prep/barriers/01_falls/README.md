# Falls

Download waterfall data from various sources, match to FWA stream network, identify barriers.

## Sources

- FISS obstacles, [BC Data Catalogue](https://catalogue.data.gov.bc.ca/dataset/provincial-obstacles-to-fish-passage)
- FISS obstacles, [unpublished](https://www.hillcrestgeo.ca/outgoing/public/whse_fish)
- FWA obstructions, [BC Data Catalogue](https://catalogue.data.gov.bc.ca/dataset/freshwater-atlas-obstructions)
- [Manually compiled](data/falls_other.csv)

## Usage

#### Barriers

The script classifies barriers to fish passage as follows:

- FISS falls with height value >= 5
- all FWA falls (height is not present in this data)

Add records to `data/falls_barrier_ind.csv` to override the modelled the barrier status of FISS/FWA falls as required.

#### Adding features

To add falls not present in FISS/FWA, add rows to the manually compiled falls file `data/falls_other.csv` as required.
Populate the `barrier_ind` column in this file to control the barrier status of features added.


#### Load and process

    ./falls.sh

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