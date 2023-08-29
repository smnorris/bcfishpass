# Data files

User editable inputs. 


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


## user_falls.csv

Falls not present in FWA/FISS. Both barriers and non-barriers may be included.
NOTE - to be removed after bcfishpass incorporates CABD falls, submit CABD falls fixes to CABD.


## user_habitat_classification.csv

Manually specify known segments of rearing/spawning habitat for target species.


## user_modelled_crossing_fixes.csv

Update the barrier status of modelled culverts
(based primarily on imagery review, finding locations where bridges are present / no stream is present / 
no road is present)


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


## dfo_known_sockeye_lakes.csv

`waterbody_poly_id` of FWA lakes known to potentially support Sockeye
Source is `Conservation Units for Pacific Salmon under the Wild Salmon Policy, L. Blair Holtby1 and Kristine A. Ciruna2, 2007`
Data were provided by PSF as 50k lakes shapefile then referenced to FWA by SN.
