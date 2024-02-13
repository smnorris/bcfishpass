DROP FUNCTION IF EXISTS postgisftw.wcrp_barrier_severity(text);

CREATE FUNCTION postgisftw.wcrp_barrier_severity(watershed_group_code TEXT)

-- watershed_group_code: BULK, LNIC, HORS, BOWR, QUES, CARR, ELKR

RETURNS TABLE(
  structure_type TEXT,
  n_assessed_barrier bigint,
  n_assess_total bigint,
  pct_assessed_barrier numeric
)
LANGUAGE 'plpgsql'
IMMUTABLE PARALLEL SAFE

AS $$

DECLARE
   v_wsg   text := watershed_group_code;

BEGIN

RETURN query

-- dams and assessed crossings on potentially accessible streams (to target spp)
-- - n total
-- - n barriers
-- - pct barriers
SELECT
  cft.crossing_feature_type,
  count(*) filter (where c.barrier_status in ('BARRIER', 'POTENTIAL')) as n_barrier,
  count(*) as n_total,
  round((count(*) filter (where c.barrier_status in ('BARRIER', 'POTENTIAL'))::numeric / count(*)::numeric) * 100, 1) as pct_barrier
from bcfishpass.crossings c
inner join bcfishpass.crossings_feature_type_vw cft using (aggregated_crossings_id)
inner join bcfishpass.crossings_upstream_access a using (aggregated_crossings_id)
where c.watershed_group_code = v_wsg
-- do not include flathead in ELKR
and c.wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree is false
-- pscis crossing downstream or dam downstream
and (c.stream_crossing_id is not null or c.dam_id is not null)
-- potentially accessible to target species
and (
  cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0 or
  cardinality(a.barriers_st_dnstr) = 0 or
  cardinality(a.barriers_wct_dnstr) = 0
)
group by c.watershed_group_code, cft.crossing_feature_type
order by c.watershed_group_code, cft.crossing_feature_type;

END

$$;

COMMENT ON FUNCTION postgisftw.wcrp_barrier_severity IS
'For given watershed group, returns count of dams/pscis crossings on potentially accessible streams
- n total
- n barrier
- pct that are barrier';

REVOKE EXECUTE ON FUNCTION postgisftw.wcrp_barrier_severity FROM public;

-- select * from postgisftw.wcrp_barrier_severity('QUES')