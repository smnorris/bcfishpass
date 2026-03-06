-- ADD FISH OBSERVATION EXCLUSIONS
BEGIN;

  DROP TABLE IF EXISTS bcfishpass.observation_exclusions;
  CREATE TABLE bcfishpass.observation_exclusions (
    observation_key       text ,
    data_error            boolean,
    release_exclude       boolean,
    release_include       boolean,
    reviewer_name         text,
    review_date           date,
    source_1              text,
    source_2              text,
    notes                 text,
    primary key (observation_key)         
  );

  ALTER TABLE bcfishpass.observations add column release boolean;
  
COMMIT;
