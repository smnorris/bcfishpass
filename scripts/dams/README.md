# Dams

BC dam locations and barrier status have been compiled by the Canadian Wildlife Federation from several sources.
See https://github.com/smnorris/bcdams for more information and edit this data if barrier status fixes are required.

## Usage

Download the BC dam dataset compiled by CWF and match the points to the nearest FWA stream (within 50m):

    ./dams.sh

## Output table

                             Table "bcfishpass.dams"
              Column          |         Type         | Collation | Nullable | Default
    --------------------------+----------------------+-----------+----------+---------
     dam_id                   | integer              |           | not null |
     dam_name                 | text                 |           |          |
     waterbody_name           | text                 |           |          |
     owner                    | text                 |           |          |
     hydro_dam_ind            | text                 |           |          |
     barrier_ind              | text                 |           |          |
     source_dataset           | text                 |           |          |
     source_id                | integer              |           |          |
     linear_feature_id        | bigint               |           |          |
     blue_line_key            | integer              |           |          |
     downstream_route_measure | double precision     |           |          |
     wscode_ltree             | ltree                |           |          |
     localcode_ltree          | ltree                |           |          |
     distance_to_stream       | double precision     |           |          |
     watershed_group_code     | text                 |           |          |
     geom                     | geometry(Point,3005) |           |          |
    Indexes:
        "dams_pkey" PRIMARY KEY, btree (dam_id)
        "dams_blue_line_key_downstream_route_measure_key" UNIQUE CONSTRAINT, btree (blue_line_key, downstream_route_measure)
        "dams_blue_line_key_idx" btree (blue_line_key)
        "dams_geom_idx" gist (geom)
        "dams_linear_feature_id_idx" btree (linear_feature_id)
        "dams_localcode_ltree_idx" gist (localcode_ltree)
        "dams_localcode_ltree_idx1" btree (localcode_ltree)
        "dams_watershed_group_code_idx" btree (watershed_group_code)
        "dams_wscode_ltree_idx" gist (wscode_ltree)
        "dams_wscode_ltree_idx1" btree (wscode_ltree)