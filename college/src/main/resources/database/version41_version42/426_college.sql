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
-- Author: Norbert Harrer
-- Date:   2013-09-16
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

UPDATE opuscollege.appVersions SET dbVersion = 4.26 WHERE lower(module) = 'college';

-------------------------------------------------------
-- table classgroup for classes feature
-------------------------------------------------------

CREATE SEQUENCE opuscollege.classgroupseq;
ALTER TABLE opuscollege.classgroupseq OWNER TO postgres;

CREATE TABLE opuscollege.classgroup
(
  id integer NOT NULL DEFAULT nextval('opuscollege.classgroupseq'::regclass),
  description character varying,
  studygradetypeid integer NOT NULL,
  writewho character varying NOT NULL DEFAULT 'opuscollege'::character varying,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),
  --
  CONSTRAINT classgroup_pkey PRIMARY KEY (id),
  CONSTRAINT classgroup_studygradetypeid_fkey FOREIGN KEY (studygradetypeid)
      REFERENCES opuscollege.studygradetype (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);
ALTER TABLE opuscollege.testteacher OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.classgroup TO postgres;

----------------------------------------------------------------------
-- table studentclassgroup: m:n releationship  student <-> classgroup
----------------------------------------------------------------------

CREATE SEQUENCE opuscollege.studentclassgroupseq;
ALTER TABLE opuscollege.studentclassgroupseq OWNER TO postgres;

CREATE TABLE opuscollege.studentclassgroup
(
  id integer NOT NULL DEFAULT nextval('opuscollege.studentclassgroupseq'::regclass),
  studentid integer NOT NULL,
  classgroupid integer NOT NULL,
  writewho character varying NOT NULL DEFAULT 'opuscollege'::character varying,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),
  --
  CONSTRAINT studentclassgroup_pkey PRIMARY KEY (id),
  CONSTRAINT studentclassgroup_studentid_fkey FOREIGN KEY (studentid)
      REFERENCES opuscollege.student (studentid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT studentclassgroup_classgroupid_fkey FOREIGN KEY (classgroupid)
      REFERENCES opuscollege.classgroup (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);
ALTER TABLE opuscollege.studentclassgroup OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.studentclassgroup TO postgres;

----------------------------------------------------------------------
-- table subjectclassgroup: m:n releationship  subject <-> classgroup
----------------------------------------------------------------------

CREATE SEQUENCE opuscollege.subjectclassgroupseq;
ALTER TABLE opuscollege.subjectclassgroupseq OWNER TO postgres;

CREATE TABLE opuscollege.subjectclassgroup
(
  id integer NOT NULL DEFAULT nextval('opuscollege.subjectclassgroupseq'::regclass),
  subjectid integer NOT NULL,
  classgroupid integer NOT NULL,
  writewho character varying NOT NULL DEFAULT 'opuscollege'::character varying,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),
  --
  CONSTRAINT subjectclassgroup_pkey PRIMARY KEY (id),
  CONSTRAINT subjectclassgroup_subjectid_fkey FOREIGN KEY (subjectid)
      REFERENCES opuscollege.subject (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT subjectclassgroup_classgroupid_fkey FOREIGN KEY (classgroupid)
      REFERENCES opuscollege.classgroup (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);
ALTER TABLE opuscollege.subjectclassgroup OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.subjectclassgroup TO postgres;

----------------------------------------------------------------------
-- references to classgroup in subjectteacher, examinationteacher 
-- and testteacher
----------------------------------------------------------------------

ALTER TABLE opuscollege.subjectteacher ADD COLUMN classgroupid integer REFERENCES opuscollege.classgroup(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE opuscollege.examinationteacher ADD COLUMN classgroupid integer REFERENCES opuscollege.classgroup(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE opuscollege.testteacher ADD COLUMN classgroupid integer REFERENCES opuscollege.classgroup(id) ON UPDATE CASCADE ON DELETE CASCADE;
