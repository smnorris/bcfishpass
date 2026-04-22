--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2 (Ubuntu 16.2-1.pgdg22.04+1)
-- Dumped by pg_dump version 17.7 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: bcfishpass; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA bcfishpass;


--
-- Name: aw_linear_summary(); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.aw_linear_summary() RETURNS TABLE(assessment_watershed_id integer, length_total numeric, length_naturallyaccessible_obsrvd_bt numeric, length_naturallyaccessible_obsrvd_bt_access_a numeric, length_naturallyaccessible_obsrvd_bt_access_b numeric, length_naturallyaccessible_model_bt numeric, length_naturallyaccessible_model_bt_access_a numeric, length_naturallyaccessible_model_bt_access_b numeric, length_naturallyaccessible_obsrvd_ch numeric, length_naturallyaccessible_obsrvd_ch_access_a numeric, length_naturallyaccessible_obsrvd_ch_access_b numeric, length_naturallyaccessible_model_ch numeric, length_naturallyaccessible_model_ch_access_a numeric, length_naturallyaccessible_model_ch_access_b numeric, length_naturallyaccessible_obsrvd_cm numeric, length_naturallyaccessible_obsrvd_cm_access_a numeric, length_naturallyaccessible_obsrvd_cm_access_b numeric, length_naturallyaccessible_model_cm numeric, length_naturallyaccessible_model_cm_access_a numeric, length_naturallyaccessible_model_cm_access_b numeric, length_naturallyaccessible_obsrvd_co numeric, length_naturallyaccessible_obsrvd_co_access_a numeric, length_naturallyaccessible_obsrvd_co_access_b numeric, length_naturallyaccessible_model_co numeric, length_naturallyaccessible_model_co_access_a numeric, length_naturallyaccessible_model_co_access_b numeric, length_naturallyaccessible_obsrvd_pk numeric, length_naturallyaccessible_obsrvd_pk_access_a numeric, length_naturallyaccessible_obsrvd_pk_access_b numeric, length_naturallyaccessible_model_pk numeric, length_naturallyaccessible_model_pk_access_a numeric, length_naturallyaccessible_model_pk_access_b numeric, length_naturallyaccessible_obsrvd_sk numeric, length_naturallyaccessible_obsrvd_sk_access_a numeric, length_naturallyaccessible_obsrvd_sk_access_b numeric, length_naturallyaccessible_model_sk numeric, length_naturallyaccessible_model_sk_access_a numeric, length_naturallyaccessible_model_sk_access_b numeric, length_naturallyaccessible_obsrvd_salmon numeric, length_naturallyaccessible_obsrvd_salmon_access_a numeric, length_naturallyaccessible_obsrvd_salmon_access_b numeric, length_naturallyaccessible_model_salmon numeric, length_naturallyaccessible_model_salmon_access_a numeric, length_naturallyaccessible_model_salmon_access_b numeric, length_naturallyaccessible_obsrvd_st numeric, length_naturallyaccessible_obsrvd_st_access_a numeric, length_naturallyaccessible_obsrvd_st_access_b numeric, length_naturallyaccessible_model_st numeric, length_naturallyaccessible_model_st_access_a numeric, length_naturallyaccessible_model_st_access_b numeric, length_naturallyaccessible_obsrvd_wct numeric, length_naturallyaccessible_obsrvd_wct_access_a numeric, length_naturallyaccessible_obsrvd_wct_access_b numeric, length_naturallyaccessible_model_wct numeric, length_naturallyaccessible_model_wct_access_a numeric, length_naturallyaccessible_model_wct_access_b numeric, length_spawningrearing_obsrvd_bt numeric, length_spawningrearing_obsrvd_bt_access_a numeric, length_spawningrearing_obsrvd_bt_access_b numeric, length_spawningrearing_model_bt numeric, length_spawningrearing_model_bt_access_a numeric, length_spawningrearing_model_bt_access_b numeric, length_spawningrearing_obsrvd_ch numeric, length_spawningrearing_obsrvd_ch_access_a numeric, length_spawningrearing_obsrvd_ch_access_b numeric, length_spawningrearing_model_ch numeric, length_spawningrearing_model_ch_access_a numeric, length_spawningrearing_model_ch_access_b numeric, length_spawningrearing_obsrvd_cm numeric, length_spawningrearing_obsrvd_cm_access_a numeric, length_spawningrearing_obsrvd_cm_access_b numeric, length_spawningrearing_model_cm numeric, length_spawningrearing_model_cm_access_a numeric, length_spawningrearing_model_cm_access_b numeric, length_spawningrearing_obsrvd_co numeric, length_spawningrearing_obsrvd_co_access_a numeric, length_spawningrearing_obsrvd_co_access_b numeric, length_spawningrearing_model_co numeric, length_spawningrearing_model_co_access_a numeric, length_spawningrearing_model_co_access_b numeric, length_spawningrearing_obsrvd_pk numeric, length_spawningrearing_obsrvd_pk_access_a numeric, length_spawningrearing_obsrvd_pk_access_b numeric, length_spawningrearing_model_pk numeric, length_spawningrearing_model_pk_access_a numeric, length_spawningrearing_model_pk_access_b numeric, length_spawningrearing_obsrvd_sk numeric, length_spawningrearing_obsrvd_sk_access_a numeric, length_spawningrearing_obsrvd_sk_access_b numeric, length_spawningrearing_model_sk numeric, length_spawningrearing_model_sk_access_a numeric, length_spawningrearing_model_sk_access_b numeric, length_spawningrearing_obsrvd_st numeric, length_spawningrearing_obsrvd_st_access_a numeric, length_spawningrearing_obsrvd_st_access_b numeric, length_spawningrearing_model_st numeric, length_spawningrearing_model_st_access_a numeric, length_spawningrearing_model_st_access_b numeric, length_spawningrearing_obsrvd_wct numeric, length_spawningrearing_obsrvd_wct_access_a numeric, length_spawningrearing_obsrvd_wct_access_b numeric, length_spawningrearing_model_wct numeric, length_spawningrearing_model_wct_access_a numeric, length_spawningrearing_model_wct_access_b numeric, length_spawningrearing_obsrvd_salmon numeric, length_spawningrearing_obsrvd_salmon_access_a numeric, length_spawningrearing_obsrvd_salmon_access_b numeric, length_spawningrearing_model_salmon numeric, length_spawningrearing_model_salmon_access_a numeric, length_spawningrearing_model_salmon_access_b numeric, length_spawningrearing_obsrvd_salmon_st numeric, length_spawningrearing_obsrvd_salmon_st_access_a numeric, length_spawningrearing_obsrvd_salmon_st_access_b numeric, length_spawningrearing_model_salmon_st numeric, length_spawningrearing_model_salmon_st_access_a numeric, length_spawningrearing_model_salmon_st_access_b numeric)
    LANGUAGE sql
    AS $$

with accessible as
(
  select
    aw.assmnt_watershed_id as assessment_watershed_id,
    s.watershed_group_code,
    sum(st_length(geom)) length_total,

    sum(st_length(geom)) filter (where s.access_bt = 2) as length_naturallyaccessible_obsrvd_bt,
    sum(st_length(geom)) filter (where s.access_bt = 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_obsrvd_bt_access_a,
    sum(st_length(geom)) filter (where s.access_bt = 2 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_obsrvd_bt_access_b,
    sum(st_length(geom)) filter (where s.access_bt = 1) as length_naturallyaccessible_model_bt,
    sum(st_length(geom)) filter (where s.access_bt = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_model_bt_access_a,
    sum(st_length(geom)) filter (where s.access_bt = 1 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_model_bt_access_b,

    sum(st_length(geom)) filter (where s.access_ch = 2) as length_naturallyaccessible_obsrvd_ch,
    sum(st_length(geom)) filter (where s.access_ch = 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_obsrvd_ch_access_a,
    sum(st_length(geom)) filter (where s.access_ch = 2 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_obsrvd_ch_access_b,
    sum(st_length(geom)) filter (where s.access_ch = 1) as length_naturallyaccessible_model_ch,
    sum(st_length(geom)) filter (where s.access_ch = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_model_ch_access_a,
    sum(st_length(geom)) filter (where s.access_ch = 1 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_model_ch_access_b,

    sum(st_length(geom)) filter (where s.access_cm = 2) as length_naturallyaccessible_obsrvd_cm,
    sum(st_length(geom)) filter (where s.access_cm = 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_obsrvd_cm_access_a,
    sum(st_length(geom)) filter (where s.access_cm = 2 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_obsrvd_cm_access_b,
    sum(st_length(geom)) filter (where s.access_cm = 1) as length_naturallyaccessible_model_cm,
    sum(st_length(geom)) filter (where s.access_cm = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_model_cm_access_a,
    sum(st_length(geom)) filter (where s.access_cm = 1 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_model_cm_access_b,

    sum(st_length(geom)) filter (where s.access_co = 2) as length_naturallyaccessible_obsrvd_co,
    sum(st_length(geom)) filter (where s.access_co = 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_obsrvd_co_access_a,
    sum(st_length(geom)) filter (where s.access_co = 2 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_obsrvd_co_access_b,
    sum(st_length(geom)) filter (where s.access_co = 1) as length_naturallyaccessible_model_co,
    sum(st_length(geom)) filter (where s.access_co = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_model_co_access_a,
    sum(st_length(geom)) filter (where s.access_co = 1 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_model_co_access_b,

    sum(st_length(geom)) filter (where s.access_pk = 2) as length_naturallyaccessible_obsrvd_pk,
    sum(st_length(geom)) filter (where s.access_pk = 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_obsrvd_pk_access_a,
    sum(st_length(geom)) filter (where s.access_pk = 2 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_obsrvd_pk_access_b,
    sum(st_length(geom)) filter (where s.access_pk = 1) as length_naturallyaccessible_model_pk,
    sum(st_length(geom)) filter (where s.access_pk = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_model_pk_access_a,
    sum(st_length(geom)) filter (where s.access_pk = 1 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_model_pk_access_b,

    sum(st_length(geom)) filter (where s.access_sk = 2) as length_naturallyaccessible_obsrvd_sk,
    sum(st_length(geom)) filter (where s.access_sk = 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_obsrvd_sk_access_a,
    sum(st_length(geom)) filter (where s.access_sk = 2 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_obsrvd_sk_access_b,
    sum(st_length(geom)) filter (where s.access_sk = 1) as length_naturallyaccessible_model_sk,
    sum(st_length(geom)) filter (where s.access_sk = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_model_sk_access_a,
    sum(st_length(geom)) filter (where s.access_sk = 1 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_model_sk_access_b,

    sum(st_length(geom)) filter (where s.access_salmon = 2) as length_naturallyaccessible_obsrvd_salmon,
    sum(st_length(geom)) filter (where s.access_salmon = 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_obsrvd_salmon_access_a,
    sum(st_length(geom)) filter (where s.access_salmon = 2 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_obsrvd_salmon_access_b,
    sum(st_length(geom)) filter (where s.access_salmon = 1) as length_naturallyaccessible_model_salmon,
    sum(st_length(geom)) filter (where s.access_salmon = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_model_salmon_access_a,
    sum(st_length(geom)) filter (where s.access_salmon = 1 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_model_salmon_access_b,

    sum(st_length(geom)) filter (where s.access_st = 2) as length_naturallyaccessible_obsrvd_st,
    sum(st_length(geom)) filter (where s.access_st = 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_obsrvd_st_access_a,
    sum(st_length(geom)) filter (where s.access_st = 2 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_obsrvd_st_access_b,
    sum(st_length(geom)) filter (where s.access_st = 1) as length_naturallyaccessible_model_st,
    sum(st_length(geom)) filter (where s.access_st = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_model_st_access_a,
    sum(st_length(geom)) filter (where s.access_st = 1 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_model_st_access_b,

    sum(st_length(geom)) filter (where s.access_wct = 2) as length_naturallyaccessible_obsrvd_wct,
    sum(st_length(geom)) filter (where s.access_wct = 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_obsrvd_wct_access_a,
    sum(st_length(geom)) filter (where s.access_wct = 2 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_obsrvd_wct_access_b,
    sum(st_length(geom)) filter (where s.access_wct = 1) as length_naturallyaccessible_model_wct,
    sum(st_length(geom)) filter (where s.access_wct = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_naturallyaccessible_model_wct_access_a,
    sum(st_length(geom)) filter (where s.access_wct = 1 and barriers_anthropogenic_dnstr is null) as length_naturallyaccessible_model_wct_access_b
  from bcfishpass.streams_vw s
  inner join whse_basemapping.fwa_assessment_watersheds_streams_lut aw on s.linear_feature_id = aw.linear_feature_id
  group by aw.assmnt_watershed_id, s.watershed_group_code
),

spawning_rearing as (
  select
    aw.assmnt_watershed_id as assessment_watershed_id,
    s.watershed_group_code,

    -- bt
    sum(st_length(geom)) filter (where greatest(spawning_bt, rearing_bt) = 1) as length_spawningrearing_model_bt,
    sum(st_length(geom)) filter (where greatest(spawning_bt, rearing_bt) = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_model_bt_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_bt, rearing_bt) = 1 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_model_bt_access_b,
    sum(st_length(geom)) filter (where greatest(spawning_bt, rearing_bt) >= 2) as length_spawningrearing_obsrvd_bt,
    sum(st_length(geom)) filter (where greatest(spawning_bt, rearing_bt) >= 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_obsrvd_bt_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_bt, rearing_bt) >= 2 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_obsrvd_bt_access_b,

    -- ch
    sum(st_length(geom)) filter (where greatest(spawning_ch, rearing_ch) = 1) as length_spawningrearing_model_ch,
    sum(st_length(geom)) filter (where greatest(spawning_ch, rearing_ch) = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_model_ch_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_ch, rearing_ch) = 1 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_model_ch_access_b,
    sum(st_length(geom)) filter (where greatest(spawning_ch, rearing_ch) >= 2) as length_spawningrearing_obsrvd_ch,
    sum(st_length(geom)) filter (where greatest(spawning_ch, rearing_ch) >= 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_obsrvd_ch_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_ch, rearing_ch) >= 2 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_obsrvd_ch_access_b,

    -- cm
    sum(st_length(geom)) filter (where spawning_cm = 1) as length_spawningrearing_model_cm,
    sum(st_length(geom)) filter (where spawning_cm = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_model_cm_access_a,
    sum(st_length(geom)) filter (where spawning_cm = 1 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_model_cm_access_b,
    sum(st_length(geom)) filter (where spawning_cm >= 2) as length_spawningrearing_obsrvd_cm,
    sum(st_length(geom)) filter (where spawning_cm >= 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_obsrvd_cm_access_a,
    sum(st_length(geom)) filter (where spawning_cm >= 2 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_obsrvd_cm_access_b,

    -- co
    sum(st_length(geom)) filter (where greatest(spawning_co, rearing_co) = 1) as length_spawningrearing_model_co,
    sum(st_length(geom)) filter (where greatest(spawning_co, rearing_co) = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_model_co_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_co, rearing_co) = 1 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_model_co_access_b,
    sum(st_length(geom)) filter (where greatest(spawning_co, rearing_co) >= 2) as length_spawningrearing_obsrvd_co,
    sum(st_length(geom)) filter (where greatest(spawning_co, rearing_co) >= 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_obsrvd_co_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_co, rearing_co) >= 2 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_obsrvd_co_access_b,

    -- pk
    sum(st_length(geom)) filter (where spawning_pk = 1) as length_spawningrearing_model_pk,
    sum(st_length(geom)) filter (where spawning_pk = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_model_pk_access_a,
    sum(st_length(geom)) filter (where spawning_pk = 1 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_model_pk_access_b,
    sum(st_length(geom)) filter (where spawning_pk >= 2) as length_spawningrearing_obsrvd_pk,
    sum(st_length(geom)) filter (where spawning_pk >= 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_obsrvd_pk_access_a,
    sum(st_length(geom)) filter (where spawning_pk >= 2 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_obsrvd_pk_access_b,

    -- sk
    sum(st_length(geom)) filter (where greatest(spawning_sk, rearing_sk) = 1) as length_spawningrearing_model_sk,
    sum(st_length(geom)) filter (where greatest(spawning_sk, rearing_sk) = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_model_sk_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_sk, rearing_sk) = 1 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_model_sk_access_b,
    sum(st_length(geom)) filter (where greatest(spawning_sk, rearing_sk) >= 2) as length_spawningrearing_obsrvd_sk,
    sum(st_length(geom)) filter (where greatest(spawning_sk, rearing_sk) >= 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_obsrvd_sk_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_sk, rearing_sk) >= 2 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_obsrvd_sk_access_b,

    -- st
    sum(st_length(geom)) filter (where greatest(spawning_st, rearing_st) = 1) as length_spawningrearing_model_st,
    sum(st_length(geom)) filter (where greatest(spawning_st, rearing_st) = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_model_st_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_st, rearing_st) = 1 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_model_st_access_b,
    sum(st_length(geom)) filter (where greatest(spawning_st, rearing_st) >= 2) as length_spawningrearing_obsrvd_st,
    sum(st_length(geom)) filter (where greatest(spawning_st, rearing_st) >= 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_obsrvd_st_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_st, rearing_st) >= 2 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_obsrvd_st_access_b,

    -- wct
    sum(st_length(geom)) filter (where greatest(spawning_wct, rearing_wct) = 1) as length_spawningrearing_model_wct,
    sum(st_length(geom)) filter (where greatest(spawning_wct, rearing_wct) = 1 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_model_wct_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_wct, rearing_wct) = 1 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_model_wct_access_b,
    sum(st_length(geom)) filter (where greatest(spawning_wct, rearing_wct) >= 2) as length_spawningrearing_obsrvd_wct,
    sum(st_length(geom)) filter (where greatest(spawning_wct, rearing_wct) >= 2 and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawningrearing_obsrvd_wct_access_a,
    sum(st_length(geom)) filter (where greatest(spawning_wct, rearing_wct) >= 2 and barriers_anthropogenic_dnstr is null) as length_spawningrearing_obsrvd_wct_access_b,

    -- all salmon
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk) = 1
    ) as length_spawningrearing_model_salmon,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk) = 1
        and barriers_dams_dnstr is null
        and barriers_pscis_dnstr is null
    ) as length_spawningrearing_model_salmon_access_a,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk) = 1
        and barriers_anthropogenic_dnstr is null
    ) as length_spawningrearing_model_salmon_access_b,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk) >= 2
    ) as length_spawningrearing_obsrvd_salmon,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk) >= 2
        and barriers_dams_dnstr is null
        and barriers_pscis_dnstr is null
    ) as length_spawningrearing_obsrvd_salmon_access_a,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk) >= 2
        and barriers_anthropogenic_dnstr is null
      ) as length_spawningrearing_obsrvd_salmon_access_b,

    -- all salmon AND steelhead
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk, spawning_st, rearing_st) = 1
    ) as length_spawningrearing_model_salmon_st,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk, spawning_st, rearing_st) = 1
        and barriers_dams_dnstr is null
        and barriers_pscis_dnstr is null
    ) as length_spawningrearing_model_salmon_st_access_a,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk, spawning_st, rearing_st) = 1
        and barriers_anthropogenic_dnstr is null
    ) as length_spawningrearing_model_salmon_st_access_b,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk, spawning_st, rearing_st) >= 2
    ) as length_spawningrearing_obsrvd_salmon_st,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk, spawning_st, rearing_st) >= 2
        and barriers_dams_dnstr is null
        and barriers_pscis_dnstr is null
    ) as length_spawningrearing_obsrvd_salmon_st_access_a,
    sum(st_length(geom)) filter (
      where
        greatest(spawning_ch, rearing_ch, spawning_cm, spawning_co, rearing_co, spawning_pk, spawning_sk, rearing_sk, spawning_st, rearing_st) >= 2
        and barriers_anthropogenic_dnstr is null
    ) as length_spawningrearing_obsrvd_salmon_st_access_b
  from bcfishpass.streams_vw s
  inner join whse_basemapping.fwa_assessment_watersheds_streams_lut aw on s.linear_feature_id = aw.linear_feature_id
  group by aw.assmnt_watershed_id, s.watershed_group_code
)

-- set to km, round to nearest cm (keep the high precision because this data gets rolled up to watershed group)
select
  a.assessment_watershed_id,
  round((coalesce(a.length_total, 0) / 1000)::numeric, 5) as length_total,
  round((coalesce(a.length_naturallyaccessible_obsrvd_bt, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_bt,
  round((coalesce(a.length_naturallyaccessible_obsrvd_bt_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_bt_access_a,
  round((coalesce(a.length_naturallyaccessible_obsrvd_bt_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_bt_access_b,
  round((coalesce(a.length_naturallyaccessible_model_bt, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_bt,
  round((coalesce(a.length_naturallyaccessible_model_bt_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_bt_access_a,
  round((coalesce(a.length_naturallyaccessible_model_bt_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_bt_access_b,

  round((coalesce(a.length_naturallyaccessible_obsrvd_ch, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_ch,
  round((coalesce(a.length_naturallyaccessible_obsrvd_ch_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_ch_access_a,
  round((coalesce(a.length_naturallyaccessible_obsrvd_ch_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_ch_access_b,
  round((coalesce(a.length_naturallyaccessible_model_ch, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_ch,
  round((coalesce(a.length_naturallyaccessible_model_ch_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_ch_access_a,
  round((coalesce(a.length_naturallyaccessible_model_ch_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_ch_access_b,

  round((coalesce(a.length_naturallyaccessible_obsrvd_cm, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_cm,
  round((coalesce(a.length_naturallyaccessible_obsrvd_cm_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_cm_access_a,
  round((coalesce(a.length_naturallyaccessible_obsrvd_cm_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_cm_access_b,
  round((coalesce(a.length_naturallyaccessible_model_cm, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_cm,
  round((coalesce(a.length_naturallyaccessible_model_cm_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_cm_access_a,
  round((coalesce(a.length_naturallyaccessible_model_cm_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_cm_access_b,

  round((coalesce(a.length_naturallyaccessible_obsrvd_co, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_co,
  round((coalesce(a.length_naturallyaccessible_obsrvd_co_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_co_access_a,
  round((coalesce(a.length_naturallyaccessible_obsrvd_co_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_co_access_b,
  round((coalesce(a.length_naturallyaccessible_model_co, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_co,
  round((coalesce(a.length_naturallyaccessible_model_co_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_co_access_a,
  round((coalesce(a.length_naturallyaccessible_model_co_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_co_access_b,

  round((coalesce(a.length_naturallyaccessible_obsrvd_pk, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_pk,
  round((coalesce(a.length_naturallyaccessible_obsrvd_pk_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_pk_access_a,
  round((coalesce(a.length_naturallyaccessible_obsrvd_pk_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_pk_access_b,
  round((coalesce(a.length_naturallyaccessible_model_pk, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_pk,
  round((coalesce(a.length_naturallyaccessible_model_pk_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_pk_access_a,
  round((coalesce(a.length_naturallyaccessible_model_pk_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_pk_access_b,

  round((coalesce(a.length_naturallyaccessible_obsrvd_sk, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_sk,
  round((coalesce(a.length_naturallyaccessible_obsrvd_sk_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_sk_access_a,
  round((coalesce(a.length_naturallyaccessible_obsrvd_sk_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_sk_access_b,
  round((coalesce(a.length_naturallyaccessible_model_sk, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_sk,
  round((coalesce(a.length_naturallyaccessible_model_sk_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_sk_access_a,
  round((coalesce(a.length_naturallyaccessible_model_sk_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_sk_access_b,

  round((coalesce(a.length_naturallyaccessible_obsrvd_salmon, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_salmon,
  round((coalesce(a.length_naturallyaccessible_obsrvd_salmon_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_salmon_access_a,
  round((coalesce(a.length_naturallyaccessible_obsrvd_salmon_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_salmon_access_b,
  round((coalesce(a.length_naturallyaccessible_model_salmon, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_salmon,
  round((coalesce(a.length_naturallyaccessible_model_salmon_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_salmon_access_a,
  round((coalesce(a.length_naturallyaccessible_model_salmon_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_salmon_access_b,
  round((coalesce(a.length_naturallyaccessible_obsrvd_st, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_st,
  round((coalesce(a.length_naturallyaccessible_obsrvd_st_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_st_access_a,
  round((coalesce(a.length_naturallyaccessible_obsrvd_st_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_st_access_b,
  round((coalesce(a.length_naturallyaccessible_model_st, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_st,
  round((coalesce(a.length_naturallyaccessible_model_st_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_st_access_a,
  round((coalesce(a.length_naturallyaccessible_model_st_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_st_access_b,
  round((coalesce(a.length_naturallyaccessible_obsrvd_wct, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_wct,
  round((coalesce(a.length_naturallyaccessible_obsrvd_wct_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_wct_access_a,
  round((coalesce(a.length_naturallyaccessible_obsrvd_wct_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_obsrvd_wct_access_b,
  round((coalesce(a.length_naturallyaccessible_model_wct, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_wct,
  round((coalesce(a.length_naturallyaccessible_model_wct_access_a, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_wct_access_a,
  round((coalesce(a.length_naturallyaccessible_model_wct_access_b, 0) / 1000)::numeric, 5) as length_naturallyaccessible_model_wct_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_bt, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_bt,
  round((coalesce(h.length_spawningrearing_obsrvd_bt_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_bt_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_bt_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_bt_access_b,
  round((coalesce(h.length_spawningrearing_model_bt, 0) / 1000)::numeric, 5) as length_spawningrearing_model_bt,
  round((coalesce(h.length_spawningrearing_model_bt_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_bt_access_a,
  round((coalesce(h.length_spawningrearing_model_bt_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_bt_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_ch, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_ch,
  round((coalesce(h.length_spawningrearing_obsrvd_ch_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_ch_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_ch_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_ch_access_b,
  round((coalesce(h.length_spawningrearing_model_ch, 0) / 1000)::numeric, 5) as length_spawningrearing_model_ch,
  round((coalesce(h.length_spawningrearing_model_ch_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_ch_access_a,
  round((coalesce(h.length_spawningrearing_model_ch_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_ch_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_cm, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_cm,
  round((coalesce(h.length_spawningrearing_obsrvd_cm_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_cm_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_cm_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_cm_access_b,
  round((coalesce(h.length_spawningrearing_model_cm, 0) / 1000)::numeric, 5) as length_spawningrearing_model_cm,
  round((coalesce(h.length_spawningrearing_model_cm_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_cm_access_a,
  round((coalesce(h.length_spawningrearing_model_cm_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_cm_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_co, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_co,
  round((coalesce(h.length_spawningrearing_obsrvd_co_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_co_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_co_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_co_access_b,
  round((coalesce(h.length_spawningrearing_model_co, 0) / 1000)::numeric, 5) as length_spawningrearing_model_co,
  round((coalesce(h.length_spawningrearing_model_co_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_co_access_a,
  round((coalesce(h.length_spawningrearing_model_co_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_co_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_pk, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_pk,
  round((coalesce(h.length_spawningrearing_obsrvd_pk_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_pk_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_pk_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_pk_access_b,
  round((coalesce(h.length_spawningrearing_model_pk, 0) / 1000)::numeric, 5) as length_spawningrearing_model_pk,
  round((coalesce(h.length_spawningrearing_model_pk_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_pk_access_a,
  round((coalesce(h.length_spawningrearing_model_pk_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_pk_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_sk, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_sk,
  round((coalesce(h.length_spawningrearing_obsrvd_sk_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_sk_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_sk_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_sk_access_b,
  round((coalesce(h.length_spawningrearing_model_sk, 0) / 1000)::numeric, 5) as length_spawningrearing_model_sk,
  round((coalesce(h.length_spawningrearing_model_sk_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_sk_access_a,
  round((coalesce(h.length_spawningrearing_model_sk_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_sk_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_st, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_st,
  round((coalesce(h.length_spawningrearing_obsrvd_st_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_st_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_st_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_st_access_b,
  round((coalesce(h.length_spawningrearing_model_st, 0) / 1000)::numeric, 5) as length_spawningrearing_model_st,
  round((coalesce(h.length_spawningrearing_model_st_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_st_access_a,
  round((coalesce(h.length_spawningrearing_model_st_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_st_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_wct, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_wct,
  round((coalesce(h.length_spawningrearing_obsrvd_wct_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_wct_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_wct_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_wct_access_b,
  round((coalesce(h.length_spawningrearing_model_wct, 0) / 1000)::numeric, 5) as length_spawningrearing_model_wct,
  round((coalesce(h.length_spawningrearing_model_wct_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_wct_access_a,
  round((coalesce(h.length_spawningrearing_model_wct_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_wct_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_salmon, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_salmon,
  round((coalesce(h.length_spawningrearing_obsrvd_salmon_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_salmon_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_salmon_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_salmon_access_b,
  round((coalesce(h.length_spawningrearing_model_salmon, 0) / 1000)::numeric, 5) as length_spawningrearing_model_salmon,
  round((coalesce(h.length_spawningrearing_model_salmon_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_salmon_access_a,
  round((coalesce(h.length_spawningrearing_model_salmon_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_salmon_access_b,
  round((coalesce(h.length_spawningrearing_obsrvd_salmon_st, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_salmon_st,
  round((coalesce(h.length_spawningrearing_obsrvd_salmon_st_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_salmon_st_access_a,
  round((coalesce(h.length_spawningrearing_obsrvd_salmon_st_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_obsrvd_salmon_st_access_b,
  round((coalesce(h.length_spawningrearing_model_salmon_st, 0) / 1000)::numeric, 5) as length_spawningrearing_model_salmon_st,
  round((coalesce(h.length_spawningrearing_model_salmon_st_access_a, 0) / 1000)::numeric, 5) as length_spawningrearing_model_salmon_st_access_a,
  round((coalesce(h.length_spawningrearing_model_salmon_st_access_b, 0) / 1000)::numeric, 5) as length_spawningrearing_model_salmon_st_access_b
from accessible a
left outer join spawning_rearing h on a.assessment_watershed_id = h.assessment_watershed_id
order by a.assessment_watershed_id

$$;


--
-- Name: break_streams(text, text); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.break_streams(point_table text, wsg text) RETURNS void
    LANGUAGE plpgsql
    AS $$

BEGIN

  EXECUTE format('
    ---------------------------------------------------------------
    -- create a temp table where we segment streams at point locations
    ---------------------------------------------------------------
    CREATE TEMPORARY TABLE temp_streams AS
    WITH breakpoints AS
    (
    -- because we are rounding the measure, collapse any duplicates with DISTINCT
    -- note that rounding only works (does not potentially shift the point off of stream of interest)
    -- because we are joining only if the point is not within 1m of the endpoint
      SELECT DISTINCT
        blue_line_key,
        round(downstream_route_measure::numeric)::integer as downstream_route_measure
      FROM bcfishpass.%I
      WHERE watershed_group_code = %L
    ),

    to_break AS
    (
      SELECT
        s.segmented_stream_id,
        s.linear_feature_id,
        s.downstream_route_measure AS meas_stream_ds,
        s.upstream_route_measure AS meas_stream_us,
        b.downstream_route_measure AS meas_event
      FROM
        bcfishpass.streams s
        INNER JOIN breakpoints b
        ON s.blue_line_key = b.blue_line_key AND
        -- match based on measure, but only break stream lines where the
        -- barrier pt is >1m from the end of the existing stream segment
        (b.downstream_route_measure - s.downstream_route_measure) > 1 AND
        (s.upstream_route_measure - b.downstream_route_measure) > 1
    ),

    -- derive measures of new lines from break points
    new_measures AS
    (
      SELECT
        segmented_stream_id,
        linear_feature_id,
        --meas_stream_ds,
        --meas_stream_us,
        meas_event AS downstream_route_measure,
        lead(meas_event, 1, meas_stream_us) OVER (PARTITION BY segmented_stream_id
          ORDER BY meas_event) AS upstream_route_measure
      FROM
        to_break
    )

    -- create new geoms
    SELECT
      n.segmented_stream_id,
      s.linear_feature_id,
      n.downstream_route_measure,
      n.upstream_route_measure,
      s.upstream_area_ha             ,
      s.stream_order_parent          ,
      s.stream_order_max             ,
      s.map_upstream                 ,
      s.channel_width                ,
      s.mad_m3s                      ,
      (ST_Dump(ST_LocateBetween
        (s.geom, n.downstream_route_measure, n.upstream_route_measure
        ))).geom AS geom
    FROM new_measures n
    INNER JOIN bcfishpass.streams s ON n.segmented_stream_id = s.segmented_stream_id;


    ---------------------------------------------------------------
    -- shorten existing stream features
    ---------------------------------------------------------------
    WITH min_segs AS
    (
      SELECT DISTINCT ON (segmented_stream_id)
        segmented_stream_id,
        downstream_route_measure
      FROM
        temp_streams
      ORDER BY
        segmented_stream_id,
        downstream_route_measure ASC
    ),

    shortened AS
    (
      SELECT
        m.segmented_stream_id,
        ST_Length(ST_LocateBetween(s.geom, s.downstream_route_measure, m.downstream_route_measure)) as length_metre,
        (ST_Dump(ST_LocateBetween (s.geom, s.downstream_route_measure, m.downstream_route_measure))).geom as geom
      FROM min_segs m
      INNER JOIN bcfishpass.streams s
      ON m.segmented_stream_id = s.segmented_stream_id
    )

    UPDATE
      bcfishpass.streams a
    SET
      geom = b.geom
    FROM
      shortened b
    WHERE
      b.segmented_stream_id = a.segmented_stream_id;


    ---------------------------------------------------------------
    -- now insert new features
    ---------------------------------------------------------------
    INSERT INTO bcfishpass.streams
    (
      linear_feature_id,
      edge_type,
      blue_line_key,
      watershed_key,
      watershed_group_code,
      waterbody_key,
      wscode_ltree,
      localcode_ltree,
      gnis_name,
      stream_order,
      stream_magnitude,
      feature_code,
      upstream_area_ha             ,
      stream_order_parent          ,
      stream_order_max             ,
      map_upstream                 ,
      channel_width                ,
      mad_m3s                      ,
      geom
    )
    SELECT
      t.linear_feature_id,
      s.edge_type,
      s.blue_line_key,
      s.watershed_key,
      s.watershed_group_code,
      s.waterbody_key,
      s.wscode_ltree,
      s.localcode_ltree,
      s.gnis_name,
      s.stream_order,
      s.stream_magnitude,
      s.feature_code,
      t.upstream_area_ha             ,
      t.stream_order_parent          ,
      t.stream_order_max             ,
      t.map_upstream                 ,
      t.channel_width                ,
      t.mad_m3s                      ,
      t.geom
    FROM temp_streams t
    INNER JOIN whse_basemapping.fwa_stream_networks_sp s
    ON t.linear_feature_id = s.linear_feature_id
    ON CONFLICT DO NOTHING;',
    point_table,
    wsg
  );

END
$$;


--
-- Name: create_barrier_table(text); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.create_barrier_table(barriertype text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

    EXECUTE format('
        DROP TABLE IF EXISTS bcfishpass.%I;

        CREATE UNLOGGED TABLE bcfishpass.%I
        (
            %I text primary key,
            barrier_type text,
            barrier_name text,
            linear_feature_id integer,
            blue_line_key integer,
            watershed_key integer,
            downstream_route_measure double precision,
            wscode_ltree ltree,
            localcode_ltree ltree,
            watershed_group_code character varying (4),
            geom geometry(Point, 3005),
            UNIQUE (blue_line_key, downstream_route_measure)
        );',
        'barriers_' || barriertype,
        'barriers_' || barriertype,
        'barriers_' || barriertype || '_id'
    );

    EXECUTE format('
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I (linear_feature_id);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I (blue_line_key);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I (watershed_key);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I (blue_line_key, downstream_route_measure);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I (watershed_group_code);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I USING GIST (wscode_ltree);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I USING BTREE (wscode_ltree);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I USING GIST (localcode_ltree);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I USING BTREE (localcode_ltree);
        CREATE INDEX IF NOT EXISTS %I ON bcfishpass.%I USING GIST (geom);',
        'br_' || barriertype || '_linear_feature_id_idx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_blue_line_key_idx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_wskey_idx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_blk_meas_idx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_watershed_group_code_idx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_wscode_ltree_gidx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_wscode_ltree_bidx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_localcode_ltree_gidx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_localcode_ltree_bidx',
        'barriers_' || barriertype,
        'br_' || barriertype || '_geom_idx',
        'barriers_' || barriertype
    );

END
$$;


--
-- Name: load_dnstr(text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.load_dnstr(table_a text, table_a_id text, table_b text, table_b_id text, out_table text, dnstr_id text, include_equivalents text, wsg text) RETURNS void
    LANGUAGE plpgsql
    AS $_$

BEGIN

  EXECUTE format('

    insert into %5$s
    (%2$s, %6$s)

    select
      %2$s,
      array_agg(downstream_id) filter (where downstream_id is not null) as %6$s
    from
        (select
            a.%2$s,
            b.%4$s as downstream_id
        from
            %1$s a
        inner join %3$s b on
        fwa_downstream(
            a.blue_line_key,
            a.downstream_route_measure,
            a.wscode_ltree,
            a.localcode_ltree,
            b.blue_line_key,
            b.downstream_route_measure,
            b.wscode_ltree,
            b.localcode_ltree,
            %7$s,
            1
        )
        where a.watershed_group_code = %8$L
        order by
          a.%2$s,
          b.wscode_ltree desc,
          b.localcode_ltree desc,
          b.downstream_route_measure desc
        ) as d
    group by %2$s

    on conflict ( %2$s )
    do update set %6$s = EXCLUDED.%6$s;',
table_a,
table_a_id,
table_b,
table_b_id,
out_table,
dnstr_id,
include_equivalents,
wsg);

END
$_$;


--
-- Name: load_dnstr_chunked(text, text, text, text, text, text, text, integer, integer); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.load_dnstr_chunked(table_a text, table_a_id text, table_b text, table_b_id text, out_table text, dnstr_id text, include_equivalents text, chunk_limit integer, chunk_offset integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$

BEGIN

  EXECUTE format('

    with chunk as (
      select * 
      from %1$s 
      limit %8$s offset %9$s
    )

    insert into %5$s
    (%2$s, %6$s)

    select
      %2$s,
      array_agg(downstream_id) filter (where downstream_id is not null) as %6$s
    from
        (select
            a.%2$s,
            b.%4$s as downstream_id
        from
            chunk a
        inner join %3$s b on
        fwa_downstream(
            a.blue_line_key,
            a.downstream_route_measure,
            a.wscode_ltree,
            a.localcode_ltree,
            b.blue_line_key,
            b.downstream_route_measure,
            b.wscode_ltree,
            b.localcode_ltree,
            %7$s,
            1
        )
        order by
          a.%2$s,
          b.wscode_ltree desc,
          b.localcode_ltree desc,
          b.downstream_route_measure desc
        ) as d
    group by %2$s;',
table_a,
table_a_id,
table_b,
table_b_id,
out_table,
dnstr_id,
include_equivalents,
chunk_limit,
chunk_offset);

END
$_$;


--
-- Name: load_upstr(text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.load_upstr(table_a text, table_a_id text, table_b text, table_b_id text, out_table text, upstr_id text, include_equivalents text, wsg text) RETURNS void
    LANGUAGE plpgsql
    AS $_$

BEGIN

  EXECUTE format('

    insert into %5$s
    (%2$s, %6$s)

    select
      %2$s,
      array_agg(upstream_id) filter (where upstream_id is not null) as %6$s
    from
        (select
            a.%2$s,
            b.%4$s as upstream_id
        from
            %1$s a
        inner join %3$s b on
        fwa_upstream(
            a.blue_line_key,
            a.downstream_route_measure,
            a.wscode_ltree,
            a.localcode_ltree,
            b.blue_line_key,
            b.downstream_route_measure,
            b.wscode_ltree,
            b.localcode_ltree,
            %7$s,
            1
        )
        where a.watershed_group_code = %8$L
        order by
          a.%2$s,
          b.wscode_ltree desc,
          b.localcode_ltree desc,
          b.downstream_route_measure desc
        ) as d
    group by %2$s;',
table_a,
table_a_id,
table_b,
table_b_id,
out_table,
upstr_id,
include_equivalents,
wsg);

END
$_$;


--
-- Name: streamsasmvt(integer, integer, integer); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.streamsasmvt(z integer, x integer, y integer) RETURNS bytea
    LANGUAGE plpgsql STABLE PARALLEL SAFE
    AS $$
DECLARE
    result bytea;
BEGIN
    WITH
    
    bounds AS (
      SELECT ST_TileEnvelope(z, x, y) AS geom
    ), 

    mvtgeom AS (
      SELECT
        s.segmented_stream_id,
        s.linear_feature_id,
        s.edge_type,
        s.blue_line_key,
        s.watershed_key,
        s.watershed_group_code,
        s.downstream_route_measure,
        s.length_metre,
        s.waterbody_key,
        s.wscode_ltree,
        s.localcode_ltree,
        s.gnis_name,
        s.stream_order,
        s.stream_magnitude,
        s.gradient,
        s.feature_code,
        s.upstream_route_measure,
        s.upstream_area_ha,
        s.stream_order_parent,
        s.stream_order_max,
        s.map_upstream,
        s.channel_width,
        s.mad_m3s,
        s.barriers_anthropogenic_dnstr,
        s.barriers_pscis_dnstr,
        s.barriers_dams_dnstr,
        s.barriers_dams_hydro_dnstr,
        s.barriers_bt_dnstr,
        s.barriers_ch_cm_co_pk_sk_dnstr,
        s.barriers_ct_dv_rb_dnstr,
        s.barriers_st_dnstr,
        s.barriers_wct_dnstr,
        s.crossings_dnstr,
        s.dam_dnstr_ind,
        s.dam_hydro_dnstr_ind,
        s.remediated_dnstr_ind,
        s.obsrvtn_event_upstr,
        s.obsrvtn_species_codes_upstr,
        s.species_codes_dnstr,
        s.model_spawning_bt,
        s.model_spawning_ch,
        s.model_spawning_cm,
        s.model_spawning_co,
        s.model_spawning_pk,
        s.model_spawning_sk,
        s.model_spawning_st,
        s.model_spawning_wct,
        s.model_rearing_bt,
        s.model_rearing_ch,
        s.model_rearing_co,
        s.model_rearing_sk,
        s.model_rearing_st,
        s.model_rearing_wct,
        s.mapping_code_bt,
        s.mapping_code_ch,
        s.mapping_code_cm,
        s.mapping_code_co,
        s.mapping_code_pk,
        s.mapping_code_sk,
        s.mapping_code_st,
        s.mapping_code_wct,
        s.mapping_code_salmon,
        ST_AsMVTGeom(ST_Transform(ST_Force2D(s.geom), 3857), bounds.geom)
      FROM bcfishpass.streams s, bounds
      WHERE ST_Intersects(s.geom, ST_Transform((select geom from bounds), 3005))
      AND s.edge_type != 6010 
      AND s.wscode_ltree is not null
      AND s.stream_order_max >= (-z + 13)
     )

    SELECT ST_AsMVT(mvtgeom, 'default')
    INTO result
    FROM mvtgeom;

    RETURN result;
END;
$$;


--
-- Name: FUNCTION streamsasmvt(z integer, x integer, y integer); Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON FUNCTION bcfishpass.streamsasmvt(z integer, x integer, y integer) IS 'Zoom-level dependent bcfishpass streams';


--
-- Name: utmzone(public.geometry); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.utmzone(public.geometry) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
 DECLARE
     geomgeog geometry;
     zone int;
     pref int;

 BEGIN
     geomgeog:= ST_Transform($1, 4326);

     IF (ST_Y(geomgeog))>0 THEN
        pref:=32600;
     ELSE
        pref:=32700;
     END IF;

     zone:=floor((ST_X(geomgeog)+180)/6)+1;

     RETURN zone+pref;
 END;
 $_$;


--
-- Name: wsg_crossing_summary(); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.wsg_crossing_summary() RETURNS TABLE(watershed_group_code text, crossing_feature_type text, n_crossings_total integer, n_passable_total integer, n_barriers_total integer, n_potential_total integer, n_unknown_total integer, n_barriers_accessible_bt integer, n_potential_accessible_bt integer, n_unknown_accessible_bt integer, n_barriers_accessible_ch_cm_co_pk_sk integer, n_potential_accessible_ch_cm_co_pk_sk integer, n_unknown_accessible_ch_cm_co_pk_sk integer, n_barriers_accessible_st integer, n_potential_accessible_st integer, n_unknown_accessible_st integer, n_barriers_accessible_wct integer, n_potential_accessible_wct integer, n_unknown_accessible_wct integer, n_barriers_habitat_bt integer, n_potential_habitat_bt integer, n_unknown_habitat_bt integer, n_barriers_habitat_ch integer, n_potential_habitat_ch integer, n_unknown_habitat_ch integer, n_barriers_habitat_cm integer, n_potential_habitat_cm integer, n_unknown_habitat_cm integer, n_barriers_habitat_co integer, n_potential_habitat_co integer, n_unknown_habitat_co integer, n_barriers_habitat_pk integer, n_potential_habitat_pk integer, n_unknown_habitat_pk integer, n_barriers_habitat_sk integer, n_potential_habitat_sk integer, n_unknown_habitat_sk integer, n_barriers_habitat_salmon integer, n_potential_habitat_salmon integer, n_unknown_habitat_salmon integer, n_barriers_habitat_st integer, n_potential_habitat_st integer, n_unknown_habitat_st integer, n_barriers_habitat_wct integer, n_potential_habitat_wct integer, n_unknown_habitat_wct integer)
    LANGUAGE sql
    AS $$

select
  watershed_group_code,
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

from bcfishpass.crossings_vw
group by watershed_group_code, crossing_feature_type
order by watershed_group_code, crossing_feature_type;

$$;


--
-- Name: wsg_linear_summary(); Type: FUNCTION; Schema: bcfishpass; Owner: -
--

CREATE FUNCTION bcfishpass.wsg_linear_summary() RETURNS TABLE(watershed_group_code text, length_total numeric, length_potentiallyaccessible_bt numeric, length_potentiallyaccessible_bt_observed numeric, length_potentiallyaccessible_bt_accessible_a numeric, length_potentiallyaccessible_bt_accessible_b numeric, length_obsrvd_spawning_rearing_bt numeric, length_obsrvd_spawning_rearing_bt_accessible_a numeric, length_obsrvd_spawning_rearing_bt_accessible_b numeric, length_spawning_rearing_bt numeric, length_spawning_rearing_bt_accessible_a numeric, length_spawning_rearing_bt_accessible_b numeric, length_potentiallyaccessible_ch_cm_co_pk_sk numeric, length_potentiallyaccessible_ch_cm_co_pk_sk_observed numeric, length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_a numeric, length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_b numeric, length_obsrvd_spawning_rearing_ch numeric, length_obsrvd_spawning_rearing_ch_accessible_a numeric, length_obsrvd_spawning_rearing_ch_accessible_b numeric, length_spawning_rearing_ch numeric, length_spawning_rearing_ch_accessible_a numeric, length_spawning_rearing_ch_accessible_b numeric, length_obsrvd_spawning_rearing_cm numeric, length_obsrvd_spawning_rearing_cm_accessible_a numeric, length_obsrvd_spawning_rearing_cm_accessible_b numeric, length_spawning_rearing_cm numeric, length_spawning_rearing_cm_accessible_a numeric, length_spawning_rearing_cm_accessible_b numeric, length_obsrvd_spawning_rearing_co numeric, length_obsrvd_spawning_rearing_co_accessible_a numeric, length_obsrvd_spawning_rearing_co_accessible_b numeric, length_spawning_rearing_co numeric, length_spawning_rearing_co_accessible_a numeric, length_spawning_rearing_co_accessible_b numeric, length_obsrvd_spawning_rearing_pk numeric, length_obsrvd_spawning_rearing_pk_accessible_a numeric, length_obsrvd_spawning_rearing_pk_accessible_b numeric, length_spawning_rearing_pk numeric, length_spawning_rearing_pk_accessible_a numeric, length_spawning_rearing_pk_accessible_b numeric, length_obsrvd_spawning_rearing_sk numeric, length_obsrvd_spawning_rearing_sk_accessible_a numeric, length_obsrvd_spawning_rearing_sk_accessible_b numeric, length_spawning_rearing_sk numeric, length_spawning_rearing_sk_accessible_a numeric, length_spawning_rearing_sk_accessible_b numeric, length_potentiallyaccessible_st numeric, length_potentiallyaccessible_st_observed numeric, length_potentiallyaccessible_st_accessible_a numeric, length_potentiallyaccessible_st_accessible_b numeric, length_obsrvd_spawning_rearing_st numeric, length_obsrvd_spawning_rearing_st_accessible_a numeric, length_obsrvd_spawning_rearing_st_accessible_b numeric, length_spawning_rearing_st numeric, length_spawning_rearing_st_accessible_a numeric, length_spawning_rearing_st_accessible_b numeric, length_potentiallyaccessible_wct numeric, length_potentiallyaccessible_wct_observed numeric, length_potentiallyaccessible_wct_accessible_a numeric, length_potentiallyaccessible_wct_accessible_b numeric, length_obsrvd_spawning_rearing_wct numeric, length_obsrvd_spawning_rearing_wct_accessible_a numeric, length_obsrvd_spawning_rearing_wct_accessible_b numeric, length_spawning_rearing_wct numeric, length_spawning_rearing_wct_accessible_a numeric, length_spawning_rearing_wct_accessible_b numeric)
    LANGUAGE sql
    AS $$

with accessible as
(
  select
    s.watershed_group_code,
    sum(st_length(geom)) length_total,    
    
    sum(st_length(geom)) filter (where barriers_bt_dnstr = array[]::text[]) as length_potentiallyaccessible_bt,
    sum(st_length(geom)) filter (where barriers_bt_dnstr = array[]::text[] and 'BT' = any(obsrvtn_species_codes_upstr)) as length_potentiallyaccessible_bt_observed,
    sum(st_length(geom)) filter (where barriers_bt_dnstr = array[]::text[] and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_potentiallyaccessible_bt_accessible_a,
    sum(st_length(geom)) filter (where barriers_bt_dnstr = array[]::text[] and barriers_anthropogenic_dnstr is null) as length_potentiallyaccessible_bt_accessible_b,

    sum(st_length(geom)) filter (where barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]) as length_potentiallyaccessible_ch_cm_co_pk_sk,
    sum(st_length(geom)) filter (where barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and obsrvtn_species_codes_upstr && array['CH','CM','CO','PK','SK']) as length_potentiallyaccessible_ch_cm_co_pk_sk_observed,
    sum(st_length(geom)) filter (where barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_a,
    sum(st_length(geom)) filter (where barriers_ch_cm_co_pk_sk_dnstr = array[]::text[] and barriers_anthropogenic_dnstr is null) as length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_b,

    sum(st_length(geom)) filter (where barriers_st_dnstr = array[]::text[]) as length_potentiallyaccessible_st,
    sum(st_length(geom)) filter (where barriers_st_dnstr = array[]::text[] and 'ST' = any(obsrvtn_species_codes_upstr)) as length_potentiallyaccessible_st_observed,
    sum(st_length(geom)) filter (where barriers_st_dnstr = array[]::text[] and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_potentiallyaccessible_st_accessible_a,
    sum(st_length(geom)) filter (where barriers_st_dnstr = array[]::text[] and barriers_anthropogenic_dnstr is null) as length_potentiallyaccessible_st_accessible_b,
    
    sum(st_length(geom)) filter (where barriers_wct_dnstr = array[]::text[]) as length_potentiallyaccessible_wct,
    sum(st_length(geom)) filter (where barriers_wct_dnstr = array[]::text[] and 'WCT' = any(obsrvtn_species_codes_upstr)) as length_potentiallyaccessible_wct_observed,
    sum(st_length(geom)) filter (where barriers_wct_dnstr = array[]::text[] and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_potentiallyaccessible_wct_accessible_a,
    sum(st_length(geom)) filter (where barriers_wct_dnstr = array[]::text[] and barriers_anthropogenic_dnstr is null) as length_potentiallyaccessible_wct_accessible_b
  from bcfishpass.streams_access_vw sv
  inner join bcfishpass.streams s on sv.segmented_stream_id = s.segmented_stream_id
  group by watershed_group_code
),

spawning_rearing_observed as (
  select
    s.watershed_group_code,
    sum(st_length(geom)) filter (where h.spawning_bt is true or h.rearing_bt is true) as length_obsrvd_spawning_rearing_bt,
    sum(st_length(geom)) filter (where (h.spawning_bt is true or h.rearing_bt is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_bt_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_bt is true or h.rearing_bt is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_bt_accessible_b,
    
    sum(st_length(geom)) filter (where h.spawning_ch is true or h.rearing_ch is true) as length_obsrvd_spawning_rearing_ch,
    sum(st_length(geom)) filter (where (h.spawning_ch is true or h.rearing_ch is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_ch_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_ch is true or h.rearing_ch is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_ch_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_cm is true) as length_obsrvd_spawning_rearing_cm,
    sum(st_length(geom)) filter (where (h.spawning_cm is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_cm_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_cm is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_cm_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_co is true or h.rearing_co is true) as length_obsrvd_spawning_rearing_co,
    sum(st_length(geom)) filter (where (h.spawning_co is true or h.rearing_co is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_co_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_co is true or h.rearing_co is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_co_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_pk is true) as length_obsrvd_spawning_rearing_pk,
    sum(st_length(geom)) filter (where (h.spawning_pk is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_pk_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_pk is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_pk_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_sk is true or h.rearing_sk is true) as length_obsrvd_spawning_rearing_sk,
    sum(st_length(geom)) filter (where (h.spawning_sk is true or h.rearing_sk is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_sk_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_sk is true or h.rearing_sk is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_sk_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_st is true or h.rearing_st is true) as length_obsrvd_spawning_rearing_st,
    sum(st_length(geom)) filter (where (h.spawning_st is true or h.rearing_st is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_st_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_st is true or h.rearing_st is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_st_accessible_b,
    
    sum(st_length(geom)) filter (where h.spawning_wct is true or h.rearing_wct is true) as length_obsrvd_spawning_rearing_wct,
    sum(st_length(geom)) filter (where (h.spawning_wct is true or h.rearing_wct is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_obsrvd_spawning_rearing_wct_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_wct is true or h.rearing_wct is true) and barriers_anthropogenic_dnstr is null) as length_obsrvd_spawning_rearing_wct_accessible_b
  from bcfishpass.streams_access_vw sv
  left outer join bcfishpass.streams_habitat_known_vw h on sv.segmented_stream_id = h.segmented_stream_id
  inner join bcfishpass.streams s on sv.segmented_stream_id = s.segmented_stream_id
  group by watershed_group_code
),

spawning_rearing_modelled as (
  select
    s.watershed_group_code,
    sum(st_length(geom)) filter (where h.spawning_bt is true or h.rearing_bt is true) as length_spawning_rearing_bt,
    sum(st_length(geom)) filter (where (h.spawning_bt is true or h.rearing_bt is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_bt_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_bt is true or h.rearing_bt is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_bt_accessible_b,
    
    sum(st_length(geom)) filter (where h.spawning_ch is true or h.rearing_ch is true) as length_spawning_rearing_ch,
    sum(st_length(geom)) filter (where (h.spawning_ch is true or h.rearing_ch is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_ch_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_ch is true or h.rearing_ch is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_ch_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_cm is true) as length_spawning_rearing_cm,
    sum(st_length(geom)) filter (where (h.spawning_cm is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_cm_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_cm is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_cm_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_co is true or h.rearing_co is true) as length_spawning_rearing_co,
    sum(st_length(geom)) filter (where (h.spawning_co is true or h.rearing_co is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_co_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_co is true or h.rearing_co is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_co_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_pk is true) as length_spawning_rearing_pk,
    sum(st_length(geom)) filter (where (h.spawning_pk is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_pk_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_pk is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_pk_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_sk is true or h.rearing_sk is true) as length_spawning_rearing_sk,
    sum(st_length(geom)) filter (where (h.spawning_sk is true or h.rearing_sk is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_sk_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_sk is true or h.rearing_sk is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_sk_accessible_b,

    sum(st_length(geom)) filter (where h.spawning_st is true or h.rearing_st is true) as length_spawning_rearing_st,
    sum(st_length(geom)) filter (where (h.spawning_st is true or h.rearing_st is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_st_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_st is true or h.rearing_st is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_st_accessible_b,
    
    sum(st_length(geom)) filter (where h.spawning_wct is true or h.rearing_wct is true) as length_spawning_rearing_wct,
    sum(st_length(geom)) filter (where (h.spawning_wct is true or h.rearing_wct is true) and barriers_dams_dnstr is null and barriers_pscis_dnstr is null) as length_spawning_rearing_wct_accessible_a,
    sum(st_length(geom)) filter (where (h.spawning_wct is true or h.rearing_wct is true) and barriers_anthropogenic_dnstr is null) as length_spawning_rearing_wct_accessible_b
  from bcfishpass.streams_access_vw sv
  left outer join bcfishpass.streams_habitat_linear_vw h on sv.segmented_stream_id = h.segmented_stream_id
  inner join bcfishpass.streams s on sv.segmented_stream_id = s.segmented_stream_id
  group by watershed_group_code
)

-- round to nearest km
select
  a.watershed_group_code,
  round((coalesce(a.length_total, 0) / 1000)::numeric, 2) as length_total,
  -- bull trout
  round((coalesce(a.length_potentiallyaccessible_bt, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_bt,
  round((coalesce(a.length_potentiallyaccessible_bt_observed, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_bt_observed,
  round((coalesce(a.length_potentiallyaccessible_bt_accessible_a, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_bt_accessible_a,
  round((coalesce(a.length_potentiallyaccessible_bt_accessible_b, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_bt_accessible_b,
  round((coalesce(o.length_obsrvd_spawning_rearing_bt, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_bt,
  round((coalesce(o.length_obsrvd_spawning_rearing_bt_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_bt_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_bt_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_bt_accessible_b,
  round((coalesce(m.length_spawning_rearing_bt, 0) / 1000)::numeric, 2) as length_spawning_rearing_bt,
  round((coalesce(m.length_spawning_rearing_bt_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_bt_accessible_a,
  round((coalesce(m.length_spawning_rearing_bt_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_bt_accessible_b,

  -- salmon access
  round((coalesce(a.length_potentiallyaccessible_ch_cm_co_pk_sk, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_ch_cm_co_pk_sk,
  round((coalesce(a.length_potentiallyaccessible_ch_cm_co_pk_sk_observed, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_ch_cm_co_pk_sk_observed,
  round((coalesce(a.length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_a, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_a,
  round((coalesce(a.length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_b, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_b,
  
  --ch/cm/co/pk/sk spawning/rearing reported separately
  round((coalesce(o.length_obsrvd_spawning_rearing_ch, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_ch,
  round((coalesce(o.length_obsrvd_spawning_rearing_ch_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_ch_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_ch_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_ch_accessible_b,
  round((coalesce(m.length_spawning_rearing_ch, 0) / 1000)::numeric, 2) as length_spawning_rearing_ch,
  round((coalesce(m.length_spawning_rearing_ch_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_ch_accessible_a,
  round((coalesce(m.length_spawning_rearing_ch_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_ch_accessible_b,

  round((coalesce(o.length_obsrvd_spawning_rearing_cm, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_cm,
  round((coalesce(o.length_obsrvd_spawning_rearing_cm_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_cm_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_cm_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_cm_accessible_b,
  round((coalesce(m.length_spawning_rearing_cm, 0) / 1000)::numeric, 2) as length_spawning_rearing_cm,
  round((coalesce(m.length_spawning_rearing_cm_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_cm_accessible_a,
  round((coalesce(m.length_spawning_rearing_cm_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_cm_accessible_b,

  round((coalesce(o.length_obsrvd_spawning_rearing_co, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_co,
  round((coalesce(o.length_obsrvd_spawning_rearing_co_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_co_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_co_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_co_accessible_b,
  round((coalesce(m.length_spawning_rearing_co, 0) / 1000)::numeric, 2) as length_spawning_rearing_co,
  round((coalesce(m.length_spawning_rearing_co_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_co_accessible_a,
  round((coalesce(m.length_spawning_rearing_co_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_co_accessible_b,

  round((coalesce(o.length_obsrvd_spawning_rearing_pk, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_pk,
  round((coalesce(o.length_obsrvd_spawning_rearing_pk_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_pk_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_pk_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_pk_accessible_b,
  round((coalesce(m.length_spawning_rearing_pk, 0) / 1000)::numeric, 2) as length_spawning_rearing_pk,
  round((coalesce(m.length_spawning_rearing_pk_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_pk_accessible_a,
  round((coalesce(m.length_spawning_rearing_pk_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_pk_accessible_b,

  round((coalesce(o.length_obsrvd_spawning_rearing_sk, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_sk,
  round((coalesce(o.length_obsrvd_spawning_rearing_sk_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_sk_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_sk_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_sk_accessible_b,
  round((coalesce(m.length_spawning_rearing_sk, 0) / 1000)::numeric, 2) as length_spawning_rearing_sk,
  round((coalesce(m.length_spawning_rearing_sk_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_sk_accessible_a,
  round((coalesce(m.length_spawning_rearing_sk_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_sk_accessible_b,

  -- steelhead
  round((coalesce(a.length_potentiallyaccessible_st, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_st,
  round((coalesce(a.length_potentiallyaccessible_st_observed, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_st_observed,
  round((coalesce(a.length_potentiallyaccessible_st_accessible_a, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_st_accessible_a,
  round((coalesce(a.length_potentiallyaccessible_st_accessible_b, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_st_accessible_b,
  round((coalesce(o.length_obsrvd_spawning_rearing_st, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_st,
  round((coalesce(o.length_obsrvd_spawning_rearing_st_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_st_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_st_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_st_accessible_b,
  round((coalesce(m.length_spawning_rearing_st, 0) / 1000)::numeric, 2) as length_spawning_rearing_st,
  round((coalesce(m.length_spawning_rearing_st_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_st_accessible_a,
  round((coalesce(m.length_spawning_rearing_st_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_st_accessible_b,

  -- wct
  round((coalesce(a.length_potentiallyaccessible_wct, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_wct,
  round((coalesce(a.length_potentiallyaccessible_wct_observed, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_wct_observed,
  round((coalesce(a.length_potentiallyaccessible_wct_accessible_a, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_wct_accessible_a,
  round((coalesce(a.length_potentiallyaccessible_wct_accessible_b, 0) / 1000)::numeric, 2) as length_potentiallyaccessible_wct_accessible_b,
  round((coalesce(o.length_obsrvd_spawning_rearing_wct, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_wct,
  round((coalesce(o.length_obsrvd_spawning_rearing_wct_accessible_a, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_wct_accessible_a,
  round((coalesce(o.length_obsrvd_spawning_rearing_wct_accessible_b, 0) / 1000)::numeric, 2) as length_obsrvd_spawning_rearing_wct_accessible_b,
  round((coalesce(m.length_spawning_rearing_wct, 0) / 1000)::numeric, 2) as length_spawning_rearing_wct,
  round((coalesce(m.length_spawning_rearing_wct_accessible_a, 0) / 1000)::numeric, 2) as length_spawning_rearing_wct_accessible_a,
  round((coalesce(m.length_spawning_rearing_wct_accessible_b, 0) / 1000)::numeric, 2) as length_spawning_rearing_wct_accessible_b

from accessible a
left outer join spawning_rearing_observed o on a.watershed_group_code = o.watershed_group_code
left outer join spawning_rearing_modelled m  on a.watershed_group_code = m.watershed_group_code
order by a.watershed_group_code;

$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: log; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.log (
    model_run_id integer NOT NULL,
    model_type text NOT NULL,
    date_completed timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    model_version text NOT NULL,
    CONSTRAINT log_model_type_check CHECK ((model_type = ANY (ARRAY['LINEAR'::text, 'LATERAL'::text])))
);


--
-- Name: log_aw_linear_summary; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.log_aw_linear_summary (
    model_run_id integer,
    assessment_watershed_id integer,
    length_total numeric,
    length_naturallyaccessible_obsrvd_bt numeric,
    length_naturallyaccessible_obsrvd_bt_access_a numeric,
    length_naturallyaccessible_obsrvd_bt_access_b numeric,
    length_naturallyaccessible_model_bt numeric,
    length_naturallyaccessible_model_bt_access_a numeric,
    length_naturallyaccessible_model_bt_access_b numeric,
    length_naturallyaccessible_obsrvd_ch numeric,
    length_naturallyaccessible_obsrvd_ch_access_a numeric,
    length_naturallyaccessible_obsrvd_ch_access_b numeric,
    length_naturallyaccessible_model_ch numeric,
    length_naturallyaccessible_model_ch_access_a numeric,
    length_naturallyaccessible_model_ch_access_b numeric,
    length_naturallyaccessible_obsrvd_cm numeric,
    length_naturallyaccessible_obsrvd_cm_access_a numeric,
    length_naturallyaccessible_obsrvd_cm_access_b numeric,
    length_naturallyaccessible_model_cm numeric,
    length_naturallyaccessible_model_cm_access_a numeric,
    length_naturallyaccessible_model_cm_access_b numeric,
    length_naturallyaccessible_obsrvd_co numeric,
    length_naturallyaccessible_obsrvd_co_access_a numeric,
    length_naturallyaccessible_obsrvd_co_access_b numeric,
    length_naturallyaccessible_model_co numeric,
    length_naturallyaccessible_model_co_access_a numeric,
    length_naturallyaccessible_model_co_access_b numeric,
    length_naturallyaccessible_obsrvd_pk numeric,
    length_naturallyaccessible_obsrvd_pk_access_a numeric,
    length_naturallyaccessible_obsrvd_pk_access_b numeric,
    length_naturallyaccessible_model_pk numeric,
    length_naturallyaccessible_model_pk_access_a numeric,
    length_naturallyaccessible_model_pk_access_b numeric,
    length_naturallyaccessible_obsrvd_sk numeric,
    length_naturallyaccessible_obsrvd_sk_access_a numeric,
    length_naturallyaccessible_obsrvd_sk_access_b numeric,
    length_naturallyaccessible_model_sk numeric,
    length_naturallyaccessible_model_sk_access_a numeric,
    length_naturallyaccessible_model_sk_access_b numeric,
    length_naturallyaccessible_obsrvd_salmon numeric,
    length_naturallyaccessible_obsrvd_salmon_access_a numeric,
    length_naturallyaccessible_obsrvd_salmon_access_b numeric,
    length_naturallyaccessible_model_salmon numeric,
    length_naturallyaccessible_model_salmon_access_a numeric,
    length_naturallyaccessible_model_salmon_access_b numeric,
    length_naturallyaccessible_obsrvd_st numeric,
    length_naturallyaccessible_obsrvd_st_access_a numeric,
    length_naturallyaccessible_obsrvd_st_access_b numeric,
    length_naturallyaccessible_model_st numeric,
    length_naturallyaccessible_model_st_access_a numeric,
    length_naturallyaccessible_model_st_access_b numeric,
    length_naturallyaccessible_obsrvd_wct numeric,
    length_naturallyaccessible_obsrvd_wct_access_a numeric,
    length_naturallyaccessible_obsrvd_wct_access_b numeric,
    length_naturallyaccessible_model_wct numeric,
    length_naturallyaccessible_model_wct_access_a numeric,
    length_naturallyaccessible_model_wct_access_b numeric,
    length_spawningrearing_obsrvd_bt numeric,
    length_spawningrearing_obsrvd_bt_access_a numeric,
    length_spawningrearing_obsrvd_bt_access_b numeric,
    length_spawningrearing_model_bt numeric,
    length_spawningrearing_model_bt_access_a numeric,
    length_spawningrearing_model_bt_access_b numeric,
    length_spawningrearing_obsrvd_ch numeric,
    length_spawningrearing_obsrvd_ch_access_a numeric,
    length_spawningrearing_obsrvd_ch_access_b numeric,
    length_spawningrearing_model_ch numeric,
    length_spawningrearing_model_ch_access_a numeric,
    length_spawningrearing_model_ch_access_b numeric,
    length_spawningrearing_obsrvd_cm numeric,
    length_spawningrearing_obsrvd_cm_access_a numeric,
    length_spawningrearing_obsrvd_cm_access_b numeric,
    length_spawningrearing_model_cm numeric,
    length_spawningrearing_model_cm_access_a numeric,
    length_spawningrearing_model_cm_access_b numeric,
    length_spawningrearing_obsrvd_co numeric,
    length_spawningrearing_obsrvd_co_access_a numeric,
    length_spawningrearing_obsrvd_co_access_b numeric,
    length_spawningrearing_model_co numeric,
    length_spawningrearing_model_co_access_a numeric,
    length_spawningrearing_model_co_access_b numeric,
    length_spawningrearing_obsrvd_pk numeric,
    length_spawningrearing_obsrvd_pk_access_a numeric,
    length_spawningrearing_obsrvd_pk_access_b numeric,
    length_spawningrearing_model_pk numeric,
    length_spawningrearing_model_pk_access_a numeric,
    length_spawningrearing_model_pk_access_b numeric,
    length_spawningrearing_obsrvd_sk numeric,
    length_spawningrearing_obsrvd_sk_access_a numeric,
    length_spawningrearing_obsrvd_sk_access_b numeric,
    length_spawningrearing_model_sk numeric,
    length_spawningrearing_model_sk_access_a numeric,
    length_spawningrearing_model_sk_access_b numeric,
    length_spawningrearing_obsrvd_st numeric,
    length_spawningrearing_obsrvd_st_access_a numeric,
    length_spawningrearing_obsrvd_st_access_b numeric,
    length_spawningrearing_model_st numeric,
    length_spawningrearing_model_st_access_a numeric,
    length_spawningrearing_model_st_access_b numeric,
    length_spawningrearing_obsrvd_wct numeric,
    length_spawningrearing_obsrvd_wct_access_a numeric,
    length_spawningrearing_obsrvd_wct_access_b numeric,
    length_spawningrearing_model_wct numeric,
    length_spawningrearing_model_wct_access_a numeric,
    length_spawningrearing_model_wct_access_b numeric,
    length_spawningrearing_obsrvd_salmon numeric,
    length_spawningrearing_obsrvd_salmon_access_a numeric,
    length_spawningrearing_obsrvd_salmon_access_b numeric,
    length_spawningrearing_model_salmon numeric,
    length_spawningrearing_model_salmon_access_a numeric,
    length_spawningrearing_model_salmon_access_b numeric,
    length_spawningrearing_obsrvd_salmon_st numeric,
    length_spawningrearing_obsrvd_salmon_st_access_a numeric,
    length_spawningrearing_obsrvd_salmon_st_access_b numeric,
    length_spawningrearing_model_salmon_st numeric,
    length_spawningrearing_model_salmon_st_access_a numeric,
    length_spawningrearing_model_salmon_st_access_b numeric
);


--
-- Name: aw_linear_summary_current; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.aw_linear_summary_current AS
 SELECT DISTINCT ON (s.assessment_watershed_id) s.assessment_watershed_id,
    s.length_total,
    s.length_naturallyaccessible_obsrvd_bt,
    s.length_naturallyaccessible_obsrvd_bt_access_a,
    s.length_naturallyaccessible_obsrvd_bt_access_b,
    s.length_naturallyaccessible_model_bt,
    s.length_naturallyaccessible_model_bt_access_a,
    s.length_naturallyaccessible_model_bt_access_b,
    s.length_naturallyaccessible_obsrvd_ch,
    s.length_naturallyaccessible_obsrvd_ch_access_a,
    s.length_naturallyaccessible_obsrvd_ch_access_b,
    s.length_naturallyaccessible_model_ch,
    s.length_naturallyaccessible_model_ch_access_a,
    s.length_naturallyaccessible_model_ch_access_b,
    s.length_naturallyaccessible_obsrvd_cm,
    s.length_naturallyaccessible_obsrvd_cm_access_a,
    s.length_naturallyaccessible_obsrvd_cm_access_b,
    s.length_naturallyaccessible_model_cm,
    s.length_naturallyaccessible_model_cm_access_a,
    s.length_naturallyaccessible_model_cm_access_b,
    s.length_naturallyaccessible_obsrvd_co,
    s.length_naturallyaccessible_obsrvd_co_access_a,
    s.length_naturallyaccessible_obsrvd_co_access_b,
    s.length_naturallyaccessible_model_co,
    s.length_naturallyaccessible_model_co_access_a,
    s.length_naturallyaccessible_model_co_access_b,
    s.length_naturallyaccessible_obsrvd_pk,
    s.length_naturallyaccessible_obsrvd_pk_access_a,
    s.length_naturallyaccessible_obsrvd_pk_access_b,
    s.length_naturallyaccessible_model_pk,
    s.length_naturallyaccessible_model_pk_access_a,
    s.length_naturallyaccessible_model_pk_access_b,
    s.length_naturallyaccessible_obsrvd_sk,
    s.length_naturallyaccessible_obsrvd_sk_access_a,
    s.length_naturallyaccessible_obsrvd_sk_access_b,
    s.length_naturallyaccessible_model_sk,
    s.length_naturallyaccessible_model_sk_access_a,
    s.length_naturallyaccessible_model_sk_access_b,
    s.length_naturallyaccessible_obsrvd_salmon,
    s.length_naturallyaccessible_obsrvd_salmon_access_a,
    s.length_naturallyaccessible_obsrvd_salmon_access_b,
    s.length_naturallyaccessible_model_salmon,
    s.length_naturallyaccessible_model_salmon_access_a,
    s.length_naturallyaccessible_model_salmon_access_b,
    s.length_naturallyaccessible_obsrvd_st,
    s.length_naturallyaccessible_obsrvd_st_access_a,
    s.length_naturallyaccessible_obsrvd_st_access_b,
    s.length_naturallyaccessible_model_st,
    s.length_naturallyaccessible_model_st_access_a,
    s.length_naturallyaccessible_model_st_access_b,
    s.length_naturallyaccessible_obsrvd_wct,
    s.length_naturallyaccessible_obsrvd_wct_access_a,
    s.length_naturallyaccessible_obsrvd_wct_access_b,
    s.length_naturallyaccessible_model_wct,
    s.length_naturallyaccessible_model_wct_access_a,
    s.length_naturallyaccessible_model_wct_access_b,
    s.length_spawningrearing_obsrvd_bt,
    s.length_spawningrearing_obsrvd_bt_access_a,
    s.length_spawningrearing_obsrvd_bt_access_b,
    s.length_spawningrearing_model_bt,
    s.length_spawningrearing_model_bt_access_a,
    s.length_spawningrearing_model_bt_access_b,
    s.length_spawningrearing_obsrvd_ch,
    s.length_spawningrearing_obsrvd_ch_access_a,
    s.length_spawningrearing_obsrvd_ch_access_b,
    s.length_spawningrearing_model_ch,
    s.length_spawningrearing_model_ch_access_a,
    s.length_spawningrearing_model_ch_access_b,
    s.length_spawningrearing_obsrvd_cm,
    s.length_spawningrearing_obsrvd_cm_access_a,
    s.length_spawningrearing_obsrvd_cm_access_b,
    s.length_spawningrearing_model_cm,
    s.length_spawningrearing_model_cm_access_a,
    s.length_spawningrearing_model_cm_access_b,
    s.length_spawningrearing_obsrvd_co,
    s.length_spawningrearing_obsrvd_co_access_a,
    s.length_spawningrearing_obsrvd_co_access_b,
    s.length_spawningrearing_model_co,
    s.length_spawningrearing_model_co_access_a,
    s.length_spawningrearing_model_co_access_b,
    s.length_spawningrearing_obsrvd_pk,
    s.length_spawningrearing_obsrvd_pk_access_a,
    s.length_spawningrearing_obsrvd_pk_access_b,
    s.length_spawningrearing_model_pk,
    s.length_spawningrearing_model_pk_access_a,
    s.length_spawningrearing_model_pk_access_b,
    s.length_spawningrearing_obsrvd_sk,
    s.length_spawningrearing_obsrvd_sk_access_a,
    s.length_spawningrearing_obsrvd_sk_access_b,
    s.length_spawningrearing_model_sk,
    s.length_spawningrearing_model_sk_access_a,
    s.length_spawningrearing_model_sk_access_b,
    s.length_spawningrearing_obsrvd_st,
    s.length_spawningrearing_obsrvd_st_access_a,
    s.length_spawningrearing_obsrvd_st_access_b,
    s.length_spawningrearing_model_st,
    s.length_spawningrearing_model_st_access_a,
    s.length_spawningrearing_model_st_access_b,
    s.length_spawningrearing_obsrvd_wct,
    s.length_spawningrearing_obsrvd_wct_access_a,
    s.length_spawningrearing_obsrvd_wct_access_b,
    s.length_spawningrearing_model_wct,
    s.length_spawningrearing_model_wct_access_a,
    s.length_spawningrearing_model_wct_access_b,
    s.length_spawningrearing_obsrvd_salmon,
    s.length_spawningrearing_obsrvd_salmon_access_a,
    s.length_spawningrearing_obsrvd_salmon_access_b,
    s.length_spawningrearing_model_salmon,
    s.length_spawningrearing_model_salmon_access_a,
    s.length_spawningrearing_model_salmon_access_b,
    s.length_spawningrearing_obsrvd_salmon_st,
    s.length_spawningrearing_obsrvd_salmon_st_access_a,
    s.length_spawningrearing_obsrvd_salmon_st_access_b,
    s.length_spawningrearing_model_salmon_st,
    s.length_spawningrearing_model_salmon_st_access_a,
    s.length_spawningrearing_model_salmon_st_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_bt_access_b + s.length_naturallyaccessible_model_bt_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_bt + s.length_naturallyaccessible_model_bt), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_bt_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_ch_access_b + s.length_naturallyaccessible_model_ch_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_ch + s.length_naturallyaccessible_model_ch), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_ch_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_cm_access_b + s.length_naturallyaccessible_model_cm_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_cm + s.length_naturallyaccessible_model_cm), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_cm_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_co_access_b + s.length_naturallyaccessible_model_co_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_co + s.length_naturallyaccessible_model_co), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_co_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_pk_access_b + s.length_naturallyaccessible_model_pk_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_pk + s.length_naturallyaccessible_model_pk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_pk_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_sk_access_b + s.length_naturallyaccessible_model_sk_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_sk + s.length_naturallyaccessible_model_sk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_sk_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_salmon_access_b + s.length_naturallyaccessible_model_salmon_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_salmon + s.length_naturallyaccessible_model_salmon), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_salmon_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_st_access_b + s.length_naturallyaccessible_model_st_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_st + s.length_naturallyaccessible_model_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_st_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_wct_access_b + s.length_naturallyaccessible_model_wct_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_wct + s.length_naturallyaccessible_model_wct), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_wct_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_bt_access_b + s.length_spawningrearing_model_bt_access_b) / NULLIF((s.length_spawningrearing_obsrvd_bt + s.length_spawningrearing_model_bt), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_bt_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_ch_access_b + s.length_spawningrearing_model_ch_access_b) / NULLIF((s.length_spawningrearing_obsrvd_ch + s.length_spawningrearing_model_ch), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_ch_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_cm_access_b + s.length_spawningrearing_model_cm_access_b) / NULLIF((s.length_spawningrearing_obsrvd_cm + s.length_spawningrearing_model_cm), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_cm_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_co_access_b + s.length_spawningrearing_model_co_access_b) / NULLIF((s.length_spawningrearing_obsrvd_co + s.length_spawningrearing_model_co), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_co_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_pk_access_b + s.length_spawningrearing_model_pk_access_b) / NULLIF((s.length_spawningrearing_obsrvd_pk + s.length_spawningrearing_model_pk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_pk_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_sk_access_b + s.length_spawningrearing_model_sk_access_b) / NULLIF((s.length_spawningrearing_obsrvd_sk + s.length_spawningrearing_model_sk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_sk_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_st_access_b + s.length_spawningrearing_model_st_access_b) / NULLIF((s.length_spawningrearing_obsrvd_st + s.length_spawningrearing_model_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_st_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_wct_access_b + s.length_spawningrearing_model_wct_access_b) / NULLIF((s.length_spawningrearing_obsrvd_wct + s.length_spawningrearing_model_wct), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_wct_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_salmon_access_b + s.length_spawningrearing_model_salmon_access_b) / NULLIF((s.length_spawningrearing_obsrvd_salmon + s.length_spawningrearing_model_salmon), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_salmon_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_salmon_st_access_b + s.length_spawningrearing_model_salmon_st_access_b) / NULLIF((s.length_spawningrearing_obsrvd_salmon_st + s.length_spawningrearing_model_salmon_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_salmon_st_access_b
   FROM ((bcfishpass.log_aw_linear_summary s
     JOIN bcfishpass.log l ON ((s.model_run_id = l.model_run_id)))
     JOIN whse_basemapping.fwa_assessment_watersheds_poly aw ON ((s.assessment_watershed_id = aw.watershed_feature_id)))
  ORDER BY s.assessment_watershed_id, l.date_completed DESC;


--
-- Name: aw_linear_summary_previous; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.aw_linear_summary_previous AS
 SELECT DISTINCT ON (s.assessment_watershed_id) s.assessment_watershed_id,
    s.length_total,
    s.length_naturallyaccessible_obsrvd_bt,
    s.length_naturallyaccessible_obsrvd_bt_access_a,
    s.length_naturallyaccessible_obsrvd_bt_access_b,
    s.length_naturallyaccessible_model_bt,
    s.length_naturallyaccessible_model_bt_access_a,
    s.length_naturallyaccessible_model_bt_access_b,
    s.length_naturallyaccessible_obsrvd_ch,
    s.length_naturallyaccessible_obsrvd_ch_access_a,
    s.length_naturallyaccessible_obsrvd_ch_access_b,
    s.length_naturallyaccessible_model_ch,
    s.length_naturallyaccessible_model_ch_access_a,
    s.length_naturallyaccessible_model_ch_access_b,
    s.length_naturallyaccessible_obsrvd_cm,
    s.length_naturallyaccessible_obsrvd_cm_access_a,
    s.length_naturallyaccessible_obsrvd_cm_access_b,
    s.length_naturallyaccessible_model_cm,
    s.length_naturallyaccessible_model_cm_access_a,
    s.length_naturallyaccessible_model_cm_access_b,
    s.length_naturallyaccessible_obsrvd_co,
    s.length_naturallyaccessible_obsrvd_co_access_a,
    s.length_naturallyaccessible_obsrvd_co_access_b,
    s.length_naturallyaccessible_model_co,
    s.length_naturallyaccessible_model_co_access_a,
    s.length_naturallyaccessible_model_co_access_b,
    s.length_naturallyaccessible_obsrvd_pk,
    s.length_naturallyaccessible_obsrvd_pk_access_a,
    s.length_naturallyaccessible_obsrvd_pk_access_b,
    s.length_naturallyaccessible_model_pk,
    s.length_naturallyaccessible_model_pk_access_a,
    s.length_naturallyaccessible_model_pk_access_b,
    s.length_naturallyaccessible_obsrvd_sk,
    s.length_naturallyaccessible_obsrvd_sk_access_a,
    s.length_naturallyaccessible_obsrvd_sk_access_b,
    s.length_naturallyaccessible_model_sk,
    s.length_naturallyaccessible_model_sk_access_a,
    s.length_naturallyaccessible_model_sk_access_b,
    s.length_naturallyaccessible_obsrvd_salmon,
    s.length_naturallyaccessible_obsrvd_salmon_access_a,
    s.length_naturallyaccessible_obsrvd_salmon_access_b,
    s.length_naturallyaccessible_model_salmon,
    s.length_naturallyaccessible_model_salmon_access_a,
    s.length_naturallyaccessible_model_salmon_access_b,
    s.length_naturallyaccessible_obsrvd_st,
    s.length_naturallyaccessible_obsrvd_st_access_a,
    s.length_naturallyaccessible_obsrvd_st_access_b,
    s.length_naturallyaccessible_model_st,
    s.length_naturallyaccessible_model_st_access_a,
    s.length_naturallyaccessible_model_st_access_b,
    s.length_naturallyaccessible_obsrvd_wct,
    s.length_naturallyaccessible_obsrvd_wct_access_a,
    s.length_naturallyaccessible_obsrvd_wct_access_b,
    s.length_naturallyaccessible_model_wct,
    s.length_naturallyaccessible_model_wct_access_a,
    s.length_naturallyaccessible_model_wct_access_b,
    s.length_spawningrearing_obsrvd_bt,
    s.length_spawningrearing_obsrvd_bt_access_a,
    s.length_spawningrearing_obsrvd_bt_access_b,
    s.length_spawningrearing_model_bt,
    s.length_spawningrearing_model_bt_access_a,
    s.length_spawningrearing_model_bt_access_b,
    s.length_spawningrearing_obsrvd_ch,
    s.length_spawningrearing_obsrvd_ch_access_a,
    s.length_spawningrearing_obsrvd_ch_access_b,
    s.length_spawningrearing_model_ch,
    s.length_spawningrearing_model_ch_access_a,
    s.length_spawningrearing_model_ch_access_b,
    s.length_spawningrearing_obsrvd_cm,
    s.length_spawningrearing_obsrvd_cm_access_a,
    s.length_spawningrearing_obsrvd_cm_access_b,
    s.length_spawningrearing_model_cm,
    s.length_spawningrearing_model_cm_access_a,
    s.length_spawningrearing_model_cm_access_b,
    s.length_spawningrearing_obsrvd_co,
    s.length_spawningrearing_obsrvd_co_access_a,
    s.length_spawningrearing_obsrvd_co_access_b,
    s.length_spawningrearing_model_co,
    s.length_spawningrearing_model_co_access_a,
    s.length_spawningrearing_model_co_access_b,
    s.length_spawningrearing_obsrvd_pk,
    s.length_spawningrearing_obsrvd_pk_access_a,
    s.length_spawningrearing_obsrvd_pk_access_b,
    s.length_spawningrearing_model_pk,
    s.length_spawningrearing_model_pk_access_a,
    s.length_spawningrearing_model_pk_access_b,
    s.length_spawningrearing_obsrvd_sk,
    s.length_spawningrearing_obsrvd_sk_access_a,
    s.length_spawningrearing_obsrvd_sk_access_b,
    s.length_spawningrearing_model_sk,
    s.length_spawningrearing_model_sk_access_a,
    s.length_spawningrearing_model_sk_access_b,
    s.length_spawningrearing_obsrvd_st,
    s.length_spawningrearing_obsrvd_st_access_a,
    s.length_spawningrearing_obsrvd_st_access_b,
    s.length_spawningrearing_model_st,
    s.length_spawningrearing_model_st_access_a,
    s.length_spawningrearing_model_st_access_b,
    s.length_spawningrearing_obsrvd_wct,
    s.length_spawningrearing_obsrvd_wct_access_a,
    s.length_spawningrearing_obsrvd_wct_access_b,
    s.length_spawningrearing_model_wct,
    s.length_spawningrearing_model_wct_access_a,
    s.length_spawningrearing_model_wct_access_b,
    s.length_spawningrearing_obsrvd_salmon,
    s.length_spawningrearing_obsrvd_salmon_access_a,
    s.length_spawningrearing_obsrvd_salmon_access_b,
    s.length_spawningrearing_model_salmon,
    s.length_spawningrearing_model_salmon_access_a,
    s.length_spawningrearing_model_salmon_access_b,
    s.length_spawningrearing_obsrvd_salmon_st,
    s.length_spawningrearing_obsrvd_salmon_st_access_a,
    s.length_spawningrearing_obsrvd_salmon_st_access_b,
    s.length_spawningrearing_model_salmon_st,
    s.length_spawningrearing_model_salmon_st_access_a,
    s.length_spawningrearing_model_salmon_st_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_bt_access_b + s.length_naturallyaccessible_model_bt_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_bt + s.length_naturallyaccessible_model_bt), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_bt_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_ch_access_b + s.length_naturallyaccessible_model_ch_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_ch + s.length_naturallyaccessible_model_ch), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_ch_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_cm_access_b + s.length_naturallyaccessible_model_cm_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_cm + s.length_naturallyaccessible_model_cm), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_cm_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_co_access_b + s.length_naturallyaccessible_model_co_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_co + s.length_naturallyaccessible_model_co), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_co_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_pk_access_b + s.length_naturallyaccessible_model_pk_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_pk + s.length_naturallyaccessible_model_pk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_pk_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_sk_access_b + s.length_naturallyaccessible_model_sk_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_sk + s.length_naturallyaccessible_model_sk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_sk_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_salmon_access_b + s.length_naturallyaccessible_model_salmon_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_salmon + s.length_naturallyaccessible_model_salmon), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_salmon_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_st_access_b + s.length_naturallyaccessible_model_st_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_st + s.length_naturallyaccessible_model_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_st_access_b,
    round((COALESCE(((s.length_naturallyaccessible_obsrvd_wct_access_b + s.length_naturallyaccessible_model_wct_access_b) / NULLIF((s.length_naturallyaccessible_obsrvd_wct + s.length_naturallyaccessible_model_wct), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_wct_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_bt_access_b + s.length_spawningrearing_model_bt_access_b) / NULLIF((s.length_spawningrearing_obsrvd_bt + s.length_spawningrearing_model_bt), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_bt_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_ch_access_b + s.length_spawningrearing_model_ch_access_b) / NULLIF((s.length_spawningrearing_obsrvd_ch + s.length_spawningrearing_model_ch), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_ch_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_cm_access_b + s.length_spawningrearing_model_cm_access_b) / NULLIF((s.length_spawningrearing_obsrvd_cm + s.length_spawningrearing_model_cm), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_cm_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_co_access_b + s.length_spawningrearing_model_co_access_b) / NULLIF((s.length_spawningrearing_obsrvd_co + s.length_spawningrearing_model_co), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_co_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_pk_access_b + s.length_spawningrearing_model_pk_access_b) / NULLIF((s.length_spawningrearing_obsrvd_pk + s.length_spawningrearing_model_pk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_pk_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_sk_access_b + s.length_spawningrearing_model_sk_access_b) / NULLIF((s.length_spawningrearing_obsrvd_sk + s.length_spawningrearing_model_sk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_sk_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_st_access_b + s.length_spawningrearing_model_st_access_b) / NULLIF((s.length_spawningrearing_obsrvd_st + s.length_spawningrearing_model_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_st_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_wct_access_b + s.length_spawningrearing_model_wct_access_b) / NULLIF((s.length_spawningrearing_obsrvd_wct + s.length_spawningrearing_model_wct), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_wct_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_salmon_access_b + s.length_spawningrearing_model_salmon_access_b) / NULLIF((s.length_spawningrearing_obsrvd_salmon + s.length_spawningrearing_model_salmon), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_salmon_access_b,
    round((COALESCE(((s.length_spawningrearing_obsrvd_salmon_st_access_b + s.length_spawningrearing_model_salmon_st_access_b) / NULLIF((s.length_spawningrearing_obsrvd_salmon_st + s.length_spawningrearing_model_salmon_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_salmon_st_access_b
   FROM ((bcfishpass.log_aw_linear_summary s
     JOIN bcfishpass.log l ON ((s.model_run_id = l.model_run_id)))
     JOIN whse_basemapping.fwa_assessment_watersheds_poly aw ON ((s.assessment_watershed_id = aw.watershed_feature_id)))
  WHERE (l.date_completed = ( SELECT log.date_completed
           FROM bcfishpass.log
          ORDER BY log.date_completed DESC
         OFFSET 1
         LIMIT 1))
  ORDER BY s.assessment_watershed_id, l.date_completed DESC;


--
-- Name: aw_linear_summary_diff; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.aw_linear_summary_diff AS
 SELECT a.assessment_watershed_id,
    a.length_total,
    (a.length_naturallyaccessible_obsrvd_bt - b.length_naturallyaccessible_obsrvd_bt) AS length_naturallyaccessible_obsrvd_bt,
    (a.length_naturallyaccessible_obsrvd_bt_access_a - b.length_naturallyaccessible_obsrvd_bt_access_a) AS length_naturallyaccessible_obsrvd_bt_access_a,
    (a.length_naturallyaccessible_obsrvd_bt_access_b - b.length_naturallyaccessible_obsrvd_bt_access_b) AS length_naturallyaccessible_obsrvd_bt_access_b,
    (a.length_naturallyaccessible_model_bt - b.length_naturallyaccessible_model_bt) AS length_naturallyaccessible_model_bt,
    (a.length_naturallyaccessible_model_bt_access_a - b.length_naturallyaccessible_model_bt_access_a) AS length_naturallyaccessible_model_bt_access_a,
    (a.length_naturallyaccessible_model_bt_access_b - b.length_naturallyaccessible_model_bt_access_b) AS length_naturallyaccessible_model_bt_access_b,
    (a.length_naturallyaccessible_obsrvd_ch - b.length_naturallyaccessible_obsrvd_ch) AS length_naturallyaccessible_obsrvd_ch,
    (a.length_naturallyaccessible_obsrvd_ch_access_a - b.length_naturallyaccessible_obsrvd_ch_access_a) AS length_naturallyaccessible_obsrvd_ch_access_a,
    (a.length_naturallyaccessible_obsrvd_ch_access_b - b.length_naturallyaccessible_obsrvd_ch_access_b) AS length_naturallyaccessible_obsrvd_ch_access_b,
    (a.length_naturallyaccessible_model_ch - b.length_naturallyaccessible_model_ch) AS length_naturallyaccessible_model_ch,
    (a.length_naturallyaccessible_model_ch_access_a - b.length_naturallyaccessible_model_ch_access_a) AS length_naturallyaccessible_model_ch_access_a,
    (a.length_naturallyaccessible_model_ch_access_b - b.length_naturallyaccessible_model_ch_access_b) AS length_naturallyaccessible_model_ch_access_b,
    (a.length_naturallyaccessible_obsrvd_cm - b.length_naturallyaccessible_obsrvd_cm) AS length_naturallyaccessible_obsrvd_cm,
    (a.length_naturallyaccessible_obsrvd_cm_access_a - b.length_naturallyaccessible_obsrvd_cm_access_a) AS length_naturallyaccessible_obsrvd_cm_access_a,
    (a.length_naturallyaccessible_obsrvd_cm_access_b - b.length_naturallyaccessible_obsrvd_cm_access_b) AS length_naturallyaccessible_obsrvd_cm_access_b,
    (a.length_naturallyaccessible_model_cm - b.length_naturallyaccessible_model_cm) AS length_naturallyaccessible_model_cm,
    (a.length_naturallyaccessible_model_cm_access_a - b.length_naturallyaccessible_model_cm_access_a) AS length_naturallyaccessible_model_cm_access_a,
    (a.length_naturallyaccessible_model_cm_access_b - b.length_naturallyaccessible_model_cm_access_b) AS length_naturallyaccessible_model_cm_access_b,
    (a.length_naturallyaccessible_obsrvd_co - b.length_naturallyaccessible_obsrvd_co) AS length_naturallyaccessible_obsrvd_co,
    (a.length_naturallyaccessible_obsrvd_co_access_a - b.length_naturallyaccessible_obsrvd_co_access_a) AS length_naturallyaccessible_obsrvd_co_access_a,
    (a.length_naturallyaccessible_obsrvd_co_access_b - b.length_naturallyaccessible_obsrvd_co_access_b) AS length_naturallyaccessible_obsrvd_co_access_b,
    (a.length_naturallyaccessible_model_co - b.length_naturallyaccessible_model_co) AS length_naturallyaccessible_model_co,
    (a.length_naturallyaccessible_model_co_access_a - b.length_naturallyaccessible_model_co_access_a) AS length_naturallyaccessible_model_co_access_a,
    (a.length_naturallyaccessible_model_co_access_b - b.length_naturallyaccessible_model_co_access_b) AS length_naturallyaccessible_model_co_access_b,
    (a.length_naturallyaccessible_obsrvd_pk - b.length_naturallyaccessible_obsrvd_pk) AS length_naturallyaccessible_obsrvd_pk,
    (a.length_naturallyaccessible_obsrvd_pk_access_a - b.length_naturallyaccessible_obsrvd_pk_access_a) AS length_naturallyaccessible_obsrvd_pk_access_a,
    (a.length_naturallyaccessible_obsrvd_pk_access_b - b.length_naturallyaccessible_obsrvd_pk_access_b) AS length_naturallyaccessible_obsrvd_pk_access_b,
    (a.length_naturallyaccessible_model_pk - b.length_naturallyaccessible_model_pk) AS length_naturallyaccessible_model_pk,
    (a.length_naturallyaccessible_model_pk_access_a - b.length_naturallyaccessible_model_pk_access_a) AS length_naturallyaccessible_model_pk_access_a,
    (a.length_naturallyaccessible_model_pk_access_b - b.length_naturallyaccessible_model_pk_access_b) AS length_naturallyaccessible_model_pk_access_b,
    (a.length_naturallyaccessible_obsrvd_sk - b.length_naturallyaccessible_obsrvd_sk) AS length_naturallyaccessible_obsrvd_sk,
    (a.length_naturallyaccessible_obsrvd_sk_access_a - b.length_naturallyaccessible_obsrvd_sk_access_a) AS length_naturallyaccessible_obsrvd_sk_access_a,
    (a.length_naturallyaccessible_obsrvd_sk_access_b - b.length_naturallyaccessible_obsrvd_sk_access_b) AS length_naturallyaccessible_obsrvd_sk_access_b,
    (a.length_naturallyaccessible_model_sk - b.length_naturallyaccessible_model_sk) AS length_naturallyaccessible_model_sk,
    (a.length_naturallyaccessible_model_sk_access_a - b.length_naturallyaccessible_model_sk_access_a) AS length_naturallyaccessible_model_sk_access_a,
    (a.length_naturallyaccessible_model_sk_access_b - b.length_naturallyaccessible_model_sk_access_b) AS length_naturallyaccessible_model_sk_access_b,
    (a.length_naturallyaccessible_obsrvd_salmon - b.length_naturallyaccessible_obsrvd_salmon) AS length_naturallyaccessible_obsrvd_salmon,
    (a.length_naturallyaccessible_obsrvd_salmon_access_a - b.length_naturallyaccessible_obsrvd_salmon_access_a) AS length_naturallyaccessible_obsrvd_salmon_access_a,
    (a.length_naturallyaccessible_obsrvd_salmon_access_b - b.length_naturallyaccessible_obsrvd_salmon_access_b) AS length_naturallyaccessible_obsrvd_salmon_access_b,
    (a.length_naturallyaccessible_model_salmon - b.length_naturallyaccessible_model_salmon) AS length_naturallyaccessible_model_salmon,
    (a.length_naturallyaccessible_model_salmon_access_a - b.length_naturallyaccessible_model_salmon_access_a) AS length_naturallyaccessible_model_salmon_access_a,
    (a.length_naturallyaccessible_model_salmon_access_b - b.length_naturallyaccessible_model_salmon_access_b) AS length_naturallyaccessible_model_salmon_access_b,
    (a.length_naturallyaccessible_obsrvd_st - b.length_naturallyaccessible_obsrvd_st) AS length_naturallyaccessible_obsrvd_st,
    (a.length_naturallyaccessible_obsrvd_st_access_a - b.length_naturallyaccessible_obsrvd_st_access_a) AS length_naturallyaccessible_obsrvd_st_access_a,
    (a.length_naturallyaccessible_obsrvd_st_access_b - b.length_naturallyaccessible_obsrvd_st_access_b) AS length_naturallyaccessible_obsrvd_st_access_b,
    (a.length_naturallyaccessible_model_st - b.length_naturallyaccessible_model_st) AS length_naturallyaccessible_model_st,
    (a.length_naturallyaccessible_model_st_access_a - b.length_naturallyaccessible_model_st_access_a) AS length_naturallyaccessible_model_st_access_a,
    (a.length_naturallyaccessible_model_st_access_b - b.length_naturallyaccessible_model_st_access_b) AS length_naturallyaccessible_model_st_access_b,
    (a.length_naturallyaccessible_obsrvd_wct - b.length_naturallyaccessible_obsrvd_wct) AS length_naturallyaccessible_obsrvd_wct,
    (a.length_naturallyaccessible_obsrvd_wct_access_a - b.length_naturallyaccessible_obsrvd_wct_access_a) AS length_naturallyaccessible_obsrvd_wct_access_a,
    (a.length_naturallyaccessible_obsrvd_wct_access_b - b.length_naturallyaccessible_obsrvd_wct_access_b) AS length_naturallyaccessible_obsrvd_wct_access_b,
    (a.length_naturallyaccessible_model_wct - b.length_naturallyaccessible_model_wct) AS length_naturallyaccessible_model_wct,
    (a.length_naturallyaccessible_model_wct_access_a - b.length_naturallyaccessible_model_wct_access_a) AS length_naturallyaccessible_model_wct_access_a,
    (a.length_naturallyaccessible_model_wct_access_b - b.length_naturallyaccessible_model_wct_access_b) AS length_naturallyaccessible_model_wct_access_b,
    (a.length_spawningrearing_obsrvd_bt - b.length_spawningrearing_obsrvd_bt) AS length_spawningrearing_obsrvd_bt,
    (a.length_spawningrearing_obsrvd_bt_access_a - b.length_spawningrearing_obsrvd_bt_access_a) AS length_spawningrearing_obsrvd_bt_access_a,
    (a.length_spawningrearing_obsrvd_bt_access_b - b.length_spawningrearing_obsrvd_bt_access_b) AS length_spawningrearing_obsrvd_bt_access_b,
    (a.length_spawningrearing_model_bt - b.length_spawningrearing_model_bt) AS length_spawningrearing_model_bt,
    (a.length_spawningrearing_model_bt_access_a - b.length_spawningrearing_model_bt_access_a) AS length_spawningrearing_model_bt_access_a,
    (a.length_spawningrearing_model_bt_access_b - b.length_spawningrearing_model_bt_access_b) AS length_spawningrearing_model_bt_access_b,
    (a.length_spawningrearing_obsrvd_ch - b.length_spawningrearing_obsrvd_ch) AS length_spawningrearing_obsrvd_ch,
    (a.length_spawningrearing_obsrvd_ch_access_a - b.length_spawningrearing_obsrvd_ch_access_a) AS length_spawningrearing_obsrvd_ch_access_a,
    (a.length_spawningrearing_obsrvd_ch_access_b - b.length_spawningrearing_obsrvd_ch_access_b) AS length_spawningrearing_obsrvd_ch_access_b,
    (a.length_spawningrearing_model_ch - b.length_spawningrearing_model_ch) AS length_spawningrearing_model_ch,
    (a.length_spawningrearing_model_ch_access_a - b.length_spawningrearing_model_ch_access_a) AS length_spawningrearing_model_ch_access_a,
    (a.length_spawningrearing_model_ch_access_b - b.length_spawningrearing_model_ch_access_b) AS length_spawningrearing_model_ch_access_b,
    (a.length_spawningrearing_obsrvd_cm - b.length_spawningrearing_obsrvd_cm) AS length_spawningrearing_obsrvd_cm,
    (a.length_spawningrearing_obsrvd_cm_access_a - b.length_spawningrearing_obsrvd_cm_access_a) AS length_spawningrearing_obsrvd_cm_access_a,
    (a.length_spawningrearing_obsrvd_cm_access_b - b.length_spawningrearing_obsrvd_cm_access_b) AS length_spawningrearing_obsrvd_cm_access_b,
    (a.length_spawningrearing_model_cm - b.length_spawningrearing_model_cm) AS length_spawningrearing_model_cm,
    (a.length_spawningrearing_model_cm_access_a - b.length_spawningrearing_model_cm_access_a) AS length_spawningrearing_model_cm_access_a,
    (a.length_spawningrearing_model_cm_access_b - b.length_spawningrearing_model_cm_access_b) AS length_spawningrearing_model_cm_access_b,
    (a.length_spawningrearing_obsrvd_co - b.length_spawningrearing_obsrvd_co) AS length_spawningrearing_obsrvd_co,
    (a.length_spawningrearing_obsrvd_co_access_a - b.length_spawningrearing_obsrvd_co_access_a) AS length_spawningrearing_obsrvd_co_access_a,
    (a.length_spawningrearing_obsrvd_co_access_b - b.length_spawningrearing_obsrvd_co_access_b) AS length_spawningrearing_obsrvd_co_access_b,
    (a.length_spawningrearing_model_co - b.length_spawningrearing_model_co) AS length_spawningrearing_model_co,
    (a.length_spawningrearing_model_co_access_a - b.length_spawningrearing_model_co_access_a) AS length_spawningrearing_model_co_access_a,
    (a.length_spawningrearing_model_co_access_b - b.length_spawningrearing_model_co_access_b) AS length_spawningrearing_model_co_access_b,
    (a.length_spawningrearing_obsrvd_pk - b.length_spawningrearing_obsrvd_pk) AS length_spawningrearing_obsrvd_pk,
    (a.length_spawningrearing_obsrvd_pk_access_a - b.length_spawningrearing_obsrvd_pk_access_a) AS length_spawningrearing_obsrvd_pk_access_a,
    (a.length_spawningrearing_obsrvd_pk_access_b - b.length_spawningrearing_obsrvd_pk_access_b) AS length_spawningrearing_obsrvd_pk_access_b,
    (a.length_spawningrearing_model_pk - b.length_spawningrearing_model_pk) AS length_spawningrearing_model_pk,
    (a.length_spawningrearing_model_pk_access_a - b.length_spawningrearing_model_pk_access_a) AS length_spawningrearing_model_pk_access_a,
    (a.length_spawningrearing_model_pk_access_b - b.length_spawningrearing_model_pk_access_b) AS length_spawningrearing_model_pk_access_b,
    (a.length_spawningrearing_obsrvd_sk - b.length_spawningrearing_obsrvd_sk) AS length_spawningrearing_obsrvd_sk,
    (a.length_spawningrearing_obsrvd_sk_access_a - b.length_spawningrearing_obsrvd_sk_access_a) AS length_spawningrearing_obsrvd_sk_access_a,
    (a.length_spawningrearing_obsrvd_sk_access_b - b.length_spawningrearing_obsrvd_sk_access_b) AS length_spawningrearing_obsrvd_sk_access_b,
    (a.length_spawningrearing_model_sk - b.length_spawningrearing_model_sk) AS length_spawningrearing_model_sk,
    (a.length_spawningrearing_model_sk_access_a - b.length_spawningrearing_model_sk_access_a) AS length_spawningrearing_model_sk_access_a,
    (a.length_spawningrearing_model_sk_access_b - b.length_spawningrearing_model_sk_access_b) AS length_spawningrearing_model_sk_access_b,
    (a.length_spawningrearing_obsrvd_st - b.length_spawningrearing_obsrvd_st) AS length_spawningrearing_obsrvd_st,
    (a.length_spawningrearing_obsrvd_st_access_a - b.length_spawningrearing_obsrvd_st_access_a) AS length_spawningrearing_obsrvd_st_access_a,
    (a.length_spawningrearing_obsrvd_st_access_b - b.length_spawningrearing_obsrvd_st_access_b) AS length_spawningrearing_obsrvd_st_access_b,
    (a.length_spawningrearing_model_st - b.length_spawningrearing_model_st) AS length_spawningrearing_model_st,
    (a.length_spawningrearing_model_st_access_a - b.length_spawningrearing_model_st_access_a) AS length_spawningrearing_model_st_access_a,
    (a.length_spawningrearing_model_st_access_b - b.length_spawningrearing_model_st_access_b) AS length_spawningrearing_model_st_access_b,
    (a.length_spawningrearing_obsrvd_wct - b.length_spawningrearing_obsrvd_wct) AS length_spawningrearing_obsrvd_wct,
    (a.length_spawningrearing_obsrvd_wct_access_a - b.length_spawningrearing_obsrvd_wct_access_a) AS length_spawningrearing_obsrvd_wct_access_a,
    (a.length_spawningrearing_obsrvd_wct_access_b - b.length_spawningrearing_obsrvd_wct_access_b) AS length_spawningrearing_obsrvd_wct_access_b,
    (a.length_spawningrearing_model_wct - b.length_spawningrearing_model_wct) AS length_spawningrearing_model_wct,
    (a.length_spawningrearing_model_wct_access_a - b.length_spawningrearing_model_wct_access_a) AS length_spawningrearing_model_wct_access_a,
    (a.length_spawningrearing_model_wct_access_b - b.length_spawningrearing_model_wct_access_b) AS length_spawningrearing_model_wct_access_b,
    (a.length_spawningrearing_obsrvd_salmon - b.length_spawningrearing_obsrvd_salmon) AS length_spawningrearing_obsrvd_salmon,
    (a.length_spawningrearing_obsrvd_salmon_access_a - b.length_spawningrearing_obsrvd_salmon_access_a) AS length_spawningrearing_obsrvd_salmon_access_a,
    (a.length_spawningrearing_obsrvd_salmon_access_b - b.length_spawningrearing_obsrvd_salmon_access_b) AS length_spawningrearing_obsrvd_salmon_access_b,
    (a.length_spawningrearing_model_salmon - b.length_spawningrearing_model_salmon) AS length_spawningrearing_model_salmon,
    (a.length_spawningrearing_model_salmon_access_a - b.length_spawningrearing_model_salmon_access_a) AS length_spawningrearing_model_salmon_access_a,
    (a.length_spawningrearing_model_salmon_access_b - b.length_spawningrearing_model_salmon_access_b) AS length_spawningrearing_model_salmon_access_b,
    (a.length_spawningrearing_obsrvd_salmon_st - b.length_spawningrearing_obsrvd_salmon_st) AS length_spawningrearing_obsrvd_salmon_st,
    (a.length_spawningrearing_obsrvd_salmon_st_access_a - b.length_spawningrearing_obsrvd_salmon_st_access_a) AS length_spawningrearing_obsrvd_salmon_st_access_a,
    (a.length_spawningrearing_obsrvd_salmon_st_access_b - b.length_spawningrearing_obsrvd_salmon_st_access_b) AS length_spawningrearing_obsrvd_salmon_st_access_b,
    (a.length_spawningrearing_model_salmon_st - b.length_spawningrearing_model_salmon_st) AS length_spawningrearing_model_salmon_st,
    (a.length_spawningrearing_model_salmon_st_access_a - b.length_spawningrearing_model_salmon_st_access_a) AS length_spawningrearing_model_salmon_st_access_a,
    (a.length_spawningrearing_model_salmon_st_access_b - b.length_spawningrearing_model_salmon_st_access_b) AS length_spawningrearing_model_salmon_st_access_b,
    (a.pct_naturallyaccessible_bt_access_b - b.pct_naturallyaccessible_bt_access_b) AS pct_naturallyaccessible_bt_access_b,
    (a.pct_naturallyaccessible_ch_access_b - b.pct_naturallyaccessible_ch_access_b) AS pct_naturallyaccessible_ch_access_b,
    (a.pct_naturallyaccessible_cm_access_b - b.pct_naturallyaccessible_cm_access_b) AS pct_naturallyaccessible_cm_access_b,
    (a.pct_naturallyaccessible_co_access_b - b.pct_naturallyaccessible_co_access_b) AS pct_naturallyaccessible_co_access_b,
    (a.pct_naturallyaccessible_pk_access_b - b.pct_naturallyaccessible_pk_access_b) AS pct_naturallyaccessible_pk_access_b,
    (a.pct_naturallyaccessible_sk_access_b - b.pct_naturallyaccessible_sk_access_b) AS pct_naturallyaccessible_sk_access_b,
    (a.pct_naturallyaccessible_salmon_access_b - b.pct_naturallyaccessible_salmon_access_b) AS pct_naturallyaccessible_salmon_access_b,
    (a.pct_naturallyaccessible_st_access_b - b.pct_naturallyaccessible_st_access_b) AS pct_naturallyaccessible_st_access_b,
    (a.pct_naturallyaccessible_wct_access_b - b.pct_naturallyaccessible_wct_access_b) AS pct_naturallyaccessible_wct_access_b,
    (a.pct_spawningrearing_bt_access_b - b.pct_spawningrearing_bt_access_b) AS pct_spawningrearing_bt_access_b,
    (a.pct_spawningrearing_ch_access_b - b.pct_spawningrearing_ch_access_b) AS pct_spawningrearing_ch_access_b,
    (a.pct_spawningrearing_cm_access_b - b.pct_spawningrearing_cm_access_b) AS pct_spawningrearing_cm_access_b,
    (a.pct_spawningrearing_co_access_b - b.pct_spawningrearing_co_access_b) AS pct_spawningrearing_co_access_b,
    (a.pct_spawningrearing_pk_access_b - b.pct_spawningrearing_pk_access_b) AS pct_spawningrearing_pk_access_b,
    (a.pct_spawningrearing_sk_access_b - b.pct_spawningrearing_sk_access_b) AS pct_spawningrearing_sk_access_b,
    (a.pct_spawningrearing_st_access_b - b.pct_spawningrearing_st_access_b) AS pct_spawningrearing_st_access_b,
    (a.pct_spawningrearing_wct_access_b - b.pct_spawningrearing_wct_access_b) AS pct_spawningrearing_wct_access_b,
    (a.pct_spawningrearing_salmon_access_b - b.pct_spawningrearing_salmon_access_b) AS pct_spawningrearing_salmon_access_b,
    (a.pct_spawningrearing_salmon_st_access_b - b.pct_spawningrearing_salmon_st_access_b) AS pct_spawningrearing_salmon_st_access_b
   FROM (bcfishpass.aw_linear_summary_current a
     JOIN bcfishpass.aw_linear_summary_previous b ON ((a.assessment_watershed_id = b.assessment_watershed_id)))
  ORDER BY a.assessment_watershed_id;


--
-- Name: barriers_anthropogenic; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE UNLOGGED TABLE bcfishpass.barriers_anthropogenic (
    barriers_anthropogenic_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: barriers_anthropogenic_dnstr_barriers_anthropogenic; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.barriers_anthropogenic_dnstr_barriers_anthropogenic (
    barriers_anthropogenic_id text NOT NULL,
    features_dnstr text[]
);


--
-- Name: barriers_bt; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.barriers_bt (
    barriers_bt_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005),
    total_network_km double precision DEFAULT 0
);


--
-- Name: barriers_ch_cm_co_pk_sk; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.barriers_ch_cm_co_pk_sk (
    barriers_ch_cm_co_pk_sk_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005),
    total_network_km double precision DEFAULT 0
);


--
-- Name: barriers_ct_dv_rb; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.barriers_ct_dv_rb (
    barriers_ct_dv_rb_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005),
    total_network_km double precision DEFAULT 0
);


--
-- Name: barriers_dams; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE UNLOGGED TABLE bcfishpass.barriers_dams (
    barriers_dams_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: barriers_dams_hydro; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE UNLOGGED TABLE bcfishpass.barriers_dams_hydro (
    barriers_dams_hydro_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: barriers_falls; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE UNLOGGED TABLE bcfishpass.barriers_falls (
    barriers_falls_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: barriers_gradient; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.barriers_gradient (
    barriers_gradient_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: barriers_pscis; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE UNLOGGED TABLE bcfishpass.barriers_pscis (
    barriers_pscis_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: barriers_remediations; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE UNLOGGED TABLE bcfishpass.barriers_remediations (
    barriers_remediations_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: barriers_st; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.barriers_st (
    barriers_st_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005),
    total_network_km double precision DEFAULT 0
);


--
-- Name: barriers_subsurfaceflow; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.barriers_subsurfaceflow (
    barriers_subsurfaceflow_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: barriers_user_definite; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE UNLOGGED TABLE bcfishpass.barriers_user_definite (
    barriers_user_definite_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: barriers_wct; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.barriers_wct (
    barriers_wct_id text NOT NULL,
    barrier_type text,
    barrier_name text,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005),
    total_network_km double precision DEFAULT 0
);


--
-- Name: cabd_additions; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.cabd_additions (
    feature_type text,
    name text,
    height numeric,
    barrier_ind boolean,
    blue_line_key integer NOT NULL,
    downstream_route_measure integer NOT NULL,
    reviewer_name text,
    review_date date,
    source text,
    notes text,
    CONSTRAINT cabd_additions_feature_type_check CHECK ((feature_type = ANY (ARRAY['dams'::text, 'waterfalls'::text])))
);


--
-- Name: TABLE cabd_additions; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON TABLE bcfishpass.cabd_additions IS 'Insert falls or dams required for bcfishpass but not present in CABD. Includes placeholders for dams outside of BC';


--
-- Name: COLUMN cabd_additions.feature_type; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.feature_type IS 'Feature type, either waterfalls or dams';


--
-- Name: COLUMN cabd_additions.name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.name IS 'Name of waterfalls or dam';


--
-- Name: COLUMN cabd_additions.height; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.height IS 'Height (m) of waterfalls or dam';


--
-- Name: COLUMN cabd_additions.barrier_ind; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.barrier_ind IS 'Barrier status of waterfalls or dam (true/false)';


--
-- Name: COLUMN cabd_additions.blue_line_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.blue_line_key IS 'FWA blue_line_key (flow line) on which the feature lies';


--
-- Name: COLUMN cabd_additions.downstream_route_measure; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.downstream_route_measure IS 'The distance, in meters, along the blue_line_key from the mouth of the stream/blue_line_key to the feature.';


--
-- Name: COLUMN cabd_additions.reviewer_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.reviewer_name IS 'Initials of user submitting the review, eg SN';


--
-- Name: COLUMN cabd_additions.review_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';


--
-- Name: COLUMN cabd_additions.source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.source IS 'Description or link to the source(s) documenting the feature';


--
-- Name: COLUMN cabd_additions.notes; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_additions.notes IS 'Reviewer notes on rationale for addition of the feature and/or how the source were interpreted';


--
-- Name: cabd_blkey_xref; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.cabd_blkey_xref (
    cabd_id text,
    blue_line_key integer,
    reviewer_name text,
    review_date date,
    notes text
);


--
-- Name: TABLE cabd_blkey_xref; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON TABLE bcfishpass.cabd_blkey_xref IS 'Cross reference CABD features to FWA flow lines (blue_line_key), used when CABD feature location is closest to an inapproprate flow line';


--
-- Name: COLUMN cabd_blkey_xref.cabd_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_blkey_xref.cabd_id IS 'CABD unique identifier';


--
-- Name: COLUMN cabd_blkey_xref.blue_line_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_blkey_xref.blue_line_key IS 'FWA blue_line_key (flow line) to which the CABD feature should be linked';


--
-- Name: COLUMN cabd_blkey_xref.reviewer_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_blkey_xref.reviewer_name IS 'Initials of user submitting the review, eg SN';


--
-- Name: COLUMN cabd_blkey_xref.review_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_blkey_xref.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';


--
-- Name: COLUMN cabd_blkey_xref.notes; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_blkey_xref.notes IS 'Reviewer notes on rationale for fix and/or how the source(s) were interpreted';


--
-- Name: cabd_exclusions; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.cabd_exclusions (
    cabd_id text NOT NULL,
    feature_type text,
    reviewer_name text,
    review_date date,
    source text,
    notes text,
    CONSTRAINT cabd_exclusions_feature_type_check CHECK ((feature_type = ANY (ARRAY['dams'::text, 'waterfalls'::text])))
);


--
-- Name: TABLE cabd_exclusions; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON TABLE bcfishpass.cabd_exclusions IS 'Exclude CABD records (waterfalls and dams) from bcfishpass usage';


--
-- Name: COLUMN cabd_exclusions.cabd_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_exclusions.cabd_id IS 'CABD unique identifier';


--
-- Name: COLUMN cabd_exclusions.feature_type; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_exclusions.feature_type IS 'Feature type, either waterfalls or dams';


--
-- Name: COLUMN cabd_exclusions.reviewer_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_exclusions.reviewer_name IS 'Initials of user submitting the review, eg SN';


--
-- Name: COLUMN cabd_exclusions.review_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_exclusions.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';


--
-- Name: COLUMN cabd_exclusions.source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_exclusions.source IS 'Description or link to the source(s) indicating why the feature should be excluded';


--
-- Name: COLUMN cabd_exclusions.notes; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_exclusions.notes IS 'Reviewer notes on rationale for exclusion and/or how the source were interpreted';


--
-- Name: cabd_passability_status_updates; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.cabd_passability_status_updates (
    cabd_id text NOT NULL,
    passability_status_code integer,
    reviewer_name text,
    review_date date,
    source text,
    notes text,
    CONSTRAINT cabd_passability_status_updates_passability_status_code_check CHECK (((passability_status_code > 0) AND (passability_status_code < 7)))
);


--
-- Name: TABLE cabd_passability_status_updates; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON TABLE bcfishpass.cabd_passability_status_updates IS 'Update the passability_status_code (within bcfishpass) of existing CABD features (dams or waterfalls)';


--
-- Name: COLUMN cabd_passability_status_updates.cabd_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_passability_status_updates.cabd_id IS 'CABD unique identifier';


--
-- Name: COLUMN cabd_passability_status_updates.passability_status_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_passability_status_updates.passability_status_code IS 'Code referencing the degree to which the feature acts as a barrier to fish in the upstream direction. (1=Barrier, 2=Partial barrier, 3=Passable, 4=Unknown, 5=NA-No Structure, 6=NA-Decommissioned/Removed)';


--
-- Name: COLUMN cabd_passability_status_updates.reviewer_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_passability_status_updates.reviewer_name IS 'Initials of user submitting the review, eg SN';


--
-- Name: COLUMN cabd_passability_status_updates.review_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_passability_status_updates.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';


--
-- Name: COLUMN cabd_passability_status_updates.source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_passability_status_updates.source IS 'Description or link to the source(s) documenting the passability status of the feature';


--
-- Name: COLUMN cabd_passability_status_updates.notes; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.cabd_passability_status_updates.notes IS 'Reviewer notes on rationale for fix and/or how the source(s) were interpreted';


--
-- Name: crossings; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings (
    aggregated_crossings_id text NOT NULL,
    stream_crossing_id integer,
    dam_id text,
    user_crossing_misc_id bigint,
    modelled_crossing_id integer,
    crossing_source text,
    pscis_status text,
    crossing_type_code text,
    crossing_subtype_code text,
    modelled_crossing_type_source text[],
    barrier_status text,
    pscis_road_name text,
    pscis_stream_name text,
    pscis_assessment_comment text,
    pscis_assessment_date date,
    pscis_final_score integer,
    transport_line_structured_name_1 text,
    transport_line_type_description text,
    transport_line_surface_description text,
    ften_forest_file_id text,
    ften_road_section_id text,
    ften_file_type_description text,
    ften_client_number text,
    ften_client_name text,
    ften_life_cycle_status_code text,
    ften_map_label text,
    rail_track_name text,
    rail_owner_name text,
    rail_operator_english_name text,
    ogc_proponent text,
    dam_name text,
    dam_height double precision,
    dam_owner text,
    dam_use text,
    dam_operating_status text,
    utm_zone integer,
    utm_easting integer,
    utm_northing integer,
    linear_feature_id integer,
    blue_line_key integer,
    watershed_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code text,
    gnis_stream_name text,
    stream_order integer,
    stream_magnitude integer,
    geom public.geometry(PointZM,3005),
    crossing_feature_type text
);


--
-- Name: COLUMN crossings.aggregated_crossings_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.aggregated_crossings_id IS 'unique identifier for crossing, generated from stream_crossing_id, modelled_crossing_id + 1000000000, user_barrier_anthropogenic_id + 1200000000, cabd_id';


--
-- Name: COLUMN crossings.stream_crossing_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.stream_crossing_id IS 'PSCIS stream crossing unique identifier';


--
-- Name: COLUMN crossings.dam_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.dam_id IS 'BC Dams unique identifier';


--
-- Name: COLUMN crossings.user_crossing_misc_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.user_crossing_misc_id IS 'User added misc anthropogenic barriers unique identifier';


--
-- Name: COLUMN crossings.modelled_crossing_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.modelled_crossing_id IS 'Modelled crossing unique identifier';


--
-- Name: COLUMN crossings.crossing_source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.crossing_source IS 'Data source for the crossing, one of: {PSCIS,MODELLED CROSSINGS,CABD,MISC BARRIERS}';


--
-- Name: COLUMN crossings.pscis_status; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.pscis_status IS 'From PSCIS, the current_pscis_status of the crossing, one of: {ASSESSED,HABITAT CONFIRMATION,DESIGN,REMEDIATED}';


--
-- Name: COLUMN crossings.crossing_type_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.crossing_type_code IS 'Defines the type of crossing present at the location of the stream crossing. Acceptable types are: OBS = Open Bottom Structure CBS = Closed Bottom Structure OTHER = Crossing structure does not fit into the above categories. Eg: ford, wier';


--
-- Name: COLUMN crossings.crossing_subtype_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.crossing_subtype_code IS 'Further definition of the type of crossing, one of {BRIDGE,CRTBOX,DAM,FORD,OVAL,PIPEARCH,ROUND,WEIR,WOODBOX,NULL}';


--
-- Name: COLUMN crossings.modelled_crossing_type_source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.modelled_crossing_type_source IS 'List of sources that indicate if a modelled crossing is open bottom, Acceptable values are: FWA_EDGE_TYPE=double line river, FWA_STREAM_ORDER=stream order >=6, GBA_RAILWAY_STRUCTURE_LINES_SP=railway structure, "MANUAL FIX"=manually identified OBS, MOT_ROAD_STRUCTURE_SP=MoT structure, TRANSPORT_LINE_STRUCTURE_CODE=DRA structure}';


--
-- Name: COLUMN crossings.barrier_status; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.barrier_status IS 'The evaluation of the crossing as a barrier to the fish passage. From PSCIS, this is based on the FINAL SCORE value. For other data sources this varies. Acceptable Values are: PASSABLE - Passable, POTENTIAL - Potential or partial barrier, BARRIER - Barrier, UNKNOWN - Other';


--
-- Name: COLUMN crossings.pscis_road_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.pscis_road_name IS 'PSCIS road name, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings.pscis_stream_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.pscis_stream_name IS 'PSCIS stream name, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings.pscis_assessment_comment; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.pscis_assessment_comment IS 'PSCIS assessment_comment, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings.pscis_assessment_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.pscis_assessment_date IS 'PSCIS assessment_date, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings.pscis_final_score; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.pscis_final_score IS 'PSCIS final_score, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings.transport_line_structured_name_1; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.transport_line_structured_name_1 IS 'DRA road name, taken from the nearest DRA road (within 30m)';


--
-- Name: COLUMN crossings.transport_line_type_description; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.transport_line_type_description IS 'DRA road type, taken from the nearest DRA road (within 30m)';


--
-- Name: COLUMN crossings.transport_line_surface_description; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.transport_line_surface_description IS 'DRA road surface, taken from the nearest DRA road (within 30m)';


--
-- Name: COLUMN crossings.ften_forest_file_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.ften_forest_file_id IS 'FTEN road forest_file_id value, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings.ften_road_section_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.ften_road_section_id IS 'FTEN road road_section_id value, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings.ften_file_type_description; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.ften_file_type_description IS 'FTEN road tenure type (Forest Service Road, Road Permit, etc), taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings.ften_client_number; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.ften_client_number IS 'FTEN road client number, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings.ften_client_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.ften_client_name IS 'FTEN road client name, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings.ften_life_cycle_status_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.ften_life_cycle_status_code IS 'FTEN road life_cycle_status_code (active or retired, pending roads are not included), taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings.ften_map_label; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.ften_map_label IS 'FTEN road map_label value, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings.rail_track_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.rail_track_name IS 'Railway name, taken from nearest railway (within 25m)';


--
-- Name: COLUMN crossings.rail_owner_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.rail_owner_name IS 'Railway owner name, taken from nearest railway (within 25m)';


--
-- Name: COLUMN crossings.rail_operator_english_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.rail_operator_english_name IS 'Railway operator name, taken from nearest railway (within 25m)';


--
-- Name: COLUMN crossings.ogc_proponent; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.ogc_proponent IS 'OGC road tenure proponent (currently modelled crossings only, taken from OGC road that crosses the stream)';


--
-- Name: COLUMN crossings.dam_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.dam_name IS 'See CABD dams column: dam_name_en';


--
-- Name: COLUMN crossings.dam_height; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.dam_height IS 'See CABD dams column: dam_height';


--
-- Name: COLUMN crossings.dam_owner; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.dam_owner IS 'See CABD dams column: owner';


--
-- Name: COLUMN crossings.dam_use; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.dam_use IS 'See CABD table dam_use_codes';


--
-- Name: COLUMN crossings.dam_operating_status; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.dam_operating_status IS 'See CABD dams column dam_operating_status';


--
-- Name: COLUMN crossings.utm_zone; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.utm_zone IS 'UTM ZONE is a segment of the Earths surface 6 degrees of longitude in width. The zones are numbered eastward starting at the meridian 180 degrees from the prime meridian at Greenwich. There are five zones numbered 7 through 11 that cover British Columbia, e.g., Zone 10 with a central meridian at -123 degrees.';


--
-- Name: COLUMN crossings.utm_easting; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.utm_easting IS 'UTM EASTING is the distance in meters eastward to or from the central meridian of a UTM zone with a false easting of 500000 meters. e.g., 440698';


--
-- Name: COLUMN crossings.utm_northing; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.utm_northing IS 'UTM NORTHING is the distance in meters northward from the equator. e.g., 6197826';


--
-- Name: COLUMN crossings.linear_feature_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.linear_feature_id IS 'From BC FWA, the unique identifier for a stream segment (flow network arc)';


--
-- Name: COLUMN crossings.blue_line_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.blue_line_key IS 'From BC FWA, uniquely identifies a single flow line such that a main channel and a secondary channel with the same watershed code would have different blue line keys (the Fraser River and all side channels have different blue line keys).';


--
-- Name: COLUMN crossings.watershed_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.watershed_key IS 'From BC FWA, a key that identifies a stream system. There is a 1:1 match between a watershed key and watershed code. The watershed key will match the blue line key for the mainstem.';


--
-- Name: COLUMN crossings.downstream_route_measure; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.downstream_route_measure IS 'The distance, in meters, along the blue_line_key from the mouth of the stream/blue_line_key to the feature.';


--
-- Name: COLUMN crossings.wscode_ltree; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.wscode_ltree IS 'A truncated version of the BC FWA fwa_watershed_code (trailing zeros removed and "-" replaced with ".", stored as postgres type ltree for fast tree based queries';


--
-- Name: COLUMN crossings.localcode_ltree; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.localcode_ltree IS 'A truncated version of the BC FWA local_watershed_code (trailing zeros removed and "-" replaced with ".", stored as postgres type ltree for fast tree based queries';


--
-- Name: COLUMN crossings.watershed_group_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.watershed_group_code IS 'The watershed group code associated with the feature.';


--
-- Name: COLUMN crossings.gnis_stream_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.gnis_stream_name IS 'The BCGNIS (BC Geographical Names Information System) name associated with the FWA stream';


--
-- Name: COLUMN crossings.stream_order; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.stream_order IS 'Order of FWA stream at point';


--
-- Name: COLUMN crossings.stream_magnitude; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.stream_magnitude IS 'Magnitude of FWA stream at point';


--
-- Name: COLUMN crossings.geom; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings.geom IS 'The point geometry associated with the feature';


--
-- Name: crossings_admin_vw; Type: MATERIALIZED VIEW; Schema: bcfishpass; Owner: -
--

CREATE MATERIALIZED VIEW bcfishpass.crossings_admin_vw AS
 SELECT DISTINCT ON (c.aggregated_crossings_id) c.aggregated_crossings_id,
    rd.admin_area_abbreviation AS abms_regional_district,
    muni.admin_area_abbreviation AS abms_municipality,
    ir.english_name AS clab_indian_reserve_name,
    ir.band_name AS clab_indian_reserve_band_name,
    np.english_name AS clab_national_park_name,
    pp.protected_lands_name AS bc_protected_lands_name,
    pmbc.owner_type AS pmbc_owner_type,
    nr.region_org_unit_name AS adm_nr_region,
    nr.district_name AS adm_nr_district
   FROM (((((((bcfishpass.crossings c
     LEFT JOIN whse_legal_admin_boundaries.abms_regional_districts_sp rd ON (public.st_intersects(c.geom, rd.geom)))
     LEFT JOIN whse_legal_admin_boundaries.abms_municipalities_sp muni ON (public.st_intersects(c.geom, muni.geom)))
     LEFT JOIN whse_admin_boundaries.adm_indian_reserves_bands_sp ir ON (public.st_intersects(c.geom, ir.geom)))
     LEFT JOIN whse_admin_boundaries.clab_national_parks np ON (public.st_intersects(c.geom, np.geom)))
     LEFT JOIN whse_tantalis.ta_park_ecores_pa_svw pp ON (public.st_intersects(c.geom, pp.geom)))
     LEFT JOIN whse_cadastre.pmbc_parcel_fabric_poly_svw pmbc ON (public.st_intersects(c.geom, pmbc.geom)))
     LEFT JOIN whse_admin_boundaries.adm_nr_districts_spg nr ON (public.st_intersects(c.geom, pmbc.geom)))
  ORDER BY c.aggregated_crossings_id, rd.admin_area_abbreviation, muni.admin_area_abbreviation, ir.english_name, pp.protected_lands_name, pmbc.owner_type, nr.district_name
  WITH NO DATA;


--
-- Name: crossings_dnstr_barriers_anthropogenic; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings_dnstr_barriers_anthropogenic (
    aggregated_crossings_id text NOT NULL,
    features_dnstr text[]
);


--
-- Name: crossings_dnstr_crossings; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings_dnstr_crossings (
    aggregated_crossings_id text NOT NULL,
    features_dnstr text[]
);


--
-- Name: crossings_dnstr_observations; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings_dnstr_observations (
    aggregated_crossings_id text NOT NULL,
    observedspp_dnstr text[]
);


--
-- Name: crossings_upstr_barriers_anthropogenic; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings_upstr_barriers_anthropogenic (
    aggregated_crossings_id text NOT NULL,
    features_upstr text[]
);


--
-- Name: crossings_upstr_barriers_per_model; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings_upstr_barriers_per_model (
    aggregated_crossings_id text,
    barriers_upstr_bt text[],
    barriers_upstr_ch_cm_co_pk_sk text[],
    barriers_upstr_ct_dv_rb text[],
    barriers_upstr_st text[],
    barriers_upstr_wct text[]
);


--
-- Name: crossings_upstr_observations; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings_upstr_observations (
    aggregated_crossings_id text NOT NULL,
    observedspp_upstr text[]
);


--
-- Name: crossings_upstream_access; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings_upstream_access (
    aggregated_crossings_id text NOT NULL,
    watershed_group_code character varying(4),
    gradient double precision,
    total_network_km double precision DEFAULT 0,
    total_stream_km double precision DEFAULT 0,
    total_lakereservoir_ha double precision DEFAULT 0,
    total_wetland_ha double precision DEFAULT 0,
    total_slopeclass03_waterbodies_km double precision DEFAULT 0,
    total_slopeclass03_km double precision DEFAULT 0,
    total_slopeclass05_km double precision DEFAULT 0,
    total_slopeclass08_km double precision DEFAULT 0,
    total_slopeclass15_km double precision DEFAULT 0,
    total_slopeclass22_km double precision DEFAULT 0,
    total_slopeclass30_km double precision DEFAULT 0,
    total_belowupstrbarriers_network_km double precision DEFAULT 0,
    total_belowupstrbarriers_stream_km double precision DEFAULT 0,
    total_belowupstrbarriers_lakereservoir_ha double precision DEFAULT 0,
    total_belowupstrbarriers_wetland_ha double precision DEFAULT 0,
    total_belowupstrbarriers_slopeclass03_waterbodies_km double precision DEFAULT 0,
    total_belowupstrbarriers_slopeclass03_km double precision DEFAULT 0,
    total_belowupstrbarriers_slopeclass05_km double precision DEFAULT 0,
    total_belowupstrbarriers_slopeclass08_km double precision DEFAULT 0,
    total_belowupstrbarriers_slopeclass15_km double precision DEFAULT 0,
    total_belowupstrbarriers_slopeclass22_km double precision DEFAULT 0,
    total_belowupstrbarriers_slopeclass30_km double precision DEFAULT 0,
    barriers_bt_dnstr text[],
    bt_network_km double precision DEFAULT 0,
    bt_stream_km double precision DEFAULT 0,
    bt_lakereservoir_ha double precision DEFAULT 0,
    bt_wetland_ha double precision DEFAULT 0,
    bt_slopeclass03_waterbodies_km double precision DEFAULT 0,
    bt_slopeclass03_km double precision DEFAULT 0,
    bt_slopeclass05_km double precision DEFAULT 0,
    bt_slopeclass08_km double precision DEFAULT 0,
    bt_slopeclass15_km double precision DEFAULT 0,
    bt_slopeclass22_km double precision DEFAULT 0,
    bt_slopeclass30_km double precision DEFAULT 0,
    bt_belowupstrbarriers_network_km double precision DEFAULT 0,
    bt_belowupstrbarriers_stream_km double precision DEFAULT 0,
    bt_belowupstrbarriers_lakereservoir_ha double precision DEFAULT 0,
    bt_belowupstrbarriers_wetland_ha double precision DEFAULT 0,
    bt_belowupstrbarriers_slopeclass03_waterbodies_km double precision DEFAULT 0,
    bt_belowupstrbarriers_slopeclass03_km double precision DEFAULT 0,
    bt_belowupstrbarriers_slopeclass05_km double precision DEFAULT 0,
    bt_belowupstrbarriers_slopeclass08_km double precision DEFAULT 0,
    bt_belowupstrbarriers_slopeclass15_km double precision DEFAULT 0,
    bt_belowupstrbarriers_slopeclass22_km double precision DEFAULT 0,
    bt_belowupstrbarriers_slopeclass30_km double precision DEFAULT 0,
    barriers_ch_cm_co_pk_sk_dnstr text[],
    ch_cm_co_pk_sk_network_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_stream_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_lakereservoir_ha double precision DEFAULT 0,
    ch_cm_co_pk_sk_wetland_ha double precision DEFAULT 0,
    ch_cm_co_pk_sk_slopeclass03_waterbodies_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_slopeclass03_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_slopeclass05_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_slopeclass08_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_slopeclass15_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_slopeclass22_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_slopeclass30_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_network_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_stream_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km double precision DEFAULT 0,
    ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km double precision DEFAULT 0,
    barriers_ct_dv_rb_dnstr text[],
    ct_dv_rb_network_km double precision DEFAULT 0,
    ct_dv_rb_stream_km double precision DEFAULT 0,
    ct_dv_rb_lakereservoir_ha double precision DEFAULT 0,
    ct_dv_rb_wetland_ha double precision DEFAULT 0,
    ct_dv_rb_slopeclass03_waterbodies_km double precision DEFAULT 0,
    ct_dv_rb_slopeclass03_km double precision DEFAULT 0,
    ct_dv_rb_slopeclass05_km double precision DEFAULT 0,
    ct_dv_rb_slopeclass08_km double precision DEFAULT 0,
    ct_dv_rb_slopeclass15_km double precision DEFAULT 0,
    ct_dv_rb_slopeclass22_km double precision DEFAULT 0,
    ct_dv_rb_slopeclass30_km double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_network_km double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_stream_km double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_lakereservoir_ha double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_wetland_ha double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_slopeclass03_waterbodies_km double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_slopeclass03_km double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_slopeclass05_km double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_slopeclass08_km double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_slopeclass15_km double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_slopeclass22_km double precision DEFAULT 0,
    ct_dv_rb_belowupstrbarriers_slopeclass30_km double precision DEFAULT 0,
    barriers_st_dnstr text[],
    st_network_km double precision DEFAULT 0,
    st_stream_km double precision DEFAULT 0,
    st_lakereservoir_ha double precision DEFAULT 0,
    st_wetland_ha double precision DEFAULT 0,
    st_slopeclass03_waterbodies_km double precision DEFAULT 0,
    st_slopeclass03_km double precision DEFAULT 0,
    st_slopeclass05_km double precision DEFAULT 0,
    st_slopeclass08_km double precision DEFAULT 0,
    st_slopeclass15_km double precision DEFAULT 0,
    st_slopeclass22_km double precision DEFAULT 0,
    st_slopeclass30_km double precision DEFAULT 0,
    st_belowupstrbarriers_network_km double precision DEFAULT 0,
    st_belowupstrbarriers_stream_km double precision DEFAULT 0,
    st_belowupstrbarriers_lakereservoir_ha double precision DEFAULT 0,
    st_belowupstrbarriers_wetland_ha double precision DEFAULT 0,
    st_belowupstrbarriers_slopeclass03_waterbodies_km double precision DEFAULT 0,
    st_belowupstrbarriers_slopeclass03_km double precision DEFAULT 0,
    st_belowupstrbarriers_slopeclass05_km double precision DEFAULT 0,
    st_belowupstrbarriers_slopeclass08_km double precision DEFAULT 0,
    st_belowupstrbarriers_slopeclass15_km double precision DEFAULT 0,
    st_belowupstrbarriers_slopeclass22_km double precision DEFAULT 0,
    st_belowupstrbarriers_slopeclass30_km double precision DEFAULT 0,
    barriers_wct_dnstr text[],
    wct_network_km double precision DEFAULT 0,
    wct_stream_km double precision DEFAULT 0,
    wct_lakereservoir_ha double precision DEFAULT 0,
    wct_wetland_ha double precision DEFAULT 0,
    wct_slopeclass03_waterbodies_km double precision DEFAULT 0,
    wct_slopeclass03_km double precision DEFAULT 0,
    wct_slopeclass05_km double precision DEFAULT 0,
    wct_slopeclass08_km double precision DEFAULT 0,
    wct_slopeclass15_km double precision DEFAULT 0,
    wct_slopeclass22_km double precision DEFAULT 0,
    wct_slopeclass30_km double precision DEFAULT 0,
    wct_belowupstrbarriers_network_km double precision DEFAULT 0,
    wct_belowupstrbarriers_stream_km double precision DEFAULT 0,
    wct_belowupstrbarriers_lakereservoir_ha double precision DEFAULT 0,
    wct_belowupstrbarriers_wetland_ha double precision DEFAULT 0,
    wct_belowupstrbarriers_slopeclass03_waterbodies_km double precision DEFAULT 0,
    wct_belowupstrbarriers_slopeclass03_km double precision DEFAULT 0,
    wct_belowupstrbarriers_slopeclass05_km double precision DEFAULT 0,
    wct_belowupstrbarriers_slopeclass08_km double precision DEFAULT 0,
    wct_belowupstrbarriers_slopeclass15_km double precision DEFAULT 0,
    wct_belowupstrbarriers_slopeclass22_km double precision DEFAULT 0,
    wct_belowupstrbarriers_slopeclass30_km double precision DEFAULT 0
);


--
-- Name: crossings_upstream_habitat; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings_upstream_habitat (
    aggregated_crossings_id text NOT NULL,
    watershed_group_code character varying(4),
    bt_spawning_km double precision DEFAULT 0,
    bt_rearing_km double precision DEFAULT 0,
    bt_spawning_belowupstrbarriers_km double precision DEFAULT 0,
    bt_rearing_belowupstrbarriers_km double precision DEFAULT 0,
    ch_spawning_km double precision DEFAULT 0,
    ch_rearing_km double precision DEFAULT 0,
    ch_spawning_belowupstrbarriers_km double precision DEFAULT 0,
    ch_rearing_belowupstrbarriers_km double precision DEFAULT 0,
    cm_spawning_km double precision DEFAULT 0,
    cm_spawning_belowupstrbarriers_km double precision DEFAULT 0,
    co_spawning_km double precision DEFAULT 0,
    co_rearing_km double precision DEFAULT 0,
    co_rearing_ha double precision DEFAULT 0,
    co_spawning_belowupstrbarriers_km double precision DEFAULT 0,
    co_rearing_belowupstrbarriers_km double precision DEFAULT 0,
    co_rearing_belowupstrbarriers_ha double precision DEFAULT 0,
    pk_spawning_km double precision DEFAULT 0,
    pk_spawning_belowupstrbarriers_km double precision DEFAULT 0,
    sk_spawning_km double precision DEFAULT 0,
    sk_rearing_km double precision DEFAULT 0,
    sk_rearing_ha double precision DEFAULT 0,
    sk_spawning_belowupstrbarriers_km double precision DEFAULT 0,
    sk_rearing_belowupstrbarriers_km double precision DEFAULT 0,
    sk_rearing_belowupstrbarriers_ha double precision DEFAULT 0,
    st_spawning_km double precision DEFAULT 0,
    st_rearing_km double precision DEFAULT 0,
    st_spawning_belowupstrbarriers_km double precision DEFAULT 0,
    st_rearing_belowupstrbarriers_km double precision DEFAULT 0,
    wct_spawning_km double precision DEFAULT 0,
    wct_rearing_km double precision DEFAULT 0,
    wct_spawning_belowupstrbarriers_km double precision DEFAULT 0,
    wct_rearing_belowupstrbarriers_km double precision DEFAULT 0,
    bt_spawningrearing_km double precision DEFAULT 0,
    bt_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0,
    ch_spawningrearing_km double precision DEFAULT 0,
    ch_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0,
    co_spawningrearing_km double precision DEFAULT 0,
    co_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0,
    sk_spawningrearing_km double precision DEFAULT 0,
    sk_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0,
    st_spawningrearing_km double precision DEFAULT 0,
    st_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0,
    salmon_spawningrearing_km double precision DEFAULT 0,
    salmon_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0,
    salmonsteelhead_spawningrearing_km double precision DEFAULT 0,
    salmonsteelhead_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0,
    wct_spawningrearing_km double precision DEFAULT 0,
    wct_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0
);


--
-- Name: crossings_upstream_habitat_wcrp; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.crossings_upstream_habitat_wcrp (
    aggregated_crossings_id text NOT NULL,
    watershed_group_code character varying(4),
    co_rearing_km double precision DEFAULT 0,
    co_rearing_belowupstrbarriers_km double precision DEFAULT 0,
    sk_rearing_km double precision DEFAULT 0,
    sk_rearing_belowupstrbarriers_km double precision DEFAULT 0,
    all_spawning_km double precision DEFAULT 0,
    all_spawning_belowupstrbarriers_km double precision DEFAULT 0,
    all_rearing_km double precision DEFAULT 0,
    all_rearing_belowupstrbarriers_km double precision DEFAULT 0,
    all_spawningrearing_km double precision DEFAULT 0,
    all_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0,
    co_spawningrearing_km double precision DEFAULT 0,
    co_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0,
    sk_spawningrearing_km double precision DEFAULT 0,
    sk_spawningrearing_belowupstrbarriers_km double precision DEFAULT 0
);


--
-- Name: streams; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams (
    segmented_stream_id text GENERATED ALWAYS AS ((((blue_line_key)::text || '.'::text) || (round((public.st_m(public.st_pointn(geom, 1)) * (1000)::double precision)))::text)) STORED NOT NULL,
    linear_feature_id bigint,
    edge_type integer,
    blue_line_key integer,
    watershed_key integer,
    watershed_group_code character varying(4),
    downstream_route_measure double precision GENERATED ALWAYS AS (public.st_m(public.st_pointn(geom, 1))) STORED,
    length_metre double precision GENERATED ALWAYS AS (public.st_length(geom)) STORED,
    waterbody_key integer,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    gnis_name character varying(80),
    stream_order integer,
    stream_magnitude integer,
    gradient double precision GENERATED ALWAYS AS (round((((public.st_z(public.st_pointn(geom, '-1'::integer)) - public.st_z(public.st_pointn(geom, 1))) / public.st_length(geom)))::numeric, 4)) STORED,
    feature_code character varying(10),
    upstream_route_measure double precision GENERATED ALWAYS AS (public.st_m(public.st_pointn(geom, '-1'::integer))) STORED,
    upstream_area_ha double precision,
    stream_order_parent integer,
    stream_order_max integer,
    map_upstream integer,
    channel_width double precision,
    mad_m3s double precision,
    geom public.geometry(LineStringZM,3005)
);


--
-- Name: crossings_vw; Type: MATERIALIZED VIEW; Schema: bcfishpass; Owner: -
--

CREATE MATERIALIZED VIEW bcfishpass.crossings_vw AS
 SELECT DISTINCT ON (c.aggregated_crossings_id) c.aggregated_crossings_id,
    c.stream_crossing_id,
    c.dam_id,
    c.user_crossing_misc_id,
    c.modelled_crossing_id,
    c.crossing_source,
    c.crossing_feature_type,
    c.pscis_status,
    c.crossing_type_code,
    c.crossing_subtype_code,
    array_to_string(c.modelled_crossing_type_source, ';'::text) AS modelled_crossing_type_source,
    c.barrier_status,
    c.pscis_road_name,
    c.pscis_stream_name,
    c.pscis_assessment_comment,
    c.pscis_assessment_date,
    c.pscis_final_score,
    c.transport_line_structured_name_1,
    c.transport_line_type_description,
    c.transport_line_surface_description,
    c.ften_forest_file_id,
    c.ften_road_section_id,
    c.ften_file_type_description,
    c.ften_client_number,
    c.ften_client_name,
    c.ften_life_cycle_status_code,
    c.ften_map_label,
    c.rail_track_name,
    c.rail_owner_name,
    c.rail_operator_english_name,
    c.ogc_proponent,
    c.dam_name,
    c.dam_height,
    c.dam_owner,
    c.dam_use,
    c.dam_operating_status,
    c.utm_zone,
    c.utm_easting,
    c.utm_northing,
    t.map_tile_display_name AS dbm_mof_50k_grid,
    c.linear_feature_id,
    c.blue_line_key,
    c.watershed_key,
    c.downstream_route_measure,
    c.wscode_ltree AS wscode,
    c.localcode_ltree AS localcode,
    c.watershed_group_code,
    c.gnis_stream_name,
    c.stream_order,
    c.stream_magnitude,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(cdo.observedspp_dnstr, ';'::text) AS observedspp_dnstr,
    array_to_string(cuo.observedspp_upstr, ';'::text) AS observedspp_upstr,
    array_to_string(cd.features_dnstr, ';'::text) AS crossings_dnstr,
    array_to_string(ad.features_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    COALESCE(array_length(ad.features_dnstr, 1), 0) AS barriers_anthropogenic_dnstr_count,
    array_to_string(au.features_upstr, ';'::text) AS barriers_anthropogenic_upstr,
    COALESCE(array_length(au.features_upstr, 1), 0) AS barriers_anthropogenic_upstr_count,
    array_to_string(aum.barriers_upstr_bt, ';'::text) AS barriers_anthropogenic_bt_upstr,
    COALESCE(array_length(aum.barriers_upstr_bt, 1), 0) AS barriers_anthropogenic_upstr_bt_count,
    array_to_string(aum.barriers_upstr_ch_cm_co_pk_sk, ';'::text) AS barriers_anthropogenic_ch_cm_co_pk_sk_upstr,
    COALESCE(array_length(aum.barriers_upstr_ch_cm_co_pk_sk, 1), 0) AS barriers_anthropogenic_ch_cm_co_pk_sk_upstr_count,
    array_to_string(aum.barriers_upstr_st, ';'::text) AS barriers_anthropogenic_st_upstr,
    COALESCE(array_length(aum.barriers_upstr_st, 1), 0) AS barriers_anthropogenic_st_upstr_count,
    array_to_string(aum.barriers_upstr_wct, ';'::text) AS barriers_anthropogenic_wct_upstr,
    COALESCE(array_length(aum.barriers_upstr_wct, 1), 0) AS barriers_anthropogenic_wct_upstr_count,
    a.gradient,
    a.total_network_km,
    a.total_stream_km,
    a.total_lakereservoir_ha,
    a.total_wetland_ha,
    a.total_slopeclass03_waterbodies_km,
    a.total_slopeclass03_km,
    a.total_slopeclass05_km,
    a.total_slopeclass08_km,
    a.total_slopeclass15_km,
    a.total_slopeclass22_km,
    a.total_slopeclass30_km,
    a.total_belowupstrbarriers_network_km,
    a.total_belowupstrbarriers_stream_km,
    a.total_belowupstrbarriers_lakereservoir_ha,
    a.total_belowupstrbarriers_wetland_ha,
    a.total_belowupstrbarriers_slopeclass03_waterbodies_km,
    a.total_belowupstrbarriers_slopeclass03_km,
    a.total_belowupstrbarriers_slopeclass05_km,
    a.total_belowupstrbarriers_slopeclass08_km,
    a.total_belowupstrbarriers_slopeclass15_km,
    a.total_belowupstrbarriers_slopeclass22_km,
    a.total_belowupstrbarriers_slopeclass30_km,
    array_to_string(a.barriers_bt_dnstr, ';'::text) AS barriers_bt_dnstr,
    a.bt_network_km,
    a.bt_stream_km,
    a.bt_lakereservoir_ha,
    a.bt_wetland_ha,
    a.bt_slopeclass03_waterbodies_km,
    a.bt_slopeclass03_km,
    a.bt_slopeclass05_km,
    a.bt_slopeclass08_km,
    a.bt_slopeclass15_km,
    a.bt_slopeclass22_km,
    a.bt_slopeclass30_km,
    a.bt_belowupstrbarriers_network_km,
    a.bt_belowupstrbarriers_stream_km,
    a.bt_belowupstrbarriers_lakereservoir_ha,
    a.bt_belowupstrbarriers_wetland_ha,
    a.bt_belowupstrbarriers_slopeclass03_waterbodies_km,
    a.bt_belowupstrbarriers_slopeclass03_km,
    a.bt_belowupstrbarriers_slopeclass05_km,
    a.bt_belowupstrbarriers_slopeclass08_km,
    a.bt_belowupstrbarriers_slopeclass15_km,
    a.bt_belowupstrbarriers_slopeclass22_km,
    a.bt_belowupstrbarriers_slopeclass30_km,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    a.ch_cm_co_pk_sk_network_km,
    a.ch_cm_co_pk_sk_stream_km,
    a.ch_cm_co_pk_sk_lakereservoir_ha,
    a.ch_cm_co_pk_sk_wetland_ha,
    a.ch_cm_co_pk_sk_slopeclass03_waterbodies_km,
    a.ch_cm_co_pk_sk_slopeclass03_km,
    a.ch_cm_co_pk_sk_slopeclass05_km,
    a.ch_cm_co_pk_sk_slopeclass08_km,
    a.ch_cm_co_pk_sk_slopeclass15_km,
    a.ch_cm_co_pk_sk_slopeclass22_km,
    a.ch_cm_co_pk_sk_slopeclass30_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_network_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_stream_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha,
    a.ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km,
    a.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km,
    array_to_string(a.barriers_st_dnstr, ';'::text) AS barriers_st_dnstr,
    a.st_network_km,
    a.st_stream_km,
    a.st_lakereservoir_ha,
    a.st_wetland_ha,
    a.st_slopeclass03_waterbodies_km,
    a.st_slopeclass03_km,
    a.st_slopeclass05_km,
    a.st_slopeclass08_km,
    a.st_slopeclass15_km,
    a.st_slopeclass22_km,
    a.st_slopeclass30_km,
    a.st_belowupstrbarriers_network_km,
    a.st_belowupstrbarriers_stream_km,
    a.st_belowupstrbarriers_lakereservoir_ha,
    a.st_belowupstrbarriers_wetland_ha,
    a.st_belowupstrbarriers_slopeclass03_waterbodies_km,
    a.st_belowupstrbarriers_slopeclass03_km,
    a.st_belowupstrbarriers_slopeclass05_km,
    a.st_belowupstrbarriers_slopeclass08_km,
    a.st_belowupstrbarriers_slopeclass15_km,
    a.st_belowupstrbarriers_slopeclass22_km,
    a.st_belowupstrbarriers_slopeclass30_km,
    array_to_string(a.barriers_wct_dnstr, ';'::text) AS barriers_wct_dnstr,
    a.wct_network_km,
    a.wct_stream_km,
    a.wct_lakereservoir_ha,
    a.wct_wetland_ha,
    a.wct_slopeclass03_waterbodies_km,
    a.wct_slopeclass03_km,
    a.wct_slopeclass05_km,
    a.wct_slopeclass08_km,
    a.wct_slopeclass15_km,
    a.wct_slopeclass22_km,
    a.wct_slopeclass30_km,
    a.wct_belowupstrbarriers_network_km,
    a.wct_belowupstrbarriers_stream_km,
    a.wct_belowupstrbarriers_lakereservoir_ha,
    a.wct_belowupstrbarriers_wetland_ha,
    a.wct_belowupstrbarriers_slopeclass03_waterbodies_km,
    a.wct_belowupstrbarriers_slopeclass03_km,
    a.wct_belowupstrbarriers_slopeclass05_km,
    a.wct_belowupstrbarriers_slopeclass08_km,
    a.wct_belowupstrbarriers_slopeclass15_km,
    a.wct_belowupstrbarriers_slopeclass22_km,
    a.wct_belowupstrbarriers_slopeclass30_km,
    h.bt_spawning_km,
    h.bt_rearing_km,
    h.bt_spawningrearing_km,
    h.bt_spawning_belowupstrbarriers_km,
    h.bt_rearing_belowupstrbarriers_km,
    h.bt_spawningrearing_belowupstrbarriers_km,
    h.ch_spawning_km,
    h.ch_rearing_km,
    h.ch_spawningrearing_km,
    h.ch_spawning_belowupstrbarriers_km,
    h.ch_rearing_belowupstrbarriers_km,
    h.ch_spawningrearing_belowupstrbarriers_km,
    h.cm_spawning_km,
    h.cm_spawning_belowupstrbarriers_km,
    h.co_spawning_km,
    h.co_rearing_km,
    h.co_rearing_ha,
    h.co_spawningrearing_km,
    h.co_spawning_belowupstrbarriers_km,
    h.co_rearing_belowupstrbarriers_km,
    h.co_rearing_belowupstrbarriers_ha,
    h.co_spawningrearing_belowupstrbarriers_km,
    h.pk_spawning_km,
    h.pk_spawning_belowupstrbarriers_km,
    h.sk_spawning_km,
    h.sk_rearing_km,
    h.sk_rearing_ha,
    h.sk_spawningrearing_km,
    h.sk_spawning_belowupstrbarriers_km,
    h.sk_rearing_belowupstrbarriers_km,
    h.sk_rearing_belowupstrbarriers_ha,
    h.sk_spawningrearing_belowupstrbarriers_km,
    h.st_spawning_km,
    h.st_rearing_km,
    h.st_spawningrearing_km,
    h.st_spawning_belowupstrbarriers_km,
    h.st_rearing_belowupstrbarriers_km,
    h.st_spawningrearing_belowupstrbarriers_km,
    h.salmon_spawningrearing_km,
    h.salmon_spawningrearing_belowupstrbarriers_km,
    h.salmonsteelhead_spawningrearing_km,
    h.salmonsteelhead_spawningrearing_belowupstrbarriers_km,
    h.wct_spawning_km,
    h.wct_rearing_km,
    h.wct_spawningrearing_km,
    h.wct_spawning_belowupstrbarriers_km,
    h.wct_rearing_belowupstrbarriers_km,
    h.wct_spawningrearing_belowupstrbarriers_km,
    c.geom
   FROM ((((((((((bcfishpass.crossings c
     LEFT JOIN bcfishpass.crossings_dnstr_observations cdo ON ((c.aggregated_crossings_id = cdo.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstr_observations cuo ON ((c.aggregated_crossings_id = cuo.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_dnstr_crossings cd ON ((c.aggregated_crossings_id = cd.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_dnstr_barriers_anthropogenic ad ON ((c.aggregated_crossings_id = ad.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstr_barriers_anthropogenic au ON ((c.aggregated_crossings_id = au.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstr_barriers_per_model aum ON ((c.aggregated_crossings_id = aum.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstream_access a ON ((c.aggregated_crossings_id = a.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstream_habitat h ON ((c.aggregated_crossings_id = h.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.streams s ON ((c.linear_feature_id = s.linear_feature_id)))
     LEFT JOIN whse_basemapping.dbm_mof_50k_grid t ON (public.st_intersects(c.geom, t.geom)))
  ORDER BY c.aggregated_crossings_id, s.downstream_route_measure
  WITH NO DATA;


--
-- Name: COLUMN crossings_vw.aggregated_crossings_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.aggregated_crossings_id IS 'unique identifier for crossing, generated from stream_crossing_id, modelled_crossing_id + 1000000000, user_barrier_anthropogenic_id + 1200000000, cabd_id';


--
-- Name: COLUMN crossings_vw.stream_crossing_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.stream_crossing_id IS 'PSCIS stream crossing unique identifier';


--
-- Name: COLUMN crossings_vw.dam_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.dam_id IS 'BC Dams unique identifier';


--
-- Name: COLUMN crossings_vw.user_crossing_misc_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.user_crossing_misc_id IS 'Misc user added crossings unique identifier';


--
-- Name: COLUMN crossings_vw.modelled_crossing_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.modelled_crossing_id IS 'Modelled crossing unique identifier';


--
-- Name: COLUMN crossings_vw.crossing_source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.crossing_source IS 'Data source for the crossing, one of: {PSCIS,MODELLED CROSSINGS,CABD,MISC BARRIERS}';


--
-- Name: COLUMN crossings_vw.pscis_status; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.pscis_status IS 'From PSCIS, the current_pscis_status of the crossing, one of: {ASSESSED,HABITAT CONFIRMATION,DESIGN,REMEDIATED}';


--
-- Name: COLUMN crossings_vw.crossing_type_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.crossing_type_code IS 'Defines the type of crossing present at the location of the stream crossing. Acceptable types are: OBS = Open Bottom Structure CBS = Closed Bottom Structure OTHER = Crossing structure does not fit into the above categories. Eg: ford, wier';


--
-- Name: COLUMN crossings_vw.crossing_subtype_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.crossing_subtype_code IS 'Further definition of the type of crossing, one of {BRIDGE,CRTBOX,DAM,FORD,OVAL,PIPEARCH,ROUND,WEIR,WOODBOX,NULL}';


--
-- Name: COLUMN crossings_vw.modelled_crossing_type_source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.modelled_crossing_type_source IS 'List of sources that indicate if a modelled crossing is open bottom, Acceptable values are: FWA_EDGE_TYPE=double line river, FWA_STREAM_ORDER=stream order >=6, GBA_RAILWAY_STRUCTURE_LINES_SP=railway structure, "MANUAL FIX"=manually identified OBS, MOT_ROAD_STRUCTURE_SP=MoT structure, TRANSPORT_LINE_STRUCTURE_CODE=DRA structure}';


--
-- Name: COLUMN crossings_vw.barrier_status; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barrier_status IS 'The evaluation of the crossing as a barrier to the fish passage. From PSCIS, this is based on the FINAL SCORE value. For other data sources this varies. Acceptable Values are: PASSABLE - Passable, POTENTIAL - Potential or partial barrier, BARRIER - Barrier, UNKNOWN - Other';


--
-- Name: COLUMN crossings_vw.pscis_road_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.pscis_road_name IS 'PSCIS road name, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings_vw.pscis_stream_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.pscis_stream_name IS 'PSCIS stream name, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings_vw.pscis_assessment_comment; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.pscis_assessment_comment IS 'PSCIS assessment_comment, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings_vw.pscis_assessment_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.pscis_assessment_date IS 'PSCIS assessment_date, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings_vw.pscis_final_score; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.pscis_final_score IS 'PSCIS final_score, taken from the PSCIS assessment data submission';


--
-- Name: COLUMN crossings_vw.transport_line_structured_name_1; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.transport_line_structured_name_1 IS 'DRA road name, taken from the nearest DRA road (within 30m)';


--
-- Name: COLUMN crossings_vw.transport_line_type_description; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.transport_line_type_description IS 'DRA road type, taken from the nearest DRA road (within 30m)';


--
-- Name: COLUMN crossings_vw.transport_line_surface_description; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.transport_line_surface_description IS 'DRA road surface, taken from the nearest DRA road (within 30m)';


--
-- Name: COLUMN crossings_vw.ften_forest_file_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ften_forest_file_id IS 'FTEN road forest_file_id value, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings_vw.ften_road_section_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ften_road_section_id IS 'FTEN road road_section_id value, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings_vw.ften_file_type_description; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ften_file_type_description IS 'FTEN road tenure type (Forest Service Road, Road Permit, etc), taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings_vw.ften_client_number; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ften_client_number IS 'FTEN road client number, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings_vw.ften_client_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ften_client_name IS 'FTEN road client name, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings_vw.ften_life_cycle_status_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ften_life_cycle_status_code IS 'FTEN road life_cycle_status_code (active or retired, pending roads are not included), taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings_vw.ften_map_label; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ften_map_label IS 'FTEN road map_label value, taken from the nearest FTEN road (within 30m)';


--
-- Name: COLUMN crossings_vw.rail_track_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.rail_track_name IS 'Railway name, taken from nearest railway (within 25m)';


--
-- Name: COLUMN crossings_vw.rail_owner_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.rail_owner_name IS 'Railway owner name, taken from nearest railway (within 25m)';


--
-- Name: COLUMN crossings_vw.rail_operator_english_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.rail_operator_english_name IS 'Railway operator name, taken from nearest railway (within 25m)';


--
-- Name: COLUMN crossings_vw.ogc_proponent; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ogc_proponent IS 'OGC road tenure proponent (currently modelled crossings only, taken from OGC road that crosses the stream)';


--
-- Name: COLUMN crossings_vw.dam_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.dam_name IS 'See CABD dams column: dam_name_en';


--
-- Name: COLUMN crossings_vw.dam_height; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.dam_height IS 'See CABD dams column: dam_height';


--
-- Name: COLUMN crossings_vw.dam_owner; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.dam_owner IS 'See CABD dams column: owner';


--
-- Name: COLUMN crossings_vw.dam_use; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.dam_use IS 'See CABD table dam_use_codes';


--
-- Name: COLUMN crossings_vw.dam_operating_status; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.dam_operating_status IS 'See CABD dams column dam_operating_status';


--
-- Name: COLUMN crossings_vw.utm_zone; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.utm_zone IS 'UTM ZONE is a segment of the Earths surface 6 degrees of longitude in width. The zones are numbered eastward starting at the meridian 180 degrees from the prime meridian at Greenwich. There are five zones numbered 7 through 11 that cover British Columbia, e.g., Zone 10 with a central meridian at -123 degrees.';


--
-- Name: COLUMN crossings_vw.utm_easting; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.utm_easting IS 'UTM EASTING is the distance in meters eastward to or from the central meridian of a UTM zone with a false easting of 500000 meters. e.g., 440698';


--
-- Name: COLUMN crossings_vw.utm_northing; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.utm_northing IS 'UTM NORTHING is the distance in meters northward from the equator. e.g., 6197826';


--
-- Name: COLUMN crossings_vw.linear_feature_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.linear_feature_id IS 'From BC FWA, the unique identifier for a stream segment (flow network arc)';


--
-- Name: COLUMN crossings_vw.blue_line_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.blue_line_key IS 'From BC FWA, uniquely identifies a single flow line such that a main channel and a secondary channel with the same watershed code would have different blue line keys (the Fraser River and all side channels have different blue line keys).';


--
-- Name: COLUMN crossings_vw.watershed_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.watershed_key IS 'From BC FWA, a key that identifies a stream system. There is a 1:1 match between a watershed key and watershed code. The watershed key will match the blue line key for the mainstem.';


--
-- Name: COLUMN crossings_vw.downstream_route_measure; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.downstream_route_measure IS 'The distance, in meters, along the blue_line_key from the mouth of the stream/blue_line_key to the feature.';


--
-- Name: COLUMN crossings_vw.wscode; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wscode IS 'A truncated version of the BC FWA fwa_watershed_code (trailing zeros removed and "-" replaced with ".", stored as postgres type ltree for fast tree based queries';


--
-- Name: COLUMN crossings_vw.localcode; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.localcode IS 'A truncated version of the BC FWA local_watershed_code (trailing zeros removed and "-" replaced with ".", stored as postgres type ltree for fast tree based queries';


--
-- Name: COLUMN crossings_vw.watershed_group_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.watershed_group_code IS 'The watershed group code associated with the feature.';


--
-- Name: COLUMN crossings_vw.gnis_stream_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.gnis_stream_name IS 'The BCGNIS (BC Geographical Names Information System) name associated with the FWA stream';


--
-- Name: COLUMN crossings_vw.stream_order; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.stream_order IS 'Order of FWA stream at point';


--
-- Name: COLUMN crossings_vw.stream_magnitude; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.stream_magnitude IS 'Magnitude of FWA stream at point';


--
-- Name: COLUMN crossings_vw.upstream_area_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.upstream_area_ha IS 'Cumulative area upstream of the end of the stream (as defined by linear_feature_id)';


--
-- Name: COLUMN crossings_vw.stream_order_parent; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.stream_order_parent IS 'Stream order of the stream into which the stream drains';


--
-- Name: COLUMN crossings_vw.stream_order_max; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.stream_order_max IS 'Maximum stream order associated with the stream (as defined by blue_line_key)';


--
-- Name: COLUMN crossings_vw.map_upstream; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.map_upstream IS 'Mean annual precipitation for the watershed upstream of the stream segment (as defined by linear_feature_id)';


--
-- Name: COLUMN crossings_vw.channel_width; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.channel_width IS 'Modelled channel width of the stream (m)';


--
-- Name: COLUMN crossings_vw.mad_m3s; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.mad_m3s IS 'Modelled mean annual discharge of the stream (m3/s)';


--
-- Name: COLUMN crossings_vw.observedspp_dnstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.observedspp_dnstr IS 'Species codes of downstream fish observations';


--
-- Name: COLUMN crossings_vw.observedspp_upstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.observedspp_upstr IS 'Species codes of upstream fish observations';


--
-- Name: COLUMN crossings_vw.crossings_dnstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.crossings_dnstr IS 'aggregated_crossings_id value for all downstream crossings';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_dnstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_dnstr IS 'aggregated_crossings_id value for all downstream anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_dnstr_count; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_dnstr_count IS 'Count of anthropogenic downstream barriers';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_upstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_upstr IS 'aggregated_crossings_id value for all upstream anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_upstr_count; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_upstr_count IS 'Count of all upstream anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_bt_upstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_bt_upstr IS 'aggregated_crossings_id value for upstream anthropogenic barriers on streams accessible to Bull Trout';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_upstr_bt_count; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_upstr_bt_count IS 'Count of upstream anthropogenic barriers on streams accessible to Bull Trout';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_ch_cm_co_pk_sk_upstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_ch_cm_co_pk_sk_upstr IS 'aggregated_crossings_id value for upstream anthropogenic barriers on streams accessible to Pacific Salmon';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_ch_cm_co_pk_sk_upstr_count; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_ch_cm_co_pk_sk_upstr_count IS 'Count of upstream anthropogenic barriers on streams accessible to Pacific Salmon';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_st_upstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_st_upstr IS 'aggregated_crossings_id value for upstream anthropogenic barriers on streams accessible to Steelhead';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_st_upstr_count; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_st_upstr_count IS 'Count of upstream anthropogenic barriers on streams accessible to Steelhead';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_wct_upstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_wct_upstr IS 'aggregated_crossings_id value for upstream anthropogenic barriers on streams accessible to West Slope Cutthroat Trout';


--
-- Name: COLUMN crossings_vw.barriers_anthropogenic_wct_upstr_count; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_anthropogenic_wct_upstr_count IS 'Count of upstream anthropogenic barriers on streams accessible to Bull Trout';


--
-- Name: COLUMN crossings_vw.gradient; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.gradient IS 'Gradient of stream segment at crossing (defined by stream_segment_id)';


--
-- Name: COLUMN crossings_vw.total_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_network_km IS 'Total upstream length of FWA stream network (km)';


--
-- Name: COLUMN crossings_vw.total_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_stream_km IS 'Total upstream length of FWA streams (single and double line, km)';


--
-- Name: COLUMN crossings_vw.total_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs (ha)';


--
-- Name: COLUMN crossings_vw.total_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_wetland_ha IS 'Total upstream area of wetlands (ha)';


--
-- Name: COLUMN crossings_vw.total_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies (km)';


--
-- Name: COLUMN crossings_vw.total_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_slopeclass03_km IS 'Total upstream length of stream < 3% gradient (km)';


--
-- Name: COLUMN crossings_vw.total_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_slopeclass05_km IS 'Total upstream length of stream < 5% gradient (km)';


--
-- Name: COLUMN crossings_vw.total_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_slopeclass08_km IS 'Total upstream length of stream < 8% gradient (km)';


--
-- Name: COLUMN crossings_vw.total_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_slopeclass15_km IS 'Total upstream length of stream < 15% gradient (km)';


--
-- Name: COLUMN crossings_vw.total_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_slopeclass22_km IS 'Total upstream length of stream < 22% gradient (km)';


--
-- Name: COLUMN crossings_vw.total_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_slopeclass30_km IS 'Total upstream length of stream < 30% gradient (km)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams, downstream of any anthropogenic barrier  (single and double line, km)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.total_belowupstrbarriers_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.total_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.barriers_bt_dnstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_bt_dnstr IS 'aggregated_crossings_id value for downstream anthropogenic barriers on streams accessible to Bull Trout';


--
-- Name: COLUMN crossings_vw.bt_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_network_km IS 'Total upstream length of FWA stream network accessible to Bull Trout (km)';


--
-- Name: COLUMN crossings_vw.bt_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_stream_km IS 'Total upstream length of FWA streams accessible to Bull Trout (single and double line, km)';


--
-- Name: COLUMN crossings_vw.bt_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Bull Trout (ha)';


--
-- Name: COLUMN crossings_vw.bt_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_wetland_ha IS 'Total upstream area of wetlands accessible to Bull Trout (ha)';


--
-- Name: COLUMN crossings_vw.bt_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Bull Trout (km)';


--
-- Name: COLUMN crossings_vw.bt_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Bull Trout (km)';


--
-- Name: COLUMN crossings_vw.bt_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Bull Trout (km)';


--
-- Name: COLUMN crossings_vw.bt_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Bull Trout (km)';


--
-- Name: COLUMN crossings_vw.bt_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Bull Trout (km)';


--
-- Name: COLUMN crossings_vw.bt_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Bull Trout (km)';


--
-- Name: COLUMN crossings_vw.bt_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Bull Trout (km)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network accessible to Bull Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams accessible to Bull Trout, downstream of any anthropogenic barrier  (single and double line, km)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Bull Trout, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands accessible to Bull Trout, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Bull Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.bt_belowupstrbarriers_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Bull Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.barriers_ch_cm_co_pk_sk_dnstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_ch_cm_co_pk_sk_dnstr IS 'aggregated_crossings_id value for downstream anthropogenic barriers on streams accessible to Pacific Salmon';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_network_km IS 'Total upstream length of FWA stream network accessible to Pacific Salmon (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_stream_km IS 'Total upstream length of FWA streams accessible to Pacific Salmon (single and double line, km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Pacific Salmon (ha)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_wetland_ha IS 'Total upstream area of wetlands accessible to Pacific Salmon (ha)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Pacific Salmon (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Pacific Salmon (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Pacific Salmon (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Pacific Salmon (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Pacific Salmon (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Pacific Salmon (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Pacific Salmon (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams accessible to Pacific Salmon, downstream of any anthropogenic barrier  (single and double line, km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Pacific Salmon, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands accessible to Pacific Salmon, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Pacific Salmon, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.barriers_st_dnstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_st_dnstr IS 'aggregated_crossings_id value for downstream anthropogenic barriers on streams accessible to Steelhead';


--
-- Name: COLUMN crossings_vw.st_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_network_km IS 'Total upstream length of FWA stream network accessible to Steelhead (km)';


--
-- Name: COLUMN crossings_vw.st_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_stream_km IS 'Total upstream length of FWA streams accessible to Steelhead (single and double line, km)';


--
-- Name: COLUMN crossings_vw.st_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Steelhead (ha)';


--
-- Name: COLUMN crossings_vw.st_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_wetland_ha IS 'Total upstream area of wetlands accessible to Steelhead (ha)';


--
-- Name: COLUMN crossings_vw.st_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Steelhead (km)';


--
-- Name: COLUMN crossings_vw.st_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Steelhead (km)';


--
-- Name: COLUMN crossings_vw.st_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Steelhead (km)';


--
-- Name: COLUMN crossings_vw.st_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Steelhead (km)';


--
-- Name: COLUMN crossings_vw.st_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Steelhead (km)';


--
-- Name: COLUMN crossings_vw.st_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Steelhead (km)';


--
-- Name: COLUMN crossings_vw.st_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Steelhead (km)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network accessible to Steelhead, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams accessible to Steelhead, downstream of any anthropogenic barrier  (single and double line, km)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to Steelhead, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands accessible to Steelhead, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to Steelhead, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.st_belowupstrbarriers_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to Steelhead, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.barriers_wct_dnstr; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.barriers_wct_dnstr IS 'aggregated_crossings_id value for downstream anthropogenic barriers on streams accessible to West Slope Cutthroat Trout';


--
-- Name: COLUMN crossings_vw.wct_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_network_km IS 'Total upstream length of FWA stream network accessible to West Slope Cutthroat Trout (km)';


--
-- Name: COLUMN crossings_vw.wct_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_stream_km IS 'Total upstream length of FWA streams accessible to West Slope Cutthroat Trout (single and double line, km)';


--
-- Name: COLUMN crossings_vw.wct_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to West Slope Cutthroat Trout (ha)';


--
-- Name: COLUMN crossings_vw.wct_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_wetland_ha IS 'Total upstream area of wetlands accessible to West Slope Cutthroat Trout (ha)';


--
-- Name: COLUMN crossings_vw.wct_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to West Slope Cutthroat Trout (km)';


--
-- Name: COLUMN crossings_vw.wct_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to West Slope Cutthroat Trout (km)';


--
-- Name: COLUMN crossings_vw.wct_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to West Slope Cutthroat Trout (km)';


--
-- Name: COLUMN crossings_vw.wct_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to West Slope Cutthroat Trout (km)';


--
-- Name: COLUMN crossings_vw.wct_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to West Slope Cutthroat Trout (km)';


--
-- Name: COLUMN crossings_vw.wct_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to West Slope Cutthroat Trout (km)';


--
-- Name: COLUMN crossings_vw.wct_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to West Slope Cutthroat Trout (km)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_network_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_network_km IS 'Total upstream length of FWA stream network accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_stream_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_stream_km IS 'Total upstream length of FWA streams accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier  (single and double line, km)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_lakereservoir_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_lakereservoir_ha IS 'Total upstream area of lakes and reservoirs accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_wetland_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_wetland_ha IS 'Total upstream area of wetlands accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier  (ha)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_slopeclass03_waterbodies_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass03_waterbodies_km IS 'Total upstream length of stream < 3% gradient and connected waterbodies accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_slopeclass03_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass03_km IS 'Total upstream length of stream < 3% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_slopeclass05_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass05_km IS 'Total upstream length of stream < 5% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_slopeclass08_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass08_km IS 'Total upstream length of stream < 8% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_slopeclass15_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass15_km IS 'Total upstream length of stream < 15% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_slopeclass22_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass22_km IS 'Total upstream length of stream < 22% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.wct_belowupstrbarriers_slopeclass30_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_belowupstrbarriers_slopeclass30_km IS 'Total upstream length of stream < 30% gradient accessible to West Slope Cutthroat Trout, downstream of any anthropogenic barrier (km)';


--
-- Name: COLUMN crossings_vw.bt_spawning_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_spawning_km IS 'Upstream length of modelled/observed Bull Trout spawning';


--
-- Name: COLUMN crossings_vw.bt_rearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_rearing_km IS 'Upstream length of modelled/observed Bull Trout rearing';


--
-- Name: COLUMN crossings_vw.bt_spawningrearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_spawningrearing_km IS 'Upstream length of modelled/observed Bull Trout spawning and/or rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.bt_spawning_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Bull Trout spawning, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.bt_rearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.bt_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Bull Trout rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.ch_spawning_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_spawning_km IS 'Upstream length of modelled/observed Chinook spawning';


--
-- Name: COLUMN crossings_vw.ch_rearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_rearing_km IS 'Upstream length of modelled/observed Chinook rearing';


--
-- Name: COLUMN crossings_vw.ch_spawningrearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_spawningrearing_km IS 'Upstream length of modelled/observed Chinook spawning and/or rearing';


--
-- Name: COLUMN crossings_vw.ch_spawning_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Chinook spawning, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.ch_rearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Chinook rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.ch_spawningrearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.ch_spawningrearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Chinook spawning and/or rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.cm_spawning_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.cm_spawning_km IS 'Upstream length of modelled/observed Chum spawning';


--
-- Name: COLUMN crossings_vw.cm_spawning_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.cm_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Chum spawning, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.co_spawning_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.co_spawning_km IS 'Upstream length of modelled/observed Coho spawning';


--
-- Name: COLUMN crossings_vw.co_rearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.co_rearing_km IS 'Upstream length of modelled/observed Coho rearing';


--
-- Name: COLUMN crossings_vw.co_rearing_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.co_rearing_ha IS 'Upstream area (wetlands) of modelled/observed Coho rearing';


--
-- Name: COLUMN crossings_vw.co_spawningrearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.co_spawningrearing_km IS 'Upstream length of modelled/observed Coho spawning and/or rearing';


--
-- Name: COLUMN crossings_vw.co_spawning_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.co_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Coho spawning, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.co_rearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.co_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Coho rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.co_rearing_belowupstrbarriers_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.co_rearing_belowupstrbarriers_ha IS 'Upstream area (wetlands) of modelled/observed Coho rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.co_spawningrearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.co_spawningrearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Coho spawning and/or rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.pk_spawning_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.pk_spawning_km IS 'Upstream length of modelled/observed Pink spawning';


--
-- Name: COLUMN crossings_vw.pk_spawning_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.pk_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Pink spawning, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.sk_spawning_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.sk_spawning_km IS 'Upstream length of modelled/observed Sockeye spawning';


--
-- Name: COLUMN crossings_vw.sk_rearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.sk_rearing_km IS 'Upstream length of modelled/observed Sockeye rearing';


--
-- Name: COLUMN crossings_vw.sk_rearing_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.sk_rearing_ha IS 'Upstream area (lakes) of modelled/observed Sockeye rearing';


--
-- Name: COLUMN crossings_vw.sk_spawningrearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.sk_spawningrearing_km IS 'Upstream length of modelled/observed Sockeye spawning and/or rearing';


--
-- Name: COLUMN crossings_vw.sk_spawning_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.sk_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Sockeye spawning';


--
-- Name: COLUMN crossings_vw.sk_rearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.sk_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Sockeye rearing';


--
-- Name: COLUMN crossings_vw.sk_rearing_belowupstrbarriers_ha; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.sk_rearing_belowupstrbarriers_ha IS 'Upstream area (lakes) of modelled/observed Sockeye rearing';


--
-- Name: COLUMN crossings_vw.st_spawning_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_spawning_km IS 'Upstream length of modelled/observed Steelhead spawning';


--
-- Name: COLUMN crossings_vw.st_rearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_rearing_km IS 'Upstream length of modelled/observed Steelhead rearing';


--
-- Name: COLUMN crossings_vw.st_spawningrearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_spawningrearing_km IS 'Upstream length of modelled/observed Steelhead spawning and/or rearing';


--
-- Name: COLUMN crossings_vw.st_spawning_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed Steelhead spawning, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.st_rearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Steelhead rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.st_spawningrearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.st_spawningrearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Steelhead spawning and/or rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.salmon_spawningrearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.salmon_spawningrearing_km IS 'Upstream length of modelled/observed Salmon spawning and/or rearing';


--
-- Name: COLUMN crossings_vw.salmon_spawningrearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.salmon_spawningrearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Salmon spawning and/or rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.salmonsteelhead_spawningrearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.salmonsteelhead_spawningrearing_km IS 'Upstream length of modelled/observed Salmon and/or Steelhead spawning and/or rearing';


--
-- Name: COLUMN crossings_vw.salmonsteelhead_spawningrearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.salmonsteelhead_spawningrearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed Salmon and/or Steelhead spawning and/or rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.wct_spawning_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_spawning_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout spawning';


--
-- Name: COLUMN crossings_vw.wct_rearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_rearing_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout rearing';


--
-- Name: COLUMN crossings_vw.wct_spawningrearing_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_spawningrearing_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout spawning and/or rearing';


--
-- Name: COLUMN crossings_vw.wct_spawning_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_spawning_belowupstrbarriers_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout spawning, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.wct_rearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_rearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.wct_spawningrearing_belowupstrbarriers_km; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.wct_spawningrearing_belowupstrbarriers_km IS 'Upstream length of modelled/observed West Slope Cutthroat Trout spawning and/or rearing, downstream of any anthropogenic barriers';


--
-- Name: COLUMN crossings_vw.geom; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.crossings_vw.geom IS 'The point geometry associated with the feature';


--
-- Name: wcrp_ranked_barriers; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.wcrp_ranked_barriers (
    aggregated_crossings_id text NOT NULL,
    set_id numeric,
    total_hab_gain_set numeric,
    num_barriers_set integer,
    avg_gain_per_barrier numeric,
    dnstr_set_ids character varying[],
    rank_avg_gain_per_barrier numeric,
    rank_avg_gain_tiered numeric,
    rank_total_upstr_hab numeric,
    rank_combined numeric,
    tier_combined character varying
);


--
-- Name: wcrp_watersheds; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.wcrp_watersheds (
    watershed_group_code character varying(4),
    ch boolean,
    cm boolean,
    co boolean,
    pk boolean,
    sk boolean,
    st boolean,
    wct boolean,
    notes text,
    wcrp character varying(32),
    bt boolean
);


--
-- Name: crossings_wcrp_vw; Type: MATERIALIZED VIEW; Schema: bcfishpass; Owner: -
--

CREATE MATERIALIZED VIEW bcfishpass.crossings_wcrp_vw AS
 WITH upstr_wcrp_barriers AS MATERIALIZED (
         SELECT DISTINCT ba.aggregated_crossings_id,
            h_1.aggregated_crossings_id AS upstr_barriers,
            h_1.all_spawningrearing_km
           FROM (bcfishpass.crossings_upstr_barriers_anthropogenic ba
             JOIN bcfishpass.crossings_upstream_habitat_wcrp h_1 ON ((h_1.aggregated_crossings_id = ANY (ba.features_upstr))))
          WHERE (h_1.all_spawningrearing_km > (0)::double precision)
          ORDER BY ba.aggregated_crossings_id, h_1.aggregated_crossings_id
        ), upstr_wcrp_barriers_list AS (
         SELECT upstr_wcrp_barriers.aggregated_crossings_id,
            array_to_string(array_agg(upstr_wcrp_barriers.upstr_barriers), ';'::text) AS barriers_anthropogenic_habitat_wcrp_upstr,
            COALESCE(array_length(array_agg(upstr_wcrp_barriers.upstr_barriers), 1), 0) AS barriers_anthropogenic_habitat_wcrp_upstr_count
           FROM upstr_wcrp_barriers
          GROUP BY upstr_wcrp_barriers.aggregated_crossings_id
          ORDER BY upstr_wcrp_barriers.aggregated_crossings_id
        )
 SELECT DISTINCT ON (c.aggregated_crossings_id) c.aggregated_crossings_id,
    c.modelled_crossing_id,
    c.crossing_source,
    c.crossing_feature_type,
    c.pscis_status,
    c.crossing_type_code,
    c.crossing_subtype_code,
    c.barrier_status,
    c.pscis_road_name,
    c.pscis_stream_name,
    c.pscis_assessment_comment,
    c.pscis_assessment_date,
    c.transport_line_structured_name_1,
    c.rail_track_name,
    c.dam_name,
    c.dam_height,
    c.dam_owner,
    c.dam_use,
    c.dam_operating_status,
    c.utm_zone,
    c.utm_easting,
    c.utm_northing,
    c.blue_line_key,
    c.downstream_route_measure,
    c.wscode_ltree AS wscode,
    c.localcode_ltree AS localcode,
    c.watershed_group_code,
    c.gnis_stream_name,
    array_to_string(ad.features_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    COALESCE(array_length(ad.features_dnstr, 1), 0) AS barriers_anthropogenic_dnstr_count,
    uwbl.barriers_anthropogenic_habitat_wcrp_upstr,
    uwbl.barriers_anthropogenic_habitat_wcrp_upstr_count,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    array_to_string(a.barriers_st_dnstr, ';'::text) AS barriers_st_dnstr,
    array_to_string(a.barriers_wct_dnstr, ';'::text) AS barriers_wct_dnstr,
    h.ch_spawning_km,
    h.ch_rearing_km,
    h.ch_spawningrearing_km,
    h.ch_spawning_belowupstrbarriers_km,
    h.ch_rearing_belowupstrbarriers_km,
    h.ch_spawningrearing_belowupstrbarriers_km,
    h.cm_spawning_km,
    h.cm_spawning_belowupstrbarriers_km,
    h.co_spawning_km,
    h_wcrp.co_rearing_km,
    h_wcrp.co_spawningrearing_km,
    h.co_rearing_ha,
    h.co_spawning_belowupstrbarriers_km,
    h_wcrp.co_rearing_belowupstrbarriers_km,
    h_wcrp.co_spawningrearing_belowupstrbarriers_km,
    h.co_rearing_belowupstrbarriers_ha,
    h.pk_spawning_km,
    h.pk_spawning_belowupstrbarriers_km,
    h.sk_spawning_km,
    h_wcrp.sk_rearing_km,
    h_wcrp.sk_spawningrearing_km,
    h.sk_rearing_ha,
    h.sk_spawning_belowupstrbarriers_km,
    h_wcrp.sk_rearing_belowupstrbarriers_km,
    h_wcrp.sk_spawningrearing_belowupstrbarriers_km,
    h.sk_rearing_belowupstrbarriers_ha,
    h.st_spawning_km,
    h.st_rearing_km,
    h.st_spawningrearing_km,
    h.st_spawning_belowupstrbarriers_km,
    h.st_rearing_belowupstrbarriers_km,
    h.st_spawningrearing_belowupstrbarriers_km,
    h.wct_spawning_km,
    h.wct_rearing_km,
    h.wct_spawningrearing_km,
    h.wct_spawning_belowupstrbarriers_km,
    h.wct_rearing_belowupstrbarriers_km,
    h.wct_spawningrearing_belowupstrbarriers_km,
    h_wcrp.all_spawning_km,
    h_wcrp.all_spawning_belowupstrbarriers_km,
    h_wcrp.all_rearing_km,
    h_wcrp.all_rearing_belowupstrbarriers_km,
    h_wcrp.all_spawningrearing_km,
    h_wcrp.all_spawningrearing_belowupstrbarriers_km,
    r.set_id,
    r.total_hab_gain_set,
    r.num_barriers_set,
    r.avg_gain_per_barrier,
    r.dnstr_set_ids,
    r.rank_avg_gain_per_barrier,
    r.rank_avg_gain_tiered,
    r.rank_total_upstr_hab,
    r.rank_combined,
    r.tier_combined,
    c.geom
   FROM (((((((((((((bcfishpass.crossings c
     JOIN bcfishpass.wcrp_watersheds w ON ((c.watershed_group_code = (w.watershed_group_code)::text)))
     LEFT JOIN bcfishpass.crossings_dnstr_observations cdo ON ((c.aggregated_crossings_id = cdo.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstr_observations cuo ON ((c.aggregated_crossings_id = cuo.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_dnstr_crossings cd ON ((c.aggregated_crossings_id = cd.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_dnstr_barriers_anthropogenic ad ON ((c.aggregated_crossings_id = ad.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstr_barriers_anthropogenic au ON ((c.aggregated_crossings_id = au.aggregated_crossings_id)))
     LEFT JOIN upstr_wcrp_barriers_list uwbl ON ((c.aggregated_crossings_id = uwbl.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstream_access a ON ((c.aggregated_crossings_id = a.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstream_habitat h ON ((c.aggregated_crossings_id = h.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.crossings_upstream_habitat_wcrp h_wcrp ON ((c.aggregated_crossings_id = h_wcrp.aggregated_crossings_id)))
     LEFT JOIN bcfishpass.streams s ON ((c.linear_feature_id = s.linear_feature_id)))
     LEFT JOIN whse_basemapping.dbm_mof_50k_grid t ON (public.st_intersects(c.geom, t.geom)))
     LEFT JOIN bcfishpass.wcrp_ranked_barriers r ON ((c.aggregated_crossings_id = r.aggregated_crossings_id)))
  WHERE (COALESCE(c.stream_crossing_id, 0) <> ALL (ARRAY[199427, 197789, 197838, 197861, 197805, 125961, 199428]))
  ORDER BY c.aggregated_crossings_id, s.downstream_route_measure
  WITH NO DATA;


--
-- Name: dams; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.dams (
    dam_id text NOT NULL,
    linear_feature_id bigint,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    distance_to_stream double precision,
    watershed_group_code character varying(4),
    dam_name_en text,
    height_m double precision,
    owner text,
    dam_use text,
    operating_status text,
    passability_status_code integer,
    geom public.geometry(Point,3005)
);


--
-- Name: dams_not_matched_to_streams; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.dams_not_matched_to_streams AS
 SELECT a.cabd_id,
    a.dam_name_en
   FROM (cabd.dams a
     LEFT JOIN bcfishpass.dams b ON ((a.cabd_id = b.dam_id)))
  WHERE (b.dam_id IS NULL)
  ORDER BY a.cabd_id;


--
-- Name: dams_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.dams_vw AS
 SELECT dam_id,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    distance_to_stream,
    watershed_group_code,
    dam_name_en,
    height_m,
    owner,
    dam_use,
    operating_status,
    passability_status_code,
    geom
   FROM bcfishpass.dams;


--
-- Name: db_version; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.db_version (
    tag text NOT NULL,
    applied_at timestamp without time zone NOT NULL
);


--
-- Name: dfo_known_sockeye_lakes; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.dfo_known_sockeye_lakes (
    waterbody_poly_id integer NOT NULL
);


--
-- Name: falls; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.falls (
    falls_id text NOT NULL,
    linear_feature_id bigint,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    distance_to_stream double precision,
    watershed_group_code character varying(4),
    falls_name text,
    height_m double precision,
    barrier_ind boolean,
    geom public.geometry(Point,3005)
);


--
-- Name: falls_not_matched_to_streams; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.falls_not_matched_to_streams AS
 SELECT a.cabd_id,
    a.fall_name_en
   FROM (cabd.waterfalls a
     LEFT JOIN bcfishpass.falls b ON ((a.cabd_id = b.falls_id)))
  WHERE (b.falls_id IS NULL)
  ORDER BY a.cabd_id;


--
-- Name: falls_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.falls_vw AS
 SELECT falls_id,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    distance_to_stream,
    watershed_group_code,
    falls_name,
    height_m,
    barrier_ind,
    geom
   FROM bcfishpass.falls;


--
-- Name: fptwg_summary_roads_vw; Type: MATERIALIZED VIEW; Schema: bcfishpass; Owner: -
--

CREATE MATERIALIZED VIEW bcfishpass.fptwg_summary_roads_vw AS
 WITH roads AS (
         SELECT w.watershed_feature_id,
                CASE
                    WHEN ((c.description)::text = ANY ((ARRAY['Road alleyway'::character varying, 'Road arterial major'::character varying, 'Road arterial minor'::character varying, 'Road collector major'::character varying, 'Road collector minor'::character varying, 'Road freeway'::character varying, 'Road highway major'::character varying, 'Road highway minor'::character varying, 'Road lane'::character varying, 'Road local'::character varying, 'Private driveway demographic'::character varying, 'Road pedestrian mall'::character varying, 'Road runway non-demographic'::character varying, 'Road recreation demographic'::character varying, 'Road ramp'::character varying, 'Road restricted'::character varying, 'Road strata'::character varying, 'Road service'::character varying, 'Road yield lane'::character varying])::text[])) THEN 'ROAD, DEMOGRAPHIC'::text
                    WHEN (upper((c.description)::text) ~~ 'TRAIL%'::text) THEN 'TRAIL'::text
                    WHEN (c.description IS NOT NULL) THEN 'ROAD, RESOURCE/OTHER'::text
                    ELSE NULL::text
                END AS road_type,
                CASE
                    WHEN public.st_coveredby(r.geom, w.geom) THEN r.geom
                    ELSE public.st_intersection(r.geom, w.geom)
                END AS geom
           FROM ((whse_basemapping.fwa_assessment_watersheds_poly w
             JOIN whse_basemapping.transport_line r ON (public.st_intersects(w.geom, r.geom)))
             JOIN whse_basemapping.transport_line_type_code c ON (((r.transport_line_type_code)::text = (c.transport_line_type_code)::text)))
          WHERE (((r.transport_line_type_code)::text <> ALL ((ARRAY['F'::character varying, 'FP'::character varying, 'FR'::character varying, 'T'::character varying, 'TR'::character varying, 'TS'::character varying, 'RP'::character varying, 'RWA'::character varying])::text[])) AND ((r.transport_line_surface_code)::text <> 'D'::text) AND ((COALESCE(r.transport_line_structure_code, ''::character varying))::text <> 'T'::text))
        UNION ALL
         SELECT w.watershed_feature_id,
            'RAIL'::text AS road_type,
                CASE
                    WHEN public.st_coveredby(r.geom, w.geom) THEN r.geom
                    ELSE public.st_intersection(r.geom, w.geom)
                END AS geom
           FROM (whse_basemapping.fwa_assessment_watersheds_poly w
             JOIN whse_basemapping.gba_railway_tracks_sp r ON (public.st_intersects(w.geom, r.geom)))
          WHERE ((r.track_classification)::text <> ALL ((ARRAY['Ferry Route'::character varying, 'Yard'::character varying, 'Siding'::character varying])::text[]))
        )
 SELECT watershed_feature_id,
    sum(public.st_length(geom)) FILTER (WHERE (road_type = 'RAIL'::text)) AS length_rail,
    sum(public.st_length(geom)) FILTER (WHERE (road_type = 'ROAD, RESOURCE/OTHER'::text)) AS length_resourceroad,
    sum(public.st_length(geom)) FILTER (WHERE (road_type = 'ROAD, DEMOGRAPHIC'::text)) AS length_demographicroad,
    sum(public.st_length(geom)) FILTER (WHERE (road_type = 'TRAIL'::text)) AS length_trail
   FROM roads
  WHERE (public.st_dimension(geom) = 1)
  GROUP BY watershed_feature_id
  WITH NO DATA;


--
-- Name: streams_access; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams_access (
    segmented_stream_id text NOT NULL,
    barriers_anthropogenic_dnstr text[],
    barriers_pscis_dnstr text[],
    barriers_dams_dnstr text[],
    barriers_dams_hydro_dnstr text[],
    barriers_bt_dnstr text[],
    barriers_ch_cm_co_pk_sk_dnstr text[],
    barriers_ct_dv_rb_dnstr text[],
    barriers_st_dnstr text[],
    barriers_wct_dnstr text[],
    access_bt integer,
    access_ch integer,
    access_cm integer,
    access_co integer,
    access_pk integer,
    access_sk integer,
    access_salmon integer,
    access_ct_dv_rb integer,
    access_st integer,
    access_wct integer,
    observation_key_upstr text[],
    obsrvtn_species_codes_upstr text[],
    species_codes_dnstr text[],
    crossings_dnstr text[],
    remediated_dnstr_ind boolean,
    dam_dnstr_ind boolean,
    dam_hydro_dnstr_ind boolean
);


--
-- Name: streams_habitat_linear; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams_habitat_linear (
    segmented_stream_id text NOT NULL,
    spawning_bt integer,
    spawning_ch integer,
    spawning_cm integer,
    spawning_co integer,
    spawning_pk integer,
    spawning_sk integer,
    spawning_st integer,
    spawning_wct integer,
    rearing_bt integer,
    rearing_ch integer,
    rearing_co integer,
    rearing_sk integer,
    rearing_st integer,
    rearing_wct integer
);


--
-- Name: freshwater_fish_habitat_accessibility_model_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.freshwater_fish_habitat_accessibility_model_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.downstream_route_measure,
    s.upstream_route_measure,
    s.watershed_group_code,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.feature_code,
        CASE
            WHEN (a.access_salmon = 2) THEN 'OBSERVED'::text
            WHEN (a.access_salmon = 1) THEN 'INFERRED'::text
            WHEN (a.access_salmon = 0) THEN 'NATURAL_BARRIER'::text
            ELSE NULL::text
        END AS model_access_salmon,
        CASE
            WHEN (a.access_st = 2) THEN 'OBSERVED'::text
            WHEN (a.access_st = 1) THEN 'INFERRED'::text
            WHEN (a.access_st = 0) THEN 'NATURAL_BARRIER'::text
            ELSE NULL::text
        END AS model_access_steelhead,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    array_to_string(a.barriers_st_dnstr, ';'::text) AS barriers_st_dnstr,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    s.geom
   FROM ((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)));


--
-- Name: fwa_assessment_watersheds_waterbodies_vw; Type: MATERIALIZED VIEW; Schema: bcfishpass; Owner: -
--

CREATE MATERIALIZED VIEW bcfishpass.fwa_assessment_watersheds_waterbodies_vw AS
 WITH lakes AS (
         SELECT w_1.watershed_feature_id,
            wb.waterbody_poly_id,
                CASE
                    WHEN public.st_coveredby(wb.geom, w_1.geom) THEN wb.geom
                    ELSE public.st_intersection(wb.geom, w_1.geom)
                END AS geom
           FROM (whse_basemapping.fwa_assessment_watersheds_poly w_1
             JOIN whse_basemapping.fwa_lakes_poly wb ON ((public.st_intersects(w_1.geom, wb.geom) AND ((w_1.watershed_group_code)::text = (wb.watershed_group_code)::text))))
        ), reservoirs AS (
         SELECT w_1.watershed_feature_id,
            wb.waterbody_poly_id,
                CASE
                    WHEN public.st_coveredby(wb.geom, w_1.geom) THEN wb.geom
                    ELSE public.st_intersection(wb.geom, w_1.geom)
                END AS geom
           FROM (whse_basemapping.fwa_assessment_watersheds_poly w_1
             JOIN whse_basemapping.fwa_manmade_waterbodies_poly wb ON ((public.st_intersects(w_1.geom, wb.geom) AND ((w_1.watershed_group_code)::text = (wb.watershed_group_code)::text))))
        ), wetlands AS (
         SELECT w_1.watershed_feature_id,
            wb.waterbody_poly_id,
                CASE
                    WHEN public.st_coveredby(wb.geom, w_1.geom) THEN wb.geom
                    ELSE public.st_intersection(wb.geom, w_1.geom)
                END AS geom
           FROM (whse_basemapping.fwa_assessment_watersheds_poly w_1
             JOIN whse_basemapping.fwa_manmade_waterbodies_poly wb ON ((public.st_intersects(w_1.geom, wb.geom) AND ((w_1.watershed_group_code)::text = (wb.watershed_group_code)::text))))
        )
 SELECT a.watershed_feature_id,
    count(DISTINCT l.waterbody_poly_id) AS n_lakes,
    round(((sum(public.st_area(l.geom)) / (10000)::double precision))::numeric, 2) AS area_lakes,
    count(DISTINCT m.waterbody_poly_id) AS n_manmade_waterbodies,
    round(((sum(public.st_area(m.geom)) / (10000)::double precision))::numeric, 2) AS area_manmade_waterbodies,
    count(DISTINCT w.waterbody_poly_id) AS n_wetlands,
    round(((sum(public.st_area(w.geom)) / (10000)::double precision))::numeric, 2) AS area_wetlands
   FROM (((whse_basemapping.fwa_assessment_watersheds_poly a
     LEFT JOIN lakes l ON ((a.watershed_feature_id = l.watershed_feature_id)))
     LEFT JOIN reservoirs m ON ((a.watershed_feature_id = m.watershed_feature_id)))
     LEFT JOIN wetlands w ON ((a.watershed_feature_id = w.watershed_feature_id)))
  GROUP BY a.watershed_feature_id
  ORDER BY a.watershed_feature_id
  WITH NO DATA;


--
-- Name: gradient_barriers; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.gradient_barriers (
    gradient_barrier_id bigint GENERATED ALWAYS AS (((((((blue_line_key)::bigint + 1) - 354087611) * 10000000))::double precision + round(((downstream_route_measure)::bigint)::double precision))) STORED NOT NULL,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    gradient_class integer
);


--
-- Name: habitat_linear_bt; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.habitat_linear_bt (
    segmented_stream_id text NOT NULL,
    spawning boolean,
    rearing boolean
);


--
-- Name: habitat_linear_ch; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.habitat_linear_ch (
    segmented_stream_id text NOT NULL,
    spawning boolean,
    rearing boolean
);


--
-- Name: habitat_linear_cm; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.habitat_linear_cm (
    segmented_stream_id text NOT NULL,
    spawning boolean
);


--
-- Name: habitat_linear_co; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.habitat_linear_co (
    segmented_stream_id text NOT NULL,
    spawning boolean,
    rearing boolean
);


--
-- Name: habitat_linear_pk; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.habitat_linear_pk (
    segmented_stream_id text NOT NULL,
    spawning boolean
);


--
-- Name: habitat_linear_sk; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.habitat_linear_sk (
    segmented_stream_id text NOT NULL,
    spawning boolean,
    rearing boolean
);


--
-- Name: habitat_linear_st; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.habitat_linear_st (
    segmented_stream_id text NOT NULL,
    spawning boolean,
    rearing boolean
);


--
-- Name: habitat_linear_wct; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.habitat_linear_wct (
    segmented_stream_id text NOT NULL,
    spawning boolean,
    rearing boolean
);


--
-- Name: log_model_run_id_seq; Type: SEQUENCE; Schema: bcfishpass; Owner: -
--

CREATE SEQUENCE bcfishpass.log_model_run_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_model_run_id_seq; Type: SEQUENCE OWNED BY; Schema: bcfishpass; Owner: -
--

ALTER SEQUENCE bcfishpass.log_model_run_id_seq OWNED BY bcfishpass.log.model_run_id;


--
-- Name: log_objectstorage; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.log_objectstorage (
    model_run_id integer NOT NULL,
    object_name text NOT NULL,
    version_id text,
    etag text
);


--
-- Name: log_parameters_habitat_method; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.log_parameters_habitat_method (
    model_run_id integer,
    watershed_group_code character varying(4),
    model text
);


--
-- Name: log_parameters_habitat_thresholds; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.log_parameters_habitat_thresholds (
    model_run_id integer,
    species_code text,
    spawn_gradient_max numeric,
    spawn_channel_width_min numeric,
    spawn_channel_width_max numeric,
    spawn_mad_min numeric,
    spawn_mad_max numeric,
    rear_gradient_max numeric,
    rear_channel_width_min numeric,
    rear_channel_width_max numeric,
    rear_mad_min numeric,
    rear_mad_max numeric,
    rear_lake_ha_min integer
);


--
-- Name: log_replication; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.log_replication (
    object_name text NOT NULL,
    version_id text,
    etag text,
    replication_timestamp timestamp without time zone
);


--
-- Name: log_wsg_crossing_summary; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.log_wsg_crossing_summary (
    model_run_id integer,
    watershed_group_code text,
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


--
-- Name: log_wsg_linear_summary; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.log_wsg_linear_summary (
    model_run_id integer,
    watershed_group_code text,
    length_total numeric,
    length_potentiallyaccessible_bt numeric,
    length_potentiallyaccessible_bt_observed numeric,
    length_potentiallyaccessible_bt_accessible_a numeric,
    length_potentiallyaccessible_bt_accessible_b numeric,
    length_obsrvd_spawning_rearing_bt numeric,
    length_obsrvd_spawning_rearing_bt_accessible_a numeric,
    length_obsrvd_spawning_rearing_bt_accessible_b numeric,
    length_spawning_rearing_bt numeric,
    length_spawning_rearing_bt_accessible_a numeric,
    length_spawning_rearing_bt_accessible_b numeric,
    length_potentiallyaccessible_ch_cm_co_pk_sk numeric,
    length_potentiallyaccessible_ch_cm_co_pk_sk_observed numeric,
    length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_a numeric,
    length_potentiallyaccessible_ch_cm_co_pk_sk_accessible_b numeric,
    length_obsrvd_spawning_rearing_ch numeric,
    length_obsrvd_spawning_rearing_ch_accessible_a numeric,
    length_obsrvd_spawning_rearing_ch_accessible_b numeric,
    length_spawning_rearing_ch numeric,
    length_spawning_rearing_ch_accessible_a numeric,
    length_spawning_rearing_ch_accessible_b numeric,
    length_obsrvd_spawning_rearing_cm numeric,
    length_obsrvd_spawning_rearing_cm_accessible_a numeric,
    length_obsrvd_spawning_rearing_cm_accessible_b numeric,
    length_spawning_rearing_cm numeric,
    length_spawning_rearing_cm_accessible_a numeric,
    length_spawning_rearing_cm_accessible_b numeric,
    length_obsrvd_spawning_rearing_co numeric,
    length_obsrvd_spawning_rearing_co_accessible_a numeric,
    length_obsrvd_spawning_rearing_co_accessible_b numeric,
    length_spawning_rearing_co numeric,
    length_spawning_rearing_co_accessible_a numeric,
    length_spawning_rearing_co_accessible_b numeric,
    length_obsrvd_spawning_rearing_pk numeric,
    length_obsrvd_spawning_rearing_pk_accessible_a numeric,
    length_obsrvd_spawning_rearing_pk_accessible_b numeric,
    length_spawning_rearing_pk numeric,
    length_spawning_rearing_pk_accessible_a numeric,
    length_spawning_rearing_pk_accessible_b numeric,
    length_obsrvd_spawning_rearing_sk numeric,
    length_obsrvd_spawning_rearing_sk_accessible_a numeric,
    length_obsrvd_spawning_rearing_sk_accessible_b numeric,
    length_spawning_rearing_sk numeric,
    length_spawning_rearing_sk_accessible_a numeric,
    length_spawning_rearing_sk_accessible_b numeric,
    length_potentiallyaccessible_st numeric,
    length_potentiallyaccessible_st_observed numeric,
    length_potentiallyaccessible_st_accessible_a numeric,
    length_potentiallyaccessible_st_accessible_b numeric,
    length_obsrvd_spawning_rearing_st numeric,
    length_obsrvd_spawning_rearing_st_accessible_a numeric,
    length_obsrvd_spawning_rearing_st_accessible_b numeric,
    length_spawning_rearing_st numeric,
    length_spawning_rearing_st_accessible_a numeric,
    length_spawning_rearing_st_accessible_b numeric,
    length_potentiallyaccessible_wct numeric,
    length_potentiallyaccessible_wct_observed numeric,
    length_potentiallyaccessible_wct_accessible_a numeric,
    length_potentiallyaccessible_wct_accessible_b numeric,
    length_obsrvd_spawning_rearing_wct numeric,
    length_obsrvd_spawning_rearing_wct_accessible_a numeric,
    length_obsrvd_spawning_rearing_wct_accessible_b numeric,
    length_spawning_rearing_wct numeric,
    length_spawning_rearing_wct_accessible_a numeric,
    length_spawning_rearing_wct_accessible_b numeric
);


--
-- Name: modelled_stream_crossings; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.modelled_stream_crossings (
    modelled_crossing_id integer NOT NULL,
    modelled_crossing_type character varying(5),
    modelled_crossing_type_source text[],
    transport_line_id integer,
    ften_road_section_lines_id integer,
    og_road_segment_permit_id integer,
    og_petrlm_dev_rd_pre06_pub_id integer,
    railway_track_id integer,
    linear_feature_id bigint,
    blue_line_key integer,
    downstream_route_measure double precision,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    watershed_group_code character varying(4),
    geom public.geometry(PointZM,3005)
);


--
-- Name: modelled_stream_crossings_modelled_crossing_id_seq; Type: SEQUENCE; Schema: bcfishpass; Owner: -
--

CREATE SEQUENCE bcfishpass.modelled_stream_crossings_modelled_crossing_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: modelled_stream_crossings_modelled_crossing_id_seq; Type: SEQUENCE OWNED BY; Schema: bcfishpass; Owner: -
--

ALTER SEQUENCE bcfishpass.modelled_stream_crossings_modelled_crossing_id_seq OWNED BY bcfishpass.modelled_stream_crossings.modelled_crossing_id;


--
-- Name: observation_exclusions; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.observation_exclusions (
    observation_key text NOT NULL,
    data_error boolean,
    release_exclude boolean,
    release_include boolean,
    reviewer_name text,
    review_date date,
    source_1 text,
    source_2 text,
    notes text
);


--
-- Name: TABLE observation_exclusions; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON TABLE bcfishpass.observation_exclusions IS 'Flag FISS observation points as data error; temporary/one time release/stocking/enhancement; ongoing release/stocking/enhancement';


--
-- Name: COLUMN observation_exclusions.observation_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observation_exclusions.observation_key IS 'bcfishobs created stable unique id, a hash of columns [source, species_code, observation_date, utm_zone, utm_easting, utm_northing, life_stage_code, activity_code]';


--
-- Name: COLUMN observation_exclusions.data_error; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observation_exclusions.data_error IS 'True if record contains a confirmed/conclusive data error, exclude it from bcfishpass (most commonly, point is in the wrong location)';


--
-- Name: COLUMN observation_exclusions.release_exclude; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observation_exclusions.release_exclude IS 'True if record is related to a limited/one time release/stocking/enhancement event, exclude from bcfishpass habitat modelling';


--
-- Name: COLUMN observation_exclusions.release_include; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observation_exclusions.release_include IS 'True if record is related to an ongoing release/stocking/enhancement program, include in bcfishpass habitat modelling but exclude from QA of barriers';


--
-- Name: COLUMN observation_exclusions.reviewer_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observation_exclusions.reviewer_name IS 'Initials of user submitting the review, eg SN';


--
-- Name: COLUMN observation_exclusions.review_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observation_exclusions.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';


--
-- Name: COLUMN observation_exclusions.source_1; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observation_exclusions.source_1 IS 'Description or link to the primary source(s) documenting the observation or related information';


--
-- Name: COLUMN observation_exclusions.source_2; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observation_exclusions.source_2 IS 'Description or link to the secondary source(s) documenting the observation or related information';


--
-- Name: COLUMN observation_exclusions.notes; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observation_exclusions.notes IS 'Reviewer notes on rationale for fix and/or how the source(s) were interpreted';


--
-- Name: observations; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.observations (
    observation_key text NOT NULL,
    fish_observation_point_id numeric,
    wbody_id numeric,
    species_code character varying(6),
    agency_id numeric,
    point_type_code character varying(20),
    observation_date date,
    agency_name character varying(60),
    source character varying(1000),
    source_ref character varying(4000),
    utm_zone integer,
    utm_easting integer,
    utm_northing integer,
    activity_code character varying(100),
    activity character varying(300),
    life_stage_code character varying(100),
    life_stage character varying(300),
    species_name character varying(60),
    waterbody_identifier character varying(9),
    waterbody_type character varying(20),
    gazetted_name character varying(30),
    new_watershed_code character varying(56),
    trimmed_watershed_code character varying(56),
    acat_report_url character varying(254),
    feature_code character varying(10),
    linear_feature_id bigint,
    wscode public.ltree,
    localcode public.ltree,
    blue_line_key integer,
    watershed_group_code character varying(4),
    downstream_route_measure double precision,
    match_type text,
    distance_to_stream double precision,
    geom public.geometry(PointZ,3005),
    release boolean
);


--
-- Name: COLUMN observations.observation_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.observation_key IS 'Stable unique id, a hash of columns [source, species_code, observation_date, utm_zone, utm_easting, utm_northing, life_stage_code, activity_code]';


--
-- Name: COLUMN observations.fish_observation_point_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.fish_observation_point_id IS 'Source observation primary key (unstable)';


--
-- Name: COLUMN observations.wbody_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.wbody_id IS 'WBODY ID is a foreign key to WDIC_WATERBODIES.';


--
-- Name: COLUMN observations.species_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.species_code IS 'BC fish species code, see https://raw.githubusercontent.com/smnorris/fishbc/master/data-raw/whse_fish_species_cd/whse_fish_species_cd.csv';


--
-- Name: COLUMN observations.agency_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.agency_id IS 'AGENCY ID is a foreign key to AGENCIES.';


--
-- Name: COLUMN observations.point_type_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.point_type_code IS 'POINT TYPE CODE indicates if the row represents a direct Observation or a Summary of direct observations.';


--
-- Name: COLUMN observations.observation_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.observation_date IS 'The date on which the observation occurred.';


--
-- Name: COLUMN observations.agency_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.agency_name IS 'The name of the agency that made the observation.';


--
-- Name: COLUMN observations.source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.source IS 'The abbreviation, and if appropriate, the primary key, of the dataset(s) from which the data was obtained. For example: FDIS Database: fshclctn_id 66589';


--
-- Name: COLUMN observations.source_ref; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.source_ref IS 'The concatenation of all biographical references for the source data.  This may include citations to reports that published the observations, or the name of a project under which the observations were made. Some example values for SOURCE REF are: A RECONNAISSANCE SURVEY OF CULTUS LAKE, and Bonaparte Watershed Fish and Fish Habitat Inventory - 2000';


--
-- Name: COLUMN observations.utm_zone; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.utm_zone IS 'UTM ZONE is the 2 digit numeric code identifying the UTM Zone in which the UTM EASTING and UTM NORTHING lie.';


--
-- Name: COLUMN observations.utm_easting; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.utm_easting IS 'UTM EASTING is the UTM Easting value within the specified UTM ZONE for this observation point.';


--
-- Name: COLUMN observations.utm_northing; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.utm_northing IS 'UTM NORTHING is the UTM Northing value within the specified UTM ZONE for this observation point.';


--
-- Name: COLUMN observations.activity_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.activity_code IS 'ACTIVITY CODE contains the fish activity code from the source dataset, such as I for Incubating, or SPE for Spawning In Estuary.';


--
-- Name: COLUMN observations.activity; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.activity IS 'ACTIVITY is a full textual description of the activity the fish was engaged in when it was observed, such as SPAWNING.';


--
-- Name: COLUMN observations.life_stage_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.life_stage_code IS 'LIFE STAGE CODE is a short character code identiying the life stage of the fish species for this oberservation.  Each source dataset of observations uses its own set of LIFE STAGE CODES.  For example, in the FDIS dataset, U means Undetermined, NS means Not Specified, M means Mature, IM means Immature, and MT means Maturing.  Descriptions for each LIFE STAGE CODE are given in the LIFE STAGE attribute.';


--
-- Name: COLUMN observations.life_stage; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.life_stage IS 'LIFE STAGE is the full textual description corresponding to the LIFE STAGE CODE';


--
-- Name: COLUMN observations.species_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.species_name IS 'SPECIES NAME is the common name of the fish SPECIES that was observed.';


--
-- Name: COLUMN observations.waterbody_identifier; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.waterbody_identifier IS 'WATERBODY IDENTIFIER is a unique code identifying the waterbody in which the observation was made. It is a 5-digit seqnce number followed by a 4-character watershed group code.';


--
-- Name: COLUMN observations.waterbody_type; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.waterbody_type IS 'WATERBODY TYPE is a the type of waterbody in which the observation was made. For example, Stream or Lake.';


--
-- Name: COLUMN observations.gazetted_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.gazetted_name IS 'GAZETTED NAME is the gazetted name of the waterbody in which the observation was made.';


--
-- Name: COLUMN observations.new_watershed_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.new_watershed_code IS 'NEW WATERSHED CODE is a watershed code, formatted with dashes, as assigned in the Watershed Atlas. For example: 900-569800-08600-00000-0000-0000-000-000-000-000-000-000.';


--
-- Name: COLUMN observations.trimmed_watershed_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.trimmed_watershed_code IS 'TRIMMED WATERSHED CODE is the NEW WATERSHED CODE, but with trailing zeros removed. For example, if the NEW WATERSHED CODE is 100-005200-43400-50000-0000-0000-000-000-000-000-000-000, then the TRIMMED WATERSHED CODE will be 100-005200-43400-50000.';


--
-- Name: COLUMN observations.acat_report_url; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.acat_report_url IS 'ACAT REPORT URL is a URL to the ACAT REPORT which provides additional information about the FISS FISH OBSRVTN PNT SP.';


--
-- Name: COLUMN observations.feature_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.feature_code IS 'FEATURE CODE contains a value based on the Canadian Council of Surveys and Mappings (CCSM) system for classification of geographic features.';


--
-- Name: COLUMN observations.linear_feature_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.linear_feature_id IS 'See FWA documentation';


--
-- Name: COLUMN observations.wscode; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.wscode IS 'Truncated FWA fwa_watershed_code';


--
-- Name: COLUMN observations.localcode; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.localcode IS 'Truncated FWA local_watershed_code';


--
-- Name: COLUMN observations.blue_line_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.blue_line_key IS 'See FWA documentation';


--
-- Name: COLUMN observations.watershed_group_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.watershed_group_code IS 'See FWA documentation';


--
-- Name: COLUMN observations.downstream_route_measure; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.downstream_route_measure IS 'See FWA documentation';


--
-- Name: COLUMN observations.match_type; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.match_type IS 'Description of how the observation was matched to the stream';


--
-- Name: COLUMN observations.distance_to_stream; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.distance_to_stream IS 'Distance (m) from source observation to output point';


--
-- Name: COLUMN observations.geom; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.observations.geom IS 'Geometry of observation as snapped to the FWA stream network';


--
-- Name: observations_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.observations_vw AS
 SELECT observation_key,
    fish_observation_point_id,
    wbody_id,
    species_code,
    agency_id,
    point_type_code,
    observation_date,
    agency_name,
    source,
    source_ref,
    utm_zone,
    utm_easting,
    utm_northing,
    activity_code,
    activity,
    life_stage_code,
    life_stage,
    species_name,
    waterbody_identifier,
    waterbody_type,
    gazetted_name,
    new_watershed_code,
    trimmed_watershed_code,
    acat_report_url,
    feature_code,
    linear_feature_id,
    wscode,
    localcode,
    blue_line_key,
    watershed_group_code,
    downstream_route_measure,
    match_type,
    distance_to_stream,
    geom
   FROM bcfishpass.observations;


--
-- Name: parameters_habitat_method; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.parameters_habitat_method (
    watershed_group_code character varying(4),
    model text
);


--
-- Name: parameters_habitat_thresholds; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.parameters_habitat_thresholds (
    species_code text,
    spawn_gradient_max numeric,
    spawn_channel_width_min numeric,
    spawn_channel_width_max numeric,
    spawn_mad_min numeric,
    spawn_mad_max numeric,
    rear_gradient_max numeric,
    rear_channel_width_min numeric,
    rear_channel_width_max numeric,
    rear_mad_min numeric,
    rear_mad_max numeric,
    rear_lake_ha_min integer
);


--
-- Name: pscis; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.pscis (
    stream_crossing_id integer NOT NULL,
    modelled_crossing_id integer,
    pscis_status text,
    current_crossing_type_code character varying(10),
    current_crossing_subtype_code character varying(10),
    current_barrier_result_code text,
    distance_to_stream double precision,
    suspect_match character varying(17),
    linear_feature_id bigint,
    wscode_ltree public.ltree,
    localcode_ltree public.ltree,
    blue_line_key integer,
    downstream_route_measure double precision,
    watershed_group_code character varying(4),
    geom public.geometry(Point,3005)
);


--
-- Name: pscis_modelledcrossings_streams_xref; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.pscis_modelledcrossings_streams_xref (
    stream_crossing_id integer NOT NULL,
    modelled_crossing_id integer,
    linear_feature_id integer,
    watershed_group_code character varying(4),
    reviewer text,
    notes text
);


--
-- Name: pscis_not_matched_to_streams; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.pscis_not_matched_to_streams (
    stream_crossing_id integer NOT NULL,
    current_pscis_status text,
    current_barrier_result_code text,
    current_crossing_type_code text,
    current_crossing_subtype_code text,
    watershed_group_code text,
    geom public.geometry(Point)
);


--
-- Name: pscis_points_all; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.pscis_points_all (
    stream_crossing_id integer NOT NULL,
    current_pscis_status text,
    current_barrier_result_code text,
    current_crossing_type_code text,
    current_crossing_subtype_code text,
    geom public.geometry(Point,3005)
);


--
-- Name: pscis_points_duplicates; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.pscis_points_duplicates (
    stream_crossing_id integer,
    duplicate_10m boolean,
    duplicate_5m_instream boolean,
    watershed_group_code text
);


--
-- Name: pscis_streams_150m; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.pscis_streams_150m (
    id bigint,
    stream_crossing_id integer,
    modelled_crossing_id integer,
    linear_feature_id bigint,
    blue_line_key integer,
    downstream_route_measure double precision,
    watershed_group_code character varying(4),
    distance_to_stream double precision,
    gnis_name character varying(80),
    stream_name character varying(256),
    name_score integer,
    stream_order integer,
    downstream_channel_width numeric,
    width_order_score integer,
    crossing_type_code character varying(24),
    modelled_crossing_type character varying(5),
    modelled_xing_dist double precision,
    modelled_xing_dist_instream numeric,
    multiple_match_ind boolean
);


--
-- Name: qa_naturalbarriers_ch_cm_co_pk_sk_st; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.qa_naturalbarriers_ch_cm_co_pk_sk_st (
    barrier_id text NOT NULL,
    barrier_type text,
    watershed_group_code text,
    observations_upstr text,
    n_observations_upstr integer,
    n_ch_upstr integer,
    n_cm_upstr integer,
    n_co_upstr integer,
    n_pk_upstr integer,
    n_sk_upstr integer,
    n_st_upstr integer
);


--
-- Name: qa_observations_ch_cm_co_pk_sk_st; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.qa_observations_ch_cm_co_pk_sk_st (
    observation_key text NOT NULL,
    species_code character varying(6),
    observation_date date,
    activity_code character varying(100),
    activity character varying(300),
    life_stage_code character varying(100),
    life_stage character varying(300),
    acat_report_url character varying(254),
    agency_name character varying(60),
    source character varying(1000),
    source_ref character varying(4000),
    release boolean,
    watershed_group_code character varying(4),
    gradient_15_dnstr text,
    gradient_20_dnstr text,
    gradient_25_dnstr text,
    gradient_30_dnstr text,
    falls_dnstr text,
    subsurfaceflow_dnstr text,
    gradient_15_dnstr_count integer,
    gradient_20_dnstr_count integer,
    gradient_25_dnstr_count integer,
    gradient_30_dnstr_count integer,
    falls_dnstr_count integer,
    subsurfaceflow_dnstr_count integer
);


--
-- Name: streams_mapping_code; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams_mapping_code (
    segmented_stream_id text NOT NULL,
    mapping_code_bt text,
    mapping_code_ch text,
    mapping_code_cm text,
    mapping_code_co text,
    mapping_code_pk text,
    mapping_code_sk text,
    mapping_code_st text,
    mapping_code_wct text,
    mapping_code_salmon text
);


--
-- Name: streams_bt_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_bt_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_bt_dnstr, ';'::text) AS barriers_bt_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_bt AS access,
        CASE
            WHEN (a.access_bt = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_bt
        END AS spawning,
        CASE
            WHEN (a.access_bt = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_bt
        END AS rearing,
    m.mapping_code_bt AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_bt > 0);


--
-- Name: streams_ch_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_ch_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_ch AS access,
        CASE
            WHEN (a.access_ch = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_ch
        END AS spawning,
        CASE
            WHEN (a.access_ch = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_ch
        END AS rearing,
    m.mapping_code_ch AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_ch > 0);


--
-- Name: streams_cm_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_cm_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_cm AS access,
        CASE
            WHEN (a.access_cm = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_cm
        END AS spawning,
    m.mapping_code_cm AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_cm > 0);


--
-- Name: streams_co_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_co_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_co AS access,
        CASE
            WHEN (a.access_co = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_co
        END AS spawning,
        CASE
            WHEN (a.access_co = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_co
        END AS rearing,
    m.mapping_code_co AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_co > 0);


--
-- Name: streams_ct_dv_rb_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_ct_dv_rb_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_ct_dv_rb_dnstr, ';'::text) AS barriers_ct_dv_rb_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_ct_dv_rb AS access,
    NULL::text AS spawning,
    NULL::text AS rearing,
    NULL::text AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_ct_dv_rb > 0);


--
-- Name: streams_dnstr_barriers; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams_dnstr_barriers (
    segmented_stream_id text NOT NULL,
    barriers_anthropogenic_dnstr text[],
    barriers_pscis_dnstr text[],
    barriers_dams_dnstr text[],
    barriers_dams_hydro_dnstr text[],
    barriers_bt_dnstr text[],
    barriers_ct_dv_rb_dnstr text[],
    barriers_ch_cm_co_pk_sk_dnstr text[],
    barriers_st_dnstr text[],
    barriers_wct_dnstr text[]
);


--
-- Name: streams_dnstr_barriers_remediations; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams_dnstr_barriers_remediations (
    segmented_stream_id text NOT NULL,
    remediations_barriers_dnstr text[]
);


--
-- Name: streams_dnstr_crossings; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams_dnstr_crossings (
    segmented_stream_id text NOT NULL,
    crossings_dnstr text[]
);


--
-- Name: streams_dnstr_species; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams_dnstr_species (
    segmented_stream_id text NOT NULL,
    species_codes_dnstr text[]
);


--
-- Name: streams_habitat_known; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams_habitat_known (
    segmented_stream_id text NOT NULL,
    spawning_bt integer,
    spawning_ch integer,
    spawning_cm integer,
    spawning_co integer,
    spawning_pk integer,
    spawning_sk integer,
    spawning_st integer,
    spawning_wct integer,
    rearing_bt integer,
    rearing_ch integer,
    rearing_co integer,
    rearing_sk integer,
    rearing_st integer,
    rearing_wct integer
);


--
-- Name: streams_pk_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_pk_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_pk,
        CASE
            WHEN (a.access_pk = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_pk
        END AS spawning,
    m.mapping_code_pk AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_pk > 0);


--
-- Name: streams_salmon_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_salmon_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_salmon AS access,
    GREATEST(h.spawning_ch, h.spawning_cm, h.spawning_co, h.spawning_pk, h.spawning_sk) AS spawning,
    GREATEST(h.rearing_ch, h.rearing_co, h.rearing_sk) AS rearing,
    m.mapping_code_salmon AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_salmon > 0);


--
-- Name: streams_sk_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_sk_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_sk AS access,
        CASE
            WHEN (a.access_sk = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_sk
        END AS spawning,
        CASE
            WHEN (a.access_sk = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_sk
        END AS rearing,
    m.mapping_code_sk AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_sk > 0);


--
-- Name: streams_st_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_st_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_st_dnstr, ';'::text) AS barriers_st_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_st AS access,
        CASE
            WHEN (a.access_st = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_st
        END AS spawning,
        CASE
            WHEN (a.access_st = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_st
        END AS rearing,
    m.mapping_code_st AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_st > 0);


--
-- Name: streams_upstr_observations; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.streams_upstr_observations (
    segmented_stream_id text NOT NULL,
    observation_key_upstr text[],
    obsrvtn_species_codes_upstr text[]
);


--
-- Name: streams_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_bt_dnstr, ';'::text) AS barriers_bt_dnstr,
    array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';'::text) AS barriers_ch_cm_co_pk_sk_dnstr,
    array_to_string(a.barriers_ct_dv_rb_dnstr, ';'::text) AS barriers_ct_dv_rb_dnstr,
    array_to_string(a.barriers_st_dnstr, ';'::text) AS barriers_st_dnstr,
    array_to_string(a.barriers_wct_dnstr, ';'::text) AS barriers_wct_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_bt,
    a.access_ch,
    a.access_cm,
    a.access_co,
    a.access_pk,
    a.access_sk,
    a.access_st,
    a.access_wct,
    a.access_salmon,
        CASE
            WHEN (a.access_bt = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_bt
        END AS spawning_bt,
        CASE
            WHEN (a.access_ch = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_ch
        END AS spawning_ch,
        CASE
            WHEN (a.access_cm = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_cm
        END AS spawning_cm,
        CASE
            WHEN (a.access_co = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_co
        END AS spawning_co,
        CASE
            WHEN (a.access_pk = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_pk
        END AS spawning_pk,
        CASE
            WHEN (a.access_sk = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_sk
        END AS spawning_sk,
        CASE
            WHEN (a.access_st = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_st
        END AS spawning_st,
        CASE
            WHEN (a.access_wct = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_wct
        END AS spawning_wct,
        CASE
            WHEN (a.access_bt = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_bt
        END AS rearing_bt,
        CASE
            WHEN (a.access_ch = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_ch
        END AS rearing_ch,
        CASE
            WHEN (a.access_co = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_co
        END AS rearing_co,
        CASE
            WHEN (a.access_sk = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_sk
        END AS rearing_sk,
        CASE
            WHEN (a.access_st = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_st
        END AS rearing_st,
        CASE
            WHEN (a.access_wct = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_wct
        END AS rearing_wct,
    m.mapping_code_bt,
    m.mapping_code_ch,
    m.mapping_code_cm,
    m.mapping_code_co,
    m.mapping_code_pk,
    m.mapping_code_sk,
    m.mapping_code_st,
    m.mapping_code_wct,
    m.mapping_code_salmon,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)));


--
-- Name: streams_wct_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.streams_wct_vw AS
 SELECT s.segmented_stream_id,
    s.linear_feature_id,
    s.edge_type,
    s.blue_line_key,
    s.watershed_key,
    s.watershed_group_code,
    s.downstream_route_measure,
    s.length_metre,
    s.waterbody_key,
    s.wscode_ltree AS wscode,
    s.localcode_ltree AS localcode,
    s.gnis_name,
    s.stream_order,
    s.stream_magnitude,
    s.gradient,
    s.feature_code,
    s.upstream_route_measure,
    s.upstream_area_ha,
    s.stream_order_parent,
    s.stream_order_max,
    s.map_upstream,
    s.channel_width,
    s.mad_m3s,
    array_to_string(a.barriers_anthropogenic_dnstr, ';'::text) AS barriers_anthropogenic_dnstr,
    array_to_string(a.barriers_pscis_dnstr, ';'::text) AS barriers_pscis_dnstr,
    array_to_string(a.barriers_dams_dnstr, ';'::text) AS barriers_dams_dnstr,
    array_to_string(a.barriers_dams_hydro_dnstr, ';'::text) AS barriers_dams_hydro_dnstr,
    array_to_string(a.barriers_wct_dnstr, ';'::text) AS barriers_wct_dnstr,
    array_to_string(a.crossings_dnstr, ';'::text) AS crossings_dnstr,
    a.dam_dnstr_ind,
    a.dam_hydro_dnstr_ind,
    a.remediated_dnstr_ind,
    array_to_string(a.observation_key_upstr, ';'::text) AS observation_key_upstr,
    array_to_string(a.obsrvtn_species_codes_upstr, ';'::text) AS obsrvtn_species_codes_upstr,
    array_to_string(a.species_codes_dnstr, ';'::text) AS species_codes_dnstr,
    a.access_wct AS access,
        CASE
            WHEN (a.access_wct = '-9'::integer) THEN '-9'::integer
            ELSE h.spawning_wct
        END AS spawning,
        CASE
            WHEN (a.access_wct = '-9'::integer) THEN '-9'::integer
            ELSE h.rearing_wct
        END AS rearing,
    m.mapping_code_wct AS mapping_code,
    s.geom
   FROM (((bcfishpass.streams s
     LEFT JOIN bcfishpass.streams_access a ON ((s.segmented_stream_id = a.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_habitat_linear h ON ((s.segmented_stream_id = h.segmented_stream_id)))
     LEFT JOIN bcfishpass.streams_mapping_code m ON ((s.segmented_stream_id = m.segmented_stream_id)))
  WHERE (a.access_wct > 0);


--
-- Name: user_barriers_definite; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.user_barriers_definite (
    barrier_type text,
    barrier_name text,
    blue_line_key integer NOT NULL,
    downstream_route_measure double precision NOT NULL,
    watershed_group_code character varying(4),
    reviewer_name text,
    review_date date,
    source text,
    notes text
);


--
-- Name: user_barriers_definite_control; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.user_barriers_definite_control (
    blue_line_key integer NOT NULL,
    downstream_route_measure integer NOT NULL,
    barrier_type text,
    barrier_ind boolean,
    watershed_group_code text,
    reviewer_name text,
    review_date date,
    source text,
    notes text
);


--
-- Name: user_crossings_misc; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.user_crossings_misc (
    user_crossing_misc_id integer NOT NULL,
    blue_line_key integer NOT NULL,
    downstream_route_measure double precision NOT NULL,
    crossing_type_code text NOT NULL,
    crossing_subtype_code text NOT NULL,
    barrier_status text NOT NULL,
    watershed_group_code character varying(4) NOT NULL,
    reviewer_name text NOT NULL,
    review_date date NOT NULL,
    source text NOT NULL,
    notes text,
    CONSTRAINT user_crossings_misc_barrier_status_check CHECK ((barrier_status = ANY (ARRAY['BARRIER'::text, 'PASSABLE'::text, 'POTENTIAL'::text, 'UNKNOWN'::text]))),
    CONSTRAINT user_crossings_misc_crossing_subtype_code_check CHECK (((crossing_subtype_code ~ '^[A-Z0-9_]+$'::text) AND (char_length(crossing_subtype_code) <= 20))),
    CONSTRAINT user_crossings_misc_crossing_type_code_check CHECK ((crossing_type_code = ANY (ARRAY['CBS'::text, 'OBS'::text, 'OTHER'::text])))
);


--
-- Name: COLUMN user_crossings_misc.user_crossing_misc_id; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.user_crossing_misc_id IS 'User defined primary key - ensure this is unique';


--
-- Name: COLUMN user_crossings_misc.blue_line_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.blue_line_key IS 'See FWA documentation';


--
-- Name: COLUMN user_crossings_misc.downstream_route_measure; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.downstream_route_measure IS 'See FWA documentation';


--
-- Name: COLUMN user_crossings_misc.crossing_type_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.crossing_type_code IS 'Defines the type of crossing present at the location of the stream crossing. One of: {OBS=Open Bottom Structure CBS=Closed Bottom Structure OTHER=Crossing structure does not fit into the above categories (ford/wier)}';


--
-- Name: COLUMN user_crossings_misc.crossing_subtype_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.crossing_subtype_code IS 'Further definition of the type of crossing. One of {BRIDGE; CRTBOX; DAM; FORD; OVAL; PIPEARCH; ROUND; WEIR; WOODBOX; NULL}';


--
-- Name: COLUMN user_crossings_misc.barrier_status; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.barrier_status IS 'The evaluation of the crossing as a barrier to the fish passage. From PSCIS, this is based on the FINAL SCORE value. For other data sources this varies. One of: {PASSABLE - Passable; POTENTIAL - Potential or partial barrier; BARRIER - Barrier; UNKNOWN - Other}';


--
-- Name: COLUMN user_crossings_misc.watershed_group_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.watershed_group_code IS 'See FWA documentation';


--
-- Name: COLUMN user_crossings_misc.reviewer_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.reviewer_name IS 'Initials of user submitting the review, eg SN';


--
-- Name: COLUMN user_crossings_misc.review_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';


--
-- Name: COLUMN user_crossings_misc.source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.source IS 'Description or link to the source(s) documenting the feature';


--
-- Name: COLUMN user_crossings_misc.notes; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_crossings_misc.notes IS 'Reviewer notes on rationale for addition of the feature and/or how the source were interpreted';


--
-- Name: user_habitat_classification; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.user_habitat_classification (
    blue_line_key integer NOT NULL,
    downstream_route_measure double precision NOT NULL,
    upstream_route_measure double precision NOT NULL,
    watershed_group_code character varying(4),
    species_code text NOT NULL,
    spawning integer,
    rearing integer,
    reviewer_name text,
    review_date date,
    source text,
    notes text
);


--
-- Name: COLUMN user_habitat_classification.blue_line_key; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.blue_line_key IS 'See FWA documentation';


--
-- Name: COLUMN user_habitat_classification.downstream_route_measure; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.downstream_route_measure IS 'Measure of stream at point where user habitat classification begins';


--
-- Name: COLUMN user_habitat_classification.upstream_route_measure; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.upstream_route_measure IS 'Measure of stream at point where user habitat classification ends';


--
-- Name: COLUMN user_habitat_classification.watershed_group_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.watershed_group_code IS 'See FWA documentation';


--
-- Name: COLUMN user_habitat_classification.species_code; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.species_code IS 'Habitat classification applies to this species - see whse_fish.species_cd for values';


--
-- Name: COLUMN user_habitat_classification.spawning; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.spawning IS 'Spawning classification (-1: known non-spawning; 1: known spawning, -4: mining altered stream)';


--
-- Name: COLUMN user_habitat_classification.rearing; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.rearing IS 'Rearing classification (-1: known non-rearing; 1: known rearing, -4: mining altered stream)';


--
-- Name: COLUMN user_habitat_classification.reviewer_name; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.reviewer_name IS 'Initials of user submitting the review, eg SN';


--
-- Name: COLUMN user_habitat_classification.review_date; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.review_date IS 'Date of review, in form YYYY-MM-DD eg 2025-01-07';


--
-- Name: COLUMN user_habitat_classification.source; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.source IS 'Description or link to the source(s) documenting the feature';


--
-- Name: COLUMN user_habitat_classification.notes; Type: COMMENT; Schema: bcfishpass; Owner: -
--

COMMENT ON COLUMN bcfishpass.user_habitat_classification.notes IS 'Reviewer notes on rationale for addition of the feature and/or how the source were interpreted';


--
-- Name: user_habitat_classification_endpoints; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.user_habitat_classification_endpoints (
    blue_line_key integer NOT NULL,
    downstream_route_measure double precision NOT NULL,
    linear_feature_id bigint,
    watershed_group_code character varying(4)
);


--
-- Name: user_habitat_codes; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.user_habitat_codes (
    habitat_code integer NOT NULL,
    habitat_value text NOT NULL
);


--
-- Name: user_modelled_crossing_fixes; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.user_modelled_crossing_fixes (
    modelled_crossing_id integer NOT NULL,
    structure text,
    watershed_group_code character varying(4),
    reviewer_name text,
    review_date date,
    source text,
    notes text
);


--
-- Name: user_pscis_barrier_status; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.user_pscis_barrier_status (
    stream_crossing_id integer NOT NULL,
    user_barrier_status text,
    watershed_group_code character varying(4),
    reviewer_name text,
    reviewer_date date,
    notes text
);


--
-- Name: wcrp_barrier_count_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.wcrp_barrier_count_vw AS
 WITH model_status AS (
         SELECT c_1.aggregated_crossings_id,
                CASE
                    WHEN ((((h.ch_spawning_km > (0)::double precision) OR (h.ch_rearing_km > (0)::double precision)) AND (w_1.ch IS TRUE)) OR (((h.co_spawning_km > (0)::double precision) OR (h.co_rearing_km > (0)::double precision)) AND (w_1.co IS TRUE)) OR (((h.sk_spawning_km > (0)::double precision) OR (h.sk_rearing_km > (0)::double precision)) AND (w_1.sk IS TRUE)) OR (((h.st_spawning_km > (0)::double precision) OR (h.st_rearing_km > (0)::double precision)) AND (w_1.st IS TRUE)) OR (((h.wct_spawning_km > (0)::double precision) OR (h.wct_rearing_km > (0)::double precision)) AND (w_1.wct IS TRUE))) THEN 'HABITAT'::text
                    WHEN (((w_1.ch IS TRUE) AND (cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0)) OR ((w_1.co IS TRUE) AND (cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0)) OR ((w_1.sk IS TRUE) AND (cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0)) OR ((w_1.st IS TRUE) AND (cardinality(a.barriers_st_dnstr) = 0)) OR ((w_1.wct IS TRUE) AND (cardinality(a.barriers_wct_dnstr) = 0))) THEN 'ACCESSIBLE'::text
                    ELSE 'NATURAL_BARRIER'::text
                END AS model_status
           FROM (((bcfishpass.crossings c_1
             LEFT JOIN bcfishpass.crossings_upstream_access a ON ((c_1.aggregated_crossings_id = a.aggregated_crossings_id)))
             LEFT JOIN bcfishpass.crossings_upstream_habitat h ON ((c_1.aggregated_crossings_id = h.aggregated_crossings_id)))
             LEFT JOIN bcfishpass.wcrp_watersheds w_1 ON ((c_1.watershed_group_code = (w_1.watershed_group_code)::text)))
        )
 SELECT c.watershed_group_code,
    ms.model_status,
    c.crossing_feature_type,
    count(*) FILTER (WHERE (c.barrier_status = 'PASSABLE'::text)) AS n_passable,
    count(*) FILTER (WHERE (c.barrier_status = 'BARRIER'::text)) AS n_barrier,
    count(*) FILTER (WHERE (c.barrier_status = 'POTENTIAL'::text)) AS n_potential,
    count(*) FILTER (WHERE (c.barrier_status = 'UNKNOWN'::text)) AS n_unknown,
    count(*) AS total
   FROM ((bcfishpass.crossings c
     LEFT JOIN model_status ms ON ((c.aggregated_crossings_id = ms.aggregated_crossings_id)))
     JOIN bcfishpass.wcrp_watersheds w ON ((c.watershed_group_code = (w.watershed_group_code)::text)))
  WHERE ((c.wscode_ltree OPERATOR(public.<@) '300.602565.854327.993941.902282.132363'::public.ltree) IS FALSE)
  GROUP BY c.watershed_group_code, ms.model_status, c.crossing_feature_type
  ORDER BY c.watershed_group_code, ms.model_status, c.crossing_feature_type;


--
-- Name: wcrp_confirmed_barriers; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.wcrp_confirmed_barriers (
    aggregated_crossings_id text NOT NULL,
    internal_name text,
    watercourse_name text,
    road_name text,
    easting integer,
    northing integer,
    zone integer,
    barrier_type text,
    barrier_owner text,
    assessment_step_completed text,
    partial_passability_notes text,
    upstream_habitat_quality text,
    constructability text,
    estimated_cost integer,
    cost_benefit_ratio integer,
    priority text,
    next_steps text,
    next_steps_timeline text,
    next_steps_lead text,
    next_steps_others_involved text,
    reason text,
    comments text,
    CONSTRAINT wcrp_confirmed_barriers_assessment_step_completed_check CHECK ((assessment_step_completed = ANY (ARRAY['Informal assessment'::text, 'Barrier assessment'::text, 'Habitat confirmation'::text, 'Detailed habitat investigation'::text]))),
    CONSTRAINT wcrp_confirmed_barriers_next_steps_check CHECK ((next_steps = ANY (ARRAY['Engage with barrier owner'::text, 'Bring barrier to regulator'::text, 'Commission engineering designs'::text, 'Remove'::text, 'Replace'::text, 'Leave until end of life cycle'::text, 'identify barrier owner'::text, 'Engage in public consultation'::text, 'Fundraise'::text]))),
    CONSTRAINT wcrp_confirmed_barriers_priority_check CHECK ((priority = ANY (ARRAY['High'::text, 'Medium'::text, 'Low'::text])))
);


--
-- Name: wcrp_data_deficient_structures; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.wcrp_data_deficient_structures (
    aggregated_crossings_id text NOT NULL,
    internal_name text,
    watercourse_name text,
    road_name text,
    easting integer,
    northing integer,
    zone integer,
    structure_type text,
    assessment_step_completed text,
    structure_owner text,
    next_steps text,
    next_steps_lead text,
    comments text,
    CONSTRAINT wcrp_data_deficient_structures_assessment_step_completed_check CHECK ((assessment_step_completed = ANY (ARRAY['Informal assessment'::text, 'Barrier assessment'::text, 'Habitat confirmation'::text, 'Detailed habitat investigation'::text]))),
    CONSTRAINT wcrp_data_deficient_structures_next_steps_check CHECK ((next_steps = ANY (ARRAY['Barrier assessment'::text, 'Habitat confirmation'::text, 'Detailed habitat investigation'::text, 'Other'::text, 'Passage study'::text])))
);


--
-- Name: wcrp_excluded_structures; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.wcrp_excluded_structures (
    aggregated_crossings_id text NOT NULL,
    internal_name text,
    watercourse_name text,
    road_name text,
    easting integer,
    northing integer,
    zone integer,
    exclusion_reason text,
    exclusion_method text,
    comments text,
    supporting_links text,
    CONSTRAINT wcrp_excluded_structures_exclusion_method_check CHECK ((exclusion_method = ANY (ARRAY['Imagery review'::text, 'Field assessment'::text, 'Local knowledge'::text, 'Informal assessment'::text]))),
    CONSTRAINT wcrp_excluded_structures_exclusion_reason_check CHECK ((exclusion_reason = ANY (ARRAY['Passable'::text, 'No structure'::text, 'No key upstream habitat'::text, 'No structure/key upstream habitat'::text])))
);


--
-- Name: wcrp_habitat_connectivity_status_vw; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.wcrp_habitat_connectivity_status_vw AS
 WITH length_totals AS (
         SELECT s.watershed_group_code,
            'SPAWNING'::text AS habitat_type,
            COALESCE(round(((sum(public.st_length(s.geom)) FILTER (WHERE (((h.spawning_ch > 0) AND (w.ch IS TRUE)) OR ((h.spawning_co > 0) AND (w.co IS TRUE)) OR ((h.spawning_st > 0) AND (w.st IS TRUE)) OR ((h.spawning_sk > 0) AND (w.sk IS TRUE)) OR ((h.spawning_wct > 0) AND (w.wct IS TRUE)))) / (1000)::double precision))::numeric, 2), (0)::numeric) AS total_km,
            COALESCE(round(((sum(public.st_length(s.geom)) FILTER (WHERE ((((h.spawning_ch > 0) AND (w.ch IS TRUE)) OR ((h.spawning_co > 0) AND (w.co IS TRUE)) OR ((h.spawning_st > 0) AND (w.st IS TRUE)) OR ((h.spawning_sk > 0) AND (w.sk IS TRUE)) OR ((h.spawning_wct > 0) AND (w.wct IS TRUE))) AND (a.barriers_anthropogenic_dnstr IS NULL))) / (1000)::double precision))::numeric, 2), (0)::numeric) AS accessible_km
           FROM (((bcfishpass.streams s
             JOIN bcfishpass.streams_habitat_linear h USING (segmented_stream_id))
             JOIN bcfishpass.streams_access a USING (segmented_stream_id))
             JOIN bcfishpass.wcrp_watersheds w ON (((s.watershed_group_code)::text = (w.watershed_group_code)::text)))
          GROUP BY s.watershed_group_code
        UNION ALL
         SELECT s.watershed_group_code,
            'REARING'::text AS habitat_type,
            round(((((COALESCE(sum(public.st_length(s.geom)) FILTER (WHERE (((h.rearing_ch > 0) AND (w.ch IS TRUE)) OR ((h.rearing_st > 0) AND (w.st IS TRUE)) OR ((h.rearing_sk > 0) AND (w.sk IS TRUE)) OR ((h.rearing_co > 0) AND (w.co IS TRUE)) OR ((h.rearing_wct > 0) AND (w.wct IS TRUE)))), (0)::double precision) + COALESCE(sum((public.st_length(s.geom) * (0.5)::double precision)) FILTER (WHERE ((h.rearing_co > 0) AND (w.co IS TRUE) AND (s.edge_type = 1050))), (0)::double precision)) + COALESCE(sum((public.st_length(s.geom) * (0.5)::double precision)) FILTER (WHERE ((h.rearing_sk > 0) AND (w.sk IS TRUE))), (0)::double precision)) / (1000)::double precision))::numeric, 2) AS total_km,
            round(((((COALESCE(sum(public.st_length(s.geom)) FILTER (WHERE ((((h.rearing_ch > 0) AND (w.ch IS TRUE)) OR ((h.rearing_co > 0) AND (w.co IS TRUE)) OR ((h.rearing_st > 0) AND (w.st IS TRUE)) OR ((h.rearing_sk > 0) AND (w.sk IS TRUE)) OR ((h.rearing_wct > 0) AND (w.wct IS TRUE))) AND (a.barriers_anthropogenic_dnstr IS NULL))), (0)::double precision) + COALESCE(sum((public.st_length(s.geom) * (0.5)::double precision)) FILTER (WHERE ((h.rearing_co > 0) AND (w.co IS TRUE) AND (s.edge_type = 1050) AND (a.barriers_anthropogenic_dnstr IS NULL))), (0)::double precision)) + COALESCE(sum((public.st_length(s.geom) * (0.5)::double precision)) FILTER (WHERE ((h.rearing_sk > 0) AND (w.sk IS TRUE) AND (a.barriers_anthropogenic_dnstr IS NULL))), (0)::double precision)) / (1000)::double precision))::numeric, 2) AS accessible_km
           FROM (((bcfishpass.streams s
             JOIN bcfishpass.streams_habitat_linear h USING (segmented_stream_id))
             JOIN bcfishpass.streams_access a USING (segmented_stream_id))
             JOIN bcfishpass.wcrp_watersheds w ON (((s.watershed_group_code)::text = (w.watershed_group_code)::text)))
          GROUP BY s.watershed_group_code
        UNION ALL
         SELECT s.watershed_group_code,
            'ALL'::text AS habitat_type,
            round(((((COALESCE(sum(public.st_length(s.geom)) FILTER (WHERE (((h.spawning_ch > 0) AND (w.ch IS TRUE)) OR ((h.spawning_co > 0) AND (w.co IS TRUE)) OR ((h.spawning_st > 0) AND (w.st IS TRUE)) OR ((h.spawning_sk > 0) AND (w.sk IS TRUE)) OR ((h.spawning_wct > 0) AND (w.wct IS TRUE)) OR ((h.rearing_ch > 0) AND (w.ch IS TRUE)) OR ((h.rearing_co > 0) AND (w.co IS TRUE)) OR ((h.rearing_st > 0) AND (w.st IS TRUE)) OR ((h.rearing_sk > 0) AND (w.sk IS TRUE)) OR ((h.rearing_wct > 0) AND (w.wct IS TRUE)))), (0)::double precision) + COALESCE(sum((public.st_length(s.geom) * (0.5)::double precision)) FILTER (WHERE ((h.rearing_co > 0) AND (w.co IS TRUE) AND (s.edge_type = 1050))), (0)::double precision)) + COALESCE(sum((public.st_length(s.geom) * (0.5)::double precision)) FILTER (WHERE ((h.rearing_sk > 0) AND (w.sk IS TRUE))), (0)::double precision)) / (1000)::double precision))::numeric, 2) AS total_km,
            round(((((COALESCE(sum(public.st_length(s.geom)) FILTER (WHERE ((((h.spawning_ch > 0) AND (w.ch IS TRUE)) OR ((h.spawning_co > 0) AND (w.co IS TRUE)) OR ((h.spawning_st > 0) AND (w.st IS TRUE)) OR ((h.spawning_sk > 0) AND (w.sk IS TRUE)) OR ((h.spawning_wct > 0) AND (w.wct IS TRUE)) OR ((h.rearing_ch > 0) AND (w.ch IS TRUE)) OR ((h.rearing_co > 0) AND (w.co IS TRUE)) OR ((h.rearing_st > 0) AND (w.st IS TRUE)) OR ((h.rearing_sk > 0) AND (w.sk IS TRUE)) OR ((h.rearing_wct > 0) AND (w.wct IS TRUE))) AND (a.barriers_anthropogenic_dnstr IS NULL))), (0)::double precision) + COALESCE(sum((public.st_length(s.geom) * (0.5)::double precision)) FILTER (WHERE ((h.rearing_co > 0) AND (s.edge_type = 1050) AND (a.barriers_anthropogenic_dnstr IS NULL))), (0)::double precision)) + COALESCE(sum((public.st_length(s.geom) * (0.5)::double precision)) FILTER (WHERE ((h.rearing_sk > 0) AND (a.barriers_anthropogenic_dnstr IS NULL))), (0)::double precision)) / (1000)::double precision))::numeric, 2) AS accessible_km
           FROM (((bcfishpass.streams s
             JOIN bcfishpass.streams_habitat_linear h USING (segmented_stream_id))
             JOIN bcfishpass.streams_access a USING (segmented_stream_id))
             JOIN bcfishpass.wcrp_watersheds w ON (((s.watershed_group_code)::text = (w.watershed_group_code)::text)))
          GROUP BY s.watershed_group_code
        UNION ALL
         SELECT s.watershed_group_code,
            'UPSTREAM_ELKO'::text AS habitat_type,
            round(((COALESCE(sum(public.st_length(s.geom)) FILTER (WHERE (((h.spawning_wct > 0) AND (w.wct IS TRUE)) OR ((h.rearing_wct > 0) AND (w.wct IS TRUE)))), (0)::double precision) / (1000)::double precision))::numeric, 2) AS total_km,
            round(((COALESCE(sum(public.st_length(s.geom)) FILTER (WHERE ((((h.spawning_wct > 0) AND (w.wct IS TRUE)) OR ((h.rearing_wct > 0) AND (w.wct IS TRUE))) AND (a.barriers_anthropogenic_dnstr = ( SELECT a_1.barriers_anthropogenic_dnstr
                   FROM ((bcfishpass.streams s_1
                     JOIN bcfishpass.streams_habitat_linear h_1 USING (segmented_stream_id))
                     JOIN bcfishpass.streams_access a_1 USING (segmented_stream_id))
                  WHERE (s_1.segmented_stream_id ~~ '356570562.22912000'::text))))), (0)::double precision) / (1000)::double precision))::numeric, 2) AS accessible_km
           FROM (((bcfishpass.streams s
             JOIN bcfishpass.streams_habitat_linear h USING (segmented_stream_id))
             JOIN bcfishpass.streams_access a USING (segmented_stream_id))
             JOIN bcfishpass.wcrp_watersheds w ON (((s.watershed_group_code)::text = (w.watershed_group_code)::text)))
          WHERE whse_basemapping.fwa_upstream(356570562, (22910)::double precision, (22910)::double precision, '300.625474.584724'::public.ltree, '300.625474.584724.100997'::public.ltree, s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree)
          GROUP BY s.watershed_group_code
        UNION ALL
         SELECT s.watershed_group_code,
            'DOWNSTREAM_ELKO'::text AS habitat_type,
            round(((COALESCE(sum(public.st_length(s.geom)) FILTER (WHERE (((h.spawning_wct > 0) AND (w.wct IS TRUE)) OR ((h.rearing_wct > 0) AND (w.wct IS TRUE)))), (0)::double precision) / (1000)::double precision))::numeric, 2) AS total_km,
            round(((COALESCE(sum(public.st_length(s.geom)) FILTER (WHERE (((((h.spawning_wct > 0) AND (w.wct IS TRUE)) OR ((h.rearing_wct > 0) AND (w.wct IS TRUE))) AND (a.barriers_anthropogenic_dnstr IS NULL) AND (a.barriers_wct_dnstr = ARRAY[]::text[])) OR (a.barriers_anthropogenic_dnstr = ( SELECT DISTINCT a_1.barriers_anthropogenic_dnstr
                   FROM ((bcfishpass.streams s_1
                     JOIN bcfishpass.streams_habitat_linear h_1 USING (segmented_stream_id))
                     JOIN bcfishpass.streams_access a_1 USING (segmented_stream_id))
                  WHERE (s_1.linear_feature_id = 706872063))))), (0)::double precision) / (1000)::double precision))::numeric, 2) AS accessible_km
           FROM (((bcfishpass.streams s
             JOIN bcfishpass.streams_habitat_linear h USING (segmented_stream_id))
             JOIN bcfishpass.streams_access a USING (segmented_stream_id))
             JOIN bcfishpass.wcrp_watersheds w ON (((s.watershed_group_code)::text = (w.watershed_group_code)::text)))
          WHERE ((s.wscode_ltree OPERATOR(public.<@) '300.625474.584724'::public.ltree) AND (NOT whse_basemapping.fwa_upstream(356570562, (22910)::double precision, (22910)::double precision, '300.625474.584724'::public.ltree, '300.625474.584724.100997'::public.ltree, s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree)))
          GROUP BY s.watershed_group_code
        )
 SELECT watershed_group_code,
    habitat_type,
    total_km,
    accessible_km,
    round(((accessible_km / (total_km + 0.0001)) * (100)::numeric), 2) AS pct_accessible
   FROM length_totals
  ORDER BY watershed_group_code, habitat_type DESC;


--
-- Name: wcrp_rehabilitiated_structures; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.wcrp_rehabilitiated_structures (
    aggregated_crossing_id text NOT NULL,
    internal_name text,
    watercourse_name text,
    road_name text,
    easting integer,
    northing integer,
    zone integer,
    rehabilitation_type text,
    rehabilitated_by text,
    rehabilitation_date date,
    rehabilitation_cost_estimate integer,
    rehabilitation_cost_actual integer,
    comments text,
    supporting_links text,
    CONSTRAINT wcrp_rehabilitiated_structures_rehabilitation_type_check CHECK ((rehabilitation_type = ANY (ARRAY['Removal'::text, 'Replacement - OBS'::text, 'Replacement - CBS'::text, 'Decommissioning'::text])))
);


--
-- Name: wsg_crossing_summary_current; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.wsg_crossing_summary_current AS
 SELECT s.model_run_id,
    s.watershed_group_code,
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
   FROM (bcfishpass.log_wsg_crossing_summary s
     JOIN bcfishpass.log l ON ((s.model_run_id = l.model_run_id)))
  WHERE (l.model_run_id = ( SELECT log.model_run_id
           FROM bcfishpass.log
          ORDER BY log.model_run_id DESC
         LIMIT 1))
  ORDER BY s.watershed_group_code, s.crossing_feature_type;


--
-- Name: wsg_crossing_summary_previous; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.wsg_crossing_summary_previous AS
 SELECT s.model_run_id,
    s.watershed_group_code,
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
   FROM (bcfishpass.log_wsg_crossing_summary s
     JOIN bcfishpass.log l ON ((s.model_run_id = l.model_run_id)))
  WHERE (l.model_run_id = ( SELECT log.model_run_id
           FROM bcfishpass.log
          ORDER BY log.model_run_id DESC
         OFFSET 1
         LIMIT 1))
  ORDER BY s.watershed_group_code;


--
-- Name: wsg_crossing_summary_diff; Type: VIEW; Schema: bcfishpass; Owner: -
--

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
     JOIN bcfishpass.wsg_crossing_summary_previous b ON (((a.watershed_group_code = b.watershed_group_code) AND (a.crossing_feature_type = b.crossing_feature_type))))
  ORDER BY a.watershed_group_code;


--
-- Name: wsg_linear_summary_current; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.wsg_linear_summary_current AS
 WITH sums AS (
         SELECT aw.watershed_group_code,
            sum(s_1.length_total) AS length_total,
            sum(s_1.length_naturallyaccessible_obsrvd_bt) AS length_naturallyaccessible_obsrvd_bt,
            sum(s_1.length_naturallyaccessible_obsrvd_bt_access_a) AS length_naturallyaccessible_obsrvd_bt_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_bt_access_b) AS length_naturallyaccessible_obsrvd_bt_access_b,
            sum(s_1.length_naturallyaccessible_model_bt) AS length_naturallyaccessible_model_bt,
            sum(s_1.length_naturallyaccessible_model_bt_access_a) AS length_naturallyaccessible_model_bt_access_a,
            sum(s_1.length_naturallyaccessible_model_bt_access_b) AS length_naturallyaccessible_model_bt_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_ch) AS length_naturallyaccessible_obsrvd_ch,
            sum(s_1.length_naturallyaccessible_obsrvd_ch_access_a) AS length_naturallyaccessible_obsrvd_ch_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_ch_access_b) AS length_naturallyaccessible_obsrvd_ch_access_b,
            sum(s_1.length_naturallyaccessible_model_ch) AS length_naturallyaccessible_model_ch,
            sum(s_1.length_naturallyaccessible_model_ch_access_a) AS length_naturallyaccessible_model_ch_access_a,
            sum(s_1.length_naturallyaccessible_model_ch_access_b) AS length_naturallyaccessible_model_ch_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_cm) AS length_naturallyaccessible_obsrvd_cm,
            sum(s_1.length_naturallyaccessible_obsrvd_cm_access_a) AS length_naturallyaccessible_obsrvd_cm_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_cm_access_b) AS length_naturallyaccessible_obsrvd_cm_access_b,
            sum(s_1.length_naturallyaccessible_model_cm) AS length_naturallyaccessible_model_cm,
            sum(s_1.length_naturallyaccessible_model_cm_access_a) AS length_naturallyaccessible_model_cm_access_a,
            sum(s_1.length_naturallyaccessible_model_cm_access_b) AS length_naturallyaccessible_model_cm_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_co) AS length_naturallyaccessible_obsrvd_co,
            sum(s_1.length_naturallyaccessible_obsrvd_co_access_a) AS length_naturallyaccessible_obsrvd_co_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_co_access_b) AS length_naturallyaccessible_obsrvd_co_access_b,
            sum(s_1.length_naturallyaccessible_model_co) AS length_naturallyaccessible_model_co,
            sum(s_1.length_naturallyaccessible_model_co_access_a) AS length_naturallyaccessible_model_co_access_a,
            sum(s_1.length_naturallyaccessible_model_co_access_b) AS length_naturallyaccessible_model_co_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_pk) AS length_naturallyaccessible_obsrvd_pk,
            sum(s_1.length_naturallyaccessible_obsrvd_pk_access_a) AS length_naturallyaccessible_obsrvd_pk_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_pk_access_b) AS length_naturallyaccessible_obsrvd_pk_access_b,
            sum(s_1.length_naturallyaccessible_model_pk) AS length_naturallyaccessible_model_pk,
            sum(s_1.length_naturallyaccessible_model_pk_access_a) AS length_naturallyaccessible_model_pk_access_a,
            sum(s_1.length_naturallyaccessible_model_pk_access_b) AS length_naturallyaccessible_model_pk_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_sk) AS length_naturallyaccessible_obsrvd_sk,
            sum(s_1.length_naturallyaccessible_obsrvd_sk_access_a) AS length_naturallyaccessible_obsrvd_sk_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_sk_access_b) AS length_naturallyaccessible_obsrvd_sk_access_b,
            sum(s_1.length_naturallyaccessible_model_sk) AS length_naturallyaccessible_model_sk,
            sum(s_1.length_naturallyaccessible_model_sk_access_a) AS length_naturallyaccessible_model_sk_access_a,
            sum(s_1.length_naturallyaccessible_model_sk_access_b) AS length_naturallyaccessible_model_sk_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_salmon) AS length_naturallyaccessible_obsrvd_salmon,
            sum(s_1.length_naturallyaccessible_obsrvd_salmon_access_a) AS length_naturallyaccessible_obsrvd_salmon_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_salmon_access_b) AS length_naturallyaccessible_obsrvd_salmon_access_b,
            sum(s_1.length_naturallyaccessible_model_salmon) AS length_naturallyaccessible_model_salmon,
            sum(s_1.length_naturallyaccessible_model_salmon_access_a) AS length_naturallyaccessible_model_salmon_access_a,
            sum(s_1.length_naturallyaccessible_model_salmon_access_b) AS length_naturallyaccessible_model_salmon_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_st) AS length_naturallyaccessible_obsrvd_st,
            sum(s_1.length_naturallyaccessible_obsrvd_st_access_a) AS length_naturallyaccessible_obsrvd_st_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_st_access_b) AS length_naturallyaccessible_obsrvd_st_access_b,
            sum(s_1.length_naturallyaccessible_model_st) AS length_naturallyaccessible_model_st,
            sum(s_1.length_naturallyaccessible_model_st_access_a) AS length_naturallyaccessible_model_st_access_a,
            sum(s_1.length_naturallyaccessible_model_st_access_b) AS length_naturallyaccessible_model_st_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_wct) AS length_naturallyaccessible_obsrvd_wct,
            sum(s_1.length_naturallyaccessible_obsrvd_wct_access_a) AS length_naturallyaccessible_obsrvd_wct_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_wct_access_b) AS length_naturallyaccessible_obsrvd_wct_access_b,
            sum(s_1.length_naturallyaccessible_model_wct) AS length_naturallyaccessible_model_wct,
            sum(s_1.length_naturallyaccessible_model_wct_access_a) AS length_naturallyaccessible_model_wct_access_a,
            sum(s_1.length_naturallyaccessible_model_wct_access_b) AS length_naturallyaccessible_model_wct_access_b,
            sum(s_1.length_spawningrearing_obsrvd_bt) AS length_spawningrearing_obsrvd_bt,
            sum(s_1.length_spawningrearing_obsrvd_bt_access_a) AS length_spawningrearing_obsrvd_bt_access_a,
            sum(s_1.length_spawningrearing_obsrvd_bt_access_b) AS length_spawningrearing_obsrvd_bt_access_b,
            sum(s_1.length_spawningrearing_model_bt) AS length_spawningrearing_model_bt,
            sum(s_1.length_spawningrearing_model_bt_access_a) AS length_spawningrearing_model_bt_access_a,
            sum(s_1.length_spawningrearing_model_bt_access_b) AS length_spawningrearing_model_bt_access_b,
            sum(s_1.length_spawningrearing_obsrvd_ch) AS length_spawningrearing_obsrvd_ch,
            sum(s_1.length_spawningrearing_obsrvd_ch_access_a) AS length_spawningrearing_obsrvd_ch_access_a,
            sum(s_1.length_spawningrearing_obsrvd_ch_access_b) AS length_spawningrearing_obsrvd_ch_access_b,
            sum(s_1.length_spawningrearing_model_ch) AS length_spawningrearing_model_ch,
            sum(s_1.length_spawningrearing_model_ch_access_a) AS length_spawningrearing_model_ch_access_a,
            sum(s_1.length_spawningrearing_model_ch_access_b) AS length_spawningrearing_model_ch_access_b,
            sum(s_1.length_spawningrearing_obsrvd_cm) AS length_spawningrearing_obsrvd_cm,
            sum(s_1.length_spawningrearing_obsrvd_cm_access_a) AS length_spawningrearing_obsrvd_cm_access_a,
            sum(s_1.length_spawningrearing_obsrvd_cm_access_b) AS length_spawningrearing_obsrvd_cm_access_b,
            sum(s_1.length_spawningrearing_model_cm) AS length_spawningrearing_model_cm,
            sum(s_1.length_spawningrearing_model_cm_access_a) AS length_spawningrearing_model_cm_access_a,
            sum(s_1.length_spawningrearing_model_cm_access_b) AS length_spawningrearing_model_cm_access_b,
            sum(s_1.length_spawningrearing_obsrvd_co) AS length_spawningrearing_obsrvd_co,
            sum(s_1.length_spawningrearing_obsrvd_co_access_a) AS length_spawningrearing_obsrvd_co_access_a,
            sum(s_1.length_spawningrearing_obsrvd_co_access_b) AS length_spawningrearing_obsrvd_co_access_b,
            sum(s_1.length_spawningrearing_model_co) AS length_spawningrearing_model_co,
            sum(s_1.length_spawningrearing_model_co_access_a) AS length_spawningrearing_model_co_access_a,
            sum(s_1.length_spawningrearing_model_co_access_b) AS length_spawningrearing_model_co_access_b,
            sum(s_1.length_spawningrearing_obsrvd_pk) AS length_spawningrearing_obsrvd_pk,
            sum(s_1.length_spawningrearing_obsrvd_pk_access_a) AS length_spawningrearing_obsrvd_pk_access_a,
            sum(s_1.length_spawningrearing_obsrvd_pk_access_b) AS length_spawningrearing_obsrvd_pk_access_b,
            sum(s_1.length_spawningrearing_model_pk) AS length_spawningrearing_model_pk,
            sum(s_1.length_spawningrearing_model_pk_access_a) AS length_spawningrearing_model_pk_access_a,
            sum(s_1.length_spawningrearing_model_pk_access_b) AS length_spawningrearing_model_pk_access_b,
            sum(s_1.length_spawningrearing_obsrvd_sk) AS length_spawningrearing_obsrvd_sk,
            sum(s_1.length_spawningrearing_obsrvd_sk_access_a) AS length_spawningrearing_obsrvd_sk_access_a,
            sum(s_1.length_spawningrearing_obsrvd_sk_access_b) AS length_spawningrearing_obsrvd_sk_access_b,
            sum(s_1.length_spawningrearing_model_sk) AS length_spawningrearing_model_sk,
            sum(s_1.length_spawningrearing_model_sk_access_a) AS length_spawningrearing_model_sk_access_a,
            sum(s_1.length_spawningrearing_model_sk_access_b) AS length_spawningrearing_model_sk_access_b,
            sum(s_1.length_spawningrearing_obsrvd_st) AS length_spawningrearing_obsrvd_st,
            sum(s_1.length_spawningrearing_obsrvd_st_access_a) AS length_spawningrearing_obsrvd_st_access_a,
            sum(s_1.length_spawningrearing_obsrvd_st_access_b) AS length_spawningrearing_obsrvd_st_access_b,
            sum(s_1.length_spawningrearing_model_st) AS length_spawningrearing_model_st,
            sum(s_1.length_spawningrearing_model_st_access_a) AS length_spawningrearing_model_st_access_a,
            sum(s_1.length_spawningrearing_model_st_access_b) AS length_spawningrearing_model_st_access_b,
            sum(s_1.length_spawningrearing_obsrvd_wct) AS length_spawningrearing_obsrvd_wct,
            sum(s_1.length_spawningrearing_obsrvd_wct_access_a) AS length_spawningrearing_obsrvd_wct_access_a,
            sum(s_1.length_spawningrearing_obsrvd_wct_access_b) AS length_spawningrearing_obsrvd_wct_access_b,
            sum(s_1.length_spawningrearing_model_wct) AS length_spawningrearing_model_wct,
            sum(s_1.length_spawningrearing_model_wct_access_a) AS length_spawningrearing_model_wct_access_a,
            sum(s_1.length_spawningrearing_model_wct_access_b) AS length_spawningrearing_model_wct_access_b,
            sum(s_1.length_spawningrearing_obsrvd_salmon) AS length_spawningrearing_obsrvd_salmon,
            sum(s_1.length_spawningrearing_obsrvd_salmon_access_a) AS length_spawningrearing_obsrvd_salmon_access_a,
            sum(s_1.length_spawningrearing_obsrvd_salmon_access_b) AS length_spawningrearing_obsrvd_salmon_access_b,
            sum(s_1.length_spawningrearing_model_salmon) AS length_spawningrearing_model_salmon,
            sum(s_1.length_spawningrearing_model_salmon_access_a) AS length_spawningrearing_model_salmon_access_a,
            sum(s_1.length_spawningrearing_model_salmon_access_b) AS length_spawningrearing_model_salmon_access_b,
            sum(s_1.length_spawningrearing_obsrvd_salmon_st) AS length_spawningrearing_obsrvd_salmon_st,
            sum(s_1.length_spawningrearing_obsrvd_salmon_st_access_a) AS length_spawningrearing_obsrvd_salmon_st_access_a,
            sum(s_1.length_spawningrearing_obsrvd_salmon_st_access_b) AS length_spawningrearing_obsrvd_salmon_st_access_b,
            sum(s_1.length_spawningrearing_model_salmon_st) AS length_spawningrearing_model_salmon_st,
            sum(s_1.length_spawningrearing_model_salmon_st_access_a) AS length_spawningrearing_model_salmon_st_access_a,
            sum(s_1.length_spawningrearing_model_salmon_st_access_b) AS length_spawningrearing_model_salmon_st_access_b
           FROM ((bcfishpass.log_aw_linear_summary s_1
             JOIN bcfishpass.log l ON ((s_1.model_run_id = l.model_run_id)))
             JOIN whse_basemapping.fwa_assessment_watersheds_poly aw ON ((s_1.assessment_watershed_id = aw.watershed_feature_id)))
          WHERE (l.date_completed = ( SELECT log.date_completed
                   FROM bcfishpass.log
                  ORDER BY log.date_completed DESC
                 LIMIT 1))
          GROUP BY aw.watershed_group_code
          ORDER BY aw.watershed_group_code
        )
 SELECT watershed_group_code,
    length_total,
    length_naturallyaccessible_obsrvd_bt,
    length_naturallyaccessible_obsrvd_bt_access_a,
    length_naturallyaccessible_obsrvd_bt_access_b,
    length_naturallyaccessible_model_bt,
    length_naturallyaccessible_model_bt_access_a,
    length_naturallyaccessible_model_bt_access_b,
    length_naturallyaccessible_obsrvd_ch,
    length_naturallyaccessible_obsrvd_ch_access_a,
    length_naturallyaccessible_obsrvd_ch_access_b,
    length_naturallyaccessible_model_ch,
    length_naturallyaccessible_model_ch_access_a,
    length_naturallyaccessible_model_ch_access_b,
    length_naturallyaccessible_obsrvd_cm,
    length_naturallyaccessible_obsrvd_cm_access_a,
    length_naturallyaccessible_obsrvd_cm_access_b,
    length_naturallyaccessible_model_cm,
    length_naturallyaccessible_model_cm_access_a,
    length_naturallyaccessible_model_cm_access_b,
    length_naturallyaccessible_obsrvd_co,
    length_naturallyaccessible_obsrvd_co_access_a,
    length_naturallyaccessible_obsrvd_co_access_b,
    length_naturallyaccessible_model_co,
    length_naturallyaccessible_model_co_access_a,
    length_naturallyaccessible_model_co_access_b,
    length_naturallyaccessible_obsrvd_pk,
    length_naturallyaccessible_obsrvd_pk_access_a,
    length_naturallyaccessible_obsrvd_pk_access_b,
    length_naturallyaccessible_model_pk,
    length_naturallyaccessible_model_pk_access_a,
    length_naturallyaccessible_model_pk_access_b,
    length_naturallyaccessible_obsrvd_sk,
    length_naturallyaccessible_obsrvd_sk_access_a,
    length_naturallyaccessible_obsrvd_sk_access_b,
    length_naturallyaccessible_model_sk,
    length_naturallyaccessible_model_sk_access_a,
    length_naturallyaccessible_model_sk_access_b,
    length_naturallyaccessible_obsrvd_salmon,
    length_naturallyaccessible_obsrvd_salmon_access_a,
    length_naturallyaccessible_obsrvd_salmon_access_b,
    length_naturallyaccessible_model_salmon,
    length_naturallyaccessible_model_salmon_access_a,
    length_naturallyaccessible_model_salmon_access_b,
    length_naturallyaccessible_obsrvd_st,
    length_naturallyaccessible_obsrvd_st_access_a,
    length_naturallyaccessible_obsrvd_st_access_b,
    length_naturallyaccessible_model_st,
    length_naturallyaccessible_model_st_access_a,
    length_naturallyaccessible_model_st_access_b,
    length_naturallyaccessible_obsrvd_wct,
    length_naturallyaccessible_obsrvd_wct_access_a,
    length_naturallyaccessible_obsrvd_wct_access_b,
    length_naturallyaccessible_model_wct,
    length_naturallyaccessible_model_wct_access_a,
    length_naturallyaccessible_model_wct_access_b,
    length_spawningrearing_obsrvd_bt,
    length_spawningrearing_obsrvd_bt_access_a,
    length_spawningrearing_obsrvd_bt_access_b,
    length_spawningrearing_model_bt,
    length_spawningrearing_model_bt_access_a,
    length_spawningrearing_model_bt_access_b,
    length_spawningrearing_obsrvd_ch,
    length_spawningrearing_obsrvd_ch_access_a,
    length_spawningrearing_obsrvd_ch_access_b,
    length_spawningrearing_model_ch,
    length_spawningrearing_model_ch_access_a,
    length_spawningrearing_model_ch_access_b,
    length_spawningrearing_obsrvd_cm,
    length_spawningrearing_obsrvd_cm_access_a,
    length_spawningrearing_obsrvd_cm_access_b,
    length_spawningrearing_model_cm,
    length_spawningrearing_model_cm_access_a,
    length_spawningrearing_model_cm_access_b,
    length_spawningrearing_obsrvd_co,
    length_spawningrearing_obsrvd_co_access_a,
    length_spawningrearing_obsrvd_co_access_b,
    length_spawningrearing_model_co,
    length_spawningrearing_model_co_access_a,
    length_spawningrearing_model_co_access_b,
    length_spawningrearing_obsrvd_pk,
    length_spawningrearing_obsrvd_pk_access_a,
    length_spawningrearing_obsrvd_pk_access_b,
    length_spawningrearing_model_pk,
    length_spawningrearing_model_pk_access_a,
    length_spawningrearing_model_pk_access_b,
    length_spawningrearing_obsrvd_sk,
    length_spawningrearing_obsrvd_sk_access_a,
    length_spawningrearing_obsrvd_sk_access_b,
    length_spawningrearing_model_sk,
    length_spawningrearing_model_sk_access_a,
    length_spawningrearing_model_sk_access_b,
    length_spawningrearing_obsrvd_st,
    length_spawningrearing_obsrvd_st_access_a,
    length_spawningrearing_obsrvd_st_access_b,
    length_spawningrearing_model_st,
    length_spawningrearing_model_st_access_a,
    length_spawningrearing_model_st_access_b,
    length_spawningrearing_obsrvd_wct,
    length_spawningrearing_obsrvd_wct_access_a,
    length_spawningrearing_obsrvd_wct_access_b,
    length_spawningrearing_model_wct,
    length_spawningrearing_model_wct_access_a,
    length_spawningrearing_model_wct_access_b,
    length_spawningrearing_obsrvd_salmon,
    length_spawningrearing_obsrvd_salmon_access_a,
    length_spawningrearing_obsrvd_salmon_access_b,
    length_spawningrearing_model_salmon,
    length_spawningrearing_model_salmon_access_a,
    length_spawningrearing_model_salmon_access_b,
    length_spawningrearing_obsrvd_salmon_st,
    length_spawningrearing_obsrvd_salmon_st_access_a,
    length_spawningrearing_obsrvd_salmon_st_access_b,
    length_spawningrearing_model_salmon_st,
    length_spawningrearing_model_salmon_st_access_a,
    length_spawningrearing_model_salmon_st_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_bt_access_b + length_naturallyaccessible_model_bt_access_b) / NULLIF((length_naturallyaccessible_obsrvd_bt + length_naturallyaccessible_model_bt), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_bt_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_ch_access_b + length_naturallyaccessible_model_ch_access_b) / NULLIF((length_naturallyaccessible_obsrvd_ch + length_naturallyaccessible_model_ch), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_ch_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_cm_access_b + length_naturallyaccessible_model_cm_access_b) / NULLIF((length_naturallyaccessible_obsrvd_cm + length_naturallyaccessible_model_cm), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_cm_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_co_access_b + length_naturallyaccessible_model_co_access_b) / NULLIF((length_naturallyaccessible_obsrvd_co + length_naturallyaccessible_model_co), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_co_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_pk_access_b + length_naturallyaccessible_model_pk_access_b) / NULLIF((length_naturallyaccessible_obsrvd_pk + length_naturallyaccessible_model_pk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_pk_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_sk_access_b + length_naturallyaccessible_model_sk_access_b) / NULLIF((length_naturallyaccessible_obsrvd_sk + length_naturallyaccessible_model_sk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_sk_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_salmon_access_b + length_naturallyaccessible_model_salmon_access_b) / NULLIF((length_naturallyaccessible_obsrvd_salmon + length_naturallyaccessible_model_salmon), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_salmon_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_st_access_b + length_naturallyaccessible_model_st_access_b) / NULLIF((length_naturallyaccessible_obsrvd_st + length_naturallyaccessible_model_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_st_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_wct_access_b + length_naturallyaccessible_model_wct_access_b) / NULLIF((length_naturallyaccessible_obsrvd_wct + length_naturallyaccessible_model_wct), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_wct_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_bt_access_b + length_spawningrearing_model_bt_access_b) / NULLIF((length_spawningrearing_obsrvd_bt + length_spawningrearing_model_bt), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_bt_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_ch_access_b + length_spawningrearing_model_ch_access_b) / NULLIF((length_spawningrearing_obsrvd_ch + length_spawningrearing_model_ch), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_ch_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_cm_access_b + length_spawningrearing_model_cm_access_b) / NULLIF((length_spawningrearing_obsrvd_cm + length_spawningrearing_model_cm), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_cm_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_co_access_b + length_spawningrearing_model_co_access_b) / NULLIF((length_spawningrearing_obsrvd_co + length_spawningrearing_model_co), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_co_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_pk_access_b + length_spawningrearing_model_pk_access_b) / NULLIF((length_spawningrearing_obsrvd_pk + length_spawningrearing_model_pk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_pk_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_sk_access_b + length_spawningrearing_model_sk_access_b) / NULLIF((length_spawningrearing_obsrvd_sk + length_spawningrearing_model_sk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_sk_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_st_access_b + length_spawningrearing_model_st_access_b) / NULLIF((length_spawningrearing_obsrvd_st + length_spawningrearing_model_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_st_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_wct_access_b + length_spawningrearing_model_wct_access_b) / NULLIF((length_spawningrearing_obsrvd_wct + length_spawningrearing_model_wct), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_wct_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_salmon_access_b + length_spawningrearing_model_salmon_access_b) / NULLIF((length_spawningrearing_obsrvd_salmon + length_spawningrearing_model_salmon), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_salmon_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_salmon_st_access_b + length_spawningrearing_model_salmon_st_access_b) / NULLIF((length_spawningrearing_obsrvd_salmon_st + length_spawningrearing_model_salmon_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_salmon_st_access_b
   FROM sums s;


--
-- Name: wsg_linear_summary_previous; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.wsg_linear_summary_previous AS
 WITH sums AS (
         SELECT aw.watershed_group_code,
            sum(s_1.length_total) AS length_total,
            sum(s_1.length_naturallyaccessible_obsrvd_bt) AS length_naturallyaccessible_obsrvd_bt,
            sum(s_1.length_naturallyaccessible_obsrvd_bt_access_a) AS length_naturallyaccessible_obsrvd_bt_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_bt_access_b) AS length_naturallyaccessible_obsrvd_bt_access_b,
            sum(s_1.length_naturallyaccessible_model_bt) AS length_naturallyaccessible_model_bt,
            sum(s_1.length_naturallyaccessible_model_bt_access_a) AS length_naturallyaccessible_model_bt_access_a,
            sum(s_1.length_naturallyaccessible_model_bt_access_b) AS length_naturallyaccessible_model_bt_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_ch) AS length_naturallyaccessible_obsrvd_ch,
            sum(s_1.length_naturallyaccessible_obsrvd_ch_access_a) AS length_naturallyaccessible_obsrvd_ch_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_ch_access_b) AS length_naturallyaccessible_obsrvd_ch_access_b,
            sum(s_1.length_naturallyaccessible_model_ch) AS length_naturallyaccessible_model_ch,
            sum(s_1.length_naturallyaccessible_model_ch_access_a) AS length_naturallyaccessible_model_ch_access_a,
            sum(s_1.length_naturallyaccessible_model_ch_access_b) AS length_naturallyaccessible_model_ch_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_cm) AS length_naturallyaccessible_obsrvd_cm,
            sum(s_1.length_naturallyaccessible_obsrvd_cm_access_a) AS length_naturallyaccessible_obsrvd_cm_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_cm_access_b) AS length_naturallyaccessible_obsrvd_cm_access_b,
            sum(s_1.length_naturallyaccessible_model_cm) AS length_naturallyaccessible_model_cm,
            sum(s_1.length_naturallyaccessible_model_cm_access_a) AS length_naturallyaccessible_model_cm_access_a,
            sum(s_1.length_naturallyaccessible_model_cm_access_b) AS length_naturallyaccessible_model_cm_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_co) AS length_naturallyaccessible_obsrvd_co,
            sum(s_1.length_naturallyaccessible_obsrvd_co_access_a) AS length_naturallyaccessible_obsrvd_co_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_co_access_b) AS length_naturallyaccessible_obsrvd_co_access_b,
            sum(s_1.length_naturallyaccessible_model_co) AS length_naturallyaccessible_model_co,
            sum(s_1.length_naturallyaccessible_model_co_access_a) AS length_naturallyaccessible_model_co_access_a,
            sum(s_1.length_naturallyaccessible_model_co_access_b) AS length_naturallyaccessible_model_co_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_pk) AS length_naturallyaccessible_obsrvd_pk,
            sum(s_1.length_naturallyaccessible_obsrvd_pk_access_a) AS length_naturallyaccessible_obsrvd_pk_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_pk_access_b) AS length_naturallyaccessible_obsrvd_pk_access_b,
            sum(s_1.length_naturallyaccessible_model_pk) AS length_naturallyaccessible_model_pk,
            sum(s_1.length_naturallyaccessible_model_pk_access_a) AS length_naturallyaccessible_model_pk_access_a,
            sum(s_1.length_naturallyaccessible_model_pk_access_b) AS length_naturallyaccessible_model_pk_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_sk) AS length_naturallyaccessible_obsrvd_sk,
            sum(s_1.length_naturallyaccessible_obsrvd_sk_access_a) AS length_naturallyaccessible_obsrvd_sk_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_sk_access_b) AS length_naturallyaccessible_obsrvd_sk_access_b,
            sum(s_1.length_naturallyaccessible_model_sk) AS length_naturallyaccessible_model_sk,
            sum(s_1.length_naturallyaccessible_model_sk_access_a) AS length_naturallyaccessible_model_sk_access_a,
            sum(s_1.length_naturallyaccessible_model_sk_access_b) AS length_naturallyaccessible_model_sk_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_salmon) AS length_naturallyaccessible_obsrvd_salmon,
            sum(s_1.length_naturallyaccessible_obsrvd_salmon_access_a) AS length_naturallyaccessible_obsrvd_salmon_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_salmon_access_b) AS length_naturallyaccessible_obsrvd_salmon_access_b,
            sum(s_1.length_naturallyaccessible_model_salmon) AS length_naturallyaccessible_model_salmon,
            sum(s_1.length_naturallyaccessible_model_salmon_access_a) AS length_naturallyaccessible_model_salmon_access_a,
            sum(s_1.length_naturallyaccessible_model_salmon_access_b) AS length_naturallyaccessible_model_salmon_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_st) AS length_naturallyaccessible_obsrvd_st,
            sum(s_1.length_naturallyaccessible_obsrvd_st_access_a) AS length_naturallyaccessible_obsrvd_st_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_st_access_b) AS length_naturallyaccessible_obsrvd_st_access_b,
            sum(s_1.length_naturallyaccessible_model_st) AS length_naturallyaccessible_model_st,
            sum(s_1.length_naturallyaccessible_model_st_access_a) AS length_naturallyaccessible_model_st_access_a,
            sum(s_1.length_naturallyaccessible_model_st_access_b) AS length_naturallyaccessible_model_st_access_b,
            sum(s_1.length_naturallyaccessible_obsrvd_wct) AS length_naturallyaccessible_obsrvd_wct,
            sum(s_1.length_naturallyaccessible_obsrvd_wct_access_a) AS length_naturallyaccessible_obsrvd_wct_access_a,
            sum(s_1.length_naturallyaccessible_obsrvd_wct_access_b) AS length_naturallyaccessible_obsrvd_wct_access_b,
            sum(s_1.length_naturallyaccessible_model_wct) AS length_naturallyaccessible_model_wct,
            sum(s_1.length_naturallyaccessible_model_wct_access_a) AS length_naturallyaccessible_model_wct_access_a,
            sum(s_1.length_naturallyaccessible_model_wct_access_b) AS length_naturallyaccessible_model_wct_access_b,
            sum(s_1.length_spawningrearing_obsrvd_bt) AS length_spawningrearing_obsrvd_bt,
            sum(s_1.length_spawningrearing_obsrvd_bt_access_a) AS length_spawningrearing_obsrvd_bt_access_a,
            sum(s_1.length_spawningrearing_obsrvd_bt_access_b) AS length_spawningrearing_obsrvd_bt_access_b,
            sum(s_1.length_spawningrearing_model_bt) AS length_spawningrearing_model_bt,
            sum(s_1.length_spawningrearing_model_bt_access_a) AS length_spawningrearing_model_bt_access_a,
            sum(s_1.length_spawningrearing_model_bt_access_b) AS length_spawningrearing_model_bt_access_b,
            sum(s_1.length_spawningrearing_obsrvd_ch) AS length_spawningrearing_obsrvd_ch,
            sum(s_1.length_spawningrearing_obsrvd_ch_access_a) AS length_spawningrearing_obsrvd_ch_access_a,
            sum(s_1.length_spawningrearing_obsrvd_ch_access_b) AS length_spawningrearing_obsrvd_ch_access_b,
            sum(s_1.length_spawningrearing_model_ch) AS length_spawningrearing_model_ch,
            sum(s_1.length_spawningrearing_model_ch_access_a) AS length_spawningrearing_model_ch_access_a,
            sum(s_1.length_spawningrearing_model_ch_access_b) AS length_spawningrearing_model_ch_access_b,
            sum(s_1.length_spawningrearing_obsrvd_cm) AS length_spawningrearing_obsrvd_cm,
            sum(s_1.length_spawningrearing_obsrvd_cm_access_a) AS length_spawningrearing_obsrvd_cm_access_a,
            sum(s_1.length_spawningrearing_obsrvd_cm_access_b) AS length_spawningrearing_obsrvd_cm_access_b,
            sum(s_1.length_spawningrearing_model_cm) AS length_spawningrearing_model_cm,
            sum(s_1.length_spawningrearing_model_cm_access_a) AS length_spawningrearing_model_cm_access_a,
            sum(s_1.length_spawningrearing_model_cm_access_b) AS length_spawningrearing_model_cm_access_b,
            sum(s_1.length_spawningrearing_obsrvd_co) AS length_spawningrearing_obsrvd_co,
            sum(s_1.length_spawningrearing_obsrvd_co_access_a) AS length_spawningrearing_obsrvd_co_access_a,
            sum(s_1.length_spawningrearing_obsrvd_co_access_b) AS length_spawningrearing_obsrvd_co_access_b,
            sum(s_1.length_spawningrearing_model_co) AS length_spawningrearing_model_co,
            sum(s_1.length_spawningrearing_model_co_access_a) AS length_spawningrearing_model_co_access_a,
            sum(s_1.length_spawningrearing_model_co_access_b) AS length_spawningrearing_model_co_access_b,
            sum(s_1.length_spawningrearing_obsrvd_pk) AS length_spawningrearing_obsrvd_pk,
            sum(s_1.length_spawningrearing_obsrvd_pk_access_a) AS length_spawningrearing_obsrvd_pk_access_a,
            sum(s_1.length_spawningrearing_obsrvd_pk_access_b) AS length_spawningrearing_obsrvd_pk_access_b,
            sum(s_1.length_spawningrearing_model_pk) AS length_spawningrearing_model_pk,
            sum(s_1.length_spawningrearing_model_pk_access_a) AS length_spawningrearing_model_pk_access_a,
            sum(s_1.length_spawningrearing_model_pk_access_b) AS length_spawningrearing_model_pk_access_b,
            sum(s_1.length_spawningrearing_obsrvd_sk) AS length_spawningrearing_obsrvd_sk,
            sum(s_1.length_spawningrearing_obsrvd_sk_access_a) AS length_spawningrearing_obsrvd_sk_access_a,
            sum(s_1.length_spawningrearing_obsrvd_sk_access_b) AS length_spawningrearing_obsrvd_sk_access_b,
            sum(s_1.length_spawningrearing_model_sk) AS length_spawningrearing_model_sk,
            sum(s_1.length_spawningrearing_model_sk_access_a) AS length_spawningrearing_model_sk_access_a,
            sum(s_1.length_spawningrearing_model_sk_access_b) AS length_spawningrearing_model_sk_access_b,
            sum(s_1.length_spawningrearing_obsrvd_st) AS length_spawningrearing_obsrvd_st,
            sum(s_1.length_spawningrearing_obsrvd_st_access_a) AS length_spawningrearing_obsrvd_st_access_a,
            sum(s_1.length_spawningrearing_obsrvd_st_access_b) AS length_spawningrearing_obsrvd_st_access_b,
            sum(s_1.length_spawningrearing_model_st) AS length_spawningrearing_model_st,
            sum(s_1.length_spawningrearing_model_st_access_a) AS length_spawningrearing_model_st_access_a,
            sum(s_1.length_spawningrearing_model_st_access_b) AS length_spawningrearing_model_st_access_b,
            sum(s_1.length_spawningrearing_obsrvd_wct) AS length_spawningrearing_obsrvd_wct,
            sum(s_1.length_spawningrearing_obsrvd_wct_access_a) AS length_spawningrearing_obsrvd_wct_access_a,
            sum(s_1.length_spawningrearing_obsrvd_wct_access_b) AS length_spawningrearing_obsrvd_wct_access_b,
            sum(s_1.length_spawningrearing_model_wct) AS length_spawningrearing_model_wct,
            sum(s_1.length_spawningrearing_model_wct_access_a) AS length_spawningrearing_model_wct_access_a,
            sum(s_1.length_spawningrearing_model_wct_access_b) AS length_spawningrearing_model_wct_access_b,
            sum(s_1.length_spawningrearing_obsrvd_salmon) AS length_spawningrearing_obsrvd_salmon,
            sum(s_1.length_spawningrearing_obsrvd_salmon_access_a) AS length_spawningrearing_obsrvd_salmon_access_a,
            sum(s_1.length_spawningrearing_obsrvd_salmon_access_b) AS length_spawningrearing_obsrvd_salmon_access_b,
            sum(s_1.length_spawningrearing_model_salmon) AS length_spawningrearing_model_salmon,
            sum(s_1.length_spawningrearing_model_salmon_access_a) AS length_spawningrearing_model_salmon_access_a,
            sum(s_1.length_spawningrearing_model_salmon_access_b) AS length_spawningrearing_model_salmon_access_b,
            sum(s_1.length_spawningrearing_obsrvd_salmon_st) AS length_spawningrearing_obsrvd_salmon_st,
            sum(s_1.length_spawningrearing_obsrvd_salmon_st_access_a) AS length_spawningrearing_obsrvd_salmon_st_access_a,
            sum(s_1.length_spawningrearing_obsrvd_salmon_st_access_b) AS length_spawningrearing_obsrvd_salmon_st_access_b,
            sum(s_1.length_spawningrearing_model_salmon_st) AS length_spawningrearing_model_salmon_st,
            sum(s_1.length_spawningrearing_model_salmon_st_access_a) AS length_spawningrearing_model_salmon_st_access_a,
            sum(s_1.length_spawningrearing_model_salmon_st_access_b) AS length_spawningrearing_model_salmon_st_access_b
           FROM ((bcfishpass.log_aw_linear_summary s_1
             JOIN bcfishpass.log l ON ((s_1.model_run_id = l.model_run_id)))
             JOIN whse_basemapping.fwa_assessment_watersheds_poly aw ON ((s_1.assessment_watershed_id = aw.watershed_feature_id)))
          WHERE (l.date_completed = ( SELECT log.date_completed
                   FROM bcfishpass.log
                  ORDER BY log.date_completed DESC
                 OFFSET 1
                 LIMIT 1))
          GROUP BY aw.watershed_group_code
          ORDER BY aw.watershed_group_code
        )
 SELECT watershed_group_code,
    length_total,
    length_naturallyaccessible_obsrvd_bt,
    length_naturallyaccessible_obsrvd_bt_access_a,
    length_naturallyaccessible_obsrvd_bt_access_b,
    length_naturallyaccessible_model_bt,
    length_naturallyaccessible_model_bt_access_a,
    length_naturallyaccessible_model_bt_access_b,
    length_naturallyaccessible_obsrvd_ch,
    length_naturallyaccessible_obsrvd_ch_access_a,
    length_naturallyaccessible_obsrvd_ch_access_b,
    length_naturallyaccessible_model_ch,
    length_naturallyaccessible_model_ch_access_a,
    length_naturallyaccessible_model_ch_access_b,
    length_naturallyaccessible_obsrvd_cm,
    length_naturallyaccessible_obsrvd_cm_access_a,
    length_naturallyaccessible_obsrvd_cm_access_b,
    length_naturallyaccessible_model_cm,
    length_naturallyaccessible_model_cm_access_a,
    length_naturallyaccessible_model_cm_access_b,
    length_naturallyaccessible_obsrvd_co,
    length_naturallyaccessible_obsrvd_co_access_a,
    length_naturallyaccessible_obsrvd_co_access_b,
    length_naturallyaccessible_model_co,
    length_naturallyaccessible_model_co_access_a,
    length_naturallyaccessible_model_co_access_b,
    length_naturallyaccessible_obsrvd_pk,
    length_naturallyaccessible_obsrvd_pk_access_a,
    length_naturallyaccessible_obsrvd_pk_access_b,
    length_naturallyaccessible_model_pk,
    length_naturallyaccessible_model_pk_access_a,
    length_naturallyaccessible_model_pk_access_b,
    length_naturallyaccessible_obsrvd_sk,
    length_naturallyaccessible_obsrvd_sk_access_a,
    length_naturallyaccessible_obsrvd_sk_access_b,
    length_naturallyaccessible_model_sk,
    length_naturallyaccessible_model_sk_access_a,
    length_naturallyaccessible_model_sk_access_b,
    length_naturallyaccessible_obsrvd_salmon,
    length_naturallyaccessible_obsrvd_salmon_access_a,
    length_naturallyaccessible_obsrvd_salmon_access_b,
    length_naturallyaccessible_model_salmon,
    length_naturallyaccessible_model_salmon_access_a,
    length_naturallyaccessible_model_salmon_access_b,
    length_naturallyaccessible_obsrvd_st,
    length_naturallyaccessible_obsrvd_st_access_a,
    length_naturallyaccessible_obsrvd_st_access_b,
    length_naturallyaccessible_model_st,
    length_naturallyaccessible_model_st_access_a,
    length_naturallyaccessible_model_st_access_b,
    length_naturallyaccessible_obsrvd_wct,
    length_naturallyaccessible_obsrvd_wct_access_a,
    length_naturallyaccessible_obsrvd_wct_access_b,
    length_naturallyaccessible_model_wct,
    length_naturallyaccessible_model_wct_access_a,
    length_naturallyaccessible_model_wct_access_b,
    length_spawningrearing_obsrvd_bt,
    length_spawningrearing_obsrvd_bt_access_a,
    length_spawningrearing_obsrvd_bt_access_b,
    length_spawningrearing_model_bt,
    length_spawningrearing_model_bt_access_a,
    length_spawningrearing_model_bt_access_b,
    length_spawningrearing_obsrvd_ch,
    length_spawningrearing_obsrvd_ch_access_a,
    length_spawningrearing_obsrvd_ch_access_b,
    length_spawningrearing_model_ch,
    length_spawningrearing_model_ch_access_a,
    length_spawningrearing_model_ch_access_b,
    length_spawningrearing_obsrvd_cm,
    length_spawningrearing_obsrvd_cm_access_a,
    length_spawningrearing_obsrvd_cm_access_b,
    length_spawningrearing_model_cm,
    length_spawningrearing_model_cm_access_a,
    length_spawningrearing_model_cm_access_b,
    length_spawningrearing_obsrvd_co,
    length_spawningrearing_obsrvd_co_access_a,
    length_spawningrearing_obsrvd_co_access_b,
    length_spawningrearing_model_co,
    length_spawningrearing_model_co_access_a,
    length_spawningrearing_model_co_access_b,
    length_spawningrearing_obsrvd_pk,
    length_spawningrearing_obsrvd_pk_access_a,
    length_spawningrearing_obsrvd_pk_access_b,
    length_spawningrearing_model_pk,
    length_spawningrearing_model_pk_access_a,
    length_spawningrearing_model_pk_access_b,
    length_spawningrearing_obsrvd_sk,
    length_spawningrearing_obsrvd_sk_access_a,
    length_spawningrearing_obsrvd_sk_access_b,
    length_spawningrearing_model_sk,
    length_spawningrearing_model_sk_access_a,
    length_spawningrearing_model_sk_access_b,
    length_spawningrearing_obsrvd_st,
    length_spawningrearing_obsrvd_st_access_a,
    length_spawningrearing_obsrvd_st_access_b,
    length_spawningrearing_model_st,
    length_spawningrearing_model_st_access_a,
    length_spawningrearing_model_st_access_b,
    length_spawningrearing_obsrvd_wct,
    length_spawningrearing_obsrvd_wct_access_a,
    length_spawningrearing_obsrvd_wct_access_b,
    length_spawningrearing_model_wct,
    length_spawningrearing_model_wct_access_a,
    length_spawningrearing_model_wct_access_b,
    length_spawningrearing_obsrvd_salmon,
    length_spawningrearing_obsrvd_salmon_access_a,
    length_spawningrearing_obsrvd_salmon_access_b,
    length_spawningrearing_model_salmon,
    length_spawningrearing_model_salmon_access_a,
    length_spawningrearing_model_salmon_access_b,
    length_spawningrearing_obsrvd_salmon_st,
    length_spawningrearing_obsrvd_salmon_st_access_a,
    length_spawningrearing_obsrvd_salmon_st_access_b,
    length_spawningrearing_model_salmon_st,
    length_spawningrearing_model_salmon_st_access_a,
    length_spawningrearing_model_salmon_st_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_bt_access_b + length_naturallyaccessible_model_bt_access_b) / NULLIF((length_naturallyaccessible_obsrvd_bt + length_naturallyaccessible_model_bt), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_bt_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_ch_access_b + length_naturallyaccessible_model_ch_access_b) / NULLIF((length_naturallyaccessible_obsrvd_ch + length_naturallyaccessible_model_ch), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_ch_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_cm_access_b + length_naturallyaccessible_model_cm_access_b) / NULLIF((length_naturallyaccessible_obsrvd_cm + length_naturallyaccessible_model_cm), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_cm_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_co_access_b + length_naturallyaccessible_model_co_access_b) / NULLIF((length_naturallyaccessible_obsrvd_co + length_naturallyaccessible_model_co), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_co_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_pk_access_b + length_naturallyaccessible_model_pk_access_b) / NULLIF((length_naturallyaccessible_obsrvd_pk + length_naturallyaccessible_model_pk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_pk_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_sk_access_b + length_naturallyaccessible_model_sk_access_b) / NULLIF((length_naturallyaccessible_obsrvd_sk + length_naturallyaccessible_model_sk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_sk_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_salmon_access_b + length_naturallyaccessible_model_salmon_access_b) / NULLIF((length_naturallyaccessible_obsrvd_salmon + length_naturallyaccessible_model_salmon), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_salmon_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_st_access_b + length_naturallyaccessible_model_st_access_b) / NULLIF((length_naturallyaccessible_obsrvd_st + length_naturallyaccessible_model_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_st_access_b,
    round((COALESCE(((length_naturallyaccessible_obsrvd_wct_access_b + length_naturallyaccessible_model_wct_access_b) / NULLIF((length_naturallyaccessible_obsrvd_wct + length_naturallyaccessible_model_wct), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_naturallyaccessible_wct_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_bt_access_b + length_spawningrearing_model_bt_access_b) / NULLIF((length_spawningrearing_obsrvd_bt + length_spawningrearing_model_bt), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_bt_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_ch_access_b + length_spawningrearing_model_ch_access_b) / NULLIF((length_spawningrearing_obsrvd_ch + length_spawningrearing_model_ch), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_ch_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_cm_access_b + length_spawningrearing_model_cm_access_b) / NULLIF((length_spawningrearing_obsrvd_cm + length_spawningrearing_model_cm), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_cm_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_co_access_b + length_spawningrearing_model_co_access_b) / NULLIF((length_spawningrearing_obsrvd_co + length_spawningrearing_model_co), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_co_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_pk_access_b + length_spawningrearing_model_pk_access_b) / NULLIF((length_spawningrearing_obsrvd_pk + length_spawningrearing_model_pk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_pk_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_sk_access_b + length_spawningrearing_model_sk_access_b) / NULLIF((length_spawningrearing_obsrvd_sk + length_spawningrearing_model_sk), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_sk_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_st_access_b + length_spawningrearing_model_st_access_b) / NULLIF((length_spawningrearing_obsrvd_st + length_spawningrearing_model_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_st_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_wct_access_b + length_spawningrearing_model_wct_access_b) / NULLIF((length_spawningrearing_obsrvd_wct + length_spawningrearing_model_wct), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_wct_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_salmon_access_b + length_spawningrearing_model_salmon_access_b) / NULLIF((length_spawningrearing_obsrvd_salmon + length_spawningrearing_model_salmon), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_salmon_access_b,
    round((COALESCE(((length_spawningrearing_obsrvd_salmon_st_access_b + length_spawningrearing_model_salmon_st_access_b) / NULLIF((length_spawningrearing_obsrvd_salmon_st + length_spawningrearing_model_salmon_st), (0)::numeric)), (0)::numeric) * (100)::numeric), 2) AS pct_spawningrearing_salmon_st_access_b
   FROM sums s;


--
-- Name: wsg_linear_summary_diff; Type: VIEW; Schema: bcfishpass; Owner: -
--

CREATE VIEW bcfishpass.wsg_linear_summary_diff AS
 SELECT a.watershed_group_code,
    a.length_total,
    (a.length_naturallyaccessible_obsrvd_bt - b.length_naturallyaccessible_obsrvd_bt) AS length_naturallyaccessible_obsrvd_bt,
    (a.length_naturallyaccessible_obsrvd_bt_access_a - b.length_naturallyaccessible_obsrvd_bt_access_a) AS length_naturallyaccessible_obsrvd_bt_access_a,
    (a.length_naturallyaccessible_obsrvd_bt_access_b - b.length_naturallyaccessible_obsrvd_bt_access_b) AS length_naturallyaccessible_obsrvd_bt_access_b,
    (a.length_naturallyaccessible_model_bt - b.length_naturallyaccessible_model_bt) AS length_naturallyaccessible_model_bt,
    (a.length_naturallyaccessible_model_bt_access_a - b.length_naturallyaccessible_model_bt_access_a) AS length_naturallyaccessible_model_bt_access_a,
    (a.length_naturallyaccessible_model_bt_access_b - b.length_naturallyaccessible_model_bt_access_b) AS length_naturallyaccessible_model_bt_access_b,
    (a.length_naturallyaccessible_obsrvd_ch - b.length_naturallyaccessible_obsrvd_ch) AS length_naturallyaccessible_obsrvd_ch,
    (a.length_naturallyaccessible_obsrvd_ch_access_a - b.length_naturallyaccessible_obsrvd_ch_access_a) AS length_naturallyaccessible_obsrvd_ch_access_a,
    (a.length_naturallyaccessible_obsrvd_ch_access_b - b.length_naturallyaccessible_obsrvd_ch_access_b) AS length_naturallyaccessible_obsrvd_ch_access_b,
    (a.length_naturallyaccessible_model_ch - b.length_naturallyaccessible_model_ch) AS length_naturallyaccessible_model_ch,
    (a.length_naturallyaccessible_model_ch_access_a - b.length_naturallyaccessible_model_ch_access_a) AS length_naturallyaccessible_model_ch_access_a,
    (a.length_naturallyaccessible_model_ch_access_b - b.length_naturallyaccessible_model_ch_access_b) AS length_naturallyaccessible_model_ch_access_b,
    (a.length_naturallyaccessible_obsrvd_cm - b.length_naturallyaccessible_obsrvd_cm) AS length_naturallyaccessible_obsrvd_cm,
    (a.length_naturallyaccessible_obsrvd_cm_access_a - b.length_naturallyaccessible_obsrvd_cm_access_a) AS length_naturallyaccessible_obsrvd_cm_access_a,
    (a.length_naturallyaccessible_obsrvd_cm_access_b - b.length_naturallyaccessible_obsrvd_cm_access_b) AS length_naturallyaccessible_obsrvd_cm_access_b,
    (a.length_naturallyaccessible_model_cm - b.length_naturallyaccessible_model_cm) AS length_naturallyaccessible_model_cm,
    (a.length_naturallyaccessible_model_cm_access_a - b.length_naturallyaccessible_model_cm_access_a) AS length_naturallyaccessible_model_cm_access_a,
    (a.length_naturallyaccessible_model_cm_access_b - b.length_naturallyaccessible_model_cm_access_b) AS length_naturallyaccessible_model_cm_access_b,
    (a.length_naturallyaccessible_obsrvd_co - b.length_naturallyaccessible_obsrvd_co) AS length_naturallyaccessible_obsrvd_co,
    (a.length_naturallyaccessible_obsrvd_co_access_a - b.length_naturallyaccessible_obsrvd_co_access_a) AS length_naturallyaccessible_obsrvd_co_access_a,
    (a.length_naturallyaccessible_obsrvd_co_access_b - b.length_naturallyaccessible_obsrvd_co_access_b) AS length_naturallyaccessible_obsrvd_co_access_b,
    (a.length_naturallyaccessible_model_co - b.length_naturallyaccessible_model_co) AS length_naturallyaccessible_model_co,
    (a.length_naturallyaccessible_model_co_access_a - b.length_naturallyaccessible_model_co_access_a) AS length_naturallyaccessible_model_co_access_a,
    (a.length_naturallyaccessible_model_co_access_b - b.length_naturallyaccessible_model_co_access_b) AS length_naturallyaccessible_model_co_access_b,
    (a.length_naturallyaccessible_obsrvd_pk - b.length_naturallyaccessible_obsrvd_pk) AS length_naturallyaccessible_obsrvd_pk,
    (a.length_naturallyaccessible_obsrvd_pk_access_a - b.length_naturallyaccessible_obsrvd_pk_access_a) AS length_naturallyaccessible_obsrvd_pk_access_a,
    (a.length_naturallyaccessible_obsrvd_pk_access_b - b.length_naturallyaccessible_obsrvd_pk_access_b) AS length_naturallyaccessible_obsrvd_pk_access_b,
    (a.length_naturallyaccessible_model_pk - b.length_naturallyaccessible_model_pk) AS length_naturallyaccessible_model_pk,
    (a.length_naturallyaccessible_model_pk_access_a - b.length_naturallyaccessible_model_pk_access_a) AS length_naturallyaccessible_model_pk_access_a,
    (a.length_naturallyaccessible_model_pk_access_b - b.length_naturallyaccessible_model_pk_access_b) AS length_naturallyaccessible_model_pk_access_b,
    (a.length_naturallyaccessible_obsrvd_sk - b.length_naturallyaccessible_obsrvd_sk) AS length_naturallyaccessible_obsrvd_sk,
    (a.length_naturallyaccessible_obsrvd_sk_access_a - b.length_naturallyaccessible_obsrvd_sk_access_a) AS length_naturallyaccessible_obsrvd_sk_access_a,
    (a.length_naturallyaccessible_obsrvd_sk_access_b - b.length_naturallyaccessible_obsrvd_sk_access_b) AS length_naturallyaccessible_obsrvd_sk_access_b,
    (a.length_naturallyaccessible_model_sk - b.length_naturallyaccessible_model_sk) AS length_naturallyaccessible_model_sk,
    (a.length_naturallyaccessible_model_sk_access_a - b.length_naturallyaccessible_model_sk_access_a) AS length_naturallyaccessible_model_sk_access_a,
    (a.length_naturallyaccessible_model_sk_access_b - b.length_naturallyaccessible_model_sk_access_b) AS length_naturallyaccessible_model_sk_access_b,
    (a.length_naturallyaccessible_obsrvd_salmon - b.length_naturallyaccessible_obsrvd_salmon) AS length_naturallyaccessible_obsrvd_salmon,
    (a.length_naturallyaccessible_obsrvd_salmon_access_a - b.length_naturallyaccessible_obsrvd_salmon_access_a) AS length_naturallyaccessible_obsrvd_salmon_access_a,
    (a.length_naturallyaccessible_obsrvd_salmon_access_b - b.length_naturallyaccessible_obsrvd_salmon_access_b) AS length_naturallyaccessible_obsrvd_salmon_access_b,
    (a.length_naturallyaccessible_model_salmon - b.length_naturallyaccessible_model_salmon) AS length_naturallyaccessible_model_salmon,
    (a.length_naturallyaccessible_model_salmon_access_a - b.length_naturallyaccessible_model_salmon_access_a) AS length_naturallyaccessible_model_salmon_access_a,
    (a.length_naturallyaccessible_model_salmon_access_b - b.length_naturallyaccessible_model_salmon_access_b) AS length_naturallyaccessible_model_salmon_access_b,
    (a.length_naturallyaccessible_obsrvd_st - b.length_naturallyaccessible_obsrvd_st) AS length_naturallyaccessible_obsrvd_st,
    (a.length_naturallyaccessible_obsrvd_st_access_a - b.length_naturallyaccessible_obsrvd_st_access_a) AS length_naturallyaccessible_obsrvd_st_access_a,
    (a.length_naturallyaccessible_obsrvd_st_access_b - b.length_naturallyaccessible_obsrvd_st_access_b) AS length_naturallyaccessible_obsrvd_st_access_b,
    (a.length_naturallyaccessible_model_st - b.length_naturallyaccessible_model_st) AS length_naturallyaccessible_model_st,
    (a.length_naturallyaccessible_model_st_access_a - b.length_naturallyaccessible_model_st_access_a) AS length_naturallyaccessible_model_st_access_a,
    (a.length_naturallyaccessible_model_st_access_b - b.length_naturallyaccessible_model_st_access_b) AS length_naturallyaccessible_model_st_access_b,
    (a.length_naturallyaccessible_obsrvd_wct - b.length_naturallyaccessible_obsrvd_wct) AS length_naturallyaccessible_obsrvd_wct,
    (a.length_naturallyaccessible_obsrvd_wct_access_a - b.length_naturallyaccessible_obsrvd_wct_access_a) AS length_naturallyaccessible_obsrvd_wct_access_a,
    (a.length_naturallyaccessible_obsrvd_wct_access_b - b.length_naturallyaccessible_obsrvd_wct_access_b) AS length_naturallyaccessible_obsrvd_wct_access_b,
    (a.length_naturallyaccessible_model_wct - b.length_naturallyaccessible_model_wct) AS length_naturallyaccessible_model_wct,
    (a.length_naturallyaccessible_model_wct_access_a - b.length_naturallyaccessible_model_wct_access_a) AS length_naturallyaccessible_model_wct_access_a,
    (a.length_naturallyaccessible_model_wct_access_b - b.length_naturallyaccessible_model_wct_access_b) AS length_naturallyaccessible_model_wct_access_b,
    (a.length_spawningrearing_obsrvd_bt - b.length_spawningrearing_obsrvd_bt) AS length_spawningrearing_obsrvd_bt,
    (a.length_spawningrearing_obsrvd_bt_access_a - b.length_spawningrearing_obsrvd_bt_access_a) AS length_spawningrearing_obsrvd_bt_access_a,
    (a.length_spawningrearing_obsrvd_bt_access_b - b.length_spawningrearing_obsrvd_bt_access_b) AS length_spawningrearing_obsrvd_bt_access_b,
    (a.length_spawningrearing_model_bt - b.length_spawningrearing_model_bt) AS length_spawningrearing_model_bt,
    (a.length_spawningrearing_model_bt_access_a - b.length_spawningrearing_model_bt_access_a) AS length_spawningrearing_model_bt_access_a,
    (a.length_spawningrearing_model_bt_access_b - b.length_spawningrearing_model_bt_access_b) AS length_spawningrearing_model_bt_access_b,
    (a.length_spawningrearing_obsrvd_ch - b.length_spawningrearing_obsrvd_ch) AS length_spawningrearing_obsrvd_ch,
    (a.length_spawningrearing_obsrvd_ch_access_a - b.length_spawningrearing_obsrvd_ch_access_a) AS length_spawningrearing_obsrvd_ch_access_a,
    (a.length_spawningrearing_obsrvd_ch_access_b - b.length_spawningrearing_obsrvd_ch_access_b) AS length_spawningrearing_obsrvd_ch_access_b,
    (a.length_spawningrearing_model_ch - b.length_spawningrearing_model_ch) AS length_spawningrearing_model_ch,
    (a.length_spawningrearing_model_ch_access_a - b.length_spawningrearing_model_ch_access_a) AS length_spawningrearing_model_ch_access_a,
    (a.length_spawningrearing_model_ch_access_b - b.length_spawningrearing_model_ch_access_b) AS length_spawningrearing_model_ch_access_b,
    (a.length_spawningrearing_obsrvd_cm - b.length_spawningrearing_obsrvd_cm) AS length_spawningrearing_obsrvd_cm,
    (a.length_spawningrearing_obsrvd_cm_access_a - b.length_spawningrearing_obsrvd_cm_access_a) AS length_spawningrearing_obsrvd_cm_access_a,
    (a.length_spawningrearing_obsrvd_cm_access_b - b.length_spawningrearing_obsrvd_cm_access_b) AS length_spawningrearing_obsrvd_cm_access_b,
    (a.length_spawningrearing_model_cm - b.length_spawningrearing_model_cm) AS length_spawningrearing_model_cm,
    (a.length_spawningrearing_model_cm_access_a - b.length_spawningrearing_model_cm_access_a) AS length_spawningrearing_model_cm_access_a,
    (a.length_spawningrearing_model_cm_access_b - b.length_spawningrearing_model_cm_access_b) AS length_spawningrearing_model_cm_access_b,
    (a.length_spawningrearing_obsrvd_co - b.length_spawningrearing_obsrvd_co) AS length_spawningrearing_obsrvd_co,
    (a.length_spawningrearing_obsrvd_co_access_a - b.length_spawningrearing_obsrvd_co_access_a) AS length_spawningrearing_obsrvd_co_access_a,
    (a.length_spawningrearing_obsrvd_co_access_b - b.length_spawningrearing_obsrvd_co_access_b) AS length_spawningrearing_obsrvd_co_access_b,
    (a.length_spawningrearing_model_co - b.length_spawningrearing_model_co) AS length_spawningrearing_model_co,
    (a.length_spawningrearing_model_co_access_a - b.length_spawningrearing_model_co_access_a) AS length_spawningrearing_model_co_access_a,
    (a.length_spawningrearing_model_co_access_b - b.length_spawningrearing_model_co_access_b) AS length_spawningrearing_model_co_access_b,
    (a.length_spawningrearing_obsrvd_pk - b.length_spawningrearing_obsrvd_pk) AS length_spawningrearing_obsrvd_pk,
    (a.length_spawningrearing_obsrvd_pk_access_a - b.length_spawningrearing_obsrvd_pk_access_a) AS length_spawningrearing_obsrvd_pk_access_a,
    (a.length_spawningrearing_obsrvd_pk_access_b - b.length_spawningrearing_obsrvd_pk_access_b) AS length_spawningrearing_obsrvd_pk_access_b,
    (a.length_spawningrearing_model_pk - b.length_spawningrearing_model_pk) AS length_spawningrearing_model_pk,
    (a.length_spawningrearing_model_pk_access_a - b.length_spawningrearing_model_pk_access_a) AS length_spawningrearing_model_pk_access_a,
    (a.length_spawningrearing_model_pk_access_b - b.length_spawningrearing_model_pk_access_b) AS length_spawningrearing_model_pk_access_b,
    (a.length_spawningrearing_obsrvd_sk - b.length_spawningrearing_obsrvd_sk) AS length_spawningrearing_obsrvd_sk,
    (a.length_spawningrearing_obsrvd_sk_access_a - b.length_spawningrearing_obsrvd_sk_access_a) AS length_spawningrearing_obsrvd_sk_access_a,
    (a.length_spawningrearing_obsrvd_sk_access_b - b.length_spawningrearing_obsrvd_sk_access_b) AS length_spawningrearing_obsrvd_sk_access_b,
    (a.length_spawningrearing_model_sk - b.length_spawningrearing_model_sk) AS length_spawningrearing_model_sk,
    (a.length_spawningrearing_model_sk_access_a - b.length_spawningrearing_model_sk_access_a) AS length_spawningrearing_model_sk_access_a,
    (a.length_spawningrearing_model_sk_access_b - b.length_spawningrearing_model_sk_access_b) AS length_spawningrearing_model_sk_access_b,
    (a.length_spawningrearing_obsrvd_st - b.length_spawningrearing_obsrvd_st) AS length_spawningrearing_obsrvd_st,
    (a.length_spawningrearing_obsrvd_st_access_a - b.length_spawningrearing_obsrvd_st_access_a) AS length_spawningrearing_obsrvd_st_access_a,
    (a.length_spawningrearing_obsrvd_st_access_b - b.length_spawningrearing_obsrvd_st_access_b) AS length_spawningrearing_obsrvd_st_access_b,
    (a.length_spawningrearing_model_st - b.length_spawningrearing_model_st) AS length_spawningrearing_model_st,
    (a.length_spawningrearing_model_st_access_a - b.length_spawningrearing_model_st_access_a) AS length_spawningrearing_model_st_access_a,
    (a.length_spawningrearing_model_st_access_b - b.length_spawningrearing_model_st_access_b) AS length_spawningrearing_model_st_access_b,
    (a.length_spawningrearing_obsrvd_wct - b.length_spawningrearing_obsrvd_wct) AS length_spawningrearing_obsrvd_wct,
    (a.length_spawningrearing_obsrvd_wct_access_a - b.length_spawningrearing_obsrvd_wct_access_a) AS length_spawningrearing_obsrvd_wct_access_a,
    (a.length_spawningrearing_obsrvd_wct_access_b - b.length_spawningrearing_obsrvd_wct_access_b) AS length_spawningrearing_obsrvd_wct_access_b,
    (a.length_spawningrearing_model_wct - b.length_spawningrearing_model_wct) AS length_spawningrearing_model_wct,
    (a.length_spawningrearing_model_wct_access_a - b.length_spawningrearing_model_wct_access_a) AS length_spawningrearing_model_wct_access_a,
    (a.length_spawningrearing_model_wct_access_b - b.length_spawningrearing_model_wct_access_b) AS length_spawningrearing_model_wct_access_b,
    (a.length_spawningrearing_obsrvd_salmon - b.length_spawningrearing_obsrvd_salmon) AS length_spawningrearing_obsrvd_salmon,
    (a.length_spawningrearing_obsrvd_salmon_access_a - b.length_spawningrearing_obsrvd_salmon_access_a) AS length_spawningrearing_obsrvd_salmon_access_a,
    (a.length_spawningrearing_obsrvd_salmon_access_b - b.length_spawningrearing_obsrvd_salmon_access_b) AS length_spawningrearing_obsrvd_salmon_access_b,
    (a.length_spawningrearing_model_salmon - b.length_spawningrearing_model_salmon) AS length_spawningrearing_model_salmon,
    (a.length_spawningrearing_model_salmon_access_a - b.length_spawningrearing_model_salmon_access_a) AS length_spawningrearing_model_salmon_access_a,
    (a.length_spawningrearing_model_salmon_access_b - b.length_spawningrearing_model_salmon_access_b) AS length_spawningrearing_model_salmon_access_b,
    (a.length_spawningrearing_obsrvd_salmon_st - b.length_spawningrearing_obsrvd_salmon_st) AS length_spawningrearing_obsrvd_salmon_st,
    (a.length_spawningrearing_obsrvd_salmon_st_access_a - b.length_spawningrearing_obsrvd_salmon_st_access_a) AS length_spawningrearing_obsrvd_salmon_st_access_a,
    (a.length_spawningrearing_obsrvd_salmon_st_access_b - b.length_spawningrearing_obsrvd_salmon_st_access_b) AS length_spawningrearing_obsrvd_salmon_st_access_b,
    (a.length_spawningrearing_model_salmon_st - b.length_spawningrearing_model_salmon_st) AS length_spawningrearing_model_salmon_st,
    (a.length_spawningrearing_model_salmon_st_access_a - b.length_spawningrearing_model_salmon_st_access_a) AS length_spawningrearing_model_salmon_st_access_a,
    (a.length_spawningrearing_model_salmon_st_access_b - b.length_spawningrearing_model_salmon_st_access_b) AS length_spawningrearing_model_salmon_st_access_b,
    (a.pct_naturallyaccessible_bt_access_b - b.pct_naturallyaccessible_bt_access_b) AS pct_naturallyaccessible_bt_access_b,
    (a.pct_naturallyaccessible_ch_access_b - b.pct_naturallyaccessible_ch_access_b) AS pct_naturallyaccessible_ch_access_b,
    (a.pct_naturallyaccessible_cm_access_b - b.pct_naturallyaccessible_cm_access_b) AS pct_naturallyaccessible_cm_access_b,
    (a.pct_naturallyaccessible_co_access_b - b.pct_naturallyaccessible_co_access_b) AS pct_naturallyaccessible_co_access_b,
    (a.pct_naturallyaccessible_pk_access_b - b.pct_naturallyaccessible_pk_access_b) AS pct_naturallyaccessible_pk_access_b,
    (a.pct_naturallyaccessible_sk_access_b - b.pct_naturallyaccessible_sk_access_b) AS pct_naturallyaccessible_sk_access_b,
    (a.pct_naturallyaccessible_salmon_access_b - b.pct_naturallyaccessible_salmon_access_b) AS pct_naturallyaccessible_salmon_access_b,
    (a.pct_naturallyaccessible_st_access_b - b.pct_naturallyaccessible_st_access_b) AS pct_naturallyaccessible_st_access_b,
    (a.pct_naturallyaccessible_wct_access_b - b.pct_naturallyaccessible_wct_access_b) AS pct_naturallyaccessible_wct_access_b,
    (a.pct_spawningrearing_bt_access_b - b.pct_spawningrearing_bt_access_b) AS pct_spawningrearing_bt_access_b,
    (a.pct_spawningrearing_ch_access_b - b.pct_spawningrearing_ch_access_b) AS pct_spawningrearing_ch_access_b,
    (a.pct_spawningrearing_cm_access_b - b.pct_spawningrearing_cm_access_b) AS pct_spawningrearing_cm_access_b,
    (a.pct_spawningrearing_co_access_b - b.pct_spawningrearing_co_access_b) AS pct_spawningrearing_co_access_b,
    (a.pct_spawningrearing_pk_access_b - b.pct_spawningrearing_pk_access_b) AS pct_spawningrearing_pk_access_b,
    (a.pct_spawningrearing_sk_access_b - b.pct_spawningrearing_sk_access_b) AS pct_spawningrearing_sk_access_b,
    (a.pct_spawningrearing_st_access_b - b.pct_spawningrearing_st_access_b) AS pct_spawningrearing_st_access_b,
    (a.pct_spawningrearing_wct_access_b - b.pct_spawningrearing_wct_access_b) AS pct_spawningrearing_wct_access_b,
    (a.pct_spawningrearing_salmon_access_b - b.pct_spawningrearing_salmon_access_b) AS pct_spawningrearing_salmon_access_b,
    (a.pct_spawningrearing_salmon_st_access_b - b.pct_spawningrearing_salmon_st_access_b) AS pct_spawningrearing_salmon_st_access_b
   FROM (bcfishpass.wsg_linear_summary_current a
     JOIN bcfishpass.wsg_linear_summary_previous b ON (((a.watershed_group_code)::text = (b.watershed_group_code)::text)))
  ORDER BY a.watershed_group_code;


--
-- Name: wsg_species_presence; Type: TABLE; Schema: bcfishpass; Owner: -
--

CREATE TABLE bcfishpass.wsg_species_presence (
    watershed_group_code character varying(4),
    bt boolean,
    ch boolean,
    cm boolean,
    co boolean,
    ct boolean,
    dv boolean,
    gr boolean,
    pk boolean,
    rb boolean,
    sk boolean,
    st boolean,
    wct boolean,
    notes text
);


--
-- Name: log model_run_id; Type: DEFAULT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.log ALTER COLUMN model_run_id SET DEFAULT nextval('bcfishpass.log_model_run_id_seq'::regclass);


--
-- Name: modelled_stream_crossings modelled_crossing_id; Type: DEFAULT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.modelled_stream_crossings ALTER COLUMN modelled_crossing_id SET DEFAULT nextval('bcfishpass.modelled_stream_crossings_modelled_crossing_id_seq'::regclass);


--
-- Name: barriers_anthropogenic barriers_anthropogenic_blue_line_key_downstream_route_measu_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_anthropogenic
    ADD CONSTRAINT barriers_anthropogenic_blue_line_key_downstream_route_measu_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_anthropogenic_dnstr_barriers_anthropogenic barriers_anthropogenic_dnstr_barriers_anthropogenic_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_anthropogenic_dnstr_barriers_anthropogenic
    ADD CONSTRAINT barriers_anthropogenic_dnstr_barriers_anthropogenic_pkey PRIMARY KEY (barriers_anthropogenic_id);


--
-- Name: barriers_anthropogenic barriers_anthropogenic_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_anthropogenic
    ADD CONSTRAINT barriers_anthropogenic_pkey PRIMARY KEY (barriers_anthropogenic_id);


--
-- Name: barriers_bt barriers_bt_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_bt
    ADD CONSTRAINT barriers_bt_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_bt barriers_bt_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_bt
    ADD CONSTRAINT barriers_bt_pkey PRIMARY KEY (barriers_bt_id);


--
-- Name: barriers_ch_cm_co_pk_sk barriers_ch_cm_co_pk_sk_blue_line_key_downstream_route_meas_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_ch_cm_co_pk_sk
    ADD CONSTRAINT barriers_ch_cm_co_pk_sk_blue_line_key_downstream_route_meas_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_ch_cm_co_pk_sk barriers_ch_cm_co_pk_sk_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_ch_cm_co_pk_sk
    ADD CONSTRAINT barriers_ch_cm_co_pk_sk_pkey PRIMARY KEY (barriers_ch_cm_co_pk_sk_id);


--
-- Name: barriers_ct_dv_rb barriers_ct_dv_rb_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_ct_dv_rb
    ADD CONSTRAINT barriers_ct_dv_rb_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_ct_dv_rb barriers_ct_dv_rb_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_ct_dv_rb
    ADD CONSTRAINT barriers_ct_dv_rb_pkey PRIMARY KEY (barriers_ct_dv_rb_id);


--
-- Name: barriers_dams barriers_dams_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_dams
    ADD CONSTRAINT barriers_dams_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_dams_hydro barriers_dams_hydro_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_dams_hydro
    ADD CONSTRAINT barriers_dams_hydro_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_dams_hydro barriers_dams_hydro_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_dams_hydro
    ADD CONSTRAINT barriers_dams_hydro_pkey PRIMARY KEY (barriers_dams_hydro_id);


--
-- Name: barriers_dams barriers_dams_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_dams
    ADD CONSTRAINT barriers_dams_pkey PRIMARY KEY (barriers_dams_id);


--
-- Name: barriers_falls barriers_falls_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_falls
    ADD CONSTRAINT barriers_falls_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_falls barriers_falls_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_falls
    ADD CONSTRAINT barriers_falls_pkey PRIMARY KEY (barriers_falls_id);


--
-- Name: barriers_gradient barriers_gradient_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_gradient
    ADD CONSTRAINT barriers_gradient_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_gradient barriers_gradient_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_gradient
    ADD CONSTRAINT barriers_gradient_pkey PRIMARY KEY (barriers_gradient_id);


--
-- Name: barriers_pscis barriers_pscis_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_pscis
    ADD CONSTRAINT barriers_pscis_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_pscis barriers_pscis_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_pscis
    ADD CONSTRAINT barriers_pscis_pkey PRIMARY KEY (barriers_pscis_id);


--
-- Name: barriers_remediations barriers_remediations_blue_line_key_downstream_route_measur_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_remediations
    ADD CONSTRAINT barriers_remediations_blue_line_key_downstream_route_measur_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_remediations barriers_remediations_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_remediations
    ADD CONSTRAINT barriers_remediations_pkey PRIMARY KEY (barriers_remediations_id);


--
-- Name: barriers_st barriers_st_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_st
    ADD CONSTRAINT barriers_st_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_st barriers_st_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_st
    ADD CONSTRAINT barriers_st_pkey PRIMARY KEY (barriers_st_id);


--
-- Name: barriers_subsurfaceflow barriers_subsurfaceflow_blue_line_key_downstream_route_meas_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_subsurfaceflow
    ADD CONSTRAINT barriers_subsurfaceflow_blue_line_key_downstream_route_meas_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_subsurfaceflow barriers_subsurfaceflow_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_subsurfaceflow
    ADD CONSTRAINT barriers_subsurfaceflow_pkey PRIMARY KEY (barriers_subsurfaceflow_id);


--
-- Name: barriers_user_definite barriers_user_definite_blue_line_key_downstream_route_measu_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_user_definite
    ADD CONSTRAINT barriers_user_definite_blue_line_key_downstream_route_measu_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_user_definite barriers_user_definite_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_user_definite
    ADD CONSTRAINT barriers_user_definite_pkey PRIMARY KEY (barriers_user_definite_id);


--
-- Name: barriers_wct barriers_wct_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_wct
    ADD CONSTRAINT barriers_wct_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: barriers_wct barriers_wct_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.barriers_wct
    ADD CONSTRAINT barriers_wct_pkey PRIMARY KEY (barriers_wct_id);


--
-- Name: cabd_additions cabd_additions_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.cabd_additions
    ADD CONSTRAINT cabd_additions_pkey PRIMARY KEY (blue_line_key, downstream_route_measure);


--
-- Name: cabd_exclusions cabd_exclusions_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.cabd_exclusions
    ADD CONSTRAINT cabd_exclusions_pkey PRIMARY KEY (cabd_id);


--
-- Name: cabd_passability_status_updates cabd_passability_status_updates_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.cabd_passability_status_updates
    ADD CONSTRAINT cabd_passability_status_updates_pkey PRIMARY KEY (cabd_id);


--
-- Name: crossings crossings_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings
    ADD CONSTRAINT crossings_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: crossings_dnstr_barriers_anthropogenic crossings_dnstr_barriers_anthropogenic_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings_dnstr_barriers_anthropogenic
    ADD CONSTRAINT crossings_dnstr_barriers_anthropogenic_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: crossings_dnstr_crossings crossings_dnstr_crossings_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings_dnstr_crossings
    ADD CONSTRAINT crossings_dnstr_crossings_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: crossings_dnstr_observations crossings_dnstr_observations_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings_dnstr_observations
    ADD CONSTRAINT crossings_dnstr_observations_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: crossings crossings_modelled_crossing_id_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings
    ADD CONSTRAINT crossings_modelled_crossing_id_key UNIQUE (modelled_crossing_id);


--
-- Name: crossings crossings_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings
    ADD CONSTRAINT crossings_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: crossings crossings_stream_crossing_id_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings
    ADD CONSTRAINT crossings_stream_crossing_id_key UNIQUE (stream_crossing_id);


--
-- Name: crossings_upstr_barriers_anthropogenic crossings_upstr_barriers_anthropogenic_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings_upstr_barriers_anthropogenic
    ADD CONSTRAINT crossings_upstr_barriers_anthropogenic_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: crossings_upstr_observations crossings_upstr_observations_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings_upstr_observations
    ADD CONSTRAINT crossings_upstr_observations_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: crossings_upstream_access crossings_upstream_access_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings_upstream_access
    ADD CONSTRAINT crossings_upstream_access_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: crossings_upstream_habitat crossings_upstream_habitat_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings_upstream_habitat
    ADD CONSTRAINT crossings_upstream_habitat_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: crossings_upstream_habitat_wcrp crossings_upstream_habitat_wcrp_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings_upstream_habitat_wcrp
    ADD CONSTRAINT crossings_upstream_habitat_wcrp_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: crossings crossings_user_barrier_anthropogenic_id_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.crossings
    ADD CONSTRAINT crossings_user_barrier_anthropogenic_id_key UNIQUE (user_crossing_misc_id);


--
-- Name: dams dams_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.dams
    ADD CONSTRAINT dams_pkey PRIMARY KEY (dam_id);


--
-- Name: dfo_known_sockeye_lakes dfo_known_sockeye_lakes_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.dfo_known_sockeye_lakes
    ADD CONSTRAINT dfo_known_sockeye_lakes_pkey PRIMARY KEY (waterbody_poly_id);


--
-- Name: falls falls_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.falls
    ADD CONSTRAINT falls_pkey PRIMARY KEY (falls_id);


--
-- Name: gradient_barriers gradient_barriers_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.gradient_barriers
    ADD CONSTRAINT gradient_barriers_pkey PRIMARY KEY (gradient_barrier_id);


--
-- Name: habitat_linear_bt habitat_linear_bt_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.habitat_linear_bt
    ADD CONSTRAINT habitat_linear_bt_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: habitat_linear_ch habitat_linear_ch_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.habitat_linear_ch
    ADD CONSTRAINT habitat_linear_ch_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: habitat_linear_cm habitat_linear_cm_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.habitat_linear_cm
    ADD CONSTRAINT habitat_linear_cm_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: habitat_linear_co habitat_linear_co_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.habitat_linear_co
    ADD CONSTRAINT habitat_linear_co_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: habitat_linear_pk habitat_linear_pk_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.habitat_linear_pk
    ADD CONSTRAINT habitat_linear_pk_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: habitat_linear_sk habitat_linear_sk_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.habitat_linear_sk
    ADD CONSTRAINT habitat_linear_sk_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: habitat_linear_st habitat_linear_st_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.habitat_linear_st
    ADD CONSTRAINT habitat_linear_st_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: habitat_linear_wct habitat_linear_wct_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.habitat_linear_wct
    ADD CONSTRAINT habitat_linear_wct_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: log_objectstorage log_objectstorage_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.log_objectstorage
    ADD CONSTRAINT log_objectstorage_pkey PRIMARY KEY (model_run_id, object_name);


--
-- Name: log log_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (model_run_id);


--
-- Name: log_replication log_replication_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.log_replication
    ADD CONSTRAINT log_replication_pkey PRIMARY KEY (object_name);


--
-- Name: modelled_stream_crossings modelled_stream_crossings_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.modelled_stream_crossings
    ADD CONSTRAINT modelled_stream_crossings_pkey PRIMARY KEY (modelled_crossing_id);


--
-- Name: observation_exclusions observation_exclusions_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.observation_exclusions
    ADD CONSTRAINT observation_exclusions_pkey PRIMARY KEY (observation_key);


--
-- Name: observations observations_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.observations
    ADD CONSTRAINT observations_pkey PRIMARY KEY (observation_key);


--
-- Name: pscis pscis_blue_line_key_downstream_route_measure_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.pscis
    ADD CONSTRAINT pscis_blue_line_key_downstream_route_measure_key UNIQUE (blue_line_key, downstream_route_measure);


--
-- Name: pscis_modelledcrossings_streams_xref pscis_modelledcrossings_streams_xref_modelled_crossing_id_key; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.pscis_modelledcrossings_streams_xref
    ADD CONSTRAINT pscis_modelledcrossings_streams_xref_modelled_crossing_id_key UNIQUE (modelled_crossing_id);


--
-- Name: pscis_modelledcrossings_streams_xref pscis_modelledcrossings_streams_xref_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.pscis_modelledcrossings_streams_xref
    ADD CONSTRAINT pscis_modelledcrossings_streams_xref_pkey PRIMARY KEY (stream_crossing_id);


--
-- Name: pscis_not_matched_to_streams pscis_not_matched_to_streams_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.pscis_not_matched_to_streams
    ADD CONSTRAINT pscis_not_matched_to_streams_pkey PRIMARY KEY (stream_crossing_id);


--
-- Name: pscis pscis_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.pscis
    ADD CONSTRAINT pscis_pkey PRIMARY KEY (stream_crossing_id);


--
-- Name: pscis_points_all pscis_points_all_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.pscis_points_all
    ADD CONSTRAINT pscis_points_all_pkey PRIMARY KEY (stream_crossing_id);


--
-- Name: qa_naturalbarriers_ch_cm_co_pk_sk_st qa_naturalbarriers_ch_cm_co_pk_sk_st_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.qa_naturalbarriers_ch_cm_co_pk_sk_st
    ADD CONSTRAINT qa_naturalbarriers_ch_cm_co_pk_sk_st_pkey PRIMARY KEY (barrier_id);


--
-- Name: qa_observations_ch_cm_co_pk_sk_st qa_observations_ch_cm_co_pk_sk_st_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.qa_observations_ch_cm_co_pk_sk_st
    ADD CONSTRAINT qa_observations_ch_cm_co_pk_sk_st_pkey PRIMARY KEY (observation_key);


--
-- Name: streams_access streams_access_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams_access
    ADD CONSTRAINT streams_access_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: streams_dnstr_barriers streams_dnstr_barriers_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams_dnstr_barriers
    ADD CONSTRAINT streams_dnstr_barriers_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: streams_dnstr_barriers_remediations streams_dnstr_barriers_remediations_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams_dnstr_barriers_remediations
    ADD CONSTRAINT streams_dnstr_barriers_remediations_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: streams_dnstr_crossings streams_dnstr_crossings_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams_dnstr_crossings
    ADD CONSTRAINT streams_dnstr_crossings_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: streams_dnstr_species streams_dnstr_species_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams_dnstr_species
    ADD CONSTRAINT streams_dnstr_species_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: streams_habitat_known streams_habitat_known_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams_habitat_known
    ADD CONSTRAINT streams_habitat_known_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: streams_habitat_linear streams_habitat_linear_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams_habitat_linear
    ADD CONSTRAINT streams_habitat_linear_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: streams_mapping_code streams_mapping_code_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams_mapping_code
    ADD CONSTRAINT streams_mapping_code_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: streams streams_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams
    ADD CONSTRAINT streams_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: streams_upstr_observations streams_upstr_observations_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.streams_upstr_observations
    ADD CONSTRAINT streams_upstr_observations_pkey PRIMARY KEY (segmented_stream_id);


--
-- Name: user_barriers_definite_control user_barriers_definite_control_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_barriers_definite_control
    ADD CONSTRAINT user_barriers_definite_control_pkey PRIMARY KEY (blue_line_key, downstream_route_measure);


--
-- Name: user_barriers_definite user_barriers_definite_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_barriers_definite
    ADD CONSTRAINT user_barriers_definite_pkey PRIMARY KEY (blue_line_key, downstream_route_measure);


--
-- Name: user_crossings_misc user_crossings_misc_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_crossings_misc
    ADD CONSTRAINT user_crossings_misc_pkey PRIMARY KEY (user_crossing_misc_id);


--
-- Name: user_habitat_classification_endpoints user_habitat_classification_endpoints_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_habitat_classification_endpoints
    ADD CONSTRAINT user_habitat_classification_endpoints_pkey PRIMARY KEY (blue_line_key, downstream_route_measure);


--
-- Name: user_habitat_classification user_habitat_classification_temp_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_habitat_classification
    ADD CONSTRAINT user_habitat_classification_temp_pkey PRIMARY KEY (blue_line_key, downstream_route_measure, upstream_route_measure, species_code);


--
-- Name: user_habitat_codes user_habitat_codes_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_habitat_codes
    ADD CONSTRAINT user_habitat_codes_pkey PRIMARY KEY (habitat_code);


--
-- Name: user_modelled_crossing_fixes user_modelled_crossing_fixes_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_modelled_crossing_fixes
    ADD CONSTRAINT user_modelled_crossing_fixes_pkey PRIMARY KEY (modelled_crossing_id);


--
-- Name: user_pscis_barrier_status user_pscis_barrier_status_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_pscis_barrier_status
    ADD CONSTRAINT user_pscis_barrier_status_pkey PRIMARY KEY (stream_crossing_id);


--
-- Name: wcrp_confirmed_barriers wcrp_confirmed_barriers_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.wcrp_confirmed_barriers
    ADD CONSTRAINT wcrp_confirmed_barriers_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: wcrp_data_deficient_structures wcrp_data_deficient_structures_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.wcrp_data_deficient_structures
    ADD CONSTRAINT wcrp_data_deficient_structures_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: wcrp_excluded_structures wcrp_excluded_structures_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.wcrp_excluded_structures
    ADD CONSTRAINT wcrp_excluded_structures_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: wcrp_ranked_barriers wcrp_ranked_barriers_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.wcrp_ranked_barriers
    ADD CONSTRAINT wcrp_ranked_barriers_pkey PRIMARY KEY (aggregated_crossings_id);


--
-- Name: wcrp_rehabilitiated_structures wcrp_rehabilitiated_structures_pkey; Type: CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.wcrp_rehabilitiated_structures
    ADD CONSTRAINT wcrp_rehabilitiated_structures_pkey PRIMARY KEY (aggregated_crossing_id);


--
-- Name: br_anthropogenic_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_blk_meas_idx ON bcfishpass.barriers_anthropogenic USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_anthropogenic_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_blue_line_key_idx ON bcfishpass.barriers_anthropogenic USING btree (blue_line_key);


--
-- Name: br_anthropogenic_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_geom_idx ON bcfishpass.barriers_anthropogenic USING gist (geom);


--
-- Name: br_anthropogenic_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_linear_feature_id_idx ON bcfishpass.barriers_anthropogenic USING btree (linear_feature_id);


--
-- Name: br_anthropogenic_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_localcode_ltree_bidx ON bcfishpass.barriers_anthropogenic USING btree (localcode_ltree);


--
-- Name: br_anthropogenic_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_localcode_ltree_gidx ON bcfishpass.barriers_anthropogenic USING gist (localcode_ltree);


--
-- Name: br_anthropogenic_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_watershed_group_code_idx ON bcfishpass.barriers_anthropogenic USING btree (watershed_group_code);


--
-- Name: br_anthropogenic_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_wscode_ltree_bidx ON bcfishpass.barriers_anthropogenic USING btree (wscode_ltree);


--
-- Name: br_anthropogenic_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_wscode_ltree_gidx ON bcfishpass.barriers_anthropogenic USING gist (wscode_ltree);


--
-- Name: br_anthropogenic_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_anthropogenic_wskey_idx ON bcfishpass.barriers_anthropogenic USING btree (watershed_key);


--
-- Name: br_bt_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_blk_meas_idx ON bcfishpass.barriers_bt USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_bt_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_blue_line_key_idx ON bcfishpass.barriers_bt USING btree (blue_line_key);


--
-- Name: br_bt_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_geom_idx ON bcfishpass.barriers_bt USING gist (geom);


--
-- Name: br_bt_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_linear_feature_id_idx ON bcfishpass.barriers_bt USING btree (linear_feature_id);


--
-- Name: br_bt_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_localcode_ltree_bidx ON bcfishpass.barriers_bt USING btree (localcode_ltree);


--
-- Name: br_bt_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_localcode_ltree_gidx ON bcfishpass.barriers_bt USING gist (localcode_ltree);


--
-- Name: br_bt_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_watershed_group_code_idx ON bcfishpass.barriers_bt USING btree (watershed_group_code);


--
-- Name: br_bt_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_wscode_ltree_bidx ON bcfishpass.barriers_bt USING btree (wscode_ltree);


--
-- Name: br_bt_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_wscode_ltree_gidx ON bcfishpass.barriers_bt USING gist (wscode_ltree);


--
-- Name: br_bt_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_bt_wskey_idx ON bcfishpass.barriers_bt USING btree (watershed_key);


--
-- Name: br_ch_cm_co_pk_sk_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_blk_meas_idx ON bcfishpass.barriers_ch_cm_co_pk_sk USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_ch_cm_co_pk_sk_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_blue_line_key_idx ON bcfishpass.barriers_ch_cm_co_pk_sk USING btree (blue_line_key);


--
-- Name: br_ch_cm_co_pk_sk_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_geom_idx ON bcfishpass.barriers_ch_cm_co_pk_sk USING gist (geom);


--
-- Name: br_ch_cm_co_pk_sk_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_linear_feature_id_idx ON bcfishpass.barriers_ch_cm_co_pk_sk USING btree (linear_feature_id);


--
-- Name: br_ch_cm_co_pk_sk_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_localcode_ltree_bidx ON bcfishpass.barriers_ch_cm_co_pk_sk USING btree (localcode_ltree);


--
-- Name: br_ch_cm_co_pk_sk_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_localcode_ltree_gidx ON bcfishpass.barriers_ch_cm_co_pk_sk USING gist (localcode_ltree);


--
-- Name: br_ch_cm_co_pk_sk_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_watershed_group_code_idx ON bcfishpass.barriers_ch_cm_co_pk_sk USING btree (watershed_group_code);


--
-- Name: br_ch_cm_co_pk_sk_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_wscode_ltree_bidx ON bcfishpass.barriers_ch_cm_co_pk_sk USING btree (wscode_ltree);


--
-- Name: br_ch_cm_co_pk_sk_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_wscode_ltree_gidx ON bcfishpass.barriers_ch_cm_co_pk_sk USING gist (wscode_ltree);


--
-- Name: br_ch_cm_co_pk_sk_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ch_cm_co_pk_sk_wskey_idx ON bcfishpass.barriers_ch_cm_co_pk_sk USING btree (watershed_key);


--
-- Name: br_ct_dv_rb_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_blk_meas_idx ON bcfishpass.barriers_ct_dv_rb USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_ct_dv_rb_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_blue_line_key_idx ON bcfishpass.barriers_ct_dv_rb USING btree (blue_line_key);


--
-- Name: br_ct_dv_rb_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_geom_idx ON bcfishpass.barriers_ct_dv_rb USING gist (geom);


--
-- Name: br_ct_dv_rb_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_linear_feature_id_idx ON bcfishpass.barriers_ct_dv_rb USING btree (linear_feature_id);


--
-- Name: br_ct_dv_rb_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_localcode_ltree_bidx ON bcfishpass.barriers_ct_dv_rb USING btree (localcode_ltree);


--
-- Name: br_ct_dv_rb_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_localcode_ltree_gidx ON bcfishpass.barriers_ct_dv_rb USING gist (localcode_ltree);


--
-- Name: br_ct_dv_rb_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_watershed_group_code_idx ON bcfishpass.barriers_ct_dv_rb USING btree (watershed_group_code);


--
-- Name: br_ct_dv_rb_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_wscode_ltree_bidx ON bcfishpass.barriers_ct_dv_rb USING btree (wscode_ltree);


--
-- Name: br_ct_dv_rb_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_wscode_ltree_gidx ON bcfishpass.barriers_ct_dv_rb USING gist (wscode_ltree);


--
-- Name: br_ct_dv_rb_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_ct_dv_rb_wskey_idx ON bcfishpass.barriers_ct_dv_rb USING btree (watershed_key);


--
-- Name: br_dams_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_blk_meas_idx ON bcfishpass.barriers_dams USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_dams_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_blue_line_key_idx ON bcfishpass.barriers_dams USING btree (blue_line_key);


--
-- Name: br_dams_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_geom_idx ON bcfishpass.barriers_dams USING gist (geom);


--
-- Name: br_dams_hydro_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_blk_meas_idx ON bcfishpass.barriers_dams_hydro USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_dams_hydro_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_blue_line_key_idx ON bcfishpass.barriers_dams_hydro USING btree (blue_line_key);


--
-- Name: br_dams_hydro_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_geom_idx ON bcfishpass.barriers_dams_hydro USING gist (geom);


--
-- Name: br_dams_hydro_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_linear_feature_id_idx ON bcfishpass.barriers_dams_hydro USING btree (linear_feature_id);


--
-- Name: br_dams_hydro_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_localcode_ltree_bidx ON bcfishpass.barriers_dams_hydro USING btree (localcode_ltree);


--
-- Name: br_dams_hydro_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_localcode_ltree_gidx ON bcfishpass.barriers_dams_hydro USING gist (localcode_ltree);


--
-- Name: br_dams_hydro_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_watershed_group_code_idx ON bcfishpass.barriers_dams_hydro USING btree (watershed_group_code);


--
-- Name: br_dams_hydro_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_wscode_ltree_bidx ON bcfishpass.barriers_dams_hydro USING btree (wscode_ltree);


--
-- Name: br_dams_hydro_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_wscode_ltree_gidx ON bcfishpass.barriers_dams_hydro USING gist (wscode_ltree);


--
-- Name: br_dams_hydro_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_hydro_wskey_idx ON bcfishpass.barriers_dams_hydro USING btree (watershed_key);


--
-- Name: br_dams_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_linear_feature_id_idx ON bcfishpass.barriers_dams USING btree (linear_feature_id);


--
-- Name: br_dams_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_localcode_ltree_bidx ON bcfishpass.barriers_dams USING btree (localcode_ltree);


--
-- Name: br_dams_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_localcode_ltree_gidx ON bcfishpass.barriers_dams USING gist (localcode_ltree);


--
-- Name: br_dams_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_watershed_group_code_idx ON bcfishpass.barriers_dams USING btree (watershed_group_code);


--
-- Name: br_dams_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_wscode_ltree_bidx ON bcfishpass.barriers_dams USING btree (wscode_ltree);


--
-- Name: br_dams_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_wscode_ltree_gidx ON bcfishpass.barriers_dams USING gist (wscode_ltree);


--
-- Name: br_dams_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_dams_wskey_idx ON bcfishpass.barriers_dams USING btree (watershed_key);


--
-- Name: br_falls_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_blk_meas_idx ON bcfishpass.barriers_falls USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_falls_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_blue_line_key_idx ON bcfishpass.barriers_falls USING btree (blue_line_key);


--
-- Name: br_falls_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_geom_idx ON bcfishpass.barriers_falls USING gist (geom);


--
-- Name: br_falls_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_linear_feature_id_idx ON bcfishpass.barriers_falls USING btree (linear_feature_id);


--
-- Name: br_falls_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_localcode_ltree_bidx ON bcfishpass.barriers_falls USING btree (localcode_ltree);


--
-- Name: br_falls_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_localcode_ltree_gidx ON bcfishpass.barriers_falls USING gist (localcode_ltree);


--
-- Name: br_falls_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_watershed_group_code_idx ON bcfishpass.barriers_falls USING btree (watershed_group_code);


--
-- Name: br_falls_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_wscode_ltree_bidx ON bcfishpass.barriers_falls USING btree (wscode_ltree);


--
-- Name: br_falls_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_wscode_ltree_gidx ON bcfishpass.barriers_falls USING gist (wscode_ltree);


--
-- Name: br_falls_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_falls_wskey_idx ON bcfishpass.barriers_falls USING btree (watershed_key);


--
-- Name: br_gradient_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_blk_meas_idx ON bcfishpass.barriers_gradient USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_gradient_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_blue_line_key_idx ON bcfishpass.barriers_gradient USING btree (blue_line_key);


--
-- Name: br_gradient_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_geom_idx ON bcfishpass.barriers_gradient USING gist (geom);


--
-- Name: br_gradient_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_linear_feature_id_idx ON bcfishpass.barriers_gradient USING btree (linear_feature_id);


--
-- Name: br_gradient_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_localcode_ltree_bidx ON bcfishpass.barriers_gradient USING btree (localcode_ltree);


--
-- Name: br_gradient_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_localcode_ltree_gidx ON bcfishpass.barriers_gradient USING gist (localcode_ltree);


--
-- Name: br_gradient_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_watershed_group_code_idx ON bcfishpass.barriers_gradient USING btree (watershed_group_code);


--
-- Name: br_gradient_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_wscode_ltree_bidx ON bcfishpass.barriers_gradient USING btree (wscode_ltree);


--
-- Name: br_gradient_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_wscode_ltree_gidx ON bcfishpass.barriers_gradient USING gist (wscode_ltree);


--
-- Name: br_gradient_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_gradient_wskey_idx ON bcfishpass.barriers_gradient USING btree (watershed_key);


--
-- Name: br_pscis_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_blk_meas_idx ON bcfishpass.barriers_pscis USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_pscis_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_blue_line_key_idx ON bcfishpass.barriers_pscis USING btree (blue_line_key);


--
-- Name: br_pscis_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_geom_idx ON bcfishpass.barriers_pscis USING gist (geom);


--
-- Name: br_pscis_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_linear_feature_id_idx ON bcfishpass.barriers_pscis USING btree (linear_feature_id);


--
-- Name: br_pscis_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_localcode_ltree_bidx ON bcfishpass.barriers_pscis USING btree (localcode_ltree);


--
-- Name: br_pscis_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_localcode_ltree_gidx ON bcfishpass.barriers_pscis USING gist (localcode_ltree);


--
-- Name: br_pscis_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_watershed_group_code_idx ON bcfishpass.barriers_pscis USING btree (watershed_group_code);


--
-- Name: br_pscis_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_wscode_ltree_bidx ON bcfishpass.barriers_pscis USING btree (wscode_ltree);


--
-- Name: br_pscis_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_wscode_ltree_gidx ON bcfishpass.barriers_pscis USING gist (wscode_ltree);


--
-- Name: br_pscis_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_pscis_wskey_idx ON bcfishpass.barriers_pscis USING btree (watershed_key);


--
-- Name: br_remediations_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_blk_meas_idx ON bcfishpass.barriers_remediations USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_remediations_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_blue_line_key_idx ON bcfishpass.barriers_remediations USING btree (blue_line_key);


--
-- Name: br_remediations_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_geom_idx ON bcfishpass.barriers_remediations USING gist (geom);


--
-- Name: br_remediations_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_linear_feature_id_idx ON bcfishpass.barriers_remediations USING btree (linear_feature_id);


--
-- Name: br_remediations_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_localcode_ltree_bidx ON bcfishpass.barriers_remediations USING btree (localcode_ltree);


--
-- Name: br_remediations_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_localcode_ltree_gidx ON bcfishpass.barriers_remediations USING gist (localcode_ltree);


--
-- Name: br_remediations_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_watershed_group_code_idx ON bcfishpass.barriers_remediations USING btree (watershed_group_code);


--
-- Name: br_remediations_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_wscode_ltree_bidx ON bcfishpass.barriers_remediations USING btree (wscode_ltree);


--
-- Name: br_remediations_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_wscode_ltree_gidx ON bcfishpass.barriers_remediations USING gist (wscode_ltree);


--
-- Name: br_remediations_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_remediations_wskey_idx ON bcfishpass.barriers_remediations USING btree (watershed_key);


--
-- Name: br_st_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_blk_meas_idx ON bcfishpass.barriers_st USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_st_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_blue_line_key_idx ON bcfishpass.barriers_st USING btree (blue_line_key);


--
-- Name: br_st_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_geom_idx ON bcfishpass.barriers_st USING gist (geom);


--
-- Name: br_st_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_linear_feature_id_idx ON bcfishpass.barriers_st USING btree (linear_feature_id);


--
-- Name: br_st_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_localcode_ltree_bidx ON bcfishpass.barriers_st USING btree (localcode_ltree);


--
-- Name: br_st_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_localcode_ltree_gidx ON bcfishpass.barriers_st USING gist (localcode_ltree);


--
-- Name: br_st_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_watershed_group_code_idx ON bcfishpass.barriers_st USING btree (watershed_group_code);


--
-- Name: br_st_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_wscode_ltree_bidx ON bcfishpass.barriers_st USING btree (wscode_ltree);


--
-- Name: br_st_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_wscode_ltree_gidx ON bcfishpass.barriers_st USING gist (wscode_ltree);


--
-- Name: br_st_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_st_wskey_idx ON bcfishpass.barriers_st USING btree (watershed_key);


--
-- Name: br_subsurfaceflow_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_blk_meas_idx ON bcfishpass.barriers_subsurfaceflow USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_subsurfaceflow_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_blue_line_key_idx ON bcfishpass.barriers_subsurfaceflow USING btree (blue_line_key);


--
-- Name: br_subsurfaceflow_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_geom_idx ON bcfishpass.barriers_subsurfaceflow USING gist (geom);


--
-- Name: br_subsurfaceflow_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_linear_feature_id_idx ON bcfishpass.barriers_subsurfaceflow USING btree (linear_feature_id);


--
-- Name: br_subsurfaceflow_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_localcode_ltree_bidx ON bcfishpass.barriers_subsurfaceflow USING btree (localcode_ltree);


--
-- Name: br_subsurfaceflow_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_localcode_ltree_gidx ON bcfishpass.barriers_subsurfaceflow USING gist (localcode_ltree);


--
-- Name: br_subsurfaceflow_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_watershed_group_code_idx ON bcfishpass.barriers_subsurfaceflow USING btree (watershed_group_code);


--
-- Name: br_subsurfaceflow_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_wscode_ltree_bidx ON bcfishpass.barriers_subsurfaceflow USING btree (wscode_ltree);


--
-- Name: br_subsurfaceflow_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_wscode_ltree_gidx ON bcfishpass.barriers_subsurfaceflow USING gist (wscode_ltree);


--
-- Name: br_subsurfaceflow_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_subsurfaceflow_wskey_idx ON bcfishpass.barriers_subsurfaceflow USING btree (watershed_key);


--
-- Name: br_user_definite_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_blk_meas_idx ON bcfishpass.barriers_user_definite USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_user_definite_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_blue_line_key_idx ON bcfishpass.barriers_user_definite USING btree (blue_line_key);


--
-- Name: br_user_definite_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_geom_idx ON bcfishpass.barriers_user_definite USING gist (geom);


--
-- Name: br_user_definite_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_linear_feature_id_idx ON bcfishpass.barriers_user_definite USING btree (linear_feature_id);


--
-- Name: br_user_definite_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_localcode_ltree_bidx ON bcfishpass.barriers_user_definite USING btree (localcode_ltree);


--
-- Name: br_user_definite_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_localcode_ltree_gidx ON bcfishpass.barriers_user_definite USING gist (localcode_ltree);


--
-- Name: br_user_definite_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_watershed_group_code_idx ON bcfishpass.barriers_user_definite USING btree (watershed_group_code);


--
-- Name: br_user_definite_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_wscode_ltree_bidx ON bcfishpass.barriers_user_definite USING btree (wscode_ltree);


--
-- Name: br_user_definite_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_wscode_ltree_gidx ON bcfishpass.barriers_user_definite USING gist (wscode_ltree);


--
-- Name: br_user_definite_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_user_definite_wskey_idx ON bcfishpass.barriers_user_definite USING btree (watershed_key);


--
-- Name: br_wct_blk_meas_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_blk_meas_idx ON bcfishpass.barriers_wct USING btree (blue_line_key, downstream_route_measure);


--
-- Name: br_wct_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_blue_line_key_idx ON bcfishpass.barriers_wct USING btree (blue_line_key);


--
-- Name: br_wct_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_geom_idx ON bcfishpass.barriers_wct USING gist (geom);


--
-- Name: br_wct_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_linear_feature_id_idx ON bcfishpass.barriers_wct USING btree (linear_feature_id);


--
-- Name: br_wct_localcode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_localcode_ltree_bidx ON bcfishpass.barriers_wct USING btree (localcode_ltree);


--
-- Name: br_wct_localcode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_localcode_ltree_gidx ON bcfishpass.barriers_wct USING gist (localcode_ltree);


--
-- Name: br_wct_watershed_group_code_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_watershed_group_code_idx ON bcfishpass.barriers_wct USING btree (watershed_group_code);


--
-- Name: br_wct_wscode_ltree_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_wscode_ltree_bidx ON bcfishpass.barriers_wct USING btree (wscode_ltree);


--
-- Name: br_wct_wscode_ltree_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_wscode_ltree_gidx ON bcfishpass.barriers_wct USING gist (wscode_ltree);


--
-- Name: br_wct_wskey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX br_wct_wskey_idx ON bcfishpass.barriers_wct USING btree (watershed_key);


--
-- Name: crossings_blk_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_blk_idx ON bcfishpass.crossings USING btree (blue_line_key);


--
-- Name: crossings_dam_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_dam_id_idx ON bcfishpass.crossings USING btree (dam_id);


--
-- Name: crossings_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_geom_idx ON bcfishpass.crossings USING gist (geom);


--
-- Name: crossings_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_linear_feature_id_idx ON bcfishpass.crossings USING btree (linear_feature_id);


--
-- Name: crossings_localcode_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_localcode_bidx ON bcfishpass.crossings USING btree (localcode_ltree);


--
-- Name: crossings_localcode_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_localcode_gidx ON bcfishpass.crossings USING gist (localcode_ltree);


--
-- Name: crossings_modelled_crossing_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_modelled_crossing_id_idx ON bcfishpass.crossings USING btree (modelled_crossing_id);


--
-- Name: crossings_stream_crossing_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_stream_crossing_id_idx ON bcfishpass.crossings USING btree (stream_crossing_id);


--
-- Name: crossings_vw_aggregated_crossings_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE UNIQUE INDEX crossings_vw_aggregated_crossings_id_idx ON bcfishpass.crossings_vw USING btree (aggregated_crossings_id);


--
-- Name: crossings_vw_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_vw_geom_idx ON bcfishpass.crossings_vw USING gist (geom);


--
-- Name: crossings_wscode_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_wscode_bidx ON bcfishpass.crossings USING btree (wscode_ltree);


--
-- Name: crossings_wscode_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_wscode_gidx ON bcfishpass.crossings USING gist (wscode_ltree);


--
-- Name: crossings_wsgcode_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_wsgcode_idx ON bcfishpass.crossings USING btree (watershed_group_code);


--
-- Name: crossings_wsk_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX crossings_wsk_idx ON bcfishpass.crossings USING btree (watershed_key);


--
-- Name: dams_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX dams_geom_idx ON bcfishpass.dams USING gist (geom);


--
-- Name: falls_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX falls_geom_idx ON bcfishpass.falls USING gist (geom);


--
-- Name: fptwg_summary_roads_vw_watershed_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX fptwg_summary_roads_vw_watershed_feature_id_idx ON bcfishpass.fptwg_summary_roads_vw USING btree (watershed_feature_id);


--
-- Name: fwa_assessment_watersheds_waterbodies__watershed_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX fwa_assessment_watersheds_waterbodies__watershed_feature_id_idx ON bcfishpass.fwa_assessment_watersheds_waterbodies_vw USING btree (watershed_feature_id);


--
-- Name: grdntbr_blk_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX grdntbr_blk_idx ON bcfishpass.gradient_barriers USING btree (blue_line_key);


--
-- Name: grdntbr_localcode_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX grdntbr_localcode_bidx ON bcfishpass.gradient_barriers USING btree (localcode_ltree);


--
-- Name: grdntbr_localcode_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX grdntbr_localcode_gidx ON bcfishpass.gradient_barriers USING gist (localcode_ltree);


--
-- Name: grdntbr_wscode_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX grdntbr_wscode_bidx ON bcfishpass.gradient_barriers USING btree (wscode_ltree);


--
-- Name: grdntbr_wscode_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX grdntbr_wscode_gidx ON bcfishpass.gradient_barriers USING gist (wscode_ltree);


--
-- Name: grdntbr_wsgcode_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX grdntbr_wsgcode_idx ON bcfishpass.gradient_barriers USING btree (watershed_group_code);


--
-- Name: modelled_stream_crossings_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_blue_line_key_idx ON bcfishpass.modelled_stream_crossings USING btree (blue_line_key);


--
-- Name: modelled_stream_crossings_ften_road_section_lines_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_ften_road_section_lines_id_idx ON bcfishpass.modelled_stream_crossings USING btree (ften_road_section_lines_id);


--
-- Name: modelled_stream_crossings_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_geom_idx ON bcfishpass.modelled_stream_crossings USING gist (geom);


--
-- Name: modelled_stream_crossings_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_linear_feature_id_idx ON bcfishpass.modelled_stream_crossings USING btree (linear_feature_id);


--
-- Name: modelled_stream_crossings_localcode_ltree_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_localcode_ltree_idx ON bcfishpass.modelled_stream_crossings USING gist (localcode_ltree);


--
-- Name: modelled_stream_crossings_localcode_ltree_idx1; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_localcode_ltree_idx1 ON bcfishpass.modelled_stream_crossings USING btree (localcode_ltree);


--
-- Name: modelled_stream_crossings_og_petrlm_dev_rd_pre06_pub_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_og_petrlm_dev_rd_pre06_pub_id_idx ON bcfishpass.modelled_stream_crossings USING btree (og_petrlm_dev_rd_pre06_pub_id);


--
-- Name: modelled_stream_crossings_og_road_segment_permit_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_og_road_segment_permit_id_idx ON bcfishpass.modelled_stream_crossings USING btree (og_road_segment_permit_id);


--
-- Name: modelled_stream_crossings_railway_track_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_railway_track_id_idx ON bcfishpass.modelled_stream_crossings USING btree (railway_track_id);


--
-- Name: modelled_stream_crossings_transport_line_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_transport_line_id_idx ON bcfishpass.modelled_stream_crossings USING btree (transport_line_id);


--
-- Name: modelled_stream_crossings_wscode_ltree_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_wscode_ltree_idx ON bcfishpass.modelled_stream_crossings USING gist (wscode_ltree);


--
-- Name: modelled_stream_crossings_wscode_ltree_idx1; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX modelled_stream_crossings_wscode_ltree_idx1 ON bcfishpass.modelled_stream_crossings USING btree (wscode_ltree);


--
-- Name: observations_blue_line_key_downstream_route_measure_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX observations_blue_line_key_downstream_route_measure_idx ON bcfishpass.observations USING btree (blue_line_key, downstream_route_measure);


--
-- Name: observations_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX observations_blue_line_key_idx ON bcfishpass.observations USING btree (blue_line_key);


--
-- Name: observations_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX observations_geom_idx ON bcfishpass.observations USING gist (geom);


--
-- Name: observations_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX observations_linear_feature_id_idx ON bcfishpass.observations USING btree (linear_feature_id);


--
-- Name: observations_localcode_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX observations_localcode_idx ON bcfishpass.observations USING btree (localcode);


--
-- Name: observations_localcode_idx1; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX observations_localcode_idx1 ON bcfishpass.observations USING gist (localcode);


--
-- Name: observations_wscode_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX observations_wscode_idx ON bcfishpass.observations USING btree (wscode);


--
-- Name: observations_wscode_idx1; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX observations_wscode_idx1 ON bcfishpass.observations USING gist (wscode);


--
-- Name: pscis_blue_line_key_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_blue_line_key_idx ON bcfishpass.pscis USING btree (blue_line_key);


--
-- Name: pscis_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_geom_idx ON bcfishpass.pscis USING gist (geom);


--
-- Name: pscis_linear_feature_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_linear_feature_id_idx ON bcfishpass.pscis USING btree (linear_feature_id);


--
-- Name: pscis_localcode_ltree_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_localcode_ltree_idx ON bcfishpass.pscis USING gist (localcode_ltree);


--
-- Name: pscis_localcode_ltree_idx1; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_localcode_ltree_idx1 ON bcfishpass.pscis USING btree (localcode_ltree);


--
-- Name: pscis_modelled_crossing_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_modelled_crossing_id_idx ON bcfishpass.pscis USING btree (modelled_crossing_id);


--
-- Name: pscis_not_matched_to_streams_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_not_matched_to_streams_geom_idx ON bcfishpass.pscis_not_matched_to_streams USING gist (geom);


--
-- Name: pscis_points_all_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_points_all_geom_idx ON bcfishpass.pscis_points_all USING gist (geom);


--
-- Name: pscis_streams_150m_modelled_crossing_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_streams_150m_modelled_crossing_id_idx ON bcfishpass.pscis_streams_150m USING btree (modelled_crossing_id);


--
-- Name: pscis_streams_150m_stream_crossing_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_streams_150m_stream_crossing_id_idx ON bcfishpass.pscis_streams_150m USING btree (stream_crossing_id);


--
-- Name: pscis_wscode_ltree_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_wscode_ltree_idx ON bcfishpass.pscis USING gist (wscode_ltree);


--
-- Name: pscis_wscode_ltree_idx1; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX pscis_wscode_ltree_idx1 ON bcfishpass.pscis USING btree (wscode_ltree);


--
-- Name: streams_blkey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX streams_blkey_idx ON bcfishpass.streams USING btree (blue_line_key);


--
-- Name: streams_geom_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX streams_geom_idx ON bcfishpass.streams USING gist (geom);


--
-- Name: streams_lc_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX streams_lc_bidx ON bcfishpass.streams USING btree (localcode_ltree);


--
-- Name: streams_lc_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX streams_lc_gidx ON bcfishpass.streams USING gist (localcode_ltree);


--
-- Name: streams_lfeatid_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX streams_lfeatid_idx ON bcfishpass.streams USING btree (linear_feature_id);


--
-- Name: streams_wbkey_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX streams_wbkey_idx ON bcfishpass.streams USING btree (waterbody_key);


--
-- Name: streams_wsc_bidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX streams_wsc_bidx ON bcfishpass.streams USING btree (wscode_ltree);


--
-- Name: streams_wsc_gidx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX streams_wsc_gidx ON bcfishpass.streams USING gist (wscode_ltree);


--
-- Name: streams_wsg_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX streams_wsg_idx ON bcfishpass.streams USING btree (watershed_group_code);


--
-- Name: user_modelled_crossing_fixes_modelled_crossing_id_idx; Type: INDEX; Schema: bcfishpass; Owner: -
--

CREATE INDEX user_modelled_crossing_fixes_modelled_crossing_id_idx ON bcfishpass.user_modelled_crossing_fixes USING btree (modelled_crossing_id);


--
-- Name: log_aw_linear_summary log_aw_linear_summary_model_run_id_fkey; Type: FK CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.log_aw_linear_summary
    ADD CONSTRAINT log_aw_linear_summary_model_run_id_fkey FOREIGN KEY (model_run_id) REFERENCES bcfishpass.log(model_run_id);


--
-- Name: log_parameters_habitat_method log_parameters_habitat_method_model_run_id_fkey; Type: FK CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.log_parameters_habitat_method
    ADD CONSTRAINT log_parameters_habitat_method_model_run_id_fkey FOREIGN KEY (model_run_id) REFERENCES bcfishpass.log(model_run_id);


--
-- Name: log_parameters_habitat_thresholds log_parameters_habitat_thresholds_model_run_id_fkey; Type: FK CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.log_parameters_habitat_thresholds
    ADD CONSTRAINT log_parameters_habitat_thresholds_model_run_id_fkey FOREIGN KEY (model_run_id) REFERENCES bcfishpass.log(model_run_id);


--
-- Name: log_wsg_crossing_summary log_wsg_crossing_summary_model_run_id_fkey; Type: FK CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.log_wsg_crossing_summary
    ADD CONSTRAINT log_wsg_crossing_summary_model_run_id_fkey FOREIGN KEY (model_run_id) REFERENCES bcfishpass.log(model_run_id);


--
-- Name: log_wsg_linear_summary log_wsg_linear_summary_model_run_id_fkey; Type: FK CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.log_wsg_linear_summary
    ADD CONSTRAINT log_wsg_linear_summary_model_run_id_fkey FOREIGN KEY (model_run_id) REFERENCES bcfishpass.log(model_run_id);


--
-- Name: user_habitat_classification user_habitat_classification_temp_rearing_fkey; Type: FK CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_habitat_classification
    ADD CONSTRAINT user_habitat_classification_temp_rearing_fkey FOREIGN KEY (rearing) REFERENCES bcfishpass.user_habitat_codes(habitat_code);


--
-- Name: user_habitat_classification user_habitat_classification_temp_spawning_fkey; Type: FK CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_habitat_classification
    ADD CONSTRAINT user_habitat_classification_temp_spawning_fkey FOREIGN KEY (spawning) REFERENCES bcfishpass.user_habitat_codes(habitat_code);


--
-- Name: user_habitat_classification user_habitat_classification_temp_species_code_fkey; Type: FK CONSTRAINT; Schema: bcfishpass; Owner: -
--

ALTER TABLE ONLY bcfishpass.user_habitat_classification
    ADD CONSTRAINT user_habitat_classification_temp_species_code_fkey FOREIGN KEY (species_code) REFERENCES whse_fish.species_cd(code);


--
-- PostgreSQL database dump complete
--
