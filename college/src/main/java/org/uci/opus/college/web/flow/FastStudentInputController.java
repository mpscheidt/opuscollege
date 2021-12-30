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

package org.uci.opus.college.web.flow;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.Address;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.SecondarySchoolSubject;
import org.uci.opus.college.domain.SecondarySchoolSubjectGroup;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.StudentUtil;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AddressManagerInterface;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudentNumberGeneratorInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.service.extpoint.CollegeServiceExtensions;
import org.uci.opus.college.validator.FastStudentInputValidator;
import org.uci.opus.college.web.form.FastStudentInputForm;
import org.uci.opus.college.web.form.person.includes.SubjectAndBlockSGTSelection;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.lookup.LookupUtil;

@Controller
@RequestMapping(value="/college/person/fastStudentInput")
public class FastStudentInputController {

    private static final String FORM = "fastStudentInputForm";
    private static Logger log = LoggerFactory.getLogger(FastStudentInputController.class);
    @Autowired private AddressManagerInterface addressManager;
    @Autowired private AppConfigManagerInterface appConfigManager;
    @Autowired private CollegeServiceExtensions collegeServiceExtensions;
    @Autowired private FastStudentInputValidator fastStudentInputValidator;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private MessageSource messageSource;
    @Autowired private OpusInit opusInit;
    @Autowired private OpusMethods opusMethods;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private SubjectManagerInterface subjectManager;

    // studentnumbergenerator must be autowired because of primary flag:
    @Autowired private StudentNumberGeneratorInterface studentNumberGenerator;

    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    // The newForm parameter is only useful when coming from elsewhere (e.g. the menu).
    // So after removing session form objects, we can remove the newForm parameter
    @RequestMapping(params = "newForm='true'")
    public String renderScreenViaGet(HttpServletRequest request, ModelMap model) {
        if (log.isDebugEnabled()) {
            log.debug("renderScreenViaGet - removing form session objects");
        }
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(FORM, session, model, opusMethods.isNewForm(request));
        return "redirect:/college/person/fastStudentInput.view";    // without newForm=true
    }
    
