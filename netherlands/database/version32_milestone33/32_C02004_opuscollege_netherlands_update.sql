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

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('netherlands','A','Y',3.22);

-------------------------------------------------------
-- table nationalityGroup
-------------------------------------------------------
DELETE FROM opuscollege.nationalityGroup where lang = 'nl';

INSERT INTO opuscollege.nationalityGroup(code,lang,description) VALUES('SADC','nl','SADC');
INSERT INTO opuscollege.nationalityGroup(code,lang,description) VALUES('OTNA','nl','Andere nationaliteit');

-------------------------------------------------------
-- table studyIntensity
-------------------------------------------------------
DELETE FROM opuscollege.studyIntensity where lang = 'nl';
INSERT INTO opuscollege.studyIntensity(lang,code,description) VALUES ('nl','F','fulltime');
INSERT INTO opuscollege.studyIntensity(lang,code,description) VALUES ('nl','P','parttime');

-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('REVERSE_PROGRESS_STATUS','nl','Y','Reverse progress statuses in cntd registration');

-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_NOTES','nl','Y','Read notes on career interests, activities and placements of students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDENT_NOTES','nl','Y','Create notes on career interests, activities and placements of students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_NOTES','nl','Y','Alter notes on career interests, activities and placements of students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENT_NOTES','nl','Y','Delete notes on career interests, activities and placements of students');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_COUNSELING','pt','Y','Read notes on counseling of students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDENT_COUNSELING','pt','Y','Create notes on counseling of students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_COUNSELING','pt','Y','Alter notes on counseling of students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENT_COUNSELING','pt','Y','Delete notes on counseling of students');

-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_FINANCE','nl','Y','Read information in the financial module');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_FINANCE','nl','Y','Create information in the financial module');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_FINANCE','nl','Y','Update information in the financial module');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_FINANCE','nl','Y','Delete information in the financial module');

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

-----------------------------------------------------------
-- lookup TABLE progressStatus
-----------------------------------------------------------
DELETE FROM opuscollege.progressStatus where lang='nl';

INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','01','CP - Clear pass','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','03','R - Repeat','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','04','P - Proceed','Y','Y','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','14','S - Suspended','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','15','E - Expelled','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','19','PT - At Part-time','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','22','EU - Exclude university','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','23','WP - Withdrawn with permission','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','25','G - Graduate','N','N','Y','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','27','PR - Proceed & Repeat','Y','Y','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','29','TPT - To Part-time','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','31','FT - To Full-time','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','34','ES - Exclude school','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','35','EP - Exclude program','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','37','WTP - Penalty withdrawal/Withdrawal without permission','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('nl','53','DE - Deferred/Supp. Examinations','N','N','N','N');


-------------------------------------------------------
-- table gradeType
-------------------------------------------------------
DELETE FROM opuscollege.gradeType where lang='nl';

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','SEC','Secondary school','sec.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','BSC','Bachelor of science','B.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','LIC','Licentiate','Lic..');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','MSC','Master of science','M.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','PHD','Doctor','Ph.D.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','BA','Bachelor of art','B.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','MA','Master of art','M.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','DA','Diploma other than maths and science','Dpl.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','DSC','Diploma maths and science','Dpl.M.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','BEng','Bachelor of Engineering','B.Eng.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','MEngSc','Master of Engineering Science','M.Eng.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','MScEng','Master of Science Engineering ','M.Sc.Eng.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('nl','MBA','Master of Business Administration','M.BA.');

-------------------------------------------------------
-- table discipline
-------------------------------------------------------
DELETE FROM opuscollege.discipline where lang = 'nl';

INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('nl','1','Human Resource Mgt');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('nl','2','Education');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('nl','3','Sociology');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('nl','4','Anthropology');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('nl','5','Law');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('nl','6','Public Administration');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('nl','7','Personnel Mgt');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('nl','8','Political science');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('nl','9','Economics');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('nl','10','Business Administration');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('nl','11','Commerce');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('nl','12','Accountancy');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('nl','13','Other bachelor with 3 years of practical experience');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('nl','14','Practicing HRM with postgraduate Diploma from recognized institution');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('nl','15','Holder of professional accounting qualifications (ACCA, CIMA)');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('nl','16','2 years of practical experience and First degree in any bachelor');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('nl','17','3 years of practical experience and Post-graduate diploma in various disciplines');
INSERT INTO opuscollege.discipline (lang,code,description) VALUES ('nl','18','Holder of professional qualification (CIOB, RICS, RIBA)');

-------------------------------------------------------
-- table disciplineGroup
-------------------------------------------------------
DELETE FROM opuscollege.disciplinegroup where lang = 'nl';

INSERT INTO opuscollege.disciplinegroup (lang,code,description) VALUES ('nl','1','Master of Arts - Human Resource Mgt');
INSERT INTO opuscollege.disciplinegroup (lang,code,description) VALUES ('nl','2','Master of Business Administration General');
INSERT INTO opuscollege.disciplinegroup (lang,code,description) VALUES ('nl','3','Master of Business Administration Financial');
INSERT INTO opuscollege.disciplinegroup (lang,code,description) VALUES ('nl','4','Master of Science in Project Mgt');

-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_ACCOMMODATION_DATA','nl','Y','Create accommodation data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_ACCOMMODATION_DATA','nl','Y','Update accommodation data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_ACCOMMODATION_DATA','nl','Y','Delete accommodation data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_ACCOMMODATION_DATA','nl','Y','Read accommodation data');

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

INSERT INTO opuscollege.penaltyType(code,lang,active,description) VALUES('1','nl','Y','Late cardinal time-unit registration (bursar)');
INSERT INTO opuscollege.penaltyType(code,lang,active,description) VALUES('2','nl','Y','Late examination registration (bursar)');
INSERT INTO opuscollege.penaltyType(code,lang,active,description) VALUES('3','nl','Y','Losing / destroying books (library)');
INSERT INTO opuscollege.penaltyType(code,lang,active,description) VALUES('4','nl','Y','Losing keys (accommodation, dean of students)');
INSERT INTO opuscollege.penaltyType(code,lang,active,description) VALUES('5','nl','Y','Breaking windows (accommodation, dean of students)');

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
    VALUES ('2011-01-01',NULL,'useOfScholarshipDecisionCriteria','N');

-------------------------------------------------------
-- table appConfig
-------------------------------------------------------
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'useOfStudentBalancesGeneration','Y');
