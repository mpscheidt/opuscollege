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
-- Date:   2013-08-18
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
UPDATE opuscollege.appVersions SET dbVersion = 4.27 WHERE lower(module) = 'college';


-------------------------------------------------------
-- table opuscollege.opusrole_privilege
-------------------------------------------------------

-- This script replicates the privileges to create/read/update/delete studyplan results to CTU results, subject results, examination results and test results.
-- This is done because the studyplan results privileges were used for all levels, but dedicated privileges have been created for each level.

-- CRUD cardinal time unit results
INSERT INTO opuscollege.opusrole_privilege (privilegecode, "role")
SELECT 'CREATE_CARDINALTIMEUNIT_RESULTS', "role" FROM opuscollege.opusrole_privilege WHERE privilegecode = 'CREATE_STUDYPLAN_RESULTS'
AND NOT EXISTS (
  SELECT * FROM opuscollege.opusrole_privilege orp WHERE orp.privilegecode = 'CREATE_CARDINALTIMEUNIT_RESULTS' and orp."role" = opusrole_privilege."role"
);

INSERT INTO opuscollege.opusrole_privilege (privilegecode, "role")
SELECT 'READ_CARDINALTIMEUNIT_RESULTS', "role" FROM opuscollege.opusrole_privilege WHERE privilegecode = 'READ_STUDYPLAN_RESULTS'
AND NOT EXISTS (
  SELECT * FROM opuscollege.opusrole_privilege orp WHERE orp.privilegecode = 'READ_CARDINALTIMEUNIT_RESULTS' and orp."role" = opusrole_privilege."role"
);

INSERT INTO opuscollege.opusrole_privilege (privilegecode, "role")
SELECT 'UPDATE_CARDINALTIMEUNIT_RESULTS', "role" FROM opuscollege.opusrole_privilege WHERE privilegecode = 'UPDATE_STUDYPLAN_RESULTS'
AND NOT EXISTS (
  SELECT * FROM opuscollege.opusrole_privilege orp WHERE orp.privilegecode = 'UPDATE_CARDINALTIMEUNIT_RESULTS' and orp."role" = opusrole_privilege."role"
);

INSERT INTO opuscollege.opusrole_privilege (privilegecode, "role")
SELECT 'DELETE_CARDINALTIMEUNIT_RESULTS', "role" FROM opuscollege.opusrole_privilege WHERE privilegecode = 'DELETE_STUDYPLAN_RESULTS'
AND NOT EXISTS (
  SELECT * FROM opuscollege.opusrole_privilege orp WHERE orp.privilegecode = 'DELETE_CARDINALTIMEUNIT_RESULTS' and orp."role" = opusrole_privilege."role"
);


-- CRUD subject results
INSERT INTO opuscollege.opusrole_privilege (privilegecode, "role")
SELECT 'CREATE_SUBJECTS_RESULTS', "role" FROM opuscollege.opusrole_privilege WHERE privilegecode = 'CREATE_STUDYPLAN_RESULTS'
AND NOT EXISTS (
  SELECT * FROM opuscollege.opusrole_privilege orp WHERE orp.privilegecode = 'CREATE_SUBJECTS_RESULTS' and orp."role" = opusrole_privilege."role"
);

INSERT INTO opuscollege.opusrole_privilege (privilegecode, "role")
SELECT 'READ_SUBJECTS_RESULTS', "role" FROM opuscollege.opusrole_privilege WHERE privilegecode = 'READ_STUDYPLAN_RESULTS'
AND NOT EXISTS (
  SELECT * FROM opuscollege.opusrole_privilege orp WHERE orp.privilegecode = 'READ_SUBJECTS_RESULTS' and orp."role" = opusrole_privilege."role"
);

INSERT INTO opuscollege.opusrole_privilege (privilegecode, "role")
SELECT 'UPDATE_SUBJECTS_RESULTS', "role" FROM opuscollege.opusrole_privilege WHERE privilegecode = 'UPDATE_STUDYPLAN_RESULTS'
AND NOT EXISTS (
  SELECT * FROM opuscollege.opusrole_privilege orp WHERE orp.privilegecode = 'UPDATE_SUBJECTS_RESULTS' and orp."role" = opusrole_privilege."role"
);

