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

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('mozambique','A','Y',3.22);

-------------------------------------------------------
-- table nationalityGroup
-------------------------------------------------------
DELETE FROM opuscollege.nationalityGroup where lang = 'pt';
INSERT INTO opuscollege.nationalityGroup(code,lang,description) VALUES('SADC','pt','SADC');
INSERT INTO opuscollege.nationalityGroup(code,lang,description) VALUES('OTNA','pt','Outra nacionalidade');

-------------------------------------------------------
-- table studyIntensity
-------------------------------------------------------
DELETE FROM opuscollege.studyIntensity;
INSERT INTO opuscollege.studyIntensity(lang,code,description) VALUES ('en','F','Full time');
INSERT INTO opuscollege.studyIntensity(lang,code,description) VALUES ('en','P','Part time');
INSERT INTO opuscollege.studyIntensity(lang,code,description) VALUES ('pt','F','Tempo inteiro');
INSERT INTO opuscollege.studyIntensity(lang,code,description) VALUES ('pt','P','Tempo parcial');

-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('REVERSE_PROGRESS_STATUS','pt','Y','Reverse progress statuses in cntd registration');

-------------------------------------------------------
-- table appConfig
-------------------------------------------------------
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'mailEnabled','N');

-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_NOTES','pt','Y','Read notes on career interests, activities and placements of students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDENT_NOTES','pt','Y','Create notes on career interests, activities and placements of students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_NOTES','pt','Y','Alter notes on career interests, activities and placements of students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENT_NOTES','pt','Y','Delete notes on career interests, activities and placements of students');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_COUNSELING','pt','Y','Read notes on counseling of students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDENT_COUNSELING','pt','Y','Create notes on counseling of students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_COUNSELING','pt','Y','Alter notes on counseling of students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENT_COUNSELING','pt','Y','Delete notes on counseling of students');

-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_FINANCE','pt','Y','Read information in the financial module');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_FINANCE','pt','Y','Create information in the financial module');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_FINANCE','pt','Y','Update information in the financial module');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_FINANCE','pt','Y','Delete information in the financial module');

-------------------------------------------------------
-- table appConfig
-------------------------------------------------------
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'cntdRegistrationBscBaCutOffPointCreditFemale';
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'cntdRegistrationBscBaCutOffPointCreditMale';
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'cntdRegistrationBscBaCutOffPointRelativesCreditFemale';
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'cntdRegistrationBscBaCutOffPointRelativesCreditMale';

DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'cntdRegistrationMscMaCutOffPointCreditFemale';
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'cntdRegistrationMscMaCutOffPointCreditMale';
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'cntdRegistrationMscMaCutOffPointRelativesCreditFemale';
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'cntdRegistrationMscMaCutOffPointRelativesCreditMale';

DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'admissionBscBaCutOffPointCreditFemale';
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'admissionBscBaCutOffPointCreditMale';
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'admissionBscBaCutOffPointRelativesCreditFemale';
DELETE FROM opuscollege.appConfig where appConfigAttributeName = 'admissionBscBaCutOffPointRelativesCreditMale';

INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'cntdRegistrationBachelorCutOffPointCreditFemale','2');
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'cntdRegistrationBachelorCutOffPointCreditMale','1');
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'cntdRegistrationMasterCutOffPointCreditFemale','0.5');
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'cntdRegistrationMasterCutOffPointCreditMale','1');

INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'admissionBachelorCutOffPointCreditFemale','1');
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'admissionBachelorCutOffPointCreditMale','3');

INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'cntdRegistrationBachelorCutOffPointRelativesCreditFemale','2.5');
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'cntdRegistrationBachelorCutOffPointRelativesCreditMale','1.5');
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'cntdRegistrationMasterCutOffPointRelativesCreditFemale','0');
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'cntdRegistrationMasterCutOffPointRelativesCreditMale','0.5');

INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'admissionBachelorCutOffPointRelativesCreditFemale','0');
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2000-01-01',NULL,'admissionBachelorCutOffPointRelativesCreditMale','2');

-------------------------------------------------------
-- table studyPlanStatus
-------------------------------------------------------

DELETE FROM opuscollege.studyPlanStatus WHERE lang='pt';
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','1','Aguardando pagamento');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','2','Aguardando escolha do curso');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','3','Inscrição aprovado');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','4','Inscrição rejeitado');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','10','Temporiamente inactivo');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','11','Graduado');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','12','Desistiu');

INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','9','Anulou matricula');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','9','Canceled registration');

-------------------------------------------------------
-- table gradeType
-------------------------------------------------------

