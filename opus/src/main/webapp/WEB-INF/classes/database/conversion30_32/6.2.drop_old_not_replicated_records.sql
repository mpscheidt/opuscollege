--drop records with no academicyear associated
DELETE FROM opuscollege.StudyGradeType WHERE originalStudyGradeTypeId = 0;
DELETE FROM opuscollege.Examination WHERE originalExaminationId = 0;
DELETE FROM opuscollege.Test WHERE originalTestId = 0;
DELETE FROM opuscollege.Subject WHERE originalSubjectId = 0 ;