INSERT INTO opuscollege.opusrole_privilege (privilegecode, "role")
SELECT 'DELETE_SUBJECTS_RESULTS', "role" FROM opuscollege.opusrole_privilege WHERE privilegecode = 'DELETE_STUDYPLAN_RESULTS'
AND NOT EXISTS (
  SELECT * FROM opuscollege.opusrole_privilege orp WHERE orp.privilegecode = 'DELETE_SUBJECTS_RESULTS' and orp."role" = opusrole_privilege."role"
);

-- CRUD examination results
INSERT INTO opuscollege.opusrole_privilege (privilegecode, "role")
SELECT 'CREATE_EXAMINATION_RESULTS', "role" FROM opuscollege.opusrole_privilege WHERE privilegecode = 'CREATE_STUDYPLAN_RESULTS'
AND NOT EXISTS (
  SELECT * FROM opuscollege.opusrole_privilege orp WHERE orp.privilegecode = 'CREATE_EXAMINATION_RESULTS' and orp."role" = opusrole_privilege."role"
);

INSERT INTO opuscollege.opusrole_privilege (privilegecode, "role")
SELECT 'READ_EXAMINATION_RESULTS', "role" FROM opuscollege.opusrole_privilege WHERE privilegecode = 'READ_STUDYPLAN_RESULTS'
AND NOT EXISTS (
  SELECT * FROM opuscollege.opusrole_privilege orp WHERE orp.privilegecode = 'READ_EXAMINATION_RESULTS' and orp."role" = opusrole_privilege."role"
);

INSERT INTO opuscollege.opusrole_privilege (privilegecode, "role")
SELECT 'UPDATE_EXAMINATION_RESULTS', "role" FROM opuscollege.opusrole_privilege WHERE privilegecode = 'UPDATE_STUDYPLAN_RESULTS'
AND NOT EXISTS (
  SELECT * FROM opuscollege.opusrole_privilege orp WHERE orp.privilegecode = 'UPDATE_EXAMINATION_RESULTS' and orp."role" = opusrole_privilege."role"
);

INSERT INTO opuscollege.opusrole_privilege (privilegecode, "role")
SELECT 'DELETE_EXAMINATION_RESULTS', "role" FROM opuscollege.opusrole_privilege WHERE privilegecode = 'DELETE_STUDYPLAN_RESULTS'
AND NOT EXISTS (
  SELECT * FROM opuscollege.opusrole_privilege orp WHERE orp.privilegecode = 'DELETE_EXAMINATION_RESULTS' and orp."role" = opusrole_privilege."role"
);

-- CRUD test results
INSERT INTO opuscollege.opusrole_privilege (privilegecode, "role")
SELECT 'CREATE_TEST_RESULTS', "role" FROM opuscollege.opusrole_privilege WHERE privilegecode = 'CREATE_STUDYPLAN_RESULTS'
AND NOT EXISTS (
  SELECT * FROM opuscollege.opusrole_privilege orp WHERE orp.privilegecode = 'CREATE_TEST_RESULTS' and orp."role" = opusrole_privilege."role"
);

INSERT INTO opuscollege.opusrole_privilege (privilegecode, "role")
SELECT 'READ_TEST_RESULTS', "role" FROM opuscollege.opusrole_privilege WHERE privilegecode = 'READ_STUDYPLAN_RESULTS'
AND NOT EXISTS (
  SELECT * FROM opuscollege.opusrole_privilege orp WHERE orp.privilegecode = 'READ_TEST_RESULTS' and orp."role" = opusrole_privilege."role"
);

INSERT INTO opuscollege.opusrole_privilege (privilegecode, "role")
SELECT 'UPDATE_TEST_RESULTS', "role" FROM opuscollege.opusrole_privilege WHERE privilegecode = 'UPDATE_STUDYPLAN_RESULTS'
AND NOT EXISTS (
  SELECT * FROM opuscollege.opusrole_privilege orp WHERE orp.privilegecode = 'UPDATE_TEST_RESULTS' and orp."role" = opusrole_privilege."role"
);

INSERT INTO opuscollege.opusrole_privilege (privilegecode, "role")
SELECT 'DELETE_TEST_RESULTS', "role" FROM opuscollege.opusrole_privilege WHERE privilegecode = 'DELETE_STUDYPLAN_RESULTS'
AND NOT EXISTS (
  SELECT * FROM opuscollege.opusrole_privilege orp WHERE orp.privilegecode = 'DELETE_TEST_RESULTS' and orp."role" = opusrole_privilege."role"
);


