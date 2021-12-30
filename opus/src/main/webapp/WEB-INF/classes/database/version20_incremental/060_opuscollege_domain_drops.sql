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
--

-------------------------------------------------------
-- Domain tables
-------------------------------------------------------

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.appVersions CASCADE;

-------------------------------------------------------
-- table role
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.role CASCADE;

-------------------------------------------------------
-- table opusUser
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.opusUser CASCADE;

-------------------------------------------------------
-- table opusUserRole
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.opusUserRole CASCADE;


-------------------------------------------------------
-- table institution
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.institution CASCADE;

-------------------------------------------------------
-- table branch
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.branch CASCADE;

-------------------------------------------------------
-- table person
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.person CASCADE;

-------------------------------------------------------
-- table organizationalUnit
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.organizationalUnit CASCADE;

-------------------------------------------------------
-- table staffMemberFunction
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.staffMemberFunction CASCADE;

-------------------------------------------------------
-- table staffMember
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.staffMember CASCADE;

-------------------------------------------------------
-- table contract
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.contract CASCADE;

-------------------------------------------------------
-- table student
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.student CASCADE;

-------------------------------------------------------
-- table studentAbsence
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.studentAbsence CASCADE;

-------------------------------------------------------
-- TABLE study
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.study CASCADE;

-------------------------------------------------------
-- TABLE address
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.address;

-------------------------------------------------------
-- TABLE studyGradeType
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.studyGradeType CASCADE;

-------------------------------------------------------
-- TABLE studyYear
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.studyYear CASCADE;

-------------------------------------------------------
-- TABLE subject
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.subject CASCADE;

-------------------------------------------------------
-- TABLE subjectBlock
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.subjectBlock CASCADE;

-------------------------------------------------------
-- TABLE subjectSubjectBlock
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.subjectSubjectBlock CASCADE;

-------------------------------------------------------
-- TABLE subjectStudyGradeType
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.subjectStudyGradeType CASCADE;

-------------------------------------------------------
-- table subjectStudyYear
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.subjectStudyYear CASCADE;

-------------------------------------------------------
-- table subjectBlockStudyGradeType
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.subjectBlockStudyGradeType CASCADE;

-------------------------------------------------------
-- table subjectBlockStudyYear
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.subjectBlockStudyYear CASCADE;

-------------------------------------------------------
-- table subjectTeacher
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.subjectTeacher CASCADE;

-------------------------------------------------------
-- table subjectStudyType
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.subjectStudyType CASCADE;

-------------------------------------------------------
-- TABLE studyPlan
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.studyPlan CASCADE;

-------------------------------------------------------
-- TABLE studyPlanDetail
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.studyPlanDetail CASCADE;

-------------------------------------------------------
-- TABLE examination
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.examination CASCADE;

-------------------------------------------------------
-- table examinationTeacher
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.examinationTeacher CASCADE;

-------------------------------------------------------
-- TABLE examinationResult
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.examinationResult CASCADE;

-------------------------------------------------------
-- TABLE subjectResult
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.subjectResult CASCADE;

-------------------------------------------------------
-- TABLE exam
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.exam CASCADE;

-------------------------------------------------------
-- TABLE node_relationships_n_level
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.node_relationships_n_level;

-------------------------------------------------------
-- FUNCTION crawl_tree
-------------------------------------------------------
DROP FUNCTION IF EXISTS opuscollege.crawl_tree(integer, integer);



   