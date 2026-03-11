BEGIN; 

	alter table bcfishpass.wcrp_watersheds 
	add column bt boolean;

COMMIT;