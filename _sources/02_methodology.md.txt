# Access model methodology

`bcfishpass` is an update and extension of the BC Fish Passage Technical Working Group (FPTWG) Fish Passage modelling - the basic logic for evaluating connectivity is much the same as in previous versions. Using the [BC Freshwater Atlas](https://github.com/smnorris/fwapg) (FWA) stream as the mapping base, barriers to a given species are identified and any watercourse downstream of all barriers to that species is considered 'potentially accessible' to the species. The processing steps involved are:

### 1. Collect known natural barriers
	
Collect known natural barriers: waterfalls >= 5m, subsurface flow, and miscellaneous known barriers from expert input:

| barrier type | source
---------------|-----------
| waterfalls   | [FISS obstacles](https://catalogue.data.gov.bc.ca/dataset/provincial-obstacles-to-fish-passage)
| waterfalls   | [FISS obstacles, unpublished](https://www.hillcrestgeo.ca/outgoing/public/whse_fish)
| waterfalls   | [FWA obstructions](https://catalogue.data.gov.bc.ca/dataset/freshwater-atlas-obstructions)
| waterfalls   | [expert/user identified falls](/data/user_falls.csv)
| subsurface flow | [FWA streams](https://catalogue.data.gov.bc.ca/dataset/freshwater-atlas-stream-network)
| misc         | [expert/user identified barriers](/data/user_barriers_definite.csv)


### 2. Generate gradient barriers

FWA streams are analyzed to identify point locations (“gradient barriers”) where the stream begins to exceed a chosen gradient threshold for at least 100 linear meters. The gradient threshold used depends on the swimming ability of the species of interest. Gradient barriers are added to the collection of natural barriers.

### 3. Filter natural barriers 

Natural barriers downstream of [Known Fish Observations](https://github.com/smnorris/bcfishobs) are removed from the model - we presume that if there are observations of a given species upstream of a natural feature, it cannot be a barrier to that species. To correct for species misidentification or other issues in the observations dataset a count and or date threshold can be set. For example, filter natural barriers with >= 5 observations upstream since 1990.

### 4. Identify stream downstream of all natural barriers

Watercourses downstream of all natural barriers to a given species can be considered "potentially accessible" to that species. In other words, a migratory fish of the given swimming ability could potentially access all these streams if no anthropogenic barriers are present.

### 5. Collect known anthropogenic barriers 

Dams, assessed PSCIS barriers and expert/user identified barriers are collected:

| barrier type | source
---------------|-----------
| dams                    | [Canadian Aquatic Barrier Database](https://aquaticbarriers.ca)
| PSCIS assessed barriers | [PSCIS Assessments](https://catalogue.data.gov.bc.ca/dataset/pscis-assessments)
| misc                    | [expert/user identified barriers](/data/user_barriers_anthropogenic.csv)


### 6. Model potential anthropogenic barriers

Potential anthropogenic barriers (closed bottom structures, ie culverts) are identified by mapping intersections of FWA streams and linear infrastructure (roads, rail lines, major trails). This set of potential barriers is filtered, removing locations of known bridge structures and locations where a open bottom/bridge structure is presumed to exist (where the stream is defined by a river polygon (‘double line streams’) and where the stream is of 6th order or higher). See [modelled crossings] for a full list of data sources.

### 7. Manually QA modelled potential barriers

Manual QA/QC of the potential barriers dataset has been project based - some areas have been reviewed, many have not. To date, review has primarily been along rail corridors and at very high impact sites. *Before planning field visits, further review of potential barriers is always advised*.

QA/QC is a review of commonly available satellite imagery (Google/Bing/ESRI) at the crossing site. If the imagery clearly shows a bridge or that the crossing does not exist (road or stream not present), the crossing is removed from the potential barriers dataset. Where the imagery is not definitive, the site is retained as a potential barrier. 


### 8. Report

For a given area of interest, modelling reports on:

- total length of stream potentially accessible to species of interest
- length of potentially accessible stream with no known or potential anthropogenic barriers downstream
- amount of potentially accessible stream upstream of each known/potential barrier
- amount of potentially accessible stream upstream of each known/potential barrier, and downstream of any other known/potential barrier
