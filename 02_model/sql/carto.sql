-- small scale streams - aggregate over blueline, class, order > 1
DROP TABLE IF EXISTS bcfishpass.carto_streams_large;

CREATE TABLE bcfishpass.carto_streams_large
(
  carto_stream_large_id serial primary key,
  blue_line_key             integer                           ,
  gnis_name                 character varying(80)            ,
  stream_order              integer                           ,
  accessibility_model_salmon    text,
  accessibility_model_steelhead text,
  accessibility_model_wct       text,
  geom geometry(LineString,3005)
);

INSERT INTO bcfishpass.carto_streams_large
  (blue_line_key,
  gnis_name,
  stream_order,
  accessibility_model_salmon,
  accessibility_model_steelhead,
  accessibility_model_wct,
  geom)
SELECT
  blue_line_key,
  gnis_name,
  stream_order,
  accessibility_model_salmon,
  accessibility_model_steelhead,
  accessibility_model_wct,
  (ST_Dump(ST_UNION(ST_Force2D(geom)))).geom as geom
FROM bcfishpass.streams
WHERE stream_order > 2
GROUP BY blue_line_key,
  gnis_name,
  stream_order,
  accessibility_model_salmon,
  accessibility_model_steelhead,
  accessibility_model_wct;