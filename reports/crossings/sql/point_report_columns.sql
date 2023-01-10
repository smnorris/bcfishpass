-- --------------------
-- ADD REQUIRED COLUMNS TO EXISTING TABLE
-- --------------------

ALTER TABLE bcfishpass.:point_table
  ADD COLUMN IF NOT EXISTS gradient                                                 double precision,
  ADD COLUMN IF NOT EXISTS total_network_km                                         double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_stream_km                                          double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_lakereservoir_ha                                   double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_wetland_ha                                         double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_slopeclass03_waterbodies_km                        double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_slopeclass03_km                                    double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_slopeclass05_km                                    double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_slopeclass08_km                                    double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_slopeclass15_km                                    double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_slopeclass22_km                                    double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_slopeclass30_km                                    double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_network_km                      double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_stream_km                       double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_lakereservoir_ha                double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_wetland_ha                      double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_slopeclass03_waterbodies_km     double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_slopeclass03_km                 double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_slopeclass05_km                 double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_slopeclass08_km                 double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_slopeclass15_km                 double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_slopeclass22_km                 double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_belowupstrbarriers_slopeclass30_km                 double precision DEFAULT 0,

  ADD COLUMN IF NOT EXISTS barriers_bt_dnstr                                    text,
  ADD COLUMN IF NOT EXISTS bt_network_km                                      double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_stream_km                                       double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_lakereservoir_ha                                double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_wetland_ha                                      double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_slopeclass03_waterbodies_km                     double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_slopeclass03_km                                 double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_slopeclass05_km                                 double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_slopeclass08_km                                 double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_slopeclass15_km                                 double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_slopeclass22_km                                 double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_slopeclass30_km                                 double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_belowupstrbarriers_network_km                   double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_belowupstrbarriers_stream_km                    double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_belowupstrbarriers_lakereservoir_ha             double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_belowupstrbarriers_wetland_ha                   double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_belowupstrbarriers_slopeclass03_waterbodies_km  double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_belowupstrbarriers_slopeclass03_km              double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_belowupstrbarriers_slopeclass05_km              double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_belowupstrbarriers_slopeclass08_km              double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_belowupstrbarriers_slopeclass15_km              double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_belowupstrbarriers_slopeclass22_km              double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_belowupstrbarriers_slopeclass30_km              double precision DEFAULT 0,

  ADD COLUMN IF NOT EXISTS barriers_ch_cm_co_pk_sk_dnstr                                    text,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_network_km                                      double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_stream_km                                       double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_lakereservoir_ha                                double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_wetland_ha                                      double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_slopeclass03_waterbodies_km                     double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_slopeclass03_km                                 double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_slopeclass05_km                                 double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_slopeclass08_km                                 double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_slopeclass15_km                                 double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_slopeclass22_km                                 double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_slopeclass30_km                                 double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_belowupstrbarriers_network_km                   double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_belowupstrbarriers_stream_km                    double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha             double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha                   double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km  double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km              double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km              double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km              double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km              double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km              double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km              double precision DEFAULT 0,

  ADD COLUMN IF NOT EXISTS barriers_st_dnstr                                          text,
  ADD COLUMN IF NOT EXISTS st_network_km                                            double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_stream_km                                             double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_lakereservoir_ha                                      double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_wetland_ha                                            double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_slopeclass03_waterbodies_km                           double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_slopeclass03_km                                       double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_slopeclass05_km                                       double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_slopeclass08_km                                       double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_slopeclass15_km                                       double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_slopeclass22_km                                       double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_slopeclass30_km                                       double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_belowupstrbarriers_network_km                         double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_belowupstrbarriers_stream_km                          double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_belowupstrbarriers_lakereservoir_ha                   double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_belowupstrbarriers_wetland_ha                         double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_belowupstrbarriers_slopeclass03_waterbodies_km        double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_belowupstrbarriers_slopeclass03_km                    double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_belowupstrbarriers_slopeclass05_km                    double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_belowupstrbarriers_slopeclass08_km                    double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_belowupstrbarriers_slopeclass15_km                    double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_belowupstrbarriers_slopeclass22_km                    double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_belowupstrbarriers_slopeclass30_km                    double precision DEFAULT 0,

  ADD COLUMN IF NOT EXISTS barriers_wct_dnstr                                         text,
  ADD COLUMN IF NOT EXISTS wct_network_km                                           double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_stream_km                                            double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_lakereservoir_ha                                     double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_wetland_ha                                           double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_slopeclass03_waterbodies_km                          double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_slopeclass03_km                                      double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_slopeclass05_km                                      double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_slopeclass08_km                                      double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_slopeclass15_km                                      double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_slopeclass22_km                                      double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_slopeclass30_km                                      double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_network_km                        double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_stream_km                         double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_lakereservoir_ha                  double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_wetland_ha                        double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass03_waterbodies_km       double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass03_km                   double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass05_km                   double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass08_km                   double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass15_km                   double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass22_km                   double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_belowupstrbarriers_slopeclass30_km                   double precision DEFAULT 0,

  ADD COLUMN IF NOT EXISTS bt_spawning_km                                          double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_rearing_km                                           double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_spawning_belowupstrbarriers_km                       double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS bt_rearing_belowupstrbarriers_km                        double precision DEFAULT 0,

  ADD COLUMN IF NOT EXISTS ch_spawning_km                                           double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_rearing_km                                            double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_spawning_belowupstrbarriers_km                        double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ch_rearing_belowupstrbarriers_km                         double precision DEFAULT 0,
  
  ADD COLUMN IF NOT EXISTS cm_spawning_km                                            double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS cm_spawning_belowupstrbarriers_km                        double precision DEFAULT 0,

  ADD COLUMN IF NOT EXISTS co_spawning_km                                           double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS co_rearing_km                                            double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS co_rearing_ha                                            double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS co_spawning_belowupstrbarriers_km                        double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS co_rearing_belowupstrbarriers_km                         double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS co_rearing_belowupstrbarriers_ha                         double precision DEFAULT 0,

  ADD COLUMN IF NOT EXISTS pk_spawning_km                                            double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS pk_spawning_belowupstrbarriers_km                        double precision DEFAULT 0,

  ADD COLUMN IF NOT EXISTS sk_spawning_km                                           double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS sk_rearing_km                                            double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS sk_rearing_ha                                            double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS sk_spawning_belowupstrbarriers_km                        double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS sk_rearing_belowupstrbarriers_km                         double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS sk_rearing_belowupstrbarriers_ha                         double precision DEFAULT 0,

  ADD COLUMN IF NOT EXISTS st_spawning_km                                           double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_rearing_km                                            double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_spawning_belowupstrbarriers_km                        double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS st_rearing_belowupstrbarriers_km                         double precision DEFAULT 0,

  ADD COLUMN IF NOT EXISTS wct_spawning_km                                          double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_rearing_km                                           double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_spawning_belowupstrbarriers_km                       double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_rearing_belowupstrbarriers_km                        double precision DEFAULT 0,

  ADD COLUMN IF NOT EXISTS all_spawning_km                                          double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS all_spawning_belowupstrbarriers_km                       double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS all_rearing_km                                           double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS all_rearing_belowupstrbarriers_km                        double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS all_spawningrearing_km                                   double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS all_spawningrearing_belowupstrbarriers_km                double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_betweenbarriers_network_km                           double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_spawning_betweenbarriers_km                          double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_rearing_betweenbarriers_km                           double precision DEFAULT 0,
  ADD COLUMN IF NOT EXISTS wct_spawningrearing_betweenbarriers_km                   double precision DEFAULT 0;
  


