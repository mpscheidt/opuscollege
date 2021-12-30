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
 * The Original Code is Opus-College netherlands module code.
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
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'netherlands';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('netherlands','A','Y',3.13);

-------------------------------------------------------
-- table gradeType (with title for academicTitle)
-------------------------------------------------------
DELETE FROM opuscollege.gradeType where lang='nl';

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','SEC','secondary school','sec.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','BSC','bachelor of science','B.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','LIC','licentiate','Lic..');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','MSC','master of science','M.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','PHD','doctor','Ph.D.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','BA','bachelor of art','B.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','MA','master of art','M.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','DA','diploma other than maths and science','Dpl.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','DSC','diploma maths and science','Dpl.M.Sc.');

-------------------------------------------------------
-- inserts on TABLE studyPlanStatus
-------------------------------------------------------
DELETE FROM opuscollege.studyPlanStatus where lang='nl';

INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','1','start initiële toelating');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','2','in afwachting van betaling initiële toelating');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','3','goedgekeurd voor verdere registratie');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','4','toelating afgekeurd');

INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','10','tijdelijk inactief');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','11','afgestudeerd');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','12','teruggetrokken');


-----------------------------------------------------------
-- lookup TABLE cardinalTimeUnitStatus
-----------------------------------------------------------
DELETE FROM opuscollege.cardinalTimeUnitStatus where lang='nl';

INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('nl','5','begin voortzetting registratie');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('nl','6','wacht op goedkeuring registratie');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('nl','7','registratie afgekeurd');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('nl','8','registratie goedgekeurd (wacht op betaling)');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('nl','9','actief geregistreerd');

-----------------------------------------------------------
-- lookup TABLE progressStatus -> lookup7 table
-----------------------------------------------------------
DELETE FROM opuscollege.progressStatus where lang='nl';

INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','01','Clear pass','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','27','Proceed & Repeat','Y','Y','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','29','To Part-time','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','19','At Part-time','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','31','To Full-time','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','03','Repeat','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','35','Exclude program','Y','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','34','Exclude school','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','22','Exclude university','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','23','Withdrawn with permission','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','25','Graduate','N','N','Y','N');

