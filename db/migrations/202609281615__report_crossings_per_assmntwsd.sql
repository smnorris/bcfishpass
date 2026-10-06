-- report on crossing counts per assessment watershed, then roll up to watershed group
BEGIN;

  -- drop existing function that summarizes crossing counts per watershed group
  DROP FUNCTION bcfishpass.wsg_crossing_summary;

  -- create new function that summarizes per assessment watershed
  CREATE FUNCTION bcfishpass.aw_crossing_summary() RETURNS TABLE(
    assessment_watershed_id integer,
    crossing_feature_type text,
    n_crossings_total integer,
    n_passable_total integer,
    n_barriers_total integer,
    n_potential_total integer,
    n_unknown_total integer,
    n_barriers_accessible_bt integer,
    n_potential_accessible_bt integer,
    n_unknown_accessible_bt integer,
    n_barriers_accessible_ch_cm_co_pk_sk integer,
    n_potential_accessible_ch_cm_co_pk_sk integer,
    n_unknown_accessible_ch_cm_co_pk_sk integer,
    n_barriers_accessible_st integer,
    n_potential_accessible_st integer,
    n_unknown_accessible_st integer,
    n_barriers_accessible_wct integer,
    n_potential_accessible_wct integer,
    n_unknown_accessible_wct integer,
    n_barriers_habitat_bt integer,
    n_potential_habitat_bt integer,
    n_unknown_habitat_bt integer,
    n_barriers_habitat_ch integer,
    n_potential_habitat_ch integer,
    n_unknown_habitat_ch integer,
    n_barriers_habitat_cm integer,
    n_potential_habitat_cm integer,
    n_unknown_habitat_cm integer,
    n_barriers_habitat_co integer,
    n_potential_habitat_co integer,
    n_unknown_habitat_co integer,
    n_barriers_habitat_pk integer,
    n_potential_habitat_pk integer,
    n_unknown_habitat_pk integer,
    n_barriers_habitat_sk integer,
    n_potential_habitat_sk integer,
    n_unknown_habitat_sk integer,
    n_barriers_habitat_salmon integer,
    n_potential_habitat_salmon integer,
    n_unknown_habitat_salmon integer,
    n_barriers_habitat_st integer,
    n_potential_habitat_st integer,
    n_unknown_habitat_st integer,
    n_barriers_habitat_wct integer,
    n_potential_habitat_wct integer,
    n_unknown_habitat_wct integer
  )
    LANGUAGE sql
    AS $$

  SELECT
    aw.assmnt_watershed_id as assessment_watershed_id,
    crossing_feature_type,
    count(*) as n_crossings_total,
    count(*) filter (where barrier_status = 'PASSABLE') as n_passable_total, -- just report on passable for totals, we are more interested in barriers
    count(*) filter (where barrier_status = 'BARRIER') as n_barriers_total,
    count(*) filter (where barrier_status = 'POTENTIAL') as n_potential_total,
    count(*) filter (where barrier_status = 'UNKNOWN') as n_unknown_total,

    -- crossings on potentially accessible streams
    count(*) filter (where barrier_status = 'BARRIER' and barriers_bt_dnstr = '') as n_barriers_accessible_bt,
    count(*) filter (where barrier_status = 'POTENTIAL' and barriers_bt_dnstr = '') as n_potential_accessible_bt,
    count(*) filter (where barrier_status = 'UNKNOWN' and barriers_bt_dnstr = '') as n_unknown_accessible_bt,

    count(*) filter (where barrier_status = 'BARRIER' and barriers_ch_cm_co_pk_sk_dnstr = '') as n_barriers_accessible_ch_cm_co_pk_sk,
    count(*) filter (where barrier_status = 'POTENTIAL' and barriers_ch_cm_co_pk_sk_dnstr = '') as n_potential_accessible_ch_cm_co_pk_sk,
    count(*) filter (where barrier_status = 'UNKNOWN' and barriers_ch_cm_co_pk_sk_dnstr = '') as n_unknown_accessible_ch_cm_co_pk_sk,

    count(*) filter (where barrier_status = 'BARRIER' and barriers_st_dnstr = '') as n_barriers_accessible_st,
    count(*) filter (where barrier_status = 'POTENTIAL' and barriers_st_dnstr = '') as n_potential_accessible_st,
    count(*) filter (where barrier_status = 'UNKNOWN' and barriers_st_dnstr = '') as n_unknown_accessible_st,

    count(*) filter (where barrier_status = 'BARRIER' and barriers_wct_dnstr = '') as n_barriers_accessible_wct,
    count(*) filter (where barrier_status = 'POTENTIAL' and barriers_wct_dnstr = '') as n_potential_accessible_wct,
    count(*) filter (where barrier_status = 'UNKNOWN' and barriers_wct_dnstr = '') as n_unknown_accessible_wct,

    -- crossings with modelled/known habitat upstream
    count(*) filter (where barrier_status = 'BARRIER' and (
      bt_spawning_km > 0 or
      bt_rearing_km > 0)
     ) as n_barriers_habitat_bt,
    count(*) filter (where barrier_status = 'POTENTIAL' and (
      bt_spawning_km > 0 or
      bt_rearing_km > 0)
     ) as n_potential_habitat_bt,
    count(*) filter (where barrier_status = 'UNKNOWN' and (
      bt_spawning_km > 0 or
      bt_rearing_km > 0)
     ) as n_unknown_habitat_bt,

    count(*) filter (where barrier_status = 'BARRIER' and (
      ch_spawning_km > 0 or
      ch_rearing_km > 0)
     ) as n_barriers_habitat_ch,
    count(*) filter (where barrier_status = 'POTENTIAL' and (
      ch_spawning_km > 0 or
      ch_rearing_km > 0)
     ) as n_potential_habitat_ch,
    count(*) filter (where barrier_status = 'UNKNOWN' and (
      ch_spawning_km > 0 or
      ch_rearing_km > 0)
     ) as n_unknown_habitat_ch,

    count(*) filter (where barrier_status = 'BARRIER' and cm_spawning_km > 0) as n_barriers_habitat_cm,
    count(*) filter (where barrier_status = 'POTENTIAL' and cm_spawning_km > 0) as n_potential_habitat_cm,
    count(*) filter (where barrier_status = 'UNKNOWN' and cm_spawning_km > 0) as n_unknown_habitat_cm,

    count(*) filter (where barrier_status = 'BARRIER' and (
      co_spawning_km > 0 or
      co_rearing_km > 0)
     ) as n_barriers_habitat_co,
    count(*) filter (where barrier_status = 'POTENTIAL' and (
      co_spawning_km > 0 or
      co_rearing_km > 0)
     ) as n_potential_habitat_co,
    count(*) filter (where barrier_status = 'UNKNOWN' and (
      co_spawning_km > 0 or
      co_rearing_km > 0)
     ) as n_unknown_habitat_co,

    count(*) filter (where barrier_status = 'BARRIER' and pk_spawning_km > 0) as n_barriers_habitat_pk,
    count(*) filter (where barrier_status = 'POTENTIAL' and pk_spawning_km > 0) as n_potential_habitat_pk,
    count(*) filter (where barrier_status = 'UNKNOWN' and pk_spawning_km > 0) as n_unknown_habitat_pk,

    count(*) filter (where barrier_status = 'BARRIER' and (
      sk_spawning_km > 0 or
      sk_rearing_km > 0)
     ) as n_barriers_habitat_sk,
    count(*) filter (where barrier_status = 'POTENTIAL' and (
      sk_spawning_km > 0 or
      sk_rearing_km > 0)
     ) as n_potential_habitat_sk,
    count(*) filter (where barrier_status = 'UNKNOWN' and (
      sk_spawning_km > 0 or
      sk_rearing_km > 0)
     ) as n_unknown_habitat_sk,

    count(*) filter (where barrier_status = 'BARRIER' and (
      ch_spawning_km > 0 or
      ch_rearing_km > 0 or
      cm_spawning_km > 0 or
      co_spawning_km > 0 or
      co_rearing_km > 0 or
      pk_spawning_km > 0 or
      sk_spawning_km > 0 or
      sk_rearing_km > 0)
     ) as n_barriers_habitat_salmon,
    count(*) filter (where barrier_status = 'POTENTIAL' and (
      ch_spawning_km > 0 or
      ch_rearing_km > 0 or
      cm_spawning_km > 0 or
      co_spawning_km > 0 or
      co_rearing_km > 0 or
      pk_spawning_km > 0 or
      sk_spawning_km > 0 or
      sk_rearing_km > 0)
     ) as n_potential_habitat_salmon,
    count(*) filter (where barrier_status = 'UNKNOWN' and (
      ch_spawning_km > 0 or
      ch_rearing_km > 0 or
      cm_spawning_km > 0 or
      co_spawning_km > 0 or
      co_rearing_km > 0 or
      pk_spawning_km > 0 or
      sk_spawning_km > 0 or
      sk_rearing_km > 0)
     ) as n_unknown_habitat_salmon,

    count(*) filter (where barrier_status = 'BARRIER' and (
      st_spawning_km > 0 or
      st_rearing_km > 0)
     ) as n_barriers_habitat_st,
    count(*) filter (where barrier_status = 'POTENTIAL' and (
      st_spawning_km > 0 or
      st_rearing_km > 0)
     ) as n_potential_habitat_st,
    count(*) filter (where barrier_status = 'UNKNOWN' and (
      st_spawning_km > 0 or
      st_rearing_km > 0)
     ) as n_unknown_habitat_st,

    count(*) filter (where barrier_status = 'BARRIER' and (
      wct_spawning_km > 0 or
      wct_rearing_km > 0)
     ) as n_barriers_habitat_wct,
    count(*) filter (where barrier_status = 'POTENTIAL' and (
      wct_spawning_km > 0 or
      wct_rearing_km > 0)
     ) as n_potential_habitat_wct,
    count(*) filter (where barrier_status = 'UNKNOWN' and (
      wct_spawning_km > 0 or
      wct_rearing_km > 0)
     ) as n_unknown_habitat_wct

  FROM bcfishpass.crossings_vw c
  INNER JOIN whse_basemapping.fwa_assessment_watersheds_streams_lut aw on c.linear_feature_id = aw.linear_feature_id
  GROUP BY aw.assmnt_watershed_id, crossing_feature_type
  ORDER BY aw.assmnt_watershed_id, crossing_feature_type
