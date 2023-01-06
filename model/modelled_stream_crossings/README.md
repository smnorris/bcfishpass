# Modelling road/railway - stream crossings

Generate potential locations of road/railway stream crossings and associated structures in British Columbia.

In addition to generating the intersection points of roads/railways and streams, attempt to:

- remove duplicate crossings
- identify crossings that are likely to be bridges/open bottom structures
- maintain a consistent unique identifier value (`modelled_crossing_id`) that is stable with script re-runs

## Methods and sources

### Stream features

Streams are taken from the [BC Freshwater Atlas](https://catalogue.data.gov.bc.ca/dataset/freshwater-atlas-stream-network) and loaded using [fwapg](https://github.com/smnorris/fwapg).

### Linear transportation features

Road and railway features are downloaded from DataBC. Features used to generate stream crossings are defined by the queries below. The queries attempt to extract transportation features only at locations where there is likely to be a stream crossing structure.

| Source         | Query |
| ------------- | ------------- |
| [Digital Road Atlas (DRA)](https://catalogue.data.gov.bc.ca/dataset/digital-road-atlas-dra-master-partially-attributed-roads)  | `transport_line_type_code NOT IN ('F','FP','FR','T','TR','TS','RP','RWA') AND transport_line_surface_code != 'D' AND transport_line_structure_code != 'T' ` |
| [Forest Tenure Roads](https://catalogue.data.gov.bc.ca/dataset/forest-tenure-road-section-lines)  | `life_cycle_status_code NOT IN ('RETIRED', 'PENDING')` |
| [OGC Road Segment Permits](https://catalogue.data.gov.bc.ca/dataset/oil-and-gas-commission-road-segment-permits)  | `status = 'Approved' AND road_type_desc != 'Snow Ice Road'` |
| [OGC Development Roads pre-2006](https://catalogue.data.gov.bc.ca/dataset/ogc-petroleum-development-roads-pre-2006-public-version) | `petrlm_development_road_type != 'WINT'` |
| [NRN Railway Tracks](https://catalogue.data.gov.bc.ca/dataset/railway-track-line)  | `structure_type != 'Tunnel'` (via spatial join to `gba_railway_structure_lines_sp`) |

### Overlay and de-duplication

Intersection points of the stream and road features are created. Because we want to generate locations of individual structures, crossings (on the same stream) are de-duplicated using several data source specific tolerances:

- merge DRA crossings on freeways/highways with a 30m tolerance
- merge DRA crossings on arterial/collector road with a 20m tolerance
- merge other types of DRA crossings within a 12.5m tolerance
- merge FTEN crossings within a 12.5m tolerance
- merge OGC crossings within a 12.5m tolerance
- merge railway crossings within a 20m tolerance

DRA crossings are also merged across streams at a tolerance of 10m.

After same-source data crossings are merged, all crossings are de-duplicated using a 10m tolerance across all (road) data sources (railway crossings are not merged with the road sources). The actual location of an output crossing corresponds to the location from the highest priority dataset - in this order of decreasing priority: DRA, FTEN, OGC permits, OGC permits pre2006. Despite the duplicate removals, the unique identifier for each source road within 10m of a crossing is retained - all crossings can be linked back to their various source road datasets.

### Bridges / Open Bottom Structures

Once duplicates have been removed, output crossings are identified/modelled as open bottom structures via these properties:

| Source         | Query        | output `modelled_crossing_type_source` |
| ------------- | ------------- | ------------- |
| [Stream order](https://catalogue.data.gov.bc.ca/dataset/freshwater-atlas-stream-network) | `stream_order >= 6` | `FWA_STREAM_ORDER` |
| [Rivers/double line streams](https://catalogue.data.gov.bc.ca/dataset/freshwater-atlas-stream-network)  | `edge_type IN (1200, 1250, 1300, 1350, 1400, 1450, 1475)` | `FWA_EDGE_TYPE` |
| [MOT structures](https://catalogue.data.gov.bc.ca/dataset/ministry-of-transportation-mot-road-structures) | `bmis_structure_type = 'BRIDGE'` | `MOT_ROAD_STRUCTURE_SP` |
| [PSCIS structures](https://catalogue.data.gov.bc.ca/dataset/pscis-assessments) | `current_crossing_type_code = 'OBS'` | `PSCIS` |
| [DRA structures](https://catalogue.data.gov.bc.ca/dataset/digital-road-atlas-dra-master-partially-attributed-roads) | `transport_line_structure_code IN ('B','C','E','F','O','R','V')` | `TRANSPORT_LINE_STRUCTURE_CODE` |
| [Railway structures](https://catalogue.data.gov.bc.ca/dataset/railway-structure-line) | `structure_type LIKE 'BRIDGE%'` | `GBA_RAILWAY_STRUCTURE_LINES_SP` |


## Run scripts

Download data and run scripts to generate the crossings.

    ./modelled_stream_crossings.sh

Note that the script re-generates **all** modelled crossings.
To ensure that ID values for the crossings are consistent with previous model outputs, an archived version of the modelled crossings is downloaded and the `modelled_crossing_id` values are transferred from the archive to the new output crossings (where crossings are within 10m distance).

## Output

Output table is `bcfishpass.modelled_stream_crossings`:

```
                                                            Table "bcfishpass.modelled_stream_crossings"
            Column             |          Type          | Collation | Nullable |                                       Default
-------------------------------+------------------------+-----------+----------+--------------------------------------------------------------------------------------
 modelled_crossing_id          | integer                |           | not null | nextval('bcfishpass.modelled_stream_crossings_modelled_crossing_id_seq'::regclass)
 modelled_crossing_type        | character varying(5)   |           |          |
 modelled_crossing_type_source | text[]                 |           |          |
 transport_line_id             | integer                |           |          |
 ften_road_section_line_id     | text                   |           |          |
 og_road_segment_permit_id     | integer                |           |          |
 og_petrlm_dev_rd_pre06_pub_id | integer                |           |          |
 railway_track_id              | integer                |           |          |
 linear_feature_id             | bigint                 |           |          |
 blue_line_key                 | integer                |           |          |
 downstream_route_measure      | double precision       |           |          |
 wscode_ltree                  | ltree                  |           |          |
 localcode_ltree               | ltree                  |           |          |
 watershed_group_code          | character varying(4)   |           |          |
 geom                          | geometry(PointZM,3005) |           |          |
Indexes:
    "modelled_stream_crossings_pkey" PRIMARY KEY, btree (modelled_crossing_id)
    "modelled_stream_crossings_blue_line_key_idx" btree (blue_line_key)
    "modelled_stream_crossings_ften_road_section_line_id_idx" btree (ften_road_section_line_id)
    "modelled_stream_crossings_geom_idx" gist (geom)
    "modelled_stream_crossings_linear_feature_id_idx" btree (linear_feature_id)
    "modelled_stream_crossings_og_petrlm_dev_rd_pre06_pub_id_idx" btree (og_petrlm_dev_rd_pre06_pub_id)
    "modelled_stream_crossings_og_road_segment_permit_id_idx" btree (og_road_segment_permit_id)
    "modelled_stream_crossings_railway_track_id_idx" btree (railway_track_id)
    "modelled_stream_crossings_transport_line_id_idx" btree (transport_line_id)
```

## Known errors and limitations

The model will generally over-estimate the extent of closed bottom stream crossings / culverts. The primary errors are:

1. A bridge / open bottom structure exists at a crossing modelled as CBS. This is primarily due to:

    - we have very limited data on where bridges are present
    - modelling bridges as occuring at stream order >= 6 is relatively conservative by design - culverts can exist on these higher order streams, we do not want to miss these important locations

2. No structure exists at the mapped road/stream crossing. This can be due to a number of different data issues:

    Roads:

    - DRA mapping can be over-generous in its definition of 'road'
    - a road has been deactivated or never had a crossing structure
    - FTEN road data is tenure data, not actual 'as built' data - an FTEN road may not have been built

    Streams:

    - there is insufficent flow in the stream channel for a structure to have been necessary in road construction
    - the stream is incorrectly mapped
    - the stream channel has moved from where it was mapped (stream mapping is from BC TRIM I data, circa 1998)


## Fixes

Because the above errors will often result in erroneous modelled culverts with a great deal of stream and potential habitat upstream, it is important to conduct a manual review of the modelled crossings before prioritizing sites for field assessment.  A manual review is generally a simple visual review of available satellite imagery - the user can quickly identify sites where it is clear that a bridge is present or no road/stream crossing is present.

To apply these fixes, add the crossing id and fix information for the crossing of interest to [`data/modelled_stream_crossings_fixes.csv`](data/modelled_stream_crossings_fixes.csv)

#### modelled_stream_crossings_fixes.csv

| Column               | Description |
|----------------------|-------------|
|`modelled_crossing_id`| ID of modelled crossing |
|`watershed_group_code`| watershed group code of watershed in which crossing lies (for quick reference only) |
|`reviewer`            | initials of user conducting review |
|`structure`           | `OBS` - a bridge is present; `NONE` - no stream crossing (or structure) is present
|`notes`               | relevant notes based on review of imagery and/or other sources
