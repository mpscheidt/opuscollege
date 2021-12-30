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

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.05);

-------------------------------------------------------
-- TABLE subjectblock
-------------------------------------------------------
ALTER TABLE opuscollege.subjectBlock ADD COLUMN blockTypeCode VARCHAR;

-------------------------------------------------------
-- conversion studyyear -> subjectblock
-------------------------------------------------------

-- add extra values to subjectblock from studyyear:
ALTER TABLE opuscollege.subjectBlock ADD COLUMN creditAmountOverall INTEGER NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.subjectBlock ADD COLUMN creditAmountPercCompulsory INTEGER NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.subjectBlock ADD COLUMN creditAmountPercCompulsoryFromList INTEGER NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.subjectBlock ADD COLUMN creditAmountPercFreeChoice INTEGER NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.subjectBlock ADD COLUMN brsMaxContactHours VARCHAR;
ALTER TABLE opuscollege.subjectBlock ADD COLUMN studyTimeCode VARCHAR;

-- add extra columns to subjectBlock:
ALTER table opuscollege.subjectBlock ADD column currentAcademicYearId INTEGER NOT NULL DEFAULT 0;
-- ALTER table opuscollege.subjectBlock ADD column cardinalTimeUnitCode VARCHAR NOT NULL DEFAULT '';
ALTER table opuscollege.subjectBlock ADD column cardinalTimeUnitNumber INTEGER NOT NULL DEFAULT 0;

-- add extra columns to subject:
ALTER table opuscollege.subject ADD column currentAcademicYearId INTEGER NOT NULL DEFAULT 0;
ALTER table opuscollege.subject ADD column cardinalTimeUnitCode VARCHAR NOT NULL DEFAULT '';
ALTER table opuscollege.subject ADD column cardinalTimeUnitNumber INTEGER NOT NULL DEFAULT 0;

-- uniqueness constraint has to include academic year
ALTER TABLE opuscollege.subjectblock DROP CONSTRAINT subjectblock_subjectblockcode_key;
ALTER TABLE opuscollege.subjectblock DROP CONSTRAINT subjectblock_subjectblockcode_currentacademicyearid_key;
ALTER TABLE opuscollege.subjectblock ADD CONSTRAINT subjectblock_subjectblockcode_currentacademicyearid_key 
    UNIQUE(subjectblockcode, currentacademicyearid);

ALTER TABLE opuscollege.subject DROP CONSTRAINT subject_subjectcode_key;
ALTER TABLE opuscollege.subject DROP CONSTRAINT subject_subjectcode_currentacademicyearid_key;
ALTER TABLE opuscollege.subject ADD CONSTRAINT subject_subjectcode_currentacademicyearid_key 
    UNIQUE(subjectcode, currentacademicyearid);

-- move current values in studyYear to subjectBlock:
--INSERT INTO opuscollege.subjectBlock (
--    subjectblockcode, subjectblockdescription, targetgroupcode, 
--    subjectblockstructurevalidfromyear, subjectblockstructurevalidthroughyear,
--    creditAmountOverall, creditAmountPercCompulsory, creditAmountPercCompulsoryFromList, 
--    creditAmountPercFreeChoice, brsMaxContactHours, studyTimeCode,
--    studygradetypeid, cardinaltimeunitcode, cardinaltimeunitnumber
--    )   
--SELECT id, yearnumbervariation, targetgroupcode,
--    coursestructurevalidfromyear, coursestructurevalidthroughyear,  
--    creditAmountOverall, creditAmountPercCompulsory, creditAmountPercCompulsoryFromList, 
--    creditAmountPercFreeChoice, brsMaxContactHours, studyTimeCode,
--    studygradetypeid, '1', yearnumber
--FROM opuscollege.studyYear;
	
-- move current values in subjectStudyYear to subjectSubjectBlock:
--INSERT INTO opuscollege.subjectSubjectBlock (
--	subjectId, subjectBlockId
--	)
--SELECT subjectId, (
--		SELECT opuscollege.subjectBlock.id FROM opuscollege.subjectBlock 	
--		INNER JOIN opuscollege.studyYear ON subjectBlock.subjectBlockCode = CAST (studyYear.id AS VARCHAR)
--		WHERE studyYear.id = subjectStudyYear.studyYearId 
--		)
--FROM opuscollege.subjectStudyYear;

-- move current values in studyplandetail of studyyearId to subjectBlockId:
--UPDATE opuscollege.studyPlanDetail a
--	SET subjectBlockId = (
--		SELECT opuscollege.subjectBlock.id 
--		FROM opuscollege.studyPlanDetail b
--		INNER JOIN opuscollege.subjectBlock ON subjectBlock.subjectBlockCode = CAST (b.studyYearId AS VARCHAR) 
--		INNER JOIN opuscollege.studyYear ON b.studyYearId = studyYear.id
--		WHERE b.id = a.id
--	)
--	WHERE EXISTS (SELECT id FROM opuscollege.studyYear WHERE id = studyYearId);


-- remove column studyYearId from studyplandetail:
ALTER TABLE opuscollege.studyPlanDetail DROP COLUMN studyYearId;


-- finally: delete subjectStudyYear and studyYear
DROP SEQUENCE IF EXISTS opuscollege.studyYearSeq CASCADE;
DROP TABLE IF EXISTS opuscollege.studyYear CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.subjectStudyYearSeq CASCADE;
DROP TABLE IF EXISTS opuscollege.subjectStudyYear CASCADE;

