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

Three .csv files are generated:

observations_max_gradients_downstream - all salmon/steelhead observations (non releases) and max downstream gradient
salmon_uniqueobslocation_max_gradients_downstream - distinct species/location for salmon and max dnstr gradient
steelhead_uniqueobslocation_max_gradients_downstream - distinct location/adult flag for steelhead and max dnstr gradient

