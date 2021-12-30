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
-- Author: Ben Mazyopa
-- Date: 2013-09-10
--

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
UPDATE opuscollege.appVersions SET dbVersion = 4.01 WHERE lower(module) = 'accommodation';

----------------------------------------------------
-- Create fresh sqeuences for acc_accommodationresource
-- and acc_studentaccommodationresource
----------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.acc_accommodationresourceseq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.acc_studentaccommodationresourceseq CASCADE;

CREATE SEQUENCE opuscollege.acc_accommodationresourceseq;
CREATE SEQUENCE opuscollege.acc_studentaccommodationresourceseq;

ALTER TABLE opuscollege.acc_accommodationresourceseq OWNER TO postgres;
ALTER TABLE opuscollege.acc_studentaccommodationresourceseq OWNER TO postgres;

-----------------------------------------------------
-- table acc_accommodationresource:: used to store 
-- various resources names which have to be allocated to 
-- a student 
-----------------------------------------------------
CREATE TABLE opuscollege.acc_accommodationresource
(
  id integer NOT NULL DEFAULT nextval('opuscollege.acc_accommodationresourceseq'::regclass),
  "name" varchar NOT NULL UNIQUE,
  description varchar,
  active char(1) NOT NULL DEFAULT 'Y',
  writewho character varying NOT NULL DEFAULT 'opuscollege-accommodation'::character varying,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),

  CONSTRAINT acc_accommodationresource_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

ALTER TABLE opuscollege.acc_accommodationresource OWNER TO postgres;
GRANT ALL ON TABLE opuscollege.acc_accommodationresource TO postgres;


-----------------------------------------------------
-- table acc_studentaccommodationresource:: used to store 
-- various allocated resources which have been assigned to a student.
-- It keeps tract of all allocated items to a student
-----------------------------------------------------
CREATE TABLE opuscollege.acc_studentaccommodationresource
(
  id integer NOT NULL DEFAULT nextval('opuscollege.acc_studentaccommodationresourceseq'::regclass),
  studentaccommodationid integer NOT NULL,
  accommodationresourceid integer NOT NULL DEFAULT 0,
  datecollected timestamp NOT NULL DEFAULT now(),
  datereturned timestamp,
  commentwhencollecting varchar(255),
  commentwhenreturning varchar(255),
  returned character(1) NOT NULL DEFAULT 'N'::bpchar,
  writewho character varying NOT NULL DEFAULT 'opuscollege-accommodation'::character varying,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),

  CONSTRAINT acc_studentaccommodationresource_pkey PRIMARY KEY (studentaccommodationid,accommodationresourceid),
  CONSTRAINT acc_studentaccommodationresource_studentaccommodationid_fkey FOREIGN KEY (studentaccommodationid)
      REFERENCES opuscollege.acc_studentaccommodation (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT acc_studentaccommodationresource_accommodationresourceid_fkey FOREIGN KEY (accommodationresourceid)
      REFERENCES opuscollege.acc_accommodationresource (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);

ALTER TABLE opuscollege.acc_studentaccommodationresource OWNER TO postgres;
GRANT ALL ON TABLE opuscollege.acc_studentaccommodationresource TO postgres;


--------------------------------------------------------
-- Insert several types of AccommodationResource
--------------------------------------------------------
INSERT INTO opuscollege.acc_accommodationresource ("name") VALUES('Matress');
INSERT INTO opuscollege.acc_accommodationresource ("name") VALUES('Curtain Net');
INSERT INTO opuscollege.acc_accommodationresource ("name") VALUES('Curtain (Normal)');
INSERT INTO opuscollege.acc_accommodationresource ("name") VALUES('Key');
INSERT INTO opuscollege.acc_accommodationresource ("name") VALUES('Study Lamp');
INSERT INTO opuscollege.acc_accommodationresource ("name") VALUES('Wall Switch');
INSERT INTO opuscollege.acc_accommodationresource ("name") VALUES('Wall Socket');
INSERT INTO opuscollege.acc_accommodationresource ("name") VALUES('Mortice-Lock');
INSERT INTO opuscollege.acc_accommodationresource ("name") VALUES('Pad-Lock');
INSERT INTO opuscollege.acc_accommodationresource ("name") VALUES('Bed (Single - Bed)');
INSERT INTO opuscollege.acc_accommodationresource ("name") VALUES('Bed (3 - Quarters)');
INSERT INTO opuscollege.acc_accommodationresource ("name") VALUES('Bed (Double Bed)');
INSERT INTO opuscollege.acc_accommodationresource ("name") VALUES('Dinning Chair');
INSERT INTO opuscollege.acc_accommodationresource ("name") VALUES('Chair (Standard)');
INSERT INTO opuscollege.acc_accommodationresource ("name") VALUES('Key-Blocker');
