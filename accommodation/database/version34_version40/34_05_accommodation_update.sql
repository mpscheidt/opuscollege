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
-- Author: Stelio Macumbe
-- Date: 2012-07-10
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'accommodation';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion)
VALUES('accommodation','A','Y',3.22);

-------------------------------------------------------
-- table acc_Hostel
-------------------------------------------------------       
--Create unique case insensitive index        
CREATE UNIQUE INDEX unique_hostelcode ON opuscollege.acc_Hostel ((lower(code)));

-------------------------------------------------------
-- table acc_block
-------------------------------------------------------       
ALTER TABLE opuscollege.acc_block ADD CONSTRAINT fk_block_hostelid FOREIGN KEY (hostelId) REFERENCES opuscollege.acc_hostel ON UPDATE CASCADE;

-------------------------------------------------------
-- table acc_accommodationfee
-------------------------------------------------------       
ALTER TABLE opuscollege.acc_accommodationfee ADD CONSTRAINT fk_accommodationfee_feeid FOREIGN KEY (feeId) REFERENCES opuscollege.fee_fee ON UPDATE CASCADE;

-------------------------------------------------------
-- table acc_Room
-------------------------------------------------------
--Remove repeated entries
DELETE FROM "opuscollege".acc_room
	    WHERE id NOT IN(
        	SELECT MAX(dup.id) FROM opuscollege.acc_room AS dup
			GROUP BY dup.code
		);
		
CREATE UNIQUE INDEX unique_acc_roomcode ON opuscollege.acc_Room ((lower(code)));

-------------------------------------------------------
-- table acc_RoomType
-------------------------------------------------------
ALTER TABLE opuscollege.acc_roomtype ADD CONSTRAINT unique_acc_roomtype_code_lang UNIQUE(code,lang);