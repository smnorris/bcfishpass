-- summarize spawning/rearing/spawning&rearing habitat lengths per group, by accessibility

drop view if exists bcfishpass.wcrp_habitat_connectivity_status_vw;

create view bcfishpass.wcrp_habitat_connectivity_status_vw as

with length_totals as
(
-- SPAWNING length
-- ---------------
-- all spawning habitat is simple, just add it up
  SELECT
    watershed_group_code,
    'SPAWNING' as habitat_type,
    round((SUM(ST_Length(geom)) FILTER (
      WHERE model_spawning_ch IS TRUE
      OR model_spawning_co IS TRUE
      OR model_spawning_st IS TRUE
      OR model_spawning_sk IS TRUE
    ) / 1000)::numeric, 2) as total_km,

    -- spawning accessible
    round((SUM(ST_Length(geom)) FILTER (
      WHERE (model_spawning_ch IS TRUE AND barriers_anthropogenic_dnstr IS NULL)
      OR (model_spawning_co IS TRUE AND barriers_anthropogenic_dnstr IS NULL)
      OR (model_spawning_st IS TRUE AND barriers_anthropogenic_dnstr IS NULL)
      OR (model_spawning_sk IS TRUE AND barriers_anthropogenic_dnstr IS NULL)
    ) / 1000)::numeric, 2) as accessible_km
  FROM bcfishpass.streams_vw s
  GROUP BY s.watershed_group_code
  
 UNION ALL
 
-- REARING length
-- --------------
-- rearing is more complex, add an extra .5 for CO/SK rearing in wetlands/lakes respectively

 SELECT
   watershed_group_code,
   'REARING' as habitat_type,
    round(
      (
        (
          SUM(ST_Length(geom)) FILTER (
            WHERE
            model_rearing_ch IS TRUE OR
            model_rearing_st IS TRUE OR
            model_rearing_sk IS TRUE OR
            model_rearing_co IS TRUE
          ) +
          -- add .5 coho rearing in wetlands
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE model_rearing_co IS TRUE AND edge_type = 1050
          ) +
          -- add .5 sockeye rearing in lakes (all of it)
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE model_spawning_sk IS TRUE
          )
        ) / 1000
      )::numeric, 2
      ) AS total_km,

    -- rearing accessible
    round(
      (
        (
          SUM(ST_Length(geom)) FILTER (
            WHERE
              (model_rearing_ch IS TRUE AND barriers_anthropogenic_dnstr IS NULL) OR
              (model_rearing_co IS TRUE AND barriers_anthropogenic_dnstr IS NULL) OR
              (model_rearing_st IS TRUE AND barriers_anthropogenic_dnstr IS NULL) OR
              (model_rearing_sk IS TRUE AND barriers_anthropogenic_dnstr IS NULL)
          ) +
          -- add .5 coho rearing in wetlands
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE
              model_rearing_co IS TRUE AND
              edge_type = 1050 AND barriers_anthropogenic_dnstr IS NULL
          ) +
          -- add .5 sockeye rearing in lakes (all of it)
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE
              model_spawning_sk IS TRUE AND barriers_anthropogenic_dnstr IS NULL
          )
        ) / 1000
      )::numeric, 2
    ) AS accessible_km
    FROM bcfishpass.streams_vw s
  GROUP BY s.watershed_group_code

UNION ALL
  -- spawning or rearing - total km of habitat
  SELECT
    watershed_group_code,
    'ALL' as habitat_type,
    round(
      (
        (
          SUM(ST_Length(geom)) FILTER (
            WHERE
              (model_rearing_ch IS TRUE) OR
              (model_rearing_co IS TRUE) OR
              (model_rearing_st IS TRUE) OR
              (model_rearing_sk IS TRUE) OR
              (model_spawning_ch IS TRUE)
              OR (model_spawning_co IS TRUE)
              OR (model_spawning_st IS TRUE)
              OR (model_spawning_sk IS TRUE)
            )
            +
          -- add .5 coho rearing in wetlands
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE
              model_rearing_co IS TRUE AND
              edge_type = 1050 
          ) +
          -- add .5 sockeye rearing in lakes (all of it)
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE
              model_spawning_sk IS TRUE 
          )
    ) / 1000)::numeric, 2) AS total_km,

  -- total acccessible km
    round(
      (
        (
          SUM(ST_Length(geom)) FILTER (
            WHERE
              (model_rearing_ch IS TRUE AND barriers_anthropogenic_dnstr IS NULL) OR
              (model_rearing_co IS TRUE AND barriers_anthropogenic_dnstr IS NULL) OR
              (model_rearing_st IS TRUE AND barriers_anthropogenic_dnstr IS NULL) OR
              (model_rearing_sk IS TRUE AND barriers_anthropogenic_dnstr IS NULL) OR
              (model_spawning_ch IS TRUE AND barriers_anthropogenic_dnstr IS NULL) OR 
              (model_spawning_co IS TRUE AND barriers_anthropogenic_dnstr IS NULL) OR 
              (model_spawning_st IS TRUE AND barriers_anthropogenic_dnstr IS NULL) OR 
              (model_spawning_sk IS TRUE AND barriers_anthropogenic_dnstr IS NULL)
            )
            +
          -- add .5 coho rearing in wetlands
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE
              model_rearing_co IS TRUE AND
              edge_type = 1050 AND barriers_anthropogenic_dnstr IS NULL
          ) +
          -- add .5 sockeye rearing in lakes (all of it)
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE
              model_spawning_sk IS TRUE AND barriers_anthropogenic_dnstr IS NULL              
          )
    ) / 1000)::numeric, 2) AS accessible_km
    FROM bcfishpass.streams_vw s
  GROUP BY s.watershed_group_code
)

select
  watershed_group_code,
  habitat_type,
  total_km,
  accessible_km,
  round((accessible_km / total_km) * 100, 2) as pct_accessible
from length_totals
where watershed_group_code in ('BULK','LNIC','HORS','BOWR','QUES','CARR','ELKR')
order by watershed_group_code, habitat_type desc;


-- select * from wcrp_habitat_connectivity_status_vw;