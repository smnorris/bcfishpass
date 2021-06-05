# Dams

BC dam locations and barrier status have been compiled by the Canadian Wildlife Federation from several sources.
See https://github.com/smnorris/bcdams for more information.

## Usage

Download the BC dam dataset compiled by CWF and match the points to the nearest FWA streams:

    ./dams.sh

## Output table

                                                 Table "bcfishpass.bcdams_events"
              Column          |         Type         | Collation | Nullable |                         Default
    --------------------------+----------------------+-----------+----------+----------------------------------------------------------
     dam_id                   | integer              |           | not null | nextval('bcfishpass.bcdams_events_dam_id_seq'::regclass)
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
        "bcdams_events_pkey" PRIMARY KEY, btree (dam_id)
        "bcdams_events_blue_line_key_idx" btree (blue_line_key)
        "bcdams_events_geom_idx" gist (geom)
        "bcdams_events_linear_feature_id_idx" btree (linear_feature_id)
        "bcdams_events_localcode_ltree_idx" gist (localcode_ltree)
        "bcdams_events_localcode_ltree_idx1" btree (localcode_ltree)
        "bcdams_events_watershed_group_code_idx" btree (watershed_group_code)
        "bcdams_events_wscode_ltree_idx" gist (wscode_ltree)
        "bcdams_events_wscode_ltree_idx1" btree (wscode_ltree)