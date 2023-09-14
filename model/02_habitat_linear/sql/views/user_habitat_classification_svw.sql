-- display known spawning/rearing sites as streams

drop materialized view if exists bcfishpass.user_habitat_classification_svw;
create materialized view bcfishpass.user_habitat_classification_svw as 

with streams as (
  select
    row_number() over() as id,
    a.linear_feature_id,
    a.blue_line_key,
    a.downstream_route_measure,
    a.upstream_route_measure,
    b.species_code,
    b.habitat_type,
    b.habitat_ind,
    b.reviewer_name,
    b.review_date,
    b.source,
    b.notes,
    st_locatebetween(a.geom, b.downstream_route_measure, b.upstream_route_measure)::geometry(MultiLinestringZM, 3005) as geom
  from whse_basemapping.fwa_stream_networks_sp a
  inner join bcfishpass.user_habitat_classification b
  on a.blue_line_key = b.blue_line_key
  and (
    (
     round(a.downstream_route_measure::numeric, 4) >= round(b.downstream_route_measure::numeric, 4) and
     round(a.downstream_route_measure::numeric, 4) < round(b.upstream_route_measure::numeric, 4)
    )
    or
    (
     round(a.upstream_route_measure::numeric, 4) >= round(b.downstream_route_measure::numeric, 4) and
     round(a.upstream_route_measure::numeric, 4) < round(b.upstream_route_measure::numeric, 4)
    )
  )
)

select row_number() over() as id, *
from (
  select 
    blue_line_key,
    species_code,
    habitat_type,
    array_agg(distinct reviewer_name) as reviewer_name,
    array_agg(distinct review_date) as review_date,
    array_agg(distinct source) as review_source,
    array_agg(distinct notes) as notes,
    (st_dump(st_linemerge(st_union(geom, 1), True))).geom as geom
  from streams s
  where habitat_ind is true
  group by blue_line_key, species_code, habitat_type
) as f;

create index on bcfishpass.user_habitat_classification_svw using gist (geom);