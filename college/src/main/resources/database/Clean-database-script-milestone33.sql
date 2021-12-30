-- first clean up manually:
--person, opususer, staffmember manually
--institution, branch, organizationalunit

-- leave the initial branch 'registry' and underlying organizational units in the database

-- audit
delete from audit.cardinaltimeunitresult_hist;
delete from audit.examinationresult_hist;
delete from audit.fee_fee_hist;
delete from audit.fee_payment_hist;
delete from audit.financialrequest_hist;
delete from audit.financialtransaction_hist;
delete from audit.studentbalance_hist;
delete from audit.studyplanresult_hist;
delete from audit.subjectresult_hist;
delete from audit.testresult_hist;
delete from audit.thesisresult_hist;

-- opuscollege
delete from opuscollege.acc_accommodationfee;
delete from opuscollege.acc_accommodationfeepayment;
delete from opuscollege.acc_accommodationselectioncriteria;
delete from opuscollege.acc_block;
delete from opuscollege.acc_hostel;
delete from opuscollege.acc_hosteltype;
delete from opuscollege.acc_room;
delete from opuscollege.acc_studentaccommodation;
delete from opuscollege.acc_studentaccommodationselectioncriteria;
delete from opuscollege.address;
delete from opuscollege.administrativepost;
delete from opuscollege.admissionregistrationconfig;
delete from opuscollege.cardinaltimeunitresult;
delete from opuscollege.cardinaltimeunitstudygradetype;
delete from opuscollege.careerposition;
delete from opuscollege.contract;
delete from opuscollege.examination;
delete from opuscollege.examinationresult;
delete from opuscollege.examinationteacher;
delete from opuscollege.fee_fee;
delete from opuscollege.fee_payment;
delete from opuscollege.financialrequest;
delete from opuscollege.financialtransaction;
delete from opuscollege.gradedsecondaryschoolsubject;
delete from opuscollege.groupedsecondaryschoolsubject;

delete from opuscollege.logmailerror;
delete from opuscollege.obtainedqualification;
delete from opuscollege.penalty;
delete from opuscollege.referee;
delete from opuscollege.requestadmissionperiod;
delete from opuscollege.requestforchange;

delete from opuscollege.sch_bank;
delete from opuscollege.sch_complaint;
delete from opuscollege.sch_subsidy;
delete from opuscollege.sch_scholarshipapplication;
delete from opuscollege.sch_scholarship;
delete from opuscollege.sch_student;
delete from opuscollege.sch_sponsorfeepercentage;
delete from opuscollege.sch_sponsorpayment;

delete from opuscollege.secondaryschoolsubjectgroup;
delete from opuscollege.student;
delete from opuscollege.studentabsence;
delete from opuscollege.studentactivity;
delete from opuscollege.studentbalance;
delete from opuscollege.studentcareer;
delete from opuscollege.studentcounseling;
delete from opuscollege.studentexpulsion;
delete from opuscollege.studentplacement;
delete from opuscollege.studentstudentstatus;
delete from opuscollege.study;
delete from opuscollege.studygradetype;
delete from opuscollege.studygradetypeprerequisite;
delete from opuscollege.studyplan;
delete from opuscollege.studyplancardinaltimeunit;
delete from opuscollege.studyplandetail;
delete from opuscollege.studyplanresult;
delete from opuscollege.subject;
delete from opuscollege.subjectblock;
delete from opuscollege.subjectblockprerequisite;
delete from opuscollege.subjectblockstudygradetype;
delete from opuscollege.subjectprerequisite;
delete from opuscollege.subjectresult;
delete from opuscollege.subjectstudygradetype;
delete from opuscollege.subjectstudytype;
delete from opuscollege.subjectsubjectblock;

delete from opuscollege.subjectteacher;
delete from opuscollege.test;
delete from opuscollege.testresult;
delete from opuscollege.testteacher;
delete from opuscollege.thesis;
delete from opuscollege.thesisresult;
delete from opuscollege.thesissupervisor;
