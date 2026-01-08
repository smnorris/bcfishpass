# Data and fix tables 

User editable data inputs and fixes - mostly fix tables.

To make a fix to bcfishpass inputs via these tables:

- clone the repository
- edit the file of interest, making the required fix/addition
- create a pull request

## cabd_additions

Insert falls or dams required for bcfishpass but not present in CABD. Includes placeholders for dams outside of BC

| Column | Type | Description |
|--------|------|-------------|
| `feature_type` | `text` | Feature type, either waterfalls or dams |
| `name` | `text` | Name of waterfalls or dam |
| `height` | `numeric` | Height (m) of waterfalls or dam |
| `barrier_ind` | `boolean` | Barrier status of waterfalls or dam (true/false) |
| `blue_line_key` | `integer` | FWA blue_line_key (flow line) on which the feature lies |
| `downstream_route_measure` | `integer` | The distance, in meters, along the blue_line_key from the mouth of the stream/blue_line_key to the feature. |
| `reviewer_name` | `text` | Initials of user submitting the review, eg SN |
| `review_date` | `date` | Date of review, in form YYYY-MM-DD eg 2025-01-07 |
| `source` | `text` | Description or link to the source(s) documenting the feature |
| `notes` | `text` | Reviewer notes on rationale for addition of the feature and/or how the source were interpreted |

## cabd_blkey_xref

Cross reference CABD features to FWA flow lines (blue_line_key), used when CABD feature location is closest to an inapproprate flow line

| Column | Type | Description |
|--------|------|-------------|
| `cabd_id` | `text` | CABD unique identifier |
| `blue_line_key` | `integer` | FWA blue_line_key (flow line) to which the CABD feature should be linked |
| `reviewer_name` | `text` | Initials of user submitting the review, eg SN |
| `review_date` | `date` | Date of review, in form YYYY-MM-DD eg 2025-01-07 |
| `notes` | `text` | Reviewer notes on rationale for fix and/or how the source(s) were interpreted |

## cabd_exclusions

Exclude CABD records (waterfalls and dams) from bcfishpass usage

| Column | Type | Description |
|--------|------|-------------|
| `cabd_id` | `text` | CABD unique identifier |
| `feature_type` | `text` | Feature type, either waterfalls or dams |
| `reviewer_name` | `text` | Initials of user submitting the review, eg SN |
| `review_date` | `date` | Date of review, in form YYYY-MM-DD eg 2025-01-07 |
| `source` | `text` | Description or link to the source(s) indicating why the feature should be excluded |
| `notes` | `text` | Reviewer notes on rationale for exclusion and/or how the source were interpreted |

## cabd_passability_status_updates

Update the passability_status_code (within bcfishpass) of existing CABD features (dams or waterfalls)

| Column | Type | Description |
|--------|------|-------------|
| `cabd_id` | `text` | CABD unique identifier |
| `passability_status_code` | `integer` | Code referencing the degree to which the feature acts as a barrier to fish in the upstream direction. (1=Barrier, 2=Partial barrier, 3=Passable, 4=Unknown, 5=NA-No Structure, 6=NA-Decommissioned/Removed) |
| `reviewer_name` | `text` | Initials of user submitting the review, eg SN |
| `review_date` | `date` | Date of review, in form YYYY-MM-DD eg 2025-01-07 |
| `source` | `text` | Description or link to the source(s) documenting the passability status of the feature |
| `notes` | `text` | Reviewer notes on rationale for fix and/or how the source(s) were interpreted |


## dfo_known_sockeye_lakes.csv

`waterbody_poly_id` of FWA lakes known to potentially support Sockeye
Source is `Conservation Units for Pacific Salmon under the Wild Salmon Policy, L. Blair Holtby1 and Kristine A. Ciruna2, 2007`
Data were provided by PSF as 50k lakes shapefile then referenced to FWA.


## observation_exclusions

Flag FISS observation points for exclusion (temporary/one time releases or data errors) or as ongoing releases (ongoing release programs create valid habitat, but are inapproprate for natural barrier QA).

| Column | Type | Description |
|--------|------|-------------|
| `observation_key` | `text` | bcfishobs created stable unique id, a hash of columns [source, species_code, observation_date, utm_zone, utm_easting, utm_northing, life_stage_code, activity_code] |
| `exclude` | `boolean` | Set as true to exclude the observation from bcfishpass - either the observation is a data error or related to a limited/one time release/stocking event. |
| `release` | `boolean` | Set as true to flag the observation as part of an ongoing release program (for general info and to exclude from QA of natural barriers) |
| `reviewer_name` | `text` | Initials of user submitting the review, eg SN |
| `review_date` | `date` | Date of review, in form YYYY-MM-DD eg 2025-01-07 |
| `source_1` | `text` | Description or link to the primary source(s) documenting the observation or related information |
| `source_2` | `text` | Description or link to the secondary source(s) documenting the observation or related information |
| `notes` | `text` | Reviewer notes on rationale for fix and/or how the source(s) were interpreted |


## pscis_modelledcrossings_streams_xref.csv

Correct/force linkage of PSCIS crossings to FWA streams and/or modelled crossings.


## user_barriers_anthropogenic.csv

Anthropogenic barriers not present in inventories or modelling (eg weirs, flood control structures, 
crossings on unmapped roads/railways, other). Do not add dams/weirs, these should be submitted to CABD.


## user_barriers_definite.csv

Locations of additional known natural barriers to fish passage not present in other sources, plus 
other misc barriers used to exclude upstream from consideration (eg, stream does not exist due to mining impacts)
Includes interpretation of PSCIS assessment comments where stream is not accessible to fish (unmapped falls downstream or similar).


## user_barriers_definite_control.csv

Currently, controls the barrier status of natural barriers (gradient, falls, subsurface flow). 
NOTE -  this table will only be used to identify modelled barriers known to be passable 
(gradient, subsurface flow) once bcfishpass incorporates CABD falls


## user_habitat_classification.csv

Manually specify known segments of rearing/spawning habitat for target species.


## user_modelled_crossing_fixes.csv

Update the barrier status of modelled culverts
(based primarily on imagery review, finding locations where bridges are present / no stream is present / 
no road is present)


## user_pscis_barrier_status.csv

Update the barrier status of PSCIS crossings (for bcfishpass modelling only). PSCIS submissions can be slow,
support planning by adding barrier status of a crossing before a submission is made.


## wcrp_watersheds.csv

A list of watershed groups and target species for CWF WCRP reporting.


## wsg_species_presence.csv

A list of all BC watershed groups and presence/absence of target species (Coho, Chinook, Sockeye, Steelhead, West Slope Cutthroat Trout).
Data created by CWF/Hillcrest Geographics, 2019/2020.

Watersheds were assigned presence/absence of given species based on review of:
- BC Fish Observations
- associated FISS records/database
- literature review

**CAVEAT**
This list is by no means a definitive list of watersheds that may support salmon.
The list was generated as an input for prioritizing watersheds for further salmon/steelhead fish passage assessments.
As such, watersheds in the Columbia (upstream of the Chief Joseph dam) and Mackenzie Basins were defined as out of scope.
