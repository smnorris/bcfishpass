# Access model

- for a given species or species grouping, identify stream downstream of natural barriers (known and modelled) 
- identify locations of known and potential anthropogenic barriers to fish passage and their impacts on connectivity

See [docs](https://smnorris.github.io/bcfishpass/02_methodology.html) for methodology.

## Setup

#### Study area

Watershed groups to be processed are listed in `wsg.txt`. Edit this file as required.

#### Modify existing models

To modify a model for a given species, edit `sql/model_barriers_<spp>.sql` to update required criteria (for example, modify the maximum gradient barrier threshold)

#### Add new models

1. If modelling species not covered in existing models, edit `bcfishpass/data/wsg_species_precence.csv` to include a column for any additional species, noting the watershed groups where they occur
2. add a new `sql/model_access_<spp>.sql` file defining barriers to the species/species group, and what features may cancel barriers (observations, known habitat - see existing files for examples)
3. update `sql/observations.sql` as required to ensure observations for any new species of interest are captured in model
4. update `sql/access.sql` to set model output column to empty text array where no barriers exist downstream
5. update `sql/streams_model_access.sql` to load model output column into streams table


## Process

To run all scripts:

    make

## Outputs

See [docs](https://smnorris.github.io/bcfishpass/02_methodology.html).