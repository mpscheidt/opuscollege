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

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'netherlands';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('netherlands','A','Y',3.21);

-------------------------------------------------------
-- table opusprivilege
-------------------------------------------------------
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TOGGLE_CUTOFFPOINT_ADMISSION_BA_BSC','nl','Y','Set the cut-off point for applying bachelor students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BA_BSC','nl','Y','Set the cut-off point for registering bachelor students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MA_MSC','nl','Y','Set the cut-off point for registering master / postgraduate students');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_IDENTIFICATION_DATA','nl','Y','Vul het National Registration Number, Identficatienummer -en type van een student in');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_IDENTIFICATION_DATA','nl','Y','Pas het National Registration Number, Identficatienummer -en type van een student aan');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_IDENTIFICATION_DATA','nl','Y','Verwijder het Delete National Registration Number, Identficatienummer -en type van een student');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_IDENTIFICATION_DATA','nl','Y','Bekijk het National Registration Number, Identficatienummer -en type van een student');

-----------------------------------------------------------
-- lookup TABLE cardinalTimeUnitStatus
-----------------------------------------------------------
DELETE FROM opuscollege.cardinalTimeUnitStatus where lang='nl';

INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('nl','5','Waiting for payment');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('nl','6','Waiting for selection');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('nl','7','Customize programme');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('nl','8','Waiting for approval of registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('nl','9','Rejected registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('nl','10','Actively registered');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('nl','20','Request for change');

-----------------------------------------------------------
-- lookup TABLE applicantCategory
-----------------------------------------------------------
DELETE FROM opuscollege.applicantCategory where lang='nl';

INSERT INTO opuscollege.applicantCategory (lang,code,description) VALUES ('nl','1','Schoolverlater');
INSERT INTO opuscollege.applicantCategory (lang,code,description) VALUES ('nl','2','Niet-schoolverlater');
INSERT INTO opuscollege.applicantCategory (lang,code,description) VALUES ('nl','3','Speciaal geval');

-------------------------------------------------------
-- lookup table studyPlanStatus
-------------------------------------------------------
DELETE FROM opuscollege.studyPlanStatus where lang='nl';

INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','1','Waiting for payment');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','2','Waiting for selection');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','3','Approved initial admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','4','Rejected initial admission');

INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','10','Temporarily inactive');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','11','Graduated');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('nl','12','Withdrawn');

