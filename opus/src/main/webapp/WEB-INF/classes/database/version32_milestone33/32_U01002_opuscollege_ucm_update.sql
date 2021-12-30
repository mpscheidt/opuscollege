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
 * The Original Code is Opus-College ucm module code.
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
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'ucm';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('ucm','A','Y',3.04);

-------------------------------------------------------
-- table academicYear
-------------------------------------------------------

UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2001/02') WHERE description = '2000/01';
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2002/03') WHERE description = '2001/02';
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2003/04') WHERE description = '2002/03';
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2004/05') WHERE description = '2003/04';
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2005/06') WHERE description = '2004/05';
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2006/07') WHERE description = '2005/06';
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2007/08') WHERE description = '2006/07';
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2008/09') WHERE description = '2007/08';
UPDATE opuscollege.academicYear SET nextAcademicYearId = (
    select id from opuscollege.academicYear where description = '2009/10') WHERE description = '2008/09';

    
-------------------------------------------------------
-- table appconfig
-------------------------------------------------------

update opuscollege.appconfig set startdate = '2000-01-01';


-------------------------------------------------------
-- privileges
-------------------------------------------------------

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_OPUSUSER');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','RESET_PASSWORD');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','TRANSFER_CURRICULUM');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','TRANSFER_STUDENTS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STUDYPLANDETAILS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','FINALIZE_CONTINUED_REGISTRATION_FLOW');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_FOREIGN_STUDYPLAN_DETAILS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_FOREIGN_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STUDYGRADETYPE_RFC');


-------------------------------------------------------
-- table appConfig
-------------------------------------------------------

INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'admissionInitialStudyPlanStatus','3'); -- 3 = APPROVED_ADMISSION
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'cntdRegistrationInitialCardinalTimeUnitStatus','10'); -- 10 = Actively registered

-------------------------------------------------------
-- table mailConfig
-------------------------------------------------------

INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforpayment_admission', 'en', 'Your request for admission has been set to status waiting-for-payment.','Your request for admission has been set to status waiting-for-payment.<br />Please go to the bank with the application form and pay the application fee.', 'academicoffice@ucm.ac.mz');
INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforpayment_admission', 'pt', 'Your request for admission has been set to status waiting-for-payment.','Your request for admission has been set to status waiting-for-payment.<br />Please go to the bank with the application form and pay the application fee.','academicoffice@ucm.ac.mz');

INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforselection_admission', 'en', 'Your request for admission has been set to status waiting-for-selection.','Your request for admission has been set to status waiting-for-selection.<br />Your payment has been received and you are now awaiting the selection by the university.', 'academicoffice@ucm.ac.mz');
INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforselection_admission', 'pt', 'Your request for admission has been set to status waiting-for-selection.','Your request for admission has been set to status waiting-for-selection.<br />Your payment has been received and you are now awaiting the selection by the university.','academicoffice@ucm.ac.mz');

INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforpayment_registration', 'en', 'Your request for continued registration has been set to status waiting-for-payment.','Your request for admission has been set to status waiting-for-payment.<br />Please go to the bank with the continued registration form and pay the registration fees.', 'registry@ucm.ac.mz');
INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforpayment_registration', 'pt', 'Your request for continued registration has been set to status waiting-for-payment.','Your request for admission has been set to status waiting-for-payment.<br />Please go to the bank with the continued registration form and pay the registration fees.','registry@ucm.ac.mz');

INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforselection_registration', 'en', 'Your request for continued registration has been set to status waiting-for-selection.','Your request for continued registration has been set to status waiting-for-selection.<br />Your payment has been received and you are now awaiting the selection by the university.', 'registry@ucm.ac.mz');
INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforselection_registration', 'pt', 'Your request for continued registration has been set to status waiting-for-selection.','Your request for continued registration has been set to status waiting-for-selection.<br />Your payment has been received and you are now awaiting the selection by the university.','registry@ucm.ac.mz');

INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforapproval_registration', 'en', 'Your request for continued registration has been set to status waiting-for-approval.','Your request for continued registration has been set to status waiting-for-approval.<br />You have been positively selected and you are now awaiting the formal approval of the university.', 'registry@ucm.ac.mz');
INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('waitingforapproval_registration', 'pt', 'Your request for continued registration has been set to status waiting-for-approval.','Your request for continued registration has been set to status waiting-for-approval.<br />You have been positively selected and you are now awaiting the formal approval of the university.','registry@ucm.ac.mz');

INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('requestforchange_registration', 'en', 'Your request for continued registration has been set to status request-for-change.','Your request for continued registration has been set to status request-for-change.<br />Your request for change has been received by the corresponding officer at the university.', 'registry@ucm.ac.mz');
INSERT INTO opuscollege.mailConfig (msgType,lang, msgSubject,msgBody, msgSender) VALUES ('requestforchange_registration', 'pt', 'Your request for continued registration has been set to status request-for-change.','Your request for continued registration has been set to status request-for-change.<br />Your request for change has been received by the corresponding officer at the university.','registry@ucm.ac.mz');