    @RequestMapping()   // default mapping, e.g. post after filter selection
    public String setupForm(HttpServletRequest request, ModelMap model) {
        log.debug("renderScreen");
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        
        session.setAttribute("menuChoice", "student");

        Map<String, Object> referenceDataMap = referenceData(request);
        model.addAllAttributes(referenceDataMap);

        SubjectAndBlockSGTSelection sabc = (SubjectAndBlockSGTSelection) model.get("subjectAndBlockSelection");

        if (!model.containsAttribute(FORM)) {
            if (log.isDebugEnabled()) {
                log.debug("FastStudentInput.renderscreen: no attribute fastStudentInputForm found, creating one");
            }
            Student student = StudentUtil.newStudentWithStudyPlanAndAddress();
            if (log.isDebugEnabled()) {
                if (student.getStudyPlans() != null) {
                    log.debug("fastStudentInputForm: student-studyplans size:" + student.getStudyPlans().size());
                } else {
                    log.debug("FastStudentInput.renderscreen: student-studyplans is NULL");
                }
            }
            int ouId = (Integer) session.getAttribute("organizationalUnitId");
            String newStudentCode = collegeServiceExtensions.createUniqueStudentCode(StudentNumberGeneratorInterface.KEY_SCREEN, ouId, student);
            student.setStudentCode(newStudentCode);
            FastStudentInputForm fastStudentInputForm = new FastStudentInputForm();
            fastStudentInputForm.setStudent(student);
            fastStudentInputForm.setStudentCodeWillBeGenerated(studentNumberGenerator.applies(StudentNumberGeneratorInterface.KEY_SUBMIT));

            Collection<Integer> subjectBlockStudyGradeTypeIds = null;
            boolean resetSubjectsAndSubjectBlocks = ServletUtil.getBooleanParam(request, "resetSubjectsAndSubjectBlocks", false);
            if (!resetSubjectsAndSubjectBlocks) {   // if filters changed, forget previously selected subject blocks
                subjectBlockStudyGradeTypeIds = (Collection<Integer>) session.getAttribute("subjectBlockStudyGradeTypeIds");
            }
            if (subjectBlockStudyGradeTypeIds == null) {
                // select check boxes of compulsory subject (blocks) by default
                List<SubjectBlockStudyGradeType> compulsorySubjectBlockStudyGradeTypes = sabc.getCompulsorySubjectBlockStudyGradeTypes();  // (List<SubjectBlockStudyGradeType>) referenceDataMap.get("compulsorySubjectBlockStudyGradeTypes");
                subjectBlockStudyGradeTypeIds = DomainUtil.getIds(compulsorySubjectBlockStudyGradeTypes);
            }
            fastStudentInputForm.setSubjectBlockStudyGradeTypeIds(subjectBlockStudyGradeTypeIds);

            Collection<Integer> subjectStudyGradeTypeIds = null;
            if (!resetSubjectsAndSubjectBlocks) {   // if filters changed, forget previously selected subjects
                subjectStudyGradeTypeIds = (Collection<Integer>) session.getAttribute("subjectStudyGradeTypeIds");
            }
            if (subjectStudyGradeTypeIds == null) {
                List<SubjectStudyGradeType> compulsorySubjectStudyGradeTypes = sabc.getCompulsorySubjectStudyGradeTypes(); // (List<SubjectStudyGradeType>) referenceDataMap.get("compulsorySubjectStudyGradeTypes");
                subjectStudyGradeTypeIds = DomainUtil.getIds(compulsorySubjectStudyGradeTypes);
            }
            fastStudentInputForm.setSubjectStudyGradeTypeIds(subjectStudyGradeTypeIds);

            // set max number of subjects
            int studyGradeTypeId = ServletUtil.getIntValue(session, request, "studyGradeTypeId", 0);
            if (studyGradeTypeId != 0) {
                StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyGradeTypeId);
                int maxNumberOfSubjects = studyGradeType.getMaxNumberOfSubjectsPerCardinalTimeUnit();
                if (maxNumberOfSubjects == 0) {
                    // if unspecified (= 0), then take application init parameter
                   maxNumberOfSubjects = opusInit.getMaxSubjectsPerCardinalTimeUnit();
                }
                fastStudentInputForm.setMaxNumberOfSubjects(maxNumberOfSubjects);
            }

            model.addAttribute(fastStudentInputForm);
        }
        
