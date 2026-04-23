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
   accessible_spawningrearing_all                               numeric

  );


  -- view of current habitat connecitvity status, plus percentages
  drop view if exists bcfishpass.wcrp_habitat_connectivity_status_vw;

  create view bcfishpass.wcrp_habitat_connectivity_status_vw as
  select distinct on (wcrp, watershed_group_code)
    wcrp,
    watershed_group_code,

    total_spawning_ch,
    total_spawning_co,
    total_spawning_sk,
    total_spawning_st,
    total_spawning_wct,
    total_rearing_ch,
    total_rearing_co,
    total_rearing_sk,
    total_rearing_st,
    total_rearing_wct,
    total_spawningrearing_ch,
    total_spawningrearing_co,
    total_spawningrearing_sk,
    total_spawningrearing_st,
    total_spawningrearing_wct,
    total_spawning_all,
    total_rearing_all,
    total_spawningrearing_all,
    
    accessible_spawning_ch,
    accessible_spawning_co,
    accessible_spawning_sk,
    accessible_spawning_st,
    accessible_spawning_wct,
    accessible_rearing_ch,
    accessible_rearing_co,
    accessible_rearing_sk,
    accessible_rearing_st,
    accessible_rearing_wct,
    accessible_spawningrearing_ch,
    accessible_spawningrearing_co,
    accessible_spawningrearing_sk,
    accessible_spawningrearing_st,
    accessible_spawningrearing_wct,
    accessible_spawning_all,
    accessible_rearing_all,
    accessible_spawningrearing_all,

    total_spawning_ch - accessible_spawning_ch as disconnected_spawning_ch,
    total_spawning_co - accessible_spawning_co as disconnected_spawning_co,
    total_spawning_sk - accessible_spawning_sk as disconnected_spawning_sk,
    total_spawning_st - accessible_spawning_st as disconnected_spawning_st,
    total_spawning_wct - accessible_spawning_wct as disconnected_spawning_wct,
    total_rearing_ch - accessible_rearing_ch as disconnected_rearing_ch,
    total_rearing_co - accessible_rearing_co as disconnected_rearing_co,
    total_rearing_sk - accessible_rearing_sk as disconnected_rearing_sk,
    total_rearing_st - accessible_rearing_st as disconnected_rearing_st,
    total_rearing_wct - accessible_rearing_wct as disconnected_rearing_wct,
    total_spawningrearing_ch - accessible_spawningrearing_ch as disconnected_spawningrearing_ch,
    total_spawningrearing_co - accessible_spawningrearing_co as disconnected_spawningrearing_co,
    total_spawningrearing_sk - accessible_spawningrearing_sk as disconnected_spawningrearing_sk,
    total_spawningrearing_st - accessible_spawningrearing_st as disconnected_spawningrearing_st,
    total_spawningrearing_wct - accessible_spawningrearing_wct as disconnected_spawningrearing_wct,
    total_spawning_all - accessible_spawning_all as disconnected_spawning_all,
    total_rearing_all - accessible_rearing_all as disconnected_rearing_all,
    total_spawningrearing_all - accessible_spawningrearing_all as disconnected_spawningrearing_all,

    -- percentage accessible
    round(coalesce(accessible_spawning_ch / nullif(total_spawning_ch, 0),0) * 100, 2) as pct_accessible_spawning_ch,
    round(coalesce(accessible_spawning_co / nullif(total_spawning_co, 0),0) * 100, 2) as pct_accessible_spawning_co,
    round(coalesce(accessible_spawning_sk / nullif(total_spawning_sk, 0),0) * 100, 2) as pct_accessible_spawning_sk,
    round(coalesce(accessible_spawning_st / nullif(total_spawning_st, 0),0) * 100, 2) as pct_accessible_spawning_st,
    round(coalesce(accessible_spawning_wct / nullif(total_spawning_wct, 0),0) * 100, 2) as pct_accessible_spawning_wct,
    round(coalesce(accessible_rearing_ch / nullif(total_rearing_ch, 0),0) * 100, 2) as pct_accessible_rearing_ch,
    round(coalesce(accessible_rearing_co / nullif(total_rearing_co, 0),0) * 100, 2) as pct_accessible_rearing_co,
    round(coalesce(accessible_rearing_sk / nullif(total_rearing_sk, 0),0) * 100, 2) as pct_accessible_rearing_sk,
    round(coalesce(accessible_rearing_st / nullif(total_rearing_st, 0),0) * 100, 2) as pct_accessible_rearing_st,
    round(coalesce(accessible_rearing_wct / nullif(total_rearing_wct, 0),0) * 100, 2) as pct_accessible_rearing_wct,
    round(coalesce(accessible_spawningrearing_ch / nullif(total_spawningrearing_ch, 0),0) * 100, 2) as pct_accessible_spawningrearing_ch,
    round(coalesce(accessible_spawningrearing_co / nullif(total_spawningrearing_co, 0),0) * 100, 2) as pct_accessible_spawningrearing_co,
    round(coalesce(accessible_spawningrearing_sk / nullif(total_spawningrearing_sk, 0),0) * 100, 2) as pct_accessible_spawningrearing_sk,
    round(coalesce(accessible_spawningrearing_st / nullif(total_spawningrearing_st, 0),0) * 100, 2) as pct_accessible_spawningrearing_st,
    round(coalesce(accessible_spawningrearing_wct / nullif(total_spawningrearing_wct, 0),0) * 100, 2) as pct_accessible_spawningrearing_wct,
    round(coalesce(accessible_spawning_all / nullif(total_spawning_all, 0),0) * 100, 2) as pct_accessible_spawning_all,
    round(coalesce(accessible_rearing_all / nullif(total_rearing_all, 0),0) * 100, 2) as pct_accessible_rearing_all,
    round(coalesce(accessible_spawningrearing_all / nullif(total_spawningrearing_all, 0),0) * 100, 2) as pct_accessible_spawningrearing_all
    
  from bcfishpass.log_wcrp_habitat_connectivity s
  inner join bcfishpass.log l on s.model_run_id = l.model_run_id
  order by s.wcrp, s.watershed_group_code, l.date_completed desc;



