/*******************************************************************************
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"), you may not use this file except in compliance with
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

-- 
-- Author: Markus Pscheidt
-- Date: 2018-03-02

-- system related tables
CREATE INDEX opususerrole_role_idx ON opuscollege.opususerrole (role);

-- study related tables
-- there is an old record with organizationalunitid = -1, which prevents creating a foreign key
delete from opuscollege.study
where not exists (
  select 1 from opuscollege.organizationalunit where study.organizationalunitid = organizationalunit.id
);
ALTER TABLE opuscollege.study ADD CONSTRAINT study_organizationalunitid_fkey FOREIGN KEY (organizationalunitid) REFERENCES opuscollege.organizationalunit (id);
CREATE INDEX study_organizationalUnitId_idx ON opuscollege.study (organizationalunitid);
  
CREATE INDEX subject_currentacademicyearid_idx ON opuscollege.subject (currentacademicyearid);
CREATE INDEX subject_primaryStudyId_idx ON opuscollege.subject (primaryStudyId);
CREATE INDEX subjectteacher_subjectid_idx ON opuscollege.subjectTeacher (subjectid);
CREATE INDEX subjectSubjectBlock_subjectId_idx ON opuscollege.subjectSubjectBlock (subjectId);

CREATE INDEX examination_subjectId_idx ON opuscollege.examination (subjectId);

CREATE INDEX studygradetype_currentAcademicYearId_idx ON opuscollege.studygradetype (currentAcademicYearId);
CREATE INDEX studygradetype_studyId_idx ON opuscollege.studygradetype (studyId);

CREATE INDEX test_examinationid_idx ON opuscollege.test (examinationid);

-- student related tables
CREATE INDEX student_personId_idx ON opuscollege.student (personId);
CREATE INDEX student_studentId_idx ON opuscollege.student (studentId);

CREATE INDEX studyplan_studentId_idx ON opuscollege.studyplan (studentId);

CREATE INDEX studyPlanCardinalTimeUnit_cardinalTimeUnitStatusCode_idx ON opuscollege.studyPlanCardinalTimeUnit (cardinalTimeUnitStatusCode);
CREATE INDEX studyPlanCardinalTimeUnit_studyGradeTypeId_idx ON opuscollege.studyPlanCardinalTimeUnit (studyGradeTypeId);
CREATE INDEX studyPlanCardinalTimeUnit_studyPlanId_idx ON opuscollege.studyPlanCardinalTimeUnit (studyPlanId);

CREATE INDEX studyPlanDetail_studyPlanCardinalTimeUnitId_idx ON opuscollege.studyPlanDetail (studyPlanCardinalTimeUnitId);
CREATE INDEX studyPlanDetail_subjectblockid_idx ON opuscollege.studyPlanDetail (subjectblockid);
CREATE INDEX studyPlanDetail_subjectid_idx ON opuscollege.studyPlanDetail (subjectid);

-- result related tables

-- these take relatively much of disk space: from 2214 MB to 2234 and 2255 MB for the two indexes
CREATE INDEX subjectResult_studyPlanDetailId_idx ON opuscollege.subjectresult (studyplandetailid);
CREATE INDEX subjectResult_subjectId_idx ON opuscollege.subjectresult (subjectId);

CREATE INDEX examinationResult_studyPlanDetailId_idx ON opuscollege.examinationResult (studyPlanDetailId);
CREATE INDEX testResult_studyPlanDetailId_idx ON opuscollege.testResult (studyPlanDetailId);

-- history tables are expensive: before 2299 MB, after 2359 MB (only for subjectresult_hist_subjectId_idx)
CREATE INDEX subjectresult_hist_subjectId_idx ON audit.subjectresult_hist (subjectId);
CREATE INDEX examinationresult_hist_examinationid_idx ON audit.examinationresult_hist (examinationid);
CREATE INDEX testresult_hist_testid_idx ON audit.testresult_hist (testid);

