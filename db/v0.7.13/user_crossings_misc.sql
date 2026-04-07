  -- rename user_barriers_anthropogenic to user_crossings_misc, 
  -- adding barrier_status and standard crossing crossing type/subtype codes
BEGIN;

  drop table bcfishpass.user_barriers_anthropogenic;

  create table bcfishpass.user_crossings_misc (
      user_crossing_misc_id        integer PRIMARY KEY, 
      blue_line_key                 integer NOT NULL,
      downstream_route_measure      double precision NOT NULL,
      crossing_type_code            text NOT NULL CHECK (crossing_type_code  IN ('CBS','OBS','OTHER')),
      crossing_subtype_code         text NOT NULL CHECK (crossing_subtype_code ~ '^[A-Z0-9_]+$' AND char_length(crossing_subtype_code) <= 20),
      barrier_status                text NOT NULL CHECK (barrier_status IN ('BARRIER','PASSABLE','POTENTIAL','UNKNOWN')),
      watershed_group_code          character varying(4) NOT NULL,
      reviewer_name                 text NOT NULL,
      review_date                   date NOT NULL,
      source                        text NOT NULL,
      notes                         text                
  );

  -- update fk in crossings table
  alter table bcfishpass.crossings rename column user_barrier_anthropogenic_id to user_crossing_misc_id;
  
  comment on column bcfishpass.user_crossings_misc.user_crossing_misc_id IS 'User defined primary key - ensure this is unique';
  comment on column bcfishpass.user_crossings_misc.blue_line_key IS 'See FWA documentation';
  comment on column bcfishpass.user_crossings_misc.downstream_route_measure IS 'See FWA documentation';
  comment on column bcfishpass.user_crossings_misc.crossing_type_code IS 'Defines the type of crossing present at the location of the stream crossing. One of: {OBS=Open Bottom Structure CBS=Closed Bottom Structure OTHER=Crossing structure does not fit into the above categories (ford/wier)}';
  comment on column bcfishpass.user_crossings_misc.crossing_subtype_code IS 'Further definition of the type of crossing. One of {BRIDGE; CRTBOX; DAM; FORD; OVAL; PIPEARCH; ROUND; WEIR; WOODBOX; NULL}';
  comment on column bcfishpass.user_crossings_misc.barrier_status IS 'The evaluation of the crossing as a barrier to the fish passage. From PSCIS, this is based on the FINAL SCORE value. For other data sources this varies. One of: {PASSABLE - Passable; POTENTIAL - Potential or partial barrier; BARRIER - Barrier; UNKNOWN - Other}';
  comment on column bcfishpass.user_crossings_misc.watershed_group_code IS 'See FWA documentation';
  comment on column bcfishpass.user_crossings_misc.reviewer_name IS 'Initials of user submitting the review, eg SN';
  comment on column bcfishpass.user_crossings_misc.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';
  comment on column bcfishpass.user_crossings_misc.source IS 'Description or link to the source(s) documenting the feature';
  comment on column bcfishpass.user_crossings_misc.notes IS 'Reviewer notes on rationale for addition of the feature and/or how the source were interpreted';

COMMIT;
