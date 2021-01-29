# PSCIS

The [BC Provincial Stream Crossing Information System](https://www2.gov.bc.ca/gov/content/environment/natural-resource-stewardship/land-based-investment/investment-categories/fish-passage) (PSCIS) monitors fish passage on road-stream crossings throughout British Columbia. These scripts index the crossings on the BC Freshwater Atlas stream network - creating an event table that permits upstream/downstream queries. This enables reporting on aquatic habitat potentially blocked by failed culverts.

## Matching PSCIS crossings to modelled crossings or streams

PSCIS crossings (location based on GPS coordinates at site) need to be matched to the correct stream for priorization to work. Also, to avoid duplication when mapping and reporting on barriers, we need to match PSCIS crossings to modelled crossings.

The scripts included match PSCIS points to streams an modelled crossings based primarily on minimum distance (with some minor checks). Because mapping is often not true to real world coordinates and GPS errors do occur, this is not good enough in many instances, a PSCIS barrier on a small trib can easily (and often) be snapped to a major river that happens to be closer to the PSCIS point. To reduce this issue, a manually built lookup table included to enforce the correct matching of PSCIS points to modelled crossings/streams.

Edit this lookup [`data/pscis_modelledcrossings_streams_xref.csv`](`data/pscis_modelledcrossings_streams_xref`) when new PSCIS data is added or when errors in snapping are found. Rows should be added in one of three patterns:


1. Force match of a PSCIS crossing to specific modelled crossing:


    | stream_crossing_id | modelled_crossing_id | linear_feature_id | reviewer |                           notes |
    |--------------------|----------------------|-------------------|----------|---------------------------------- |
    |              197656|             1800071  |                   |       SN | Match based on assessor comments |


2. Force match of a PSCIS crossing to a stream (where no modelled crossing is present):


    | stream_crossing_id | modelled_crossing_id | linear_feature_id | reviewer |                           notes         |
    |--------------------|----------------------|-------------------|----------|-----------------------------------------|
    |              3085  |                      | 17081483          |       SN | No modelled crossing, matched to stream |


3. Force **no** match of PSCIS crossing to any FWA stream (there is no mapped stream that corresponds to the assessment):

    | stream_crossing_id | modelled_crossing_id | linear_feature_id | reviewer |                           notes       |
    |--------------------|----------------------|-------------------|----------|---------------------------------------|
    |              2901  |                      |                   |       SN | No stream mapped at crossing location |


Note that PSCIS crossings not on mapped streams are included in prioritization and habitat reporting.


## Run scripts

If latest PSCIS is not already loaded, get it from DataBC:

    ./load.sh

Match PSCIS points to streams:

    ./pscis.sh


## Method

Each step noted matches the sql script / output table name:

1. **`pscis_points_all`**  Combines the four `WHSE_FISH.PSCIS` views (assessments, confirmations, designs, remediations) into a single table with unique crossing locations.

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
Do this by first adding all PSCIS records that have been manually matched to streams to the event table (currently `BULK`, `ELKR`, `HORS`, `LNIC`).
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