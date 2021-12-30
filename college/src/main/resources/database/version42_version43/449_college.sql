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
-- Date:   2015-06-30
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
UPDATE opuscollege.appVersions SET dbVersion = 4.49, writeWhen = now() WHERE lower(module) = 'college';


-------------------------------------------------------
-- table institutiontype
-- this used to be educationtype, which was later used for different purpose
--     which led to universities being shown with a wrong type in the institutions overview
-------------------------------------------------------
CREATE TABLE opuscollege.institutionType (
    id serial primary key,
    code VARCHAR NOT NULL,
    lang CHAR(2) NOT NULL,
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    UNIQUE(code, lang)
);

INSERT INTO opuscollege.institutionType (lang,code,description) VALUES ('en','1','secondary school');
INSERT INTO opuscollege.institutionType (lang,code,description) VALUES ('en','3','higher education');

INSERT INTO opuscollege.institutionType (lang,code,description) VALUES ('pt','1','escola secundária');
INSERT INTO opuscollege.institutionType (lang,code,description) VALUES ('pt','3','ensino superior');

-------------------------------------------------------
-- table institution
-------------------------------------------------------
ALTER TABLE opuscollege.institution RENAME COLUMN educationTypeCode TO institutionTypeCode;

-------------------------------------------------------
-- table student
-------------------------------------------------------
ALTER TABLE opuscollege.student RENAME COLUMN previousinstitutioneducationtypecode TO previousinstitutiontypecode;

-------------------------------------------------------
-- table lookuptable
-------------------------------------------------------
INSERT INTO opuscollege.lookuptable(tableName, lookupType, active) VALUES ('institutiontype', 'Lookup', 'N');

-------------------------------------------------------
-- table tabledependency: some dependencies are now to institutiontype rather than educationtype
-------------------------------------------------------
UPDATE opuscollege.tabledependency
SET 
  lookuptableid = (select id from opuscollege.lookuptable WHERE tableName = 'institutiontype')
, dependenttablecolumn = 'institutionTypeCode'
WHERE dependenttable = 'institution' and dependenttablecolumn = 'educationTypeCode';

-- in table student the column was renamed from previousInstitutionEducationTypeCode to previousInstitutionTypeCode
UPDATE opuscollege.tabledependency
SET 
  lookuptableid = (select id from opuscollege.lookuptable WHERE tableName = 'institutiontype')
, dependenttablecolumn = 'previousInstitutionTypeCode'
WHERE dependenttable = 'student' and dependenttablecolumn = 'previousInstitutionEducationTypeCode';

