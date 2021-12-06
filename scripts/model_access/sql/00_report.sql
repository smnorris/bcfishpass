# upstr_observedspp may already exist. if so, drop it
ALTER TABLE {point_schema}.{point_table} DROP COLUMN IF EXISTS upstr_observedspp;

-- add the reporting columns
-- stream characteristics, accessibility model status
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS stream_order integer;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS stream_magnitude integer;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS gradient double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS accessibility_model_salmon    text;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS accessibility_model_steelhead text;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS accessibility_model_wct       text;

-- upstream/downstream reporting
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS dnstr_observedspp text[];
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS upstr_observedspp text[];
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS watershed_upstr_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_network_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_stream_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_lakereservoir_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_wetland_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_slopeclass03_waterbodies_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_slopeclass03_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_slopeclass05_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_slopeclass08_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_slopeclass15_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_slopeclass22_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_slopeclass30_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_network_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_stream_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_lakereservoir_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_wetland_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_slopeclass03_waterbodies_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_slopeclass03_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_slopeclass05_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_slopeclass08_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_slopeclass15_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_slopeclass22_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_slopeclass30_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_network_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_stream_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_lakereservoir_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_wetland_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_slopeclass03_waterbodies_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_slopeclass03_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_slopeclass05_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_slopeclass08_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_slopeclass15_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_slopeclass22_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_slopeclass30_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_network_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_stream_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_lakereservoir_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_wetland_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_slopeclass03_waterbodies_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_slopeclass03_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_slopeclass05_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_slopeclass08_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_slopeclass15_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_slopeclass22_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS salmon_belowupstrbarriers_slopeclass30_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_network_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_stream_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_lakereservoir_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_wetland_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_slopeclass03_waterbodies_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_slopeclass03_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_slopeclass05_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_slopeclass08_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_slopeclass15_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_slopeclass22_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_slopeclass30_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_network_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_stream_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_lakereservoir_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_wetland_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_slopeclass03_waterbodies_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_slopeclass03_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_slopeclass05_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_slopeclass08_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_slopeclass15_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_slopeclass22_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS steelhead_belowupstrbarriers_slopeclass30_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_network_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_stream_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_lakereservoir_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_wetland_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_slopeclass03_waterbodies_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_slopeclass03_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_slopeclass05_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_slopeclass08_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_slopeclass15_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_slopeclass22_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_slopeclass30_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_network_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_stream_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_lakereservoir_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_wetland_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass03_waterbodies_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass03_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass05_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass08_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass15_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass22_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass30_km double precision;
-- modelled spawn/rear summaries, including wetland/lake areas for co/sk
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS ch_spawning_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS ch_rearing_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS ch_spawning_belowupstrbarriers_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS ch_rearing_belowupstrbarriers_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS co_spawning_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS co_rearing_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS co_rearing_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS co_spawning_belowupstrbarriers_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS co_rearing_belowupstrbarriers_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS co_rearing_belowupstrbarriers_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS sk_spawning_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS sk_rearing_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS sk_rearing_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS sk_spawning_belowupstrbarriers_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS sk_rearing_belowupstrbarriers_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS sk_rearing_belowupstrbarriers_ha double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS st_spawning_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS st_rearing_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS st_spawning_belowupstrbarriers_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS st_rearing_belowupstrbarriers_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_spawning_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_rearing_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_spawning_belowupstrbarriers_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_rearing_belowupstrbarriers_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS all_spawning_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS all_spawning_belowupstrbarriers_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS all_rearing_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS all_rearing_belowupstrbarriers_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS all_spawningrearing_km double precision;
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS all_spawningrearing_belowupstrbarriers_km double precision;

-- map tile used for generating pdf planning maps
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS dbm_mof_50k_grid text;

