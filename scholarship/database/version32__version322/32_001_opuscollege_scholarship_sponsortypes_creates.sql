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
 * The Original Code is Opus-College scholarship module code.
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

-- Opus College (c) UNZA - Katuta G.C. Kaunda - September 2011
--
-- KERNEL opuscollege / MODULE scholarship
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'scholarship';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('scholarship','A','Y',3.14);

-------------------------------------------------------
-- table sch_sponsor
-------------------------------------------------------

ALTER TABLE opuscollege.sch_sponsor add CONSTRAINT fk_sponsorcode UNIQUE (code);

-------------------------------------------------------
-- table sch_sponsortypes
-------------------------------------------------------

CREATE TABLE opuscollege.sch_sponsorType(
	id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.sch_sponsorType_seq'),
	code VARCHAR NOT NULL,
	name VARCHAR not null,
	lang VARCHAR NOT NULL,
	description VARCHAR NOT NULL,
	active CHAR(1) DEFAULT 'Y',
	writeWho VARCHAR NOT NULL DEFAULT 'opuscollege-scholarship',
	writeWhen TIMESTAMP NOT NULL DEFAULT now(),
	
	--
	UNIQUE(code),
	PRIMARY KEY(id)
);
ALTER TABLE opuscollege.sch_sponsorType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.sch_sponsorType TO postgres;

-------------------------------------------------------
-- table sch_sponsorSponsorType
-------------------------------------------------------
CREATE TABLE opuscollege.sch_sponsorSponsorType(
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.sch_sponsorSponsorType_seq'),
    sponsorCode VARCHAR NOT NULL,
    sponsorTypeCode VARCHAR NOT NULL,
    
    --
    --Need to alter sch_sponsor(code) and make it unique
    FOREIGN KEY (sponsorCode) REFERENCES opuscollege.sch_sponsor(code),
    FOREIGN KEY (sponsorTypeCode) REFERENCES opuscollege.sch_sponsorType(code),
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.sch_sponsorSponsorType OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.sch_sponsorSponsorType TO postgres;

-------------------------------------------------------
-- table sch_sponsorshipPercentages
-------------------------------------------------------
CREATE TABLE opuscollege.sch_sponsorshipPercentage (
	id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.sch_sponsorshipPercentage_seq'),
	sponsorCode VARCHAR NOT NULL,
	feeTypeCode VARCHAR NOT NULL,
	percentage	VARCHAR NOT NULL,
	
	--
	FOREIGN KEY (sponsorCode) REFERENCES opuscollege.sch_sponsor(code),
	FOREIGN KEY (feeTypeCode) REFERENCES opuscollege.fee_feeType(feeTypeCode),
	PRIMARY KEY(id)
);
ALTER TABLE opuscollege.sch_sponsorshipPercentage OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.sch_sponsorshipPercentage TO postgres;



