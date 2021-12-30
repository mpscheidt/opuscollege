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
-- Author: Markus Pscheidt
-- Date:   2012-07-08
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'fee';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion)
VALUES('fee','A','Y',3.18);


-------------------------------------------------------
-- table fee_unit
-------------------------------------------------------

DROP SEQUENCE IF EXISTS opuscollege.fee_unitSeq CASCADE;
DROP TABLE IF EXISTS opuscollege.fee_unit;

CREATE SEQUENCE opuscollege.fee_unitSeq;
ALTER TABLE opuscollege.fee_unitSeq OWNER TO postgres;

CREATE TABLE opuscollege.fee_unit (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.fee_unitSeq'),
    code VARCHAR NOT NULL,
    lang CHAR(2) NOT NULL,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    description VARCHAR,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.fee_unit OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.fee_unit TO postgres;

DELETE FROM opuscollege.fee_unit where lang='en';
INSERT INTO opuscollege.fee_unit (lang,code,description) VALUES ('en','1','Subject');
INSERT INTO opuscollege.fee_unit (lang,code,description) VALUES ('en','2','Cardinal time unit');
INSERT INTO opuscollege.fee_unit (lang,code,description) VALUES ('en','3','Academic year');
INSERT INTO opuscollege.fee_unit (lang,code,description) VALUES ('en','4','Study grade type');

-------------------------------------------------------
-- table lookuptable
-------------------------------------------------------
INSERT INTO opuscollege.lookuptable(tablename, lookuptype, active) VALUES ('fee_unit', 'Lookup', 'N');


-------------------------------------------------------
-- table fee_fee
-------------------------------------------------------

-- studyIntensityCode: full time / part time
ALTER TABLE opuscollege.fee_fee add column studyIntensityCode VARCHAR NOT NULL DEFAULT '';
ALTER TABLE audit.fee_fee_hist add column studyIntensityCode VARCHAR;

-- feeUnit: subject / CTU / academic year / studyGradeType
ALTER TABLE opuscollege.fee_fee add column feeUnitCode VARCHAR NOT NULL DEFAULT '';
ALTER TABLE audit.fee_fee_hist add column feeUnitCode VARCHAR;

-- applicationMode: manual ('M') / automatic ('A')
ALTER TABLE opuscollege.fee_fee add column applicationMode CHAR(1) NOT NULL DEFAULT 'A';
ALTER TABLE audit.fee_fee_hist add column applicationMode CHAR(1);

-- cardinalTimeUnitNumber: 0 (any), 1, 2, 3, ..
ALTER TABLE opuscollege.fee_fee add column cardinalTimeUnitNumber INTEGER NOT NULL DEFAULT 0;
ALTER TABLE audit.fee_fee_hist add column cardinalTimeUnitNumber INTEGER NOT NULL DEFAULT 0;

