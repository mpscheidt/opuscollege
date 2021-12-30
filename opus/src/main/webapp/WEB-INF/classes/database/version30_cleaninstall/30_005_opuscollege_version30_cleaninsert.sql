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

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.0);

-------------------------------------------------------
-- Restore user-errors on start-up
-------------------------------------------------------
ALTER TABLE opuscollege.subjectImportance OWNER TO postgres;
ALTER FUNCTION opuscollege.rename_col_obsolete_to_active() OWNER TO postgres;

-------------------------------------------------------
-- Domain tables
-------------------------------------------------------

-------------------------------------------------------
-- table role
-------------------------------------------------------
DELETE FROM opuscollege.opusUserRole;
DELETE FROM opuscollege.role;

-- EN
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('en','admin', 'system administrator');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('en','admin-C', 'central administrator institution');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('en','admin-B', 'central administrator branch');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('en','admin-D', 'decentral administrator');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('en','staff', 'staff member');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('en','teacher', 'teacher');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('en','student', 'student');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('en','guest', 'system guest');
-- PT
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('pt','admin', 'administrador de sistema');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('pt','admin-C', 'administrador central avaliação institucional');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('pt','admin-B', 'central administrator avaliação das delegações');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('pt','admin-D', 'administrador decentral');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('pt','staff', 'funcionário');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('pt','teacher', 'professor');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('pt','student', 'estudante');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('pt','guest', 'visitante de sistema');
-- NL
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','admin', 'systeem beheerder');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','admin-C', 'centrale beheerder institutuut');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','admin-B', 'centrale beheerder vestiging');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','admin-D', 'decentrale beheerder');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','staff', 'medewerker');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','teacher', 'docent');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','student', 'student');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','guest', 'gast');

-------------------------------------------------------
-- table person
-------------------------------------------------------
DELETE FROM opuscollege.person;

INSERT INTO opuscollege.person
    (personCode,surNameFull, 
    firstNamesFull,firstNamesAlias,birthDate) 
VALUES ('1','MEC','Administrator','AMS'
        ,'1960-01-01');

INSERT INTO opuscollege.person
(personCode,surNameFull, 
firstNamesFull,firstNamesAlias,birthDate) 
            VALUES ('2','Student',
            'Sample Student','SaS',
            '2005-05-16');

INSERT INTO opuscollege.person
    (personCode,surNameFull, 
    firstNamesFull,firstNamesAlias,birthDate) 
VALUES ('3','MECAdmin','Administrator','AMS'
        ,'1960-01-01');

INSERT INTO opuscollege.person
    (personCode,surNameFull, 
    firstNamesFull,firstNamesAlias,birthDate) 
VALUES ('XPX','DEMO','Administrator','DEMO'
        ,'1960-01-01');

-------------------------------------------------------
-- table opusUser
-------------------------------------------------------
DELETE FROM opuscollege.opusUser;

INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '1'),'MEC', 'e9e14c66502be9d6cbad2be3aa48041e');
INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '2'),'student', 'cd73502828457d15655bbd7a63fb0bc8');
INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = '3'),'MECAdmin', '6c4f158d214fab78e77b36922dad2ba3');
INSERT INTO opuscollege.opusUser (personId,userName,pw) VALUES((select id from opuscollege.person where personCode = 'XPX'),'DEMO', '962d89c410bc4623b8d2670d2d975405');

-------------------------------------------------------
-- table opusUserRole
-------------------------------------------------------
DELETE FROM opuscollege.opusUserRole;

INSERT INTO opuscollege.opusUserRole (lang,userName,role) VALUES ('en','MEC', 'admin');
INSERT INTO opuscollege.opusUserRole (lang,username,role) VALUES ('en','student', 'student');
INSERT INTO opuscollege.opusUserRole (lang,userName,role) VALUES ('en','MECAdmin', 'admin-C');
INSERT INTO opuscollege.opusUserRole (lang,userName,role) VALUES ('en','DEMO', 'admin-B');

-------------------------------------------------------
-- table institution
-------------------------------------------------------
DELETE FROM opuscollege.institution;

INSERT INTO opuscollege.institution(educationTypeCode,provinceCode ,institutionCode,institutionDescription,rector) VALUES ('3','05','UNIV00','MEC', NULL);

-------------------------------------------------------
-- table branch
-------------------------------------------------------
DELETE FROM opuscollege.branch;

INSERT INTO opuscollege.branch (branchCode,institutionId,branchDescription) VALUES ('01',(SELECT id from opuscollege.institution where institutionCode='UNIV00'),'MEC Branch');

