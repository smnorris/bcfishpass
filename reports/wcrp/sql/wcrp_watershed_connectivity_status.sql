DROP FUNCTION postgisftw.wcrp_watershed_connectivity_status(TEXT,TEXT);

CREATE OR REPLACE FUNCTION postgisftw.wcrp_watershed_connectivity_status(watershed_group_code TEXT, habitat_type TEXT default 'ALL')
--watershed_group: watershed group codes from db e.g. HORS, BULK, etc.
--habitat_type: SPAWN, REAR or ALL
  RETURNS TABLE(
    watershed_group_cd varchar (4),
	  connectivity_status NUMERIC,
	  all_habitat NUMERIC,
	  all_habitat_accessible NUMERIC
  )
  LANGUAGE 'plpgsql'
  IMMUTABLE PARALLEL SAFE 

AS $$

DECLARE
   v_wsg   text := watershed_group_code;
   v_hab  text := habitat_type;

BEGIN

-- report on total modelled habitat vs accessible modelled habitat


IF (v_hab = 'REAR')

  THEN RETURN query

  with numbers AS
  (
  SELECT

    s.watershed_group_code,

    -- SPAWNING length
    -- ---------------
    -- all spawning habitat is simple, just add it up
    round((SUM(ST_Length(geom)) FILTER (
      WHERE model_spawning_ch IS TRUE
      OR model_spawning_co IS TRUE
      OR model_spawning_st IS TRUE
      OR model_spawning_sk IS TRUE
    ) / 1000)::numeric, 2) as spawning_km,

    -- spawning accessible
    round((SUM(ST_Length(geom)) FILTER (
      WHERE (model_spawning_ch IS TRUE AND barriers_anthropogenic_dnstr IS NULL)
      OR (model_spawning_co IS TRUE AND barriers_anthropogenic_dnstr IS NULL)
      OR (model_spawning_st IS TRUE AND barriers_anthropogenic_dnstr IS NULL)
      OR (model_spawning_sk IS TRUE AND barriers_anthropogenic_dnstr IS NULL)
    ) / 1000)::numeric, 2) as spawning_accessible_km,

  -- REARING length
  -- --------------
  -- rearing is more complex, add an extra .5 for CO/SK rearing in wetlands/lakes respectively
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
      ) AS rearing_km,

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
    ) AS rearing_accessible_km,

  --total km of habitat
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
          -- CREATEadd .5 coho rearing in wetlands
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
    ) / 1000)::numeric, 2) AS all_habitat_km,

  --total acccessible km
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
          -- CREATEadd .5 coho rearing in wetlands
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
    ) / 1000)::numeric, 2) AS all_habitat_accessible_km

  FROM bcfishpass.streams s
  --WHERE watershed_group_code IN ('LNIC','BULK','HORS')
  WHERE s.watershed_group_code = v_wsg
  GROUP BY s.watershed_group_code
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
      a.watershed_group_code,
      a.rearing_pct_accessible,
      a.all_habitat_km,
      a.all_habitat_accessible_km
  FROM access a;