$$;


  -- new log table that holds results of above query per model run
  CREATE TABLE bcfishpass.log_aw_crossing_summary (
    model_run_id integer,
    assessment_watershed_id integer,
    crossing_feature_type text,
    n_crossings_total integer,
    n_passable_total integer,
    n_barriers_total integer,
    n_potential_total integer,
    n_unknown_total integer,
    n_barriers_accessible_bt integer,
    n_potential_accessible_bt integer,
    n_unknown_accessible_bt integer,
    n_barriers_accessible_ch_cm_co_pk_sk integer,
    n_potential_accessible_ch_cm_co_pk_sk integer,
    n_unknown_accessible_ch_cm_co_pk_sk integer,
    n_barriers_accessible_st integer,
    n_potential_accessible_st integer,
    n_unknown_accessible_st integer,
    n_barriers_accessible_wct integer,
    n_potential_accessible_wct integer,
    n_unknown_accessible_wct integer,
    n_barriers_habitat_bt integer,
    n_potential_habitat_bt integer,
    n_unknown_habitat_bt integer,
    n_barriers_habitat_ch integer,
    n_potential_habitat_ch integer,
    n_unknown_habitat_ch integer,
    n_barriers_habitat_cm integer,
    n_potential_habitat_cm integer,
    n_unknown_habitat_cm integer,
    n_barriers_habitat_co integer,
    n_potential_habitat_co integer,
    n_unknown_habitat_co integer,
    n_barriers_habitat_pk integer,
    n_potential_habitat_pk integer,
    n_unknown_habitat_pk integer,
    n_barriers_habitat_sk integer,
    n_potential_habitat_sk integer,
    n_unknown_habitat_sk integer,
    n_barriers_habitat_salmon integer,
    n_potential_habitat_salmon integer,
    n_unknown_habitat_salmon integer,
    n_barriers_habitat_st integer,
    n_potential_habitat_st integer,
    n_unknown_habitat_st integer,
    n_barriers_habitat_wct integer,
    n_potential_habitat_wct integer,
    n_unknown_habitat_wct integer
  );

  -- create current/prev/diff views at aw level
