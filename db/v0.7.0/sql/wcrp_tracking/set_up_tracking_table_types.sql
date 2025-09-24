-- Creates the enum types and trigger functions for all tracking tables
-- Only needs to be run once. All tracking tables (even outside of wcrp_hors) can reuse these types and triggers.
drop type if exists
	wcrp_hors.tt_structure_type,
	wcrp_hors.tt_structure_list_status_type,
	wcrp_hors.tt_assessment_type,
	wcrp_hors.tt_excl_reason_type,
	wcrp_hors.tt_excl_method_type,
	wcrp_hors.tt_partial_passability_type,
	wcrp_hors.tt_partial_passability_notes_type,
	wcrp_hors.tt_upstr_hab_quality_type,
	wcrp_hors.tt_priority_type,
	wcrp_hors.tt_rehabilitation_type,
	wcrp_hors.tt_next_steps_type,
	wcrp_hors.tt_constructability_type;
	

CREATE TYPE wcrp_hors.tt_structure_type AS ENUM
    ('Dam', 'Stream crossing - OBS', 'Stream crossing - CBS', 'Stream crossing - Ford', 'Other', 'None', '');
	
CREATE TYPE wcrp_hors.tt_structure_list_status_type AS ENUM
    ('Assessed structure that remains data deficient', 'Confirmed barrier', 'Rehabilitated barrier', 'Excluded structure', '');
	
CREATE TYPE wcrp_hors.tt_assessment_type AS ENUM
    ('Informal assessment', 
	 'Barrier assessment', 
	 'Habitat confirmation', 
	 'Detailed habitat investigation', 
	 'Engineering design', 'Rehabilitated', 
	 'Post-rehabilitation monitoring', 
	 'Other',
	 '');
	
CREATE TYPE wcrp_hors.tt_excl_reason_type AS ENUM
    ('Passable', 'No structure', 'No key upstream habitat', 'No structure and key upstream habitat', '');
	
CREATE TYPE wcrp_hors.tt_excl_method_type AS ENUM
    ('Imagery review', 'Informal assessment', 'Field assessment', 'Local knowledge', '');
	
CREATE TYPE wcrp_hors.tt_partial_passability_type AS ENUM
    ('Yes', 'No', 'Unknown');
	
CREATE TYPE wcrp_hors.tt_partial_passability_notes_type AS ENUM
    ('Proportion of individuals', 'Proportion of time', 'Other (see notes)','');
	
CREATE TYPE wcrp_hors.tt_upstr_hab_quality_type AS ENUM
    ('High', 'Medium', 'Low', 'N/A or unassessed');
	
CREATE TYPE wcrp_hors.tt_priority_type AS ENUM
    ('High', 'Medium', 'Low', 'Non-actionable', '');
	
CREATE TYPE wcrp_hors.tt_rehabilitation_type AS ENUM
    ('Removal/decommissioned', 'Replacement - OBS', 'Replacement - CBS', 'Retrofit', '');
	
CREATE TYPE wcrp_hors.tt_next_steps_type AS ENUM
    ('Barrier assessment (data deficient structures only)', 
	 'Habitat confirmation (data deficient structures only)',
	 'In-depth habitat investigation (data deficient structures only)',
	 'In-depth passage assessment (data deficient structures only)', 
	 'Engage with barrier owner', 
	 'Bring barrier to regulator',
	 'Commission engineering designs', 
	 'Leave until end of lifecycle', 
	 'Identify barrier owner', 
	 'Engage in public consultation',
	 'Fundraise', 
	 'Rehabilitation',
	 'Post-rehabilitation monitoring',
	 'N/A - project complete (rehabilitated structures only)', 
	 'Engage with partners',
	 'Barrier reassessment',
	 'Non-actionable',
	 ''
	);


	
create type wcrp_hors.tt_constructability_type as enum (
	'Difficult',
	'Moderate',
	'Easy',
	''
);


create or replace function wcrp_hors.blank2null()
	returns trigger
	language plpgsql as
$func$
begin
	if NEW.structure_list_status = '' then
		NEW.structure_list_status = NULL;
	end if;
	
	if NEW.structure_type = '' then
		NEW.structure_type = NULL;
	end if;
	
	if NEW.assessment_type_completed = '' then
		NEW.assessment_type_completed = NULL;
	end if;
	
	if NEW.reason_for_exclusion = '' then
		NEW.reason_for_exclusion = NULL;
	end if;
	
	if NEW.method_of_exclusion = '' then
		NEW.method_of_exclusion = NULL;
	end if;
	
	if NEW.partial_passability_notes = '' then
		NEW.partial_passability_notes = NULL;
	end if;
	
	if NEW.constructability = '' then
		NEW.constructability = NULL;
	end if;
	
	if NEW.priority = '' then
		NEW.priority = NULL;
	end if;
	
	if NEW.type_of_rehabilitation = '' then
		NEW.type_of_rehabilitation = NULL;
	end if;
	
	if NEW.next_steps = '' then
		NEW.next_steps = NULL;
	end if;
	
	return NEW;
end
$func$;