-- streams, 3rd order and larger
DROP TABLE IF EXISTS bcfishpass.streams_carto_order3gt;

CREATE TABLE bcfishpass.streams_carto_order3gt
(
  carto_stream_order3gt_id  serial primary key,
  blue_line_key             integer                           ,
  gnis_name                 character varying(80)            ,
  stream_order              integer                           ,
  access_model_bt           text,
  access_model_ch_co_sk     text,
  access_model_ch_co_sk_b   text,
  access_model_pk           text,
  access_model_st           text,
  access_model_wct          text,
  geom geometry(LineString,3005)
);

INSERT INTO bcfishpass.streams_carto_order3gt
  (blue_line_key,
  gnis_name,
  stream_order,
  access_model_bt,
  access_model_ch_co_sk,
  access_model_ch_co_sk_b,
  access_model_pk,
  access_model_st,
  access_model_wct,
  geom)
SELECT
  blue_line_key,
  gnis_name,
  stream_order,
  access_model_bt,
  access_model_ch_co_sk,
  access_model_ch_co_sk_b,
  access_model_pk,
  access_model_st,
  access_model_wct,
  (ST_Dump(ST_UNION(ST_Force2D(geom)))).geom as geom
FROM bcfishpass.streams
WHERE stream_order >= 3
GROUP BY blue_line_key,
  gnis_name,
  stream_order,
  access_model_bt,
  access_model_ch_co_sk,
  access_model_ch_co_sk_b,
  access_model_pk,
  access_model_st,
  access_model_wct;

CREATE INDEX ON bcfishpass.streams_carto_order3gt USING gist (geom);

-- generalized streams, 5th order and larger
DROP TABLE IF EXISTS bcfishpass.streams_carto_order6gt;

CREATE TABLE bcfishpass.streams_carto_order6gt
(
  carto_stream_order5gt_id  serial primary key,
  blue_line_key             integer                           ,
  gnis_name                 character varying(80)            ,
  stream_order              integer                           ,
  access_model_bt           text,
  access_model_ch_co_sk     text,
  access_model_ch_co_sk_b   text,
  access_model_pk           text,
  access_model_st           text,
  access_model_wct          text,
  geom geometry(LineString,3005)
);

INSERT INTO bcfishpass.streams_carto_order6gt
  (blue_line_key,
  gnis_name,
  stream_order,
  access_model_bt,
  access_model_ch_co_sk,
  access_model_ch_co_sk_b,
  access_model_pk,
  access_model_st,
  access_model_wct,
  geom)
SELECT
  blue_line_key,
  gnis_name,
  stream_order,
  access_model_bt,
  access_model_ch_co_sk,
  access_model_ch_co_sk_b,
  access_model_pk,
  access_model_st,
  access_model_wct,
  st_simplify((ST_Dump(ST_UNION(ST_Force2D(geom)))).geom, 200) as geom
FROM bcfishpass.streams
WHERE stream_order >= 6
GROUP BY blue_line_key,
  gnis_name,
  stream_order,
  access_model_bt,
  access_model_ch_co_sk,
  access_model_ch_co_sk_b,
  access_model_pk,
  access_model_st,
  access_model_wct;

CREATE INDEX ON bcfishpass.streams_carto_order6gt USING gist (geom);

-- create per species/species group observation views
create or replace view bcfishpass.observations_bt_vw as
with obs as
(
select
  fish_obsrvtn_pnt_distinct_id,
  unnest(species_codes) as species_code,
  unnest(observation_ids) as observation_id,
  unnest(observation_dates) as observation_date,
  geom
from bcfishpass.observations
)

select
  fish_obsrvtn_pnt_distinct_id,
  array_to_string(array_agg(species_code), ' ') as species_codes,
  array_to_string(array_agg(observation_id),';') as observation_ids,
  array_to_string(array_agg(observation_date),';') as observation_date,
  geom
from obs
where species_code = 'BT'
group by fish_obsrvtn_pnt_distinct_id, geom;

create or replace view bcfishpass.observations_ch_co_sk_vw as
with obs as
(
select
  fish_obsrvtn_pnt_distinct_id,
  unnest(species_codes) as species_code,
  unnest(observation_ids) as observation_id,
  unnest(observation_dates) as observation_date,
  geom
from bcfishpass.observations
)
select
  fish_obsrvtn_pnt_distinct_id,
  array_to_string(array_agg(species_code), ' ') as species_codes,
  array_to_string(array_agg(observation_id),';') as observation_ids,
  array_to_string(array_agg(observation_date),';') as observation_date,
  geom
from obs
where species_code in ('CH','CO','SK')
group by fish_obsrvtn_pnt_distinct_id, geom;


create or replace view bcfishpass.observations_pk_vw as
with obs as
(
select
  fish_obsrvtn_pnt_distinct_id,
  unnest(species_codes) as species_code,
  unnest(observation_ids) as observation_id,
  unnest(observation_dates) as observation_date,
  geom
from bcfishpass.observations
)
select
  fish_obsrvtn_pnt_distinct_id,
  array_to_string(array_agg(species_code), ' ') as species_codes,
  array_to_string(array_agg(observation_id),';') as observation_ids,
  array_to_string(array_agg(observation_date),';') as observation_date,
  geom
from obs
where species_code = 'PK'
group by fish_obsrvtn_pnt_distinct_id, geom;

create or replace view bcfishpass.observations_st_vw as
with obs as
(
select
  fish_obsrvtn_pnt_distinct_id,
  unnest(species_codes) as species_code,
  unnest(observation_ids) as observation_id,
  unnest(observation_dates) as observation_date,
  geom
from bcfishpass.observations
)
select
  fish_obsrvtn_pnt_distinct_id,
  array_to_string(array_agg(species_code), ' ') as species_codes,
  array_to_string(array_agg(observation_id),';') as observation_ids,
  array_to_string(array_agg(observation_date),';') as observation_date,
  geom
from obs
where species_code = 'ST'
group by fish_obsrvtn_pnt_distinct_id, geom;

create or replace view bcfishpass.observations_wct_vw as
with obs as
(
select
  fish_obsrvtn_pnt_distinct_id,
  unnest(species_codes) as species_code,
  unnest(observation_ids) as observation_id,
  unnest(observation_dates) as observation_date,
  geom
from bcfishpass.observations
)
select
  fish_obsrvtn_pnt_distinct_id,
  array_to_string(array_agg(species_code), ' ') as species_codes,
  array_to_string(array_agg(observation_id),';') as observation_ids,
  array_to_string(array_agg(observation_date),';') as observation_date,
  geom
from obs
where species_code = 'WCT'
group by fish_obsrvtn_pnt_distinct_id, geom;