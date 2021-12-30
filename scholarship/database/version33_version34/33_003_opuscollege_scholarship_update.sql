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
 * The Original Code is Opus-College sponsor module code.
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

-- Opus College (c) UCI - Stelio Macumbe - July 3 , 2012
--
-- KERNEL opuscollege / MODULE scholarship
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'scholarship';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('scholarship','A','Y', 3.28);

ALTER TABLE opuscollege.sch_sponsor ALTER COLUMN code SET NOT NULL;
ALTER TABLE opuscollege.sch_sponsor ALTER COLUMN "name" SET NOT NULL;
--Create unique case insensitive index        
CREATE UNIQUE INDEX unique_sch_sponsorcode ON opuscollege.sch_Sponsor ((lower(code)));

ALTER TABLE opuscollege.sch_sponsorfeepercentage ADD COLUMN writewho character varying NOT NULL DEFAULT 'opusscholarship';
ALTER TABLE opuscollege.sch_sponsorfeepercentage ADD COLUMN writewhen timestamp without time zone NOT NULL DEFAULT now();

ALTER TABLE opuscollege.sch_sponsorfeepercentage DROP COLUMN sponsorcode;
ALTER TABLE opuscollege.sch_sponsorfeepercentage ADD COLUMN sponsorId integer NOT NULL;
ALTER TABLE opuscollege.sch_sponsorfeepercentage ADD COLUMN active character(1) NOT NULL DEFAULT 'Y';

ALTER TABLE opuscollege.sch_sponsorfeepercentage ADD CONSTRAINT fk_sponsor_sponsorfeepercentage FOREIGN KEY (sponsorId) REFERENCES opuscollege.sch_sponsor (id) ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE opuscollege.sch_sponsorfeepercentage ADD CONSTRAINT unique_sch_sponsorfeepercentage_sponsorfeecategory UNIQUE(sponsorId, feeCategoryCode);