-- --------------------
-- ADD COMMENTS TO THE NEW COLUMNS
-- --------------------
COMMENT ON COLUMN bcfishpass.:point_table.gradient IS 'Stream slope at point';
COMMENT ON COLUMN bcfishpass.:point_table.total_network_km IS 'Total length of stream network upstream of point';
COMMENT ON COLUMN bcfishpass.:point_table.total_stream_km IS 'Total length of streams and rivers upstream of point (does not include network connectors in lakes etc)';
COMMENT ON COLUMN bcfishpass.:point_table.total_lakereservoir_ha IS 'Total area lakes and reservoirs upstream of point ';
COMMENT ON COLUMN bcfishpass.:point_table.total_wetland_ha IS 'Total area wetlands upstream of point ';
COMMENT ON COLUMN bcfishpass.:point_table.total_slopeclass03_waterbodies_km IS 'Total length of stream connectors (in waterbodies) potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.total_slopeclass03_km IS 'Total length of stream potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.total_slopeclass05_km IS 'Total length of stream potentially accessible upstream of point with slope 3-5%';
COMMENT ON COLUMN bcfishpass.:point_table.total_slopeclass08_km IS 'Total length of stream potentially accessible upstream of point with slope 5-8%';
COMMENT ON COLUMN bcfishpass.:point_table.total_slopeclass15_km IS 'Total length of stream potentially accessible upstream of point with slope 8-15%';
COMMENT ON COLUMN bcfishpass.:point_table.total_slopeclass22_km IS 'Total length of stream potentially accessible upstream of point with slope 15-22%';
COMMENT ON COLUMN bcfishpass.:point_table.total_slopeclass30_km IS 'Total length of stream potentially accessible upstream of point with slope 22-30%';
COMMENT ON COLUMN bcfishpass.:point_table.total_belowupstrbarriers_network_km IS 'Total length of stream network potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN bcfishpass.:point_table.total_belowupstrbarriers_stream_km IS 'Total length of streams and rivers potentially accessible upstream of point and below any additional upstream barriers (does not include network connectors in lakes etc)';
COMMENT ON COLUMN bcfishpass.:point_table.total_belowupstrbarriers_lakereservoir_ha IS 'Total area lakes and reservoirs potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN bcfishpass.:point_table.total_belowupstrbarriers_wetland_ha IS 'Total area wetlands potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN bcfishpass.:point_table.total_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total length of stream connectors (in waterbodies) potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.total_belowupstrbarriers_slopeclass03_km IS 'Total length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.total_belowupstrbarriers_slopeclass05_km IS 'Total length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 3-5%';
COMMENT ON COLUMN bcfishpass.:point_table.total_belowupstrbarriers_slopeclass08_km IS 'Total length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 5-8%';
COMMENT ON COLUMN bcfishpass.:point_table.total_belowupstrbarriers_slopeclass15_km IS 'Total length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 8-15%';
COMMENT ON COLUMN bcfishpass.:point_table.total_belowupstrbarriers_slopeclass22_km IS 'Total length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 15-22%';
COMMENT ON COLUMN bcfishpass.:point_table.total_belowupstrbarriers_slopeclass30_km IS 'Total length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 22-30%';

