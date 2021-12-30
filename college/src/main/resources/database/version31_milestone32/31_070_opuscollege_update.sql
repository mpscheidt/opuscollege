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
-- KERNEL opuscollege / MODULE admission
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.26);


----------------------------------------------------------------------
-- Sequences
----------------------------------------------------------------------
drop sequence opuscollege.secondarySchoolSubjectSeq;
CREATE SEQUENCE opuscollege.secondarySchoolSubjectSeq;
ALTER TABLE opuscollege.secondarySchoolSubjectSeq OWNER TO postgres;

drop sequence opuscollege.secondarySchoolSubjectGroupSeq;
CREATE SEQUENCE opuscollege.secondarySchoolSubjectGroupSeq;
ALTER TABLE opuscollege.secondarySchoolSubjectGroupSeq OWNER TO postgres;

drop sequence opuscollege.groupedSecondarySchoolSubjectSeq;
CREATE SEQUENCE opuscollege.groupedSecondarySchoolSubjectSeq;
ALTER TABLE opuscollege.groupedSecondarySchoolSubjectSeq OWNER TO postgres;

drop sequence opuscollege.gradedSecondarySchoolSubjectSeq;
CREATE SEQUENCE opuscollege.gradedSecondarySchoolSubjectSeq;
ALTER TABLE opuscollege.gradedSecondarySchoolSubjectSeq OWNER TO postgres;

----------------------------------------------------------------------
-- table secondarySchoolSubject
----------------------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.secondarySchoolSubject;
CREATE TABLE opuscollege.secondarySchoolSubject (
    id INTEGER NOT NULL DEFAULT nextval('opuscollege.secondarySchoolSubjectSeq'),
    code varchar NOT NULL,
    lang char(6) NOT NULL,
    active char(1) NOT NULL DEFAULT 'Y',
    description varchar,
    writewho varchar NOT NULL DEFAULT 'opuscollege',
    writewhen timestamp NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);

ALTER TABLE opuscollege.secondarySchoolSubject OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.secondarySchoolSubject TO postgres;

-----------------------------------------------------------
-- TABLE secondarySchoolSubjectGroup
-----------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.secondarySchoolSubjectGroup;
CREATE TABLE opuscollege.secondarySchoolSubjectGroup (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.secondarySchoolSubjectGroupSeq'),
    groupNumber INTEGER NOT NULL,
    minimumNumberToGrade INTEGER NOT NULL,
    maximumNumberToGrade INTEGER NOT NULL,
    studyGradeTypeId INTEGER NOT NULL,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(groupNumber, studyGradeTypeId)
);
ALTER TABLE opuscollege.secondarySchoolSubjectGroup OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.secondarySchoolSubjectGroup TO postgres;


-----------------------------------------------------------
-- TABLE groupedSecondarySchoolSubject
-----------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.groupedSecondarySchoolSubject;
CREATE TABLE opuscollege.groupedSecondarySchoolSubject (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.groupedSecondarySchoolSubjectSeq'),
    secondarySchoolSubjectId INTEGER NOT NULL,
    secondarySchoolSubjectGroupId INTEGER NOT NULL,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(secondarySchoolSubjectId, secondarySchoolSubjectGroupId)
);
ALTER TABLE opuscollege.groupedSecondarySchoolSubject OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.groupedSecondarySchoolSubject TO postgres;


-----------------------------------------------------------
-- TABLE gradedSecondarySchoolSubject
-----------------------------------------------------------

DROP TABLE IF EXISTS opuscollege.gradedSecondarySchoolSubject;
CREATE TABLE opuscollege.gradedSecondarySchoolSubject (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.gradedSecondarySchoolSubjectSeq'),
    secondarySchoolSubjectId INTEGER NOT NULL,
    studyPlanId INTEGER NOT NULL,
    grade VARCHAR,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(secondarySchoolSubjectId, studyPlanId)
);
ALTER TABLE opuscollege.gradedSecondarySchoolSubject OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.gradedSecondarySchoolSubject TO postgres;

