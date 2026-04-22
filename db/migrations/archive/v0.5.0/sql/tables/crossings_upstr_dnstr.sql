-- note other crossings/barriers upstream / downstream of crossings in crossings table / barriers anth table

create table bcfishpass.crossings_dnstr_crossings (
	aggregated_crossings_id text primary key, 
	features_dnstr text[]
);

create table bcfishpass.crossings_dnstr_barriers_anthropogenic (
	aggregated_crossings_id text primary key, 
	features_dnstr text[]
);

create table bcfishpass.crossings_upstr_barriers_anthropogenic (
	aggregated_crossings_id text primary key, 
	features_upstr text[]
	);

create table bcfishpass.barriers_anthropogenic_dnstr_barriers_anthropogenic (
	barriers_anthropogenic_id text primary key, 
	features_dnstr text[]
);