COMMENT ON COLUMN bcfishpass.:point_table.barriers_bt_dnstr IS 'Modelled accessibility to Bull Trout (25% max)';
COMMENT ON COLUMN bcfishpass.:point_table.bt_network_km IS 'Bull Trout model, total length of stream network potentially accessible upstream of point';
COMMENT ON COLUMN bcfishpass.:point_table.bt_stream_km IS 'Bull Trout model, total length of streams and rivers potentially accessible upstream of point  (does not include network connectors in lakes etc)';
COMMENT ON COLUMN bcfishpass.:point_table.bt_lakereservoir_ha IS 'Bull Trout model, total area lakes and reservoirs potentially accessible upstream of point ';
COMMENT ON COLUMN bcfishpass.:point_table.bt_wetland_ha IS 'Bull Trout model, total area wetlands potentially accessible upstream of point ';
COMMENT ON COLUMN bcfishpass.:point_table.bt_slopeclass03_waterbodies_km IS 'Bull Trout model, length of stream connectors (in waterbodies) potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.bt_slopeclass03_km IS 'Bull Trout model, length of stream potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.bt_slopeclass05_km IS 'Bull Trout model, length of stream potentially accessible upstream of point with slope 3-5%';
COMMENT ON COLUMN bcfishpass.:point_table.bt_slopeclass08_km IS 'Bull Trout model, length of stream potentially accessible upstream of point with slope 5-8%';
COMMENT ON COLUMN bcfishpass.:point_table.bt_slopeclass15_km IS 'Bull Trout model, length of stream potentially accessible upstream of point with slope 8-15%';
COMMENT ON COLUMN bcfishpass.:point_table.bt_slopeclass22_km IS 'Bull Trout model, length of stream potentially accessible upstream of point with slope 15-22%';
COMMENT ON COLUMN bcfishpass.:point_table.bt_slopeclass30_km IS 'Bull Trout model, length of stream potentially accessible upstream of point with slope 22-30%';
COMMENT ON COLUMN bcfishpass.:point_table.bt_belowupstrbarriers_network_km IS 'Bull Trout model, total length of stream network potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN bcfishpass.:point_table.bt_belowupstrbarriers_stream_km IS 'Bull Trout model, total length of streams and rivers potentially accessible upstream of point and below any additional upstream barriers (does not include network connectors in lakes etc)';
COMMENT ON COLUMN bcfishpass.:point_table.bt_belowupstrbarriers_lakereservoir_ha IS 'Bull Trout model, total area lakes and reservoirs potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN bcfishpass.:point_table.bt_belowupstrbarriers_wetland_ha IS 'Bull Trout model, total area wetlands potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN bcfishpass.:point_table.bt_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Bull Trout model, length of stream connectors (in waterbodies) potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.bt_belowupstrbarriers_slopeclass03_km IS 'Bull Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.bt_belowupstrbarriers_slopeclass05_km IS 'Bull Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 3-5%';
COMMENT ON COLUMN bcfishpass.:point_table.bt_belowupstrbarriers_slopeclass08_km IS 'Bull Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 5-8%';
COMMENT ON COLUMN bcfishpass.:point_table.bt_belowupstrbarriers_slopeclass15_km IS 'Bull Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 8-15%';
COMMENT ON COLUMN bcfishpass.:point_table.bt_belowupstrbarriers_slopeclass22_km IS 'Bull Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 15-22%';
COMMENT ON COLUMN bcfishpass.:point_table.bt_belowupstrbarriers_slopeclass30_km IS 'Bull Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 22-30%';

