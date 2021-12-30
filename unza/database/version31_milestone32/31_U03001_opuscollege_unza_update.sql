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
 * The Original Code is Opus-College unza module code.
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
--
-- Updates specific to UNZA Module
--
-- Initial author: Monique in het Veld

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'unza';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('unza','A','Y',3.12);

-----------------------------------------------------------
-- lookup TABLE progressStatus, which shows the status of a CTU in a studyplan
-----------------------------------------------------------
DELETE FROM opuscollege.progressStatus where lang='en';

INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','01','Clear pass','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','02','Redirect','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','03','Repeat year','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','04','Proceed','Y','Y','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','05','Change School','Y','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','06','To clinical','Y','Y','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','07','Left mid year','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','08','W.O.P.','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','09','Graduate Pass','N','N','Y','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','10','Graduate Merit','N','N','Y','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','11','To part-time / Corr','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','12','Graduate credit','N','N','Y','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','13','Graduate distinction','N','N','Y','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','14','Suspended','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','15','Expelled','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','16','Leave of absence','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','17','Supplementary exams','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','18','Deferred exams','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','19','At part-time','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','20','N.E. (No exam)','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','21','Deceased','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','22','Exclude UNZA','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','23','Withdrawn with perm','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','24','Incomplete','Y','Y','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','25','Graduate','N','N','Y','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','26','Resitting only','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','27','Proceed & repeat','Y','Y','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','28','At full-time & corr','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','29','To part-time','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','30','At correspondence','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','31','To full-time','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','32','Readmit','Y','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','33','Resitting & PT/FT','Y','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','34','Exclude school','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','35','Exclude program','Y','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','36','***Special case***','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','37','Penalty withdrawal','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','38','Graduate Diploma','N','N','Y','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','39','Graduate posthumous','N','N','Y','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','40','Grad certificate','N','N','Y','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','41','Results withheld','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','42','De-registered','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','43','University closed','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','49','New student','Y','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','51','Graduate aegrotat','N','N','Y','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','52','Deceased','N','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','53','Deferred/Supp. exams','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','54','Appeal granted','Y','N','N','N');

-------------------------------------------------------
-- table appConfig
-------------------------------------------------------
INSERT INTO opuscollege.appConfig(appConfigAttributeName,appConfigAttributeValue) VALUES ('numberOfSubjectsToCountForStudyPlanMark', '16');
