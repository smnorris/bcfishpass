-- point in poly queries with BEC/Ecosections are too slow.
-- Subdivide the geoms to improve performance

-- alter source so it shows up in qgis
ALTER TABLE whse_terrestrial_ecology.erc_ecosections_sp ALTER COLUMN geom SET DATA TYPE geometry(MultiPolygon, 3005);

-- create subdivided table
DROP TABLE IF EXISTS whse_terrestrial_ecology.erc_ecosections_subdivided;
CREATE TABLE whse_terrestrial_ecology.erc_ecosections_subdivided (LIKE whse_terrestrial_ecology.erc_ecosections_sp INCLUDING ALL);
ALTER TABLE whse_terrestrial_ecology.erc_ecosections_subdivided DROP COLUMN ogc_fid;

INSERT INTO whse_terrestrial_ecology.erc_ecosections_subdivided
SELECT
  id,
  ecosection_code,
  feature_code,
  ecosection_name,
  parent_ecoregion_code,
  effective_date,
  expiry_date,
  objectid,
  se_anno_cad_data,
  feature_area_sqm,
  feature_length_m,
  st_multi(ST_Subdivide(ST_Force2D(geom))) as geom
FROM whse_terrestrial_ecology.erc_ecosections_sp;

CREATE INDEX ON whse_terrestrial_ecology.erc_ecosections_subdivided USING gist (geom);
ANALYZE whse_terrestrial_ecology.erc_ecosections_subdivided;

-- alter source so it shows up in qgis
ALTER TABLE whse_forest_vegetation.bec_biogeoclimatic_poly ALTER COLUMN geom SET DATA TYPE geometry(MultiPolygon, 3005);

-- create subdivided table
DROP TABLE IF EXISTS whse_forest_vegetation.bec_biogeoclimatic_poly_subdivided;
CREATE TABLE whse_forest_vegetation.bec_biogeoclimatic_poly_subdivided (LIKE whse_forest_vegetation.bec_biogeoclimatic_poly INCLUDING ALL);
ALTER TABLE whse_forest_vegetation.bec_biogeoclimatic_poly_subdivided DROP COLUMN ogc_fid;

INSERT INTO whse_forest_vegetation.bec_biogeoclimatic_poly_subdivided
SELECT
 id,
 feature_class_skey,
 zone,
 subzone,
 variant,
 phase,
 natural_disturbance,
 map_label,
 bgc_label,
 zone_name,
 subzone_name,
 variant_name,
 phase_name,
 natural_disturbance_name,
 feature_area_sqm,
 feature_length_m,
 feature_area,
 feature_length,
 objectid,
 se_anno_cad_data,
 st_multi(ST_Subdivide(ST_Force2D(geom))) as geom
FROM whse_forest_vegetation.bec_biogeoclimatic_poly;

CREATE INDEX ON whse_forest_vegetation.bec_biogeoclimatic_poly_subdivided USING gist (geom);
ANALYZE whse_forest_vegetation.bec_biogeoclimatic_poly_subdivided;