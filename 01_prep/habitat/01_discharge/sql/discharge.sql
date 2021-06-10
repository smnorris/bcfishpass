-- Insert data from load table, plus area of the fundamental watershed(s) associated with the stream (where present)
INSERT INTO bcfishpass.discharge
(
  wscode_ltree,
  localcode_ltree,
  watershed_group_code,
  area,
  discharge
)

SELECT
  a.wscode_ltree::ltree,
  a.localcode_ltree::ltree,
  a.watershed_group_code,
  coalesce(round(sum(ST_Area(b.geom))), 1)::bigint as area, -- coalesce to area=1 where no watershed matched (to avoid any divisions by zero)
  avg(a.discharge)::integer as discharge
FROM bcfishpass.discharge_load a
LEFT JOIN whse_basemapping.fwa_watersheds_poly b            -- left join to ensure all data comes through
ON a.wscode_ltree::ltree = b.wscode_ltree AND a.localcode_ltree::ltree = b.localcode_ltree
WHERE a.discharge IS NOT NULL AND a.watershed_group_code = :'wsg'
GROUP BY a.wscode_ltree::ltree, a.localcode_ltree::ltree, a.watershed_group_code
on conflict do nothing;