.. bcfishpass documentation master file, created by
   sphinx-quickstart on Thu Nov 25 19:27:46 2021.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

bcfishpass
=================================

``bcfishpass`` is a collection of scripts to create and maintain an aquatic connectivity / fish passage database for British Columbia.

The ``bcfishpass`` database:

- tracks/models natural barriers to fish passage (waterfalls, steep gradients, other)
- tracks/models anthropogenic barriers to fish passage (dams, road-stream crossings, other)
- models accessibility of streams to given fish species based on natural and anthropogenic barriers
- models potential spawning and rearing habitat for select species based on stream gradient and either modelled discharge or modelled channel width
- enables prioritization of road-stream crossing sites for field assessment
- provides tools for visualizing and quantifying aquatic connectivity / fish passage issues in BC


.. toctree::
   :maxdepth: 2
   :caption: Contents:

   01_background
   02_model_access
   03_model_habitat_linear
   04_model_habitat_lateral
   05_data_dictionary
   06_credits
