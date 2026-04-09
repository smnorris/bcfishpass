BEGIN;

  -- create temp user habitat classification for holding translated data
  DROP TABLE IF EXISTS bcfishpass.user_habitat_classification_temp;
  
  -- make ws code a unique index so it can be used as fk
  DROP index fwa_watershed_groups_watershed_group_code_idx;
  CREATE UNIQUE INDEX fwa_watershed_groups_watershed_group_code_idx on whse_basemapping.fwa_watershed_groups_poly (watershed_group_code);
  
  -- add a function checking measure validity (are the measures actually present on the stream)
  -- note that this only checks against min/max - transboundary stream measures are not validated
  CREATE OR REPLACE FUNCTION check_line_measures()
  RETURNS trigger AS $$
  DECLARE
    r record;
  BEGIN
    SELECT round(min(downstream_route_measure)) as downstream_route_measure, round(max(upstream_route_measure)) as upstream_route_measure INTO r
    FROM whse_basemapping.fwa_stream_networks_sp
    WHERE blue_line_key = NEW.blue_line_key;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'blue_line_key % does not exist', NEW.blue_line_key;
    END IF;

    IF NEW.downstream_route_measure < r.downstream_route_measure OR NEW.upstream_route_measure > r.upstream_route_measure THEN
      RAISE EXCEPTION
        'measures [%, %] are outside route % range [%, %]',
        NEW.downstream_route_measure, NEW.upstream_route_measure,
        NEW.blue_line_key,
        r.downstream_route_measure, r.upstream_route_measure;
    END IF;

    IF NEW.downstream_route_measure > NEW.upstream_route_measure THEN
      RAISE EXCEPTION 'downstream_route_measure % must be <= upstream_route_measure %',
        NEW.downstream_route_measure, NEW.upstream_route_measure;
    END IF;

    RETURN NEW;
  END;
  $$ LANGUAGE plpgsql;

  -- list valid habitat codes to be used in user_habitat_classification
  DROP TABLE IF EXISTS bcfishpass.user_habitat_codes;
  CREATE TABLE bcfishpass.user_habitat_codes (
    habitat_code int PRIMARY KEY,
    habitat_value text not null
  );
  INSERT INTO bcfishpass.user_habitat_codes VALUES (-1, 'KNOWN NON HABITAT'), (1, 'KNOWN HABITAT'), (-4, 'KNOWN NON HABITAT - MINING ALTERED STREAM');

  -- **
  -- data is loaded from csv, but we can define the transformation and find bad records here in the db.
  -- Note that some records are excluded (see WHERE below) as they do not meet the new constraints and require manual checking.
  -- These are temporarily archived to file outside of version control and will be loaded to csv when ready
  -- (most issues are in CHWK due to changes to FWA base)
  -- **
  CREATE TABLE bcfishpass.user_habitat_classification_temp
  (
    blue_line_key integer,
    downstream_route_measure double precision,
    upstream_route_measure double precision,
    watershed_group_code varchar(4) references whse_basemapping.fwa_watershed_groups_poly(watershed_group_code),
    species_code text references whse_fish.species_cd(code),
    spawning integer references bcfishpass.user_habitat_codes(habitat_code),
    rearing integer references bcfishpass.user_habitat_codes(habitat_code),
    reviewer_name text,
    review_date date,
    source text,
    notes text,
    PRIMARY KEY (blue_line_key, downstream_route_measure, upstream_route_measure, species_code)
  );

  CREATE TRIGGER trg_check_user_habitat_measures
  BEFORE INSERT OR UPDATE ON bcfishpass.user_habitat_classification_temp
  FOR EACH ROW EXECUTE FUNCTION check_line_measures();

  with hab1 as (
    select distinct
      blue_line_key,
      round(downstream_route_measure) as downstream_route_measure,
      round(upstream_route_measure) as upstream_route_measure,
      case 
        when watershed_group_code = 'KULM' then 'KLUM'  -- clean existing watershed code errors
        else watershed_group_code 
      end as watershed_group_code,
      species_code,
      case 
        when upper(habitat_type) = 'SPAWNING' AND habitat_ind is true then 1 
        when upper(habitat_type) = 'SPAWNING' AND habitat_ind is false then -1
      end as spawning,
      case 
        when upper(habitat_type) = 'REARING' AND habitat_ind is true then 1 
        when upper(habitat_type) = 'REARING' AND habitat_ind is false then -1
      end as rearing,
      reviewer_name,
      review_date,
      source,
      notes
    from bcfishpass.user_habitat_classification
    order by review_date, watershed_group_code, blue_line_key
  ),
  hab2 as (
    select 
      blue_line_key,
      downstream_route_measure,
      upstream_route_measure,
      watershed_group_code,
      species_code,
      max(spawning) as spawning,
      max(rearing) as rearing,
      reviewer_name,
      review_date,
      source,
      notes
    from hab1
    group by 
    blue_line_key,
      downstream_route_measure,
      upstream_route_measure,
      watershed_group_code,
      species_code,
      reviewer_name,
      review_date,
      source,
      notes
    order by review_date, watershed_group_code, blue_line_key, downstream_route_measure, upstream_route_measure
  ),

  hab3 as (
    select distinct on (blue_line_key, downstream_route_measure, upstream_route_measure, watershed_group_code, species_code)
      blue_line_key, downstream_route_measure, upstream_route_measure, watershed_group_code, species_code,
      spawning,
      rearing,
      reviewer_name,
      review_date,
      source,
      notes
    from hab2
    order by blue_line_key, downstream_route_measure, upstream_route_measure, watershed_group_code, species_code, review_date
  )  

  insert into bcfishpass.user_habitat_classification_temp (
    blue_line_key,
    downstream_route_measure,
    upstream_route_measure,
    watershed_group_code,
    species_code,
    spawning,
    rearing,
    reviewer_name,
    review_date,
    source,
    notes
  )

  -- exclude bad keys or measures, these need to be manually reviewed/edited and reloaded via the csv
  select * 
  from hab3 
  where blue_line_key not in (356235759, 356305867, 355995203, 380887781, 355995081) 
  and blue_line_key::text||','||downstream_route_measure::text||','||upstream_route_measure::text != '356310903,3482,5864'
  and blue_line_key::text||','||reviewer_name != '356363467,TMK'
  and blue_line_key::text||','||downstream_route_measure::text||','||upstream_route_measure::text != '356286496,3069,3169'
  and blue_line_key::text||','||downstream_route_measure::text||','||upstream_route_measure::text != '356570548,131846,131946'
  and blue_line_key::text||','||downstream_route_measure::text||','||upstream_route_measure::text != '360886273,25272,25372'
  and blue_line_key::text||','||downstream_route_measure::text||','||upstream_route_measure::text != '360886555,30794,30894'
  and blue_line_key::text||','||downstream_route_measure::text||','||upstream_route_measure::text != '360886901,85401,85501'
  and blue_line_key::text||','||downstream_route_measure::text||','||upstream_route_measure::text != '360887301,254434,254534'
  and blue_line_key::text||','||downstream_route_measure::text||','||upstream_route_measure::text != '360887377,36529,36629'
  order by review_date, watershed_group_code, blue_line_key, downstream_route_measure, species_code;


  -- swap out old data for new
  drop table bcfishpass.user_habitat_classification;
  alter table bcfishpass.user_habitat_classification_temp rename to user_habitat_classification;
  
  comment on column bcfishpass.user_habitat_classification.blue_line_key IS 'See FWA documentation';
  comment on column bcfishpass.user_habitat_classification.downstream_route_measure IS 'Measure of stream at point where user habitat classification begins';
  comment on column bcfishpass.user_habitat_classification.upstream_route_measure IS 'Measure of stream at point where user habitat classification ends';
  comment on column bcfishpass.user_habitat_classification.watershed_group_code IS 'See FWA documentation';
  comment on column bcfishpass.user_habitat_classification.species_code IS 'Habitat classification applies to this species - see whse_fish.species_cd for values';
  comment on column bcfishpass.user_habitat_classification.spawning IS 'Spawning classification (-1: known non-spawning; 1: known spawning, -4: mining altered stream)';
  comment on column bcfishpass.user_habitat_classification.rearing IS 'Rearing classification (-1: known non-rearing; 1: known rearing, -4: mining altered stream)';
  comment on column bcfishpass.user_habitat_classification.reviewer_name IS 'Initials of user submitting the review, eg SN';
  comment on column bcfishpass.user_habitat_classification.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';
  comment on column bcfishpass.user_habitat_classification.source IS 'Description or link to the source(s) documenting the feature';
  comment on column bcfishpass.user_habitat_classification.notes IS 'Reviewer notes on rationale for addition of the feature and/or how the source were interpreted';


COMMIT;

