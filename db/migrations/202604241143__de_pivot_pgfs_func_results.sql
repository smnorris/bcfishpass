-- pgfs results can be filtered with CQL, there is no need for any args to the function

BEGIN;
 

  DROP FUNCTION IF EXISTS postgisftw.wcrp_habitat_connectivity_status_v2;


  CREATE OR REPLACE FUNCTION postgisftw.wcrp_habitat_connectivity_status_v2()

  RETURNS TABLE(
  	  wcrp                                                    text,
      watershed_group_code                                    text,
      habitat_connectivity_type                               text,
      habitat_connectivity_value                              numeric
  )

  LANGUAGE 'plpgsql'
  STABLE PARALLEL SAFE

  AS $$
  
  BEGIN
  RETURN QUERY
  
    SELECT
      t.wcrp,
      t.watershed_group_code,
      col.habitat_connectivity_type,
      col.habitat_connectivity_value
    FROM bcfishpass.wcrp_habitat_connectivity_status_vw_v2 t
    CROSS JOIN LATERAL (
      VALUES
        ('total_spawning_ch',                    total_spawning_ch),
        ('total_spawning_co',                    total_spawning_co),
        ('total_spawning_sk',                    total_spawning_sk),
        ('total_spawning_st',                    total_spawning_st),
        ('total_spawning_wct',                   total_spawning_wct),
        ('total_rearing_ch',                     total_rearing_ch),
        ('total_rearing_co',                     total_rearing_co),
        ('total_rearing_sk',                     total_rearing_sk),
        ('total_rearing_st',                     total_rearing_st),
        ('total_rearing_wct',                    total_rearing_wct),
        ('total_spawningrearing_ch',             total_spawningrearing_ch),
        ('total_spawningrearing_co',             total_spawningrearing_co),
        ('total_spawningrearing_sk',             total_spawningrearing_sk),
        ('total_spawningrearing_st',             total_spawningrearing_st),
        ('total_spawningrearing_wct',            total_spawningrearing_wct),
        ('total_spawning_all',                   total_spawning_all),
        ('total_rearing_all',                    total_rearing_all),
        ('total_spawningrearing_all',            total_spawningrearing_all),
        ('accessible_spawning_ch',               accessible_spawning_ch),
        ('accessible_spawning_co',               accessible_spawning_co),
        ('accessible_spawning_sk',               accessible_spawning_sk),
        ('accessible_spawning_st',               accessible_spawning_st),
        ('accessible_spawning_wct',              accessible_spawning_wct),
        ('accessible_rearing_ch',                accessible_rearing_ch),
        ('accessible_rearing_co',                accessible_rearing_co),
        ('accessible_rearing_sk',                accessible_rearing_sk),
        ('accessible_rearing_st',                accessible_rearing_st),
        ('accessible_rearing_wct',               accessible_rearing_wct),
        ('accessible_spawningrearing_ch',        accessible_spawningrearing_ch),
        ('accessible_spawningrearing_co',        accessible_spawningrearing_co),
        ('accessible_spawningrearing_sk',        accessible_spawningrearing_sk),
        ('accessible_spawningrearing_st',        accessible_spawningrearing_st),
        ('accessible_spawningrearing_wct',       accessible_spawningrearing_wct),
        ('accessible_spawning_all',              accessible_spawning_all),
        ('accessible_rearing_all',               accessible_rearing_all),
        ('accessible_spawningrearing_all',       accessible_spawningrearing_all),
        ('disconnected_spawning_ch',             disconnected_spawning_ch),
        ('disconnected_spawning_co',             disconnected_spawning_co),
        ('disconnected_spawning_sk',             disconnected_spawning_sk),
        ('disconnected_spawning_st',             disconnected_spawning_st),
        ('disconnected_spawning_wct',            disconnected_spawning_wct),
        ('disconnected_rearing_ch',              disconnected_rearing_ch),
        ('disconnected_rearing_co',              disconnected_rearing_co),
        ('disconnected_rearing_sk',              disconnected_rearing_sk),
        ('disconnected_rearing_st',              disconnected_rearing_st),
        ('disconnected_rearing_wct',             disconnected_rearing_wct),
        ('disconnected_spawningrearing_ch',      disconnected_spawningrearing_ch),
        ('disconnected_spawningrearing_co',      disconnected_spawningrearing_co),
        ('disconnected_spawningrearing_sk',      disconnected_spawningrearing_sk),
        ('disconnected_spawningrearing_st',      disconnected_spawningrearing_st),
        ('disconnected_spawningrearing_wct',     disconnected_spawningrearing_wct),
        ('disconnected_spawning_all',            disconnected_spawning_all),
        ('disconnected_rearing_all',             disconnected_rearing_all),
        ('disconnected_spawningrearing_all',     disconnected_spawningrearing_all),
        ('pct_accessible_spawning_ch',           pct_accessible_spawning_ch),
        ('pct_accessible_spawning_co',           pct_accessible_spawning_co),
        ('pct_accessible_spawning_sk',           pct_accessible_spawning_sk),
        ('pct_accessible_spawning_st',           pct_accessible_spawning_st),
        ('pct_accessible_spawning_wct',          pct_accessible_spawning_wct),
        ('pct_accessible_rearing_ch',            pct_accessible_rearing_ch),
        ('pct_accessible_rearing_co',            pct_accessible_rearing_co),
        ('pct_accessible_rearing_sk',            pct_accessible_rearing_sk),
        ('pct_accessible_rearing_st',            pct_accessible_rearing_st),
        ('pct_accessible_rearing_wct',           pct_accessible_rearing_wct),
        ('pct_accessible_spawningrearing_ch',    pct_accessible_spawningrearing_ch),
        ('pct_accessible_spawningrearing_co',    pct_accessible_spawningrearing_co),
        ('pct_accessible_spawningrearing_sk',    pct_accessible_spawningrearing_sk),
        ('pct_accessible_spawningrearing_st',    pct_accessible_spawningrearing_st),
        ('pct_accessible_spawningrearing_wct',   pct_accessible_spawningrearing_wct),
        ('pct_accessible_spawning_all',          pct_accessible_spawning_all),
        ('pct_accessible_rearing_all',           pct_accessible_rearing_all),
        ('pct_accessible_spawningrearing_all',   pct_accessible_spawningrearing_all)
    ) AS col(habitat_connectivity_type, habitat_connectivity_value)
    WHERE col.habitat_connectivity_value IS NOT NULL;

  END
  $$;

  COMMENT ON FUNCTION postgisftw.wcrp_habitat_connectivity_status_v2 IS
  'For each WCRP / watershed group, return total/accessible lengths and percentage accessible 
  for habitat types of interest for that plan';

  REVOKE EXECUTE ON FUNCTION postgisftw.wcrp_habitat_connectivity_status_v2 FROM public;

  -- select * from postgisftw.wcrp_habitat_connectivity_status_v2()

 
COMMIT;