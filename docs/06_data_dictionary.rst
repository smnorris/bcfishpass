============================
Data Dictionary
============================

------------------
Freshwater Fish Habitat Accessibility MODEL - Pacific Salmon and Steelhead
------------------
A weekly bcfishpass data extract of Pacific Salmon (Chinook, Chum, Coho, Pink, Sockeye) and Steelhead access models (and associated data) is `available for download <https://bcfishpass.s3.us-west-2.amazonaws.com/freshwater_fish_habitat_accessibility_MODEL.gpkg.zip>`_.

The models included in this distribution are generated as described in the :ref:`access model section <access>`, with the following parameters:

- for salmon, potential :ref:`gradient barriers <gradient_barriers>` are considered passable up to 15%
- for steelhead, potential :ref:`gradient barriers <gradient_barriers>` are considered passable up to 20%
- for both salmon and steelhead, potential natural barriers with 5 or more upstream observations of any of the target species (``CH, CM, CO, PK, SK, ST``) since January 01, 1990 are presumed to be passable

Tables/layers included in the distribution are:


crossings
============================

Aggregated stream crossing locations.  Features are aggregated from:

- PSCIS stream crossings (where possible to match to an FWA stream)
- CABD dams (where possible to match to an FWA stream)
- modelled road/rail/trail stream crossings
- misc anthropogenic barriers from expert/local input

aIncludes barrier status, key attributes from source datasets, and various length upstream summaries.

.. csv-table::
   :file: tables/freshwater_fish_habitat_accessibility_model/crossings.csv
   :header-rows: 1


gradient_barriers
============================


barriers_subsurfaceflow
============================


barriers_falls
============================


barriers_salmon
============================


barriers_steelhead
============================


model_access_salmon
============================


model_access_steelhead
============================


observations
============================