COMMENT ON COLUMN bcfishpass.:point_table.barriers_ch_cm_co_pk_sk_dnstr IS 'Modelled accessibility to Pacific Salmon (CH/CM/CO/PK/SK, 15% max)';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_network_km IS 'Pacific salmon model (CH/CM/CO/PK/SK), total length of stream network potentially accessible upstream of point';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_stream_km IS 'Pacific salmon model (CH/CM/CO/PK/SK), total length of streams and rivers potentially accessible upstream of point  (does not include network connectors in lakes etc)';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_lakereservoir_ha IS 'Pacific salmon model (CH/CM/CO/PK/SK), total area lakes and reservoirs potentially accessible upstream of point ';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_wetland_ha IS 'Pacific salmon model (CH/CM/CO/PK/SK), total area wetlands potentially accessible upstream of point ';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_slopeclass03_waterbodies_km IS 'Pacific salmon model (CH/CM/CO/PK/SK), length of stream connectors (in waterbodies) potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_slopeclass03_km IS 'Pacific salmon model (CH/CM/CO/PK/SK), length of stream potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_slopeclass05_km IS 'Pacific salmon model (CH/CM/CO/PK/SK), length of stream potentially accessible upstream of point with slope 3-5%';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_slopeclass08_km IS 'Pacific salmon model (CH/CM/CO/PK/SK), length of stream potentially accessible upstream of point with slope 5-8%';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_slopeclass15_km IS 'Pacific salmon model (CH/CM/CO/PK/SK), length of stream potentially accessible upstream of point with slope 8-15%';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_slopeclass22_km IS 'Pacific salmon model (CH/CM/CO/PK/SK), length of stream potentially accessible upstream of point with slope 15-22%';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_slopeclass30_km IS 'Pacific salmon model (CH/CM/CO/PK/SK), length of stream potentially accessible upstream of point with slope 22-30%';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_belowupstrbarriers_network_km IS 'Pacific salmon model (CH/CM/CO/PK/SK), total length of stream network potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_belowupstrbarriers_stream_km IS 'Pacific salmon model (CH/CM/CO/PK/SK), total length of streams and rivers potentially accessible upstream of point and below any additional upstream barriers (does not include network connectors in lakes etc)';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha IS 'Pacific salmon model (CH/CM/CO/PK/SK), total area lakes and reservoirs potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha IS 'Pacific salmon model (CH/CM/CO/PK/SK), total area wetlands potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Pacific salmon model (CH/CM/CO/PK/SK), length of stream connectors (in waterbodies) potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km IS 'Pacific salmon model (CH/CM/CO/PK/SK), length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km IS 'Pacific salmon model (CH/CM/CO/PK/SK), length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 3-5%';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km IS 'Pacific salmon model (CH/CM/CO/PK/SK), length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 5-8%';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km IS 'Pacific salmon model (CH/CM/CO/PK/SK), length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 8-15%';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km IS 'Pacific salmon model (CH/CM/CO/PK/SK), length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 15-22%';
COMMENT ON COLUMN bcfishpass.:point_table.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km IS 'Pacific salmon model (CH/CM/CO/PK/SK), length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 22-30%';

