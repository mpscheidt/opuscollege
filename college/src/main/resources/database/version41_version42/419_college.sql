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

-- 
-- Author: Markus Pscheidt
-- Date:   2013-07-10
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
UPDATE opuscollege.appVersions SET dbVersion = 4.19 WHERE lower(module) = 'college';


-------------------------------------------------------
-- table OpusPrivilege
-------------------------------------------------------
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('CREATE_SUBJECTS_RESULTS', 'en', 'Create subject results (and set any subject teacher)');
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('READ_SUBJECTS_RESULTS', 'en', 'Read subject results');
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('UPDATE_SUBJECTS_RESULTS', 'en', 'Update all subject results (and set any subject teacher)');
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('DELETE_SUBJECTS_RESULTS', 'en', 'Delete subject results');

INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('CREATE_SUBJECTS_RESULTS', 'pt', 'Create subject results (and set any subject teacher)');
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('READ_SUBJECTS_RESULTS', 'pt', 'Read subject results');
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('UPDATE_SUBJECTS_RESULTS', 'pt', 'Update all subject results (and set any subject teacher)');
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('DELETE_SUBJECTS_RESULTS', 'pt', 'Delete subject results');

INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('CREATE_SUBJECTS_RESULTS', 'nl', 'Create subject results (and set any subject teacher)');
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('READ_SUBJECTS_RESULTS', 'nl', 'Read subject results');
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('UPDATE_SUBJECTS_RESULTS', 'nl', 'Update all subject results (and set any subject teacher)');
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('DELETE_SUBJECTS_RESULTS', 'nl', 'Delete subject results');

-------------------------------------------------------
-- table opuscollege.opusrole_privilege
-------------------------------------------------------
-- By default teachers can alter the assigned subjects, examinations and tests
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry', 'CREATE_SUBJECTS_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry', 'READ_SUBJECTS_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry', 'UPDATE_SUBJECTS_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry', 'DELETE_SUBJECTS_RESULTS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin', 'CREATE_SUBJECTS_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin', 'READ_SUBJECTS_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin', 'UPDATE_SUBJECTS_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin', 'DELETE_SUBJECTS_RESULTS');

