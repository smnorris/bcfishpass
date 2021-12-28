-- for given watershed group, delete all records from given table below observations for given species
CREATE OR REPLACE FUNCTION bcfishpass.delete_barriers_below_observations(barriertype text, species_code text, wsg text)
  RETURNS VOID
  LANGUAGE plpgsql AS
$func$

BEGIN

    EXECUTE format('
        
        WITH barriers_below_observations AS
        (
            SELECT DISTINCT
              b.%I
             FROM bcfishpass.%I b
             INNER JOIN bcfishpass.observations o
             ON FWA_Upstream(
                    b.blue_line_key,
                    b.downstream_route_measure,
                    b.wscode_ltree,
                    b.localcode_ltree,
                    o.blue_line_key,
                    o.downstream_route_measure,
                    o.wscode_ltree,
                    o.localcode_ltree,
                    False,
                    1
                  )
            WHERE b.watershed_group_code = %L
            AND o.species_codes && ARRAY[%L]
        )

        DELETE FROM bcfishpass.%I
        WHERE %I IN (SELECT * FROM barriers_below_observations);',
    'barriers_' || barriertype || '_id',
    'barriers_' || barriertype,
    wsg,
    species_code,
    'barriers_' || barriertype,
    'barriers_' || barriertype || '_id'
    );

END
$func$;