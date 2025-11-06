-- support salmon species specific access models

ALTER TABLE bcfishpass.streams_dnstr_barriers
ADD COLUMN barriers_ch_dnstr text[];

ALTER TABLE bcfishpass.streams_dnstr_barriers
ADD COLUMN barriers_cm_dnstr text[];

ALTER TABLE bcfishpass.streams_dnstr_barriers
ADD COLUMN barriers_co_dnstr text[];

ALTER TABLE bcfishpass.streams_dnstr_barriers
ADD COLUMN barriers_pk_dnstr text[];

ALTER TABLE bcfishpass.streams_dnstr_barriers
ADD COLUMN barriers_sk_dnstr text[];


-- enable constraining access to below set elevation by creating
-- elevation barriers

CREATE TABLE bcfishpass.elevation_barriers (
   elevation_barrier_id bigint GENERATED ALWAYS AS ((((blue_line_key::bigint + 1) - 354087611) * 10000000) + round(downstream_route_measure::bigint)) STORED PRIMARY KEY,
   blue_line_key             integer               ,
   downstream_route_measure  double precision      ,
   wscode_ltree              ltree                 ,
   localcode_ltree           ltree                 ,
   watershed_group_code      character varying(4)  ,
   elevation                integer
 );

create index elevbr_blk_idx on bcfishpass.elevation_barriers (blue_line_key);
create index elevbr_wsgcode_idx on bcfishpass.elevation_barriers (watershed_group_code);
create index elevbr_wscode_gidx on bcfishpass.elevation_barriers using gist (wscode_ltree);
create index elevbr_wscode_bidx on bcfishpass.elevation_barriers using btree (wscode_ltree);
create index elevbr_localcode_gidx on bcfishpass.elevation_barriers using gist (localcode_ltree);
create index elevbr_localcode_bidx on bcfishpass.elevation_barriers using btree (localcode_ltree);