-- Schema opuscollege

-- script cleans students, but not staff members, clean manually:
--   person, opususer, staffmember
--      (however: opususer records are removed that are not referenced)
--   academicyear
--   institution, branch, organizationalunit

-- leave the initial branch 'registry' and underlying organizational units in the database

-- TODO find out why 'lookuptable' is truncated; it is needed in test database

-- results
truncate opuscollege.testresult;
truncate opuscollege.examinationresult;
truncate opuscollege.subjectresult;
truncate opuscollege.cardinaltimeunitresult;
truncate opuscollege.thesisresult;
truncate opuscollege.studyplanresult;

-- students
truncate opuscollege.careerposition; -- references studyplan
truncate opuscollege.gradedsecondaryschoolsubject; -- references studyplan
truncate opuscollege.obtainedqualification; -- references studyplan
truncate opuscollege.referee; -- references studyplan
truncate opuscollege.requestforchange; -- no direct reference, but is about changing studyplans
truncate opuscollege.studyplandetail cascade; -- references studyplancardinaltimeunit
truncate opuscollege.studyplancardinaltimeunit cascade;
truncate opuscollege.thesissupervisor;
truncate opuscollege.thesisthesisstatus;
truncate opuscollege.thesis; -- references studyplan
truncate opuscollege.studyplan cascade; -- references student
truncate opuscollege.penalty; -- references student
truncate opuscollege.studentabsence;
truncate opuscollege.studentactivity;
truncate opuscollege.studentcareer;
truncate opuscollege.studentclassgroup;
truncate opuscollege.studentcounseling;
truncate opuscollege.studentexpulsion;
truncate opuscollege.studentplacement;
truncate opuscollege.studentstudentstatus;
truncate opuscollege.address; -- references person, study, organizationalunit
delete from opuscollege.person where id not in (     -- referenced by student
  select personid from opuscollege.staffmember
);
truncate opuscollege.student CASCADE;

-- curriculum
truncate opuscollege.testteacher;
truncate opuscollege.test CASCADE;
truncate opuscollege.examinationteacher;
truncate opuscollege.examination CASCADE;

truncate opuscollege.subjectteacher;
truncate opuscollege.subjectprerequisite;
truncate opuscollege.subjectstudygradetype;
truncate opuscollege.subjectstudytype;
truncate opuscollege.subjectsubjectblock;
truncate opuscollege.subject CASCADE;
truncate opuscollege.subjectblockprerequisite;
truncate opuscollege.subjectblockstudygradetype;
truncate opuscollege.subjectblock CASCADE;

truncate opuscollege.classgroup CASCADE; -- references studygradetype
truncate opuscollege.secondaryschoolsubjectgroup CASCADE; -- references studygradetype
truncate opuscollege.cardinaltimeunitstudygradetype CASCADE;
truncate opuscollege.studygradetypeprerequisite CASCADE;
truncate opuscollege.studygradetype CASCADE;
truncate opuscollege.study CASCADE;

truncate opuscollege.requestadmissionperiod CASCADE; -- references academicyear


-- staffmember
truncate opuscollege.contract CASCADE; -- references staff member

delete from opuscollege.opususer
where not exists (
 select * from opuscollege.student where opususer.personid = student.personid
) and not exists (
 select * from opuscollege.staffmember where opususer.personid = staffmember.personid
);

-- institution
truncate opuscollege.admissionregistrationconfig CASCADE; -- references organizationalunit, academicyear


-- admin
truncate opuscollege.groupeddiscipline CASCADE;
truncate opuscollege.groupedsecondaryschoolsubject CASCADE;
truncate opuscollege.logmailerror CASCADE;
truncate opuscollege.logrequesterror CASCADE;

-- lookups
--truncate opuscollege.administrativepost;
--truncate opuscollege.secondaryschoolsubject;
--truncate opuscollege.disciplinegroup;


-- Schema audit
truncate audit.cardinaltimeunitresult_hist;
truncate audit.endgrade_hist;
truncate audit.examinationresult_hist;
truncate audit.gradedsecondaryschoolsubject_hist;
truncate audit.staffmember_hist;
truncate audit.student_hist;
truncate audit.studentabsence_hist;
truncate audit.studentexpulsion_hist;
truncate audit.studyplanresult_hist;
truncate audit.subjectresult_hist;
truncate audit.testresult_hist;
truncate audit.thesisresult_hist;

