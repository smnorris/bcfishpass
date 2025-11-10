-- ensure duplicates are not added to this fix table on load

BEGIN;

  CREATE TEMPORARY TABLE user_modelled_crossing_fixes_unique AS
    SELECT * FROM (
      SELECT DISTINCT ON (modelled_crossing_id)
        modelled_crossing_id,
        structure,
        watershed_group_code,
        reviewer_name,
        review_date,
        source,
        notes
      FROM bcfishpass.user_modelled_crossing_fixes
      ORDER BY modelled_crossing_id, review_date
      ) as f
    ORDER BY review_date;

  TRUNCATE bcfishpass.user_modelled_crossing_fixes;

  ALTER TABLE bcfishpass.user_modelled_crossing_fixes
  ADD PRIMARY KEY (modelled_crossing_id);

  INSERT INTO bcfishpass.user_modelled_crossing_fixes (
    modelled_crossing_id,
    structure,
    watershed_group_code,
    reviewer_name,
    review_date,
    source,
    notes
  )
  SELECT
    modelled_crossing_id,
    structure,
    watershed_group_code,
    reviewer_name,
    review_date,
    source,
    notes
  FROM user_modelled_crossing_fixes_unique;

COMMIT;