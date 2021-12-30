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

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',2.2);

-------------------------------------------------------
-- table bloodType
-------------------------------------------------------
DELETE FROM opuscollege.bloodType;

INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','1','A');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','2','B');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','3','AB');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','4','0');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','5','unknown');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','6','A-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','7','A-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','8','B-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','9','B-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','10','AB-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','11','AB-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','12','0-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','13','0-Neg');

INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','1','A');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','2','B');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','3','AB');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','4','0');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','5','desconhecido');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','6','A-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','7','A-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','8','B-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','9','B-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','10','AB-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','11','AB-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','12','0-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','13','0-Neg');

-------------------------------------------------------
-- table academicyear - part 1
-------------------------------------------------------

DROP SEQUENCE IF EXISTS opuscollege.academicYearSeq CASCADE;

CREATE SEQUENCE opuscollege.academicYearSeq;
ALTER TABLE opuscollege.academicYearSeq OWNER TO postgres;

DROP TABLE IF EXISTS opuscollege.academicYear CASCADE;

CREATE TABLE opuscollege.academicYear (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.academicYearSeq'),
    description VARCHAR,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.academicYear OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.academicYear TO postgres;

INSERT INTO opuscollege.academicYear(description) (SELECT DISTINCT academicYear FROM opuscollege.studyplandetail);

-------------------------------------------------------
-- table academicyear - part 2
-------------------------------------------------------

ALTER TABLE opuscollege.studyPlanDetail ADD column academicYearId INTEGER NOT NULL DEFAULT 0;

UPDATE opuscollege.studyPlanDetail 
SET academicYearId = 
    (SELECT id from opuscollege.academicYear 
        WHERE description = opuscollege.studyPlanDetail.academicYear)
WHERE academicYear = 
    (SELECT description from opuscollege.academicYear 
        WHERE description = opuscollege.studyPlanDetail.academicYear)
;

DELETE FROM opuscollege.academicYear WHERE description IS NULL OR description = '';

ALTER TABLE opuscollege.studyPlanDetail DROP column academicYear;

-------------------------------------------------------
-- table academicyear - part 3
-------------------------------------------------------

ALTER TABLE opuscollege.academicYear ADD COLUMN code VARCHAR NOT NULL DEFAULT '';
ALTER TABLE opuscollege.academicYear ADD COLUMN lang CHAR(2) NOT NULL DEFAULT '';

UPDATE opuscollege.academicYear SET code = id;

UPDATE opuscollege.academicYear SET lang = 'pt';

-- http://msdn.microsoft.com/en-us/library/aa977880(VS.71).aspx
INSERT INTO opuscollege.academicYear (description, active, code,lang)
   SELECT description,active,code,'en' FROM opuscollege.academicYear;

-------------------------------------------------------
-- table academicyear - part 4
-------------------------------------------------------
ALTER TABLE opuscollege.studyPlanDetail ADD column academicYearCode VARCHAR NOT NULL DEFAULT '';

UPDATE opuscollege.studyPlanDetail 
SET academicYearCode = 
    (SELECT code from opuscollege.academicYear 
        WHERE opuscollege.academicYear.code = opuscollege.studyPlanDetail.academicYearId AND lang = 'en')
WHERE academicYearId = 
    (SELECT code from opuscollege.academicYear 
        WHERE opuscollege.academicYear.code = opuscollege.studyPlanDetail.academicYearId AND lang = 'en')
;

ALTER TABLE opuscollege.studyPlanDetail DROP column academicYearId;