-------------------------------------------------------
-- DOMAIN TABLE endGrade
-------------------------------------------------------
DELETE FROM opuscollege.endGrade WHERE lang='nl';
-- AR ATTACHMENT RESULT
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','S','AR',2.5,55.8,100,'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','F','AR',0,0,54.7,'Fail','N','','N');
-- BSC BACHELOR (SCIENCE)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','A+','BSC',2.5,85.8,100,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','A','BSC',2,74.8,85.7,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','B+','BSC',1.5,65.8,74.7,'Meritorious','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','B','BSC',1,55.8,65.7,'Very Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','C+','BSC',0.5,45.8,55.7,'Clear Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','C','BSC',0,39.8,45.7,'Bare Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','D+','BSC',0,34.8,39.7,'Fail','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','D','BSC',0,0,34.7,'Definite Fail','N','','N');
-- BA BACHELOR (ART)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','A+','BA',2.5,85.8,100,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','A','BA',2,74.8,85.7,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','B+','BA',1.5,65.8,74.7,'Meritorious','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','B','BA',1,55.8,65.7,'Very Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','C+','BA',0.5,45.8,55.7,'Clear Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','C','BA',0,39.8,45.7,'Bare Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','D+','BA',0,34.8,39.7,'Fail','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','D','BA',0,0,34.7,'Definite Fail','N','','N');
-- MSC MASTER (SCIENCE)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','A+','MSC',6,85.6,100,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','A','MSC',5,74.6,85.5,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','B+','MSC',4,69.6,74.5,'Meritorious','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','B','MSC',3,64.6,69.5,'Very Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','C+','MSC',2,54.6,64.5,'Clear Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','C','MSC',1,49.6,54.5,'Bare Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','F','MSC',0,0,49.5,'Fail in a Supplementary Examination','N','','N');
-- MA MASTER (ART)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','A+','MA',6,85.6,100,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','A','MA',5,74.6,85.5,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','B+','MA',4,69.6,74.5,'Meritorious','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','B','MA',3,64.6,69.5,'Very Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','C+','MA',2,54.6,64.5,'Clear Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','C','MA',1,49.6,54.5,'Bare Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','F','MA',0,0,49.5,'Fail in a Supplementary Examination','N','','N');
-- DA DIPLOMA (other than MATHS AND SCIENCE)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','A+','DA',5,85.6,100,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','A','DA',4,75.6,85.5,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','B+','DA',3,67.6,75.5,'Meritorious','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','B','DA',2,61.6,67.5,'Very Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','C+','DA',1,55.6,61.5,'Clear Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','C','DA',0,49.6,55.5,'Bare Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','D+','DA',0,39.6,49.5,'Fail','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','D','DA',0,0,39.5,'Definite Fail','N','','N');
-- DSC DIPLOMA (MATHS AND SCIENCE)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','A+','DSC',5,89.6,100,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','A','DSC',4,84.6,89.5,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','B+','DSC',3,79.6,84.5,'Meritorious','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','B','DSC',2,69.6,79.5,'Very Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','C+','DSC',1,59.6,69.5,'Clear Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','C','DSC',0,49.6,59.5,'Bare Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','D+','DSC',0,39.6,49.5,'Fail','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','D','DSC',0,0,39.5,'Definite Fail','N','','N');
-- DIST-DEGR DISTANT EDUCATION (DEGREE PROGRAMME)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','A+','DIST-DEGR',5,86,100,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','A','DIST-DEGR',4,76,85,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','B+','DIST-DEGR',3,68,75,'Meritorious','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','B','DIST-DEGR',2,62,67,'Very Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','C+','DIST-DEGR',1,56,61,'Clear Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','C','DIST-DEGR',0,50,55,'Bare Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','D+','DIST-DEGR',0,40,49,'Fail','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','D','DIST-DEGR',0,0,39,'Definite Fail','N','','N');
-- DIST DISTANT EDUCATION
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','A+','DIST',5,89.6,100,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','A','DIST',4,84.6,89.5,'Distinction','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','B+','DIST',3,79.6,84.5,'Meritorious','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','B','DIST',2,69.6,79.5,'Very Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','C+','DIST',1,59.6,69.5,'Clear Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','C','DIST',0,49.6,59.5,'Bare Pass','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','D+','DIST',0,39.6,49.5,'Fail','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','D','DIST',0,0,39.5,'Definite Fail','N','','N');
-- PHD DOCTOR
-- TODO !!

-- SECONDARY SCHOOL
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','EEN','SEC',1,0,0,'','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','TWEE','SEC',2,0,0,'','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','DRIE','SEC',3,0,0,'','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','VIER','SEC',4,0,0,'','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','VIJF','SEC',5,0,0,'','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES ('nl','ZES','SEC',6,0,0,'','Y','','N');

-------------------------------------------------------
-- table studentStatus
-------------------------------------------------------
DELETE FROM opuscollege.studentStatus where lang='nl';

INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('nl','1','actief');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('nl','5','overleden');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('nl','101','verwijderd');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('nl','102','geschorst');

----------------------------------------------------------------------
-- table cardinalTimeUnit
----------------------------------------------------------------------
DELETE FROM opuscollege.cardinaltimeunit WHERE lang = 'nl';

INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('nl','1','jaar', 1);
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('nl','2','semester', 2);
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('nl','3','trimester', 3);

-------------------------------------------------------
-- DOMAIN TABLE role
-------------------------------------------------------
DELETE FROM opuscollege.role;

-- NL
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('nl','admin', 'functional administrator and registry', 1);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('nl','dvc', 'deputy vice chancellor', 2);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('nl','registry', 'registry office', 2);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('nl','admin-C', 'academic affairs office', 3);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('nl','admin-B', 'branch', 3);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('nl','admin-S', 'head of 1st level unit - dean etc.', 4);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('nl','admin-D', 'head of 2nd level unit', 5);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('nl','teacher', 'lecturer', 6);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('nl','student', 'student', 7);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('nl','guest', 'system guest', 8);
-- these roles are 'lowest' , will not alter other userroles
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('nl','finance', 'financial officer', 10);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('nl','library', 'librarian', 10);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('nl','audit', 'internal audit', 10);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('nl','dos', 'dean of Students', 10);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('nl','pr', 'pr / communication', 10);

-- not (yet) implemented
--INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('ln','staff', 'staff member', 6);
--INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('nl','alumnus', 'alumnus', 7);

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
