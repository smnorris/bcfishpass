-- Create a table for holding all distinct PSCIS crossings
DROP VIEW IF EXISTS bcfishpass.pscis_not_matched_to_streams_vw;

DROP TABLE IF EXISTS bcfishpass.pscis_points_all;
CREATE TABLE bcfishpass.pscis_points_all
 (
     stream_crossing_id integer PRIMARY KEY,
     current_pscis_status text,
     current_barrier_result_code text,
     current_crossing_type_code text,
     current_crossing_subtype_code text,
     geom geometry(POINT, 3005)
 );

-- Insert in reverse order of status (remediation, design, conf, asssessment),
-- to ensure that the most current status of a given crossing is retained
INSERT INTO bcfishpass.pscis_points_all
SELECT
 d.stream_crossing_id::integer,
 d.current_pscis_status,
 d.current_barrier_result_code,
 d.current_crossing_type_code,
 d.current_crossing_subtype_code,
 d.geom
FROM whse_fish.pscis_remediation_svw d;

INSERT INTO bcfishpass.pscis_points_all
SELECT
 d.stream_crossing_id::integer,
 d.current_pscis_status,
 d.current_barrier_result_code,
 d.current_crossing_type_code,
 d.current_crossing_subtype_code,
 d.geom
FROM whse_fish.pscis_design_proposal_svw d
LEFT OUTER JOIN bcfishpass.pscis_points_all a
ON d.stream_crossing_id = a.stream_crossing_id
WHERE a.stream_crossing_id IS NULL;

INSERT INTO bcfishpass.pscis_points_all
SELECT
  d.stream_crossing_id::integer,
  'CONFIRMATION' AS current_pscis_status,
  d.current_barrier_result_code,
  d.current_crossing_type_code,
  d.current_crossing_subtype_code,
  d.geom
FROM whse_fish.pscis_habitat_confirmation_svw d
LEFT OUTER JOIN bcfishpass.pscis_points_all a
ON d.stream_crossing_id = a.stream_crossing_id
WHERE a.stream_crossing_id IS NULL;

INSERT INTO bcfishpass.pscis_points_all
SELECT
 d.stream_crossing_id::integer,
 d.current_pscis_status,
 d.current_barrier_result_code,
 d.current_crossing_type_code,
 d.current_crossing_subtype_code,
 d.geom
FROM whse_fish.pscis_assessment_svw d
LEFT OUTER JOIN bcfishpass.pscis_points_all a
ON d.stream_crossing_id = a.stream_crossing_id
WHERE a.stream_crossing_id IS NULL;

CREATE INDEX ON bcfishpass.pscis_points_all USING GIST (geom);

-- report on count of crossings
SELECT count(*)
FROM bcfishpass.pscis_points_all;

-- check the count on ENVPROD1
-- SELECT count(*) FROM pscis.pscis_stream_crossing_sp;

