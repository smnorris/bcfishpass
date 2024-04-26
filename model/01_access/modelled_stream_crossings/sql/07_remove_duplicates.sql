-- Remove crossing duplication caused by using multiple sources for the same road.

-- When removing duplicates, we consider sources in this order
-- of presumed spatial accuracy (FTEN and OGC are tenures, not as-built)
-- 1. DRA
-- 2. FTEN
-- 3. OGC permits
-- 4. OGC pre-06
-- (don't consider railways, there is only one source)

-- Retain the ids of the deleted duplicate records by adding them to the
-- retained/matched records. This is desirable because FTEN attributes are valuable
-- for fish passage work (tenure holder etc)

-- To do this:
-- From records to be filtered for duplicates (eg ften), find all points
-- that are within 20m of higher priority crossings (dra in the case of ften).
-- First update all the matched DRA crossings with the IDs of the matched FTEN crossings.
-- Note that not as many dra crossings may be updated as ften crossings within 20m - there
-- will be instances of >1 ften crossing within 20m of a single dra crossing.
-- In these cases, the FTEN id (within 20m) retained will be random.
-- With the update done, delete all the ften crossings found within 20m of the
-- dra crossings.
-- Repeat for each source of lower priority, matching the points in the source to all
-- higher priority crossings that have already been processed (ie, the ogc crossings
-- are matched to all DRA and FTEN crossings within 20m)


-- -----------------------------------------------------------
-- Match FTEN crossings to DRA crossings within 20m
-- then assign the FTEN id to the DRA crossing
-- -----------------------------------------------------------
WITH matched_xings AS
(
  SELECT
    t1.modelled_crossing_id as modelled_crossing_id_del,
    t1.transport_line_id    as transport_line_id_del,
    t1.ften_road_section_lines_id as ften_road_section_lines_id_del,
    t1.og_road_segment_permit_id as og_road_segment_permit_id_del,
    t1.og_petrlm_dev_rd_pre06_pub_id as og_petrlm_dev_rd_pre06_pub_id_del,
    nn.modelled_crossing_id as modelled_crossing_id_keep,
    nn.transport_line_id    as transport_line_id_keep,
    nn.ften_road_section_lines_id as ften_road_section_lines_id_keep,
    nn.og_road_segment_permit_id as og_road_segment_permit_id_keep,
    nn.og_petrlm_dev_rd_pre06_pub_id as og_petrlm_dev_rd_pre06_pub_id_keep
  FROM bcfishpass.modelled_stream_crossings_build t1
  CROSS JOIN LATERAL
    (SELECT
     modelled_crossing_id,
         transport_line_id,
         ften_road_section_lines_id,
         og_road_segment_permit_id,
         og_petrlm_dev_rd_pre06_pub_id,
       ST_Distance(t1.geom, t2.geom) as dist
     FROM bcfishpass.modelled_stream_crossings_build t2
     WHERE t2.transport_line_id IS NOT NULL
     ORDER BY t1.geom <-> t2.geom
     LIMIT 1) as nn
  WHERE t1.ften_road_section_lines_id IS NOT NULL
  AND nn.dist < 20
  ORDER BY t1.modelled_crossing_id
)
UPDATE bcfishpass.modelled_stream_crossings_build x
SET ften_road_section_lines_id = m.ften_road_section_lines_id_del
FROM matched_xings m
WHERE x.modelled_crossing_id = m.modelled_crossing_id_keep;

-- Do the same match and delete the FTEN crossings within 20m
-- of a DRA crossing
WITH matched_xings AS
(
  SELECT
    t1.modelled_crossing_id as modelled_crossing_id_del,
    t1.transport_line_id    as transport_line_id_del,
    t1.ften_road_section_lines_id as ften_road_section_lines_id_del,
    t1.og_road_segment_permit_id as og_road_segment_permit_id_del,
    t1.og_petrlm_dev_rd_pre06_pub_id as og_petrlm_dev_rd_pre06_pub_id_del,
    nn.modelled_crossing_id as modelled_crossing_id_keep,
    nn.transport_line_id    as transport_line_id_keep,
    nn.ften_road_section_lines_id as ften_road_section_lines_id_keep,
    nn.og_road_segment_permit_id as og_road_segment_permit_id_keep,
    nn.og_petrlm_dev_rd_pre06_pub_id as og_petrlm_dev_rd_pre06_pub_id_keep
  FROM bcfishpass.modelled_stream_crossings_build t1
  CROSS JOIN LATERAL
    (SELECT
       modelled_crossing_id,
         transport_line_id,
         ften_road_section_lines_id,
         og_road_segment_permit_id,
         og_petrlm_dev_rd_pre06_pub_id,
       ST_Distance(t1.geom, t2.geom) as dist
     FROM bcfishpass.modelled_stream_crossings_build t2
     WHERE t2.transport_line_id IS NOT NULL
     ORDER BY t1.geom <-> t2.geom
     LIMIT 1) as nn
  WHERE t1.ften_road_section_lines_id IS NOT NULL
  AND t1.transport_line_id IS NULL
  AND nn.dist < 20
  ORDER BY t1.modelled_crossing_id
)
DELETE FROM bcfishpass.modelled_stream_crossings_build x
WHERE modelled_crossing_id IN (SELECT modelled_crossing_id_del FROM matched_xings);


-- -----------------------------------------------------------
-- Match OGC crossings to DRA/FTEN crossings within 20m,
-- then assign the OGC id to the DRA/FTEN crossing
-- -----------------------------------------------------------
WITH matched_xings AS
(
SELECT
    t1.modelled_crossing_id as modelled_crossing_id_del,
    t1.transport_line_id    as transport_line_id_del,
    t1.ften_road_section_lines_id as ften_road_section_lines_id_del,
    t1.og_road_segment_permit_id as og_road_segment_permit_id_del,
    t1.og_petrlm_dev_rd_pre06_pub_id as og_petrlm_dev_rd_pre06_pub_id_del,
    nn.modelled_crossing_id as modelled_crossing_id_keep,
    nn.transport_line_id    as transport_line_id_keep,
    nn.ften_road_section_lines_id as ften_road_section_lines_id_keep,
    nn.og_road_segment_permit_id as og_road_segment_permit_id_keep,
    nn.og_petrlm_dev_rd_pre06_pub_id as og_petrlm_dev_rd_pre06_pub_id_keep
  FROM bcfishpass.modelled_stream_crossings_build t1
    CROSS JOIN LATERAL
      (SELECT
        modelled_crossing_id,
         transport_line_id,
         ften_road_section_lines_id,
         og_road_segment_permit_id,
         og_petrlm_dev_rd_pre06_pub_id,
         ST_Distance(t1.geom, t2.geom) as dist
       FROM bcfishpass.modelled_stream_crossings_build t2
       WHERE t2.transport_line_id IS NOT NULL OR t2.ften_road_section_lines_id IS NOT NULL
       ORDER BY t1.geom <-> t2.geom
       LIMIT 1) as nn
    WHERE t1.og_road_segment_permit_id IS NOT NULL
    AND nn.dist < 20
    ORDER BY t1.modelled_crossing_id
)
UPDATE bcfishpass.modelled_stream_crossings_build x
SET og_road_segment_permit_id = m.og_road_segment_permit_id_del
FROM matched_xings m
WHERE x.modelled_crossing_id = m.modelled_crossing_id_keep;

-- do the same match and delete the ogc crossings within 20m of the dra/ften crossings
WITH matched_xings AS
(
SELECT
    t1.modelled_crossing_id as modelled_crossing_id_del,
    t1.transport_line_id    as transport_line_id_del,
    t1.ften_road_section_lines_id as ften_road_section_lines_id_del,
    t1.og_road_segment_permit_id as og_road_segment_permit_id_del,
    t1.og_petrlm_dev_rd_pre06_pub_id as og_petrlm_dev_rd_pre06_pub_id_del,
    nn.modelled_crossing_id as modelled_crossing_id_keep,
    nn.transport_line_id    as transport_line_id_keep,
    nn.ften_road_section_lines_id as ften_road_section_lines_id_keep,
    nn.og_road_segment_permit_id as og_road_segment_permit_id_keep,
    nn.og_petrlm_dev_rd_pre06_pub_id as og_petrlm_dev_rd_pre06_pub_id_keep
  FROM bcfishpass.modelled_stream_crossings_build t1
    CROSS JOIN LATERAL
      (SELECT
         modelled_crossing_id,
         transport_line_id,
         ften_road_section_lines_id,
         og_road_segment_permit_id,
         og_petrlm_dev_rd_pre06_pub_id,
         ST_Distance(t1.geom, t2.geom) as dist
       FROM bcfishpass.modelled_stream_crossings_build t2
       WHERE t2.transport_line_id IS NOT NULL OR t2.ften_road_section_lines_id IS NOT NULL
       ORDER BY t1.geom <-> t2.geom
       LIMIT 1) as nn
    WHERE t1.og_road_segment_permit_id IS NOT NULL
    AND t1.transport_line_id IS NULL
    AND t1.ften_road_section_lines_id IS NULL
    AND nn.dist < 20
    ORDER BY t1.modelled_crossing_id
)
DELETE FROM bcfishpass.modelled_stream_crossings_build
WHERE modelled_crossing_id IN (SELECT modelled_crossing_id_del FROM matched_xings);

-- -----------------------------------------------------------
-- Match OGCPRE06 crossings to DRA/FTEN/OGC crossings within 20m,
-- then assign the OGCPRE06 id to the DRA/FTEN/OGC crossing
-- -----------------------------------------------------------
WITH matched_xings AS
(
SELECT
    t1.modelled_crossing_id as modelled_crossing_id_del,
    t1.transport_line_id    as transport_line_id_del,
    t1.ften_road_section_lines_id as ften_road_section_lines_id_del,
    t1.og_road_segment_permit_id as og_road_segment_permit_id_del,
    t1.og_petrlm_dev_rd_pre06_pub_id as og_petrlm_dev_rd_pre06_pub_id_del,
    nn.modelled_crossing_id as modelled_crossing_id_keep,
    nn.transport_line_id    as transport_line_id_keep,
    nn.ften_road_section_lines_id as ften_road_section_lines_id_keep,
    nn.og_road_segment_permit_id as og_road_segment_permit_id_keep,
    nn.og_petrlm_dev_rd_pre06_pub_id as og_petrlm_dev_rd_pre06_pub_id_keep
  FROM bcfishpass.modelled_stream_crossings_build t1
    CROSS JOIN LATERAL
      (SELECT
         modelled_crossing_id,
         transport_line_id,
         ften_road_section_lines_id,
         og_road_segment_permit_id,
         og_petrlm_dev_rd_pre06_pub_id,
         ST_Distance(t1.geom, t2.geom) as dist
       FROM bcfishpass.modelled_stream_crossings_build t2
       WHERE
         t2.transport_line_id IS NOT NULL
         OR t2.ften_road_section_lines_id IS NOT NULL
         OR t2.og_road_segment_permit_id IS NOT NULL
       ORDER BY t1.geom <-> t2.geom
       LIMIT 1) as nn
    WHERE t1.og_petrlm_dev_rd_pre06_pub_id IS NOT NULL
    AND nn.dist < 20
    ORDER BY t1.modelled_crossing_id
)
UPDATE bcfishpass.modelled_stream_crossings_build x
SET og_petrlm_dev_rd_pre06_pub_id = m.og_petrlm_dev_rd_pre06_pub_id_del
FROM matched_xings m
WHERE x.modelled_crossing_id = m.modelled_crossing_id_keep;

-- do the same match and delete the ogcpre06 crossings within 20m of the dra/ften/ogc crossings
WITH matched_xings AS
(
SELECT
    t1.modelled_crossing_id as modelled_crossing_id_del,
    t1.transport_line_id    as transport_line_id_del,
    t1.ften_road_section_lines_id as ften_road_section_lines_id_del,
    t1.og_road_segment_permit_id as og_road_segment_permit_id_del,
    t1.og_petrlm_dev_rd_pre06_pub_id as og_petrlm_dev_rd_pre06_pub_id_del,
    nn.modelled_crossing_id as modelled_crossing_id_keep,
    nn.transport_line_id    as transport_line_id_keep,
    nn.ften_road_section_lines_id as ften_road_section_lines_id_keep,
    nn.og_road_segment_permit_id as og_road_segment_permit_id_keep,
    nn.og_petrlm_dev_rd_pre06_pub_id as og_petrlm_dev_rd_pre06_pub_id_keep
  FROM bcfishpass.modelled_stream_crossings_build t1
    CROSS JOIN LATERAL
      (SELECT
         modelled_crossing_id,
         transport_line_id,
         ften_road_section_lines_id,
         og_road_segment_permit_id,
         og_petrlm_dev_rd_pre06_pub_id,
         ST_Distance(t1.geom, t2.geom) as dist
       FROM bcfishpass.modelled_stream_crossings_build t2
       WHERE
         t2.transport_line_id IS NOT NULL
         OR t2.ften_road_section_lines_id IS NOT NULL
         OR t2.og_road_segment_permit_id IS NOT NULL
       ORDER BY t1.geom <-> t2.geom
       LIMIT 1) as nn
    WHERE t1.og_petrlm_dev_rd_pre06_pub_id IS NOT NULL
    AND t1.transport_line_id IS NULL
    AND t1.ften_road_section_lines_id IS NULL
    AND t1.og_road_segment_permit_id IS NULL
    AND nn.dist < 20
    ORDER BY t1.modelled_crossing_id
)
DELETE FROM bcfishpass.modelled_stream_crossings_build
WHERE modelled_crossing_id IN (SELECT modelled_crossing_id_del FROM matched_xings);