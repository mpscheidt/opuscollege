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

-- 
-- Author: Markus Pscheidt
-- Date:   2015-07-27
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
UPDATE opuscollege.appVersions SET dbVersion = 4.10 WHERE lower(module) = 'scholarship';

-------------------------------------------------------
-- sequences ownership
-------------------------------------------------------
ALTER SEQUENCE opuscollege.sch_bankseq OWNED BY opuscollege.sch_bank.id;
ALTER SEQUENCE opuscollege.sch_complaintseq OWNED BY opuscollege.sch_complaint.id;
ALTER SEQUENCE opuscollege.sch_complaintstatusseq OWNED BY opuscollege.sch_complaintstatus.id;
ALTER SEQUENCE opuscollege.sch_decisioncriteriaseq OWNED BY opuscollege.sch_decisioncriteria.id;
ALTER SEQUENCE opuscollege.sch_scholarshipapplicationseq OWNED BY opuscollege.sch_scholarshipapplication.id;
ALTER SEQUENCE opuscollege.sch_scholarshipseq OWNED BY opuscollege.sch_scholarship.id;
ALTER SEQUENCE opuscollege.sch_scholarshiptypeseq OWNED BY opuscollege.sch_scholarshiptype.id;
ALTER SEQUENCE opuscollege.sch_scholarshipfeepercentage_seq OWNED BY opuscollege.sch_scholarshipfeepercentage.id;
ALTER SEQUENCE opuscollege.sch_sponsorpayment_seq OWNED BY opuscollege.sch_sponsorpayment.id;
ALTER SEQUENCE opuscollege.sch_sponsorseq OWNED BY opuscollege.sch_sponsor.id;
ALTER SEQUENCE opuscollege.sch_sponsortype_seq OWNED BY opuscollege.sch_sponsortype.id;
ALTER SEQUENCE opuscollege.sch_studentseq OWNED BY opuscollege.sch_student.scholarshipstudentid;
ALTER SEQUENCE opuscollege.sch_subsidyseq OWNED BY opuscollege.sch_subsidy.id;
ALTER SEQUENCE opuscollege.sch_subsidytypeseq OWNED BY opuscollege.sch_subsidytype.id;

SELECT SETVAL('opuscollege.sch_bankseq', COALESCE(MAX(id), 1) ) FROM opuscollege.sch_bank;
SELECT SETVAL('opuscollege.sch_complaintseq', COALESCE(MAX(id), 1) ) FROM opuscollege.sch_complaint;
SELECT SETVAL('opuscollege.sch_complaintstatusseq', COALESCE(MAX(id), 1) ) FROM opuscollege.sch_complaintstatus;
SELECT SETVAL('opuscollege.sch_decisioncriteriaseq', COALESCE(MAX(id), 1) ) FROM opuscollege.sch_decisioncriteria;
SELECT SETVAL('opuscollege.sch_scholarshipapplicationseq', COALESCE(MAX(id), 1) ) FROM opuscollege.sch_scholarshipapplication;
SELECT SETVAL('opuscollege.sch_scholarshipseq', COALESCE(MAX(id), 1) ) FROM opuscollege.sch_scholarship;
SELECT SETVAL('opuscollege.sch_scholarshiptypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.sch_scholarshiptype;
SELECT SETVAL('opuscollege.sch_scholarshipfeepercentage_seq', COALESCE(MAX(id), 1) ) FROM opuscollege.sch_scholarshipfeepercentage;
SELECT SETVAL('opuscollege.sch_sponsorpayment_seq', COALESCE(MAX(id), 1) ) FROM opuscollege.sch_sponsorpayment;
SELECT SETVAL('opuscollege.sch_sponsorseq', COALESCE(MAX(id), 1) ) FROM opuscollege.sch_sponsor;
SELECT SETVAL('opuscollege.sch_sponsortype_seq', COALESCE(MAX(id), 1) ) FROM opuscollege.sch_sponsortype;
SELECT SETVAL('opuscollege.sch_studentseq', COALESCE(MAX(scholarshipstudentid), 1) ) FROM opuscollege.sch_student;
SELECT SETVAL('opuscollege.sch_subsidyseq', COALESCE(MAX(id), 1) ) FROM opuscollege.sch_subsidy;
SELECT SETVAL('opuscollege.sch_subsidytypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.sch_subsidytype;
