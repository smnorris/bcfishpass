CREATE OR REPLACE FUNCTION bcfishpass.streamsasmvt(
            z integer, x integer, y integer)
RETURNS bytea
AS $$
DECLARE
    result bytea;
BEGIN
    WITH
    
    bounds AS (
      SELECT ST_TileEnvelope(z, x, y) AS geom
    ), 

    mvtgeom AS (
      SELECT
        s.segmented_stream_id,
        s.linear_feature_id,
        s.edge_type,
        s.blue_line_key,
        s.watershed_key,
        s.watershed_group_code,
        s.downstream_route_measure,
        s.length_metre,
        s.waterbody_key,
        s.wscode_ltree,
        s.localcode_ltree,
        s.gnis_name,
        s.stream_order,
        s.stream_magnitude,
        s.gradient,
        s.feature_code,
        s.upstream_route_measure,
        s.upstream_area_ha,
        s.stream_order_parent,
        s.stream_order_max,
        s.map_upstream,
        s.channel_width,
        s.mad_m3s,
        s.barriers_anthropogenic_dnstr,
        s.barriers_pscis_dnstr,
        s.barriers_dams_dnstr,
        s.barriers_dams_hydro_dnstr,
        s.barriers_bt_dnstr,
        s.barriers_ch_cm_co_pk_sk_dnstr,
        s.barriers_ct_dv_rb_dnstr,
        s.barriers_st_dnstr,
        s.barriers_wct_dnstr,
        s.crossings_dnstr,
        s.dam_dnstr_ind,
        s.dam_hydro_dnstr_ind,
        s.remediated_dnstr_ind,
        s.obsrvtn_event_upstr,
        s.obsrvtn_species_codes_upstr,
        s.species_codes_dnstr,
        s.model_spawning_bt,
        s.model_spawning_ch,
        s.model_spawning_cm,
        s.model_spawning_co,
        s.model_spawning_pk,
        s.model_spawning_sk,
        s.model_spawning_st,
        s.model_spawning_wct,
        s.model_rearing_bt,
        s.model_rearing_ch,
        s.model_rearing_co,
        s.model_rearing_sk,
        s.model_rearing_st,
        s.model_rearing_wct,
        s.mapping_code_bt,
        s.mapping_code_ch,
        s.mapping_code_cm,
        s.mapping_code_co,
        s.mapping_code_pk,
        s.mapping_code_sk,
        s.mapping_code_st,
        s.mapping_code_wct,
        s.mapping_code_salmon,
        ST_AsMVTGeom(ST_Transform(ST_Force2D(s.geom), 3857), bounds.geom)
      FROM bcfishpass.streams s, bounds
      WHERE ST_Intersects(s.geom, ST_Transform((select geom from bounds), 3005))
      AND s.edge_type != 6010 
      AND s.wscode_ltree is not null
      AND s.stream_order_max >= (-z + 13)
     )

    SELECT ST_AsMVT(mvtgeom, 'default')
    INTO result
    FROM mvtgeom;

    RETURN result;
END;
$$
LANGUAGE 'plpgsql'
STABLE
PARALLEL SAFE;

COMMENT ON FUNCTION bcfishpass.streamsasmvt IS 'Zoom-level dependent bcfishpass streams';