-- log habitat connectivity status

BEGIN;

  drop table if exists bcfishpass.log_wcrp_habitat_connectivity cascade;

  create table bcfishpass.log_wcrp_habitat_connectivity (
   model_run_id                                             integer references bcfishpass.log(model_run_id),
   wcrp                                                     text,
   watershed_group_code                                     text,
   
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

   accessible_spawning_ch                                       numeric,
   accessible_spawning_co                                       numeric,
   accessible_spawning_sk                                       numeric,
   accessible_spawning_st                                       numeric,
   accessible_spawning_wct                                      numeric,
   
   accessible_rearing_ch                                        numeric,
   accessible_rearing_co                                        numeric,
   accessible_rearing_sk                                        numeric,
   accessible_rearing_st                                        numeric,
   accessible_rearing_wct                                       numeric,

   accessible_spawningrearing_ch                                numeric,
   accessible_spawningrearing_co                                numeric,
   accessible_spawningrearing_sk                                numeric,
   accessible_spawningrearing_st                                numeric,
   accessible_spawningrearing_wct                               numeric,

   accessible_spawning_all                                      numeric,
   accessible_rearing_all                                       numeric,
   accessible_spawningrearing_all                               numeric,
  
   primary key (model_run_id, wcrp, watershed_group_code)
);


  -- view of current habitat connecitvity status, plus percentages
  drop view if exists bcfishpass.wcrp_habitat_connectivity_status_vw;

  create view bcfishpass.wcrp_habitat_connectivity_status_vw as
  select distinct on (wcrp, watershed_group_code)
    wcrp,
    watershed_group_code,

    round(total_spawning_ch, 2) as total_spawning_ch,
    round(total_spawning_co, 2) as total_spawning_co,
    round(total_spawning_sk, 2) as total_spawning_sk,
    round(total_spawning_st, 2) as total_spawning_st,
    round(total_spawning_wct, 2) as total_spawning_wct,
    round(total_rearing_ch, 2) as total_rearing_ch,
    round(total_rearing_co, 2) as total_rearing_co,
    round(total_rearing_sk, 2) as total_rearing_sk,
    round(total_rearing_st, 2) as total_rearing_st,
    round(total_rearing_wct, 2) as total_rearing_wct,
    round(total_spawningrearing_ch, 2) as total_spawningrearing_ch,
    round(total_spawningrearing_co, 2) as total_spawningrearing_co,
    round(total_spawningrearing_sk, 2) as total_spawningrearing_sk,
    round(total_spawningrearing_st, 2) as total_spawningrearing_st,
    round(total_spawningrearing_wct, 2) as total_spawningrearing_wct,
    round(total_spawning_all, 2) as total_spawning_all,
    round(total_rearing_all, 2) as total_rearing_all,
    round(total_spawningrearing_all, 2) as total_spawningrearing_all,
    
    round(accessible_spawning_ch, 2) as accessible_spawning_ch,
    round(accessible_spawning_co, 2) as accessible_spawning_co,
    round(accessible_spawning_sk, 2) as accessible_spawning_sk,
    round(accessible_spawning_st, 2) as accessible_spawning_st,
    round(accessible_spawning_wct, 2) as accessible_spawning_wct,
    round(accessible_rearing_ch, 2) as accessible_rearing_ch,
    round(accessible_rearing_co, 2) as accessible_rearing_co,
    round(accessible_rearing_sk, 2) as accessible_rearing_sk,
    round(accessible_rearing_st, 2) as accessible_rearing_st,
    round(accessible_rearing_wct, 2) as accessible_rearing_wct,
    round(accessible_spawningrearing_ch, 2) as accessible_spawningrearing_ch,
    round(accessible_spawningrearing_co, 2) as accessible_spawningrearing_co,
    round(accessible_spawningrearing_sk, 2) as accessible_spawningrearing_sk,
    round(accessible_spawningrearing_st, 2) as accessible_spawningrearing_st,
    round(accessible_spawningrearing_wct, 2) as accessible_spawningrearing_wct,
    round(accessible_spawning_all, 2) as accessible_spawning_all,
    round(accessible_rearing_all, 2) as accessible_rearing_all,
    round(accessible_spawningrearing_all, 2) as accessible_spawningrearing_all,

    round(total_spawning_ch - accessible_spawning_ch, 2) as disconnected_spawning_ch,
    round(total_spawning_co - accessible_spawning_co, 2) as disconnected_spawning_co,
    round(total_spawning_sk - accessible_spawning_sk, 2) as disconnected_spawning_sk,
    round(total_spawning_st - accessible_spawning_st, 2) as disconnected_spawning_st,
    round(total_spawning_wct - accessible_spawning_wct, 2) as disconnected_spawning_wct,
    round(total_rearing_ch - accessible_rearing_ch, 2) as disconnected_rearing_ch,
    round(total_rearing_co - accessible_rearing_co, 2) as disconnected_rearing_co,
    round(total_rearing_sk - accessible_rearing_sk, 2) as disconnected_rearing_sk,
    round(total_rearing_st - accessible_rearing_st, 2) as disconnected_rearing_st,
    round(total_rearing_wct - accessible_rearing_wct, 2) as disconnected_rearing_wct,
    round(total_spawningrearing_ch - accessible_spawningrearing_ch, 2) as disconnected_spawningrearing_ch,
    round(total_spawningrearing_co - accessible_spawningrearing_co, 2) as disconnected_spawningrearing_co,
    round(total_spawningrearing_sk - accessible_spawningrearing_sk, 2) as disconnected_spawningrearing_sk,
    round(total_spawningrearing_st - accessible_spawningrearing_st, 2) as disconnected_spawningrearing_st,
    round(total_spawningrearing_wct - accessible_spawningrearing_wct, 2) as disconnected_spawningrearing_wct,
    round(total_spawning_all - accessible_spawning_all, 2) as disconnected_spawning_all,
    round(total_rearing_all - accessible_rearing_all, 2) as disconnected_rearing_all,
    round(total_spawningrearing_all - accessible_spawningrearing_all, 2) as disconnected_spawningrearing_all,

    -- percentage accessible. null if species is not targeted
    round(accessible_spawning_ch / nullif(total_spawning_ch, 0) * 100, 2) as pct_accessible_spawning_ch,
    round(accessible_spawning_co / nullif(total_spawning_co, 0) * 100, 2) as pct_accessible_spawning_co,
    round(accessible_spawning_sk / nullif(total_spawning_sk, 0) * 100, 2) as pct_accessible_spawning_sk,
    round(accessible_spawning_st / nullif(total_spawning_st, 0) * 100, 2) as pct_accessible_spawning_st,
    round(accessible_spawning_wct / nullif(total_spawning_wct, 0) * 100, 2) as pct_accessible_spawning_wct,
    round(accessible_rearing_ch / nullif(total_rearing_ch, 0) * 100, 2) as pct_accessible_rearing_ch,
    round(accessible_rearing_co / nullif(total_rearing_co, 0) * 100, 2) as pct_accessible_rearing_co,
    round(accessible_rearing_sk / nullif(total_rearing_sk, 0) * 100, 2) as pct_accessible_rearing_sk,
    round(accessible_rearing_st / nullif(total_rearing_st, 0) * 100, 2) as pct_accessible_rearing_st,
    round(accessible_rearing_wct / nullif(total_rearing_wct, 0) * 100, 2) as pct_accessible_rearing_wct,
    round(accessible_spawningrearing_ch / nullif(total_spawningrearing_ch, 0) * 100, 2) as pct_accessible_spawningrearing_ch,
    round(accessible_spawningrearing_co / nullif(total_spawningrearing_co, 0) * 100, 2) as pct_accessible_spawningrearing_co,
    round(accessible_spawningrearing_sk / nullif(total_spawningrearing_sk, 0) * 100, 2) as pct_accessible_spawningrearing_sk,
    round(accessible_spawningrearing_st / nullif(total_spawningrearing_st, 0) * 100, 2) as pct_accessible_spawningrearing_st,
    round(accessible_spawningrearing_wct / nullif(total_spawningrearing_wct, 0) * 100, 2) as pct_accessible_spawningrearing_wct,
    round(accessible_spawning_all / nullif(total_spawning_all, 0) * 100, 2) as pct_accessible_spawning_all,
    round(accessible_rearing_all / nullif(total_rearing_all, 0) * 100, 2) as pct_accessible_rearing_all,
    round(accessible_spawningrearing_all / nullif(total_spawningrearing_all, 0) * 100, 2) as pct_accessible_spawningrearing_all
    
  from bcfishpass.log_wcrp_habitat_connectivity s
  inner join bcfishpass.log l on s.model_run_id = l.model_run_id
  order by s.wcrp, s.watershed_group_code, l.date_completed desc;



