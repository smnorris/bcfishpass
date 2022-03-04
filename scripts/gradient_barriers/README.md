# Gradient barriers

Generate points at which FWA streams exceed given slope threshold(s) for more than a specified distance.

## Method

FWA stream network lines hold standardized Z values; each vertex of a stream line holds an associated elevation value
derived from the BC Digital Elevation Model. Absolute elevation accuracy is subject to error in the DEM, but all elevations 
have been processed/QA'ed to ensure *relative* elevation is clean - all streams flow downhill. With these clean Z values, 
we can confidently calculate the gradient of a stream at any point.

To identify locations where a stream slope's exceeds a given threshold, start at the mouth of a stream (`blue_line_key`)
and iterate through each vertex of the stream flow line.  Calculate the slope of the portion of stream 100m
(or some other specified distance) upstream of each vertex. Wherever the measured slope exceeds the value of
the given threshold(s), record this location and slope as a potential 'gradient barrier'. 

To prevent identification of potential gradient barriers within waterbodies (where a slope rises directly above the waterbody), 
only these `edge_type` codes are included: `(1000,1050,1100,1150,1250,1350,1410,2000,2300)` - network connectors and similar 
are excluded.

To create and load the gradient barrier table:

    make

The script identifies potential gradient barriers at 5/7/10/12/15/20/25/30 percent thresholds, finding slope over 100m. 
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

If any gradient barriers need to be removed because they are not present/not barriers, add them to `data/gradient_barriers_passable.csv`.
