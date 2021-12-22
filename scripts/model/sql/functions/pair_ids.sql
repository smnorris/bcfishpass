-- function to create unique id from two integers, used to
-- combine blue_line_key / downstream_route_measure for a convenient unique
-- identifier that does not depend on a sequence
-- https://stackoverflow.com/questions/22393399/postgresql-how-to-create-a-pairing-function
CREATE OR REPLACE FUNCTION pair_ids(x bigint, y bigint)
  RETURNS bigint AS
$func$
SELECT CASE WHEN x < y THEN
          x * (y - 1) + ((y - x - 2)^2)::bigint / 4
       ELSE
          (x - 1) * y + ((x - y - 2)^2)::bigint / 4
       END
$func$  LANGUAGE sql IMMUTABLE;