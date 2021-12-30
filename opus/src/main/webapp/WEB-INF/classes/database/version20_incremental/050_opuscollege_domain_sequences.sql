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

-- Opus College (c) UCI - Monique in het Veld May 2007
--
-- CREATEDB opusCollege --UTF8 --owner postgres --tablespace pg_default
--
-- CREATE SCHEMA opuscollege
-- AUTHORIZATION postgres;

--

-------------------------------------------------------
-- Domain tables
-------------------------------------------------------
-------------------------------------------------------
-- Sequences
-------------------------------------------------------

DROP SEQUENCE IF EXISTS opuscollege.addressSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.branchSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.contractSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.institutionSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.opusUserSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.opusUserRoleSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.organizationalUnitSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.personSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.roleSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.staffMemberSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.studentSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.studentAbsenceSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.studySeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.studyGradeTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.studyYearSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.subjectSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.subjectBlockSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.studyPlanSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.studyPlanDetailSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.examinationSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.examinationResultSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.subjectResultSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.appVersionsSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.subjectTeacherSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.examinationTeacherSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.subjectStudyGradeTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.subjectSubjectBlockSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.subjectStudyYearSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.subjectBlockStudyGradeTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.subjectBlockStudyYearSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.subjectStudyTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.examSeq CASCADE;

CREATE SEQUENCE opuscollege.addressSeq;
CREATE SEQUENCE opuscollege.branchSeq;
CREATE SEQUENCE opuscollege.contractSeq;
CREATE SEQUENCE opuscollege.institutionSeq;
CREATE SEQUENCE opuscollege.opusUserSeq;
CREATE SEQUENCE opuscollege.opusUserRoleSeq;
CREATE SEQUENCE opuscollege.organizationalUnitSeq;
CREATE SEQUENCE opuscollege.personSeq;
CREATE SEQUENCE opuscollege.roleSeq;
CREATE SEQUENCE opuscollege.staffMemberSeq;
CREATE SEQUENCE opuscollege.studentSeq;
CREATE SEQUENCE opuscollege.studentAbsenceSeq;
CREATE SEQUENCE opuscollege.studySeq;
CREATE SEQUENCE opuscollege.studyGradeTypeSeq;
CREATE SEQUENCE opuscollege.studyYearSeq;
CREATE SEQUENCE opuscollege.subjectSeq;
CREATE SEQUENCE opuscollege.subjectBlockSeq;
CREATE SEQUENCE opuscollege.studyPlanSeq;
CREATE SEQUENCE opuscollege.studyPlanDetailSeq;
CREATE SEQUENCE opuscollege.examinationSeq;
CREATE SEQUENCE opuscollege.examinationResultSeq;
CREATE SEQUENCE opuscollege.subjectResultSeq;
CREATE SEQUENCE opuscollege.appVersionsSeq;
CREATE SEQUENCE opuscollege.subjectTeacherSeq;
CREATE SEQUENCE opuscollege.examinationTeacherSeq;
CREATE SEQUENCE opuscollege.subjectStudyGradeTypeSeq;
CREATE SEQUENCE opuscollege.subjectSubjectBlockSeq;
CREATE SEQUENCE opuscollege.subjectStudyYearSeq;
CREATE SEQUENCE opuscollege.subjectBlockStudyGradeTypeSeq;
CREATE SEQUENCE opuscollege.subjectBlockStudyYearSeq;
CREATE SEQUENCE opuscollege.subjectStudyTypeSeq;
CREATE SEQUENCE opuscollege.examSeq;

ALTER TABLE opuscollege.addressSeq OWNER TO postgres;
ALTER TABLE opuscollege.branchSeq OWNER TO postgres;
ALTER TABLE opuscollege.contractSeq OWNER TO postgres;
ALTER TABLE opuscollege.institutionSeq OWNER TO postgres;
ALTER TABLE opuscollege.opusUserSeq OWNER TO postgres;
ALTER TABLE opuscollege.opusUserRoleSeq OWNER TO postgres;
ALTER TABLE opuscollege.organizationalUnitSeq OWNER TO postgres;
ALTER TABLE opuscollege.personSeq OWNER TO postgres;
ALTER TABLE opuscollege.roleSeq OWNER TO postgres;
ALTER TABLE opuscollege.staffMemberSeq OWNER TO postgres;
ALTER TABLE opuscollege.studentSeq OWNER TO postgres;
ALTER TABLE opuscollege.studentAbsenceSeq OWNER TO postgres;
ALTER TABLE opuscollege.studySeq OWNER TO postgres;
ALTER TABLE opuscollege.studyGradeTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.studyYearSeq OWNER TO postgres;
ALTER TABLE opuscollege.subjectSeq OWNER TO postgres;
ALTER TABLE opuscollege.subjectBlockSeq OWNER TO postgres;
ALTER TABLE opuscollege.studyPlanSeq OWNER TO postgres;
ALTER TABLE opuscollege.studyPlanDetailSeq OWNER TO postgres;
ALTER TABLE opuscollege.examinationSeq OWNER TO postgres;
ALTER TABLE opuscollege.examinationResultSeq OWNER TO postgres;
ALTER TABLE opuscollege.subjectResultSeq OWNER TO postgres;
ALTER TABLE opuscollege.appVersionsSeq OWNER TO postgres;
ALTER TABLE opuscollege.subjectTeacherSeq OWNER TO postgres;
ALTER TABLE opuscollege.examinationTeacherSeq OWNER TO postgres;
ALTER TABLE opuscollege.subjectStudyGradeTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.subjectSubjectBlockSeq OWNER TO postgres;
ALTER TABLE opuscollege.subjectStudyYearSeq OWNER TO postgres;
ALTER TABLE opuscollege.subjectBlockStudyGradeTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.subjectBlockStudyYearSeq OWNER TO postgres;
ALTER TABLE opuscollege.subjectStudyTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.examSeq OWNER TO postgres;
