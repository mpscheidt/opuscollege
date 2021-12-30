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
 * The Original Code is Opus-College college module code.
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
-- Author: Stelio Macumbe
-- Date: 2012-06-28
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';
INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.68);

DROP TABLE audit.person_hist;

-- Table: audit.staffmember_hist
DROP TABLE audit.staffmember_hist;

CREATE TABLE audit.staffmember_hist
(
  operation character(1) NOT NULL,
  staffmemberid integer NOT NULL ,
  staffmembercode character varying NOT NULL,
  personid integer NOT NULL,
  dateofappointment date DEFAULT now(),
  appointmenttypecode character varying,
  stafftypecode character varying,
  primaryunitofappointmentid integer NOT NULL DEFAULT 0,
  educationtypecode character varying,
  writewho character varying NOT NULL ,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),
  startworkday time(5) without time zone,
  endworkday time(5) without time zone,
  teachingdaypartcode character varying,
  supervisingdaypartcode character varying,
  
   id integer NOT NULL ,
  personcode character varying NOT NULL,
  active character(1) NOT NULL DEFAULT 'Y'::bpchar,
  surnamefull character varying NOT NULL,
  surnamealias character varying,
  firstnamesfull character varying NOT NULL,
  firstnamesalias character varying,
  nationalregistrationnumber character varying,
  civiltitlecode character varying,
  gradetypecode character varying,
  gendercode character varying DEFAULT '3'::character varying,
  birthdate date NOT NULL DEFAULT now(),
  nationalitycode character varying,
  placeofbirth character varying,
  districtofbirthcode character varying,
  provinceofbirthcode character varying,
  countryofbirthcode character varying,
  cityoforigin character varying,
  administrativepostoforigincode character varying,
  districtoforigincode character varying,
  provinceoforigincode character varying,
  countryoforigincode character varying,
  civilstatuscode character varying,
  housingoncampus character(1),
  identificationtypecode character varying,
  identificationnumber character varying,
  identificationplaceofissue character varying,
  identificationdateofissue date,
  identificationdateofexpiration date,
  professioncode character varying,
  professiondescription character varying,
  languagefirstcode character varying,
  languagefirstmasteringlevelcode character varying,
  languagesecondcode character varying,
  languagesecondmasteringlevelcode character varying,
  languagethirdcode character varying,
  languagethirdmasteringlevelcode character varying,
  contactpersonemergenciesname character varying,
  contactpersonemergenciestelephonenumber character varying,
  bloodtypecode character varying,
  healthissues character varying,
  photograph bytea,
  remarks character varying,
  registrationdate date NOT NULL DEFAULT now(),
  photographname character varying,
  photographmimetype character varying,
  publichomepage character(1) NOT NULL DEFAULT 'N'::bpchar,
  socialnetworks character varying,
  hobbies character varying,
  motivation character varying
);

ALTER TABLE audit.staffmember_hist OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE,REFERENCES, TRIGGER ON TABLE audit.staffmember_hist TO postgres;


-- Table: audit.student_hist

DROP TABLE audit.student_hist;

CREATE TABLE audit.student_hist
(
  operation character(1) NOT NULL,
  studentid integer NOT NULL ,
  studentcode character varying NOT NULL,
  personid integer NOT NULL,
  dateofenrolment date DEFAULT now(),
  primarystudyid integer NOT NULL DEFAULT 0,
  expellationdate date,
  reasonforexpellation character varying,
  previousinstitutionid integer NOT NULL,
  previousinstitutionname character varying,
  previousinstitutiondistrictcode character varying,
  previousinstitutionprovincecode character varying,
  previousinstitutioncountrycode character varying,
  previousinstitutioneducationtypecode character varying,
  previousinstitutionfinalgradetypecode character varying,
  previousinstitutionfinalmark character varying,
  previousinstitutiondiplomaphotograph bytea,
  scholarship character(1) NOT NULL DEFAULT 'N'::bpchar,
  fatherfullname character varying,
  fathereducationcode character varying DEFAULT '0'::character varying,
  fatherprofessioncode character varying DEFAULT '0'::character varying,
  fatherprofessiondescription character varying,
  motherfullname character varying,
  mothereducationcode character varying DEFAULT '0'::character varying,
  motherprofessioncode character varying DEFAULT '0'::character varying,
  motherprofessiondescription character varying,
  financialguardianfullname character varying,
  financialguardianrelation character varying,
  financialguardianprofession character varying,
  writewho character varying,
  writewhen timestamp without time zone NOT NULL DEFAULT now(),
  expellationenddate date,
  expellationtypecode character varying,
  previousinstitutiondiplomaphotographremarks character varying,
  previousinstitutiondiplomaphotographname character varying,
  previousinstitutiondiplomaphotographmimetype character varying,
  subscriptionrequirementsfulfilled character(1) NOT NULL DEFAULT 'Y'::bpchar,
  secondarystudyid integer NOT NULL DEFAULT 0,
  foreignstudent character(1) NOT NULL DEFAULT 'N'::bpchar,
  nationalitygroupcode character varying,
  fathertelephone character varying,
  mothertelephone character varying,
  relativeofstaffmember character(1) NOT NULL DEFAULT 'N'::bpchar,
  relativestaffmemberid integer NOT NULL DEFAULT 0,
  ruralareaorigin character(1) NOT NULL DEFAULT 'N'::bpchar,
  
  id integer NOT NULL ,
  personcode character varying NOT NULL,
  active character(1) NOT NULL DEFAULT 'Y'::bpchar,
  surnamefull character varying NOT NULL,
  surnamealias character varying,
  firstnamesfull character varying NOT NULL,
  firstnamesalias character varying,
  nationalregistrationnumber character varying,
  civiltitlecode character varying,
  gradetypecode character varying,
  gendercode character varying DEFAULT '3'::character varying,
  birthdate date NOT NULL DEFAULT now(),
  nationalitycode character varying,
  placeofbirth character varying,
  districtofbirthcode character varying,
  provinceofbirthcode character varying,
  countryofbirthcode character varying,
  cityoforigin character varying,
  administrativepostoforigincode character varying,
  districtoforigincode character varying,
  provinceoforigincode character varying,
  countryoforigincode character varying,
  civilstatuscode character varying,
  housingoncampus character(1),
  identificationtypecode character varying,
  identificationnumber character varying,
  identificationplaceofissue character varying,
  identificationdateofissue date,
  identificationdateofexpiration date,
  professioncode character varying,
  professiondescription character varying,
  languagefirstcode character varying,
  languagefirstmasteringlevelcode character varying,
  languagesecondcode character varying,
  languagesecondmasteringlevelcode character varying,
  languagethirdcode character varying,
  languagethirdmasteringlevelcode character varying,
  contactpersonemergenciesname character varying,
  contactpersonemergenciestelephonenumber character varying,
  bloodtypecode character varying,
  healthissues character varying,
  photograph bytea,
  remarks character varying,
  registrationdate date NOT NULL DEFAULT now(),
  photographname character varying,
  photographmimetype character varying,
  publichomepage character(1) NOT NULL DEFAULT 'N'::bpchar,
  socialnetworks character varying,
  hobbies character varying,
  motivation character varying
);

ALTER TABLE audit.student_hist OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE,REFERENCES, TRIGGER ON TABLE audit.student_hist TO postgres;
