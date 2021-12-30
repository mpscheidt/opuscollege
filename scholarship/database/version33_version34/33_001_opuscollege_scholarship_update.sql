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
 * The Original Code is Opus-College scholarship module code.
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

-- Opus College (c) UCI - Monique in het Veld - march 2012
--
-- KERNEL opuscollege / MODULE scholarship
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'scholarship';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('scholarship','A','Y',3.26);

-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SCHOLARSHIPS','en','Y','Create information on scholarships');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SCHOLARSHIPS','en','Y','Read information on scholarships');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SCHOLARSHIPS','en','Y','Update information on scholarships');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SCHOLARSHIPS','en','Y','Delete information on scholarships');

-------------------------------------------------------
-- table sch_scholarshipapplication
-------------------------------------------------------
ALTER TABLE opuscollege.sch_scholarshipapplication add column feeId INTEGER NOT NULL DEFAULT 0;

-------------------------------------------------------
-- table opusrole_privilege
-------------------------------------------------------
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','CREATE_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','UPDATE_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','DELETE_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','READ_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','CREATE_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','UPDATE_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','DELETE_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_SCHOLARSHIPS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','READ_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_SCHOLARSHIPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SCHOLARSHIPS');

