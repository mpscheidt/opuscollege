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

-- Opus College (c) UCI - Janneke Nooitgedagt
--
-- KERNEL opuscollege / MODULE - : privileges
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.48);

-------------------------------------------------------
-- table studyGradeType
-------------------------------------------------------
ALTER TABLE opuscollege.studygradetype ADD COLUMN maxnumberofstudents integer DEFAULT 0;

-------------------------------------------------------
-- table admissionRegistrationConfig
-------------------------------------------------------
ALTER TABLE opuscollege.admissionRegistrationConfig ADD COLUMN startOfRefundPeriod DATE;
ALTER TABLE opuscollege.admissionRegistrationConfig ADD COLUMN endOfRefundPeriod DATE;

-------------------------------------------------------
-- table student
-------------------------------------------------------
ALTER TABLE opuscollege.student ADD COLUMN fathertelephone character varying;
ALTER TABLE opuscollege.student ADD COLUMN mothertelephone character varying;

-------------------------------------------------------
-- table studentActivity
-------------------------------------------------------
CREATE SEQUENCE opuscollege.studentActivitySeq;
ALTER TABLE opuscollege.studentActivitySeq OWNER TO postgres;

CREATE TABLE opuscollege.studentActivity (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studentActivitySeq'),
    studentid integer NOT NULL,
    description character varying,
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.studentActivity OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.studentActivity TO postgres;

-------------------------------------------------------
-- table studentCareer
-------------------------------------------------------
CREATE SEQUENCE opuscollege.studentCareerSeq;
ALTER TABLE opuscollege.studentCareerSeq OWNER TO postgres;

CREATE TABLE opuscollege.studentCareer (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studentCareerSeq'),
    studentid integer NOT NULL,
    description character varying,
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.studentCareer OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.studentCareer TO postgres;

-------------------------------------------------------
-- table studentCounseling
-------------------------------------------------------
CREATE SEQUENCE opuscollege.studentCounselingSeq;
ALTER TABLE opuscollege.studentCounselingSeq OWNER TO postgres;

CREATE TABLE opuscollege.studentCounseling (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studentCounselingSeq'),
    studentid integer NOT NULL,
    description character varying,
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.studentCounseling OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.studentCounseling TO postgres;

-------------------------------------------------------
-- table studentPlacement
-------------------------------------------------------
CREATE SEQUENCE opuscollege.studentPlacementSeq;
ALTER TABLE opuscollege.studentPlacementSeq OWNER TO postgres;

CREATE TABLE opuscollege.studentPlacement (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studentPlacementSeq'),
    studentid integer NOT NULL,
    description character varying,
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.studentPlacement OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.studentPlacement TO postgres;

-------------------------------------------------------
-- neutral super admin user instead of Sata
-------------------------------------------------------
UPDATE opuscollege.person 
        set surnamefull = 'Admin101', firstnamesfull = 'M.M.J.', firstnamesalias = 'M.M.', birthdate = '1950-01-01'
        where surnamefull = 'Sata' and firstnamesfull = 'Michael Chilufya';
UPDATE opuscollege.opususer set username = 'Admin101' where username = 'SATA';
UPDATE opuscollege.opususerrole set username = 'Admin101' where username = 'SATA'; 
UPDATE opuscollege.opususer set pw = '573d9378d0cda4bf2546007b5ac7661d' where username = 'SATA';

-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_NOTES','en','Y','Read notes on career interests, activities and placements of students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDENT_NOTES','en','Y','Create notes on career interests, activities and placements of students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_NOTES','en','Y','Alter notes on career interests, activities and placements of students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENT_NOTES','en','Y','Delete notes on career interests, activities and placements of students');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_COUNSELING','en','Y','Read notes on counseling of students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDENT_COUNSELING','en','Y','Create notes on counseling of students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_COUNSELING','en','Y','Alter notes on counseling of students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENT_COUNSELING','en','Y','Delete notes on counseling of students');

-------------------------------------------------------
-- table opusrole_privilege
-------------------------------------------------------

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','READ_STUDENT_NOTES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','CREATE_STUDENT_NOTES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','UPDATE_STUDENT_NOTES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','DELETE_STUDENT_NOTES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDENT_NOTES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDENT_NOTES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDENT_NOTES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STUDENT_NOTES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STUDENT_NOTES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','CREATE_STUDENT_NOTES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','UPDATE_STUDENT_NOTES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','DELETE_STUDENT_NOTES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STUDENT_COUNSELING');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','CREATE_STUDENT_COUNSELING');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','UPDATE_STUDENT_COUNSELING');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','DELETE_STUDENT_COUNSELING');

-------------------------------------------------------
-- table appConfig
-------------------------------------------------------
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'smtpServerAdress','smtp.ru.nl');

INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'smtpBulkServerAdress','smtp-bulk.ru.nl');
    
-------------------------------------------------------
-- table opusrole_privilege
-------------------------------------------------------

DELETE FROM opuscollege.opusrole_privilege where privilegeCode = 'TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BA_BSC'
    AND role = 'finance';
DELETE FROM opuscollege.opusrole_privilege where privilegecode = 'TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MA_MSC'
    AND role = 'finance';
DELETE FROM opuscollege.opusrole_privilege where privilegecode = 'FINALIZE_CONTINUED_REGISTRATION_FLOW'
    AND role = 'finance';
    