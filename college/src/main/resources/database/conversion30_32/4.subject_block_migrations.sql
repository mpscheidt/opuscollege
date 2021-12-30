--Migrate data from study years to subject blocks
--ALTER TABLE opuscollege.SubjectBlock ADD COLUMN originalStudyYearId Integer;
INSERT INTO opuscollege.SubjectBlock(
          id
	, subjectBlockCode
	, subjectBlockDescription
	, active
	, targetGroupCode
	, registrationDate
	, brsPassingSubjectBlock
	, blockTypeCode
	, brsMaxContactHours
	, studyTimeCode
	, currentAcademicYearId
	, primaryStudyId
	, freeChoiceOption
)
SELECT StudyYear.id
	, 'SB' || StudyYear.id
	--, yearNumber || '° ano'
	, yearNumberVariation
	, 'Y'
	, StudyYear.targetGroupCode
	, StudyYear.registrationDate
	, StudyYear.brsPassingStudyYear
	, '2' /*study year*/
	, StudyYear.studyTimeCode
	, StudyYear.brsMaxContactHours
	, StudyYear.currentAcademicYearId
	, StudyYear.primaryStudyId 
	, 'Y'
  FROM opuscollege.StudyYear
  WHERE StudyYear.originalStudyYearId != 0 --include only new studyyears
;

-- because the id has been hard-coded, the next value for the sequence needs to be set manually
SELECT setval('opuscollege.subjectblockseq', (select max(id) from opuscollege.subjectblock));

--Migrate from SubjectStudyYear to SubjectBlock
--To do SubjectStudyYear combination for each academic year
INSERT INTO opuscollege.SubjectSubjectBlock (
    subjectId, subjectBlockId
    )
SELECT Subject.id, studyyear.id
FROM opuscollege.SubjectStudyYear
INNER JOIN opuscollege.Subject ON Subject.originalSubjectId = SubjectStudyYear.subjectId
INNER JOIN opuscollege.studyyear ON studyyear.originalStudyYearId = SubjectStudyYear.studyYearId
WHERE Subject.currentAcademicYearId = studyyear.currentAcademicYearid
;

-- recover invisible subject results by adding respective subjects to subject blocks
/*INSERT INTO opuscollege.SubjectSubjectBlock (
    subjectId
  , subjectBlockId
)
SELECT DISTINCT 
    subjectResult.subjectId
  , studyplandetail.subjectBlockId
  FROM opuscollege.subjectResult
  inner join opuscollege.studyplandetail studyplandetail on subjectresult.studyplandetailid = studyplandetail.id
WHERE subjectresult.invisible = true
and studyplandetail.subjectBlockId != 0
;*/

/*INSERT INTO opuscollege.studyplandetail (
    studyPlanId
  , subjectId
  , studyplancardinaltimeunitid
  , studyGradeTypeid
  , acadedemicYearId
)
SELECT 
    origSPD.studyPlanId
  , subjectResult.subjectId
  , origSPD.studyPlanCardinalTimeUnitId
  , origSPD.studyGradeTypeId
  , origSPD.academicyearid
  FROM opuscollege.subjectResult
    inner join opuscollege.studyplandetail origSPD on subjectresult.studyplandetailid = origSPD.id
--  INNER JOIN opuscollege.subject ON subjectresult.subjectid = subject.Id
WHERE subjectresult.invisible = true
;*/

-- subjectblock associations with studygradetypes
INSERT INTO opuscollege.subjectBlockStudyGradeType (
    subjectblockid
  , studygradetypeid
  , cardinaltimeunitnumber
  , rigiditytypecode
)
SELECT
    studyyear.id
  , studyyear.studygradetypeid
  , studyyear.yearnumber
  , '1'
FROM opuscollege.studyyear
WHERE originalstudyyearid != 0
;
