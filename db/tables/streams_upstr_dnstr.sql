--
-- Create tables tracking features downstream of streams (and upstream observations)
--

drop table if exists bcfishpass.streams_dnstr_barriers cascade;
create table bcfishpass.streams_dnstr_barriers (
	segmented_stream_id text primary key,
	barriers_anthropogenic_dnstr text[],
	barriers_pscis_dnstr text[],
	barriers_dams_dnstr text[],
	barriers_dams_hydro_dnstr text[],
	barriers_bt_dnstr text[],
	barriers_ct_dv_rb_dnstr text[],
  barriers_ch_cm_co_pk_sk_dnstr text[],
	barriers_st_dnstr text[],
	barriers_wct_dnstr text[]
);

-- all crossings dnstr, not just barriers
drop table if exists bcfishpass.streams_dnstr_crossings cascade;
create table bcfishpass.streams_dnstr_crossings (
	segmented_stream_id text primary key,
	crossings_dnstr text[]
);

-- remediations/barriers downstream (for mapping barrier type of next downstream barrier)
drop table if exists bcfishpass.streams_dnstr_barriers_remediations cascade;
create table bcfishpass.streams_dnstr_barriers_remediations (
	segmented_stream_id text primary key,
	remediations_barriers_dnstr text[]
);

-- observations (for convenience in the field and reporting, not an input to individual models)
drop table if exists bcfishpass.streams_dnstr_species cascade;
create table bcfishpass.streams_dnstr_species (
	segmented_stream_id text primary key,
	species_codes_dnstr text[]
);

drop table if exists bcfishpass.streams_upstr_observations cascade;
create table bcfishpass.streams_upstr_observations (
	segmented_stream_id text primary key,
	obsrvtn_event_upstr bigint[],
	obsrvtn_species_codes_upstr text[]
);