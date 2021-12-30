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

-- Opus College (c) UCI - Janneke Nooitgedagt August 2008
--
-- KERNEL opuscollege / MODULE scholarship
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'scholarship';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('scholarship','A','Y',2.00);

-------------------------------------------------------

DELETE FROM opuscollege.sch_scholarshipType;

-- EN
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('cs', 'complete scholarship', 'en');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('hs', 'housing scholarship', 'en');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('rs', 'reduced scholarship', 'en');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ds', '50% discount', 'en');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('fs', 'free of fees', 'en');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ms', 'merit scholarship', 'en');
-- PT
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('cs', 'bolsa completa', 'pt');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('hs', 'bolsa de alojamento', 'pt');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('rs', 'bolsa reduzida', 'pt');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ds', 'redu&ccedil;&atilde;o 50%', 'pt');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('fs', 'insen&ccedil;&atilde;o', 'pt');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ms', 'bolsa de m&eacute;rito', 'pt');

---------------------------------------------------------
-- sch_sponsor
---------------------------------------------------------

DELETE FROM opuscollege.sch_sponsor;

INSERT INTO opuscollege.sch_sponsor(code, name) VALUES ('OE', 'OE');
INSERT INTO opuscollege.sch_sponsor(code, name) VALUES ('MOZ', 'Mozal');
INSERT INTO opuscollege.sch_sponsor(code, name) VALUES ('SID', 'Sida/Sarec');
INSERT INTO opuscollege.sch_sponsor(code, name) VALUES ('GdG', 'Governo de Gaza');
INSERT INTO opuscollege.sch_sponsor(code, name) VALUES ('GdT', 'Governo de Tete');
INSERT INTO opuscollege.sch_sponsor(code, name) VALUES ('OTH', 'Outro');
INSERT INTO opuscollege.sch_sponsor(code, name) VALUES ('CTB', 'CTB');

------------------------------------------------------
-- table subsidyType
-------------------------------------------------------

DELETE FROM opuscollege.sch_subsidyType;

-- EN
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('mat', 'Material', 'en');
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('tesB', 'Thesis (Bank)', 'en');
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('tesA', 'Thesis (Signature)', 'en');
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('tesF', 'Thesis (Final)', 'en');
-- PT
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('mat', 'Material', 'pt');
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('tesB', 'Tese (Banco)', 'pt');
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('tesA', 'Tese (Assinatura)', 'pt');
INSERT INTO opuscollege.sch_subsidyType(code, description, lang) VALUES ('tesF', 'Tese (DFin)', 'pt');


---------------------------------------------------------
-- sch_decisionCriteria
---------------------------------------------------------
DELETE FROM opuscollege.sch_decisionCriteria;

-- EN
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('A', 'A', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Art.13', 'Art.13', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Art.14,3', 'Art.14,3', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('B', 'B', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('C', 'C', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Dez', 'December', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('E', 'E', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Excep', 'Exceptional', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Extemp', 'Out of time', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('F', 'F', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('G', 'G', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('H', 'H', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('I', 'I', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('J', 'J', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Jul', 'July', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('K', 'K', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('L', 'L', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('L) Excep', 'L) Exceptional', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('M', 'M', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('N', 'N', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Nov', 'November', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('O', 'O', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('O) Art.14,3', 'O) Art.14,3', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Out', 'October', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('P', 'P', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Q', 'Q', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('R', 'R', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('S', 'S', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Set', 'September', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('T', 'T', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('U', 'U', 'en');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('U) Art.13', 'U) Art.13', 'en');
-- PT
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('A', 'A', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Art.13', 'Art.13', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Art.14,3', 'Art.14,3', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('B', 'B', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('C', 'C', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Dez', 'Dezembro', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('E', 'E', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Excep', 'Excepcional', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Extemp', 'Extempor&atilde;neo', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('F', 'F', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('G', 'G', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('H', 'H', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('I', 'I', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('J', 'J', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Jul', 'Julho', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('K', 'K', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('L', 'L', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('L) Excep', 'L) Excepcional', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('M', 'M', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('N', 'N', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Nov', 'Novembro', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('O', 'O', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('O) Art.14,3', 'O) Art.14,3', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Out', 'Outubro', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('P', 'P', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Q', 'Q', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('R', 'R', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('S', 'S', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('Set', 'Setembro', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('T', 'T', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('U', 'U', 'pt');
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('U) Art.13', 'U) Art.13', 'pt');

---------------------------------------------------------
-- sch_sponsor
---------------------------------------------------------

DELETE FROM opuscollege.sch_bank;

INSERT INTO opuscollege.sch_bank(code, name) VALUES ('PB', 'Postbank');
INSERT INTO opuscollege.sch_bank(code, name) VALUES ('ABN', 'ABN-AMRO');
INSERT INTO opuscollege.sch_bank(code, name) VALUES ('RABO', 'Rabobank');

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'scholarship';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('scholarship','A','Y',2.00);