        return "college/person/fastStudentInput"; // point to the jsp file
    }

    // in case a student has been created, let's load the new student to give feedback
    @ModelAttribute("successfullyCreatedStudent")
    public Student populateSuccessfullyCreatedStudent(HttpServletRequest request) {
        Student student = null;
        int studentId = ServletUtil.getIntParam(request, "successfullyCreatedStudentId", 0);
        if (studentId != 0) {
            String preferredLanguage = OpusMethods.getPreferredLanguage(request);
            student = studentManager.findStudent(preferredLanguage, studentId);
        }
        return student;
    }
    
    protected Map<String, Object> referenceData(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        // due to include of inst-branch-orgunit in jsp, dependent filters do not get reset automatically with hidden inputs
        ServletUtil.assertDependentProperties(session, request, "primaryStudyId", new String[] {"institutionId", "branchId", "organizationalUnitId"});
        ServletUtil.assertDependentProperties(session, request, "academicYearId", new String[] {"institutionId", "branchId", "organizationalUnitId", "primaryStudyId"});
        ServletUtil.assertDependentProperties(session, request, "studyGradeTypeId", new String[] {"institutionId", "branchId", "organizationalUnitId", "primaryStudyId", "academicYearId"});
        ServletUtil.assertDependentProperties(session, request, "cardinalTimeUnitNumber", new String[] {"institutionId", "branchId", "organizationalUnitId", "primaryStudyId", "academicYearId", "studyGradeTypeId"});
        ServletUtil.assertDependentProperties(session, request, "classgroupId", new String[] {"institutionId", "branchId", "organizationalUnitId", "primaryStudyId", "academicYearId", "studyGradeTypeId", "cardinalTimeUnitNumber"});

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        StudentFilterBuilder fb = new StudentFilterBuilder(request, opusMethods, lookupCacher, studyManager, studentManager);
        fb.setSubjectBlockMapper(subjectBlockMapper);
        fb.initChosenValues(true);      // this remembers all filter selections in the session
        fb.doLookups();
        lookupCacher.getAddressLookups(preferredLanguage, request);
        fb.loadStudies();
        fb.loadAcademicYears();
        fb.loadStudyGradeTypes(true);
//        fb.loadSubjectBlockStudyGradeTypes();

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS for filters
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                      session, request, fb.getInstitutionTypeCode(), fb.getInstitutionId()
                                  , fb.getBranchId(), fb.getOrganizationalUnitId());

        // for easier and faster JSP rendering, make maps out of lookup lists
        LookupUtil.putCodeToDescriptionMap(request, "allGradeTypes", "allGradeTypesMap");
        LookupUtil.putCodeToDescriptionMap(request, "allStudyForms", "allStudyFormsMap");
        LookupUtil.putCodeToDescriptionMap(request, "allStudyTimes", "allStudyTimesMap");
        LookupUtil.putCodeToDescriptionMap(request, "allCardinalTimeUnits", "allCardinalTimeUnitsMap");

        // --- Build the model ---
        Map<String, Object> model = new HashMap<>();

        int studyGradeTypeId = fb.getStudyGradeTypeId();
        Integer cardinalTimeUnitNumber = fb.getCardinalTimeUnitNumber();
        SubjectAndBlockSGTSelection sabc = subjectManager.getSubjectAndBlockSGTSelection(studyGradeTypeId, cardinalTimeUnitNumber, preferredLanguage);
        model.put("subjectAndBlockSelection", sabc);

        return model;
    }

    

    // submit button clicked: let's try to create a new student and study plan
    @Transactional
    @RequestMapping(params = "action=add")
    public String processStudentSubmit(HttpServletRequest request,
            @ModelAttribute(FORM) FastStudentInputForm fastStudentInputForm,
            BindingResult result, ModelMap model, @RequestParam("previousDiplomaFile") MultipartFile previousDiplomaFile) throws IOException {
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        Student student = fastStudentInputForm.getStudent();
        if (log.isDebugEnabled()) {
            log.debug("Attempting to add student: " + student.getSurnameFull() + ", " + student.getFirstnamesFull() + "(" + student.getGenderCode() + "): " + student.getBirthdate());
        }
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        Locale currentLoc = RequestContextUtils.getLocale(request);
        String fastStudentInputError = "";
        
        int orgUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
        int primaryStudyId = ServletUtil.getIntParamSetOnSession(session, request, "primaryStudyId");
        ServletUtil.getIntParamSetOnSession(session, request, "academicYearId");
        int studyGradeTypeId = ServletUtil.getIntParamSetOnSession(session, request, "studyGradeTypeId");
        int cardinalTimeUnitNumber = ServletUtil.getIntParamSetOnSession(session, request, "cardinalTimeUnitNumber");
        int classgroupId = ServletUtil.getParamSetAttrAsInt(request, "classgroupId", 0);
        StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyGradeTypeId);
        List <SecondarySchoolSubjectGroup> secondarySchoolSubjectGroups = 
        	studyManager.findSecondarySchoolSubjectGroups(studyGradeTypeId, preferredLanguage);
        if (secondarySchoolSubjectGroups == null) {
            Study study = studyManager.findStudy(primaryStudyId);
            
            // Would it be possible to use the normal validation mechanism to display this error messages?
            
            fastStudentInputError = study.getStudyDescription() + "/" + studyGradeType.getGradeTypeDescription() + 
                    " (" + studyGradeType.getCurrentAcademicYearId() + ")"
                    + messageSource.getMessage("jsp.error.secondaryschoolsubject.missing", null, currentLoc);
            request.setAttribute("fastStudentInputError", fastStudentInputError);
            
        }
        if (secondarySchoolSubjectGroups != null) {
            if (student.getStudyPlans() != null) {
                if (log.isDebugEnabled()) {
                    log.debug("student.getStudyPlans() filled"); 
                }
                // add the secondarySchoolSubjectGroups to the studyplan of the student
                student.getStudyPlans().get(0).setSecondarySchoolSubjectGroups(secondarySchoolSubjectGroups);
            } else {
                if (log.isDebugEnabled()) {
                    log.debug("FastStudentInput: student.getStudyPlans() empty"); 
                }
            }
        }
        
        // prepare for validation and validate
        StudentUtil.setDefaultValues(student);      // DB expects certain values to be non-null
        student.setPrimaryStudyId(primaryStudyId);
        student.addStudentStudentStatus(new Date(), "1");
        student.setPersonCode(StringUtil.createUniqueCode("P", "" + orgUnitId));

        fastStudentInputValidator.validate(fastStudentInputForm, result);        // validate fields
        
        // calculate total number of subjects in this cardinaltimeunit (for maximum values):
        Set<Integer> allSelectedSubjectIds = new HashSet<>();
        for (int sbsgtId : fastStudentInputForm.getSubjectBlockStudyGradeTypeIds()) {
            SubjectBlockStudyGradeType sbsgt = subjectBlockMapper.findSubjectBlockStudyGradeType(sbsgtId, preferredLanguage);
            List<Subject> subjects = subjectBlockMapper.findSubjectsForSubjectBlock(sbsgt.getSubjectBlock().getId());
            for (Subject s : subjects) {
                allSelectedSubjectIds.add(s.getId());
            }
        }
        for (int ssgtId : fastStudentInputForm.getSubjectStudyGradeTypeIds()) {
            SubjectStudyGradeType ssgt = subjectManager.findSubjectStudyGradeType(preferredLanguage, ssgtId);
            allSelectedSubjectIds.add(ssgt.getSubjectId());
        }
        if (allSelectedSubjectIds.size() > fastStudentInputForm.getMaxNumberOfSubjects()) {
            result.reject("jsp.error.maxnumber.subjects.exceeded");
        }

        // validate previous diploma (if one has been chosen)
        if (!previousDiplomaFile.isEmpty()) {

            // validate if previous diploma file is too big
            int maxUploadSizeImage = appConfigManager.getMaxUploadSizeImage();
            if (previousDiplomaFile.getSize() > maxUploadSizeImage) {
                result.rejectValue("student.previousInstitutionDiplomaPhotograph", "invalid.uploadsize", new Object[] {maxUploadSizeImage}, null);
            }

            // validate file type
            List<String> imageMimeTypes = OpusMethods.getImageMimeTypes(session);
            List<String> docMimeTypes = OpusMethods.getDocMimeTypes(session);
            String previousDiplomaContentType = previousDiplomaFile.getContentType();
            if (!imageMimeTypes.contains(previousDiplomaContentType) &&
                    !docMimeTypes.contains(previousDiplomaContentType)) {
                result.rejectValue("student.previousInstitutionDiplomaPhotograph", "invalid.doctype.format");
            }
        }

        // we need the studyplan for the secondaryschool subjectgroups
        StudyPlan studyPlan;
        if (student.getStudyPlans() != null) {
            studyPlan = student.getStudyPlans().get(0);
        } else {
            // this case of empty student.getStudyPlans() only occurs if no
            // studyPlan property is bound in the JSP (e.g. application number)
            studyPlan = new StudyPlan();
        }
        
        // check validity secondary school subjects before adding student:
        if (!"Y".equals(student.getForeignStudent()) 
            && studyPlan.getSecondarySchoolSubjectGroups() != null 
                && studyPlan.getSecondarySchoolSubjectGroups().size() > 0) {
            
            List < SecondarySchoolSubject > compareSubjects = new ArrayList<>();
            
            for (SecondarySchoolSubjectGroup subjectGroup : studyPlan.getSecondarySchoolSubjectGroups()) {
                if (subjectGroup.getSecondarySchoolSubjects() != null 
                      && subjectGroup.getSecondarySchoolSubjects().size() > 0) { 
                    compareSubjects.addAll(subjectGroup.getSecondarySchoolSubjects());
                }
            }
            if (compareSubjects.size() != 0) {      
                for (SecondarySchoolSubject checkSubject : compareSubjects) {
                    if (!StringUtil.isNullOrEmpty(checkSubject.getGrade(), true) 
                            && !"0".equals(checkSubject.getGrade())) {
                        int countSubject = 0;
                        for (SecondarySchoolSubject compareSubject : compareSubjects) {
                            if (!StringUtil.isNullOrEmpty(compareSubject.getGrade(), true) 
                                    && !"0".equals(compareSubject.getGrade())) {
                                if (checkSubject.getId() == compareSubject.getId()) {
                                    countSubject = countSubject + 1;
                                }
                            }
                        }
                        if (countSubject > 1) {
//                          dbValidationError = dbValidationError + (
//                                    student.getStudentCode() + ". "
//                                 + messageSource.getMessage(
//                                     "jsp.error.student.edit", null, currentLoc)
//                                 + messageSource.getMessage(
//                                    "jsp.error.secondaryschoolsubject.already.graded", null, currentLoc)
//                             );
                            result.reject("jsp.error.student.edit");
                            result.reject("jsp.error.secondaryschoolsubject.already.graded");
                            break;
                        }                           
                    }
                }
            }
        }

        // create student number and do existence check of student (if no validation errors occured yet)
        if (!result.hasErrors()) {

            // create a student number if student number has been left empty (the number will be validated on uniqueness)
            if (StringUtil.isNullOrEmpty(student.getStudentCode())) {
//                    String studentCode = studentNumberGenerator.createUniqueStudentNumberOnSubmit(orgUnitId, student);
                    String studentCode = collegeServiceExtensions.createUniqueStudentCode(StudentNumberGeneratorInterface.KEY_SUBMIT, orgUnitId, student);
                    student.setStudentCode(studentCode);
            }

            String dbValidationError = studentManager.validateNewStudent(student, currentLoc);   // validate if student already exists
    
            if (dbValidationError != null && !dbValidationError.isEmpty()) {
                result.reject(dbValidationError);
            }
            
        }
        
        // All validation before here!
        // In case of validation errors, no redirect
        
        if (result.hasErrors() || !"".equals(fastStudentInputError)) {
            return setupForm(request, model);
        }
        
        // put the diploma image into the Student object
        if (!previousDiplomaFile.isEmpty()) {
            student.setPreviousInstitutionDiplomaPhotograph(previousDiplomaFile.getBytes());
            student.setPreviousInstitutionDiplomaPhotographName(previousDiplomaFile.getName());
            student.setPreviousInstitutionDiplomaPhotographMimeType(previousDiplomaFile.getContentType());
        }

        // -- prepare for storage --
        // then create the opus user objects
        OpusUserRole studentOpusUserRole = new OpusUserRole();
        studentOpusUserRole.setRole("student");
        OpusUser studentOpusUser = new OpusUser();
        studentOpusUser.setLang(appConfigManager.getAppLanguages().get(0));
        studentOpusUser.setPreferredOrganizationalUnitId(orgUnitId);

    	// store new student
