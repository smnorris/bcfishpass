# Data dictionary

## Freshwater Fish Habitat Accessibility MODEL – Pacific Salmon and Steelhead

A weekly bcfishpass data extract of Pacific Salmon (Chinook, Chum, Coho, Pink, Sockeye) and Steelhead access models (and associated data) is [available for download](https://bcfishpass.s3.us-west-2.amazonaws.com/freshwater_fish_habitat_accessibility_MODEL.gpkg.zip).

The models included in this distribution are generated as described in [access model](02_model_access.md), with the following parameters:

- for salmon, [potential gradient barriers](02_model_access.md#generate-gradient-barriers) are considered passable up to 15%
- for steelhead, [potential gradient barriers](02_model_access.md#generate-gradient-barriers) are considered passable up to 20%
- for both salmon and steelhead, potential natural barriers with 5 or more upstream observations of any of the target species (`CH, CM, CO, PK, SK, ST`) since January 01, 1990 are presumed to be passable

### crossings

Aggregated stream crossing locations.  Sources:

- PSCIS stream crossings (matched to FWA streams)
- CABD dams
- modelled road/rail/trail stream crossings
- misc anthropogenic barriers from expert/local input

Includes barrier status, key attributes from source datasets, and upstream length total summaries.

|                            Column                             |          Type          | Description | 
|---------------------------------------------------------------|------------------------|-----------|
 | `aggregated_crossings_id` | `text` | unique identifier for crossing, generated from stream_crossing_id, modelled_crossing_id + 1000000000, user_barrier_anthropogenic_id + 1200000000, cabd_id |
| `stream_crossing_id` | `integer` | PSCIS stream crossing unique identifier |
| `dam_id` | `uuid` | CABD unique identifier |
| `user_barrier_anthropogenic_id` | `bigint` | User added misc anthropogenic barriers unique identifier |
| `modelled_crossing_id` | `integer` | Modelled crossing unique identifier |
| `crossing_source` | `text` | Data source for the crossing, one of: {PSCIS,MODELLED CROSSINGS,CABD,MISC BARRIERS} |
| `crossing_feature_type` | `text` | The general type of feature crossing the stream, valid feature types are {DAM,RAIL,"ROAD, DEMOGRAPHIC","ROAD, RESOURCE/OTHER",TRAIL,WEIR} |
| `pscis_status` | `text` | From PSCIS, the current_pscis_status of the crossing, one of: {ASSESSED,HABITAT CONFIRMATION,DESIGN,REMEDIATED} |
| `crossing_type_code` | `text` | Defines the type of crossing present at the location of the stream crossing. Acceptable types are: OBS = Open Bottom Structure CBS = Closed Bottom Structure OTHER = Crossing structure does not fit into the above categories. Eg: ford, wier |
| `crossing_subtype_code` | `text` | Further definition of the type of crossing, one of {BRIDGE,CRTBOX,DAM,FORD,OVAL,PIPEARCH,ROUND,WEIR,WOODBOX,NULL} |
| `modelled_crossing_type_source` | `text` | List of sources that indicate if a modelled crossing is open bottom, Acceptable values are: FWA_EDGE_TYPE=double line river, FWA_STREAM_ORDER=stream order >=6, GBA_RAILWAY_STRUCTURE_LINES_SP=railway structure, "MANUAL FIX"=manually identified OBS, MOT_ROAD_STRUCTURE_SP=MoT structure, TRANSPORT_LINE_STRUCTURE_CODE=DRA structure} |
| `barrier_status` | `text` | The evaluation of the crossing as a barrier to the fish passage. From PSCIS, this is based on the FINAL SCORE value. For other data sources this varies. Acceptable Values are: PASSABLE - Passable, POTENTIAL - Potential or partial barrier, BARRIER - Barrier, UNKNOWN - Other |
| `pscis_road_name` | `text` | PSCIS road name, taken from the PSCIS assessment data submission |
| `pscis_stream_name` | `text` | PSCIS stream name, taken from the PSCIS assessment data submission |
| `pscis_assessment_comment` | `text` | PSCIS assessment_comment, taken from the PSCIS assessment data submission |
| `pscis_assessment_date` | `date` | PSCIS assessment_date, taken from the PSCIS assessment data submission |
| `pscis_final_score` | `integer` | PSCIS final_score, taken from the PSCIS assessment data submission |
| `transport_line_structured_name_1` | `text` | DRA road name, taken from the nearest DRA road (within 30m) |
| `transport_line_type_description` | `text` | DRA road type, taken from the nearest DRA road (within 30m) |
| `transport_line_surface_description` | `text` | DRA road surface, taken from the nearest DRA road (within 30m) |
| `ften_forest_file_id` | `text` | FTEN road forest_file_id value, taken from the nearest FTEN road (within 30m) |
| `ften_file_type_description` | `text` | FTEN road tenure type (Forest Service Road, Road Permit, etc), taken from the nearest FTEN road (within 30m) |
| `ften_client_number` | `text` | FTEN road client number, taken from the nearest FTEN road (within 30m) |
| `ften_client_name` | `text` | FTEN road client name, taken from the nearest FTEN road (within 30m) |
| `ften_life_cycle_status_code` | `text` | FTEN road life_cycle_status_code (active or retired, pending roads are not included), taken from the nearest FTEN road (within 30m) |
| `rail_track_name` | `text` | Railway name, taken from nearest railway (within 25m) |
| `rail_owner_name` | `text` | Railway owner name, taken from nearest railway (within 25m) |
| `rail_operator_english_name` | `text` | Railway operator name, taken from nearest railway (within 25m) |
| `ogc_proponent` | `text` | OGC road tenure proponent (currently modelled crossings only, taken from OGC road that crosses the stream) |
| `dam_name` | `text` | See CABD dams column: dam_name_en |
| `dam_height` | `double precision` | See CABD dams column: dam_height |
| `dam_owner` | `text` | See CABD dams column: owner |
| `dam_use` | `text` | See CABD table dam_use_codes |
| `dam_operating_status` | `text` | See CABD dams column dam_operating_status |
| `utm_zone` | `integer` | UTM ZONE is a segment of the Earths surface 6 degrees of longitude in width. The zones are numbered eastward starting at the meridian 180 degrees from the prime meridian at Greenwich. There are five zones numbered 7 through 11 that cover British Columbia, e.g., Zone 10 with a central meridian at -123 degrees. |
| `utm_easting` | `integer` | UTM EASTING is the distance in meters eastward to or from the central meridian of a UTM zone with a false easting of 500000 meters. e.g., 440698 |
| `utm_northing` | `integer` | UTM NORTHING is the distance in meters northward from the equator. e.g., 6197826 |
| `dbm_mof_50k_grid` | `text` | WHSE_BASEMAPPING.DBM_MOF_50K_GRID map_tile_display_name, used for generating planning map pdfs |
| `linear_feature_id` | `integer` | From BC FWA, the unique identifier for a stream segment (flow network arc) |
| `blue_line_key` | `integer` | From BC FWA, uniquely identifies a single flow line such that a main channel and a secondary channel with the same watershed code would have different blue line keys (the Fraser River and all side channels have different blue line keys). |
| `watershed_key` | `integer` | From BC FWA, a key that identifies a stream system. There is a 1:1 match between a watershed key and watershed code. The watershed key will match the blue line key for the mainstem. |
| `downstream_route_measure` | `double precision` | The distance, in meters, along the blue_line_key from the mouth of the stream/blue_line_key to the feature. |
| `wscode` | `text` | A truncated version of the BC FWA fwa_watershed_code (trailing zeros removed and "-" replaced with "." |
| `localcode` | `text` | A truncated version of the BC FWA local_watershed_code (trailing zeros removed and "-" replaced with "." |
| `watershed_group_code` | `text` | The watershed group code associated with the feature. |
| `gnis_stream_name` | `text` | The BCGNIS (BC Geographical Names Information System) name associated with the FWA stream |
| `stream_order` | `integer` | Order of FWA stream at point |
| `stream_magnitude` | `integer` | Magnitude of FWA stream at point |


### gradient_barriers

### barriers_subsurfaceflow

### barriers_falls

### barriers_salmon

### barriers_steelhead

### model_access_salmon

### model_access_steelhead

### observations

## bcfishpass

bcfishpass tables

