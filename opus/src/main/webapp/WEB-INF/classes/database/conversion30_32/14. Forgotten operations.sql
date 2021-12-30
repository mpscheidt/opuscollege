
-- For future DB migrations, the operations in this script should be integrated into the 
-- main DB migration scripts, because at this time it is only a workaround.


-- some studyplandetails of loose subject weren't migrated correctly yet: missing cardinaltimeunitid

update opuscollege.studyplandetail sdp1
set studyplancardinaltimeunitid = sdp2.studyplancardinaltimeunitid
from 
opuscollege.studyplandetail sdp2 

where sdp2.studyplancardinaltimeunitid != 0
  and sdp1.studyplanid = sdp2.studyplanid
  and sdp1.academicyearid = sdp2.academicyearid
and sdp1.studyplancardinaltimeunitid = 0

-- create missing studyplancardinaltimeunits

insert into opuscollege.studyplancardinaltimeunit
(studyplanid, cardinaltimeunitnumber, studygradetypeid, cardinaltimeunitstatuscode)

select distinct
     studyplandetail.studyplanid
     , cardinaltimeunitnumber
     , studyplandetail.studygradetypeid
     , '10'
      from opuscollege.studyplandetail
inner join opuscollege.academicyear on studyplandetail.academicyearid = academicyear.id

inner join opuscollege.studyplandetail prevsdp on studyplandetail.studyplanid = prevsdp.studyplanid
  and prevsdp.studyplancardinaltimeunitid != 0

inner join opuscollege.studyplancardinaltimeunit on prevsdp.studyplancardinaltimeunitid = studyplancardinaltimeunit.id
inner join opuscollege.academicyear prevay on prevsdp.academicyearid = prevay.id and prevay.nextAcademicYearId = academicyear.id

where studyplandetail.studyplancardinaltimeunitid = 0

-- update as many studyplandetails as possible
update opuscollege.studyplandetail
set studyplancardinaltimeunitid = 
  (
  select id from opuscollege.studyplancardinaltimeunit
  where studyplancardinaltimeunit.studyplanid = studyplandetail.studyplanid
    and studyplancardinaltimeunit.studygradetypeid = studyplandetail.studygradetypeid
  )

where studyplandetail.studyplancardinaltimeunitid = 0
and exists (
  select * from opuscollege.studyplancardinaltimeunit
  where studyplancardinaltimeunit.studyplanid = studyplandetail.studyplanid
    and studyplancardinaltimeunit.studygradetypeid = studyplandetail.studygradetypeid
)

-- these are the remaining studyplandetails (do by hand)
select * from opuscollege.studyplandetail
where not exists (
  select * from opuscollege.studyplancardinaltimeunit
  where studyplancardinaltimeunit.studyplanid = studyplandetail.studyplanid
    and studyplancardinaltimeunit.studygradetypeid = studyplandetail.studygradetypeid
)
and studyplandetail.studyplancardinaltimeunitid = 0
and (subjectid != 0 or subjectblockid != 0)


ALTER TABLE opuscollege.studyPlanDetail DROP COLUMN academicYearId;

