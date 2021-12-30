
-- cardinaltimeunit
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('cardinaltimeunit', 'Lookup8', 'Y');
-- data
DELETE FROM opuscollege.cardinaltimeunit;
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('en','1','Year', 1);
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('en','2','Semester', 2);
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('en','3','Trimester', 3);

INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('pt','1','Ano', 1);
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('pt','2','Semestre', 2);
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('pt','3','Trimestre', 3);


-- dayPart
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('daypart', 'Lookup', 'Y');
-- data
DELETE FROM opuscollege.daypart;
INSERT INTO opuscollege.daypart (lang,code,description) VALUES ('en','1','Morning');
INSERT INTO opuscollege.daypart (lang,code,description) VALUES ('en','2','Afternoon');
INSERT INTO opuscollege.daypart (lang,code,description) VALUES ('en','3','Evening');

INSERT INTO opuscollege.daypart (lang,code,description) VALUES ('pt','1','Manh&atilde;');
INSERT INTO opuscollege.daypart (lang,code,description) VALUES ('pt','2','Tarde');
INSERT INTO opuscollege.daypart (lang,code,description) VALUES ('pt','3','Noite');


-- thesisStatus
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('thesisstatus', 'Lookup', 'Y');
-- data
DELETE FROM opuscollege.thesisStatus;
INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('en','1','Admission requested');
INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('en','2','Proposal cleared');
INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('en','3','Thesis accepted');

INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('pt','1','Admission requested');
INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('pt','2','Proposal cleared');
INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('pt','3','Thesis accepted');


-- studyPlanStatus
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('studyplanstatus', 'Lookup', 'Y');
-- data
DELETE FROM opuscollege.studyPlanStatus;
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','1','Start initial admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','2','Waiting for payment initial admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','3','Approved initial admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','4','Rejected initial admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','10','Temporarily inactive');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','11','Graduated');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','12','Withdrawn');

INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','1','Waiting for payment');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','2','Waiting for selection');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','3','Approved initial admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','4','Rejected initial admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','10','Temporarily inactive');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','11','Graduated');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','12','Withdrawn');


-- studentStatus
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('studentstatus'   , 'Lookup'  , 'Y');
-- data
DELETE FROM opuscollege.studentStatus;
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('en','1','Active');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('en','5','Deceased');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('en','101','Expelled');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('en','102','Suspended');

INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('pt','1','Activo');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('pt','5','Falecido');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('pt','101','Expulso');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('pt','102','Suspenso');


-- progressStatus
INSERT INTO opuscollege.lookupTable(tableName , lookupType , active) VALUES ('progressstatus', 'Lookup7', 'Y');
-- data
DELETE FROM opuscollege.progressStatus;
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','01','Clear pass','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','27','Proceed & Repeat','Y','Y','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','29','To Part-time','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','19','At Part-time','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','31','To Full-time','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','03','Repeat','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','35','Exclude program','Y','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','34','Exclude school','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','22','Exclude university','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','23','Withdrawn with permission','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','25','Graduate','N','N','Y','N');

INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','01','Passar (todas cadeiras aprovadas)','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','27','Continuar & repetir','Y','Y','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','29','Para tempo parcial','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','19','No tempo parcial','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','31','Para tempo inteiro','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','03','Repetir todas cadeiras','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','35','Excluir do programa','Y','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','34','Excluir da eschola','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','22','Excluir da universidade','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','23','Ausen&ccedil;a autorizada','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','25','Graduar','N','N','Y','N');


-- rfcStatus
INSERT INTO opuscollege.lookupTable(tableName , lookupType , active) VALUES ('rfcstatus', 'Lookup', 'Y');
-- data
DELETE FROM opuscollege.rfcStatus;
INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('en','1','New');
INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('en','2','Resolved');
INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('en','3','Refused');

INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('pt','1','Novo');
INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('pt','2','Resolvido');
INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('pt','3','Recusado');


-- cardinalTimeUnitStatus
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('cardinaltimeunitstatus', 'Lookup', 'Y');
-- data
DELETE FROM opuscollege.cardinalTimeUnitStatus;
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','5','Start continued registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','6','Waiting for approval of registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','7','Request for change');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','8','Rejected registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','9','Approved registration (waiting for payment)');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','10','Actively registered');

INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('pt','5','Start continued registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('pt','6','Waiting for approval of registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('pt','7','Rejected registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('pt','8','Approved registration (waiting for payment)');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('pt','9','Actively registered');

-- endGradeType
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('endgradetype', 'Lookup', 'Y');
-- data
DELETE FROM opuscollege.endGradeType;
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','CA','Continuous assessment');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','SE','Sessional examination');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','SR','Subject result');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','PC','Project course result');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','AR','Attachment result');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','CTU','Cardinal time unit endgrade');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','TR','Thesis result');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','BSC','Bachelor of science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','BA','Bachelor of art');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','MSC','Master of science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','MA','Master of art');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','PHD','Doctor');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','LIC','Licentiate');

INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','CA','Avalia&ccedil;&atilde;o cont&iacute;nua');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','SE','Exame');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','SR','Resultado da cadeira');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','PC','Resultado do projecto');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','AR','Resultado do est&aacute;gio');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','CTU','Nota final do semestre/ano');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','TR','Resultado da tese');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','BSC','Bachelor of science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','BA','Bachelor of art');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','MSC','Master of science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','MA','Master of art');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','PHD','Doctor');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','LIC','Licenciatura');


-- secondarySchoolSubject
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('secondaryschoolsubject', 'Lookup', 'N');
-- no data in Mozambique


-- endgrade
-- EN
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','26', 'LIC', 0.0, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','25', 'LIC', 0.0, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','24', 'BSC', 0.0, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','25', 'BSC', 0.0, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','22', 'MSC', 0.0, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','21', 'MSC', 0.0, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','20', '',20, 0.0, 0.0, '20','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','19', '',19, 0.0, 0.0, '19','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','18', '',18, 0.0, 0.0, '18','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','17', '',17, 0.0, 0.0, '17','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','16', '',16, 0.0, 0.0, '16','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','15', '',15, 0.0, 0.0, '15','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','14', '',14, 0.0, 0.0, '14','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','13', '',13, 0.0, 0.0, '13','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','12', '',12, 0.0, 0.0, '12','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','11', '',11, 0.0, 0.0, '11','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','10', '',10, 0.0, 0.0, '10','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','09', '',9, 0.0, 0.0, '9','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','08', '',8, 0.0, 0.0, '8','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','07', '',7, 0.0, 0.0, '7','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','06', '',6, 0.0, 0.0, '6','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','05', '',5, 0.0, 0.0, '5','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','04', '',4, 0.0, 0.0, '4','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','03', '',3, 0.0, 0.0, '3','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','02', '',2, 0.0, 0.0, '2','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','01', '',1, 0.0, 0.0, '1','N','','N');

-- PT
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','26', 'LIC', 0.0, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','25', 'LIC', 0.0, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','24', 'BSC', 0.0, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','25', 'BSC', 0.0, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','22', 'MSC', 0.0, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','21', 'MSC', 0.0, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','20', '',20, 0.0, 0.0, '20','Y','20','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','19', '',19, 0.0, 0.0, '19','Y','19','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','18', '',18, 0.0, 0.0, '18','Y','18','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','17', '',17, 0.0, 0.0, '17','Y','17','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','16', '',16, 0.0, 0.0, '16','Y','16','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','15', '',15, 0.0, 0.0, '15','Y','15','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','14', '',14, 0.0, 0.0, '14','Y','14','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','13', '',13, 0.0, 0.0, '13','N','13','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','12', '',12, 0.0, 0.0, '12','N','12','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','11', '',11, 0.0, 0.0, '11','N','11','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','10', '',10, 0.0, 0.0, '10','N','10','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','09', '',9, 0.0, 0.0, '9','N','9','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','08', '',8, 0.0, 0.0, '8','N','8','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','07', '',7, 0.0, 0.0, '7','N','7','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','06', '',6, 0.0, 0.0, '6','N','6','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','05', '',5, 0.0, 0.0, '5','N','5','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','04', '',4, 0.0, 0.0, '4','N','4','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','03', '',3, 0.0, 0.0, '3','N','3','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','02', '',2, 0.0, 0.0, '2','N','2','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','01', '',1, 0.0, 0.0, '1','N','1','N');


