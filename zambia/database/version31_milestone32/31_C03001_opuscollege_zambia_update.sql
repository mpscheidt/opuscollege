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
 * The Original Code is Opus-College zambia module code.
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
-- Updates specific to Zambia
--
-- Initial author: Monique in het Veld


-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'zambia';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('zambia','A','Y',3.12);

-------------------------------------------------------
-- table opusUser
-------------------------------------------------------
UPDATE opuscollege.opususer SET lang = 'en_ZM' WHERE lang = 'en' AND personId > 82;

-----------------------------------------------------------
-- lookup TABLE cardinalTimeUnitStatus
-----------------------------------------------------------
DELETE FROM opuscollege.cardinalTimeUnitStatus where lang='en';

INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','5','start continued registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','6','waiting for approval of registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','7','rejected registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','8','approved registration (waiting for payment)');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','9','actively registered');

-----------------------------------------------------------
-- lookup TABLE progressStatus -> lookup7 table
-----------------------------------------------------------
DELETE FROM opuscollege.progressStatus where lang='en';

INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','01','Clear pass','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','27','Proceed & Repeat','Y','Y','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','29','To Part-time','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','19','At Part-time','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','31','To Full-time','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','03','Repeat','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','35','Exclude program','Y','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','34','Exclude school','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','22','Exclude university','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','23','Withdrawn with permission','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','25','Graduate','N','N','Y','N');

-------------------------------------------------------
-- DOMAIN TABLE endGrade
-------------------------------------------------------
DELETE FROM opuscollege.endGrade WHERE lang='en';
-- AR ATTACHMENT RESULT
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','S','AR',2.5,55.8,100,'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','F','AR',0,0,54.7,'Fail','N','','N');
-- BSC BACHELOR (SCIENCE)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','A+','BSC',2.5,85.8,100,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','A','BSC',2,74.8,85.7,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','B+','BSC',1.5,65.8,74.7,'Meritorious','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','B','BSC',1,55.8,65.7,'Very Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','C+','BSC',0.5,45.8,55.7,'Clear Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','C','BSC',0,39.8,45.7,'Bare Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','D+','BSC',0,34.8,39.7,'Fail','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','D','BSC',0,0,34.7,'Definite Fail','N','','N');
-- BA BACHELOR (ART)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','A+','BA',2.5,85.8,100,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','A','BA',2,74.8,85.7,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','B+','BA',1.5,65.8,74.7,'Meritorious','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','B','BA',1,55.8,65.7,'Very Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','C+','BA',0.5,45.8,55.7,'Clear Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','C','BA',0,39.8,45.7,'Bare Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','D+','BA',0,34.8,39.7,'Fail','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','D','BA',0,0,34.7,'Definite Fail','N','','N');
-- MSC MASTER (SCIENCE)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','A+','MSC',6,85.6,100,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','A','MSC',5,74.6,85.5,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','B+','MSC',4,69.6,74.5,'Meritorious','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','B','MSC',3,64.6,69.5,'Very Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','C+','MSC',2,54.6,64.5,'Clear Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','C','MSC',1,49.6,54.5,'Bare Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','F','MSC',0,0,49.5,'Fail in a Supplementary Examination','N','','N');
-- MA MASTER (ART)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','A+','MA',6,85.6,100,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','A','MA',5,74.6,85.5,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','B+','MA',4,69.6,74.5,'Meritorious','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','B','MA',3,64.6,69.5,'Very Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','C+','MA',2,54.6,64.5,'Clear Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','C','MA',1,49.6,54.5,'Bare Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','F','MA',0,0,49.5,'Fail in a Supplementary Examination','N','','N');
-- DA DIPLOMA (other than MATHS AND SCIENCE)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','A+','DA',5,85.6,100,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','A','DA',4,75.6,85.5,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','B+','DA',3,67.6,75.5,'Meritorious','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','B','DA',2,61.6,67.5,'Very Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','C+','DA',1,55.6,61.5,'Clear Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','C','DA',0,49.6,55.5,'Bare Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','D+','DA',0,39.6,49.5,'Fail','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','D','DA',0,0,39.5,'Definite Fail','N','','N');
-- DSC DIPLOMA (MATHS AND SCIENCE)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','A+','DSC',5,89.6,100,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','A','DSC',4,84.6,89.5,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','B+','DSC',3,79.6,84.5,'Meritorious','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','B','DSC',2,69.6,79.5,'Very Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','C+','DSC',1,59.6,69.5,'Clear Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','C','DSC',0,49.6,59.5,'Bare Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','D+','DSC',0,39.6,49.5,'Fail','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','D','DSC',0,0,39.5,'Definite Fail','N','','N');
-- DIST-DEGR DISTANT EDUCATION (DEGREE PROGRAMME)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','A+','DIST-DEGR',5,86,100,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','A','DIST-DEGR',4,76,85,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','B+','DIST-DEGR',3,68,75,'Meritorious','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','B','DIST-DEGR',2,62,67,'Very Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','C+','DIST-DEGR',1,56,61,'Clear Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','C','DIST-DEGR',0,50,55,'Bare Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','D+','DIST-DEGR',0,40,49,'Fail','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','D','DIST-DEGR',0,0,39,'Definite Fail','N','','N');
-- DIST DISTANT EDUCATION
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','A+','DIST',5,89.6,100,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','A','DIST',4,84.6,89.5,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','B+','DIST',3,79.6,84.5,'Meritorious','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','B','DIST',2,69.6,79.5,'Very Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','C+','DIST',1,59.6,69.5,'Clear Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','C','DIST',0,49.6,59.5,'Bare Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','D+','DIST',0,39.6,49.5,'Fail','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','D','DIST',0,0,39.5,'Definite Fail','N','','N');
-- PHD DOCTOR
-- TODO !!