COMMENT ON COLUMN {point_schema}.{point_table}.stream_order IS 'Order of FWA stream at point';
COMMENT ON COLUMN {point_schema}.{point_table}.stream_magnitude IS 'Magnitude of FWA stream at point';
COMMENT ON COLUMN {point_schema}.{point_table}.gradient IS 'Stream slope at point';
COMMENT ON COLUMN {point_schema}.{point_table}.accessibility_model_salmon IS 'Modelled accessibility to Salmon (15% max)';
COMMENT ON COLUMN {point_schema}.{point_table}.accessibility_model_steelhead IS 'Modelled accessibility to Steelhead (20% max)';
COMMENT ON COLUMN {point_schema}.{point_table}.accessibility_model_wct IS 'Modelled accessibility to West Slope Cutthroat Trout (20% max or downstream of known WCT observation)';     ;
COMMENT ON COLUMN {point_schema}.{point_table}.watershed_upstr_ha IS 'Total watershed area upstream of point (approximate, does not include area of the fundamental watershed in which the point lies)';
COMMENT ON COLUMN {point_schema}.{point_table}.dnstr_observedspp IS 'Fish species observed downstream of point (on the same stream/blue_line_key)';
COMMENT ON COLUMN {point_schema}.{point_table}.upstr_observedspp IS 'Fish species observed anywhere upstream of point';
COMMENT ON COLUMN {point_schema}.{point_table}.total_network_km IS 'Total length of stream network upstream of point';
COMMENT ON COLUMN {point_schema}.{point_table}.total_stream_km IS 'Total length of streams and rivers upstream of point (does not include network connectors in lakes etc)';
COMMENT ON COLUMN {point_schema}.{point_table}.total_lakereservoir_ha IS 'Total area lakes and reservoirs upstream of point ';
COMMENT ON COLUMN {point_schema}.{point_table}.total_wetland_ha IS 'Total area wetlands upstream of point ';
COMMENT ON COLUMN {point_schema}.{point_table}.total_slopeclass03_waterbodies_km IS 'Total length of stream connectors (in waterbodies) potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.total_slopeclass03_km IS 'Total length of stream potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.total_slopeclass05_km IS 'Total length of stream potentially accessible upstream of point with slope 3-5%';
COMMENT ON COLUMN {point_schema}.{point_table}.total_slopeclass08_km IS 'Total length of stream potentially accessible upstream of point with slope 5-8%';
COMMENT ON COLUMN {point_schema}.{point_table}.total_slopeclass15_km IS 'Total length of stream potentially accessible upstream of point with slope 8-15%';
COMMENT ON COLUMN {point_schema}.{point_table}.total_slopeclass22_km IS 'Total length of stream potentially accessible upstream of point with slope 15-22%';
COMMENT ON COLUMN {point_schema}.{point_table}.total_slopeclass30_km IS 'Total length of stream potentially accessible upstream of point with slope 22-30%';
COMMENT ON COLUMN {point_schema}.{point_table}.total_belowupstrbarriers_network_km IS 'Total length of stream network potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.total_belowupstrbarriers_stream_km IS 'Total length of streams and rivers potentially accessible upstream of point and below any additional upstream barriers (does not include network connectors in lakes etc)';
COMMENT ON COLUMN {point_schema}.{point_table}.total_belowupstrbarriers_lakereservoir_ha IS 'Total area lakes and reservoirs potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.total_belowupstrbarriers_wetland_ha IS 'Total area wetlands potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.total_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total length of stream connectors (in waterbodies) potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.total_belowupstrbarriers_slopeclass03_km IS 'Total length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.total_belowupstrbarriers_slopeclass05_km IS 'Total length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 3-5%';
COMMENT ON COLUMN {point_schema}.{point_table}.total_belowupstrbarriers_slopeclass08_km IS 'Total length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 5-8%';
COMMENT ON COLUMN {point_schema}.{point_table}.total_belowupstrbarriers_slopeclass15_km IS 'Total length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 8-15%';
COMMENT ON COLUMN {point_schema}.{point_table}.total_belowupstrbarriers_slopeclass22_km IS 'Total length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 15-22%';
COMMENT ON COLUMN {point_schema}.{point_table}.total_belowupstrbarriers_slopeclass30_km IS 'Total length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 22-30%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_network_km IS 'Salmon model, total length of stream network potentially accessible upstream of point';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_stream_km IS 'Salmon model, total length of streams and rivers potentially accessible upstream of point  (does not include network connectors in lakes etc)';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_lakereservoir_ha IS 'Salmon model, total area lakes and reservoirs potentially accessible upstream of point ';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_wetland_ha IS 'Salmon model, total area wetlands potentially accessible upstream of point ';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_slopeclass03_waterbodies_km IS 'Salmon model, length of stream connectors (in waterbodies) potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_slopeclass03_km IS 'Salmon model, length of stream potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_slopeclass05_km IS 'Salmon model, length of stream potentially accessible upstream of point with slope 3-5%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_slopeclass08_km IS 'Salmon model, length of stream potentially accessible upstream of point with slope 5-8%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_slopeclass15_km IS 'Salmon model, length of stream potentially accessible upstream of point with slope 8-15%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_slopeclass22_km IS 'Salmon model, length of stream potentially accessible upstream of point with slope 15-22%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_slopeclass30_km IS 'Salmon model, length of stream potentially accessible upstream of point with slope 22-30%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_network_km IS 'Salmon model, total length of stream network potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_stream_km IS 'Salmon model, total length of streams and rivers potentially accessible upstream of point and below any additional upstream barriers (does not include network connectors in lakes etc)';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_lakereservoir_ha IS 'Salmon model, total area lakes and reservoirs potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_wetland_ha IS 'Salmon model, total area wetlands potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Salmon model, length of stream connectors (in waterbodies) potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_slopeclass03_km IS 'Salmon model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_slopeclass05_km IS 'Salmon model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 3-5%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_slopeclass08_km IS 'Salmon model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 5-8%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_slopeclass15_km IS 'Salmon model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 8-15%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_slopeclass22_km IS 'Salmon model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 15-22%';
COMMENT ON COLUMN {point_schema}.{point_table}.salmon_belowupstrbarriers_slopeclass30_km IS 'Salmon model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 22-30%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_network_km IS 'Steelhead model, total length of stream network potentially accessible upstream of point';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_stream_km IS 'Steelhead model, total length of streams and rivers potentially accessible upstream of point  (does not include network connectors in lakes etc)';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_lakereservoir_ha IS 'Steelhead model, total area lakes and reservoirs potentially accessible upstream of point ';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_wetland_ha IS 'Steelhead model, total area wetlands potentially accessible upstream of point ';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_slopeclass03_waterbodies_km IS 'Steelhead model, length of stream connectors (in waterbodies) potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_slopeclass03_km IS 'Steelhead model, length of stream potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_slopeclass05_km IS 'Steelhead model, length of stream potentially accessible upstream of point with slope 3-5%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_slopeclass08_km IS 'Steelhead model, length of stream potentially accessible upstream of point with slope 5-8%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_slopeclass15_km IS 'Steelhead model, length of stream potentially accessible upstream of point with slope 8-15%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_slopeclass22_km IS 'Steelhead model, length of stream potentially accessible upstream of point with slope 15-22%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_slopeclass30_km IS 'Steelhead model, length of stream potentially accessible upstream of point with slope 22-30%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_network_km IS 'Steelhead model, total length of stream network potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_stream_km IS 'Steelhead model, total length of streams and rivers potentially accessible upstream of point and below any additional upstream barriers (does not include network connectors in lakes etc)';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_lakereservoir_ha IS 'Steelhead model, total area lakes and reservoirs potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_wetland_ha IS 'Steelhead model, total area wetlands potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Steelhead model, length of stream connectors (in waterbodies) potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_slopeclass03_km IS 'Steelhead model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_slopeclass05_km IS 'Steelhead model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 3-5%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_slopeclass08_km IS 'Steelhead model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 5-8%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_slopeclass15_km IS 'Steelhead model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 8-15%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_slopeclass22_km IS 'Steelhead model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 15-22%';
COMMENT ON COLUMN {point_schema}.{point_table}.steelhead_belowupstrbarriers_slopeclass30_km IS 'Steelhead model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 22-30%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_network_km IS 'Westslope Cuthroat Trout model, total length of stream network potentially accessible upstream of point';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_stream_km IS 'Westslope Cuthroat Trout model, total length of streams and rivers potentially accessible upstream of point  (does not include network connectors in lakes etc)';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_lakereservoir_ha IS 'Westslope Cuthroat Trout model, total area lakes and reservoirs potentially accessible upstream of point ';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_wetland_ha IS 'Westslope Cuthroat Trout model, total area wetlands potentially accessible upstream of point ';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_slopeclass03_waterbodies_km IS 'Westslope Cutthroat Trout model, length of stream connectors (in waterbodies) potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_slopeclass03_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_slopeclass05_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point with slope 3-5%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_slopeclass08_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point with slope 5-8%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_slopeclass15_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point with slope 8-15%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_slopeclass22_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point with slope 15-22%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_slopeclass30_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point with slope 22-30%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_network_km IS 'Westslope Cutthroat Trout model, total length of stream network potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_stream_km IS 'Westslope Cuthroat Trout model, total length of streams and rivers potentially accessible upstream of point and below any additional upstream barriers (does not include network connectors in lakes etc)';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_lakereservoir_ha IS 'Westslope Cutthroat Trout model, total area lakes and reservoirs potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_wetland_ha IS 'Westslope Cutthroat Trout model, total area wetlands potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Westslope Cutthroat Trout model, length of stream connectors (in waterbodies) potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_slopeclass03_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_slopeclass05_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 3-5%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_slopeclass08_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 5-8%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_slopeclass15_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 8-15%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_slopeclass22_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 15-22%';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_belowupstrbarriers_slopeclass30_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 22-30%';
-- modelled spawn/rear habitat summaries
COMMENT ON COLUMN {point_schema}.{point_table}.ch_spawning_km IS 'Length of stream upstream of point modelled as potential Chinook spawning habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.ch_rearing_km IS 'Length of stream upstream of point modelled as potential Chinook rearing habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.ch_spawning_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Chinook spawning habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.ch_rearing_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Chinook rearing habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.co_spawning_km IS 'Length of stream upstream of point modelled as potential Coho spawning habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.co_rearing_km IS 'Length of stream upstream of point modelled as potential Coho rearing habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.co_rearing_ha IS 'Area of wetlands upstream of point modelled as potential Coho rearing habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.co_spawning_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Coho spawning habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.co_rearing_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Coho rearing habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.co_rearing_belowupstrbarriers_ha IS 'Area of wetlands upstream of point and below any additional upstream barriers, modelled as potential Coho rearing habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.sk_spawning_km IS 'Length of stream upstream of point modelled as potential Sockeye spawning habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.sk_rearing_km IS 'Length of stream upstream of point modelled as potential Sockeye rearing habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.sk_rearing_ha IS 'Area of lakes upstream of point modelled as potential Sockeye rearing habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.sk_spawning_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Sockeye spawning habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.sk_rearing_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Sockeye rearing habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.sk_rearing_belowupstrbarriers_ha IS 'Area of lakes upstream of point and below any additional upstream barriers, modelled as potential Sockeye rearing habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.st_spawning_km IS 'Length of stream upstream of point modelled as potential Steelhead spawning habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.st_rearing_km IS 'Length of stream upstream of point modelled as potential Steelhead rearing habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.st_spawning_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Steelhead spawning habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.st_rearing_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Steelhead rearing habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_spawning_km IS 'Length of stream upstream of point modelled as potential Westslope Cutthroat spawning habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_rearing_km IS 'Length of stream upstream of point modelled as potential Westslope Cutthroat rearing habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_spawning_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Westslope Cutthroat spawning habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.wct_rearing_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Westslope Cutthroat rearing habitat';
COMMENT ON COLUMN {point_schema}.{point_table}.all_spawning_km IS 'Length of stream upstream of point modelled as potential spawning habitat (all CH,CO,SK,ST,WCT)';
COMMENT ON COLUMN {point_schema}.{point_table}.all_spawning_belowupstrbarriers_km IS 'Length of stream upstream of point modelled as potential rearing habitat (all CH,CO,SK,ST,WCT)';
COMMENT ON COLUMN {point_schema}.{point_table}.all_rearing_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential spawning habitat (all CH,CO,SK,ST,WCT)';
COMMENT ON COLUMN {point_schema}.{point_table}.all_rearing_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential rearing habitat (all CH,CO,SK,ST,WCT)';
COMMENT ON COLUMN {point_schema}.{point_table}.all_spawningrearing_km IS 'Length of all spawning and rearing habitat upstream of point';
COMMENT ON COLUMN {point_schema}.{point_table}.all_spawningrearing_belowupstrbarriers_km IS 'Length of all spawning and rearing habitat upstream of point';
COMMENT ON COLUMN {point_schema}.{point_table}.dbm_mof_50k_grid IS 'WHSE_BASEMAPPING.DBM_MOF_50K_GRID map_tile_display_name, used for generating planning map pdfs';





