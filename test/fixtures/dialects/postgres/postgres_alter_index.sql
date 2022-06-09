ALTER INDEX distributors RENAME TO suppliers;

ALTER INDEX distributors SET TABLESPACE fasttablespace;

ALTER INDEX distributors SET (fillfactor = 75);

ALTER INDEX coord_idx ALTER COLUMN 3 SET STATISTICS 1000;

ALTER INDEX IF EXISTS foo ATTACH PARTITION bar;

ALTER INDEX foo NO DEPENDS ON EXTENSION barr;

ALTER INDEX foo RESET (thing, other_thing);

ALTER INDEX foo ALTER 4 SET STATISTICS 7;

ALTER INDEX ALL IN TABLESPACE foo OWNED BY role_1, account_admin, steve
SET TABLESPACE bar NOWAIT;

-- roles can be double-quoted
ALTER INDEX ALL IN TABLESPACE foo OWNED BY "role_1", "account_admin", "steve"
SET TABLESPACE bar NOWAIT;
