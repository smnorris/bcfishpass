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

Edit the lookup [`data/pscis_modelledcrossings_streams_xref.csv`](`data/pscis_modelledcrossings_streams_xref`) when new PSCIS data is
added or when errors in snapping are found. Rows should be added using one of three patterns below:


1. Force match of a PSCIS crossing to specific modelled crossing (this implicitly matches the PSCIS crossing to the correct stream) by
adding the PSCIS `stream_crossing_id` and the corresponding ``modelled_crossing_id``:


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


## Method

Each step noted matches the sql script / output table name:

1. **`pscis_points_all`**  Combines the four `WHSE_FISH.PSCIS` sources (assessments, confirmations, designs, remediations) into a single table with unique crossing locations.

2. **`pscis_events_prelim1`**  References `pscis_points_all` to the closest stream(s) in FWA stream network within 100m. A crossing will often be within 100m of more than one stream, all results are kept in this preliminary step.

3. **`pscis_events_prelim2`** From `events_prelim1`, attempts to find the PSCIS points to the correct stream using a combination of:

    - distance of PSCIS point to stream
    - similarity of PSCIS `stream_name` to the stream's `gnis_name`
    - the relationship of PSCIS `downstream_channel_width` to the stream's`stream_order` - if a very wide channel is matched to a low order stream, it is probably not the correct match

4. **`pscis_model_match_pts`** Match PSCIS points to the modelled crossings where possible. Similar to the matching of PSCIS crossings to streams noted above, the script attempts to find the best match based on:

    - distance of PSCIS point to modelled crossing point
    - matching the crossing types (if PSCIS `crossing_subtype_code` indicates the crossing is a bridge/open bottom and the model predicts a bridge/open bottom, the points are probably a match)
    - as above, check the relationship of PSCIS `downstream_channel_width` to the stream's `stream_order`

5. **`pscis_events_prelim3`**  Combine the results from 1 and 2 above into a single table that is our best guess of which stream the PSCIS crossing should be associdated with. Because we do not want to overly shift the field GPS coordinates in PSCIS, we are very conservative with matching to modelled points and will primarily snap to the closest point on the stream rather than a modelled crossing farther away.

6. **`pscis_events`**  Create primary output table of interest - all pscis records (that are on a stream) as points on the FWA stream network.
Do this by first adding all PSCIS records that have been manually matched to streams to the event table.
For remaining points, remove locations from `pscis_events_prelim3` which are obvious duplicates (instream position is within 5m).
The PSCIS feature retained is based on (in order of priority):
    - status (in order of REMEDIATED, DESIGN, CONFIRMATION, ASSESSED)
    - most recently assessed
    - closest source point to stream

7. **`pscis_points_duplicates`** For general QA of PSCIS features, create a report of all source crossing locations that are within 10m of another crossing location.




## Output table definition

```
                           Table "bcfishpass.pscis_events"
           Column            |         Type         | Collation | Nullable | Default
-----------------------------+----------------------+-----------+----------+---------
 stream_crossing_id          | integer              |           | not null |
 model_crossing_id           | integer              |           |          |
 distance_to_stream          | double precision     |           |          |
 linear_feature_id           | bigint               |           |          |
 wscode_ltree                | ltree                |           |          |
 localcode_ltree             | ltree                |           |          |
 fwa_watershed_code          | text                 |           |          |
 local_watershed_code        | text                 |           |          |
 blue_line_key               | integer              |           |          |
 downstream_route_measure    | double precision     |           |          |
 watershed_group_code        | character varying(4) |           |          |
 score                       | integer              |           |          |
 pscis_status                | text                 |           |          |
 current_barrier_result_code | text                 |           |          |
 geom                        | geometry(Point,3005) |           |          |
Indexes:
    "pscis_events_pkey" PRIMARY KEY, btree (stream_crossing_id)
    "pscis_events_blue_line_key_idx" btree (blue_line_key)
    "pscis_events_geom_idx" gist (geom)
    "pscis_events_linear_feature_id_idx" btree (linear_feature_id)
    "pscis_events_localcode_ltree_idx" gist (localcode_ltree)
    "pscis_events_localcode_ltree_idx1" btree (localcode_ltree)
    "pscis_events_model_crossing_id_idx" btree (model_crossing_id)
    "pscis_events_wscode_ltree_idx" gist (wscode_ltree)
    "pscis_events_wscode_ltree_idx1" btree (wscode_ltree)
```