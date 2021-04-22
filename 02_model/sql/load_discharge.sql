-- add discharge column to streams table
ALTER TABLE bcfishpass.streams ADD COLUMN IF NOT EXISTS mad_m3s double precision;

UPDATE bcfishpass.streams s
SET
  mad_m3s = f.mad_m3s
FROM foundry.fwa_streams_mad f
WHERE s.linear_feature_id = f.linear_feature_id
AND s.watershed_group_code NOT IN ('BULK', 'HORS'); -- BULK and HORS are proprietary, do not incude in output streams table


