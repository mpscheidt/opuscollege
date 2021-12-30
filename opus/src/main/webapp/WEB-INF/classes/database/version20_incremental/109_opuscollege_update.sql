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

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',1.09);

-------------------------------------------------------
-- TABLE test
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.testSeq CASCADE;
CREATE SEQUENCE opuscollege.testSeq;
ALTER TABLE opuscollege.testSeq OWNER TO postgres;

DROP TABLE IF EXISTS opuscollege.test CASCADE;
CREATE TABLE opuscollege.test (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.testSeq'), 
    testCode VARCHAR NOT NULL, 
    testDescription VARCHAR,
    examinationId INTEGER NOT NULL,
    examinationTypeCode VARCHAR NOT NULL,
    numberOfAttempts INTEGER NOT NULL,
    weighingFactor INTEGER NOT NULL,
    minimumMark VARCHAR,
    maximumMark VARCHAR,
    BRsPassingTest VARCHAR,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.test OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.test TO postgres;

-------------------------------------------------------
-- table testTeacher
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.testTeacherSeq CASCADE;
CREATE SEQUENCE opuscollege.testTeacherSeq;
ALTER TABLE opuscollege.testTeacherSeq OWNER TO postgres;

DROP TABLE IF EXISTS opuscollege.testTeacher CASCADE;
CREATE TABLE opuscollege.testTeacher (
   id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.testTeacherSeq'), 
   staffMemberId INTEGER NOT NULL REFERENCES opuscollege.staffMember(staffMemberId) ON DELETE CASCADE ON UPDATE CASCADE,
   testId INTEGER NOT NULL REFERENCES opuscollege.test(id) ON DELETE CASCADE ON UPDATE CASCADE,
   active CHAR(1) NOT NULL DEFAULT 'Y',
   writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
   writeWhen TIMESTAMP NOT NULL DEFAULT now(),
   --
   PRIMARY KEY(id),
   UNIQUE(staffMemberId,testId)
);
ALTER TABLE opuscollege.testTeacher OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.testTeacher TO postgres; 

-------------------------------------------------------
-- TABLE testResult
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.testResultSeq CASCADE;
CREATE SEQUENCE opuscollege.testResultSeq;
ALTER TABLE opuscollege.testResultSeq OWNER TO postgres;

DROP TABLE IF EXISTS opuscollege.testResult CASCADE;
CREATE TABLE opuscollege.testResult (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.testResultSeq'), 
    testId INTEGER NOT NULL REFERENCES opuscollege.test(id) ON DELETE CASCADE ON UPDATE CASCADE,
    examinationId INTEGER NOT NULL REFERENCES opuscollege.examination(id) ON DELETE CASCADE ON UPDATE CASCADE,
    studyPlanDetailId INTEGER NOT NULL REFERENCES opuscollege.studyPlanDetail(id) ON DELETE CASCADE ON UPDATE CASCADE,
    testResultDate DATE,
    attemptNr INTEGER NOT NULL,
    finalAttempt CHAR(1) NOT NULL DEFAULT 'N',
    mark VARCHAR,
    passed CHAR(1) NOT NULL DEFAULT 'N',
    staffMemberId INTEGER NOT NULL REFERENCES opuscollege.staffMember(staffMemberId) ON DELETE CASCADE ON UPDATE CASCADE,
    BRsPassingTest VARCHAR,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(testId,examinationId,studyPlanDetailId,attemptNr)
);
ALTER TABLE opuscollege.testResult OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.testResult TO postgres;

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
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','100','combined tests');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','101','final examination');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('en','8','homework');

INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','1','oral');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','2','escrito');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','3','papel');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','4','pratico');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','5','tese');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','6','caso de estudo');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','7','apresentacao');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','100','nota de frequentia');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','101','exame final');
INSERT INTO opuscollege.examinationType (lang,code,description) VALUES ('pt','8','trabalhos de casa');

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',2.00);