UPDATE opuscollege.gradeType set description = 'Licenciatura' where description = 'Licentiatura';


-----------------------------------------------------------
-- lookup TABLE progressStatus -> lookup7 table
-----------------------------------------------------------
DELETE FROM opuscollege.progressStatus where lang='pt';

INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','01','Transitar (todas cadeiras aprovadas)','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','27','Transitar & repetir','Y','Y','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','29','Para tempo parcial','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','31','Para tempo inteiro','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','03','Repetir todas cadeiras','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','35','Excluir do curso','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','34','Excluir da eschola','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','22','Excluir da universidade','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','23','Ausen&ccedil;a autorizada','N','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','25','Graduar','N','N','Y','N');
--INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','04','Transitar & repetir cadeiras obrigatorias reprovadas','Y','Y','N','S');

-------------------------------------------------------
-- table gradeType (with title for academicTitle)
-------------------------------------------------------

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','MBA','Master of Business Administration','M.BA.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','MBA','Master of Business Administration','M.BA.');

-------------------------------------------------------
-- table discipline
-------------------------------------------------------
DELETE FROM opuscollege.discipline where lang = 'pt';

INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('pt','1','Human Resource Mgt');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('pt','2','Education');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('pt','3','Sociology');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('pt','4','Anthropology');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('pt','5','Law');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('pt','6','Public Administration');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('pt','7','Personnel Mgt');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('pt','8','Political science');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('pt','9','Economics');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('pt','10','Business Administration');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('pt','11','Commerce');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('pt','12','Accountancy');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('pt','13','Other bachelor with 3 years of practical experience');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('pt','14','Practicing HRM with postgraduate Diploma from recognized institution');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('pt','15','Holder of professional accounting qualifications (ACCA, CIMA)');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('pt','16','2 years of practical experience and First degree in any bachelor');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('pt','17','3 years of practical experience and Post-graduate diploma in various disciplines');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('pt','18','Holder of professional qualification (CIOB, RICS, RIBA)');

-------------------------------------------------------
-- table disciplineGroup
-------------------------------------------------------
DELETE FROM opuscollege.disciplinegroup where lang = 'pt';

INSERT INTO opuscollege.disciplinegroup (lang,code,description) VALUES ('pt','1','Master of Arts - Human Resource Mgt');
INSERT INTO opuscollege.disciplinegroup (lang,code,description) VALUES ('pt','2','Master of Business Administration General');
INSERT INTO opuscollege.disciplinegroup (lang,code,description) VALUES ('pt','3','Master of Business Administration Financial');
INSERT INTO opuscollege.disciplinegroup (lang,code,description) VALUES ('pt','4','Master of Science in Project Mgt');

-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_ACCOMMODATION_DATA','pt','Y','Create accommodation data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_ACCOMMODATION_DATA','pt','Y','Update accommodation data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_ACCOMMODATION_DATA','pt','Y','Delete accommodation data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_ACCOMMODATION_DATA','pt','Y','Read accommodation data');

-------------------------------------------------------
-- table rigidityType
-------------------------------------------------------

UPDATE opuscollege.rigidityType SET description = 'obrigat&oacute;rio' where code = '1' and lang = 'pt';


-------------------------------------------------------
-- table penaltyType
-------------------------------------------------------

INSERT INTO opuscollege.penaltyType(code,lang,active,description) VALUES('1','pt','Y','Late cardinal time-unit registration (bursar)');
INSERT INTO opuscollege.penaltyType(code,lang,active,description) VALUES('2','pt','Y','Late examination registration (bursar)');
INSERT INTO opuscollege.penaltyType(code,lang,active,description) VALUES('3','pt','Y','Losing / destroying books (library)');
INSERT INTO opuscollege.penaltyType(code,lang,active,description) VALUES('4','pt','Y','Losing keys (accommodation, dean of students)');
INSERT INTO opuscollege.penaltyType(code,lang,active,description) VALUES('5','pt','Y','Breaking windows (accommodation, dean of students)');

-------------------------------------------------------
-- table appConfig
-------------------------------------------------------
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'useOfSubjectBlocks','Y');

INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'useOfSubsidies','Y');
    
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'numberOfSubjectsToCountForStudyPlanMark','0');
    
-------------------------------------------------------
-- table appConfig
-------------------------------------------------------
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'useOfScholarshipPercentages','N');
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'useOfScholarshipDecisionCriteria','Y');

-------------------------------------------------------
-- table appConfig
-------------------------------------------------------
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'useOfStudentBalancesGeneration','N');
    