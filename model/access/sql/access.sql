-- access is almost completely coded by running the _dnstr processing.
-- however, because we process multiple spp at once, a null value does not necessarily mean
-- a stream is accessible, it may merely be in a watershed for which the species is not present
-- So, for watersheds where species *is* present, fill in access model columns with empty array 
-- where no barrier exists downstream to make access model queries relatively straightforward

-- this is an unfortunate hack - but necessary at this point to avoid having to re-write all 
-- access queries to join to the species presence table (or creating a new access code column 
-- for each spp)

update bcfishpass.streams
set barriers_bt_dnstr = array[]::text[]
where barriers_bt_dnstr is null and
watershed_group_code in (
	select p.watershed_group_code
	from bcfishpass.param_watersheds p
	inner join bcfishpass.wsg_species_presence s
	on p.watershed_group_code = s.watershed_group_code
	where s.bt is not null
);

update bcfishpass.streams
set barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
where barriers_ch_cm_co_pk_sk_dnstr is null and
watershed_group_code in (
	select p.watershed_group_code
	from bcfishpass.param_watersheds p
	inner join bcfishpass.wsg_species_presence s
	on p.watershed_group_code = s.watershed_group_code
	where s.ch is not null or s.cm is not null or s.co is not null or s.pk is not null or s.sk is not null
);

update bcfishpass.streams
set barriers_st_dnstr = array[]::text[]
where barriers_st_dnstr is null and
watershed_group_code in (
	select p.watershed_group_code
	from bcfishpass.param_watersheds p
	inner join bcfishpass.wsg_species_presence s
	on p.watershed_group_code = s.watershed_group_code
	where s.st is not null
);

update bcfishpass.streams
set barriers_wct_dnstr = array[]::text[]
where barriers_wct_dnstr is null and
watershed_group_code in (
	select p.watershed_group_code
	from bcfishpass.param_watersheds p
	inner join bcfishpass.wsg_species_presence s
	on p.watershed_group_code = s.watershed_group_code
	where s.wct is not null
);
