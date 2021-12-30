---##### Studyplan 

--status.code  to studyplanstatuscode mappings

--- 	-----------------------------------------------------------------------------------------
--  	|statuscode|  status.description  | studyplanstatus.code | studyplanstatus.description |
---- 	-----------------------------------------------------------------------------------------
--      |    1      |  Active              |        3             |  Approved Initial Admission |
        -----------------------------------------------------------------------------------------
--      |    2      |  temporary inactive  |        10            |  temporary inactive |
        -----------------------------------------------------------------------------------------
-- 	    |    4      |  Graduated	       |        11            |    Graduated		|
        -----------------------------------------------------------------------------------------
--      |    6      |  Withdrawn           |        12            |     Withdrawn		|
--      -----------------------------------------------------------------------------------------
--      |    7      |   Reprovado          |         4            |  Rejected Initial Admission    |
--      -----------------------------------------------------------------------------------------
--      |    8      |  nunca frequentou    |        12             |   Withdrawn   |
--      -----------------------------------------------------------------------------------------
--      |    9      |    Anula Matricula   |        12            |      Withdrawn              |
--      -----------------------------------------------------------------------------------------
--      |    11     |Approved Registration |         3            | Approved Initial Admission  |
--      -----------------------------------------------------------------------------------------
--      |    12     |  Actively Registered |         3            |  Approved Initial Admission |
--      -----------------------------------------------------------------------------------------
--      |    null   |                      |         3            |  Approved Initial Admission |
--      -----------------------------------------------------------------------------------------

--migrate from Student.status to studyplan.statuscode
-- old code 1 (active) -> new code 3 (Approved initial admission)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '3'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode = '1')
 );
-- old code 2 (temporary inactive) -> new code 10 (temporary inactive)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '10'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode = '2')
 );
-- old code 4 (graduated) -> new code 11 (graduated)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '11'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode = '4')
 );
-- old code 6 (desistiu) -> new code 12 (withdrawn)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '12'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode = '6')
 );
-- old code 7 (reprovado) -> new code 4 (rejected initial admission)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '4'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode = '7')
 );
-- old code 8 (nunca frequentou) -> new code 12 (withdrawn)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '12'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode = '8')
 );
-- old code 9 (anula matricula) -> new code 12 (withdrawn)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '12'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode = '9')
 );
-- old code 11 (Approved Registration) -> new code 3 (Approved initial admission)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '3'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode = '11')
 );
-- old code 12 (actively registered) -> new code 3 (Approved initial admission)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '3'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode = '12')
 );
-- old code null -> new code 3 (Approved initial admission)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '3'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode is null)
 );


--######################### StudyGradeType #################################################

-- field numberOfYears has been removed in favor of numberOfCardinalTimeUnits
UPDATE opuscollege.StudyGradeType SET numberOfCardinalTimeUnits = numberOfYears;

-- set a high max number of subjects per year unit that won't be surpassed
--UPDATE opuscollege.StudyGradeType SET maxnumberofsubjectspercardinaltimeunit = 20;

-- set max number of failed subjects per year
UPDATE opuscollege.StudyGradeType SET maxnumberoffailedsubjectspercardinaltimeunit = 3;

--new field studyTimeCode takes its value from studyyear with same studygradetype(.id)
--new field studyTimeCode takes its value from studyyear with same studygradetype(.id)
UPDATE opuscollege.StudyGradeType SET studyTimeCode =
(SELECT studyTimeCode FROM opuscollege.StudyYear 
WHERE (StudyYear.studyGradeTypeId = StudyGradeType.Id)
ORDER BY StudyYear.id DESC
LIMIT 1
);
--following two statements copied from 30_030_opuscollege_update.sql , line 21
-- set default value for cardinalTimeUnitCode of existing records to studyyear (code '1'):
UPDATE opuscollege.studyGradeType SET cardinalTimeUnitCode = '1';
-- set default value for maxNumberOfCardinalTimeUnits of existing records to 7:
UPDATE opuscollege.studyGradeType SET maxNumberOfCardinalTimeUnits = 7;

