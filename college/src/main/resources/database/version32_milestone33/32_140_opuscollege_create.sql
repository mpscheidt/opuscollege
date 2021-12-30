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

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.53);

-------------------------------------------------------
-- table obtainedQualification
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.obtainedQualificationseq CASCADE;
DROP TABLE IF EXISTS opuscollege.obtainedQualification;

CREATE SEQUENCE opuscollege.obtainedQualificationseq;
ALTER TABLE opuscollege.obtainedQualificationseq OWNER TO postgres;

CREATE TABLE opuscollege.obtainedQualification (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.obtainedQualificationseq'),
    studyplanid integer NOT NULL,
    university character varying,
    startdate date,
    enddate date,
    qualification character varying,
    endgradedate date,
    gradetypecode character varying,
    active character(1) NOT NULL DEFAULT 'Y'::bpchar,
    writewho character varying NOT NULL DEFAULT 'opuscollege'::character varying,
    writewhen timestamp without time zone NOT NULL DEFAULT now(),
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.obtainedQualification OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE,REFERENCES, TRIGGER ON TABLE opuscollege.obtainedQualification TO postgres;

-------------------------------------------------------
-- table careerPosition
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.careerPositionseq CASCADE;
DROP TABLE IF EXISTS opuscollege.careerPosition;

CREATE SEQUENCE opuscollege.careerPositionseq;
ALTER TABLE opuscollege.careerPositionseq OWNER TO postgres;

CREATE TABLE opuscollege.careerPosition (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.careerPositionseq'),
    studyplanid integer NOT NULL,
    employer character varying,
    startdate date,
    enddate date,
    careerposition character varying,
    responsibility character varying,
    active character(1) NOT NULL DEFAULT 'Y'::bpchar,
    writewho character varying NOT NULL DEFAULT 'opuscollege'::character varying,
    writewhen timestamp without time zone NOT NULL DEFAULT now(),
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.careerPosition OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE,REFERENCES, TRIGGER ON TABLE opuscollege.careerPosition TO postgres;

-------------------------------------------------------
-- table referee
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.refereeseq CASCADE;
DROP TABLE IF EXISTS opuscollege.referee;

CREATE SEQUENCE opuscollege.refereeseq;
ALTER TABLE opuscollege.refereeseq OWNER TO postgres;

CREATE TABLE opuscollege.referee (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.refereeseq'),
    studyplanid INTEGER NOT NULL,
    name character varying,
    address character varying,
    telephone character varying,
    email character varying,
    orderby INTEGER,
    active character(1) NOT NULL DEFAULT 'Y'::bpchar,
    writewho character varying NOT NULL DEFAULT 'opuscollege'::character varying,
    writewhen timestamp without time zone NOT NULL DEFAULT now(),
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.referee OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE,REFERENCES, TRIGGER ON TABLE opuscollege.referee TO postgres;

-------------------------------------------------------
-- table subject / subjectstudygradetype + subjectblock / subjectblockstudygradetype
-------------------------------------------------------
ALTER TABLE opuscollege.subject DROP column subjectImportanceCode;
ALTER TABLE opuscollege.subjectStudyGradeType ADD COLUMN importanceTypeCode VARCHAR;
ALTER TABLE opuscollege.subjectBlock DROP column importanceCode;
ALTER TABLE opuscollege.subjectBlockStudyGradeType ADD COLUMN importanceTypeCode VARCHAR;

ALTER TABLE opuscollege.subjectImportance RENAME TO importanceType;

UPDATE opuscollege.lookuptable set tablename = 'importancetype' where tablename = 'subjectimportance';
UPDATE opuscollege.lookuptable SET active = 'N' where lower(tablename) = 'importancetype';

-------------------------------------------------------
-- table discipline
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.disciplineseq CASCADE;
DROP TABLE IF EXISTS opuscollege.discipline;

CREATE SEQUENCE opuscollege.disciplineseq;
ALTER TABLE opuscollege.disciplineseq OWNER TO postgres;

CREATE TABLE opuscollege.discipline (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.disciplineSeq'),
    code VARCHAR NOT NULL,
    lang CHAR(2) NOT NULL,
    active character(1) NOT NULL DEFAULT 'Y'::bpchar,
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.discipline OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.discipline TO postgres;

INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('discipline', 'Lookup', 'Y');

INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('en','1','Human Resource Mgt');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('en','2','Education');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('en','3','Sociology');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('en','4','Anthropology');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('en','5','Law');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('en','6','Public Administration');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('en','7','Personnel Mgt');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('en','8','Political science');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('en','9','Economics');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('en','10','Business Administration');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('en','11','Commerce');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('en','12','Accountancy');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('en','13','Other bachelor with 3 years of practical experience');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('en','14','Practicing HRM with postgraduate Diploma from recognized institution');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('en','15','Holder of professional accounting qualifications (ACCA, CIMA)');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('en','16','2 years of practical experience and First degree in any bachelor');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('en','17','3 years of practical experience and Post-graduate diploma in various disciplines');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('en','18','Holder of professional qualification (CIOB, RICS, RIBA)');

-------------------------------------------------------
-- table disciplineGroup
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.disciplinegroupseq CASCADE;
DROP TABLE IF EXISTS opuscollege.disciplinegroup;

CREATE SEQUENCE opuscollege.disciplinegroupseq;
ALTER TABLE opuscollege.disciplinegroupseq OWNER TO postgres;

CREATE TABLE opuscollege.disciplinegroup (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.disciplinegroupSeq'),
    code VARCHAR NOT NULL,
    lang CHAR(2) NOT NULL,
    active character(1) NOT NULL DEFAULT 'Y'::bpchar,
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.disciplinegroup OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.disciplinegroup TO postgres;

INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('disciplinegroup', 'Lookup', 'Y');

INSERT INTO opuscollege.disciplinegroup (lang,code,description) VALUES ('en','1','Master of Arts - Human Resource Mgt');
INSERT INTO opuscollege.disciplinegroup (lang,code,description) VALUES ('en','2','Master of Business Administration General');
INSERT INTO opuscollege.disciplinegroup (lang,code,description) VALUES ('en','3','Master of Business Administration Financial');
INSERT INTO opuscollege.disciplinegroup (lang,code,description) VALUES ('en','4','Master of Science in Project Mgt');

-------------------------------------------------------
-- table groupedDiscipline
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.groupedDisciplineseq CASCADE;
DROP TABLE IF EXISTS opuscollege.groupedDiscipline;

CREATE SEQUENCE opuscollege.groupedDisciplineseq;
ALTER TABLE opuscollege.groupedDisciplineseq OWNER TO postgres;

CREATE TABLE opuscollege.groupedDiscipline (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.groupedDisciplineSeq'),
    disciplineCode VARCHAR NOT NULL,
    disciplineGroupCode VARCHAR NOT NULL,
    active character(1) NOT NULL DEFAULT 'Y'::bpchar,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(disciplineCode, disciplineGroupCode)
);
ALTER TABLE opuscollege.groupedDiscipline OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.groupedDiscipline TO postgres;

INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('1', '1');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('1', '2');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('1', '3');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('1', '4');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('1', '5');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('1', '6');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('1', '7');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('1', '8');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('1', '9');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('1', '13');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('1', '14');

INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('2', '9');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('2', '10');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('2', '11');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('2', '12');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('2', '13');

INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('3', '9');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('3', '10');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('3', '11');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('3', '12');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('3', '13');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('3', '15');

INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('4', '16');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('4', '17');
INSERT INTO opuscollege.groupedDiscipline (disciplineGroupCode, disciplineCode) VALUES ('4', '18');

-----------------------------------------------------------------------------------------------------------------
-- alter table studyGradeType
-----------------------------------------------------------------------------------------------------------------
ALTER TABLE opuscollege.studygradetype ADD COLUMN disciplinegroupcode VARCHAR;

-----------------------------------------------------------------------------------------------------------------
-- alter table studyPlan
-----------------------------------------------------------------------------------------------------------------
ALTER TABLE opuscollege.studyplan ADD COLUMN previousdisciplineCode character varying;;
ALTER TABLE opuscollege.studyplan ADD COLUMN previousdisciplinegrade character varying;

-----------------------------------------------------------------------------------------------------------------
-- alter table gradedsecondaryschoolsubject
-----------------------------------------------------------------------------------------------------------------
ALTER TABLE opuscollege.gradedsecondaryschoolsubject ADD COLUMN level character(1);

-----------------------------------------------------------------------------------------------------------------
-- alter table subject
-----------------------------------------------------------------------------------------------------------------
ALTER TABLE opuscollege.subject ADD COLUMN resultType character varying;

-------------------------------------------------------
-- table thesissupervisor
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.thesissupervisorseq CASCADE;
DROP TABLE IF EXISTS opuscollege.thesissupervisor;

CREATE SEQUENCE opuscollege.thesissupervisorseq;
ALTER TABLE opuscollege.thesissupervisorseq OWNER TO postgres;

CREATE TABLE opuscollege.thesissupervisor (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.thesissupervisorseq'),
    thesisid INTEGER NOT NULL,
    name character varying,
    address character varying,
    telephone character varying,
    email character varying,
    principal character(1) NOT NULL DEFAULT 'N'::bpchar,
    orderby INTEGER,
    active character(1) NOT NULL DEFAULT 'Y'::bpchar,
    writewho character varying NOT NULL DEFAULT 'opuscollege'::character varying,
    writewhen timestamp without time zone NOT NULL DEFAULT now(),
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.thesissupervisor OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE,REFERENCES, TRIGGER ON TABLE opuscollege.thesissupervisor TO postgres;

-------------------------------------------------------
-- table thesisThesisStatus
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.thesisthesisstatusseq CASCADE;
DROP TABLE IF EXISTS opuscollege.thesisThesisStatus;

CREATE SEQUENCE opuscollege.thesisthesisstatusseq;
ALTER TABLE opuscollege.thesisthesisstatusseq OWNER TO postgres;


CREATE TABLE opuscollege.thesisThesisStatus (
    id integer NOT NULL DEFAULT nextval('opuscollege.thesisthesisstatusseq'),
    thesisid integer NOT NULL,
    startdate date,
    thesisstatuscode character varying,
    active character(1) NOT NULL DEFAULT 'Y'::bpchar,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.thesisThesisStatus OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE,REFERENCES, TRIGGER ON TABLE opuscollege.thesisThesisStatus TO postgres;

-------------------------------------------------------
-- table opusrole_privilege
-------------------------------------------------------
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_IDENTIFICATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_IDENTIFICATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_IDENTIFICATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_IDENTIFICATION_DATA');

-------------------------------------------------------
-- table thesis
-------------------------------------------------------
ALTER TABLE opuscollege.thesis DROP COLUMN thesisstatuscode;

-------------------------------------------------------
-- table testResult
-------------------------------------------------------
ALTER TABLE opuscollege.testResult ADD COLUMN examinationResultId integer NOT NULL DEFAULT 0;
ALTER TABLE audit.testResult_hist ADD COLUMN examinationResultId integer NOT NULL DEFAULT 0;

ALTER TABLE opuscollege.testResult
    DROP CONSTRAINT testresult_testid_key;

ALTER TABLE opuscollege.testResult
    ADD CONSTRAINT testresult_testattemptnr_key 
    UNIQUE(testId,examinationId,examinationResultId,studyPlanDetailId,attemptNr);

-------------------------------------------------------
-- table examinationResult
-------------------------------------------------------
ALTER TABLE opuscollege.examinationResult ADD COLUMN subjectResultId integer NOT NULL DEFAULT 0;
ALTER TABLE audit.examinationResult_hist ADD COLUMN subjectResultId integer NOT NULL DEFAULT 0;

ALTER TABLE opuscollege.examinationResult
    DROP CONSTRAINT examinationresult_examinationattemptnr_key;

ALTER TABLE opuscollege.examinationResult
    ADD CONSTRAINT examinationresult_examinationattemptnr_key 
    UNIQUE(examinationId,subjectId,subjectResultId,studyPlanDetailId,attemptNr);
