-- log habitat connectivity status

BEGIN;

  drop table if exists bcfishpass.log_wcrp_habitat_connectivity cascade;
  
  create table bcfishpass.log_wcrp_habitat_connectivity (
   model_run_id                                             integer references bcfishpass.log(model_run_id),
   wcrp                                                     text,
   
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
  create view bcfishpass.wcrp_habitat_connectivity as
  select distinct on (wcrp)
    wcrp,
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
  order by s.wcrp, l.date_completed desc;


COMMIT;
