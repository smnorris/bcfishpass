-- calculate DCI for Elk River system above Elko dam

-- First, find the lengths of each portion of stream between barriers/potential barriers
WITH segments AS
(
  SELECT
    watershed_group_code,
    dnstr_barriers_anthropogenic,
    SUM(ST_Length(geom)) as length_segment
  FROM bcfishpass.streams
  WHERE accessibility_model_wct IS NOT NULL
  AND FWA_Upstream(356570562, 22910, 22910, '300.625474.584724'::ltree, '300.625474.584724.100997'::ltree, blue_line_key, downstream_route_measure, wscode_ltree, localcode_ltree) -- only above Elko Dam
  GROUP BY watershed_group_code, dnstr_barriers_anthropogenic
),

-- find the total length of all streams selected above
totals AS
(
  SELECT
   watershed_group_code,
   sum(length_segment) as length_total
  FROM segments
  GROUP BY watershed_group_code
)

-- calculate DCI
SELECT
  t.watershed_group_code,
  ROUND(SUM((s.length_segment * s.length_segment) / (t.length_total * t.length_total))::numeric, 4) as dci
FROM segments s
INNER JOIN totals t
ON s.watershed_Group_code = t.watershed_group_code
GROUP BY t.watershed_group_code;