-------------------------------------------------------
-- table organizationalUnit
-------------------------------------------------------
DELETE FROM opuscollege.organizationalUnit;

INSERT INTO opuscollege.organizationalUnit (organizationalUnitCode,organizationalUnitDescription,
branchId,unitLevel,unitAreaCode,unitTypeCode,academicFieldCode,directorId) 
VALUES 
('MECBRANCH1UNIT1','MEC-unit1',(SELECT id FROM opuscollege.branch WHERE branchDescription = 'MEC Branch'),
1,'1','1','1',(select id from opuscollege.person where personCode = '1'));

-------------------------------------------------------
-- table staffMember
-------------------------------------------------------
DELETE FROM opuscollege.staffMember;

INSERT INTO opuscollege.staffMember
    (staffMemberCode, 
    personId,
    dateOfAppointment,
    appointmentTypeCode,
    staffTypeCode,
    primaryUnitOfAppointmentId,
    educationTypeCode)
    VALUES('1',(select id from opuscollege.person where surNameFull = 'MEC'),'2005-01-01','1','1',
    (select id from opuscollege.organizationalunit where organizationalUnitCode = 'MECBRANCH1UNIT1'),'3');

INSERT INTO opuscollege.staffMember
    (staffMemberCode, 
    personId,
    primaryUnitOfAppointmentId)
    VALUES('2',
    (select id from opuscollege.person where surNameFull = 'MECAdmin'),
    (select id from opuscollege.organizationalunit where organizationalUnitCode = 'MECBRANCH1UNIT1')
    );

    INSERT INTO opuscollege.staffMember
    (staffMemberCode, 
    personId,
    primaryUnitOfAppointmentId)
    VALUES('XSX',
    (select id from opuscollege.person where surNameFull = 'DEMO'),
    (select id from opuscollege.organizationalunit where organizationalUnitCode = 'MECBRANCH1UNIT1')
    );

-------------------------------------------------------
-- table staffMemberFunction
-------------------------------------------------------
DELETE FROM opuscollege.staffMemberFunction;

-------------------------------------------------------
-- table contract
-------------------------------------------------------
DELETE FROM opuscollege.contract;

INSERT INTO opuscollege.contract
    (contractCode,
    staffMemberId, 
    contractTypeCode,
    contractDurationCode,
    contractStartDate,
    contractEndDate,
    contactHours,
    fteAppointmentOverall,
    fteEducation,
    fteResearch,
    fteAdministrativeTasks)
    VALUES('1',(select staffMemberId from opuscollege.staffMember where staffMemberCode = '1'),'2','1','2005-01-01','2008-05-01',10.5,80,40,30,0);

INSERT INTO opuscollege.contract
    (contractCode,
    staffMemberId, 
    contractTypeCode,
    contractDurationCode,
    contractStartDate,
    contractEndDate,
    contactHours,
    fteAppointmentOverall,
    fteEducation,
    fteResearch,
    fteAdministrativeTasks)
    VALUES('2',(select staffMemberId from opuscollege.staffMember where staffMemberCode = '1'),'1','2','2007-01-01','2009-01-01',36,90,40,30,20);

-------------------------------------------------------
-- TABLE study
-------------------------------------------------------
DELETE FROM opuscollege.study;
    
    INSERT INTO opuscollege.study (
    studyDescription,
    organizationalUnitId,
    academicFieldCode,
    dateOfEstablishment
 ) VALUES ('Biofisica',(select id from opuscollege.organizationalUnit where organizationalUnitCode = 'MECBRANCH1UNIT1'),'1','2003-08-01');

 -------------------------------------------------------
-- table student
-------------------------------------------------------
DELETE FROM opuscollege.student;

INSERT INTO opuscollege.student
    (studentCode, 
    personId,
    dateOfEnrolment ,
    primaryStudyId ,
    statusCode,
    previousInstitutionId,
    previousInstitutionName ,
    previousInstitutionDistrictCode ,
    previousInstitutionProvinceCode ,
    previousInstitutionCountryCode ,
    previousInstitutionEducationTypeCode ,
    previousInstitutionFinalGradeTypeCode, 
    previousInstitutionFinalMark,
    previousInstitutionDiplomaPhotograph,
    scholarship,
    fatherFullName,
    fatherEducationCode,
    fatherProfessionCode,
    motherFullName,
    motherEducationCode,
    motherProfessionCode,
    financialGuardianFullName,
    financialGuardianRelation,
    financialGuardianProfession
    )
    VALUES('1XX',(select id from opuscollege.person where personCode = '2'),'2005-01-01',(select id from opuscollege.study where studyDescription = 'Biofisica'),'1',1,
    'Escola Secunádria Januario Pedro','03-002','03','008','2','1','8PLUS', NULL,
    'Y','Some Father','3','1','Some Mother', '2','2','Some Guardian','3','4');

