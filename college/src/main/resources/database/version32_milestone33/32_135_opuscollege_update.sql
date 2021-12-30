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

-- Opus College (c) UCI - Markus Pscheidt
--
-- KERNEL opuscollege
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.52);

-------------------------------------------------------
-- table role
-------------------------------------------------------

UPDATE opuscollege.role set level = 2 where role = 'registry';  -- same level as admin-C
UPDATE opuscollege.role set level = 2 where role = 'dvc';       -- same level as admin-C
UPDATE opuscollege.role set level = 2 where role = 'audit';     -- same level as admin-C
UPDATE opuscollege.role set level = 4 where role = 'admin-S';   -- head of 1st level
UPDATE opuscollege.role set level = 4 where role = 'library';   -- same as 1st level
UPDATE opuscollege.role set level = 4 where role = 'finance';   -- same as 1st level
UPDATE opuscollege.role set level = 4 where role = 'dos';       -- same as 1st level
UPDATE opuscollege.role set level = 4 where role = 'pr';        -- same as 1st level
UPDATE opuscollege.role set level = 5 where role = 'admin-D';   -- head of 2nd level
UPDATE opuscollege.role set level = 6 where role = 'teacher';
UPDATE opuscollege.role set level = 7 where role = 'student';
UPDATE opuscollege.role set level = 8 where role = 'guest';

-------------------------------------------------------
-- table person
-------------------------------------------------------
ALTER TABLE opuscollege.person
   ADD COLUMN motivation character varying;

-------------------------------------------------------
-- table opusprivilege & opusrole_privilege
-------------------------------------------------------
UPDATE opuscollege.opusprivilege set code = 'TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BACHELOR'
    WHERE code = 'TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BA_BSC';
UPDATE opuscollege.opusprivilege set code = 'TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MASTER'
    WHERE code = 'TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MA_MSC';
UPDATE opuscollege.opusprivilege set code = 'TOGGLE_CUTOFFPOINT_ADMISSION_BACHELOR'
    WHERE code = 'TOGGLE_CUTOFFPOINT_ADMISSION_BA_BSC';
UPDATE opuscollege.opusprivilege set code = 'TOGGLE_CUTOFFPOINT_ADMISSION_MASTER'
    WHERE code = 'TOGGLE_CUTOFFPOINT_ADMISSION_MA_MSC';

UPDATE opuscollege.opusrole_privilege set privilegecode = 'TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BACHELOR'
    WHERE privilegecode = 'TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BA_BSC';
UPDATE opuscollege.opusrole_privilege set privilegecode = 'TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MASTER'
    WHERE privilegecode = 'TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MA_MSC';
UPDATE opuscollege.opusrole_privilege set privilegecode = 'TOGGLE_CUTOFFPOINT_ADMISSION_BACHELOR'
    WHERE privilegecode = 'TOGGLE_CUTOFFPOINT_ADMISSION_BA_BSC';
UPDATE opuscollege.opusrole_privilege set privilegecode = 'TOGGLE_CUTOFFPOINT_ADMISSION_MASTER'
    WHERE privilegecode = 'TOGGLE_CUTOFFPOINT_ADMISSION_MA_MSC';

-------------------------------------------------------
-- table student
-------------------------------------------------------
ALTER TABLE opuscollege.student ADD COLUMN relativeOfStaffMember character(1) DEFAULT 'N'::bpchar NOT NULL;
ALTER TABLE opuscollege.student ADD COLUMN relativeStaffMemberId integer NOT NULL DEFAULT 0;
