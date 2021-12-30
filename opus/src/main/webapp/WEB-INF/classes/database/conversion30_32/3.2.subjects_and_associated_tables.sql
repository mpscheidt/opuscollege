
-- subject teachers
-- following columns will be dropped later
ALTER TABLE opuscollege.subjectteacher ADD migrated boolean NOT NULL DEFAULT false;

INSERT INTO opuscollege.subjectTeacher (
  staffmemberid
, subjectid
, active
, migrated
) SELECT 
  staffmemberid
, subject.id
, subjectTeacher.active
, true
FROM opuscollege.subjectTeacher
INNER JOIN opuscollege.subject ON subjectTeacher.subjectId = subject.originalsubjectId;

DELETE FROM opuscollege.subjectTeacher WHERE migrated = false;


-- didactical forms for subject (subjectstudytype)
-- following columns will be dropped later
ALTER TABLE opuscollege.subjectStudyType ADD migrated boolean NOT NULL DEFAULT false;

INSERT INTO opuscollege.subjectStudyType (
  subjectid
, studytypecode
, active
, migrated
) SELECT
  subject.id
, studytypecode
, subjectStudyType.active
, true
FROM opuscollege.subjectStudyType
INNER JOIN opuscollege.subject ON subjectStudyType.subjectId = subject.originalsubjectId;

DELETE FROM opuscollege.subjectStudyType WHERE migrated = false;


-- subject results:
-- first mark subject results that are currently invisible (probably unintentionally)
-- and include subjects related to invisible subject results in migration
-- column will be dropped later
/*ALTER TABLE opuscollege.subjectResult ADD COLUMN invisible boolean NOT NULL DEFAULT false;
UPDATE opuscollege.subjectResult SET invisible = true
WHERE id in (
    select distinct subjectresult.id from opuscollege.subjectresult
    inner join opuscollege.studyplandetail on subjectresult.studyplandetailid = studyplandetail.id
    where not exists (
    select * from opuscollege.subject where subject.originalsubjectid = subjectresult.subjectid
      and subject.currentacademicyearid = studyplandetail.academicyearid
    )
);*/


-- Recover 'invisible subject results':
-- Transfer subjects related to invisible subject results (to avoid losing these subject results)
/*INSERT INTO opuscollege.Subject(

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
--   subjectcode || '_' || AcademicYear.description 
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
  FROM opuscollege.SubjectResult
  INNER JOIN opuscollege.subject ON subjectresult.subjectid = subject.id
  INNER JOIN opuscollege.studyplandetail ON subjectresult.studyplandetailid = studyplandetail.id 
  WHERE subjectresult.invisible = true
;*/


-- subject results
UPDATE opuscollege.subjectResult SET subjectId = subject.id
FROM opuscollege.studyplandetail, opuscollege.subject
WHERE subjectResult.studyPlanDetailId = studyPlanDetail.id
and Subject.originalSubjectId = subjectResult.subjectId
AND Subject.currentAcademicYearId = StudyPlanDetail.academicYearId;





--###########Replicate exams for each Subject/AcademicYear

--### following columns will be dropped later
ALTER TABLE opuscollege.Examination ADD originalExaminationId Integer NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.Examination ADD currentAcademicYearId Integer NOT NULL DEFAULT 0;

INSERT INTO opuscollege.Examination(
	examinationcode
	, examinationdescription
	, subjectid
	, examinationtypecode
	, numberofattempts
	, weighingfactor
	, brspassingexamination
	, active
	, originalExaminationId
	, currentAcademicYearId
	)
  
SELECT 
	Examination.examinationCode
	, Examination.examinationDescription
	, Subject.id
	, Examination.examinationTypeCode
	, Examination.numberOfAttempts
	, Examination.weighingFactor
	, Examination.brsPassingExamination
	, Examination.active
	, Examination.id
	, Subject.currentAcademicYearId
FROM opuscollege.Examination
INNER JOIN opuscollege.Subject ON Subject.originalSubjectId = Examination.subjectId
;


--#tables that depend on examination

-- examinationteacher 
-- examinationresult
-- test
-- testteacher
-- testresult

--UPDATE opuscollege.ExaminationTeacher SET ExaminationId = Examination.id
--FROM opuscollege.Examination 
--WHERE Examination.originalExaminationId = examinationId;

-- following columns will be dropped later
ALTER TABLE opuscollege.ExaminationTeacher ADD migrated boolean NOT NULL DEFAULT false;

INSERT INTO opuscollege.ExaminationTeacher (
  staffmemberid
, examinationid
, active
, migrated
) SELECT 
  staffmemberid
, examination.id
, ExaminationTeacher.active
, true
FROM opuscollege.ExaminationTeacher
INNER JOIN opuscollege.Examination ON ExaminationTeacher.examinationId = examination.originalExaminationId;

DELETE FROM opuscollege.ExaminationTeacher WHERE migrated = false;


--##############################################################################################################################################
--####set the right examination for the right academic year


UPDATE opuscollege.examinationresult
	SET examinationId = Examination.id
	    ,subjectId  = Subject.id

FROM opuscollege.Subject, opuscollege.Examination, opuscollege.StudyPlanDetail

WHERE (Subject.originalSubjectId = ExaminationResult.subjectId) 
AND (ExaminationResult.examinationId = Examination.originalExaminationId)
AND (Examination.currentAcademicYearId = Subject.currentAcademicYearId)
AND (Subject.currentAcademicYearId = StudyPlanDetail.academicYearId)
AND (ExaminationResult.studyPlanDetailId = StudyPlanDetail.id)
;

--##############################################################################################################################################

--### following columns will be dropped later
ALTER TABLE opuscollege.Test ADD originalTestId Integer NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.Test ADD currentAcademicYearId Integer NOT NULL DEFAULT 0;

INSERT INTO opuscollege.Test(           
	    testCode
           , testDescription
           , examinationId
           , examinationTypeCode
           , numberofAttempts
           , weighingFactor
           , minimumMark
           , maximumMark
           , brsPassingTest
           , active
           , originalTestId
	   , currentAcademicYearId
	)
SELECT testCode
	, testDescription
	, Examination.id
	, Test.examinationTypeCode
	, Test.numberOfAttempts
	, Test.weighingFactor
	, minimumMark
	, maximummark
	, brsPassingTest
	, Test.active
	, test.id
	, Examination.currentAcademicYearId
  FROM opuscollege.test
  INNER JOIN opuscollege.Examination ON Examination.originalExaminationId = Test.examinationId
;


-- test teacher
-- following columns will be dropped later
ALTER TABLE opuscollege.testTeacher ADD migrated boolean NOT NULL DEFAULT false;

INSERT INTO opuscollege.testTeacher (
  staffmemberid
, testid
, active
, migrated
) SELECT 
  staffmemberid
, test.id
, testTeacher.active
, true
FROM opuscollege.testTeacher
INNER JOIN opuscollege.test ON testTeacher.testId = test.originalTestId;

DELETE FROM opuscollege.testTeacher WHERE migrated = false;


UPDATE opuscollege.TestResult 
	SET testId = Test.id, examinationId = Examination.id
FROM opuscollege.Test, opuscollege.examination, opuscollege.StudyPlanDetail
WHERE       (TestResult.testId = Test.originalTestId)
	AND (TestResult.studyPlanDetailId = StudyPlanDetail.id)
	AND (Test.currentAcademicYearId = StudyPlanDetail.academicYearId)
	AND TestResult.examinationId = examination.originalExaminationId
	AND examination.currentAcademicYearId = StudyPlanDetail.academicYearId;


