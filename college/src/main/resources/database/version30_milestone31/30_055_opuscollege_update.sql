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

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.11);

-------------------------------------------------------
-- table opusPrivilege
-------------------------------------------------------

-- MOVED TO domain inserts per country
--INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('3', 'en', 'Editability of student data: all');
--INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('4', 'en', 'Editability of student data: personal data');

--INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('3', 'nl', 'Editability van studentendata: alles');
--INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('4', 'nl', 'Editability van studentendata: persoonlijke data');

--INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('3', 'pt', 'Editability of student data: all');
--INSERT INTO opuscollege.opusPrivilege(code, lang, description) VALUES('4', 'pt', 'Editability of student data: personal data');

DROP SEQUENCE IF EXISTS opuscollege.htmlFieldSeq CASCADE;
CREATE SEQUENCE opuscollege.htmlFieldSeq;
ALTER TABLE opuscollege.htmlFieldSeq OWNER TO postgres;

-------------------------------------------------------
-- table htmlField
-------------------------------------------------------
CREATE TABLE opuscollege.htmlField (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.htmlFieldSeq'),
    htmlFieldId VARCHAR NOT NULL,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(id),
    UNIQUE(htmlFieldId)
);
ALTER TABLE opuscollege.htmlField OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.htmlField TO postgres;

-- MOVED TO domain inserts per country
-- TAB PERSONAL DATA
-- accordion details
/*INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('institutionId');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('branchId');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('organizationalUnitId');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('primaryStudyId');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('secondaryStudyId');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('foreignStudent');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('studentCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('surnameFull');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('firstnamesFull');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('firstnamesAlias');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('nationalRegistrationNumber');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('civilTitleCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('gradeTypeCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('genderCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('birthdate');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('civilStatusCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('housingOnCampus');
-- accordion background
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('nationalityCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('countryOfBirthCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('provinceOfBirthCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('districtOfBirthCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('placeOfBirth');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('countryOfOriginCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('provinceOfOriginCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('districtOfOriginCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('cityOfOrigin');
-- accordion identification
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('identificationTypeCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('identificationNumber');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('identificationPlaceOfIssue');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('identificationDateOfIssue');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('identificationDateOfExpiration');
-- accordion miscellaneous
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('professionDescription');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('languageFirstCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('languageFirstMasteringLevelCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('languageSecondCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('languageSecondMasteringLevelCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('languageThirdCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('languageThirdMasteringLevelCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('contactPersonEmergenciesName');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('contactPersonEmergenciesTelephoneNumber');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('bloodTypeCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('healthIssues');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('active');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('publicHomepage');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('socialNetworks');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('hobbies');
-- accordions photograph and remarks
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('hasPhoto');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('remarks');
-- accordion family
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('fatherFullName');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('fatherEducationCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('fatherProfessionDescription');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('motherFullName');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('motherEducationCode');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('motherProfessionDescription');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('financialGuardianFullName');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('financialGuardianRelation');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('financialGuardianProfession');
-- tab opususer data
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('opusUserRole_username');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('opusUserRole_role');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('opusUser_lang');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('opusUser_pw');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('opusUserRoles');

INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('addresses');
*/

/*

INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('');
INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('');

INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', '', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', '', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', '', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', '', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', '', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', '', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', '', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', '', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', '', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', '', 'E');

INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', '', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', '', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', '', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', '', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', '', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', '', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', '', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', '', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', '', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', '', 'V');
*/

-------------------------------------------------------
-- table htmlFieldPrivilege
-------------------------------------------------------
CREATE TABLE opuscollege.htmlFieldPrivilege (
    opusPrivilegeCode VARCHAR NOT NULL,
    htmlFieldId  VARCHAR NOT NULL,
    authorisationCode VARCHAR NOT NULL,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(opusPrivilegeCode, htmlFieldId)
);
ALTER TABLE opuscollege.htmlFieldPrivilege OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.htmlFieldPrivilege TO postgres;

