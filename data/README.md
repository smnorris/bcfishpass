# Data files

User editable inputs.


## pscis_modelledcrossings_streams_xref.csv

Correct/force linkage of PSCIS crossings to FWA streams and/or modelled crossings.


## user_barriers_anthropogenic.csv

Add built stream crossing features that are not dams or culverts here (eg weirs, flood control structures, other)


## user_barriers_definite.csv

Add known locations of barriers to fish passage not present in other sources. Includes interpretation of PSCIS
assessment comments where stream is not accessible (unmapped falls downstream or similar)


## user_barriers_definite_control.csv

Control the barrier status of input data. Eg, set a known FISS falls of unknown height to be a barrier.


## user_falls.csv

Falls not present in FWA/FISS. Both barriers and non-barriers may be included.


## user_habitat_classification.csv

Manually specify known segments of rearing/spawning habitat for target species.


## user_modelled_crossing_fixes.csv

Update the barrier status of modelled culverts
(based primarily on imagery review, finding locations where bridges are present or no road is present)


## user_pscis_barrier_status.csv

Update the barrier status of PSCIS crossings (for bcfishpass modelling only). PSCIS submissions can be slow,
support planning by adding barrier status of a crossing before a submission is made.


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
