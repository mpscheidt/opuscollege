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

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.25);

-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------
ALTER TABLE opuscollege.opusprivilege ALTER lang TYPE character(6);
ALTER TABLE opuscollege.opusprivilege ADD COLUMN validFrom date;
ALTER TABLE opuscollege.opusprivilege ADD COLUMN validThrough date;

ALTER TABLE opuscollege.opusrole_privilege ADD COLUMN validFrom date;
ALTER TABLE opuscollege.opusrole_privilege ADD COLUMN validThrough date;
ALTER TABLE opuscollege.opusrole_privilege ADD COLUMN active character varying(1) NOT NULL DEFAULT 'Y';

-------------------------------------------------------
-- table subject
-------------------------------------------------------
ALTER TABLE opuscollege.subject ALTER creditamount TYPE numeric(4,1), ALTER creditamount DROP NOT NULL;

-------------------------------------------------------
-- table lookuptable
-------------------------------------------------------
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('endGradeType', 'Lookup', 'Y');

-------------------------------------------------------
-- table studygradetype
-------------------------------------------------------
ALTER TABLE opuscollege.studygradetype ADD COLUMN maxNumberOfFailedSubjectsPerCardinalTimeUnit integer NOT NULL DEFAULT 0;

-------------------------------------------------------
-- table examination
-------------------------------------------------------
ALTER TABLE opuscollege.examination ADD COLUMN currentAcademicYearId integer NOT NULL DEFAULT 0;

-------------------------------------------------------
-- table test
-------------------------------------------------------
ALTER TABLE opuscollege.test ADD COLUMN currentAcademicYearId integer NOT NULL DEFAULT 0;

-------------------------------------------------------
-- table examinationResultHistory
-------------------------------------------------------
ALTER TABLE opuscollege.examinationResultHistory DROP COLUMN writewhen; 
ALTER TABLE opuscollege.examinationResultHistory ADD COLUMN writewhen TIMESTAMP without time zone NOT NULL DEFAULT now();

ALTER TABLE opuscollege.examinationResultHistory DROP CONSTRAINT examinationResultHistory_examinationattemptnr_key;

----------------------------------------------------------------------
-- table studentExpulsion
-- expulsion formerly called expellation
----------------------------------------------------------------------

CREATE SEQUENCE opuscollege.studentExpulsionSeq;
ALTER TABLE opuscollege.studentExpulsionSeq OWNER TO postgres;

CREATE TABLE opuscollege.studentExpulsion (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studentExpulsionSeq'), 
    studentId INTEGER NOT NULL REFERENCES opuscollege.student(studentId) ON DELETE CASCADE ON UPDATE CASCADE,
    startdate DATE,
    enddate DATE,
    expulsiontypecode VARCHAR,
    reasonforExpulsion VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(startdate,enddate)
);
ALTER TABLE opuscollege.studentExpulsion OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.studentExpulsion TO postgres;

INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('secondarySchoolSubject', 'Lookup', 'N');


----------------------------------------------------------------------
-- table htmlField + htmlFieldprivilege
-- expulsion formerly called expellation
----------------------------------------------------------------------
drop table opuscollege.htmlField;
drop table opuscollege.htmlFieldprivilege;

----------------------------------------------------------------------
-- table thesisResult
----------------------------------------------------------------------
ALTER TABLE opuscollege.thesisResult ADD COLUMN thesisId INTEGER NOT NULL DEFAULT 0;

----------------------------------------------------------------------
-- table cardinalTimeUnit
----------------------------------------------------------------------
ALTER TABLE opuscollege.cardinalTimeUnit ADD COLUMN nrOfUnitsPerYear INTEGER NOT NULL DEFAULT 0;
-- inserts into table cardinaltimeunit
-------------------------------------------------------
DELETE FROM opuscollege.cardinaltimeunit WHERE lang = 'en';

INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('en','1','year', 1);
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('en','2','semester', 2);
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('en','3','trimester', 3);

-- update table lookuptable
UPDATE opuscollege.lookuptable SET tableName = 'cardinalTimeUnit' where tableName = 'cardinaltimeunit';
UPDATE opuscollege.lookuptable SET lookupType = 'Lookup8' where tableName = 'cardinalTimeUnit';

-------------------------------------------------------

CREATE TABLE opuscollege.requestAdmissionPeriod (
    startdate DATE,
    enddate DATE,
    academicYearId INTEGER,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(startdate, enddate, academicYearId)
);
ALTER TABLE opuscollege.requestAdmissionPeriod OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.requestAdmissionPeriod TO postgres;

-------------------------------------------------------
-- table appConfig
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.appConfigSeq CASCADE;
CREATE SEQUENCE opuscollege.appConfigSeq;
ALTER TABLE opuscollege.appConfigSeq OWNER TO postgres;
DROP TABLE IF EXISTS opuscollege.appConfig CASCADE;
CREATE TABLE opuscollege.appConfig (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.appConfigSeq'), 
    appConfigAttributeName VARCHAR NOT NULL DEFAULT '',
    appConfigAttributeValue VARCHAR NOT NULL DEFAULT '',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(appConfigAttributeName)
);
ALTER TABLE opuscollege.appConfig OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.appConfig TO postgres;

-------------------------------------------------------
-- table cardinalTimeUnitResult
-------------------------------------------------------
ALTER TABLE opuscollege.cardinalTimeUnitResult ADD COLUMN endGradeComment VARCHAR;

