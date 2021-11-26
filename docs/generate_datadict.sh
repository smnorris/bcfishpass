psql2csv "SELECT a.attname As column_name,  d.description
FROM pg_class As c
INNER JOIN pg_attribute As a ON c.oid = a.attrelid
LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
LEFT JOIN pg_tablespace t ON t.oid = c.reltablespace
LEFT JOIN pg_description As d ON (d.objoid = c.oid AND d.objsubid = a.attnum)
WHERE  c.relkind IN('r', 'v') AND  n.nspname = 'bcfishpass' AND c.relname = 'crossings'
AND a.attname not in ('cmax','cmin','tableoid','xmax','xmin','ctid','geom');" > crossings.csv