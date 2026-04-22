-- all parks in single object
drop materialized view if exists bcdata.parks;

create materialized view bcdata.parks as
select row_number() over() as id, *
from (
select
  'whse_admin_boundaries.clab_national_parks' as source,
  'NATIONAL PARK' as designation,
  english_name as name,
  st_multi(st_union(geom))::geometry(Multipolygon, 3005) as geom
from whse_admin_boundaries.clab_national_parks
group by
  english_name
union all
select
  'whse_tantalis.ta_park_ecores_pa_svw' as source,
  protected_lands_designation as designation,
  protected_lands_name as name,
  st_multi(geom)::geometry(Multipolygon, 3005) as geom
from whse_tantalis.ta_park_ecores_pa_svw
union all
select
  'whse_tantalis.ta_conservancy_areas_svw' as source,
  'CONSERVANCY' as designation,
  conservancy_area_name as name,
  st_multi(geom)::geometry(Multipolygon, 3005) as geom
from whse_tantalis.ta_conservancy_areas_svw
union all
select
  'whse_basemapping.gba_local_reg_greenspaces_sp' as source,
  upper(park_type) || ' ' || upper(park_primary_use) as designation,
  park_name as name,
  st_multi(geom)::geometry(Multipolygon, 3005) as geom
from whse_basemapping.gba_local_reg_greenspaces_sp
) as p;

create index on bcdata.parks using gist (geom);
