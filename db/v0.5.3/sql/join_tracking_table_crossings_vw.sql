
-- This function joins the tracking table to bcfishpass.crossings_wcrp_vw on the barrier ID
create or replace function wcrp_hors.join_tracking_table_crossings_wcrp_vw(p_wcrp text)
	returns void
as
$$
begin 
	execute format('create or replace view wcrp_%I.combined_tracking_table_crossings_wcrp_vw_%I as
				   select 
				   	cv.*, 
				   	tt.*
				   from bcfishpass.crossings_wcrp_vw cv
				   join wcrp_%I.combined_tracking_table_%I tt 
				   	on tt.barrier_id = cv.aggregated_crossings_id', p_wcrp, p_wcrp, p_wcrp, p_wcrp);
end
$$
language plpgsql;

-- loop through each WCRP and create a view for each one
with data (wcrp) as (
	select wcrp
	from bcfishpass.wcrp_watersheds
)
select wcrp_hors.join_tracking_table_crossings_wcrp_vw(wcrp)
from data;