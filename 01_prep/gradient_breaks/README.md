# Gradient breaks

Generate points at which FWA streams exceed given slope threshold(s) for more than a specified distance.

FWA stream network lines hold standardized Z values; every vertex of a stream holds an associated elevation value
derived from the BC Digital Elevation Model and also QA'ed to ensure that all streams flow downhill. With these Z
values, it is easy to analyze the gradient of a stream at any point.

To identify potential gradient barriers on a given stream, start at the mouth of a stream (`blue_line_key`) and
iterate through each vertex of the stream flow line, calculating the gradient between the given vertex and the
next vertex at least 100m (or as otherwised specified) upstream.  Any section of stream with gradient falling
within the noted gradient classes is identified and a 'gradient break' point is generated at the vertex where this
slope begins.

To generate:

    python gradient_breaks.py <thresholds> <interval> <watershed_groups>