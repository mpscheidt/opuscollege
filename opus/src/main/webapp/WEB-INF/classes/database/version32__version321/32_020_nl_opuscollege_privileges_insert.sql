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

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.29);



DELETE FROM  opuscollege.opusprivilege where lang = 'nl';

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('ADMINISTER_SYSTEM','nl','Y','Perform changes on system configuration');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('APPROVE_SUBJECT_SUBSCRIPTIONS','nl','Y','Approve subject subscriptions');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('GENERATE_STUDENT_REPORTS','nl','Y','Generate student reports');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('GENERATE_STATISTICS','nl','Y','Generate statistics');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_ACADEMIC_YEARS','nl','Y','Create academic years');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_BRANCHES','nl','Y','Create branches');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_CHILD_ORG_UNITS','nl','Y','Show child organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_EXAMINATIONS','nl','Y','Create exams');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_EXAMINATION_SUPERVISORS','nl','Y','Assign examination supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_FOREIGN_STUDYPLAN_DETAILS','nl','Y','Create studyplan details from other universities in a studyplan');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_FOREIGN_STUDYPLAN_RESULTS','nl','Y','Create studyplan results for studyplan details from other universities');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_FEES','nl','Y','Create fees');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_INSTITUTIONS','nl','Y','Create institutions');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_LOOKUPS','nl','Y','Create lookups');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_ORG_UNITS','nl','Y','Create organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL','nl','Y','Allow each student to subscribe to subjects and subject blocks pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_ROLES','nl','Y','Create roles');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SECONDARY_SCHOOLS','nl','Y','Create organizations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STAFFMEMBERS','nl','Y','Create Staff members');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STAFFMEMBER_ADDRESSES','nl','Y','Create staff member addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STAFFMEMBER_CONTRACTS','nl','Y','Create staff member contracts');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDENTS','nl','Y','Create all students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDY_PLANS','nl','Y','Create study plans');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDENT_ABSENCES','nl','Y','Create student absences');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDENT_ADDRESSES','nl','Y','Create student addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDIES','nl','Y','Create studies');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDY_ADDRESSES','nl','Y','Create study addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDYGRADETYPE_RFC','nl','Y','Create RFCs for a study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDYGRADETYPES','nl','Y','Create study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECTS','nl','Y','Create subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECT_PREREQUISITES','nl','Y','Define subjects prerequisites');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECT_STUDYGRADETYPES','nl','Y','Assign subjects to study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECT_SUBJECTBLOCKS','nl','Y','Assign subjects to subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECT_TEACHERS','nl','Y','Assign subject teachers');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECTBLOCKS','nl','Y','Create subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECTBLOCK_PREREQUISITES','nl','Y','Define subject block prerequisites');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECTBLOCK_STUDYGRADETYPES','nl','Y','Assign subject blocks to study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDYPLAN_RESULTS','nl','Y','Create studyplan results');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDYPLANDETAILS','nl','Y','Subscribe students to subjects and subject blocks pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDYPLANDETAILS_PENDING_APPROVAL','nl','Y','Subscribe students to subjects and subject blocks pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_TEST_SUPERVISORS','nl','Y','Assign test supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_USER_ROLES','nl','Y','Create what roles users are assigned to');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_ACADEMIC_YEARS','nl','Y','Delete academic years');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_BRANCHES','nl','Y','Delete branches');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_CHILD_ORG_UNITS','nl','Y','Delete child organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_EXAMINATIONS','nl','Y','Delete examinations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_EXAMINATION_SUPERVISORS','nl','Y','Delete examination supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_FEES','nl','Y','Delete fees');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_INSTITUTIONS','nl','Y','Delete institutions');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_LOOKUPS','nl','Y','Delete lookups');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SECONDARY_SCHOOLS','nl','Y','Delete organizations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_ORG_UNITS','nl','Y','Delete organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_ROLES','nl','Y','Delete roles');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STAFFMEMBERS','nl','Y','Delete staff members');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STAFFMEMBER_CONTRACTS','nl','Y','Delete staff member contracts');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STAFFMEMBER_ADDRESSES','nl','Y','Delete staff member addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENTS','nl','Y','Delete students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENT_SUBSCRIPTION_DATA','nl','Y','Delete student subscription data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENT_ABSENCES','nl','Y','Delete student absences');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENT_ADDRESSES','nl','Y','Delete student addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDIES','nl','Y','Delete studies');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDY_ADDRESSES','nl','Y','Delete study addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDYGRADETYPES','nl','Y','Delete study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDY_PLANS','nl','Y','Delete study plans');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECTS','nl','Y','Delete subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECT_PREREQUISITES','nl','Y','Remove subject prerequisites');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECT_STUDYGRADETYPES','nl','Y','Remove subjects from study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECT_SUBJECTBLOCKS','nl','Y','Remove subjects from subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECT_TEACHERS','nl','Y','Delete subject teachers');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECTBLOCKS','nl','Y','Delete subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECTBLOCK_PREREQUISITES','nl','Y','Remove subject block prerequisites');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECTBLOCK_STUDYGRADETYPES','nl','Y','Remove subject blocks from study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_TESTS','nl','Y','Delete tests');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_TEST_SUPERVISORS','nl','Y','Delete test supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_USER_ROLES','nl','Y','Remove roles form users');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('FINALIZE_ADMISSION_FLOW','nl','Y','Make final progression step in the admission flow');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('FINALIZE_CONTINUED_REGISTRATION_FLOW','nl','Y','Make final progression step in the continued registration flow');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('PROGRESS_ADMISSION_FLOW','nl','Y','Make progression steps in the admission flow');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('PROGRESS_CONTINUED_REGISTRATION_FLOW','nl','Y','Make progression steps in the continued registration flow');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_ACADEMIC_YEARS','nl','Y','View academic years');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_BRANCHES','nl','Y','View branches');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_EXAMINATIONS','nl','Y','View examinations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_EXAMINATION_SUPERVISORS','nl','Y','View examination supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_FEES','nl','Y','View fees');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_INSTITUTIONS','nl','Y','View institutions');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_LOOKUPS','nl','Y','View lookups');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_OPUSUSER','nl','Y','View Opususer data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_ORG_UNITS','nl','Y','View organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_OWN_STUDYPLAN_RESULTS','nl','Y','View own study plan results for subjects teacher teaches or student');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_PRIMARY_AND_CHILD_ORG_UNITS','nl','Y','View primary organizational unit and its children');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_ROLES','nl','Y','View roles');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SECONDARY_SCHOOLS','nl','Y','View organizations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STAFFMEMBERS','nl','Y','View Staff members');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STAFFMEMBER_CONTRACTS','nl','Y','Read staff member contracts');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STAFFMEMBER_ADDRESSES','nl','Y','Read staff member addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENTS','nl','Y','View all students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENTS_SAME_STUDYGRADETYPE','nl','Y','View only students in the study grade type');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_SUBSCRIPTION_DATA','nl','Y','View student subscription data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_ABSENCES','nl','Y','View student absences');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_ADDRESSES','nl','Y','View student addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_MEDICAL_DATA','nl','Y','View student medical data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDIES','nl','Y','View studies');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDY_ADDRESSES','nl','Y','Read study addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDYGRADETYPES','nl','Y','View study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDY_PLANS','nl','Y','View study plans');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDYPLAN_RESULTS','nl','Y','View study plan results');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECTBLOCKS','nl','Y','View subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECTS','nl','Y','View subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECT_TEACHERS','nl','Y','View subject teachers');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECT_STUDYGRADETYPES','nl','Y','View associations subject / study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECT_SUBJECTBLOCKS','nl','Y','View associations subject / subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECTBLOCK_STUDYGRADETYPES','nl','Y','View associations subject block / study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_TESTS','nl','Y','View tests');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_TEST_SUPERVISORS','nl','Y','View test supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_USER_ROLES','nl','Y','View what roles users are assigned to');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('RESET_PASSWORD','nl','Y','Reset passwords');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('SET_CARDINALTIMEUNIT_ACTIVELY_REGISTERED','nl','Y','Set the cardinal time unit status to actively registered');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TOGGLE_CUTOFFPOINT','nl','Y','Cut-off point bepalen voor zich aanmeldende studenten');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_ACADEMIC_YEARS','nl','Y','Update academic years');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_BRANCHES','nl','Y','Update branches');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_EXAMINATIONS','nl','Y','Update Examinations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_FEES','nl','Y','Update fees');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_FOREIGN_STUDYPLAN_DETAILS','nl','Y','Update studyplan with studyplan details from other universities');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_FOREIGN_STUDYPLAN_RESULTS','nl','Y','Update studyplan results for studyplan details from other universities');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_INSTITUTIONS','nl','Y','Update institutions');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_LOOKUPS','nl','Y','Update lookups');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SECONDARY_SCHOOLS','nl','Y','Update organizations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_OPUSUSER','nl','Y','Update Opususer data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_OWN_STUDYPLAN_RESULTS_PENDING_APPROVAL','nl','Y','Allow each teachert to update subjects and subject block results pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL','nl','Y','Allow each student to update subjects and subject block subscriptions pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_ORG_UNITS','nl','Y','Update organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_PRIMARY_AND_CHILD_ORG_UNITS','nl','Y','Update primary organizational unit and its children');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_ROLES','nl','Y','Update roles');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STAFFMEMBERS','nl','Y','Update staff members');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STAFFMEMBER_CONTRACTS','nl','Y','Update staff member contracts');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STAFFMEMBER_ADDRESSES','nl','Y','Update staff member addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENTS','nl','Y','Update students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_SUBSCRIPTION_DATA','nl','Y','View student subscription data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_ABSENCES','nl','Y','Delete student absences');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_ADDRESSES','nl','Y','Delete student addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_MEDICAL_DATA','nl','Y','Update student medical data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDIES','nl','Y','Update studies');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDY_ADDRESSES','nl','Y','Create study addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDY_PLANS','nl','Y','Update study plans');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDYPLAN_RESULTS','nl','Y','Update studyplan results');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL','nl','Y','Update studyplan results upon appeal');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDYGRADETYPE_RFC','nl','Y','Update RFCs for a study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDYGRADETYPES','nl','Y','Update study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECTS','nl','Y','Update subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECT_STUDYGRADETYPES','nl','Y','Update associations subject / study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECT_SUBJECTBLOCKS','nl','Y','Update associations subject / subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECTBLOCK_STUDYGRADETYPES','nl','Y','Update associations subject block / study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECTBLOCKS','nl','Y','Update subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_USER_ROLES','nl','Y','Update user roles');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TRANSFER_CURRICULUM','nl','Y','Transfer curriculum');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TRANSFER_STUDENTS','nl','Y','Transfer students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TRANSFER_SUBJECTS','nl','Y','Transfer selectted and elective subjects to next ctu');

