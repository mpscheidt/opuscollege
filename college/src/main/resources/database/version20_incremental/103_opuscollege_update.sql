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
-- possible states: N = not installed, I = installed, A = activated
ALTER TABLE opuscollege.appVersions DROP column coreDb;
ALTER TABLE opuscollege.appVersions DROP column reportsDb;
--ALTER TABLE opuscollege.appVersions DROP column scholarshipDb;

ALTER TABLE opuscollege.appVersions ADD column module VARCHAR NOT NULL DEFAULT '';
ALTER TABLE opuscollege.appVersions ADD column state CHAR(1) NOT NULL DEFAULT 'N';
ALTER TABLE opuscollege.appVersions ADD column db CHAR(1) NOT NULL DEFAULT 'N';
ALTER TABLE opuscollege.appVersions ADD column dbVersion numeric(10,2) NOT NULL DEFAULT 0.00;

DELETE FROM opuscollege.appVersions;

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',1.03);

ALTER TABLE opuscollege.subject ADD column subjectStructureValidFromYear INTEGER NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.subject ADD column subjectStructureValidThroughYear INTEGER NOT NULL DEFAULT 0;

ALTER TABLE opuscollege.subjectBlock ADD column subjectBlokStructureValidFromYear INTEGER NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.subjectBlock ADD column subjectBlockStructureValidThroughYear INTEGER NOT NULL DEFAULT 0;


-------------------------------------------------------
-- table Person
-------------------------------------------------------

ALTER TABLE opuscollege.person ADD column photographName VARCHAR;
ALTER TABLE opuscollege.person ADD column photographMimeType VARCHAR;

-------------------------------------------------------
-- table student
-------------------------------------------------------

ALTER TABLE opuscollege.student ADD column previousInstitutionDiplomaPhotographName VARCHAR;
ALTER TABLE opuscollege.student ADD column previousInstitutionDiplomaPhotographMimeType VARCHAR;


-------------------------------------------------------
-- TABLE subjectResult
-------------------------------------------------------

DROP TABLE opuscollege.subjectResult;

CREATE TABLE opuscollege.subjectResult (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.subjectResultSeq'), 
    subjectId INTEGER NOT NULL REFERENCES opuscollege.subject(id) ON DELETE CASCADE ON UPDATE CASCADE,
    studyPlanDetailId INTEGER NOT NULL REFERENCES opuscollege.studyPlanDetail(id) ON DELETE CASCADE ON UPDATE CASCADE,
	subjectResultDate DATE,
	attemptNr INTEGER NOT NULL,
	finalAttempt CHAR(1) NOT NULL DEFAULT 'N',
	mark VARCHAR,
    staffMemberId INTEGER NOT NULL REFERENCES opuscollege.staffMember(staffMemberId) ON DELETE CASCADE ON UPDATE CASCADE,
	BRsPassingSubject VARCHAR,
 	obsolete CHAR(1) NOT NULL DEFAULT 'N',
	writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(subjectResultDate,subjectId,studyPlanDetailId)
);
ALTER TABLE opuscollege.subjectResult OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.subjectResult TO postgres;

-------------------------------------------------------
-- TABLE examinationResult
-------------------------------------------------------
DROP TABLE opuscollege.examinationResult;

CREATE TABLE opuscollege.examinationResult (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.examinationResultSeq'), 
    examinationId INTEGER NOT NULL REFERENCES opuscollege.examination(id) ON DELETE CASCADE ON UPDATE CASCADE,
    subjectId INTEGER NOT NULL REFERENCES opuscollege.subject(id) ON DELETE CASCADE ON UPDATE CASCADE,
    studyPlanDetailId INTEGER NOT NULL REFERENCES opuscollege.studyPlanDetail(id) ON DELETE CASCADE ON UPDATE CASCADE,
	examinationResultDate DATE,
	attemptNr INTEGER NOT NULL,
	finalAttempt CHAR(1) NOT NULL DEFAULT 'N',
	mark VARCHAR,
    staffMemberId INTEGER NOT NULL REFERENCES opuscollege.staffMember(staffMemberId) ON DELETE CASCADE ON UPDATE CASCADE,
	BRsPassingExamination VARCHAR,
 	obsolete CHAR(1) NOT NULL DEFAULT 'N',
	writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(examinationResultDate,examinationId,subjectId,studyPlanDetailId)
);
ALTER TABLE opuscollege.examinationResult OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.examinationResult TO postgres;

-------------------------------------------------------
-- TABLE studyPlanDetail
-------------------------------------------------------
ALTER TABLE opuscollege.studyPlanDetail ADD column academicYear VARCHAR;

-------------------------------------------------------
-- table examinationType
-------------------------------------------------------
DELETE FROM opuscollege.examinationType;

INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','1','oral');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','2','written');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','3','paper');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','4','lab/practical');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','5','thesis');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','6','case study');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','7','presentation');

INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','1','oral');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','2','escrito');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','3','papel');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','4','pratico');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','5','tese');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','6','caso de estudo');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','7','apresentacao');

-------------------------------------------------------
-- table examinationResult
-------------------------------------------------------

ALTER TABLE opuscollege.examinationResult
    drop CONSTRAINT examinationresult_examinationresultdate_key;


ALTER TABLE opuscollege.examinationResult
add CONSTRAINT examinationresult_examinationattemptnr_key
  UNIQUE(examinationId,subjectId,studyPlanDetailId,attemptNr);

ALTER TABLE opuscollege.examinationResult DROP COLUMN brsPassingExamination;

-------------------------------------------------------
-- table subjectResult
-------------------------------------------------------

ALTER TABLE opuscollege.subjectResult
    drop CONSTRAINT subjectresult_subjectresultdate_key;

ALTER TABLE opuscollege.subjectResult 
add CONSTRAINT subjectresult_subjectresultattemptnr_key
  UNIQUE(subjectId,studyPlanDetailId,attemptNr);

ALTER TABLE opuscollege.subjectResult DROP COLUMN brsPassingSubject;

-------------------------------------------------------
-- table exam
-------------------------------------------------------
ALTER TABLE opuscollege.exam DROP COLUMN brsPassingExam;

-------------------------------------------------------
-- table studyPlan
-------------------------------------------------------
ALTER TABLE opuscollege.studyPlan ADD COLUMN BRsPassingExam VARCHAR;