CREATE VIEW bcfishpass.aw_crossing_summary_current AS
 SELECT s.model_run_id,
    s.assessment_watershed_id,
    s.crossing_feature_type,
    s.n_crossings_total,
    s.n_passable_total,
    s.n_barriers_total,
    s.n_potential_total,
    s.n_unknown_total,
    s.n_barriers_accessible_bt,
    s.n_potential_accessible_bt,
    s.n_unknown_accessible_bt,
    s.n_barriers_accessible_ch_cm_co_pk_sk,
    s.n_potential_accessible_ch_cm_co_pk_sk,
    s.n_unknown_accessible_ch_cm_co_pk_sk,
    s.n_barriers_accessible_st,
    s.n_potential_accessible_st,
    s.n_unknown_accessible_st,
    s.n_barriers_accessible_wct,
    s.n_potential_accessible_wct,
    s.n_unknown_accessible_wct,
    s.n_barriers_habitat_bt,
    s.n_potential_habitat_bt,
    s.n_unknown_habitat_bt,
    s.n_barriers_habitat_ch,
    s.n_potential_habitat_ch,
    s.n_unknown_habitat_ch,
    s.n_barriers_habitat_cm,
    s.n_potential_habitat_cm,
    s.n_unknown_habitat_cm,
    s.n_barriers_habitat_co,
    s.n_potential_habitat_co,
    s.n_unknown_habitat_co,
    s.n_barriers_habitat_pk,
    s.n_potential_habitat_pk,
    s.n_unknown_habitat_pk,
    s.n_barriers_habitat_sk,
    s.n_potential_habitat_sk,
    s.n_unknown_habitat_sk,
    s.n_barriers_habitat_salmon,
    s.n_potential_habitat_salmon,
    s.n_unknown_habitat_salmon,
    s.n_barriers_habitat_st,
    s.n_potential_habitat_st,
    s.n_unknown_habitat_st,
    s.n_barriers_habitat_wct,
    s.n_potential_habitat_wct,
    s.n_unknown_habitat_wct
   FROM (bcfishpass.log_aw_crossing_summary s
     JOIN bcfishpass.log l ON ((s.model_run_id = l.model_run_id)))
  WHERE (l.model_run_id = ( SELECT log.model_run_id
           FROM bcfishpass.log
          ORDER BY log.model_run_id DESC
         LIMIT 1))
  ORDER BY s.assessment_watershed_id, s.crossing_feature_type;


