/*
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
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
 */

package org.uci.opus.college.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.Errors;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Address;
import org.uci.opus.college.domain.AppConfigAttribute;
import org.uci.opus.college.domain.BranchAcademicYearTimeUnit;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup7;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Penalty;
import org.uci.opus.college.domain.Person;
import org.uci.opus.college.domain.Role;
import org.uci.opus.college.domain.SecondarySchoolSubject;
import org.uci.opus.college.domain.SecondarySchoolSubjectGroup;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudentAbsence;
import org.uci.opus.college.domain.StudentExpulsion;
import org.uci.opus.college.domain.StudentList;
import org.uci.opus.college.domain.StudentStudentStatus;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.SubjectBlockPrerequisite;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectPrerequisite;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.Thesis;
import org.uci.opus.college.domain.ThesisStatus;
import org.uci.opus.college.domain.ThesisSupervisor;
import org.uci.opus.college.domain.extpoint.StudentBalanceInformation;
import org.uci.opus.college.domain.result.SubjectResult;
import org.uci.opus.college.domain.util.FailedSubjectInfo;
import org.uci.opus.college.domain.util.StudyPlanCardinalTimeUnitAnalyzer;
import org.uci.opus.college.persistence.AddressMapper;
import org.uci.opus.college.persistence.FailedSubjectInfoMapper;
import org.uci.opus.college.persistence.LookupMapper;
import org.uci.opus.college.persistence.OrganizationalUnitMapper;
import org.uci.opus.college.persistence.PenaltyMapper;
import org.uci.opus.college.persistence.StudentAbsenceMapper;
import org.uci.opus.college.persistence.StudentClassgroupMapper;
import org.uci.opus.college.persistence.StudentExpulsionMapper;
import org.uci.opus.college.persistence.StudentMapper;
import org.uci.opus.college.persistence.StudentStudentStatusMapper;
import org.uci.opus.college.persistence.StudyplanCardinaltimeunitMapper;
import org.uci.opus.college.persistence.StudyplanDetailMapper;
import org.uci.opus.college.persistence.StudyplanMapper;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.persistence.SubjectMapper;
import org.uci.opus.college.persistence.ThesisMapper;
import org.uci.opus.college.persistence.ThesisStatusMapper;
import org.uci.opus.college.persistence.ThesisSupervisorMapper;
import org.uci.opus.college.service.extpoint.CollegeServiceExtensions;
import org.uci.opus.college.service.extpoint.IStudyPlanDetailListener;
import org.uci.opus.college.service.extpoint.StudentBalanceEvaluation;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.AcademicYearUtil;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.ListUtil;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.lookup.LookupUtil;

/**
 * @author move Service class that contains OpusUser-related management methods.
 */
public class StudentManager implements StudentManagerInterface {

    private static Logger log = LoggerFactory.getLogger(StudentManager.class);

    @Autowired
    private StudentMapper studentMapper;
    @Autowired
    private PersonManagerInterface personManager;
    @Autowired
    private OpusUserManagerInterface opusUserManager;
    @Autowired
    private LookupMapper lookupDao;
    @Autowired
    private AppConfigManagerInterface appConfigManager;
    @Autowired
    private BranchManagerInterface branchManager;
    @Autowired
    private StudyManagerInterface studyManager;
    @Autowired
    private AcademicYearManagerInterface academicYearManager;
    @Autowired
    private LookupCacher lookupCacher;
    @Autowired
    private SubjectManagerInterface subjectManager;
    @Autowired
    private ResultManagerInterface resultManager;
    @Autowired
    private OpusMethods opusMethods;
    @Autowired
    private CollegeServiceExtensions collegeServiceExtensions;
    @Autowired
    private OpusInit opusInit;
    @Autowired
    private FailedSubjectInfoMapper failedSubjectInfoMapper;
    @Autowired
    private PenaltyMapper penaltyMapper;
    @Autowired
    private NoteManager noteManager;
    @Autowired
    private SqlSession sqlSession;
    @Autowired
    private AddressMapper addressMapper;
    @Autowired
    private OrganizationalUnitMapper organizationalUnitMapper;
    @Autowired
    private StudentAbsenceMapper studentAbsenceMapper;
    @Autowired
    private StudentClassgroupMapper studentClassgroupMapper;
    @Autowired
    private StudentExpulsionMapper studentExpulsionMapper;
    @Autowired
    private StudentStudentStatusMapper studentStudentStatusMapper;
    @Autowired
    private StudyplanCardinaltimeunitMapper studyplanCardinaltimeunitMapper;
    @Autowired
    private StudyplanDetailMapper studyplanDetailMapper;
    @Autowired
    private StudyplanMapper studyplanMapper;
    @Autowired
    private SubjectMapper subjectMapper;
    @Autowired
    private SubjectBlockMapper subjectBlockMapper;
    @Autowired
    private ThesisMapper thesisMapper;
    @Autowired
    private ThesisStatusMapper thesisStatusMapper;
    @Autowired
    private ThesisSupervisorMapper thesisSupervisorMapper;

    @Override
    @Transactional
    public StudentList findAllStudents(String preferredLanguage) {

        return new StudentList(studentMapper.findAllStudents(preferredLanguage));
    }

    @Override
    @Transactional
    public int findStudentCount(Map<String, Object> map) {
        return studentMapper.findStudentCount(map);
    }

    @Override
    @Transactional
    public StudentList findStudents(Map<String, Object> map) {

        StudentList allStudents = new StudentList(studentMapper.findStudents(map));

        // MP 2016-05-06: Don't see any sense to load secondary subject school data here, it slows down the loading of students
//        for (Student student : allStudents) {
//            List<StudyPlan> newStudyPlans = new ArrayList<>();
//            for (StudyPlan studyPlan : student.getStudyPlans()) {
//                if (log.isDebugEnabled()) {
//                    log.debug("StudentManager.findStudents: studentid:" + student.getStudentId() + ", studyPlanId = " + studyPlan.getId());
//                }
//                // add all secondarySchoolSubjectGroups for this studyplan:
//                map.put("studyPlanId", studyPlan.getId());
//
//                List<SecondarySchoolSubjectGroup> secondarySchoolSubjectGroups = studyManager.findSecondarySchoolSubjectGroupsForStudyPlan(map);
//                studyPlan.setSecondarySchoolSubjectGroups(secondarySchoolSubjectGroups);
//
//                // add all gradedsecondarySchoolSubjects to this studyplan:
//                List<SecondarySchoolSubject> gradedsecondarySchoolSubjects = studyManager.findGradedSecondarySchoolSubjectsForStudyPlan(studyPlan.getId());
//                studyPlan.setGradedSecondarySchoolSubjects(gradedsecondarySchoolSubjects);
//
//                if (log.isDebugEnabled()) {
//                    log.debug("StudentManager.findStudents: studyPlanId = " + studyPlan.getId() + ", secondarySchoolSubjectGroups.size: " + secondarySchoolSubjectGroups.size()
//                            + ", gradedsecondarySchoolSubjects.size: " + gradedsecondarySchoolSubjects.size());
//                }
//                newStudyPlans.add(studyPlan);
//            }
//            student.setStudyPlans(newStudyPlans);
//        }
        return allStudents;
    }

