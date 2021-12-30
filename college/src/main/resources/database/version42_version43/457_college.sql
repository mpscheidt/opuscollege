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
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
UPDATE opuscollege.appVersions SET dbVersion = 4.57, writeWhen = now() WHERE lower(module) = 'college';

-------------------------------------------------------
-- table appConfig
-------------------------------------------------------

ALTER TABLE opuscollege.appconfig ADD COLUMN branchId integer REFERENCES opuscollege.branch;

ALTER TABLE opuscollege.appconfig DROP CONSTRAINT appconfig_pkey,
    ADD CONSTRAINT appconfig_pkey PRIMARY KEY (id);

-- unique constraint does not accept COALESCE method, but unique index does, therefore enforce uniqueness including NULLable column branchId
-- see: http://stackoverflow.com/a/8289327/606662
CREATE UNIQUE INDEX appconfig_unique_idx ON opuscollege.appconfig (startdate, appconfigattributename, COALESCE(branchid, 0));

-- specify the default value of the sysoption
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('1970-01-01',NULL,'examinationFailCascade', 'Y');

-- tables examination and test
ALTER TABLE opuscollege.examination ADD CONSTRAINT examination_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES opuscollege.subject;
ALTER TABLE opuscollege.test ADD CONSTRAINT test_examinationid_fkey FOREIGN KEY (examinationid) REFERENCES opuscollege.examination;
