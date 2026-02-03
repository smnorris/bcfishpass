# Gradient barrier interval/threshold analysis

Generate data for selecting length interval at which we generate gradient barriers and subsequent per-species gradient thresholds.

Measure gradients (to nearest 1%) at:
- 100m
- 50m
- 25m 


## Analysis

On a bcfishpass db at tag `v0.8.0`:

    ./observations_dnstr_gradients.sh 
	
## outputs

Three .csv files are generated, with one row per salmon/steelhead observation:

| column                            | description                   |
|-----------------------------------| ----------------------------- |
| observation_key                   | observation unique identifier |
| species_code                      | observation species code |
| watershed_group_code              | watershed group code at observation |
| stream_order                      | stream order at observation |
| elevation                         | elevation at observation |
| obs_dist_to_ocean                 | distance from observation downstream to ocean |
| upstr100m_grade                   | maximum gradient within 100m upstream of observation |
| dnstr_max_grade                   | maximum gradient (>5%) downstream of observation |
| dnstr_max_grade_dist_to_ocean_km  | distance from start (downstream end) of max gradient downstream of observation, downstream to the ocean |
  
