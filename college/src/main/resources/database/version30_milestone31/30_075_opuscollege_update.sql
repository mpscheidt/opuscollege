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

-- Opus College
-- KERNEL opuscollege / MODULE college
--
-- Initial author: Markus Pscheidt

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.15);



-- Sequences

DROP SEQUENCE IF EXISTS opuscollege.studentstatusseq CASCADE;
CREATE SEQUENCE opuscollege.studentstatusseq;

DROP SEQUENCE IF EXISTS opuscollege.studentstudentstatusseq CASCADE;
CREATE SEQUENCE opuscollege.studentstudentstatusseq;


-- Table: opuscollege.studentStatus

DROP TABLE IF EXISTS opuscollege.studentStatus;

CREATE TABLE opuscollege.studentStatus
(
  id integer NOT NULL DEFAULT nextval('opuscollege.studentstatusseq'::regclass),
  code character varying NOT NULL,
  lang character(2) NOT NULL,
  active character(1) NOT NULL DEFAULT 'Y'::bpchar,
  description character varying,
  writewho character varying NOT NULL DEFAULT 'opuscollege'::character varying,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT studentStatus_pkey PRIMARY KEY (id, lang),
  CONSTRAINT studentStatus_id_key UNIQUE (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE opuscollege.studentStatus OWNER TO postgres;
GRANT ALL ON TABLE opuscollege.studentStatus TO postgres;


INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('studentStatus'   , 'Lookup'  , 'Y');


-- insert some standard values 
-- (with the same codes as previously in the status table to ease upgrades)
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('en','1','active');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('en','5','deceased');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('en','101','expelled');

INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('pt','1','activo');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('pt','5','falecido');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('pt','101','expulso');


-- Table: opuscollege.studentstudentstatus

DROP TABLE IF EXISTS opuscollege.studentStudentStatus;

CREATE TABLE opuscollege.studentStudentStatus
(
  id integer NOT NULL DEFAULT nextval('opuscollege.studentstudentstatusseq'::regclass),
  studentId integer NOT NULL,
  startDate date,
  studentStatusCode character varying,
  writeWho character varying NOT NULL DEFAULT 'opuscollege'::character varying,
  writeWhen timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT studentstudentstatus_pkey PRIMARY KEY (id),
  CONSTRAINT studentstudentstatus_studentid_fkey FOREIGN KEY (studentid)
      REFERENCES opuscollege.student (studentid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE opuscollege.studentStudentStatus OWNER TO postgres;
GRANT ALL ON TABLE opuscollege.studentStudentStatus TO postgres;


-- Table: opuscollege.examinationResultHistory

DROP TABLE IF EXISTS opuscollege.examinationResultHistory;

CREATE TABLE opuscollege.examinationResultHistory
(
  id integer NOT NULL,
  examinationid integer NOT NULL,
  subjectid integer NOT NULL,
  studyplandetailid integer NOT NULL,
  examinationresultdate date,
  attemptnr integer NOT NULL,
  mark character varying,
  staffmemberid integer NOT NULL,
  active character(1) NOT NULL,
  writewho character varying NOT NULL,
  writewhen timestamp without time zone NOT NULL,
  passed character(1) NOT NULL,
  CONSTRAINT examinationResultHistory_pkey PRIMARY KEY (id, writewhen),
  CONSTRAINT examinationResultHistory_examinationid_fkey FOREIGN KEY (examinationid)
      REFERENCES opuscollege.examination (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT examinationResultHistory_staffmemberid_fkey FOREIGN KEY (staffmemberid)
      REFERENCES opuscollege.staffmember (staffmemberid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT examinationResultHistory_studyplandetailid_fkey FOREIGN KEY (studyplandetailid)
      REFERENCES opuscollege.studyplandetail (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT examinationResultHistory_subjectid_fkey FOREIGN KEY (subjectid)
      REFERENCES opuscollege.subject (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT examinationResultHistory_examinationattemptnr_key UNIQUE (examinationid, subjectid, studyplandetailid, attemptnr)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE opuscollege.examinationResultHistory OWNER TO postgres;
GRANT ALL ON TABLE opuscollege.examinationResultHistory TO postgres;


-----------------------------------------------------
-- allow to store country variation of user language
-- e.g. en_ZM stands for Zambian variation of English
-----------------------------------------------------
ALTER TABLE opuscollege.opususer ALTER COLUMN lang TYPE character(5);