-- gradetype
DELETE FROM opuscollege.gradeType;

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','SEC','Secondary school','sec.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','BSC','Bachelor of science','B.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','LIC','Licentiate','Lic..');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','MSC','Master of science','M.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','PHD','Doctor','Ph.D.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','BA','Bachelor of art','B.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','MA','Master of art','M.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','DAP','Diploma Ano Propedeutico','Ano-P.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','LICBSC','Licenciate (pre-req: bac.)','Lic-Bac.');

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','SEC','Ensino secund&aacute;rio','Ensino sec.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','BSC','Bacharelato','B.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','LIC','Licentiatura','Lic..');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','MSC','Mestre','M.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','PHD','Ph.D.','Ph.D.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','BA','Bachelor of art','B.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','MA','master of art','M.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','DAP','Diploma Ano Propedeutico','Ano-P.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','LICBSC','Licenciatura (pre-req: bac.)','Lic-Bac.');

UPDATE opuscollege.studyGradeType set gradeTypeCode = 'SEC' where gradeTypeCode = '2';
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'BSC' where gradeTypeCode = '3';
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'LIC' where gradeTypeCode = '4';
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'MSC' where gradeTypeCode = '5';
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'PHD' where gradeTypeCode = '6';
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'DAP' where gradeTypeCode = '7';    -- "diploma ano propedeutico"
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'LICBSC' where gradeTypeCode = '8'; -- "licenciate (pre-req: bac.)"

UPDATE opuscollege.studyPlan set gradeTypeCode = 'SEC' where gradeTypeCode = '2';
UPDATE opuscollege.studyPlan set gradeTypeCode = 'BSC' where gradeTypeCode = '3';
UPDATE opuscollege.studyPlan set gradeTypeCode = 'LIC' where gradeTypeCode = '4';
UPDATE opuscollege.studyPlan set gradeTypeCode = 'MSC' where gradeTypeCode = '5';
UPDATE opuscollege.studyPlan set gradeTypeCode = 'PHD' where gradeTypeCode = '6';
UPDATE opuscollege.studyPlan set gradeTypeCode = 'DAP' where gradeTypeCode = '7';    -- "diploma ano propedeutico"
UPDATE opuscollege.studyPlan set gradeTypeCode = 'LICBSC' where gradeTypeCode = '8'; -- "licenciate (pre-req: bac.)"

UPDATE opuscollege.person set gradeTypeCode = 'SEC' where gradeTypeCode = '2';
UPDATE opuscollege.person set gradeTypeCode = 'BSC' where gradeTypeCode = '3';
UPDATE opuscollege.person set gradeTypeCode = 'LIC' where gradeTypeCode = '4';
UPDATE opuscollege.person set gradeTypeCode = 'MSC' where gradeTypeCode = '5';
UPDATE opuscollege.person set gradeTypeCode = 'PHD' where gradeTypeCode = '6';
UPDATE opuscollege.person set gradeTypeCode = 'DAP' where gradeTypeCode = '7';    -- "diploma ano propedeutico"
UPDATE opuscollege.person set gradeTypeCode = 'LICBSC' where gradeTypeCode = '8'; -- "licenciate (pre-req: bac.)"

-------------------------------------------------------
-- table authorisation
-------------------------------------------------------
DELETE FROM opuscollege.authorisation;

INSERT INTO opuscollege.authorisation(code, description) VALUES('E', 'editable');
INSERT INTO opuscollege.authorisation(code, description) VALUES('V', 'visible');
INSERT INTO opuscollege.authorisation(code, description) VALUES('H', 'hidden');

-------------------------------------------------------
-- DOMAIN TABLE endGradeGeneral (applicable for all endgradetypes)
-------------------------------------------------------
DELETE FROM opuscollege.endGradeGeneral;

-- EN
INSERT INTO opuscollege.endGradeGeneral (lang,code,comment,description,temporaryGrade) VALUES ('en','WP','Withdrawn from course with permission','','N');
INSERT INTO opuscollege.endGradeGeneral (lang,code,comment,description,temporaryGrade) VALUES ('en','DC','Deceased during course','','N');
-- PT
INSERT INTO opuscollege.endGradeGeneral (lang,code,comment,description,temporaryGrade) VALUES ('pt','WP','Withdrawn from course with permission','','N');
INSERT INTO opuscollege.endGradeGeneral (lang,code,comment,description,temporaryGrade) VALUES ('pt','DC','Deceased during course','','N');

