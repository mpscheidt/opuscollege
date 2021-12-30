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

package org.uci.opus.college.web.flow.person;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.AdmissionRegistrationConfig;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.Rfc;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.SubjectAndBlockCompilation;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.service.RfcManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.StudySettings;
import org.uci.opus.college.web.form.SubscribeToSubjectsFilterForm;
import org.uci.opus.college.web.form.SubscribeToSubjectsForm;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.lookup.LookupUtil;

@Controller
@RequestMapping(value = "/college/person/subscribeToSubjects")
@SessionAttributes("filterForm")
public class SubscribeToSubjectsController {

    Logger log = LoggerFactory.getLogger(SubscribeToSubjectsController.class);
    @Autowired private AppConfigManagerInterface appConfigManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private OpusInit opusInit;
    @Autowired private OpusMethods opusMethods;
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private ResultManagerInterface resultManager;
    @Autowired private RfcManagerInterface rfcManager;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private SubjectManagerInterface subjectManager;

    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    @RequestMapping(params = "action=filter")
    public String processFilterPost(HttpServletRequest request,
            @ModelAttribute("filterForm") SubscribeToSubjectsFilterForm filterForm, ModelMap model) throws ParseException {
        return setupForm(request, filterForm, model);
    }

    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) throws ParseException {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject("filterForm", session, model, opusMethods.isNewForm(request));
        session.setAttribute("menuChoice", "student");

        // initialize new filter form
        SubscribeToSubjectsFilterForm filterForm = (SubscribeToSubjectsFilterForm) model.get("filterForm");
        if (filterForm == null) {
            filterForm = new SubscribeToSubjectsFilterForm();
    
            // Students typically will want to see the result of the approval / reject process
            // whereas the approver will want to hide those that have been dealt with
            boolean showProcessed = !request.isUserInRole("APPROVE_SUBJECT_SUBSCRIPTIONS");
            filterForm.setShowProcessed(ServletUtil.getBooleanValue(session, request, "showProcessed", showProcessed));
            model.addAttribute("filterForm", filterForm);
        }
        
        return setupForm(request, filterForm, model);
    }

    private String setupForm(HttpServletRequest request, SubscribeToSubjectsFilterForm filterForm, ModelMap model) throws ParseException {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
//        opusMethods.removeSessionFormObject("filterForm", session, opusMethods.isNewForm(request));

        StudentFilterBuilder fb = dealWithFilters(request, filterForm);
        getLookups(fb.getStudyGradeTypeId(), request, model);

        // for easier and faster JSP rendering, make maps out of lookup lists
        LookupUtil.putCodeToDescriptionMap(request, "allGradeTypes", "allGradeTypesMap");
        LookupUtil.putCodeToDescriptionMap(request, "allStudyForms", "allStudyFormsMap");
        LookupUtil.putCodeToDescriptionMap(request, "allStudyTimes", "allStudyTimesMap");
        LookupUtil.putCodeToDescriptionMap(request, "allCardinalTimeUnits", "allCardinalTimeUnitsMap");
        LookupUtil.putCodeToDescriptionMap(request, "allProgressStatuses", "allProgressStatusesMap");

        // get list of all available subjects and blocks of selected CTU
        SubjectAndBlockCompilation allSubjectsAndBlocks = getSubjectsAndBlocks(request, fb);
        filterForm.setAllSubjectsAndBlocks(allSubjectsAndBlocks);

        // default subjects and blocks are simply the compulsory ones
        List<Integer> defaultSubjectBlockIds = DomainUtil.getIds(allSubjectsAndBlocks.getCompulsorySubjectBlocks());
        List<Integer> defaultSubjectIds = DomainUtil.getIds(allSubjectsAndBlocks.getCompulsorySubjects());
        filterForm.setDefaultSubjectBlockIds(defaultSubjectBlockIds);
        filterForm.setDefaultSubjectIds(defaultSubjectIds);

        // if all mandatory filters have been chosen, get the list of students
        if (fb.getCardinalTimeUnitNumber() != null) {
            Map<String, Object> parameterMap = new HashMap<>();
//            parameterMap.put("studyId", fb.getPrimaryStudyId());
            parameterMap.put("studyGradeTypeId", fb.getStudyGradeTypeId());
            parameterMap.put("cardinalTimeUnitNumber", fb.getCardinalTimeUnitNumber());
            parameterMap.put("studyplanStatusCode", OpusConstants.STUDYPLAN_STATUS_APPROVED_ADMISSION);

            // Decide which students with which CTU status shall be retrieved from the database
            List<String> statusesToLoad = getCTUStatusesToLoad(request, filterForm.isShowProcessed());
            if (statusesToLoad.isEmpty()) {
                throw new IllegalStateException("No statuses to load - this should never happen");
            }
            parameterMap.put("cardinalTimeUnitStatusCodes", statusesToLoad);

            List<? extends Lookup> allAvailableCardinalTimeUnitStatuses = getCTUStatusesToShow(request);
            request.setAttribute("availableCardinalTimeUnitStatuses", allAvailableCardinalTimeUnitStatuses);

            // if only one status is available, preselect that status for the user
//            String defaultCardinalTimeUnitStatus = "";
//            if (allAvailableCardinalTimeUnitStatuses.size() == 1) {
//                defaultCardinalTimeUnitStatus = allAvailableCardinalTimeUnitStatuses.get(0).getCode();
//            }

            // are the privileges limited to the subscription of one particular student (the current user)
            if (request.isUserInRole("CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL") 
                    && !request.isUserInRole("CREATE_STUDYPLANDETAILS_PENDING_APPROVAL")) {
                OpusUser opusUser = opusMethods.getOpusUser();
                parameterMap.put("personId", opusUser.getPersonId());
            }

            parameterMap.put("preferredPersonSorting", opusInit.getPreferredPersonSorting());
            List<Student> allStudents = studentManager.findStudentsWithCTUAndSubjectResults(parameterMap);

            // get eligible subjects map: eligible subjects -> list of students
            Map<StudentGroup, List<Student>> studentGroupToStudentsMap = getStudentGroupToStudentsMap(allSubjectsAndBlocks, allStudents);
            model.addAttribute("studentGroupToStudentsMap", studentGroupToStudentsMap);

            // we need a form object for each tab
            int i = 0;
            for (Map.Entry<StudentGroup, List<Student>> entry: studentGroupToStudentsMap.entrySet()) {
                StudentGroup studentGroup = entry.getKey();

                String formName = "subscribeToSubjectsForm" + i;
                SubscribeToSubjectsForm form;
                if (model.containsAttribute(formName)) {
                    form = (SubscribeToSubjectsForm) model.get(formName);
                } else {
                    form = new SubscribeToSubjectsForm();
                    model.addAttribute(formName, form);

                    initFormValues(form, defaultSubjectBlockIds, defaultSubjectIds, studentGroup, entry.getValue());
                }

                i++;
            }
        }

        // if filter elements selected, then check for registration periods
        AdmissionRegistrationConfig admissionRegistrationConfig = null;
        if (fb.getOrganizationalUnitId() != 0 && fb.getAcademicYearId() != 0) {
        	admissionRegistrationConfig = organizationalUnitManager
                    .findAdmissionRegistrationConfig(fb.getOrganizationalUnitId(), fb.getAcademicYearId(), true);
        }
        if (admissionRegistrationConfig != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");      
            Date todayWithoutTime = sdf.parse(sdf.format(new Date()));
            if (todayWithoutTime.compareTo(admissionRegistrationConfig.getStartOfRegistration()) < 0 ||
                    todayWithoutTime.compareTo(admissionRegistrationConfig.getEndOfRegistration()) > 0) {
                model.put("outsideRegistrationPeriod", true);
            }
        }
        model.put("admissionRegistrationConfig", admissionRegistrationConfig);
        
        return "college/person/subscribeToSubjects"; // point to the jsp file
    }

    /**
     * Depending on the user's privileges, decide which studyplanCTUs with which
     * CTU statuses shall be loaded.
     * 
     * @param request
     * @param showProcessed
     * @return
     */
    private List<String> getCTUStatusesToLoad(HttpServletRequest request, boolean showProcessed) {

    	if (log.isDebugEnabled()) {
	        log.debug("getUserPrincipal = " + request.getUserPrincipal());
	        log.debug("request.isUserInRole(CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL) = " + request.isUserInRole("CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL"));
	        log.debug("request.isUserInRole(CREATE_STUDYPLANDETAILS_PENDING_APPROVAL) = " + request.isUserInRole("CREATE_STUDYPLANDETAILS_PENDING_APPROVAL"));
	        log.debug("request.isUserInRole(APPROVE_SUBJECT_SUBSCRIPTIONS) = " + request.isUserInRole("APPROVE_SUBJECT_SUBSCRIPTIONS"));
    	}

        List<String> statusesToLoad = new ArrayList<>();
        if (request.isUserInRole("CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL")
                || request.isUserInRole("CREATE_STUDYPLANDETAILS_PENDING_APPROVAL")) {
            statusesToLoad.add(OpusConstants.CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME);
            statusesToLoad.add(OpusConstants.CARDINALTIMEUNIT_STATUS_REQUEST_FOR_CHANGE);
            if (showProcessed) {
                statusesToLoad.add(OpusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED);
                statusesToLoad.add(OpusConstants.CARDINALTIMEUNIT_STATUS_WAITING_FOR_APPROVAL_OF_REGISTRATION);
                statusesToLoad.add(OpusConstants.CARDINALTIMEUNIT_STATUS_REJECTED_REGISTRATION);
            }
        }
        if (request.isUserInRole("APPROVE_SUBJECT_SUBSCRIPTIONS")) {
            statusesToLoad.add(OpusConstants.CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME);
            statusesToLoad.add(OpusConstants.CARDINALTIMEUNIT_STATUS_WAITING_FOR_APPROVAL_OF_REGISTRATION);
            if (showProcessed) {
                statusesToLoad.add(OpusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED);
//                statusesToLoad.add(OpusConstants.CARDINALTIMEUNIT_STATUS_WAITING_FOR_APPROVAL_OF_REGISTRATION);
                statusesToLoad.add(OpusConstants.CARDINALTIMEUNIT_STATUS_REJECTED_REGISTRATION);
                statusesToLoad.add(OpusConstants.CARDINALTIMEUNIT_STATUS_REQUEST_FOR_CHANGE);
            }
        }
        return statusesToLoad;
    }

    /**
     * Get the list of statuses that the user can choose from to decide the next
     * status.
     * 
     * @param request
     * @return
     */
    private List<? extends Lookup> getCTUStatusesToShow(HttpServletRequest request) {

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        List<? extends Lookup> allCardinalTimeUnitStatuses = lookupCacher.getAllCardinalTimeUnitStatuses(preferredLanguage);

        // Set to avoid duplicates
        Collection<String> statusCodes = new HashSet<>();

        if (request.isUserInRole("CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL")
                || request.isUserInRole("CREATE_STUDYPLANDETAILS_PENDING_APPROVAL")) {
            statusCodes.add(OpusConstants.CARDINALTIMEUNIT_STATUS_WAITING_FOR_APPROVAL_OF_REGISTRATION);
        }
        if (request.isUserInRole("APPROVE_SUBJECT_SUBSCRIPTIONS")) {
            statusCodes.add(OpusConstants.CARDINALTIMEUNIT_STATUS_REQUEST_FOR_CHANGE);
            statusCodes.add(OpusConstants.CARDINALTIMEUNIT_STATUS_REJECTED_REGISTRATION);
            statusCodes.add(OpusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED);
        }

        List<? extends Lookup> availableCardinalTimeUnitStatuses = LookupUtil.getSubSet(allCardinalTimeUnitStatuses, statusCodes);
        return availableCardinalTimeUnitStatuses;
    }

    private void initFormValues(SubscribeToSubjectsForm form,
            Collection<Integer> defaultSubjectBlockIds,
            Collection<Integer> defaultSubjectIds,
            StudentGroup studentGroup, List<Student> students) {
        // initialize each form with previously selected subjects and subject blocks
        List<Integer> subjectBlockIds;
        List<Integer> subjectIds;

        // subscribed subject blocks and subjects are those that are already in the study plan
        Set<Integer> subscribedSubjectBlockIds = studentGroup.getSubscribedSubjectBlockIds();
        Set<Integer> subscribedSubjectIds = studentGroup.getSubscribedSubjectIds();

        if (subscribedSubjectBlockIds != null && !subscribedSubjectBlockIds.isEmpty()
                || subscribedSubjectIds != null && !subscribedSubjectIds.isEmpty()) {
            subjectBlockIds = new ArrayList<>(subscribedSubjectBlockIds);
            subjectIds =  new ArrayList<>(subscribedSubjectIds);
        } else {
            // if no previous selections have been made, set default selections to compulsory subject blocks and subjects
            // but only select not-yet-passed subjects and blocks in which no subject was passed yet
            subjectBlockIds = new ArrayList<>();
            subjectIds = new ArrayList<>();
            
            if (defaultSubjectBlockIds != null) {
                for (int sbid : defaultSubjectBlockIds) {
                    if (!studentGroup.hasPassedAnySubject(sbid)) {
                        subjectBlockIds.add(sbid);
                    }
                }
            }
            if (defaultSubjectIds != null) {
                for (int subjectId : defaultSubjectIds) {
                    if (!studentGroup.hasPassed(subjectId)) {
                        subjectIds.add(subjectId);
                    }
                }
            }
        }

        // now tell the forms about the subject blocks and subjects that shall be preselected
        form.setSubjectBlockIds(subjectBlockIds);
        form.setSubjectIds(subjectIds);
        
        // preselect all students in the form, and set rfc comments
        for (Student student: students) {
            StudyPlanCardinalTimeUnit spctu = student.getStudyPlans().get(0).getStudyPlanCardinalTimeUnits().get(0);
            form.getSelectedStudyPlanCTUIds().add(spctu.getId());
            if (spctu.getLatestRfc() != null) {
                form.getRfcComments().put(spctu.getId(), spctu.getLatestRfc().getComments());
                form.getRfcTexts().put(spctu.getId(), spctu.getLatestRfc().getText());
            }
        }

        // set status code to db value if exists
        form.setCardinalTimeUnitStatusCode(studentGroup.getCardinalTimeUnitStatusCode());
        
        // possibly set default CTU status code
//        if (form.getCardinalTimeUnitStatusCode() == null 
//                || form.getCardinalTimeUnitStatusCode().isEmpty()
//                || "0".equals(form.getCardinalTimeUnitStatusCode())) {
//            form.setCardinalTimeUnitStatusCode(defaultStudyPlanCardinalTimeUnitStatus);
//        }
    }

    /**
     * Determine which student is eligible to choose which subjects and subject blocks.
     * 
     * @param allSubjectsAndBlocks
     * @param allStudents
     * @return
     */
    private Map<StudentGroup, List<Student>> getStudentGroupToStudentsMap(SubjectAndBlockCompilation allSubjectsAndBlocks, List<Student> allStudents) {

        Map<StudentGroup, List<Student>> map = new TreeMap<>(new StudentGroupComparator());

        Collection<Subject> standardSubjects = allSubjectsAndBlocks.getAllSubjectsInclBlocks();
        Collection<SubjectBlock> standardSubjectBlocks = allSubjectsAndBlocks.getAllSubjectBlocks();
        Collection<Integer> standardSubjectIds = DomainUtil.getIds(standardSubjects);

        for (Student student : allStudents) {
            StudentGroup studentGroup = new StudentGroup();
            studentGroup.studentCode = student.getStudentCode();
            
            // Make a copy of the subjects, because it can be different for every studentGroup
            Collection<Subject> allSubjects = new HashSet<>(standardSubjects);

//            Collection<Integer> passedSubjectIds = getPassedSubjectIds(allSubjectIds, student);
            StudyPlan studyPlan = student.getStudyPlans().get(0);
            StudyPlanCardinalTimeUnit studyPlanCTU = studyPlan.getStudyPlanCardinalTimeUnits().get(0);
            
            // We want to know if subjects were passed in previous time units, not in the current one
            // When looking at historic data, there would be unnecessary groupings because of different set of passed subjects in the current time unit
            List<Subject> passedSubjects = resultManager.findPassedSubjects(studyPlan.getId(), standardSubjectIds, studyPlanCTU.getId());
            studentGroup.setPassedSubjects(passedSubjects);

            // check for subject blocks and subjects that have already been subscribed to
            for (StudyPlanDetail sdp: studyPlanCTU.getStudyPlanDetails()) {
                if (sdp.getSubjectId() != 0) {
                    studentGroup.addSubscribedSubjectId(sdp.getSubjectId());
                }
                if (sdp.getSubjectBlockId() != 0) {
                    studentGroup.addSubscribedSubjectBlockId(sdp.getSubjectBlockId());
                }
            }

            // Find non-curricular subjects: these subjects not defined in the curriculum as compulsory/elective, but students are subscribed to it anyway
            // This is not supposed to happen and is mainly to show to the user about these subscribed subjects, so that the study plan can be corrected
            // It may be the result of data migration where the data is not perfect
            List<Integer> outerCurricularSubjectIds = new ArrayList<>(studentGroup.getSubscribedSubjectIds());
            outerCurricularSubjectIds.removeAll(standardSubjectIds);
            if (!outerCurricularSubjectIds.isEmpty()) {
                List<Subject> outerCurricularSubjects = subjectManager.findSubjects(outerCurricularSubjectIds);
                studentGroup.setOuterCurricularSubjects(outerCurricularSubjects);
                allSubjects.addAll(outerCurricularSubjects);
            }

            studentGroup.setAllSubjects(allSubjects);
            studentGroup.setAllSubjectBlocks(standardSubjectBlocks);

            // take over ctu status code
            studentGroup.setCardinalTimeUnitStatusCode(studyPlanCTU.getCardinalTimeUnitStatusCode());
            
            // add the student to "his kind" of students who have passed the same subjects
            List<Student> sameKindOfStudents = map.get(studentGroup);
            if (sameKindOfStudents == null) {
                sameKindOfStudents = new ArrayList<>();
                map.put(studentGroup, sameKindOfStudents);
            }
            sameKindOfStudents.add(student);

        }

        return map;
    }

    /**
     * Find the subjects that the given student has successfully passed.
     * 
     * @param allSubjectIds
     * @param student
     * @return
     */
