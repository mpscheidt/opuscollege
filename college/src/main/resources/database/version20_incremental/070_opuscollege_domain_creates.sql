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
CREATE TABLE opuscollege.appVersions (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.appVersionsSeq'), 
	coreDb numeric(5,1) NOT NULL DEFAULT 1.0,
	coreWar numeric(5,1) NOT NULL DEFAULT 1.0,
	reportsDb numeric(5,1) NOT NULL DEFAULT 0,
	reportsJar numeric(5,1) NOT NULL DEFAULT 0,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.appVersions OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.appVersions TO postgres;

-------------------------------------------------------
-- table role
-------------------------------------------------------
CREATE TABLE opuscollege.role (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.roleSeq'), 
	lang CHAR(2) NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    role VARCHAR NOT NULL, -- name of the role
    roleDescription VARCHAR NOT NULL,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(lang,role)
);
ALTER TABLE opuscollege.role OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.role TO postgres;

-------------------------------------------------------
-- table person
-------------------------------------------------------
CREATE TABLE opuscollege.person (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.personSeq'),
    personCode VARCHAR NOT NULL, 
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    surNameFull VARCHAR NOT NULL,
    surNameAlias VARCHAR,
    firstNamesFull VARCHAR NOT NULL,
    firstNamesAlias VARCHAR,
    nationalRegistrationNumber VARCHAR,
    civilTitleCode VARCHAR,
    gradeTypeCode VARCHAR,
    genderCode VARCHAR DEFAULT '3',
    birthDate DATE NOT NULL DEFAULT now(),
    nationalityCode VARCHAR,
    placeOfBirth VARCHAR,
    districtOfBirthCode VARCHAR,
    provinceOfBirthCode VARCHAR,
    countryOfBirthCode VARCHAR,
    cityOfOrigin VARCHAR,
    administrativePostOfOriginCode VARCHAR,
    districtOfOriginCode VARCHAR,
    provinceOfOriginCode VARCHAR,
    countryOfOriginCode VARCHAR,
    civilStatusCode VARCHAR,
    housingOnCampus CHAR(1),
    identificationTypeCode VARCHAR,
    identificationNumber VARCHAR,
    identificationPlaceOfIssue VARCHAR,
    identificationDateOfIssue DATE,
    identificationDateOfExpiration DATE,
    professionCode VARCHAR, 
    professionDescription VARCHAR, 
    languageFirstCode VARCHAR ,
    languageFirstMasteringLevelCode VARCHAR ,
    languageSecondCode VARCHAR ,
    languageSecondMasteringLevelCode VARCHAR ,
    languageThirdCode VARCHAR,
    languageThirdMasteringLevelCode VARCHAR ,
    contactPersonEmergenciesName VARCHAR,
    contactPersonEmergenciesTelephoneNumber VARCHAR,
    bloodTypeCode VARCHAR ,
    healthIssues VARCHAR,
    photograph BYTEA,
    remarks VARCHAR,
    registrationDate DATE NOT NULL DEFAULT now(),
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(personCode)
);
ALTER TABLE opuscollege.person OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.person TO postgres;

-------------------------------------------------------
-- table opusUser
-------------------------------------------------------
CREATE TABLE opuscollege.opusUser (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.opusUserSeq'),
    personId INTEGER NOT NULL DEFAULT 0,
    userName VARCHAR NOT NULL, -- login name
    pw VARCHAR, -- password
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(userName)
);
ALTER TABLE opuscollege.opusUser OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.opusUser TO postgres;

-------------------------------------------------------
-- table opusUserRole
-------------------------------------------------------
CREATE TABLE opuscollege.opusUserRole (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.opusUserRoleSeq'),
    lang CHAR(2) NOT NULL,
    role VARCHAR NOT NULL,
    userName VARCHAR NOT NULL REFERENCES opuscollege.opusUser(userName) ON DELETE CASCADE ON UPDATE CASCADE,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(role, userName),
    FOREIGN KEY (lang,role) REFERENCES opuscollege.role(lang,role)
);
ALTER TABLE opuscollege.opusUserRole OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.opusUserRole TO postgres;

-------------------------------------------------------
-- table institution
-------------------------------------------------------
CREATE TABLE opuscollege.institution (
	id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.institutionSeq'), 
    institutionCode VARCHAR NOT NULL,
    educationTypeCode VARCHAR NOT NULL,
    institutionDescription VARCHAR,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    provinceCode VARCHAR NOT NULL,
    rector VARCHAR,
    registrationDate DATE NOT NULL DEFAULT now(),
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(institutionCode)
);
ALTER TABLE opuscollege.institution OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.institution TO postgres;

-------------------------------------------------------
-- table branch
-------------------------------------------------------
CREATE TABLE opuscollege.branch (
	id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.branchSeq'), 
    branchCode VARCHAR NOT NULL,
    branchDescription VARCHAR,
    institutionId INTEGER NOT NULL REFERENCES opuscollege.institution(id) ON DELETE CASCADE ON UPDATE CASCADE,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    registrationDate DATE NOT NULL DEFAULT now(),
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.branch OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.branch TO postgres;

-------------------------------------------------------
-- table organizationalUnit
-------------------------------------------------------
CREATE TABLE opuscollege.organizationalUnit (
	id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.organizationalUnitSeq'), 
    organizationalUnitCode VARCHAR NOT NULL,
    organizationalUnitDescription VARCHAR,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    branchId INTEGER NOT NULL,
    unitLevel INTEGER NOT NULL DEFAULT 0,
    parentOrganizationalUnitId INTEGER NOT NULL DEFAULT 0,
    unitAreaCode VARCHAR NOT NULL,
    unitTypeCode VARCHAR NOT NULL,
    academicFieldCode VARCHAR NOT NULL,
	directorId INTEGER NOT NULL, -- director
    registrationDate DATE NOT NULL DEFAULT now(),
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(organizationalUnitCode)
);
ALTER TABLE opuscollege.organizationalUnit OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.organizationalUnit TO postgres;

-------------------------------------------------------
-- table staffMember
-------------------------------------------------------
CREATE TABLE opuscollege.staffMember (
    staffMemberId INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.staffMemberSeq'), 
    staffMemberCode VARCHAR NOT NULL, 
    personId INTEGER NOT NULL REFERENCES opuscollege.person(id) ON DELETE CASCADE ON UPDATE CASCADE,
    dateOfAppointment DATE DEFAULT now(),
    appointmentTypeCode VARCHAR,
    staffTypeCode VARCHAR,
    primaryUnitOfAppointmentId INTEGER NOT NULL DEFAULT 0,
    educationTypeCode VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(staffMemberId),
    UNIQUE(staffMemberCode)

);
ALTER TABLE opuscollege.staffMember OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.staffMember TO postgres;

-------------------------------------------------------
-- table staffMemberFunction
-------------------------------------------------------
CREATE TABLE opuscollege.staffMemberFunction (
   staffMemberId INTEGER NOT NULL REFERENCES opuscollege.staffMember(staffMemberId) ON DELETE CASCADE ON UPDATE CASCADE,
   functionCode VARCHAR NOT NULL,
   functionLevelCode VARCHAR NOT NULL,
   obsolete CHAR(1) NOT NULL DEFAULT 'N',
   writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
   writeWhen TIMESTAMP NOT NULL DEFAULT now(),
   --
   PRIMARY KEY(staffMemberId,functionCode)
);
ALTER TABLE opuscollege.staffMemberFunction OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.staffMemberFunction TO postgres; 

-------------------------------------------------------
-- table contract
-------------------------------------------------------
CREATE TABLE opuscollege.contract (
	id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.contractSeq'), 
    contractCode VARCHAR NOT NULL, 
    staffMemberId INTEGER NOT NULL REFERENCES opuscollege.staffMember(staffMemberId) ON DELETE CASCADE ON UPDATE CASCADE,
    contractTypeCode VARCHAR NOT NULL,
    contractDurationCode VARCHAR NOT NULL,
    contractStartDate DATE NOT NULL,
    contractEndDate DATE,
    contactHours NUMERIC(10,2) NOT NULL DEFAULT 0,
    fteAppointmentOverall NUMERIC(10,2) NOT NULL,
    fteEducation NUMERIC(10,2) NOT NULL,
    fteResearch NUMERIC(10,2) NOT NULL,
    fteAdministrativeTasks NUMERIC(10,2) NOT NULL,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(contractCode)
);
ALTER TABLE opuscollege.contract OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.contract TO postgres;

-------------------------------------------------------
-- table student
-------------------------------------------------------
CREATE TABLE opuscollege.student (
	studentId INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studentSeq'), 
    studentCode VARCHAR NOT NULL, 
    personId INTEGER NOT NULL REFERENCES opuscollege.person(id) ON DELETE CASCADE ON UPDATE CASCADE,
    dateOfEnrolment DATE DEFAULT now(),
    primaryStudyId INTEGER NOT NULL default 0,
    statusCode VARCHAR,
    expellationDate DATE,
    expellationForFalseCertificates CHAR(1) NOT NULL DEFAULT 'N',
    reasonForExpellation VARCHAR,
    previousInstitutionId INTEGER NOT NULL,
	previousInstitutionName VARCHAR,
    previousInstitutionDistrictCode VARCHAR,
    previousInstitutionProvinceCode VARCHAR,
    previousInstitutionCountryCode VARCHAR,
    previousInstitutionEducationTypeCode VARCHAR,
    previousInstitutionFinalGradeTypeCode VARCHAR,
    previousInstitutionFinalMark VARCHAR,
    previousInstitutionDiplomaPhotograph BYTEA,
    scholarship CHAR(1) NOT NULL DEFAULT 'N',
    fatherFullName VARCHAR,
    fatherEducationCode VARCHAR DEFAULT '0',
    fatherProfessionCode VARCHAR DEFAULT '0',
    fatherProfessionDescription VARCHAR,
    motherFullName VARCHAR,
    motherEducationCode VARCHAR DEFAULT '0',
    motherProfessionCode VARCHAR DEFAULT '0',
    motherProfessionDescription VARCHAR,
    financialGuardianFullName VARCHAR,
    financialGuardianRelation VARCHAR,
    financialGuardianProfession VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(studentId),
    UNIQUE(studentCode)
);
ALTER TABLE opuscollege.student OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.student TO postgres;

-------------------------------------------------------
-- table studentAbsence
-------------------------------------------------------
CREATE TABLE opuscollege.studentAbsence (
	id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studentAbsenceSeq'), 
	studentId INTEGER NOT NULL REFERENCES opuscollege.student(studentId) ON DELETE CASCADE ON UPDATE CASCADE,
    startdateTemporaryInactivity DATE,
    enddateTemporaryInactivity DATE,
    reasonForAbsence VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(startdateTemporaryInactivity,enddateTemporaryInactivity)
);
ALTER TABLE opuscollege.studentAbsence OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.studentAbsence TO postgres;

-------------------------------------------------------
-- TABLE study
-------------------------------------------------------
CREATE TABLE opuscollege.study (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studySeq'), 
    studyDescription VARCHAR,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    organizationalUnitId INTEGER NOT NULL,
    academicFieldCode VARCHAR NOT NULL,
    dateOfEstablishment DATE,
    startDate DATE,
    registrationDate DATE NOT NULL DEFAULT now(),
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.study OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.study TO postgres;

-------------------------------------------------------
-- TABLE address
-------------------------------------------------------
CREATE TABLE opuscollege.address (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.addressSeq'), 
	addressTypeCode VARCHAR NOT NULL,
    personId INTEGER DEFAULT 0,
    studyId INTEGER DEFAULT 0,
    organizationalUnitId INTEGER DEFAULT 0,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
	street VARCHAR,
	number INTEGER NOT NULL DEFAULT 0,
	numberExtension VARCHAR,
	zipCode VARCHAR,
	POBox VARCHAR,
	city VARCHAR,
	administrativePostCode VARCHAR,
	districtCode VARCHAR NOT NULL,
    provinceCode VARCHAR NOT NULL,
    countryCode VARCHAR NOT NULL,
	telephone VARCHAR,
	faxNumber VARCHAR,
	mobilePhone VARCHAR,
	emailAddress VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.address OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.address TO postgres;

-------------------------------------------------------
-- TABLE studyGradeType
-------------------------------------------------------
CREATE TABLE opuscollege.studyGradeType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studyGradeTypeSeq'), 
    studyId INTEGER NOT NULL,
    gradeTypeCode VARCHAR NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    numberOfYears INTEGER NOT NULL DEFAULT 0,
    contactId INTEGER NOT NULL DEFAULT 0,
    registrationDate DATE NOT NULL DEFAULT now(),
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.studyGradeType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.studyGradeType TO postgres;

-------------------------------------------------------
-- TABLE studyYear
-------------------------------------------------------
CREATE TABLE opuscollege.studyYear (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studyYearSeq'), 
    studyGradeTypeId INTEGER NOT NULL,
	yearNumber INTEGER NOT NULL,
	yearNumberVariation VARCHAR NOT NULL,
	courseStructureValidFromYear INTEGER NOT NULL DEFAULT 0,
	courseStructureValidThroughYear INTEGER NOT NULL DEFAULT 0,
    creditAmountOverall INTEGER NOT NULL DEFAULT 0,
    creditAmountPercCompulsory INTEGER NOT NULL DEFAULT 0,
    creditAmountPercCompulsoryFromList INTEGER NOT NULL DEFAULT 0,
    creditAmountPercFreeChoice INTEGER NOT NULL DEFAULT 0,
	studyFormCode VARCHAR,
	studyTimeCode VARCHAR,
	targetGroupCode VARCHAR,
	BRsMaxContactHours VARCHAR,
	BRsPassingStudyYear VARCHAR,
    registrationDate DATE NOT NULL DEFAULT now(),
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.studyYear OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.studyYear TO postgres;

-------------------------------------------------------
-- TABLE subject
-------------------------------------------------------
CREATE TABLE opuscollege.subject (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.subjectSeq'), 
    subjectCode VARCHAR NOT NULL, 
    subjectDescription VARCHAR,
    subjectContentDescription VARCHAR,
    primaryStudyId INTEGER NOT NULL,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
	targetGroupCode VARCHAR,
	rigidityTypeCode VARCHAR,
	subjectImportanceCode VARCHAR,
	freeChoiceOption CHAR(1) DEFAULT 'Y',
	creditAmount INTEGER NOT NULL,
	creditAmountPercTheory INTEGER NOT NULL,
	creditAmountPercPractice INTEGER NOT NULL,
	hoursToInvest INTEGER NOT NULL DEFAULT 0,
	frequencyCode VARCHAR,
	studyFormCode VARCHAR,
	studyTimeCode VARCHAR,
	examTypeCode VARCHAR,
	maximumParticipants INTEGER NOT NULL,
	BRsApplyingToSubject VARCHAR,
	BRsPassingSubject VARCHAR,
    registrationDate DATE NOT NULL DEFAULT now(),
	writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(subjectCode)
);
ALTER TABLE opuscollege.subject OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.subject TO postgres;

-------------------------------------------------------
-- TABLE subjectBlock
-------------------------------------------------------
CREATE TABLE opuscollege.subjectBlock (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.subjectBlockSeq'), 
    subjectBlockCode VARCHAR NOT NULL, 
    subjectBlockDescription VARCHAR,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
	targetGroupCode VARCHAR NOT NULL,
	BRsApplyingToBlock VARCHAR,
    registrationDate DATE NOT NULL DEFAULT now(),
	writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(subjectBlockCode)
);
ALTER TABLE opuscollege.subjectBlock OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.subjectBlock TO postgres;

-------------------------------------------------------
-- table subjectSubjectBlock
-------------------------------------------------------
CREATE TABLE opuscollege.subjectSubjectBlock (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.subjectSubjectBlockSeq'), 
    subjectId INTEGER NOT NULL REFERENCES opuscollege.subject(id) ON DELETE CASCADE ON UPDATE CASCADE,
    subjectBlockId INTEGER REFERENCES opuscollege.subjectBlock(id) ON DELETE CASCADE ON UPDATE CASCADE,
    obsolete CHAR(1) NOT NULL DEFAULT 'N',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(subjectId,subjectBlockId)
);
ALTER TABLE opuscollege.subjectSubjectBlock OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.subjectSubjectBlock TO postgres; 

-------------------------------------------------------
-- table subjectStudyGradeType
-------------------------------------------------------
CREATE TABLE opuscollege.subjectStudyGradeType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.subjectStudyGradeTypeSeq'), 
    subjectId INTEGER NOT NULL REFERENCES opuscollege.subject(id) ON DELETE CASCADE ON UPDATE CASCADE,
    studyGradeTypeId INTEGER,
    obsolete CHAR(1) NOT NULL DEFAULT 'N',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.subjectStudyGradeType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.subjectStudyGradeType TO postgres; 

-------------------------------------------------------
-- table subjectStudyYear
-------------------------------------------------------
CREATE TABLE opuscollege.subjectStudyYear (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.subjectStudyYearSeq'), 
    subjectId INTEGER NOT NULL REFERENCES opuscollege.subject(id) ON DELETE CASCADE ON UPDATE CASCADE,
    studyYearId INTEGER REFERENCES opuscollege.studyYear(id) ON DELETE CASCADE ON UPDATE CASCADE,
	timeUnitCode VARCHAR NOT NULL,
    obsolete CHAR(1) NOT NULL DEFAULT 'N',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(subjectId,studyYearId)
);
ALTER TABLE opuscollege.subjectStudyYear OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.subjectStudyYear TO postgres; 

-------------------------------------------------------
-- table subjectBlockStudyGradeType
-------------------------------------------------------
CREATE TABLE opuscollege.subjectBlockStudyGradeType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.subjectBlockStudyGradeTypeSeq'), 
    subjectBlockId INTEGER NOT NULL REFERENCES opuscollege.subjectBlock(id) ON DELETE CASCADE ON UPDATE CASCADE,
    studyGradeTypeId INTEGER REFERENCES opuscollege.studyGradeType(id) ON DELETE CASCADE ON UPDATE CASCADE,
    obsolete CHAR(1) NOT NULL DEFAULT 'N',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(subjectBlockId,studyGradeTypeId)
);
ALTER TABLE opuscollege.subjectBlockStudyGradeType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.subjectBlockStudyGradeType TO postgres; 

-------------------------------------------------------
-- table subjectBlockStudyYear
-------------------------------------------------------
CREATE TABLE opuscollege.subjectBlockStudyYear (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.subjectBlockStudyYearSeq'), 
    subjectBlockId INTEGER NOT NULL REFERENCES opuscollege.subjectBlock(id) ON DELETE CASCADE ON UPDATE CASCADE,
    studyYearId INTEGER REFERENCES opuscollege.studyYear(id) ON DELETE CASCADE ON UPDATE CASCADE,
	timeUnitCode VARCHAR NOT NULL,
	targetGroupCode VARCHAR NOT NULL,
    obsolete CHAR(1) NOT NULL DEFAULT 'N',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(subjectBlockId,studyYearId)
);
ALTER TABLE opuscollege.subjectBlockStudyYear OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.subjectBlockStudyYear TO postgres; 

-------------------------------------------------------
-- table subjectTeacher
-------------------------------------------------------
CREATE TABLE opuscollege.subjectTeacher (
   id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.subjectTeacherSeq'), 
   staffMemberId INTEGER NOT NULL REFERENCES opuscollege.staffMember(staffMemberId) ON DELETE CASCADE ON UPDATE CASCADE,
   subjectId INTEGER NOT NULL REFERENCES opuscollege.subject(id) ON DELETE CASCADE ON UPDATE CASCADE,
   obsolete CHAR(1) NOT NULL DEFAULT 'N',
   writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
   writeWhen TIMESTAMP NOT NULL DEFAULT now(),
   --
   PRIMARY KEY(id),
   UNIQUE(staffMemberId,subjectId)
);
ALTER TABLE opuscollege.subjectTeacher OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.subjectTeacher TO postgres; 

-------------------------------------------------------
-- table subjectStudyType
-------------------------------------------------------
CREATE TABLE opuscollege.subjectStudyType (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.subjectStudyTypeSeq'), 
    subjectId INTEGER NOT NULL REFERENCES opuscollege.subject(id) ON DELETE CASCADE ON UPDATE CASCADE,
    studyTypeCode VARCHAR NOT NULL,
    obsolete CHAR(1) NOT NULL DEFAULT 'N',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(subjectId,studyTypeCode)
);
ALTER TABLE opuscollege.subjectStudyType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.subjectStudyType TO postgres; 

-------------------------------------------------------
-- TABLE studyPlan
-------------------------------------------------------
CREATE TABLE opuscollege.studyPlan (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studyPlanSeq'), 
    studentId INTEGER NOT NULL,
    studyGradeTypeId INTEGER NOT NULL,
    studyPlanDescription VARCHAR,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.studyPlan OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.studyPlan TO postgres;

-------------------------------------------------------
-- TABLE studyPlanDetail
-------------------------------------------------------
CREATE TABLE opuscollege.studyPlanDetail (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studyPlanDetailSeq'), 
    studyPlanId INTEGER NOT NULL,
    subjectId INTEGER NOT NULL DEFAULT 0,
    subjectBlockId INTEGER NOT NULL DEFAULT 0,
    studyYearId INTEGER NOT NULL DEFAULT 0,
	obsolete CHAR(1) NOT NULL DEFAULT 'N',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.studyPlanDetail OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.studyPlanDetail TO postgres;

-------------------------------------------------------
-- TABLE examination
-------------------------------------------------------
CREATE TABLE opuscollege.examination (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.examinationSeq'), 
    examinationCode VARCHAR NOT NULL, 
    examinationDescription VARCHAR,
    subjectId INTEGER NOT NULL,
	examinationTypeCode VARCHAR NOT NULL,
	numberOfAttempts INTEGER NOT NULL,
	weighingFactor INTEGER NOT NULL,
	minimumMark VARCHAR,
	maximumMark VARCHAR,
	BRsPassingExamination VARCHAR,
 	obsolete CHAR(1) NOT NULL DEFAULT 'N',
	writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.examination OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.examination TO postgres;

-------------------------------------------------------
-- table examinationTeacher
-------------------------------------------------------
CREATE TABLE opuscollege.examinationTeacher (
   id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.examinationTeacherSeq'), 
   staffMemberId INTEGER NOT NULL REFERENCES opuscollege.staffMember(staffMemberId) ON DELETE CASCADE ON UPDATE CASCADE,
   examinationId INTEGER NOT NULL REFERENCES opuscollege.examination(id) ON DELETE CASCADE ON UPDATE CASCADE,
   obsolete CHAR(1) NOT NULL DEFAULT 'N',
   writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
   writeWhen TIMESTAMP NOT NULL DEFAULT now(),
   --
   PRIMARY KEY(id),
   UNIQUE(staffMemberId,examinationId)
);
ALTER TABLE opuscollege.examinationTeacher OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.examinationTeacher TO postgres; 

-------------------------------------------------------
-- TABLE examinationResult
-------------------------------------------------------
CREATE TABLE opuscollege.examinationResult (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.examinationResultSeq'), 
    examinationId INTEGER NOT NULL REFERENCES opuscollege.examination(id) ON DELETE CASCADE ON UPDATE CASCADE,
    subjectId INTEGER NOT NULL REFERENCES opuscollege.subject(id) ON DELETE CASCADE ON UPDATE CASCADE,
    studyPlanDetailId INTEGER NOT NULL REFERENCES opuscollege.studyPlanDetail(id) ON DELETE CASCADE ON UPDATE CASCADE,
	examinationResultDate DATE,
	attemptNr INTEGER NOT NULL,
	finalAttempt CHAR(1) NOT NULL DEFAULT 'N',
	mark VARCHAR,
    staffMemberId INTEGER NOT NULL REFERENCES opuscollege.staffMember(staffMemberId) ON DELETE CASCADE ON UPDATE CASCADE,
	BRsPassingExamination VARCHAR,
 	obsolete CHAR(1) NOT NULL DEFAULT 'N',
	writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(examinationId,subjectId,studyPlanDetailId)
);
ALTER TABLE opuscollege.examinationResult OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.examinationResult TO postgres;

-------------------------------------------------------
-- TABLE subjectResult
-------------------------------------------------------
CREATE TABLE opuscollege.subjectResult (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.subjectResultSeq'), 
    subjectId INTEGER NOT NULL REFERENCES opuscollege.subject(id) ON DELETE CASCADE ON UPDATE CASCADE,
    studyPlanDetailId INTEGER NOT NULL REFERENCES opuscollege.studyPlanDetail(id) ON DELETE CASCADE ON UPDATE CASCADE,
	subjectResultDate DATE,
	attemptNr INTEGER NOT NULL,
	finalAttempt CHAR(1) NOT NULL DEFAULT 'N',
	mark VARCHAR,
    staffMemberId INTEGER NOT NULL REFERENCES opuscollege.staffMember(staffMemberId) ON DELETE CASCADE ON UPDATE CASCADE,
	BRsPassingSubject VARCHAR,
 	obsolete CHAR(1) NOT NULL DEFAULT 'N',
	writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(subjectId,studyPlanDetailId)
);
ALTER TABLE opuscollege.subjectResult OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.subjectResult TO postgres;

-------------------------------------------------------
-- TABLE exam
-------------------------------------------------------
CREATE TABLE opuscollege.exam (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.examSeq'), 
    studyPlanId INTEGER NOT NULL REFERENCES opuscollege.studyPlan(id) ON DELETE CASCADE ON UPDATE CASCADE,
	examDate DATE,
	finalMark CHAR(1) NOT NULL DEFAULT 'N',
	mark VARCHAR,
	BRsPassingExam VARCHAR,
 	obsolete CHAR(1) NOT NULL DEFAULT 'N',
	writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(studyPlanId)
);
ALTER TABLE opuscollege.exam OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.exam TO postgres;

-------------------------------------------------------
-- TABLE node_relationships_n_level
-------------------------------------------------------

CREATE TABLE opuscollege.node_relationships_n_level (
  "level" integer
)
INHERITS (opuscollege.organizationalunit)
WITH (OIDS=FALSE);
ALTER TABLE opuscollege.node_relationships_n_level OWNER TO postgres;

 