COMMENT ON COLUMN bcfishpass.:point_table.barriers_st_dnstr IS 'Modelled accessibility to Steelhead (20% max)';
COMMENT ON COLUMN bcfishpass.:point_table.st_network_km IS 'Steelhead model, total length of stream network potentially accessible upstream of point';
COMMENT ON COLUMN bcfishpass.:point_table.st_stream_km IS 'Steelhead model, total length of streams and rivers potentially accessible upstream of point  (does not include network connectors in lakes etc)';
COMMENT ON COLUMN bcfishpass.:point_table.st_lakereservoir_ha IS 'Steelhead model, total area lakes and reservoirs potentially accessible upstream of point ';
COMMENT ON COLUMN bcfishpass.:point_table.st_wetland_ha IS 'Steelhead model, total area wetlands potentially accessible upstream of point ';
COMMENT ON COLUMN bcfishpass.:point_table.st_slopeclass03_waterbodies_km IS 'Steelhead model, length of stream connectors (in waterbodies) potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.st_slopeclass03_km IS 'Steelhead model, length of stream potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.st_slopeclass05_km IS 'Steelhead model, length of stream potentially accessible upstream of point with slope 3-5%';
COMMENT ON COLUMN bcfishpass.:point_table.st_slopeclass08_km IS 'Steelhead model, length of stream potentially accessible upstream of point with slope 5-8%';
COMMENT ON COLUMN bcfishpass.:point_table.st_slopeclass15_km IS 'Steelhead model, length of stream potentially accessible upstream of point with slope 8-15%';
COMMENT ON COLUMN bcfishpass.:point_table.st_slopeclass22_km IS 'Steelhead model, length of stream potentially accessible upstream of point with slope 15-22%';
COMMENT ON COLUMN bcfishpass.:point_table.st_slopeclass30_km IS 'Steelhead model, length of stream potentially accessible upstream of point with slope 22-30%';
COMMENT ON COLUMN bcfishpass.:point_table.st_belowupstrbarriers_network_km IS 'Steelhead model, total length of stream network potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN bcfishpass.:point_table.st_belowupstrbarriers_stream_km IS 'Steelhead model, total length of streams and rivers potentially accessible upstream of point and below any additional upstream barriers (does not include network connectors in lakes etc)';
COMMENT ON COLUMN bcfishpass.:point_table.st_belowupstrbarriers_lakereservoir_ha IS 'Steelhead model, total area lakes and reservoirs potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN bcfishpass.:point_table.st_belowupstrbarriers_wetland_ha IS 'Steelhead model, total area wetlands potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN bcfishpass.:point_table.st_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Steelhead model, length of stream connectors (in waterbodies) potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.st_belowupstrbarriers_slopeclass03_km IS 'Steelhead model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.st_belowupstrbarriers_slopeclass05_km IS 'Steelhead model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 3-5%';
COMMENT ON COLUMN bcfishpass.:point_table.st_belowupstrbarriers_slopeclass08_km IS 'Steelhead model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 5-8%';
COMMENT ON COLUMN bcfishpass.:point_table.st_belowupstrbarriers_slopeclass15_km IS 'Steelhead model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 8-15%';
COMMENT ON COLUMN bcfishpass.:point_table.st_belowupstrbarriers_slopeclass22_km IS 'Steelhead model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 15-22%';
COMMENT ON COLUMN bcfishpass.:point_table.st_belowupstrbarriers_slopeclass30_km IS 'Steelhead model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 22-30%';
COMMENT ON COLUMN bcfishpass.:point_table.barriers_wct_dnstr IS 'Modelled accessibility to West Slope Cutthroat Trout (20% max or downstream of known WCT observation)';     ;
COMMENT ON COLUMN bcfishpass.:point_table.wct_network_km IS 'Westslope Cuthroat Trout model, total length of stream network potentially accessible upstream of point';
COMMENT ON COLUMN bcfishpass.:point_table.wct_stream_km IS 'Westslope Cuthroat Trout model, total length of streams and rivers potentially accessible upstream of point  (does not include network connectors in lakes etc)';
COMMENT ON COLUMN bcfishpass.:point_table.wct_lakereservoir_ha IS 'Westslope Cuthroat Trout model, total area lakes and reservoirs potentially accessible upstream of point ';
COMMENT ON COLUMN bcfishpass.:point_table.wct_wetland_ha IS 'Westslope Cuthroat Trout model, total area wetlands potentially accessible upstream of point ';
COMMENT ON COLUMN bcfishpass.:point_table.wct_slopeclass03_waterbodies_km IS 'Westslope Cutthroat Trout model, length of stream connectors (in waterbodies) potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.wct_slopeclass03_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.wct_slopeclass05_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point with slope 3-5%';
COMMENT ON COLUMN bcfishpass.:point_table.wct_slopeclass08_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point with slope 5-8%';
COMMENT ON COLUMN bcfishpass.:point_table.wct_slopeclass15_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point with slope 8-15%';
COMMENT ON COLUMN bcfishpass.:point_table.wct_slopeclass22_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point with slope 15-22%';
COMMENT ON COLUMN bcfishpass.:point_table.wct_slopeclass30_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point with slope 22-30%';
COMMENT ON COLUMN bcfishpass.:point_table.wct_belowupstrbarriers_network_km IS 'Westslope Cutthroat Trout model, total length of stream network potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN bcfishpass.:point_table.wct_belowupstrbarriers_stream_km IS 'Westslope Cuthroat Trout model, total length of streams and rivers potentially accessible upstream of point and below any additional upstream barriers (does not include network connectors in lakes etc)';
COMMENT ON COLUMN bcfishpass.:point_table.wct_belowupstrbarriers_lakereservoir_ha IS 'Westslope Cutthroat Trout model, total area lakes and reservoirs potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN bcfishpass.:point_table.wct_belowupstrbarriers_wetland_ha IS 'Westslope Cutthroat Trout model, total area wetlands potentially accessible upstream of point and below any additional upstream barriers';
COMMENT ON COLUMN bcfishpass.:point_table.wct_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Westslope Cutthroat Trout model, length of stream connectors (in waterbodies) potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.wct_belowupstrbarriers_slopeclass03_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 0-3%';
COMMENT ON COLUMN bcfishpass.:point_table.wct_belowupstrbarriers_slopeclass05_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 3-5%';
COMMENT ON COLUMN bcfishpass.:point_table.wct_belowupstrbarriers_slopeclass08_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 5-8%';
COMMENT ON COLUMN bcfishpass.:point_table.wct_belowupstrbarriers_slopeclass15_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 8-15%';
COMMENT ON COLUMN bcfishpass.:point_table.wct_belowupstrbarriers_slopeclass22_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 15-22%';
COMMENT ON COLUMN bcfishpass.:point_table.wct_belowupstrbarriers_slopeclass30_km IS 'Westslope Cutthroat Trout model, length of stream potentially accessible upstream of point and below any additional upstream barriers, with slope 22-30%';

