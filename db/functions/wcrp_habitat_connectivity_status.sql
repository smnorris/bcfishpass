-- report on total modelled habitat vs accessible modelled habitat

DROP FUNCTION postgisftw.wcrp_habitat_connectivity_status(TEXT,TEXT);

CREATE OR REPLACE FUNCTION postgisftw.wcrp_habitat_connectivity_status(
  watershed_group_code TEXT,
  habitat_type TEXT default 'ALL'
)

-- watershed_group_code: BULK, LNIC, HORS, BOWR, QUES, CARR, ELKR
-- habitat_type:         SPAWNING, REARING, ALL (default)

  RETURNS TABLE(
    connectivity_status NUMERIC,
    all_habitat NUMERIC,
    all_habitat_accessible NUMERIC
  )
  LANGUAGE 'plpgsql'
  IMMUTABLE PARALLEL SAFE

AS $$

DECLARE
   v_wsg  text := watershed_group_code;
   v_hab  text := habitat_type;

BEGIN
RETURN QUERY
select
  pct_accessible as connectivity_status,
  total_km as all_habitat,
  accessible_km as all_habitat_accessible
from bcfishpass.wcrp_habitat_connectivity_status_vw v
where v.watershed_group_code = v_wsg
and v.habitat_type = v_hab;

END
$$;

COMMENT ON FUNCTION postgisftw.wcrp_habitat_connectivity_status IS
'Return pct habitat accessible, total km habitat, and km habitat accessible
for the habitat type and watershed group specified.';

REVOKE EXECUTE ON FUNCTION postgisftw.wcrp_habitat_connectivity_status FROM public;

-- select * from postgisftw.wcrp_habitat_connectivity_status('QUES')
-- select * from postgisftw.wcrp_habitat_connectivity_status('QUES', 'ALL')
-- select * from postgisftw.wcrp_habitat_connectivity_status('QUES', 'SPAWNING')
-- select * from postgisftw.wcrp_habitat_connectivity_status('QUES', 'REARING')