    @Override
    @Transactional
    public StudentList filterStudents(StudentList allStudents, String prevStudyPlanStatusCode, String nextStudyPlanStatusCode, String prevCardinalTimeUnitStatusCode,
            String nextCardinalTimeUnitStatusCode, HttpServletRequest request) {

        String msgType = "";
        OpusUser opusUser = null;
        String mailEnabled = "N";
        String[] recipients = new String[1];

        if (allStudents != null) {

            List<? extends AppConfigAttribute> appConfig = opusMethods.getAppConfig();
            for (int i = 0; i < appConfig.size(); i++) {
                if ("mailEnabled".equals(appConfig.get(i).getAppConfigAttributeName())) {
                    mailEnabled = appConfig.get(i).getAppConfigAttributeValue();
                    break;
                }
            }

            for (Student student : allStudents) {
                if (log.isDebugEnabled()) {
                    log.debug("StudentManager.filterStudents : student.getProceedToAdmissionProgressStatus() = " + student.getProceedToAdmissionProgressStatus()
                            + ", student.getProceedToAdmissionFinalizeStatus() = " + student.getProceedToAdmissionFinalizeStatus()
                            + ",student.getProceedToContinuedRegistrationProgressStatus() = " + student.getProceedToContinuedRegistrationProgressStatus()
                            + ",student.getProceedToContinuedRegistrationFinalizeStatus() = " + student.getProceedToContinuedRegistrationFinalizeStatus());
                }
                opusUser = opusUserManager.findOpusUserByPersonId(student.getPersonId());
                if (log.isDebugEnabled()) {
                    log.debug("StudentManager.filterStudents : student.opusUser: " + opusUser.getId());
                }

                if (student.getProceedToAdmissionProgressStatus() || student.getProceedToAdmissionFinalizeStatus()) {
                    if (log.isDebugEnabled()) {
                        log.debug("StudentManager.filterStudents : student.getProceedToAdmissionProgressStatus(): " + student.getProceedToAdmissionProgressStatus()
                                + ", student.getProceedToAdmissionFinalizeStatus(): " + student.getProceedToAdmissionFinalizeStatus() + "- prevStudyPlanStatusCode = "
                                + prevStudyPlanStatusCode + ", nextStudyPlanStatusCode = " + nextStudyPlanStatusCode);
                    }
                    if (prevStudyPlanStatusCode != null && !"".equals(prevStudyPlanStatusCode) && nextStudyPlanStatusCode != null && !"".equals(nextStudyPlanStatusCode)) {

                        if ("Y".equals(mailEnabled)) {
                            if (nextStudyPlanStatusCode.equals(OpusConstants.STUDYPLAN_STATUS_WAITING_FOR_PAYMENT)) {
                                msgType = "waitingforpayment_admission";
                            }
                            if (nextStudyPlanStatusCode.equals(OpusConstants.STUDYPLAN_STATUS_WAITING_FOR_SELECTION)) {
                                msgType = "waitingforselection_admission";
                            }
                            if (nextStudyPlanStatusCode.equals(OpusConstants.STUDYPLAN_STATUS_REJECTED_ADMISSION)) {
                                msgType = "rejected_admission";
                            }
                            if (nextStudyPlanStatusCode.equals(OpusConstants.STUDYPLAN_STATUS_APPROVED_ADMISSION)) {
                                msgType = "approved_admission";
                            }
                        }

                        List<StudyPlan> studyPlans = (List<StudyPlan>) student.getStudyPlans();
                        for (StudyPlan studyPlan : studyPlans) {
                            if (prevStudyPlanStatusCode.equals(studyPlan.getStudyPlanStatusCode())) {
                                studyPlan.setStudyPlanStatusCode(nextStudyPlanStatusCode);
                                String writeWho = opusMethods.getWriteWho(request);
                                this.updateStudyPlanStatusCode(studyPlan, writeWho);
                                if ("Y".equals(mailEnabled)) {
                                    // send mail to student - rejected or
                                    // approved:
                                    if (!"".equals(msgType)) {
                                        if (student.getAddresses() != null && student.getAddresses().size() != 0) {
                                            if (student.getAddresses().get(0) != null) {
                                                Address address = student.getAddresses().get(0);
                                                if (!StringUtil.isNullOrEmpty(address.getEmailAddress())) {
                                                    recipients[0] = address.getEmailAddress();
                                                } else {
                                                    recipients[0] = student.getSurnameFull();
                                                }

                                            } else {
                                                recipients[0] = student.getSurnameFull();
                                            }
                                        } else {
                                            recipients[0] = student.getSurnameFull();
                                        }
                                        opusMethods.sendMail(recipients, msgType, opusUser.getLang(), null, null);
                                    }
                                }
                            }
                        }
                    }
                }

                if (student.getProceedToContinuedRegistrationProgressStatus() || student.getProceedToContinuedRegistrationFinalizeStatus()) {
                    if (log.isDebugEnabled()) {
                        log.debug("StudentManager.filterStudents : student.getProceedToContinuedRegistrationProgressStatus(): "
                                + student.getProceedToContinuedRegistrationProgressStatus() + ", student.getProceedToContinuedRegistrationFinalizeStatus(): "
                                + student.getProceedToContinuedRegistrationFinalizeStatus() + "- prevCardinalTimeUnitStatusCode = " + prevCardinalTimeUnitStatusCode
                                + ", nextCardinalTimeUnitStatusCode = " + nextCardinalTimeUnitStatusCode);
                    }
                    if (prevCardinalTimeUnitStatusCode != null && !"".equals(prevCardinalTimeUnitStatusCode) && nextCardinalTimeUnitStatusCode != null
                            && !"".equals(nextCardinalTimeUnitStatusCode)) {
                        List<StudyPlan> studyPlans = (List<StudyPlan>) student.getStudyPlans();

                        if ("Y".equals(mailEnabled)) {
                            if (nextCardinalTimeUnitStatusCode.equals(OpusConstants.CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT)) {
                                msgType = "waitingforpayment_registration";
                            }
                            if (nextCardinalTimeUnitStatusCode.equals(OpusConstants.CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME)) {
                                msgType = "customize_programme";
                            }
                            if (nextCardinalTimeUnitStatusCode.equals(OpusConstants.CARDINALTIMEUNIT_STATUS_WAITING_FOR_APPROVAL_OF_REGISTRATION)) {
                                msgType = "waitingforapproval_registration";
                            }
                            if (nextCardinalTimeUnitStatusCode.equals(OpusConstants.CARDINALTIMEUNIT_STATUS_REJECTED_REGISTRATION)) {
                                msgType = "rejected_registration";

                            }
                            if (nextCardinalTimeUnitStatusCode.equals(OpusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED)) {
                                msgType = "actively_registered";
                            }
                            if (nextCardinalTimeUnitStatusCode.equals(OpusConstants.CARDINALTIMEUNIT_STATUS_REQUEST_FOR_CHANGE)) {
                                msgType = "requestforchange_registration";
                            }
                        }

                        for (StudyPlan studyPlan : studyPlans) {
                            List<StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits = (List<StudyPlanCardinalTimeUnit>) studyPlan.getStudyPlanCardinalTimeUnits();
                            for (StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit : studyPlanCardinalTimeUnits) {
                                if (prevCardinalTimeUnitStatusCode.equals(studyPlanCardinalTimeUnit.getCardinalTimeUnitStatusCode())) {
                                    studyPlanCardinalTimeUnit.setCardinalTimeUnitStatusCode(nextCardinalTimeUnitStatusCode);
                                    this.updateCardinalTimeUnitStatusCode(studyPlanCardinalTimeUnit);
                                    if ("Y".equals(mailEnabled)) {
                                        // send mail to student: rejected,
                                        // registered or customize programme
                                        if (!"".equals(msgType)) {
                                            if (student.getAddresses() != null && student.getAddresses().size() != 0) {
                                                if (student.getAddresses().get(0) != null) {
                                                    Address address = student.getAddresses().get(0);
                                                    if (!StringUtil.isNullOrEmpty(address.getEmailAddress())) {
                                                        recipients[0] = address.getEmailAddress();
                                                    } else {
                                                        recipients[0] = student.getSurnameFull();
                                                    }

                                                } else {
                                                    recipients[0] = student.getSurnameFull();
                                                }
                                            } else {
                                                recipients[0] = student.getSurnameFull();
                                            }
                                            opusMethods.sendMail(recipients, msgType, opusUser.getLang(), null, null);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        return allStudents;
    }

    @Override
    @Transactional
    public StudentList findStudentsWithCTUAndSubjectResults(Map<String, Object> map) {

        return new StudentList(studentMapper.findStudents_WithCTUAndSubjectResults(map));
    }

    @Override
    @Transactional
    public Student findStudent(String preferredLanguage, int studentId) {

        return studentMapper.findStudent(preferredLanguage, studentId);
    }

    @Override
    @Transactional
    public Student findPlainStudent(int studentId) {

        Student student = studentMapper.findPlainStudent(studentId);
        return student;
    }

    @Override
    @Transactional
    public Student findPlainStudentByStudyPlanCtuId(int studyPlanCtuId) {
        Student student = studentMapper.findPlainStudentByStudyPlanCtuId(studyPlanCtuId);
        return student;
    }

    @Override
    @Transactional
    public Student findStudentByPersonId(int personId) {

        Student student = null;

        student = studentMapper.findStudentByPersonId(personId);

        return student;
    }

    @Override
    @Transactional
    public Student findStudentByCode(String studentCode) {

        Student student = null;

        student = studentMapper.findStudentByCode(studentCode);

        return student;
    }

    @Override
    @Transactional
    public Student findStudentByParams(Map<String, Object> map) {

        Student student = null;

        student = studentMapper.findStudentByParams(map);

        return student;
    }

    @Override
    @Transactional
    public Student findStudentByParams2(Map<String, Object> map) {
        Student student = null;

        student = studentMapper.findStudentByParams2(map);

        return student;
    }

    @Override
    @Transactional
    public List<Student> findStudentsByStudyGradeAcademicYear(Map<String, Object> map) {
        List<Student> students = studentMapper.findStudentsByStudyGradeAcademicYear(map);
        return students;
    }

    @Override
    @Transactional
    public OrganizationalUnit findOrganizationalUnitForStudent(int personId) {

        return organizationalUnitMapper.findOrganizationalUnitForStudent(personId);
    }

    // @Override @Transactional
    // public List<StudyPlan> findStudyPlansByParams(Map<String, Object> map) {
    //
    // List<StudyPlan> studyPlans = null;
    //
    // studyPlans = studentDao.findStudyPlansByParams(map);
    //
    // return studyPlans;
    // }
    //
    // @Override @Transactional
    // public List<? extends StudyPlan> findStudyPlansByParams2(Map<String, Object> map) {
    // return studentDao.findStudyPlansByParams2(map);
    // }

    @Override
    @Transactional
    public List<StudyPlan> findStudyPlansForStudent(int studentId) {

        return studyplanMapper.findStudyPlansForStudent(studentId);
    }

    @Override
    @Transactional
    public List<StudyPlan> findStudyPlansForStudentByParams(Map<String, Object> map) {

        return studyplanMapper.findStudyPlansForStudentByParams(map);
    }

    @Override
    @Transactional
    public StudyPlan findStudyPlan(int studyPlanId, int highestGradeOfSecondarySchoolSubjects, int lowestGradeOfSecondarySchoolSubjects, String preferredLanguage) {


        StudyPlan studyPlan = studyplanMapper.findStudyPlan(studyPlanId);

        Map<String, Object> map = new HashMap<>();
        map.put("studyPlanId", studyPlanId);
        map.put("preferredLanguage", preferredLanguage);
        map.put("defaultMaximumGradePoint", highestGradeOfSecondarySchoolSubjects);
        map.put("defaultMinimumGradePoint", lowestGradeOfSecondarySchoolSubjects);

        // add all secondarySchoolSubjectGroups for this studyplan:
        List<SecondarySchoolSubjectGroup> secondarySchoolSubjectGroups = studyManager.findSecondarySchoolSubjectGroupsForStudyPlan(map);
        List<SecondarySchoolSubject> groupedSecondarySchoolSubjects = new ArrayList<>();
        studyPlan.setSecondarySchoolSubjectGroups(secondarySchoolSubjectGroups);
        for (int i = 0; i < secondarySchoolSubjectGroups.size(); i++) {
            groupedSecondarySchoolSubjects.addAll(secondarySchoolSubjectGroups.get(i).getSecondarySchoolSubjects());
        }
        if (log.isDebugEnabled()) {
            log.debug("findStudyPlan.groupedSecondarySchoolSubjects.size =" + groupedSecondarySchoolSubjects.size());
        }

        // add all ungrouped secondarySchoolSubjects for this studyplan:
        List<SecondarySchoolSubject> allSecondarySchoolSubjects = studyManager.findUngroupedSecondarySchoolSubjectsForStudyPlan(map);
        SecondarySchoolSubject ungroupedSubject = null;
        // extract grouped secondaryschoolsubjects from full list above to get
        // ungrouped list:
        List<SecondarySchoolSubject> ungroupedSecondarySchoolSubjects = new ArrayList<>();
        for (int i = 0; i < allSecondarySchoolSubjects.size(); i++) {
            ungroupedSubject = allSecondarySchoolSubjects.get(i);
            for (int j = 0; j < groupedSecondarySchoolSubjects.size(); j++) {
                if (allSecondarySchoolSubjects.get(i).getId() != groupedSecondarySchoolSubjects.get(j).getId()) {
                    // continue
                } else {
                    ungroupedSubject = null;
                    break;
                }
            }
            if (ungroupedSubject != null) {
                ungroupedSecondarySchoolSubjects.add(ungroupedSubject);
            }
        }
        if (log.isDebugEnabled()) {
            log.debug("findStudyPlan.ungroupedSecondarySchoolSubjects.size =" + ungroupedSecondarySchoolSubjects.size());
        }
        studyPlan.setUngroupedSecondarySchoolSubjects(ungroupedSecondarySchoolSubjects);

        return studyPlan;
    }

    @Override
    @Transactional
    public StudyPlan findStudyPlan(int studyPlanId) {
        return studyplanMapper.findStudyPlan(studyPlanId);
    }

    @Override
    @Transactional
    public StudyPlan findStudyPlanByParams(Map<String, Object> map) {

        return studyplanMapper.findStudyPlanByParams(map);
    }

    @Override
    @Transactional
    public StudyPlan findStudyPlanByParams2(Map<String, Object> map) {
        return studyplanMapper.findStudyPlanByParams2(map);
    }

    @Override
    @Transactional
    public void addStudyPlanToStudent(StudyPlan studyPlan, String writeWho) {

        studyplanMapper.addStudyPlanToStudent(studyPlan);

        collegeServiceExtensions.studyPlanAdded(studyPlan, writeWho);
    }

    @Override
    @Transactional
    public void updateStudyPlan(StudyPlan studyPlan, String writeWho) {

        collegeServiceExtensions.beforeStudyPlanUpdate(studyPlan, writeWho);
        studyplanMapper.updateStudyPlan(studyPlan);
    }

    @Override
    @Transactional
    public void updateStudyPlanStatusCode(StudyPlan studyPlan, String writeWho) {

        collegeServiceExtensions.beforeStudyPlanStatusUpdate(studyPlan, writeWho);
        studyplanMapper.updateStudyPlanStatusCode(studyPlan);
    }

    @Override
    @Transactional
    public void updateCardinalTimeUnitStatusCode(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit) {
        studyplanCardinaltimeunitMapper.updateCardinalTimeUnitStatusCode(studyPlanCardinalTimeUnit);
    }

    @Override
    @Transactional
    public void deleteStudyPlan(int studyPlanId, String writeWho) {

        collegeServiceExtensions.beforeStudyPlanDelete(studyPlanId, writeWho);

        studyplanDetailMapper.deleteStudyPlanDetailsForStudyPlan(studyPlanId);

        studyplanMapper.deleteStudyPlan(studyPlanId);
    }

    @Override
    @Transactional
    public List<StudyPlanDetail> findStudyPlanDetailsForStudent(Map<String, Object> map) {

        return studyplanDetailMapper.findStudyPlanDetailsForStudent(map);
    }

    @Override
    @Transactional
    public List<StudyPlanDetail> findStudyPlanDetailsForStudyPlanCardinalTimeUnit(int id) {

        return studyplanDetailMapper.findStudyPlanDetailsForStudyPlanCardinalTimeUnit(id);
    }

    @Override
    @Transactional
    public List<StudyPlanDetail> findStudyPlanDetailsForStudyPlanCardinalTimeUnitByParams(Map<String, Object> map) {

        return studyplanDetailMapper.findStudyPlanDetailsForStudyPlanCardinalTimeUnitByParams(map);
    }

    @Override
    @Transactional
    public List<StudyPlanDetail> findStudyPlanDetailsForStudyPlan(int studyPlanId) {

        return studyplanDetailMapper.findStudyPlanDetailsForStudyPlan(studyPlanId);
    }

    @Override
    @Transactional
    public List<StudyPlanDetail> findStudyPlanDetailsForSubject(int subjectId) {

        return studyplanDetailMapper.findStudyPlanDetailsForSubject(subjectId);
    }

    @Override
    @Transactional
    public List<StudyPlanDetail> findStudyPlanDetailsByParams(Map<String, Object> map) {

        return studyplanDetailMapper.findStudyPlanDetailsByParams(map);
    }

    @Override
    @Transactional
    public List<? extends StudyPlanDetail> findStudyPlanDetailsForSubjectStudyGradeType(int subjectStudyGradeTypeId) {

        return studyplanDetailMapper.findStudyPlanDetailsForSubjectStudyGradeType(subjectStudyGradeTypeId);
    }

    @Override
    @Transactional
    public List<? extends StudyPlanDetail> findStudyPlanDetailsForSubjectBlockStudyGradeType(int subjectBlockStudyGradeTypeId) {

        return studyplanDetailMapper.findStudyPlanDetailsForSubjectBlockStudyGradeType(subjectBlockStudyGradeTypeId);
    }

    @Override
    @Transactional
    public StudyPlanDetail findStudyPlanDetail(int studyPlanDetailId) {

        return studyplanDetailMapper.findStudyPlanDetail(studyPlanDetailId);
    }

    @Override
    @Transactional
    public StudyPlanDetail findStudyPlanDetailByParams(Map<String, Object> map) {

        return studyplanDetailMapper.findStudyPlanDetailByParams(map);
    }

    @Override
    @Transactional
    public void addStudyPlanDetail(StudyPlanDetail studyPlanDetail, HttpServletRequest request) {

        studyplanDetailMapper.addStudyPlanDetail(studyPlanDetail);

        Collection<IStudyPlanDetailListener> addStudyPlanDetailListeners = collegeServiceExtensions.getStudyPlanDetailListeners();
        if (addStudyPlanDetailListeners != null) {
            for (IStudyPlanDetailListener extension : addStudyPlanDetailListeners) {
                extension.studyPlanDetailAdded(studyPlanDetail, request);
            }
        }
    }

    @Transactional
    public void addStudyPlanDetails(List<StudyPlanDetail> studyPlanDetails, HttpServletRequest request) {

        for (StudyPlanDetail studyPlanDetail : studyPlanDetails) {
            this.addStudyPlanDetail(studyPlanDetail, request);
        }
    }

    @Override
    @Transactional
    public void updateStudyPlanDetail(StudyPlanDetail studyPlanDetail) {

        studyplanDetailMapper.updateStudyPlanDetail(studyPlanDetail);
    }

    @Override
    @Transactional
    public void deleteStudyPlanDetail(int studyPlanDetailId, HttpServletRequest request) {

        collegeServiceExtensions.beforeStudyPlanDetailDelete(studyPlanDetailId, request);

        studyplanDetailMapper.deleteStudyPlanDetail(studyPlanDetailId);

    }

    @Override
    @Transactional
    public StudentAbsence findStudentAbsence(int studentAbsenceId) {

        return studentAbsenceMapper.findStudentAbsence(studentAbsenceId);
    }

    @Override
    @Transactional
    public void addStudentAbsence(StudentAbsence studentAbsence) {

        studentAbsenceMapper.addStudentAbsence(studentAbsence);
        updateStudentAbsenceHistory(studentAbsence, "I");
    }

    @Override
    @Transactional
    public void updateStudentAbsence(StudentAbsence studentAbsence) {

        studentAbsenceMapper.updateStudentAbsence(studentAbsence);
        updateStudentAbsenceHistory(studentAbsence, "U");
    }

    @Override
    @Transactional
    public void deleteStudentAbsence(int studentAbsenceId, String writeWho) {

        StudentAbsence studentAbsence = findStudentAbsence(studentAbsenceId);
        studentAbsence.setWriteWho(writeWho);

        studentAbsenceMapper.deleteStudentAbsence(studentAbsenceId);

        updateStudentAbsenceHistory(studentAbsence, "D");
    }

    private void updateStudentAbsenceHistory(StudentAbsence studentAbsence, String operation) {

        Map<String, Object> map = new HashMap<>();

        map.put("operation", operation);
        map.put("StudentAbsence", studentAbsence);

        // getSqlMapClientTemplate().insert("Student.addStudentAbsenceHistory", map);
        sqlSession.insert(StudentAbsenceMapper.class.getName() + ".addStudentAbsenceHistory", map);
    }

    private void udateStudentExpulsionHistory(StudentExpulsion studentExpulsion, String operation) {

        Map<String, Object> map = new HashMap<>();

        map.put("operation", operation);
        map.put("StudentExpulsion", studentExpulsion);

        // getSqlMapClientTemplate().insert("Student.addStudentExpulsionHistory", map);
        sqlSession.insert(StudentExpulsionMapper.class.getName() + ".addStudentExpulsionHistory", map);
    }

    @Override
    public StudentExpulsion findStudentExpulsion(int studentExpulsionId, String preferredLanguage) {

        // StudentExpulsion studentExpulsion = null;
        // Map<String, Object> map = new HashMap<>();
        // map.put("studentExpulsionId", studentExpulsionId);
        // map.put("preferredLanguage", preferredLanguage);
        // studentExpulsion = studentDao.findStudentExpulsion(map);
        //
        // return studentExpulsion;
        return studentExpulsionMapper.findStudentExpulsion(studentExpulsionId, preferredLanguage);
    }

    @Override
    public List<StudentExpulsion> findStudentExpulsions(int studentId, String preferredLanguage) {

        // Map<String, Object> map = new HashMap<>();
        // map.put("studentId", studentId);
        // map.put("preferredLanguage", preferredLanguage);
        //
        // return studentDao.findStudentExpulsions(map);
        return studentExpulsionMapper.findStudentExpulsions(studentId, preferredLanguage);
    }

    @Override
    @Transactional
    public void addStudentExpulsion(StudentExpulsion studentExpulsion) {
        studentExpulsionMapper.addStudentExpulsion(studentExpulsion);
        udateStudentExpulsionHistory(studentExpulsion, "I");
    }

    @Override
    @Transactional
    public void updateStudentExpulsion(StudentExpulsion studentExpulsion) {
        studentExpulsionMapper.updateStudentExpulsion(studentExpulsion);
        udateStudentExpulsionHistory(studentExpulsion, "U");
    }

    @Override
    @Transactional
    public void deleteStudentExpulsion(int studentExpulsionId, String preferredLanguage, String writeWho) {

        StudentExpulsion studentExpulsion = findStudentExpulsion(studentExpulsionId, preferredLanguage);
        studentExpulsion.setWriteWho(writeWho);

        studentExpulsionMapper.deleteStudentExpulsion(studentExpulsionId);

        udateStudentExpulsionHistory(studentExpulsion, "D");
    }

    @Override
    @Transactional
    public void addStudent(Student student, OpusUserRole studentOpusUserRole, OpusUser studentOpusUser) {

        // insert person:
        personManager.addPerson(student);
        // retrieve new personId:
        Person person = personManager.findPersonByCode(student.getPersonCode());
        int personId = person.getId();
        // create new opusUser + opusUserRole:
        // language is always filled
        studentOpusUser.setPersonId(personId);
        if ("".equals(studentOpusUserRole.getUserName()) || studentOpusUserRole.getUserName() == null) {
            String userName = StringUtil.createSimpleUniqueCode("U", StringUtil.fullTrim(student.getSurnameFull()));
            studentOpusUserRole.setUserName(userName);
        }
        studentOpusUser.setUserName(studentOpusUserRole.getUserName());
        if ("".equals(studentOpusUserRole.getRole()) || studentOpusUserRole.getRole() == null) {
            Role role = opusUserManager.findRole(studentOpusUser.getLang2LetterCode(), "student");
            studentOpusUserRole.setRole(role.getRole());
        }
        opusUserManager.addOpusUser(studentOpusUser);

        // update staffmember before inserting:
        student.setPersonId(person.getId());
        studentMapper.addStudent(student);
        studentMapper.addStudentHistory(student, "I");

        // first find the correct organizationalUnitId
        int orgId = (this.findOrganizationalUnitForStudent(personId)).getId();
        studentOpusUserRole.setOrganizationalUnitId(orgId);
        opusUserManager.addOpusUserRole(studentOpusUserRole);

        // add studentStudentStatuses
        if (student.getStudentStudentStatuses() != null) {
            for (StudentStudentStatus ssStatus : student.getStudentStudentStatuses()) {
                ssStatus.setStudentId(student.getStudentId());
                studentStudentStatusMapper.addStudentStudentStatus(ssStatus);
            }
        }
    }

    @Override
    @Transactional
    public void updateStudent(Student student, OpusUserRole opusUserRole, OpusUser opusUser, String oldPw) {

        /* first update staffmember part in case staffMemberId changed */
        this.updateStudent(student);
        personManager.updatePerson(student);

        // update opusUserRole if changed:
        if (opusUserRole != null) {
            if ("".equals(opusUserRole.getUserName()) || opusUserRole.getUserName() == null) {
                opusUserRole.setUserName(StringUtil.createSimpleUniqueCode("U", StringUtil.fullTrim(student.getSurnameFull())));
            }

            opusUser.setUserName(opusUserRole.getUserName());
            if ("".equals(opusUserRole.getRole()) || opusUserRole.getRole() == null) {
                Role role = opusUserManager.findRole(opusUser.getLang2LetterCode(), "guest");
                opusUserRole.setRole(role.getRole());
            }
            opusUserManager.updateOpusUser(opusUser, oldPw);
            opusUserManager.updateOpusUserRole(opusUserRole);
        } else {
            if (opusUser != null) {
                opusUserManager.updateOpusUser(opusUser, oldPw);
            }
        }

    }
    
    @Override
    @Transactional
    public void updateStudent(Student student) {

        studentMapper.updateStudent(student);
        studentMapper.addStudentHistory(student, "U");
    }

    @Override
    @Transactional
    public void deleteStudent(String preferredLanguage, int studentId, String writeWho) {

        Student student = studentMapper.findStudent(preferredLanguage, studentId);

        if (student.getAddresses().size() != 0) {
            addressMapper.deleteStudentInAddress(student.getPersonId());
        }
        if (student.getStudyPlans().size() != 0) {
            // delete details per studyplan:
            for (int i = 0; i < student.getStudyPlans().size(); i++) {
                studyplanDetailMapper.deleteStudyPlanDetailsForStudyPlan(student.getStudyPlans().get(i).getId());
            }
            // delete studyplan itself:
            studentMapper.deleteStudentInStudyPlan(studentId);
        }

        student.setWriteWho(writeWho);
        studentMapper.deleteStudent(studentId);
        studentMapper.addStudentHistory(student, "D");

        noteManager.deleteNotes(studentId);
        studentAbsenceMapper.deleteStudentAbsences(studentId);
        studentExpulsionMapper.deleteStudentExpulsions(studentId);
        penaltyMapper.deletePenalties(studentId);
        opusUserManager.deleteOpusUserRole(student.getPersonId());
        opusUserManager.deleteOpusUser(student.getPersonId());
        personManager.deletePerson(student.getPersonId(), writeWho);
    }

    @Override
    @Transactional
    public void deleteLookupFromStudent(int studentId, String lookupCode, String lookupType) {
        lookupDao.deleteLookupFromEntity("student", studentId, lookupCode, lookupType);
    }

    @Override
    @Transactional
    public List<SubjectBlock> findSubjectBlocksForStudyPlan(int studyPlanId) {
        return subjectBlockMapper.findSubjectBlocksForStudyPlan(studyPlanId);
    }

    @Override
    @Transactional
    public List<SubjectBlock> findSubjectBlocksForStudyPlanCardinalTimeUnit(int studyPlanCardinalTimeUnitId) {
        return subjectBlockMapper.findSubjectBlocksForStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId);
    }

    @Override
    @Transactional
    public List<Subject> findSubjectsForStudyPlanCardinalTimeUnit(Map<String, Object> map) {
        return subjectMapper.findSubjectsForStudyPlanCardinalTimeUnit(map);
    }

    @Override
    @Transactional
    public List<Subject> findSubjectsForStudyPlanCardinalTimeUnit(int subjectsForStudyPlanCardinalTimeUnitId) {
        Map<String, Object> map = new HashMap<>();
        map.put("studyPlanCardinalTimeUnitId", subjectsForStudyPlanCardinalTimeUnitId);
        return findSubjectsForStudyPlanCardinalTimeUnit(map);
    }

    @Override
    @Transactional
    public List<Integer> findSubjectIdsForStudyPlanCardinalTimeUnitAndInBlocks(int studyPlanCardinalTimeUnitId) {
        return subjectMapper.findSubjectIdsForStudyPlanCardinalTimeUnitAndInBlocks(studyPlanCardinalTimeUnitId);
    }

    @Override
    @Transactional
    public List<Subject> findActiveSubjectsForStudyPlan(int studyPlanId) {
        return subjectMapper.findActiveSubjectsForStudyPlan(studyPlanId);
    }

    @Override
    @Transactional
    public List<Subject> findActiveSubjectsForCardinalTimeUnit(Map<String, Object> map) {
        return subjectMapper.findActiveSubjectsForCardinalTimeUnit(map);
    }

    @Override
    @Transactional
    public List<Subject> findActiveSubjectsForStudyPlanCardinalTimeUnit(Map<String, Object> map) {

        return subjectMapper.findActiveSubjectsForStudyPlanCardinalTimeUnit(map);
    }

    @Override
    @Transactional
    public void updatePreviousInstitutionDiplomaPhotograph(Student student) {

        studentMapper.updatePreviousInstitutionDiplomaPhotograph(student);
    }

    /* Methods concerning Thesis */

    @Override
    @Transactional
    public Thesis findThesis(int thesisId) {

        return thesisMapper.findThesis(thesisId);
    }

    @Override
    @Transactional
    public void addThesis(Thesis thesis) {
        thesisMapper.addThesis(thesis);

    }

    @Override
    @Transactional
    public void deleteThesis(int thesisId) {
        thesisMapper.deleteThesis(thesisId);

    }

    @Override
    @Transactional
    public Thesis findThesisByCode(String thesisCode) {
        return thesisMapper.findThesisByCode(thesisCode);
    }

    @Override
    @Transactional
    public Thesis findThesisForStudyPlan(int studyPlanId) {
        return thesisMapper.findThesisForStudyPlan(studyPlanId);
    }

    @Override
    @Transactional
    public void updateThesis(Thesis thesis) {
        thesisMapper.updateThesis(thesis);
    }

    @Override
    @Transactional
    public List<StudyPlanCardinalTimeUnit> findStudyPlanCardinalTimeUnitsByParams(Map<String, Object> map) {

        return studyplanCardinaltimeunitMapper.findStudyPlanCardinalTimeUnitsByParams(map);
    }

    @Override
    @Transactional
    public List<StudyPlanCardinalTimeUnit> findStudyPlanCardinalTimeUnits(List<Integer> studyPlanCardinalTimeUnitIds) {

        Map<String, Object> map = new HashMap<>();
        map.put("studyPlanCardinalTimeUnitIds", studyPlanCardinalTimeUnitIds);
        List<StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits = findStudyPlanCardinalTimeUnitsByParams(map);

        return studyPlanCardinalTimeUnits;
    }

    @Override
    @Transactional
    public List<Integer> findStudyPlanCardinalTimeUnitIds(Map<String, Object> map) {

        return studyplanCardinaltimeunitMapper.findStudyPlanCardinalTimeUnitIds(map);
    }

    @Override
    @Transactional
    public int findMaxCardinalTimeUnitNumberForStudyPlan(int studyPlanId) {

        Integer max = studyplanCardinaltimeunitMapper.findMaxCardinalTimeUnitNumberForStudyPlan(studyPlanId);
        return max == null ? 0 : max;
    }

    @Override
    @Transactional
    public StudyPlanCardinalTimeUnit findMaxCardinalTimeUnitForStudyPlan(int studyPlanId) {
        return studyplanCardinaltimeunitMapper.findMaxCardinalTimeUnitForStudyPlan(studyPlanId);
    }

    @Override
    @Transactional
    public int findMinCardinalTimeUnitNumberForStudyPlan(int studyPlanId) {

        Integer min = studyplanCardinaltimeunitMapper.findMinCardinalTimeUnitNumberForStudyPlan(studyPlanId);
        return min == null ? 0 : min;
    }

    @Override
    @Transactional
    public StudyPlanCardinalTimeUnit findMinCardinalTimeUnitForStudyPlan(int studyPlanId) {

        return studyplanCardinaltimeunitMapper.findMinCardinalTimeUnitForStudyPlan(studyPlanId);
    }

    @Override
    @Transactional
    public int findMaxCardinalTimeUnitNumberForStudyPlanCTU(int studyPlanId, int studyGradeTypeId) {

        return studyplanCardinaltimeunitMapper.findMaxCardinalTimeUnitNumberForStudyPlanCTU(studyPlanId, studyGradeTypeId);
    }

    @Override
    @Transactional
    public StudyPlanCardinalTimeUnit findStudyPlanCardinalTimeUnit(int studyPlanCardinalTimeUnitId) {

        return studyplanCardinaltimeunitMapper.findStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId);
    }

    @Override
    @Transactional
    public StudentStudentStatus findStudentStudentStatus(int studentStudentStatusId) {

        return studentStudentStatusMapper.findStudentStudentStatus(studentStudentStatusId);
    }

    @Override
    @Transactional
    public void addStudentStudentStatus(StudentStudentStatus studentStudentStatus) {
        studentStudentStatusMapper.addStudentStudentStatus(studentStudentStatus);
    }

    @Override
    @Transactional
    public void updateStudentStudentStatus(StudentStudentStatus studentStudentStatus) {
        studentStudentStatusMapper.updateStudentStudentStatus(studentStudentStatus);
    }

    @Override
    @Transactional
    public void deleteStudentStudentStatus(int studentStudentStatusId) {
        studentStudentStatusMapper.deleteStudentStudentStatus(studentStudentStatusId);
    }

    @Override
    public String getStudentStatus(Student student, String language) {
        String studentStatus = null;
        String studentStatusCode = student.getLatestStudentStatusCode();
        if (studentStatusCode != null) {
            Lookup lookup = LookupUtil.getLookupByCode(lookupCacher.getAllStudentStatuses(language), studentStatusCode);
            if (lookup != null) {
                studentStatus = lookup.getDescription();
            }
        }
        return studentStatus;
    }

    @Override
    @Transactional
    public StudyPlanCardinalTimeUnit findStudyPlanCardinalTimeUnitByParams(Map<String, Object> map) {

        return studyplanCardinaltimeunitMapper.findStudyPlanCardinalTimeUnitByParams(map);
    }

    @Override
    @Transactional
    public StudyPlanCardinalTimeUnit findStudyPlanCardinalTimeUnitByParams(int studyPlanId, int studyGradeTypeId, int cardinalTimeUnitNumber) {

        Map<String, Object> map = new HashMap<>();
        map.put("studyPlanId", studyPlanId);
        map.put("studyGradeTypeId", studyGradeTypeId);
        map.put("cardinalTimeUnitNumber", cardinalTimeUnitNumber);
        return studyplanCardinaltimeunitMapper.findStudyPlanCardinalTimeUnitByParams(map);
    }

    @Override
    @Transactional
    public StudyPlanCardinalTimeUnit findStudyPlanCtuForStudyPlanDetail(int studyPlanDetailId) {
        return studyplanCardinaltimeunitMapper.findStudyPlanCtuForStudyPlanDetail(studyPlanDetailId);
    }

    @Override
    @Transactional
    public void addStudyPlanCardinalTimeUnit(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, StudyPlanCardinalTimeUnit previousStudyPlanCardinalTimeUnit,
            HttpServletRequest request) {

        studyplanCardinaltimeunitMapper.addStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit);

        collegeServiceExtensions.studyPlanCardinalTimeUnitAdded(studyPlanCardinalTimeUnit, previousStudyPlanCardinalTimeUnit, request);
    }

    @Override
    @Transactional
    public void updateStudyPlanCardinalTimeUnit(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit) {
        studyplanCardinaltimeunitMapper.updateStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit);
    }

    @Override
    @Transactional
    public void deleteStudyPlanCardinalTimeUnit(int studyPlanCardinalTimeUnitId, String writeWho) {

        collegeServiceExtensions.beforeStudyPlanCardinalTimeUnitDelete(studyPlanCardinalTimeUnitId, writeWho);

        studyplanCardinaltimeunitMapper.deleteStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId);
    }

    @Override
    @Transactional
    public List<StudyPlanCardinalTimeUnit> findDescendingStudyPlanCardinalTimeUnitsForStudyPlan(int studyPlanId) {
        return studyplanCardinaltimeunitMapper.findDescendingStudyPlanCardinalTimeUnitsForStudyPlan(studyPlanId);
    }

    @Override
    @Transactional
    public String validateNewStudent(Student student, Locale currentLoc) {
        String showStudentError = "";

        /* test if the combination already exists */
        Map<String, Object> findStudentMap = new HashMap<>();
        findStudentMap.put("studentCode", student.getStudentCode());
        findStudentMap.put("surnameFull", student.getSurnameFull());
        findStudentMap.put("firstNamesFull", student.getFirstnamesFull());
        findStudentMap.put("birthdate", student.getBirthdate());
        findStudentMap.put("primaryStudyId", student.getPrimaryStudyId());
        findStudentMap.put("nationalRegistrationNumber", student.getNationalRegistrationNumber());
        if (findStudentByParams(findStudentMap) != null) {
            showStudentError = "jsp.error.student.alreadyexists";
            // } else {
            // // check whether studentCode already exists:
            // if (findStudentByCode(student.getStudentCode()) != null) {
            // showStudentError = "jsp.error.studentcode.alreadyexists";
            // }
        }
        return showStudentError;
    }

    @Override
    @Transactional
    public int findPersonId(int studentId) {
        Integer personId = studentMapper.findPersonId(studentId);
        return personId == null ? 0 : personId;
    }

    @Override
    @Transactional
    public int findPersonId(String studentId) {
        if (studentId == null || studentId.isEmpty()) {
            return 0;
        }

        return findPersonId(new Integer(studentId));
    }

    @Override
    @Transactional
    public void addStudyPlanDetail(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, int subjectBlockId, int subjectId, HttpServletRequest request) {

        StudyPlanDetail studyPlanDetail = new StudyPlanDetail();
        studyPlanDetail.setStudyPlanId(studyPlanCardinalTimeUnit.getStudyPlanId());
        studyPlanDetail.setStudyPlanCardinalTimeUnitId(studyPlanCardinalTimeUnit.getId());
        studyPlanDetail.setSubjectBlockId(subjectBlockId);
        studyPlanDetail.setSubjectId(subjectId);
        studyPlanDetail.setStudyGradeTypeId(studyPlanCardinalTimeUnit.getStudyGradeTypeId());
        studyPlanDetail.setActive("Y");
        addStudyPlanDetail(studyPlanDetail, request);

    }

    @Override
    @Transactional
    public void retainSubjectBlockStudyPlanDetails(StudyPlanCardinalTimeUnit studyPlanCTU, Collection<Integer> subjectBlockIds, HttpServletRequest request) {

        List<? extends StudyPlanDetail> sdpDetails = studyPlanCTU.getStudyPlanDetails();
        for (StudyPlanDetail sdpDetail : sdpDetails) {
            int sbid = sdpDetail.getSubjectBlockId();
            if (sbid != 0 && !subjectBlockIds.contains(sbid)) {
                deleteStudyPlanDetail(sdpDetail.getId(), request);
            }
        }
    }

    @Override
    @Transactional
    public void retainSubjectStudyPlanDetails(StudyPlanCardinalTimeUnit studyPlanCTU, Collection<Integer> subjectIds, HttpServletRequest request) {

        List<? extends StudyPlanDetail> sdpDetails = studyPlanCTU.getStudyPlanDetails();
        for (StudyPlanDetail sdpDetail : sdpDetails) {
            int subjectId = sdpDetail.getSubjectId();
            if (subjectId != 0 && !subjectIds.contains(subjectId)) {
                deleteStudyPlanDetail(sdpDetail.getId(), request);
            }
        }
    }

    @Override
    @Transactional
    public void addMissingSubjectBlockStudyPlanDetails(StudyPlanCardinalTimeUnit studyPlanCTU, Collection<Integer> subjectBlockIds, HttpServletRequest request) {

        StudyPlanCardinalTimeUnitAnalyzer spctuAnalyzer = new StudyPlanCardinalTimeUnitAnalyzer(studyPlanCTU);
        for (int subjectBlockId : subjectBlockIds) {
            if (!spctuAnalyzer.containsSubjectBlock(subjectBlockId)) {
                addStudyPlanDetail(studyPlanCTU, subjectBlockId, 0, request);
            }
        }
    }

    @Override
    @Transactional
    public void addMissingSubjectStudyPlanDetails(StudyPlanCardinalTimeUnit studyPlanCTU, Collection<Integer> subjectIds, HttpServletRequest request) {

        StudyPlanCardinalTimeUnitAnalyzer spctuAnalyzer = new StudyPlanCardinalTimeUnitAnalyzer(studyPlanCTU);
        for (int subjectId : subjectIds) {
            if (!spctuAnalyzer.containsSubject(subjectId)) {
                if (existStudyPlanDetail(studyPlanCTU.getStudyPlanId(), subjectId)) {
                    log.info("Subject with id = " + subjectId + " ignored, because it is included in one of the assigned subject blocks in the study plan with id = "
                            + studyPlanCTU.getStudyPlanId());
                } else {
                    addStudyPlanDetail(studyPlanCTU, 0, subjectId, request);
                }
            }
        }
    }

    // TODO modify to use subjectCode (or stableId) instead of subjectId
    // subjectId won't identify existing studyPlanDetails in different academic years.
    // see StudyPlanDetailEditController where findStudyPlanDetailsByParams is used.
    @Override
    @Transactional
    public boolean existStudyPlanDetail(int studyPlanId, int subjectId) {
        Map<String, Object> map = new HashMap<>();
        map.put("studyPlanId", studyPlanId);
        map.put("subjectId", subjectId);
        List<StudyPlanDetail> existingStudyPlanDetails = findStudyPlanDetailsByParams(map);

        return existingStudyPlanDetails != null && existingStudyPlanDetails.size() != 0;
    }

    @Override
    @Transactional
    public List<Integer> findStudyPlanIds(List<Integer> studyPlanCardinalTimeUnitIds) {
        Map<String, Object> map = new HashMap<>();
        map.put("studyPlanCardinalTimeUnitIds", studyPlanCardinalTimeUnitIds);
        return this.findStudyPlanIds(map);
    }

    @Override
    @Transactional
    public List<Integer> findStudyPlanIds(Map<String, Object> map) {
        return studyplanMapper.findStudyPlanIds(map);
    }

    @Override
    @Transactional
    public void updateProgressStatuses(Map<Integer, String> progressStatuses, String preferredLanguage, String writeWho) {
        for (Map.Entry<Integer, String> entry : progressStatuses.entrySet()) {
            int studyPlanCardinalTimeUnitId = entry.getKey();
            String newProgressStatusCode = entry.getValue();
            StudyPlanCardinalTimeUnit spctu = findStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId);
            String oldProgressStatusCode = spctu.getProgressStatusCode();

            if (!newProgressStatusCode.equals(oldProgressStatusCode)) {
                spctu.setProgressStatusCode(newProgressStatusCode);
                updateStudyPlanCardinalTimeUnit(spctu);

                updateStudyPlanStatus(spctu.getStudyPlanId(), oldProgressStatusCode, newProgressStatusCode, preferredLanguage, writeWho);
            }
        }
    }

    @Override
    @Transactional
    public void updateStudyPlanStatus(int studyPlanId, String oldProgressStatusCode, String newProgressStatusCode, String preferredLanguage, String writeWho) {

        // if status change involves the graduating flag, then update
        // studyplan.status
        CodeToLookupMap codeToLookupMap = new CodeToLookupMap(lookupCacher.getAllProgressStatuses(preferredLanguage));
        Lookup7 oldProgressStatus = (Lookup7) codeToLookupMap.get(oldProgressStatusCode);
        Lookup7 newProgressStatus = (Lookup7) codeToLookupMap.get(newProgressStatusCode);
        boolean isOldGraduating = oldProgressStatus != null && "Y".equalsIgnoreCase(oldProgressStatus.getGraduating());
        boolean isNewGraduating = newProgressStatus != null && "Y".equalsIgnoreCase(newProgressStatus.getGraduating());

        if (isOldGraduating != isNewGraduating) {
            StudyPlan studyPlan = findStudyPlan(studyPlanId);
            if (!isOldGraduating && isNewGraduating) {
                studyPlan.setStudyPlanStatusCode(OpusConstants.STUDYPLAN_STATUS_GRADUATED);
            } else if (isOldGraduating && !isNewGraduating) {
                studyPlan.setStudyPlanStatusCode(OpusConstants.STUDYPLAN_STATUS_APPROVED_ADMISSION);
            }
            updateStudyPlan(studyPlan, writeWho);
        }
    }

    @Override
    @Transactional
    public StudyPlanCardinalTimeUnit generateNextStudyPlanCardinalTimeUnit(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, int newAcademicYearId, HttpServletRequest request) {

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        StudyPlanCardinalTimeUnit newStudyPlanCardinalTimeUnit = null;
        Lookup7 progressStatus = null;
        StudyGradeType studyGradeType = null;
        StudyGradeType newStudyGradeType = null;

        List<? extends Lookup7> allProgressStatuses = lookupCacher.getAllProgressStatuses(preferredLanguage);
        for (int j = 0; j < allProgressStatuses.size(); j++) {
            if ((studyPlanCardinalTimeUnit.getProgressStatusCode()).equals(allProgressStatuses.get(j).getCode())) {
                progressStatus = (Lookup7) allProgressStatuses.get(j);
                break;
            }
        }

        if (progressStatus != null) {

            newStudyPlanCardinalTimeUnit = new StudyPlanCardinalTimeUnit();
            newStudyPlanCardinalTimeUnit.setStudyPlanId(studyPlanCardinalTimeUnit.getStudyPlanId());
            newStudyPlanCardinalTimeUnit.setActive("Y");
            newStudyPlanCardinalTimeUnit.setCardinalTimeUnitStatusCode(appConfigManager.getCntdRegistrationInitialCardinalTimeUnitStatus());
            newStudyPlanCardinalTimeUnit.setTuitionWaiver(studyPlanCardinalTimeUnit.getTuitionWaiver());
            newStudyPlanCardinalTimeUnit.setStudyIntensityCode(getNextStudyIntensityCode(progressStatus));

            if ("Y".equals(progressStatus.getContinuing()) && "N".equals(progressStatus.getGraduating())) {
                if ("Y".equals(progressStatus.getIncrement())) {
                    newStudyPlanCardinalTimeUnit.setCardinalTimeUnitNumber(studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber() + 1);
                } else {
                    newStudyPlanCardinalTimeUnit.setCardinalTimeUnitNumber(studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber());
                }

                studyGradeType = studyManager.findStudyGradeType(studyPlanCardinalTimeUnit.getStudyGradeTypeId());

                // if clear pass or 'to full time', both options possible: this
                // or next academic year:
                if ("Y".equals(progressStatus.getIncrement()) && "N".equals(progressStatus.getCarrying())) {
                    // use the academicyear from the parameter
                    if (log.isDebugEnabled()) {
                        log.debug("StudentManager.generateNextStudyPlanCardinalTimeUnit: newAcademicYearId from param = " + newAcademicYearId);
                    }
                } else {
                    List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
                    // next ctu is always in the next academic year:
                    if (log.isDebugEnabled()) {
                        log.debug("StudentManager.generateNextStudyPlanCardinalTimeUnit: studyGradeType.getCurrentAcademicYearId() = " + studyGradeType.getCurrentAcademicYearId());
                    }
                    newAcademicYearId = AcademicYearUtil.getNextAcademicYearId(allAcademicYears, studyGradeType.getCurrentAcademicYearId());
                    if (log.isDebugEnabled()) {
                        log.debug("StudentManager.generateNextStudyPlanCardinalTimeUnit: newAcademicYearId = " + newAcademicYearId);
                    }
                }

                if (newAcademicYearId != 0) {

                    // find studygradetype with this new academicyear:
                    Map<String, Object> findMap = new HashMap<>();
                    findMap.put("studyId", studyGradeType.getStudyId());
                    findMap.put("gradeTypeCode", studyGradeType.getGradeTypeCode());
                    findMap.put("currentAcademicYearId", newAcademicYearId);
                    findMap.put("studyTimeCode", studyGradeType.getStudyTimeCode());
                    findMap.put("studyFormCode", studyGradeType.getStudyFormCode());
                    findMap.put("preferredLanguage", preferredLanguage);
                    if ("Y".equals(request.getAttribute("iUseOfPartTimeStudyGradeTypes"))) {
                        // find out if a switch between parttime / fulltime must
                        // be made:
                        if ((OpusConstants.PROGRESS_STATUS_TO_PARTTIME).equals(progressStatus.getCode())) {
                            findMap.put("studyIntensityCode", "P");
                        } else {
                            if ((OpusConstants.PROGRESS_STATUS_TO_FULLTIME).equals(progressStatus.getCode())) {
                                findMap.put("studyIntensityCode", "F");
                            } else {
                                findMap.put("studyIntensityCode", studyGradeType.getStudyIntensityCode());
                            }
                        }
                    }
                    newStudyGradeType = studyManager.findStudyGradeTypeByParams(findMap);

                    if (newStudyGradeType != null) {
                        newStudyPlanCardinalTimeUnit.setStudyGradeTypeId(newStudyGradeType.getId());

                        this.addStudyPlanCardinalTimeUnit(newStudyPlanCardinalTimeUnit, studyPlanCardinalTimeUnit, request);
                        if (log.isDebugEnabled()) {
                            log.debug("StudentManager: newly created studyPlanCardinalTimeUnit on top of last one - last one id = " + studyPlanCardinalTimeUnit.getId());
                        }

                        if (log.isDebugEnabled()) {
                            log.debug("StudentManager: newly created studyPlanCardinalTimeUnit on top of last one - new id = " + studyPlanCardinalTimeUnit.getId());
                        }
                    } else {
                        if (log.isDebugEnabled()) {
                            log.debug("StudentManager: no studygradetype found for params and ac year " + newAcademicYearId);
                        }
                    }
                }
            }
        }
        return newStudyPlanCardinalTimeUnit;
    }

    @Override
    @Transactional
    public List<StudyPlanCardinalTimeUnit> findLowestStudyPlanCardinalTimeUnitsForStudyPlan(int studyPlanId) {

        List<StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits = null;

        studyPlanCardinalTimeUnits = studyplanCardinaltimeunitMapper.findLowestStudyPlanCardinalTimeUnitsForStudyPlan(studyPlanId);

        return studyPlanCardinalTimeUnits;

    }

    // TODO Move to ResultManager
    @Override
    @Transactional
    @Deprecated
    public List<FailedSubjectInfo> findAllFailedCompulsorySubjectsForStudyPlan(int studyPlanId) {

        List<String> allCheckedSubjectCodes = new ArrayList<>();
        boolean subjectPassed = false;

        List<FailedSubjectInfo> allFailedSubjects = new ArrayList<>();

        // find all studyPlanDetails (containing the subject(block)s) of this studyPlan
        Map<String, Object> spdMap = new HashMap<>();
        spdMap.put("studyPlanId", studyPlanId);
        spdMap.put("exempted", false);
        List<StudyPlanDetail> allStudyPlanDetails = findStudyPlanDetailsByParams(spdMap);
        // List <StudyPlanDetail> allStudyPlanDetails =
        // this.findStudyPlanDetailsForStudyPlan(studyPlanId);
        // if (allStudyPlanDetails == null) {
        // allStudyPlanDetails = new ArrayList<StudyPlanDetail>();
        // }

        // find all actually passed subjects
        Map<String, Object> map = new HashMap<>();
        map.put("studyPlanId", studyPlanId);
        map.put("passed", OpusConstants.GENERAL_YES);
        map.put("active", OpusConstants.GENERAL_YES);
        List<SubjectResult> allPassedSubjectResults = resultManager.findSubjectResultsByParams(map);

        if (allPassedSubjectResults == null) {
            allPassedSubjectResults = new ArrayList<>();
        }

        /*
         * now check for every subject if it has actually been passed; use the subjectCode to see if
         * it is the same subject
         */
        for (StudyPlanDetail studyPlanDetail : allStudyPlanDetails) {
            int studyGradeTypeId = this.findStudyPlanCtuForStudyPlanDetail(studyPlanDetail.getId()).getStudyGradeTypeId();

            if (studyPlanDetail.getSubjectId() != 0) {
                Subject subject = subjectManager.findSubject(studyPlanDetail.getSubjectId());
                // it only should be checked once if a subject has been passed
                boolean subjectAlreadyInCheckList = false;
                for (String subjectCode : allCheckedSubjectCodes) {
                    if (subject.getSubjectCode().equals(subjectCode)) {
                        subjectAlreadyInCheckList = true;
                        break;
                    }
                }

                if (!subjectAlreadyInCheckList) {

                    allCheckedSubjectCodes.add(subject.getSubjectCode());

                    for (SubjectResult passedResult : allPassedSubjectResults) {
                        Subject passedSubject = subjectManager.findSubject(passedResult.getSubjectId());
                        if (subject.getSubjectCode().equalsIgnoreCase(passedSubject.getSubjectCode())) {
                            subjectPassed = true;
                            // allPassedSubjectResults.remove(passedResult);
                            break;
                        }
                    }
                    if (!subjectPassed) {
                        // add the subject to the list is if is compulsory
                        HashMap<String, Object> subjectMmap = new HashMap<>();
                        subjectMmap.put("subjectCode", subject.getSubjectCode());
                        subjectMmap.put("studyGradeTypeId", studyGradeTypeId);
                        subjectMmap.put("rigidityTypeCode", OpusConstants.RIGIDITY_COMPULSORY);
                        SubjectStudyGradeType subjectStudyGradeType = subjectManager.findSubjectStudyGradeTypeByParams(subjectMmap);

                        if (subjectStudyGradeType != null) {
                            FailedSubjectInfo failedSubjectInfo = new FailedSubjectInfo(subjectStudyGradeType.getSubjectId(), subject.getSubjectCode(),
                                    subjectStudyGradeType.getCardinalTimeUnitNumber());
                            allFailedSubjects.add(failedSubjectInfo);
                        }
                    }
                }

                // TODO: studyPlanDetail is a subjectBlock
                // } else if (studyPlanDetail.getSubjectBlockId() != 0) {
                // int subjectBlockId = studyPlanDetail.getSubjectBlockId();
                //
                // // first check if the subjectBlock is compulsory. If not, just ignore it.
                // HashMap<String, Object> subjectBlockMap = new HashMap<String, Object>();
                // subjectBlockMap.put("subjectBlockId", subjectBlockId);
                // subjectBlockMap.put("studyGradeTypeId", studyGradeTypeId);
                // subjectBlockMap.put("rigidityTypeCode", OpusConstants.RIGIDITY_COMPULSORY);
                //
                // List<SubjectBlockStudyGradeType> allSubjectBlockSTGTs =
                // subjectManager.findSubjectBlockStudyGradeTypes(subjectBlockMap);
                //
                // if (allSubjectBlockSTGTs != null) {
                // // find the subjects in the block and check if they have been passed
                // List <Subject> subjectsInBlock =
                // subjectManager.findSubjectsInSubjectBlock(subjectBlockId);
                // for (Subject subject : subjectsInBlock) {
                // // first make sure a subject with this code has not already been checked
                // boolean subjectAlreadyInCheckList = false;
                // for (String subjectCode : allCheckedSubjectCodes) {
                // if (subject.getSubjectCode().equals(subjectCode)) {
                // subjectAlreadyInCheckList = true;
                // }
                // }
                //
                // if (!subjectAlreadyInCheckList) {
                // allCheckedSubjectCodes.add(subject.getSubjectCode());
                //
                // for (SubjectResult passedResult : allPassedSubjectResults) {
                // Subject passedSubject = subjectManager.findSubject(passedResult.getSubjectId());
                // if (subject.getSubjectCode().equalsIgnoreCase(passedSubject.getSubjectCode())) {
                // subjectPassed = true;
                // break;
                // }
                // }
                // if (!subjectPassed) {
                // allFailedSubjects.add(subject);
                // }
                // }
                // }
                // }
            }
            // reset
            subjectPassed = false;
        }

        return allFailedSubjects;
    }

    private int findSubjectIdIfTaughtInNextCtu(FailedSubjectInfo failedSubjectInfo, StudyPlanCardinalTimeUnit newStudyPlanCtu) {

        if (newStudyPlanCtu == null) {
            return 0;
        }

        int subjectId = failedSubjectInfo.getSubjectId();

        // determine
        StudyGradeType newStudyGradeType = studyManager.findStudyGradeType(newStudyPlanCtu.getStudyGradeTypeId());
        if (newStudyGradeType == null) {
            throw new RuntimeException("StudyGradeType could not be found, which indicates a major inconsistency.");
        }
        int newAcademicYearId = newStudyGradeType.getCurrentAcademicYearId();
        String cardinalTimeUnitCode = newStudyGradeType.getCardinalTimeUnitCode();

        /*
         * the failed subject should be taught in a CTU that is parallel to the CTU of the new
         * studyPlanCTU. E.g. if the programme is semester based, the number of timeUnits per year
         * is 2. Then CTU's 1,3,5,7, etc are taught at the same moment and CTU's 2,4,6,8 etc too.So
         * if you failed a subject in CTU 1, in can be repeated during CTU 3 (or 5, 7 etc).
         */
        double nrOfUnitsPerYear = studyManager.findNrOfUnitsPerYearForCardinalTimeUnitCode(cardinalTimeUnitCode);
        double newCTUNumber = newStudyPlanCtu.getCardinalTimeUnitNumber();
        double oldCTUnumber = failedSubjectInfo.getCardinalTimeUnitNumber();
        // should return 0
        double determineIfCorrectCTU = (newCTUNumber - oldCTUnumber) / nrOfUnitsPerYear % 1;

        int newSubjectId = 0;
        if (determineIfCorrectCTU == 0.0) {
            String subjectCode = subjectManager.findSubject(subjectId).getSubjectCode();
            Map<String, Object> map = new HashMap<>();
            map.put("studyGradeTypeId", newStudyPlanCtu.getStudyGradeTypeId());
            map.put("subjectCode", subjectCode);
            map.put("cardinalTimeUnitNumberExact", oldCTUnumber);
            map.put("currentAcademicYearId", newAcademicYearId);
            List<Subject> subjectsTaught = subjectManager.findSubjects(map);
            if (!ListUtil.isNullOrEmpty(subjectsTaught)) {
                if (subjectsTaught.size() != 1) {
                    throw new RuntimeException("Expected not more than one record, but found " + subjectsTaught.size() + " records");
                }
                newSubjectId = subjectsTaught.get(0).getId();
            }
        }
        return newSubjectId;
    }

    /**
     * Create a list of studyPlanDetails from a list of subjects for a given
     * studyPlanCardinalTimeUnit
     */
    private List<StudyPlanDetail> createStudyPlanDetailsForSubjects(List<FailedSubjectInfo> failedSubjectInfos, StudyPlanCardinalTimeUnit newStudyPlanCtu) {

        if (log.isDebugEnabled()) {
            log.debug("StudentManager.createStudyPlanDetailsForSubjects entered...");
        }

        List<StudyPlanDetail> studyPlanDetails = new ArrayList<>();
        int studyPlanId = newStudyPlanCtu.getStudyPlanId();

        for (FailedSubjectInfo subjectSGT : failedSubjectInfos) {
            int newSubjectId = findSubjectIdIfTaughtInNextCtu(subjectSGT, newStudyPlanCtu);
            if (newSubjectId != 0) {
                // TODO need to add rigidityTypeCode to StudyPlanDetail table and class because for
                // repeated subjects the status is not clear
                StudyPlanDetail newStudyPlanDetail = new StudyPlanDetail();
                newStudyPlanDetail.setActive("Y");
                newStudyPlanDetail.setStudyPlanId(studyPlanId);
                newStudyPlanDetail.setStudyGradeTypeId(newStudyPlanCtu.getStudyGradeTypeId());
                newStudyPlanDetail.setSubjectId(newSubjectId);
                newStudyPlanDetail.setStudyPlanCardinalTimeUnitId(newStudyPlanCtu.getId());

                studyPlanDetails.add(newStudyPlanDetail);
            }
        }
        return studyPlanDetails;
    }

    @Override
    @Transactional
    public void generateDetailsForStudyPlanCardinalTimeUnit(StudyPlanCardinalTimeUnit oldStudyPlanCardinalTimeUnit, StudyPlanCardinalTimeUnit newStudyPlanCardinalTimeUnit,
            HttpServletRequest request, Errors errors) {

        HttpSession session = request.getSession(false);
        String iMajorMinor = opusInit.getMajorMinor();
        String iUseOfPartTimeStudyGradeTypes = (String) session.getAttribute("iUseOfPartTimeStudyGradeTypes");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        Locale currentLoc = OpusMethods.getPreferredLocale(request);

        int studyPlanId = oldStudyPlanCardinalTimeUnit.getStudyPlanId();

        // find all failed subjects
        // List<FailedSubjectInfo> subjectsToRepeat =
        // this.findAllFailedCompulsorySubjectsForStudyPlan(studyPlanId);
        List<FailedSubjectInfo> subjectsToRepeat = failedSubjectInfoMapper.findAllFailedSubjectInfosForStudyPlan(studyPlanId, OpusConstants.RIGIDITY_COMPULSORY);

        Lookup7 oldProgressStatus = null;
        List<StudyPlanDetail> allNewStudyPlanDetails = new ArrayList<>();

        if (newStudyPlanCardinalTimeUnit.getProgressStatusCode() != null) {
            errors.reject("jsp.error.progressstatus.newctu.filled");
            return;
        }

        List<Lookup7> allProgressStatuses = lookupCacher.getAllProgressStatuses(preferredLanguage);
        oldProgressStatus = (Lookup7) LookupUtil.getLookupByCode(allProgressStatuses, oldStudyPlanCardinalTimeUnit.getProgressStatusCode());

        // handle all situations:
        // not continuing - no details filled
        if ("N".equals(oldProgressStatus.getContinuing())) {
            errors.reject("jsp.error.progressstatus.newctu.not.continuing");
            return;
        } else {
            if (log.isDebugEnabled()) {
                log.debug("StudentManager.generateDetailsForStudyPlanCardinalTimeUnit: oldProgressStatus - increment = " + oldProgressStatus.getIncrement() + ", carrying = "
                        + oldProgressStatus.getCarrying());
            }

            // incrementing, or not incrementing and carrying all: fill studyplan-ctu with
            // compulsory new subject(block)s
            // and with failed subjects
            if (("N".equals(oldProgressStatus.getIncrement()) && "A".equals(oldProgressStatus.getCarrying())) || ("Y".equals(oldProgressStatus.getIncrement())
                    && ("N".equals(oldProgressStatus.getCarrying()) || "S".equals(oldProgressStatus.getCarrying()) || "A".equals(oldProgressStatus.getCarrying())))) {

                allNewStudyPlanDetails = this.createCompulsoryNewStudyPlanDetailsForNextStudyPlanCTU(newStudyPlanCardinalTimeUnit, currentLoc, preferredLanguage, iMajorMinor,
                        iUseOfPartTimeStudyGradeTypes);

                /*
                 * if the student is not incrementing, the failed subjects could already be in the
                 * list of newStudyPlanDetails. if so, they should not be added again.
                 */
                // NB: An iterator needs to be used to remove items from the same collection that we
                // are iterating
                Iterator<FailedSubjectInfo> it = subjectsToRepeat.iterator();
                while (it.hasNext()) {
                    FailedSubjectInfo subjectToRepeat = it.next();
                    String subjectToRepeatCode = subjectManager.findSubject(subjectToRepeat.getSubjectId()).getSubjectCode();
                    for (StudyPlanDetail studyPlanDetail : allNewStudyPlanDetails) {
                        if (studyPlanDetail.getSubjectId() != 0) {
                            String subjectCode = subjectManager.findSubject(studyPlanDetail.getSubjectId()).getSubjectCode();
                            if (subjectToRepeatCode.equals(subjectCode)) {
                                it.remove();
                                break;
                            }
                        } else if (studyPlanDetail.getSubjectBlockId() != 0) {
                            // find all subjects in block
                            List<Subject> allSubjectsInBlock = subjectManager.findSubjectsInSubjectBlock(studyPlanDetail.getSubjectBlockId());
                            boolean isSubjectToRepeatRemoved = false;
                            for (Subject subjectInBlock : allSubjectsInBlock) {
                                if (subjectToRepeatCode.equals(subjectInBlock.getSubjectCode())) {
                                    it.remove();
                                    isSubjectToRepeatRemoved = true;
                                    break;
                                }
                            }
                            if (isSubjectToRepeatRemoved) {
                                break;
                            }
                        }
                    }
                }

                // add remaining failed Subjects
                allNewStudyPlanDetails.addAll(createStudyPlanDetailsForSubjects(subjectsToRepeat, newStudyPlanCardinalTimeUnit));

                // not incrementing, carrying selected: add only failed subjects
            } else if ("N".equals(oldProgressStatus.getIncrement()) && "S".equals(oldProgressStatus.getCarrying())) {
                allNewStudyPlanDetails = this.createStudyPlanDetailsForSubjects(subjectsToRepeat, newStudyPlanCardinalTimeUnit);
            }
        }

        // step: insert the list of studyplandetails into the database
        if (!ListUtil.isNullOrEmpty(allNewStudyPlanDetails)) {
            for (StudyPlanDetail studyPlanDetail : allNewStudyPlanDetails) {
                this.addStudyPlanDetail(studyPlanDetail, request);
            }
        }

    }

    @Override
    @Transactional
    public List<StudyPlanDetail> createCompulsoryNewStudyPlanDetailsForNextStudyPlanCTU(StudyPlanCardinalTimeUnit newStudyPlanCardinalTimeUnit, Locale currentLoc,
            String preferredLanguage, String iMajorMinor, String iUseOfPartTimeStudyGradeTypes) {

        List<StudyPlanDetail> allNewStudyPlanDetails = new ArrayList<>();
        StudyGradeType newStudyGradeType = null;
        StudyPlanDetail newStudyPlanDetail = null;
        List<SubjectStudyGradeType> allSubjectStudyGradeTypes = null;
        List<SubjectBlockStudyGradeType> allSubjectBlockStudyGradeTypes = null;
        int studyPlanId = newStudyPlanCardinalTimeUnit.getStudyPlanId();

        newStudyGradeType = studyManager.findStudyGradeType(newStudyPlanCardinalTimeUnit.getStudyGradeTypeId());

        Map<String, Object> findMap = new HashMap<>();
        findMap.put("preferredLanguage", preferredLanguage);
        findMap.put("studyId", newStudyGradeType.getStudyId());
        findMap.put("studyGradeTypeId", newStudyGradeType.getId());
        findMap.put("cardinalTimeUnitNumber", newStudyPlanCardinalTimeUnit.getCardinalTimeUnitNumber());
        findMap.put("rigidityTypeCode", OpusConstants.RIGIDITY_COMPULSORY);
        // if major/minor is active, extend subjectstudygradetypemap with new
        // arguments:
        if ("Y".equals(iMajorMinor)) {
            StudyPlan studyPlan = this.findStudyPlan(newStudyPlanCardinalTimeUnit.getStudyPlanId());
            if (studyPlan.getMinor1Id() != 0) {
                Map<String, Object> map = new HashMap<>();
                map.put("studyId", studyPlan.getMinor1Id());
                map.put("gradeTypeCode", null);
                map.put("currentAcademicYearId", newStudyGradeType.getCurrentAcademicYearId());
                map.put("studyTimeCode", newStudyGradeType.getStudyTimeCode());
                map.put("studyFormCode", newStudyGradeType.getStudyFormCode());
                if ("Y".equals(iUseOfPartTimeStudyGradeTypes)) {
                    map.put("studyIntensityCode", newStudyGradeType.getStudyIntensityCode());
                }
                map.put("preferredLanguage", preferredLanguage);
                StudyGradeType minorNewStudyGradeType = studyManager.findStudyGradeTypeByParams(map);

                findMap.put("minor1Id", studyPlan.getMinor1Id());
                findMap.put("minorStudyGradeTypeId", minorNewStudyGradeType.getId());
                findMap.put("importanceTypeMajor", OpusConstants.IMPORTANCE_TYPE_MAJOR);
                findMap.put("importanceTypeMinor", OpusConstants.IMPORTANCE_TYPE_MINOR);
            }
        }
        // find all compulsory subjects for the new studygradetype, cardinaltimeunitnumber:
        allSubjectStudyGradeTypes = subjectManager.findSubjectStudyGradeTypes(findMap);

        if (log.isDebugEnabled()) {
            log.debug("StudentManager.createCompulsoryNewStudyPlanDetailsForNextStudyPlanCTU: allSubjectStudyGradeTypes.size(): " + allSubjectStudyGradeTypes.size());
        }
        if (allSubjectStudyGradeTypes != null) {
            for (SubjectStudyGradeType subjectStudyGradeType : allSubjectStudyGradeTypes) {
                if (subjectStudyGradeType != null && subjectStudyGradeType.getCardinalTimeUnitNumber() != 0) {
                    // check if there are no pending prerequisites
                    if (!this.hasPendingPrerequisites(subjectStudyGradeType, studyPlanId)) {
                        newStudyPlanDetail = new StudyPlanDetail();
                        newStudyPlanDetail.setActive("Y");
                        newStudyPlanDetail.setStudyPlanId(newStudyPlanCardinalTimeUnit.getStudyPlanId());
                        newStudyPlanDetail.setStudyGradeTypeId(subjectStudyGradeType.getStudyGradeTypeId());
                        newStudyPlanDetail.setSubjectId(subjectStudyGradeType.getSubjectId());
                        newStudyPlanDetail.setStudyPlanCardinalTimeUnitId(newStudyPlanCardinalTimeUnit.getId());

                        allNewStudyPlanDetails.add(newStudyPlanDetail);
                    }
                }
            }
        } else {
            if ("Y".equals(iMajorMinor)) {
                // TODO case majorMinor ?Needed?
            }
        }

        // find all compulsory subjectblocks for the new studygradetype:
        allSubjectBlockStudyGradeTypes = subjectBlockMapper.findSubjectBlockStudyGradeTypes(findMap);
        if (log.isDebugEnabled()) {
            log.debug("StudentManager.createCompulsoryNewStudyPlanDetailsForNextStudyPlanCTU: allSubjectBlockStudyGradeTypes.size(): " + allSubjectBlockStudyGradeTypes.size());
        }
        if (allSubjectBlockStudyGradeTypes != null) {
            for (SubjectBlockStudyGradeType subjectBlockStudyGradeType : allSubjectBlockStudyGradeTypes) {

                if (subjectBlockStudyGradeType.getCardinalTimeUnitNumber() != 0) {
                    if (!hasPendingPrerequisites(subjectBlockStudyGradeType, studyPlanId)) {
                        newStudyPlanDetail = new StudyPlanDetail();
                        newStudyPlanDetail.setActive("Y");
                        newStudyPlanDetail.setStudyPlanId(newStudyPlanCardinalTimeUnit.getStudyPlanId());
                        newStudyPlanDetail.setStudyGradeTypeId(subjectBlockStudyGradeType.getStudyGradeType().getId());
                        newStudyPlanDetail.setSubjectBlockId(subjectBlockStudyGradeType.getSubjectBlock().getId());
                        newStudyPlanDetail.setStudyPlanCardinalTimeUnitId(newStudyPlanCardinalTimeUnit.getId());

                        allNewStudyPlanDetails.add(newStudyPlanDetail);
                    }
                }
            }
        } else {
            if ("Y".equals(iMajorMinor)) {
                // TODO case majorMinor ?Needed?
            }
        }

        return allNewStudyPlanDetails;
    }

    private boolean hasPendingPrerequisites(SubjectStudyGradeType subjectStudyGradeType, int studyPlanId) {
        boolean hasPendingPrerequisites = false;
        if (!ListUtil.isNullOrEmpty(subjectStudyGradeType.getSubjectPrerequisites())) {
            List<SubjectPrerequisite> prerequisites = subjectStudyGradeType.getSubjectPrerequisites();
            for (SubjectPrerequisite prerequisite : prerequisites) {
                String subjectCode = prerequisite.getRequiredSubjectCode();
                Map<String, Object> map = new HashMap<>();
                map.put("studyPlanId", studyPlanId);
                map.put("subjectCode", subjectCode);
                map.put("passed", OpusConstants.GENERAL_YES);
                map.put("active", OpusConstants.GENERAL_YES);
                List<SubjectResult> passedSubjectResults = resultManager.findSubjectResultsByParams(map);
                if (ListUtil.isNullOrEmpty(passedSubjectResults)) {
                    hasPendingPrerequisites = true;
                    break;
                }
            }

        }
        return hasPendingPrerequisites;
    }

    private boolean hasPendingPrerequisites(SubjectBlockStudyGradeType subjectBlockStudyGradeType, int studyPlanId) {
        boolean hasPendingPrerequisites = false;
        if (!ListUtil.isNullOrEmpty(subjectBlockStudyGradeType.getSubjectBlockPrerequisites())) {
            int studyGradeTypeId = subjectBlockStudyGradeType.getStudyGradeType().getId();
            // check if all subjects in prerequisite blocks have been passed
            for (SubjectBlockPrerequisite subjectBlockPrereq : subjectBlockStudyGradeType.getSubjectBlockPrerequisites()) {
                String requiredBlockCode = subjectBlockPrereq.getRequiredSubjectBlockCode();
                Map<String, Object> subjectBlockMap = new HashMap<>();
                subjectBlockMap.put("studyGradeTypeId", studyGradeTypeId);
                subjectBlockMap.put("subjectBlockCode", requiredBlockCode);
                SubjectBlockStudyGradeType requiredSubjectBlockSTGT = subjectBlockMapper.findSubjectBlockStudyGradeTypeByParams(subjectBlockMap);
                if (requiredSubjectBlockSTGT == null) {
                    log.warn("Subject block prerequisite is invalid and therefore ignored: subjectBlockStudyGradeTypeId=" + subjectBlockPrereq.getSubjectBlockStudyGradeTypeId()
                            + ", studyGradeTypeId=" + studyGradeTypeId + "subjectBlockCode=" + requiredBlockCode);
                    continue;
                }
                int subjectBlockId = requiredSubjectBlockSTGT.getSubjectBlock().getId();
                List<Subject> allSubjects = subjectBlockMapper.findSubjectsForSubjectBlock(subjectBlockId);
                for (Subject subject : allSubjects) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("studyPlanId", studyPlanId);
                    map.put("subjectCode", subject.getSubjectCode());
                    map.put("passed", OpusConstants.GENERAL_YES);
                    map.put("active", OpusConstants.GENERAL_YES);
                    List<SubjectResult> passedSubjectResults = resultManager.findSubjectResultsByParams(map);
                    if (ListUtil.isNullOrEmpty(passedSubjectResults)) {
                        hasPendingPrerequisites = true;
                        break;
                    }
                }
                if (hasPendingPrerequisites) {
                    break;
                }
            }
        }
        return hasPendingPrerequisites;
    }

    @Override
    @Transactional
    public StudyPlanCardinalTimeUnit findPreviousStudyPlanCardinalTimeUnit(StudyPlanCardinalTimeUnit newStudyPlanCardinalTimeUnit) {

        StudyPlanCardinalTimeUnit previousStudyPlanCardinalTimeUnit = null;

        // params for studyplan ctu in same ctunumber, with continuing Y and increment N
        Map<String, Object> map = new HashMap<>();
        map.put("studyPlanId", newStudyPlanCardinalTimeUnit.getStudyPlanId());
        map.put("cardinalTimeUnitNumber", newStudyPlanCardinalTimeUnit.getCardinalTimeUnitNumber());
        map.put("continuing", "Y");
        map.put("increment", "N");

        previousStudyPlanCardinalTimeUnit = this.findStudyPlanCardinalTimeUnitByParams(map);
        // if not found, params for studyplan ctu in previous ctunumber, with
        // continuing Y and increment Y
        if (previousStudyPlanCardinalTimeUnit == null) {
            if (log.isDebugEnabled()) {
                log.debug("StudentManager.findPreviousStudyPlanCardinalTimeUnit: no studyplanctu found in same ctunumber");
            }
            map.put("cardinalTimeUnitNumber", (newStudyPlanCardinalTimeUnit.getCardinalTimeUnitNumber() - 1));
            map.put("continuing", "Y");
            map.put("increment", "Y");
        }
        previousStudyPlanCardinalTimeUnit = this.findStudyPlanCardinalTimeUnitByParams(map);

        if (log.isDebugEnabled()) {
            if (previousStudyPlanCardinalTimeUnit == null) {
                log.debug("StudentManager.findPreviousStudyPlanCardinalTimeUnit: no studyplanctu found in previous ctunumber");
            }
        }

        return previousStudyPlanCardinalTimeUnit;
    }

    @Override
    @Transactional
    public StudyPlanCardinalTimeUnit findNextStudyPlanCardinalTimeUnit(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit, String iUseOfPartTimeStudyGradeTypes) {

        StudyPlanCardinalTimeUnit nextStudyPlanCardinalTimeUnit = null;
        Lookup7 progressStatus = null;
        StudyGradeType studyGradeType = null;
        StudyGradeType newStudyGradeType = null;
        int newAcademicYearId = 0;
        Map<String, Object> findMap = new HashMap<>();

        if (StringUtil.isNullOrEmpty(studyPlanCardinalTimeUnit.getProgressStatusCode())) {
            // no next studyplancardinaltimeunit
            return null;
        } else {

            @SuppressWarnings("deprecation")
            List<? extends Lookup7> allProgressStatuses = lookupCacher.getAllProgressStatuses();
            for (int j = 0; j < allProgressStatuses.size(); j++) {
                if ((studyPlanCardinalTimeUnit.getProgressStatusCode()).equals(allProgressStatuses.get(j).getCode())) {
                    progressStatus = (Lookup7) allProgressStatuses.get(j);
                    break;
                }
            }

            if (progressStatus != null) {

                nextStudyPlanCardinalTimeUnit = new StudyPlanCardinalTimeUnit();
                nextStudyPlanCardinalTimeUnit.setStudyPlanId(studyPlanCardinalTimeUnit.getStudyPlanId());
                nextStudyPlanCardinalTimeUnit.setActive("Y");
                nextStudyPlanCardinalTimeUnit.setTuitionWaiver(studyPlanCardinalTimeUnit.getTuitionWaiver());

                if ("Y".equals(progressStatus.getContinuing()) && "N".equals(progressStatus.getGraduating())) {
                    if ("Y".equals(progressStatus.getIncrement())) {
                        nextStudyPlanCardinalTimeUnit.setCardinalTimeUnitNumber(studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber() + 1);
                    } else {
                        nextStudyPlanCardinalTimeUnit.setCardinalTimeUnitNumber(studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber());
                    }

                    studyGradeType = studyManager.findStudyGradeType(studyPlanCardinalTimeUnit.getStudyGradeTypeId());

                    // if clear pass or 'to full time', both options possible:
                    // this or next academic year:
                    // first check next year:
                    List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
                    // next ctu is in the next academic year:
                    newAcademicYearId = AcademicYearUtil.getNextAcademicYearId(allAcademicYears, studyGradeType.getCurrentAcademicYearId());
                    if (log.isDebugEnabled()) {
                        log.debug("StudentManager.findNextStudyPlanCardinalTimeUnit: newAcademicYearId (next ac. year) = " + newAcademicYearId);
                    }
                    // find studygradetype with this new academicyear:
                    findMap.put("studyId", studyGradeType.getStudyId());
                    findMap.put("gradeTypeCode", studyGradeType.getGradeTypeCode());
                    findMap.put("currentAcademicYearId", newAcademicYearId);
                    findMap.put("studyTimeCode", studyGradeType.getStudyTimeCode());
                    findMap.put("studyFormCode", studyGradeType.getStudyFormCode());
                    if ("Y".equals(iUseOfPartTimeStudyGradeTypes)) {
                        // find out if a switch between parttime / fulltime must
                        // be made:
                        if ((OpusConstants.PROGRESS_STATUS_TO_PARTTIME).equals(progressStatus.getCode())) {
                            findMap.put("studyIntensityCode", "P");
                        } else {
                            if ((OpusConstants.PROGRESS_STATUS_TO_FULLTIME).equals(progressStatus.getCode())) {
                                findMap.put("studyIntensityCode", "F");
                            } else {
                                findMap.put("studyIntensityCode", studyGradeType.getStudyIntensityCode());
                            }
                        }
                    }
                    newStudyGradeType = studyManager.findPlainStudyGradeType(findMap);

                    // then check current academic year for specific progress
                    // statuses
                    if (newStudyGradeType == null) {
                        if ("Y".equals(progressStatus.getIncrement()) && "N".equals(progressStatus.getCarrying())) {
                            // next ctu is possibly in the same academic year as
                            // the current studygradetype
                            newAcademicYearId = studyGradeType.getCurrentAcademicYearId();
                            if (log.isDebugEnabled()) {
                                log.debug("StudentManager.findNextStudyPlanCardinalTimeUnit: newAcademicYearId (from studygradetype) = " + newAcademicYearId);
                            }
                            // find studygradetype with this new academicyear:
                            findMap.put("studyId", studyGradeType.getStudyId());
                            findMap.put("gradeTypeCode", studyGradeType.getGradeTypeCode());
                            findMap.put("currentAcademicYearId", newAcademicYearId);
                            findMap.put("studyTimeCode", studyGradeType.getStudyTimeCode());
                            findMap.put("studyFormCode", studyGradeType.getStudyFormCode());
                            if ("Y".equals(iUseOfPartTimeStudyGradeTypes)) {
                                // find out if a switch between parttime /
                                // fulltime must be made:
                                if ((OpusConstants.PROGRESS_STATUS_TO_PARTTIME).equals(progressStatus.getCode())) {
                                    findMap.put("studyIntensityCode", "P");
                                } else {
                                    if ((OpusConstants.PROGRESS_STATUS_TO_FULLTIME).equals(progressStatus.getCode())) {
                                        findMap.put("studyIntensityCode", "F");
                                    } else {
                                        findMap.put("studyIntensityCode", studyGradeType.getStudyIntensityCode());
                                    }
                                }
                            }
                            newStudyGradeType = studyManager.findPlainStudyGradeType(findMap);
                        }
                    }

                    if (newStudyGradeType != null) {
                        findMap.put("studyPlanId", nextStudyPlanCardinalTimeUnit.getStudyPlanId());
                        findMap.put("studyGradeTypeId", newStudyGradeType.getId());
                        findMap.put("progressStatusCode", null);
                        findMap.put("cardinalTimeUnitNumber", nextStudyPlanCardinalTimeUnit.getCardinalTimeUnitNumber());
                        nextStudyPlanCardinalTimeUnit = this.findStudyPlanCardinalTimeUnitByParams(findMap);
                        if (nextStudyPlanCardinalTimeUnit != null) {
                            if (log.isDebugEnabled()) {
                                log.debug("StudentManager: find next studyPlanCardinalTimeUnit on top of last one - last one id = " + studyPlanCardinalTimeUnit.getId()
                                        + ", new one:" + nextStudyPlanCardinalTimeUnit.getId());
                            }
                        }
                    } else {
                        if (log.isDebugEnabled()) {
                            log.debug("StudentManager: no studygradetype found for params and ac year " + newAcademicYearId);
                        }
                    }

                }
            }
        }

        if (log.isDebugEnabled()) {
            if (nextStudyPlanCardinalTimeUnit == null) {
                log.debug("StudentManager.findNextStudyPlanCardinalTimeUnit: no next studyplanctu found");
            }
        }

        return nextStudyPlanCardinalTimeUnit;
    }

    @Override
    @Transactional
    public List<StudyPlanCardinalTimeUnit> findStudyPlanCardinalTimeUnitsForStudent(int studentId) {

        return studyplanCardinaltimeunitMapper.findStudyPlanCardinalTimeUnitsForStudent(studentId);
    }

    // @Override @Transactional
    // public Note findNote(int noteId, String noteType) {
    // String strNoteType = this.getNoteType(noteType);
    // return sqlSession.selectOne(Note.class.getName() + ".find" + strNoteType, noteId);
    //// return studentDao.findNote(noteId, strNoteType);
    // }
    //
    // @Override
    // @Transactional
    // public void addNote(Note note, String noteType) {
    // String strNoteType = this.getNoteType(noteType);
    // sqlSession.update(Note.class.getName() + ".add" + strNoteType);
    //// studentDao.addNote(note, strNoteType);
    // }
    //
    // @Override
    // @Transactional
    // public void updateNote(Note note, String noteType) {
    // String strNoteType = this.getNoteType(noteType);
    // sqlSession.update(Note.class.getName() + ".update" + strNoteType);
    //// studentDao.updateNote(note, strNoteType);
    // }
    //
    // @Override @Transactional
    // public void deleteNote(int noteId, String noteType) {
    // String strNoteType = this.getNoteType(noteType);
    // sqlSession.update(Note.class.getName() + ".delete" + strNoteType);
    //// studentDao.deleteNote(noteId, strNoteType);
    // }

    // ThesisSupervisor

    @Override
    @Transactional
    public void addThesisSupervisor(ThesisSupervisor thesisSupervisor) {
        thesisSupervisorMapper.addThesisSupervisor(thesisSupervisor);
    }

    @Override
    @Transactional
    public void updateThesisSupervisor(ThesisSupervisor thesisSupervisor) {
        thesisSupervisorMapper.updateThesisSupervisor(thesisSupervisor);
    }

    @Override
    @Transactional
    public void updateThesisSupervisorsPrincipal(int thesisId, String principal) {
        thesisSupervisorMapper.updateThesisSupervisorsPrincipal(thesisId, principal);
    }

    @Override
    @Transactional
    public void deleteThesisSupervisor(int thesisSupervisorId) {
        thesisSupervisorMapper.deleteThesisSupervisor(thesisSupervisorId);
    }

    @Override
    @Transactional
    public void deleteThesisSupervisorsByThesisId(int thesisId) {
        thesisSupervisorMapper.deleteThesisSupervisorsByThesisId(thesisId);
    }

    @Override
    @Transactional
    public ThesisSupervisor findThesisSupervisor(int id) {
        return thesisSupervisorMapper.findThesisSupervisor(id);
    }

    @Override
    @Transactional
    public List<ThesisSupervisor> findThesisSupervisorsByThesisId(int thesisId) {
        return thesisSupervisorMapper.findThesisSupervisorsByThesisId(thesisId);
    }

    @Override
    @Transactional
    public ThesisStatus findThesisStatus(int thesisStatusId) {

        return thesisStatusMapper.findThesisStatus(thesisStatusId);
    }

    @Override
    @Transactional
    public List<ThesisStatus> findThesisStatuses(Map<String, Object> map) {

        return thesisStatusMapper.findThesisStatuses(map);
    }

    @Override
    @Transactional
    public void addThesisStatus(ThesisStatus thesisStatus) {
        thesisStatusMapper.addThesisStatus(thesisStatus);
    }

    @Override
    @Transactional
    public void updateThesisStatus(ThesisStatus thesisStatus) {
        thesisStatusMapper.updateThesisStatus(thesisStatus);
    }

    @Override
    @Transactional
    public void deleteThesisStatus(int thesisStatusId) {
        thesisStatusMapper.deleteThesisStatus(thesisStatusId);
    }

    @Override
    @Transactional
    public void deleteThesisStatusesByThesisId(int thesisId) {
        thesisStatusMapper.deleteThesisStatusesByThesisId(thesisId);
    }

    @Override
    @Transactional
    public Penalty findPenalty(int penaltyId, String preferredLanguage) {

        Penalty penalty = null;
        penalty = penaltyMapper.findPenalty(penaltyId, preferredLanguage);

        return penalty;
    }

    @Override
    @Transactional
    public List<Penalty> findPenalties(int studentId, String preferredLanguage) {

        return penaltyMapper.findPenalties(studentId, preferredLanguage);
    }

    @Override
    @Transactional
    public void addPenalty(Penalty penalty) {
        penaltyMapper.addPenalty(penalty);
    }

    @Override
    @Transactional
    public void updatePenalty(Penalty penalty) {
        penaltyMapper.updatePenalty(penalty);
    }

    @Override
    @Transactional
    public void deletePenalty(int penaltyId) {
        penaltyMapper.deletePenalty(penaltyId);
    }

    @Override
    @Transactional
    public int findStudentIdForStudyPlanDetailId(int studyPlanDetailId) {
        return studentMapper.findStudentIdForStudyPlanDetailId(studyPlanDetailId);
    }

    @Override
    @Transactional
    public Integer findStudentsClassgroupIdForStudyPlanDetailId(int studyPlanDetailId) {
        return studentClassgroupMapper.findStudentsClassgroupIdForStudyPlanDetailId(studyPlanDetailId);
    }

    @Override
    @Transactional
    public int findStudentIdForStudyPlanCardinalTimeUnitId(int studyPlanCardinalTimeUnitId) {
        return studentMapper.findStudentIdForStudyPlanCardinalTimeUnitId(studyPlanCardinalTimeUnitId);
    }

    @Override
    @Transactional
    public int findStudentIdForStudentCode(String studentCode) {
        return studentMapper.findStudentIdForStudentCode(studentCode);
    }

    @Override
    @Transactional
    public String findStudentCodeForStudentId(int studentId) {
        return studentMapper.findStudentCodeForStudentId(studentId);
    }

    @Override
    @Transactional
    public boolean hasOtherStudyPlanCardinalTimeUnits(int studyPlanId, int studyPlanCardinalTimeUnitId) {
        boolean result = true;

        // see if there is at least one studyplanCTU with an id different than
        // the given one
        Map<String, Object> map = new HashMap<>();
        map.put("studyPlanId", studyPlanId);
        List<StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits = findStudyPlanCardinalTimeUnitsByParams(map);
        if (studyPlanCardinalTimeUnits != null) {
            for (StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit : studyPlanCardinalTimeUnits) {
                if (studyPlanCardinalTimeUnit.getId() == studyPlanCardinalTimeUnitId) {
                    result = false;
                    break;
                }
            }
        }

        return result;
    }

    @Override
    @Transactional
    public String getNextStudyIntensityCode(Lookup7 progressStatus) {
        String studyIntensityCode;

        // if (a) continuing, (b) non-incrementing and (c) carrying-selected,
        // then part-time
        if ("Y".equalsIgnoreCase(progressStatus.getContinuing()) && "N".equalsIgnoreCase(progressStatus.getIncrement()) && "S".equalsIgnoreCase(progressStatus.getCarrying())) {
            studyIntensityCode = OpusConstants.STUDY_INTENSITY_PARTTIME;
        } else {
            studyIntensityCode = OpusConstants.STUDY_INTENSITY_FULLTIME;
        }

        return studyIntensityCode;
    }

    @Override
    @Transactional
    public void setResultsPublished(List<StudyPlanCardinalTimeUnit> studyPlanCardinalTimeUnits) {
        for (StudyPlanCardinalTimeUnit spctu : studyPlanCardinalTimeUnits) {
            setResultsPublished(spctu);
        }
    }

    @Override
    @Transactional
    public void setResultsPublished(StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit) {

    	int branchId = studyplanMapper.findBranchIdForStudyPlan(studyPlanCardinalTimeUnit.getStudyPlanId());

        Date defaultResultsPublishDate = appConfigManager.getDefaultResultsPublishDate();

        boolean resultsPublished = getResultsPublished(studyPlanCardinalTimeUnit, branchId, new Date(), defaultResultsPublishDate);
        studyPlanCardinalTimeUnit.setResultsPublished(resultsPublished);
    }

    @Override
    @Transactional
    public boolean getResultsPublished(StudyPlanCardinalTimeUnit spctu, int branchId, Date date, Date defaultResultsPublishDate) {
        StudyGradeType studyGradeType = studyManager.findStudyGradeType(spctu.getStudyGradeTypeId());
        int nrOfUnitsPerYear = studyManager.findNrOfUnitsPerYearForCardinalTimeUnitCode(studyGradeType.getCardinalTimeUnitCode());
        int cardinalTimeUnitNumber = spctu.getCardinalTimeUnitNumber() % nrOfUnitsPerYear;
        if (cardinalTimeUnitNumber == 0)
            cardinalTimeUnitNumber = nrOfUnitsPerYear; // e.g. year, semester 2, trimester 3
        BranchAcademicYearTimeUnit branchAcademicYearTimeUnit = branchManager.findBranchAcademicYearTimeUnit(branchId, studyGradeType.getCurrentAcademicYearId(),
                studyGradeType.getCardinalTimeUnitCode(), cardinalTimeUnitNumber);
        Date resultVisibilityDate = branchAcademicYearTimeUnit != null ? branchAcademicYearTimeUnit.getResultsPublishDate() : defaultResultsPublishDate;
        boolean resultsPublished = !resultVisibilityDate.after(date);
        return resultsPublished;
    }

    @Override
    @Transactional
    public void fillStudentBalanceInformation(Student student) {
        if (student != null && student.getStudentBalanceInformation() == null) {
            StudentBalanceEvaluation studentBalanceEvaluation = collegeServiceExtensions.getStudentBalanceEvaluation();
            StudentBalanceInformation studentBalanceInformation = studentBalanceEvaluation.getStudentBalanceInformation(student.getStudentId());
            student.setStudentBalanceInformation(studentBalanceInformation);
            student.setHasMadeSufficientPayments(studentBalanceEvaluation.hasMadeSufficientPaymentsForRegistration(studentBalanceInformation));
        }
    }

    @Override
    @Transactional
    public String findIdentificationNumberByStudyPlanId(int studyPlanId) {
        return studentMapper.findIdentificationNumberByStudyPlanId(studyPlanId);
    }

    @Override
    @Transactional
    public List<StudyPlanDetail> extractNonExempted(List<StudyPlanDetail> studyPlanDetails) {
        List<StudyPlanDetail> nonExempted = new ArrayList<>();

        if (studyPlanDetails != null) {
            for (StudyPlanDetail sdp : studyPlanDetails) {
                if (!sdp.isExempted()) {
                    nonExempted.add(sdp);
                }
            }
        }

        return nonExempted;
    }

}
