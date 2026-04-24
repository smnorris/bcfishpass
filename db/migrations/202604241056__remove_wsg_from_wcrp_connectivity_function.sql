-- pgfs results can be filtered with CQL, there is no need for any args to the function

BEGIN;
 


  DROP FUNCTION IF EXISTS postgisftw.wcrp_habitat_connectivity_status_v2;



  CREATE OR REPLACE FUNCTION postgisftw.wcrp_habitat_connectivity_status_v2()

  RETURNS TABLE(
  	  wcrp                                                    text,
      watershed_group_code                                    text,
      total_spawning_ch                                       numeric,
      total_spawning_co                                       numeric,
      total_spawning_sk                                       numeric,
      total_spawning_st                                       numeric,
      total_spawning_wct                                      numeric,
      total_rearing_ch                                        numeric,
      total_rearing_co                                        numeric,
      total_rearing_sk                                        numeric,
      total_rearing_st                                        numeric,
      total_rearing_wct                                       numeric,
      total_spawningrearing_ch                                numeric,
      total_spawningrearing_co                                numeric,
      total_spawningrearing_sk                                numeric,
      total_spawningrearing_st                                numeric,
      total_spawningrearing_wct                               numeric,
      total_spawning_all                                      numeric,
      total_rearing_all                                       numeric,
      total_spawningrearing_all                               numeric,

      accessible_spawning_ch                                  numeric,
      accessible_spawning_co                                  numeric,
      accessible_spawning_sk                                  numeric,
      accessible_spawning_st                                  numeric,
      accessible_spawning_wct                                 numeric,
      accessible_rearing_ch                                   numeric,
      accessible_rearing_co                                   numeric,
      accessible_rearing_sk                                   numeric,
      accessible_rearing_st                                   numeric,
      accessible_rearing_wct                                  numeric,
      accessible_spawningrearing_ch                           numeric,
      accessible_spawningrearing_co                           numeric,
      accessible_spawningrearing_sk                           numeric,
      accessible_spawningrearing_st                           numeric,
      accessible_spawningrearing_wct                          numeric,
      accessible_spawning_all                                 numeric,
      accessible_rearing_all                                  numeric,
      accessible_spawningrearing_all                          numeric,

      disconnected_spawning_ch                                numeric,
      disconnected_spawning_co                                numeric,
      disconnected_spawning_sk                                numeric,
      disconnected_spawning_st                                numeric,
      disconnected_spawning_wct                               numeric,
      disconnected_rearing_ch                                 numeric,
      disconnected_rearing_co                                 numeric,
      disconnected_rearing_sk                                 numeric,
      disconnected_rearing_st                                 numeric,
      disconnected_rearing_wct                                numeric,
      disconnected_spawningrearing_ch                         numeric,
      disconnected_spawningrearing_co                         numeric,
      disconnected_spawningrearing_sk                         numeric,
      disconnected_spawningrearing_st                         numeric,
      disconnected_spawningrearing_wct                        numeric,
      disconnected_spawning_all                               numeric,
      disconnected_rearing_all                                numeric,
      disconnected_spawningrearing_all                        numeric,

      pct_accessible_spawning_ch                              numeric,
      pct_accessible_spawning_co                              numeric,
      pct_accessible_spawning_sk                              numeric,
      pct_accessible_spawning_st                              numeric,
      pct_accessible_spawning_wct                             numeric,
      pct_accessible_rearing_ch                               numeric,
      pct_accessible_rearing_co                               numeric,
      pct_accessible_rearing_sk                               numeric,
      pct_accessible_rearing_st                               numeric,
      pct_accessible_rearing_wct                              numeric,
      pct_accessible_spawningrearing_ch                       numeric,
      pct_accessible_spawningrearing_co                       numeric,
      pct_accessible_spawningrearing_sk                       numeric,
      pct_accessible_spawningrearing_st                       numeric,
      pct_accessible_spawningrearing_wct                      numeric,
      pct_accessible_spawning_all                             numeric,
      pct_accessible_rearing_all                              numeric,
      pct_accessible_spawningrearing_all                      numeric
  )

  LANGUAGE 'plpgsql'
  STABLE PARALLEL SAFE

  AS $$

  DECLARE
      v_wcrp                 text := wcrp;
      v_watershed_group_code text := p_watershed_group_code;

  BEGIN
  RETURN QUERY
  
  SELECT * FROM bcfishpass.wcrp_habitat_connectivity_status_vw_v2;

  END
  $$;

  COMMENT ON FUNCTION postgisftw.wcrp_habitat_connectivity_status_v2 IS
  'For each WCRP / watershed group, return total/accessible lengths and percentage accessible for habitat types spawning; rearing; spawning and/or rearing 
  per target species and for all target species.';

  REVOKE EXECUTE ON FUNCTION postgisftw.wcrp_habitat_connectivity_status_v2 FROM public;

  -- select * from postgisftw.wcrp_habitat_connectivity_status_v2()

 
COMMIT;
