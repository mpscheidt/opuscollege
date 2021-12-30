
SET search_path = opuscollege, pg_catalog;
/*
ALTER TABLE opususerrole
	DROP CONSTRAINT opususerrole_role_key;

ALTER TABLE opususerrole
	DROP CONSTRAINT opususerrole_lang_fkey;

ALTER TABLE subject
	DROP CONSTRAINT subject_subjectcode_key;

ALTER TABLE subjectblock
	DROP CONSTRAINT subjectblock_subjectblockcode_key;

ALTER TABLE subjectblockstudygradetype
	DROP CONSTRAINT subjectblockstudygradetype_subjectblockid_key;

ALTER TABLE subjectblockstudyyear
	DROP CONSTRAINT subjectblockstudyyear_studyyearid_fkey;
*/
DROP TABLE exam;

DROP TABLE markevaluation;

DROP TABLE studyyear CASCADE;

DROP TABLE subjectstudyyear;

DROP SEQUENCE markevaluationseq;

DROP SEQUENCE studyyearseq;

DROP SEQUENCE subjectstudyyearseq;

ALTER TABLE academicyear
	DROP COLUMN code,
	DROP COLUMN lang;

ALTER TABLE opususerrole
	DROP COLUMN lang;

ALTER TABLE student
	DROP COLUMN statuscode;

ALTER TABLE studygradetype
	DROP COLUMN numberofyears;

ALTER TABLE studyplan
	DROP COLUMN studygradetypeid;

ALTER TABLE studyplandetail
	DROP COLUMN studyyearid;

ALTER TABLE subject
	DROP COLUMN rigiditytypecode,
	DROP COLUMN subjectimportancecode,
	DROP COLUMN studyformcode,
	DROP COLUMN brsapplyingtosubject,
	DROP COLUMN subjectstructurevalidfromyear,
	DROP COLUMN subjectstructurevalidthroughyear;

ALTER TABLE subjectblock
	DROP COLUMN brsapplyingtoblock,
	DROP COLUMN subjectblockstructurevalidfromyear,
	DROP COLUMN subjectblockstructurevalidthroughyear;


--drop temporary columns
ALTER TABLE Examination	DROP COLUMN originalExaminationId;
ALTER TABLE Examination	DROP COLUMN currentAcademicYearId;

ALTER TABLE Test DROP COLUMN originalTestId;
ALTER TABLE Test DROP COLUMN currentAcademicYearId;



ALTER TABLE opuscollege.Subject DROP COLUMN originalSubjectId;
ALTER TABLE opuscollege.StudyGradeType DROP COLUMN originalStudyGradeTypeId;


ALTER TABLE opuscollege.StudyPlanCardinalTimeUnit DROP COLUMN studyPlanDetailId ;


ALTER TABLE opuscollege.subjectteacher DROP COLUMN migrated;
ALTER TABLE opuscollege.subjectStudyType DROP COLUMN migrated;
ALTER TABLE opuscollege.ExaminationTeacher DROP COLUMN migrated;
ALTER TABLE opuscollege.testTeacher DROP COLUMN migrated;
--ALTER TABLE opuscollege.subjectResult DROP COLUMN invisible;

