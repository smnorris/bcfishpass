-- ensure duplicates are not added to this fix table on load

BEGIN;

  TRUNCATE bcfishpass.user_modelled_crossing_fixes;

  ALTER TABLE bcfishpass.user_modelled_crossing_fixes
  ADD PRIMARY KEY (modelled_crossing_id);

COMMIT;