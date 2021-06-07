# PSCIS

The [BC Provincial Stream Crossing Information System](https://www2.gov.bc.ca/gov/content/environment/natural-resource-stewardship/land-based-investment/investment-categories/fish-passage) (PSCIS) monitors fish passage status of road (and rail) stream crossings (ie bridges and culverts).

These scripts reference PSCIS features to the BC Freshwater Atlas stream network and identify potential problems in the PSCIS data.

## Usage


### Edit lookup
The scripts included match PSCIS points to streams and modelled crossings based primarily on minimum distance (with some basic checks).
Because mapping, GPS and data entry errors are common, this is inadequate. For instance, the GPS coordinates of a PSCIS crossing for an
assessment of a small tributary may be closer to the mapped location of a major river than the stream on which the assessment was done -
if this occurs at a PSCIS barrier, everything upstream on the major system will incorrectly be coded as inaccessible.  To eliminate this
issue, a manually built lookup table is included to enforce the correct matching of PSCIS points to modelled crossings or streams.

Edit the lookup [`data/pscis_modelledcrossings_streams_xref.csv`](data/pscis_modelledcrossings_streams_xref.csv) when new PSCIS data is
added or when errors in snapping are found. Rows should be added using one of three patterns below:


1. Force match of a PSCIS crossing to specific modelled crossing (this implicitly matches the PSCIS crossing to the correct stream) by
adding the PSCIS `stream_crossing_id` and the corresponding `modelled_crossing_id`:


    | stream_crossing_id | modelled_crossing_id | linear_feature_id | reviewer |                           notes |
    |--------------------|----------------------|-------------------|----------|---------------------------------- |
    |              197656|             1800071  |                   |       SN | Match based on assessor comments |


2. Force match of a PSCIS crossing to a stream at a location where no modelled crossing is present by adding the PSCIS
`stream_crossing_id` and the `linear_feature_id` of the matched stream.


    | stream_crossing_id | modelled_crossing_id | linear_feature_id | reviewer |                           notes         |
    |--------------------|----------------------|-------------------|----------|-----------------------------------------|
    |              3085  |                      | 17081483          |       SN | No modelled crossing, matched to stream |


3. If there is no mapped stream that corresponds to the the PSCIS feature, we can force **no** match of the PSCIS crossing to any FWA stream
by adding the `stream_crossing_id` and leaving the `modelled_crossing_id` and `linear_feature_id` empty:

    | stream_crossing_id | modelled_crossing_id | linear_feature_id | reviewer |                           notes       |
    |--------------------|----------------------|-------------------|----------|---------------------------------------|
    |              2901  |                      |                   |       SN | No stream mapped at crossing location |


Note that PSCIS crossings not on mapped streams cannot be included in habitat reporting/prioritization.


### Run scripts

    ./pscis.sh


## Scripts/method


1. `sql/01_pscis_points_all.sql`

    Combine the four `WHSE_FISH.PSCIS` sources (assessments, confirmations, designs, remediations) into temp table holding all unique PSCIS crossings `bcfishpass.pscis_points_all`.

2. `sql/02_pscis_events_prelim1.sql`

    Join unique crossings in `bcfishpass.pscis_points_all` to all FWA stream(s) within 200m, saving to temp table `bcfishpass.pscis_events_prelim1.sql`.

3. `sql/03_pscis_events_prelim2.sql`

    Attempt to assign PSCIS crossings in `bcfishpass.pscis_events_prelim1` to the *correct* stream within 150m by scoring matched streams using a combination of:

    - distance of PSCIS crossing to stream
    - similarity of the PSCIS crossing's `stream_name` to the stream's `gnis_name`
    - the relationship of the PSCIS crossing's `downstream_channel_width` to the stream's`stream_order` (if a very wide channel (measured) is matched to a low order stream, the match is likely incorrect)

    If the PSCIS crossing is within 175m of a modelled crossing that is on the same stream (stream with the best score), the PSCIS crossing is also matched to that modelled crossing. Output is written to temp table `bcfishpass.pscis_events_prelim2`

4. `sql/04_pscis.sql`

    Create the output table `bcfishpass.pscis`:

    - first, insert PSCIS crossings that have been manually matched to streams/modelled crossings in `pscis_modelledcrossings_streams_xref.csv`
    - next, insert PSCIS crossings from `pscis_events_prelim2`, filtering out duplicates and matches that score very poorly
    - create a view holding PSCIS crossings that do not make it into the output `pscis` table: `pscis_not_matched_to_streams_vw`

5. `sql/05_pscis_points_duplicates.sql`

    For QA of PSCIS data, create a table of duplicate records (crossing source coordinates <10m apart or instream distance <5m apart)


## Output tables / views

PSCIS crossings matched to streams:

              Table "bcfishpass.pscis"
                Column             |         Type          | Collation | Nullable | Default
    -------------------------------+-----------------------+-----------+----------+---------
     stream_crossing_id            | integer               |           | not null |
     modelled_crossing_id          | integer               |           |          |
     pscis_status                  | text                  |           |          |
     current_crossing_type_code    | character varying(10) |           |          |
     current_crossing_subtype_code | character varying(10) |           |          |
     current_barrier_result_code   | text                  |           |          |
     distance_to_stream            | double precision      |           |          |
     stream_match_score            | integer               |           |          |
     linear_feature_id             | bigint                |           |          |
     wscode_ltree                  | ltree                 |           |          |
     localcode_ltree               | ltree                 |           |          |
     blue_line_key                 | integer               |           |          |
     downstream_route_measure      | double precision      |           |          |
     watershed_group_code          | character varying(4)  |           |          |
     geom                          | geometry(Point,3005)  |           |          |
    Indexes:
        "pscis_pkey" PRIMARY KEY, btree (stream_crossing_id)
        "pscis_blue_line_key_downstream_route_measure_key" UNIQUE CONSTRAINT, btree (blue_line_key, downstream_route_measure)
        "pscis_blue_line_key_idx" btree (blue_line_key)
        "pscis_geom_idx" gist (geom)
        "pscis_linear_feature_id_idx" btree (linear_feature_id)
        "pscis_localcode_ltree_idx" gist (localcode_ltree)
        "pscis_localcode_ltree_idx1" btree (localcode_ltree)
        "pscis_modelled_crossing_id_idx" btree (modelled_crossing_id)
        "pscis_wscode_ltree_idx" gist (wscode_ltree)
        "pscis_wscode_ltree_idx1" btree (wscode_ltree)


All PSCIS crossings in a single table:

                Table "bcfishpass.pscis_points_all"
                Column             |         Type         | Collation | Nullable | Default
    -------------------------------+----------------------+-----------+----------+---------
     stream_crossing_id            | integer              |           | not null |
     current_pscis_status          | text                 |           |          |
     current_barrier_result_code   | text                 |           |          |
     current_crossing_type_code    | text                 |           |          |
     current_crossing_subtype_code | text                 |           |          |
     geom                          | geometry(Point,3005) |           |          |
    Indexes:
        "pscis_points_all_pkey" PRIMARY KEY, btree (stream_crossing_id)
        "pscis_points_all_geom_idx" gist (geom)


Duplicate PSCIS crossings (for QA):

                Table "bcfishpass.pscis_points_duplicates"
            Column         |  Type   | Collation | Nullable | Default
    -----------------------+---------+-----------+----------+---------
     stream_crossing_id    | integer |           |          |
     duplicate_10m         | boolean |           |          |
     duplicate_5m_instream | boolean |           |          |
     watershed_group_code  | text    |           |          |


PSCIS crossings that are not matched to streams:

                   View "bcfishpass.pscis_not_matched_to_streams_vw"
                Column             |         Type         | Collation | Nullable | Default
    -------------------------------+----------------------+-----------+----------+---------
     stream_crossing_id            | integer              |           |          |
     current_pscis_status          | text                 |           |          |
     current_barrier_result_code   | text                 |           |          |
     current_crossing_type_code    | text                 |           |          |
     current_crossing_subtype_code | text                 |           |          |
     watershed_group_code          | character varying    |           |          |
     geom                          | geometry(Point,3005) |           |          |