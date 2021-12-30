/*******************************************************************************
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"), you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College college module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 *   For Java files, see Javadoc @author tags.
 * 
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * 
 * ***** END LICENSE BLOCK *****
 ******************************************************************************/

-- 
-- Author: Markus Pscheidt
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
UPDATE opuscollege.appVersions SET dbVersion = 4.52, writeWhen = now() WHERE lower(module) = 'college';


-------------------------------------------------------
-- Fix sequence ownership
-- See: https://wiki.postgresql.org/wiki/Fixing_Sequences
-------------------------------------------------------

ALTER SEQUENCE opuscollege.institutiontype_id_seq OWNED BY opuscollege.institutiontype.id;
ALTER SEQUENCE opuscollege.academicfieldseq OWNED BY opuscollege.academicfield.id;
ALTER SEQUENCE opuscollege.academicyearseq OWNED BY opuscollege.academicyear.id;
ALTER SEQUENCE opuscollege.addressseq OWNED BY opuscollege.address.id;
ALTER SEQUENCE opuscollege.addresstypeseq OWNED BY opuscollege.addresstype.id;
ALTER SEQUENCE opuscollege.administrativepostseq OWNED BY opuscollege.administrativepost.id;
ALTER SEQUENCE opuscollege.appconfigseq OWNED BY opuscollege.appconfig.id;
ALTER SEQUENCE opuscollege.applicantcategoryseq OWNED BY opuscollege.applicantcategory.id;
ALTER SEQUENCE opuscollege.appointmenttypeseq OWNED BY opuscollege.appointmenttype.id;
ALTER SEQUENCE opuscollege.appversionsseq OWNED BY opuscollege.appversions.id;
ALTER SEQUENCE opuscollege.blocktypeseq OWNED BY opuscollege.blocktype.id;
ALTER SEQUENCE opuscollege.bloodtypeseq OWNED BY opuscollege.bloodtype.id;
ALTER SEQUENCE opuscollege.branchacademicyeartimeunitseq OWNED BY opuscollege.branchacademicyeartimeunit.id;
ALTER SEQUENCE opuscollege.branchseq OWNED BY opuscollege.branch.id;
ALTER SEQUENCE opuscollege.cardinaltimeunitresultseq OWNED BY opuscollege.cardinaltimeunitresult.id;
ALTER SEQUENCE opuscollege.cardinaltimeunitseq OWNED BY opuscollege.cardinaltimeunit.id;
ALTER SEQUENCE opuscollege.cardinaltimeunitstatusseq OWNED BY opuscollege.cardinaltimeunitstatus.id;
ALTER SEQUENCE opuscollege.cardinaltimeunitstudygradetypeseq OWNED BY opuscollege.cardinaltimeunitstudygradetype.id;
ALTER SEQUENCE opuscollege.careerpositionseq OWNED BY opuscollege.careerposition.id;
ALTER SEQUENCE opuscollege.civilstatusseq OWNED BY opuscollege.civilstatus.id;
ALTER SEQUENCE opuscollege.civiltitleseq OWNED BY opuscollege.civiltitle.id;
ALTER SEQUENCE opuscollege.classgroupseq OWNED BY opuscollege.classgroup.id;
ALTER SEQUENCE opuscollege.contractdurationseq OWNED BY opuscollege.contractduration.id;
ALTER SEQUENCE opuscollege.contractseq OWNED BY opuscollege.contract.id;
ALTER SEQUENCE opuscollege.contracttypeseq OWNED BY opuscollege.contracttype.id;
ALTER SEQUENCE opuscollege.countryseq OWNED BY opuscollege.country.id;
ALTER SEQUENCE opuscollege.daypartseq OWNED BY opuscollege.daypart.id;
ALTER SEQUENCE opuscollege.disciplinegroupseq OWNED BY opuscollege.disciplinegroup.id;
ALTER SEQUENCE opuscollege.disciplineseq OWNED BY opuscollege.discipline.id;
ALTER SEQUENCE opuscollege.districtseq OWNED BY opuscollege.district.id;
ALTER SEQUENCE opuscollege.educationareaseq OWNED BY opuscollege.educationarea.id;
ALTER SEQUENCE opuscollege.educationlevelseq OWNED BY opuscollege.educationlevel.id;
ALTER SEQUENCE opuscollege.educationtypeseq OWNED BY opuscollege.educationtype.id;
ALTER SEQUENCE opuscollege.endgradegeneralseq OWNED BY opuscollege.endgradegeneral.id;
ALTER SEQUENCE opuscollege.endgradeseq OWNED BY opuscollege.endgrade.id;
ALTER SEQUENCE opuscollege.endgradetypeseq OWNED BY opuscollege.endgradetype.id;
ALTER SEQUENCE opuscollege.examinationresultcomment_id_seq OWNED BY opuscollege.examinationresultcomment.id;
ALTER SEQUENCE opuscollege.examinationresultseq OWNED BY opuscollege.examinationresult.id;
ALTER SEQUENCE opuscollege.examinationseq OWNED BY opuscollege.examination.id;
ALTER SEQUENCE opuscollege.examinationteacherseq OWNED BY opuscollege.examinationteacher.id;
ALTER SEQUENCE opuscollege.examinationtypeseq OWNED BY opuscollege.examinationtype.id;
ALTER SEQUENCE opuscollege.examseq OWNED BY opuscollege.studyplanresult.id;
ALTER SEQUENCE opuscollege.examtypeseq OWNED BY opuscollege.examtype.id;
ALTER SEQUENCE opuscollege.expellationtypeseq OWNED BY opuscollege.expellationtype.id;
ALTER SEQUENCE opuscollege.failgradeseq OWNED BY opuscollege.failgrade.id;
ALTER SEQUENCE opuscollege.fieldofeducationseq OWNED BY opuscollege.fieldofeducation.id;
ALTER SEQUENCE opuscollege.frequencyseq OWNED BY opuscollege.frequency.id;
ALTER SEQUENCE opuscollege.functionlevelseq OWNED BY opuscollege.functionlevel.id;
ALTER SEQUENCE opuscollege.functionseq OWNED BY opuscollege.function.id;
ALTER SEQUENCE opuscollege.genderseq OWNED BY opuscollege.gender.id;
ALTER SEQUENCE opuscollege.gradedsecondaryschoolsubjectseq OWNED BY opuscollege.gradedsecondaryschoolsubject.id;
ALTER SEQUENCE opuscollege.gradetypeseq OWNED BY opuscollege.gradetype.id;
ALTER SEQUENCE opuscollege.groupeddisciplineseq OWNED BY opuscollege.groupeddiscipline.id;
ALTER SEQUENCE opuscollege.groupedsecondaryschoolsubjectseq OWNED BY opuscollege.groupedsecondaryschoolsubject.id;
ALTER SEQUENCE opuscollege.identificationtypeseq OWNED BY opuscollege.identificationtype.id;
ALTER SEQUENCE opuscollege.institutionseq OWNED BY opuscollege.institution.id;
ALTER SEQUENCE opuscollege.languageseq OWNED BY opuscollege.language.id;
ALTER SEQUENCE opuscollege.levelofeducationseq OWNED BY opuscollege.levelofeducation.id;
ALTER SEQUENCE opuscollege.logmailerrorseq OWNED BY opuscollege.logmailerror.id;
ALTER SEQUENCE opuscollege.logrequesterrorseq OWNED BY opuscollege.logrequesterror.id;
ALTER SEQUENCE opuscollege.lookuptableseq OWNED BY opuscollege.lookuptable.id;
ALTER SEQUENCE opuscollege.mailconfigseq OWNED BY opuscollege.mailconfig.id;
ALTER SEQUENCE opuscollege.masteringlevelseq OWNED BY opuscollege.masteringlevel.id;
ALTER SEQUENCE opuscollege.nationalitygroupseq OWNED BY opuscollege.nationalitygroup.id;
ALTER SEQUENCE opuscollege.nationalityseq OWNED BY opuscollege.nationality.id;
ALTER SEQUENCE opuscollege.obtainedqualificationseq OWNED BY opuscollege.obtainedqualification.id;
ALTER SEQUENCE opuscollege.opusprivilegeseq OWNED BY opuscollege.opusprivilege.id;
ALTER SEQUENCE opuscollege.opusrole_privilegeseq OWNED BY opuscollege.opusrole_privilege.id;
ALTER SEQUENCE opuscollege.opususerroleseq OWNED BY opuscollege.opususerrole.id;
ALTER SEQUENCE opuscollege.opususerseq OWNED BY opuscollege.opususer.id;
ALTER SEQUENCE opuscollege.organizationalunitacademicyearseq OWNED BY opuscollege.admissionregistrationconfig.id;
ALTER SEQUENCE opuscollege.penaltyseq OWNED BY opuscollege.penalty.id;
ALTER SEQUENCE opuscollege.penaltytypeseq OWNED BY opuscollege.penaltytype.id;
ALTER SEQUENCE opuscollege.personseq OWNED BY opuscollege.person.id;
ALTER SEQUENCE opuscollege.professionseq OWNED BY opuscollege.profession.id;
ALTER SEQUENCE opuscollege.progressstatusseq OWNED BY opuscollege.progressstatus.id;
ALTER SEQUENCE opuscollege.provinceseq OWNED BY opuscollege.province.id;
ALTER SEQUENCE opuscollege.refereeseq OWNED BY opuscollege.referee.id;
ALTER SEQUENCE opuscollege.relationtypeseq OWNED BY opuscollege.relationtype.id;
ALTER SEQUENCE opuscollege.reportpropertyseq OWNED BY opuscollege.reportproperty.id;
ALTER SEQUENCE opuscollege.requestforchangeseq OWNED BY opuscollege.requestforchange.id;
ALTER SEQUENCE opuscollege.rfcstatusseq OWNED BY opuscollege.rfcstatus.id;
ALTER SEQUENCE opuscollege.rigiditytypeseq OWNED BY opuscollege.rigiditytype.id;
ALTER SEQUENCE opuscollege.roleseq OWNED BY opuscollege.role.id;
ALTER SEQUENCE opuscollege.secondaryschoolsubjectgroupseq OWNED BY opuscollege.secondaryschoolsubjectgroup.id;
ALTER SEQUENCE opuscollege.secondaryschoolsubjectseq OWNED BY opuscollege.secondaryschoolsubject.id;
ALTER SEQUENCE opuscollege.staffmemberseq OWNED BY opuscollege.staffmember.staffmemberid;
ALTER SEQUENCE opuscollege.stafftypeseq OWNED BY opuscollege.stafftype.id;
ALTER SEQUENCE opuscollege.statusseq OWNED BY opuscollege.status.id;
ALTER SEQUENCE opuscollege.studentabsenceseq OWNED BY opuscollege.studentabsence.id;
ALTER SEQUENCE opuscollege.studentactivityseq OWNED BY opuscollege.studentactivity.id;
ALTER SEQUENCE opuscollege.studentcareerseq OWNED BY opuscollege.studentcareer.id;
ALTER SEQUENCE opuscollege.studentclassgroupseq OWNED BY opuscollege.studentclassgroup.id;
ALTER SEQUENCE opuscollege.studentcounselingseq OWNED BY opuscollege.studentcounseling.id;
ALTER SEQUENCE opuscollege.studentexpulsionseq OWNED BY opuscollege.studentexpulsion.id;
ALTER SEQUENCE opuscollege.studentplacementseq OWNED BY opuscollege.studentplacement.id;
ALTER SEQUENCE opuscollege.studentseq OWNED BY opuscollege.student.studentid;
ALTER SEQUENCE opuscollege.studentstatusseq OWNED BY opuscollege.studentstatus.id;
ALTER SEQUENCE opuscollege.studentstudentstatusseq OWNED BY opuscollege.studentstudentstatus.id;
ALTER SEQUENCE opuscollege.studyformseq OWNED BY opuscollege.studyform.id;
ALTER SEQUENCE opuscollege.studygradetypeseq OWNED BY opuscollege.studygradetype.id;
ALTER SEQUENCE opuscollege.studyintensityseq OWNED BY opuscollege.studyintensity.id;
ALTER SEQUENCE opuscollege.studyplancardinaltimeunitseq OWNED BY opuscollege.studyplancardinaltimeunit.id;
ALTER SEQUENCE opuscollege.studyplandetailseq OWNED BY opuscollege.studyplandetail.id;
ALTER SEQUENCE opuscollege.studyplanseq OWNED BY opuscollege.studyplan.id;
ALTER SEQUENCE opuscollege.studyplanstatusseq OWNED BY opuscollege.studyplanstatus.id;
ALTER SEQUENCE opuscollege.studyseq OWNED BY opuscollege.study.id;
ALTER SEQUENCE opuscollege.studytimeseq OWNED BY opuscollege.studytime.id;
ALTER SEQUENCE opuscollege.studytypeseq OWNED BY opuscollege.studytype.id;
ALTER SEQUENCE opuscollege.subjectblockseq OWNED BY opuscollege.subjectblock.id;
ALTER SEQUENCE opuscollege.subjectblockstudygradetypeseq OWNED BY opuscollege.subjectblockstudygradetype.id;
ALTER SEQUENCE opuscollege.subjectclassgroupseq OWNED BY opuscollege.subjectclassgroup.id;
ALTER SEQUENCE opuscollege.subjectimportanceseq OWNED BY opuscollege.importancetype.id;
ALTER SEQUENCE opuscollege.subjectresultseq OWNED BY opuscollege.subjectresult.id;
ALTER SEQUENCE opuscollege.subjectseq OWNED BY opuscollege.subject.id;
ALTER SEQUENCE opuscollege.subjectstudygradetypeseq OWNED BY opuscollege.subjectstudygradetype.id;
ALTER SEQUENCE opuscollege.subjectstudytypeseq OWNED BY opuscollege.subjectstudytype.id;
ALTER SEQUENCE opuscollege.subjectsubjectblockseq OWNED BY opuscollege.subjectsubjectblock.id;
ALTER SEQUENCE opuscollege.subjectteacherseq OWNED BY opuscollege.subjectteacher.id;
ALTER SEQUENCE opuscollege.tabledependencyseq OWNED BY opuscollege.tabledependency.id;
ALTER SEQUENCE opuscollege.targetgroupseq OWNED BY opuscollege.targetgroup.id;
ALTER SEQUENCE opuscollege.testresultcomment_id_seq OWNED BY opuscollege.testresultcomment.id;
ALTER SEQUENCE opuscollege.testresultseq OWNED BY opuscollege.testresult.id;
ALTER SEQUENCE opuscollege.testseq OWNED BY opuscollege.test.id;
ALTER SEQUENCE opuscollege.testteacherseq OWNED BY opuscollege.testteacher.id;
ALTER SEQUENCE opuscollege.thesisresultseq OWNED BY opuscollege.thesisresult.id;
ALTER SEQUENCE opuscollege.thesisseq OWNED BY opuscollege.thesis.id;
ALTER SEQUENCE opuscollege.thesisstatusseq OWNED BY opuscollege.thesisstatus.id;
ALTER SEQUENCE opuscollege.thesissupervisorseq OWNED BY opuscollege.thesissupervisor.id;
ALTER SEQUENCE opuscollege.thesisthesisstatusseq OWNED BY opuscollege.thesisthesisstatus.id;
ALTER SEQUENCE opuscollege.unitareaseq OWNED BY opuscollege.unitarea.id;
ALTER SEQUENCE opuscollege.unittypeseq OWNED BY opuscollege.unittype.id;

