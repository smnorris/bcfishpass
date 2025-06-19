============================
Data Dictionary
============================

Weekly bcfishpass data extracts are available for download as zipped geopackages.

The models included in this distribution are generated as described in the :ref:`model description section <description>`, with the following parameters:

- for salmon, potential :ref:`gradient barriers <gradient_barriers>` are considered passable up to 15%
- for steelhead, potential :ref:`gradient barriers <gradient_barriers>` are considered passable up to 20%
- for both salmon and steelhead, potential natural barriers with 5 or more upstream observations of any of the target species (``CH, CM, CO, PK, SK, ST``) since January 01, 1990 are presumed to be passable

Files included in the distribution are:


crossings (points)
============================
`https://nrs.objectstore.gov.bc.ca/bchamp/bcfishpass.gpkg.zip <https://nrs.objectstore.gov.bc.ca/bchamp/bcfishpass_crossings.gpkg.zip>`_.

Road-stream crossings (and dams), including: tenure information; barrier status; upstream/downstream habitat lengths

.. csv-table::
   :file: tables/crossings_vw.csv
   :header-rows: 1


streams (lines)
============================
`https://nrs.objectstore.gov.bc.ca/bchamp/bcfishpass.gpkg.zip <https://nrs.objectstore.gov.bc.ca/bchamp/bcfishpass_streams.gpkg.zip>`_.

BC FWA stream network, with bcfishpass model classifications.

.. csv-table::
   :file: tables/streams_vw.csv
   :header-rows: 1


summary_linear (non-spatial)
============================
`https://nrs.objectstore.gov.bc.ca/bchamp/bcfishpass.gpkg.zip <https://nrs.objectstore.gov.bc.ca/bchamp/bcfishpass_aw_summary_linear.csv.zip>`_.

FWA Assessment Watershed habitat and connectivity status reporting for Pacific Salmon (Chinook, Chum, Coho, Pink, Sockeye) and Steelhead.
The report summarizes total modelled naturally accessible length per species, and total modelled spawning/rearing accessible length per species.

.. csv-table::
   :file: tables/linear_summary.csv
   :header-rows: 1
