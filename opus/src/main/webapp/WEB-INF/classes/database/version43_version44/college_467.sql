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
-- Author: Markus Pscheidt
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
UPDATE opuscollege.appVersions SET dbVersion = 4.67, writeWhen = now() WHERE lower(module) = 'college';

-------------------------------------------------------
-- country, province, district, administrativepost
-------------------------------------------------------

ALTER TABLE opuscollege.country ADD COLUMN geonameid integer;
ALTER TABLE opuscollege.province ADD COLUMN geonameid integer;
ALTER TABLE opuscollege.district ADD COLUMN geonameid integer;
ALTER TABLE opuscollege.administrativepost ADD COLUMN geonameid integer;

ALTER TABLE opuscollege.country ALTER COLUMN lang TYPE varchar;
ALTER TABLE opuscollege.province ALTER COLUMN lang TYPE varchar;
ALTER TABLE opuscollege.district ALTER COLUMN lang TYPE varchar;
ALTER TABLE opuscollege.administrativepost ALTER COLUMN lang TYPE varchar;

-------------------------------------------------------
-- table bloodType - there were some inconsistencies with what should be 'pt' entries being 'en' entries instead
-- Since these values are a fixed set, they can be re-created
-------------------------------------------------------
DELETE FROM opuscollege.bloodType;

INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','1','A');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','2','B');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','3','AB');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','4','0');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','5','Unknown');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','6','A-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','7','A-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','8','B-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','9','B-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','10','AB-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','11','AB-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','12','0-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('en','13','0-Neg');

INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','1','A');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','2','B');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','3','AB');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','4','0');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','5','Desconhecido');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','6','A-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','7','A-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','8','B-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','9','B-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','10','AB-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','11','AB-Neg');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','12','0-Pos');
INSERT INTO opuscollege.bloodType (lang,code,description) VALUES ('pt','13','0-Neg');

-------------------------------------------------------
-- remove duplicate entries in mailconfig
-------------------------------------------------------

delete from opuscollege.mailconfig 
where exists (
  select 1 from opuscollege.mailconfig first
  where mailconfig.msgtype = first.msgtype and mailconfig.lang = first.lang and mailconfig.id > first.id
);

-------------------------------------------------------
-- correct the primary keys and unique constraints of lookup tables
-------------------------------------------------------

ALTER TABLE opuscollege.academicfield
    DROP CONSTRAINT academicfield_id_key,
    DROP CONSTRAINT academicfield_pkey,
    ADD CONSTRAINT academicfield_pkey PRIMARY KEY (id),
    ADD CONSTRAINT academicfield_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.addresstype
    DROP CONSTRAINT addresstype_id_key,
    DROP CONSTRAINT addresstype_pkey,
    ADD CONSTRAINT addresstype_pkey PRIMARY KEY (id),
    ADD CONSTRAINT addresstype_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.administrativepost
    DROP CONSTRAINT administrativepost_id_key,
    DROP CONSTRAINT administrativepost_pkey,
    ADD CONSTRAINT administrativepost_pkey PRIMARY KEY (id),
    ADD CONSTRAINT administrativepost_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.applicantcategory
    DROP CONSTRAINT applicantcategory_id_key,
    DROP CONSTRAINT applicantcategory_pkey,
    ADD CONSTRAINT applicantcategory_pkey PRIMARY KEY (id),
    ADD CONSTRAINT applicantcategory_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.appointmenttype
    DROP CONSTRAINT appointmenttype_id_key,
    DROP CONSTRAINT appointmenttype_pkey,
    ADD CONSTRAINT appointmenttype_pkey PRIMARY KEY (id),
    ADD CONSTRAINT appointmenttype_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.blocktype
    DROP CONSTRAINT blocktype_id_key,
    DROP CONSTRAINT blocktype_pkey,
    ADD CONSTRAINT blocktype_pkey PRIMARY KEY (id),
    ADD CONSTRAINT blocktype_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.bloodtype
    DROP CONSTRAINT bloodtype_id_key,
    DROP CONSTRAINT bloodtype_pkey,
    ADD CONSTRAINT bloodtype_pkey PRIMARY KEY (id),
    ADD CONSTRAINT bloodtype_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.cardinaltimeunit
    DROP CONSTRAINT cardinaltimeunit_id_key,
    DROP CONSTRAINT cardinaltimeunit_pkey,
    ADD CONSTRAINT cardinaltimeunit_pkey PRIMARY KEY (id),
    ADD CONSTRAINT cardinaltimeunit_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.cardinaltimeunitstatus
    DROP CONSTRAINT cardinaltimeunitstatus_id_key,
    DROP CONSTRAINT cardinaltimeunitstatus_pkey,
    ADD CONSTRAINT cardinaltimeunitstatus_pkey PRIMARY KEY (id),
    ADD CONSTRAINT cardinaltimeunitstatus_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.civilstatus
    DROP CONSTRAINT civilstatus_id_key,
    DROP CONSTRAINT civilstatus_pkey,
    ADD CONSTRAINT civilstatus_pkey PRIMARY KEY (id),
    ADD CONSTRAINT civilstatus_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.civiltitle
    DROP CONSTRAINT civiltitle_id_key,
    DROP CONSTRAINT civiltitle_pkey,
    ADD CONSTRAINT civiltitle_pkey PRIMARY KEY (id),
    ADD CONSTRAINT civiltitle_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.contractduration
    DROP CONSTRAINT contractduration_id_key,
    DROP CONSTRAINT contractduration_pkey,
    ADD CONSTRAINT contractduration_pkey PRIMARY KEY (id),
    ADD CONSTRAINT contractduration_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.contracttype
    DROP CONSTRAINT contracttype_id_key,
    DROP CONSTRAINT contracttype_pkey,
    ADD CONSTRAINT contracttype_pkey PRIMARY KEY (id),
    ADD CONSTRAINT contracttype_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.country
    DROP CONSTRAINT country_id_key,
    DROP CONSTRAINT country_pkey,
    ADD CONSTRAINT country_pkey PRIMARY KEY (id),
    ADD CONSTRAINT country_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.daypart
    DROP CONSTRAINT daypart_id_key,
    DROP CONSTRAINT daypart_pkey,
    ADD CONSTRAINT daypart_pkey PRIMARY KEY (id),
    ADD CONSTRAINT daypart_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.discipline
    DROP CONSTRAINT discipline_id_key,
    DROP CONSTRAINT discipline_pkey,
    ADD CONSTRAINT discipline_pkey PRIMARY KEY (id),
    ADD CONSTRAINT discipline_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.district
    DROP CONSTRAINT district_id_key,
    DROP CONSTRAINT district_pkey,
    ADD CONSTRAINT district_pkey PRIMARY KEY (id),
    ADD CONSTRAINT district_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.educationarea
    DROP CONSTRAINT educationarea_id_key,
    DROP CONSTRAINT educationarea_pkey,
    ADD CONSTRAINT educationarea_pkey PRIMARY KEY (id),
    ADD CONSTRAINT educationarea_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.educationlevel
    DROP CONSTRAINT educationlevel_id_key,
    DROP CONSTRAINT educationlevel_pkey,
    ADD CONSTRAINT educationlevel_pkey PRIMARY KEY (id),
    ADD CONSTRAINT educationlevel_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.educationtype
    DROP CONSTRAINT educationtype_id_key,
    DROP CONSTRAINT educationtype_pkey,
    ADD CONSTRAINT educationtype_pkey PRIMARY KEY (id),
    ADD CONSTRAINT educationtype_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.endgradegeneral
    ADD CONSTRAINT endgradegeneral_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.endgradetype
    DROP CONSTRAINT endgradetype_id_key,
    DROP CONSTRAINT endgradetype_pkey,
    ADD CONSTRAINT endgradetype_pkey PRIMARY KEY (id),
    ADD CONSTRAINT endgradetype_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.examinationtype
    DROP CONSTRAINT examinationtype_id_key,
    DROP CONSTRAINT examinationtype_pkey,
    ADD CONSTRAINT examinationtype_pkey PRIMARY KEY (id),
    ADD CONSTRAINT examinationtype_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.examtype
    DROP CONSTRAINT examtype_id_key,
    DROP CONSTRAINT examtype_pkey,
    ADD CONSTRAINT examtype_pkey PRIMARY KEY (id),
    ADD CONSTRAINT examtype_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.expellationtype
    DROP CONSTRAINT expellationtype_id_key,
    DROP CONSTRAINT expellationtype_pkey,
    ADD CONSTRAINT expellationtype_pkey PRIMARY KEY (id),
    ADD CONSTRAINT expellationtype_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.failgrade
    ADD CONSTRAINT failgrade_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.fieldofeducation
    DROP CONSTRAINT fieldofeducation_id_key,
    DROP CONSTRAINT fieldofeducation_pkey,
    ADD CONSTRAINT fieldofeducation_pkey PRIMARY KEY (id),
    ADD CONSTRAINT fieldofeducation_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.frequency
    DROP CONSTRAINT frequency_id_key,
    DROP CONSTRAINT frequency_pkey,
    ADD CONSTRAINT frequency_pkey PRIMARY KEY (id),
    ADD CONSTRAINT frequency_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.function
    DROP CONSTRAINT function_id_key,
    DROP CONSTRAINT function_pkey,
    ADD CONSTRAINT function_pkey PRIMARY KEY (id),
    ADD CONSTRAINT function_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.functionlevel
    DROP CONSTRAINT functionlevel_id_key,
    DROP CONSTRAINT functionlevel_pkey,
    ADD CONSTRAINT functionlevel_pkey PRIMARY KEY (id),
    ADD CONSTRAINT functionlevel_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.gender
    DROP CONSTRAINT gender_id_key,
    DROP CONSTRAINT gender_pkey,
    ADD CONSTRAINT gender_pkey PRIMARY KEY (id),
    ADD CONSTRAINT gender_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.gradetype
    ADD CONSTRAINT gradetype_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.identificationtype
    DROP CONSTRAINT identificationtype_id_key,
    DROP CONSTRAINT identificationtype_pkey,
    ADD CONSTRAINT identificationtype_pkey PRIMARY KEY (id),
    ADD CONSTRAINT identificationtype_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.importancetype
    DROP CONSTRAINT subjectimportance_id_key,
    DROP CONSTRAINT subjectimportance_pkey,
    ADD CONSTRAINT importancetype_pkey PRIMARY KEY (id),
    ADD CONSTRAINT importancetype_uq_key UNIQUE (code, lang);

-- duplicate codes exist for Macua and Macondi, there update one of them according ISO 639-3
-- see https://en.wikipedia.org/wiki/Makonde_language
-- Note that there is no official two-letter code for Makonde, so use the 3-letter code for both columns
UPDATE opuscollege.language set code = 'kde', descriptionshort = 'kde' where lower(description) like 'macondi%';
    
