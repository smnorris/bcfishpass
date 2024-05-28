-- ==============================================
-- CHUM HABITAT POTENTIAL MODEL 
-- ==============================================

-- ----------------------------------------------
-- SPAWNING
-- ----------------------------------------------
WITH rivers AS  -- get unique river waterbodies, there are some duplicates
(
  SELECT DISTINCT waterbody_key
  FROM whse_basemapping.fwa_rivers_poly
),

model AS
(
  SELECT
    s.segmented_stream_id,
    s.blue_line_key,
    s.wscode_ltree,
    s.localcode_ltree,
    cw.channel_width,
    s.gradient,
    CASE
      WHEN hk.spawning_cm is true  -- observed/known habitat
      THEN true
      WHEN
        wsg.model = 'cw' AND
        s.gradient <= t.spawn_gradient_max AND
        (cw.channel_width > t.spawn_channel_width_min OR r.waterbody_key IS NOT NULL) AND
        cw.channel_width <= t.spawn_channel_width_max AND
        av.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
      THEN true
      WHEN wsg.model = 'mad' AND
        s.gradient <= t.spawn_gradient_max AND (
          mad.mad_m3s > t.spawn_mad_min OR
          s.stream_order >= 8
        ) AND
        av.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
      THEN true
    END AS spawning
  FROM bcfishpass.streams s
  inner join bcfishpass.streams_access_vw av on s.segmented_stream_id = av.segmented_stream_id
  left outer join whse_basemapping.fwa_stream_networks_channel_width cw on s.linear_feature_id = cw.linear_feature_id
  left outer join whse_basemapping.fwa_stream_networks_discharge mad on s.linear_feature_id = mad.linear_feature_id
  INNER JOIN bcfishpass.parameters_habitat_method wsg ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb ON s.waterbody_key = wb.waterbody_key
  LEFT OUTER JOIN bcfishpass.parameters_habitat_thresholds t ON t.species_code = 'CM'
  INNER JOIN bcfishpass.wsg_species_presence p ON s.watershed_group_code = p.watershed_group_code
  LEFT OUTER JOIN rivers r ON s.waterbody_key = r.waterbody_key
  left outer join bcfishpass.streams_habitat_known_vw hk on s.segmented_stream_id = hk.segmented_stream_id
  WHERE
    p.cm is true AND
    s.watershed_group_code = :'wsg' AND
    -- streams and rivers only
    (
      wb.waterbody_type = 'R' OR (wb.waterbody_type IS NULL AND s.edge_type IN (1000,1100,2000,2300))
    )
)

insert into bcfishpass.habitat_linear_cm
(segmented_stream_id, spawning)
select
  segmented_stream_id,
  spawning
FROM model
where spawning is true;
