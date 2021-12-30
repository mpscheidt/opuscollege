/*******************************************************************************
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College college module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 *   For Java files, see Javadoc @author tags.
 * 
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * 
 * ***** END LICENSE BLOCK *****
 ******************************************************************************/

-- Opus College (c) UCI - Stelio Alexandre July 2010
--
-- KERNEL opuscollege / MODULE college
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.03);

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

ALTER table opuscollege.academicyear ADD column startDate DATE;
ALTER table opuscollege.academicyear ADD column endDate DATE;

ALTER table opuscollege.academicyear DROP column lang;
ALTER table opuscollege.academicyear DROP column code;


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


DROP SEQUENCE IF EXISTS opuscollege.studyYearAcademicYearSeq CASCADE;
CREATE SEQUENCE opuscollege.studyYearAcademicYearSeq;
ALTER TABLE opuscollege.studyYearAcademicYearSeq OWNER TO postgres;


-------------------------------------------------------
-- table studyyearacademicyear
-------------------------------------------------------

CREATE TABLE opuscollege.studyYearAcademicYear (
   id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studyYearAcademicYearSeq'), 
   studyYearId INTEGER NOT NULL,
   academicYearId INTEGER NOT NULL,
   writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
   writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    FOREIGN KEY (studyYearId) REFERENCES opuscollege.studyYear(id),
    FOREIGN KEY (academicYearId) REFERENCES opuscollege.academicYear(id),
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.studyYearAcademicYear OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.studyYearAcademicYear TO postgres;


DELETE FROM opuscollege.lookuptable WHERE lower(tablename) = 'academicyear';
DELETE FROM opuscollege.tabledependency WHERE lookuptableid = 2; -------academic year tables



