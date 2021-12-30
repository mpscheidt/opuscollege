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

-- 
-- Author: Markus Pscheidt
-- Date:   2013-04-03
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'scholarship';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion)
VALUES('scholarship', 'A', 'Y', 4.01);

-------------------------------------------------------
-- table sch_sponsor
-------------------------------------------------------

ALTER TABLE opuscollege.sch_sponsor ADD COLUMN academicYearId integer REFERENCES opuscollege.academicYear (id);

UPDATE opuscollege.sch_sponsor set academicYearId = (select min(id) from opuscollege.academicyear);

ALTER TABLE opuscollege.sch_sponsor ALTER COLUMN academicyearid SET NOT NULL;

DROP INDEX opuscollege.unique_sch_sponsorcode;
ALTER TABLE opuscollege.sch_sponsor DROP CONSTRAINT fk_sponsorcode;
ALTER TABLE opuscollege.sch_sponsor ADD CONSTRAINT uq_code_academicYearId UNIQUE (code, academicYearId);

CREATE SEQUENCE opuscollege.sch_sponsortransfer_seq;
ALTER SEQUENCE opuscollege.sch_sponsortransfer_seq OWNER TO postgres;

ALTER TABLE opuscollege.sch_sponsor ADD COLUMN transferId integer;
UPDATE opuscollege.sch_sponsor SET transferId = nextval('opuscollege.sch_sponsortransfer_seq'::regclass);
ALTER TABLE opuscollege.sch_sponsor ALTER COLUMN transferId SET NOT NULL;
ALTER TABLE opuscollege.sch_sponsor ALTER COLUMN transferId SET DEFAULT nextval('opuscollege.sch_sponsortransfer_seq'::regclass);

TRUNCATE opuscollege.sch_sponsor CASCADE;

-------------------------------------------------------
-- table sch_sponsorpayment
-------------------------------------------------------

ALTER TABLE opuscollege.sch_sponsorpayment DROP COLUMN scholarshipapplicationid;
ALTER TABLE opuscollege.sch_sponsorpayment DROP COLUMN academicyearid;
ALTER TABLE opuscollege.sch_sponsorpayment DROP COLUMN paymentduedate;
TRUNCATE opuscollege.sch_sponsorpayment;
ALTER TABLE opuscollege.sch_sponsorpayment ADD COLUMN sponsorId integer NOT NULL REFERENCES opuscollege.sch_sponsor (id);
ALTER TABLE opuscollege.sch_sponsorpayment ADD COLUMN writeWho VARCHAR NOT NULL DEFAULT 'opuscollege';
ALTER TABLE opuscollege.sch_sponsorpayment ADD COLUMN writeWhen TIMESTAMP NOT NULL DEFAULT now();

CREATE SEQUENCE opuscollege.sch_sponsorpaymenttransfer_seq;
ALTER SEQUENCE opuscollege.sch_sponsorpaymenttransfer_seq OWNER TO postgres;

ALTER TABLE opuscollege.sch_sponsorpayment ADD COLUMN transferId integer;
UPDATE opuscollege.sch_sponsorpayment SET transferId = nextval('opuscollege.sch_sponsorpaymenttransfer_seq'::regclass);
ALTER TABLE opuscollege.sch_sponsorpayment ALTER COLUMN transferId SET NOT NULL;
ALTER TABLE opuscollege.sch_sponsorpayment ALTER COLUMN transferId SET DEFAULT nextval('opuscollege.sch_sponsorpaymenttransfer_seq'::regclass);

-------------------------------------------------------
-- table sch_sponsorinvoice
-------------------------------------------------------

CREATE SEQUENCE opuscollege.sch_sponsorinvoiceSeq;
ALTER SEQUENCE opuscollege.sch_sponsorinvoiceSeq OWNER TO postgres;

CREATE TABLE opuscollege.sch_sponsorinvoice
(
  id integer NOT NULL DEFAULT nextval('opuscollege.sch_sponsorinvoiceseq'),
  sponsorId integer NOT NULL,
  invoiceNumber integer UNIQUE,
  invoiceDate date,
  amount numeric(10,2),
  active CHAR(1) NOT NULL DEFAULT 'Y',
  writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
  writeWhen TIMESTAMP NOT NULL DEFAULT now(),
  
  CONSTRAINT sch_sponsorinvoice_pkey PRIMARY KEY (id ),
  CONSTRAINT sponsorId_fkey FOREIGN KEY (sponsorId)
      REFERENCES opuscollege.sch_sponsor (id)
);

ALTER TABLE opuscollege.sch_sponsorinvoice OWNER TO postgres;
GRANT ALL ON TABLE opuscollege.sch_sponsorinvoice TO postgres;

-------------------------------------------------------
-- table sch_scholarship
-------------------------------------------------------

CREATE SEQUENCE opuscollege.sch_scholarshiptransfer_seq;
ALTER SEQUENCE opuscollege.sch_scholarshiptransfer_seq OWNER TO postgres;

ALTER TABLE opuscollege.sch_scholarship ADD COLUMN transferId integer;
UPDATE opuscollege.sch_scholarship SET transferId = nextval('opuscollege.sch_scholarshiptransfer_seq'::regclass);
ALTER TABLE opuscollege.sch_scholarship ALTER COLUMN transferId SET NOT NULL;
ALTER TABLE opuscollege.sch_scholarship ALTER COLUMN transferId SET DEFAULT nextval('opuscollege.sch_scholarshiptransfer_seq'::regclass);

