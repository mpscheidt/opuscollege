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

-- Opus College
-- KERNEL opuscollege / MODULE college
--
-- Initial author: Janneke Nooitgedagt

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.19);


-------------------------------------------------------
-- table studyGradeType: add constraint
-------------------------------------------------------
ALTER TABLE opuscollege.studyGradeType ADD CONSTRAINT study_gradetype_studyform_studytime_academicyear_key 
    UNIQUE(studyId, gradeTypeCode, studyFormCode, studyTimeCode, currentAcademicYearId);

-------------------------------------------------------
-- sequences

-- sequence rfcStatusSeq and requestForChangeSeq
-------------------------------------------------------

DROP SEQUENCE IF EXISTS opuscollege.rfcStatusSeq CASCADE;

CREATE SEQUENCE opuscollege.rfcStatusSeq;
ALTER TABLE opuscollege.rfcStatusSeq OWNER TO postgres;

DROP SEQUENCE IF EXISTS opuscollege.requestForChangeSeq CASCADE;

CREATE SEQUENCE opuscollege.requestForChangeSeq;
ALTER TABLE opuscollege.requestForChangeSeq OWNER TO postgres;

-------------------------------------------------------
-- table rfcStatus
-------------------------------------------------------
CREATE TABLE opuscollege.rfcStatus (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.rfcStatusSeq'),
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
ALTER TABLE opuscollege.rfcStatus OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.rfcStatus TO postgres;

-------------------------------------------------------
-- table RequestForChange
-------------------------------------------------------
CREATE TABLE opuscollege.RequestForChange (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.requestForChangeSeq'), 
    requestingUserId INTEGER NOT NULL DEFAULT 0,
    respondingUserId INTEGER NOT NULL DEFAULT 0,
    rfc TEXT, 
    comments TEXT,
    entityId INTEGER NOT NULL DEFAULT 0,
    entityTypeCode varchar NOT NULL,
    rfcStatusCode varchar NOT NULL,
    expirationDate  DATE,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege'::character varying,
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);


-------------------------------------------------------
-- DOMAIN TABLE studyPlanCardinalTimeUnit
-------------------------------------------------------

ALTER TABLE opuscollege.studyPlanCardinalTimeUnit ALTER COLUMN progressStatusCode TYPE VARCHAR;
ALTER TABLE opuscollege.studyPlanCardinalTimeUnit ALTER COLUMN progressStatusCode DROP NOT NULL;
ALTER TABLE opuscollege.studyPlanCardinalTimeUnit ALTER COLUMN progressStatusCode DROP DEFAULT;

-------------------------------------------------------
-- DOMAIN TABLE studyPlanDetail
-------------------------------------------------------
ALTER TABLE opuscollege.studyPlanDetail DROP COLUMN rigidityTypeCode;
ALTER TABLE opuscollege.studyPlanDetail ADD COLUMN studyGradeTypeId int4 NOT NULL DEFAULT 0;

-------------------------------------------------------
-- TABLE lookupTable
-------------------------------------------------------
INSERT INTO opuscollege.lookupTable(tableName , lookupType , active) VALUES ('rfcStatus', 'Lookup', 'Y');

-------------------------------------------------------
-- TABLE all lookup tables
-------------------------------------------------------
ALTER TABLE opuscollege.academicField ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.addressType ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.administrativePost ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.appointmentType ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.blockType ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.bloodType ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.civilStatus ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.civilTitle ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.contractDuration ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.contractType ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.country ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.district ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.educationType ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.examinationType ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.examType ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.expellationType ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.fieldOfEducation ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.frequency ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.function ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.functionLevel ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.gender ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.gradeType ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.identificationType ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.language ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.levelOfEducation ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.masteringLevel ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.nationality ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.profession ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.province ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.relationType ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.rigidityType ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.staffType ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.status ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.studyForm ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.studyTime ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.studyType ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.subjectImportance ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.targetGroup ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.timeUnit ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.unitArea ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.unitType ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.cardinaltimeunit ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.dayPart ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.thesisStatus ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.studyPlanStatus ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.studentStatus ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.progressStatus ALTER COLUMN lang TYPE CHAR(6);
ALTER TABLE opuscollege.rfcStatus ALTER COLUMN lang TYPE CHAR(6);

-------------------------------------------------------
-- TABLE fixed value lookup tables
-------------------------------------------------------

UPDATE opuscollege.lookupTable SET active = 'N' WHERE tableName = 'gradeType';
UPDATE opuscollege.lookupTable SET active = 'N' WHERE tableName = 'endGradeType';
UPDATE opuscollege.lookupTable SET active = 'N' WHERE tableName = 'educationType';
UPDATE opuscollege.lookupTable SET active = 'N' WHERE tableName = 'rigidityType';
UPDATE opuscollege.lookupTable SET active = 'N' WHERE tableName = 'addressType';


-------------------------------------------------------
-- DOMAIN TABLE studyPlan
-------------------------------------------------------
ALTER TABLE opuscollege.studyPlan ADD COLUMN minor1Id int4 NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.studyPlan ADD COLUMN major2Id int4 NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.studyPlan ADD COLUMN minor2Id int4 NOT NULL DEFAULT 0;