-------------------------------------------------------
-- table studentAbsence
-------------------------------------------------------
DELETE FROM opuscollege.studentAbsence;

-------------------------------------------------------
-- TABLE address
-------------------------------------------------------
DELETE FROM opuscollege.address;

INSERT INTO opuscollege.address
    (
    addressTypeCode,
    personId, 
    studyId,
    organizationalUnitId,
    street ,
    number,
    numberExtension,
    zipCode,
    city,
    administrativePostCode,
    districtCode,
    provinceCode,
    countryCode,
    telephone ,
    faxNumber,
    mobilePhone ,
    emailAddress)
    VALUES(
    '1',(select id from opuscollege.person where personCode = '1'),0,0,'main street',16,'','HB11100','Nijmegen','1','1','1','2','018-222333',NULL,
    '06-33322111','info@testmail.com');

-------------------------------------------------------
-- TABLE studyGradeType
-------------------------------------------------------
DELETE FROM opuscollege.studyGradeType;

-------------------------------------------------------
-- TABLE studyYear
-------------------------------------------------------
DELETE FROM opuscollege.studyYear;

-------------------------------------------------------
-- TABLE subject
-------------------------------------------------------
DELETE FROM opuscollege.subject;

-------------------------------------------------------
-- table subjectStudyGradeType
-------------------------------------------------------
DELETE FROM opuscollege.subjectStudyGradeType;

-------------------------------------------------------
-- table subjectStudyYear
-------------------------------------------------------
DELETE FROM opuscollege.subjectStudyYear;

-------------------------------------------------------
-- table subjectStudyType
-------------------------------------------------------
DELETE FROM opuscollege.subjectStudyType;

-------------------------------------------------------
-- TABLE subjectSubjectBlock
-------------------------------------------------------
DELETE FROM opuscollege.subjectSubjectBlock;

-------------------------------------------------------
-- TABLE subjectBlock
-------------------------------------------------------
DELETE FROM opuscollege.subjectBlock;

-------------------------------------------------------
-- table subjectBlockStudyGradeType
-------------------------------------------------------
DELETE FROM opuscollege.subjectBlockStudyGradeType;

-------------------------------------------------------
-- table subjectBlockStudyYear
-------------------------------------------------------
DELETE FROM opuscollege.subjectBlockStudyYear;

-------------------------------------------------------
-- table subjectStudyYear
-------------------------------------------------------
DELETE FROM opuscollege.subjectStudyYear;

-------------------------------------------------------
-- table subjectTeacher
-------------------------------------------------------
DELETE FROM opuscollege.subjectTeacher;

-------------------------------------------------------
-- table subjectBlockStudyYear
-------------------------------------------------------
DELETE FROM opuscollege.subjectBlockStudyYear;

-------------------------------------------------------
-- table subjectStudyType
-------------------------------------------------------
DELETE FROM opuscollege.subjectStudyType;

-------------------------------------------------------
-- table subjectResult
-------------------------------------------------------
DELETE FROM opuscollege.subjectResult;

-------------------------------------------------------
-- TABLE studyPlan
-------------------------------------------------------
DELETE FROM opuscollege.studyPlan;

-------------------------------------------------------
-- TABLE studyPlanDetail
-------------------------------------------------------
DELETE FROM opuscollege.studyPlanDetail;
    
-------------------------------------------------------
-- TABLE exam
-------------------------------------------------------
DELETE FROM opuscollege.exam;

-------------------------------------------------------
-- TABLE examination
-------------------------------------------------------
DELETE FROM opuscollege.examination;

-------------------------------------------------------
-- TABLE examinationResult
-------------------------------------------------------
DELETE FROM opuscollege.examinationResult;

-------------------------------------------------------
-- TABLE examinationTeacher
-------------------------------------------------------
DELETE FROM opuscollege.examinationTeacher;

-------------------------------------------------------
-- TABLE test
-------------------------------------------------------
DELETE FROM opuscollege.test;

-------------------------------------------------------
-- TABLE testResult
-------------------------------------------------------
DELETE FROM opuscollege.testResult;

-------------------------------------------------------
-- TABLE testTeacher
-------------------------------------------------------
DELETE FROM opuscollege.testTeacher;


-------------------------------------------------------
-- Lookup tables
-------------------------------------------------------

