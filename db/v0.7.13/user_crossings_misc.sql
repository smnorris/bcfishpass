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

COMMIT;