COMMENT ON COLUMN bcfishpass.:point_table.ch_spawning_km IS 'Length of stream upstream of point modelled as potential Chinook spawning habitat';
COMMENT ON COLUMN bcfishpass.:point_table.ch_rearing_km IS 'Length of stream upstream of point modelled as potential Chinook rearing habitat';
COMMENT ON COLUMN bcfishpass.:point_table.ch_spawning_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Chinook spawning habitat';
COMMENT ON COLUMN bcfishpass.:point_table.ch_rearing_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Chinook rearing habitat';
COMMENT ON COLUMN bcfishpass.:point_table.co_spawning_km IS 'Length of stream upstream of point modelled as potential Coho spawning habitat';
COMMENT ON COLUMN bcfishpass.:point_table.co_rearing_km IS 'Length of stream upstream of point modelled as potential Coho rearing habitat';
COMMENT ON COLUMN bcfishpass.:point_table.co_rearing_ha IS 'Area of wetlands upstream of point modelled as potential Coho rearing habitat';
COMMENT ON COLUMN bcfishpass.:point_table.co_spawning_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Coho spawning habitat';
COMMENT ON COLUMN bcfishpass.:point_table.co_rearing_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Coho rearing habitat';
COMMENT ON COLUMN bcfishpass.:point_table.co_rearing_belowupstrbarriers_ha IS 'Area of wetlands upstream of point and below any additional upstream barriers, modelled as potential Coho rearing habitat';
COMMENT ON COLUMN bcfishpass.:point_table.sk_spawning_km IS 'Length of stream upstream of point modelled as potential Sockeye spawning habitat';
COMMENT ON COLUMN bcfishpass.:point_table.sk_rearing_km IS 'Length of stream upstream of point modelled as potential Sockeye rearing habitat';
COMMENT ON COLUMN bcfishpass.:point_table.sk_rearing_ha IS 'Area of lakes upstream of point modelled as potential Sockeye rearing habitat';
COMMENT ON COLUMN bcfishpass.:point_table.sk_spawning_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Sockeye spawning habitat';
COMMENT ON COLUMN bcfishpass.:point_table.sk_rearing_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Sockeye rearing habitat';
COMMENT ON COLUMN bcfishpass.:point_table.sk_rearing_belowupstrbarriers_ha IS 'Area of lakes upstream of point and below any additional upstream barriers, modelled as potential Sockeye rearing habitat';
COMMENT ON COLUMN bcfishpass.:point_table.st_spawning_km IS 'Length of stream upstream of point modelled as potential Steelhead spawning habitat';
COMMENT ON COLUMN bcfishpass.:point_table.st_rearing_km IS 'Length of stream upstream of point modelled as potential Steelhead rearing habitat';
COMMENT ON COLUMN bcfishpass.:point_table.st_spawning_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Steelhead spawning habitat';
COMMENT ON COLUMN bcfishpass.:point_table.st_rearing_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Steelhead rearing habitat';

