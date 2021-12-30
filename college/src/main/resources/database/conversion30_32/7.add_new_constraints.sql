

ALTER TABLE appconfig
	ADD CONSTRAINT appconfig_pkey PRIMARY KEY (appconfigattributename);

ALTER TABLE authorisation
	ADD CONSTRAINT authorisation_pkey PRIMARY KEY (code);

ALTER TABLE cardinaltimeunit
	ADD CONSTRAINT cardinaltimeunit_pkey PRIMARY KEY (id, lang);

ALTER TABLE cardinaltimeunitresult
	ADD CONSTRAINT cardinaltimeunitresult_pkey PRIMARY KEY (id);

ALTER TABLE cardinaltimeunitstatus
	ADD CONSTRAINT cardinaltimeunitstatus_pkey PRIMARY KEY (id, lang);

ALTER TABLE cardinaltimeunitstudygradetype
	ADD CONSTRAINT cardinaltimeunitstudygradetype_pkey PRIMARY KEY (id);

ALTER TABLE daypart
	ADD CONSTRAINT daypart_pkey PRIMARY KEY (id, lang);

ALTER TABLE endgrade
	ADD CONSTRAINT endgrade_pkey PRIMARY KEY (id);

ALTER TABLE endgradegeneral
	ADD CONSTRAINT endgradegeneral_pkey PRIMARY KEY (id);

ALTER TABLE endgradetype
	ADD CONSTRAINT endgradetype_pkey PRIMARY KEY (id, lang);

ALTER TABLE failgrade
	ADD CONSTRAINT failgrade_pkey PRIMARY KEY (id);

ALTER TABLE gradedsecondaryschoolsubject
	ADD CONSTRAINT gradedsecondaryschoolsubject_pkey PRIMARY KEY (id);

ALTER TABLE groupedsecondaryschoolsubject
	ADD CONSTRAINT groupedsecondaryschoolsubject_pkey PRIMARY KEY (id);

ALTER TABLE opusprivilege
	ADD CONSTRAINT opusprivilege_pkey PRIMARY KEY (id, lang);

ALTER TABLE opusrole_privilege
	ADD CONSTRAINT opusrole_privilege_pkey PRIMARY KEY (id);

ALTER TABLE organizationalunitacademicyear
	ADD CONSTRAINT organizationalunitacademicyear_pkey PRIMARY KEY (organizationalunitid, academicyearid);

ALTER TABLE progressstatus
	ADD CONSTRAINT progressstatus_pkey PRIMARY KEY (id, lang);

ALTER TABLE requestadmissionperiod
	ADD CONSTRAINT requestadmissionperiod_pkey PRIMARY KEY (startdate, enddate, academicyearid);

ALTER TABLE requestforchange
	ADD CONSTRAINT requestforchange_pkey PRIMARY KEY (id);

ALTER TABLE rfcstatus
	ADD CONSTRAINT rfcstatus_pkey PRIMARY KEY (id, lang);

ALTER TABLE secondaryschoolsubject
	ADD CONSTRAINT secondaryschoolsubject_pkey PRIMARY KEY (id, lang);

ALTER TABLE secondaryschoolsubjectgroup
	ADD CONSTRAINT secondaryschoolsubjectgroup_pkey PRIMARY KEY (id);

ALTER TABLE studentexpulsion
	ADD CONSTRAINT studentexpulsion_pkey PRIMARY KEY (id);

ALTER TABLE studentstatus
	ADD CONSTRAINT studentstatus_pkey PRIMARY KEY (id, lang);

ALTER TABLE studentstudentstatus
	ADD CONSTRAINT studentstudentstatus_pkey PRIMARY KEY (id);

ALTER TABLE studygradetypeprerequisite
	ADD CONSTRAINT studygradetypeprerequisite_pkey PRIMARY KEY (studygradetypeid, requiredstudygradetypeid);

ALTER TABLE studyplancardinaltimeunit
	ADD CONSTRAINT studyplancardinaltimeunit_pkey PRIMARY KEY (id);

ALTER TABLE studyplanresult
	ADD CONSTRAINT exam_pkey PRIMARY KEY (id);

ALTER TABLE studyplanstatus
	ADD CONSTRAINT studyplanstatus_pkey PRIMARY KEY (id, lang);

ALTER TABLE subjectblockprerequisite
	ADD CONSTRAINT subjectblockprerequisite_pkey PRIMARY KEY (subjectblockid, subjectblockstudygradetypeid);

ALTER TABLE subjectprerequisite
	ADD CONSTRAINT subjectprerequisite_pkey PRIMARY KEY (subjectid, subjectstudygradetypeid);

ALTER TABLE thesis
	ADD CONSTRAINT thesis_pkey PRIMARY KEY (id);

ALTER TABLE thesisresult
	ADD CONSTRAINT thesisresult_pkey PRIMARY KEY (id);

ALTER TABLE thesisstatus
	ADD CONSTRAINT thesisstatus_pkey PRIMARY KEY (id, lang);

ALTER TABLE cardinaltimeunit
	ADD CONSTRAINT cardinaltimeunit_id_key UNIQUE (id);

ALTER TABLE cardinaltimeunitresult
	ADD CONSTRAINT cardinaltimeunitresult_studyplanid_key UNIQUE (studyplanid, studyplancardinaltimeunitid);

ALTER TABLE cardinaltimeunitstatus
	ADD CONSTRAINT cardinaltimeunitstatus_id_key UNIQUE (id);

