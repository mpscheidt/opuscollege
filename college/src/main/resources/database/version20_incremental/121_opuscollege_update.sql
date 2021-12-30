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

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',2.2);

-------------------------------------------------------
-- table lookupTable
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.lookupTableSeq CASCADE;

CREATE SEQUENCE opuscollege.lookupTableSeq;
ALTER TABLE opuscollege.lookupTableSeq OWNER TO postgres;

DROP TABLE IF EXISTS opuscollege.lookupTable CASCADE;

CREATE TABLE opuscollege.lookupTable (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.lookupTableSeq'),
    tableName VARCHAR NOT NULL,
    lookupType VARCHAR NOT NULL ,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.lookupTable OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.lookupTable TO postgres;

--delete duplicate entries
DELETE FROM "opuscollege".lookuptable
	    WHERE id NOT IN
	(SELECT MAX(id)
        FROM "opuscollege".lookuptable AS dup
        GROUP BY dup.tablename);
ALTER TABLE opuscollege.lookuptable ADD CONSTRAINT unique_table_name UNIQUE (tablename);



INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('academicField'        , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('academicYear'        , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('addressType'          , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('administrativePost'   , 'Lookup4' , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('appointmentType'      , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('blockType'            , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('bloodType'            , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('civilStatus'          , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('civilTitle'           , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('contractDuration'     , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('contractType'         , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('country'              , 'Lookup3' , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('district'             , 'Lookup2' , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('educationType'        , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('examinationType'      , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('examType'             , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('expellationType'      , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('fieldOfEducation'     , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('frequency'            , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('function'             , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('functionLevel'        , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('gender'               , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('gradeType'            , 'Lookup6' , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('identificationType'   , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('language'             , 'Lookup1' , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('levelOfEducation'     , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('markEvaluation'       , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('masteringLevel'       , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('nationality'          , 'Lookup1' , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('profession'           , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('province'             , 'Lookup5' , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('relationType'         , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('rigidityType'         , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('staffType'            , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('status'               , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('studyForm'            , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('studyTime'            , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('studyType'            , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('subjectImportance'    , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('targetGroup'          , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('timeUnit'             , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('unitArea'             , 'Lookup'  , 'Y');
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('unitType'             , 'Lookup'  , 'Y');


-------------------------------------------------------
-- table tableDependency
-------------------------------------------------------

DROP SEQUENCE IF EXISTS opuscollege.tableDependencySeq CASCADE;

CREATE SEQUENCE opuscollege.tableDependencySeq;
ALTER TABLE opuscollege.tableDependencySeq OWNER TO postgres;


DROP TABLE IF EXISTS opuscollege.tableDependency CASCADE;

CREATE TABLE opuscollege.tableDependency (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.tableDependencySeq'),
    lookupTableId INTEGER NOT NULL,
    dependentTable VARCHAR NOT NULL,
    dependentTableColumn VARCHAR NOT NULL,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id)
);
ALTER TABLE opuscollege.tableDependency OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.tableDependency TO postgres;



INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (1  , 'organizationalUnit'      , 'academicFieldCode'                    , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (1  , 'study'                   , 'academicFieldCode'                    , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (2  , 'studyPlanDetail'         , 'academicYearCode'                     , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (2  , 'sch_scholarship'         , 'academicYearCode'                     , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (3  , 'address'                 , 'addressTypeCode'                      , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (4  , 'person'                  , 'administrativePostOfOriginCode'       , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (4  , 'address'                 , 'administrativePostOfOriginCode'       , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (5  , 'staffMember'             , 'appointmentTypeCode'                  , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (7  , 'person'                  , 'bloodTypeCode'                        , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (8  , 'person'                  , 'civilStatusCode'                      , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (9  , 'person'                  , 'civilTitleCode'                       , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (10 , 'contract'                , 'contractDurationCode'                 , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (11 , 'contract'                , 'contractTypeCode'                     , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (12 , 'province'                , 'countryCode'                          , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (12 , 'person'                  , 'countryOfOriginCode'                  , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (12 , 'person'                  , 'countryOfBirthCode'                   , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (12 , 'address'                 , 'countryCode'                          , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (12 , 'student'                 , 'previousInstitutionCountryCode'       , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (13 , 'administrativePost'      , 'districtCode'                         , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (13 , 'person'                  , 'districtOfBirthCode'                  , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (13 , 'person'                  , 'districtOfOriginCode'                 , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (14 , 'institution'             , 'educationTypeCode'                    , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (14 , 'staffMember'             , 'educationTypeCode'                    , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (14 , 'student'                 , 'previousInstitutionEducationTypeCode' , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (15 , 'examination'             , 'examinationTypeCode'                  , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (15 , 'test'                    , 'examinationTypeCode'                  , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (16 , 'subject'                 , 'examTypeCode'                         , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (17 , 'student'                 , 'expellationTypeCode'                  , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (19 , 'subject'                 , 'frequencyCode'                        , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (20 , 'staffMemberFunction'     , 'functionCode'                         , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (21 , 'staffMemberFunction'     , 'functionLevelCode'                    , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (22 , 'person'                  , 'genderCode'                           , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (23 , 'person'                  , 'gradeTypeCode'                        , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (23 , 'student'                 , 'previousInstitutionFinalGradeTypeCode', 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (23 , 'studyGradeType'          , 'gradeTypeCode'                        , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (24 , 'person'                  , 'identificationTypeCode'               , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (25 , 'person'                  , 'languageFirstCode'                    , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (25 , 'person'                  , 'languageSecondCode'                   , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (25 , 'person'                  , 'languageThirdCode'                    , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (28 , 'person'                  , 'languageFirstMasteringLevelCode'      , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (28 , 'person'                  , 'languageSecondMasteringLevelCode'     , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (28 , 'person'                  , 'languageThirdMasteringLevelCode'      , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (29 , 'person'                  , 'nationalityCode'                      , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (30 , 'person'                  , 'professionCode'                       , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (30 , 'student'                 , 'fatherProfessionCode'                 , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (30 , 'student'                 , 'motherProfessionCode'                 , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (31 , 'district'                , 'provinceCode'                         , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (31 , 'person'                  , 'provinceOfBirthCode'                  , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (31 , 'person'                  , 'provinceOfOriginCode'                 , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (31 , 'institution'             , 'provinceCode'                         , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (31 , 'student'                 , 'previousInstitutionProvinceCode'      , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (31 , 'address'                 , 'provinceCode'                         , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (33 , 'subject'                 , 'rigidityTypeCode'                     , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (34 , 'staffMember'             , 'staffTypeCode'                        , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (35 , 'student'                 , 'statusCode'                           , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (36 , 'studyYear'               , 'studyFormCode'                        , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (36 , 'subject'                 , 'studyFormCode'                        , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (37 , 'studyYear'               , 'studyTimeCode'                        , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (37 , 'subject'                 , 'studyTimeCode'                        , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (38 , 'subjectStudyType'        , 'studyTypeCode'                        , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (39 , 'subject'                 , 'subjectImportanceCode'                , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (40 , 'studyYear'               , 'targetGroupCode'                      , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (40 , 'subject'                 , 'targetGroupCode'                      , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (40 , 'subjectBlock'            , 'targetGroupCode'                      , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (40 , 'subjectBlockStudyYear'   , 'targetGroupCode'                      , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (41 , 'subjectStudyYear'        , 'timeUnitCode'                         , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (41 , 'subjectBlockStudyYear'   , 'timeUnitCode'                         , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (42 , 'organizationalUnit'      , 'unitAreaCode'                         , 'Y');
INSERT INTO opuscollege.tabledependency(lookupTableId , dependentTable , dependentTableColumn , active) VALUES (43 , 'organizationalUnit'      , 'unitTypeCode'                         , 'Y');









