# Gradient barriers

Create and load potential [gradient barriers](https://smnorris.github.io/bcfishpass/02_model_access.html#generate-gradient-barriers).

- gradient barriers are generated at 5/7/10/12/15/20/25/30 percent thresholds, using a 100m minimum length
- only watershed groups included in `bcfishpass.parameters_habitat_method` are processed/included



## Usage

To load the gradient barrier table:

    ./gradient_barriers.sh

1. To change the slope thresholds of interest or the length interval over which slope is measured, edit `sql/gradient_barriers_load.sql`.

2. This tool identifies the locations of *all* potential gradient barriers based on *all* given thresholds. The gradient
threshold modelled as a barrier for a given species is controlled by the access model query corresponding to that species. 

3. If any of the created gradient barriers need to be ignored when modelling (because they are not present/not barriers), 
add them to `bcfishpass/data/user_barriers_definite_control.csv`.