-- load pre-computed precip/discharge/channel width from file
\copy bcfishpass.discharge FROM data/discharge.csv delimiter ',' csv header;
\copy bcfishpass.mean_annual_precip FROM data/mean_annual_precip.csv delimiter ',' csv header;
\copy bcfishpass.channel_width FROM data/channel_width.csv delimiter ',' csv header;