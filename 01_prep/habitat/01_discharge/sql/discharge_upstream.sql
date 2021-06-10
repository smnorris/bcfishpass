-- calculate the area weighted mean of discharge contributing to a stream
WITH areas AS (
  SELECT
    a.wscode_ltree,
    a.localcode_ltree,
    b.discharge,
    b.area
  FROM bcfishpass.discharge a
  INNER JOIN bcfishpass.discharge b
  ON FWA_Upstream(a.wscode_ltree, a.localcode_ltree, b.wscode_ltree, b.localcode_ltree)
  WHERE a.watershed_group_code = :'wsg'
),

totals AS
(
  SELECT
    wscode_ltree,
    localcode_ltree,
    SUM(area) as area
  FROM areas
  GROUP BY wscode_ltree, localcode_ltree
),

weighting AS
(
  SELECT
   a.wscode_ltree,
   a.localcode_ltree,
   a.area,
   b.area as area_total,
   a.area / b.area as pct,
   a.discharge,
   (a.area / b.area) * a.discharge as weighted_discharge
  FROM areas a
  INNER JOIN totals b ON a.wscode_ltree = b.wscode_ltree AND a.localcode_ltree = b.localcode_ltree
),

weighted_mean AS
(
SELECT
  wscode_ltree,
  localcode_ltree,
  round(sum(weighted_discharge)) as discharge_upstream
FROM weighting
GROUP BY wscode_ltree, localcode_ltree
)

UPDATE bcfishpass.discharge s
SET discharge_upstream = w.discharge_upstream
FROM weighted_mean w
WHERE s.wscode_ltree = w.wscode_ltree AND s.localcode_ltree = w.localcode_ltree;
