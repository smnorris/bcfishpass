DROP FUNCTION bcfishpass.watershed_connectivity_status(TEXT,TEXT);

CREATE OR REPLACE FUNCTION bcfishpass.watershed_connectivity_status(watershed_group TEXT, habitat_type TEXT)
--watershed_group: watershed group codes from db e.g. HORS, BULK, etc.
--habitat_type: SPAWN, REAR or ALL
  RETURNS TABLE(
  	 watershed varchar (4),
	 connectivity_status NUMERIC
  )
  LANGUAGE 'plpgsql'
  IMMUTABLE PARALLEL SAFE 

AS $$

DECLARE
   v_water   text := watershed_group;
   v_hab  text := habitat_type;

BEGIN

-- report on total modelled habitat vs accessible modelled habitat


IF (v_hab = 'REAR')

  THEN RETURN query

  with numbers AS
  (
  SELECT

    watershed_group_code,


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
    ) AS rearing_accessible_km,

  --total km of habitat
    round(
      (
        (
          SUM(ST_Length(geom)) FILTER (
            WHERE
              (rearing_model_ch IS TRUE) OR
              (rearing_model_co IS TRUE) OR
              (rearing_model_st IS TRUE) OR
              (rearing_model_sk IS TRUE) OR
              (spawning_model_ch IS TRUE)
              OR (spawning_model_co IS TRUE)
              OR (spawning_model_st IS TRUE)
              OR (spawning_model_sk IS TRUE)
            )
            +
          -- CREATEadd .5 coho rearing in wetlands
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE
              rearing_model_co IS TRUE AND
              edge_type = 1050 
          ) +
          -- add .5 sockeye rearing in lakes (all of it)
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE
              spawning_model_sk IS TRUE 
          )
    ) / 1000)::numeric, 2) AS all_habitat_km,

  --total acccessible km
    round(
      (
        (
          SUM(ST_Length(geom)) FILTER (
            WHERE
              (rearing_model_ch IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE') OR
              (rearing_model_co IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE') OR
              (rearing_model_st IS TRUE AND access_model_st = 'ACCESSIBLE') OR
              (rearing_model_sk IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE') OR
              (spawning_model_ch IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE')
              OR (spawning_model_co IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE')
              OR (spawning_model_st IS TRUE AND access_model_st = 'ACCESSIBLE')
              OR (spawning_model_sk IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE')
            )
            +
          -- CREATEadd .5 coho rearing in wetlands
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
    ) / 1000)::numeric, 2) AS all_habitat_accessible_km

  FROM bcfishpass.streams
  --WHERE watershed_group_code IN ('LNIC','BULK','HORS')
  WHERE watershed_group_code = v_water
  GROUP BY watershed_group_code
  ),

  access AS (
      SELECT
          *,
          round((spawning_accessible_km / spawning_km * 100), 2)  as spawning_pct_accessible,
          round((rearing_accessible_km / rearing_km * 100), 2) as rearing_pct_accessible,
          round((all_habitat_accessible_km / all_habitat_km * 100), 2) as all_habitat_pct_accessible
          FROM numbers
  )

SELECT
      watershed_group_code,
      rearing_pct_accessible
  FROM access;

ELSIF (v_hab = 'SPAWN')

  THEN RETURN query

  with numbers AS
  (
  SELECT

    watershed_group_code,

    
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
    ) AS rearing_accessible_km,

  --total km of habitat
    round(
      (
        (
          SUM(ST_Length(geom)) FILTER (
            WHERE
              (rearing_model_ch IS TRUE) OR
              (rearing_model_co IS TRUE) OR
              (rearing_model_st IS TRUE) OR
              (rearing_model_sk IS TRUE) OR
              (spawning_model_ch IS TRUE)
              OR (spawning_model_co IS TRUE)
              OR (spawning_model_st IS TRUE)
              OR (spawning_model_sk IS TRUE)
            )
            +
          -- CREATEadd .5 coho rearing in wetlands
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE
              rearing_model_co IS TRUE AND
              edge_type = 1050 
          ) +
          -- add .5 sockeye rearing in lakes (all of it)
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE
              spawning_model_sk IS TRUE 
          )
    ) / 1000)::numeric, 2) AS all_habitat_km,

  --total acccessible km
    round(
      (
        (
          SUM(ST_Length(geom)) FILTER (
            WHERE
              (rearing_model_ch IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE') OR
              (rearing_model_co IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE') OR
              (rearing_model_st IS TRUE AND access_model_st = 'ACCESSIBLE') OR
              (rearing_model_sk IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE') OR
              (spawning_model_ch IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE')
              OR (spawning_model_co IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE')
              OR (spawning_model_st IS TRUE AND access_model_st = 'ACCESSIBLE')
              OR (spawning_model_sk IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE')
            )
            +
          -- CREATEadd .5 coho rearing in wetlands
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
    ) / 1000)::numeric, 2) AS all_habitat_accessible_km

  FROM bcfishpass.streams
  --WHERE watershed_group_code IN ('LNIC','BULK','HORS')
  WHERE watershed_group_code = v_water
  GROUP BY watershed_group_code
  ),

  access AS (
      SELECT
          *,
          round((spawning_accessible_km / spawning_km * 100), 2)  as spawning_pct_accessible,
          round((rearing_accessible_km / rearing_km * 100), 2) as rearing_pct_accessible,
          round((all_habitat_accessible_km / all_habitat_km * 100), 2) as all_habitat_pct_accessible
          FROM numbers
  )

SELECT
      watershed_group_code,
      spawning_pct_accessible
  FROM access;
ELSE

  RETURN query

  with numbers AS
  (
  SELECT

    watershed_group_code,

    
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
    ) AS rearing_accessible_km,

  --total km of habitat
    round(
      (
        (
          SUM(ST_Length(geom)) FILTER (
            WHERE
              (rearing_model_ch IS TRUE) OR
              (rearing_model_co IS TRUE) OR
              (rearing_model_st IS TRUE) OR
              (rearing_model_sk IS TRUE) OR
              (spawning_model_ch IS TRUE)
              OR (spawning_model_co IS TRUE)
              OR (spawning_model_st IS TRUE)
              OR (spawning_model_sk IS TRUE)
            )
            +
          -- CREATEadd .5 coho rearing in wetlands
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE
              rearing_model_co IS TRUE AND
              edge_type = 1050 
          ) +
          -- add .5 sockeye rearing in lakes (all of it)
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE
              spawning_model_sk IS TRUE 
          )
    ) / 1000)::numeric, 2) AS all_habitat_km,

  --total acccessible km
    round(
      (
        (
          SUM(ST_Length(geom)) FILTER (
            WHERE
              (rearing_model_ch IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE') OR
              (rearing_model_co IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE') OR
              (rearing_model_st IS TRUE AND access_model_st = 'ACCESSIBLE') OR
              (rearing_model_sk IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE') OR
              (spawning_model_ch IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE')
              OR (spawning_model_co IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE')
              OR (spawning_model_st IS TRUE AND access_model_st = 'ACCESSIBLE')
              OR (spawning_model_sk IS TRUE AND access_model_ch_co_sk = 'ACCESSIBLE')
            )
            +
          -- CREATEadd .5 coho rearing in wetlands
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
    ) / 1000)::numeric, 2) AS all_habitat_accessible_km

  FROM bcfishpass.streams
  --WHERE watershed_group_code IN ('LNIC','BULK','HORS')
  WHERE watershed_group_code = v_water
  GROUP BY watershed_group_code
  ),

  access AS (
      SELECT
          *,
          round((spawning_accessible_km / spawning_km * 100), 2)  as spawning_pct_accessible,
          round((rearing_accessible_km / rearing_km * 100), 2) as rearing_pct_accessible,
          round((all_habitat_accessible_km / all_habitat_km * 100), 2) as all_habitat_pct_accessible
          FROM numbers
  )

SELECT
      watershed_group_code,
      all_habitat_pct_accessible
  FROM access;

END IF;

END
$$;

ALTER FUNCTION bcfishpass.watershed_connectivity_status(text,text)
    OWNER TO tomasm;


COMMENT ON FUNCTION bcfishpass.all_acc_habitat IS 
'Provided is a watershed name according to the structure of bcbarriers.
The output is a percentage of combined spawning and rearing accessible 
habitat over the total modelled habitat for that particular watershed';
