# Model QA 

A rough protocol and checklists to ensure:

1. Accuracy - model is functioning as expected
2. Consistency - model outputs are consistent


## 1. Accuracy

Checks to be performed depend on where changes have been made - parameters, data or scripts.

#### A. Parameters

When changing any item in the `parameters` files (study area, IP model method/parameters), detailed checks are required.

#### B. Data 

For changes to bcfishpass data tables, ensure the fixes are being applied correctly.

#### C. Scripts 

Checks required for scripting changes will vary based on the change made. 
Work through the full QA checklist to identify checks relevant to changes made. 
Once script changes are confirmed to be functional, consider adding a consistency check query to monitor outputs.


### Model accuracy checklist

| A | B | C | check |
| --|---|---|-------|
| x |   |   | review study area - are all watershed groups specified in `parameters/parameters_habitat_method.csv` included in output?
| x |   | x | compare per-species linear habitat outputs to species presence view - are all expected watershed groups included per spp?
| x |   | x | review top 10-20 natural barriers per species (bcfishpass.barriers_ch_cm_co_pk_sk etc), are barriers correct/present?
| x |   | x | review selection of top natural barriers in randomized views (`bcfishpass.barriers_ch_cm_co_pk_sk_qa_100random`, `bcfishpass.barriers_ch_cm_co_pk_sk_qa_100random`)
| x |   | x | compare natural barriers to known habitat layer - are known habitat locations (generally) downstream of all barriers? (for anadromous spp)
| x |   | x | review top dams acting as barrier (10-20) in study area to confirm barriers are as expected/find any required data fixes
| x |   | x | review mapping of streams above dams - are there major sections of stream classed as isolated where a dam is likely passable/non-existent?
| x |   | x | review the top PSCIS barriers (10-20) in study area to confirm barriers are as expected/find any required data fixes
| x |   | x | review mapping of streams above PSCIS assessed barriers - are there major sections of stream classed as isolated due to stream/point mismatch?
| x |   | x | review top modelled crossings (10-20) in study area to confirm barriers are as expected/find any required data fixes
| x |   | x | review mapping of streams above modelled crossings - are there major sections of stream classed as isolated where a culvert is likely passable/non-existent?
| x |   | x | review selection of top anthropogenic barriers included in randomized views (`pscis_qa_100random`, `dams_qa_20random`, `modelled_stream_crossings_qa_100random`)
| x |   | x | compare output linear habitat to the known habitat layer - are areas of known spawning/rearing all included in model output? What kind of features are missed? Why?
| x |   | x | targeted review of a small selection of low gradient streams - does spawning/rearing classification match what is expected given the CW/MAD/gradient parameters?
| x | x |   | review small random selection of natural barrier fixes (or new fixes) to ensure fixes have been applied
| x | x |   | review small random selection of PSCIS-stream matching fixes (or new fixes) to ensure fixes have been applied
| x | x |   | review small random selection of known habitat fixes (or new fixes) to ensure fixes have been applied

Reviews can primarily be done within QGIS, using `bcfishpass/qgis/qa.qlr`

### 2. Consistency

For every run of the model, review summary tables for unexpected changes:

- [ ] barrier count/type per watershed group
- [ ] length of habitat per type (total stream / potentially accessible / modelled spawning-rearing) per watershed group
- [ ] comparison of length of modelled spawning vs length of known spawning
- [ ] habitat connectivity per watershed group
- [ ] top natural barriers per watershed group, natural
- [ ] top anthropogenic barriers per watershed group
- [ ] project specific reporting (eg WCRP/rail)

Add to this list as required, tracking specific outputs where useful (as a kind of regression testing).