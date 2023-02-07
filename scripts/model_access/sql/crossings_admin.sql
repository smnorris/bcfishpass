-- this takes a while to run, only do it when cutting a release


ALTER TABLE bcfishpass.crossings ADD COLUMN abms_regional_district text;
ALTER TABLE bcfishpass.crossings ADD COLUMN abms_municipality text;
ALTER TABLE bcfishpass.crossings ADD COLUMN clab_indian_reserve_name text;
ALTER TABLE bcfishpass.crossings ADD COLUMN clab_indian_reserve_band_name text;
ALTER TABLE bcfishpass.crossings ADD COLUMN clab_national_park text;
ALTER TABLE bcfishpass.crossings ADD COLUMN tantalis_park_ecores_pa text;
ALTER TABLE bcfishpass.crossings ADD COLUMN pmbc_private text;
ALTER TABLE bcfishpass.crossings ADD COLUMN adm_nr_region text;
ALTER TABLE bcfishpass.crossings ADD COLUMN adm_nr_district text;

WITH overlay AS
(SELECT DISTINCT ON (c.aggregated_crossings_id) -- some of the admin areas are not clean/distinct, make sure to select just one
  c.aggregated_crossings_id,
  rd.admin_area_abbreviation as abms_regional_district,
  muni.admin_area_abbreviation as abms_municipality,
  ir.english_name as clab_indian_reserve_name,
  ir.band_name as clab_indian_reserve_band_name,
  np.english_name as clab_national_park_name,
  pp.protected_lands_name as bc_protected_lands_name,
  pmbc.owner_type as pmbc_owner_type,
  nr.region_org_unit_name as adm_nr_region,
  nr.district_name as adm_nr_district
FROM bcfishpass.crossings c
LEFT OUTER JOIN whse_legal_admin_boundaries.abms_regional_districts_sp rd
ON ST_Intersects(c.geom, rd.geom)
LEFT OUTER JOIN whse_legal_admin_boundaries.abms_municipalities_sp muni
ON ST_Intersects(c.geom, muni.geom)
LEFT OUTER JOIN whse_admin_boundaries.adm_indian_reserves_bands_sp ir
ON ST_Intersects(c.geom, ir.geom)
LEFT OUTER JOIN whse_admin_boundaries.clab_national_parks np
ON ST_Intersects(c.geom, np.geom)
LEFT OUTER JOIN whse_tantalis.ta_park_ecores_pa_svw pp
ON ST_Intersects(c.geom, pp.geom)
LEFT OUTER JOIN whse_cadastre.pmbc_parcel_fabric_poly_svw pmbc
ON ST_Intersects(c.geom, pmbc.geom)
LEFT OUTER JOIN whse_admin_boundaries.adm_nr_districts_sp nr
ON ST_Intersects(c.geom, pmbc.geom)
ORDER BY c.aggregated_crossings_id, rd.admin_area_abbreviation, muni.admin_area_abbreviation, ir.english_name, pp.protected_lands_name, pmbc.owner_type, nr.district_name)

UPDATE bcfishpass.crossings c
SET
  abms_regional_district = o.abms_regional_district,
  abms_municipality = o.abms_municipality,
  clab_indian_reserve_name = o.clab_indian_reserve_name,
  clab_indian_reserve_band_name = o.clab_indian_reserve_band_name,
  clab_national_park_name = o.clab_national_park_name,
  bc_protected_lands_name = o.bc_protected_lands_name,
  pmbc_owner_type = o.pmbc_owner_type,
  adm_nr_region = o.adm_nr_region,
  adm_nr_distric = o.adm_nr_district
FROM overlay o
WHERE c.aggregated_crossings_id = o.aggregated_crossings_id;