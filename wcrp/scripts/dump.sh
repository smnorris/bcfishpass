#!/bin/bash
set -euxo pipefail


# Iterate over each plan_code

yq -o=json --indent 0 '.[]' wcrp/plan_config.yaml | while read -r plan; do
    
  plan_code=$(echo "$plan" | jq -r '.plan_code')
  plan_schema=$(echo "$plan" | jq -r '.plan_schema')
  filter_clause=$(echo "$plan" | jq -r '.filter_clause')

  echo Processing plan_code: $plan_code

  rm -rf /tmp/$plan_schema
  mkdir -p /tmp/$plan_schema

  # dump structures to file
  ogr2ogr \
    -f GPKG \
    /tmp/$plan_schema/structures.gpkg.zip \
    PG:$DATABASE_URL \
    --debug ON \
    -nln structures \
    -sql "SELECT * FROM  wcrp_$plan_schema.combined_output_table_vw"

  # dump streams to file
  ogr2ogr \
    -f GPKG \
    /tmp/$plan_code/streams.gpkg.zip \
    PG:$DATABASE_URL \
    -nln streams \
    -sql "SELECT
      s.segmented_stream_id,
      s.linear_feature_id,
      s.edge_type,
      s.blue_line_key,
      s.watershed_key,
      s.watershed_group_code,
      s.downstream_route_measure,
      s.length_metre,
      s.waterbody_key,
      s.wscode::text as wscode,
      s.localcode::text as localcode,
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
      CASE
        WHEN s.watershed_group_code IN ('BULK','ELKR', 'HORS') THEN NULL
        ELSE s.mad_m3s
      END as mad_m3s,
      s.barriers_anthropogenic_dnstr,
      s.barriers_pscis_dnstr,
      s.barriers_dams_dnstr,
      s.barriers_dams_hydro_dnstr,
      s.barriers_ch_cm_co_pk_sk_dnstr,
      s.barriers_ct_dv_rb_dnstr,
      s.barriers_st_dnstr,
      s.barriers_wct_dnstr,
      s.crossings_dnstr,
      s.dam_dnstr_ind,
      s.dam_hydro_dnstr_ind,
      s.remediated_dnstr_ind,
      s.observation_key_upstr,
      s.obsrvtn_species_codes_upstr,
      s.species_codes_dnstr,
      s.access_ch,
      s.access_cm,
      s.access_co,
      s.access_pk,
      s.access_sk,
      s.access_st,
      s.access_wct,
      s.access_salmon,
      s.spawning_ch,
      s.spawning_cm,
      s.spawning_co,
      s.spawning_pk,
      s.spawning_sk,
      s.spawning_st,
      s.spawning_wct,
      s.rearing_ch,
      s.rearing_co,
      s.rearing_sk,
      s.rearing_st,
      s.rearing_wct,
      s.geom
    FROM bcfishpass.streams_vw s
    WHERE $filter_clause"

done