----Create a copy of each studygradetype to each academic year
/*INSERT INTO opuscollege.StudyGradeType(
studyId
, gradeTypeCode
, active
, contactId
, registrationDate
, studyTimeCode
, currentAcademicYearId
, cardinalTimeUnitCode
, numberOfCardinalTimeUnits
, maxNumberOfCardinalTimeUnits
, numberOfSubjectsPerCardinalTimeUnit 
, maxNumberOfSubjectsPerCardinalTimeUnit
, brsPassingSubject
, studyFormCode
, maxNumberOfFailedSubjectsPerCardinalTimeUnit
) 
SELECT  
studyId
, gradeTypeCode
, StudyGradeType.active
, contactId
, registrationDate
, studyTimeCode
, AcademicYear.Id
, cardinalTimeUnitCode
, numberOfCardinalTimeUnits
, maxNumberOfCardinalTimeUnits
, numberOfSubjectsPerCardinalTimeUnit 
, maxNumberOfSubjectsPerCardinalTimeUnit
, brsPassingSubject
, studyFormCode
, maxNumberOfFailedSubjectsPerCardinalTimeUnit

FROM opuscollege.AcademicYear,opuscollege.StudyGradeType ;*/

ALTER TABLE opuscollege.StudyGradeType ADD COLUMN originalStudyGradeTypeId Integer NOT NULL DEFAULT 0;
INSERT INTO opuscollege.StudyGradeType(
studyId
, gradeTypeCode
, active
, contactId
, registrationDate
, studyTimeCode
, currentAcademicYearId
, cardinalTimeUnitCode
, numberOfCardinalTimeUnits
, maxNumberOfCardinalTimeUnits
, numberOfSubjectsPerCardinalTimeUnit 
, maxNumberOfSubjectsPerCardinalTimeUnit
, brsPassingSubject
, studyFormCode
, maxNumberOfFailedSubjectsPerCardinalTimeUnit
, originalStudyGradeTypeId
)  SELECT distinct
     
 StudygradeType.studyId
, StudygradeType.gradeTypeCode
, StudyGradeType.active
, contactId
, StudygradeType.registrationDate
, StudygradeType.studyTimeCode
, AcademicYear.Id
, cardinalTimeUnitCode
, numberOfCardinalTimeUnits
, maxNumberOfCardinalTimeUnits
, numberOfSubjectsPerCardinalTimeUnit 
, maxNumberOfSubjectsPerCardinalTimeUnit
, brsPassingSubject
, '1' -- study form: regular learning
, maxNumberOfFailedSubjectsPerCardinalTimeUnit
, StudyGradeType.id
    
FROM
     "opuscollege".StudyPlanDetail StudyPlanDetail 
     INNER JOIN "opuscollege".StudyPlan StudyPlan ON StudyPlanDetail.studyPlanId  = StudyPlan.id
     INNER JOIN "opuscollege".AcademicYear AcademicYear ON AcademicYear."id" = StudyPlanDetail."academicyearid"
     INNER JOIN "opuscollege".StudyYear StudyYear ON studyplandetail."studyyearid" = studyyear."id"
     INNER JOIN "opuscollege".StudyGradeType StudyGradeType ON ((StudyYear."studygradetypeid" = studygradeType."id")
     OR (StudyPlan.studyGradeTypeId = StudyGradeType.id))
          
     ORDER BY AcademicYear.id;

--replicate studyyears
--old study years (those which are not replicated ) will be removed at the end of the scripts so it doesnt break any dependencies
ALTER TABLE opuscollege.StudyYear ADD COLUMN originalStudyGradeTypeId Integer NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.StudyYear ADD COLUMN originalStudyYearId Integer NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.StudyYear ADD COLUMN currentAcademicYearId Integer; --to be used later when converting study years to subject blocks, subject
ALTER TABLE opuscollege.StudyYear ADD COLUMN primaryStudyId Integer; --to be used later when converting study years to subject blocks, subject blocks have a primaryStudyId

INSERT INTO opuscollege.StudyYear(
	  studygradetypeid
	, yearnumber
	, yearnumbervariation
	, coursestructurevalidfromyear
	, coursestructurevalidthroughyear
	, creditamountoverall
	, creditamountperccompulsory
	, creditamountperccompulsoryfromlist
	, creditamountpercfreechoice
	, studyformcode
	, studytimecode
	, targetgroupcode
	, brsmaxcontacthours
	, brspassingstudyyear
	, registrationdate
	, originalStudyGradeTypeId
	, originalStudyYearId
	, currentAcademicYearId
	, primaryStudyId
)

