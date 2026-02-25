-- log model run id and version id / etag of files read from or written to s3/az blob
CREATE TABLE bcfishpass.log_objectstorage (
  model_run_id integer,
  object_name text,       -- file name / table name
  version_id text,
  etag text,
  PRIMARY KEY (model_run_id, object_name)
);

-- log the version of an s3 source file when syncing to db
CREATE TABLE bcfishpass.log_replication (
  object_name text primary key,
  version_id text,
  etag text,
  replication_timestamp timestamp
);