-- run the report, updating new columns in existing table



-- first, calculate linear stats
WITH
spp_downstream AS
(
  SELECT
    {point_id},
    array_agg(species_code) as species_codes
  FROM
    (
      SELECT DISTINCT
        a.{point_id},
        unnest(species_codes) as species_code
      FROM {point_schema}.{point_table} a
      LEFT OUTER JOIN bcfishobs.fiss_fish_obsrvtn_events fo
      ON a.blue_line_key = fo.blue_line_key
      AND a.downstream_route_measure > fo.downstream_route_measure
      ORDER BY {point_id}, species_code
    ) AS f
  GROUP BY {point_id}
),

spp_upstream AS
(
SELECT
  {point_id},
  array_agg(species_code) as species_codes
FROM
  (
    SELECT DISTINCT
      a.{point_id},
      unnest(species_codes) as species_code
    FROM {point_schema}.{point_table} a
    LEFT OUTER JOIN bcfishobs.fiss_fish_obsrvtn_events fo
    ON FWA_Upstream(
      a.blue_line_key,
      a.downstream_route_measure,
      a.wscode_ltree,
      a.localcode_ltree,
      fo.blue_line_key,
      fo.downstream_route_measure,
      fo.wscode_ltree,
      fo.localcode_ltree
     )
    ORDER BY species_code
  ) AS f
GROUP BY {point_id}
),

grade AS
(
SELECT
  a.{point_id},
  s.gradient,
  s.stream_order,
  s.stream_magnitude,
  s.accessibility_model_salmon,
  s.accessibility_model_steelhead,
  s.accessibility_model_wct,
  s.upstream_area_ha
FROM {point_schema}.{point_table} a
INNER JOIN bcfishpass.streams s
ON a.linear_feature_id = s.linear_feature_id
AND a.downstream_route_measure > s.downstream_route_measure - .001
AND a.downstream_route_measure + .001 < s.upstream_route_measure
ORDER BY a.{point_id}, s.downstream_route_measure
),

report AS
(SELECT
  a.{point_id},
  b.stream_order,
  b.stream_magnitude,
  b.gradient,
  b.accessibility_model_salmon,
  b.accessibility_model_steelhead,
  b.accessibility_model_wct,
  b.upstream_area_ha AS watershed_upstr_ha,
  spd.species_codes as dnstr_observedspp,
  spu.species_codes as upstr_observedspp,

-- totals
  COALESCE(ROUND((SUM(ST_Length(s.geom)::numeric) / 1000), 2), 0) AS total_network_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))) / 1000)::numeric, 2), 0) AS total_stream_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS total_slopeclass03_waterbodies_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS total_slopeclass03_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .03 AND s.gradient < .05) / 1000))::numeric, 2), 0) as total_slopeclass05_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .05 AND s.gradient < .08) / 1000))::numeric, 2), 0) as total_slopeclass08_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .08 AND s.gradient < .15) / 1000))::numeric, 2), 0) as total_slopeclass15_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .15 AND s.gradient < .22) / 1000))::numeric, 2), 0) as total_slopeclass22_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.gradient >= .22 AND s.gradient < .30) / 1000))::numeric, 2), 0) as total_slopeclass30_km,

-- salmon model
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_salmon LIKE '%ACCESSIBLE%') / 1000)::numeric), 2), 0) AS salmon_network_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_salmon LIKE '%ACCESSIBLE%' AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS salmon_stream_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.accessibility_model_salmon LIKE '%ACCESSIBLE%') AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS salmon_slopeclass03_waterbodies_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.accessibility_model_salmon LIKE '%ACCESSIBLE%') AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS salmon_slopeclass03_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_salmon LIKE '%ACCESSIBLE%' AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as salmon_slopeclass05_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_salmon LIKE '%ACCESSIBLE%' AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as salmon_slopeclass08_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_salmon LIKE '%ACCESSIBLE%' AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as salmon_slopeclass15_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_salmon LIKE '%ACCESSIBLE%' AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as salmon_slopeclass22_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_salmon LIKE '%ACCESSIBLE%' AND (s.gradient >= .22 AND s.gradient < .3)) / 1000))::numeric, 2), 0) as salmon_slopeclass30_km,

-- steelhead
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_steelhead LIKE '%ACCESSIBLE%') / 1000)::numeric), 2), 0) AS steelhead_network_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_steelhead LIKE '%ACCESSIBLE%' AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS steelhead_stream_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.accessibility_model_steelhead LIKE '%ACCESSIBLE%') AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS steelhead_slopeclass03_waterbodies_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.accessibility_model_steelhead LIKE '%ACCESSIBLE%') AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS steelhead_slopeclass03_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_steelhead LIKE '%ACCESSIBLE%' AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as steelhead_slopeclass05_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_steelhead LIKE '%ACCESSIBLE%' AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as steelhead_slopeclass08_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_steelhead LIKE '%ACCESSIBLE%' AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as steelhead_slopeclass15_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_steelhead LIKE '%ACCESSIBLE%' AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as steelhead_slopeclass22_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_steelhead LIKE '%ACCESSIBLE%' AND (s.gradient >= .22 AND s.gradient < .30)) / 1000))::numeric, 2), 0) as steelhead_slopeclass30_km,

-- wct
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_wct LIKE '%ACCESSIBLE%') / 1000)::numeric), 2), 0) AS wct_network_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_wct LIKE '%ACCESSIBLE%' AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))))) / 1000)::numeric, 2), 0) AS wct_stream_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.accessibility_model_wct LIKE '%ACCESSIBLE%') AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type != 'R' OR (wb.waterbody_type IS NOT NULL AND s.edge_type NOT IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS wct_slopeclass03_waterbodies_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (
    WHERE (s.accessibility_model_wct LIKE '%ACCESSIBLE%') AND (s.gradient >= 0 AND s.gradient < .03) AND (wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300)))
  )) / 1000)::numeric, 2), 0) AS wct_slopeclass03_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .03 AND s.gradient < .05)) / 1000))::numeric, 2), 0) as wct_slopeclass05_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .05 AND s.gradient < .08)) / 1000))::numeric, 2), 0) as wct_slopeclass08_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .08 AND s.gradient < .15)) / 1000))::numeric, 2), 0) as wct_slopeclass15_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .15 AND s.gradient < .22)) / 1000))::numeric, 2), 0) as wct_slopeclass22_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.accessibility_model_wct LIKE '%ACCESSIBLE%' AND (s.gradient >= .22 AND s.gradient < .30)) / 1000))::numeric, 2), 0) as wct_slopeclass30_km,

