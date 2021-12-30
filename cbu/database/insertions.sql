INSERT INTO opuscollege.study (studydescription,active,organizationalunitid)
select 'Land Economy','N',organizationalunitid from opuscollege.study where studydescription='Real Estate';
INSERT INTO opuscollege.study (studydescription,active,organizationalunitid)
select 'B','N',organizationalunitid from opuscollege.study where studydescription='Building Science';