SELECT distinct

	 StudyGradeType.id
	, StudyYear.yearnumber
	, StudyYear.yearnumbervariation
	, StudyYear.coursestructurevalidfromyear
	, StudyYear.coursestructurevalidthroughyear
	, StudyYear.creditamountoverall
	, StudyYear.creditamountperccompulsory
	, StudyYear.creditamountperccompulsoryfromlist
	, StudyYear.creditamountpercfreechoice
	, StudyYear.studyformcode
	, StudyYear.studytimecode
	, StudyYear.targetgroupcode
	, StudyYear.brsmaxcontacthours
	, StudyYear.brspassingstudyyear
	, StudyYear.registrationdate
	, StudyYear.studygradetypeid -- originalStudyGradeTypeId
	, StudyYear.id -- originalStudyYearId
	, StudyGradeType.currentAcademicYearId
	, StudygradeType.studyId

    FROM opuscollege.StudyYear 
    INNER JOIN opuscollege.StudyGradeType ON (
      (StudyYear.studyGradeTypeId = StudyGradeType.originalStudyGradeTypeId)
        AND (StudyGradeType.originalStudyGradeTypeId != 0)
      )
    INNER JOIN opuscollege.studyplandetail ON studyplandetail.studyyearid = studyyear.id AND studyplandetail.academicyearid = studygradetype.currentAcademicYearId
;

--temporary column to be removed on drop columns script
ALTER TABLE opuscollege.Subject ADD COLUMN originalSubjectId Integer NOT NULL DEFAULT 0;

-- Create a copy of each Subject for which studyplandetails exist
INSERT INTO opuscollege.Subject(

	 subjectcode
	, subjectdescription
	, subjectcontentdescription
	, primarystudyid
	, active
	, targetgroupcode
	, freechoiceoption
	, creditamount
	, hourstoinvest
	, frequencycode
	, studytimecode
	, examtypecode
	, maximumparticipants
	, brspassingsubject
	, registrationdate
	, currentacademicyearid
	, originalSubjectId
)

SELECT distinct
--	 subjectcode || '_' || AcademicYear.description 
     subjectcode
    , subjectdescription
    , subjectcontentdescription
    , Subject.primarystudyid
    , Subject.active
    , Subject.targetgroupcode
    , Subject.freechoiceoption
    , creditamount
    , hourstoinvest
    , frequencycode
    , Subject.studytimecode
    , examtypecode
    , maximumparticipants
    , brspassingsubject
    , Subject.registrationdate
    , studyplandetail.academicYearid
    , Subject.id
  FROM --opuscollege.AcademicYear, opuscollege.Subject;
  opuscollege.studyplandetail
  LEFT OUTER JOIN opuscollege.studyyear studyyear ON studyplandetail.studyyearid = studyyear.id
  LEFT OUTER JOIN opuscollege.subjectstudyyear subjectstudyyear ON studyyear.id = subjectstudyyear.studyyearid

  INNER JOIN opuscollege.subject subject ON subjectstudyyear.subjectid = subject.id
             OR subject.id = studyplandetail.subjectid;


--SubjectStudyGradeType : set the SubjectId and StudyGradeTypeId according to academic year
UPDATE opuscollege.SubjectStudyGradeType SET 
subjectId = Subject.Id
,studyGradeTypeId = StudyGradeType.Id
,rigiditytypecode = '1'

FROM opuscollege.Subject,opuscollege.StudyGradeType
WHERE
    subjectId = Subject.originalSubjectId
AND studyGradeTypeId = StudyGradeType.originalStudyGradeTypeId
AND Subject.currentAcademicYearId = StudyGradeType.currentAcademicYearId
; 

--########################## Study Plan ############################################
--migrate from studyplan.studygradetypeid to studyplan.study.id & studyplan.gradetypecode
UPDATE opuscollege.StudyPlan SPa
SET gradeTypeCode = 
 (SELECT StudyGradeType.gradeTypeCode FROM opuscollege.StudyPlan SPb 
INNER JOIN  opuscollege.StudyGradeType ON SPa.studyGradeTypeId = StudyGradeType.id AND SPb.id = SPa.id
);

UPDATE opuscollege.StudyPlan SPa
SET studyId = 
 (SELECT StudyGradeType.studyId FROM opuscollege.StudyPlan SPb 
INNER JOIN  opuscollege.StudyGradeType ON SPa.studyGradeTypeId = StudyGradeType.id AND SPb.id = SPa.id
);

--##########################StudyPlanCardinalTimeUnit###############################

