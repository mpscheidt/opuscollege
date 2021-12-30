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

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.28);



DELETE FROM  opuscollege.opusprivilege where lang = 'pt';

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('ADMINISTER_SYSTEM','pt','Y','Perform changes on system configuration');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('APPROVE_SUBJECT_SUBSCRIPTIONS','pt','Y','Approve subject subscriptions');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('GENERATE_STUDENT_REPORTS','pt','Y','Generate student reports');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('GENERATE_STATISTICS','pt','Y','Generate statistics');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_ACADEMIC_YEARS','pt','Y','Create academic years');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_BRANCHES','pt','Y','Create branches');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_CHILD_ORG_UNITS','pt','Y','Show child organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_EXAMINATIONS','pt','Y','Create exams');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_EXAMINATION_SUPERVISORS','pt','Y','Assign examination supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_FOREIGN_STUDYPLAN_DETAILS','pt','Y','Create studyplan details from other universities in a studyplan');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_FOREIGN_STUDYPLAN_RESULTS','pt','Y','Create studyplan results for studyplan details from other universities');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_FEES','pt','Y','Create fees');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_INSTITUTIONS','pt','Y','Create institutions');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_LOOKUPS','pt','Y','Create lookups');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_ORG_UNITS','pt','Y','Create organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL','pt','Y','Allow each student to subscribe to subjects and subject blocks pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_ROLES','pt','Y','Create roles');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SECONDARY_SCHOOLS','pt','Y','Create organizations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STAFFMEMBERS','pt','Y','Create Staff members');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STAFFMEMBER_ADDRESSES','pt','Y','Create staff member addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STAFFMEMBER_CONTRACTS','pt','Y','Create staff member contracts');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDENTS','pt','Y','Create all students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDY_PLANS','pt','Y','Create study plans');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDENT_ABSENCES','pt','Y','Create student absences');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDENT_ADDRESSES','pt','Y','Create student addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDIES','pt','Y','Create studies');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDY_ADDRESSES','pt','Y','Create study addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDYGRADETYPE_RFC','pt','Y','Create RFCs for a study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDYGRADETYPES','pt','Y','Create study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECTS','pt','Y','Create subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECT_PREREQUISITES','pt','Y','Define subjects prerequisites');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECT_STUDYGRADETYPES','pt','Y','Assign subjects to study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECT_SUBJECTBLOCKS','pt','Y','Assign subjects to subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECT_TEACHERS','pt','Y','Assign subject teachers');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECTBLOCKS','pt','Y','Create subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECTBLOCK_PREREQUISITES','pt','Y','Define subject block prerequisites');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECTBLOCK_STUDYGRADETYPES','pt','Y','Assign subject blocks to study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDYPLAN_RESULTS','pt','Y','Create studyplan results');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDYPLANDETAILS','pt','Y','Subscribe students to subjects and subject blocks pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDYPLANDETAILS_PENDING_APPROVAL','pt','Y','Subscribe students to subjects and subject blocks pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_TEST_SUPERVISORS','pt','Y','Assign test supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_USER_ROLES','pt','Y','Create what roles users are assigned to');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_ACADEMIC_YEARS','pt','Y','Delete academic years');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_BRANCHES','pt','Y','Delete branches');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_CHILD_ORG_UNITS','pt','Y','Delete child organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_EXAMINATIONS','pt','Y','Delete examinations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_EXAMINATION_SUPERVISORS','pt','Y','Delete examination supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_FEES','pt','Y','Delete fees');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_INSTITUTIONS','pt','Y','Delete institutions');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_LOOKUPS','pt','Y','Delete lookups');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SECONDARY_SCHOOLS','pt','Y','Delete organizations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_ORG_UNITS','pt','Y','Delete organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_ROLES','pt','Y','Delete roles');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STAFFMEMBERS','pt','Y','Delete staff members');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STAFFMEMBER_CONTRACTS','pt','Y','Delete staff member contracts');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STAFFMEMBER_ADDRESSES','pt','Y','Delete staff member addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENTS','pt','Y','Delete students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENT_SUBSCRIPTION_DATA','pt','Y','Delete student subscription data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENT_ABSENCES','pt','Y','Delete student absences');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENT_ADDRESSES','pt','Y','Delete student addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDIES','pt','Y','Delete studies');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDY_ADDRESSES','pt','Y','Delete study addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDYGRADETYPES','pt','Y','Delete study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDY_PLANS','pt','Y','Delete study plans');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECTS','pt','Y','Delete subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECT_PREREQUISITES','pt','Y','Remove subject prerequisites');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECT_STUDYGRADETYPES','pt','Y','Remove subjects from study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECT_SUBJECTBLOCKS','pt','Y','Remove subjects from subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECT_TEACHERS','pt','Y','Delete subject teachers');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECTBLOCKS','pt','Y','Delete subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECTBLOCK_PREREQUISITES','pt','Y','Remove subject block prerequisites');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECTBLOCK_STUDYGRADETYPES','pt','Y','Remove subject blocks from study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_TESTS','pt','Y','Delete tests');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_TEST_SUPERVISORS','pt','Y','Delete test supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_USER_ROLES','pt','Y','Remove roles form users');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('FINALIZE_ADMISSION_FLOW','pt','Y','Make final progression step in the admission flow');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('FINALIZE_CONTINUED_REGISTRATION_FLOW','pt','Y','Make final progression step in the continued registration flow');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('PROGRESS_ADMISSION_FLOW','pt','Y','Make progression steps in the admission flow');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('PROGRESS_CONTINUED_REGISTRATION_FLOW','pt','Y','Make progression steps in the continued registration flow');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_ACADEMIC_YEARS','pt','Y','View academic years');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_BRANCHES','pt','Y','View branches');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_EXAMINATIONS','pt','Y','View examinations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_EXAMINATION_SUPERVISORS','pt','Y','View examination supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_FEES','pt','Y','View fees');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_INSTITUTIONS','pt','Y','View institutions');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_LOOKUPS','pt','Y','View lookups');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_OPUSUSER','pt','Y','View Opususer data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_ORG_UNITS','pt','Y','View organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_OWN_STUDYPLAN_RESULTS','pt','Y','View own study plan results for subjects teacher teaches or student');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_PRIMARY_AND_CHILD_ORG_UNITS','pt','Y','View primary organizational unit and its children');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_ROLES','pt','Y','View roles');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SECONDARY_SCHOOLS','pt','Y','View organizations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STAFFMEMBERS','pt','Y','View Staff members');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STAFFMEMBER_CONTRACTS','pt','Y','Read staff member contracts');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STAFFMEMBER_ADDRESSES','pt','Y','Read staff member addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENTS','pt','Y','View all students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENTS_SAME_STUDYGRADETYPE','pt','Y','View only students in the study grade type');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_SUBSCRIPTION_DATA','pt','Y','View student subscription data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_ABSENCES','pt','Y','View student absences');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_ADDRESSES','pt','Y','View student addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_MEDICAL_DATA','pt','Y','View student medical data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDIES','pt','Y','View studies');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDY_ADDRESSES','pt','Y','Read study addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDYGRADETYPES','pt','Y','View study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDY_PLANS','pt','Y','View study plans');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDYPLAN_RESULTS','pt','Y','View study plan results');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECTBLOCKS','pt','Y','View subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECTS','pt','Y','View subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECT_TEACHERS','pt','Y','View subject teachers');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECT_STUDYGRADETYPES','pt','Y','View associations subject / study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECT_SUBJECTBLOCKS','pt','Y','View associations subject / subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECTBLOCK_STUDYGRADETYPES','pt','Y','View associations subject block / study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_TESTS','pt','Y','View tests');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_TEST_SUPERVISORS','pt','Y','View test supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_USER_ROLES','pt','Y','View what roles users are assigned to');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('RESET_PASSWORD','pt','Y','Reset passwords');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('SET_CARDINALTIMEUNIT_ACTIVELY_REGISTERED','pt','Y','Set the cardinal time unit status to actively registered');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TOGGLE_CUTOFFPOINT','pt','Y','Set the cut-off point for applying students');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_ACADEMIC_YEARS','pt','Y','Update academic years');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_BRANCHES','pt','Y','Update branches');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_EXAMINATIONS','pt','Y','Update Examinations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_FEES','pt','Y','Update fees');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_FOREIGN_STUDYPLAN_DETAILS','pt','Y','Update studyplan with studyplan details from other universities');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_FOREIGN_STUDYPLAN_RESULTS','pt','Y','Update studyplan results for studyplan details from other universities');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_INSTITUTIONS','pt','Y','Update institutions');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_LOOKUPS','pt','Y','Update lookups');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SECONDARY_SCHOOLS','pt','Y','Update organizations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_OPUSUSER','pt','Y','Update Opususer data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_OWN_STUDYPLAN_RESULTS_PENDING_APPROVAL','pt','Y','Allow each teachert to update subjects and subject block results pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL','pt','Y','Allow each student to update subjects and subject block subscriptions pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_ORG_UNITS','pt','Y','Update organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_PRIMARY_AND_CHILD_ORG_UNITS','pt','Y','Update primary organizational unit and its children');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_ROLES','pt','Y','Update roles');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STAFFMEMBERS','pt','Y','Update staff members');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STAFFMEMBER_CONTRACTS','pt','Y','Update staff member contracts');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STAFFMEMBER_ADDRESSES','pt','Y','Update staff member addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENTS','pt','Y','Update students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_SUBSCRIPTION_DATA','pt','Y','View student subscription data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_ABSENCES','pt','Y','Delete student absences');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_ADDRESSES','pt','Y','Delete student addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_MEDICAL_DATA','pt','Y','Update student medical data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDIES','pt','Y','Update studies');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDY_ADDRESSES','pt','Y','Create study addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDY_PLANS','pt','Y','Update study plans');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDYPLAN_RESULTS','pt','Y','Update studyplan results');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL','pt','Y','Update studyplan results upon appeal');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDYGRADETYPE_RFC','pt','Y','Update RFCs for a study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDYGRADETYPES','pt','Y','Update study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECTS','pt','Y','Update subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECT_STUDYGRADETYPES','pt','Y','Update associations subject / study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECT_SUBJECTBLOCKS','pt','Y','Update associations subject / subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECTBLOCK_STUDYGRADETYPES','pt','Y','Update associations subject block / study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECTBLOCKS','pt','Y','Update subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_USER_ROLES','pt','Y','Update user roles');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TRANSFER_CURRICULUM','pt','Y','Transfer curriculum');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TRANSFER_STUDENTS','pt','Y','Transfer students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TRANSFER_SUBJECTS','pt','Y','Transfer selectted and elective subjects to next ctu');

