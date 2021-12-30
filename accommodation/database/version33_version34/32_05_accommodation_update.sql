DROP TABLE opuscollege.acc_studentaccommodationselectioncriteria CASCADE;
DROP TABLE opuscollege.acc_accommodationselectioncriteria CASCADE;
DROP TABLE opuscollege.acc_accommodationfeepayment CASCADE;

ALTER TABLE opuscollege.acc_hostel DROP CONSTRAINT acc_hostel_hosteltypeid_fkey;
ALTER TABLE opuscollege.acc_hostel RENAME hosteltypeid  TO hosteltypecode;
ALTER TABLE opuscollege.acc_hostel ALTER COLUMN hosteltypecode TYPE VARCHAR;