-- MOVED TO domain inserts per country
/*
-- INSERT FOR PRIVILEGE "EDIT ALL"
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'addresses', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'addresses', 'V');


-- accordion details
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'institutionId', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'branchId', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'organizationalUnitId', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'primaryStudyId', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'secondaryStudyId', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'foreignStudent', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'studentCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'surnameFull', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'firstnamesFull', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'firstnamesAlias', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'nationalRegistrationNumber', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'civilTitleCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'gradeTypeCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'genderCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'birthdate', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'civilStatusCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'housingOnCampus', 'E');
-- accordion background
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'nationalityCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'countryOfBirthCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'provinceOfBirthCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'districtOfBirthCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'placeOfBirth', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'countryOfOriginCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'provinceOfOriginCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'districtOfOriginCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'cityOfOrigin', 'E');
-- accordion identification
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'identificationTypeCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'identificationNumber', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'identificationPlaceOfIssue', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'identificationDateOfIssue', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'identificationDateOfExpiration', 'E');
-- accordion miscellaneous
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'professionDescription', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'languageFirstCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'languageFirstMasteringLevelCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'languageSecondCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'languageSecondMasteringLevelCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'languageThirdCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'languageThirdMasteringLevelCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'contactPersonEmergenciesName', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'contactPersonEmergenciesTelephoneNumber', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'bloodTypeCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'healthIssues', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'active', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'publicHomepage', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'socialNetworks', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'hobbies', 'E');
-- accordions photograph and remarks
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'hasPhoto', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'remarks', 'E');
-- accordion family
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'fatherFullName', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'fatherEducationCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'fatherProfessionDescription', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'motherFullName', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'motherEducationCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'motherProfessionDescription', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'financialGuardianFullName', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'financialGuardianRelation', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'financialGuardianProfession', 'E');
-- tab opususer data
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'opusUserRole_username', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'opusUserRole_role', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'opusUser_lang', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'opusUser_pw', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('3', 'opusUserRoles', 'E');


-- INSERT FOR PRIVILEGE "EDIT PERSONAL DATA"
-- accordion details
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'institutionId', 'H');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'branchId', 'H');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'organizationalUnitId', 'H');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'primaryStudyId', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'secondaryStudyId', 'H');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'foreignStudent', 'H');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'studentCode', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'surnameFull', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'firstnamesFull', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'firstnamesAlias', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'nationalRegistrationNumber', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'civilTitleCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'gradeTypeCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'genderCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'birthdate', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'civilStatusCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'housingOnCampus', 'E');
-- accordion background
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'nationalityCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'countryOfBirthCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'provinceOfBirthCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'districtOfBirthCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'placeOfBirth', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'countryOfOriginCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'provinceOfOriginCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'districtOfOriginCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'cityOfOrigin', 'E');
-- accordion identification
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'identificationTypeCode', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'identificationNumber', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'identificationPlaceOfIssue', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'identificationDateOfIssue', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'identificationDateOfExpiration', 'V');
-- accordion miscellaneous
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'professionDescription', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'languageFirstCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'languageFirstMasteringLevelCode', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'languageSecondCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'languageSecondMasteringLevelCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'languageThirdCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'languageThirdMasteringLevelCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'contactPersonEmergenciesName', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'contactPersonEmergenciesTelephoneNumber', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'bloodTypeCode', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'healthIssues', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'active', 'V');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'publicHomepage', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'socialNetworks', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'hobbies', 'E');
-- accordions photograph and remarks
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'hasPhoto', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'remarks', 'V');
-- accordion family
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'fatherFullName', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'fatherEducationCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'fatherProfessionDescription', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'motherFullName', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'motherEducationCode', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'motherProfessionDescription', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'financialGuardianFullName', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'financialGuardianRelation', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'financialGuardianProfession', 'E');
-- tab opususer data
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'opusUserRole_username', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'opusUserRole_role', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'opusUser_lang', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'opusUser_pw', 'E');
INSERT INTO opuscollege.htmlFieldPrivilege(opusPrivilegeCode, htmlFieldId, authorisationCode) VALUES('4', 'opusUserRoles', 'V');
*/

-------------------------------------------------------
-- table authorisation
-------------------------------------------------------
CREATE TABLE opuscollege.authorisation (
    code  VARCHAR NOT NULL,
    description VARCHAR NOT NULL,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(code)
);
ALTER TABLE opuscollege.authorisation OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.authorisation TO postgres;

-- MOVED TO domain inserts per country
--INSERT INTO opuscollege.authorisation(code, description) VALUES('E', 'editable');
--INSERT INTO opuscollege.authorisation(code, description) VALUES('V', 'visible');
--INSERT INTO opuscollege.authorisation(code, description) VALUES('H', 'hidden');