-- SECONDARY SCHOOL
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','ONE','SEC',1,0,0,'','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','TWO','SEC',2,0,0,'','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','THREE','SEC',3,0,0,'','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','FOUR','SEC',4,0,0,'','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','FIVE','SEC',5,0,0,'','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('en','SIX','SEC',6,0,0,'','Y','','N');


-------------------------------------------------------
-- DOMAIN TABLE role
-------------------------------------------------------
DELETE FROM opuscollege.role;

-- EN
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin', 'functional administrator and registry', 1);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','dvc', 'deputy vice chancellor', 2);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','registry', 'registry office', 2);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin-C', 'academic affairs office', 3);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin-B', 'branch', 3);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin-S', 'head of 1st level unit - dean etc.', 4);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin-D', 'head of 2nd level unit', 5);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','teacher', 'lecturer', 6);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','student', 'student', 7);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','guest', 'system guest', 8);
-- these roles are 'lowest' , will not alter other userroles
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','finance', 'financial officer', 10);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','library', 'librarian', 10);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','audit', 'internal audit', 10);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','dos', 'dean of Students', 10);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','pr', 'pr / communication', 10);

-- not (yet) implemented
--INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','staff', 'staff member', 6);
--INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','alumnus', 'alumnus', 7);

-------------------------------------------------------
-- DOMAIN TABLE requestAdmissionPeriod
-------------------------------------------------------
DELETE FROM opuscollege.requestAdmissionPeriod;

INSERT INTO opuscollege.requestAdmissionPeriod 
(startdate, enddate, numberOfSubjectsToGrade, academicYearId)
SELECT '2011-01-01','2011-12-31',5, id FROM opuscollege.academicYear where description = '2012';
INSERT INTO opuscollege.requestAdmissionPeriod 
(startdate, enddate, numberOfSubjectsToGrade, academicYearId)
SELECT '2012-01-01','2012-12-31',5, id FROM opuscollege.academicYear where description = '2013';

-------------------------------------------------------
-- table unitType
-------------------------------------------------------
DELETE from opuscollege.unitType where lang='en';

--INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','1','School');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','2','Department');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','3','Administration');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','4','Section');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','5','Direction');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','6','Secretariat');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','7','Institute');

-------------------------------------------------------
-- admin BANDA -> SATA
-------------------------------------------------------
UPDATE opuscollege.opusUser set userName = 'SATA' where userName = 'BANDA';
UPDATE opuscollege.opusUser set pw = '3e06fa3927cbdf4e9d93ba4541acce86' where userName = 'SATA';
UPDATE opuscollege.opusUserRole set userName = 'SATA' where userName = 'BANDA';

