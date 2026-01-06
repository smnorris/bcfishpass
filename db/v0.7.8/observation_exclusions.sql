-- ADD FISH OBSERVATION EXCLUSIONS
BEGIN;

  CREATE TABLE bcfishpass.observation_exclusions (
    observation_key       text ,
    exclude               boolean,
    release               boolean,
    reviewer_name         text,
    review_date           date,
    source_1              text,
    source_2              text,
    notes                 text,
    primary key (observation_key)         
  );

COMMIT;