-- habitat models
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.spawning_model_chinook IS TRUE) / 1000))::numeric, 2), 0) AS ch_spawning_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.rearing_model_chinook IS TRUE) / 1000))::numeric, 2), 0) AS ch_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.spawning_model_coho IS TRUE) / 1000))::numeric, 2), 0) AS co_spawning_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.rearing_model_coho IS TRUE) / 1000))::numeric, 2), 0) AS co_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.spawning_model_sockeye IS TRUE) / 1000))::numeric, 2), 0) AS sk_spawning_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.rearing_model_sockeye IS TRUE) / 1000))::numeric, 2), 0) AS sk_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.spawning_model_steelhead IS TRUE) / 1000))::numeric, 2), 0) AS st_spawning_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.rearing_model_steelhead IS TRUE) / 1000))::numeric, 2), 0) AS st_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.spawning_model_wct IS TRUE) / 1000))::numeric, 2), 0) AS wct_spawning_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.rearing_model_wct IS TRUE) / 1000))::numeric, 2), 0) AS wct_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.spawning_model_chinook IS TRUE OR
                                                        s.spawning_model_coho IS TRUE OR
                                                        s.spawning_model_sockeye IS TRUE OR
                                                        s.spawning_model_steelhead IS TRUE OR
                                                        s.spawning_model_wct IS TRUE
                                                  ) / 1000))::numeric, 2), 0)  AS all_spawning_km,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.rearing_model_chinook IS TRUE OR
                                                        s.rearing_model_coho IS TRUE OR
                                                        s.rearing_model_sockeye IS TRUE OR
                                                        s.rearing_model_steelhead IS TRUE OR
                                                        s.rearing_model_wct IS TRUE
                                                  ) / 1000))::numeric, 2), 0) AS all_rearing_km ,
  COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.spawning_model_chinook IS TRUE OR
                                                        s.spawning_model_coho IS TRUE OR
                                                        s.spawning_model_sockeye IS TRUE OR
                                                        s.spawning_model_steelhead IS TRUE OR
                                                        s.spawning_model_wct IS TRUE OR
                                                        s.rearing_model_chinook IS TRUE OR
                                                        s.rearing_model_coho IS TRUE OR
                                                        s.rearing_model_sockeye IS TRUE OR
                                                        s.rearing_model_steelhead IS TRUE OR
                                                        s.rearing_model_wct IS TRUE
                                                  ) / 1000))::numeric, 2), 0) AS all_spawningrearing_km

FROM {point_schema}.{point_table} a
INNER JOIN bcfishpass.param_watersheds g
ON a.watershed_group_code = g.watershed_group_code AND g.include IS TRUE
LEFT OUTER JOIN bcfishpass.streams s
ON FWA_Upstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    s.blue_line_key,
    s.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    True,
    1
   )
LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
ON s.waterbody_key = wb.waterbody_key
LEFT OUTER JOIN spp_upstream spu
ON a.{point_id} = spu.{point_id}
LEFT OUTER JOIN spp_downstream spd
ON a.{point_id} = spd.{point_id}
LEFT OUTER JOIN grade b
ON a.{point_id} = b.{point_id}
GROUP BY
  a.{point_id},
  b.stream_order,
  b.gradient,
  b.stream_magnitude,
  b.accessibility_model_salmon,
  b.accessibility_model_steelhead,
  b.accessibility_model_wct,
  b.upstream_area_ha,
  spd.species_codes,
  spu.species_codes
)

UPDATE {point_schema}.{point_table} p
SET
  dnstr_observedspp = r.dnstr_observedspp,
  upstr_observedspp = r.upstr_observedspp,
  stream_order = r.stream_order,
  stream_magnitude = r.stream_magnitude,
  gradient = r.gradient,
  accessibility_model_salmon = r.accessibility_model_salmon,
  accessibility_model_steelhead = r.accessibility_model_steelhead,
  accessibility_model_wct = r.accessibility_model_wct,
  watershed_upstr_ha = r.watershed_upstr_ha,
  total_network_km = r.total_network_km,
  total_stream_km = r.total_stream_km,
  total_slopeclass03_waterbodies_km = r.total_slopeclass03_waterbodies_km,
  total_slopeclass03_km = r.total_slopeclass03_km,
  total_slopeclass05_km = r.total_slopeclass05_km,
  total_slopeclass08_km = r.total_slopeclass08_km,
  total_slopeclass15_km = r.total_slopeclass15_km,
  total_slopeclass22_km = r.total_slopeclass22_km,
  total_slopeclass30_km = r.total_slopeclass30_km,
  salmon_network_km = r.salmon_network_km,
  salmon_stream_km = r.salmon_stream_km,
  salmon_slopeclass03_waterbodies_km = r.salmon_slopeclass03_waterbodies_km,
  salmon_slopeclass03_km = r.salmon_slopeclass03_km,
  salmon_slopeclass05_km = r.salmon_slopeclass05_km,
  salmon_slopeclass08_km = r.salmon_slopeclass08_km,
  salmon_slopeclass15_km = r.salmon_slopeclass15_km,
  salmon_slopeclass22_km = r.salmon_slopeclass22_km,
  salmon_slopeclass30_km = r.salmon_slopeclass30_km,
  steelhead_network_km = r.steelhead_network_km,
  steelhead_stream_km = r.steelhead_stream_km,
  steelhead_slopeclass03_waterbodies_km = r.steelhead_slopeclass03_waterbodies_km,
  steelhead_slopeclass03_km = r.steelhead_slopeclass03_km,
  steelhead_slopeclass05_km = r.steelhead_slopeclass05_km,
  steelhead_slopeclass08_km = r.steelhead_slopeclass08_km,
  steelhead_slopeclass15_km = r.steelhead_slopeclass15_km,
  steelhead_slopeclass22_km = r.steelhead_slopeclass22_km,
  steelhead_slopeclass30_km = r.steelhead_slopeclass30_km,
  wct_network_km = r.wct_network_km,
  wct_stream_km = r.wct_stream_km,
  wct_slopeclass03_waterbodies_km = r.wct_slopeclass03_waterbodies_km,
  wct_slopeclass03_km = r.wct_slopeclass03_km,
  wct_slopeclass05_km = r.wct_slopeclass05_km,
  wct_slopeclass08_km = r.wct_slopeclass08_km,
  wct_slopeclass15_km = r.wct_slopeclass15_km,
  wct_slopeclass22_km = r.wct_slopeclass22_km,
  wct_slopeclass30_km = r.wct_slopeclass30_km,
  ch_spawning_km = r.ch_spawning_km,
  ch_rearing_km = r.ch_rearing_km,
  co_spawning_km = r.co_spawning_km,
  co_rearing_km = r.co_rearing_km,
  sk_spawning_km = r.sk_spawning_km,
  sk_rearing_km = r.sk_rearing_km,
  st_spawning_km = r.st_spawning_km,
  st_rearing_km = r.st_rearing_km,
  wct_spawning_km = r.wct_spawning_km,
  wct_rearing_km = r.wct_rearing_km,
  all_spawning_km = r.all_spawning_km,
  all_rearing_km = r.all_rearing_km,
  all_spawningrearing_km = r.all_spawningrearing_km
FROM report r
WHERE p.{point_id} = r.{point_id};


-- increase linear total for co and sk rearing by 50% within wetlands/lakes
-- this is just an attempt to give these more importance (as they aren't really linear anyway)
WITH lake_wetland_rearing AS
(
  SELECT
    a.{point_id},
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.rearing_model_coho IS TRUE AND wb.waterbody_type = 'W') / 1000))::numeric, 2), 0) AS co_rearing_km_wetland,
    COALESCE(ROUND(((SUM(ST_Length(s.geom)) FILTER (WHERE s.rearing_model_sockeye IS TRUE AND wb.waterbody_type IN ('X','L')) / 1000))::numeric, 2), 0) AS sk_rearing_km_lake
  FROM {point_schema}.{point_table} a
  INNER JOIN bcfishpass.param_watersheds g
  ON a.watershed_group_code = g.watershed_group_code AND g.include IS TRUE
  LEFT OUTER JOIN bcfishpass.streams s
  ON FWA_Upstream(
      a.blue_line_key,
      a.downstream_route_measure,
      a.wscode_ltree,
      a.localcode_ltree,
      s.blue_line_key,
      s.downstream_route_measure,
      s.wscode_ltree,
      s.localcode_ltree,
      True,
      1
     )
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
  ON s.waterbody_key = wb.waterbody_key
  GROUP BY a.{point_id}
)

