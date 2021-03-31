# generate a text file listing all map tile urls

echo '# Fish Passage 48"x36" pdfs' > README.md

echo '## Bulkley River (BULK)' >> README.md
psql -t -c "SELECT
  '- [FishPassage_'||map_tile_display_name||'.pdf](https//cwfwcrp.s3-us-west-1.amazonaws.com/FishPassage_'||map_tile_display_name||'.pdf)'
  FROM whse_basemapping.dbm_mof_50k_grid g
  INNER JOIN whse_basemapping.fwa_watershed_groups_poly w
  ON st_intersects(g.geom, w.geom)
  WHERE w.watershed_group_code = 'BULK'
  ORDER BY watershed_group_name, map_tile_display_name" >> README.md

echo '## Horsefly River (HORS)' >> README.md
psql -t -c "SELECT
  '- [FishPassage_'||map_tile_display_name||'.pdf](https//cwfwcrp.s3-us-west-1.amazonaws.com/FishPassage_'||map_tile_display_name||'.pdf)'
  FROM whse_basemapping.dbm_mof_50k_grid g
  INNER JOIN whse_basemapping.fwa_watershed_groups_poly w
  ON st_intersects(g.geom, w.geom)
  WHERE w.watershed_group_code = 'HORS'
  ORDER BY watershed_group_name, map_tile_display_name" >> README.md

echo '## Lower Nicola River (LNIC)' >> README.md
psql -t -c "SELECT
  '- [FishPassage_'||map_tile_display_name||'.pdf](https//cwfwcrp.s3-us-west-1.amazonaws.com/FishPassage_'||map_tile_display_name||'.pdf)'
  FROM whse_basemapping.dbm_mof_50k_grid g
  INNER JOIN whse_basemapping.fwa_watershed_groups_poly w
  ON st_intersects(g.geom, w.geom)
  WHERE w.watershed_group_code = 'LNIC'
  ORDER BY watershed_group_name, map_tile_display_name" >> README.md