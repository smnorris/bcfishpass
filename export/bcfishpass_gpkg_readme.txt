========
bcfishpass file outputs (DRAFT)
========

Background
========
For details on how the data is generated, see the [bcfishpass code repository](https://github.com/smnorris/bcfishpass)


Layers
========

crossings
--------------
This layer combines stream crossings from several sources:
1. [PSCIS crossings](https://catalogue.data.gov.bc.ca/dataset?q=pscis) (assessments, habitat confirmations, designs, remediations
), that can be matched to a FWA stream
2. [Modelled road-stream crossings](https://github.com/smnorris/bcfishpass/tree/main/scripts/modelled_stream_crossings) (roads, railway, trails etc)
3. [Dams](https://github.com/smnorris/bcdams)

pscis_not_matched_to_streams
--------------
PSCIS crossings not matched to a FWA stream and therefore not included in the crossings layer.
Only basic info is included in this table, for more information about these crossings see the corresponding stream_crossing_id record in the source PSCIS layers.

streams
--------------
BC FWA stream network, with additional fish passage and fish habitat modelling attributes added.


Contacts
========
For more information, please contact:

Simon Norris
Spatial Data Scientist
Hillcrest Geographics
snorris@hillcrestgeo.ca

Craig Mount
Aquatic Habitat Geomorphologist
Ecosystems Information Section
Craig.Mount@gov.bc.ca