//    	if (StringUtil.isNullOrEmpty(dbValidationError)) {   // we should never come here in case of any errors! 
    	
        String writeWho = opusMethods.getWriteWho(request);
        student.setWriteWho(writeWho);
        student.setStudentWriteWho(writeWho);
        
    	studentManager.addStudent(student, studentOpusUserRole, studentOpusUser);

        // load student again, to get the newly assigned id
//        student = studentManager.findStudentByCode(student.getStudentCode());
        
        int studyPlanId = addStudyPlanToStudent(student, studyGradeTypeId, cardinalTimeUnitNumber,
                fastStudentInputForm.getSubjectBlockStudyGradeTypeIds(),
                fastStudentInputForm.getSubjectStudyGradeTypeIds(),
                studyPlan.getApplicationNumber(), request);
        // test if there are enough subjects so the correct number can be graded
        // GradedSecondarySchoolSubjects
        if (!"Y".equals(student.getForeignStudent()) 
        		&& studyPlan.getSecondarySchoolSubjectGroups() != null 
        		&& studyPlan.getSecondarySchoolSubjectGroups().size() > 0) {
        	log.info("Store secondary school subjects with student");
        	for (SecondarySchoolSubjectGroup subjectGroup : studyPlan.getSecondarySchoolSubjectGroups()) {
                if (subjectGroup.getSecondarySchoolSubjects() != null 
                      && subjectGroup.getSecondarySchoolSubjects().size() > 0) { 
                    for (SecondarySchoolSubject subject : subjectGroup.getSecondarySchoolSubjects()) {
                        if (!StringUtil.isNullOrEmpty(subject.getGrade(), true) 
                        		&& !"0".equals(subject.getGrade())) {
                            // add gradedSecondarySchoolSubject
                        	studyManager.addGradedSecondarySchoolSubject(subject, studyPlanId, subjectGroup.getId(), writeWho);
                        }
                    }
                }
            }
        }
        
        // the address needs to be stored extra
        Address address = student.getAddresses().get(0);
        if(!StringUtil.isNullOrEmpty(address.getEmailAddress(), true) || !StringUtil.isNullOrEmpty(address.getTelephone(), true)) {
            address.setPersonId(student.getPersonId());
            StudentUtil.setDefaultValues(address);
            addressManager.addAddress(address);
        }
        
        // optional: add student to classgroup
        if (classgroupId != 0) {
            studyManager.addStudentClassgroup(student.getStudentId(), classgroupId, writeWho);
        }

        log.info("Successfully stored new student: '" + student.getSurnameFull() + ", " + student.getFirstnamesFull() + "': " + student.getStudentId());

        // we don't want to loose the info on selected subject blocks and subjects -> store in session
        session.setAttribute("subjectBlockStudyGradeTypeIds", fastStudentInputForm.getSubjectBlockStudyGradeTypeIds());
        session.setAttribute("subjectStudyGradeTypeIds", fastStudentInputForm.getSubjectStudyGradeTypeIds());
        
        String view = "redirect:/college/person/fastStudentInput.view?newForm=false";
        view += "&successfullyCreatedStudentId=" + student.getStudentId();
        return view; 
    }

    private int addStudyPlanToStudent(Student student, int studyGradeTypeId,
            int cardinalTimeUnitNumber,
            Collection<Integer> subjectBlockStudyGradeTypeIds,
            Collection<Integer > subjectStudyGradeTypeIds, 
            int applicationNumber,
            HttpServletRequest request) {
        
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        //set up new study plan for student
        String writeWho = opusMethods.getWriteWho(request);
    	StudyPlan studyPlan = new StudyPlan();
        int studentId = student.getStudentId();
        StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyGradeTypeId, preferredLanguage);
        String studyPlanDescription = studyGradeType.getStudyDescription() + " - " + studyGradeType.getGradeTypeDescription();
        
        studyPlan.setActive("Y");
        studyPlan.setStudentId(studentId);
        studyPlan.setStudyId(studyGradeType.getStudyId());
        studyPlan.setGradeTypeCode(studyGradeType.getGradeTypeCode());
        studyPlan.setStudyPlanDescription(studyPlanDescription);
        studyPlan.setStudyPlanStatusCode(appConfigManager.getAdmissionInitialStudyPlanStatus());
        studyPlan.setApplicationNumber(applicationNumber);
        //add study plan to the database , so it will be assigned an id
        studentManager.addStudyPlanToStudent(studyPlan, writeWho);
        
		//as this is a new student he/she has only one study plan
        studyPlan = studentManager.findStudyPlansForStudent(studentId).get(0);

        // set up an initial studyPlanCTU
        StudyPlanCardinalTimeUnit studyPlanCTU = new StudyPlanCardinalTimeUnit();
        studyPlanCTU.setActive("Y");
        studyPlanCTU.setTuitionWaiver("N");
        studyPlanCTU.setCardinalTimeUnitNumber(cardinalTimeUnitNumber);
        studyPlanCTU.setStudyGradeTypeId(studyGradeTypeId);
        studyPlanCTU.setStudyPlanId(studyPlan.getId());
        studyPlanCTU.setCardinalTimeUnitStatusCode(
                appConfigManager.getCntdRegistrationInitialCardinalTimeUnitStatus());
        studyPlanCTU.setStudyIntensityCode(OpusConstants.STUDY_INTENSITY_FULLTIME);
        studentManager.addStudyPlanCardinalTimeUnit(studyPlanCTU, null, request);
        
        // we need the newly assigned id, so let's load the new record
        studyPlanCTU = studentManager.findStudyPlanCardinalTimeUnitByParams(
                studyPlanCTU.getStudyPlanId(),
                studyPlanCTU.getStudyGradeTypeId(),
                studyPlanCTU.getCardinalTimeUnitNumber());

        //set up new study plan details for each selected subject block and subject
        for (int sbsgtId: subjectBlockStudyGradeTypeIds) {
            StudyPlanDetail studyPlanDetail = new StudyPlanDetail();
            studyPlanDetail.setActive("Y");
            studyPlanDetail.setStudyPlanId(studyPlan.getId());
            SubjectBlockStudyGradeType sbsgt = subjectBlockMapper.findSubjectBlockStudyGradeType(sbsgtId, preferredLanguage);
            studyPlanDetail.setSubjectBlockId(sbsgt.getSubjectBlock().getId());
            studyPlanDetail.setStudyPlanCardinalTimeUnitId(studyPlanCTU.getId());
            studyPlanDetail.setStudyGradeTypeId(studyPlanCTU.getStudyGradeTypeId());
            studentManager.addStudyPlanDetail(studyPlanDetail, request);

        }
        for (int ssgtId: subjectStudyGradeTypeIds) {
            StudyPlanDetail studyPlanDetail = new StudyPlanDetail();
            studyPlanDetail.setActive("Y");
            studyPlanDetail.setStudyPlanId(studyPlan.getId());
            SubjectStudyGradeType sbsgt = subjectManager.findSubjectStudyGradeType(preferredLanguage, ssgtId);

            // the subject may already be included in one of the above added subject blocks, so filter out
            if (studentManager.existStudyPlanDetail(studyPlan.getId(), sbsgt.getSubjectId())) {
                log.info("Subject with id = " + sbsgt.getSubjectId() + " ignored, because it is included in one of the assigned subject blocks in the same study plan with id = " + studyPlan.getId());
            } else {
                studyPlanDetail.setSubjectId(sbsgt.getSubjectId());
                studyPlanDetail.setStudyPlanCardinalTimeUnitId(studyPlanCTU.getId());
                studyPlanDetail.setStudyGradeTypeId(studyPlanCTU.getStudyGradeTypeId());
                studentManager.addStudyPlanDetail(studyPlanDetail, request);

            }
        }
        
	    if (log.isDebugEnabled()) {
	       log.debug("FastStudentInput - studyplandetails added");
	    }

        return studyPlan.getId();
    }

}
