# Dams

BC dam locations and barrier status have been compiled from many sources by the Canadian Wildlife Federation into the [Canadian Aquatic Barrier Database (CABD)](https://cabd-docs.netlify.app/index.html). Dam features for bcfishpass are taken directly from the CABD.


## Usage

Download CABD dams and match the points to the nearest FWA stream (within 50m):

    ./dams.sh

## Output tables

CABD tables are as documented:

- [`cabd.dams`](https://cabd-docs.netlify.app/docs_tech/docs_tech_arch/docs_tech_arch_data_dict.html#dams.dams)

- [`cabd.dam_use_codes`](https://cabd-docs.netlify.app/docs_tech/docs_tech_arch/docs_tech_arch_data_dict.html#dams.dam_use_codes)

`bcfishpass.dams` holds only the FWA/linear referencing information associated with a dam, plus the geometry of the feature snapped to the nearest FWA stream (for more information about dams, join this table back to `cabd.dams` or refer directly to the CABD)

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