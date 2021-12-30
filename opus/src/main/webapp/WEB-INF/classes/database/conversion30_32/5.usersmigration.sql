
-----
----Copy lang values from OpusUserRole.lang to OpusUser.lang
---

UPDATE opuscollege.OpusUser SET lang = (SELECT lang FROM opuscollege.OpusUserRole WHERE OpusUserRole.username = OpusUser.username);



----
---Set the organizationalId role for staff users
UPDATE opuscollege.OpusUserRole SET organizationalUnitId = 
primaryUnitOfAppointmentId
FROM opuscollege.StaffMember, opuscollege.OpusUser

WHERE (StaffMember.personId = OpusUser.personId)
     AND (OpusUser.userName = OpusUserRole.userName);


----
---Set the organizationalId role for student users
UPDATE opuscollege.OpusUserRole SET organizationalUnitId = 
Study.organizationalUnitId
FROM opuscollege.Student, opuscollege.OpusUser, opuscollege.Study

WHERE (Student.personId = OpusUser.personId)
     AND (OpusUser.userName = OpusUserRole.userName)
     AND (Study.id = Student.primaryStudyId);


UPDATE opuscollege.OpusUserRole SET organizationalUnitId = 0 WHERE organizationalUnitId is NULL;

--assign a preferedOrganizationalUnit, the first in the list
UPDATE opuscollege.OpusUser OUa SET preferredOrganizationalUnitId = 
(SELECT organizationalUnitId FROM opuscollege.OpusUserRole
INNER JOIN opuscollege.OpusUser OUb ON 
((OUb.userName = OpusUserRole.UserName) AND (OUa.userName = OUb.userName))
 LIMIT 1
 );


UPDATE opuscollege.role SET level=1 WHERE role='admin';
UPDATE opuscollege.role SET level=2 WHERE role='admin-C';
UPDATE opuscollege.role SET level=3 WHERE role='admin-B';
UPDATE opuscollege.role SET level=4 WHERE role='admin-D';
UPDATE opuscollege.role SET level=5 WHERE role='teacher' OR role='staff';
UPDATE opuscollege.role SET level=6 WHERE role='student';
UPDATE opuscollege.role SET level=7 WHERE role='guest';



