# Gradient barriers

Generate points at which FWA streams exceed given slope threshold(s) for more than a specified distance.

## Method

FWA stream network lines hold standardized Z values; every vertex of a stream holds an associated elevation value
derived from the BC Digital Elevation Model and also QA'ed to ensure that all streams flow downhill. With these Z
values, it is easy to analyze the gradient of a stream at any point.

To identify locations where stream slope exceeds the threshold, start at the mouth of a stream (`blue_line_key`)
and iterate through each vertex of the stream flow line, calculating the slope for the portion of stream 100m
(or some other specified distance) upstream of the vertex. Wherever the upstream slope exceeds the value of
one of the provided gradient classes the slope and the location of the vertex are recorded.

To prevent breaks occuring within waterbodies (where a slope rises directly above the waterbody), only these `edge_type`
codes are included: `(1000,1050,1100,1150,1250,1350,1410,2000,2300)` - network connectors and similar are excluded.

To create and load the gradient barrier table:

    ./gradient_barriers.sh

This creates gradient breaks at 5/10/15/20/25/30 percent thresholds, finding slope over 100m. To change the slope
thresholds of interest or the interval over which slope is measured, edit `sql/gradient_barriers.sql`.

Note this script simply identifies the locations of all gradient breaks based on the given thresholds. Which
gradient breaks are actually used as barriers is controlled in the connectivity model.

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