--Delete loose StudyPlanDetails
DELETE
FROM opuscollege.StudyPlanDetail
WHERE 
(subjectId = 0 AND studyYearId = 0)
OR (subjectId IS NULL AND studyYearId IS NULL)
OR (subjectId IS NULL AND studyYearId = 0)
OR (subjectId = 0 AND studyYearId IS NULL);


--set StudyGradeType on StudyPlanDetail according to academic year
UPDATE opuscollege.StudyPlanDetail SET StudyGradeTypeId =
StudyGradeType.id
FROM opuscollege.studyPlan, opuscollege.StudyGradeType
WHERE 
studyplandetail.studyplanid = studyplan.id
AND (StudyGradeType.currentAcademicYearId = StudyPlanDetail.academicYearId)
AND (StudyGradeType.gradeTypeCode = studyplan.gradeTypeCode)
AND (StudyGradeType.studyId = studyplan.studyId)
;

--create a new StudyPlanCardinalTimeUnit for each StudyPlanDetail
--create temporary StudyPlanDetailId column , to be used later
ALTER TABLE opuscollege.StudyPlanCardinalTimeUnit ADD COLUMN studyPlanDetailId Integer;

INSERT INTO opuscollege.StudyPlanCardinalTimeUnit(
  studyPlanId
, cardinalTimeUnitNumber
, studyGradeTypeId
, studyPlanDetailId
, cardinaltimeunitstatuscode
)
SELECT StudyPlanDetail.studyPlanId
	, StudyYear.yearNumber
	, StudyPlanDetail.studyGradeTypeId
	, StudyPlanDetail.id
	, '10'
FROM opuscollege.StudyPlanDetail StudyPlanDetail
INNER JOIN opuscollege.StudyPlan StudyPlan ON StudyPlanDetail.studyPlanId = StudyPlan.Id
INNER JOIN opuscollege.StudyYear ON StudyPlanDetail.studyYearId = StudyYear.id
WHERE (studyPlanDetail.studyYearId != 0) AND (studyPlanDetail.studyYearId IS NOT NULL)
;

--loose subjects
UPDATE opuscollege.StudyPlanDetail SET subjectId = Subject.id
FROM opuscollege.Subject 
WHERE 
(Subject.originalSubjectId = StudyPlandetail.subjectId)
AND (Subject.currentAcademicYearId = StudyPlanDetail.academicYearId)
;

--#### New StudyPlanDetail structure

--studyGradeTypeId maps to old studyplan.studyGradeTypeId
/* StudyPlanDetail.studyGradeTypeId is already done a few steps earlier
UPDATE opuscollege.StudyPlanDetail SPDa
SET studyGradeTypeId = 
(
SELECT studyPlan.studyGradeTypeId
FROM opuscollege.StudyPlanDetail SPDb
 INNER JOIN opuscollege.StudyPlan ON SPDb.studyPlanId = studyPlan.id AND SPDa.id = SPDb.id
);*/

--New StudyPlandetails reference StudyPlanCardinalTimeUnit and not StudyPlan
UPDATE opuscollege.StudyPlanDetail 
SET studyPlanCardinalTimeUnitId = StudyPlanCardinalTimeUnit.id 
FROM opuscollege.StudyPlanCardinalTimeUnit 
WHERE StudyPlanCardinalTimeUnit.studyPlanDetailid = StudyPlanDetail.id
;


--map old StudyYear to CardinalTimeUnits
INSERT INTO opuscollege.CardinalTimeUnitStudyGradeType(studyGradeTypeId, cardinalTimeUnitNumber)
SELECT distinct StudyYear.studyGradeTypeId, StudyYear.yearNumber FROM opuscollege.StudyYear StudyYear WHERE originalStudyYearId != 0; --include only new studyyears

--since studyyears have been replicated because of academic years the ids must be updated so the studyyearid on studyplandetail reflects those changes
--new version of opus has subjectblockid instead of studyyearid, however studyyearid is kept in this script for later ops
UPDATE opuscollege.StudyPlanDetail SET studyYearId = StudyYear.id, subjectBlockId = StudyYear.id
FROM opuscollege.StudyYear 
WHERE (StudyPlanDetail.StudyYearId = StudyYear.originalStudyYearId)
AND (StudyYear.currentAcademicYearId = StudyPlanDetail.academicYearId)
--AND (StudyYear.originalStudyYearId != 0) --include only new studyyears
;
