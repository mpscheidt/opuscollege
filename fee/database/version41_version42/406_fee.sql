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
 * The Original Code is Opus-College fee module code.
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
 * ***** END LICENSE BLOCK *****/

-- 
-- Author: Janneke Nooitgedagt
-- Date:   2013-04-29
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'fee';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('fee','A','Y',4.06);

-------------------------------------------------------
-- table fee_fee
-------------------------------------------------------

ALTER TABLE opuscollege.fee_fee DROP COLUMN tuitionwaiverdiscountpercentage;
ALTER TABLE opuscollege.fee_fee DROP COLUMN fulltimestudentdiscountpercentage;
ALTER TABLE opuscollege.fee_fee DROP COLUMN localstudentdiscountpercentage;
ALTER TABLE opuscollege.fee_fee DROP COLUMN continuedregistrationdiscountpercentage;
ALTER TABLE opuscollege.fee_fee DROP COLUMN postgraduatediscountpercentage;

ALTER TABLE opuscollege.fee_fee ADD COLUMN nationalityGroupCode character varying;
UPDATE opuscollege.fee_fee SET nationalityGroupCode = '0';
ALTER TABLE opuscollege.fee_fee ALTER COLUMN nationalityGroupCode SET NOT NULL;
ALTER TABLE opuscollege.fee_fee ALTER COLUMN nationalityGroupCode SET DEFAULT ''::character varying;

ALTER TABLE opuscollege.fee_fee ADD COLUMN studyTimeCode character varying;
UPDATE opuscollege.fee_fee SET studyTimeCode = '0';
ALTER TABLE opuscollege.fee_fee ALTER COLUMN studyTimeCode SET NOT NULL;
ALTER TABLE opuscollege.fee_fee ALTER COLUMN studyTimeCode SET DEFAULT ''::character varying;

ALTER TABLE opuscollege.fee_fee ADD COLUMN studyFormCode character varying;
UPDATE opuscollege.fee_fee SET studyFormCode = '0';
ALTER TABLE opuscollege.fee_fee ALTER COLUMN studyFormCode SET NOT NULL;
ALTER TABLE opuscollege.fee_fee ALTER COLUMN studyFormCode SET DEFAULT ''::character varying;

ALTER TABLE opuscollege.fee_fee ADD COLUMN educationAreaCode character varying;
ALTER TABLE opuscollege.fee_fee ADD COLUMN educationLevelCode character varying;

-------------------------------------------------------
-- table fee_fee_hist
-------------------------------------------------------
ALTER TABLE audit.fee_fee_hist DROP COLUMN tuitionwaiverdiscountpercentage;
ALTER TABLE audit.fee_fee_hist DROP COLUMN fulltimestudentdiscountpercentage;
ALTER TABLE audit.fee_fee_hist DROP COLUMN localstudentdiscountpercentage;
ALTER TABLE audit.fee_fee_hist DROP COLUMN continuedregistrationdiscountpercentage;
ALTER TABLE audit.fee_fee_hist DROP COLUMN postgraduatediscountpercentage;

ALTER TABLE audit.fee_fee_hist ADD COLUMN nationalityGroupCode character varying;
ALTER TABLE audit.fee_fee_hist ADD COLUMN studyTimeCode character varying;
ALTER TABLE audit.fee_fee_hist ADD COLUMN studyFormCode character varying;
ALTER TABLE audit.fee_fee_hist ADD COLUMN educationAreaCode character varying;
ALTER TABLE audit.fee_fee_hist ADD COLUMN educationLevelCode character varying;
