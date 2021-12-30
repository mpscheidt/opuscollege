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

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.23);

-----------------------------------------------------------
-- lookup TABLE progressStatus -> lookup7 table
-----------------------------------------------------------
ALTER TABLE opuscollege.progressStatus  ADD column continuing CHAR(1) NOT NULL DEFAULT 'N';
ALTER TABLE opuscollege.progressStatus  ADD column increment CHAR(1) NOT NULL DEFAULT 'N';
ALTER TABLE opuscollege.progressStatus  ADD column graduating CHAR(1) NOT NULL DEFAULT 'N';
ALTER TABLE opuscollege.progressStatus  ADD column carrying CHAR(1) NOT NULL DEFAULT 'N';

UPDATE opuscollege.lookuptable SET lookupType = 'Lookup7' where tableName = 'progressStatus';

-----------------------------------------------------------
-- lookup TABLE progressStatus, which shows the status of a CTU in a studyplan
-----------------------------------------------------------
DELETE FROM opuscollege.progressStatus where lang='en';

INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','01','Clear pass','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','27','Proceed & Repeat','Y','Y','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','29','To Part-time','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','19','At Part-time','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','31','To Full-time','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','03','Repeat','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','35','Exclude program','Y','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','34','Exclude school','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','22','Exclude university','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','23','Withdrawn with permission','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','25','Graduate','N','N','Y','N');

-------------------------------------------------------
-- table cardinalTimeUnitResult
-------------------------------------------------------
ALTER table opuscollege.cardinalTimeUnitResult ADD column mark VARCHAR;
ALTER table opuscollege.cardinalTimeUnitResult DROP column endGrade;

-------------------------------------------------------
-- table endGrade
-------------------------------------------------------
ALTER table opuscollege.endGrade ADD column passed CHAR(1) NOT NULL DEFAULT 'N';

-------------------------------------------------------
-- table subject
-------------------------------------------------------
ALTER TABLE opuscollege.subject DROP CONSTRAINT subject_subjectcode_currentacademicyearid_key;
ALTER TABLE opuscollege.subject ADD CONSTRAINT subject_subjectcode_subjectdescription_currentacademicyearid_key UNIQUE (subjectcode, subjectdescription, currentacademicyearid);

-------------------------------------------------------
-- table studentStatus
-------------------------------------------------------
DELETE FROM opuscollege.studentStatus where lang='en';

INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('en','1','active');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('en','5','deceased');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('en','101','expelled');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('en','102','suspended');