CREATE VIEW bcfishpass.aw_crossing_summary_previous AS
 SELECT s.model_run_id,
    s.assessment_watershed_id,
    s.crossing_feature_type,
    s.n_crossings_total,
    s.n_passable_total,
    s.n_barriers_total,
    s.n_potential_total,
    s.n_unknown_total,
    s.n_barriers_accessible_bt,
    s.n_potential_accessible_bt,
    s.n_unknown_accessible_bt,
    s.n_barriers_accessible_ch_cm_co_pk_sk,
    s.n_potential_accessible_ch_cm_co_pk_sk,
    s.n_unknown_accessible_ch_cm_co_pk_sk,
    s.n_barriers_accessible_st,
    s.n_potential_accessible_st,
    s.n_unknown_accessible_st,
    s.n_barriers_accessible_wct,
    s.n_potential_accessible_wct,
    s.n_unknown_accessible_wct,
    s.n_barriers_habitat_bt,
    s.n_potential_habitat_bt,
    s.n_unknown_habitat_bt,
    s.n_barriers_habitat_ch,
    s.n_potential_habitat_ch,
    s.n_unknown_habitat_ch,
    s.n_barriers_habitat_cm,
    s.n_potential_habitat_cm,
    s.n_unknown_habitat_cm,
    s.n_barriers_habitat_co,
    s.n_potential_habitat_co,
    s.n_unknown_habitat_co,
    s.n_barriers_habitat_pk,
    s.n_potential_habitat_pk,
    s.n_unknown_habitat_pk,
    s.n_barriers_habitat_sk,
    s.n_potential_habitat_sk,
    s.n_unknown_habitat_sk,
    s.n_barriers_habitat_salmon,
    s.n_potential_habitat_salmon,
    s.n_unknown_habitat_salmon,
    s.n_barriers_habitat_st,
    s.n_potential_habitat_st,
    s.n_unknown_habitat_st,
    s.n_barriers_habitat_wct,
    s.n_potential_habitat_wct,
    s.n_unknown_habitat_wct
   FROM (bcfishpass.log_aw_crossing_summary s
     JOIN bcfishpass.log l ON ((s.model_run_id = l.model_run_id)))
  WHERE (l.model_run_id = ( SELECT log.model_run_id
           FROM bcfishpass.log
          ORDER BY log.model_run_id DESC
         OFFSET 1
         LIMIT 1))
  ORDER BY s.assessment_watershed_id, s.crossing_feature_type;


  CREATE VIEW bcfishpass.aw_crossing_summary_diff AS
  SELECT a.assessment_watershed_id,
    a.crossing_feature_type,
    (a.n_crossings_total - b.n_crossings_total) AS n_crossings_total,
    (a.n_passable_total - b.n_passable_total) AS n_passable_total,
    (a.n_barriers_total - b.n_barriers_total) AS n_barriers_total,
    (a.n_potential_total - b.n_potential_total) AS n_potential_total,
    (a.n_unknown_total - b.n_unknown_total) AS n_unknown_total,
    (a.n_barriers_accessible_bt - b.n_barriers_accessible_bt) AS n_barriers_accessible_bt,
    (a.n_potential_accessible_bt - b.n_potential_accessible_bt) AS n_potential_accessible_bt,
    (a.n_unknown_accessible_bt - b.n_unknown_accessible_bt) AS n_unknown_accessible_bt,
    (a.n_barriers_accessible_ch_cm_co_pk_sk - b.n_barriers_accessible_ch_cm_co_pk_sk) AS n_barriers_accessible_ch_cm_co_pk_sk,
    (a.n_potential_accessible_ch_cm_co_pk_sk - b.n_potential_accessible_ch_cm_co_pk_sk) AS n_potential_accessible_ch_cm_co_pk_sk,
    (a.n_unknown_accessible_ch_cm_co_pk_sk - b.n_unknown_accessible_ch_cm_co_pk_sk) AS n_unknown_accessible_ch_cm_co_pk_sk,
    (a.n_barriers_accessible_st - b.n_barriers_accessible_st) AS n_barriers_accessible_st,
    (a.n_potential_accessible_st - b.n_potential_accessible_st) AS n_potential_accessible_st,
    (a.n_unknown_accessible_st - b.n_unknown_accessible_st) AS n_unknown_accessible_st,
    (a.n_barriers_accessible_wct - b.n_barriers_accessible_wct) AS n_barriers_accessible_wct,
    (a.n_potential_accessible_wct - b.n_potential_accessible_wct) AS n_potential_accessible_wct,
    (a.n_unknown_accessible_wct - b.n_unknown_accessible_wct) AS n_unknown_accessible_wct,
    (a.n_barriers_habitat_bt - b.n_barriers_habitat_bt) AS n_barriers_habitat_bt,
    (a.n_potential_habitat_bt - b.n_potential_habitat_bt) AS n_potential_habitat_bt,
    (a.n_unknown_habitat_bt - b.n_unknown_habitat_bt) AS n_unknown_habitat_bt,
    (a.n_barriers_habitat_ch - b.n_barriers_habitat_ch) AS n_barriers_habitat_ch,
    (a.n_potential_habitat_ch - b.n_potential_habitat_ch) AS n_potential_habitat_ch,
    (a.n_unknown_habitat_ch - b.n_unknown_habitat_ch) AS n_unknown_habitat_ch,
    (a.n_barriers_habitat_cm - b.n_barriers_habitat_cm) AS n_barriers_habitat_cm,
    (a.n_potential_habitat_cm - b.n_potential_habitat_cm) AS n_potential_habitat_cm,
    (a.n_unknown_habitat_cm - b.n_unknown_habitat_cm) AS n_unknown_habitat_cm,
    (a.n_barriers_habitat_co - b.n_barriers_habitat_co) AS n_barriers_habitat_co,
    (a.n_potential_habitat_co - b.n_potential_habitat_co) AS n_potential_habitat_co,
    (a.n_unknown_habitat_co - b.n_unknown_habitat_co) AS n_unknown_habitat_co,
    (a.n_barriers_habitat_pk - b.n_barriers_habitat_pk) AS n_barriers_habitat_pk,
    (a.n_potential_habitat_pk - b.n_potential_habitat_pk) AS n_potential_habitat_pk,
    (a.n_unknown_habitat_pk - b.n_unknown_habitat_pk) AS n_unknown_habitat_pk,
    (a.n_barriers_habitat_sk - b.n_barriers_habitat_sk) AS n_barriers_habitat_sk,
    (a.n_potential_habitat_sk - b.n_potential_habitat_sk) AS n_potential_habitat_sk,
    (a.n_unknown_habitat_sk - b.n_unknown_habitat_sk) AS n_unknown_habitat_sk,
    (a.n_barriers_habitat_salmon - b.n_barriers_habitat_salmon) AS n_barriers_habitat_salmon,
    (a.n_potential_habitat_salmon - b.n_potential_habitat_salmon) AS n_potential_habitat_salmon,
    (a.n_unknown_habitat_salmon - b.n_unknown_habitat_salmon) AS n_unknown_habitat_salmon,
    (a.n_barriers_habitat_st - b.n_barriers_habitat_st) AS n_barriers_habitat_st,
    (a.n_potential_habitat_st - b.n_potential_habitat_st) AS n_potential_habitat_st,
    (a.n_unknown_habitat_st - b.n_unknown_habitat_st) AS n_unknown_habitat_st,
    (a.n_barriers_habitat_wct - b.n_barriers_habitat_wct) AS n_barriers_habitat_wct,
    (a.n_potential_habitat_wct - b.n_potential_habitat_wct) AS n_potential_habitat_wct,
    (a.n_unknown_habitat_wct - b.n_unknown_habitat_wct) AS n_unknown_habitat_wct
   FROM (bcfishpass.aw_crossing_summary_current a
     FULL OUTER JOIN bcfishpass.aw_crossing_summary_previous b ON (((a.assessment_watershed_id = b.assessment_watershed_id) AND (a.crossing_feature_type = b.crossing_feature_type))))
  ORDER BY a.assessment_watershed_id;


  -- update the wsg current / previous views to pull from aw report
  DROP VIEW bcfishpass.wsg_crossing_summary_current CASCADE;

  CREATE VIEW bcfishpass.wsg_crossing_summary_current AS
  SELECT s.model_run_id,
    aw.watershed_group_code,
    s.crossing_feature_type,
    sum(s.n_crossings_total) as n_crossings_total,
    sum(s.n_passable_total) as n_passable_total,
    sum(s.n_barriers_total) as n_barriers_total,
    sum(s.n_potential_total) as n_potential_total,
    sum(s.n_unknown_total) as n_unknown_total,
    sum(s.n_barriers_accessible_bt) as n_barriers_accessible_bt,
    sum(s.n_potential_accessible_bt) as n_potential_accessible_bt,
    sum(s.n_unknown_accessible_bt) as n_unknown_accessible_bt,
    sum(s.n_barriers_accessible_ch_cm_co_pk_sk) as n_barriers_accessible_ch_cm_co_pk_sk,
    sum(s.n_potential_accessible_ch_cm_co_pk_sk) as n_potential_accessible_ch_cm_co_pk_sk,
    sum(s.n_unknown_accessible_ch_cm_co_pk_sk) as n_unknown_accessible_ch_cm_co_pk_sk,
    sum(s.n_barriers_accessible_st) as n_barriers_accessible_st,
    sum(s.n_potential_accessible_st) as n_potential_accessible_st,
    sum(s.n_unknown_accessible_st) as n_unknown_accessible_st,
    sum(s.n_barriers_accessible_wct) as n_barriers_accessible_wct,
    sum(s.n_potential_accessible_wct) as n_potential_accessible_wct,
    sum(s.n_unknown_accessible_wct) as n_unknown_accessible_wct,
    sum(s.n_barriers_habitat_bt) as n_barriers_habitat_bt,
    sum(s.n_potential_habitat_bt) as n_potential_habitat_bt,
    sum(s.n_unknown_habitat_bt) as n_unknown_habitat_bt,
    sum(s.n_barriers_habitat_ch) as n_barriers_habitat_ch,
    sum(s.n_potential_habitat_ch) as n_potential_habitat_ch,
    sum(s.n_unknown_habitat_ch) as n_unknown_habitat_ch,
    sum(s.n_barriers_habitat_cm) as n_barriers_habitat_cm,
    sum(s.n_potential_habitat_cm) as n_potential_habitat_cm,
    sum(s.n_unknown_habitat_cm) as n_unknown_habitat_cm,
    sum(s.n_barriers_habitat_co) as n_barriers_habitat_co,
    sum(s.n_potential_habitat_co) as n_potential_habitat_co,
    sum(s.n_unknown_habitat_co) as n_unknown_habitat_co,
    sum(s.n_barriers_habitat_pk) as n_barriers_habitat_pk,
    sum(s.n_potential_habitat_pk) as n_potential_habitat_pk,
    sum(s.n_unknown_habitat_pk) as n_unknown_habitat_pk,
    sum(s.n_barriers_habitat_sk) as n_barriers_habitat_sk,
    sum(s.n_potential_habitat_sk) as n_potential_habitat_sk,
    sum(s.n_unknown_habitat_sk) as n_unknown_habitat_sk,
    sum(s.n_barriers_habitat_salmon) as n_barriers_habitat_salmon,
    sum(s.n_potential_habitat_salmon) as n_potential_habitat_salmon,
    sum(s.n_unknown_habitat_salmon) as n_unknown_habitat_salmon,
    sum(s.n_barriers_habitat_st) as n_barriers_habitat_st,
    sum(s.n_potential_habitat_st) as n_potential_habitat_st,
    sum(s.n_unknown_habitat_st) as n_unknown_habitat_st,
    sum(s.n_barriers_habitat_wct) as n_barriers_habitat_wct,
    sum(s.n_potential_habitat_wct) as n_potential_habitat_wct,
    sum(s.n_unknown_habitat_wct) as n_unknown_habitat_wct
   FROM (bcfishpass.log_aw_crossing_summary s
     JOIN bcfishpass.log l ON ((s.model_run_id = l.model_run_id))
     JOIN whse_basemapping.fwa_assessment_watersheds_poly aw ON (s.assessment_watershed_id = aw.watershed_feature_id)
     )
  WHERE (l.model_run_id = ( SELECT log.model_run_id
           FROM bcfishpass.log
          ORDER BY log.model_run_id DESC
         LIMIT 1))
  GROUP BY s.model_run_id, aw.watershed_group_code, s.crossing_feature_type
  ORDER BY s.model_run_id, aw.watershed_group_code, s.crossing_feature_type;


  DROP VIEW bcfishpass.wsg_crossing_summary_previous;
  CREATE VIEW bcfishpass.wsg_crossing_summary_previous AS
  SELECT s.model_run_id,
    aw.watershed_group_code,
    s.crossing_feature_type,
    sum(s.n_crossings_total) as n_crossings_total,
    sum(s.n_passable_total) as n_passable_total,
    sum(s.n_barriers_total) as n_barriers_total,
    sum(s.n_potential_total) as n_potential_total,
    sum(s.n_unknown_total) as n_unknown_total,
    sum(s.n_barriers_accessible_bt) as n_barriers_accessible_bt,
    sum(s.n_potential_accessible_bt) as n_potential_accessible_bt,
    sum(s.n_unknown_accessible_bt) as n_unknown_accessible_bt,
    sum(s.n_barriers_accessible_ch_cm_co_pk_sk) as n_barriers_accessible_ch_cm_co_pk_sk,
    sum(s.n_potential_accessible_ch_cm_co_pk_sk) as n_potential_accessible_ch_cm_co_pk_sk,
    sum(s.n_unknown_accessible_ch_cm_co_pk_sk) as n_unknown_accessible_ch_cm_co_pk_sk,
    sum(s.n_barriers_accessible_st) as n_barriers_accessible_st,
    sum(s.n_potential_accessible_st) as n_potential_accessible_st,
    sum(s.n_unknown_accessible_st) as n_unknown_accessible_st,
    sum(s.n_barriers_accessible_wct) as n_barriers_accessible_wct,
    sum(s.n_potential_accessible_wct) as n_potential_accessible_wct,
    sum(s.n_unknown_accessible_wct) as n_unknown_accessible_wct,
    sum(s.n_barriers_habitat_bt) as n_barriers_habitat_bt,
    sum(s.n_potential_habitat_bt) as n_potential_habitat_bt,
    sum(s.n_unknown_habitat_bt) as n_unknown_habitat_bt,
    sum(s.n_barriers_habitat_ch) as n_barriers_habitat_ch,
    sum(s.n_potential_habitat_ch) as n_potential_habitat_ch,
    sum(s.n_unknown_habitat_ch) as n_unknown_habitat_ch,
    sum(s.n_barriers_habitat_cm) as n_barriers_habitat_cm,
    sum(s.n_potential_habitat_cm) as n_potential_habitat_cm,
    sum(s.n_unknown_habitat_cm) as n_unknown_habitat_cm,
    sum(s.n_barriers_habitat_co) as n_barriers_habitat_co,
    sum(s.n_potential_habitat_co) as n_potential_habitat_co,
    sum(s.n_unknown_habitat_co) as n_unknown_habitat_co,
    sum(s.n_barriers_habitat_pk) as n_barriers_habitat_pk,
    sum(s.n_potential_habitat_pk) as n_potential_habitat_pk,
    sum(s.n_unknown_habitat_pk) as n_unknown_habitat_pk,
    sum(s.n_barriers_habitat_sk) as n_barriers_habitat_sk,
    sum(s.n_potential_habitat_sk) as n_potential_habitat_sk,
    sum(s.n_unknown_habitat_sk) as n_unknown_habitat_sk,
    sum(s.n_barriers_habitat_salmon) as n_barriers_habitat_salmon,
    sum(s.n_potential_habitat_salmon) as n_potential_habitat_salmon,
    sum(s.n_unknown_habitat_salmon) as n_unknown_habitat_salmon,
    sum(s.n_barriers_habitat_st) as n_barriers_habitat_st,
    sum(s.n_potential_habitat_st) as n_potential_habitat_st,
    sum(s.n_unknown_habitat_st) as n_unknown_habitat_st,
    sum(s.n_barriers_habitat_wct) as n_barriers_habitat_wct,
    sum(s.n_potential_habitat_wct) as n_potential_habitat_wct,
    sum(s.n_unknown_habitat_wct) as n_unknown_habitat_wct
   FROM (bcfishpass.log_aw_crossing_summary s
     JOIN bcfishpass.log l ON ((s.model_run_id = l.model_run_id))
     JOIN whse_basemapping.fwa_assessment_watersheds_poly aw ON (s.assessment_watershed_id = aw.watershed_feature_id)
     )
  WHERE (l.model_run_id = ( SELECT log.model_run_id
           FROM bcfishpass.log
          ORDER BY log.model_run_id DESC
         OFFSET 1
         LIMIT 1))
  GROUP BY s.model_run_id, aw.watershed_group_code, s.crossing_feature_type
  ORDER BY s.model_run_id, aw.watershed_group_code, s.crossing_feature_type;


  -- wsg diff view is basically unchanged, but the join is fixed in case there are new feature types added per group across model runs
  CREATE VIEW bcfishpass.wsg_crossing_summary_diff AS
  SELECT a.watershed_group_code,
    a.crossing_feature_type,
    (a.n_crossings_total - b.n_crossings_total) AS n_crossings_total,
    (a.n_passable_total - b.n_passable_total) AS n_passable_total,
    (a.n_barriers_total - b.n_barriers_total) AS n_barriers_total,
    (a.n_potential_total - b.n_potential_total) AS n_potential_total,
    (a.n_unknown_total - b.n_unknown_total) AS n_unknown_total,
    (a.n_barriers_accessible_bt - b.n_barriers_accessible_bt) AS n_barriers_accessible_bt,
    (a.n_potential_accessible_bt - b.n_potential_accessible_bt) AS n_potential_accessible_bt,
    (a.n_unknown_accessible_bt - b.n_unknown_accessible_bt) AS n_unknown_accessible_bt,
    (a.n_barriers_accessible_ch_cm_co_pk_sk - b.n_barriers_accessible_ch_cm_co_pk_sk) AS n_barriers_accessible_ch_cm_co_pk_sk,
    (a.n_potential_accessible_ch_cm_co_pk_sk - b.n_potential_accessible_ch_cm_co_pk_sk) AS n_potential_accessible_ch_cm_co_pk_sk,
    (a.n_unknown_accessible_ch_cm_co_pk_sk - b.n_unknown_accessible_ch_cm_co_pk_sk) AS n_unknown_accessible_ch_cm_co_pk_sk,
    (a.n_barriers_accessible_st - b.n_barriers_accessible_st) AS n_barriers_accessible_st,
    (a.n_potential_accessible_st - b.n_potential_accessible_st) AS n_potential_accessible_st,
    (a.n_unknown_accessible_st - b.n_unknown_accessible_st) AS n_unknown_accessible_st,
    (a.n_barriers_accessible_wct - b.n_barriers_accessible_wct) AS n_barriers_accessible_wct,
    (a.n_potential_accessible_wct - b.n_potential_accessible_wct) AS n_potential_accessible_wct,
    (a.n_unknown_accessible_wct - b.n_unknown_accessible_wct) AS n_unknown_accessible_wct,
    (a.n_barriers_habitat_bt - b.n_barriers_habitat_bt) AS n_barriers_habitat_bt,
    (a.n_potential_habitat_bt - b.n_potential_habitat_bt) AS n_potential_habitat_bt,
    (a.n_unknown_habitat_bt - b.n_unknown_habitat_bt) AS n_unknown_habitat_bt,
    (a.n_barriers_habitat_ch - b.n_barriers_habitat_ch) AS n_barriers_habitat_ch,
    (a.n_potential_habitat_ch - b.n_potential_habitat_ch) AS n_potential_habitat_ch,
    (a.n_unknown_habitat_ch - b.n_unknown_habitat_ch) AS n_unknown_habitat_ch,
    (a.n_barriers_habitat_cm - b.n_barriers_habitat_cm) AS n_barriers_habitat_cm,
    (a.n_potential_habitat_cm - b.n_potential_habitat_cm) AS n_potential_habitat_cm,
    (a.n_unknown_habitat_cm - b.n_unknown_habitat_cm) AS n_unknown_habitat_cm,
    (a.n_barriers_habitat_co - b.n_barriers_habitat_co) AS n_barriers_habitat_co,
    (a.n_potential_habitat_co - b.n_potential_habitat_co) AS n_potential_habitat_co,
    (a.n_unknown_habitat_co - b.n_unknown_habitat_co) AS n_unknown_habitat_co,
    (a.n_barriers_habitat_pk - b.n_barriers_habitat_pk) AS n_barriers_habitat_pk,
    (a.n_potential_habitat_pk - b.n_potential_habitat_pk) AS n_potential_habitat_pk,
    (a.n_unknown_habitat_pk - b.n_unknown_habitat_pk) AS n_unknown_habitat_pk,
    (a.n_barriers_habitat_sk - b.n_barriers_habitat_sk) AS n_barriers_habitat_sk,
    (a.n_potential_habitat_sk - b.n_potential_habitat_sk) AS n_potential_habitat_sk,
    (a.n_unknown_habitat_sk - b.n_unknown_habitat_sk) AS n_unknown_habitat_sk,
    (a.n_barriers_habitat_salmon - b.n_barriers_habitat_salmon) AS n_barriers_habitat_salmon,
    (a.n_potential_habitat_salmon - b.n_potential_habitat_salmon) AS n_potential_habitat_salmon,
    (a.n_unknown_habitat_salmon - b.n_unknown_habitat_salmon) AS n_unknown_habitat_salmon,
    (a.n_barriers_habitat_st - b.n_barriers_habitat_st) AS n_barriers_habitat_st,
    (a.n_potential_habitat_st - b.n_potential_habitat_st) AS n_potential_habitat_st,
    (a.n_unknown_habitat_st - b.n_unknown_habitat_st) AS n_unknown_habitat_st,
    (a.n_barriers_habitat_wct - b.n_barriers_habitat_wct) AS n_barriers_habitat_wct,
    (a.n_potential_habitat_wct - b.n_potential_habitat_wct) AS n_potential_habitat_wct,
    (a.n_unknown_habitat_wct - b.n_unknown_habitat_wct) AS n_unknown_habitat_wct
   FROM (bcfishpass.wsg_crossing_summary_current a
     FULL OUTER JOIN bcfishpass.wsg_crossing_summary_previous b ON (((a.watershed_group_code = b.watershed_group_code) AND (a.crossing_feature_type = b.crossing_feature_type))))
  ORDER BY a.watershed_group_code;


COMMIT;
 
