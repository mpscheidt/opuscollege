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
 * The Original Code is Opus-College mozambique module code.
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
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'mozambique';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('mozambique','A','Y',3.13);

-------------------------------------------------------
-- table gradeType (with title for academicTitle)
-------------------------------------------------------
DELETE FROM opuscollege.gradeType where lang='pt';

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','SEC','Ensino secund&aacute;rio','Ensino sec.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','BSC','Bacharelato','B.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','LIC','Licentiatura','Lic..');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','MSC','Mestre','M.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','PHD','Ph.D.','Ph.D.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','BA','Bachelor of art','B.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','MA','Master of art','M.A.');

-------------------------------------------------------
-- inserts on TABLE studyPlanStatus
-------------------------------------------------------
DELETE FROM opuscollege.studyPlanStatus where lang='pt';

INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','1','');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','2','');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','3','');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','4','');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','10','');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','11','');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','12','');

-----------------------------------------------------------
-- lookup TABLE cardinalTimeUnitStatus
-----------------------------------------------------------
DELETE FROM opuscollege.cardinalTimeUnitStatus where lang='pt';

INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('pt','5','start continued registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('pt','6','waiting for approval of registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('pt','7','rejected registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('pt','8','approved registration (waiting for payment)');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('pt','9','actively registered');

-----------------------------------------------------------
-- lookup TABLE progressStatus -> lookup7 table
-----------------------------------------------------------
DELETE FROM opuscollege.progressStatus where lang='pt';

INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','01','Passar (todas cadeiras aprovadas)','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','27','Continuar & repetir','Y','Y','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','29','Para tempo parcial','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','19','No tempo parcial','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','31','Para tempo inteiro','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','03','Repetir todas cadeiras','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','35','Excluir do programa','Y','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','34','Excluir da eschola','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','22','Excluir da universidade','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','23','Ausen&ccedil;a autorizada','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','25','Graduar','N','N','Y','N');

-------------------------------------------------------
-- DOMAIN TABLE endGrade
-------------------------------------------------------
DELETE FROM opuscollege.endGrade;
-- EN
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','26', 'LIC', 0.0, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','25', 'LIC', 0.0, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','24', 'BSC', 0.0, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','25', 'BSC', 0.0, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','22', 'MSC', 0.0, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','21', 'MSC', 0.0, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','20', '',20, 0.0, 0.0, '20','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','19', '',19, 0.0, 0.0, '19','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','18', '',18, 0.0, 0.0, '18','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','17', '',17, 0.0, 0.0, '17','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','16', '',16, 0.0, 0.0, '16','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','15', '',15, 0.0, 0.0, '15','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','14', '',14, 0.0, 0.0, '14','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','13', '',13, 0.0, 0.0, '13','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','12', '',12, 0.0, 0.0, '12','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','11', '',11, 0.0, 0.0, '11','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','10', '',10, 0.0, 0.0, '10','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','09', '',9, 0.0, 0.0, '9','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','08', '',8, 0.0, 0.0, '8','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','07', '',7, 0.0, 0.0, '7','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','06', '',6, 0.0, 0.0, '6','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','05', '',5, 0.0, 0.0, '5','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','04', '',4, 0.0, 0.0, '4','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','03', '',3, 0.0, 0.0, '3','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','02', '',2, 0.0, 0.0, '2','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','01', '',1, 0.0, 0.0, '1','N','','N');

-- PT
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','26', 'LIC', 0.0, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','25', 'LIC', 0.0, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','24', 'BSC', 0.0, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','25', 'BSC', 0.0, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','22', 'MSC', 0.0, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','21', 'MSC', 0.0, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','20', '',20, 0.0, 0.0, '20','Y','20','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','19', '',19, 0.0, 0.0, '19','Y','19','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','18', '',18, 0.0, 0.0, '18','Y','18','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','17', '',17, 0.0, 0.0, '17','Y','17','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','16', '',16, 0.0, 0.0, '16','Y','16','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','15', '',15, 0.0, 0.0, '15','Y','15','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','14', '',14, 0.0, 0.0, '14','Y','14','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','13', '',13, 0.0, 0.0, '13','N','13','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','12', '',12, 0.0, 0.0, '12','N','12','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','11', '',11, 0.0, 0.0, '11','N','11','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','10', '',10, 0.0, 0.0, '10','N','10','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','09', '',9, 0.0, 0.0, '9','N','9','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','08', '',8, 0.0, 0.0, '8','N','8','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','07', '',7, 0.0, 0.0, '7','N','7','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','06', '',6, 0.0, 0.0, '6','N','6','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','05', '',5, 0.0, 0.0, '5','N','5','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','04', '',4, 0.0, 0.0, '4','N','4','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','03', '',3, 0.0, 0.0, '3','N','3','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','02', '',2, 0.0, 0.0, '2','N','2','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','01', '',1, 0.0, 0.0, '1','N','1','N');

-------------------------------------------------------
-- table studentStatus
-------------------------------------------------------
DELETE FROM opuscollege.studentStatus where lang='pt';

INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('pt','1','Activo');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('pt','5','Falecido');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('pt','101','Expulso');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('pt','102','Suspenso');

----------------------------------------------------------------------
-- table cardinalTimeUnit
----------------------------------------------------------------------
DELETE FROM opuscollege.cardinaltimeunit WHERE lang = 'pt';

INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('pt','1','Ano', 1);
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('pt','2','Semestre', 2);
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('pt','3','Trimestre', 3);

----------------------------------------------------------------------
-- table role
----------------------------------------------------------------------

DELETE FROM opuscollege.role;

-- EN
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin', 'Functional administrator and registry', 1);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin-C', 'Academic affairs office', 2);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin-B', 'Branch', 3);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin-D', 'Head of 2nd level unit', 4);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','teacher', 'Lecturer', 5);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','student', 'Student', 6);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','guest', 'System guest', 7);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','finance', 'Financial officer', 8);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','dvc', 'Deputy vice chancellor', 9);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','library', 'Librarian', 10);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','audit', 'Internal audit', 11);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','dos', 'Dean of Students', 12);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','pr', 'PR / communication', 13);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','registry', 'registry office', 14);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin-S', 'Head of 1st level unit - dean etc.', 15);

-- not (yet) implemented
--INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','staff', 'staff member', 16);
--INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','alumnus', 'alumnus', 17);

-- PT
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','admin', 'Functional administrator and registry', 1);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','admin-C', 'Academic affairs office', 2);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','admin-B', 'Branch', 3);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','admin-D', 'Head of 2nd level unit', 4);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','teacher', 'Lecturer', 5);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','student', 'Student', 6);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','guest', 'System guest', 7);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','finance', 'Financial officer', 8);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','dvc', 'Deputy vice chancellor', 9);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','library', 'Librarian', 10);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','audit', 'Internal audit', 11);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','dos', 'Dean of Students', 12);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','pr', 'PR / communication', 13);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','registry', 'Registry office', 14);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','admin-S', 'Head of 1st level unit - dean etc.', 15);

-- not (yet) implemented
--INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','staff', 'staff member', 16);
--INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','alumnus', 'alumnus', 17);

----------------------------------------------------------------------
-- table opususerrole
----------------------------------------------------------------------

-- switch current roles 'staff' to 'teacher'
UPDATE opuscollege.opususerrole set role = 'teacher' where role = 'staff';

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
