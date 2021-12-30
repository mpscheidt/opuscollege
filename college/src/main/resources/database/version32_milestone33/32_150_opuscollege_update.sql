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

-- Opus College (c) UCI - Janneke Nooitgedagt
--
-- KERNEL opuscollege
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.55);

--------------------------------------------------------------
-- delete some privileges from opusrole_privilege for admin-B
--------------------------------------------------------------

DELETE FROM opuscollege.opusrole_privilege where role = 'admin-B' and privilegecode = 'CREATE_IDENTIFICATION_DATA';
DELETE FROM opuscollege.opusrole_privilege where role = 'admin-B' and privilegecode = 'UPDATE_IDENTIFICATION_DATA';
DELETE FROM opuscollege.opusrole_privilege where role = 'admin-B' and privilegecode = 'DELETE_IDENTIFICATION_DATA';

-------------------------------------------------------
-- table lookuptable
-------------------------------------------------------
UPDATE opuscollege.lookuptable SET active = 'N' where lower(tablename) = 'studytime';
UPDATE opuscollege.lookuptable SET active = 'N' where lower(tablename) = 'studyform';

-------------------------------------------------------
-- table appConfig
-------------------------------------------------------
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'admissionInitialStudyPlanStatus','1'); -- 1 = WAITING_FOR_PAYMENT
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'cntdRegistrationInitialCardinalTimeUnitStatus','5'); -- 5 = WAITING_FOR_PAYMENT


-------------------------------------------------------
-- table penaltyType
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.penaltyTypeSeq CASCADE;
DROP TABLE IF EXISTS opuscollege.penaltyType;

CREATE SEQUENCE opuscollege.penaltyTypeSeq;
ALTER TABLE opuscollege.penaltyTypeSeq OWNER TO postgres;

CREATE TABLE opuscollege.penaltyType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.penaltyTypeSeq'),
    code VARCHAR NOT NULL,
    lang CHAR(2) NOT NULL,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.penaltyType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.penaltyType TO postgres;

INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('penaltyType', 'Lookup', 'Y');  

INSERT INTO opuscollege.penaltyType(code,lang,active,description) VALUES('1','en','Y','Late cardinal time-unit registration (bursar)');
INSERT INTO opuscollege.penaltyType(code,lang,active,description) VALUES('2','en','Y','Late examination registration (bursar)');
INSERT INTO opuscollege.penaltyType(code,lang,active,description) VALUES('3','en','Y','Losing / destroying books (library)');
INSERT INTO opuscollege.penaltyType(code,lang,active,description) VALUES('4','en','Y','Losing keys (accommodation, dean of students)');
INSERT INTO opuscollege.penaltyType(code,lang,active,description) VALUES('5','en','Y','Breaking windows (accommodation, dean of students)');

-------------------------------------------------------
-- table penalty
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.penaltySeq CASCADE;
DROP TABLE IF EXISTS opuscollege.penalty;

CREATE SEQUENCE opuscollege.penaltySeq;
ALTER TABLE opuscollege.penaltySeq OWNER TO postgres;

CREATE TABLE opuscollege.penalty (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.penaltySeq'),
    studentid integer NOT NULL,
    penaltytypecode VARCHAR NOT NULL,
    amount numeric(10,2) NOT NULL DEFAULT 0.00,
    startdate date,
    enddate date,
    remark character varying,
    paid CHAR(1) NOT NULL DEFAULT 'N',
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(id)
);
ALTER TABLE opuscollege.penalty OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.penalty TO postgres;

-------------------------------------------------------
-- table appConfig
-------------------------------------------------------
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'useOfSubjectBlocks','Y');
  
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'academicYearOfAdmission';

