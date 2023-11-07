============================
Data Dictionary
============================

------------------
Freshwater Fish Habitat Accessibility MODEL - Pacific Salmon and Steelhead
------------------
A weekly bcfishpass data extract of Pacific Salmon (Chinook, Chum, Coho, Pink, Sockeye) and Steelhead access models (and associated data) is available for download as a zipped geopackage:

`https://bcfishpass.s3.us-west-2.amazonaws.com/freshwater_fish_habitat_accessibility_MODEL.gpkg.zip <https://bcfishpass.s3.us-west-2.amazonaws.com/freshwater_fish_habitat_accessibility_MODEL.gpkg.zip>`_.

The models included in this distribution are generated as described in the :ref:`access model section <access>`, with the following parameters:

- for salmon, potential :ref:`gradient barriers <gradient_barriers>` are considered passable up to 15%
- for steelhead, potential :ref:`gradient barriers <gradient_barriers>` are considered passable up to 20%
- for both salmon and steelhead, potential natural barriers with 5 or more upstream observations of any of the target species (``CH, CM, CO, PK, SK, ST``) since January 01, 1990 are presumed to be passable

Tables/layers included in the distribution are:


barriers_salmon
============================

Locations of natural barriers to salmon (Chinook, Chum, Coho, Pink, Sockeye) migration
with no other natural barriers downstream, and less than 5 observations of salmon
or steelhead upstream since January 01, 1990.

Includes waterfalls, subsurface flow, gradient barriers of 15% and greater, and
misc user supplied barriers.

.. csv-table::
   :file: tables/freshwater_fish_habitat_accessibility_model/barriers_salmon.csv
   :header-rows: 1


barriers_steelhead
============================

Locations of natural barriers to steelhead migration with no other natural barriers
downstream, and less than 5 observations of salmon or steelhead upstream since January
01, 1990. Includes waterfalls, subsurface flow, gradient barriers of 20% and greater,
and user supplied misc barriers.

.. csv-table::
   :file: tables/freshwater_fish_habitat_accessibility_model/barriers_steelhead.csv
   :header-rows: 1


crossings
============================

Aggregated stream crossing locations.  Features are aggregated from:

- PSCIS stream crossings (where possible to match to an FWA stream)
- CABD dams (where possible to match to an FWA stream)
- modelled road/rail/trail stream crossings
- misc anthropogenic barriers from expert/local input

Includes barrier status, key attributes from source datasets, and various length upstream summaries.

.. csv-table::
   :file: tables/freshwater_fish_habitat_accessibility_model/crossings.csv
   :header-rows: 1


model_access_salmon
============================

All FWA stream downstream of points included in `barriers_salmon`.  In the absence
of anthropogenic barriers, all pacific salmon could potentially access all the streams
included (presuming all else is equal and adequate flow is present in the stream).

.. csv-table::
   :file: tables/freshwater_fish_habitat_accessibility_model/model_access_salmon.csv
   :header-rows: 1


model_access_steelhead
============================

All FWA stream downstream of points included in `barriers_steelhead`.  In the absence
of anthropogenic barriers, steelhead could potentially access all the streams included
(presuming all else is equal and adequate flow is present in the stream).

.. csv-table::
   :file: tables/freshwater_fish_habitat_accessibility_model/model_access_steelhead.csv
   :header-rows: 1


observations
============================

Locations (on the FWA stream network) of known salmon and steelhead observations
used to generate the modelling. Derived from `Known BC Fish Observations <https://catalogue.data.gov.bc.ca/dataset/known-bc-fish-observations-and-bc-fish-distributions>`_
by `bcfishobs <https://github.com/smnorris/bcfishobs>`_.

.. csv-table::
   :file: tables/freshwater_fish_habitat_accessibility_model/observations.csv
   :header-rows: 1


------------------
Gradient barriers
------------------
A static provincial extract of the `gradient_barriers` table is available for download:
`https://bcfishpass.s3.us-west-2.amazonaws.com/gradient_barriers.gpkg.zip <https://bcfishpass.s3.us-west-2.amazonaws.com/gradient_barriers.gpkg.zip>`_.

gradient_barriers
============================
Output of the :ref:`gradient barrier <gradient_barriers>` analysis for commonly used gradients.
Locations of the stream vertex where a stream's slope begins to exceed 5, 10, 15, 20, 25, and 30% for at least
100m upstream.

.. csv-table::
   :file: tables/gradient_barriers.csv
   :header-rows: 1