UPDATE {point_schema}.{point_table} p
SET
  co_rearing_km = co_rearing_km + (r.co_rearing_km_wetland * .5),
  sk_rearing_km = sk_rearing_km + (r.sk_rearing_km_lake * .5),
  all_rearing_km = all_rearing_km + (r.co_rearing_km_wetland * .5) + (r.sk_rearing_km_lake * .5),
  all_spawningrearing_km = all_spawningrearing_km + (r.co_rearing_km_wetland * .5) + (r.sk_rearing_km_lake * .5)
FROM lake_wetland_rearing r
WHERE p.{point_id} = r.{point_id};


-- populate upstream area stats
WITH upstr_wb AS
(SELECT DISTINCT
  a.{point_id},
  s.waterbody_key,
  s.accessibility_model_salmon,
  s.accessibility_model_steelhead,
  s.accessibility_model_wct,
  s.rearing_model_coho,
  s.rearing_model_sockeye,
  ST_Area(lake.geom) as area_lake,
  ST_Area(manmade.geom) as area_manmade,
  ST_Area(wetland.geom) as area_wetland
FROM {point_schema}.{point_table} a
LEFT OUTER JOIN bcfishpass.streams s
ON FWA_Upstream(
    a.blue_line_key,
    a.downstream_route_measure,
    a.wscode_ltree,
    a.localcode_ltree,
    s.blue_line_key,
    s.downstream_route_measure,
    s.wscode_ltree,
    s.localcode_ltree,
    True,
    1
   )
LEFT OUTER JOIN whse_basemapping.fwa_lakes_poly lake
ON s.waterbody_key = lake.waterbody_key
LEFT OUTER JOIN whse_basemapping.fwa_manmade_waterbodies_poly manmade
ON s.waterbody_key = manmade.waterbody_key
LEFT OUTER JOIN whse_basemapping.fwa_wetlands_poly wetland
ON s.waterbody_key = wetland.waterbody_key
WHERE s.waterbody_key IS NOT NULL
ORDER BY a.{point_id}
),

report AS
(SELECT
  {point_id},
  ROUND(((
    SUM(COALESCE(uwb.area_lake, 0)) + SUM(COALESCE(uwb.area_manmade,0))) / 10000)::numeric, 2
  ) AS total_lakereservoir_ha,
  ROUND((SUM(COALESCE(uwb.area_wetland, 0)) / 10000)::numeric, 2) AS total_wetland_ha,
  ROUND(((SUM(COALESCE(uwb.area_lake, 0)) FILTER (WHERE uwb.accessibility_model_salmon LIKE '%ACCESSIBLE%') +
          SUM(COALESCE(uwb.area_manmade, 0)) FILTER (WHERE uwb.accessibility_model_salmon LIKE '%ACCESSIBLE%')) / 10000)::numeric, 2) AS salmon_lakereservoir_ha,
  ROUND(((SUM(COALESCE(uwb.area_wetland, 0)) FILTER (WHERE uwb.accessibility_model_salmon LIKE '%ACCESSIBLE%')) / 10000)::numeric, 2) AS salmon_wetland_ha,
  ROUND(((SUM(COALESCE(uwb.area_lake, 0)) FILTER (WHERE uwb.accessibility_model_steelhead LIKE '%ACCESSIBLE%') +
          SUM(COALESCE(uwb.area_manmade, 0)) FILTER (WHERE uwb.accessibility_model_steelhead LIKE '%ACCESSIBLE%')) / 10000)::numeric, 2) AS steelhead_lakereservoir_ha,
  ROUND(((SUM(COALESCE(uwb.area_wetland, 0)) FILTER (WHERE uwb.accessibility_model_steelhead LIKE '%ACCESSIBLE%')) / 10000)::numeric, 2) AS steelhead_wetland_ha,
  ROUND(((SUM(COALESCE(uwb.area_lake, 0)) FILTER (WHERE uwb.accessibility_model_wct LIKE '%ACCESSIBLE%') +
          SUM(uwb.area_manmade) FILTER (WHERE uwb.accessibility_model_wct LIKE '%ACCESSIBLE%')) / 10000)::numeric, 2) AS wct_lakereservoir_ha,
  ROUND(((SUM(COALESCE(uwb.area_wetland, 0)) FILTER (WHERE uwb.accessibility_model_wct LIKE '%ACCESSIBLE%')) / 10000)::numeric, 2) AS wct_wetland_ha,
  ROUND(((SUM(COALESCE(uwb.area_wetland, 0)) FILTER (WHERE uwb.rearing_model_coho = True)) / 10000)::numeric, 2) AS co_rearing_ha,
  ROUND(((SUM(COALESCE(uwb.area_lake, 0)) FILTER (WHERE uwb.rearing_model_sockeye = True) +
          SUM(COALESCE(uwb.area_manmade, 0)) FILTER (WHERE uwb.rearing_model_sockeye = True)) / 10000)::numeric, 2) AS sk_rearing_ha
FROM upstr_wb uwb
GROUP BY {point_id}
)

UPDATE {point_schema}.{point_table} p
SET
  total_lakereservoir_ha = r.total_lakereservoir_ha,
  total_wetland_ha = r.total_wetland_ha,
  salmon_lakereservoir_ha = r.salmon_lakereservoir_ha,
  salmon_wetland_ha = r.salmon_wetland_ha,
  steelhead_lakereservoir_ha = r.steelhead_lakereservoir_ha,
  steelhead_wetland_ha = r.steelhead_wetland_ha,
  wct_lakereservoir_ha = r.wct_lakereservoir_ha,
  wct_wetland_ha = r.wct_wetland_ha,
  co_rearing_ha = r.co_rearing_ha,
  sk_rearing_ha = r.sk_rearing_ha
FROM report r
WHERE p.{point_id} = r.{point_id};


-- Calculate and populate upstream length/area stats for below addtional upstream barriers
-- (this is the total at the given point as already calculated, minus the total on all points immediately upstream of the point)
-- NOTE - this has to be re-run separately for bcfishpass.crossings because it includes a mixture of passable/barriers,
-- and not all tables we run this report on will have the barrier_status column
-- see 00_report_crossings_obs_belowupstrbarriers.sql

