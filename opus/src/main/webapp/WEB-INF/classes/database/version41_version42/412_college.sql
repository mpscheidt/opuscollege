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
 * The Original Code is Opus-College college module code.
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
-- Author: Janneke Nooitgedagt
-- Date:   2013-05-02
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion)
VALUES('college','A','Y',4.12);

-------------------------------------------------------
-- table gradetype
-------------------------------------------------------
ALTER TABLE opuscollege.gradetype ADD COLUMN educationAreaCode character varying;
-- ALTER TABLE opuscollege.gradetype RENAME titleshort TO educationlevel;


--------------------------------------------------------------------
-- table educationArea and educationLevel
--------------------------------------------------------------------

-- sequences
CREATE SEQUENCE opuscollege.educationareaseq
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;
	
CREATE SEQUENCE opuscollege.educationlevelseq
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

-- tables
CREATE TABLE opuscollege.educationArea
(
  id integer NOT NULL DEFAULT nextval('opuscollege.educationareaseq'::regclass),
  code character varying NOT NULL,
  lang character(6) NOT NULL,
  active character(1) NOT NULL DEFAULT 'Y'::bpchar,
  description character varying,
  writewho character varying NOT NULL DEFAULT 'opuscollege'::character varying,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),
  --
  PRIMARY KEY(id, lang),
  UNIQUE(id)
);
ALTER TABLE opuscollege.educationArea
  OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.educationArea TO postgres;


CREATE TABLE opuscollege.educationLevel
(
  id integer NOT NULL DEFAULT nextval('opuscollege.educationlevelseq'::regclass),
  code character varying NOT NULL,
  lang character(6) NOT NULL,
  active character(1) NOT NULL DEFAULT 'Y'::bpchar,
  description character varying,
  writewho character varying NOT NULL DEFAULT 'opuscollege'::character varying,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),
  --
  PRIMARY KEY(id, lang),
  UNIQUE(id)
);
ALTER TABLE opuscollege.educationLevel
  OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.educationLevel TO postgres;

-- inserts
insert into opuscollege.educationLevel (code, description, lang) values ('B', 'Bachelor', 'en');
insert into opuscollege.educationLevel (code, description, lang) values ('M', 'Master', 'en');
insert into opuscollege.educationLevel (code, description, lang) values ('B', 'Bachelor', 'pt');
insert into opuscollege.educationLevel (code, description, lang) values ('M', 'Master', 'pt');
insert into opuscollege.educationLevel (code, description, lang) values ('B', 'Bachelor', 'nl');
insert into opuscollege.educationLevel (code, description, lang) values ('M', 'Master', 'nl');

insert into opuscollege.educationArea (code, description, lang) values ('S', 'Science based', 'en');
insert into opuscollege.educationArea (code, description, lang) values ('A', 'Art based', 'en');
insert into opuscollege.educationArea (code, description, lang) values ('M', 'Medicine based', 'en');
insert into opuscollege.educationArea (code, description, lang) values ('S', 'Science based', 'pt');
insert into opuscollege.educationArea (code, description, lang) values ('A', 'Art based', 'pt');
insert into opuscollege.educationArea (code, description, lang) values ('M', 'Medicine based', 'pt');
insert into opuscollege.educationArea (code, description, lang) values ('S', 'Science based', 'nl');
insert into opuscollege.educationArea (code, description, lang) values ('A', 'Art based', 'nl');
insert into opuscollege.educationArea (code, description, lang) values ('M', 'Medicine based', 'nl');

--------------------------------------------------------------------
-- table lookuptable
--------------------------------------------------------------------
insert into opuscollege.lookuptable (tablename, lookuptype) values ('educationlevel', 'Lookup');
insert into opuscollege.lookuptable (tablename, lookuptype) values ('educationarea', 'Lookup');

