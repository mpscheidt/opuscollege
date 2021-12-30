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
 * The Original Code is Opus-College cbu module code.
 * 
 * The Initial Developer of the Original Code is
 * Computer Centre, Copperbelt University, Zambia
 * Portions created by the Initial Developer are Copyright (C) 2012
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
-- Author: Janneke Nooitgedagt
-- Date: 2013-01-16
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'cbu';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion)
VALUES('cbu','A','Y',4.01);



-------------------------------------------------------
-- table role
-------------------------------------------------------
delete from opuscollege.role where lower(role) = 'warden';

INSERT INTO opuscollege.role (lang, active, role, roledescription, level) VALUES ('en','Y','warden','Hall warden', 5);

-------------------------------------------------------
-- table opusrole_privilege
-------------------------------------------------------
delete from opuscollege.opusrole_privilege where lower(role) = 'warden';

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('warden','ALLOCATE_ROOM');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('warden','READ_ACCOMMODATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('warden','READ_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('warden','READ_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('warden','READ_PRIMARY_AND_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('warden','CREATE_ACCOMMODATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('warden','UPDATE_ACCOMMODATION_DATA');

delete from opuscollege.opusrole_privilege where lower(role) = 'admin' and privilegecode = 'CREATE_ACCOMMODATION_DATA';
delete from opuscollege.opusrole_privilege where lower(role) = 'admin' and privilegecode = 'UPDATE_ACCOMMODATION_DATA';

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','CREATE_ACCOMMODATION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','UPDATE_ACCOMMODATION_DATA');


