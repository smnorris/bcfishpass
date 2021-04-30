# Gradient barriers

Generate points at which FWA streams exceed given slope threshold(s) for more than a specified distance.

FWA stream network lines hold standardized Z values; every vertex of a stream holds an associated elevation value
derived from the BC Digital Elevation Model and also QA'ed to ensure that all streams flow downhill. With these Z
values, it is easy to analyze the gradient of a stream at any point.

To identify potential gradient barriers on a given stream, start at the mouth of a stream (`blue_line_key`) and
iterate through each vertex of the stream flow line, calculating the gradient between the given vertex and a
point 100m upstream. Any 100m section of stream with gradient falling within the noted gradient classes is
identified and a point is generated at the vertex where this slope begins.

These are the `edge_type`s included: `(1000,1050,1100,1150,1250,1350,1410,2000,2300)` - network connectors
within lakes and similar are excluded.

To create and load the gradient barrier table:

    ./gradient_barriers.sh

To change the slope thresholds of interest or the interval at which slope is measured, edit `sql/gradient_barriers.sql`