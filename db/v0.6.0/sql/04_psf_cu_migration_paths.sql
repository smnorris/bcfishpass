-- create tables for PSF migration path analysis

create table psf.cu_migrationpaths_ch (
  linear_feature_id bigint,
  segmented_stream_id text,
  cuid integer
);

create table psf.cu_migrationpaths_cm (
  linear_feature_id bigint,
  segmented_stream_id text,
  cuid integer
);

create table psf.cu_migrationpaths_co (
  linear_feature_id bigint,
  segmented_stream_id text,
  cuid integer
);

create table psf.cu_migrationpaths_pk (
  linear_feature_id bigint,
  segmented_stream_id text,
  cuid integer
);

create table psf.cu_migrationpaths_sk (
  linear_feature_id bigint,
  segmented_stream_id text,
  cuid integer
);

create table psf.cu_migrationpaths_st (
  linear_feature_id bigint,
  segmented_stream_id text,
  cuid integer
);
