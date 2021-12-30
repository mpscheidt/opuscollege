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
 * The Original Code is Opus-College accommodation module code.
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

-- Opus College (c) CBU - Ben Mazyopa
--
-- KERNEL opuscollege / MODULE accommodation
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'accommodation';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('accommodation','A','Y',3.13);


-------------------------------------------------------
-- Sequences
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.acc_studentaccommodationseq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.acc_studentaccommodationselectioncriteriaseq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.acc_accommodationselectioncriteriaseq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.acc_accommodationfeepaymentseq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.acc_accommodationfeeseq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.acc_hostelSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.acc_hosteltypeseq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.acc_roomseq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.acc_blockseq CASCADE;

CREATE SEQUENCE opusCollege.acc_studentaccommodationseq;
CREATE SEQUENCE opuscollege.acc_studentaccommodationselectioncriteriaseq;
CREATE SEQUENCE opuscollege.acc_accommodationselectioncriteriaseq;
CREATE SEQUENCE opuscollege.acc_accommodationfeepaymentseq;
CREATE SEQUENCE opuscollege.acc_accommodationfeeseq;
CREATE SEQUENCE opuscollege.acc_hostelseq;
CREATE SEQUENCE opuscollege.acc_hosteltypeseq;
CREATE SEQUENCE opuscollege.acc_roomseq;
CREATE SEQUENCE opusCollege.acc_blockseq;

ALTER TABLE opuscollege.acc_studentaccommodationseq OWNER TO postgres;
ALTER TABLE opuscollege.acc_studentaccommodationselectioncriteriaseq OWNER TO postgres;
ALTER TABLE opuscollege.acc_accommodationselectioncriteriaseq OWNER TO postgres;
ALTER TABLE opuscollege.acc_accommodationfeepaymentseq OWNER TO postgres;
ALTER TABLE opuscollege.acc_accommodationfeeseq OWNER TO postgres;
ALTER TABLE opuscollege.acc_hostelseq OWNER TO postgres;
ALTER TABLE opuscollege.acc_hosteltypeseq OWNER TO postgres;
ALTER TABLE opuscollege.acc_roomseq OWNER TO postgres;
ALTER TABLE opuscollege.acc_blockseq OWNER TO postgres;

-------------------------------------------------------
-- table acc_accommodation
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.acc_accommodationfee CASCADE;
DROP TABLE IF EXISTS opuscollege.acc_accommodationfeepayment CASCADE;
DROP TABLE IF EXISTS opuscollege.acc_accommodationselectioncriteria CASCADE;
DROP TABLE IF EXISTS opuscollege.acc_hostel CASCADE;
DROP TABLE IF EXISTS opuscollege.acc_hosteltype CASCADE;
DROP TABLE IF EXISTS opuscollege.acc_room CASCADE;
DROP TABLE IF EXISTS opuscollege.acc_studentaccommodationselectioncriteria CASCADE;
DROP TABLE IF EXISTS opuscollege.acc_studentaccommodation CASCADE;
DROP TABLE IF EXISTS opuscollege.acc_block CASCADE;