ALTER TABLE opuscollege.language
    DROP CONSTRAINT language_id_key,
    DROP CONSTRAINT language_pkey,
    ADD CONSTRAINT language_pkey PRIMARY KEY (id),
    ADD CONSTRAINT language_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.levelofeducation
    DROP CONSTRAINT levelofeducation_id_key,
    DROP CONSTRAINT levelofeducation_pkey,
    ADD CONSTRAINT levelofeducation_pkey PRIMARY KEY (id),
    ADD CONSTRAINT levelofeducation_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.lookuptable
    ADD CONSTRAINT lookuptable_uq_key UNIQUE (tablename);

ALTER TABLE opuscollege.mailconfig
    ADD CONSTRAINT mailconfig_uq_key UNIQUE (msgtype, lang);

ALTER TABLE opuscollege.masteringlevel
    DROP CONSTRAINT masteringlevel_id_key,
    DROP CONSTRAINT masteringlevel_pkey,
    ADD CONSTRAINT masteringlevel_pkey PRIMARY KEY (id),
    ADD CONSTRAINT masteringlevel_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.nationality
    DROP CONSTRAINT nationality_id_key,
    DROP CONSTRAINT nationality_pkey,
    ADD CONSTRAINT nationality_pkey PRIMARY KEY (id),
    ADD CONSTRAINT nationality_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.nationalitygroup
    DROP CONSTRAINT nationalitygroup_id_key,
    DROP CONSTRAINT nationalitygroup_pkey,
    ADD CONSTRAINT nationalitygroup_pkey PRIMARY KEY (id),
    ADD CONSTRAINT nationalitygroup_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.opusprivilege
    DROP CONSTRAINT opusprivilege_id_key,
    DROP CONSTRAINT opusprivilege_lang_key,
    DROP CONSTRAINT opusprivilege_pkey,
    ADD CONSTRAINT opusprivilege_pkey PRIMARY KEY (id),
    ADD CONSTRAINT opusprivilege_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.penaltytype
    DROP CONSTRAINT penaltytype_id_key,
    DROP CONSTRAINT penaltytype_pkey,
    ADD CONSTRAINT penaltytype_pkey PRIMARY KEY (id),
    ADD CONSTRAINT penaltytype_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.profession
    DROP CONSTRAINT profession_id_key,
    DROP CONSTRAINT profession_pkey,
    ADD CONSTRAINT profession_pkey PRIMARY KEY (id),
    ADD CONSTRAINT profession_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.progressstatus
    DROP CONSTRAINT progressstatus_id_key,
    DROP CONSTRAINT progressstatus_pkey,
    ADD CONSTRAINT progressstatus_pkey PRIMARY KEY (id),
    ADD CONSTRAINT progressstatus_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.province
    DROP CONSTRAINT province_id_key,
    DROP CONSTRAINT province_pkey,
    ADD CONSTRAINT province_pkey PRIMARY KEY (id),
    ADD CONSTRAINT province_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.relationtype
    DROP CONSTRAINT relationtype_id_key,
    DROP CONSTRAINT relationtype_pkey,
    ADD CONSTRAINT relationtype_pkey PRIMARY KEY (id),
    ADD CONSTRAINT relationtype_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.rfcstatus
    DROP CONSTRAINT rfcstatus_id_key,
    DROP CONSTRAINT rfcstatus_pkey,
    ADD CONSTRAINT rfcstatus_pkey PRIMARY KEY (id),
    ADD CONSTRAINT rfcstatus_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.rigiditytype
    DROP CONSTRAINT rigiditytype_id_key,
    DROP CONSTRAINT rigiditytype_pkey,
    ADD CONSTRAINT rigiditytype_pkey PRIMARY KEY (id),
    ADD CONSTRAINT rigiditytype_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.stafftype
    DROP CONSTRAINT stafftype_id_key,
    DROP CONSTRAINT stafftype_pkey,
    ADD CONSTRAINT stafftype_pkey PRIMARY KEY (id),
    ADD CONSTRAINT stafftype_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.status
    DROP CONSTRAINT status_id_key,
    DROP CONSTRAINT status_pkey,
    ADD CONSTRAINT status_pkey PRIMARY KEY (id),
    ADD CONSTRAINT status_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.studentstatus
    DROP CONSTRAINT studentstatus_id_key,
    DROP CONSTRAINT studentstatus_pkey,
    ADD CONSTRAINT studentstatus_pkey PRIMARY KEY (id),
    ADD CONSTRAINT studentstatus_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.studyform
    DROP CONSTRAINT studyform_id_key,
    DROP CONSTRAINT studyform_pkey,
    ADD CONSTRAINT studyform_pkey PRIMARY KEY (id),
    ADD CONSTRAINT studyform_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.studyintensity
    DROP CONSTRAINT studyintensity_id_key,
    DROP CONSTRAINT studyintensity_pkey,
    ADD CONSTRAINT studyintensity_pkey PRIMARY KEY (id),
    ADD CONSTRAINT studyintensity_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.studyplanstatus
    DROP CONSTRAINT studyplanstatus_id_key,
    DROP CONSTRAINT studyplanstatus_pkey,
    ADD CONSTRAINT studyplanstatus_pkey PRIMARY KEY (id),
    ADD CONSTRAINT studyplanstatus_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.studytime
    DROP CONSTRAINT studytime_id_key,
    DROP CONSTRAINT studytime_pkey,
    ADD CONSTRAINT studytime_pkey PRIMARY KEY (id),
    ADD CONSTRAINT studytime_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.studytype
    DROP CONSTRAINT studytype_id_key,
    DROP CONSTRAINT studytype_pkey,
    ADD CONSTRAINT studytype_pkey PRIMARY KEY (id),
    ADD CONSTRAINT studytype_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.tabledependency
    ADD CONSTRAINT tabledependency_uq_key UNIQUE (dependenttable, dependenttablecolumn);

ALTER TABLE opuscollege.targetgroup
    DROP CONSTRAINT targetgroup_id_key,
    DROP CONSTRAINT targetgroup_pkey,
    ADD CONSTRAINT targetgroup_pkey PRIMARY KEY (id),
    ADD CONSTRAINT targetgroup_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.thesisstatus
    DROP CONSTRAINT thesisstatus_id_key,
    DROP CONSTRAINT thesisstatus_pkey,
    ADD CONSTRAINT thesisstatus_pkey PRIMARY KEY (id),
    ADD CONSTRAINT thesisstatus_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.unitarea
    DROP CONSTRAINT unitarea_id_key,
    DROP CONSTRAINT unitarea_pkey,
    ADD CONSTRAINT unitarea_pkey PRIMARY KEY (id),
    ADD CONSTRAINT unitarea_uq_key UNIQUE (code, lang);

ALTER TABLE opuscollege.unittype
    DROP CONSTRAINT unittype_id_key,
    DROP CONSTRAINT unittype_pkey,
    ADD CONSTRAINT unittype_pkey PRIMARY KEY (id),
    ADD CONSTRAINT unittype_uq_key UNIQUE (code, lang);

-------------------------------------------------------
-- academicyear: set unique constraint
-------------------------------------------------------
ALTER TABLE opuscollege.academicyear ADD CONSTRAINT academicyear_uq_key UNIQUE (description);
    
-------------------------------------------------------
-- set geonameid in order to avoid duplicates upon adding geoname records
-------------------------------------------------------

-- province: set geonamid
update opuscollege.province set geonameid = 1051823 where code = 'MZ-01';
update opuscollege.province set geonameid = 1046058 where code = 'MZ-02';
update opuscollege.province set geonameid = 1045110 where code = 'MZ-03';
update opuscollege.province set geonameid = 1040947 where code = 'MZ-04';
update opuscollege.province set geonameid = 1040649 where code = 'MZ-05';
update opuscollege.province set geonameid = 1033354 where code = 'MZ-06';
update opuscollege.province set geonameid = 1030006 where code = 'MZ-07';
update opuscollege.province set geonameid = 1026804 where code = 'MZ-08';
update opuscollege.province set geonameid = 1026010 where code = 'MZ-09';
update opuscollege.province set geonameid = 1024312 where code = 'MZ-10';
update opuscollege.province set geonameid = 1105845 where code = 'MZ-11';

-- Angola (AO)
update opuscollege.province set geonameid = 3348310 where code = '25'; -- Huambo
update opuscollege.province set geonameid = 2243598 where code = '28'; -- Bengo
update opuscollege.province set geonameid = 3351640 where code = '31'; -- Bie
update opuscollege.province set geonameid = 3351660 where code = '34'; -- Benguela
update opuscollege.province set geonameid = 2243266 where code = '37'; -- Cabinda
update opuscollege.province set geonameid = 876337 where code = '40'; -- Kuando Kubango
update opuscollege.province set geonameid = 2241660 where code = '43'; -- Cuanza Norte Province
update opuscollege.province set geonameid = 2240444 where code = '61'; -- Luanda

-- Kenia (KE)
update opuscollege.province set geonameid = 192709 where code = '46'; -- Kiambu

-- Italy (IT)
update opuscollege.province set geonameid = 3164604 where code = '49';

-- Zambia (ZM)
update opuscollege.province set geonameid = 921064 where code = 'ZM-01';
update opuscollege.province set geonameid = 917524 where code = 'ZM-02';
update opuscollege.province set geonameid = 917388 where code = 'ZM-03';
update opuscollege.province set geonameid = 909845 where code = 'ZM-04';
update opuscollege.province set geonameid = 909129 where code = 'ZM-05';
update opuscollege.province set geonameid = 900601 where code = 'ZM-06';
update opuscollege.province set geonameid = 900594 where code = 'ZM-07';
update opuscollege.province set geonameid = 896972 where code = 'ZM-08';
update opuscollege.province set geonameid = 896140 where code = 'ZM-09';

-- district: set geonamid
update opuscollege.district set geonameid = 7909876 where code = 'MZ-01-01';
update opuscollege.district set geonameid = 9252729 where code = 'MZ-01-02';
update opuscollege.district set geonameid = 1045383 where code = 'MZ-01-03';
update opuscollege.district set geonameid = 1042455 where code = 'MZ-01-04';
update opuscollege.district set geonameid = 1039148 where code = 'MZ-01-05';
update opuscollege.district set geonameid = 9252727 where code = 'MZ-01-06';
update opuscollege.district set geonameid = 1037368 where code = 'MZ-01-07';
update opuscollege.district set geonameid = 8299277 where code = 'MZ-01-08';
update opuscollege.district set geonameid = 7909845 where code = 'MZ-01-09';
update opuscollege.district set geonameid = 7911292 where code = 'MZ-01-10';
update opuscollege.district set geonameid = 1029247 where code = 'MZ-01-11';
update opuscollege.district set geonameid = 7646427 where code = 'MZ-01-12'; -- Pemba-Metuge inexistent and replaced with Pemba
update opuscollege.district set geonameid = 1028315 where code = 'MZ-01-13';
update opuscollege.district set geonameid = 7646427 where code = 'MZ-01-14';
update opuscollege.district set geonameid = 7874119 where code = 'MZ-01-15';
update opuscollege.district set geonameid = 9252735 where code = 'MZ-01-16';
update opuscollege.district set geonameid = 9252736 where code = 'MZ-01-17';