-- Set all sequence values to the correct values
SELECT SETVAL('opuscollege.academicfieldseq', COALESCE(MAX(id), 1) ) FROM opuscollege.academicfield;
SELECT SETVAL('opuscollege.academicyearseq', COALESCE(MAX(id), 1) ) FROM opuscollege.academicyear;
SELECT SETVAL('opuscollege.addressseq', COALESCE(MAX(id), 1) ) FROM opuscollege.address;
SELECT SETVAL('opuscollege.addresstypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.addresstype;
SELECT SETVAL('opuscollege.administrativepostseq', COALESCE(MAX(id), 1) ) FROM opuscollege.administrativepost;
SELECT SETVAL('opuscollege.appconfigseq', COALESCE(MAX(id), 1) ) FROM opuscollege.appconfig;
SELECT SETVAL('opuscollege.applicantcategoryseq', COALESCE(MAX(id), 1) ) FROM opuscollege.applicantcategory;
SELECT SETVAL('opuscollege.appointmenttypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.appointmenttype;
SELECT SETVAL('opuscollege.appversionsseq', COALESCE(MAX(id), 1) ) FROM opuscollege.appversions;
SELECT SETVAL('opuscollege.blocktypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.blocktype;
SELECT SETVAL('opuscollege.bloodtypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.bloodtype;
SELECT SETVAL('opuscollege.branchacademicyeartimeunitseq', COALESCE(MAX(id), 1) ) FROM opuscollege.branchacademicyeartimeunit;
SELECT SETVAL('opuscollege.branchseq', COALESCE(MAX(id), 1) ) FROM opuscollege.branch;
SELECT SETVAL('opuscollege.cardinaltimeunitresultseq', COALESCE(MAX(id), 1) ) FROM opuscollege.cardinaltimeunitresult;
SELECT SETVAL('opuscollege.cardinaltimeunitseq', COALESCE(MAX(id), 1) ) FROM opuscollege.cardinaltimeunit;
SELECT SETVAL('opuscollege.cardinaltimeunitstatusseq', COALESCE(MAX(id), 1) ) FROM opuscollege.cardinaltimeunitstatus;
SELECT SETVAL('opuscollege.cardinaltimeunitstudygradetypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.cardinaltimeunitstudygradetype;
SELECT SETVAL('opuscollege.careerpositionseq', COALESCE(MAX(id), 1) ) FROM opuscollege.careerposition;
SELECT SETVAL('opuscollege.civilstatusseq', COALESCE(MAX(id), 1) ) FROM opuscollege.civilstatus;
SELECT SETVAL('opuscollege.civiltitleseq', COALESCE(MAX(id), 1) ) FROM opuscollege.civiltitle;
SELECT SETVAL('opuscollege.classgroupseq', COALESCE(MAX(id), 1) ) FROM opuscollege.classgroup;
SELECT SETVAL('opuscollege.contractdurationseq', COALESCE(MAX(id), 1) ) FROM opuscollege.contractduration;
SELECT SETVAL('opuscollege.contractseq', COALESCE(MAX(id), 1) ) FROM opuscollege.contract;
SELECT SETVAL('opuscollege.contracttypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.contracttype;
SELECT SETVAL('opuscollege.countryseq', COALESCE(MAX(id), 1) ) FROM opuscollege.country;
SELECT SETVAL('opuscollege.daypartseq', COALESCE(MAX(id), 1) ) FROM opuscollege.daypart;
SELECT SETVAL('opuscollege.disciplinegroupseq', COALESCE(MAX(id), 1) ) FROM opuscollege.disciplinegroup;
SELECT SETVAL('opuscollege.disciplineseq', COALESCE(MAX(id), 1) ) FROM opuscollege.discipline;
SELECT SETVAL('opuscollege.districtseq', COALESCE(MAX(id), 1) ) FROM opuscollege.district;
SELECT SETVAL('opuscollege.educationareaseq', COALESCE(MAX(id), 1) ) FROM opuscollege.educationarea;
SELECT SETVAL('opuscollege.educationlevelseq', COALESCE(MAX(id), 1) ) FROM opuscollege.educationlevel;
SELECT SETVAL('opuscollege.educationtypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.educationtype;
SELECT SETVAL('opuscollege.endgradegeneralseq', COALESCE(MAX(id), 1) ) FROM opuscollege.endgradegeneral;
SELECT SETVAL('opuscollege.endgradeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.endgrade;
SELECT SETVAL('opuscollege.endgradetypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.endgradetype;
SELECT SETVAL('opuscollege.examinationresultseq', COALESCE(MAX(id), 1) ) FROM opuscollege.examinationresult;
SELECT SETVAL('opuscollege.examinationresultcomment_id_seq', COALESCE(MAX(id), 1) ) FROM opuscollege.examinationresultcomment;
SELECT SETVAL('opuscollege.examinationseq', COALESCE(MAX(id), 1) ) FROM opuscollege.examination;
SELECT SETVAL('opuscollege.examinationteacherseq', COALESCE(MAX(id), 1) ) FROM opuscollege.examinationteacher;
SELECT SETVAL('opuscollege.examinationtypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.examinationtype;
SELECT SETVAL('opuscollege.examseq', COALESCE(MAX(id), 1) ) FROM opuscollege.studyplanresult;
SELECT SETVAL('opuscollege.examtypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.examtype;
SELECT SETVAL('opuscollege.expellationtypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.expellationtype;
SELECT SETVAL('opuscollege.failgradeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.failgrade;
SELECT SETVAL('opuscollege.fieldofeducationseq', COALESCE(MAX(id), 1) ) FROM opuscollege.fieldofeducation;
SELECT SETVAL('opuscollege.frequencyseq', COALESCE(MAX(id), 1) ) FROM opuscollege.frequency;
SELECT SETVAL('opuscollege.functionlevelseq', COALESCE(MAX(id), 1) ) FROM opuscollege.functionlevel;
SELECT SETVAL('opuscollege.functionseq', COALESCE(MAX(id), 1) ) FROM opuscollege.function;
SELECT SETVAL('opuscollege.genderseq', COALESCE(MAX(id), 1) ) FROM opuscollege.gender;
SELECT SETVAL('opuscollege.gradedsecondaryschoolsubjectseq', COALESCE(MAX(id), 1) ) FROM opuscollege.gradedsecondaryschoolsubject;
SELECT SETVAL('opuscollege.gradetypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.gradetype;
SELECT SETVAL('opuscollege.groupeddisciplineseq', COALESCE(MAX(id), 1) ) FROM opuscollege.groupeddiscipline;
SELECT SETVAL('opuscollege.groupedsecondaryschoolsubjectseq', COALESCE(MAX(id), 1) ) FROM opuscollege.groupedsecondaryschoolsubject;
SELECT SETVAL('opuscollege.identificationtypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.identificationtype;
SELECT SETVAL('opuscollege.institutionseq', COALESCE(MAX(id), 1) ) FROM opuscollege.institution;
SELECT SETVAL('opuscollege.institutiontype_id_seq', COALESCE(MAX(id), 1) ) FROM opuscollege.institutiontype;
SELECT SETVAL('opuscollege.languageseq', COALESCE(MAX(id), 1) ) FROM opuscollege.language;
SELECT SETVAL('opuscollege.levelofeducationseq', COALESCE(MAX(id), 1) ) FROM opuscollege.levelofeducation;
SELECT SETVAL('opuscollege.logmailerrorseq', COALESCE(MAX(id), 1) ) FROM opuscollege.logmailerror;
SELECT SETVAL('opuscollege.logrequesterrorseq', COALESCE(MAX(id), 1) ) FROM opuscollege.logrequesterror;
SELECT SETVAL('opuscollege.lookuptableseq', COALESCE(MAX(id), 1) ) FROM opuscollege.lookuptable;
SELECT SETVAL('opuscollege.mailconfigseq', COALESCE(MAX(id), 1) ) FROM opuscollege.mailconfig;
SELECT SETVAL('opuscollege.masteringlevelseq', COALESCE(MAX(id), 1) ) FROM opuscollege.masteringlevel;
SELECT SETVAL('opuscollege.nationalitygroupseq', COALESCE(MAX(id), 1) ) FROM opuscollege.nationalitygroup;
SELECT SETVAL('opuscollege.nationalityseq', COALESCE(MAX(id), 1) ) FROM opuscollege.nationality;
SELECT SETVAL('opuscollege.obtainedqualificationseq', COALESCE(MAX(id), 1) ) FROM opuscollege.obtainedqualification;
SELECT SETVAL('opuscollege.opusprivilegeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.opusprivilege;
SELECT SETVAL('opuscollege.opusrole_privilegeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.opusrole_privilege;
SELECT SETVAL('opuscollege.opususerroleseq', COALESCE(MAX(id), 1) ) FROM opuscollege.opususerrole;
SELECT SETVAL('opuscollege.opususerseq', COALESCE(MAX(id), 1) ) FROM opuscollege.opususer;
SELECT SETVAL('opuscollege.organizationalunitacademicyearseq', COALESCE(MAX(id), 1) ) FROM opuscollege.admissionregistrationconfig;
SELECT SETVAL('opuscollege.organizationalunitseq', COALESCE(MAX(id), 1) ) FROM opuscollege.organizationalunit;
SELECT SETVAL('opuscollege.penaltyseq', COALESCE(MAX(id), 1) ) FROM opuscollege.penalty;
SELECT SETVAL('opuscollege.penaltytypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.penaltytype;
SELECT SETVAL('opuscollege.personseq', COALESCE(MAX(id), 1) ) FROM opuscollege.person;
SELECT SETVAL('opuscollege.professionseq', COALESCE(MAX(id), 1) ) FROM opuscollege.profession;
SELECT SETVAL('opuscollege.progressstatusseq', COALESCE(MAX(id), 1) ) FROM opuscollege.progressstatus;
SELECT SETVAL('opuscollege.provinceseq', COALESCE(MAX(id), 1) ) FROM opuscollege.province;
SELECT SETVAL('opuscollege.refereeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.referee;
SELECT SETVAL('opuscollege.relationtypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.relationtype;
SELECT SETVAL('opuscollege.reportpropertyseq', COALESCE(MAX(id), 1) ) FROM opuscollege.reportproperty;
SELECT SETVAL('opuscollege.requestforchangeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.requestforchange;
SELECT SETVAL('opuscollege.rfcstatusseq', COALESCE(MAX(id), 1) ) FROM opuscollege.rfcstatus;
SELECT SETVAL('opuscollege.rigiditytypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.rigiditytype;
SELECT SETVAL('opuscollege.roleseq', COALESCE(MAX(id), 1) ) FROM opuscollege.role;
SELECT SETVAL('opuscollege.secondaryschoolsubjectgroupseq', COALESCE(MAX(id), 1) ) FROM opuscollege.secondaryschoolsubjectgroup;
SELECT SETVAL('opuscollege.secondaryschoolsubjectseq', COALESCE(MAX(id), 1) ) FROM opuscollege.secondaryschoolsubject;
SELECT SETVAL('opuscollege.staffmemberseq', COALESCE(MAX(staffmemberid), 1) ) FROM opuscollege.staffmember;
SELECT SETVAL('opuscollege.stafftypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.stafftype;
SELECT SETVAL('opuscollege.statusseq', COALESCE(MAX(id), 1) ) FROM opuscollege.status;
SELECT SETVAL('opuscollege.studentabsenceseq', COALESCE(MAX(id), 1) ) FROM opuscollege.studentabsence;
SELECT SETVAL('opuscollege.studentactivityseq', COALESCE(MAX(id), 1) ) FROM opuscollege.studentactivity;
SELECT SETVAL('opuscollege.studentcareerseq', COALESCE(MAX(id), 1) ) FROM opuscollege.studentcareer;
SELECT SETVAL('opuscollege.studentclassgroupseq', COALESCE(MAX(id), 1) ) FROM opuscollege.studentclassgroup;
SELECT SETVAL('opuscollege.studentcounselingseq', COALESCE(MAX(id), 1) ) FROM opuscollege.studentcounseling;
SELECT SETVAL('opuscollege.studentexpulsionseq', COALESCE(MAX(id), 1) ) FROM opuscollege.studentexpulsion;
SELECT SETVAL('opuscollege.studentplacementseq', COALESCE(MAX(id), 1) ) FROM opuscollege.studentplacement;
SELECT SETVAL('opuscollege.studentseq', COALESCE(MAX(studentid), 1) ) FROM opuscollege.student;
SELECT SETVAL('opuscollege.studentstatusseq', COALESCE(MAX(id), 1) ) FROM opuscollege.studentstatus;
SELECT SETVAL('opuscollege.studentstudentstatusseq', COALESCE(MAX(id), 1) ) FROM opuscollege.studentstudentstatus;
SELECT SETVAL('opuscollege.studyformseq', COALESCE(MAX(id), 1) ) FROM opuscollege.studyform;
SELECT SETVAL('opuscollege.studygradetypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.studygradetype;
SELECT SETVAL('opuscollege.studyintensityseq', COALESCE(MAX(id), 1) ) FROM opuscollege.studyintensity;
SELECT SETVAL('opuscollege.studyplancardinaltimeunitseq', COALESCE(MAX(id), 1) ) FROM opuscollege.studyplancardinaltimeunit;
SELECT SETVAL('opuscollege.studyplandetailseq', COALESCE(MAX(id), 1) ) FROM opuscollege.studyplandetail;
SELECT SETVAL('opuscollege.studyplanseq', COALESCE(MAX(id), 1) ) FROM opuscollege.studyplan;
SELECT SETVAL('opuscollege.studyplanstatusseq', COALESCE(MAX(id), 1) ) FROM opuscollege.studyplanstatus;
SELECT SETVAL('opuscollege.studyseq', COALESCE(MAX(id), 1) ) FROM opuscollege.study;
SELECT SETVAL('opuscollege.studytimeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.studytime;
SELECT SETVAL('opuscollege.studytypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.studytype;
SELECT SETVAL('opuscollege.subjectblockseq', COALESCE(MAX(id), 1) ) FROM opuscollege.subjectblock;
SELECT SETVAL('opuscollege.subjectblockstudygradetypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.subjectblockstudygradetype;
SELECT SETVAL('opuscollege.subjectclassgroupseq', COALESCE(MAX(id), 1) ) FROM opuscollege.subjectclassgroup;
SELECT SETVAL('opuscollege.subjectimportanceseq', COALESCE(MAX(id), 1) ) FROM opuscollege.importancetype;
SELECT SETVAL('opuscollege.subjectresultseq', COALESCE(MAX(id), 1) ) FROM opuscollege.subjectresult;
SELECT SETVAL('opuscollege.subjectseq', COALESCE(MAX(id), 1) ) FROM opuscollege.subject;
SELECT SETVAL('opuscollege.subjectstudygradetypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.subjectstudygradetype;
SELECT SETVAL('opuscollege.subjectstudytypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.subjectstudytype;
SELECT SETVAL('opuscollege.subjectsubjectblockseq', COALESCE(MAX(id), 1) ) FROM opuscollege.subjectsubjectblock;
SELECT SETVAL('opuscollege.subjectteacherseq', COALESCE(MAX(id), 1) ) FROM opuscollege.subjectteacher;
SELECT SETVAL('opuscollege.tabledependencyseq', COALESCE(MAX(id), 1) ) FROM opuscollege.tabledependency;
SELECT SETVAL('opuscollege.targetgroupseq', COALESCE(MAX(id), 1) ) FROM opuscollege.targetgroup;
SELECT SETVAL('opuscollege.testresultcomment_id_seq', COALESCE(MAX(id), 1) ) FROM opuscollege.testresultcomment;
SELECT SETVAL('opuscollege.testresultseq', COALESCE(MAX(id), 1) ) FROM opuscollege.testresult;
SELECT SETVAL('opuscollege.testseq', COALESCE(MAX(id), 1) ) FROM opuscollege.test;
SELECT SETVAL('opuscollege.testteacherseq', COALESCE(MAX(id), 1) ) FROM opuscollege.testteacher;
SELECT SETVAL('opuscollege.thesisresultseq', COALESCE(MAX(id), 1) ) FROM opuscollege.thesisresult;
SELECT SETVAL('opuscollege.thesisseq', COALESCE(MAX(id), 1) ) FROM opuscollege.thesis;
SELECT SETVAL('opuscollege.thesisstatusseq', COALESCE(MAX(id), 1) ) FROM opuscollege.thesisstatus;
SELECT SETVAL('opuscollege.thesissupervisorseq', COALESCE(MAX(id), 1) ) FROM opuscollege.thesissupervisor;
SELECT SETVAL('opuscollege.thesisthesisstatusseq', COALESCE(MAX(id), 1) ) FROM opuscollege.thesisthesisstatus;
SELECT SETVAL('opuscollege.unitareaseq', COALESCE(MAX(id), 1) ) FROM opuscollege.unitarea;
SELECT SETVAL('opuscollege.unittypeseq', COALESCE(MAX(id), 1) ) FROM opuscollege.unittype;
