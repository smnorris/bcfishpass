-- fix primary key in source table, it is not unique currently (as per catalogue metadata aug 2022)
-- create a copy rather than altering because qgis does not seem to pick up the change when accessing the 
-- table via fdw
--drop table if exists whse_forest_tenure.ften_range_poly_svw_tmp ;
--create table whse_forest_tenure.ften_range_poly_svw_tmp as 
  --select row_number() over() as id, *
  --from whse_forest_tenure.ften_range_poly_svw;
--create index on whse_forest_tenure.ften_range_poly_svw_tmp (id);
--create index on whse_forest_tenure.ften_range_poly_svw_tmp using gist (geom);
--
--drop table if exists whse_forest_tenure.ften_range_poly_svw cascade;
--alter table whse_forest_tenure.ften_range_poly_svw_tmp rename to ften_range_poly_svw;

-- create view
drop materialized view if exists whse_forest_tenure.ften_range_poly_carto_vw ;

create materialized view whse_forest_tenure.ften_range_poly_carto_vw as

-- dump poly rings and convert to lines
with rings as
(
  SELECT
    ST_Exteriorring((ST_DumpRings((st_dump(geom)).geom)).geom) AS geom
  FROM whse_forest_tenure.ften_range_poly_svw
),

-- node the lines with st_union and dump to singlepart lines
lines as
(
  SELECT
    (st_dump(st_union(geom, .1))).geom as geom
  FROM rings
),

-- polygonize the resulting noded lines
flattened AS
(
  SELECT
    (ST_Dump(ST_Polygonize(geom))).geom AS geom
  FROM lines
),

sorted AS
(
  SELECT
    d.objectid,
    d.forest_file_id,
    d.client_number,
    d.client_name,
    f.geom
  FROM flattened f
  LEFT OUTER JOIN whse_forest_tenure.ften_range_poly_svw d
  ON ST_Contains(d.geom, ST_PointOnSurface(f.geom))
  ORDER BY d.objectid
)

SELECT
  row_number() over() as id,
  array_agg(forest_file_id ORDER BY objectid) as forest_file_id,
  array_agg(client_number ORDER BY objectid) as client_number,
  array_agg(client_name ORDER BY objectid) as client_name,
  geom::geometry(polygon, 3005)
FROM sorted
GROUP BY geom;
