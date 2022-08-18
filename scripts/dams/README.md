# Dams

BC dam locations and barrier status have been compiled from many sources by the Canadian Wildlife Federation into the [Canadian Aquatic Barrier Database (CABD)](https://cabd-docs.netlify.app/index.html). Dam features for bcfishpass are taken directly from the CABD.


## Usage

Download CABD dams and match the points to the nearest FWA stream (within 50m):

    ./dams.sh

## Output table

Note that the dam id is the only CABD attribute retained in this table. For more information about dams, join back to `cabd.dams` or refer directly to the CABD.

                                 Table "bcfishpass.dams"
              Column          |         Type         | Collation | Nullable | Default
    --------------------------+----------------------+-----------+----------+---------
     dam_id                   | character varying    |           | not null |
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