-----------------------------------------------------------
-- TABLE gradedSecondarySchoolSubject
-----------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.requestAdmissionPeriod;
CREATE TABLE opuscollege.requestAdmissionPeriod (
    startdate DATE,
    enddate DATE,
    academicYearId INTEGER,
    numberOfSubjectsToGrade INTEGER,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(startdate, enddate, academicYearId)
);
ALTER TABLE opuscollege.requestAdmissionPeriod OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.requestAdmissionPeriod TO postgres;

DELETE FROM opuscollege.requestAdmissionPeriod;

INSERT INTO opuscollege.requestAdmissionPeriod 
(startdate, enddate, numberOfSubjectsToGrade, academicYearId)
SELECT '2011-01-01','2011-12-31',5, id FROM opuscollege.academicYear where description = '2012';
INSERT INTO opuscollege.requestAdmissionPeriod 
(startdate, enddate, numberOfSubjectsToGrade, academicYearId)
SELECT '2012-01-01','2012-12-31',5, id FROM opuscollege.academicYear where description = '2013';

-----------------------------------------------------------
-- TABLE groupedSecondarySchoolSubject
-----------------------------------------------------------
ALTER TABLE opuscollege.groupedSecondarySchoolSubject ADD COLUMN weight integer NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.groupedSecondarySchoolSubject ADD COLUMN minimumGradePoint integer NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.groupedSecondarySchoolSubject ADD COLUMN maximumGradePoint integer NOT NULL DEFAULT 0;

-----------------------------------------------------------
-- TABLE gradedSecondarySchoolSubject
----------------------------------------------------------
ALTER TABLE opuscollege.gradedsecondaryschoolsubject add column secondaryschoolsubjectgroupid integer DEFAULT 0 NOT NULL;

-----------------------------------------------------------
-- TABLE examination / test
----------------------------------------------------------
ALTER TABLE opuscollege.examination DROP column currentacademicyearid;
ALTER TABLE opuscollege.test DROP column currentacademicyearid;

-----------------------------------------------------------
-- TABLE opususerrole
----------------------------------------------------------
ALTER TABLE opuscollege.opususerrole DROP column branchId;
ALTER TABLE opuscollege.opususerrole DROP column institutionId;

-----------------------------------------------------------
-- TABLE studyPlan
----------------------------------------------------------
ALTER TABLE opuscollege.studyPlan add column applicationNumber integer DEFAULT 0 NOT NULL;

-----------------------------------------------------------
-- TABLE lookuptable
----------------------------------------------------------

