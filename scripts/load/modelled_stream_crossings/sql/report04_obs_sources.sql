-- Count of bridges/OBS per bridge/OBS data source
SELECT
  array_to_string(modelled_crossing_type_source, '; ') as modelled_crossing_type_sources,
  count(*) as n
FROM bcfishpass.modelled_stream_crossings
where modelled_crossing_type = 'OBS'
GROUP BY modelled_crossing_type_source