-------------------------------------------------------
-- DOMAIN TABLE failGrade
-------------------------------------------------------
DELETE FROM opuscollege.failGrade;
-- EN
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','U','Unsatisfactory, Fail in a Practical Course','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','NE','No Examination Taken','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','WD','Withdrawn from the course with penalty for unsatisfactory academic progress','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','LT','Left the course during the semester without permission','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','DQ','Disqualified in a course by Senate Examination','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','DR','Deregistered for failure to pay fees','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','RS','Re-sit course examination only','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','IN','Incomplete','','Y');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','DF','Deferred Examination','','Y');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','SP','Supplementary Examination','','Y');
-- PT
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','U','Unsatisfactory, Fail in a Practical Course','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','NE','No Examination Taken','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','WD','Withdrawn from the course with penalty for unsatisfactory academic progress','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','LT','Left the course during the semester without permission','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','DQ','Disqualified in a course by Senate Examination','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','DR','Deregistered for failure to pay fees','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','RS','Re-sit course examination only','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','IN','Incomplete','','Y');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','DF','Deferred Examination','','Y');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','SP','Supplementary Examination','','Y');


-- 30_C01002_opuscollege_mozambique_update_lookups.sql
--
-- Introduce a "MZ-" prefix to all province, district and
-- administrative post lookups and the corresponding
-- references in other tables (person, address, etc.)
--
-- This script can be run more than once without wreaking havoc.
-- This script can be run at any time - no dependencies on other scripts.
--

-- 1. Update provinces

-- update person.provinceofbirthcode
update opuscollege.person
set provinceofbirthcode='MZ-' || provinceofbirthcode
from opuscollege.province
where provinceofbirthcode = province.code
and SUBSTR (provinceofbirthcode, 1, 3) <> 'MZ-'
and countrycode = '508';

-- update person.provinceoforigincode
update opuscollege.person
set provinceoforigincode='MZ-' || provinceoforigincode
from opuscollege.province
where provinceoforigincode = province.code
and SUBSTR (provinceoforigincode, 1, 3) <> 'MZ-'
and countrycode = '508';

-- update address.provincecode
update opuscollege.address
set provincecode='MZ-' || provincecode
from opuscollege.province
where provincecode = province.code
and SUBSTR (provincecode, 1, 3) <> 'MZ-'
and province.countrycode = '508';

-- update district.provincecode
update opuscollege.district
set provincecode='MZ-' || provincecode
from opuscollege.province
where provincecode = province.code
and SUBSTR (provincecode, 1, 3) <> 'MZ-'
and province.countrycode = '508';

-- update institution.provincecode
update opuscollege.institution
set provincecode='MZ-' || provincecode
from opuscollege.province
where provincecode = province.code
and SUBSTR (provincecode, 1, 3) <> 'MZ-'
and province.countrycode = '508';

-- update the province.code
update opuscollege.province
set code='MZ-' || code
where SUBSTR (code, 1, 3) <> 'MZ-'
and province.countrycode = '508';


-- 2. Update districts

-- update person.districtofbirthcode
update opuscollege.person
set districtofbirthcode='MZ-' || districtofbirthcode
from opuscollege.district,
opuscollege.province
where districtofbirthcode = district.code
and SUBSTR (districtofbirthcode, 1, 3) <> 'MZ-'
and district.provincecode = province.code and province.lang = 'pt'
and province.countrycode = '508';

-- update person.districtoforigincode
update opuscollege.person
set districtoforigincode='MZ-' || districtoforigincode
where exists (
select * from opuscollege.province
inner join opuscollege.district on district.provincecode = province.code and province.countrycode = '508'
where districtoforigincode = district.code
)
and SUBSTR (districtoforigincode, 1, 3) <> 'MZ-';

-- update address.districtcode
update opuscollege.address
set districtcode='MZ-' || districtcode
where exists (
select * from opuscollege.province
inner join opuscollege.district on district.provincecode = province.code and province.countrycode = '508'
where districtcode = district.code
)
and SUBSTR (districtcode, 1, 3) <> 'MZ-';

-- update administrativepost.districtcode
update opuscollege.administrativepost
set districtcode='MZ-' || districtcode
where exists (
select * from opuscollege.province
inner join opuscollege.district on district.provincecode = province.code and province.countrycode = '508'
where districtcode = district.code
)
and SUBSTR (districtcode, 1, 3) <> 'MZ-';

-- update district.code
update opuscollege.district
set code='MZ-' || code
where SUBSTR (code, 1, 3) <> 'MZ-'
and exists (
select * from opuscollege.province
where district.provincecode = province.code and province.countrycode = '508'
);

