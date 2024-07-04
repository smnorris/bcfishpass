-- function to query the view (so it is visible in pgfs)
CREATE FUNCTION postgisftw.wcrp_barrier_count(
  watershed_group_code TEXT,
  model_status TEXT default 'ALL'
)
-- watershed_group_code: BULK, LNIC, HORS, BOWR, QUES, CARR, ELKR
-- model_status        : HABITAT, ACCESSIBLE, ALL (default)

RETURNS TABLE (
 crossing_feature_type TEXT,
 n_passable bigint,
 n_barrier bigint,
 n_potential bigint,
 n_unknown bigint,
 total bigint
 )
LANGUAGE 'plpgsql'
IMMUTABLE PARALLEL SAFE

AS $$

DECLARE
   v_wsg   text := watershed_group_code;
   v_model_status   text := model_status;

BEGIN

IF (v_model_status = 'ALL')
then return query

SELECT
  v.crossing_feature_type,
  sum(v.n_passable)::bigint as n_passable,
  sum(v.n_barrier)::bigint as n_barrier,
  sum(v.n_potential)::bigint as n_potential,
  sum(v.n_unknown)::bigint as n_unknown,
  (sum(v.n_passable) + sum(v.n_barrier) + sum(v.n_potential) + sum(v.n_unknown))::bigint as total
FROM bcfishpass.wcrp_barrier_count_vw v
WHERE v.watershed_group_code = v_wsg
GROUP BY v.crossing_feature_type;

ELSIF (v_model_status = 'ACCESSIBLE')
then return query
SELECT
  v.crossing_feature_type,
  sum(v.n_passable)::bigint as n_passable,
  sum(v.n_barrier)::bigint as n_barrier,
  sum(v.n_potential)::bigint as n_potential,
  sum(v.n_unknown)::bigint as n_unknown,
  (sum(v.n_passable) + sum(v.n_barrier) + sum(v.n_potential) + sum(v.n_unknown))::bigint as total
FROM bcfishpass.wcrp_barrier_count_vw v
WHERE
  v.watershed_group_code = v_wsg and
  v.model_status in ('ACCESSIBLE', 'HABITAT')
group by v.crossing_feature_type;

ELSIF (v_model_status = 'HABITAT')
then return query
SELECT
  v.crossing_feature_type,
  v.n_passable::bigint as n_passable,
  v.n_barrier::bigint as n_barrier,
  v.n_potential::bigint as n_potential,
  v.n_unknown::bigint as n_unknown,
  (v.n_passable + v.n_barrier + v.n_potential + v.n_unknown)::bigint as total
FROM bcfishpass.wcrp_barrier_count_vw v
WHERE
  v.watershed_group_code = v_wsg and
  v.model_status = 'HABITAT';

END IF;

END


$$;

COMMENT ON FUNCTION postgisftw.wcrp_barrier_count IS
'Return count of crossings per crossing_feature_type within specified watershed group.
Returns count of crossings accessible to target species if model_status=ACCESSIBLE is specified,
Returns count of crossings below modelled habitat if model_status=HABITAT is specified
Returns count of all crossings if model_status=ALL is specified (default)';

REVOKE EXECUTE ON FUNCTION postgisftw.wcrp_barrier_count FROM public;

-- test
--select * from postgisftw.wcrp_barrier_count('QUES');
--select * from postgisftw.wcrp_barrier_count('QUES','ALL');
--select * from postgisftw.wcrp_barrier_count('QUES','ACCESSIBLE');
--select * from postgisftw.wcrp_barrier_count('QUES','HABITAT');
