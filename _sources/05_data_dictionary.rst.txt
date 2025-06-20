============================
Data Dictionary
============================

Weekly bcfishpass data extracts are available for download as zipped geopackages.

Access and linear habitat models included in this distribution are generated as described in the previous sections, with the following parameters:

- for salmon, potential :ref:`gradient barriers <gradient_barriers>` are considered passable up to 15%
- for steelhead, potential :ref:`gradient barriers <gradient_barriers>` are considered passable up to 20%
- for both salmon and steelhead, potential natural barriers with 5 or more upstream observations of any of the target species (``CH, CM, CO, PK, SK, ST``) since January 01, 1990 are presumed to be passable

Draft Bull Trout and Westslope Cutthroat Trout models are also included:

- for Bull Trout, potential :ref:`gradient barriers <gradient_barriers>` are considered passable up to 25%
- for Westslope Cutthroat Trout, potential :ref:`gradient barriers <gradient_barriers>` are considered passable up to 20%
- for both Bull Trout and Westslope Cutthroat Trout, potential natural barriers are presumed to be passable if any observation(s) of the target species are found upstream

Linear spawning/rearing habitat (intrinsic potential) parameters/methods are as specified by the Canadian Wildlife Federation:

- `habitat thresholds <https://github.com/smnorris/bcfishpass/blob/main/parameters/example_cwf/parameters_habitat_thresholds.csv>`_
- `watersheds and methods <https://github.com/smnorris/bcfishpass/blob/main/parameters/example_cwf/parameters_habitat_method.csv>`_

Note that while stream discharge (m3/s) is used to model habitat in the Bulkley, Horsefly and Elk River watershed groups, proprietary data
discharge was used. Discharge data is not provided in these files for those watershed groups.


Files included in this data distribution are:

- `bcfishpass_crossings.gpkg.zip <https://nrs.objectstore.gov.bc.ca/bchamp/bcfishpass_crossings.gpkg.zip>`_
- `bcfishpass_streams.gpkg.zip <https://nrs.objectstore.gov.bc.ca/bchamp/bcfishpass_streams.gpkg.zip>`_
- `bcfishpass_summary_aw_linear.csv <https://nrs.objectstore.gov.bc.ca/bchamp/bcfishpass_summary_aw_linear.csv>`_

Note that draft lateral habitat modelling is not included - this is available on request.


`crossings <https://nrs.objectstore.gov.bc.ca/bchamp/bcfishpass_crossings.gpkg.zip>`_ (points)
============================

Road-stream crossings (and dams), including: tenure information; barrier status; upstream/downstream habitat lengths

.. csv-table::
   :file: tables/crossings_vw.csv
   :header-rows: 1


`streams <https://nrs.objectstore.gov.bc.ca/bchamp/bcfishpass_streams.gpkg.zip>`_ (lines)
============================

BC FWA stream network, with bcfishpass model classifications.

.. csv-table::
   :file: tables/streams_vw.csv
   :header-rows: 1


`summary_aw_linear <https://nrs.objectstore.gov.bc.ca/bchamp/bcfishpass_summary_aw_linear.csv>`_ (non-spatial)
============================

A `FWA Assessment Watershed <https://catalogue.data.gov.bc.ca/dataset/freshwater-atlas-assessment-watersheds>`_ level summary report of habitat
and connectivity status for Pacific Salmon (Chinook, Chum, Coho, Pink, Sockeye), Steelhead, Bull Trout and Westslope Cutthroat Trout.
The report summarizes total modelled naturally accessible length per species, and total modelled spawning/rearing accessible length per species.

.. csv-table::
   :file: tables/summary_aw_linear.csv
   :header-rows: 1
