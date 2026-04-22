

ALTER TABLE bcfishpass.db_version ALTER COLUMN tag SET NOT NULL;
ALTER TABLE bcfishpass.db_version ADD COLUMN applied_at timestamp;
UPDATE bcfishpass.db_version SET applied_at = '2026-04-16';
ALTER TABLE bcfishpass.db_version ALTER COLUMN applied_at SET NOT NULL;