ELSIF (v_hab = 'SPAWN')

  THEN RETURN query

  with numbers AS
  (
  SELECT

    s.watershed_group_code,

    
  -- SPAWNING length
  -- ---------------
    -- all spawning habitat is simple, just add it up
    round((SUM(ST_Length(geom)) FILTER (
      WHERE model_spawning_ch IS TRUE
      OR model_spawning_co IS TRUE
      OR model_spawning_st IS TRUE
      OR model_spawning_sk IS TRUE
    ) / 1000)::numeric, 2) as spawning_km,

    -- spawning accessible
    round((SUM(ST_Length(geom)) FILTER (
      WHERE 
        (model_spawning_ch IS TRUE AND barriers_anthropogenic_dnstr IS NULL) OR 
        (model_spawning_co IS TRUE AND barriers_anthropogenic_dnstr IS NULL) OR 
        (model_spawning_st IS TRUE AND barriers_anthropogenic_dnstr IS NULL) OR 
        (model_spawning_sk IS TRUE AND barriers_anthropogenic_dnstr IS NULL)
    ) / 1000)::numeric, 2) as spawning_accessible_km,

  -- REARING length
  -- --------------
  -- rearing is more complex, add an extra .5 for CO/SK rearing in wetlands/lakes respectively
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
      ) AS rearing_km,

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
              edge_type = 1050 AND
              barriers_anthropogenic_dnstr IS NULL
          ) +
          -- add .5 sockeye rearing in lakes (all of it)
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE
              model_spawning_sk IS TRUE AND
              barriers_anthropogenic_dnstr IS NULL              
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
          -- CREATEadd .5 coho rearing in wetlands
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
    ) / 1000)::numeric, 2) AS all_habitat_km,

  --total acccessible km
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
          -- CREATEadd .5 coho rearing in wetlands
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE
              model_rearing_co IS TRUE AND
              edge_type = 1050 AND
              barriers_anthropogenic_dnstr IS NULL
          ) +
          -- add .5 sockeye rearing in lakes (all of it)
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE
              model_spawning_sk IS TRUE AND
              barriers_anthropogenic_dnstr IS NULL
          )
    ) / 1000)::numeric, 2) AS all_habitat_accessible_km

  FROM bcfishpass.streams s
  --WHERE watershed_group_code IN ('LNIC','BULK','HORS')
  WHERE s.watershed_group_code = v_wsg
  GROUP BY s.watershed_group_code
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
      a.watershed_group_code,
      a.spawning_pct_accessible,
      a.all_habitat_km,
      a.all_habitat_accessible_km
  FROM access a;


ELSE
  RETURN query

  with numbers AS
  (
  SELECT

    s.watershed_group_code,

    
  -- SPAWNING length
  -- ---------------
    -- all spawning habitat is simple, just add it up
    round((SUM(ST_Length(geom)) FILTER (
      WHERE model_spawning_ch IS TRUE
      OR model_spawning_co IS TRUE
      OR model_spawning_st IS TRUE
      OR model_spawning_sk IS TRUE
    ) / 1000)::numeric, 2) as spawning_km,

    -- spawning accessible
    round((SUM(ST_Length(geom)) FILTER (
      WHERE 
       (model_spawning_ch IS TRUE AND barriers_anthropogenic_dnstr IS NULL) OR
       (model_spawning_co IS TRUE AND barriers_anthropogenic_dnstr IS NULL) OR
       (model_spawning_st IS TRUE AND barriers_anthropogenic_dnstr IS NULL) OR
       (model_spawning_sk IS TRUE AND barriers_anthropogenic_dnstr IS NULL)
    ) / 1000)::numeric, 2) as spawning_accessible_km,

  -- REARING length
  -- --------------
  -- rearing is more complex, add an extra .5 for CO/SK rearing in wetlands/lakes respectively
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
      ) AS rearing_km,

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
              edge_type = 1050 AND
              barriers_anthropogenic_dnstr IS NULL
          ) +
          -- add .5 sockeye rearing in lakes (all of it)
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE
              model_spawning_sk IS TRUE AND
              barriers_anthropogenic_dnstr IS NULL
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
          -- CREATEadd .5 coho rearing in wetlands
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
    ) / 1000)::numeric, 2) AS all_habitat_km,

  --total acccessible km
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
          -- CREATEadd .5 coho rearing in wetlands
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE
              model_rearing_co IS TRUE AND
              edge_type = 1050 AND
              barriers_anthropogenic_dnstr IS NULL
          ) +
          -- add .5 sockeye rearing in lakes (all of it)
          SUM(ST_Length(geom) * .5) FILTER (
            WHERE
              model_spawning_sk IS TRUE AND
              barriers_anthropogenic_dnstr IS NULL
          )
    ) / 1000)::numeric, 2) AS all_habitat_accessible_km

  FROM bcfishpass.streams s
  --WHERE watershed_group_code IN ('LNIC','BULK','HORS')
  WHERE s.watershed_group_code = v_wsg
  GROUP BY s.watershed_group_code
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
      a.watershed_group_code,
      a.all_habitat_pct_accessible,
      a.all_habitat_km,
      a.all_habitat_accessible_km
  FROM access a;

END IF;

END
$$;


COMMENT ON FUNCTION postgisftw.wcrp_watershed_connectivity_status IS
'Provided is a watershed name according to the structure of bcbarriers.
The output is a percentage of combined spawning and rearing accessible 
habitat over the total modelled habitat for that particular watershed';

REVOKE EXECUTE ON FUNCTION postgisftw.wcrp_watershed_connectivity_status FROM public;
