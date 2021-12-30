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

-------------------------------------------------------
-- LOOKUP TABLES
-------------------------------------------------------

------------------------------------------------------
-- table civilTitle
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.civilTitle CASCADE;

-------------------------------------------------------
-- TABLE gender
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.gender CASCADE;

-------------------------------------------------------
-- TABLE administrativePost
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.administrativePost CASCADE;

-------------------------------------------------------
-- TABLE nationality
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.nationality CASCADE;

-------------------------------------------------------
-- TABLE district
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.district CASCADE;

-------------------------------------------------------
-- TABLE province
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.province CASCADE;

-------------------------------------------------------
-- TABLE country
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.country CASCADE;

-------------------------------------------------------
-- TABLE civilStatus
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.civilStatus CASCADE;

-------------------------------------------------------
-- TABLE identificationType
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.identificationType CASCADE;

-------------------------------------------------------
-- TABLE language
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.language CASCADE;

-------------------------------------------------------
-- TABLE masteringLevel
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.masteringLevel CASCADE;

-------------------------------------------------------
-- TABLE appointmentType
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.appointmentType CASCADE;

-------------------------------------------------------
-- TABLE staffType
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.staffType CASCADE;

-------------------------------------------------------
-- TABLE unitArea
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.unitArea CASCADE;

-------------------------------------------------------
-- TABLE unitType
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.unitType CASCADE;

-------------------------------------------------------
-- TABLE academicField
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.academicField CASCADE;

-------------------------------------------------------
-- TABLE function
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.function CASCADE;

-------------------------------------------------------
-- TABLE functionLevel
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.functionLevel CASCADE;

-------------------------------------------------------
-- TABLE educationType
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.educationType CASCADE;

-------------------------------------------------------
-- TABLE levelOfEducation
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.levelOfEducation CASCADE;

-------------------------------------------------------
-- TABLE fieldOfEducation
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.fieldOfEducation CASCADE;

-------------------------------------------------------
-- TABLE profession
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.profession CASCADE;

-------------------------------------------------------
-- TABLE studyForm
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.studyForm CASCADE;

-------------------------------------------------------
-- TABLE studyTime
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.studyTime CASCADE;

-------------------------------------------------------
-- TABLE targetGroup
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.targetGroup CASCADE;

-------------------------------------------------------
-- TABLE contractType
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.contractType CASCADE;

-------------------------------------------------------
-- TABLE contractDuration
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.contractDuration CASCADE;

-------------------------------------------------------
-- TABLE bloodType
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.bloodType CASCADE;

-------------------------------------------------------
-- TABLE addressType
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.addressType CASCADE;

-------------------------------------------------------
-- TABLE relationType
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.relationType CASCADE;

-------------------------------------------------------
-- TABLE status
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.status CASCADE;

-------------------------------------------------------
-- table studyType
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.studyType CASCADE;

-------------------------------------------------------
-- table gradeType (also used for: academicTitle)
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.gradeType CASCADE;

-------------------------------------------------------
-- table frequency
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.frequency CASCADE;

-------------------------------------------------------
-- table blockType
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.blockType CASCADE;

-------------------------------------------------------
-- table rigidityType
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.rigidityType CASCADE;

-------------------------------------------------------
-- table timeUnit
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.timeUnit CASCADE;

-------------------------------------------------------
-- table subjectImportance
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.subjectImportance CASCADE;

-------------------------------------------------------
-- table examType
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.examType CASCADE;

-------------------------------------------------------
-- table examinationType
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.examinationType CASCADE;

