-- reference CABD dams to FWA stream network

DROP TABLE IF EXISTS bcfishpass.dams;

CREATE TABLE bcfishpass.dams
(dam_id uuid primary key,
 linear_feature_id bigint,
 blue_line_key integer,
 downstream_route_measure double precision,
 wscode_ltree ltree,
 localcode_ltree ltree,
 distance_to_stream double precision,
 watershed_group_code text,
 geom geometry(Point, 3005),
 UNIQUE (blue_line_key, downstream_route_measure)
);


INSERT INTO bcfishpass.dams
(
  dam_id,
  linear_feature_id,
  blue_line_key,
  downstream_route_measure,
  wscode_ltree,
  localcode_ltree,
  distance_to_stream,
  watershed_group_code,
  geom
)

WITH nearest AS
(
  SELECT
    pt.cabd_id as dam_id,
    str.linear_feature_id,
    str.wscode_ltree,
    str.localcode_ltree,
    str.blue_line_key,
    str.waterbody_key,
    str.length_metre,
    ST_Distance(str.geom, pt.geom) as distance_to_stream,
    str.watershed_group_code,
    str.downstream_route_measure as downstream_route_measure_str,
    (
      ST_LineLocatePoint(
        st_linemerge(str.geom),
        ST_ClosestPoint(str.geom, pt.geom)
      )
      * str.length_metre
  ) + str.downstream_route_measure AS downstream_route_measure,
  st_linemerge(str.geom) as geom_str
  FROM cabd.dams pt
  CROSS JOIN LATERAL
  (SELECT
     linear_feature_id,
     wscode_ltree,
     localcode_ltree,
     blue_line_key,
     waterbody_key,
     length_metre,
     downstream_route_measure,
     watershed_group_code,
     geom
    FROM whse_basemapping.fwa_stream_networks_sp str
    WHERE str.localcode_ltree IS NOT NULL
    AND NOT str.wscode_ltree <@ '999'
    ORDER BY str.geom <-> pt.geom
    LIMIT 1) as str
    WHERE ST_Distance(str.geom, pt.geom) <= 65
    -- exclude CABD dams that do not exist or are in the wrong spot
    AND pt.cabd_id NOT IN (
      'e8e4bd88-c3c9-407c-a7a0-15c6c51704fd', -- seton
      'f0c0f092-8502-4b98-9cf7-0c88e7d746f7', -- coldwater
      '7645a9aa-0891-4232-9cd0-c8d99658c350', -- jordan
      '803b0bc6-038d-4611-b478-04815e912e3e', -- sooke
      'd8a604b7-0a71-4d6a-86fc-0c2ac9a45e47', -- bulkley/aitken
      '6a792d8f-b9c5-44a4-a260-0f06c3b20821'  -- salmon/merton
      )
)

SELECT
    dam_id::uuid,
    linear_feature_id,
    blue_line_key,
    downstream_route_measure,
    wscode_ltree,
    localcode_ltree,
    distance_to_stream,
    watershed_group_code,
    ST_Force2D(
      ST_LineInterpolatePoint(geom_str,
       ROUND(
         CAST(
            (downstream_route_measure -
               downstream_route_measure_str) / length_metre AS NUMERIC
          ),
         5)
       )
    )::geometry(Point, 3005) AS geom
FROM nearest
ON CONFLICT DO NOTHING;

CREATE INDEX ON bcfishpass.dams (linear_feature_id);
CREATE INDEX ON bcfishpass.dams (blue_line_key);
CREATE INDEX ON bcfishpass.dams (watershed_group_code);
CREATE INDEX ON bcfishpass.dams USING GIST (wscode_ltree);
CREATE INDEX ON bcfishpass.dams USING BTREE (wscode_ltree);
CREATE INDEX ON bcfishpass.dams USING GIST (localcode_ltree);
CREATE INDEX ON bcfishpass.dams USING BTREE (localcode_ltree);
CREATE INDEX ON bcfishpass.dams USING GIST (geom);


