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
 * The Original Code is Opus-College accommodation module code.
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
-- Author: Markus Pscheidt
-- Date: 2012-06-29
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'accommodation';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('accommodation','A','Y',3.20);


-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------
DELETE FROM opuscollege.opusprivilege where code = 'APPLY_FOR_ACCOMMODATION';
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('APPLY_FOR_ACCOMMODATION','en','Y','Apply for accommodation');

-------------------------------------------------------
-- table opusrole_privilege
-------------------------------------------------------
DELETE FROM opuscollege.opusrole_privilege where privilegecode = 'APPLY_FOR_ACCOMMODATION';
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','APPLY_FOR_ACCOMMODATION');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','APPLY_FOR_ACCOMMODATION');

-------------------------------------------------------
-- table lookupTable
-------------------------------------------------------
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('acc_hosteltype', 'Lookup', 'Y');  

-------------------------------------------------------
-- table tableDependency
-------------------------------------------------------
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) 
VALUES ((SELECT id FROM opuscollege.lookuptable WHERE lower(tableName) = lower('acc_roomtype')), 'acc_room', 'roomTypeCode','Y');

INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) 
VALUES ((SELECT id FROM opuscollege.lookuptable WHERE lower(tableName) = lower('acc_hosteltype')), 'acc_hostel', 'hostelTypeCode','Y');

-------------------------------------------------------
-- table acc_accommodationfee
-------------------------------------------------------
-- must not have any record in this table when executing the following!
ALTER TABLE opuscollege.acc_accommodationfee DROP COLUMN hostelId;
ALTER TABLE opuscollege.acc_accommodationfee DROP COLUMN blockId;
ALTER TABLE opuscollege.acc_accommodationfee DROP COLUMN roomId;
ALTER TABLE opuscollege.acc_accommodationfee DROP COLUMN amountdue;
ALTER TABLE opuscollege.acc_accommodationfee DROP COLUMN description;
ALTER TABLE opuscollege.acc_accommodationfee DROP COLUMN academicYearId;
ALTER TABLE opuscollege.acc_accommodationfee DROP COLUMN deadline;
ALTER TABLE opuscollege.acc_accommodationfee DROP COLUMN numberofinstallments;
ALTER TABLE opuscollege.acc_accommodationfee DROP COLUMN active;
ALTER TABLE opuscollege.acc_accommodationfee ADD COLUMN hostelTypeCode VARCHAR NOT NULL;
ALTER TABLE opuscollege.acc_accommodationfee ADD COLUMN roomTypeCode VARCHAR NOT NULL;
ALTER TABLE opuscollege.acc_accommodationfee ADD COLUMN feeId INTEGER NOT NULL;
ALTER TABLE opuscollege.acc_accommodationfee RENAME COLUMN id TO accommodationFeeId;

