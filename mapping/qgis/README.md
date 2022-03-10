# QGIS

## FishPassage_30k.qlr

This is a QGIS layer file defining and symbolizing all layers required for general fish passage mapping ([see samples](https://www.hillcrestgeo.ca/outgoing/fishpassage/projects/)).

Generally QGIS works well with large provincial datasets, but in your database connection settings, remember to check:

    [x] Don't resolve types of unrestricted columns (GEOMETRY)
    [x] Use estimated table metadata


### Load additional base data

The QGIS layer file includes several data sources that are not loaded to the `bcfishpass` database by default.

Before downloading, consider editing `tctr_tiles.txt` to specify only NTS 250k tiles within your area of interest.

Download all data to the postgres db specified by `$DATABASE_URL`:

    make


### Change data sources

`bcfishpass` database connection is set as `postgresql://postgres@localhost:5432/bcfishpass`.
If your database connection parameters differ:
- install [`changeDataSource`](https://geogear.wordpress.com/2016/01/29/changedatasourceplugin-plugin-release-2-0/) plugin
- modify the database connection parameters for all `bcfishpass` layers using the find and replace boxes


## 48x36 30k pdfs

When generating pdfs, use the supplied layer file and remember to:
- edit title
- modify selection for records in dbm_mof_50k_grid to match area of interest
- double check that the model displayed is correct:
    + crossings (salmon/steelhead/wct)
    + definite barriers (salmon/steelhead/wct)
    + streams (width=gradient or width=habitat)
- if adding additional legend/text items, check that font matches (arial)
- check that map frame/project CRS matches UTM zone of study area
- modify atlas as required
- export atlas to tif (to reduce file size)
- convert tif to pdf with gdal


