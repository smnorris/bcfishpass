# Manual habitat classification


Habitat model outputs will often disagree with expert/local knowledge of target species behaviour.

The table `bcfishpass.manual_habitat_classification` provides a method to override modelled habitat outputs
with known habitat/non-habitat classifications.

Add records to `manual_habitat_classification.csv` where spawning/rearing is known to occur/known not to occur.

To load data:

    ./manual_habitat_classification.sh