-------------------------------------------------------
-- TABLE administrativePost
-------------------------------------------------------
DELETE FROM opuscollege.administrativePost;

-------------------------------------------------------
-- TABLE district
-------------------------------------------------------
DELETE FROM opuscollege.district;

-------------------------------------------------------
-- TABLE province
-------------------------------------------------------
DELETE FROM opuscollege.province;


-------------------------------------------------------
-- Functions
-------------------------------------------------------

-------------------------------------------------------
-- FUNCTION crawl_tree(integer, integer)
-------------------------------------------------------

CREATE OR REPLACE FUNCTION opuscollege.crawl_tree(integer, integer)
  RETURNS SETOF opuscollege.node_relationships_n_level AS
$BODY$DECLARE
temp RECORD;
child RECORD;
BEGIN
  SELECT INTO temp *, $2 AS level FROM opuscollege.organizationalunit WHERE
id = $1;

  IF FOUND THEN
    RETURN NEXT temp;
      FOR child IN SELECT id FROM opuscollege.organizationalunit WHERE
parentorganizationalunitid = $1 ORDER BY unitlevel LOOP
        FOR temp IN SELECT * FROM opuscollege.crawl_tree(child.id, $2 +
1) LOOP
            RETURN NEXT temp;
        END LOOP;
      END LOOP;
   END IF;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION opuscollege.crawl_tree(integer, integer) OWNER TO postgres;

-------------------------------------------------------
-- FUNCTION remove_diacritics(string)
-------------------------------------------------------

CREATE OR REPLACE FUNCTION opuscollege.remove_diacritics(p_string character varying)
  RETURNS character varying AS
$BODY$
DECLARE
  v_string varchar(1000);

BEGIN
  v_string := lower( p_string );

  v_string := replace( v_string, 'à', 'a');
  v_string := replace( v_string, 'á', 'a');
  v_string := replace( v_string, 'â', 'a');
  v_string := replace( v_string, 'ã', 'a');
  v_string := replace( v_string, 'ä', 'a');
  v_string := replace( v_string, 'å', 'a');
  v_string := replace( v_string, 'æ', 'a');

  v_string := replace( v_string, 'ç', 'c');

  v_string := replace( v_string, 'è', 'e');
  v_string := replace( v_string, 'é', 'e');
  v_string := replace( v_string, 'ê', 'e');
  v_string := replace( v_string, 'ë', 'e');

  v_string := replace( v_string, 'ì', 'i');
  v_string := replace( v_string, 'í', 'i');
  v_string := replace( v_string, 'î', 'i');
  v_string := replace( v_string, 'ï', 'i');

  v_string := replace( v_string, 'ñ', 'n');

  v_string := replace( v_string, 'ò', 'o');
  v_string := replace( v_string, 'ó', 'o');
  v_string := replace( v_string, 'ô', 'o');
  v_string := replace( v_string, 'õ', 'o');
  v_string := replace( v_string, 'ö', 'o');
  v_string := replace( v_string, 'ø', 'o');

  v_string := replace( v_string, 'ù', 'u');
  v_string := replace( v_string, 'ú', 'u');
  v_string := replace( v_string, 'û', 'u');
  v_string := replace( v_string, 'ü', 'u');

  v_string := replace( v_string, 'ý', 'y');
  v_string := replace( v_string, 'ÿ', 'y');

  return v_string;

EXCEPTION
  when others then
     return p_string;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION opuscollege.remove_diacritics(p_string character varying) OWNER TO postgres;



-------------------------------------------------------
-- table student
-------------------------------------------------------
ALTER table opuscollege.student ADD column secondaryStudyId INTEGER NOT NULL default 0;

-------------------------------------------------------
-- table person
-------------------------------------------------------
ALTER table opuscollege.person ADD column publicHomePage CHAR(1) NOT NULL DEFAULT 'N';
ALTER table opuscollege.person ADD column socialNetworks VARCHAR;
ALTER table opuscollege.person ADD column hobbies VARCHAR;

-------------------------------------------------------
-- table status
-------------------------------------------------------
INSERT INTO opuscollege.status (lang,code,description) VALUES ('en','10','initial application');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('en','11','approved registration');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('en','12','actively registered');

INSERT INTO opuscollege.status (lang,code,description) VALUES ('pt','10','initial application');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('pt','11','approved registration');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('pt','12','actively registered');

INSERT INTO opuscollege.status (lang,code,description) VALUES ('nl','10','initiele aanmelding');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('nl','11','goedgekeurde registratie');
INSERT INTO opuscollege.status (lang,code,description) VALUES ('nl','12','actief geregistreerd');
