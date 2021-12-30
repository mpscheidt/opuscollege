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

-- Opus College
-- KERNEL opuscollege / MODULE college
--
-- Initial author: Markus Pscheidt

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.17);

-------------------------------------------------------
-- SEQUENCE cardinalTimeUnitResultSeq
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.cardinalTimeUnitResultSeq CASCADE;

CREATE SEQUENCE opuscollege.cardinalTimeUnitResultSeq;
ALTER TABLE opuscollege.cardinalTimeUnitResultSeq OWNER TO postgres;

-------------------------------------------------------
-- TABLE cardinalTimeUnitResult
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.cardinalTimeUnitResult CASCADE;

CREATE TABLE opuscollege.cardinalTimeUnitResult (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.cardinalTimeUnitResultSeq'), 
    studyPlanId INTEGER NOT NULL DEFAULT 0,
	studyPlanCardinalTimeUnitId INTEGER NOT NULL DEFAULT 0,
    cardinalTimeUnitResultDate DATE,
	endGrade numeric(5,2),
 	active CHAR(1) NOT NULL DEFAULT 'Y',
	passed CHAR(1) NOT NULL DEFAULT 'N',
	writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(studyPlanId,studyPlanCardinalTimeUnitId)
);
ALTER TABLE opuscollege.cardinalTimeUnitResult OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.cardinalTimeUnitResult TO postgres;

-------------------------------------------------------
-- TABLE studyPlanDetail
-------------------------------------------------------
--INSERT INTO opuscollege.studyPlanCardinalTimeUnit (studyPlanId, currentAcademicYearId, cardinalTimeUnitNumber) 
--	(	SELECT studyPlanId, academicYearId, 1 
--		FROM opuscollege.studyPlanDetail
--	);
	
ALTER TABLE opuscollege.studyPlanDetail DROP COLUMN academicYearId;
ALTER TABLE opuscollege.studyPlanDetail ADD COLUMN studyPlanCardinalTimeUnitId INTEGER NOT NULL DEFAULT 0;

-------------------------------------------------------
-- TABLE studyPlanCardinalTimeUnit
-------------------------------------------------------
ALTER TABLE opuscollege.studyPlanCardinalTimeUnit ADD COLUMN studyGradeTypeId INTEGER NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.studyPlanCardinalTimeUnit DROP COLUMN currentAcademicYearId;

-------------------------------------------------------
-- TABLE studyPlan
-------------------------------------------------------
--UPDATE opuscollege.studyPlanCardinalTimeUnit a 
--	SET studyGradeTypeID =	
--		(SELECT studyGradeTypeID FROM opuscollege.studyPlan b
--		WHERE a.studyPlanId = b.id) 
--;

ALTER TABLE opuscollege.studyPlan DROP COLUMN studyGradeTypeId;
ALTER TABLE opuscollege.studyPlan DROP COLUMN currentAcademicYearId;
ALTER TABLE opuscollege.studyPlan ADD COLUMN studyId INTEGER NOT NULL default 0;
ALTER TABLE opuscollege.studyPlan ADD COLUMN gradeTypeCode VARCHAR;

-------------------------------------------------------
-- TABLE cardinalTimeUnitStudyGradeType
-------------------------------------------------------
ALTER TABLE opuscollege.cardinalTimeUnitStudyGradeType DROP COLUMN currentAcademicYearId;

-------------------------------------------------------
-- TABLE lookupTable
-------------------------------------------------------
INSERT INTO opuscollege.lookupTable(tableName , lookupType , active) VALUES ('progressStatus', 'Lookup', 'Y');

