-- load connectivity numbers per wcrp

select
   :'wcrp' as wcrp,
   
    sum(st_length(geom)) filter (where h.spawning_ch > 0) as total_spawning_ch,
    sum(st_length(geom)) filter (where h.spawning_co > 0) as total_spawning_co,
    sum(st_length(geom)) filter (where h.spawning_sk > 0) as total_spawning_sk,
    sum(st_length(geom)) filter (where h.spawning_st > 0) as total_spawning_st,
    sum(st_length(geom)) filter (where h.spawning_wct > 0) as total_spawning_wct,

    sum(st_length(geom)) filter (where h.rearing_ch > 0) as total_rearing_ch,
    sum(st_length(geom)) filter (where h.rearing_co > 0) as total_rearing_co,
    sum(st_length(geom)) filter (where h.rearing_sk > 0) as total_rearing_sk,
    sum(st_length(geom)) filter (where h.rearing_st > 0) as total_rearing_st,
    sum(st_length(geom)) filter (where h.rearing_wct > 0) as total_rearing_wct,

    sum(st_length(geom)) filter (where greatest(h.spawning_ch, h.rearing_ch) > 0) as total_spawningrearing_ch,
    sum(st_length(geom)) filter (where greatest(h.spawning_co, h.rearing_co) > 0) as total_spawningrearing_co,
    sum(st_length(geom)) filter (where greatest(h.spawning_sk, h.rearing_sk) > 0) as total_spawningrearing_sk,
    sum(st_length(geom)) filter (where greatest(h.spawning_st, h.rearing_st) > 0) as total_spawningrearing_st,
    sum(st_length(geom)) filter (where greatest(h.spawning_wct, h.rearing_wct) > 0) as total_spawningrearing_wct,

    sum(st_length(geom)) filter (where greatest(<spawning_columns>) > 0) as total_spawning_all,
    sum(st_length(geom)) filter (where greatest(<rearing_columns>) > 0) as total_rearing_all,
    sum(st_length(geom)) filter (where greatest(<spawning_columns>, <rearing_columns>) > 0) as total_spawningrearing_all,


    sum(st_length(geom)) filter (where h.spawning_ch > 0 and a.barriers_anthropogenic_dnstr IS NULL) as total_spawning_ch,
    sum(st_length(geom)) filter (where h.spawning_co > 0 and a.barriers_anthropogenic_dnstr IS NULL) as total_spawning_co,
    sum(st_length(geom)) filter (where h.spawning_sk > 0 and a.barriers_anthropogenic_dnstr IS NULL) as total_spawning_sk,
    sum(st_length(geom)) filter (where h.spawning_st > 0 and a.barriers_anthropogenic_dnstr IS NULL) as total_spawning_st,
    sum(st_length(geom)) filter (where h.spawning_wct > 0 and a.barriers_anthropogenic_dnstr IS NULL) as total_spawning_wct,

    sum(st_length(geom)) filter (where h.rearing_ch > 0 and a.barriers_anthropogenic_dnstr IS NULL) as total_rearing_ch,
    sum(st_length(geom)) filter (where h.rearing_co > 0 and a.barriers_anthropogenic_dnstr IS NULL) as total_rearing_co,
    sum(st_length(geom)) filter (where h.rearing_sk > 0 and a.barriers_anthropogenic_dnstr IS NULL) as total_rearing_sk,
    sum(st_length(geom)) filter (where h.rearing_st > 0 and a.barriers_anthropogenic_dnstr IS NULL) as total_rearing_st,
    sum(st_length(geom)) filter (where h.rearing_wct > 0 and a.barriers_anthropogenic_dnstr IS NULL) as total_rearing_wct,

    sum(st_length(geom)) filter (where greatest(h.spawning_ch, h.rearing_ch) > 0 and a.barriers_anthropogenic_dnstr IS NULL) as total_spawningrearing_ch,
    sum(st_length(geom)) filter (where greatest(h.spawning_co, h.rearing_co) > 0 and a.barriers_anthropogenic_dnstr IS NULL) as total_spawningrearing_co,
    sum(st_length(geom)) filter (where greatest(h.spawning_sk, h.rearing_sk) > 0 and a.barriers_anthropogenic_dnstr IS NULL) as total_spawningrearing_sk,
    sum(st_length(geom)) filter (where greatest(h.spawning_st, h.rearing_st) > 0 and a.barriers_anthropogenic_dnstr IS NULL) as total_spawningrearing_st,
    sum(st_length(geom)) filter (where greatest(h.spawning_wct, h.rearing_wct) > 0 and a.barriers_anthropogenic_dnstr IS NULL) as total_spawningrearing_wct,

    sum(st_length(geom)) filter (where greatest(<spawning_columns>) > 0 and a.barriers_anthropogenic_dnstr IS NULL) as total_spawning_all,
    sum(st_length(geom)) filter (where greatest(<rearing_columns>) > 0 and a.barriers_anthropogenic_dnstr IS NULL) as total_rearing_all,
    sum(st_length(geom)) filter (where greatest(<spawning_columns>, <rearing_columns>) > 0 and a.barriers_anthropogenic_dnstr IS NULL) as total_spawningrearing_all,
 from bcfishpass.streams s
 inner join bcfishpass.streams_habitat_linear h using (segmented_stream_id)
 inner join bcfishpass.streams_access a using (segmented_stream_id)
 where <CONDITION>