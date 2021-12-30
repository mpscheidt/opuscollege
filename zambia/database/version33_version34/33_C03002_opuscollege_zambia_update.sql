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

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('zambia','A','Y',3.26);

-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------

insert into opuscollege.opusprivilege(code, lang, description) values('ADMINISTER_SYSTEM', 'en_ZM', 'Perform changes on system configuration');
insert into opuscollege.opusprivilege(code, lang, description) values('APPROVE_SUBJECT_SUBSCRIPTIONS', 'en_ZM', 'Approve course subscriptions');
insert into opuscollege.opusprivilege(code, lang, description) values('GENERATE_STUDENT_REPORTS', 'en_ZM', 'Generate student reports');
insert into opuscollege.opusprivilege(code, lang, description) values('GENERATE_STATISTICS', 'en_ZM', 'Generate statistics');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_ACADEMIC_YEARS', 'en_ZM', 'Create academic years');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_BRANCHES', 'en_ZM', 'Create second level units');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_CHILD_ORG_UNITS', 'en_ZM', 'Show child second level units');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_EXAMINATION_SUPERVISORS', 'en_ZM', 'Assign examination supervisors');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_FEES', 'en_ZM', 'Create fees');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_FOREIGN_STUDYPLAN_DETAILS', 'en_ZM', 'Create studyplan details from other universities in a studyplan');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_FOREIGN_STUDYPLAN_RESULTS', 'en_ZM', 'Create studyplan results for studyplan details from other universities');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_INSTITUTIONS', 'en_ZM', 'Create institutions');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_LOOKUPS', 'en_ZM', 'Create lookups');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_ORG_UNITS', 'en_ZM', 'Create second level units');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL', 'en_ZM', 'Allow each student to subscribe to courses and course blocks pending approval');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_ROLES', 'en_ZM', 'Create roles');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_SECONDARY_SCHOOLS', 'en_ZM', 'Create organizations');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_STAFFMEMBERS', 'en_ZM', 'Create Staff members');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_STAFFMEMBER_ADDRESSES', 'en_ZM', 'Create staff member addresses');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_STAFFMEMBER_CONTRACTS', 'en_ZM', 'Create staff member contracts');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_STUDENTS', 'en_ZM', 'Create all students');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_STUDY_PLANS', 'en_ZM', 'Create study plans');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_STUDENT_ABSENCES', 'en_ZM', 'Create student absences');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_STUDENT_ADDRESSES', 'en_ZM', 'Create student addresses');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_STUDIES', 'en_ZM', 'Create studies');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_STUDY_ADDRESSES', 'en_ZM', 'Create study addresses');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_STUDYGRADETYPE_RFC', 'en_ZM', 'Create RFCs for a programmes of study');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_STUDYGRADETYPES', 'en_ZM', 'Create programmes of study');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_SUBJECTS', 'en_ZM', 'Create courses');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_SUBJECT_PREREQUISITES', 'en_ZM', 'Define courses prerequisites');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_SUBJECT_STUDYGRADETYPES', 'en_ZM', 'Assign courses to programmes of study');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_SUBJECT_SUBJECTBLOCKS', 'en_ZM', 'Assign courses to course blocks');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_SUBJECT_TEACHERS', 'en_ZM', 'Assign course lecturers');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_SUBJECTBLOCKS', 'en_ZM', 'Create course blocks');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_SUBJECTBLOCK_PREREQUISITES', 'en_ZM', 'Define course block prerequisites');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_SUBJECTBLOCK_STUDYGRADETYPES', 'en_ZM', 'Assign course blocks to programmes of study');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_STUDYPLAN_RESULTS', 'en_ZM', 'Create studyplan results');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_STUDYPLANDETAILS', 'en_ZM', 'Subscribe students to courses and course blocks pending approval');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_STUDYPLANDETAILS_PENDING_APPROVAL', 'en_ZM', 'Subscribe students to courses and course blocks pending approval');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_TEST_SUPERVISORS', 'en_ZM', 'Assign test supervisors');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_USER_ROLES', 'en_ZM', 'Create what roles users are assigned to');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_ACADEMIC_YEARS', 'en_ZM', 'Delete academic years');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_BRANCHES', 'en_ZM', 'Delete second level units');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_CHILD_ORG_UNITS', 'en_ZM', 'Delete child second level units');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_EXAMINATIONS', 'en_ZM', 'Delete examinations');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_EXAMINATION_SUPERVISORS', 'en_ZM', 'Delete examination supervisors');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_FEES', 'en_ZM', 'Delete fees');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_INSTITUTIONS', 'en_ZM', 'Delete institutions');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_LOOKUPS', 'en_ZM', 'Delete lookups');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_SECONDARY_SCHOOLS', 'en_ZM', 'Delete organizations');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_ORG_UNITS', 'en_ZM', 'Delete second level units');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_ROLES', 'en_ZM', 'Delete roles');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_STAFFMEMBERS', 'en_ZM', 'Delete staff members');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_STAFFMEMBER_CONTRACTS', 'en_ZM', 'Delete staff member contracts');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_STAFFMEMBER_ADDRESSES', 'en_ZM', 'Delete staff member addresses');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_STUDENTS', 'en_ZM', 'Delete students');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_STUDENT_ABSENCES', 'en_ZM', 'Delete student absences');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_STUDENT_ADDRESSES', 'en_ZM', 'Delete student addresses');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_STUDIES', 'en_ZM', 'Delete studies');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_STUDY_ADDRESSES', 'en_ZM', 'Delete study addresses');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_STUDYGRADETYPES', 'en_ZM', 'Delete programmes of study');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_STUDY_PLANS', 'en_ZM', 'Delete study plans');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_SUBJECTS', 'en_ZM', 'Delete courses');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_SUBJECT_PREREQUISITES', 'en_ZM', 'Remove course prerequisites');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_SUBJECT_STUDYGRADETYPES', 'en_ZM', 'Remove courses from programmes of study');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_SUBJECT_SUBJECTBLOCKS', 'en_ZM', 'Remove courses from course blocks');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_SUBJECT_TEACHERS', 'en_ZM', 'Delete course lecturers');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_SUBJECTBLOCKS', 'en_ZM', 'Delete courses');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_SUBJECTBLOCK_PREREQUISITES', 'en_ZM', 'Remove course block prerequisites');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_SUBJECTBLOCK_STUDYGRADETYPES', 'en_ZM', 'Remove course blocks from programmes of study');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_TESTS', 'en_ZM', 'Delete tests');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_TEST_SUPERVISORS', 'en_ZM', 'Delete test supervisors');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_USER_ROLES', 'en_ZM', 'Remove roles form users');
insert into opuscollege.opusprivilege(code, lang, description) values('FINALIZE_ADMISSION_FLOW', 'en_ZM', 'Make final progression step in the admission flow');
insert into opuscollege.opusprivilege(code, lang, description) values('FINALIZE_CONTINUED_REGISTRATION_FLOW', 'en_ZM', 'Make final progression step in the continued registration flow');
insert into opuscollege.opusprivilege(code, lang, description) values('PROGRESS_ADMISSION_FLOW', 'en_ZM', 'Make progression steps in the admission flow');
insert into opuscollege.opusprivilege(code, lang, description) values('PROGRESS_CONTINUED_REGISTRATION_FLOW', 'en_ZM', 'Make progression steps in the continued registration flow');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_ACADEMIC_YEARS', 'en_ZM', 'View academic years');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_BRANCHES', 'en_ZM', 'View second level units');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_EXAMINATIONS', 'en_ZM', 'View examinations');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_EXAMINATION_SUPERVISORS', 'en_ZM', 'View examination supervisors');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_FEES', 'en_ZM', 'View fees');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_INSTITUTIONS', 'en_ZM', 'View institutions');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_LOOKUPS', 'en_ZM', 'View lookups');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_OPUSUSER', 'en_ZM', 'View Opususer data');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_ORG_UNITS', 'en_ZM', 'View second level units');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_OWN_STUDYPLAN_RESULTS', 'en_ZM', 'View own study plan results for courses lecturer teaches or student');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_PRIMARY_AND_CHILD_ORG_UNITS', 'en_ZM', 'View primary second level unit and its children');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_ROLES', 'en_ZM', 'View roles');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_SECONDARY_SCHOOLS', 'en_ZM', 'View organizations');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_STAFFMEMBERS', 'en_ZM', 'View Staff members');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_STAFFMEMBER_CONTRACTS', 'en_ZM', 'Read staff member contracts');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_STAFFMEMBER_ADDRESSES', 'en_ZM', 'Read staff member addresses');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_STUDENTS', 'en_ZM', 'View all students');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_STUDENTS_SAME_STUDYGRADETYPE', 'en_ZM', 'View only students in the programme of study');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_STUDENT_SUBSCRIPTION_DATA', 'en_ZM', 'View student subscription data');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_STUDENT_ABSENCES', 'en_ZM', 'View student absences');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_STUDENT_ADDRESSES', 'en_ZM', 'View student addresses');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_STUDENT_MEDICAL_DATA', 'en_ZM', 'View student medical data');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_STUDIES', 'en_ZM', 'View studies');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_STUDY_ADDRESSES', 'en_ZM', 'Read study addresses');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_STUDYGRADETYPES', 'en_ZM', 'View programmes of study');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_STUDY_PLANS', 'en_ZM', 'View study plans');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_STUDYPLAN_RESULTS', 'en_ZM', 'View study plan results');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_SUBJECTBLOCKS', 'en_ZM', 'View course blocks');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_SUBJECTS', 'en_ZM', 'View courses');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_SUBJECT_TEACHERS', 'en_ZM', 'View course lecturers');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_SUBJECT_STUDYGRADETYPES', 'en_ZM', 'View associations course / programmes of study');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_SUBJECT_SUBJECTBLOCKS', 'en_ZM', 'View associations course / course blocks');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_SUBJECTBLOCK_STUDYGRADETYPES', 'en_ZM', 'View associations course block / programmes of study');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_TESTS', 'en_ZM', 'View tests');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_TEST_SUPERVISORS', 'en_ZM', 'View test supervisors');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_USER_ROLES', 'en_ZM', 'View what roles users are assigned to');
insert into opuscollege.opusprivilege(code, lang, description) values('RESET_PASSWORD', 'en_ZM', 'Reset passwords');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_ACADEMIC_YEARS', 'en_ZM', 'Update academic years');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_BRANCHES', 'en_ZM', 'Update second level units');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_EXAMINATIONS', 'en_ZM', 'Update Examinations');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_FEES', 'en_ZM', 'Update fees');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_FOREIGN_STUDYPLAN_DETAILS', 'en_ZM', 'Update studyplan with studyplan details from other universities');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_FOREIGN_STUDYPLAN_RESULTS', 'en_ZM', 'Update studyplan results for studyplan details from other universities');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_INSTITUTIONS', 'en_ZM', 'Update institutions');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_LOOKUPS', 'en_ZM', 'Update lookups');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_SECONDARY_SCHOOLS', 'en_ZM', 'Update organizations');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_OPUSUSER', 'en_ZM', 'Update Opususer data');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_ORG_UNITS', 'en_ZM', 'Update second level units');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_OWN_STUDYPLAN_RESULTS_PENDING_APPROVAL', 'en_ZM', 'Allow each lecturer to update courses and course block results pending approval');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL', 'en_ZM', 'Allow each student to update courses and course block subscriptions pending approval');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_PRIMARY_AND_CHILD_ORG_UNITS', 'en_ZM', 'Update primary second level unit and its children');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_PROGRESS_STATUS', 'en_ZM', 'Update student progress status');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_ROLES', 'en_ZM', 'Update roles');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_STAFFMEMBERS', 'en_ZM', 'Update staff members');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_STAFFMEMBER_CONTRACTS', 'en_ZM', 'Update staff member contracts');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_STAFFMEMBER_ADDRESSES', 'en_ZM', 'Update staff member addresses');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_STUDENTS', 'en_ZM', 'Update students');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_STUDENT_SUBSCRIPTION_DATA', 'en_ZM', 'View student subscription data');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_STUDENT_ABSENCES', 'en_ZM', 'Delete student absences');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_STUDENT_ADDRESSES', 'en_ZM', 'Delete student addresses');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_STUDENT_MEDICAL_DATA', 'en_ZM', 'Update student medical data');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_STUDIES', 'en_ZM', 'Update studies');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_STUDY_ADDRESSES', 'en_ZM', 'Create study addresses');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_STUDY_PLANS', 'en_ZM', 'Update study plans');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_STUDYPLAN_RESULTS', 'en_ZM', 'Update studyplan results');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL', 'en_ZM', 'Update studyplan results upon appeal');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_STUDYGRADETYPE_RFC', 'en_ZM', 'Update RFCs for a programmes of study');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_STUDYGRADETYPES', 'en_ZM', 'Update programmes of study');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_SUBJECTS', 'en_ZM', 'Update courses');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_SUBJECT_STUDYGRADETYPES', 'en_ZM', 'Update associations course / programmes of study');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_SUBJECT_SUBJECTBLOCKS', 'en_ZM', 'Update associations course / course blocks');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_SUBJECTBLOCK_STUDYGRADETYPES', 'en_ZM', 'Update associations course block / programmes of study');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_SUBJECTBLOCKS', 'en_ZM', 'Update course blocks');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_USER_ROLES', 'en_ZM', 'Update user roles');
insert into opuscollege.opusprivilege(code, lang, description) values('TRANSFER_CURRICULUM', 'en_ZM', 'Transfer curriculum');
insert into opuscollege.opusprivilege(code, lang, description) values('TRANSFER_STUDENTS', 'en_ZM', 'Transfer students');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_IDENTIFICATION_DATA', 'en_ZM', 'Create National Registration Number, Identfication Number and Type of a student');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_IDENTIFICATION_DATA', 'en_ZM', 'Delete National Registration Number, Identfication Number and Type of a student');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_IDENTIFICATION_DATA', 'en_ZM', 'Update National Registration Number, Identfication Number and Type of a student');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_IDENTIFICATION_DATA', 'en_ZM', 'View National Registration Number, Identfication Number and Type of a student');
insert into opuscollege.opusprivilege(code, lang, description) values('REVERSE_PROGRESS_STATUS', 'en_ZM', 'Reverse progress statuses in cntd registration');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_STUDENT_NOTES', 'en_ZM', 'Read notes on career interests, activities and placements of students');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_STUDENT_NOTES', 'en_ZM', 'Create notes on career interests, activities and placements of students');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_STUDENT_NOTES', 'en_ZM', 'Alter notes on career interests, activities and placements of students');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_STUDENT_NOTES', 'en_ZM', 'Delete notes on career interests, activities and placements of students');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_STUDENT_COUNSELING', 'en_ZM', 'Read notes on counseling of students');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_STUDENT_COUNSELING', 'en_ZM', 'Create notes on counseling of students');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_STUDENT_COUNSELING', 'en_ZM', 'Alter notes on counseling of students');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_STUDENT_COUNSELING', 'en_ZM', 'Delete notes on counseling of students');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_FINANCE', 'en_ZM', 'Read information in the financial module');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_FINANCE', 'en_ZM', 'Create information in the financial module');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_FINANCE', 'en_ZM', 'Update information in the financial module');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_FINANCE', 'en_ZM', 'Delete information in the financial module');
insert into opuscollege.opusprivilege(code, lang, description) values('TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BACHELOR', 'en_ZM', 'Set the cut-off point for registering bachelor students');
insert into opuscollege.opusprivilege(code, lang, description) values('TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MASTER', 'en_ZM', 'Set the cut-off point for registering master / postgraduate students');
insert into opuscollege.opusprivilege(code, lang, description) values('TOGGLE_CUTOFFPOINT_ADMISSION_BACHELOR', 'en_ZM', 'Set the cut-off point for applying bachelor students');
insert into opuscollege.opusprivilege(code, lang, description) values('GENERATE_HISTORY_REPORTS', 'en_ZM', 'Generate history reports');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_SCHOLARSHIPS', 'en_ZM', 'Create information on scholarships');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_SCHOLARSHIPS', 'en_ZM', 'Read information on scholarships');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_SCHOLARSHIPS', 'en_ZM', 'Update information on scholarships');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_SCHOLARSHIPS', 'en_ZM', 'Delete information on scholarships');
insert into opuscollege.opusprivilege(code, lang, description) values('CREATE_ACCOMMODATION_DATA', 'en_ZM', 'Create accommodation data');
insert into opuscollege.opusprivilege(code, lang, description) values('UPDATE_ACCOMMODATION_DATA', 'en_ZM', 'Update accommodation data');
insert into opuscollege.opusprivilege(code, lang, description) values('DELETE_ACCOMMODATION_DATA', 'en_ZM', 'Delete accommodation data');
insert into opuscollege.opusprivilege(code, lang, description) values('READ_ACCOMMODATION_DATA', 'en_ZM', 'Read accommodation data');
insert into opuscollege.opusprivilege(code, lang, description) values('ACCESS_CONTEXT_HELP', 'en_ZM', 'Show the context help');
insert into opuscollege.opusprivilege(code, lang, description) values('ALLOCATE_ROOM', 'en_ZM', 'Allocate Room');
