-- report on total modelled habitat vs accessible modelled habitat

with numbers AS
(
SELECT

  watershed_group_code,

  -- TOTAL length
  -- -------------------------
  -- total length
  round((SUM(ST_Length(geom)) / 1000)::numeric, 2) as total_km,

  -- total stream length potentially accessible
  round((SUM(ST_Length(geom)) FILTER
  (WHERE access_model_ch_co_sk like '%ACCESSIBLE%'
     OR access_model_st like '%ACCESSIBLE%') / 1000)::numeric, 2) as total_potentially_accessible_km,

-- total stream length accessible
  round((SUM(ST_Length(geom)) FILTER
  (WHERE access_model_ch_co_sk = 'ACCESSIBLE'
     OR access_model_st = 'ACCESSIBLE') / 1000)::numeric, 2) as total_accessible_km,

-- SPAWNING length
-- ---------------
  -- all spawning habitat is simple, just add it up
  round((SUM(ST_Length(geom)) FILTER (
     WHERE spawning_model_ch IS TRUE
     OR spawning_model_co IS TRUE
     OR spawning_model_st IS TRUE
     OR spawning_model_sk IS TRUE
   ) / 1000)::numeric, 2) as spawning_km,

  -- spawning accessible
  round((SUM(ST_Length(geom)) FILTER (
     WHERE (spawning_model_ch IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE')
     OR (spawning_model_co IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE')
     OR (spawning_model_st IS TRUE AND access_model_st = 'ACCESSIBLE')
     OR (spawning_model_sk IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE')
   ) / 1000)::numeric, 2) as spawning_accessible_km,

-- REARING length
-- --------------
-- rearing is more complex, add an extra .5 for CO/SK rearing in wetlands/lakes respectively
  round(
    (
      (
        SUM(ST_Length(geom)) FILTER (
          WHERE
           rearing_model_ch IS TRUE OR
           rearing_model_st IS TRUE OR
           rearing_model_sk IS TRUE OR
           rearing_model_co IS TRUE
        ) +
        -- add .5 coho rearing in wetlands
        SUM(ST_Length(geom) * .5) FILTER (
          WHERE rearing_model_co IS TRUE AND edge_type = 1050
        ) +
        -- add .5 sockeye rearing in lakes (all of it)
        SUM(ST_Length(geom) * .5) FILTER (
          WHERE spawning_model_sk IS TRUE
        )
      ) / 1000
    )::numeric, 2
    ) AS rearing_km,

  -- rearing accessible
  round(
    (
      (
        SUM(ST_Length(geom)) FILTER (
          WHERE
            (rearing_model_ch IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE') OR
            (rearing_model_co IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE') OR
            (rearing_model_st IS TRUE AND access_model_st = 'ACCESSIBLE') OR
            (rearing_model_sk IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE')
        ) +
        -- add .5 coho rearing in wetlands
        SUM(ST_Length(geom) * .5) FILTER (
          WHERE
            rearing_model_co IS TRUE AND
            edge_type = 1050 AND
            access_model_ch_co_sk = 'ACCESSIBLE'
        ) +
        -- add .5 sockeye rearing in lakes (all of it)
        SUM(ST_Length(geom) * .5) FILTER (
          WHERE
            spawning_model_sk IS TRUE AND
            access_model_ch_co_sk = 'ACCESSIBLE'
        )
      ) / 1000
    )::numeric, 2
  ) AS rearing_accessible_km

FROM bcfishpass.streams
WHERE watershed_group_code IN ('LNIC','BULK','HORS')
GROUP BY watershed_group_code
)

SELECT
  *,
  round((total_accessible_km / total_km * 100), 2)  as total_pct_accessible,
  round((spawning_accessible_km / spawning_km * 100), 2)  as spawning_pct_accessible,
  round((rearing_accessible_km / rearing_km * 100), 2) as rearing_pct_accessible
FROM numbers
