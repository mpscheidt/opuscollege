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

-- Opus College (c) UCI - Stelio
--
-- KERNEL opuscollege / MODULE - : lookup lang length changes
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.37);

-------------------------------------------------------
-- tables several lookups
-------------------------------------------------------
ALTER TABLE opuscollege.cardinaltimeunitstatus ALTER lang TYPE character(6);
ALTER TABLE opuscollege.endgrade ALTER lang TYPE character(6);
ALTER TABLE opuscollege.endgradegeneral ALTER lang TYPE character(6);
ALTER TABLE opuscollege.endgradetype ALTER lang TYPE character(6);
ALTER TABLE opuscollege.failgrade ALTER lang TYPE character(6);
ALTER TABLE opuscollege.sch_complaintstatus ALTER lang TYPE character(6);
ALTER TABLE opuscollege.sch_decisioncriteria ALTER lang TYPE character(6);
ALTER TABLE opuscollege.sch_scholarshiptype ALTER lang TYPE character(6);
ALTER TABLE opuscollege.sch_subsidytype ALTER lang TYPE character(6);

-------------------------------------------------------
-- Sata instead of Banda
-------------------------------------------------------
UPDATE opuscollege.person 
        set surnamefull = 'Sata', firstnamesfull = 'Michael', firstnamesalias = 'M.S.', birthdate = '1937-01-01'
        where surnamefull = 'Banda' and firstnamesfull = 'Rupiah';
UPDATE opuscollege.opususer set username = 'SATA' where username = 'BANDA';
UPDATE opuscollege.opususerrole set username = 'SATA' where username = 'BANDA'; 
UPDATE opuscollege.opususer set pw = '3e06fa3927cbdf4e9d93ba4541acce86' where username = 'SATA';

-------------------------------------------------------
-- table subjectResult
-------------------------------------------------------
ALTER TABLE opuscollege.subjectResult ADD column endGradeComment VARCHAR;

-------------------------------------------------------
-- table testResult
-------------------------------------------------------
ALTER TABLE opuscollege.testResult DROP column brspassingtest;
ALTER TABLE opuscollege.testResult DROP column finalattempt;

-------------------------------------------------------
-- changes on cutoffpoint
-------------------------------------------------------
DELETE FROM opuscollege.opusprivilege WHERE code = 'TOGGLE_CUTOFFPOINT';

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TOGGLE_CUTOFFPOINT_ADMISSION_BA_BSC','en','Y','Set the cut-off point for applying bachelor students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BA_BSC','en','Y','Set the cut-off point for registering bachelor students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MA_MSC','en','Y','Set the cut-off point for registering master / postgraduate students');


DELETE FROM opuscollege.opusrole_privilege where privilegecode = 'TOGGLE_CUTOFFPOINT';

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','TOGGLE_CUTOFFPOINT_ADMISSION_BA_BSC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','TOGGLE_CUTOFFPOINT_ADMISSION_BA_BSC');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BA_BSC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BA_BSC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BA_BSC');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MA_MSC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MA_MSC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MA_MSC');

DELETE FROM opuscollege.opusrole_privilege where role = 'admin';
INSERT INTO opuscollege.opusrole_privilege(privilegecode,role) SELECT distinct code,'admin' FROM opuscollege.opusprivilege;
