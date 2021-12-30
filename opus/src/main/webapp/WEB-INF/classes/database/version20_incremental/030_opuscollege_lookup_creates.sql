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
-- Lookup-tables
-------------------------------------------------------
------------------------------------------------------
-- table civilTitle
-------------------------------------------------------

CREATE TABLE opuscollege.civilTitle (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.civilTitleSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.civilTitle OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.civilTitle TO postgres;

-------------------------------------------------------
-- table gender
-------------------------------------------------------
CREATE TABLE opuscollege.gender (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.genderSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.gender OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.gender TO postgres;

-------------------------------------------------------
-- table nationality
-------------------------------------------------------
CREATE TABLE opuscollege.nationality (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.nationalitySeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    descriptionShort CHAR(10),
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.nationality OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.nationality TO postgres;

-------------------------------------------------------
-- table district
-------------------------------------------------------
CREATE TABLE opuscollege.district (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.districtSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    provinceCode VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.district OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.district TO postgres;

-------------------------------------------------------
-- table administrativePost
-------------------------------------------------------
CREATE TABLE opuscollege.administrativePost (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.administrativePostSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    districtCode VARCHAR NOT NULL,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.administrativePost OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.administrativePost TO postgres;

-------------------------------------------------------
-- table province
-------------------------------------------------------
CREATE TABLE opuscollege.province (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.provinceSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    countryCode INTEGER,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.province OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.province TO postgres;

-------------------------------------------------------
-- table country
-------------------------------------------------------
CREATE TABLE opuscollege.country (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.countrySeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    short2 CHAR(2),
    short3 CHAR(3),
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.country OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.country TO postgres;

-------------------------------------------------------
-- table civilStatus
-------------------------------------------------------
CREATE TABLE opuscollege.civilStatus (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.civilStatusSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.civilStatus OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.civilStatus TO postgres;

-------------------------------------------------------
-- table identificationType
-------------------------------------------------------
CREATE TABLE opuscollege.identificationType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.identificationTypeSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.identificationType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.identificationType TO postgres;

-------------------------------------------------------
-- table language
-------------------------------------------------------
CREATE TABLE opuscollege.language (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.languageSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    descriptionShort CHAR(2),
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.language OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.language TO postgres;

-------------------------------------------------------
-- table masteringLevel
-------------------------------------------------------
CREATE TABLE opuscollege.masteringLevel (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.masteringLevelSeq'),
    code VARCHAR NOT NULL, -- not used
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.masteringLevel OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.masteringLevel TO postgres;

-------------------------------------------------------
-- table appointmentType
-------------------------------------------------------
CREATE TABLE opuscollege.appointmentType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.appointmentTypeSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.appointmentType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.appointmentType TO postgres;

-------------------------------------------------------
-- table staffType
-------------------------------------------------------
CREATE TABLE opuscollege.staffType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.staffTypeSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.staffType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.staffType TO postgres;

-------------------------------------------------------
-- table unitArea
-------------------------------------------------------
CREATE TABLE opuscollege.unitArea (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.unitAreaSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.unitArea OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.unitArea TO postgres;

-------------------------------------------------------
-- table unitType
-------------------------------------------------------
CREATE TABLE opuscollege.unitType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.unitTypeSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
   PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.unitType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.unitType TO postgres;

-------------------------------------------------------
-- table academicField
-------------------------------------------------------
CREATE TABLE opuscollege.academicField (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.academicFieldSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.academicField OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.academicField TO postgres;

-------------------------------------------------------
-- table function
-------------------------------------------------------
CREATE TABLE opuscollege.function (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.functionSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.function OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.function TO postgres;

-------------------------------------------------------
-- table functionLevel
-------------------------------------------------------
CREATE TABLE opuscollege.functionLevel (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.functionLevelSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.functionLevel OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.functionLevel TO postgres;

-------------------------------------------------------
-- table educationType
-------------------------------------------------------
CREATE TABLE opuscollege.educationType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.educationTypeSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.educationType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.educationType TO postgres;

-------------------------------------------------------
-- table levelOfEducation
-------------------------------------------------------
CREATE TABLE opuscollege.levelOfEducation (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.levelOfEducationSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.levelOfEducation OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.levelOfEducation TO postgres;

-------------------------------------------------------
-- table fieldOfEducation
-------------------------------------------------------
CREATE TABLE opuscollege.fieldOfEducation (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.fieldOfEducationSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.fieldOfEducation OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.fieldOfEducation TO postgres;

-------------------------------------------------------
-- table profession
-------------------------------------------------------
CREATE TABLE opuscollege.profession (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.professionSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.profession OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.profession TO postgres;

-------------------------------------------------------
-- table studyForm
-------------------------------------------------------
CREATE TABLE opuscollege.studyForm (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studyFormSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.studyForm OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.studyForm TO postgres;

-------------------------------------------------------
-- table studyTime
-------------------------------------------------------
CREATE TABLE opuscollege.studyTime (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studyTimeSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.studyTime OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.studyTime TO postgres;

-------------------------------------------------------
-- table targetGroup
-------------------------------------------------------
CREATE TABLE opuscollege.targetGroup (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.targetGroupSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.targetGroup OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.targetGroup TO postgres;

-------------------------------------------------------
-- table contractType
-------------------------------------------------------
CREATE TABLE opuscollege.contractType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.contractTypeSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.contractType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.contractType TO postgres;

-------------------------------------------------------
-- table contractDuration
-------------------------------------------------------
CREATE TABLE opuscollege.contractDuration (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.contractDurationSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.contractDuration OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.contractDuration TO postgres;

-------------------------------------------------------
-- table bloodType
-------------------------------------------------------
CREATE TABLE opuscollege.bloodType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.bloodTypeSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.bloodType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.bloodType TO postgres;

-------------------------------------------------------
-- table addressType
-------------------------------------------------------
CREATE TABLE opuscollege.addressType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.addressTypeSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.addressType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.addressType TO postgres;

-------------------------------------------------------
-- TABLE relationType
-------------------------------------------------------
CREATE TABLE opuscollege.relationType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.relationTypeSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.relationType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.relationType TO postgres;

-------------------------------------------------------
-- TABLE status
-------------------------------------------------------
CREATE TABLE opuscollege.status (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.statusSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.status OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.status TO postgres;

-------------------------------------------------------
-- table studyType
-------------------------------------------------------
CREATE TABLE opuscollege.studyType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studyTypeSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.studyType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.studyType TO postgres;

-------------------------------------------------------
-- TABLE gradeType (also used for academicTitle)
-------------------------------------------------------
CREATE TABLE opuscollege.gradeType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.gradeTypeSeq'), 
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    title VARCHAR NOT NULL,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.gradeType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.gradeType TO postgres;


-------------------------------------------------------
-- table frequency
-------------------------------------------------------
CREATE TABLE opuscollege.frequency (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.frequencySeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.frequency OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.frequency TO postgres;

-------------------------------------------------------
-- table blockType
-------------------------------------------------------
CREATE TABLE opuscollege.blockType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.blockTypeSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.blockType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.blockType TO postgres;

-------------------------------------------------------
-- table rigidityType
-------------------------------------------------------
CREATE TABLE opuscollege.rigidityType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.rigidityTypeSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.rigidityType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.rigidityType TO postgres;

-------------------------------------------------------
-- table timeUnit
-------------------------------------------------------
CREATE TABLE opuscollege.timeUnit (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.timeUnitSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.timeUnit OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.timeUnit TO postgres;

-------------------------------------------------------
-- table subjectImportance
-------------------------------------------------------
CREATE TABLE opuscollege.subjectImportance (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.subjectImportanceSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.subjectImportance OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.subjectImportance TO postgres;

-------------------------------------------------------
-- table examType
-------------------------------------------------------
CREATE TABLE opuscollege.examType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.examTypeSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.examType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.examType TO postgres;

-------------------------------------------------------
-- table examinationType
-------------------------------------------------------
CREATE TABLE opuscollege.examinationType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.examinationTypeSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.examinationType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.examinationType TO postgres;
