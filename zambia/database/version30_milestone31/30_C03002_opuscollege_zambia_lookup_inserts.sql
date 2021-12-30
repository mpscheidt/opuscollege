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
 * The Original Code is Opus-College zambia module code.
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
-- Lookup inserts specific to Zambia
--
-- Initial author: Monique in het Veld

-------------------------------------------------------
-- table administrativePost
-------------------------------------------------------
DELETE FROM opuscollege.administrativePost where lang='en';
--INSERT INTO opuscollege.administrativePost (lang,code,description,districtCode) VALUES('en','01-001','Ancuabe','01-01');

-------------------------------------------------------
-- table district
-------------------------------------------------------
DELETE FROM opuscollege.district where lang='en' and description like 'ZM-%';
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-01-01','Chibombo','ZM-01');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-01-02','Kabwe','ZM-01');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-01-03','Kapiri Mposhi','ZM-01');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-01-04','Mkushi','ZM-01');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-01-05','Mumbwa','ZM-01');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-01-06','Serenje','ZM-01');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-02-01','Chililabombwe','ZM-02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-02-02','Chingola','ZM-02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-02-03','Kalulushi','ZM-02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-02-04','Kitwe','ZM-02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-02-05','Luanshya','ZM-02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-02-06','Lufwanyama','ZM-02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-02-07','Masaiti','ZM-02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-02-08','Mpongwe','ZM-02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-02-09','Mufulira','ZM-02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-02-10','Ndola ','ZM-02');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-03-01','Chadiza','ZM-03');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-03-02','Chama','ZM-03');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-03-03','Chipata','ZM-03');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-03-04','Katete','ZM-03');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-03-05','Lundazi','ZM-03');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-03-06','Mambwe','ZM-03');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-03-07','Nyimba','ZM-03');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-03-08','Petauke','ZM-03');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-04-01','Chiengi','ZM-04');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-04-02','Kawambwa','ZM-04');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-04-03','Mansa','ZM-04');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-04-04','Milenge','ZM-04');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-04-05','Mwense','ZM-04');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-04-06','Nchelenge','ZM-04');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-04-07','Samfya','ZM-04');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-05-01','Chongwe','ZM-05');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-05-02','Kafue','ZM-05');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-05-03','Luangwa','ZM-05');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-05-04','Lusaka','ZM-05');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-06-01','Chilubi','ZM-06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-06-02','Chinsali','ZM-06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-06-03','Isoka','ZM-06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-06-04','Kaputa','ZM-06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-06-05','Kasama District','ZM-06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-06-06','Luwingu','ZM-06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-06-07','Mbala','ZM-06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-06-08','Mpika','ZM-06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-06-09','Mporokoso','ZM-06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-06-10','Mpulungu','ZM-06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-06-11','Mungwi','ZM-06');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-07-01','Chavuma','ZM-07');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-07-02','Kabompo','ZM-07');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-07-03','Kasempa','ZM-07');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-07-04','Mufumbwe','ZM-07');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-07-05','Mwinilunga','ZM-07');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-07-06','Solwezi','ZM-07');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-07-07','Zambezi','ZM-07');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-08-01','Choma','ZM-08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-08-02','Gwembe','ZM-08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-08-03','Itezhi-Tezhi','ZM-08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-08-04','Kalomo','ZM-08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-08-05','Kazungula','ZM-08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-08-06','Livingstone','ZM-08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-08-07','Mazabuka','ZM-08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-08-08','Monze','ZM-08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-08-09','Namwala','ZM-08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-08-10','Siavonga','ZM-08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-08-11','Sinazongwe','ZM-08');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-09-01','Kalabo','ZM-09');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-09-02','Kaoma','ZM-09');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-09-03','Lukulu','ZM-09');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-09-04','Mongu','ZM-09');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-09-05','Senanga','ZM-09');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-09-06','Sesheke','ZM-09');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','ZM-09-07','Shangombo','ZM-09');

-------------------------------------------------------
-- table endGradeType (for calculations on all levels)
-- NOTE: used in calculations, can not be altered !!
-------------------------------------------------------
DELETE FROM opuscollege.endGradeType where lang='en';

-- EN
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','CA','continuous assessment');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','SE','sessional examination');

INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','SR','course result');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','PC','project course result');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','TR','thesis result');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','AR','attachment result');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','CTU','cardinal time unit endgrade');

INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','BSC','bachelor of science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','BA','bachelor of art');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','MSC','master of science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','MA','master of art');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','DA','diploma other than maths and science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','DSC','diploma maths and science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','DIST-DEGR','degree programme (distant education)');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','DIST','distant education');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','PHD','doctor');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','LIC','licentiate');


-------------------------------------------------------
-- table function
-------------------------------------------------------
DELETE FROM opuscollege.function where lang='en';

INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','1','Chief Professor');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','2','Associate Professor');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','3','Assistant Professor');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','4','Researcher');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','5','Assistant');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','6','Assistant-stagiaire');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','7','Monitor');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','8','Director');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','9','Sub Director of Education');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','10','Sub Director of Research');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','11','Dean of School');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','12','Head of Department');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','13','Head of Group');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','14','Head of Course');
INSERT INTO opuscollege.function (lang,code,description) VALUES ('en','15','Head of Section');


-------------------------------------------------------
-- table gradeType (with title for academicTitle)
-------------------------------------------------------
DELETE FROM opuscollege.gradeType where lang='en' and title IN ('D.A.', 'D.Sc.');

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','13','diploma - other than maths and science','D.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','14','diploma - maths and science','D.Sc.');

-------------------------------------------------------
-- table identificationType
-------------------------------------------------------
DELETE FROM opuscollege.identificationType where lang='en';

INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('en','1','National Registration Card');
INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('en','3','passport');
INSERT INTO opuscollege.identificationType (lang,code,description) VALUES ('en','4','drivers license');


-----------------------------------------------------------
-- lookup TABLE progressStatus, which is the status of a CTU in a studyplan
-----------------------------------------------------------
DELETE FROM opuscollege.progressStatus where lang='en';

INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','1','Progression / Clear pass');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','2','Compensatory pass / Proceed and Repeat');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','3','To Part-time');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','4','At Part-time');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','5','To Full-time');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','6','Repeat');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','7','Exclude study programme');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','8','Exclude school');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','9','Withdrawn with permission');
INSERT INTO opuscollege.progressStatus (lang,code,description) VALUES ('en','10','Graduate');

-------------------------------------------------------
-- table province
-------------------------------------------------------
DELETE FROM opuscollege.province where lang='en' and description like 'ZM-%';
INSERT INTO opuscollege.province (lang,code,description,countryCode) VALUES('en','ZM-01','Central','894');
INSERT INTO opuscollege.province (lang,code,description,countryCode) VALUES('en','ZM-02','Copperbelt','894');
INSERT INTO opuscollege.province (lang,code,description,countryCode) VALUES('en','ZM-03','Eastern','894');
INSERT INTO opuscollege.province (lang,code,description,countryCode) VALUES('en','ZM-04','Luapula','894');
INSERT INTO opuscollege.province (lang,code,description,countryCode) VALUES('en','ZM-05','Lusaka','894');
INSERT INTO opuscollege.province (lang,code,description,countryCode) VALUES('en','ZM-06','Northern','894');
INSERT INTO opuscollege.province (lang,code,description,countryCode) VALUES('en','ZM-07','North-Western','894');
INSERT INTO opuscollege.province (lang,code,description,countryCode) VALUES('en','ZM-08','Southern','894');
INSERT INTO opuscollege.province (lang,code,description,countryCode) VALUES('en','ZM-09','Western','894');

-------------------------------------------------------
-- table studyType
-------------------------------------------------------
DELETE FROM opuscollege.studyType where lang='en';

INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','1','lecture');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','2','workshop');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','3','experiment');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','4','self study');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','5','paper');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','6','e-learning');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','7','group work');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','8','individual assistance by lecturer');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','9','literature');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','10','lab/practical');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','11','project');
INSERT INTO opuscollege.studyType (lang,code,description) VALUES ('en','12','seminar');

-------------------------------------------------------
-- table unitType
-------------------------------------------------------
DELETE from opuscollege.unitType where lang='en';

INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','1','School');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','2','Department');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','3','Administration');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','4','Section');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','5','Direction');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','6','Secretariat');
INSERT INTO opuscollege.unitType (lang,code,description) VALUES ('en','7','Institute');