update opuscollege.district set geonameid = 9072735 where code = 'MZ-02-01';
update opuscollege.district set geonameid = 9252728 where code = 'MZ-02-02';
update opuscollege.district set geonameid = 1049858 where code = 'MZ-02-03';
update opuscollege.district set geonameid = 7670759 where code = 'MZ-02-04';
update opuscollege.district set geonameid = 9408663 where code = 'MZ-02-05';
update opuscollege.district set geonameid = 7874104 where code = 'MZ-02-06';
update opuscollege.district set geonameid = 1040936 where code = 'MZ-02-07';
update opuscollege.district set geonameid = 7670767 where code = 'MZ-02-08';
update opuscollege.district set geonameid = 10668849 where code = 'MZ-02-09';   -- the geonameid is indeed one digit longer than the others
update opuscollege.district set geonameid = 7670772 where code = 'MZ-02-10';
update opuscollege.district set geonameid = 7670774 where code = 'MZ-02-11';
update opuscollege.district set geonameid = 7670771 where code = 'MZ-02-12';

update opuscollege.district set geonameid = 1045762 where code = 'MZ-03-01';
update opuscollege.district set geonameid = 7670768 where code = 'MZ-03-02';
update opuscollege.district set geonameid = 7909785 where code = 'MZ-03-03';
update opuscollege.district set geonameid = 9252733 where code = 'MZ-03-04';
update opuscollege.district set geonameid = 9252733 where code = '330';
update opuscollege.district set geonameid = 7909784 where code = 'MZ-03-05';
update opuscollege.district set geonameid = 7909783 where code = 'MZ-03-06';
update opuscollege.district set geonameid = 7909715 where code = 'MZ-03-07';
update opuscollege.district set geonameid = 7909780 where code = 'MZ-03-08';
update opuscollege.district set geonameid = 7909786 where code = 'MZ-03-09';
update opuscollege.district set geonameid = 9252738 where code = 'MZ-03-10';
update opuscollege.district set geonameid = 7670754 where code = 'MZ-03-11';
update opuscollege.district set geonameid = 7909714 where code = 'MZ-03-12';
update opuscollege.district set geonameid = 9252722 where code = 'MZ-03-13';
update opuscollege.district set geonameid = 7909781 where code = 'MZ-03-14';

update opuscollege.district set geonameid = 1052446 where code = 'MZ-04-01';
update opuscollege.district set geonameid = 7646374 where code = 'MZ-04-02';
update opuscollege.district set geonameid = 1049260 where code = 'MZ-04-03';
update opuscollege.district set geonameid = 1035732 where code = 'MZ-04-04';
update opuscollege.district set geonameid = 1040948 where code = 'MZ-04-05';
update opuscollege.district set geonameid = 1037018 where code = 'MZ-04-06';
update opuscollege.district set geonameid = 7670758 where code = 'MZ-04-07';
update opuscollege.district set geonameid = 7874624 where code = 'MZ-04-08';
update opuscollege.district set geonameid = 7874620 where code = 'MZ-04-09';
update opuscollege.district set geonameid = 7874622 where code = 'MZ-04-11';  -- MZ-04-10 was missing in the db

update opuscollege.district set geonameid = 7873983 where code = 'MZ-05-01';
update opuscollege.district set geonameid = 7873976 where code = 'MZ-05-02';
update opuscollege.district set geonameid = 1090080 where code = 'MZ-05-03';
update opuscollege.district set geonameid = 8693192 where code = 'MZ-05-04';
update opuscollege.district set geonameid = 7670756 where code = 'MZ-05-05';
update opuscollege.district set geonameid = 7873980 where code = 'MZ-05-06';
update opuscollege.district set geonameid = 8301113 where code = 'MZ-05-07';
update opuscollege.district set geonameid = 1039852 where code = 'MZ-05-08';

update opuscollege.district set geonameid = 7874406 where code = 'MZ-06-01';
update opuscollege.district set geonameid = 7874411 where code = 'MZ-06-02';
update opuscollege.district set geonameid = 9252730 where code = 'MZ-06-03';
update opuscollege.district set geonameid = 9072697 where code = 'MZ-06-04';
update opuscollege.district set geonameid = 7732034 where code = 'MZ-06-05';
update opuscollege.district set geonameid = 1039205 where code = 'MZ-06-06';
update opuscollege.district set geonameid = 7732037 where code = 'MZ-06-07';
update opuscollege.district set geonameid = 1038879 where code = 'MZ-06-08';
update opuscollege.district set geonameid = 1037286 where code = 'MZ-06-09';
update opuscollege.district set geonameid = 1037282 where code = 'MZ-06-10';
update opuscollege.district set geonameid = 1037222 where code = 'MZ-06-11';
update opuscollege.district set geonameid = 1037178 where code = 'MZ-06-12';
update opuscollege.district set geonameid = 1037020 where code = 'MZ-06-13';
update opuscollege.district set geonameid = 7874410 where code = 'MZ-06-14';
update opuscollege.district set geonameid = 1035470 where code = 'MZ-06-15';
update opuscollege.district set geonameid = 1035018 where code = 'MZ-06-16';
update opuscollege.district set geonameid = 7732036 where code = 'MZ-06-17';
update opuscollege.district set geonameid = 7732036 where code = '327';
update opuscollege.district set geonameid = 7732038 where code = 'MZ-06-18';
update opuscollege.district set geonameid = 1033355 where code = 'MZ-06-19';
update opuscollege.district set geonameid = 7874408 where code = 'MZ-06-20';
update opuscollege.district set geonameid = 1046627 where code = 'MZ-06-21';
update opuscollege.district set geonameid = 1046627 where code = '321';

update opuscollege.district set geonameid = 7732033 where code = 'MZ-07-01';
update opuscollege.district set geonameid = 7874117 where code = 'MZ-07-02';
update opuscollege.district set geonameid = 1041189 where code = 'MZ-07-03';
update opuscollege.district set geonameid = 8299276 where code = 'MZ-07-04';
update opuscollege.district set geonameid = 7874416 where code = 'MZ-07-05';
update opuscollege.district set geonameid = 9252721 where code = 'MZ-07-06';
update opuscollege.district set geonameid = 7874417 where code = 'MZ-07-07';
update opuscollege.district set geonameid = 1039135 where code = 'MZ-07-08';
update opuscollege.district set geonameid = 7874414 where code = 'MZ-07-09';
update opuscollege.district set geonameid = 7874115 where code = 'MZ-07-10';
update opuscollege.district set geonameid = 10651614 where code = 'MZ-07-11';
update opuscollege.district set geonameid = 1027397 where code = 'MZ-07-12';
--update opuscollege.district set geonameid =  where code = 'MZ-07-13';   was 'Lucheringo' which seems to be an unknown district
update opuscollege.district set geonameid = 7874419 where code = 'MZ-07-14';
update opuscollege.district set geonameid = 7874420 where code = 'MZ-07-15';
update opuscollege.district set geonameid = 7874418 where code = 'MZ-07-16';
update opuscollege.district set geonameid = 7874421 where code = 'MZ-07-17';

update opuscollege.district set geonameid = 1052372 where code = 'MZ-08-01';
update opuscollege.district set geonameid = 1051852 where code = 'MZ-08-02';
update opuscollege.district set geonameid = 7874046 where code = 'MZ-08-03';
update opuscollege.district set geonameid = 7874471 where code = 'MZ-08-04';
update opuscollege.district set geonameid = 7874614 where code = 'MZ-08-05';
update opuscollege.district set geonameid = 7874472 where code = 'MZ-08-06';
update opuscollege.district set geonameid = 7873985 where code = 'MZ-08-07';
update opuscollege.district set geonameid = 7874474 where code = 'MZ-08-08';
update opuscollege.district set geonameid = 7873986 where code = 'MZ-08-09';
update opuscollege.district set geonameid = 7873984 where code = 'MZ-08-10';
update opuscollege.district set geonameid = 1045789 where code = 'MZ-08-11';
update opuscollege.district set geonameid = 7874473 where code = 'MZ-08-12';
update opuscollege.district set geonameid = 1040396 where code = 'MZ-08-13';

update opuscollege.district set geonameid = 1052937 where code = 'MZ-09-01';
update opuscollege.district set geonameid = 7909828 where code = 'MZ-09-02';
update opuscollege.district set geonameid = 7905529 where code = 'MZ-09-03';
update opuscollege.district set geonameid = 1042871 where code = 'MZ-09-04';
update opuscollege.district set geonameid = 1040587 where code = 'MZ-09-05';
update opuscollege.district set geonameid = 1037394 where code = 'MZ-09-06';
update opuscollege.district set geonameid = 1041912 where code = 'MZ-09-07';
update opuscollege.district set geonameid = 1035304 where code = 'MZ-09-08';
update opuscollege.district set geonameid = 9252731 where code = 'MZ-09-09';
update opuscollege.district set geonameid = 9252739 where code = 'MZ-09-10';
update opuscollege.district set geonameid = 7905000 where code = 'MZ-09-11';
update opuscollege.district set geonameid = 7874106 where code = 'MZ-09-12';
update opuscollege.district set geonameid = 7905199 where code = 'MZ-09-13';

update opuscollege.district set geonameid = 1053142 where code = 'MZ-10-01';
update opuscollege.district set geonameid = 1049181 where code = 'MZ-10-02';
update opuscollege.district set geonameid = 7874708 where code = 'MZ-10-03';
update opuscollege.district set geonameid = 7873991 where code = 'MZ-10-04';
update opuscollege.district set geonameid = 1045351 where code = 'MZ-10-05';
update opuscollege.district set geonameid = 7874710 where code = 'MZ-10-06';
update opuscollege.district set geonameid = 7874711 where code = 'MZ-10-07';
update opuscollege.district set geonameid = 7874712 where code = 'MZ-10-08';
update opuscollege.district set geonameid = 7880951 where code = 'MZ-10-09';
update opuscollege.district set geonameid = 1037109 where code = 'MZ-10-10';
update opuscollege.district set geonameid = 7873993 where code = 'MZ-10-11';
update opuscollege.district set geonameid = 8714615 where code = 'MZ-10-12';
update opuscollege.district set geonameid = 7874724 where code = 'MZ-10-13';
update opuscollege.district set geonameid = 7874726 where code = 'MZ-10-14';
update opuscollege.district set geonameid = 1028433 where code = 'MZ-10-16';
update opuscollege.district set geonameid = 7873988 where code = 'MZ-10-17';
update opuscollege.district set geonameid = 7909704 where code = 'MZ-10-18';

update opuscollege.district set geonameid = 10685830 where code = 'MZ-11-01';
update opuscollege.district set geonameid = 10685828 where code = 'MZ-11-02';
update opuscollege.district set geonameid = 10685829 where code = 'MZ-11-03';
update opuscollege.district set geonameid = 10685827 where code = 'MZ-11-04';
update opuscollege.district set geonameid = 10683815 where code = 'MZ-11-05';
update opuscollege.district set geonameid = 10685831 where code = 'MZ-11-06';
update opuscollege.district set geonameid = 10685832 where code = 'MZ-11-07';

update opuscollege.district set geonameid = 10701340 where code = '372';   -- Vanduzi

-- Angola (AO)
update opuscollege.district set geonameid = 3348311 where code = '339';