DROP FUNCTION IF EXISTS postgisftw.wcrp_habitat_connectivity_status;

CREATE OR REPLACE FUNCTION postgisftw.wcrp_habitat_connectivity_status(
    wcrp                      TEXT,
    p_watershed_group_code    TEXT DEFAULT NULL
)

RETURNS TABLE(
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
SELECT
    v.watershed_group_code,
    v.total_spawning_ch,
    v.total_spawning_co,
    v.total_spawning_sk,
    v.total_spawning_st,
    v.total_spawning_wct,
    v.total_rearing_ch,
    v.total_rearing_co,
    v.total_rearing_sk,
    v.total_rearing_st,
    v.total_rearing_wct,
    v.total_spawningrearing_ch,
    v.total_spawningrearing_co,
    v.total_spawningrearing_sk,
    v.total_spawningrearing_st,
    v.total_spawningrearing_wct,
    v.total_spawning_all,
    v.total_rearing_all,
    v.total_spawningrearing_all,
    v.accessible_spawning_ch,
    v.accessible_spawning_co,
    v.accessible_spawning_sk,
    v.accessible_spawning_st,
    v.accessible_spawning_wct,
    v.accessible_rearing_ch,
    v.accessible_rearing_co,
    v.accessible_rearing_sk,
    v.accessible_rearing_st,
    v.accessible_rearing_wct,
    v.accessible_spawningrearing_ch,
    v.accessible_spawningrearing_co,
    v.accessible_spawningrearing_sk,
    v.accessible_spawningrearing_st,
    v.accessible_spawningrearing_wct,
    v.accessible_spawning_all,
    v.accessible_rearing_all,
    v.accessible_spawningrearing_all,
    v.disconnected_spawning_ch,
    v.disconnected_spawning_co,
    v.disconnected_spawning_sk,
    v.disconnected_spawning_st,
    v.disconnected_spawning_wct,
    v.disconnected_rearing_ch,
    v.disconnected_rearing_co,
    v.disconnected_rearing_sk,
    v.disconnected_rearing_st,
    v.disconnected_rearing_wct,
    v.disconnected_spawningrearing_ch,
    v.disconnected_spawningrearing_co,
    v.disconnected_spawningrearing_sk,
    v.disconnected_spawningrearing_st,
    v.disconnected_spawningrearing_wct,
    v.disconnected_spawning_all,
    v.disconnected_rearing_all,
    v.disconnected_spawningrearing_all,
    v.pct_accessible_spawning_ch,
    v.pct_accessible_spawning_co,
    v.pct_accessible_spawning_sk,
    v.pct_accessible_spawning_st,
    v.pct_accessible_spawning_wct,
    v.pct_accessible_rearing_ch,
    v.pct_accessible_rearing_co,
    v.pct_accessible_rearing_sk,
    v.pct_accessible_rearing_st,
    v.pct_accessible_rearing_wct,
    v.pct_accessible_spawningrearing_ch,
    v.pct_accessible_spawningrearing_co,
    v.pct_accessible_spawningrearing_sk,
    v.pct_accessible_spawningrearing_st,
    v.pct_accessible_spawningrearing_wct,
    v.pct_accessible_spawning_all,
    v.pct_accessible_rearing_all,
    v.pct_accessible_spawningrearing_all
FROM bcfishpass.wcrp_habitat_connectivity_status_vw v
WHERE v.wcrp = v_wcrp
AND (v_watershed_group_code IS NULL OR v.watershed_group_code = v_watershed_group_code);

END
$$;

COMMENT ON FUNCTION postgisftw.wcrp_habitat_connectivity_status IS
'For WCRP specified, return total/accessible lengths and percentage accessible for habitat types spawning; rearing; spawning and/or rearing 
per target species and for all target species. Optionally filter by watershed_group_code.';

REVOKE EXECUTE ON FUNCTION postgisftw.wcrp_habitat_connectivity_status FROM public;

-- select * from postgisftw.wcrp_habitat_connectivity_status('takla')
-- select * from postgisftw.wcrp_habitat_connectivity_status('takla','DRIR')
-- select * from postgisftw.wcrp_habitat_connectivity_status('hors')
-- select * from postgisftw.wcrp_habitat_connectivity_status('bowr_ques_carr')


COMMIT;
