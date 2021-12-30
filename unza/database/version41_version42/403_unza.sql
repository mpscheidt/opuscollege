--delete from opuscollege.gradetype where id > 140;
--delete from opuscollege.subject where subjectdescription not in ('M101','M102','M103','M104','M105','M106','M107','M108') ;		
select  opuscollege.staffMember.*,
                opuscollege.person.*
        from opuscollege.staffMember
        INNER JOIN opuscollege.person ON opuscollege.staffMember.personId = opuscollege.person.id
        WHERE opuscollege.staffMember.staffMemberCode = 'dsm';	
        
 --Create studygradetype table
 select distinct ay.quotacode ,ay.majorcode,c.course 
into  srsdatastage.subjectstudygradetype2004_20122 from srsdatastage.acadyr ay 
inner join srsdatastage.credit c on c.ayear = ay.ayear 
where c.studentid = ay.studentid 
AND ay.ayear in ('20041','20042','20051','20052','20061','20062','20071','20072','20081','20082','20091','20092','20101','20102');

--Create ssgt_20041_20102
select distinct ay.yearofprogram,ay.quotacode as quota_code ,ay.majorcode as major_code,ay.course as course_code,m.title as m_title, uname,
cs.coursedescription as course_descr, cs.semester , cs.schoolcode as school_code
into srsdatastage.ssgt_20041_20102  from srsdatastage.subjectstudygradetype2004_20122 ay 
inner join srsdatastage.major m on m.majorcode = ay.majorcode 
inner join srsdatastage.course cs on ay.course = cs.coursecode
inner join srsdatastage.school s on s.code = cs.schoolcode 

--delete query
delete from opuscollege.subjectstudygradetype where id > 30410
--Query 2
select distinct a.ayear ,a.yearofprogram,quotacode,majorcode,a.schoolcode,course,coursedescription,semester from srsdatastage.acadyr a 
inner join srsdatastage.credit c on c.studentid = a.studentid 
inner join srsdatastage.course cs on cs.coursecode = c.course 
where c.ayear = a.ayear and a.ayear = '20041'