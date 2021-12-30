
-- study time is mandatory, so set a default value (1 = daytime)
update opuscollege.subject set studyTimeCode = '1' where studyTimeCode = '0' or studyTimeCode = '';

-- study time is mandatory, so set a default value (1 = daytime)
update opuscollege.subjectblock set studyTimeCode = '1' where studyTimeCode = '0' or studyTimeCode = '';

-- all lookup table entries: lowercase
update opuscollege.lookuptable set tablename = lower(tablename);



-- set subject blocks to 'evening' ('2') that are associated to evening studygradetypes
update opuscollege.subjectblock set studytimecode = '2'
from opuscollege.subjectblockstudygradetype
inner join opuscollege.studygradetype on subjectblockstudygradetype.studygradetypeid = studygradetype.id
where 
subjectblockstudygradetype.subjectblockid = subjectblock.id
and studygradetype.studytimecode = '2'
and subjectblock.studytimecode != '2'

-- set subject blocks to 'day/evening' ('3') that are associated to day/evening studygradetypes
update opuscollege.subjectblock set studytimecode = '3'
from opuscollege.subjectblockstudygradetype
inner join opuscollege.studygradetype on subjectblockstudygradetype.studygradetypeid = studygradetype.id
where 
subjectblockstudygradetype.subjectblockid = subjectblock.id
and studygradetype.studytimecode = '3'
and subjectblock.studytimecode != '3'


-- add active status to all students (visible in subscription data)
insert into opuscollege.studentstudentstatus (
studentid
, startdate
, studentstatuscode
)
select student.studentid, student.dateofenrolment, '1'
from opuscollege.student
where not exists (
  select * from opuscollege.studentstudentstatus where studentid = student.studentid
)


-- TODO create prerequisite bachelor study for studygradetypes with gradetypecode LICBSC


