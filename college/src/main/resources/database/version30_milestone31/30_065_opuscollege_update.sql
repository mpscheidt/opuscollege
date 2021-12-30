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

-- KERNEL opuscollege / MODULE college

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.13);

-------------------------------------------------------
-- DOMAIN TABLE cardinalTimeUnitStudyGradeType
-------------------------------------------------------
CREATE SEQUENCE opuscollege.cardinalTimeUnitStudyGradeTypeSeq;
ALTER TABLE opuscollege.cardinalTimeUnitStudyGradeTypeSeq OWNER TO postgres;

CREATE TABLE opuscollege.cardinalTimeUnitStudyGradeType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.cardinalTimeUnitStudyGradeTypeSeq'), 
    studyGradeTypeId INTEGER NOT NULL REFERENCES opuscollege.studyGradeType(id) ON DELETE CASCADE ON UPDATE CASCADE,
    cardinalTimeUnitNumber INTEGER NOT NULL DEFAULT 0,
	currentAcademicYearId INTEGER NOT NULL DEFAULT 0,
	numberOfElectiveSubjectBlocks INTEGER NOT NULL DEFAULT 0,
	numberOfElectiveSubjects INTEGER NOT NULL DEFAULT 0,
	active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(studyGradeTypeId,cardinalTimeUnitNumber,currentAcademicYearId)
);
ALTER TABLE opuscollege.cardinalTimeUnitStudyGradeType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.cardinalTimeUnitStudyGradeType TO postgres;

-------------------------------------------------------
-- DOMAIN TABLE studyPlanCardinalTimeUnit
-------------------------------------------------------
CREATE SEQUENCE opuscollege.studyPlanCardinalTimeUnitSeq;
ALTER TABLE opuscollege.studyPlanCardinalTimeUnitSeq OWNER TO postgres;

CREATE TABLE opuscollege.studyPlanCardinalTimeUnit (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studyPlanCardinalTimeUnitSeq'), 
    studyPlanId INTEGER NOT NULL REFERENCES opuscollege.studyPlan(id) ON DELETE CASCADE ON UPDATE CASCADE,
    cardinalTimeUnitNumber INTEGER NOT NULL DEFAULT 0,
	currentAcademicYearId INTEGER NOT NULL DEFAULT 0,
	progressStatusCode INTEGER NOT NULL DEFAULT 0,
	active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(studyPlanId,cardinalTimeUnitNumber,currentAcademicYearId)
);
ALTER TABLE opuscollege.studyPlanCardinalTimeUnit OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.studyPlanCardinalTimeUnit TO postgres;

-------------------------------------------------------
-- new lookup table progressStatus
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.progressStatusSeq CASCADE;
CREATE SEQUENCE opuscollege.progressStatusSeq;
ALTER TABLE opuscollege.endGradeTypeSeq OWNER TO postgres;

DROP TABLE IF EXISTS opuscollege.progressStatus CASCADE;
CREATE TABLE opuscollege.progressStatus (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.progressStatusSeq'),
    code VARCHAR NOT NULL,
    lang CHAR(2) NOT NULL,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.progressStatus OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.progressStatus TO postgres;






-- !! examination and test tables should not need currentAcademicYearId
-- !! because they are directly linked to subject, which has the acad. year set

-------------------------------------------------------
-- domain table examination
-------------------------------------------------------
--ALTER TABLE opuscollege.examination ADD COLUMN currentAcademicYearId INTEGER NOT NULL DEFAULT 0;

-------------------------------------------------------
-- domain table test
-------------------------------------------------------
--ALTER TABLE opuscollege.test ADD COLUMN currentAcademicYearId INTEGER NOT NULL DEFAULT 0;
