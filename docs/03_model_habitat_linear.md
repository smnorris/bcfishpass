(linear_habitat)=
# Linear spawning/rearing habitat model

Streams accessible to fish may be suitable for spawning or rearing, or may only be used as movement corridors to reach such habitats. When estimating fragmentation and prioritizing further work, the amount of usable spawning or rearing habitat (habitat quality) is of greater interest than the raw amount of corridor habitat. In addition to modelling barriers to fish passage, `bcfishpass` can model the intrinsic potential (IP) of streams to support spawning or rearing activities for several species (Pacific Salmon, Steelhead, Bull Trout, Westslope Cutthroat Trout).

Linear spawning/rearing habitat modelling is currently based on species specific criteria for:

- stream gradient
- channel width or discharge (depending on modelling requirments and/or data availability)
- connectivity (rearing streams must be connected to spawning streams)
- feature type (spawning or rearing occurs in stream / wetland / lake etc)

Output model data is also augmented with known/observed spawning locations (from FISS observations, PSF Pacific Salmon Explorer, and CWF WCRP stakeholder input)

## Gradient

Gradient of each stream segment is calculated as rise over run. Rise is taken from the Z value of the endpoints of the stream segments. Run is the length of the steam segments. Stream segments are from the BC Freshwater Atlas, further subdivided by other stream-referenced features used in the model (streams are split at barriers and observations when processing the access model). Stream lengths used for gradient calculation can thus be changed if an observation or barrier is added to the database, breaking an existing segment into smaller segments (this results in small inconsistencies to habitat outputs for a given area over time, a known limitation of the current model).

## Channel width / discharge

Spawning and rearing activity depends on sufficent flow to the stream. `bcfishpass` can be configured to use either mean annual discharge (m3/s) or channel width (m) (as a discharge proxy), depending on data availability and/or user preference. Per species spawning and rearing discharge/channel width thresholds are taken from the literature and, where unavailable in the literature, derived from known fish spawning locations. 

Discharge is modelled within the Fraser, Columbia and Peace basins: 
https://www.pacificclimate.org/data/gridded-hydrologic-model-output
https://github.com/smnorris/bcfishpass/blob/main/model/02_habitat_linear/discharge

Channel width is modelled for all of BC:
https://www.poissonconsulting.ca/temporary-hidden-link/859859031/channel-width-21b/
https://github.com/smnorris/bcfishpass/tree/main/model/02_habitat_linear/channel_width

Note that results from the above models are only valid for streams with 100% of their contributing area with BC - data for contributing area and precipitiation are both cut off at the BC border.

Values and sources for Pacific salmon and steelhead gradient and discharge/channel width thresholds are documented in Table 1 of [Rebelatto et al (2024)](https://cwf-fcf.org/en/resources/research-papers/BC_report_formatted_final.pdf), and can be adjusted per-model via the [parameters_habitat_thresholds.csv](
https://github.com/smnorris/bcfishpass/blob/main/parameters/example_testing/parameters_habitat_thresholds.csv) file.


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