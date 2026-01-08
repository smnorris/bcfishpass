BEGIN;

  comment on table bcfishpass.cabd_exclusions IS 'Exclude CABD records (waterfalls and dams) from bcfishpass usage';
  comment on column bcfishpass.cabd_exclusions.cabd_id IS 'CABD unique identifier';
  comment on column bcfishpass.cabd_exclusions.feature_type IS 'Feature type, either waterfalls or dams';
  comment on column bcfishpass.cabd_exclusions.reviewer_name IS 'Initials of user submitting the review, eg SN';
  comment on column bcfishpass.cabd_exclusions.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';
  comment on column bcfishpass.cabd_exclusions.source IS 'Description or link to the source(s) indicating why the feature should be excluded';
  comment on column bcfishpass.cabd_exclusions.notes IS 'Reviewer notes on rationale for exclusion and/or how the source were interpreted';
  
  comment on table bcfishpass.cabd_additions IS 'Insert falls or dams required for bcfishpass but not present in CABD. Includes placeholders for dams outside of BC';
  comment on column bcfishpass.cabd_additions.feature_type IS 'Feature type, either waterfalls or dams';
  comment on column bcfishpass.cabd_additions.name IS 'Name of waterfalls or dam';
  comment on column bcfishpass.cabd_additions.height IS 'Height (m) of waterfalls or dam';
  comment on column bcfishpass.cabd_additions.barrier_ind IS 'Barrier status of waterfalls or dam (true/false)';
  comment on column bcfishpass.cabd_additions.blue_line_key IS 'FWA blue_line_key (flow line) on which the feature lies';
  comment on column bcfishpass.cabd_additions.downstream_route_measure IS 'The distance, in meters, along the blue_line_key from the mouth of the stream/blue_line_key to the feature.';
  comment on column bcfishpass.cabd_additions.reviewer_name IS 'Initials of user submitting the review, eg SN';
  comment on column bcfishpass.cabd_additions.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';
  comment on column bcfishpass.cabd_additions.source IS 'Description or link to the source(s) documenting the feature';
  comment on column bcfishpass.cabd_additions.notes IS 'Reviewer notes on rationale for addition of the feature and/or how the source were interpreted';
      
  comment on table bcfishpass.cabd_passability_status_updates IS 'Update the passability_status_code (within bcfishpass) of existing CABD features (dams or waterfalls)';
  comment on column bcfishpass.cabd_passability_status_updates.cabd_id IS 'CABD unique identifier';
  comment on column bcfishpass.cabd_passability_status_updates.passability_status_code IS 'Code referencing the degree to which the feature acts as a barrier to fish in the upstream direction. (1=Barrier, 2=Partial barrier, 3=Passable, 4=Unknown, 5=NA-No Structure, 6=NA-Decommissioned/Removed)';
  comment on column bcfishpass.cabd_passability_status_updates.reviewer_name IS 'Initials of user submitting the review, eg SN';
  comment on column bcfishpass.cabd_passability_status_updates.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';
  comment on column bcfishpass.cabd_passability_status_updates.source IS 'Description or link to the source(s) documenting the passability status of the feature';
  comment on column bcfishpass.cabd_passability_status_updates.notes IS 'Reviewer notes on rationale for fix and/or how the source(s) were interpreted';
    
  comment on table bcfishpass.cabd_blkey_xref IS 'Cross reference CABD features to FWA flow lines (blue_line_key), used when CABD feature location is closest to an inapproprate flow line';
  comment on column bcfishpass.cabd_blkey_xref.cabd_id IS 'CABD unique identifier';
  comment on column bcfishpass.cabd_blkey_xref.blue_line_key IS 'FWA blue_line_key (flow line) to which the CABD feature should be linked';
  comment on column bcfishpass.cabd_blkey_xref.reviewer_name IS 'Initials of user submitting the review, eg SN';
  comment on column bcfishpass.cabd_blkey_xref.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';
  comment on column bcfishpass.cabd_blkey_xref.notes IS 'Reviewer notes on rationale for fix and/or how the source(s) were interpreted';

  comment on table bcfishpass.observation_exclusions IS 'Flag FISS observation points for exclusion (temporary/one time releases or data errors) or as ongoing releases (ongoing release programs create valid habitat, but are inapproprate for natural barrier QA).';
  comment on column bcfishpass.observation_exclusions.observation_key IS 'bcfishobs created stable unique id, a hash of columns [source, species_code, observation_date, utm_zone, utm_easting, utm_northing, life_stage_code, activity_code]';
  comment on column bcfishpass.observation_exclusions.exclude IS 'Set as true to exclude the observation from bcfishpass - either the observation is a data error or related to a limited/one time release/stocking event.';
  comment on column bcfishpass.observation_exclusions.release IS 'Set as true to flag the observation as part of an ongoing release program (for general info and to exclude from QA of natural barriers)';
  comment on column bcfishpass.observation_exclusions.reviewer_name IS 'Initials of user submitting the review, eg SN';
  comment on column bcfishpass.observation_exclusions.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';
  comment on column bcfishpass.observation_exclusions.source_1 IS 'Description or link to the primary source(s) documenting the observation or related information';
  comment on column bcfishpass.observation_exclusions.source_2 IS 'Description or link to the secondary source(s) documenting the observation or related information';
  comment on column bcfishpass.observation_exclusions.notes IS 'Reviewer notes on rationale for fix and/or how the source(s) were interpreted';

COMMIT;