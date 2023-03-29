# Access model

`bcfishpass` is an update and extension of the BC Fish Passage Technical Working Group (FPTWG) Fish Passage modelling - the basic logic for evaluating connectivity is much the same as in previous versions. Using the [BC Freshwater Atlas](https://github.com/smnorris/fwapg) (FWA) stream as the mapping base, barriers to a given species are identified and any watercourse downstream of all barriers to that species is considered 'potentially accessible' to the species. The processing steps involved are:

## 1. Collect known natural barriers
	
Collect known natural barriers: waterfalls 5m in height or more, subsurface flow, and miscellaneous known barriers from expert input:

| barrier type | source
---------------|-----------
| waterfalls   | [FISS obstacles](https://catalogue.data.gov.bc.ca/dataset/provincial-obstacles-to-fish-passage)
| waterfalls   | [FISS obstacles, unpublished](https://www.hillcrestgeo.ca/outgoing/public/whse_fish)
| waterfalls   | [FWA obstructions](https://catalogue.data.gov.bc.ca/dataset/freshwater-atlas-obstructions)
| waterfalls   | [expert/user identified falls](https://github.com/smnorris/bcfishpass/blob/main/data/user_falls.csv)
| subsurface flow | [FWA streams](https://catalogue.data.gov.bc.ca/dataset/freshwater-atlas-stream-network)
| expert/user identified barriers         | [bcfishpass](https://github.com/smnorris/bcfishpass/blob/main/data/user_barriers_definite.csv)


## 2. Generate gradient barriers

FWA stream network lines hold standardized Z values; each vertex of a stream line holds an associated elevation value derived from the BC Digital Elevation Model. Absolute elevation accuracy is subject to error in the DEM, but all elevations have been processed to ensure *relative* elevation is clean - all streams flow downhill. With these clean Z values, we can confidently calculate a reasonable estimate of the gradient of a stream at any point.

To identify locations where a stream's slope exceeds a given threshold, start at the mouth of a stream (identified by the `blue_line_key`) and iterate through each vertex of the stream flow line.  At each vertex, calculate the slope of the stream from the vertex to 100m upstream. Wherever the measured slope exceeds the value of the given threshold(s), record this location and slope as a potential 'gradient barrier'. 

`bcfishpass` scripts create potential gradient barriers at a number of default gradients, the threshold used for any 
given model is species dependent.


## 3. Filter natural barriers 

For anadromous species, natural barriers downstream of [Known Fish Observations](https://github.com/smnorris/bcfishobs) are removed from the model - we presume that if there are observations of the given species upstream of a natural feature, it cannot be a barrier to that species. To correct for species misidentification or other issues in the observations dataset a count and or date threshold can be set. For example, current access models for Pacific Salmon and Steelhead assume all natural barrier features with 5 or more observations upstream since 1990 are not currently barriers to fish passage.

For resident species, models generally remove any natural barrier below an observation.

## 4. Identify stream downstream of all natural barriers

Watercourses downstream of all natural barriers to a given species can be considered "potentially accessible" to that species. In other words, a migratory fish of the given swimming ability could potentially access all these streams if no anthropogenic barriers are present (presuming all else is equal and adequate flow is present in the stream).

## 5. Collect known anthropogenic barriers 

Dams, assessed PSCIS barriers and expert/user identified barriers are collected from these sources and loaded to the database:

| barrier type | source
---------------|-----------
| dams                    | [Canadian Aquatic Barrier Database](https://aquaticbarriers.ca)
| PSCIS assessed barriers | [PSCIS Assessments](https://catalogue.data.gov.bc.ca/dataset/pscis-assessments)
| expert/user identified barriers | [bcfishpass](https://github.com/smnorris/bcfishpass/blob/main/data/user_barriers_anthropogenic.csv)


## 6. Model potential anthropogenic barriers

Potential anthropogenic barriers (closed bottom structures, ie culverts) are identified by mapping intersections of FWA streams and linear infrastructure (roads, rail lines, major trails). This set of potential barriers is filtered, removing locations of known bridge structures and locations where a open bottom/bridge structure is presumed to exist.

### a. Download linear infrastructure

Road and railway features are downloaded from DataBC. Features used to generate stream crossings are defined by the queries below. The queries attempt to extract road and railway features only where the built feature type is likely to include a stream crossing structure.

| Source         | Query |
| ------------- | ------------- |
| [Digital Road Atlas (DRA)](https://catalogue.data.gov.bc.ca/dataset/digital-road-atlas-dra-master-partially-attributed-roads)  | `transport_line_type_code NOT IN ('F','FP','FR','T','TR','TS','RP','RWA') AND transport_line_surface_code != 'D' AND transport_line_structure_code != 'T' ` |
| [Forest Tenure Roads](https://catalogue.data.gov.bc.ca/dataset/forest-tenure-road-section-lines)  | `life_cycle_status_code NOT IN ('RETIRED', 'PENDING')` |
| [OGC Road Segment Permits](https://catalogue.data.gov.bc.ca/dataset/oil-and-gas-commission-road-segment-permits)  | `status = 'Approved' AND road_type_desc != 'Snow Ice Road'` |
| [OGC Development Roads pre-2006](https://catalogue.data.gov.bc.ca/dataset/ogc-petroleum-development-roads-pre-2006-public-version) | `petrlm_development_road_type != 'WINT'` |
| [NRN Railway Tracks](https://catalogue.data.gov.bc.ca/dataset/railway-track-line)  | `structure_type != 'Tunnel'` (via spatial join to `gba_railway_structure_lines_sp`) |

### b. Overlay and de-duplicate

Intersection points of the stream and road features are created. Because intersections can occur at road intersections / stream confluences where only one structure is likely to exist, crossings (on the same stream) are de-duplicated using several data source specific tolerances:

- merge DRA crossings on freeways/highways with a 30m tolerance
- merge DRA crossings on arterial/collector road with a 20m tolerance
- merge other types of DRA crossings within a 12.5m tolerance
- merge FTEN crossings within a 12.5m tolerance
- merge OGC crossings within a 12.5m tolerance
- merge railway crossings within a 20m tolerance

DRA crossings are also merged across streams at a tolerance of 10m.

After same-source data crossings are merged, all crossings are de-duplicated using a 10m tolerance across all (road) data sources (railway crossings are not merged with the road sources). The location of a given output crossing corresponds to the location from the highest priority dataset, in this order of decreasing priority: DRA, FTEN, OGC permits, OGC permits pre2006. Despite the removal of duplicates, the unique identifier for each source road within 10m of a crossing is retained, allowing all crossings to be linked back to all source road datasets that apply.

### c. Identify bridges / Open Bottom Structures

Modelled crossings are created at all intersections, but bridges/open bottom strutures are presumed to be passable. Open bottom structures are identified via these data sources and properties:

| Source         | Query        | 
| ------------- | ------------- |
| [Stream order](https://catalogue.data.gov.bc.ca/dataset/freshwater-atlas-stream-network) | `stream_order >= 6` |
| [Rivers/double line streams](https://catalogue.data.gov.bc.ca/dataset/freshwater-atlas-stream-network)  | `edge_type IN (1200, 1250, 1300, 1350, 1400, 1450, 1475)` | 
| [MOT structures](https://catalogue.data.gov.bc.ca/dataset/ministry-of-transportation-mot-road-structures) | `bmis_structure_type = 'BRIDGE'` | 
| [PSCIS structures](https://catalogue.data.gov.bc.ca/dataset/pscis-assessments) | `current_crossing_type_code = 'OBS'` |
| [DRA structures](https://catalogue.data.gov.bc.ca/dataset/digital-road-atlas-dra-master-partially-attributed-roads) | `transport_line_structure_code IN ('B','C','E','F','O','R','V')` |
| [Railway structures](https://catalogue.data.gov.bc.ca/dataset/railway-structure-line) | `structure_type LIKE 'BRIDGE%'` |


### d. Manually QA potential barriers

While the scripts attempt to identify crossings with open bottom strutures based on above rules, many more exist on the landscape. Manual review of commonly available satellite imagery (Google/Bing/ESRI) at crossing sites can often reveal if a bridge is present (and thus presumed to be passable). Where review has been done, the crossing is removed from the potential barriers dataset only if the imagery clearly shows a bridge or that the crossing does not exist (road or stream not present). Where the imagery is not definitive, the site is retained as a potential barrier. 

Note that manual QA/QC of the potential barriers dataset has been project based - some areas have been reviewed, many have not. To date, review has primarily been along rail corridors and at very high impact sites. *Before planning field visits, further review of potential barriers is always advised*. 


## 8. Report

For a given area of interest, modelling reports on:

- total length of stream potentially accessible to species of interest
- length of potentially accessible stream with no known or potential anthropogenic barriers downstream
- amount of potentially accessible stream upstream of each known/potential barrier
- amount of potentially accessible stream upstream of each known/potential barrier, and downstream of any other known/potential barrier

## 9. Known limitations

The model represents streams potentially passable/accessible to fish based only on known barriers, modelled gradient barriers, the species theoretical swimming ability, and known fish observations. Fish inventories are incomplete, the modelled swimming ability of various species is an approximation, and the model does not account for partial barriers.

There are many limitations associated with the component layers that were used to create the model. These errors and omissions are carried into the model and potentially even compounded when combined with other inputs.  

### FWA Stream Network

The FWA stream network is based on TRIM I stream linework. Streams tend to be under-represented in wet, coastal areas and over-represented in dry interior areas. 

TRIM features were delineated through airphoto interpretation and have varying degrees of accuracy – particularly when it comes to smaller streams.   TRIM commonly under-represents the number of streams in the wetter, coastal areas of the province and field surveyors may regularly find small streams which were not visible on the original airphotos due to canopy, terrain, shadows, etc.  As a result, these streams do not exist in the FWA and as a result, the model.  In wet areas, field crews will tend to find additional streams and road-stream crossings.

Conversely, in the drier, interior portions of the province, TRIM may over-represent the number or magnitude of streams.  These may be ephemeral or intermittent streams which only have water in them at the wettest times of the year.  Field crews often report finding only a ‘dry draw’ at locations where a stream has been shown on the mapping.

### Known Observations and Barriers

The fish observation and barrier inventories have similar limitations.  Fish observation data is based on the results of field sampling and fish collection permits.  The distribution and scale of this work has typically been driven by development requirements in the resource industries.  As such, the model is based on unevenly distributed data points.  Areas that have seen more development and resource extraction tend to have a higher density of sampling and observation points while other, less developed areas tend to have sparse or non-existent fish observation and barrier data.

Even areas with a high density of fish observation data may be problematic.  The observation dataset dates back to the early 20th Century and not all observation points are still valid.  Some historical records are found in areas that are no longer accessible to fish because natural (landslides) and/or man–made (dams, wiers, etc.) blockages have occurred since the time of observation.  Observation points may also have other errors such as incorrect co-ordinates or mis-identification of fish species.  Similarly, the obstructions layer is neither exhaustive nor guaranteed to be accurate.  These component data limitations may compound one another.

Adequate field testing / validation / ground truthing of this model and the assumptions that went into creating it have not been carried out.  Likewise, peer review of the methodology has also been limited. 