-- add discharge column to streams table
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS mad_m3s double precision;

UPDATE bcfishpass.streams s
SET
  mad_m3s = f.mad_m3s
FROM bcfishpass.discharge f
WHERE s.linear_feature_id = f.linear_feature_id;


