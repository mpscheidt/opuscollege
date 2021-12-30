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
-- Date:   2013-09-24
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
UPDATE opuscollege.appVersions SET dbVersion = 4.30 WHERE lower(module) = 'college';


-------------------------------------------------------
-- table opuscollege.appConfig
-------------------------------------------------------

-- remove unused appConfig attribute
DELETE FROM opuscollege.appConfig where lower(appConfigAttributeName) = 'numberofsubjectstocountforstudyplanmark';

-------------------------------------------------------
-- table opuscollege.opusprivilege
-------------------------------------------------------

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDYPLAN_RESULTS','en','Y','Delete studyplan results');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDYPLAN_RESULTS','nl','Y','Delete studyplan results');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDYPLAN_RESULTS','pt','Y','Remover resultados do plano do estudo');

-------------------------------------------------------
-- table opuscollege.opusrole_privilege
-------------------------------------------------------

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','DELETE_STUDYPLAN_RESULTS');
