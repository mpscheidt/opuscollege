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
 * The Original Code is Opus-College netherlands module code.
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
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'netherlands';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('netherlands','A','Y',3.01);

-------------------------------------------------------
-- DOMAIN TABLE role
-------------------------------------------------------
DELETE FROM opuscollege.role;

-- EN
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','admin', 'functional administrator');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','admin-C', 'academic affairs office');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','admin-B', 'dean /  asst. dean');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','admin-D', 'head of department');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','staff', 'staff member');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','teacher', 'teachers of subjects');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','student', 'student');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','guest', 'system guest');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','finance', 'financial officer');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','registry', 'registrar / asst. registrar');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','library', 'librarian');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','audit', 'internal audit');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','student-dean', 'dean of Students');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','pr', 'pr / communication');
INSERT INTO opuscollege.role (lang,role,roleDescription) VALUES('nl','alumnus', 'alumnus');

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
-- AR ATTACHMENT RESULT
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','S','AR',2.5,55,100,'Satisfactory','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','F','AR',0,0,54.5,'Fail','','N');
-- BSC BACHELOR (SCIENCE)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','A+','BSC',2.5,86,100,'Distinction','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','A','BSC',2,75,85.5,'Distinction','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','B+','BSC',1.5,66,74.5,'Meritorious','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','B','BSC',1,56,65.5,'Very Satisfactory','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','C+','BSC',0.5,46,55.5,'Clear Pass','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','C','BSC',0,40,45.5,'Bare Pass','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','D+','BSC',0,35,39.5,'Fail','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','D','BSC',0,0,34.5,'Definite Fail','','N');
-- BA BACHELOR (ART)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','A+','BA',2.5,86,100,'Distinction','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','A','BA',2,75,85.5,'Distinction','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','B+','BA',1.5,66,74.5,'Meritorious','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','B','BA',1,56,65.5,'Very Satisfactory','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','C+','BA',0.5,46,55.5,'Clear Pass','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','C','BA',0,40,45.5,'Bare Pass','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','D+','BA',0,35,39.5,'Fail','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','D','BA',0,0,34.5,'Definite Fail','','N');
-- MSC MASTER (SCIENCE)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','A+','MSC',6,86,100,'Distinction','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','A','MSC',5,75,85,'Distinction','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','B+','MSC',4,70,74,'Meritorious','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','B','MSC',3,65,69,'Very Satisfactory','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','C+','MSC',2,55,64,'Clear Pass','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','C','MSC',1,50,54,'Bare Pass','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','F','MSC',0,0,49,'Fail in a Supplementary Examination','','N');
-- MA MASTER (ART)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','A+','MA',6,86,100,'Distinction','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','A','MA',5,75,85,'Distinction','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','B+','MA',4,70,74,'Meritorious','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','B','MA',3,65,69,'Very Satisfactory','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','C+','MA',2,55,64,'Clear Pass','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','C','MA',1,50,54,'Bare Pass','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','F','MA',0,0,49,'Fail in a Supplementary Examination','','N');
-- DA DIPLOMA (other than MATHS AND SCIENCE)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','A+','DA',5,86,100,'Distinction','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','A','DA',4,76,85,'Distinction','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','B+','DA',3,68,75,'Meritorious','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','B','DA',2,62,67,'Very Satisfactory','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','C+','DA',1,56,61,'Clear Pass','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','C','DA',0,50,55,'Bare Pass','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','D+','DA',0,40,49,'Fail','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','D','DA',0,0,39,'Definite Fail','','N');
-- DSC DIPLOMA (MATHS AND SCIENCE)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','A+','DSC',5,90,100,'Distinction','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','A','DSC',4,85,89,'Distinction','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','B+','DSC',3,80,84,'Meritorious','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','B','DSC',2,70,79,'Very Satisfactory','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','C+','DSC',1,60,69,'Clear Pass','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','C','DSC',0,50,59,'Bare Pass','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','D+','DSC',0,40,49,'Fail','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','D','DSC',0,0,39,'Definite Fail','','N');
-- DIST-DEGR DISTANT EDUCATION (DEGREE PROGRAMME)
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','A+','DIST-DEGR',5,86,100,'Distinction','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','A','DIST-DEGR',4,76,85,'Distinction','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','B+','DIST-DEGR',3,68,75,'Meritorious','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','B','DIST-DEGR',2,62,67,'Very Satisfactory','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','C+','DIST-DEGR',1,56,61,'Clear Pass','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','C','DIST-DEGR',0,50,55,'Bare Pass','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','D+','DIST-DEGR',0,40,49,'Fail','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','D','DIST-DEGR',0,0,39,'Definite Fail','','N');
-- DIST DISTANT EDUCATION
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','A+','DIST',5,90,100,'Distinction','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','A','DIST',4,85,89,'Distinction','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','B+','DIST',3,80,84,'Meritorious','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','B','DIST',2,70,79,'Very Satisfactory','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','C+','DIST',1,60,69,'Clear Pass','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','C','DIST',0,50,59,'Bare Pass','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','D+','DIST',0,40,49,'Fail','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,description,temporaryGrade) VALUES ('nl','D','DIST',0,0,39,'Definite Fail','','N');
-- PHD DOCTOR
-- TODO !!

-------------------------------------------------------
-- DOMAIN TABLE endGradeGeneral (applicable for all endgrades above)
-------------------------------------------------------
DELETE FROM opuscollege.endGradeGeneral;

INSERT INTO opuscollege.endGradeGeneral (lang,code,comment,description,temporaryGrade) VALUES ('nl','WP','Withdrawn from course with permission','','N');
INSERT INTO opuscollege.endGradeGeneral (lang,code,comment,description,temporaryGrade) VALUES ('nl','DC','Deceased during course','','N');

-------------------------------------------------------
-- DOMAIN TABLE failGrade
-------------------------------------------------------
DELETE FROM opuscollege.failGrade;

INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('nl','U','Unsatisfactory, Fail in a Practical Course','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('nl','NE','No Examination Taken','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('nl','WD','Withdrawn from the course with penalty for unsatisfactory academic progress','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('nl','LT','Left the course during the semester without permission','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('nl','DQ','Disqualified in a course by Senate Examination','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('nl','DR','Deregistered for failure to pay fees','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('nl','RS','Re-sit course examination only','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('nl','IN','Incomplete','','Y');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('nl','DF','Deferred Examination','','Y');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('nl','SP','Supplementary Examination','','Y');
