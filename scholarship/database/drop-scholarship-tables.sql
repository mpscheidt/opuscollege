--------------------------------------------------------------------
-- Drop scholarship tables
-- Remove scholarship entries from lookuptable and tabledependency
-- Remove 'scholarship' entry from appversions table
--------------------------------------------------------------------

DROP TABLE if exists opuscollege.sch_bank;
DROP TABLE if exists opuscollege.sch_complaint;
DROP TABLE if exists opuscollege.sch_complaintstatus;
DROP TABLE if exists opuscollege.sch_decisioncriteria;
DROP TABLE if exists opuscollege.sch_scholarshipapplication;
DROP TABLE if exists opuscollege.sch_scholarship;
DROP TABLE if exists opuscollege.sch_scholarshiptype;
DROP TABLE if exists opuscollege.sch_subsidy;
DROP TABLE if exists opuscollege.sch_sponsor;
DROP TABLE if exists opuscollege.sch_sponsorfeepercentage;
DROP TABLE if exists opuscollege.sch_sponsorpayment;
DROP TABLE if exists opuscollege.sch_sponsortype;
DROP TABLE if exists opuscollege.sch_student;
DROP TABLE if exists opuscollege.sch_subsidytype;
DROP TABLE if exists audit.sch_sponsor_hist;
DROP TABLE if exists audit.sch_sponsorfeepercentage_hist;
DROP TABLE if exists audit.sch_sponsorInvoice_hist;
DROP TABLE if exists audit.sch_sponsorPayment_hist;
DROP TABLE if exists audit.sch_scholarshipFeePercentage_hist;
DELETE from opuscollege.tabledependency where dependentTable like 'sch_%';
DELETE from opuscollege.lookuptable where tablename like 'sch_%';
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'scholarship';
