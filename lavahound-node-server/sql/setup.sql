DROP DATABASE lavahound;
DROP ROLE lavahound;

CREATE ROLE lavahound LOGIN PASSWORD 'h0und' NOSUPERUSER NOINHERIT NOCREATEROLE;

CREATE DATABASE lavahound WITH OWNER = lavahound ENCODING = 'UTF8';

\c lavahound;
	
CREATE SCHEMA lavahound AUTHORIZATION lavahound;	

-- THIS IS NEEDED TO CREATE EXTENSION
ALTER USER lavahound superuser;

CREATE EXTENSION "cube" SCHEMA pg_catalog;
CREATE EXTENSION "earthdistance" SCHEMA pg_catalog;

-- This could be used for JSON or events
--CREATE EXTENSION hstore;

ALTER USER lavahound SET search_path TO lavahound;

ALTER DATABASE lavahound SET timezone TO 'UTC';

-- Use backcompat bytea mode for Postgres 9+
ALTER DATABASE lavahound SET bytea_output = 'escape'; 

