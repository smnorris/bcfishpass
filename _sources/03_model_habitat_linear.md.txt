(linear_habitat)=
# Linear spawning/rearing habitat model

Streams accessible to fish may be suitable for spawning or rearing, or may only be used as movement corridors to reach such habitats. When estimating fragmentation and prioritizing further work, the amount of usable spawning or rearing habitat (habitat quality) is of greater interest than the raw amount of corridor habitat. In addition to modelling barriers to fish passage, `bcfishpass` can model the intrinsic potential (IP) of streams to support spawning or rearing activities for several species (Pacific Salmon, Steelhead, Bull Trout, Westslope Cutthroat Trout).

Linear spawning/rearing habitat modelling is currently based on species specific criteria for:

- stream gradient
- channel width or discharge (depending on modelling requirments and/or data availability)
- connectivity (rearing streams must be connected to spawning streams)
- feature type (spawning or rearing occurs in stream / wetland / lake etc)

Per species threshold values for stream gradient and discharge/channel width are noted (and can be adjusted) in the file [parameters_habitat_thresholds.csv](
https://github.com/smnorris/bcfishpass/blob/main/parameters/example_testing/parameters_habitat_thresholds.csv).

Sources (via literature and analysis) for these values for Pacific salmon and steelhead are documented in Table 1 of [Rebelatto et al (2024)](https://cwf-fcf.org/en/resources/research-papers/BC_report_formatted_final.pdf).

Streams with observed spawning or rearing (from [FISS](https://catalogue.data.gov.bc.ca/dataset/known-bc-fish-observations-and-bc-fish-distributions) via [bcfishobs](https://github.com/smnorris/bcfishobs), PSF's [Pacific Salmon Explorer](https://www.salmonexplorer.ca), and CWF [WCRP](https://www.globalconservationsolutions.com/wp-content/uploads/2022/03/CWF-WCRP-Guide.pdf) stakeholder inputs) are automatically classified as spawning or rearing regardless of stream characteristics.

## Gradient

Per species spawning/rearing gradient thresholds were taken from the literature and, where unavailable in the literature, derived from known fish spawning locations.

Gradient of each stream segment is calculated as rise over run. Rise is taken from the Z value (elevation) of the endpoints of the stream segments. Run is the length of the steam segments.  
Stream segments are BC Freshwater Atlas stream network features, further subdivided by other stream-referenced features used in the model (when processing the access model, streams are split at natural barriers, anthropogenic crossings, and at locations of FISS observations of species listed [here](https://github.com/smnorris/bcfishpass/blob/main/model/01_access/sql/load_observations.sql) - currently `BT`,`CH`,`CM`,`CO`,`CT`,`DV`,`GR`,`PK`,`RB`,`SK`,`ST`,`WCT`).  

Note that stream lengths and resulting gradient will change if a new natural barrier, anthropogenic crossing, or observation is added to the database - breaking an existing segment into smaller segments. These changes to gradient can result in small inconsistencies to modelled spawning/rearing outputs for a given area over time.



## Discharge / channel width

Spawning and rearing activity depends on sufficent flow to the stream. `bcfishpass` can be configured to use either mean annual discharge (m3/s) or channel width (m) (as a discharge proxy), depending on data availability and/or user preference. 
Per species spawning and rearing discharge/channel width thresholds are taken from the literature and, where unavailable in the literature, derived from known fish spawning locations. 

Discharge is modelled within the Fraser, Columbia and Peace basins:  

- [PCIC source](https://www.pacificclimate.org/data/gridded-hydrologic-model-output)
- [upsampling of source to FWA streams](https://github.com/smnorris/fwapg/tree/main/extras/discharge)

Channel width is modelled for all of BC:  

- [Poisson Consulting](https://www.poissonconsulting.ca/temporary-hidden-link/859859031/channel-width-21b/) model based on upstream area / precipitation
- [data collection/preparation](https://github.com/smnorris/fwapg/tree/main/extras/channel_width)

**NOTE** contributing area (FWA watersheds) and precipitiation (ClimateBC) datasets used to model discharge / channel width are both cut off at the BC border:

- *all results from the above models are only valid for streams with 100% of their contributing area with BC*
- *streams with contributing area outside of BC (and thus with invalid spawning/rearing models) ARE NOT CURRENTLY NOTED in model outputs/file distributions*



## Feature type and connectivity

For various species and life stages, further filtering of streams to model as potential spawning/rearing habitat (based on gradient and discharge/channel width) is applied via feature type and connectivity criteria:

| Species | Life stage | Additional feature type and connectivity criteria |
|---------|------------|--------------------------------|
| Bull Trout | spawning   | within streams/rivers
| Bull Trout | rearing    | within streams/rivers AND ( <br> on spawning stream OR <br> downstream of spawning stream OR <br> on a tributary downstream of spawning and beginning within 10m of the tributary OR <br> <10km upstream of spawning with no stream segment of slope >=5% between the spawning and potential rearing <br>)   |
| Chinook | spawning   | within streams/rivers          |
| Chinook | rearing    | (within streams/rivers OR wetland) AND (<br> on spawning stream OR downstream of spawning stream OR <br> on a tributary downstream of spawning and beginning within 10m of the tributary OR <br> <10km upstream of spawning with no stream segment of slope exceeding 5% between the spawning and potential rearing <br> )<br>  **Note** - *Chinook rearing in wetlands is not initially restricted by gradient and discharge/channel width*|
| Chum | spawning   | within streams/rivers
| Chum | rearing    | No rearing modelled (this species does not generally rear in fresh water)   |
| Coho | spawning   | within streams/rivers
| Coho | rearing    | within streams/rivers AND ( <br> on spawning stream OR <br> downstream of spawning stream OR <br> on a tributary downstream of spawning and beginning within 10m of the tributary OR <br> <10km upstream of spawning with no stream segment of slope exceeding 5% between the spawning and potential rearing <br> )  |
| Pink | spawning   | within streams/rivers
| Pink | rearing    | No rearing modelled (this species does not generally rear in fresh water)   |
| Sockeye | spawning   | within streams/rivers AND ( <br> <3km downstream of rearing lake, with no stream segment of slope >=5% between the rearing lake and the potential spawning stream OR <br> upstream of the rearing lake and connected to the rearing lake (within 2m) <br>)|
| Sockeye | rearing    | lakes of >= 2km2   |
| Steelhead | spawning   | within streams/rivers          |
| Steelhead | rearing    | within streams/rivers AND ( <br> on spawning stream OR <br> downstream of spawning stream OR <br> on a tributary downstream of spawning and beginning within 10m of the tributary OR <br> <10km upstream of spawning with no stream segment of slope exceeding 5% between the spawning and potential rearing <br> ) |
| Westslope Cutthroat Trout | spawning   | within streams/rivers          |
| Westslope Cutthroat Trout | rearing    | within streams/rivers AND ( <br> on spawning stream OR <br> downstream of spawning stream OR <br> on a tributary downstream of spawning and beginning within 10m of the tributary OR <br> <10km upstream of spawning with no stream segment of slope exceeding 5% between the spawning and potential rearing <br> )   |