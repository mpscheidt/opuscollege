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
 * The Original Code is Opus-College netherlands module code.
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

-- Opus College
-- SCHOLARSHIP opusCollege / MODULE netherlands
--
-- Initial author: Monique in het Veld

-------------------------------------------------------
-- DOMAIN TABLES
-------------------------------------------------------

---------------------------------------------------------
-- sch_bank
---------------------------------------------------------
DELETE FROM opuscollege.sch_bank;

INSERT INTO opuscollege.sch_bank(code, name) VALUES ('PB', 'Postbank');
INSERT INTO opuscollege.sch_bank(code, name) VALUES ('ABN', 'ABN-AMRO');
INSERT INTO opuscollege.sch_bank(code, name) VALUES ('RABO', 'Rabobank');

---------------------------------------------------------
-- sch_sponsor
---------------------------------------------------------

DELETE FROM opuscollege.sch_sponsor;

INSERT INTO opuscollege.sch_sponsor(code, name) VALUES ('GOV', 'Regering');
INSERT INTO opuscollege.sch_sponsor(code, name) VALUES ('PRIV', 'Prive');
INSERT INTO opuscollege.sch_sponsor(code, name) VALUES ('OTH', 'Anders');

-------------------------------------------------------
-- LOOKUP TABLES
-------------------------------------------------------

-------------------------------------------------------
-- table sch_scholarshipType
-------------------------------------------------------

DELETE FROM opuscollege.sch_scholarshipType;

-- EN
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('cs', 'complete beurs', 'nl');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('hs', 'huisvesting beurs', 'nl');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('rs', 'gedeeltelijke beurs', 'nl');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ds', '50% korting', 'nl');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('fs', 'vrij van toelatingskosten', 'nl');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ms', 'laureaat beurs', 'nl');

---------------------------------------------------------
-- sch_complaintStatus
---------------------------------------------------------

DELETE FROM opuscollege.sch_complaintStatus;

-- EN
INSERT INTO opuscollege.sch_complaintStatus(code, description, lang) VALUES ('RS', 'opgelost', 'nl');
INSERT INTO opuscollege.sch_complaintStatus(code, description, lang) VALUES ('NR', 'niet opgelost', 'nl');
INSERT INTO opuscollege.sch_complaintStatus(code, description, lang) VALUES ('OP', 'open', 'nl');


------------------------------------------------------
-- table subsidyType
-------------------------------------------------------

DELETE FROM opuscollege.sch_subsidyType;

-- EN
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('mat', 'Materieel', 'nl');
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('tesB', 'Thesis (Bank)', 'nl');
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('tesA', 'Thesis (Ondertekend)', 'nl');
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('tesF', 'Thesis (Einde)', 'nl');

---------------------------------------------------------
-- sch_decisionCriteria
---------------------------------------------------------
DELETE FROM opuscollege.sch_decisionCriteria;

-- EN
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('A', 'A', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Art.13', 'Art.13', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Art.14,3', 'Art.14,3', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('B', 'B', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('C', 'C', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Dez', 'December', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('E', 'E', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Excep', 'Buitengewoon', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Extemp', 'Tijd verlopen', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('F', 'F', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('G', 'G', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('H', 'H', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('I', 'I', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('J', 'J', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Jul', 'July', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('K', 'K', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('L', 'L', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('L) Excep', 'L) Buitengewoon', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('M', 'M', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('N', 'N', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Nov', 'November', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('O', 'O', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('O) Art.14,3', 'O) Art.14,3', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Out', 'Oktober', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('P', 'P', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Q', 'Q', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('R', 'R', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('S', 'S', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Set', 'September', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('T', 'T', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('U', 'U', 'nl');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('U) Art.13', 'U) Art.13', 'nl');

