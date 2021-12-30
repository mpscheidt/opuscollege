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
-- Updates specific to Zambia
--
-- Initial author: Monique in het Veld

-------------------------------------------------------
-- table sch_sponsortype
-------------------------------------------------------
DELETE FROM opuscollege.sch_sponsortype WHERE lang='en';
--insert into sponsortype
INSERT INTO opuscollege.sch_sponsortype(code,lang,name,description) VALUES('GRZ-S','en','GRZ sponsorship','Government Sponsored Tuition Waiver through Bursaries committee. This covers Tuition only.');
INSERT INTO opuscollege.sch_sponsortype(code,lang,name,description) VALUES('EX-S','en','External sponsorsip','Sponsorship provided by institutions other than UNZA');
INSERT INTO opuscollege.sch_sponsortype(code,lang,name,description) VALUES('SDF-S','en','Staff Development Fellow (SDF)','Applicable to members of staff');
INSERT INTO opuscollege.sch_sponsortype(code,lang,name,description) VALUES('TW-S','en','Tution Waiver','Applicable to members of staff and their dependants');
INSERT INTO opuscollege.sch_sponsortype(code,lang,name,description) VALUES('STB-S','en','Staff Terminal Benefits Sponsorship','The fees due are deducted from a member of staffs unpaid terminal benefits. Beneficiaries include dependants');
INSERT INTO opuscollege.sch_sponsortype(code,lang,name,description) VALUES('SLF-S','en','Self sponsorship','The student pays all fees themselves');

-------------------------------------------------------
-- table sch_sponsor
-------------------------------------------------------
DELETE FROM opuscollege.sch_sponsor;
--insert into sponsor
INSERT INTO opuscollege.sch_sponsor(code,name) VALUES('1','GOVERNMENT OF ZAMBIA');
INSERT INTO opuscollege.sch_sponsor(code,name) VALUES('2','ZAMBIA ARMY');
INSERT INTO opuscollege.sch_sponsor(code,name) VALUES('3','AA INSTITUTE');
INSERT INTO opuscollege.sch_sponsor(code,name) VALUES('4','UGANDAN GOVERNMENT');
INSERT INTO opuscollege.sch_sponsor(code,name) VALUES('5','BARCLAYS BANK');
INSERT INTO opuscollege.sch_sponsor(code,name) VALUES('6','SIAME ASSOCIATES');
INSERT INTO opuscollege.sch_sponsor(code,name) VALUES('7','BOTSWANA GOVERNMENT');
INSERT INTO opuscollege.sch_sponsor(code,name) VALUES('8','MOBILE OIL (z) LTD');
INSERT INTO opuscollege.sch_sponsor(code,name) VALUES('11','RETIRED STAFF');
INSERT INTO opuscollege.sch_sponsor(code,name) VALUES('12','UNIVERSITY OF ZAMBIA');
INSERT INTO opuscollege.sch_sponsor(code,name) VALUES('13','STUDENT');
INSERT INTO opuscollege.sch_sponsor(code,name) VALUES('14','GUARDIAN');

