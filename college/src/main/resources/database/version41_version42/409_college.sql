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
-- Author: Markus Pscheidt
-- Date:   2013-02-17
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion)
VALUES('college','A','Y',4.09);


-- table opusprivilege
-------------------------------------------------------
DELETE FROM opuscollege.opusprivilege where code = 'UPDATE_RESULT_VISIBILITY';
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_RESULT_VISIBILITY','en','Y','Update result visibility for students');

DELETE FROM opuscollege.opusprivilege where code = 'CREATE_RESULT_VISIBILITY';
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_RESULT_VISIBILITY','en','Y','Add result visibility for students');

DELETE FROM opuscollege.opusprivilege where code = 'DELETE_RESULT_VISIBILITY';
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_RESULT_VISIBILITY','en','Y','Delete result visibility for students');

-------------------------------------------------------
-- table opusrole_privilege
-------------------------------------------------------
DELETE FROM opuscollege.opusrole_privilege where privilegecode = 'UPDATE_RESULT_VISIBILITY';
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','UPDATE_RESULT_VISIBILITY');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_RESULT_VISIBILITY');

DELETE FROM opuscollege.opusrole_privilege where privilegecode = 'CREATE_RESULT_VISIBILITY';
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','CREATE_RESULT_VISIBILITY');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_RESULT_VISIBILITY');

DELETE FROM opuscollege.opusrole_privilege where privilegecode = 'DELETE_RESULT_VISIBILITY';
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','DELETE_RESULT_VISIBILITY');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_RESULT_VISIBILITY');

-------------------------------------------------------
-- sequence branchAcademicYearTimeUnitseq
-------------------------------------------------------
CREATE SEQUENCE opuscollege.branchAcademicYearTimeUnitseq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE opuscollege.branchAcademicYearTimeUnitseq OWNER TO postgres;

-------------------------------------------------------
-- table branchAcademicYearTimeUnit
-------------------------------------------------------
CREATE TABLE opuscollege.branchAcademicYearTimeUnit
(
  id integer NOT NULL DEFAULT nextval('opuscollege.branchAcademicYearTimeUnitseq'::regclass),
  branchId integer NOT NULL,
  academicYearId integer NOT NULL,
  cardinalTimeUnitCode character varying NOT NULL,
  cardinalTimeUnitNumber integer NOT NULL,
  resultsPublishDate date,
  active character(1) NOT NULL DEFAULT 'Y'::bpchar,
  CONSTRAINT branchAcademicYearTimeUnit_pkey PRIMARY KEY (id),
  CONSTRAINT academicYear_fkey FOREIGN KEY (academicYearId)
      REFERENCES opuscollege.academicYear (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT branch_fkey FOREIGN KEY (branchId)
      REFERENCES opuscollege.branch (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE opuscollege.branchAcademicYearTimeUnit OWNER TO postgres;

-------------------------------------------------------
-- table appConfig
-------------------------------------------------------
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('1970-01-01',NULL,'defaultResultsPublishDate','2099-01-01');
