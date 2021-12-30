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

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.46);

-------------------------------------------------------
-- table appConfig
-------------------------------------------------------
ALTER TABLE opuscollege.appConfig ADD column startDate DATE;
ALTER TABLE opuscollege.appConfig ADD column endDate DATE;

UPDATE opuscollege.appConfig set startDate = '2011-01-01';

ALTER TABLE opuscollege.appconfig DROP CONSTRAINT appconfig_pkey;
ALTER TABLE opuscollege.appconfig
    ADD CONSTRAINT appconfig_pkey PRIMARY KEY (startDate, appConfigAttributeName);

    
INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    VALUES ('2011-01-01',NULL,'numberOfSubjectsToGrade',5);

INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    SELECT '2011-01-01','2011-12-31','academicYearOfAdmission', id FROM opuscollege.academicYear where description = '2012';

INSERT INTO opuscollege.appConfig (startdate, enddate, appConfigAttributeName, appConfigAttributeValue)
    SELECT '2012-01-01','2012-12-31','academicYearOfAdmission', id FROM opuscollege.academicYear where description = '2013';

-------------------------------------------------------
-- table admissionRegistrationConfig
-------------------------------------------------------
ALTER TABLE opuscollege.organizationalunitacademicyear RENAME TO admissionRegistrationConfig;

ALTER TABLE opuscollege.admissionRegistrationConfig ADD COLUMN startOfAdmission DATE;
ALTER TABLE opuscollege.admissionRegistrationConfig ADD COLUMN endOfAdmission DATE;

CREATE SEQUENCE opuscollege.studentbalance_seq;
ALTER TABLE opuscollege.studentbalance_seq OWNER TO postgres;

-------------------------------------------------------
-- table studentbalance
-------------------------------------------------------
CREATE TABLE opuscollege.studentbalance (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.studentbalance_seq'),
    studentId INTEGER NOT NULL DEFAULT 0,
    feeId INTEGER NOT NULL DEFAULT 0,
    studyPlanCardinalTimeUnitId INTEGER NOT NULL DEFAULT 0,
    studyPlanDetailId INTEGER NOT NULL DEFAULT 0,
    academicYearId INTEGER NOT NULL DEFAULT 0,
    exemption character(1) NOT NULL DEFAULT 'N',
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.studentbalance OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE,REFERENCES, TRIGGER ON TABLE opuscollege.studentbalance TO postgres;