UPDATE opuscollege.lookuptable SET tableName = 'academicfield' where tableName = 'academicField';
UPDATE opuscollege.lookuptable SET tableName = 'addresstype' where tableName = 'addressType';
UPDATE opuscollege.lookuptable SET tableName = 'administrativepost' where tableName = 'administrativePost';
UPDATE opuscollege.lookuptable SET tableName = 'appointmenttype' where tableName = 'appointmentType';
UPDATE opuscollege.lookuptable SET tableName = 'blocktype' where tableName = 'blockType';
UPDATE opuscollege.lookuptable SET tableName = 'bloodtype' where tableName = 'bloodType';
UPDATE opuscollege.lookuptable SET tableName = 'civilstatus' where tableName = 'civilStatus';
UPDATE opuscollege.lookuptable SET tableName = 'civiltitle' where tableName = 'civilTitle';
UPDATE opuscollege.lookuptable SET tableName = 'contractduration' where tableName = 'contractDuration';
UPDATE opuscollege.lookuptable SET tableName = 'contracttype' where tableName = 'contractType';
UPDATE opuscollege.lookuptable SET tableName = 'educationtype' where tableName = 'educationType';
UPDATE opuscollege.lookuptable SET tableName = 'examinationtype' where tableName = 'examinationType';
UPDATE opuscollege.lookuptable SET tableName = 'examtype' where tableName = 'examType';
UPDATE opuscollege.lookuptable SET tableName = 'expellationtype' where tableName = 'expellationType';
UPDATE opuscollege.lookuptable SET tableName = 'fieldofeducation' where tableName = 'fieldOfEducation';
UPDATE opuscollege.lookuptable SET tableName = 'functionLevel' where tableName = 'functionLevel';
UPDATE opuscollege.lookuptable SET tableName = 'gradetype' where tableName = 'gradeType';
UPDATE opuscollege.lookuptable SET tableName = 'identificationtype' where tableName = 'identificationType';
UPDATE opuscollege.lookuptable SET tableName = 'levelofeducation' where tableName = 'levelOfEducation';
UPDATE opuscollege.lookuptable SET tableName = 'masteringlevel' where tableName = 'masteringLevel';
UPDATE opuscollege.lookuptable SET tableName = 'relationtype' where tableName = 'relationType';
UPDATE opuscollege.lookuptable SET tableName = 'rigiditytype' where tableName = 'rigidityType';
UPDATE opuscollege.lookuptable SET tableName = 'stafftype' where tableName = 'staffType';
UPDATE opuscollege.lookuptable SET tableName = 'studyform' where tableName = 'studyForm';
UPDATE opuscollege.lookuptable SET tableName = 'studytime' where tableName = 'studyTime';
UPDATE opuscollege.lookuptable SET tableName = 'studytype' where tableName = 'studyType';
UPDATE opuscollege.lookuptable SET tableName = 'subjectimportance' where tableName = 'subjectImportance';
UPDATE opuscollege.lookuptable SET tableName = 'targetgroup' where tableName = 'targetGroup';
UPDATE opuscollege.lookuptable SET tableName = 'timeunit' where tableName = 'timeUnit';
UPDATE opuscollege.lookuptable SET tableName = 'unitarea' where tableName = 'unitArea';
UPDATE opuscollege.lookuptable SET tableName = 'unittype' where tableName = 'unitType';
UPDATE opuscollege.lookuptable SET tableName = 'sch_complaintstatus' where tableName = 'sch_complaintStatus';
UPDATE opuscollege.lookuptable SET tableName = 'sch_decisioncriteria' where tableName = 'sch_decisionCriteria';
UPDATE opuscollege.lookuptable SET tableName = 'sch_scholarshiptype' where tableName = 'sch_scholarshipType';
UPDATE opuscollege.lookuptable SET tableName = 'sch_subsidytype' where tableName = 'sch_subsidyType';
UPDATE opuscollege.lookuptable SET tableName = 'cardinaltimeunit' where tableName = 'cardinalTimeUnit';
UPDATE opuscollege.lookuptable SET tableName = 'fee_feecategory' where tableName = 'fee_feeCategory';
UPDATE opuscollege.lookuptable SET tableName = 'daypart' where tableName = 'dayPart';
UPDATE opuscollege.lookuptable SET tableName = 'thesisstatus' where tableName = 'thesisStatus';
UPDATE opuscollege.lookuptable SET tableName = 'studyplanstatus' where tableName = 'studyPlanStatus';
UPDATE opuscollege.lookuptable SET tableName = 'studentstatus' where tableName = 'studentStatus';
UPDATE opuscollege.lookuptable SET tableName = 'progressstatus' where tableName = 'progressStatus';
UPDATE opuscollege.lookuptable SET tableName = 'rfcstatus' where tableName = 'rfcStatus';
UPDATE opuscollege.lookuptable SET tableName = 'cardinaltimeunitstatus' where tableName = 'cardinalTimeUnitStatus';
UPDATE opuscollege.lookuptable SET tableName = 'endgradetype' where tableName = 'endGradeType';
UPDATE opuscollege.lookuptable SET tableName = 'secondaryschoolsubject' where tableName = 'secondarySchoolSubject';
