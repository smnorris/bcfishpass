# Observations

Extract observations of species of interest from `bcfishobs.observations` to `bcfishpass.observations`.

Note that the lists of species in`sql/observations.sql` must be edited when species are added to the model.

## Usage

	psql $DATABASE_URL -f sql/observations.sql