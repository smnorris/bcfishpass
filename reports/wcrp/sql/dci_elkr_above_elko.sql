-- calculate DCIa and DCIp for Elk River system above Elko dam

-- First, get total stream lengths for DCI_a (aka Longest Fragment) for habitat ONLY

WITH lengths_a AS
(SELECT
  SUM(ST_Length(geom)) FILTER (WHERE dnstr_barriers_anthropogenic = ARRAY[1100002536]) as length_accessible,
  SUM(ST_Length(geom)) FILTER (WHERE dnstr_barriers_anthropogenic <> ARRAY[1100002536]) as length_inaccessible
FROM bcfishpass.streams
WHERE (rearing_model_wct IS TRUE OR spawning_model_wct IS TRUE)
AND FWA_Upstream(356570562, 22910, 22910, '300.625474.584724'::ltree, '300.625474.584724.100997'::ltree, blue_line_key, downstream_route_measure, wscode_ltree, localcode_ltree) -- only above Elko Dam

),

-- Second, find the lengths of each portion of stream between barriers/potential barriers for habitat ONLY
segments AS
(
  SELECT
    watershed_group_code,
    dnstr_barriers_anthropogenic,
    SUM(ST_Length(geom)) as length_segment
  FROM bcfishpass.streams
  WHERE (rearing_model_wct IS TRUE OR spawning_model_wct IS TRUE)
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
),

-- calculate DCI_p
dci_p AS
(
SELECT
  t.watershed_group_code,
  ROUND(SUM((s.length_segment * s.length_segment) / (t.length_total * t.length_total))::numeric, 4) as dci_p
FROM segments s
INNER JOIN totals t
ON s.watershed_Group_code = t.watershed_group_code
GROUP BY t.watershed_group_code
),

-- calculate DCI_a
dci_a AS
(
SELECT
 round((length_accessible / (length_accessible + length_inaccessible))::numeric, 4) as dci_a
FROM lengths_a)

-- report
SELECT
  length_accessible,
  (length_accessible + length_inaccessible) as length_all_habitat,
  a.dci_a,
  p.dci_p
FROM lengths_a,dci_a a, dci_p p