-- Italy (IT)
update opuscollege.district set geonameid = 3165200 where code = '354';

-- Zambia (ZM)
update opuscollege.district set geonameid = 8714549  where code = 'ZM-01-01';
update opuscollege.district set geonameid = 916082   where code = 'ZM-01-02';
update opuscollege.district set geonameid = 916077   where code = 'ZM-01-03';
update opuscollege.district set geonameid = 906219   where code = 'ZM-01-04';
update opuscollege.district set geonameid = 904420   where code = 'ZM-01-05';
update opuscollege.district set geonameid = 898909   where code = 'ZM-01-06';
update opuscollege.district set geonameid = 919540   where code = 'ZM-02-01';
update opuscollege.district set geonameid = 919006   where code = 'ZM-02-02';
update opuscollege.district set geonameid = 914956   where code = 'ZM-02-03';
update opuscollege.district set geonameid = 911144   where code = 'ZM-02-04';
update opuscollege.district set geonameid = 909857   where code = 'ZM-02-05';
update opuscollege.district set geonameid = 10801768 where code = 'ZM-02-06';
update opuscollege.district set geonameid = 8285557  where code = 'ZM-02-07';
update opuscollege.district set geonameid = 9072524  where code = 'ZM-02-08';
update opuscollege.district set geonameid = 905389   where code = 'ZM-02-09';
update opuscollege.district set geonameid = 901342   where code = 'ZM-02-10';
update opuscollege.district set geonameid = 921026   where code = 'ZM-03-01';
update opuscollege.district set geonameid = 920896   where code = 'ZM-03-02';
update opuscollege.district set geonameid = 918699   where code = 'ZM-03-03';
update opuscollege.district set geonameid = 912053   where code = 'ZM-03-04';
update opuscollege.district set geonameid = 909296   where code = 'ZM-03-05';
update opuscollege.district set geonameid = 10800895 where code = 'ZM-03-06';
update opuscollege.district set geonameid = 7732619  where code = 'ZM-03-07';
update opuscollege.district set geonameid = 899821   where code = 'ZM-03-08';
update opuscollege.district set geonameid = 10800891 where code = 'ZM-04-01';
update opuscollege.district set geonameid = 176553   where code = 'ZM-04-02';
update opuscollege.district set geonameid = 907767   where code = 'ZM-04-03';
update opuscollege.district set geonameid = 10800892 where code = 'ZM-04-04';
update opuscollege.district set geonameid = 902718   where code = 'ZM-04-05';
update opuscollege.district set geonameid = 175497   where code = 'ZM-04-06';
update opuscollege.district set geonameid = 899273   where code = 'ZM-04-07';
update opuscollege.district set geonameid = 7910080  where code = 'ZM-05-01';
update opuscollege.district set geonameid = 7671220  where code = 'ZM-05-02';
update opuscollege.district set geonameid = 909886   where code = 'ZM-05-03';
update opuscollege.district set geonameid = 909134   where code = 'ZM-05-04';
update opuscollege.district set geonameid = 10800890 where code = 'ZM-06-01';
update opuscollege.district set geonameid = 918903   where code = 'ZM-06-02';
update opuscollege.district set geonameid = 916666   where code = 'ZM-06-03';
update opuscollege.district set geonameid = 176756   where code = 'ZM-06-04';
update opuscollege.district set geonameid = 912763   where code = 'ZM-06-05';
update opuscollege.district set geonameid = 908911   where code = 'ZM-06-06';
update opuscollege.district set geonameid = 176143   where code = 'ZM-06-07';
update opuscollege.district set geonameid = 905843   where code = 'ZM-06-08';
update opuscollege.district set geonameid = 175966   where code = 'ZM-06-09';
update opuscollege.district set geonameid = 8260556  where code = 'ZM-06-10';
update opuscollege.district set geonameid = 8260557  where code = 'ZM-06-11';
update opuscollege.district set geonameid = 10801797 where code = 'ZM-07-01';
update opuscollege.district set geonameid = 916244   where code = 'ZM-07-02';
update opuscollege.district set geonameid = 912623   where code = 'ZM-07-03';
update opuscollege.district set geonameid = 10801798 where code = 'ZM-07-04';
update opuscollege.district set geonameid = 902616   where code = 'ZM-07-05';
update opuscollege.district set geonameid = 897041   where code = 'ZM-07-06';
update opuscollege.district set geonameid = 895952   where code = 'ZM-07-07';
update opuscollege.district set geonameid = 917743   where code = 'ZM-08-01';
update opuscollege.district set geonameid = 917010   where code = 'ZM-08-02';
update opuscollege.district set geonameid = 8714550  where code = 'ZM-08-03';
update opuscollege.district set geonameid = 915082   where code = 'ZM-08-04';
update opuscollege.district set geonameid = 8260555  where code = 'ZM-08-05';
update opuscollege.district set geonameid = 910107   where code = 'ZM-08-06';
update opuscollege.district set geonameid = 907108   where code = 'ZM-08-07';
update opuscollege.district set geonameid = 906042   where code = 'ZM-08-08';
update opuscollege.district set geonameid = 901764   where code = 'ZM-08-09';
update opuscollege.district set geonameid = 7671219  where code = 'ZM-08-10';
update opuscollege.district set geonameid = 9072525  where code = 'ZM-08-11';
update opuscollege.district set geonameid = 915468   where code = 'ZM-09-01';
update opuscollege.district set geonameid = 913321   where code = 'ZM-09-02';
update opuscollege.district set geonameid = 909482   where code = 'ZM-09-03';
update opuscollege.district set geonameid = 906052   where code = 'ZM-09-04';
update opuscollege.district set geonameid = 898945   where code = 'ZM-09-05';
update opuscollege.district set geonameid = 898902   where code = 'ZM-09-06';
update opuscollege.district set geonameid = 10801800 where code = 'ZM-09-07';


-------------------------------------------------------
-- update countrycode fields
-------------------------------------------------------

update opuscollege.address set countrycode = (
  select distinct short2 from opuscollege.country where address.countrycode = country.code
) where countrycode not in ('', '0');
update opuscollege.person set countryofbirthcode = (
  select distinct short2 from opuscollege.country where person.countryofbirthcode = country.code
) where countryofbirthcode not in ('', '0');
update opuscollege.person set countryoforigincode = (
  select distinct short2 from opuscollege.country where person.countryoforigincode = country.code
) where countryoforigincode not in ('', '0');
update opuscollege.province set countrycode = (
  select distinct short2 from opuscollege.country where province.countrycode = country.code
);
update opuscollege.student set previousinstitutioncountrycode = (
  select distinct short2 from opuscollege.country where student.previousinstitutioncountrycode = country.code
) where previousinstitutioncountrycode not in ('', '0');

update audit.staffmember_hist set countryofbirthcode = (
  select distinct short2 from opuscollege.country where staffmember_hist.countryofbirthcode = country.code
) where countryofbirthcode not in ('', '0');
update audit.staffmember_hist set countryoforigincode = (
  select distinct short2 from opuscollege.country where staffmember_hist.countryoforigincode = country.code
) where countryoforigincode not in ('', '0');
update audit.student_hist set previousinstitutioncountrycode = (
  select distinct short2 from opuscollege.country where student_hist.previousinstitutioncountrycode = country.code
) where previousinstitutioncountrycode not in ('', '0');
update audit.student_hist set countryofbirthcode = (
  select distinct short2 from opuscollege.country where student_hist.countryofbirthcode = country.code
) where countryofbirthcode not in ('', '0');
update audit.student_hist set countryoforigincode = (
  select distinct short2 from opuscollege.country where student_hist.countryoforigincode = country.code
) where countryoforigincode not in ('', '0');


-- replace entire country table
SET search_path = opuscollege, pg_catalog;