-- default to total upstream
UPDATE {point_schema}.{point_table} p
SET
  total_belowupstrbarriers_network_km = total_network_km,
  total_belowupstrbarriers_stream_km = total_stream_km,
  total_belowupstrbarriers_lakereservoir_ha = total_lakereservoir_ha,
  total_belowupstrbarriers_wetland_ha = total_wetland_ha,
  total_belowupstrbarriers_slopeclass03_waterbodies_km = total_slopeclass03_waterbodies_km,
  total_belowupstrbarriers_slopeclass03_km = total_slopeclass03_km,
  total_belowupstrbarriers_slopeclass05_km = total_slopeclass05_km,
  total_belowupstrbarriers_slopeclass08_km = total_slopeclass08_km,
  total_belowupstrbarriers_slopeclass15_km = total_slopeclass15_km,
  total_belowupstrbarriers_slopeclass22_km = total_slopeclass22_km,
  total_belowupstrbarriers_slopeclass30_km = total_slopeclass30_km,
  salmon_belowupstrbarriers_network_km = salmon_network_km,
  salmon_belowupstrbarriers_stream_km = salmon_stream_km,
  salmon_belowupstrbarriers_lakereservoir_ha = salmon_lakereservoir_ha,
  salmon_belowupstrbarriers_wetland_ha = salmon_wetland_ha,
  salmon_belowupstrbarriers_slopeclass03_waterbodies_km = salmon_slopeclass03_waterbodies_km,
  salmon_belowupstrbarriers_slopeclass03_km = salmon_slopeclass03_km,
  salmon_belowupstrbarriers_slopeclass05_km = salmon_slopeclass05_km,
  salmon_belowupstrbarriers_slopeclass08_km = salmon_slopeclass08_km,
  salmon_belowupstrbarriers_slopeclass15_km = salmon_slopeclass15_km,
  salmon_belowupstrbarriers_slopeclass22_km = salmon_slopeclass22_km,
  salmon_belowupstrbarriers_slopeclass30_km = salmon_slopeclass30_km,
  steelhead_belowupstrbarriers_network_km = steelhead_network_km,
  steelhead_belowupstrbarriers_stream_km = steelhead_stream_km,
  steelhead_belowupstrbarriers_lakereservoir_ha = steelhead_lakereservoir_ha,
  steelhead_belowupstrbarriers_wetland_ha = steelhead_wetland_ha,
  steelhead_belowupstrbarriers_slopeclass03_km = steelhead_slopeclass03_km,
  steelhead_belowupstrbarriers_slopeclass05_km = steelhead_slopeclass05_km,
  steelhead_belowupstrbarriers_slopeclass08_km = steelhead_slopeclass08_km,
  steelhead_belowupstrbarriers_slopeclass15_km = steelhead_slopeclass15_km,
  steelhead_belowupstrbarriers_slopeclass22_km = steelhead_slopeclass22_km,
  steelhead_belowupstrbarriers_slopeclass30_km = steelhead_slopeclass30_km,
  wct_belowupstrbarriers_network_km = wct_network_km,
  wct_belowupstrbarriers_stream_km = wct_stream_km,
  wct_belowupstrbarriers_lakereservoir_ha = wct_lakereservoir_ha,
  wct_belowupstrbarriers_wetland_ha = wct_wetland_ha,
  wct_belowupstrbarriers_slopeclass03_km = wct_slopeclass03_km,
  wct_belowupstrbarriers_slopeclass05_km = wct_slopeclass05_km,
  wct_belowupstrbarriers_slopeclass08_km = wct_slopeclass08_km,
  wct_belowupstrbarriers_slopeclass15_km = wct_slopeclass15_km,
  wct_belowupstrbarriers_slopeclass22_km = wct_slopeclass22_km,
  wct_belowupstrbarriers_slopeclass30_km = wct_slopeclass30_km,
  ch_spawning_belowupstrbarriers_km = ch_spawning_km,
  ch_rearing_belowupstrbarriers_km = ch_rearing_km,
  co_spawning_belowupstrbarriers_km = co_spawning_km,
  co_rearing_belowupstrbarriers_km = co_rearing_km,
  sk_spawning_belowupstrbarriers_km = sk_spawning_km,
  sk_rearing_belowupstrbarriers_km = sk_rearing_km,
  st_spawning_belowupstrbarriers_km = st_spawning_km,
  st_rearing_belowupstrbarriers_km = st_rearing_km,
  wct_spawning_belowupstrbarriers_km = wct_spawning_km,
  wct_rearing_belowupstrbarriers_km = wct_rearing_km,
  all_spawning_belowupstrbarriers_km = all_spawning_km,
  all_rearing_belowupstrbarriers_km = all_rearing_km,
  all_spawningrearing_belowupstrbarriers_km = all_spawningrearing_km;

