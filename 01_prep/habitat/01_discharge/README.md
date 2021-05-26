# Discharge

Modelled mean annual discharge data is provided under license by Foundry Spatial for fish habitat modelling by Canadian Wildlife Federation in the Bulkley and Horsefly watersheds (and scheduled to be provided for the Lower Nicola in spring 2021).

These scripts are provided for convenience and completeness - for data access, please contact CWF and/or Foundry.


With discharge shapefile `cwf_mad_funds.shp` extracted and loaded to current working directory, run the load script and convert the provided discharge per watershed data into a table of discharge per stream (output table is `foundry.fwa_streams_mad`):


`./discharge.sh`

Although discharge values are not required to run the channel width model, the output table `foundry.fwa_streams_mad` is required.  Therefore, for users wishing to run the channel width version of the model that do not have access to the mean annual discharge data run:

`./discharge_norun.sh`
