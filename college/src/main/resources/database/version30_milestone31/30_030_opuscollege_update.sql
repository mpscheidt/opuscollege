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

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.06);

-------------------------------------------------------
-- cardinal time unit
-------------------------------------------------------

-- add extra columns to studygradetype:
ALTER TABLE opuscollege.studyGradeType ADD COLUMN studyTimeCode VARCHAR;
ALTER table opuscollege.studyGradeType ADD column currentAcademicYearId INTEGER NOT NULL DEFAULT 0;
ALTER table opuscollege.studyGradeType ADD column cardinalTimeUnitCode VARCHAR NOT NULL DEFAULT '';
ALTER table opuscollege.studyGradeType ADD column numberOfCardinalTimeUnits INTEGER NOT NULL DEFAULT 0;
ALTER table opuscollege.studyGradeType ADD column maxNumberOfCardinalTimeUnits INTEGER NOT NULL DEFAULT 0;
ALTER table opuscollege.studyGradeType ADD column numberOfSubjectsPerCardinalTimeUnit INTEGER NOT NULL DEFAULT 0;
ALTER table opuscollege.studyGradeType ADD column maxNumberOfSubjectsPerCardinalTimeUnit INTEGER NOT NULL DEFAULT 0;

-- set default value for cardinalTimeUnitCode of existing records to studyyear (code '1'):
UPDATE opuscollege.studyGradeType SET cardinalTimeUnitCode = '1';
-- set default value for maxNumberOfCardinalTimeUnits of existing records to 7:
UPDATE opuscollege.studyGradeType SET maxNumberOfCardinalTimeUnits = 7;
-- move current values of numberOfYears to numberOfCardinalTimeUnits:
--UPDATE opuscollege.studyGradeType a
--	SET numberOfCardinalTimeUnits = (
--		SELECT numberOfYears from opuscollege.studyGradeType b
--		WHERE a.id = b.id 
--	);
-- drop column numberOfYears:
ALTER table opuscollege.studyGradeType DROP column numberOfYears;

-- finally: delete studyYearAcademicYear
DROP SEQUENCE IF EXISTS studyYearAcademicYearSeq;
DROP TABLE IF EXISTS opuscollege.studyYearAcademicYear;

DROP SEQUENCE IF EXISTS opuscollege.subjectBlockStudyGradeTypeSeq CASCADE;
DROP TABLE IF EXISTS opuscollege.subjectBlockStudyGradeType CASCADE;

-------------------------------------------------------
-- SEQUENCE cardinalTimeUnitResultSeq
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.cardinalTimeUnitResultSeq CASCADE;

-------------------------------------------------------
-- TABLE cardinalTimeUnitResult
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.cardinalTimeUnitResult CASCADE;

-------------------------------------------------------
-- DOMAIN TABLE endGrade
-------------------------------------------------------
CREATE SEQUENCE opuscollege.endGradeSeq;
ALTER TABLE opuscollege.endGradeSeq OWNER TO postgres;

CREATE TABLE opuscollege.endGrade (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.endGradeSeq'), 
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	active CHAR(1) NOT NULL DEFAULT 'Y',
	endGradeTypeCode VARCHAR NOT NULL,
	gradePoint numeric(5,2),
	percentageMin numeric(5,2),
	percentageMax numeric(5,2),
    comment VARCHAR,
    description VARCHAR,
	temporaryGrade CHAR(1) NOT NULL DEFAULT 'N',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.endGrade OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.endGrade TO postgres;

-- move current values in markEvaluation to endGrade:
INSERT INTO opuscollege.endGrade (
	code, lang, active, endGradeTypeCode, gradePoint, comment, description
	)	
SELECT code, lang, active, '', round(CAST (description AS numeric)), description, description
FROM opuscollege.markEvaluation;

-------------------------------------------------------
-- DELETE TABLE markEvaluation and SEQUENCE markEvaluationSeq
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.markEvaluationSeq CASCADE;
DROP TABLE IF EXISTS opuscollege.markEvaluation CASCADE;
DELETE FROM opuscollege.lookuptable where tableName = 'markEvaluation';