COMMENT ON COLUMN bcfishpass.:point_table.wct_spawning_km IS 'Length of stream upstream of point modelled as potential Westslope Cutthroat spawning habitat';
COMMENT ON COLUMN bcfishpass.:point_table.wct_rearing_km IS 'Length of stream upstream of point modelled as potential Westslope Cutthroat rearing habitat';
COMMENT ON COLUMN bcfishpass.:point_table.wct_spawning_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Westslope Cutthroat spawning habitat';
COMMENT ON COLUMN bcfishpass.:point_table.wct_rearing_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Westslope Cutthroat rearing habitat';

COMMENT ON COLUMN bcfishpass.:point_table.bt_spawning_km IS 'Length of stream upstream of point modelled as potential Bull Trout spawning habitat';
COMMENT ON COLUMN bcfishpass.:point_table.bt_rearing_km IS 'Length of stream upstream of point modelled as potential Bull Trout rearing habitat';
COMMENT ON COLUMN bcfishpass.:point_table.bt_spawning_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Bull Trout spawning habitat';
COMMENT ON COLUMN bcfishpass.:point_table.bt_rearing_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential Bull Trout rearing habitat';

COMMENT ON COLUMN bcfishpass.:point_table.all_spawning_km IS 'Length of stream upstream of point modelled as potential spawning habitat for all modelled species (currently BT,CH,CO,SK,ST,WCT)';
COMMENT ON COLUMN bcfishpass.:point_table.all_spawning_belowupstrbarriers_km IS 'Length of stream upstream of point modelled as potential rearing habitat for all modelled species (currently BT,CH,CO,SK,ST,WCT)';
COMMENT ON COLUMN bcfishpass.:point_table.all_rearing_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential spawning habitat for all modelled species (currently BT,CH,CO,SK,ST,WCT)';
COMMENT ON COLUMN bcfishpass.:point_table.all_rearing_belowupstrbarriers_km IS 'Length of stream upstream of point and below any additional upstream barriers, modelled as potential rearing habitat (all CH,CO,SK,ST,WCT)';
COMMENT ON COLUMN bcfishpass.:point_table.all_spawningrearing_km IS 'Length of all spawning and rearing habitat upstream of point';
COMMENT ON COLUMN bcfishpass.:point_table.all_spawningrearing_belowupstrbarriers_km IS 'Length of all spawning and rearing habitat upstream of point';
COMMENT ON COLUMN bcfishpass.:point_table.wct_betweenbarriers_network_km IS 'Westslope Cutthroat Trout model, total length of potentially accessible stream network between crossing and all in-stream adjacent barriers';
COMMENT ON COLUMN bcfishpass.:point_table.wct_spawning_betweenbarriers_km IS 'Westslope Cutthroat Trout model, total length of spawning habitat between crossing and all in-stream adjacent barriers';
COMMENT ON COLUMN bcfishpass.:point_table.wct_rearing_betweenbarriers_km IS 'Westslope Cutthroat Trout model, total length of rearing habitat between crossing and all in-stream adjacent barriers';
COMMENT ON COLUMN bcfishpass.:point_table.wct_spawningrearing_betweenbarriers_km IS 'Westslope Cutthroat Trout model, total length of spawning and rearing habitat between crossing and all in-stream adjacent barriers';
