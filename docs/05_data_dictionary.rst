============================
Data Distribution
============================

--------------------------------------------------------------------------
BC Fish Passage model (bcfishpass)
--------------------------------------------------------------------------

A weekly bcfishpass data extract is available for download as a zipped geopackage:

`https://nrs.objectstore.gov.bc.ca/bchamp/bcfishpass.gpkg.zip <https://nrs.objectstore.gov.bc.ca/bchamp/bcfishpass.gpkg.zip>`_.

The models included in this distribution are generated as described in the :ref:`model description section <description>`, with the following parameters:

- for salmon, potential :ref:`gradient barriers <gradient_barriers>` are considered passable up to 15%
- for steelhead, potential :ref:`gradient barriers <gradient_barriers>` are considered passable up to 20%
- for both salmon and steelhead, potential natural barriers with 5 or more upstream observations of any of the target species (``CH, CM, CO, PK, SK, ST``) since January 01, 1990 are presumed to be passable

Tables/layers included in the distribution are:


streams (lines)
============================
BC FWA stream network, with bcfishpass model classifications.

.. csv-table::
   :file: tables/streams_vw.csv
   :header-rows: 1


crossings (points)
============================
Road-stream crossings (and dams), including tenure information; barrier status; upstream/downstream habitat lengths


.. csv-table::
   :file: tables/crossings_vw.csv
   :header-rows: 1


linear_summary
============================
A weekly report of `connectivity status per FWA assessment watershed <https://nrs.objectstore.gov.bc.ca/bchamp/aw_linear_summary_psf.csv>`_  for Pacific Salmon (Chinook, Chum, Coho, Pink, Sockeye) and Steelhead.
The report summarizes total modelled naturally accessible length per species, and total modelled spawning/rearing accessible length per species.

.. csv-table::
   :file: tables/linear_summary.csv
   :header-rows: 1


------------------
Pacific Salmon and Steelhead access model (subset of habitat model)
------------------

A `weekly provincial data extract <https://bcgov.github.io/bc_freshwater_fish_habitat_accessibility_model/04_data_distribution.html>`_ of Pacific Salmon (Chinook, Chum, Coho, Pink, Sockeye) and Steelhead access models (and associated data) is provided by the Province of BC. See documentation in the bcgov repository for full data definitions.

