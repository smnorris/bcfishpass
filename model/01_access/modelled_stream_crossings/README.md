# Modelling road/railway - stream crossings

Generate potential locations of road/railway stream crossings and associated structures in British Columbia.

In addition to generating the intersection points of roads/railways and streams, attempt to:

- remove duplicate crossings
- identify crossings that are likely to be bridges/open bottom structures
- maintain a consistent unique identifier value (`modelled_crossing_id`) that is stable with script re-runs

**NOTE** 
To ensure that the `modelled_crossing_id` values are consistent, load existing crossings from s3 before running this job.


## Run job

To generate a fresh set of crossings using the latest roads data, using existing ids from existing table `bcfishpass.modelled_stream_crossings` where applicable:

    ./modelled_stream_crossings.sh


## Fixes

Because the above errors will often result in erroneous modelled culverts with a great deal of stream and potential habitat upstream, it is important to conduct a manual review of the modelled crossings before prioritizing sites for field assessment.  A manual review is generally a simple visual review of available satellite imagery - the user can quickly identify sites where it is clear that a bridge is present or no road/stream crossing is present.

To apply these fixes, add the crossing id and fix information for the crossing of interest to [`data/modelled_stream_crossings_fixes.csv`](data/modelled_stream_crossings_fixes.csv)

#### modelled_stream_crossings_fixes.csv

| Column               | Description |
|----------------------|-------------|
|`modelled_crossing_id`| ID of modelled crossing |
|`watershed_group_code`| watershed group code of watershed in which crossing lies (for quick reference only) |
|`reviewer`            | initials of user conducting review |
|`structure`           | `OBS` - a bridge is present; `NONE` - no stream crossing (or structure) is present
|`notes`               | relevant notes based on review of imagery and/or other sources
