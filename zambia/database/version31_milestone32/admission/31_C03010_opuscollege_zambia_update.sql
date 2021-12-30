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
 * The Original Code is Opus-College zambia module code.
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
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'zambia';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('zambia','A','Y',3.13);

-----------------------------------------------------------
-- inserts for table secondarySchoolSubject
-----------------------------------------------------------

DELETE FROM opuscollege.secondarySchoolSubject where lang='en';
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','001','English Language');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','002','Literature in English');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','101','Mathematics');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','102','Additional Mathematics');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','201','Chemistry');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','202','Physics');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','203','Physical Science');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','204','Engineering science');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','205','Agricultural science');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','207','Biology');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','211','Science');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','301','General Science');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','304','Commerce');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','307','Food and nutrition');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','308','History');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','311','Geography');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','312','Metal work');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','314','Geometrical and mechanical drawing');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','315','Geometrical and building drawing');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','320','Bible Knowledge / Religious Education');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','321','Principles of Accounts');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','410','Language other than English');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','415','Other subjects');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','418','Computer science');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','419','Combined science');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','420','Human and social biology');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','421','Wood Work');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','422','Art');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','423','Zambian language');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','424','Economics');
INSERT INTO opuscollege.secondarySchoolSubject (lang,code,description) VALUES ('en','425','Botany');