-- report on total modelled habitat vs accessible modelled habitat
DROP FUNCTION IF EXISTS postgisftw.wcrp_habitat_connectivity_status;

CREATE OR REPLACE FUNCTION postgisftw.wcrp_habitat_connectivity_status(
  wcrp TEXT
)

  RETURNS TABLE(
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
   accessible_spawningrearing_all                               numeric
  )

  LANGUAGE 'plpgsql'
  IMMUTABLE PARALLEL SAFE

AS $$

DECLARE
   v_wcrp  text := wcrp;

BEGIN
RETURN QUERY
select
   v.total_spawning_ch                                       numeric,
   v.total_spawning_co                                       numeric,
   v.total_spawning_sk                                       numeric,
   v.total_spawning_st                                       numeric,
   v.total_spawning_wct                                      numeric,

   v.total_rearing_ch                                        numeric,
   v.total_rearing_co                                        numeric,
   v.total_rearing_sk                                        numeric,
   v.total_rearing_st                                        numeric,
   v.total_rearing_wct                                       numeric,

   v.total_spawningrearing_ch                                numeric,
   v.total_spawningrearing_co                                numeric,
   v.total_spawningrearing_sk                                numeric,
   v.total_spawningrearing_st                                numeric,
   v.total_spawningrearing_wct                               numeric,

   v.total_spawning_all                                      numeric,
   v.total_rearing_all                                       numeric,
   v.total_spawningrearing_all                               numeric,

   v.accessible_spawning_ch                                       numeric,
   v.accessible_spawning_co                                       numeric,
   v.accessible_spawning_sk                                       numeric,
   v.accessible_spawning_st                                       numeric,
   v.accessible_spawning_wct                                      numeric,

   v.accessible_rearing_ch                                        numeric,
   v.accessible_rearing_co                                        numeric,
   v.accessible_rearing_sk                                        numeric,
   v.accessible_rearing_st                                        numeric,
   v.accessible_rearing_wct                                       numeric,

   v.accessible_spawningrearing_ch                                numeric,
   v.accessible_spawningrearing_co                                numeric,
   v.accessible_spawningrearing_sk                                numeric,
   v.accessible_spawningrearing_st                                numeric,
   v.accessible_spawningrearing_wct                               numeric,

   v.accessible_spawning_all                                      numeric,
   v.accessible_rearing_all                                       numeric,
   v.accessible_spawningrearing_all                               numeric
from bcfishpass.wcrp_habitat_connectivity_status_vw v
where v.wcrp = v_wcrp;

END
$$;

COMMENT ON FUNCTION postgisftw.wcrp_habitat_connectivity_status IS
'For WCRP specified, return total/accessible lengths and percentage accessible for habitat types spawning; rearing; spawning and/or rearing 
per target species and for all target species.';

REVOKE EXECUTE ON FUNCTION postgisftw.wcrp_habitat_connectivity_status FROM public;

-- select * from postgisftw.wcrp_habitat_connectivity_status('takla')
-- select * from postgisftw.wcrp_habitat_connectivity_status('hors')
-- select * from postgisftw.wcrp_habitat_connectivity_status('bowr_ques_carr')


COMMIT;
