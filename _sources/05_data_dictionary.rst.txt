============================
Data Distribution
============================

--------------------------------------------------------------------------
BC Fish Passage model (bcfishpass)
--------------------------------------------------------------------------

Weekly bcfishpass data extracts are available for download.

Data contained in these extracts are generated as described in the preceeding documentation, with the following parameters:

- for salmon, potential :ref:`gradient barriers <gradient_barriers>` are considered passable up to 15%
- for steelhead, potential :ref:`gradient barriers <gradient_barriers>` are considered passable up to 20%
- for both salmon and steelhead, potential natural barriers with 5 or more upstream observations of any of the target species (``CH, CM, CO, PK, SK, ST``) since January 01, 1990 are presumed to be passable

Tables/layers included in the distribution are:


streams (lines)
============================
BC FWA stream network, with bcfishpass model classifications.


`https://nrs.objectstore.gov.bc.ca/bchamp/bcfishpass_streams.gpkg.zip <https://nrs.objectstore.gov.bc.ca/bchamp/bcfishpass_streams.gpkg.zip>`_


.. csv-table::
   :file: tables/streams_vw.csv
   :header-rows: 1


crossings (points)
============================
Road-stream crossings (and dams), including tenure information; barrier status; upstream/downstream habitat lengths

`https://nrs.objectstore.gov.bc.ca/bchamp/bcfishpass_crossings.gpkg.zip <https://nrs.objectstore.gov.bc.ca/bchamp/bcfishpass_crossings.gpkg.zip>`_

.. csv-table::
   :file: tables/crossings_vw.csv
   :header-rows: 1


linear_summary (non-spatial)
============================
A summary of linear habitat for Pacific Salmon (Chinook, Chum, Coho, Pink, Sockeye) and Steelhead, per FWA assessment watershed.

`https://nrs.objectstore.gov.bc.ca/bchamp/aw_linear_summary_psf.csv <https://nrs.objectstore.gov.bc.ca/bchamp/aw_linear_summary_psf.csv>`_

.. csv-table::
   :file: tables/linear_summary.csv
   :header-rows: 1


pse_migration_paths (non-spatial)
=================================
Migration paths between modelled spawning/rearing in PSE Conservation Units and the ocean, represented by FWA stream network identifiers.

| `https://nrs.objectstore.gov.bc.ca/bchamp/cu_migration_paths_ch.csv.gz <https://nrs.objectstore.gov.bc.ca/bchamp/cu_migration_paths_ch.csv.gz>`_
| `https://nrs.objectstore.gov.bc.ca/bchamp/cu_migration_paths_cm.csv.gz <https://nrs.objectstore.gov.bc.ca/bchamp/cu_migration_paths_cm.csv.gz>`_
| `https://nrs.objectstore.gov.bc.ca/bchamp/cu_migration_paths_co.csv.gz <https://nrs.objectstore.gov.bc.ca/bchamp/cu_migration_paths_co.csv.gz>`_
| `https://nrs.objectstore.gov.bc.ca/bchamp/cu_migration_paths_pk.csv.gz <https://nrs.objectstore.gov.bc.ca/bchamp/cu_migration_paths_pk.csv.gz>`_
| `https://nrs.objectstore.gov.bc.ca/bchamp/cu_migration_paths_sk.csv.gz <https://nrs.objectstore.gov.bc.ca/bchamp/cu_migration_paths_sk.csv.gz>`_
| `https://nrs.objectstore.gov.bc.ca/bchamp/cu_migration_paths_st.csv.gz <https://nrs.objectstore.gov.bc.ca/bchamp/cu_migration_paths_st.csv.gz>`_


.. csv-table::
   :file: tables/cu_migration_paths.csv
   :header-rows: 1

Note that ``segmented_stream_id`` is based on FWA ``blue_line_key`` and ``downstream_route_measure`` for a given segment.
When the segmentation by bcfishpass modelling changes, the ``segmented_stream_id`` will also change. When joining the two datasets,
be sure they are from the same model run.


----------------------------------------------------------------
Pacific Salmon and Steelhead access model (subset of bcfishpass)
----------------------------------------------------------------

A `weekly provincial data extract <https://bcgov.github.io/bc_freshwater_fish_habitat_accessibility_model/04_data_distribution.html>`_ of Pacific Salmon (Chinook, Chum, Coho, Pink, Sockeye) and Steelhead access models (and associated data) is provided by the Province of BC. See documentation in the bcgov repository for full data definitions.

