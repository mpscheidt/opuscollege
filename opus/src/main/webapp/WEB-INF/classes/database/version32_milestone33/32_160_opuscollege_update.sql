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

-- Opus College (c) UCI - Monique in het Veld, February 2012
--
-- KERNEL opuscollege
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.57);


-------------------------------------------------------
-- table opusrole_privilege
-------------------------------------------------------
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','READ_IDENTIFICATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','READ_STUDENT_SUBSCRIPTION_DATA');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_IDENTIFICATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_OPUSUSER');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_IDENTIFICATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_OPUSUSER');

DELETE FROM opuscollege.opusrole_privilege WHERE role = 'audit' and privilegecode = 'UPDATE_BRANCHES';

DELETE FROM opuscollege.opusrole_privilege WHERE role = 'library' and privilegecode = 'READ_STUDIES';
DELETE FROM opuscollege.opusrole_privilege WHERE role = 'dos' and privilegecode = 'READ_STUDIES';
DELETE FROM opuscollege.opusrole_privilege WHERE role = 'library' and privilegecode = 'READ_SUBJECTS';
DELETE FROM opuscollege.opusrole_privilege WHERE role = 'dos' and privilegecode = 'READ_SUBJECTS';
DELETE FROM opuscollege.opusrole_privilege WHERE role = 'library' and privilegecode = 'READ_SUBJECTBLOCKS';
DELETE FROM opuscollege.opusrole_privilege WHERE role = 'dos' and privilegecode = 'READ_SUBJECTBLOCKS';
DELETE FROM opuscollege.opusrole_privilege WHERE role = 'library' and privilegecode = 'READ_ACADEMIC_YEARS';
DELETE FROM opuscollege.opusrole_privilege WHERE role = 'dos' and privilegecode = 'READ_ACADEMIC_YEARS';

-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('ACCESS_CONTEXT_HELP','en','Y','Show the context help');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','ACCESS_CONTEXT_HELP');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','ACCESS_CONTEXT_HELP');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','ACCESS_CONTEXT_HELP');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','ACCESS_CONTEXT_HELP');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','ACCESS_CONTEXT_HELP');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','ACCESS_CONTEXT_HELP');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','ACCESS_CONTEXT_HELP');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','ACCESS_CONTEXT_HELP');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','ACCESS_CONTEXT_HELP');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','ACCESS_CONTEXT_HELP');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','ACCESS_CONTEXT_HELP');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','ACCESS_CONTEXT_HELP');