----------------------------------------------------------------------------------------------------------------
--Table acc_accommodationfee: table which stores hostel and room charges for each academic year
----------------------------------------------------------------------------------------------------------------
CREATE TABLE opuscollege.acc_accommodationfee (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.acc_accommodationfeeseq'), 
    amountdue NUMERIC(10,2) NOT NULL,
    hostelid INTEGER NOT NULL,
    blockid INTEGER DEFAULT 0,
    roomid INTEGER NOT NULL,
    academicyearid INTEGER NOT NULL,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege-accommodation',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    active CHAR(1) NOT NULL DEFAULT 'Y',
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.acc_accommodationfee OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.acc_accommodationfee TO postgres;

----------------------------------------------------------------------------------------------------------------
-- Table acc_accommodationfeepayment : table to store payment information for any student with accommodation
----------------------------------------------------------------------------------------------------------------
CREATE TABLE opuscollege.acc_accommodationfeepayment (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.acc_accommodationfeepaymentseq'), 
    studentaccommodationid INTEGER NOT NULL,
    accommodationfeeid INTEGER NOT NULL,
    amountpaid NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    paidto INTEGER NOT NULL DEFAULT 0,
    datepaid DATE NOT NULL DEFAULT now(),
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege-accommodation',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.acc_accommodationfeepayment OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.acc_accommodationfeepayment TO postgres;

----------------------------------------------------------------------------------------------------------------
-- Table acc_accommodationselectioncretria : table to store selection criteria information 
----------------------------------------------------------------------------------------------------------------

CREATE TABLE opuscollege.acc_accommodationselectioncriteria (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.acc_accommodationselectioncriteriaseq'), 
    code VARCHAR NOT NULL DEFAULT 0.00,
    description VARCHAR NOT NULL,
    weight INTEGER NOT NULL DEFAULT 1,
    lang VARCHAR NOT NULL DEFAULT 'en',
    writewho VARCHAR NOT NULL DEFAULT 'opuscollege-accommodation',
    writewhen TIMESTAMP NOT NULL DEFAULT now(),
    active CHAR(1) NOT NULL DEFAULT 'Y',
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.acc_accommodationselectioncriteria OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.acc_accommodationselectioncriteria TO postgres;

----------------------------------------------------------------------------------------------------------------
-- Table acc_hostel: stores information for hostels
----------------------------------------------------------------------------------------------------------------

CREATE TABLE opuscollege.acc_hostel (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.acc_hostelseq'), 
    code VARCHAR NOT NULL DEFAULT 0.00,
    description VARCHAR NOT NULL,
    numberoffloors INTEGER NOT NULL DEFAULT 1,
    hosteltypeid INTEGER NOT NULL DEFAULT 0,
    writewho VARCHAR NOT NULL DEFAULT 'opuscollege-accommodation',
    writewhen TIMESTAMP NOT NULL DEFAULT now(),
    active CHAR(1) NOT NULL DEFAULT 'Y',
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.acc_hostel OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.acc_hostel TO postgres;


----------------------------------------------------------------------------------------------------------------
-- table acc_hosteltype : stores information of the types of hostels
----------------------------------------------------------------------------------------------------------------
CREATE TABLE opuscollege.acc_hosteltype (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.acc_hosteltypeseq'), 
    code VARCHAR NOT NULL,
    description VARCHAR NOT NULL,
    lang VARCHAR NOT NULL DEFAULT 'en',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege-accommodation',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    active CHAR(1) NOT NULL DEFAULT 'Y',
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.acc_hosteltype OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.acc_hosteltype TO postgres;

----------------------------------------------------------------------------------------------------------------
--Table acc_block: table which stores of blocks belonging to the hostel
----------------------------------------------------------------------------------------------------------------
CREATE TABLE opuscollege.acc_block (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.acc_blockseq'), 
    code VARCHAR(30) NOT NULL,
    description VARCHAR(255) NOT NULL,
    hostelid INTEGER NOT NULL,
    numberoffloors INTEGER NOT NULL,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege-accommodation',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    active CHAR(1) NOT NULL DEFAULT 'Y',
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.acc_block OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.acc_block TO postgres;


----------------------------------------------------------------------------------------------------------------
-- Table acc_room : table used to store information about the rooms 
----------------------------------------------------------------------------------------------------------------
CREATE TABLE opuscollege.acc_room (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.acc_roomseq'), 
    code VARCHAR NOT NULL,
    description VARCHAR NOT NULL,
    numberofbedspaces INTEGER NOT NULL DEFAULT 1,
    hostelid INTEGER NOT NULL,
    blockid INTEGER DEFAULT 0,
    floornumber INTEGER NOT NULL,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege-accommodation',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    active CHAR(1) NOT NULL DEFAULT 'Y',
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.acc_room OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.acc_room TO postgres;


----------------------------------------------------------------------------------------------------------------
--Table acc_studentaccommodation : table to store the applicants for accommodation as well as their approval and allocations
----------------------------------------------------------------------------------------------------------------
CREATE TABLE opuscollege.acc_studentaccommodation (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.acc_studentaccommodationseq'), 
    studentid INTEGER NOT NULL,
    bednumber INTEGER NOT NULL DEFAULT 0,
    academicyearid INTEGER NOT NULL,
    dateapplied DATE NOT NULL DEFAULT now(),
    dateapproved DATE NULL,
    approved CHAR(1) NOT NULL DEFAULT 'N',
    approvedbyid INTEGER NOT NULL DEFAULT 0,
    accepted CHAR(1) NOT NULL DEFAULT 'N',
    dateaccepted DATE NULL,
    reasonForApplyingForAccommodation VARCHAR,
    comment VARCHAR NULL,
    roomid INTEGER NOT NULL DEFAULT 0,
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege-accommodation',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    active char(1) NOT NULL DEFAULT 'N',
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.acc_studentaccommodation OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.acc_studentaccommodation TO postgres;


----------------------------------------------------------------------------------------------------------------
-- Table acc_studentaccommodationselectioncretria : table to store selection criteria information for any student who have applied of accommodation
----------------------------------------------------------------------------------------------------------------
CREATE TABLE opuscollege.acc_studentaccommodationselectioncriteria (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.acc_studentaccommodationselectioncriteriaseq'), 
    studentaccommodationid INTEGER NOT NULL,
    accommodationselectioncriteriaid INTEGER NOT NULL,
    writewho VARCHAR NOT NULL DEFAULT 'opuscollege-accommodation',
    writewhen TIMESTAMP NOT NULL DEFAULT now(),
    active CHAR(1) NOT NULL DEFAULT 'Y',
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.acc_studentaccommodationselectioncriteria OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.acc_studentaccommodationselectioncriteria TO postgres;

ALTER TABLE opuscollege.acc_accommodationfee ADD FOREIGN KEY (hostelid) REFERENCES opuscollege.acc_hostel;
ALTER TABLE opuscollege.acc_accommodationfee ADD FOREIGN KEY (academicyearid) REFERENCES opuscollege.academicyear;
ALTER TABLE opuscollege.acc_accommodationfeepayment ADD FOREIGN KEY (studentaccommodationid) REFERENCES opuscollege.acc_studentaccommodation;
ALTER TABLE opuscollege.acc_accommodationfeepayment ADD FOREIGN KEY (accommodationfeeid) REFERENCES opuscollege.acc_accommodationfee;
ALTER TABLE opuscollege.acc_hostel ADD FOREIGN KEY (hosteltypeid) REFERENCES opuscollege.acc_hosteltype;
ALTER TABLE opuscollege.acc_room ADD FOREIGN KEY (hostelid) REFERENCES opuscollege.acc_hostel;
ALTER TABLE opuscollege.acc_studentaccommodation ADD FOREIGN KEY (studentid) REFERENCES opuscollege.student;
ALTER TABLE opuscollege.acc_studentaccommodation ADD FOREIGN KEY (academicyearid) REFERENCES opuscollege.academicyear;
-- ALTER TABLE opuscollege.acc_studentaccommodation ADD FOREIGN KEY (approvedbyid) REFERENCES opuscollege.person;


-------------------------------------------------------
-- table acc_hosteltype
-------------------------------------------------------
DELETE FROM opuscollege.acc_hosteltype where lang = 'en_ZM';
DELETE FROM opuscollege.acc_hosteltype where lang = 'en';

INSERT INTO opuscollege.acc_hosteltype (code,description,lang) VALUES ('NEW','New Hostels','en');
INSERT INTO opuscollege.acc_hosteltype (code,description,lang) VALUES ('OLD','Old Hostels','en');
INSERT INTO opuscollege.acc_hosteltype (code,description,lang) VALUES ('FLATS','Flatlets','en');

DELETE FROM opuscollege.appconfig where appconfigattributename='USE_HOSTELBLOCKS';
INSERT INTO opuscollege.appconfig (appconfigattributename,appconfigattributevalue,startdate) VALUES ('USE_HOSTELBLOCKS','Y',Now());
ALTER TABLE opuscollege.acc_room ADD COLUMN availablebedspace INTEGER DEFAULT 0;