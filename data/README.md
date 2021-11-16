# Misc supporting data

## wsg_species_presence.csv

List of all BC watershed groups and presence/absence of target species (Coho, Chinook, Sockeye, Steelhead, West Slope Cutthroat Trout)

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