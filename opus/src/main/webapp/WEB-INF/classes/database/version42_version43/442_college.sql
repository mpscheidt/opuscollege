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
-- Date:   2015-02-13
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
UPDATE opuscollege.appVersions SET dbVersion = 4.42, writeWhen = now() WHERE lower(module) = 'college';

-------------------------------------------------------
-- table opuscollege.opusprivilege
-- The privileges READ_OWN_.._RESULTS indicate if a student is able to read his/her own
-- subject, examination or test restuls. E.g. at Mulungushi students shall not see their examination (and test) results
-------------------------------------------------------
INSERT INTO opuscollege.opusprivilege(code, lang, active, description) VALUES('READ_OWN_SUBJECT_RESULTS','en','Y','Students can read their own subject results');
INSERT INTO opuscollege.opusprivilege(code, lang, active, description) VALUES('READ_OWN_SUBJECT_RESULTS','pt','Y','Students can read their own subject results');
INSERT INTO opuscollege.opusprivilege(code, lang, active, description) VALUES('READ_OWN_EXAMINATION_RESULTS','en','Y','Students can read their own examination results');
INSERT INTO opuscollege.opusprivilege(code, lang, active, description) VALUES('READ_OWN_EXAMINATION_RESULTS','pt','Y','Students can read their own examination results');
INSERT INTO opuscollege.opusprivilege(code, lang, active, description) VALUES('READ_OWN_TEST_RESULTS','en','Y','Students can read their own test results');
INSERT INTO opuscollege.opusprivilege(code, lang, active, description) VALUES('READ_OWN_TEST_RESULTS','pt','Y','Students can read their own test results');

-------------------------------------------------------
-- table opusrole_privilege
-------------------------------------------------------
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','READ_OWN_SUBJECT_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','READ_OWN_EXAMINATION_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','READ_OWN_TEST_RESULTS');
