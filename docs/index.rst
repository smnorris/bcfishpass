.. bcfishpass documentation master file, created by
   sphinx-quickstart on Thu Nov 25 19:27:46 2021.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

bcfishpass
=================================

``bcfishpass`` is a collection of scripts to create and maintain an aquatic connectivity / fish passage database for British Coloumbia.

The generated ``bcfishpass`` database:

- tracks/models natural barriers to fish passage (waterfalls, steep gradients, other)
- tracks/models anthropogenic barriers to fish passage (dams, road/rail stream crossings, other)
- models accessibility of streams to given fish species based on natural and anthropogenic barriers
- models potential spawning and rearing habitat for select species based on stream gradient and discharge
- provides data for prioritization of stream crossing sites for assessment and/or remediation
- provides a method for visualizing and quantifying fish passage issues in BC


.. toctree::
   :maxdepth: 2
   :caption: Contents:

   01_background
   02_methodology
   03_example_use_cases
   04_table_definitions
