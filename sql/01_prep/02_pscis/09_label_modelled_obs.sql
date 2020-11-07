-- In the modelled crossings table we can note OBS features based on PSCIS assessed crossings (that match a stream)
-- This won't be useed in the output barriers table because the model features are replaced by PSCIS points,
-- but it is useful for improving reporting on how many OBS features we can find.

-- todo - is this the best way to do this?
-- we should probably use the matched ids rather than doing another join based on proximity?

WITH pscis_obs AS
(
  SELECT
    e.stream_crossing_id,
    e.linear_feature_id,
    e.downstream_route_measure,
    p.current_crossing_type_code
  FROM whse_fish.pscis_events e
  INNER JOIN whse_fish.pscis_points_all p
  ON e.stream_crossing_id = p.stream_crossing_id
  WHERE p.current_crossing_type_code = 'OBS'
)
UPDATE bcfishpass.modelled_stream_crossings x
SET
  modelled_crossing_type = 'OBS',
  modelled_crossing_type_source = modelled_crossing_type_source||ARRAY['PSCIS']
FROM pscis_obs p
WHERE x.linear_feature_id = p.linear_feature_id
AND ABS(x.downstream_route_measure - p.downstream_route_measure) < 15;

-- now that PSCIS data has been integrated, default everything else in the modelled crossings table to CBS
UPDATE bcfishpass.modelled_stream_crossings x
SET modelled_crossing_type = 'CBS'
WHERE modelled_crossing_type IS NULL;
