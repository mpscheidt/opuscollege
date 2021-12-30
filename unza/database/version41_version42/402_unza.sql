--Delete studygrade types
delete from opuscollege.studygradetype;
delete from opuscollege.subjectstudygradetype;
--Remove duplicates in quota
alter table srsdatastage.quota  RENAME to quota_old;
select distinct * INTO srsdatastage.quota from srsdatastage.quota_old;

--Remove duplicates in opuscollege.gradetype
alter table opuscollege.gradetype RENAME to gradetype_old;
select distinct * INTO opuscollege.gradetype from opuscollege.gradetype_old;

delete from opuscollege.study where studydescription like 'Dps-%';
--Create a Programme of study/studygradetype
INSERT INTO opuscollege.studygradetype(
            studyid, gradetypecode, active, 
             currentacademicyearid, cardinaltimeunitcode, 
            numberofcardinaltimeunits, maxnumberofcardinaltimeunits, numberofsubjectspercardinaltimeunit, 
            maxnumberofsubjectspercardinaltimeunit, studytimecode, 
            studyformcode,studyintensitycode)
    VALUES (  
            1320,94, 'Y', 14,'2', 4,6,4,6,'1','1','F' );
            
--Create subject study grade type combinations
INSERT INTO opuscollege.subjectstudygradetype(
            subjectid, studygradetypeid, active, 
            cardinaltimeunitnumber, rigiditytypecode, importancetypecode)
    VALUES (71250, 85283, 'Y', 
            '1', '1', '1');