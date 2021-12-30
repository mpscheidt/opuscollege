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
 * The Original Code is Opus-College scholarship module code.
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

-- Opus College (c) UCI - Monique in het Veld - december 2012
--
-- KERNEL opuscollege / MODULE scholarship
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'scholarship';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('scholarship','A','Y',3.23);

-------------------------------------------------------
-- table sch_sponsorType
-------------------------------------------------------
ALTER TABLE opuscollege.sch_sponsorType rename column name to title;
-------------------------------------------------------
-- table sch_sponsorType
-------------------------------------------------------
DELETE FROM opuscollege.lookuptable where lower(tablename) = 'sch_sponsortype';
INSERT INTO opuscollege.lookuptable(tablename, lookuptype) VALUES ('sch_sponsortype', 'Lookup6');

-- clean up databases:
DROP SEQUENCE IF EXISTS opuscollege.sch_sponsorSponsorType_seq CASCADE;
------------------------------------------------------------------
-- table sch_scholarshipapplication
------------------------------------------------------------------
ALTER TABLE opuscollege.sch_scholarshipapplication add column studyplanid integer;
UPDATE opuscollege.sch_scholarshipapplication set studyplanid = 0;
ALTER TABLE opuscollege.sch_scholarshipapplication alter column studyplanid set not null;
ALTER TABLE opuscollege.sch_scholarshipapplication alter column studyplanid set default 0;
ALTER TABLE opuscollege.sch_scholarshipapplication drop column paymentduedate;
ALTER TABLE opuscollege.sch_scholarshipapplication drop column paymentreceiveddate;
-- Conversion
INSERT INTO opuscollege.sch_scholarshipapplication ( scholarshipstudentid, scholarshipappliedforid, scholarshipgrantedid, studyplanid, decisioncriteriacode, scholarshipamount, observation, validfrom, validuntil, active, writewho, writewhen, paymentduedate, paymentreceiveddate)
    SELECT scholarshipapplication.scholarshipstudentid, scholarshipapplication.scholarshipappliedforid, scholarshipapplication.scholarshipgrantedid, st_plan.id, scholarshipapplication.decisioncriteriacode, scholarshipapplication.scholarshipamount, scholarshipapplication.observation, scholarshipapplication.validfrom, scholarshipapplication.validuntil, scholarshipapplication.active, scholarshipapplication.writewho, scholarshipapplication.writewhen, scholarshipapplication.paymentduedate, scholarshipapplication.paymentreceiveddate
     FROM opuscollege.studyplan st_plan
      INNER JOIN opuscollege.sch_student student ON student.studentid = st_plan.studentid
      INNER JOIN opuscollege.sch_scholarshipapplication scholarshipapplication ON scholarshipapplication.scholarshipstudentid = student.scholarshipstudentid;
INSERT INTO opuscollege.sch_complaint (  complaintdate, reason, complaintstatuscode, scholarshipapplicationid, active, writewho, writewhen, result)
    SELECT sch_complaint.complaintdate, sch_complaint.reason, sch_complaint.complaintstatuscode, sch_scholarshipapplication.id, sch_complaint.active, sch_complaint.writewho, sch_complaint.writewhen, sch_complaint.result
     FROM opuscollege.sch_complaint, opuscollege.sch_scholarshipapplication
      where sch_scholarshipapplication.scholarshipstudentid in (select sch_scholarshipapplication.scholarshipstudentid from opuscollege.sch_scholarshipapplication where sch_scholarshipapplication.id = sch_complaint.scholarshipapplicationid)
      and sch_scholarshipapplication.scholarshipappliedforid in (select sch_scholarshipapplication.scholarshipappliedforid from opuscollege.sch_scholarshipapplication where sch_scholarshipapplication.id = sch_complaint.scholarshipapplicationid);
DELETE FROM opuscollege.sch_complaint USING opuscollege.sch_scholarshipapplication where opuscollege.sch_complaint.scholarshipapplicationid = opuscollege.sch_scholarshipapplication.id and opuscollege.sch_scholarshipapplication.studyplanid = 0;
DELETE FROM opuscollege.sch_scholarshipapplication where sch_scholarshipapplication.studyplanid = 0;
