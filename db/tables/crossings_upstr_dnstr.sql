-- note other crossings/barriers upstream / downstream of crossings in crossings table / barriers anth table

drop table if exists bcfishpass.crossings_dnstr_crossings cascade;
create table bcfishpass.crossings_dnstr_crossings (
	aggregated_crossings_id text primary key, 
	features_dnstr text[]
);

drop table if exists bcfishpass.crossings_dnstr_barriers_anthropogenic cascade;
create table bcfishpass.crossings_dnstr_barriers_anthropogenic (
	aggregated_crossings_id text primary key, 
	features_dnstr text[]
);

drop table if exists bcfishpass.crossings_upstr_barriers_anthropogenic cascade;
create table bcfishpass.crossings_upstr_barriers_anthropogenic (
	aggregated_crossings_id text primary key, 
	features_upstr text[]
	);

drop table if exists bcfishpass.barriers_anthropogenic_dnstr_barriers_anthropogenic cascade;
create table bcfishpass.barriers_anthropogenic_dnstr_barriers_anthropogenic (
	barriers_anthropogenic_id text primary key, 
	features_dnstr text[]
);