ALTER TABLE cardinaltimeunitstudygradetype
	ADD CONSTRAINT cardinaltimeunitstudygradetype_studygradetypeid_fkey FOREIGN KEY (studygradetypeid) REFERENCES studygradetype(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE daypart
	ADD CONSTRAINT daypart_id_key UNIQUE (id);

ALTER TABLE endgradetype
	ADD CONSTRAINT endgradetype_id_key UNIQUE (id);

ALTER TABLE examinationresulthistory
	ADD CONSTRAINT examinationresulthistory_examinationid_fkey FOREIGN KEY (examinationid) REFERENCES examination(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE examinationresulthistory
	ADD CONSTRAINT examinationresulthistory_staffmemberid_fkey FOREIGN KEY (staffmemberid) REFERENCES staffmember(staffmemberid) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE examinationresulthistory
	ADD CONSTRAINT examinationresulthistory_studyplandetailid_fkey FOREIGN KEY (studyplandetailid) REFERENCES studyplandetail(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE examinationresulthistory
	ADD CONSTRAINT examinationresulthistory_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE gradedsecondaryschoolsubject
	ADD CONSTRAINT gradedsecondaryschoolsubject_secondaryschoolsubjectid_key UNIQUE (secondaryschoolsubjectid, studyplanid);

ALTER TABLE groupedsecondaryschoolsubject
	ADD CONSTRAINT groupedsecondaryschoolsubject_secondaryschoolsubjectid_key UNIQUE (secondaryschoolsubjectid, secondaryschoolsubjectgroupid);

ALTER TABLE opusprivilege
	ADD CONSTRAINT opusprivilege_id_key UNIQUE (id);

ALTER TABLE opusprivilege
	ADD CONSTRAINT opusprivilege_lang_key UNIQUE (lang, code);

ALTER TABLE opususerrole
	ADD CONSTRAINT user_organizationalunit_unique_constraint UNIQUE (username, organizationalunitid);

ALTER TABLE organizationalunitacademicyear
	ADD CONSTRAINT organizationalunitacademicyear_academicyearid_fkey FOREIGN KEY (academicyearid) REFERENCES academicyear(id);

ALTER TABLE organizationalunitacademicyear
	ADD CONSTRAINT organizationalunitacademicyear_organizationalunitid_fkey FOREIGN KEY (organizationalunitid) REFERENCES organizationalunit(id);

ALTER TABLE progressstatus
	ADD CONSTRAINT progressstatus_id_key UNIQUE (id);

ALTER TABLE rfcstatus
	ADD CONSTRAINT rfcstatus_id_key UNIQUE (id);

ALTER TABLE secondaryschoolsubject
	ADD CONSTRAINT secondaryschoolsubject_id_key UNIQUE (id);

ALTER TABLE secondaryschoolsubjectgroup
	ADD CONSTRAINT secondaryschoolsubjectgroup_groupnumber_key UNIQUE (groupnumber, studygradetypeid);

ALTER TABLE studentexpulsion
	ADD CONSTRAINT studentexpulsion_startdate_key UNIQUE (startdate, enddate);

ALTER TABLE studentexpulsion
	ADD CONSTRAINT studentexpulsion_studentid_fkey FOREIGN KEY (studentid) REFERENCES student(studentid) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE studentstatus
	ADD CONSTRAINT studentstatus_id_key UNIQUE (id);

ALTER TABLE studentstudentstatus
	ADD CONSTRAINT studentstudentstatus_studentid_fkey FOREIGN KEY (studentid) REFERENCES student(studentid) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE studygradetype
	ADD CONSTRAINT study_gradetype_studyform_studytime_academicyear_key UNIQUE (studyid, gradetypecode, studyformcode, studytimecode, currentacademicyearid);

ALTER TABLE studyplancardinaltimeunit
	ADD CONSTRAINT studyplancardinaltimeunit_studyplanid_fkey FOREIGN KEY (studyplanid) REFERENCES studyplan(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE studyplanresult
	ADD CONSTRAINT exam_studyplanid_key UNIQUE (studyplanid);

ALTER TABLE studyplanresult
	ADD CONSTRAINT exam_studyplanid_fkey FOREIGN KEY (studyplanid) REFERENCES studyplan(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE studyplanstatus
	ADD CONSTRAINT studyplanstatus_id_key UNIQUE (id);

ALTER TABLE subject
	ADD CONSTRAINT subject_subjectcode_subjectdescription_currentacademicyearid_ke UNIQUE (subjectcode, subjectdescription, currentacademicyearid);

ALTER TABLE subjectblock
	ADD CONSTRAINT subjectblock_subjectblockcode_currentacademicyearid_key UNIQUE (subjectblockcode, currentacademicyearid);

ALTER TABLE subjectblockstudygradetype
	ADD CONSTRAINT subjectblockstudygradetype_subjectblockid_key UNIQUE (subjectblockid, studygradetypeid, cardinaltimeunitnumber, rigiditytypecode);

ALTER TABLE thesis
	ADD CONSTRAINT thesis_thesiscode_key UNIQUE (thesiscode);

ALTER TABLE thesisresult
	ADD CONSTRAINT thesisresult_studyplanid_key UNIQUE (studyplanid);

ALTER TABLE thesisstatus
	ADD CONSTRAINT thesisstatus_id_key UNIQUE (id);
