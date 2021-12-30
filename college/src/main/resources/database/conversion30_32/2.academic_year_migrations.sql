
-- delete studyplandetails without valid academic year info
DELETE FROM opuscollege.studyplandetail
WHERE academicyearcode = '-'
   OR academicyearcode = '0';

/**
Deletes duplicated academic years **/
DELETE FROM 	"opuscollege".academicyear
	    WHERE id NOT IN
	(SELECT MAX(id)
        FROM "opuscollege".academicyear AS dup
        GROUP BY dup.description);


/**
Finds tables with academicyearcode column and replace it with academicyearid
Replace codes with ids 

**/

CREATE OR REPLACE FUNCTION opuscollege.rename_col_academicyearcode_to_academicyearid()
  RETURNS integer AS
$BODY$
DECLARE
    mviews RECORD;
BEGIN
    

    FOR mviews IN select table_name from information_schema.columns where table_schema = 'opuscollege' and column_name = 'academicyearcode' and table_name != 'node_relationships_n_level' LOOP

   EXECUTE 'ALTER TABLE opuscollege.' || mviews.table_name || ' ADD COLUMN academicYearId INTEGER';
	EXECUTE 'UPDATE opuscollege.' || mviews.table_name || ' SET academicYearId = academicyear.id  FROM (SELECT id,code,description FROM opuscollege.academicyear 
	) AS academicyear WHERE ' || mviews.table_name || '.academicyearcode = academicyear.code';
 EXECUTE 'ALTER TABLE opuscollege.' || mviews.table_name || '  DROP academicYearCode ';
	
    END LOOP;


    RETURN 1;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION opuscollege.rename_col_academicyearcode_to_academicyearid() OWNER TO postgres;

SELECT opuscollege.rename_col_academicyearcode_to_academicyearid();

DROP function opuscollege.rename_col_academicyearcode_to_academicyearid();

--ALTER table opuscollege.academicyear ADD column startDate DATE;
--ALTER table opuscollege.academicyear ADD column endDate DATE;

--ALTER table opuscollege.academicyear DROP column lang;
--ALTER table opuscollege.academicyear DROP column code;


-- set start date to 1st January for years like '2005', '2006'
UPDATE opuscollege.academicyear SET startDate = 	
CAST((academicyear.description || '-01-01') AS DATE)
WHERE length(academicyear.description) <= 4;

-- set start date to 1st July for years like '2005/06', '2006/07'
UPDATE opuscollege.academicyear SET startDate = 	
CAST((substring(academicyear.description from 1 for 4) || '-07-01') AS DATE)
WHERE length(academicyear.description) > 4;

-- set end date to 31st Dezember for years like '2005', '2006'
UPDATE opuscollege.academicyear SET endDate = 	
CAST((academicyear.description || '-12-31') AS DATE)
WHERE length(academicyear.description) <= 4;

-- set end date to 30th June for years like '2005/06', '2006/07'
UPDATE opuscollege.academicyear SET endDate =
(CAST((substring(academicyear.description from 1 for 4) || '-06-30') AS DATE) + interval '1 year')
WHERE length(academicyear.description) > 4;

-------------------------------------------------------
-- table studyyear
-------------------------------------------------------
ALTER table opuscollege.studyyear ADD column academicYearId INTEGER  ;


DELETE FROM opuscollege.lookuptable WHERE lower(tablename) = 'academicyear';
DELETE FROM opuscollege.tabledependency WHERE lookuptableid = (SELECT id FROM opuscollege.LookupTable WHERE lower(LookupTable.tablename) = 'academicyear');




