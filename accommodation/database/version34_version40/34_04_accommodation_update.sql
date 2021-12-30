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
-- Date: 2012-07-07
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'accommodation';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('accommodation','A','Y',3.21);


-------------------------------------------------------
-- table audit.acc_hostel_hist
-------------------------------------------------------

-- DROP TABLE audit.acc_hostel_hist;

CREATE TABLE audit.acc_hostel_hist
(
  operation character(1) NOT NULL CHECK (operation IN ('I','D','U')),
  id integer  ,
  code character varying,
  description character varying,
  numberoffloors integer  ,
  hosteltypecode character varying ,
  writewho character varying  NOT NULL,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),
  active character(1) 

);

ALTER TABLE audit.acc_hostel_hist OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE audit.acc_hostel_hist TO postgres;

-------------------------------------------------------
-- table audit.acc_block_hist
-------------------------------------------------------

-- DROP TABLE audit.acc_block_hist;

CREATE TABLE audit.acc_block_hist
(
  operation character(1) NOT NULL CHECK (operation IN ('I','D','U')),
  id integer ,
  code character varying(30) ,
  description character varying(255) ,
  hostelid integer ,
  numberoffloors integer ,
  writewho character varying NOT NULL,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),
  active character(1)    
);

ALTER TABLE audit.acc_block_hist OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE audit.acc_block_hist TO postgres;

-------------------------------------------------------
-- table audit.acc_accommodationfee_hist
-------------------------------------------------------

-- DROP TABLE audit.acc_accommodationfee_hist;

CREATE TABLE audit.acc_accommodationfee_hist
(
  operation character(1) NOT NULL CHECK (operation IN ('I','D','U')),
  accommodationfeeid integer,
  hosteltypecode character varying ,
  roomtypecode character varying ,
  feeid integer ,
  writewho character varying NOT NULL,
  writewhen timestamp without time zone NOT NULL DEFAULT now()
);

ALTER TABLE audit.acc_accommodationfee_hist OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE audit.acc_accommodationfee_hist TO postgres;

-------------------------------------------------------
-- table audit.acc_room_hist
-------------------------------------------------------

-- DROP TABLE audit.acc_room_hist;

CREATE TABLE audit.acc_room_hist
(
  operation character(1) NOT NULL CHECK (operation IN ('I','D','U')),
  id integer ,
  code character varying ,
  description character varying ,
  numberofbedspaces integer,
  hostelid integer ,
  blockid integer ,
  floornumber integer ,
  writewho character varying ,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),
  active character(1) ,
  availablebedspace integer ,
  roomtypecode character varying 
);

ALTER TABLE audit.acc_room_hist OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE audit.acc_room_hist TO postgres;

-------------------------------------------------------
-- table audit.acc_studentaccommodation_hist
-------------------------------------------------------

-- DROP TABLE audit.acc_studentaccommodation_hist;

CREATE TABLE audit.acc_studentaccommodation_hist
(
  operation character(1) NOT NULL CHECK (operation IN ('I','D','U')),
  id integer ,
  studentid integer,
  bednumber integer,
  academicyearid integer,
  dateapplied date ,
  dateapproved date,
  approved character(1),
  approvedbyid integer ,
  accepted character(1),
  dateaccepted date,
  reasonforapplyingforaccommodation character varying,
  "comment" character varying,
  roomid integer ,
  writewho character varying NOT NULL,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),
  allocated character(1) ,
  datedeallocated date
);

ALTER TABLE audit.acc_studentaccommodation_hist OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE audit.acc_studentaccommodation_hist TO postgres;
