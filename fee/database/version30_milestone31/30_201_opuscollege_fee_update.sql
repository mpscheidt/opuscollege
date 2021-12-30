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

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'fee';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('fee','A','Y',3.01);
-------------------------------------------------------
-- Table and sequence: opuscollege.fee_feecategory
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.fee_feecategorySeq  CASCADE;
CREATE SEQUENCE opuscollege.fee_feecategorySeq;
ALTER TABLE opuscollege.fee_feecategorySeq OWNER TO postgres;

DROP TABLE IF EXISTS opuscollege.fee_feecategory;
CREATE TABLE opuscollege.fee_feecategory
(
  id integer NOT NULL DEFAULT nextval('opuscollege.fee_feecategorySeq'::regclass),
  code character varying NOT NULL,
  lang character(2) NOT NULL,
  active character(1) NOT NULL DEFAULT 'Y'::bpchar,
  description character varying,
  writewho character varying NOT NULL DEFAULT 'opuscollege'::character varying,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT fee_feecategory_pkey PRIMARY KEY (id, lang),
  CONSTRAINT fee_feecategory_id_key UNIQUE (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE opuscollege.fee_feecategory OWNER TO postgres;
GRANT ALL ON TABLE opuscollege.fee_feecategory TO postgres;

-------------------------------------------------------
-- TABLE all lookup tables
-------------------------------------------------------
ALTER TABLE opuscollege.fee_feeCategory ALTER COLUMN lang TYPE CHAR(6);
