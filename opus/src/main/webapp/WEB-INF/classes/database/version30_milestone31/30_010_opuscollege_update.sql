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

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.02);

-------------------------------------------------------
-- sequences

-- sequence cardinaltimeunitseq
-------------------------------------------------------

DROP SEQUENCE IF EXISTS opuscollege.cardinaltimeunitseq CASCADE;

CREATE SEQUENCE opuscollege.cardinaltimeunitseq;
ALTER TABLE opuscollege.cardinaltimeunitseq OWNER TO postgres;

-------------------------------------------------------
-- tables

-- table cardinaltimeunit
-------------------------------------------------------
CREATE TABLE opuscollege.cardinaltimeunit (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.cardinaltimeunitSeq'),
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
ALTER TABLE opuscollege.cardinaltimeunit OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.cardinaltimeunit TO postgres;

INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('cardinaltimeunit', 'Lookup', 'Y');

-------------------------------------------------------
-- table subjectPrerequisite
-------------------------------------------------------
CREATE TABLE opuscollege.subjectPrerequisite
(
  subjectid int4 NOT NULL,
  subjectstudygradetypeid int4 NOT NULL,
  active char(1) NOT NULL DEFAULT 'Y'::bpchar,
  writewho varchar NOT NULL DEFAULT 'opuscollege'::character varying,
  writewhen timestamp NOT NULL DEFAULT now(),
  CONSTRAINT subjectprerequisite_pkey PRIMARY KEY (subjectid, subjectstudygradetypeid)
) 
WITHOUT OIDS;
ALTER TABLE opuscollege.subjectprerequisite OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.subjectprerequisite TO postgres;
-------------------------------------------------------
-- inserts

-- inserts into table cardinaltimeunit
-------------------------------------------------------
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description) VALUES ('en','1','year');
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description) VALUES ('pt','1','ano');
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description) VALUES ('nl','1','jaar');
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description) VALUES ('en','2','semester');
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description) VALUES ('pt','2','semestre');
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description) VALUES ('nl','2','semester');
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description) VALUES ('en','3','trimester');
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description) VALUES ('pt','3','trimestre');
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description) VALUES ('nl','3','trimester');

-------------------------------------------------------
-- table student
-------------------------------------------------------
ALTER table opuscollege.student ADD column foreignStudent char(1) NOT NULL DEFAULT 'N'::bpchar;

-------------------------------------------------------
-- table subjectBlock
-------------------------------------------------------
ALTER table opuscollege.subjectBlock RENAME column BRsApplyingToBlock TO BRsApplyingToSubjectBlock;
ALTER table opuscollege.subjectBlock ADD column BRsPassingSubjectBlock VARCHAR;
--ALTER table opuscollege.subjectBlock ADD column studyGradeTypeId INTEGER NOT NULL;
ALTER table opuscollege.subjectBlock ALTER targetGroupCode DROP NOT NULL;
ALTER table opuscollege.subjectBlock ADD column cardinalTimeUnitCode VARCHAR NOT NULL DEFAULT '1';
ALTER table opuscollege.subjectBlock ALTER cardinalTimeUnitCode DROP DEFAULT;

-------------------------------------------------------
-- table subjectBlockSubjectBlock
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.subjectblocksubjectblock CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.subjectBlockSubjectBlockSeq CASCADE;

-------------------------------------------------------
-- table studyGradeTypePrerequisite
-------------------------------------------------------
CREATE TABLE opuscollege.studyGradeTypePrerequisite
(
  studyGradeTypeid int4 NOT NULL,
  requiredStudyGradeTypeid int4 NOT NULL,
  active char(1) NOT NULL DEFAULT 'Y'::bpchar,
  writewho varchar NOT NULL DEFAULT 'opuscollege'::character varying,
  writewhen timestamp NOT NULL DEFAULT now(),
  CONSTRAINT studygradetypeprerequisite_pkey PRIMARY KEY (studyGradeTypeid, requiredStudyGradeTypeid)
) 
WITHOUT OIDS;
ALTER TABLE opuscollege.studyGradeTypePrerequisite OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.studyGradeTypePrerequisite TO postgres;

