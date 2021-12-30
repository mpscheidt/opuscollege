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

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',1.06);

-------------------------------------------------------
-- TABLE student
-------------------------------------------------------
ALTER TABLE opuscollege.student ADD column subscriptionRequirementsFulfilled CHAR(1) NOT NULL DEFAULT 'Y';

-------------------------------------------------------
-- TABLE province
-------------------------------------------------------
ALTER TABLE opuscollege.province ALTER countrycode TYPE varchar;

-------------------------------------------------------
-- table unitType
-------------------------------------------------------
DELETE from opuscollege.unitType;

INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','1','Faculty');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','2','Department');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','3','Administration');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','4','Section');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','5','Direction');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','6','Secretariat');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','7','Institute');

INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','1','Faculdade');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','2','Departamento');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','3','Reparti&ccedil;&atilde;o');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','4','Sec&ccedil;&atilde;o');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','5','Direc&ccedil;&atilde;o');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','6','Secretaria');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('pt','7','Instituto');
