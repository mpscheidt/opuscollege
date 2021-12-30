
-- Note:
-- Output to messages / Meldungen panel

DROP FUNCTION IF EXISTS find_missing_translations();

CREATE FUNCTION find_missing_translations() RETURNS void AS $$
DECLARE
  lookuptable RECORD;
  rec RECORD;
BEGIN

FOR lookuptable IN select tablename from opuscollege.lookuptable LOOP
  FOR rec IN EXECUTE format('SELECT * FROM opuscollege.%I t1 where not exists (select * from opuscollege.%I t2 where t1.code = t2.code and t1.lang <> t2.lang) order by code', lookuptable.tablename, lookuptable.tablename)
  LOOP
      RAISE NOTICE '%: %', lookuptable.tablename, rec;
  END LOOP; 

END LOOP;


END;
$$ LANGUAGE plpgsql;

-- Call:
select find_missing_translations();
