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
-- Date:   2013-07-01
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
UPDATE opuscollege.appVersions SET dbVersion = 4.18 WHERE lower(module) = 'college';

-------------------------------------------------------
-- table OpusPrivilege
-------------------------------------------------------
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('CREATE_RESULTS_ASSIGNED_SUBJECTS', 'en', 'Create subject results by assigned subject teachers');
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('READ_RESULTS_ASSIGNED_SUBJECTS', 'en', 'Read subject results by assigned subject teachers');
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('UPDATE_RESULTS_ASSIGNED_SUBJECTS', 'en', 'Update subject results by assigned subject teachers');
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('DELETE_RESULTS_ASSIGNED_SUBJECTS', 'en', 'Delete subject results by assigned subject teachers');

INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('CREATE_RESULTS_ASSIGNED_EXAMINATIONS', 'en', 'Create examination results by assigned examination teachers');
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('READ_RESULTS_ASSIGNED_EXAMINATIONS', 'en', 'Read examination results by assigned examination teachers');
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('UPDATE_RESULTS_ASSIGNED_EXAMINATIONS', 'en', 'Update examination results by assigned examination teachers');
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('DELETE_RESULTS_ASSIGNED_EXAMINATIONS', 'en', 'Delete examination results by assigned examination teachers');

INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('CREATE_RESULTS_ASSIGNED_TESTS', 'en', 'Create test results by assigned test teachers');
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('READ_RESULTS_ASSIGNED_TESTS', 'en', 'Read test results by assigned test teachers');
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('UPDATE_RESULTS_ASSIGNED_TESTS', 'en', 'Update test results by assigned test teachers');
INSERT INTO opuscollege.OpusPrivilege (code, lang, description) VALUES('DELETE_RESULTS_ASSIGNED_TESTS', 'en', 'Delete test results by assigned test teachers');

-------------------------------------------------------
-- table opuscollege.opusrole_privilege
-------------------------------------------------------
-- By default teachers can alter the assigned subjects, examinations and tests
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher', 'CREATE_RESULTS_ASSIGNED_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher', 'READ_RESULTS_ASSIGNED_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher', 'UPDATE_RESULTS_ASSIGNED_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher', 'DELETE_RESULTS_ASSIGNED_SUBJECTS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher', 'CREATE_RESULTS_ASSIGNED_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher', 'READ_RESULTS_ASSIGNED_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher', 'UPDATE_RESULTS_ASSIGNED_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher', 'DELETE_RESULTS_ASSIGNED_EXAMINATIONS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher', 'CREATE_RESULTS_ASSIGNED_TESTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher', 'READ_RESULTS_ASSIGNED_TESTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher', 'UPDATE_RESULTS_ASSIGNED_TESTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher', 'DELETE_RESULTS_ASSIGNED_TESTS');
