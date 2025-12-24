-- rename/clean up cabd fix tables and permit additions/exlusions/barrier status updates
BEGIN;

  -- EXCLUSIONS
  CREATE TABLE bcfishpass.cabd_exclusions (
    cabd_id       text ,
    feature_type  text CHECK (feature_type IN ('dams', 'waterfalls')) ,
    reviewer_name text ,
    review_date   date ,
    source        text ,
    notes         text ,
    primary key (cabd_id)         
  );


  -- ADDITIONS  
  CREATE TABLE bcfishpass.cabd_additions (
  	feature_type  text CHECK (feature_type IN ('dams', 'waterfalls')) ,
    name                     text     ,
    height                   numeric  ,
    barrier_ind              boolean  ,
    blue_line_key            integer  ,
    downstream_route_measure integer  ,
    reviewer_name            text     ,
    review_date              date     ,
    source                   text     ,
    notes                    text     ,
    primary key (blue_line_key, downstream_route_measure)
  );


  -- ALLOW CABD BARRIER STATUS UPDATES/CUSTOMIZATIONS
  CREATE TABLE bcfishpass.cabd_passability_status_updates (
    cabd_id       text ,
    passability_status_code integer CHECK (passability_status_code > 0 AND passability_status_code < 7),
    reviewer_name text ,
    review_date   date ,
    source        text ,
    notes         text ,
    primary key (cabd_id)         
  );

  -- RENAME TABLE MATCHING CABD FEATURES TO FWA STREAMS
  ALTER TABLE bcfishpass.user_cabd_blkey_xref RENAME TO cabd_blkey_xref;

  -- DROP FORMER ADDITIONS/EXCLUSIONS TABLES (data is loaded from csv on every model re-run)
  DROP TABLE bcfishpass.user_cabd_dams_exclusions; 
  DROP TABLE bcfishpass.user_falls;

COMMIT;