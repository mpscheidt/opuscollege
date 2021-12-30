--select * from opuscollege.student  
--Clear students user accounts
delete from opuscollege.opususer where username in (select studentcode from opuscollege.student)  ;
--delete person
--delete from opuscollege.person where personcode in (select studentcode from opuscollege.student);
