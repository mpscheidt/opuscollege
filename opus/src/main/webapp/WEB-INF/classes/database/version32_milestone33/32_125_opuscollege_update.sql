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

-- Opus College (c) UCI - Markus Pscheidt
--
-- KERNEL opuscollege
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.50);

-------------------------------------------------------
-- Table: lookuptable
-------------------------------------------------------

UPDATE opuscollege.lookuptable SET tableName = 'functionLevel' where tableName = 'functionLevel';

-------------------------------------------------------
-- table studyYear, subjectStudyYear, subjectblockstudyyear
-------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.studyyear;
DROP TABLE IF EXISTS opuscollege.subjectstudyyear;
DROP TABLE IF EXISTS opuscollege.subjectblockstudyyear;

DELETE FROM opuscollege.tabledependency where dependenttable = 'studyYear';
DELETE FROM opuscollege.tabledependency where dependenttable = 'subjectStudyYear';
DELETE FROM opuscollege.tabledependency where dependenttable = 'subjectBlockStudyYear';

-------------------------------------------------------
-- table mailConfig
-------------------------------------------------------
CREATE SEQUENCE opuscollege.mailConfigSeq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE TABLE opuscollege.mailConfig (
    id integer DEFAULT nextval('opusCollege.mailConfigSeq'::regclass) NOT NULL,
    msgType character varying DEFAULT ''::character varying NOT NULL,
    msgSubject character varying DEFAULT ''::character varying NOT NULL,
    msgBody character varying DEFAULT ''::character varying NOT NULL,
    msgSender character varying DEFAULT ''::character varying NOT NULL,
    lang CHAR(6) NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
     --
    PRIMARY KEY(id)
);

ALTER TABLE opuscollege.mailConfig OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.mailConfig TO postgres;

-------------------------------------------------------
-- table logMailError
-------------------------------------------------------
CREATE SEQUENCE opuscollege.logMailErrorSeq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE TABLE opuscollege.logMailError (
    id integer DEFAULT nextval('opusCollege.logMailErrorSeq'::regclass) NOT NULL,
    recipients character varying DEFAULT ''::character varying NOT NULL,
    msgSubject character varying DEFAULT ''::character varying NOT NULL,
    msgSender character varying DEFAULT ''::character varying NOT NULL,
    errorMsg character varying DEFAULT ''::character varying NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
     --
    PRIMARY KEY(id)
);

ALTER TABLE opuscollege.logMailError OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.logMailError TO postgres;

-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_FINANCE','en','Y','Read information in the financial module');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_FINANCE','en','Y','Create information in the financial module');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_FINANCE','en','Y','Update information in the financial module');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_FINANCE','en','Y','Delete information in the financial module');

-------------------------------------------------------
-- table opusrole_privilege
-------------------------------------------------------
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','READ_FINANCE');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','CREATE_FINANCE');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','UPDATE_FINANCE');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','DELETE_FINANCE');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_FINANCE');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_FINANCE');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_FINANCE');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_FINANCE');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_FINANCE');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_FINANCE');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_FINANCE');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_FINANCE');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_FINANCE');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','CREATE_FINANCE');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','UPDATE_FINANCE');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','DELETE_FINANCE');

-------------------------------------------------------
-- table appConfig
-------------------------------------------------------
DELETE FROM opuscollege.appConfig where lower(appConfigAttributeName) = 'numberofsubjectstocountforstudyplanmark';

-------------------------------------------------------
-- table opusrole_privilege
-------------------------------------------------------
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','TRANSFER_CURRICULUM');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','TRANSFER_STUDENTS');

-------------------------------------------------------
-- table opusrole_privilege
-------------------------------------------------------
DELETE FROM opuscollege.opusprivilege WHERE code = 'ENTER_EXAM_RESULTS';
DELETE FROM opuscollege.opusrole_privilege WHERE privilegecode = 'ENTER_EXAM_RESULTS';
DELETE FROM opuscollege.opusprivilege WHERE code = 'ENTER_SUBJECT_RESULTS';
DELETE FROM opuscollege.opusrole_privilege WHERE privilegecode = 'ENTER_SUBJECT_RESULTS';
DELETE FROM opuscollege.opusprivilege WHERE code = 'ENTER_TEST_RESULTS';
DELETE FROM opuscollege.opusrole_privilege WHERE privilegecode = 'ENTER_TEST_RESULTS';

DELETE FROM opuscollege.opusprivilege where code = 'CREATE_TESTS';
DELETE FROM opuscollege.opusrole_privilege where privilegecode = 'CREATE_TESTS';
DELETE FROM opuscollege.opusprivilege where code = 'CREATE_EXAMINATIONS';
DELETE FROM opuscollege.opusrole_privilege where privilegecode = 'CREATE_EXAMINATIONS';

DELETE FROM opuscollege.opusprivilege where code = 'DELETE_STUDYPLAN_RESULTS';
DELETE FROM opuscollege.opusrole_privilege where privilegecode = 'DELETE_STUDYPLAN_RESULTS';

DELETE FROM opuscollege.opusprivilege where code = 'TRANSFER_SUBJECTS';
DELETE FROM opuscollege.opusrole_privilege where privilegecode = 'TRANSFER_SUBJECTS';

DELETE FROM opuscollege.opusprivilege where code = 'DELETE_STUDENT_SUBSCRIPTION_DATA';
DELETE FROM opuscollege.opusrole_privilege where privilegecode = 'DELETE_STUDENT_SUBSCRIPTION_DATA';

DELETE FROM opuscollege.opusprivilege where code = 'SET_CARDINALTIMEUNIT_ACTIVELY_REGISTERED';
DELETE FROM opuscollege.opusrole_privilege where privilegecode = 'SET_CARDINALTIMEUNIT_ACTIVELY_REGISTERED';

UPDATE opuscollege.opusrole_privilege SET privilegecode = 'UPDATE_FEES' where privilegecode = 'UPDATE__FEES';

-------------------------------------------------------
-- table lookuptable
-------------------------------------------------------
UPDATE opuscollege.lookuptable SET active = 'N' where lower(tablename) = 'gender';
