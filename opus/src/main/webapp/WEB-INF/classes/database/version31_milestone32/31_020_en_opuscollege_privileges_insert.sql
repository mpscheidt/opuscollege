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

DELETE FROM  opuscollege.opusprivilege where lang = 'en';

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('ADMINISTER_SYSTEM','en','Y','Perform changes on system configuration');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('APPROVE_SUBJECT_SUBSCRIPTIONS','en','Y','Approve subject subscriptions');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('GENERATE_STUDENT_REPORTS','en','Y','Generate student reports');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('GENERATE_STATISTICS','en','Y','Generate statistics');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_ACADEMIC_YEARS','en','Y','Create academic years');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_BRANCHES','en','Y','Create branches');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_CHILD_ORG_UNITS','en','Y','Show child organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_EXAMINATIONS','en','Y','Create exams');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_EXAMINATION_SUPERVISORS','en','Y','Assign examination supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_FEES','en','Y','Create fees');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_FOREIGN_STUDYPLAN_DETAILS','en','Y','Create studyplan details from other universities in a studyplan');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_FOREIGN_STUDYPLAN_RESULTS','en','Y','Create studyplan results for studyplan details from other universities');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_INSTITUTIONS','en','Y','Create institutions');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_LOOKUPS','en','Y','Create lookups');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_ORG_UNITS','en','Y','Create organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL','en','Y','Allow each student to subscribe to subjects and subject blocks pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_ROLES','en','Y','Create roles');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SECONDARY_SCHOOLS','en','Y','Create organizations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STAFFMEMBERS','en','Y','Create Staff members');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STAFFMEMBER_ADDRESSES','en','Y','Create staff member addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STAFFMEMBER_CONTRACTS','en','Y','Create staff member contracts');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDENTS','en','Y','Create all students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDY_PLANS','en','Y','Create study plans');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDENT_ABSENCES','en','Y','Create student absences');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDENT_ADDRESSES','en','Y','Create student addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDIES','en','Y','Create studies');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDY_ADDRESSES','en','Y','Create study addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDYGRADETYPES','en','Y','Create study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECTS','en','Y','Create subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECT_PREREQUISITES','en','Y','Define subjects prerequisites');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECT_STUDYGRADETYPES','en','Y','Assign subjects to study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECT_SUBJECTBLOCKS','en','Y','Assign subjects to subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECT_TEACHERS','en','Y','Assign subject teachers');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECTBLOCKS','en','Y','Create subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECTBLOCK_PREREQUISITES','en','Y','Define subject block prerequisites');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECTBLOCK_STUDYGRADETYPES','en','Y','Assign subject blocks to study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDYPLAN_RESULTS','en','Y','Create studyplan results');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDYPLANDETAILS','en','Y','Subscribe students to subjects and subject blocks pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDYPLANDETAILS_PENDING_APPROVAL','en','Y','Subscribe students to subjects and subject blocks pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_TEST_SUPERVISORS','en','Y','Assign test supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_USER_ROLES','en','Y','Create what roles users are assigned to');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_ACADEMIC_YEARS','en','Y','Delete academic years');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_BRANCHES','en','Y','Delete branches');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_CHILD_ORG_UNITS','en','Y','Delete child organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_EXAMINATIONS','en','Y','Delete examinations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_EXAMINATION_SUPERVISORS','en','Y','Delete examination supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_FEES','en','Y','Delete fees');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_INSTITUTIONS','en','Y','Delete institutions');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_LOOKUPS','en','Y','Delete lookups');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SECONDARY_SCHOOLS','en','Y','Delete organizations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_ORG_UNITS','en','Y','Delete organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_ROLES','en','Y','Delete roles');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STAFFMEMBERS','en','Y','Delete staff members');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STAFFMEMBER_CONTRACTS','en','Y','Delete staff member contracts');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STAFFMEMBER_ADDRESSES','en','Y','Delete staff member addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENTS','en','Y','Delete students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENT_SUBSCRIPTION_DATA','en','Y','Delete student subscription data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENT_ABSENCES','en','Y','Delete student absences');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENT_ADDRESSES','en','Y','Delete student addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDIES','en','Y','Delete studies');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDY_ADDRESSES','en','Y','Delete study addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDYGRADETYPES','en','Y','Delete study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDY_PLANS','en','Y','Delete study plans');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECTS','en','Y','Delete subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECT_PREREQUISITES','en','Y','Remove subject prerequisites');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECT_STUDYGRADETYPES','en','Y','Remove subjects from study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECT_SUBJECTBLOCKS','en','Y','Remove subjects from subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECT_TEACHERS','en','Y','Delete subject teachers');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECTBLOCKS','en','Y','Delete subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECTBLOCK_PREREQUISITES','en','Y','Remove subject block prerequisites');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECTBLOCK_STUDYGRADETYPES','en','Y','Remove subject blocks from study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_TESTS','en','Y','Delete tests');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_TEST_SUPERVISORS','en','Y','Delete test supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_USER_ROLES','en','Y','Remove roles form users');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('FINALIZE_ADMISSION_FLOW','en','Y','Make final progression step in the admission flow');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('FINALIZE_CONTINUED_REGISTRATION_FLOW','en','Y','Make final progression step in the continued registration flow');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('PROGRESS_ADMISSION_FLOW','en','Y','Make progression steps in the admission flow');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('PROGRESS_CONTINUED_REGISTRATION_FLOW','en','Y','Make progression steps in the continued registration flow');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_ACADEMIC_YEARS','en','Y','View academic years');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_BRANCHES','en','Y','View branches');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_EXAMINATIONS','en','Y','View examinations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_EXAMINATION_SUPERVISORS','en','Y','View examination supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_FEES','en','Y','View fees');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_INSTITUTIONS','en','Y','View institutions');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_LOOKUPS','en','Y','View lookups');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_OPUSUSER','en','Y','View Opususer data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_ORG_UNITS','en','Y','View organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_OWN_STUDYPLAN_RESULTS','en','Y','View own study plan results for subjects teacher teaches or student');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_PRIMARY_AND_CHILD_ORG_UNITS','en','Y','View primary organizational unit and its children');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_ROLES','en','Y','View roles');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SECONDARY_SCHOOLS','en','Y','View organizations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STAFFMEMBERS','en','Y','View Staff members');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STAFFMEMBER_CONTRACTS','en','Y','Read staff member contracts');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STAFFMEMBER_ADDRESSES','en','Y','Read staff member addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENTS','en','Y','View all students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENTS_SAME_STUDYGRADETYPE','en','Y','View only students in the study grade type');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_SUBSCRIPTION_DATA','en','Y','View student subscription data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_ABSENCES','en','Y','View student absences');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_ADDRESSES','en','Y','View student addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_MEDICAL_DATA','en','Y','View student medical data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDIES','en','Y','View studies');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDY_ADDRESSES','en','Y','Read study addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDYGRADETYPES','en','Y','View study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDY_PLANS','en','Y','View study plans');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDYPLAN_RESULTS','en','Y','View study plan results');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECTBLOCKS','en','Y','View subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECTS','en','Y','View subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECT_TEACHERS','en','Y','View subject teachers');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECT_STUDYGRADETYPES','en','Y','View associations subject / study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECT_SUBJECTBLOCKS','en','Y','View associations subject / subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECTBLOCK_STUDYGRADETYPES','en','Y','View associations subject block / study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_TESTS','en','Y','View tests');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_TEST_SUPERVISORS','en','Y','View test supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_USER_ROLES','en','Y','View what roles users are assigned to');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('RESET_PASSWORD','en','Y','Reset passwords');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('SET_CARDINALTIMEUNIT_ACTIVELY_REGISTERED','en','Y','Set the cardinal time unit status to actively registered');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TOGGLE_CUTOFFPOINT','en','Y','Set the cut-off point for applying students');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_ACADEMIC_YEARS','en','Y','Update academic years');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_BRANCHES','en','Y','Update branches');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_EXAMINATIONS','en','Y','Update Examinations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_FEES','en','Y','Update fees');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_FOREIGN_STUDYPLAN_DETAILS','en','Y','Update studyplan with studyplan details from other universities');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_FOREIGN_STUDYPLAN_RESULTS','en','Y','Update studyplan results for studyplan details from other universities');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_INSTITUTIONS','en','Y','Update institutions');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_LOOKUPS','en','Y','Update lookups');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SECONDARY_SCHOOLS','en','Y','Update organizations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_OPUSUSER','en','Y','Update Opususer data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_ORG_UNITS','en','Y','Update organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_OWN_STUDYPLAN_RESULTS_PENDING_APPROVAL','en','Y','Allow each teachert to update subjects and subject block results pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL','en','Y','Allow each student to update subjects and subject block subscriptions pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_PRIMARY_AND_CHILD_ORG_UNITS','en','Y','Update primary organizational unit and its children');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_PROGRESS_STATUS','en','Y','Update student progress status');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_ROLES','en','Y','Update roles');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STAFFMEMBERS','en','Y','Update staff members');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STAFFMEMBER_CONTRACTS','en','Y','Update staff member contracts');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STAFFMEMBER_ADDRESSES','en','Y','Update staff member addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENTS','en','Y','Update students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_SUBSCRIPTION_DATA','en','Y','View student subscription data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_ABSENCES','en','Y','Delete student absences');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_ADDRESSES','en','Y','Delete student addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_MEDICAL_DATA','en','Y','Update student medical data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDIES','en','Y','Update studies');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDY_ADDRESSES','en','Y','Create study addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDY_PLANS','en','Y','Update study plans');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDYPLAN_RESULTS','en','Y','Update studyplan results');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL','en','Y','Update studyplan results upon appeal');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDYGRADETYPE_RFC','en','Y','Update RFCs for a study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDYGRADETYPES','en','Y','Update study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECTS','en','Y','Update subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECT_STUDYGRADETYPES','en','Y','Update associations subject / study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECT_SUBJECTBLOCKS','en','Y','Update associations subject / subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECTBLOCK_STUDYGRADETYPES','en','Y','Update associations subject block / study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECTBLOCKS','en','Y','Update subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_USER_ROLES','en','Y','Update user roles');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TRANSFER_CURRICULUM','en','Y','Transfer curriculum');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TRANSFER_STUDENTS','en','Y','Transfer students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TRANSFER_SUBJECTS','en','Y','Transfer selectted and elective subjects to next ctu');

