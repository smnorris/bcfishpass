BEGIN;
	CREATE TABLE IF NOT EXISTS whse_fish.species_cd (
	  species_id     integer primary key,
	  code            text UNIQUE,
	  name            text,
	  cdcgr_code      text,
	  cdclr_code      text,
	  scientific_name text,
	  spctype_code    text,
	  spcgrp_code     text
	);

	create table bcfishobs.observations (
	 observation_key           text  primary key        ,
	 fish_observation_point_id numeric,
	 wbody_id                  numeric                  ,
	 species_code              character varying(6)     ,
	 agency_id                 numeric                  ,
	 point_type_code           character varying(20)    ,
	 observation_date          date                     ,
	 agency_name               character varying(60)    ,
	 source                    character varying(1000)  ,
	 source_ref                character varying(4000)  ,
	 utm_zone                  integer                  ,
	 utm_easting               integer                  ,
	 utm_northing              integer                  ,
	 activity_code             character varying(100)   ,
	 activity                  character varying(300)   ,
	 life_stage_code           character varying(100)   ,
	 life_stage                character varying(300)   ,
	 species_name              character varying(60)    ,
	 waterbody_identifier      character varying(9)     ,
	 waterbody_type            character varying(20)    ,
	 gazetted_name             character varying(30)    ,
	 new_watershed_code        character varying(56)    ,
	 trimmed_watershed_code    character varying(56)    ,
	 acat_report_url           character varying(254)   ,
	 feature_code              character varying(10)    ,
	 linear_feature_id         bigint,
	 wscode                    ltree,
	 localcode                 ltree,
	 blue_line_key             integer,
	 watershed_group_code      character varying(4),
	 downstream_route_measure  double precision,
	 match_type                text,
	 distance_to_stream        double precision,
	 geom                      geometry(PointZ,3005)
	);
	create index on bcfishobs.observations (linear_feature_id);
	create index on bcfishobs.observations (blue_line_key);
	create index on bcfishobs.observations (blue_line_key, downstream_route_measure);
	create index on bcfishobs.observations (wscode);
	create index on bcfishobs.observations (localcode);
	create index on bcfishobs.observations using gist (wscode);
	create index on bcfishobs.observations using gist (localcode);
	create index on bcfishobs.observations using gist (geom);


	comment on table bcfishobs.observations IS 'BC Fish Observations snapped to FWA streams';
	comment on column bcfishobs.observations.observation_key IS 'Stable unique id, a hash of columns [source, species_code, observation_date, utm_zone, utm_easting, utm_northing, life_stage_code, activity_code]';
	comment on column bcfishobs.observations.fish_observation_point_id IS 'Source observation primary key (unstable)';
	comment on column bcfishobs.observations.wbody_id IS 'WBODY ID is a foreign key to WDIC_WATERBODIES.';
	comment on column bcfishobs.observations.species_code IS 'BC fish species code, see https://raw.githubusercontent.com/smnorris/fishbc/master/data-raw/whse_fish_species_cd/whse_fish_species_cd.csv';
	comment on column bcfishobs.observations.agency_id IS 'AGENCY ID is a foreign key to AGENCIES.';
	comment on column bcfishobs.observations.point_type_code IS 'POINT TYPE CODE indicates if the row represents a direct Observation or a Summary of direct observations.';
	comment on column bcfishobs.observations.observation_date IS 'The date on which the observation occurred.';
	comment on column bcfishobs.observations.agency_name IS 'The name of the agency that made the observation.';
	comment on column bcfishobs.observations.source IS 'The abbreviation, and if appropriate, the primary key, of the dataset(s) from which the data was obtained. For example: FDIS Database: fshclctn_id 66589';
	comment on column bcfishobs.observations.source_ref IS 'The concatenation of all biographical references for the source data.  This may include citations to reports that published the observations, or the name of a project under which the observations were made. Some example values for SOURCE REF are: A RECONNAISSANCE SURVEY OF CULTUS LAKE, and Bonaparte Watershed Fish and Fish Habitat Inventory - 2000';
	comment on column bcfishobs.observations.utm_zone IS 'UTM ZONE is the 2 digit numeric code identifying the UTM Zone in which the UTM EASTING and UTM NORTHING lie.';
	comment on column bcfishobs.observations.utm_easting IS 'UTM EASTING is the UTM Easting value within the specified UTM ZONE for this observation point.';
	comment on column bcfishobs.observations.utm_northing IS 'UTM NORTHING is the UTM Northing value within the specified UTM ZONE for this observation point.';
	comment on column bcfishobs.observations.activity_code IS 'ACTIVITY CODE contains the fish activity code from the source dataset, such as I for Incubating, or SPE for Spawning In Estuary.';
	comment on column bcfishobs.observations.activity IS 'ACTIVITY is a full textual description of the activity the fish was engaged in when it was observed, such as SPAWNING.';
	comment on column bcfishobs.observations.life_stage_code IS 'LIFE STAGE CODE is a short character code identiying the life stage of the fish species for this oberservation.  Each source dataset of observations uses its own set of LIFE STAGE CODES.  For example, in the FDIS dataset, U means Undetermined, NS means Not Specified, M means Mature, IM means Immature, and MT means Maturing.  Descriptions for each LIFE STAGE CODE are given in the LIFE STAGE attribute.';
	comment on column bcfishobs.observations.life_stage IS 'LIFE STAGE is the full textual description corresponding to the LIFE STAGE CODE';
	comment on column bcfishobs.observations.species_name IS 'SPECIES NAME is the common name of the fish SPECIES that was observed.';
	comment on column bcfishobs.observations.waterbody_identifier IS 'WATERBODY IDENTIFIER is a unique code identifying the waterbody in which the observation was made. It is a 5-digit seqnce number followed by a 4-character watershed group code.';
	comment on column bcfishobs.observations.waterbody_type IS 'WATERBODY TYPE is a the type of waterbody in which the observation was made. For example, Stream or Lake.';
	comment on column bcfishobs.observations.gazetted_name IS 'GAZETTED NAME is the gazetted name of the waterbody in which the observation was made.';
	comment on column bcfishobs.observations.new_watershed_code IS 'NEW WATERSHED CODE is a watershed code, formatted with dashes, as assigned in the Watershed Atlas. For example: 900-569800-08600-00000-0000-0000-000-000-000-000-000-000.';
	comment on column bcfishobs.observations.trimmed_watershed_code IS 'TRIMMED WATERSHED CODE is the NEW WATERSHED CODE, but with trailing zeros removed. For example, if the NEW WATERSHED CODE is 100-005200-43400-50000-0000-0000-000-000-000-000-000-000, then the TRIMMED WATERSHED CODE will be 100-005200-43400-50000.';
	comment on column bcfishobs.observations.acat_report_url IS 'ACAT REPORT URL is a URL to the ACAT REPORT which provides additional information about the FISS FISH OBSRVTN PNT SP.';
	comment on column bcfishobs.observations.feature_code is 'FEATURE CODE contains a value based on the Canadian Council of Surveys and Mappings (CCSM) system for classification of geographic features.';
	comment on column bcfishobs.observations.linear_feature_id is 'See FWA documentation';
	comment on column bcfishobs.observations.wscode is 'Truncated FWA fwa_watershed_code';
	comment on column bcfishobs.observations.localcode is 'Truncated FWA local_watershed_code';
	comment on column bcfishobs.observations.blue_line_key is 'See FWA documentation';
	comment on column bcfishobs.observations.watershed_group_code is 'See FWA documentation';
	comment on column bcfishobs.observations.downstream_route_measure is 'See FWA documentation';
	comment on column bcfishobs.observations.match_type IS 'Description of how the observation was matched to the stream';
	comment on column bcfishobs.observations.distance_to_stream IS 'Distance (m) from source observation to output point';
	comment on column bcfishobs.observations.geom IS 'Geometry of observation as snapped to the FWA stream network';

COMMIT;