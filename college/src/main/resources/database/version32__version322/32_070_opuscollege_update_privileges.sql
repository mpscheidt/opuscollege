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

-- Opus College (c) UCI - Janneke Nooitgedagt
--
-- KERNEL opuscollege / MODULE - : privileges
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.39);

-------------------------------------------------------
-- table opusrole_privilege
-------------------------------------------------------
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_IDENTIFICATION_DATA','en','Y','Create National Registration Number, Identfication Number and Type of a student');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_IDENTIFICATION_DATA','en','Y','Update National Registration Number, Identfication Number and Type of a student');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_IDENTIFICATION_DATA','en','Y','Delete National Registration Number, Identfication Number and Type of a student');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_IDENTIFICATION_DATA','en','Y','View National Registration Number, Identfication Number and Type of a student');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','CREATE_IDENTIFICATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','UPDATE_IDENTIFICATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','DELETE_IDENTIFICATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','READ_IDENTIFICATION_DATA');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_IDENTIFICATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_IDENTIFICATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_IDENTIFICATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_IDENTIFICATION_DATA');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_IDENTIFICATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_IDENTIFICATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_IDENTIFICATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_IDENTIFICATION_DATA');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_IDENTIFICATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_IDENTIFICATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_IDENTIFICATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_IDENTIFICATION_DATA');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_IDENTIFICATION_DATA');

-------------------------------------------------------
-- table opusrole_privilege
-------------------------------------------------------
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','PROGRESS_ADMISSION_FLOW');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','FINALIZE_ADMISSION_FLOW');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','TOGGLE_CUTOFFPOINT_ADMISSION_BA_BSC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BA_BSC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MA_MSC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','PROGRESS_CONTINUED_REGISTRATION_FLOW');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','FINALIZE_CONTINUED_REGISTRATION_FLOW');

