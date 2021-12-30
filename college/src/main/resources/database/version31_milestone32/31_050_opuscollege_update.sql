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

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.22);

-------------------------------------------------------
-- table opususer
-------------------------------------------------------
ALTER TABLE opuscollege.opususer ADD COLUMN preferredOrganizationalUnitId INT NOT NULL DEFAULT 0;

-------------------------------------------------------
-- table gradeType
-------------------------------------------------------
DELETE FROM opuscollege.gradeType where lang='en';

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','SEC','Secondary school','sec.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','BSC','Bachelor of science','B.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','LIC','Licentiate','Lic..');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','MSC','Master of science','M.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','PHD','Doctor','Ph.D.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','BA','Bachelor of art','B.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','MA','Master of art','M.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','DA','Diploma other than maths and science','Dpl.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','DSC','Diploma maths and science','Dpl.M.Sc.');

UPDATE opuscollege.studyGradeType set gradeTypeCode = 'SEC' where gradeTypeCode = '2';
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'BSC' where gradeTypeCode = '3';
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'LIC' where gradeTypeCode = '4';
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'MSC' where gradeTypeCode = '5';
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'PHD' where gradeTypeCode = '6';
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'BA' where gradeTypeCode = '7';
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'MA' where gradeTypeCode = '8';
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'DA' where gradeTypeCode = '9';
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'DSC' where gradeTypeCode = '10';

UPDATE opuscollege.studyPlan set gradeTypeCode = 'SEC' where gradeTypeCode = '2';
UPDATE opuscollege.studyPlan set gradeTypeCode = 'BSC' where gradeTypeCode = '3';
UPDATE opuscollege.studyPlan set gradeTypeCode = 'LIC' where gradeTypeCode = '4';
UPDATE opuscollege.studyPlan set gradeTypeCode = 'MSC' where gradeTypeCode = '5';
UPDATE opuscollege.studyPlan set gradeTypeCode = 'PHD' where gradeTypeCode = '6';
UPDATE opuscollege.studyPlan set gradeTypeCode = 'BA' where gradeTypeCode = '7';
UPDATE opuscollege.studyPlan set gradeTypeCode = 'MA' where gradeTypeCode = '8';
UPDATE opuscollege.studyPlan set gradeTypeCode = 'DA' where gradeTypeCode = '9';
UPDATE opuscollege.studyPlan set gradeTypeCode = 'DSC' where gradeTypeCode = '10';

UPDATE opuscollege.person set gradeTypeCode = 'SEC' where gradeTypeCode = '2';
UPDATE opuscollege.person set gradeTypeCode = 'BSC' where gradeTypeCode = '3';
UPDATE opuscollege.person set gradeTypeCode = 'LIC' where gradeTypeCode = '4';
UPDATE opuscollege.person set gradeTypeCode = 'MSC' where gradeTypeCode = '5';
UPDATE opuscollege.person set gradeTypeCode = 'PHD' where gradeTypeCode = '6';
UPDATE opuscollege.person set gradeTypeCode = 'BA' where gradeTypeCode = '7';
UPDATE opuscollege.person set gradeTypeCode = 'MA' where gradeTypeCode = '8';
UPDATE opuscollege.person set gradeTypeCode = 'DA' where gradeTypeCode = '9';
UPDATE opuscollege.person set gradeTypeCode = 'DSC' where gradeTypeCode = '10';

-------------------------------------------------------
-- lookup table studyPlanStatus
-------------------------------------------------------
DELETE FROM opuscollege.studyPlanStatus where lang='en';

INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','1','Start initial admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','2','Waiting for payment initial admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','3','Approved initial admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','4','Rejected initial admission');

INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','10','Temporarily inactive');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','11','Graduated');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','12','Withdrawn');



-----------------------------------------------------------
-- sequence cardinalTimeUnitStatusSeq
-----------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.cardinalTimeUnitStatusSeq CASCADE;
CREATE SEQUENCE opuscollege.cardinalTimeUnitStatusSeq;
ALTER TABLE opuscollege.cardinalTimeUnitStatusSeq OWNER TO postgres;

-----------------------------------------------------------
-- lookup TABLE cardinalTimeUnitStatus
-----------------------------------------------------------
DROP TABLE IF EXISTS opuscollege.cardinalTimeUnitStatus CASCADE;
CREATE TABLE opuscollege.cardinalTimeUnitStatus (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.cardinalTimeUnitStatusSeq'),
    code VARCHAR NOT NULL,
	lang CHAR(2) NOT NULL,
    description VARCHAR,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id, lang),
    UNIQUE(id)
);
ALTER TABLE opuscollege.cardinalTimeUnitStatus OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.cardinalTimeUnitStatus TO postgres;

INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('cardinalTimeUnitStatus', 'Lookup', 'Y');

DELETE FROM opuscollege.cardinalTimeUnitStatus where lang='en';

INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','5','Start continued registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','6','Waiting for approval of registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','7','Request for change');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','8','Rejected registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','9','Approved registration (waiting for payment)');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','10','Actively registered');

-------------------------------------------------------
-- table studyplancardinaltimeunit
-------------------------------------------------------
ALTER TABLE opuscollege.studyplancardinaltimeunit ADD COLUMN cardinalTimeUnitStatusCode character varying;

