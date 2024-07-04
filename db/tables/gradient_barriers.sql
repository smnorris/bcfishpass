CREATE TABLE bcfishpass.gradient_barriers (
	 gradient_barrier_id bigint GENERATED ALWAYS AS ((((blue_line_key::bigint + 1) - 354087611) * 10000000) + round(downstream_route_measure::bigint)) STORED PRIMARY KEY,
	 blue_line_key             integer               ,
	 downstream_route_measure  double precision      ,
	 wscode_ltree              ltree                 ,
	 localcode_ltree           ltree                 ,
	 watershed_group_code      character varying(4)  ,
	 gradient_class            integer
 );

create index grdntbr_blk_idx on bcfishpass.gradient_barriers (blue_line_key);
create index grdntbr_wsgcode_idx on bcfishpass.gradient_barriers (watershed_group_code);
create index grdntbr_wscode_gidx on bcfishpass.gradient_barriers using gist (wscode_ltree);
create index grdntbr_wscode_bidx on bcfishpass.gradient_barriers using btree (wscode_ltree);
create index grdntbr_localcode_gidx on bcfishpass.gradient_barriers using gist (localcode_ltree);
create index grdntbr_localcode_bidx on bcfishpass.gradient_barriers using btree (localcode_ltree);