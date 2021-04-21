-- calculate potadromous DCI for Elk River system below Elko dam
-- (simply the length accessible divided by the length of total accessible/potentially accessible)


WITH lengths AS
(SELECT
    SUM(ST_Length(geom)) FILTER (WHERE accessibility_model_wct = 'ACCESSIBLE') as length_accessible,
    SUM(ST_Length(geom)) FILTER (WHERE accessibility_model_wct IN ('POTENTIALLY ACCESSIBLE', 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM')) as length_inaccessible
  FROM bcfishpass.streams
  WHERE accessibility_model_wct IS NOT NULL
  AND wscode_ltree <@ '300.625474.584724'::ltree
  AND NOT FWA_Upstream(356570562, 22910, 22910, '300.625474.584724'::ltree, '300.625474.584724.100997'::ltree, blue_line_key, downstream_route_measure, wscode_ltree, localcode_ltree)
)

SELECT
 round((length_accessible / (length_accessible + length_inaccessible))::numeric, 4) as dci
FROM lengths;