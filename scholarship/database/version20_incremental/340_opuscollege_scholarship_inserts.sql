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

-- Opus College (c) UCI - Monique in het Veld March 2008
--
-- KERNEL opuscollege / MODULE scholarship
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'scholarship';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('scholarship','A','Y',1.00);

-------------------------------------------------------
-- table sch_scholarshipType
-------------------------------------------------------

DELETE FROM opuscollege.sch_scholarshipType;

-- EN
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('cs', 'complete scholarship', 'EN');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('hs', 'housing scholarship', 'EN');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('rs', 'reduced scholarship', 'EN');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ds', '50% discount', 'EN');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('fs', 'free of fees', 'EN');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ms', 'merit scholarship', 'EN');
-- PT
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('cs', 'bolsa completa', 'PT');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('hs', 'bolsa de alojamento', 'PT');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('rs', 'bolsa reduzida', 'PT');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ds', 'redução 50%', 'PT');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('fs', 'insenção', 'PT');
INSERT INTO opuscollege.sch_scholarshipType(code, description, lang) VALUES ('ms', 'bolsa de mérito', 'PT');

---------------------------------------------------------
-- sch_decisionCriteria
---------------------------------------------------------

DELETE FROM opuscollege.sch_decisionCriteria;

-- EN
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('ID', 'Insufficient documentation', 'EN');
-- PT
INSERT INTO opuscollege.sch_decisionCriteria(code, description, lang) VALUES ('ID', 'Insuficiencia de documentos', 'PT');

---------------------------------------------------------
-- sch_sponsor
---------------------------------------------------------

DELETE FROM opuscollege.sch_sponsor;

INSERT INTO opuscollege.sch_sponsor(code, name) VALUES ('OE', 'Mozal');

---------------------------------------------------------
-- sch_complaintStatus
---------------------------------------------------------

DELETE FROM opuscollege.sch_complaintStatus;

-- EN
INSERT INTO opuscollege.sch_complaintStatus(code, description, lang) VALUES ('RS', 'resolved', 'EN');
INSERT INTO opuscollege.sch_complaintStatus(code, description, lang) VALUES ('NR', 'not resolved', 'EN');
INSERT INTO opuscollege.sch_complaintStatus(code, description, lang) VALUES ('OP', 'open', 'EN');

-- PT
INSERT INTO opuscollege.sch_complaintStatus(code, description, lang) VALUES ('RS', 'resolvido', 'PT');
INSERT INTO opuscollege.sch_complaintStatus(code, description, lang) VALUES ('NR', 'não resolvido', 'PT');
INSERT INTO opuscollege.sch_complaintStatus(code, description, lang) VALUES ('OP', 'aberto', 'PT');