-- then calculate the rest where there is/are anthropogenic crossings upstream
WITH report AS
(SELECT
  a.{point_id},
  ROUND((COALESCE(a.total_network_km, 0) - SUM(COALESCE(b.total_network_km, 0)))::numeric, 2) total_belowupstrbarriers_network_km,
  ROUND((COALESCE(a.total_stream_km, 0) - SUM(COALESCE(b.total_stream_km, 0)))::numeric, 2) total_belowupstrbarriers_stream_km,
  ROUND((COALESCE(a.total_lakereservoir_ha, 0) - SUM(COALESCE(b.total_lakereservoir_ha, 0)))::numeric, 2) total_belowupstrbarriers_lakereservoir_ha,
  ROUND((COALESCE(a.total_wetland_ha, 0) - SUM(COALESCE(b.total_wetland_ha, 0)))::numeric, 2) total_belowupstrbarriers_wetland_ha,
  ROUND((COALESCE(a.total_slopeclass03_waterbodies_km, 0) - SUM(COALESCE(b.total_slopeclass03_waterbodies_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass03_waterbodies_km,
  ROUND((COALESCE(a.total_slopeclass03_km, 0) - SUM(COALESCE(b.total_slopeclass03_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass03_km,
  ROUND((COALESCE(a.total_slopeclass05_km, 0) - SUM(COALESCE(b.total_slopeclass05_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass05_km,
  ROUND((COALESCE(a.total_slopeclass08_km, 0) - SUM(COALESCE(b.total_slopeclass08_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass08_km,
  ROUND((COALESCE(a.total_slopeclass15_km, 0) - SUM(COALESCE(b.total_slopeclass15_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass15_km,
  ROUND((COALESCE(a.total_slopeclass22_km, 0) - SUM(COALESCE(b.total_slopeclass22_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass22_km,
  ROUND((COALESCE(a.total_slopeclass30_km, 0) - SUM(COALESCE(b.total_slopeclass30_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass30_km,
  ROUND((COALESCE(a.salmon_network_km, 0) - SUM(COALESCE(b.salmon_network_km, 0)))::numeric, 2) salmon_belowupstrbarriers_network_km,
  ROUND((COALESCE(a.salmon_stream_km, 0) - SUM(COALESCE(b.salmon_stream_km, 0)))::numeric, 2) salmon_belowupstrbarriers_stream_km,
  ROUND((COALESCE(a.salmon_lakereservoir_ha, 0) - SUM(COALESCE(b.salmon_lakereservoir_ha, 0)))::numeric, 2) salmon_belowupstrbarriers_lakereservoir_ha,
  ROUND((COALESCE(a.salmon_wetland_ha, 0) - SUM(COALESCE(b.salmon_wetland_ha, 0)))::numeric, 2) salmon_belowupstrbarriers_wetland_ha,
  ROUND((COALESCE(a.salmon_slopeclass03_waterbodies_km, 0) - SUM(COALESCE(b.salmon_slopeclass03_waterbodies_km, 0)))::numeric, 2) salmon_belowupstrbarriers_slopeclass03_waterbodies_km,
  ROUND((COALESCE(a.salmon_slopeclass03_km, 0) - SUM(COALESCE(b.salmon_slopeclass03_km, 0)))::numeric, 2) salmon_belowupstrbarriers_slopeclass03_km,
  ROUND((COALESCE(a.salmon_slopeclass05_km, 0) - SUM(COALESCE(b.salmon_slopeclass05_km, 0)))::numeric, 2) salmon_belowupstrbarriers_slopeclass05_km,
  ROUND((COALESCE(a.salmon_slopeclass08_km, 0) - SUM(COALESCE(b.salmon_slopeclass08_km, 0)))::numeric, 2) salmon_belowupstrbarriers_slopeclass08_km,
  ROUND((COALESCE(a.salmon_slopeclass15_km, 0) - SUM(COALESCE(b.salmon_slopeclass15_km, 0)))::numeric, 2) salmon_belowupstrbarriers_slopeclass15_km,
  ROUND((COALESCE(a.salmon_slopeclass22_km, 0) - SUM(COALESCE(b.salmon_slopeclass22_km, 0)))::numeric, 2) salmon_belowupstrbarriers_slopeclass22_km,
  ROUND((COALESCE(a.salmon_slopeclass30_km, 0) - SUM(COALESCE(b.salmon_slopeclass30_km, 0)))::numeric, 2) salmon_belowupstrbarriers_slopeclass30_km,
  ROUND((COALESCE(a.steelhead_network_km, 0) - SUM(COALESCE(b.steelhead_network_km, 0)))::numeric, 2) steelhead_belowupstrbarriers_network_km,
  ROUND((COALESCE(a.steelhead_stream_km, 0) - SUM(COALESCE(b.steelhead_stream_km, 0)))::numeric, 2) steelhead_belowupstrbarriers_stream_km,
  ROUND((COALESCE(a.steelhead_lakereservoir_ha, 0) - SUM(COALESCE(b.steelhead_lakereservoir_ha, 0)))::numeric, 2) steelhead_belowupstrbarriers_lakereservoir_ha,
  ROUND((COALESCE(a.steelhead_wetland_ha, 0) - SUM(COALESCE(b.steelhead_wetland_ha, 0)))::numeric, 2) steelhead_belowupstrbarriers_wetland_ha,
  ROUND((COALESCE(a.steelhead_slopeclass03_km, 0) - SUM(COALESCE(b.steelhead_slopeclass03_km, 0)))::numeric, 2) steelhead_belowupstrbarriers_slopeclass03_km,
  ROUND((COALESCE(a.steelhead_slopeclass05_km, 0) - SUM(COALESCE(b.steelhead_slopeclass05_km, 0)))::numeric, 2) steelhead_belowupstrbarriers_slopeclass05_km,
  ROUND((COALESCE(a.steelhead_slopeclass08_km, 0) - SUM(COALESCE(b.steelhead_slopeclass08_km, 0)))::numeric, 2) steelhead_belowupstrbarriers_slopeclass08_km,
  ROUND((COALESCE(a.steelhead_slopeclass15_km, 0) - SUM(COALESCE(b.steelhead_slopeclass15_km, 0)))::numeric, 2) steelhead_belowupstrbarriers_slopeclass15_km,
  ROUND((COALESCE(a.steelhead_slopeclass22_km, 0) - SUM(COALESCE(b.steelhead_slopeclass22_km, 0)))::numeric, 2) steelhead_belowupstrbarriers_slopeclass22_km,
  ROUND((COALESCE(a.steelhead_slopeclass30_km, 0) - SUM(COALESCE(b.steelhead_slopeclass30_km, 0)))::numeric, 2) steelhead_belowupstrbarriers_slopeclass30_km,
  ROUND((COALESCE(a.wct_network_km, 0) - SUM(COALESCE(b.wct_network_km, 0)))::numeric, 2) wct_belowupstrbarriers_network_km,
  ROUND((COALESCE(a.wct_stream_km, 0) - SUM(COALESCE(b.wct_stream_km, 0)))::numeric, 2) wct_belowupstrbarriers_stream_km,
  ROUND((COALESCE(a.wct_lakereservoir_ha, 0) - SUM(COALESCE(b.wct_lakereservoir_ha, 0)))::numeric, 2) wct_belowupstrbarriers_lakereservoir_ha,
  ROUND((COALESCE(a.wct_wetland_ha, 0) - SUM(COALESCE(b.wct_wetland_ha, 0)))::numeric, 2) wct_belowupstrbarriers_wetland_ha,
  ROUND((COALESCE(a.wct_slopeclass03_km, 0) - SUM(COALESCE(b.wct_slopeclass03_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass03_km,
  ROUND((COALESCE(a.wct_slopeclass05_km, 0) - SUM(COALESCE(b.wct_slopeclass05_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass05_km,
  ROUND((COALESCE(a.wct_slopeclass08_km, 0) - SUM(COALESCE(b.wct_slopeclass08_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass08_km,
  ROUND((COALESCE(a.wct_slopeclass15_km, 0) - SUM(COALESCE(b.wct_slopeclass15_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass15_km,
  ROUND((COALESCE(a.wct_slopeclass22_km, 0) - SUM(COALESCE(b.wct_slopeclass22_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass22_km,
  ROUND((COALESCE(a.wct_slopeclass30_km, 0) - SUM(COALESCE(b.wct_slopeclass30_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass30_km,
  ROUND((COALESCE(a.ch_spawning_km, 0) - SUM(COALESCE(b.ch_spawning_km, 0)))::numeric, 2) ch_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.ch_rearing_km, 0) - SUM(COALESCE(b.ch_rearing_km, 0)))::numeric, 2) ch_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.co_spawning_km, 0) - SUM(COALESCE(b.co_spawning_km, 0)))::numeric, 2) co_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.co_rearing_km, 0) - SUM(COALESCE(b.co_rearing_km, 0)))::numeric, 2) co_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.co_rearing_ha, 0) - SUM(COALESCE(b.co_rearing_ha, 0)))::numeric, 2) co_rearing_belowupstrbarriers_ha,
  ROUND((COALESCE(a.sk_spawning_km, 0) - SUM(COALESCE(b.sk_spawning_km, 0)))::numeric, 2) sk_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.sk_rearing_km, 0) - SUM(COALESCE(b.sk_rearing_km, 0)))::numeric, 2) sk_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.sk_rearing_ha, 0) - SUM(COALESCE(b.sk_rearing_ha, 0)))::numeric, 2) sk_rearing_belowupstrbarriers_ha  ,
  ROUND((COALESCE(a.st_spawning_km, 0) - SUM(COALESCE(b.st_spawning_km, 0)))::numeric, 2) st_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.st_rearing_km, 0) - SUM(COALESCE(b.st_rearing_km, 0)))::numeric, 2) st_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.wct_spawning_km, 0) - SUM(COALESCE(b.wct_spawning_km, 0)))::numeric, 2) wct_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.wct_rearing_km, 0) - SUM(COALESCE(b.wct_rearing_km, 0)))::numeric, 2) wct_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.all_spawning_km, 0) - SUM(COALESCE(b.all_spawning_km, 0)))::numeric, 2) all_spawning_belowupstrbarriers_km,
  ROUND((COALESCE(a.all_rearing_km, 0) - SUM(COALESCE(b.all_rearing_km, 0)))::numeric, 2) all_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.all_spawningrearing_km, 0) - SUM(COALESCE(b.all_spawningrearing_km, 0)))::numeric, 2) all_spawningrearing_belowupstrbarriers_km
FROM {point_schema}.{point_table} a
INNER JOIN {barriers_schema}.{barriers_table} b
ON a.{point_id} = b.{dnstr_barriers_id}[1]
GROUP BY a.{point_id}
)

UPDATE {point_schema}.{point_table} p
SET
  total_belowupstrbarriers_network_km = r.total_belowupstrbarriers_network_km,
  total_belowupstrbarriers_stream_km = r.total_belowupstrbarriers_stream_km,
  total_belowupstrbarriers_lakereservoir_ha = r.total_belowupstrbarriers_lakereservoir_ha,
  total_belowupstrbarriers_wetland_ha = r.total_belowupstrbarriers_wetland_ha,
  total_belowupstrbarriers_slopeclass03_waterbodies_km = r.total_belowupstrbarriers_slopeclass03_waterbodies_km,
  total_belowupstrbarriers_slopeclass03_km = r.total_belowupstrbarriers_slopeclass03_km,
  total_belowupstrbarriers_slopeclass05_km = r.total_belowupstrbarriers_slopeclass05_km,
  total_belowupstrbarriers_slopeclass08_km = r.total_belowupstrbarriers_slopeclass08_km,
  total_belowupstrbarriers_slopeclass15_km = r.total_belowupstrbarriers_slopeclass15_km,
  total_belowupstrbarriers_slopeclass22_km = r.total_belowupstrbarriers_slopeclass22_km,
  total_belowupstrbarriers_slopeclass30_km = r.total_belowupstrbarriers_slopeclass30_km,
  salmon_belowupstrbarriers_network_km = r.salmon_belowupstrbarriers_network_km,
  salmon_belowupstrbarriers_stream_km = r.salmon_belowupstrbarriers_stream_km,
  salmon_belowupstrbarriers_lakereservoir_ha = r.salmon_belowupstrbarriers_lakereservoir_ha,
  salmon_belowupstrbarriers_wetland_ha = r.salmon_belowupstrbarriers_wetland_ha,
  salmon_belowupstrbarriers_slopeclass03_waterbodies_km = r.salmon_belowupstrbarriers_slopeclass03_waterbodies_km,
  salmon_belowupstrbarriers_slopeclass03_km = r.salmon_belowupstrbarriers_slopeclass03_km,
  salmon_belowupstrbarriers_slopeclass05_km = r.salmon_belowupstrbarriers_slopeclass05_km,
  salmon_belowupstrbarriers_slopeclass08_km = r.salmon_belowupstrbarriers_slopeclass08_km,
  salmon_belowupstrbarriers_slopeclass15_km = r.salmon_belowupstrbarriers_slopeclass15_km,
  salmon_belowupstrbarriers_slopeclass22_km = r.salmon_belowupstrbarriers_slopeclass22_km,
  salmon_belowupstrbarriers_slopeclass30_km = r.salmon_belowupstrbarriers_slopeclass30_km,
  steelhead_belowupstrbarriers_network_km = r.steelhead_belowupstrbarriers_network_km,
  steelhead_belowupstrbarriers_stream_km = r.steelhead_belowupstrbarriers_stream_km,
  steelhead_belowupstrbarriers_lakereservoir_ha = r.steelhead_belowupstrbarriers_lakereservoir_ha,
  steelhead_belowupstrbarriers_wetland_ha = r.steelhead_belowupstrbarriers_wetland_ha,
  steelhead_belowupstrbarriers_slopeclass03_km = r.steelhead_belowupstrbarriers_slopeclass03_km,
  steelhead_belowupstrbarriers_slopeclass05_km = r.steelhead_belowupstrbarriers_slopeclass05_km,
  steelhead_belowupstrbarriers_slopeclass08_km = r.steelhead_belowupstrbarriers_slopeclass08_km,
  steelhead_belowupstrbarriers_slopeclass15_km = r.steelhead_belowupstrbarriers_slopeclass15_km,
  steelhead_belowupstrbarriers_slopeclass22_km = r.steelhead_belowupstrbarriers_slopeclass22_km,
  steelhead_belowupstrbarriers_slopeclass30_km = r.steelhead_belowupstrbarriers_slopeclass30_km,
  wct_belowupstrbarriers_network_km = r.wct_belowupstrbarriers_network_km,
  wct_belowupstrbarriers_stream_km = r.wct_belowupstrbarriers_stream_km,
  wct_belowupstrbarriers_lakereservoir_ha = r.wct_belowupstrbarriers_lakereservoir_ha,
  wct_belowupstrbarriers_wetland_ha = r.wct_belowupstrbarriers_wetland_ha,
  wct_belowupstrbarriers_slopeclass03_km = r.wct_belowupstrbarriers_slopeclass03_km,
  wct_belowupstrbarriers_slopeclass05_km = r.wct_belowupstrbarriers_slopeclass05_km,
  wct_belowupstrbarriers_slopeclass08_km = r.wct_belowupstrbarriers_slopeclass08_km,
  wct_belowupstrbarriers_slopeclass15_km = r.wct_belowupstrbarriers_slopeclass15_km,
  wct_belowupstrbarriers_slopeclass22_km = r.wct_belowupstrbarriers_slopeclass22_km,
  wct_belowupstrbarriers_slopeclass30_km = r.wct_belowupstrbarriers_slopeclass30_km,
  ch_spawning_belowupstrbarriers_km = r.ch_spawning_belowupstrbarriers_km,
  ch_rearing_belowupstrbarriers_km = r.ch_rearing_belowupstrbarriers_km,
  co_spawning_belowupstrbarriers_km = r.co_spawning_belowupstrbarriers_km,
  co_rearing_belowupstrbarriers_km = r.co_rearing_belowupstrbarriers_km,
  sk_spawning_belowupstrbarriers_km = r.sk_spawning_belowupstrbarriers_km,
  sk_rearing_belowupstrbarriers_km = r.sk_rearing_belowupstrbarriers_km,
  st_spawning_belowupstrbarriers_km = r.st_spawning_belowupstrbarriers_km,
  st_rearing_belowupstrbarriers_km = r.st_rearing_belowupstrbarriers_km,
  wct_spawning_belowupstrbarriers_km = r.wct_spawning_belowupstrbarriers_km,
  wct_rearing_belowupstrbarriers_km = r.wct_rearing_belowupstrbarriers_km,
  all_spawning_belowupstrbarriers_km = r.all_spawning_belowupstrbarriers_km,
  all_rearing_belowupstrbarriers_km = r.all_rearing_belowupstrbarriers_km,
  all_spawningrearing_belowupstrbarriers_km = r.all_spawningrearing_belowupstrbarriers_km
FROM report r
WHERE p.{point_id} = r.{point_id};

-- also, populate map tile column
WITH tile AS
(
    SELECT
      a.{point_id},
      b.map_tile_display_name
    FROM {point_schema}.{point_table} a
    INNER JOIN whse_basemapping.dbm_mof_50k_grid b
    ON ST_Intersects(a.geom, b.geom)
)

UPDATE {point_schema}.{point_table} p
SET dbm_mof_50k_grid = t.map_tile_display_name
FROM tile t
WHERE p.{point_id} = t.{point_id};

-- ----------------------------------------------------------------------------------
-- what would be newly accessible (to resident WCT) if remediating a given barrier
-- (simply sum everything to all adjacent barriers)
ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_betweenbarriers_network_km double precision DEFAULT 0;
COMMENT ON COLUMN {point_schema}.{point_table}.wct_betweenbarriers_network_km IS 'Westslope Cutthroat Trout model, total length of potentially accessible stream network between crossing and all in-stream adjacent barriers';

ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_spawning_betweenbarriers_km double precision DEFAULT 0;
COMMENT ON COLUMN {point_schema}.{point_table}.wct_spawning_betweenbarriers_km IS 'Westslope Cutthroat Trout model, total length of spawning habitat between crossing and all in-stream adjacent barriers';

ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_rearing_betweenbarriers_km double precision DEFAULT 0;
COMMENT ON COLUMN {point_schema}.{point_table}.wct_rearing_betweenbarriers_km IS 'Westslope Cutthroat Trout model, total length of rearing habitat between crossing and all in-stream adjacent barriers';

ALTER TABLE {point_schema}.{point_table} ADD COLUMN IF NOT EXISTS wct_spawningrearing_betweenbarriers_km double precision DEFAULT 0;
COMMENT ON COLUMN {point_schema}.{point_table}.wct_spawningrearing_betweenbarriers_km IS 'Westslope Cutthroat Trout model, total length of spawning and rearing habitat between crossing and all in-stream adjacent barriers';


UPDATE {point_schema}.{point_table} p
SET wct_betweenbarriers_network_km = ROUND((p.wct_belowupstrbarriers_network_km + b.wct_belowupstrbarriers_network_km)::numeric, 2),
    wct_spawning_betweenbarriers_km = ROUND((p.wct_spawning_belowupstrbarriers_km + b.wct_spawning_belowupstrbarriers_km)::numeric, 2),
    wct_rearing_betweenbarriers_km = ROUND((p.wct_rearing_belowupstrbarriers_km + b.wct_rearing_belowupstrbarriers_km)::numeric, 2),
    wct_spawningrearing_betweenbarriers_km = ROUND((p.all_spawningrearing_belowupstrbarriers_km + b.all_spawningrearing_belowupstrbarriers_km)::numeric, 2)
FROM {point_schema}.{point_table} b
WHERE p.{dnstr_barriers_id}[1] = b.{point_id}
AND p.wct_network_km != 0
AND p.watershed_group_code = 'ELKR';

-- separate update for where there are no barriers downstream
UPDATE {point_schema}.{point_table}
SET wct_betweenbarriers_network_km = wct_belowupstrbarriers_network_km,
    wct_spawning_betweenbarriers_km = wct_spawning_belowupstrbarriers_km,
    wct_rearing_betweenbarriers_km = wct_rearing_belowupstrbarriers_km,
    wct_spawningrearing_betweenbarriers_km = all_spawningrearing_belowupstrbarriers_km
WHERE {dnstr_barriers_id} IS NULL
AND wct_network_km != 0
AND watershed_group_code = 'ELKR';
-- ----------------------------------------------------------------------------------