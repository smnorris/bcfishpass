# QGIS

### FishPassage_30k.qlr

This is a QGIS layer file defining and symbolizing all layers required for general fish passage mapping ([see samples](https://www.hillcrestgeo.ca/outgoing/fishpassage/projects/)).

Generally QGIS works well with large provincial datasets, but in your database connection settings, remember to check:

    [x] Don't resolve types of unrestricted columns (GEOMETRY)
    [x] Use estimated table metadata


Even with these options selected, two layers should also be restricted by map tile (QGIS seems to estimate count/extent of input layers when saving a project file - it can hang for several minutes on these large layers if they are not filtered). Adjust the below example filters for each layer when changing your area of interest.

- contours `WHSE_BASEMAPPING.TRIM_CONTOUR_LINES`

        bcgs_tile IN ('093A007','093A023','093A015','093A013','093A016','093A034','093A006','093A036','093A025','093A027','093A014','093A004','093A024','093A044','093A035','093A017','093A018','093A003','093A026','093A005','093A046','093A045','093A047','093A037','093A008','093A033','093A043','093A048','093A029','093A019','093A028','093A038')


- forest cover `WHSE_FOREST_VEGETATION.VEG_COMP_LYR_R1_POLY`

        map_id IN ('093A007','093A023','093A015','093A013','093A016','093A034','093A006','093A036','093A025','093A027','093A014','093A004','093A024','093A044','093A035','093A017','093A018','093A003','093A026','093A005','093A046','093A045','093A047','093A037','093A008','093A033','093A043','093A048','093A029','093A019','093A028','093A038')



Generally, you'll want to find the tiles of interest by watershed group:

```
SELECT DISTINCT t.map_tile
FROM whse_basemapping.bcgs_20k_grid t
INNER JOIN whse_basemapping.fwa_watershed_groups_poly g
ON ST_Intersects(t.geom, g.geom)
WHERE g.watershed_group_code = 'HORS';
```