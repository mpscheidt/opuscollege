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
 * The Original Code is Opus-College mozambique module code.
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
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'mozambique';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('mozambique','A','Y',3.01);

-------------------------------------------------------
-- DOMAIN TABLE role
-------------------------------------------------------
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

-------------------------------------------------------
-- DOMAIN TABLE htmlField
-------------------------------------------------------
DELETE FROM opuscollege.htmlField;

INSERT INTO opuscollege.htmlField(htmlFieldId) VALUES('institutionId');
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
*/

-------------------------------------------------------
-- DOMAIN TABLE htmlFieldPrivilege
-------------------------------------------------------
/*
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

DELETE FROM opuscollege.htmlFieldPrivilege;

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

-------------------------------------------------------
-- table authorisation
-------------------------------------------------------
DELETE FROM opuscollege.authorisation;

INSERT INTO opuscollege.authorisation(code, description) VALUES('E', 'editable');
INSERT INTO opuscollege.authorisation(code, description) VALUES('V', 'visible');
INSERT INTO opuscollege.authorisation(code, description) VALUES('H', 'hidden');

-------------------------------------------------------
-- DOMAIN TABLE endGrade
-------------------------------------------------------
DELETE FROM opuscollege.endGrade;
-- EN
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','26', '',26, 0.0, 0.0, '26','26','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','25', '',25, 0.0, 0.0, '25','25','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','24', '',24, 0.0, 0.0, '24','24','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','23', '',23, 0.0, 0.0, '23','23','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','22', '',22, 0.0, 0.0, '22','22','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','21', '',21, 0.0, 0.0, '21','21','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','20', '',20, 0.0, 0.0, '20','20','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','19', '',19, 0.0, 0.0, '19','19','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','18', '',18, 0.0, 0.0, '18','18','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','17', '',17, 0.0, 0.0, '17','17','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','16', '',16, 0.0, 0.0, '16','16','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','15', '',15, 0.0, 0.0, '15','15','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','14', '',14, 0.0, 0.0, '14','14','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','13', '',13, 0.0, 0.0, '13','13','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','12', '',12, 0.0, 0.0, '12','12','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','11', '',11, 0.0, 0.0, '11','11','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','10', '',10, 0.0, 0.0, '10','10','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','09', '',9, 0.0, 0.0, '9','9','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','08', '',8, 0.0, 0.0, '8','8','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','07', '',7, 0.0, 0.0, '7','7','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','06', '',6, 0.0, 0.0, '6','6','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','05', '',5, 0.0, 0.0, '5','5','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','04', '',4, 0.0, 0.0, '4','4','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','03', '',3, 0.0, 0.0, '3','3','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','02', '',2, 0.0, 0.0, '2','2','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('en','01', '',1, 0.0, 0.0, '1','1','N');

-- PT
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','26', '',26, 0.0, 0.0, '26','26','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','25', '',25, 0.0, 0.0, '25','25','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','24', '',24, 0.0, 0.0, '24','24','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','23', '',23, 0.0, 0.0, '23','23','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','22', '',22, 0.0, 0.0, '22','22','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','21', '',21, 0.0, 0.0, '21','21','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','20', '',20, 0.0, 0.0, '20','20','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','19', '',19, 0.0, 0.0, '19','19','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','18', '',18, 0.0, 0.0, '18','18','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','17', '',17, 0.0, 0.0, '17','17','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','16', '',16, 0.0, 0.0, '16','16','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','15', '',15, 0.0, 0.0, '15','15','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','14', '',14, 0.0, 0.0, '14','14','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','13', '',13, 0.0, 0.0, '13','13','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','12', '',12, 0.0, 0.0, '12','12','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','11', '',11, 0.0, 0.0, '11','11','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','10', '',10, 0.0, 0.0, '10','10','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','09', '',9, 0.0, 0.0, '9','9','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','08', '',8, 0.0, 0.0, '8','8','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','07', '',7, 0.0, 0.0, '7','7','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','06', '',6, 0.0, 0.0, '6','6','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','05', '',5, 0.0, 0.0, '5','5','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','04', '',4, 0.0, 0.0, '4','4','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','03', '',3, 0.0, 0.0, '3','3','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','02', '',2, 0.0, 0.0, '2','2','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES('pt','01', '',1, 0.0, 0.0, '1','1','N');

-------------------------------------------------------
-- DOMAIN TABLE endGradeGeneral (applicable for all endgradetypes)
-------------------------------------------------------
DELETE FROM opuscollege.endGradeGeneral;

-- EN
INSERT INTO opuscollege.endGradeGeneral (lang,code,comment,description,temporaryGrade) VALUES ('en','WP','Withdrawn from course with permission','','N');
INSERT INTO opuscollege.endGradeGeneral (lang,code,comment,description,temporaryGrade) VALUES ('en','DC','Deceased during course','','N');
-- PT
INSERT INTO opuscollege.endGradeGeneral (lang,code,comment,description,temporaryGrade) VALUES ('pt','WP','Withdrawn from course with permission','','N');
INSERT INTO opuscollege.endGradeGeneral (lang,code,comment,description,temporaryGrade) VALUES ('pt','DC','Deceased during course','','N');

-------------------------------------------------------
-- DOMAIN TABLE failGrade
-------------------------------------------------------
DELETE FROM opuscollege.failGrade;
-- EN
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','U','Unsatisfactory, Fail in a Practical Course','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','NE','No Examination Taken','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','WD','Withdrawn from the course with penalty for unsatisfactory academic progress','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','LT','Left the course during the semester without permission','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','DQ','Disqualified in a course by Senate Examination','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','DR','Deregistered for failure to pay fees','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','RS','Re-sit course examination only','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','IN','Incomplete','','Y');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','DF','Deferred Examination','','Y');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','SP','Supplementary Examination','','Y');
-- PT
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','U','Unsatisfactory, Fail in a Practical Course','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','NE','No Examination Taken','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','WD','Withdrawn from the course with penalty for unsatisfactory academic progress','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','LT','Left the course during the semester without permission','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','DQ','Disqualified in a course by Senate Examination','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','DR','Deregistered for failure to pay fees','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','RS','Re-sit course examination only','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','IN','Incomplete','','Y');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','DF','Deferred Examination','','Y');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','SP','Supplementary Examination','','Y');