-- 3. Update administrative posts

-- update address.administrativepostcode
update opuscollege.address
set administrativepostcode='MZ-' || administrativepostcode
where exists (
select * from opuscollege.province
inner join opuscollege.district on district.provincecode = province.code 
inner join opuscollege.administrativepost on administrativepost.districtcode = district.code
where administrativepostcode = administrativepost.code
and province.countrycode = '508'
)
and SUBSTR (administrativepostcode, 1, 3) <> 'MZ-';

-- update person.administrativepostoforigincode
update opuscollege.person
set administrativepostoforigincode='MZ-' || administrativepostoforigincode
where exists (
select * from opuscollege.province
inner join opuscollege.district on district.provincecode = province.code 
inner join opuscollege.administrativepost on administrativepost.districtcode = district.code
where administrativepostoforigincode = administrativepost.code
and province.countrycode = '508'
)
and SUBSTR (administrativepostoforigincode, 1, 3) <> 'MZ-';

-- update administrativepost.code
update opuscollege.administrativepost
set code='MZ-' || code
where SUBSTR (code, 1, 3) <> 'MZ-'
and exists (
select * from opuscollege.province
inner join opuscollege.district on district.provincecode = province.code 
where district.provincecode = province.code and province.countrycode = '508'
);


-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'mozambique';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('mozambique','A','Y',3.12);


-------------------------------------------------------
-- table district: updated City of Maputo districts
-------------------------------------------------------
DELETE FROM opuscollege.district where code like 'MZ-11-%';

INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('pt','MZ-11-01','Municipal KaMfumo (DU 1)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('pt','MZ-11-02','Municipal de Nhlamankulo (DU 2)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('pt','MZ-11-03','Municipal KaMaxakeni (DU 3)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('pt','MZ-11-04','Municipal Ka Mavota (DU 4)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('pt','MZ-11-05','Municipal KaMubukwana (DU 5)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('pt','MZ-11-06','Municipal KaTembe','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('pt','MZ-11-07','Municipal de Inhaca','MZ-11');

INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','MZ-11-01','Municipal KaMfumo (DU 1)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','MZ-11-02','Municipal de Nhlamankulo (DU 2)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','MZ-11-03','Municipal KaMaxakeni (DU 3)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','MZ-11-04','Municipal Ka Mavota (DU 4)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','MZ-11-05','Municipal KaMubukwana (DU 5)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','MZ-11-06','Municipal KaTembe','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','MZ-11-07','Municipal de Inhaca','MZ-11');


DELETE FROM opuscollege.role;

-- EN
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin', 'Functional administrator and registry', 1);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin-C', 'Academic affairs office', 2);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin-B', 'Branch', 3);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin-D', 'Head of 2nd level unit', 4);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','teacher', 'Lecturer', 5);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','student', 'Student', 6);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','guest', 'System guest', 7);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','finance', 'Financial officer', 8);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','dvc', 'Deputy vice chancellor', 9);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','library', 'Librarian', 10);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','audit', 'Internal audit', 11);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','dos', 'Dean of Students', 12);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','pr', 'PR / communication', 13);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','registry', 'registry office', 14);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin-S', 'Head of 1st level unit - dean etc.', 15);

-- not (yet) implemented
--INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','staff', 'staff member', 16);
--INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','alumnus', 'alumnus', 17);

-- PT
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','admin', 'Functional administrator and registry', 1);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','admin-C', 'Academic affairs office', 2);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','admin-B', 'Branch', 3);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','admin-D', 'Head of 2nd level unit', 4);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','teacher', 'Lecturer', 5);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','student', 'Student', 6);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','guest', 'System guest', 7);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','finance', 'Financial officer', 8);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','dvc', 'Deputy vice chancellor', 9);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','library', 'Librarian', 10);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','audit', 'Internal audit', 11);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','dos', 'Dean of Students', 12);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','pr', 'PR / communication', 13);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','registry', 'Registry office', 14);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','admin-S', 'Head of 1st level unit - dean etc.', 15);

-- not (yet) implemented
--INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','staff', 'staff member', 16);
--INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','alumnus', 'alumnus', 17);

-- switch current roles 'staff' to 'teacher'
UPDATE opuscollege.opususerrole set role = 'teacher' where role = 'staff';