truncate opuscollege.country;
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AD', 'en', 'Y', 'AD', 'AND', 'Andorra', 3041565);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AE', 'en', 'Y', 'AE', 'ARE', 'United Arab Emirates', 290557);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AF', 'en', 'Y', 'AF', 'AFG', 'Afghanistan', 1149361);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AG', 'en', 'Y', 'AG', 'ATG', 'Antigua and Barbuda', 3576396);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AI', 'en', 'Y', 'AI', 'AIA', 'Anguilla', 3573511);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AL', 'en', 'Y', 'AL', 'ALB', 'Albania', 783754);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AM', 'en', 'Y', 'AM', 'ARM', 'Armenia', 174982);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AN', 'en', 'Y', 'AN', 'ANT', 'Netherlands Antilles', 8505032);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AO', 'en', 'Y', 'AO', 'AGO', 'Angola', 3351879);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AQ', 'en', 'Y', 'AQ', 'ATA', 'Antarctica', 6697173);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AR', 'en', 'Y', 'AR', 'ARG', 'Argentina', 3865483);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AS', 'en', 'Y', 'AS', 'ASM', 'American Samoa', 5880801);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AT', 'en', 'Y', 'AT', 'AUT', 'Austria', 2782113);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AU', 'en', 'Y', 'AU', 'AUS', 'Australia', 2077456);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AW', 'en', 'Y', 'AW', 'ABW', 'Aruba', 3577279);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AX', 'en', 'Y', 'AX', 'ALA', 'Åland Islands', 661882);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AZ', 'en', 'Y', 'AZ', 'AZE', 'Azerbaijan', 587116);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BA', 'en', 'Y', 'BA', 'BIH', 'Bosnia and Herzegovina', 3277605);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BB', 'en', 'Y', 'BB', 'BRB', 'Barbados', 3374084);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BD', 'en', 'Y', 'BD', 'BGD', 'Bangladesh', 1210997);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BE', 'en', 'Y', 'BE', 'BEL', 'Belgium', 2802361);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BF', 'en', 'Y', 'BF', 'BFA', 'Burkina Faso', 2361809);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BG', 'en', 'Y', 'BG', 'BGR', 'Bulgaria', 732800);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BH', 'en', 'Y', 'BH', 'BHR', 'Bahrain', 290291);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BI', 'en', 'Y', 'BI', 'BDI', 'Burundi', 433561);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BJ', 'en', 'Y', 'BJ', 'BEN', 'Benin', 2395170);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BL', 'en', 'Y', 'BL', 'BLM', 'Saint Barthélemy', 3578476);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BM', 'en', 'Y', 'BM', 'BMU', 'Bermuda', 3573345);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BN', 'en', 'Y', 'BN', 'BRN', 'Brunei', 1820814);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BO', 'en', 'Y', 'BO', 'BOL', 'Bolivia', 3923057);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BQ', 'en', 'Y', 'BQ', 'BES', 'Bonaire, Saint Eustatius, and Saba', 7626844);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BR', 'en', 'Y', 'BR', 'BRA', 'Brazil', 3469034);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BS', 'en', 'Y', 'BS', 'BHS', 'Bahamas', 3572887);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BT', 'en', 'Y', 'BT', 'BTN', 'Bhutan', 1252634);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BV', 'en', 'Y', 'BV', 'BVT', 'Bouvet Island', 3371123);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BW', 'en', 'Y', 'BW', 'BWA', 'Botswana', 933860);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BY', 'en', 'Y', 'BY', 'BLR', 'Belarus', 630336);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BZ', 'en', 'Y', 'BZ', 'BLZ', 'Belize', 3582678);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CA', 'en', 'Y', 'CA', 'CAN', 'Canada', 6251999);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CC', 'en', 'Y', 'CC', 'CCK', 'Cocos [Keeling] Islands', 1547376);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CD', 'en', 'Y', 'CD', 'COD', 'Congo', 203312);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CF', 'en', 'Y', 'CF', 'CAF', 'Central African Republic', 239880);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CG', 'en', 'Y', 'CG', 'COG', 'Congo', 2260494);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CH', 'en', 'Y', 'CH', 'CHE', 'Switzerland', 2658434);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CI', 'en', 'Y', 'CI', 'CIV', 'Ivory Coast', 2287781);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CK', 'en', 'Y', 'CK', 'COK', 'Cook Islands', 1899402);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CL', 'en', 'Y', 'CL', 'CHL', 'Chile', 3895114);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CM', 'en', 'Y', 'CM', 'CMR', 'Cameroon', 2233387);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CN', 'en', 'Y', 'CN', 'CHN', 'China', 1814991);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CO', 'en', 'Y', 'CO', 'COL', 'Colombia', 3686110);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CR', 'en', 'Y', 'CR', 'CRI', 'Costa Rica', 3624060);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CS', 'en', 'Y', 'CS', 'SCG', 'Serbia and Montenegro', 8505033);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CU', 'en', 'Y', 'CU', 'CUB', 'Cuba', 3562981);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CV', 'en', 'Y', 'CV', 'CPV', 'Cape Verde', 3374766);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CW', 'en', 'Y', 'CW', 'CUW', 'Curaçao', 7626836);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CX', 'en', 'Y', 'CX', 'CXR', 'Christmas Island', 2078138);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CY', 'en', 'Y', 'CY', 'CYP', 'Cyprus', 146669);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CZ', 'en', 'Y', 'CZ', 'CZE', 'Czech Republic', 3077311);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('DE', 'en', 'Y', 'DE', 'DEU', 'Germany', 2921044);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('DJ', 'en', 'Y', 'DJ', 'DJI', 'Djibouti', 223816);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('DK', 'en', 'Y', 'DK', 'DNK', 'Denmark', 2623032);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('DM', 'en', 'Y', 'DM', 'DMA', 'Dominica', 3575830);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('DO', 'en', 'Y', 'DO', 'DOM', 'Dominican Republic', 3508796);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('DZ', 'en', 'Y', 'DZ', 'DZA', 'Algeria', 2589581);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('EC', 'en', 'Y', 'EC', 'ECU', 'Ecuador', 3658394);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('EE', 'en', 'Y', 'EE', 'EST', 'Estonia', 453733);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('EG', 'en', 'Y', 'EG', 'EGY', 'Egypt', 357994);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('EH', 'en', 'Y', 'EH', 'ESH', 'Western Sahara', 2461445);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ER', 'en', 'Y', 'ER', 'ERI', 'Eritrea', 338010);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ES', 'en', 'Y', 'ES', 'ESP', 'Spain', 2510769);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ET', 'en', 'Y', 'ET', 'ETH', 'Ethiopia', 337996);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('FI', 'en', 'Y', 'FI', 'FIN', 'Finland', 660013);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('FJ', 'en', 'Y', 'FJ', 'FJI', 'Fiji', 2205218);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('FK', 'en', 'Y', 'FK', 'FLK', 'Falkland Islands', 3474414);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('FM', 'en', 'Y', 'FM', 'FSM', 'Micronesia', 2081918);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('FO', 'en', 'Y', 'FO', 'FRO', 'Faroe Islands', 2622320);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('FR', 'en', 'Y', 'FR', 'FRA', 'France', 3017382);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GA', 'en', 'Y', 'GA', 'GAB', 'Gabon', 2400553);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GB', 'en', 'Y', 'GB', 'GBR', 'United Kingdom', 2635167);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GD', 'en', 'Y', 'GD', 'GRD', 'Grenada', 3580239);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GE', 'en', 'Y', 'GE', 'GEO', 'Georgia', 614540);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GF', 'en', 'Y', 'GF', 'GUF', 'French Guiana', 3381670);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GG', 'en', 'Y', 'GG', 'GGY', 'Guernsey', 3042362);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GH', 'en', 'Y', 'GH', 'GHA', 'Ghana', 2300660);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GI', 'en', 'Y', 'GI', 'GIB', 'Gibraltar', 2411586);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GL', 'en', 'Y', 'GL', 'GRL', 'Greenland', 3425505);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GM', 'en', 'Y', 'GM', 'GMB', 'The Gambia', 2413451);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GN', 'en', 'Y', 'GN', 'GIN', 'Guinea', 2420477);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GP', 'en', 'Y', 'GP', 'GLP', 'Guadeloupe', 3579143);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GQ', 'en', 'Y', 'GQ', 'GNQ', 'Equatorial Guinea', 2309096);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GR', 'en', 'Y', 'GR', 'GRC', 'Greece', 390903);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PN', 'en', 'Y', 'PN', 'PCN', 'Pitcairn Islands', 4030699);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GS', 'en', 'Y', 'GS', 'SGS', 'South Georgia and the South Sandwich Islands', 3474415);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GT', 'en', 'Y', 'GT', 'GTM', 'Guatemala', 3595528);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GU', 'en', 'Y', 'GU', 'GUM', 'Guam', 4043988);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GW', 'en', 'Y', 'GW', 'GNB', 'Guinea-Bissau', 2372248);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GY', 'en', 'Y', 'GY', 'GUY', 'Guyana', 3378535);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('HK', 'en', 'Y', 'HK', 'HKG', 'Hong Kong', 1819730);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('HM', 'en', 'Y', 'HM', 'HMD', 'Heard Island and McDonald Islands', 1547314);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('HN', 'en', 'Y', 'HN', 'HND', 'Honduras', 3608932);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('HR', 'en', 'Y', 'HR', 'HRV', 'Croatia', 3202326);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('HT', 'en', 'Y', 'HT', 'HTI', 'Haiti', 3723988);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('HU', 'en', 'Y', 'HU', 'HUN', 'Hungary', 719819);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ID', 'en', 'Y', 'ID', 'IDN', 'Indonesia', 1643084);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('IE', 'en', 'Y', 'IE', 'IRL', 'Ireland', 2963597);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('IL', 'en', 'Y', 'IL', 'ISR', 'Israel', 294640);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('IM', 'en', 'Y', 'IM', 'IMN', 'Isle of Man', 3042225);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('IN', 'en', 'Y', 'IN', 'IND', 'India', 1269750);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('IO', 'en', 'Y', 'IO', 'IOT', 'British Indian Ocean Territory', 1282588);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('IQ', 'en', 'Y', 'IQ', 'IRQ', 'Iraq', 99237);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('IR', 'en', 'Y', 'IR', 'IRN', 'Iran', 130758);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('IS', 'en', 'Y', 'IS', 'ISL', 'Iceland', 2629691);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('IT', 'en', 'Y', 'IT', 'ITA', 'Italy', 3175395);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('JE', 'en', 'Y', 'JE', 'JEY', 'Jersey', 3042142);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('JM', 'en', 'Y', 'JM', 'JAM', 'Jamaica', 3489940);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('JO', 'en', 'Y', 'JO', 'JOR', 'Hashemite Kingdom of Jordan', 248816);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('JP', 'en', 'Y', 'JP', 'JPN', 'Japan', 1861060);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KE', 'en', 'Y', 'KE', 'KEN', 'Kenya', 192950);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KG', 'en', 'Y', 'KG', 'KGZ', 'Kyrgyzstan', 1527747);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KH', 'en', 'Y', 'KH', 'KHM', 'Cambodia', 1831722);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KI', 'en', 'Y', 'KI', 'KIR', 'Kiribati', 4030945);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KM', 'en', 'Y', 'KM', 'COM', 'Comoros', 921929);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KN', 'en', 'Y', 'KN', 'KNA', 'Saint Kitts and Nevis', 3575174);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KP', 'en', 'Y', 'KP', 'PRK', 'North Korea', 1873107);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KR', 'en', 'Y', 'KR', 'KOR', 'South Korea', 1835841);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KW', 'en', 'Y', 'KW', 'KWT', 'Kuwait', 285570);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KY', 'en', 'Y', 'KY', 'CYM', 'Cayman Islands', 3580718);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KZ', 'en', 'Y', 'KZ', 'KAZ', 'Kazakhstan', 1522867);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LA', 'en', 'Y', 'LA', 'LAO', 'Laos', 1655842);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LB', 'en', 'Y', 'LB', 'LBN', 'Lebanon', 272103);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LC', 'en', 'Y', 'LC', 'LCA', 'Saint Lucia', 3576468);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LI', 'en', 'Y', 'LI', 'LIE', 'Liechtenstein', 3042058);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LK', 'en', 'Y', 'LK', 'LKA', 'Sri Lanka', 1227603);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LR', 'en', 'Y', 'LR', 'LBR', 'Liberia', 2275384);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LS', 'en', 'Y', 'LS', 'LSO', 'Lesotho', 932692);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LT', 'en', 'Y', 'LT', 'LTU', 'Lithuania', 597427);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LU', 'en', 'Y', 'LU', 'LUX', 'Luxembourg', 2960313);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LV', 'en', 'Y', 'LV', 'LVA', 'Latvia', 458258);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LY', 'en', 'Y', 'LY', 'LBY', 'Libya', 2215636);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MA', 'en', 'Y', 'MA', 'MAR', 'Morocco', 2542007);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MC', 'en', 'Y', 'MC', 'MCO', 'Monaco', 2993457);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MD', 'en', 'Y', 'MD', 'MDA', 'Moldova', 617790);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ME', 'en', 'Y', 'ME', 'MNE', 'Montenegro', 3194884);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MF', 'en', 'Y', 'MF', 'MAF', 'Saint Martin', 3578421);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MG', 'en', 'Y', 'MG', 'MDG', 'Madagascar', 1062947);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MH', 'en', 'Y', 'MH', 'MHL', 'Marshall Islands', 2080185);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MK', 'en', 'Y', 'MK', 'MKD', 'Macedonia', 718075);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ML', 'en', 'Y', 'ML', 'MLI', 'Mali', 2453866);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MM', 'en', 'Y', 'MM', 'MMR', 'Myanmar [Burma]', 1327865);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MN', 'en', 'Y', 'MN', 'MNG', 'Mongolia', 2029969);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MO', 'en', 'Y', 'MO', 'MAC', 'Macao', 1821275);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MP', 'en', 'Y', 'MP', 'MNP', 'Northern Mariana Islands', 4041468);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MQ', 'en', 'Y', 'MQ', 'MTQ', 'Martinique', 3570311);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MR', 'en', 'Y', 'MR', 'MRT', 'Mauritania', 2378080);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MS', 'en', 'Y', 'MS', 'MSR', 'Montserrat', 3578097);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MT', 'en', 'Y', 'MT', 'MLT', 'Malta', 2562770);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MU', 'en', 'Y', 'MU', 'MUS', 'Mauritius', 934292);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MV', 'en', 'Y', 'MV', 'MDV', 'Maldives', 1282028);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MW', 'en', 'Y', 'MW', 'MWI', 'Malawi', 927384);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MX', 'en', 'Y', 'MX', 'MEX', 'Mexico', 3996063);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MY', 'en', 'Y', 'MY', 'MYS', 'Malaysia', 1733045);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MZ', 'en', 'Y', 'MZ', 'MOZ', 'Mozambique', 1036973);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NA', 'en', 'Y', 'NA', 'NAM', 'Namibia', 3355338);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NC', 'en', 'Y', 'NC', 'NCL', 'New Caledonia', 2139685);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NE', 'en', 'Y', 'NE', 'NER', 'Niger', 2440476);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NF', 'en', 'Y', 'NF', 'NFK', 'Norfolk Island', 2155115);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NG', 'en', 'Y', 'NG', 'NGA', 'Naija', 2328926);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NI', 'en', 'Y', 'NI', 'NIC', 'Nicaragua', 3617476);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NL', 'en', 'Y', 'NL', 'NLD', 'Netherlands', 2750405);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NO', 'en', 'Y', 'NO', 'NOR', 'Norway', 3144096);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NP', 'en', 'Y', 'NP', 'NPL', 'Nepal', 1282988);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NR', 'en', 'Y', 'NR', 'NRU', 'Nauru', 2110425);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NU', 'en', 'Y', 'NU', 'NIU', 'Niue', 4036232);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NZ', 'en', 'Y', 'NZ', 'NZL', 'New Zealand', 2186224);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('OM', 'en', 'Y', 'OM', 'OMN', 'Oman', 286963);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PA', 'en', 'Y', 'PA', 'PAN', 'Panama', 3703430);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PE', 'en', 'Y', 'PE', 'PER', 'Peru', 3932488);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PF', 'en', 'Y', 'PF', 'PYF', 'French Polynesia', 4030656);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PG', 'en', 'Y', 'PG', 'PNG', 'Papua New Guinea', 2088628);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PH', 'en', 'Y', 'PH', 'PHL', 'Philippines', 1694008);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PK', 'en', 'Y', 'PK', 'PAK', 'Pakistan', 1168579);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PL', 'en', 'Y', 'PL', 'POL', 'Poland', 798544);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PM', 'en', 'Y', 'PM', 'SPM', 'Saint Pierre and Miquelon', 3424932);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PR', 'en', 'Y', 'PR', 'PRI', 'Puerto Rico', 4566966);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PS', 'en', 'Y', 'PS', 'PSE', 'Palestine', 6254930);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PT', 'en', 'Y', 'PT', 'PRT', 'Portugal', 2264397);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PW', 'en', 'Y', 'PW', 'PLW', 'Palau', 1559582);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PY', 'en', 'Y', 'PY', 'PRY', 'Paraguay', 3437598);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('QA', 'en', 'Y', 'QA', 'QAT', 'Qatar', 289688);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('RE', 'en', 'Y', 'RE', 'REU', 'Réunion', 935317);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('RO', 'en', 'Y', 'RO', 'ROU', 'Romania', 798549);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('RS', 'en', 'Y', 'RS', 'SRB', 'Serbia', 6290252);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('RU', 'en', 'Y', 'RU', 'RUS', 'Russia', 2017370);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('RW', 'en', 'Y', 'RW', 'RWA', 'Rwanda', 49518);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SA', 'en', 'Y', 'SA', 'SAU', 'Saudi Arabia', 102358);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SB', 'en', 'Y', 'SB', 'SLB', 'Solomon Islands', 2103350);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SC', 'en', 'Y', 'SC', 'SYC', 'Seychelles', 241170);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SD', 'en', 'Y', 'SD', 'SDN', 'Sudan', 366755);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SE', 'en', 'Y', 'SE', 'SWE', 'Sweden', 2661886);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SG', 'en', 'Y', 'SG', 'SGP', 'Singapore', 1880251);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SH', 'en', 'Y', 'SH', 'SHN', 'Saint Helena', 3370751);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SI', 'en', 'Y', 'SI', 'SVN', 'Slovenia', 3190538);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SJ', 'en', 'Y', 'SJ', 'SJM', 'Svalbard and Jan Mayen', 607072);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SK', 'en', 'Y', 'SK', 'SVK', 'Slovakia', 3057568);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SL', 'en', 'Y', 'SL', 'SLE', 'Sierra Leone', 2403846);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SM', 'en', 'Y', 'SM', 'SMR', 'San Marino', 3168068);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SN', 'en', 'Y', 'SN', 'SEN', 'Senegal', 2245662);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SO', 'en', 'Y', 'SO', 'SOM', 'Somalia', 51537);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SR', 'en', 'Y', 'SR', 'SUR', 'Suriname', 3382998);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SS', 'en', 'Y', 'SS', 'SSD', 'South Sudan', 7909807);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ST', 'en', 'Y', 'ST', 'STP', 'São Tomé and Príncipe', 2410758);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SV', 'en', 'Y', 'SV', 'SLV', 'El Salvador', 3585968);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SX', 'en', 'Y', 'SX', 'SXM', 'Sint Maarten', 7609695);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SY', 'en', 'Y', 'SY', 'SYR', 'Syria', 163843);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SZ', 'en', 'Y', 'SZ', 'SWZ', 'Swaziland', 934841);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TC', 'en', 'Y', 'TC', 'TCA', 'Turks and Caicos Islands', 3576916);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TD', 'en', 'Y', 'TD', 'TCD', 'Chad', 2434508);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TF', 'en', 'Y', 'TF', 'ATF', 'French Southern Territories', 1546748);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TG', 'en', 'Y', 'TG', 'TGO', 'Togo', 2363686);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TH', 'en', 'Y', 'TH', 'THA', 'Thailand', 1605651);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TJ', 'en', 'Y', 'TJ', 'TJK', 'Tajikistan', 1220409);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TK', 'en', 'Y', 'TK', 'TKL', 'Tokelau', 4031074);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TL', 'en', 'Y', 'TL', 'TLS', 'East Timor', 1966436);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TM', 'en', 'Y', 'TM', 'TKM', 'Turkmenistan', 1218197);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TN', 'en', 'Y', 'TN', 'TUN', 'Tunisia', 2464461);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TO', 'en', 'Y', 'TO', 'TON', 'Tonga', 4032283);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TR', 'en', 'Y', 'TR', 'TUR', 'Turkey', 298795);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TT', 'en', 'Y', 'TT', 'TTO', 'Trinidad and Tobago', 3573591);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TV', 'en', 'Y', 'TV', 'TUV', 'Tuvalu', 2110297);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TW', 'en', 'Y', 'TW', 'TWN', 'Taiwan', 1668284);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TZ', 'en', 'Y', 'TZ', 'TZA', 'Tanzania', 149590);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('UA', 'en', 'Y', 'UA', 'UKR', 'Ukraine', 690791);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('UG', 'en', 'Y', 'UG', 'UGA', 'Uganda', 226074);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('UM', 'en', 'Y', 'UM', 'UMI', 'U.S. Minor Outlying Islands', 5854968);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('US', 'en', 'Y', 'US', 'USA', 'United States of America', 6252001);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('UY', 'en', 'Y', 'UY', 'URY', 'Uruguay', 3439705);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('UZ', 'en', 'Y', 'UZ', 'UZB', 'Uzbekistan', 1512440);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('VA', 'en', 'Y', 'VA', 'VAT', 'Vatican City', 3164670);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('VC', 'en', 'Y', 'VC', 'VCT', 'Saint Vincent and the Grenadines', 3577815);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('VE', 'en', 'Y', 'VE', 'VEN', 'Venezuela', 3625428);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('VG', 'en', 'Y', 'VG', 'VGB', 'British Virgin Islands', 3577718);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('VI', 'en', 'Y', 'VI', 'VIR', 'U.S. Virgin Islands', 4796775);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('VN', 'en', 'Y', 'VN', 'VNM', 'Vietnam', 1562822);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('VU', 'en', 'Y', 'VU', 'VUT', 'Vanuatu', 2134431);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('WF', 'en', 'Y', 'WF', 'WLF', 'Wallis and Futuna', 4034749);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('WS', 'en', 'Y', 'WS', 'WSM', 'Samoa', 4034894);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('XK', 'en', 'Y', 'XK', 'XKX', 'Kosovo', 831053);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('YE', 'en', 'Y', 'YE', 'YEM', 'Yemen', 69543);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('YT', 'en', 'Y', 'YT', 'MYT', 'Mayotte', 1024031);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ZA', 'en', 'Y', 'ZA', 'ZAF', 'South Africa', 953987);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ZM', 'en', 'Y', 'ZM', 'ZMB', 'Zambia', 895949);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ZW', 'en', 'Y', 'ZW', 'ZWE', 'Zimbabwe', 878675);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AD', 'pt', 'Y', 'AD', 'AND', 'Andorra', 3041565);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AE', 'pt', 'Y', 'AE', 'ARE', 'Emirados Árabes Unidos', 290557);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AF', 'pt', 'Y', 'AF', 'AFG', 'Afeganistão', 1149361);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AG', 'pt', 'Y', 'AG', 'ATG', 'Antígua e Barbuda', 3576396);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AI', 'pt', 'Y', 'AI', 'AIA', 'Anguilla', 3573511);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AL', 'pt', 'Y', 'AL', 'ALB', 'Albânia', 783754);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AM', 'pt', 'Y', 'AM', 'ARM', 'Armênia', 174982);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AN', 'pt', 'Y', 'AN', 'ANT', 'Netherlands Antilles', 8505032);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AO', 'pt', 'Y', 'AO', 'AGO', 'Angola', 3351879);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AQ', 'pt', 'Y', 'AQ', 'ATA', 'Antártida', 6697173);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AR', 'pt', 'Y', 'AR', 'ARG', 'Argentina', 3865483);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AS', 'pt', 'Y', 'AS', 'ASM', 'Samoa Americana', 5880801);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AT', 'pt', 'Y', 'AT', 'AUT', 'Áustria', 2782113);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AU', 'pt', 'Y', 'AU', 'AUS', 'Austrália', 2077456);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AW', 'pt', 'Y', 'AW', 'ABW', 'Aruba', 3577279);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AX', 'pt', 'Y', 'AX', 'ALA', 'Ilhas Aland', 661882);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('AZ', 'pt', 'Y', 'AZ', 'AZE', 'Azerbaijão', 587116);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BA', 'pt', 'Y', 'BA', 'BIH', 'Bósnia-Herzegóvina', 3277605);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BB', 'pt', 'Y', 'BB', 'BRB', 'Barbados', 3374084);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BD', 'pt', 'Y', 'BD', 'BGD', 'Bangladexe', 1210997);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BE', 'pt', 'Y', 'BE', 'BEL', 'Bélgica', 2802361);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BF', 'pt', 'Y', 'BF', 'BFA', 'Burkina Fasso', 2361809);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BG', 'pt', 'Y', 'BG', 'BGR', 'Bulgária', 732800);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BH', 'pt', 'Y', 'BH', 'BHR', 'Bahrain', 290291);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BI', 'pt', 'Y', 'BI', 'BDI', 'Burundi', 433561);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BJ', 'pt', 'Y', 'BJ', 'BEN', 'Benin', 2395170);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BL', 'pt', 'Y', 'BL', 'BLM', 'São Bartolomeu', 3578476);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BM', 'pt', 'Y', 'BM', 'BMU', 'Bermudas', 3573345);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BN', 'pt', 'Y', 'BN', 'BRN', 'Brunei', 1820814);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BO', 'pt', 'Y', 'BO', 'BOL', 'Bolívia', 3923057);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BQ', 'pt', 'Y', 'BQ', 'BES', 'Bonaire', 7626844);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BR', 'pt', 'Y', 'BR', 'BRA', 'Brasil', 3469034);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BS', 'pt', 'Y', 'BS', 'BHS', 'Bahamas', 3572887);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BT', 'pt', 'Y', 'BT', 'BTN', 'Butão', 1252634);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BV', 'pt', 'Y', 'BV', 'BVT', 'Ilha Bouvet', 3371123);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BW', 'pt', 'Y', 'BW', 'BWA', 'Botsuana', 933860);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BY', 'pt', 'Y', 'BY', 'BLR', 'Bielo-Rússia', 630336);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('BZ', 'pt', 'Y', 'BZ', 'BLZ', 'Belize', 3582678);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CA', 'pt', 'Y', 'CA', 'CAN', 'Canadá', 6251999);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CC', 'pt', 'Y', 'CC', 'CCK', 'Ilhas Coco', 1547376);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CD', 'pt', 'Y', 'CD', 'COD', 'Congo-Kinshasa', 203312);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CF', 'pt', 'Y', 'CF', 'CAF', 'República Centro-Africana', 239880);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CG', 'pt', 'Y', 'CG', 'COG', 'Congo', 2260494);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CH', 'pt', 'Y', 'CH', 'CHE', 'Suíça', 2658434);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CI', 'pt', 'Y', 'CI', 'CIV', 'Costa do Marfim', 2287781);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CK', 'pt', 'Y', 'CK', 'COK', 'Ilhas Cook', 1899402);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CL', 'pt', 'Y', 'CL', 'CHL', 'Chile', 3895114);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CM', 'pt', 'Y', 'CM', 'CMR', 'Camarões', 2233387);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CN', 'pt', 'Y', 'CN', 'CHN', 'China', 1814991);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CO', 'pt', 'Y', 'CO', 'COL', 'Colômbia', 3686110);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CR', 'pt', 'Y', 'CR', 'CRI', 'Costa Rica', 3624060);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CS', 'pt', 'Y', 'CS', 'SCG', 'Serbia and Montenegro', 8505033);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CU', 'pt', 'Y', 'CU', 'CUB', 'Cuba', 3562981);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CV', 'pt', 'Y', 'CV', 'CPV', 'Cabo Verde', 3374766);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CW', 'pt', 'Y', 'CW', 'CUW', 'Curaçao', 7626836);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CX', 'pt', 'Y', 'CX', 'CXR', 'Ilhas Natal', 2078138);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CY', 'pt', 'Y', 'CY', 'CYP', 'Chipre', 146669);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('CZ', 'pt', 'Y', 'CZ', 'CZE', 'República Checa', 3077311);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('DE', 'pt', 'Y', 'DE', 'DEU', 'Alemanha', 2921044);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('DJ', 'pt', 'Y', 'DJ', 'DJI', 'Djibuti', 223816);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('DK', 'pt', 'Y', 'DK', 'DNK', 'Dinamarca', 2623032);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('DM', 'pt', 'Y', 'DM', 'DMA', 'Dominica', 3575830);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('DO', 'pt', 'Y', 'DO', 'DOM', 'República Dominicana', 3508796);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('DZ', 'pt', 'Y', 'DZ', 'DZA', 'Argélia', 2589581);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('EC', 'pt', 'Y', 'EC', 'ECU', 'Equador', 3658394);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('EE', 'pt', 'Y', 'EE', 'EST', 'Estônia', 453733);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('EG', 'pt', 'Y', 'EG', 'EGY', 'Egipto', 357994);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('EH', 'pt', 'Y', 'EH', 'ESH', 'Saara Ocidental', 2461445);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ER', 'pt', 'Y', 'ER', 'ERI', 'Eritreia', 338010);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ES', 'pt', 'Y', 'ES', 'ESP', 'Espanha', 2510769);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ET', 'pt', 'Y', 'ET', 'ETH', 'Etiópia', 337996);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('FI', 'pt', 'Y', 'FI', 'FIN', 'Finlândia', 660013);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('FJ', 'pt', 'Y', 'FJ', 'FJI', 'Fiji', 2205218);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('FK', 'pt', 'Y', 'FK', 'FLK', 'Ilhas Malvinas', 3474414);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('FM', 'pt', 'Y', 'FM', 'FSM', 'Micronésia', 2081918);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('FO', 'pt', 'Y', 'FO', 'FRO', 'Ilhas Faroe', 2622320);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('FR', 'pt', 'Y', 'FR', 'FRA', 'França', 3017382);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GA', 'pt', 'Y', 'GA', 'GAB', 'Gabão', 2400553);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GB', 'pt', 'Y', 'GB', 'GBR', 'Reino Unido', 2635167);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GD', 'pt', 'Y', 'GD', 'GRD', 'Granada', 3580239);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GE', 'pt', 'Y', 'GE', 'GEO', 'Geórgia', 614540);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GF', 'pt', 'Y', 'GF', 'GUF', 'Guiana Francesa', 3381670);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GG', 'pt', 'Y', 'GG', 'GGY', 'Guernsey', 3042362);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GH', 'pt', 'Y', 'GH', 'GHA', 'Gana', 2300660);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GI', 'pt', 'Y', 'GI', 'GIB', 'Gibraltar', 2411586);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GL', 'pt', 'Y', 'GL', 'GRL', 'Gronelândia', 3425505);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GM', 'pt', 'Y', 'GM', 'GMB', 'Gâmbia', 2413451);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GN', 'pt', 'Y', 'GN', 'GIN', 'Guiné', 2420477);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GP', 'pt', 'Y', 'GP', 'GLP', 'Guadalupe', 3579143);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GQ', 'pt', 'Y', 'GQ', 'GNQ', 'Guiné Equatorial', 2309096);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GR', 'pt', 'Y', 'GR', 'GRC', 'Grécia', 390903);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GS', 'pt', 'Y', 'GS', 'SGS', 'Geórgia do Sul e Ilhas Sandwich do Sul', 3474415);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GT', 'pt', 'Y', 'GT', 'GTM', 'Guatemala', 3595528);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GU', 'pt', 'Y', 'GU', 'GUM', 'Guam', 4043988);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GW', 'pt', 'Y', 'GW', 'GNB', 'Guiné-Bissau', 2372248);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('GY', 'pt', 'Y', 'GY', 'GUY', 'Guiana', 3378535);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('HK', 'pt', 'Y', 'HK', 'HKG', 'Hong Kong', 1819730);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('HM', 'pt', 'Y', 'HM', 'HMD', 'Ilha Heard e Ilhas McDonald', 1547314);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('HN', 'pt', 'Y', 'HN', 'HND', 'Honduras', 3608932);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('HR', 'pt', 'Y', 'HR', 'HRV', 'Croácia', 3202326);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('HT', 'pt', 'Y', 'HT', 'HTI', 'Haiti', 3723988);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('HU', 'pt', 'Y', 'HU', 'HUN', 'Hungria', 719819);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ID', 'pt', 'Y', 'ID', 'IDN', 'Indonésia', 1643084);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('IE', 'pt', 'Y', 'IE', 'IRL', 'Irlanda', 2963597);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('IL', 'pt', 'Y', 'IL', 'ISR', 'Israel', 294640);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('IM', 'pt', 'Y', 'IM', 'IMN', 'Ilha de Man', 3042225);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('IN', 'pt', 'Y', 'IN', 'IND', 'Índia', 1269750);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('IO', 'pt', 'Y', 'IO', 'IOT', 'Território Britânico do Oceano Índico', 1282588);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('IQ', 'pt', 'Y', 'IQ', 'IRQ', 'Iraque', 99237);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('IR', 'pt', 'Y', 'IR', 'IRN', 'Irão', 130758);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('IS', 'pt', 'Y', 'IS', 'ISL', 'Islândia', 2629691);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('IT', 'pt', 'Y', 'IT', 'ITA', 'Itália', 3175395);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('JE', 'pt', 'Y', 'JE', 'JEY', 'Jersey', 3042142);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('JM', 'pt', 'Y', 'JM', 'JAM', 'Jamaica', 3489940);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('JO', 'pt', 'Y', 'JO', 'JOR', 'Jordânia', 248816);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('JP', 'pt', 'Y', 'JP', 'JPN', 'Japão', 1861060);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KE', 'pt', 'Y', 'KE', 'KEN', 'Quênia', 192950);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KG', 'pt', 'Y', 'KG', 'KGZ', 'Quirguistão', 1527747);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KH', 'pt', 'Y', 'KH', 'KHM', 'Camboja', 1831722);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KI', 'pt', 'Y', 'KI', 'KIR', 'Quiribati', 4030945);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KM', 'pt', 'Y', 'KM', 'COM', 'Ilhas Comores', 921929);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KN', 'pt', 'Y', 'KN', 'KNA', 'São Cristóvão e Névis', 3575174);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KP', 'pt', 'Y', 'KP', 'PRK', 'Coreia do Norte', 1873107);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KR', 'pt', 'Y', 'KR', 'KOR', 'Coreia do Sul', 1835841);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KW', 'pt', 'Y', 'KW', 'KWT', 'Kuwait', 285570);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KY', 'pt', 'Y', 'KY', 'CYM', 'Ilhas Caiman', 3580718);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('KZ', 'pt', 'Y', 'KZ', 'KAZ', 'Cazaquistão', 1522867);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LA', 'pt', 'Y', 'LA', 'LAO', 'Laos', 1655842);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LB', 'pt', 'Y', 'LB', 'LBN', 'Líbano', 272103);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LC', 'pt', 'Y', 'LC', 'LCA', 'Santa Lúcia', 3576468);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LI', 'pt', 'Y', 'LI', 'LIE', 'Lichtenstein', 3042058);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LK', 'pt', 'Y', 'LK', 'LKA', 'Sri Lanka', 1227603);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LR', 'pt', 'Y', 'LR', 'LBR', 'Libéria', 2275384);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LS', 'pt', 'Y', 'LS', 'LSO', 'Lesoto', 932692);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LT', 'pt', 'Y', 'LT', 'LTU', 'Lituânia', 597427);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LU', 'pt', 'Y', 'LU', 'LUX', 'Luxemburgo', 2960313);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LV', 'pt', 'Y', 'LV', 'LVA', 'Letônia', 458258);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('LY', 'pt', 'Y', 'LY', 'LBY', 'Líbia Árabe Jamahiriya', 2215636);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MA', 'pt', 'Y', 'MA', 'MAR', 'Marrocos', 2542007);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MC', 'pt', 'Y', 'MC', 'MCO', 'Mónaco', 2993457);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MD', 'pt', 'Y', 'MD', 'MDA', 'Moldávia', 617790);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ME', 'pt', 'Y', 'ME', 'MNE', 'Montenegro', 3194884);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MF', 'pt', 'Y', 'MF', 'MAF', 'São Martinho', 3578421);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MG', 'pt', 'Y', 'MG', 'MDG', 'Madagascar', 1062947);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MH', 'pt', 'Y', 'MH', 'MHL', 'Ilhas Marshall', 2080185);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MK', 'pt', 'Y', 'MK', 'MKD', 'Macedónia', 718075);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ML', 'pt', 'Y', 'ML', 'MLI', 'Mali', 2453866);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MM', 'pt', 'Y', 'MM', 'MMR', 'Mianmar [Birmânia]', 1327865);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MN', 'pt', 'Y', 'MN', 'MNG', 'Mongólia', 2029969);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MO', 'pt', 'Y', 'MO', 'MAC', 'Macau', 1821275);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MP', 'pt', 'Y', 'MP', 'MNP', 'Ilhas Marianas do Norte', 4041468);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MQ', 'pt', 'Y', 'MQ', 'MTQ', 'Martinica', 3570311);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MR', 'pt', 'Y', 'MR', 'MRT', 'Mauritânia', 2378080);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MS', 'pt', 'Y', 'MS', 'MSR', 'Montserrat', 3578097);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MT', 'pt', 'Y', 'MT', 'MLT', 'Malta', 2562770);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MU', 'pt', 'Y', 'MU', 'MUS', 'Maurício', 934292);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MV', 'pt', 'Y', 'MV', 'MDV', 'Maldivas', 1282028);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MW', 'pt', 'Y', 'MW', 'MWI', 'Malauí', 927384);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MX', 'pt', 'Y', 'MX', 'MEX', 'México', 3996063);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MY', 'pt', 'Y', 'MY', 'MYS', 'Malásia', 1733045);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('MZ', 'pt', 'Y', 'MZ', 'MOZ', 'Moçambique', 1036973);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NA', 'pt', 'Y', 'NA', 'NAM', 'Namíbia', 3355338);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NC', 'pt', 'Y', 'NC', 'NCL', 'Nova Caledônia', 2139685);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NE', 'pt', 'Y', 'NE', 'NER', 'Níger', 2440476);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NF', 'pt', 'Y', 'NF', 'NFK', 'Ilha Norfolk', 2155115);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NG', 'pt', 'Y', 'NG', 'NGA', 'Nigéria', 2328926);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NI', 'pt', 'Y', 'NI', 'NIC', 'Nicarágua', 3617476);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NL', 'pt', 'Y', 'NL', 'NLD', 'Holanda', 2750405);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NO', 'pt', 'Y', 'NO', 'NOR', 'Noruega', 3144096);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NP', 'pt', 'Y', 'NP', 'NPL', 'Nepal', 1282988);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NR', 'pt', 'Y', 'NR', 'NRU', 'Nauru', 2110425);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NU', 'pt', 'Y', 'NU', 'NIU', 'Niue', 4036232);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('NZ', 'pt', 'Y', 'NZ', 'NZL', 'Nova Zelândia', 2186224);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('OM', 'pt', 'Y', 'OM', 'OMN', 'Omã', 286963);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PA', 'pt', 'Y', 'PA', 'PAN', 'Panamá', 3703430);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PE', 'pt', 'Y', 'PE', 'PER', 'Peru', 3932488);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PF', 'pt', 'Y', 'PF', 'PYF', 'Polinésia Francesa', 4030656);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PG', 'pt', 'Y', 'PG', 'PNG', 'Papua-Nova Guiné', 2088628);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PH', 'pt', 'Y', 'PH', 'PHL', 'Filipinas', 1694008);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PK', 'pt', 'Y', 'PK', 'PAK', 'Paquistão', 1168579);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PL', 'pt', 'Y', 'PL', 'POL', 'Polônia', 798544);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PM', 'pt', 'Y', 'PM', 'SPM', 'Saint Pierre e Miquelon', 3424932);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PN', 'pt', 'Y', 'PN', 'PCN', 'Pitcairn', 4030699);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PR', 'pt', 'Y', 'PR', 'PRI', 'Porto Rico', 4566966);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PS', 'pt', 'Y', 'PS', 'PSE', 'Territórios palestinos', 6254930);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PT', 'pt', 'Y', 'PT', 'PRT', 'Portugal', 2264397);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PW', 'pt', 'Y', 'PW', 'PLW', 'Palau', 1559582);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('PY', 'pt', 'Y', 'PY', 'PRY', 'Paraguai', 3437598);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('QA', 'pt', 'Y', 'QA', 'QAT', 'Catar', 289688);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('RE', 'pt', 'Y', 'RE', 'REU', 'Reunião', 935317);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('RO', 'pt', 'Y', 'RO', 'ROU', 'Romênia', 798549);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('RS', 'pt', 'Y', 'RS', 'SRB', 'Sérvia', 6290252);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('RU', 'pt', 'Y', 'RU', 'RUS', 'Rússia', 2017370);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('RW', 'pt', 'Y', 'RW', 'RWA', 'Ruanda', 49518);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SA', 'pt', 'Y', 'SA', 'SAU', 'Arábia Saudita', 102358);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SB', 'pt', 'Y', 'SB', 'SLB', 'Ilhas Salomão', 2103350);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SC', 'pt', 'Y', 'SC', 'SYC', 'Ilhas Seychelles', 241170);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SD', 'pt', 'Y', 'SD', 'SDN', 'Sudão', 366755);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SE', 'pt', 'Y', 'SE', 'SWE', 'Suécia', 2661886);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SG', 'pt', 'Y', 'SG', 'SGP', 'Singapura', 1880251);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SH', 'pt', 'Y', 'SH', 'SHN', 'Santa Helena', 3370751);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SI', 'pt', 'Y', 'SI', 'SVN', 'Eslovênia', 3190538);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SJ', 'pt', 'Y', 'SJ', 'SJM', 'Svalbard e Jan Mayen', 607072);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SK', 'pt', 'Y', 'SK', 'SVK', 'Eslováquia', 3057568);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SL', 'pt', 'Y', 'SL', 'SLE', 'Serra Leoa', 2403846);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SM', 'pt', 'Y', 'SM', 'SMR', 'San Marino', 3168068);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SN', 'pt', 'Y', 'SN', 'SEN', 'Senegal', 2245662);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SO', 'pt', 'Y', 'SO', 'SOM', 'Somália', 51537);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SR', 'pt', 'Y', 'SR', 'SUR', 'Suriname', 3382998);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SS', 'pt', 'Y', 'SS', 'SSD', 'Sudão do Sul', 7909807);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ST', 'pt', 'Y', 'ST', 'STP', 'São Tomé e Príncipe', 2410758);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SV', 'pt', 'Y', 'SV', 'SLV', 'El Salvador', 3585968);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SX', 'pt', 'Y', 'SX', 'SXM', 'Ilha de São Martinho', 7609695);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SY', 'pt', 'Y', 'SY', 'SYR', 'Síria', 163843);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('SZ', 'pt', 'Y', 'SZ', 'SWZ', 'Suazilândia', 934841);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TC', 'pt', 'Y', 'TC', 'TCA', 'Ilhas Turks e Caicos', 3576916);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TD', 'pt', 'Y', 'TD', 'TCD', 'Chade', 2434508);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TF', 'pt', 'Y', 'TF', 'ATF', 'Territórios Franceses do Sul', 1546748);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TG', 'pt', 'Y', 'TG', 'TGO', 'Togo', 2363686);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TH', 'pt', 'Y', 'TH', 'THA', 'Tailândia', 1605651);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TJ', 'pt', 'Y', 'TJ', 'TJK', 'Tajiquistão', 1220409);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TK', 'pt', 'Y', 'TK', 'TKL', 'Tokelau', 4031074);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TL', 'pt', 'Y', 'TL', 'TLS', 'Timor-Leste', 1966436);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TM', 'pt', 'Y', 'TM', 'TKM', 'Turquemenistão', 1218197);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TN', 'pt', 'Y', 'TN', 'TUN', 'Tunísia', 2464461);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TO', 'pt', 'Y', 'TO', 'TON', 'Tonga', 4032283);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TR', 'pt', 'Y', 'TR', 'TUR', 'Turquia', 298795);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TT', 'pt', 'Y', 'TT', 'TTO', 'Trindade e Tobago', 3573591);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TV', 'pt', 'Y', 'TV', 'TUV', 'Tuvalu', 2110297);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TW', 'pt', 'Y', 'TW', 'TWN', 'Taiwan', 1668284);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('TZ', 'pt', 'Y', 'TZ', 'TZA', 'Tanzânia', 149590);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('UA', 'pt', 'Y', 'UA', 'UKR', 'Ucrânia', 690791);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('UG', 'pt', 'Y', 'UG', 'UGA', 'Uganda', 226074);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('UM', 'pt', 'Y', 'UM', 'UMI', 'Ilhas Menores Distantes dos Estados Unidos', 5854968);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('US', 'pt', 'Y', 'US', 'USA', 'Estados Unidos', 6252001);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('UY', 'pt', 'Y', 'UY', 'URY', 'Uruguai', 3439705);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('UZ', 'pt', 'Y', 'UZ', 'UZB', 'Uzbequistão', 1512440);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('VA', 'pt', 'Y', 'VA', 'VAT', 'Santa Sé (Cidade-Estado do Vaticano)', 3164670);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('VC', 'pt', 'Y', 'VC', 'VCT', 'São Vincente e Granadinas', 3577815);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('VE', 'pt', 'Y', 'VE', 'VEN', 'Venezuela', 3625428);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('VG', 'pt', 'Y', 'VG', 'VGB', 'Ilhas Virgens Britânicas', 3577718);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('VI', 'pt', 'Y', 'VI', 'VIR', 'Ilhas Virgens dos EUA', 4796775);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('VN', 'pt', 'Y', 'VN', 'VNM', 'Vietnã', 1562822);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('VU', 'pt', 'Y', 'VU', 'VUT', 'Vanuatu', 2134431);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('WF', 'pt', 'Y', 'WF', 'WLF', 'Ilhas Wallis e Futuna', 4034749);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('WS', 'pt', 'Y', 'WS', 'WSM', 'Samoa', 4034894);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('XK', 'pt', 'Y', 'XK', 'XKX', 'Kosovo', 831053);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('YE', 'pt', 'Y', 'YE', 'YEM', 'Iêmen', 69543);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('YT', 'pt', 'Y', 'YT', 'MYT', 'Mayotte', 1024031);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ZA', 'pt', 'Y', 'ZA', 'ZAF', 'África do Sul', 953987);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ZM', 'pt', 'Y', 'ZM', 'ZMB', 'Zâmbia', 895949);
INSERT INTO country (code, lang, active, short2, short3, description, geonameid) VALUES ('ZW', 'pt', 'Y', 'ZW', 'ZWE', 'Zimbábue', 878675);

