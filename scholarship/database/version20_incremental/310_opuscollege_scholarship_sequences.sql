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

-- Opus College (c) UCI -  Feb 2008
--
-- KERNEL opuscollege / MODULE scholarship
-- 
-- Author: Celso Nhapulo

-------------------------------------------------------
-- Sequences
-------------------------------------------------------

DROP SEQUENCE IF EXISTS opuscollege.sch_studentSeq CASCADE; 
DROP SEQUENCE IF EXISTS opuscollege.sch_scholarshipTypeSeq CASCADE; 
DROP SEQUENCE IF EXISTS opuscollege.sch_scholarshipTypeYearSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.sch_scholarshipSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.sch_decisionCriteriaSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.sch_sponsorSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.sch_complaintSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.sch_complaintStatusSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.sch_subsidySeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.sch_subsidyTypeSeq CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.sch_bankSeq CASCADE;


CREATE SEQUENCE opuscollege.sch_studentSeq;
CREATE SEQUENCE opuscollege.sch_scholarshipTypeSeq;
CREATE SEQUENCE opuscollege.sch_scholarshipTypeYearSeq;
CREATE SEQUENCE opuscollege.sch_scholarshipSeq;
CREATE SEQUENCE opuscollege.sch_decisionCriteriaSeq;
CREATE SEQUENCE opuscollege.sch_sponsorSeq;
CREATE SEQUENCE opuscollege.sch_complaintSeq;
CREATE SEQUENCE opuscollege.sch_complaintStatusSeq;
CREATE SEQUENCE opuscollege.sch_subsidySeq;
CREATE SEQUENCE opuscollege.sch_subsidyTypeSeq;
CREATE SEQUENCE opuscollege.sch_bankSeq;

-------------------------------------------------------
-- ownership sequences
-------------------------------------------------------
ALTER TABLE opuscollege.sch_studentSeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_scholarshipTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_scholarshipTypeYearSeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_scholarshipSeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_decisionCriteriaSeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_sponsorSeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_complaintSeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_complaintStatusSeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_subsidySeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_subsidyTypeSeq OWNER TO postgres;
ALTER TABLE opuscollege.sch_bankSeq OWNER TO postgres;

