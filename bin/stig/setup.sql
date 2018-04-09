SET application_name="container_setup";

create extension pg_stat_statements;
create extension pgaudit;

alter user postgres password 'PG_ROOT_PASSWORD';
alter user postgres connection limit 100;

create database PG_DATABASE;

\c PG_DATABASE

create extension pg_stat_statements;
create extension pgaudit;
alter system set shared_preload_libraries='pgaudit';
alter system set pgaudit.log = 'ddl,read,role, write';

