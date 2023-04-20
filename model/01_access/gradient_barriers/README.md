# Gradient barriers

Generate points at which FWA streams exceed given slope threshold(s) for more than a specified distance.

## Usage

To create and load the gradient barrier table:

    make

This tool creates potential gradient barriers at 5/7/10/12/15/20/25/30 percent thresholds, finding slope over 100m. 
To change the slope thresholds of interest or the interval over which slope is measured, edit `sql/gradient_barriers.sql`.

Note that this tool identifies the locations of *all* potential gradient barriers based on *all* given thresholds. The gradient
threshold modelled as a barrier for a given species is controlled by the access model query corresponding to that species. 

## Output table

                         Table "bcfishpass.gradient_barriers"
              Column          |       Type       | Collation | Nullable | Default
    --------------------------+------------------+-----------+----------+---------
     blue_line_key            | integer          |           | not null |
     downstream_route_measure | double precision |           | not null |
     gradient_class           | integer          |           |          |
    Indexes:
        "gradient_barriers_pkey" PRIMARY KEY, btree (blue_line_key, downstream_route_measure)
        "gradient_barriers_test_blue_line_key_idx" btree (blue_line_key)

## Override data errors / note gradient barriers that do not exist

If any gradient barriers need to be removed because they are not present/not barriers, add them to `bcfishpass/data/gradient_barriers_passable.csv`.