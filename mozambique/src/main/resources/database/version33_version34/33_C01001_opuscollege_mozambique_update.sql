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
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('mozambique','A','Y',3.24);

-------------------------------------------------------
-- DOMAIN TABLE endGrade
-------------------------------------------------------
DELETE FROM opuscollege.endGrade;
-- EN
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','26', 'LIC', 26, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','25', 'LIC', 25, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','24', 'BSC', 24, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','23', 'BSC', 23, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','22', 'MSC', 22, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','21', 'MSC', 21, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','20', '',20, 0.0, 0.0, '20','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','19', '',19, 0.0, 0.0, '19','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','18', '',18, 0.0, 0.0, '18','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','17', '',17, 0.0, 0.0, '17','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','16', '',16, 0.0, 0.0, '16','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','15', '',15, 0.0, 0.0, '15','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','14', '',14, 0.0, 0.0, '14','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','13', '',13, 0.0, 0.0, '13','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','12', '',12, 0.0, 0.0, '12','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','11', '',11, 0.0, 0.0, '11','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','10', '',10, 0.0, 0.0, '10','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','09', '',9, 0.0, 0.0, '9','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','08', '',8, 0.0, 0.0, '8','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','07', '',7, 0.0, 0.0, '7','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','06', '',6, 0.0, 0.0, '6','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','05', '',5, 0.0, 0.0, '5','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','04', '',4, 0.0, 0.0, '4','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','03', '',3, 0.0, 0.0, '3','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','02', '',2, 0.0, 0.0, '2','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','01', '',1, 0.0, 0.0, '1','N','','N');

-- PT
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','26', 'LIC', 26, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','25', 'LIC', 25, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','24', 'BSC', 24, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','23', 'BSC', 23, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','22', 'MSC', 22, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','21', 'MSC', 21, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','20', '',20, 0.0, 0.0, '20','Y','20','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','19', '',19, 0.0, 0.0, '19','Y','19','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','18', '',18, 0.0, 0.0, '18','Y','18','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','17', '',17, 0.0, 0.0, '17','Y','17','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','16', '',16, 0.0, 0.0, '16','Y','16','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','15', '',15, 0.0, 0.0, '15','Y','15','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','14', '',14, 0.0, 0.0, '14','Y','14','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','13', '',13, 0.0, 0.0, '13','N','13','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','12', '',12, 0.0, 0.0, '12','N','12','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','11', '',11, 0.0, 0.0, '11','N','11','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','10', '',10, 0.0, 0.0, '10','N','10','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','09', '',9, 0.0, 0.0, '9','N','9','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','08', '',8, 0.0, 0.0, '8','N','8','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','07', '',7, 0.0, 0.0, '7','N','7','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','06', '',6, 0.0, 0.0, '6','N','6','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','05', '',5, 0.0, 0.0, '5','N','5','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','04', '',4, 0.0, 0.0, '4','N','4','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','03', '',3, 0.0, 0.0, '3','N','3','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','02', '',2, 0.0, 0.0, '2','N','2','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','01', '',1, 0.0, 0.0, '1','N','1','N');

-------------------------------------------------------
-- table appConfig
-------------------------------------------------------
DELETE FROM opuscollege.appconfig where appconfigattributename='USE_HOSTELBLOCKS';
INSERT INTO opuscollege.appconfig (appconfigattributename,appconfigattributevalue,startdate) VALUES ('USE_HOSTELBLOCKS','N','2011-01-01');
