# Misc supporting data

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

To load:

    psql -c "CREATE TABLE bcfishpass.wsg_species_presence (
                watershed_group_code varchar(4),
                co boolean,
                ch boolean,
                sk boolean,
                st boolean,
                wct boolean,
                notes text);"
    psql -c "\copy bcfishpass.wsg_species_presence FROM 'wsg_species_presence.csv' delimiter ',' csv header"