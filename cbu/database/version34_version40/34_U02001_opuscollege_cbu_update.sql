/*******************************************************************************
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"), you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College unza module code.
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
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'cbu';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('cbu','A','Y',3.17);

-------------------------------------------------------
-- table gradeType
-------------------------------------------------------
-------------------------------------------------------
-- table gradeType
-------------------------------------------------------
DELETE FROM opuscollege.gradeType where lang='en';

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','SEC','Secondary school','sec.');

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','BSC','Bachelor of science','B.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','LIC','Licentiate','Lic..');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','MSC','Master of science','M.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','PHD','Doctor','Ph.D.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','BA','Bachelor of art','B.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','MA','Master of art','M.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','DA','Diploma other than maths and science','Dpl.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','DSC','Diploma maths and science','Dpl.M.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','BEng','Bachelor of Engineering','B.Eng.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','MEngSc','Master of Engineering Science','M.Eng.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','MScEng','Master of Science Engineering ','M.Sc.Eng.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','MBA','Master of Business Administration','M.BA.');

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','M','Master','M.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','B','Bachelor','B');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','ADVTECH','Advanced Technology','Adv.Tech.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','ADVCERT','Advanced Certificate','Adv.Cert.');

-------------------------------------------------------
-- table endGrade
-------------------------------------------------------
INSERT INTO opuscollege.endgrade(endgradetypecode,code,lang,active,gradepoint,percentagemin,percentagemax,comment,description,temporarygrade,writewho,writewhen,passed,academicyearid)
select 'B' AS endgradetypecode,code,lang,active,gradepoint,percentagemin,percentagemax,comment,description,temporarygrade,writewho,writewhen,passed,academicyearid from opuscollege.endgrade where endgradetypecode='BA';

INSERT INTO opuscollege.endgrade(endgradetypecode,code,lang,active,gradepoint,percentagemin,percentagemax,comment,description,temporarygrade,writewho,writewhen,passed,academicyearid)
select 'ADVCERT' AS endgradetypecode,code,lang,active,gradepoint,percentagemin,percentagemax,comment,description,temporarygrade,writewho,writewhen,passed,academicyearid from opuscollege.endgrade where endgradetypecode='DA';

INSERT INTO opuscollege.endgrade(endgradetypecode,code,lang,active,gradepoint,percentagemin,percentagemax,comment,description,temporarygrade,writewho,writewhen,passed,academicyearid)
select 'ADVTECH' AS endgradetypecode,code,lang,active,gradepoint,percentagemin,percentagemax,comment,description,temporarygrade,writewho,writewhen,passed,academicyearid from opuscollege.endgrade where endgradetypecode='DA';

INSERT INTO opuscollege.endgrade(endgradetypecode,code,lang,active,gradepoint,percentagemin,percentagemax,comment,description,temporarygrade,writewho,writewhen,passed,academicyearid)
select 'M' AS endgradetypecode,code,lang,active,gradepoint,percentagemin,percentagemax,comment,description,temporarygrade,writewho,writewhen,passed,academicyearid from opuscollege.endgrade where endgradetypecode='MSC';