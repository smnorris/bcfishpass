-- do not drop and recreate this table when rebuilding database, we want to retain this data
--drop table bcfishpass.log;
create table if not exists bcfishpass.log (
  model_run_id serial primary key,
  model_type text not null,
  date_completed timestamp not null default CURRENT_TIMESTAMP,
  git_id bytea not null,
  check (model_type in ('LINEAR','LATERAL'))
);

-- for example:
-- insert into bcfishpass.log (model_type, git_id) values ('LINEAR', decode('feac3689cef93cc02a4cb4ac6a0fdadebe980f4d', 'hex')) RETURNING model_run_id;