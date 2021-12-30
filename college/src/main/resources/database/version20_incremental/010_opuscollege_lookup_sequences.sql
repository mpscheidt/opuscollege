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
-- CREATEDB opusCollege UTF8 owner postgres tablespace pg_default;
--
-- delete entire schema: DROP SCHEMA opuscollege CASCADE;
--
-- CREATE SCHEMA opuscollege
-- AUTHORIZATION postgres;
--
-- GRANT USAGE ON SCHEMA opuscollege TO postgres;
--

-------------------------------------------------------
-- Sequences
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.civilTitleSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.nationalitySeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.districtSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.administrativePostSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.provinceSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.countrySeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.civilStatusSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.identificationTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.languageSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.masteringLevelSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.appointmentTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.staffTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.unitAreaSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.unitTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.academicFieldSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.genderSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.functionSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.functionLevelSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.educationTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.levelOfEducationSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.fieldOfEducationSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.professionSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.studyFormSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.studyTimeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.targetGroupSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.contractTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.contractDurationSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.bloodTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.addressTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.relationTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.statusSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.studyTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.gradeTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.frequencySeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.blockTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.rigidityTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.timeUnitSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.subjectImportanceSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.examTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.examinationTypeSeq CASCADE;

CREATE SEQUENCE opuscollege.civilTitleSeq;
CREATE SEQUENCE opuscollege.nationalitySeq;
CREATE SEQUENCE opuscollege.districtSeq;
CREATE SEQUENCE opuscollege.administrativePostSeq;
CREATE SEQUENCE opuscollege.provinceSeq;
CREATE SEQUENCE opuscollege.countrySeq;
CREATE SEQUENCE opuscollege.civilStatusSeq;
CREATE SEQUENCE opuscollege.identificationTypeSeq;
CREATE SEQUENCE opuscollege.languageSeq;
CREATE SEQUENCE opuscollege.masteringLevelSeq;
CREATE SEQUENCE opuscollege.appointmentTypeSeq;
CREATE SEQUENCE opuscollege.staffTypeSeq;
CREATE SEQUENCE opuscollege.unitAreaSeq;
CREATE SEQUENCE opuscollege.unitTypeSeq;
CREATE SEQUENCE opuscollege.academicFieldSeq;
CREATE SEQUENCE opuscollege.genderSeq;
CREATE SEQUENCE opuscollege.functionSeq;
CREATE SEQUENCE opuscollege.functionLevelSeq;
CREATE SEQUENCE opuscollege.educationTypeSeq;
CREATE SEQUENCE opuscollege.levelOfEducationSeq;
CREATE SEQUENCE opuscollege.fieldOfEducationSeq;
CREATE SEQUENCE opuscollege.professionSeq;
CREATE SEQUENCE opuscollege.studyFormSeq;
CREATE SEQUENCE opuscollege.studyTimeSeq;
CREATE SEQUENCE opuscollege.targetGroupSeq;
CREATE SEQUENCE opuscollege.contractTypeSeq;
CREATE SEQUENCE opuscollege.contractDurationSeq;
CREATE SEQUENCE opuscollege.bloodTypeSeq;
CREATE SEQUENCE opuscollege.addressTypeSeq;
CREATE SEQUENCE opuscollege.relationTypeSeq;
CREATE SEQUENCE opuscollege.statusSeq;
CREATE SEQUENCE opuscollege.studyTypeSeq;
CREATE SEQUENCE opuscollege.gradeTypeSeq;
CREATE SEQUENCE opuscollege.frequencySeq;
CREATE SEQUENCE opuscollege.blockTypeSeq;
CREATE SEQUENCE opuscollege.rigidityTypeSeq;
CREATE SEQUENCE opuscollege.timeUnitSeq;
CREATE SEQUENCE opuscollege.subjectImportanceSeq;
CREATE SEQUENCE opuscollege.examTypeSeq;
CREATE SEQUENCE opuscollege.examinationTypeSeq;

ALTER TABLE opuscollege.civilTitleSeq OWNER TO postgres;
ALTER TABLE opuscollege.nationalitySeq OWNER TO postgres;
ALTER TABLE opuscollege.districtSeq OWNER TO postgres;
ALTER TABLE opuscollege.administrativePostSeq OWNER TO postgres;
ALTER TABLE opuscollege.provinceSeq OWNER TO postgres;
ALTER TABLE opuscollege.countrySeq OWNER TO postgres;
ALTER TABLE opuscollege.civilStatusSeq OWNER TO postgres;
ALTER TABLE opuscollege.identificationTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.languageSeq OWNER TO postgres;
ALTER TABLE opuscollege.masteringLevelSeq OWNER TO postgres;
ALTER TABLE opuscollege.appointmentTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.staffTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.unitAreaSeq OWNER TO postgres;
ALTER TABLE opuscollege.unitTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.academicFieldSeq OWNER TO postgres;
ALTER TABLE opuscollege.genderSeq OWNER TO postgres;
ALTER TABLE opuscollege.functionSeq OWNER TO postgres;
ALTER TABLE opuscollege.functionLevelSeq OWNER TO postgres;
ALTER TABLE opuscollege.educationTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.levelOfEducationSeq OWNER TO postgres;
ALTER TABLE opuscollege.fieldOfEducationSeq OWNER TO postgres;
ALTER TABLE opuscollege.professionSeq OWNER TO postgres;
ALTER TABLE opuscollege.studyFormSeq OWNER TO postgres;
ALTER TABLE opuscollege.studyTimeSeq OWNER TO postgres;
ALTER TABLE opuscollege.targetGroupSeq OWNER TO postgres;
ALTER TABLE opuscollege.contractTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.contractDurationSeq OWNER TO postgres;
ALTER TABLE opuscollege.bloodTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.addressTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.relationTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.statusSeq OWNER TO postgres;
ALTER TABLE opuscollege.studyTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.gradeTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.frequencySeq OWNER TO postgres;
ALTER TABLE opuscollege.blockTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.rigidityTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.timeUnitSeq OWNER TO postgres;
ALTER TABLE opuscollege.subjectImportanceSeq OWNER TO postgres;
ALTER TABLE opuscollege.examTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.examinationTypeSeq OWNER TO postgres;