//    protected Collection<Integer> getPassedSubjectIds(Collection<Integer> allSubjectIds, Student student) {
//
//        Collection<Integer> subjectIds = new ArrayList<Integer>();
//        if (allSubjectIds == null || allSubjectIds.isEmpty()) return subjectIds; // an empty subject id collection would omit 'equivalentSubjectIds' sql clause
//
//        // get all subject results that student has passed
//        Map<String, Object> map = new HashMap<String, Object>();
//        map.put("studentId", student.getStudentId());
//        map.put("equivalentSubjectIds", allSubjectIds);
//        map.put("passed", "Y");
//        List<SubjectResult> subjectResults = resultManager.findSubjectResultsForStudent(map);
//
//        // extract subject ids from passed subjects
//        for (SubjectResult sr : subjectResults) {
//            if ("Y".equalsIgnoreCase(sr.getPassed())) {
//                subjectIds.add(sr.getSubjectId());
//            }
//        }
//
//        return subjectIds;
//    }

    private void getLookups(int studyGradeTypeId, 
    				HttpServletRequest request, ModelMap model) {
        
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
        lookupCacher.getAddressLookups(preferredLanguage, request);
        lookupCacher.getStudyPlanLookups(preferredLanguage, request);
        lookupCacher.getAllRfcStatuses(preferredLanguage, request);

		List < ? extends Lookup > allCardinalTimeUnitStatuses = null;
		allCardinalTimeUnitStatuses = lookupCacher.getAllCardinalTimeUnitStatuses(preferredLanguage);
        // filter cardinaltimeunitstatuses for part time students:
        if (studyGradeTypeId != 0 && allCardinalTimeUnitStatuses != null) {
        	StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyGradeTypeId);
        	if (OpusConstants.STUDY_INTENSITY_PARTTIME.equals(studyGradeType.getStudyIntensityCode())) {
        		int positionOfCustomizeProgramme = 0;
        		// remove 'customize programme:
                for (int i = 0; i < allCardinalTimeUnitStatuses.size();i++) {
                	if (OpusConstants.CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME.equals(
                			allCardinalTimeUnitStatuses.get(i).getCode())) {
                		positionOfCustomizeProgramme = i;
                		break;
                	}
                }
                allCardinalTimeUnitStatuses.remove(positionOfCustomizeProgramme);
                request.setAttribute("allCardinalTimeUnitStatuses", allCardinalTimeUnitStatuses);
        	}
        }
        model.addAttribute("codeToCardinalTimeUnitStatusMap", new CodeToLookupMap(allCardinalTimeUnitStatuses));
    }
    
    private StudentFilterBuilder dealWithFilters(HttpServletRequest request,
            SubscribeToSubjectsFilterForm filterForm) {
        HttpSession session = request.getSession(false);

        StudentFilterBuilder fb = new StudentFilterBuilder(request, opusMethods, lookupCacher, studyManager, studentManager);
        fb.setSubjectBlockMapper(subjectBlockMapper);

        // create filter objects and initialize with request/session values
        Organization organization = filterForm.getOrganization();
        if (organization == null) {
            organization = new Organization();
            filterForm.setOrganization(organization);
            opusMethods.fillOrganization(session, request, organization);
        }
        StudySettings studySettings = filterForm.getStudySettings();
        if (studySettings == null) {
            studySettings = new StudySettings();
            filterForm.setStudySettings(studySettings);
            opusMethods.fillStudySettings(session, request, studySettings);
        }
        
        // filter builder needs to be refreshed with current filter selections
        fb.updateFilterBuilder(organization);
        fb.updateFilterBuilder(studySettings);

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS for filters
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(session,
                request, fb.getInstitutionTypeCode(), fb.getInstitutionId(),
                fb.getBranchId(), fb.getOrganizationalUnitId());

        fb.doLookups();
        fb.loadStudies();
        fb.loadAcademicYears();
        fb.loadStudyGradeTypes(true);

        // organization and studySettings values may have changed during filter builder operations
        fb.updateOrganization(organization);
        fb.updateStudySettings(studySettings);

        // remember filter selections in session
        opusMethods.rememberOrganization(session, organization);
        opusMethods.rememberStudySettings(session, studySettings);
        
        return fb;
    }

    private SubjectAndBlockCompilation getSubjectsAndBlocks(HttpServletRequest request,
            StudentFilterBuilder fb) {

        SubjectAndBlockCompilation subjectsAndBlocks = new SubjectAndBlockCompilation();
        if (fb.getCardinalTimeUnitNumber() != null
                && fb.getStudyGradeTypeId() != 0) {
            Map<String, Object> map = new HashMap<>();
            map.put("institutionTypeCode", fb.getInstitutionTypeCode());
            map.put("institutionId", 0);
            map.put("branchId", 0);
            map.put("organizationalUnitId", 0);
            map.put("studyId", 0);
            map.put("studyGradeTypeId", fb.getStudyGradeTypeId());
            map.put("cardinalTimeUnitNumberExact", fb.getCardinalTimeUnitNumber());
            map.put("rigidityTypeCode", OpusConstants.RIGIDITY_COMPULSORY);

            // SubjectBlockStudyGradeType has reference to subjectBlock
            subjectsAndBlocks.setCompulsorySubjectBlocks(subjectBlockMapper.findSubjectBlocksWithResultMap(map));

            // SubjectStudyGradeType unfortunately has no subject references...
            subjectsAndBlocks.setCompulsorySubjects(subjectManager.findSubjects(map));

            // after compulsory, load optional subject (blocks)
            map.put("rigidityTypeCode", OpusConstants.RIGIDITY_ELECTIVE);
            subjectsAndBlocks.setOptionalSubjectBlocks(subjectBlockMapper.findSubjectBlocksWithResultMap(map));
            subjectsAndBlocks.setOptionalSubjects(subjectManager.findSubjects(map));

            // finally, load subjects and blocks that are not associated to a particular CTUnr
            map.put("cardinalTimeUnitNumberExact", 0);
            map.put("rigidityTypeCode", OpusConstants.RIGIDITY_COMPULSORY);
            subjectsAndBlocks.setFloatingCompulsorySubjectBlocks(subjectBlockMapper.findSubjectBlocksWithResultMap(map));
            subjectsAndBlocks.setFloatingCompulsorySubjects(subjectManager.findSubjects(map));
            map.put("rigidityTypeCode", OpusConstants.RIGIDITY_ELECTIVE);
            subjectsAndBlocks.setFloatingOptionalSubjectBlocks(subjectBlockMapper.findSubjectBlocksWithResultMap(map));
            subjectsAndBlocks.setFloatingOptionalSubjects(subjectManager.findSubjects(map));

        }

        return subjectsAndBlocks;
    }

    // --------------- SUBMIT ---------------------------------

    @RequestMapping(params = "action=add")
    public String processSubmit(
            HttpServletRequest request,
            SessionStatus sessionStatus,
            @RequestParam("formNumber") Integer formNumber, 
            SubscribeToSubjectsForm subscribeToSubjectsForm,
            @ModelAttribute("filterForm") SubscribeToSubjectsFilterForm filterForm,
            ModelMap model) throws ParseException {

        // subscribeToSubjectsForm is the submitted form, but it is not registered in the model, 
        // because in this case @ModelAttribute cannot be used due to unknown name of the form in method signature.
        // Therefore, we put it into the model by hand, together with a corresponding BindingResult
        String formName = "subscribeToSubjectsForm" + formNumber;
        model.addAttribute(formName, subscribeToSubjectsForm);   // to display binding results, store under correct name
        BindingResult result = new BeanPropertyBindingResult(subscribeToSubjectsForm, formName);
        model.addAttribute(BindingResult.MODEL_KEY_PREFIX + formName, result); // ditto: need correct form name

        String cardinalTimeUnitStatusCode = subscribeToSubjectsForm.getCardinalTimeUnitStatusCode();

        // validate
        if ("0".equals(cardinalTimeUnitStatusCode)) {
            result.rejectValue("cardinalTimeUnitStatusCode", "jsp.error.subscribetosubjects.nocardinaltimeunitstatus");
        }

        // validate if ctu status is "request for change", and if so, that each spctu has a rfc text
        if (OpusConstants.CARDINALTIMEUNIT_STATUS_REQUEST_FOR_CHANGE.equals(cardinalTimeUnitStatusCode)) {
            // first check if there are individual rfc texts
            boolean individualRfcTextsMissing = false;
            for (Map.Entry<Integer, String> entry: subscribeToSubjectsForm.getRfcTexts().entrySet()) {
//                int spctuId = entry.getKey();
                if (entry.getValue() == null || entry.getValue().trim().isEmpty()) {
                    individualRfcTextsMissing = true;
                    break;
                }
            }
            
            // if individual rfc texts are missing, check if the rfcText field is filled
            if (individualRfcTextsMissing) {
                String rfcText = subscribeToSubjectsForm.getRfcText();
                if (rfcText == null || rfcText.trim().isEmpty()) {
                    result.rejectValue("rfcText", "jsp.error.subscribetosubjects.norfctext");
                }
            }
        }

        if (result.hasErrors()) {
            return setupForm(request, filterForm, model);    // in case of error, no redirect
        }

        // special case: if approval is not required, then bypass to approved status
        // Approval can only be bypassed if no changes have been made to the default set of subjects and blocks
        if (OpusConstants.CARDINALTIMEUNIT_STATUS_WAITING_FOR_APPROVAL_OF_REGISTRATION.equals(cardinalTimeUnitStatusCode)
                && appConfigManager.getCntdRegistrationAutoApproveDefaultSubjects()
                && filterForm.getDefaultSubjectBlockIds().equals(subscribeToSubjectsForm.getSubjectBlockIds())
                && filterForm.getDefaultSubjectIds().equals(subscribeToSubjectsForm.getSubjectIds())) {

            cardinalTimeUnitStatusCode = OpusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED;
            subscribeToSubjectsForm.setCardinalTimeUnitStatusCode(cardinalTimeUnitStatusCode);
        }

        // prepare for storage
        HttpSession session = request.getSession(false);
//        OpusUser opusUser = (OpusUser) session.getAttribute("opusUser");
        OpusUser opusUser = opusMethods.getOpusUser();

        Collection<Integer> studyPlanCTUIds = subscribeToSubjectsForm.getSelectedStudyPlanCTUIds();

        // do the storage
        updateRfcs(studyPlanCTUIds, subscribeToSubjectsForm.getRfcTexts(), subscribeToSubjectsForm.getRfcComments(), cardinalTimeUnitStatusCode, opusUser);

        // only write subjects and blocks if they were editable, because disabled=true won't post back the original subscriptions
        if (subscribeToSubjectsForm.isEditSubscription()) {
            Collection<Integer> subjectBlockIds = subscribeToSubjectsForm.getSubjectBlockIds();
            Collection<Integer> subjectIds = subscribeToSubjectsForm.getSubjectIds();
            updateSubscriptions(studyPlanCTUIds, subjectBlockIds, subjectIds, request);
        }

        // update the CTU status for all selected studyplanCTUs to the chosen status
        updateCTUStatus(studyPlanCTUIds, cardinalTimeUnitStatusCode);

        if (OpusConstants.CARDINALTIMEUNIT_STATUS_REQUEST_FOR_CHANGE.equals(cardinalTimeUnitStatusCode)) {
            rfcSave(request, subscribeToSubjectsForm, session);
            subscribeToSubjectsForm.setRfcText(null);   // rfc text cannot be edited
        }

        sessionStatus.setComplete();

        // after setting session complete no newForm necessary, because form object has been discarded
        return "redirect:/college/person/subscribeToSubjects.view";
    }

    private void updateSubscriptions(Collection<Integer> studyPlanCTUIds, Collection<Integer> subjectBlockIds,
            Collection<Integer> subjectIds, HttpServletRequest request) {
        if (studyPlanCTUIds == null) return;
        if (subjectBlockIds == null) subjectBlockIds = new HashSet<>(0); // we need non-null collections
        if (subjectIds == null) subjectIds = new HashSet<>(0);

        // go through the list of selected students (more precisely, their studyPlanCTUIds)
        for (int studyPlanCardinalTimeUnitId: studyPlanCTUIds) {
            StudyPlanCardinalTimeUnit studyPlanCTU = studentManager.findStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId);

            // remove studyPlanDetails that refer to deselected subject blocks and subjects
            studentManager.retainSubjectBlockStudyPlanDetails(studyPlanCTU, subjectBlockIds, request);
            studentManager.retainSubjectStudyPlanDetails(studyPlanCTU, subjectIds, request);

            // add studyPlanDetails for the subject blocks and subjects that have been additionally selected
            studentManager.addMissingSubjectBlockStudyPlanDetails(studyPlanCTU, subjectBlockIds, request);
            studentManager.addMissingSubjectStudyPlanDetails(studyPlanCTU, subjectIds, request);
        }

    }

    private void updateCTUStatus(Collection<Integer> studyPlanCTUIds, String cardinalTimeUnitStatusCode) {
        if (studyPlanCTUIds == null) return;

        // go through the list of selected students (more precisely, their studyPlanCTUIds)
        for (int studyPlanCardinalTimeUnitId: studyPlanCTUIds) {
            StudyPlanCardinalTimeUnit studyPlanCTU = studentManager.findStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnitId);

            // update ctu status
            studyPlanCTU.setCardinalTimeUnitStatusCode(cardinalTimeUnitStatusCode);
            studentManager.updateStudyPlanCardinalTimeUnit(studyPlanCTU);
        }
    }

    private void updateRfcs(Collection<Integer> studyPlanCTUIds,
            Map<Integer, String> rfcTexts, Map<Integer, String> rfcComments,
            String cardinalTimeUnitStatusCode, OpusUser opusUser) {
        
        for (int spctuId: studyPlanCTUIds) {
            Rfc rfc = rfcManager.findLatestRfc("studyplancardinaltimeunit", spctuId);
            if (rfc != null) {
                boolean update = false;

                if (rfcTexts.containsKey(spctuId)) {      // if rfc texts were editable, check if values changed
                    String newText = StringUtil.emptyStringIfNull(rfcTexts.get(spctuId), true);
                    String oldText = StringUtil.emptyStringIfNull(rfc.getText(), true);
                    if (!newText.equals(oldText)) {
                        rfc.setText(newText);
                        update = true;
                    }
                }
                if (rfcComments.containsKey(spctuId)) {      // if rfc comments were editable, check if values changed
                    String newComment = StringUtil.emptyStringIfNull(rfcComments.get(spctuId), true);
                    String oldComment = StringUtil.emptyStringIfNull(rfc.getComments(), true);
                    if (!newComment.equals(oldComment)) {
                        rfc.setComments(newComment);
                        update = true;
                    }
                }
                
                // if ctu status has been changed to approved or rejected, update rfc status accordingly
                // other ctu statuses indicate that the process isn't over yet, so keep the RFC status on "new" 
                // (the latter also in case of switching back from approved/rejected to any other ctu status)
                if (OpusConstants.CARDINALTIMEUNIT_STATUS_WAITING_FOR_APPROVAL_OF_REGISTRATION.equals(cardinalTimeUnitStatusCode)
                        && !OpusConstants.RFC_STATUS_CODE_RESOLVED.equals(rfc.getStatusCode())) {
                    rfc.setStatusCode(OpusConstants.RFC_STATUS_CODE_RESOLVED);
                    update = true;
                } else if (OpusConstants.CARDINALTIMEUNIT_STATUS_REJECTED_REGISTRATION.equals(cardinalTimeUnitStatusCode)
                        && !OpusConstants.RFC_STATUS_CODE_REFUSED.equals(rfc.getStatusCode())) {
                    rfc.setStatusCode(OpusConstants.RFC_STATUS_CODE_REFUSED);
                    update = true;
                } else if (!OpusConstants.RFC_STATUS_CODE_NEW.equals(rfc.getStatusCode())) {
                    rfc.setStatusCode(OpusConstants.RFC_STATUS_CODE_NEW);
                    update = true;
                }

                if (update) {
                    rfc.setWriteWhen(new Date());
                    rfc.setRespondingUserId(opusUser.getId());
                    rfcManager.updateRfc(rfc);
                }
            }
        }
    }

    /**
     * Write a new RFC for each selected studyPlanCardinalTimeUnit
     * @param request
     * @param form
     */
    private void rfcSave(HttpServletRequest request, SubscribeToSubjectsForm form, HttpSession session) {
        if (form.getRfcText() == null || form.getRfcText().trim().isEmpty()) return;

//        OpusUser opusUser = (OpusUser) session.getAttribute("opusUser");
        OpusUser opusUser = opusMethods.getOpusUser();
        Collection<Integer> studyPlanCTUIds = form.getSelectedStudyPlanCTUIds();
        for (int spctuId: studyPlanCTUIds) {
            // if a new rfc already exists, add to that one, otherwise create new rfc.
            Rfc rfc = rfcManager.findLatestRfc(OpusConstants.RFC_ENTITY_TYPE_STUDYPLANCARDINALTIMEUNIT, spctuId);
            if (rfc == null || !rfc.getStatusCode().equals(OpusConstants.RFC_STATUS_CODE_NEW)) {
                rfc = new Rfc();
                rfc.setText(form.getRfcText());
                rfc.setRequestingUserId(opusUser.getId());
                rfc.setEntityType(OpusConstants.RFC_ENTITY_TYPE_STUDYPLANCARDINALTIMEUNIT);
                rfc.setStatusCode(OpusConstants.RFC_STATUS_CODE_NEW);
                rfc.setActive("Y");
                opusMethods.setWriteWhoWhen(rfc, session);
                rfc.setEntityId(spctuId);
                rfcManager.addRfc(rfc);
            } else {
                rfc.setText(rfc.getText() + "\n" + form.getRfcText());
                opusMethods.setWriteWhoWhen(rfc, session);
                rfcManager.updateRfc(rfc);
            }
        }
    }

}
