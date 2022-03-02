.. bcfishpass documentation master file, created by
   sphinx-quickstart on Thu Nov 25 19:27:46 2021.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

bcfishpass
=================================

``bcfishpass`` is a collection of scripts to create and maintain an aquatic connectivity / fish passage database for British Coloumbia.

The generated ``bcfishpass`` database:

- tracks known barriers to fish passage (dams, waterfalls, PSCIS crossings)
- models potential barriers to fish passage (stream gradient, road/rail stream crossings/culverts)
- models passability/accessibility of streams based on barriers and species swimming ability
- models potential habitat (spawning and rearing) for select species
- helps to prioritize barrier assessment and/or remediation
- provides a method for visualizing and quantifying fish passage issues in BC


.. toctree::
   :maxdepth: 2
   :caption: Contents:

   01_setup
   02_usage
   03_tables
   04_functions
