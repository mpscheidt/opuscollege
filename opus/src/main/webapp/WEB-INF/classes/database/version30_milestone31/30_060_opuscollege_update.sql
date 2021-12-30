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

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.12);

-------------------------------------------------------
-- table subjectStudyGradeType
-------------------------------------------------------
ALTER TABLE opuscollege.subjectStudyGradeType ADD COLUMN cardinalTimeUnitNumber INTEGER NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.subjectStudyGradeType ADD COLUMN rigidityTypeCode CHARACTER VARYING;

-------------------------------------------------------
-- table subjectBlockStudyGradeType
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.subjectBlockStudyGradeTypeSeq CASCADE;
CREATE SEQUENCE opuscollege.subjectBlockStudyGradeTypeSeq;
ALTER TABLE opuscollege.subjectBlockStudyGradeTypeSeq OWNER TO postgres;

DROP TABLE IF EXISTS opuscollege.subjectBlockStudyGradeType CASCADE;
CREATE TABLE opuscollege.subjectBlockStudyGradeType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.subjectBlockStudyGradeTypeSeq'), 
    subjectBlockId INTEGER NOT NULL REFERENCES opuscollege.subjectBlock(id) ON DELETE CASCADE ON UPDATE CASCADE,
    studyGradeTypeId INTEGER REFERENCES opuscollege.studyGradeType(id) ON DELETE CASCADE ON UPDATE CASCADE,
    cardinalTimeUnitNumber INTEGER NOT NULL DEFAULT 0,
    rigidityTypeCode CHARACTER VARYING,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(subjectBlockId,studyGradeTypeId,cardinalTimeUnitNumber,rigidityTypeCode)
);
ALTER TABLE opuscollege.subjectBlockStudyGradeType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.subjectBlockStudyGradeType TO postgres; 

-------------------------------------------------------
-- table subject
-------------------------------------------------------
ALTER TABLE opuscollege.subject DROP COLUMN cardinalTimeUnitNumber;
ALTER TABLE opuscollege.subject DROP COLUMN cardinalTimeUnitCode;
ALTER TABLE opuscollege.subject DROP COLUMN studyFormCode;
ALTER TABLE opuscollege.subject DROP COLUMN subjectImportanceCode;
ALTER TABLE opuscollege.subject DROP COLUMN rigidityTypeCode;
ALTER TABLE opuscollege.subject DROP COLUMN brsApplyingToSubject;
ALTER TABLE opuscollege.subject DROP COLUMN subjectStructureValidFromYear;
ALTER TABLE opuscollege.subject DROP COLUMN subjectStructureValidThroughYear;
-------------------------------------------------------
-- table subjectBlock
-------------------------------------------------------
ALTER TABLE opuscollege.subjectBlock ADD COLUMN primaryStudyId integer NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.subjectBlock ADD COLUMN importanceCode CHARACTER VARYING;
ALTER TABLE opuscollege.subjectBlock ADD COLUMN freeChoiceOption character(1) DEFAULT 'N';

ALTER TABLE opuscollege.subjectBlock DROP COLUMN cardinalTimeUnitNumber;
ALTER TABLE opuscollege.subjectBlock DROP COLUMN cardinalTimeUnitCode;
--ALTER TABLE opuscollege.subjectBlock DROP COLUMN studyGradeTypeId; Comment: subjectBlock.studyGradeTypeId does not exist
ALTER TABLE opuscollege.subjectBlock DROP COLUMN subjectBlockStructureValidFromYear;
ALTER TABLE opuscollege.subjectBlock DROP COLUMN subjectBlockStructureValidThroughYear;
-------------------------------------------------------
-- table studyGradeType
-------------------------------------------------------
ALTER TABLE opuscollege.studyGradeType ADD COLUMN studyFormCode CHARACTER VARYING;

-------------------------------------------------------
-- new lookup table endGradeType
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.endGradeTypeSeq CASCADE;
CREATE SEQUENCE opuscollege.endGradeTypeSeq;
ALTER TABLE opuscollege.endGradeTypeSeq OWNER TO postgres;

DROP TABLE IF EXISTS opuscollege.endGradeType CASCADE;
CREATE TABLE opuscollege.endGradeType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.endGradeTypeSeq'),
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
ALTER TABLE opuscollege.endGradeType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.endGradeType TO postgres;

-------------------------------------------------------
-- DOMAIN TABLE endGradeGeneral
-------------------------------------------------------
CREATE SEQUENCE opuscollege.endGradeGeneralSeq;
ALTER TABLE opuscollege.endGradeGeneralSeq OWNER TO postgres;

CREATE TABLE opuscollege.endGradeGeneral (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.endGradeGeneralSeq'), 
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	active CHAR(1) NOT NULL DEFAULT 'Y',
    comment VARCHAR,
    description VARCHAR,
	temporaryGrade CHAR(1) NOT NULL DEFAULT 'N',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.endGradeGeneral OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.endGradeGeneral TO postgres;

-------------------------------------------------------
-- DOMAIN TABLE failGrade
-------------------------------------------------------
CREATE SEQUENCE opuscollege.failGradeSeq;
ALTER TABLE opuscollege.failGradeSeq OWNER TO postgres;

CREATE TABLE opuscollege.failGrade (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.failGradeSeq'), 
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	active CHAR(1) NOT NULL DEFAULT 'Y',
    comment VARCHAR,
    description VARCHAR,
	temporaryGrade CHAR(1) NOT NULL DEFAULT 'N',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.failGrade OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.failGrade TO postgres;
