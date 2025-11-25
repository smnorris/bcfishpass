# Access model

- for a given species or species grouping, identify stream downstream of natural barriers (known and modelled) 
- identify locations of known and potential anthropogenic barriers to fish passage and their impacts on connectivity

See [docs](https://smnorris.github.io/bcfishpass/02_methodology.html) for methodology.

## Setup

#### Study area

Watershed groups to be processed are listed in ../data/parameters_habitat_method.csv - edit this file to change the study area.

#### Modify existing models

To modify a model for a given species, edit `sql/model_barriers_<spp>.sql` to update required criteria (for example, modify the maximum gradient barrier threshold)

#### Add new models

1. If modelling species not covered in existing models, edit `bcfishpass/data/wsg_species_precence.csv` to include a column for any additional species, noting the watershed groups where they occur
2. add a new `sql/model_access_<spp>.sql` file defining barriers to the species/species group, and what features may cancel barriers (observations, known habitat - see existing files for examples)
3. update `sql/observations.sql` as required to ensure observations for any new species of interest are captured in model
4. update `sql/load_streams_access.sql` and various output tables/views to include new column(s) of interest


## Process

Load gradient barriers and subsurface flow from source tables to standard `bcfishpass.barriers_<type>` tables. 
This should only have to be run occasionally - when the barrier definition changes or the FWA data changes.
    

    ./00_load_fwa_barriers.sh 

Run the model:

    ./01_model_access_natural.sh
    ./02_model_access_anthropogenic.sql


## Outputs

See [docs](https://smnorris.github.io/bcfishpass/02_model_access.html).