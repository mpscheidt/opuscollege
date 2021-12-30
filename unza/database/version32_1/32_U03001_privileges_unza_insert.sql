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
 * The Original Code is Opus-College unza module code.
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
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'unza';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('unza','A','Y',3.13);

truncate opuscollege.opusrole_privilege;

-- gives every privilege to admin user 
INSERT INTO opuscollege.opusrole_privilege(privilegecode,role) SELECT distinct code,'admin' FROM opuscollege.opusprivilege;

-- registry of an institution 

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','ADMINISTER_SYSTEM');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','APPROVE_SUBJECT_SUBSCRIPTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_FEES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_FOREIGN_STUDYPLAN_DETAILS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_FOREIGN_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDYPLANDETAILS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDYGRADETYPE_RFC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_TESTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_FEES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_TESTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_PRIMARY_AND_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_FEES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDENT_MEDICAL_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_TESTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','RESET_PASSWORD');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE__FEES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_FOREIGN_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_OPUSUSER');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_PROGRESS_STATUS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDENT_MEDICAL_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDYGRADETYPE_RFC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','TRANSFER_CURRICULUM');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','TRANSFER_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','TRANSFER_SUBJECTS');

-- central administrator of an institution 
-- (almost identical to registry, except creation of foreign subjects and studyplan details)
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','APPROVE_SUBJECT_SUBSCRIPTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_FEES');
--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_FOREIGN_STUDYPLAN_DETAILS');
--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_FOREIGN_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDYPLANDETAILS_PENDING_APPROVAL');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDYPLANDETAILS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDYGRADETYPE_RFC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_TESTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_FEES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_TESTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','FINALIZE_ADMISSION_FLOW');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','PROGRESS_ADMISSION_FLOW');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_PRIMARY_AND_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_FEES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDENT_MEDICAL_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_TESTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','RESET_PASSWORD');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_FEES');
--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_FOREIGN_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_OPUSUSER');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_PROGRESS_STATUS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDENT_MEDICAL_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDYGRADETYPE_RFC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','TOGGLE_CUTOFFPOINT');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','TRANSFER_CURRICULUM');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','TRANSFER_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','TRANSFER_SUBJECTS');

-- dvc (read copy of admin-C):
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_PRIMARY_AND_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_FEES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDENT_MEDICAL_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_TESTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','UPDATE_BRANCHES');

-- internal audit of an institution 
-- initially read copy of admin-C, must develop
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_PRIMARY_AND_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_FEES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDENT_MEDICAL_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_TESTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','UPDATE_BRANCHES');

-- head of 1st level unit - dean, asst. dean
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','APPROVE_SUBJECT_SUBSCRIPTIONS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STUDYGRADETYPE_RFC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STUDYPLANDETAILS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','FINALIZE_CONTINUED_REGISTRATION_FLOW');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','PROGRESS_CONTINUED_REGISTRATION_FLOW');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_FEES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_OPUSUSER');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_PRIMARY_AND_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_USER_ROLES');

--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','TOGGLE_CUTOFFPOINT');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','TRANSFER_CURRICULUM');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','TRANSFER_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','TRANSFER_SUBJECTS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_FOREIGN_STUDYPLAN_DETAILS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_FOREIGN_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_PROGRESS_STATUS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_USER_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDYGRADETYPE_RFC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_SUBJECTBLOCK_STUDYGRADETYPES');

-- branch administrator
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','APPROVE_SUBJECT_SUBSCRIPTIONS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STUDYPLANDETAILS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STUDYGRADETYPE_RFC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','FINALIZE_CONTINUED_REGISTRATION_FLOW');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','PROGRESS_CONTINUED_REGISTRATION_FLOW');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_FEES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_OPUSUSER');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_PRIMARY_AND_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_USER_ROLES');

--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','TOGGLE_CUTOFFPOINT');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_FOREIGN_STUDYPLAN_DETAILS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_FOREIGN_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_PROGRESS_STATUS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDYGRADETYPE_RFC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_USER_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_SUBJECTBLOCK_STUDYGRADETYPES');

-- decentral administrator of an organizational unit
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','APPROVE_SUBJECT_SUBSCRIPTIONS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STUDYPLANDETAILS_PENDING_APPROVAL');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STUDYGRADETYPE_RFC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_FEES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_OPUSUSER');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_PRIMARY_AND_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','PROGRESS_CONTINUED_REGISTRATION_FLOW');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_PRIMARY_AND_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_PROGRESS_STATUS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_SUBJECTBLOCK_STUDYGRADETYPES');


-- teacher of an organizational unit
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_ACADEMIC_YEARS');
--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_OWN_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_SUBJECTBLOCKS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','UPDATE_OWN_STUDYPLAN_RESULTS_PENDING_APPROVAL');

-- student
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','READ_OWN_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','READ_STUDENTS_SAME_STUDYGRADETYPE');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','READ_STUDY_ADDRESSES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','UPDATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL');

-- guest
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('guest','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('guest','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('guest','READ_STUDIES');

-- financial officer
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','CREATE_FEES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','DELETE_FEES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','GENERATE_STATISTICS');

--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','FINALIZE_ADMISSION_FLOW');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','FINALIZE_CONTINUED_REGISTRATION_FLOW');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_FEES');
--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_SUBJECTBLOCKS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','TOGGLE_CUTOFFPOINT');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','UPDATE_FEES');

-- librarian
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_FEES');
--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_SUBJECTBLOCKS');

-- dean of students
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_ACADEMIC_YEARS');
--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STUDENT_MEDICAL_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_SUBJECTBLOCKS');

-- PR & Communication
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_ACADEMIC_YEARS');
--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_SUBJECTBLOCKS');