-- patch CABD barrier status for these passable features
update cabd.dams
set passability_status_code = 3
where cabd_id in (
'7b36e0f8-f1fb-404f-a7cd-a4760e90853f',
'784ea59b-0ea6-4830-b015-fdd3dfd577ff',
'f3a5cabc-c475-427e-b04d-3f0b41522187',
'5d1ea79f-b53b-4f64-9655-06b3fe401d2b',
'4ebe93be-54c1-4a92-8645-4eb5858b7d82',
'65953b20-10ec-43b9-a2d2-d53f63b317fe',
'15679cba-66dc-4c0e-8533-b5b632cb6581',
'e63a95bc-556d-4eec-9cc6-8c179369256f',
'e537c469-d0e3-40f9-9492-f9a9520e31bb',
'006f5d15-4bf3-40aa-8a1d-dec5368577a7',
'f5dda558-7b73-4f22-87f4-5180decbbb94',
'2e2e328c-2a90-444f-8ed6-e1171ee7d099',
'0fda6ea6-e4ec-4198-b99e-1a30426e7a74',
'6b0f4cda-a5ff-40c7-9add-9bf871ca9944',
'31b47368-1110-4570-9f10-269492be4819',
'68d22918-5704-4cab-ba6b-8928faff1d7a',
'ab90656d-10ce-4bc4-8ef5-1650fcb1e710',
'1dd79e19-f15c-4197-b4fc-cbe11d370a05',
'1dd79e19-f15c-4197-b4fc-cbe11d370a05',
'e3508007-bc87-4179-94e6-e28c28916d1f',
'e3508007-bc87-4179-94e6-e28c28916d1f',
'4642547d-5cb4-4085-8373-4c5696b4fc51',
'c735070f-7705-4615-8cb1-e0e2605a6d58',
'b9501d8c-0200-42d5-813b-0d0076a36208',
'348a3017-147e-4630-90d0-acb492778f03',
'348a3017-147e-4630-90d0-acb492778f03',
'05bf1b0f-f052-472c-a22b-b255243ca084',
'5728f6d4-84ec-4844-9244-b2cfc9cac67a',
'd40cf9b5-9f75-494b-8ebd-cbf2b34efcda',
'4ada8290-b025-40f3-8599-c957fc51f659',
'9e0b3f20-8df6-4882-958e-9cbca4edae5a',
'619e2c1e-c84b-468c-8d45-271d8950add1',
'8a1eaa40-e416-4415-974d-c7995908d80b',
'5819702a-c062-4811-9591-1e8c4b187015',
'13517adb-f1c4-423b-9450-985f15d40df2',
'06cb6234-db31-4468-a406-5b873e486b3e',
'1ba70b72-1dd7-4530-9b30-c474b03ca27c',
'e86b513c-3dce-4b4a-a49e-e86e4dac935e',
'5590e541-d00e-4f2b-ac0c-a62fc3d20de7',
'62f22b67-1335-4655-adad-07c2bca062df',
'15383d9d-bd37-4107-a858-d072828bb519',
'd15ab4c5-6c52-4507-9a37-cbd63b620c92',
'89b1e5a6-9c44-42ab-a733-621c7a1b539a',
'ab896a10-87e1-4914-8d82-5c98b0349048',
'2ff395e6-94a3-4700-8aa9-c5d7d2ee9568',
'9dde80b0-8a62-4181-b854-cb97101f9454',
'b369e20e-85b0-4fa4-9b31-6ca8797e0102',
'2579e02d-9ead-4975-928d-aad1590a46d6',
'07c08dde-055c-40f2-86bc-56f1ace30b1f',
'f27a762d-3973-4e76-9eef-cb30971baf0c',
'9e5e91a4-f348-409c-8a02-7b70a978c125',
'd8a604b7-0a71-4d6a-86fc-0c2ac9a45e47',
'd47d8761-23b7-4b0a-b437-619aaf8950b1',
'bfc3cd0d-72cf-4827-bc31-5708b0ceb506',
'20ca6324-f372-47f6-ae55-bb63aceb8d99',
'4c42b100-3292-4832-b135-b2a8ff2ef98b',
'b3a2c141-2f86-4d26-9d1c-8e1b7b7bab7a',
'6a636c3a-7b41-46f5-a7ab-e2c852c5385a',
'52dbc681-e7a9-4bee-bf56-7f3a7b09244a',
'fe5b47ce-b4ce-4669-aea7-8acde83b2e5c',
'ee74ad81-ad9d-41ee-ab94-abb3a697f54d',
'b1afdebf-b24f-449c-936e-4eedcafb307b',
'b661449e-61e1-46a3-ab46-1e466a901fe2',
'78f8cbd3-6a04-48d8-8aba-3bdc24414837',
'5c9ab110-2044-49c9-b8c3-8e86e5f4d76f',
'ab351938-1995-478c-874f-3c99d2dc6a52',
'46287b27-0aaf-4129-93fb-88c8ebe1ef68',
'8eeab4c1-18dd-46b9-bf9f-707e43a3718f',
'5b269871-f4bb-4aee-8f00-6ba007d85036',
'd835ea5c-194e-4e13-b4cb-2a70291b7de4',
'c766a9c2-50e6-4241-ab5f-b429db54fdcb',
'c42c7875-51cd-492f-bb2c-641bbd93d0ad',
'c42c7875-51cd-492f-bb2c-641bbd93d0ad',
'a2f10c51-b69f-47c2-a6f4-cbd751e85132',
'ab3b50dc-c948-4e82-875f-7a807643b228',
'f788170f-72e4-493c-83cb-3560eab2e0bb',
'af80d0bb-1881-48ba-88d8-7def11f03817',
'3988f08a-e4c4-4b21-b83d-1da89b249382'
);