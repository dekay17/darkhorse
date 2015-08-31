alter table account add column authToken varchar;

alter table account add column authTokenSecret varchar;

alter table account add column accountType bigint NOT NULL default 1000;