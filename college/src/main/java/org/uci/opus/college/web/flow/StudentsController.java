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

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.AdmissionRegistrationConfig;
import org.uci.opus.college.domain.AppConfigAttribute;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudentList;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.extpoint.StudentBalanceInformation;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToStudyMap;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.extpoint.CollegeServiceExtensions;
import org.uci.opus.college.service.extpoint.StudentBalanceEvaluation;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.StudentsForm;
import org.uci.opus.college.web.form.StudySettings;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.StudyPlanAllGradesScoreComparator;
import org.uci.opus.util.TimeTrack;

/**
 * Servlet implementation class for Servlet: StudentsController.
 *
 */
@Controller
@RequestMapping("/college/students.view")
@SessionAttributes({ StudentsController.FORM })
public class StudentsController {
    
    public static final String FORM = "studentsForm";
    private static Logger log = LoggerFactory.getLogger(StudentsController.class);
    private String formView;
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private OpusMethods opusMethods;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private AppConfigManagerInterface appConfigManager;
    @Autowired private OpusInit opusInit;
    @Autowired private CollegeServiceExtensions collegeServiceExtensions;

    public StudentsController() {
        super();
        this.formView = "college/person/students";
    }

    /**
     * @param model
     * @param request
     * @return formview
     * @throws ParseException 
     */
    @RequestMapping(method = RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) throws ParseException {
        
        if (log.isDebugEnabled()) {
            log.debug("StudentsController.setUpForm started...");
        }
        
        TimeTrack timer = new TimeTrack("studentsController.setupForm");

        Organization organization = null;
        NavigationSettings navigationSettings = null;
        StudySettings studySettings = null;
        
        HttpSession session = request.getSession(false);

        String endGradesPerGradeType = null;
        String minimumGrade = null;
        String maximumGrade = null;
        int minimumMarkValue = 0;
        int maximumMarkValue = 0;
        int numberOfRegisteredStudents = 0;
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        opusMethods.removeSessionFormObject(FORM, session, model, opusMethods.isNewForm(request));

        /* set menu to students */
        session.setAttribute("menuChoice", "students");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        StudentFilterBuilder fb = new StudentFilterBuilder(request,
				opusMethods, lookupCacher, studyManager, studentManager);

        fb.initChosenValues();
        fb.doLookups();
        fb.loadStudies();
        fb.loadStudyGradeTypes();
        fb.loadMaxCardinalTimeUnitNumber();

        /* studentsForm - fetch or create the form object and fill it 
         *     with organization and navigationSettings */
        StudentsForm studentsForm = (StudentsForm) model.get(FORM);
        if (studentsForm == null) {
        	studentsForm = new StudentsForm();
        }

        /* ORGANIZATION - fetch or create the object */
        if (studentsForm.getOrganization() != null) {
        	organization = studentsForm.getOrganization();
        } else {
        	organization = new Organization();

        	int organizationalUnitId = (Integer) session.getAttribute("organizationalUnitId");
            int branchId = (Integer) session.getAttribute("branchId");
            int institutionId = (Integer) session.getAttribute("institutionId");
            organization = opusMethods.fillOrganization(session, request, organization, 
            		organizationalUnitId, branchId, institutionId);
            studentsForm.setOrganization(organization);
        }

        /* NAVIGATION SETTINGS - fetch or create the object */
        if (studentsForm.getNavigationSettings() != null) {
        	navigationSettings = studentsForm.getNavigationSettings();
        } else {
        	navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, "students.view");
        	studentsForm.setNavigationSettings(navigationSettings);
        }

        /* Catch errormessages */
        if (!StringUtil.isNullOrEmpty(request.getParameter("showStudentError"))) {
        	studentsForm.setTxtErr(request.getParameter("showStudentError"));
        }

        /* STUDY SETTINGS - fetch or create the object */
        if (studentsForm.getStudySettings() != null) {
        	studySettings = studentsForm.getStudySettings();
        } else {
        	studySettings = new StudySettings();
        	studySettings = opusMethods.fillStudySettings(request, 
        			studySettings);
        	studentsForm.setStudySettings(studySettings);
        }
        
        /* */        
        if (!StringUtil.isNullOrEmpty(request.getParameter("admissionFlow"))) {
            request.setAttribute("admissionFlow", request.getParameter("admissionFlow"));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("continuedRegistrationFlow"))) {
            request.setAttribute("continuedRegistrationFlow", request.getParameter("continuedRegistrationFlow"));
        }
        if (request.getParameter("studyPlanStatusCode") != null) {
            studentsForm.getStudySettings().getStudyPlanStatus().setCode(request.getParameter("studyPlanStatusCode"));
        }        

        /* STUDENT STATUS */
        if (!StringUtil.isNullOrEmpty(request.getParameter("studentStatusCode"))) {
        	studentsForm.setStudentStatusCode(request.getParameter("studentStatusCode"));
        }
        
        /* GENDER */
        if (!StringUtil.isNullOrEmpty(request.getParameter("genderCode"))) {
        	studentsForm.setStudentStatusCode(request.getParameter("genderCode"));
        }
        
        /* CARDINALTIMEUNIT STATUS */
        if (!StringUtil.isNullOrEmpty(request.getParameter("cardinalTimeUnitStatusCode"))) {
        	studentsForm.setCardinalTimeUnitStatusCode(request.getParameter("cardinalTimeUnitStatusCode"));
        }

        /* relative of staffmember */
        if (!StringUtil.isNullOrEmpty(request.getParameter("relativeOfStaffMember"))) {
        	studentsForm.setRelativeOfStaffMember(request.getParameter("relativeOfStaffMember"));
        }
        
        /* rural area origin */
        if (!StringUtil.isNullOrEmpty(request.getParameter("ruralAreaOrigin"))) {
        	studentsForm.setRuralAreaOrigin(request.getParameter("ruralAreaOrigin"));
        }
 
        /* foreign student */
        if (!StringUtil.isNullOrEmpty(request.getParameter("foreignStudent"))) {
        	studentsForm.setForeignStudent(request.getParameter("foreignStudent"));
        }

        /* Catch errormessages */
        if (!StringUtil.isNullOrEmpty(request.getParameter("showStudentError"))) {
        	studentsForm.setTxtErr(request.getParameter("showStudentError"));
        }

        int organizationalUnitId = organization.getOrganizationalUnitId();

        // if no organizational unit selected and user only has privileges to a specific organizational unit, then limit to the user's organizational unit and its children
        // see OpusMethods.getInstitutionBranchOrganizationalUnitSelect() which applies the same logic
        if (organizationalUnitId == 0 && !request.isUserInRole("READ_ORG_UNITS") && request.isUserInRole("READ_PRIMARY_AND_CHILD_ORG_UNITS")) {
            OrganizationalUnit organizationalUnit = (OrganizationalUnit) session.getAttribute("organizationalUnit");
            organizationalUnitId = organizationalUnit.getId();
        }
        
        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
		opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                session, request, organization.getInstitutionTypeCode(),
                organization.getInstitutionId(), organization.getBranchId(), 
                organizationalUnitId);

        boolean limitToSameStudyGradeType = request.isUserInRole("READ_STUDENTS_SAME_STUDYGRADETYPE") && !request.isUserInRole("READ_STUDENTS");

        // performance: pre-fetch tree of organizationalUnitIds to avoid crawl-tree "thousands of times", ie. once per student
        List<Integer> organizationalUnitIds = null;
        if (organizationalUnitId != 0) {
            organizationalUnitIds = organizationalUnitManager.findTreeOfOrganizationalUnitIds(organizationalUnitId);
        }
        
        // LIST OF STUDIES
        // used to show the name of the primary study of each subject in the overview
        Map<String, Object> findMap = new HashMap<>();

        findMap.put("institutionId", organization.getInstitutionId());
    	findMap.put("branchId", organization.getBranchId());
    	findMap.put("organizationalUnitIds", organizationalUnitIds);
        findMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
        if (limitToSameStudyGradeType) {
            OpusUser opusUser = opusMethods.getOpusUser();
            findMap.put("personId", opusUser.getPersonId());
        }

        // LIST OF STUDIES TO SHOW IN DROP DOWN LIST needs to be empty if the organizational unit is not chosen
        List<Study> allStudies = null;
        if (organizationalUnitId != 0) {
            allStudies = studyManager.findStudies(findMap);
        }
        studentsForm.setDropDownListStudies(allStudies);

        findMap.put("studyId", studySettings.getStudyId());
        findMap.put("preferredLanguage", preferredLanguage);

        studentsForm.setAllStudyGradeTypes(studyManager.findStudyGradeTypes(findMap));
        studentsForm.setAllAcademicYears(academicYearManager.findAllAcademicYears());

        // determine studyGradeType according to studySettings.studyGradeTypeId
        int studyGradeTypeId = studentsForm.getStudySettings().getStudyGradeTypeId();
        StudyGradeType studyGradeType = studyGradeTypeId == 0 ? null : studyManager.findStudyGradeType(studyGradeTypeId);

        // set studygradetype into studySettings for convenience
        studySettings.setStudyGradeType(studyGradeType);
       
        if ("".equals(studentsForm.getCardinalTimeUnitStatusCode()) 
             || studentsForm.getCardinalTimeUnitStatusCode() == null) {
            studentsForm.setCardinalTimeUnitStatusCode(null);
        }
		timer.measure("begin");

        // LIST OF STUDENTS DEPENDING ON CHOSEN VALUES
        Map<String, Object> findStudentsMap = new HashMap<>();
        findStudentsMap.put("institutionId", organization.getInstitutionId());
        findStudentsMap.put("branchId", organization.getBranchId());
        findStudentsMap.put("organizationalUnitIds", organizationalUnitIds);
        findStudentsMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
        findStudentsMap.put("preferredLanguage", preferredLanguage);
        findStudentsMap.put("studyId", studySettings.getStudyId());
        findStudentsMap.put("studyGradeTypeId", studySettings.getStudyGradeTypeId());
        findStudentsMap.put("cardinalTimeUnitNumber", studySettings.getCardinalTimeUnitNumber());
        if (studySettings.getClassgroupId() != 0) {
            findStudentsMap.put("classgroupId", studySettings.getClassgroupId());
        }
    	// only show approved initial admission studyplans for continued registration flow
        if (!StringUtil.isNullOrEmpty(request.getParameter("continuedRegistrationFlow"))) {
        	findStudentsMap.put("studyPlanStatusCode", OpusConstants.STUDYPLAN_STATUS_APPROVED_ADMISSION);
        } else {
            Lookup studyPlanStatus = studySettings.getStudyPlanStatus();
            if (studyPlanStatus != null && studyPlanStatus.getCode() != null && !"0".equals(studyPlanStatus.getCode())) {
            	findStudentsMap.put("studyPlanStatusCode", studyPlanStatus.getCode());
            }
        }
        findStudentsMap.put("cardinalTimeUnitStatusCode", studentsForm.getCardinalTimeUnitStatusCode());
        findStudentsMap.put("relativeOfStaffMember", studentsForm.getRelativeOfStaffMember());
        findStudentsMap.put("ruralAreaOrigin", studentsForm.getRuralAreaOrigin());
        findStudentsMap.put("foreignStudent", studentsForm.getForeignStudent());
        findStudentsMap.put("studentStatusCode", studentsForm.getStudentStatusCode());
        findStudentsMap.put("genderCode", studentsForm.getGenderCode());
        findStudentsMap.put("searchValue", navigationSettings.getSearchValue());
        
        // Note: 'lowest grade' is higher than 'highest grade' 
        int lowestGradeOfSecondarySchoolSubjects  = appConfigManager.getSecondarySchoolSubjectsLowestGrade();
        int highestGradeOfSecondarySchoolSubjects = appConfigManager.getSecondarySchoolSubjectsHighestGrade();
       
        findStudentsMap.put("defaultMaximumGradePoint", highestGradeOfSecondarySchoolSubjects);
        findStudentsMap.put("defaultMinimumGradePoint", lowestGradeOfSecondarySchoolSubjects);

        if (limitToSameStudyGradeType) {
            List<? extends StudyGradeType> allStudyGradeTypes = studentsForm.getAllStudyGradeTypes();
            if (allStudyGradeTypes != null && !allStudyGradeTypes.isEmpty()) {
                findStudentsMap.put("studyGradeTypeIds", DomainUtil.getIds(allStudyGradeTypes));
            }
        }
        // get the total count of students that apply to the filter criteria
        int studentCount = studentManager.findStudentCount(findStudentsMap);
        studentsForm.setStudentCount(studentCount);
		timer.measure("student count");
        
        // get the students themselves
        int iPaging = opusInit.getPaging();
        findStudentsMap.put("offset", (navigationSettings.getCurrentPageNumber() - 1) * iPaging);
        findStudentsMap.put("limit", iPaging);
        StudentList allStudents = studentManager.findStudents(findStudentsMap);
        timer.measure("student list");

		for (Student student: allStudents) {
        	
            // enrich student with result of student payment evaluation
            StudentBalanceEvaluation studentBalanceEvaluation = collegeServiceExtensions.getStudentBalanceEvaluation();
            StudentBalanceInformation studentBalanceInformation = studentBalanceEvaluation.getStudentBalanceInformation(student.getStudentId());
            student.setStudentBalanceInformation(studentBalanceInformation);
            if (studentBalanceInformation != null) {
                boolean hasMadeSufficientPayments = studentBalanceEvaluation.hasMadeSufficientPaymentsForRegistration(studentBalanceInformation);
                student.setHasMadeSufficientPayments(hasMadeSufficientPayments);
            }
        }
		timer.measure("student balance");

        /* CUT OFF POINTS */
        /* Admission BA / BSC */
        if (request.getParameter("passCutOffPointAdmissionBachelor") != null) {
            BigDecimal cutOffPointAdmissionBachelor = new BigDecimal(request.getParameter("passCutOffPointAdmissionBachelor"));
            studentsForm.setCutOffPointAdmissionBachelor(cutOffPointAdmissionBachelor);
        }        
        /* Continued registration BA / BSC */
        if (request.getParameter("passCutOffPointContinuedRegistrationBachelor") != null) {
            BigDecimal cutOffPointContinuedRegistrationBachelor = new BigDecimal(request.getParameter("passCutOffPointContinuedRegistrationBachelor"));
            studentsForm.setCutOffPointContinuedRegistrationBachelor(cutOffPointContinuedRegistrationBachelor);
    		if (log.isDebugEnabled()) {
    			log.debug("StudentsController - cut off point admission Bachelor set in studentsform: " + studentsForm.getCutOffPointContinuedRegistrationBachelor());
    		}
        }        
        /* Continued registration MA / MSC */
        if (request.getParameter("passCutOffPointContinuedRegistrationMaster") != null) {
//            float cutOffPointContinuedRegistrationMaster = Float.valueOf(request.getParameter("passCutOffPointContinuedRegistrationMaster")).floatValue();
            BigDecimal cutOffPointContinuedRegistrationMaster = new BigDecimal(request.getParameter("passCutOffPointContinuedRegistrationMaster"));
            studentsForm.setCutOffPointContinuedRegistrationMaster(cutOffPointContinuedRegistrationMaster);
    		if (log.isDebugEnabled()) {
    			log.debug("StudentsController - cut off point admission Master set in studentsform: " + studentsForm.getCutOffPointContinuedRegistrationMaster());
    		}
        }        

        if (studyGradeType != null) {
	        // MINIMUM and MAXIMUM GRADE:
	        // see if the endGrades are defined on studygradetype level
            endGradesPerGradeType = studyManager.findEndGradeType(studyGradeType.getCurrentAcademicYearId());
            
	        if (endGradesPerGradeType == null || "".equals(endGradesPerGradeType)) {
	   	    	Study study = studyManager.findStudy(
	   	    			studentsForm.getStudySettings().getStudyId());
	        	// mozambican situation
	   	    	minimumGrade = study.getMinimumMarkSubject();
	   	    	maximumGrade = study.getMaximumMarkSubject();
	   	    	if (StringUtil.checkValidInt(study.getMinimumMarkSubject()) == 1) {
	   	    		minimumMarkValue = Integer.parseInt(study.getMinimumMarkSubject());
	   	    	}
	   	    	if (StringUtil.checkValidInt(study.getMaximumMarkSubject()) == 1) {
	       	    	maximumMarkValue = Integer.parseInt(study.getMaximumMarkSubject());
	   	    	}
	        } else {
	        	// zambian situation
	            Map<String, Object> minMap = new HashMap<>();
	            minMap.put("endGradeTypeCode", studyGradeType.getGradeTypeCode());
	            minMap.put("academicYearId", studyGradeType.getCurrentAcademicYearId());

	            BigDecimal minimumEndGradeForGradeType = studyManager.findMinimumEndGradeForGradeType(minMap);
	            BigDecimal maximumEndGradeForGradeType = studyManager.findMaximumEndGradeForGradeType(minMap);
	            minimumGrade = String.valueOf(minimumEndGradeForGradeType);
	            maximumGrade = String.valueOf(maximumEndGradeForGradeType);
	            minimumMarkValue = 0;
	            maximumMarkValue = 100;
	        }

	        // see how many students are already actively registered:
	        // 2018-03-15 MP: deactivated, because only in case of continued registration or admission flow
/*	        Map<String, Object> regstudmap = new HashMap<>();
	        regstudmap.put("institutionId", organization.getInstitutionId());
	        regstudmap.put("branchId", organization.getBranchId());
	        regstudmap.put("organizationalUnitIds", organizationalUnitIds);
	        regstudmap.put("institutionTypeCode", organization.getInstitutionTypeCode());
	        regstudmap.put("preferredLanguage", preferredLanguage);
	        regstudmap.put("studyId", studySettings.getStudyId());
	        regstudmap.put("studyGradeTypeId", studySettings.getStudyGradeTypeId());
	        regstudmap.put("cardinalTimeUnitNumber", studySettings.getCardinalTimeUnitNumber());
	        regstudmap.put("cardinalTimeUnitStatusCode", 
	        		OpusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED);
	        StudentList registeredStudents = studentManager.findStudents(regstudmap);
	        if (registeredStudents != null && registeredStudents.size() != 0) {
	        	numberOfRegisteredStudents = registeredStudents.size();
	        }
*/
        }
        
        request.setAttribute("minimumGrade", minimumGrade);
        request.setAttribute("maximumGrade", maximumGrade);
        request.setAttribute("minimumMarkValue", minimumMarkValue);
        request.setAttribute("maximumMarkValue", maximumMarkValue);
        request.setAttribute("studyGradeType", studyGradeType); // TODO should not be needed anymore, because it's in studySettings
        request.setAttribute("numberOfRegisteredStudents", numberOfRegisteredStudents);

        /* male & female */
        AppConfigAttribute appConfigAdmissionBachelorCutOffPointCreditFemale = 
        	appConfigManager.findAppConfigAttribute("admissionBachelorCutOffPointCreditFemale");
        BigDecimal admissionBachelorCutOffPointCreditFemale = 
                new BigDecimal(appConfigAdmissionBachelorCutOffPointCreditFemale.getAppConfigAttributeValue());
        studentsForm.setAdmissionBachelorCutOffPointCreditFemale(admissionBachelorCutOffPointCreditFemale);
        AppConfigAttribute appConfigAdmissionBachelorCutOffPointCreditMale = 
        	appConfigManager.findAppConfigAttribute("admissionBachelorCutOffPointCreditMale");
        BigDecimal admissionBachelorCutOffPointCreditMale = 
//        	Float.valueOf(appConfigAdmissionBachelorCutOffPointCreditMale.getAppConfigAttributeValue());
                new BigDecimal(appConfigAdmissionBachelorCutOffPointCreditMale.getAppConfigAttributeValue());
        studentsForm.setAdmissionBachelorCutOffPointCreditMale(admissionBachelorCutOffPointCreditMale);

//        AppConfigAttribute appConfigCntdRegistrationBachelorCutOffPointCreditFemale = 
//        	appConfigManager.findAppConfigAttribute("cntdRegistrationBachelorCutOffPointCreditFemale");
//        float cntdRegistrationBachelorCutOffPointCreditFemale = 
//        	Float.valueOf(appConfigCntdRegistrationBachelorCutOffPointCreditFemale.getAppConfigAttributeValue());
//        studentsForm.setCntdRegistrationBachelorCutOffPointCreditFemale(cntdRegistrationBachelorCutOffPointCreditFemale);
//        AppConfigAttribute appConfigCntdRegistrationBachelorCutOffPointCreditMale = 
//        	appConfigManager.findAppConfigAttribute("cntdRegistrationBachelorCutOffPointCreditMale");
//        float cntdRegistrationBachelorCutOffPointCreditMale = 
//        	Float.valueOf(appConfigCntdRegistrationBachelorCutOffPointCreditMale.getAppConfigAttributeValue());
//        studentsForm.setCntdRegistrationBachelorCutOffPointCreditMale(cntdRegistrationBachelorCutOffPointCreditMale);
//        AppConfigAttribute appConfigCntdRegistrationMasterCutOffPointCreditFemale = 
//        	appConfigManager.findAppConfigAttribute("cntdRegistrationMasterCutOffPointCreditFemale");
//        float cntdRegistrationMasterCutOffPointCreditFemale = 
//        	Float.valueOf(appConfigCntdRegistrationMasterCutOffPointCreditFemale.getAppConfigAttributeValue());
//        studentsForm.setCntdRegistrationMasterCutOffPointCreditFemale(cntdRegistrationMasterCutOffPointCreditFemale);
//        AppConfigAttribute appConfigCntdRegistrationMasterCutOffPointCreditMale = 
//           	appConfigManager.findAppConfigAttribute("cntdRegistrationMasterCutOffPointCreditMale");
//        float cntdRegistrationMasterCutOffPointCreditMale = 
//        	Float.valueOf(appConfigCntdRegistrationMasterCutOffPointCreditMale.getAppConfigAttributeValue());
//        studentsForm.setCntdRegistrationMasterCutOffPointCreditMale(cntdRegistrationMasterCutOffPointCreditMale);

        /* relatives */
        AppConfigAttribute appConfigAdmissionBachelorCutOffPointRelativesCreditFemale = 
        	appConfigManager.findAppConfigAttribute("admissionBachelorCutOffPointRelativesCreditFemale");
        BigDecimal admissionBachelorCutOffPointRelativesCreditFemale = 
                new BigDecimal(appConfigAdmissionBachelorCutOffPointRelativesCreditFemale.getAppConfigAttributeValue());
        studentsForm.setAdmissionBachelorCutOffPointRelativesCreditFemale(admissionBachelorCutOffPointRelativesCreditFemale);
        AppConfigAttribute appConfigAdmissionBachelorCutOffPointRelativesCreditMale = 
        	appConfigManager.findAppConfigAttribute("admissionBachelorCutOffPointRelativesCreditMale");
        BigDecimal admissionBachelorCutOffPointRelativesCreditMale = 
                new BigDecimal(appConfigAdmissionBachelorCutOffPointRelativesCreditMale.getAppConfigAttributeValue());
        studentsForm.setAdmissionBachelorCutOffPointRelativesCreditMale(admissionBachelorCutOffPointRelativesCreditMale);

        /* rural areas */
        AppConfigAttribute appConfigAdmissionBachelorCutOffPointCreditRuralAreas = 
        	appConfigManager.findAppConfigAttribute("admissionBachelorCutOffPointCreditRuralAreas");
        BigDecimal admissionBachelorCutOffPointCreditRuralAreas = 
                new BigDecimal(appConfigAdmissionBachelorCutOffPointCreditRuralAreas.getAppConfigAttributeValue());
        studentsForm.setAdmissionBachelorCutOffPointCreditRuralAreas(admissionBachelorCutOffPointCreditRuralAreas);

        if (studentsForm.getCutOffPointAdmissionBachelor().compareTo(BigDecimal.ZERO) != 0
                || studentsForm.getCutOffPointContinuedRegistrationBachelor().compareTo(BigDecimal.ZERO) != 0
                    || studentsForm.getCutOffPointContinuedRegistrationMaster().compareTo(BigDecimal.ZERO) != 0
        		) {

            StudentList filteredStudents = new StudentList();
            int newCounterOfStudents = 0;

            /* Admission BA / BSC - total points */
            if (studentsForm.getCutOffPointAdmissionBachelor().compareTo(BigDecimal.ZERO) != 0) {
        		
        		if (log.isDebugEnabled()) {
        			log.debug("StudentsController - cut off point admission BA/BSC entered");
        		}

        		// TODO get the numberOfSubjectsToGrade via the normal framework to load a appConfig paramter
        		//      but careful: the appConfig queries do not take into account the startdate <= date <= enddate 
        		//      see AcademicYear.findRequestAdmissionNumberOfSubjectsToGrade query for how to do that
        		// add the number of subjects to grade when applying for admission of bachelor
                int numberOfSubjectsToGrade = academicYearManager.findRequestAdmissionNumberOfSubjectsToGrade(new Date());

	            /**
	             * For admission BA/BSC the cut-off point is a desired max total of all secondary school grades
	             * So for a number of 5 counted secondary school grades the highest cut-offpoint would be
	             *       (highestGrade * numberOfSecondarySchoolSubjects)
	             *       (     1       *         5     					  = 5)
	             *  The lowest max total will be (depending on grade 5 or 6 will be 25 or 30.
	             */
                BigDecimal cutOffPointAdmissionBachelor = studentsForm.getCutOffPointAdmissionBachelor();
	            
	            if (log.isDebugEnabled()) {
	                log.debug(" ------------------------------------------------------- ");
	                log.debug(" -- CUTOFFPOINT Admission BA/BSC: allStudents.size(): " + allStudents.size());
	                log.debug(" -- CUTOFFPOINT Admission BA/BSC: cutOffPoint totals: " + cutOffPointAdmissionBachelor 
	                        + " ( " + studentsForm.getCutOffPointAdmissionBachelor() + ")");
	            }

	            for (Student student : allStudents) {
	            
	                if (log.isDebugEnabled()) {
	                    log.debug(" ------------------------------------------------------- ");
	                    log.debug(" -- CUTOFFPOINT Admission BA/BSC: student " + student.getFirstnamesFull());
	                }

	                List <StudyPlan> studyPlans = student.getStudyPlans();
	                boolean pass = false;

	                int plansWithStatusCodeStartAdmission = 0;                
	                BigDecimal cutOffPointCreditFemale = admissionBachelorCutOffPointCreditFemale;
	                BigDecimal cutOffPointCreditMale = admissionBachelorCutOffPointCreditMale;
	                BigDecimal cutOffPointCreditRuralAreas = admissionBachelorCutOffPointCreditRuralAreas;
	                if (log.isDebugEnabled()) {
	                	log.debug("StudentsController: cutOffPointCreditRuralAreas = " + cutOffPointCreditRuralAreas);
	                }
	                // you only want to keep the studyPlans that matter in the admission flow, in this case
	                // the plans with status "waiting for selection"
	                List <StudyPlan> selectedStudyPlans = new ArrayList<>();
	                for (StudyPlan studyPlan : studyPlans) {                                        
	                    
	                    if (studyPlan.getStudyPlanStatusCode().equals(
	                            OpusConstants.STUDYPLAN_STATUS_WAITING_FOR_SELECTION)) {

	                    	// add number of secondary school subjects to grade
	                    	studyPlan.setNumberOfSubjectsToGrade(numberOfSubjectsToGrade);

	                        plansWithStatusCodeStartAdmission++;    

	                        if ("Y".equals(student.getRelativeOfStaffMember())) {
	                        	cutOffPointCreditFemale = admissionBachelorCutOffPointRelativesCreditFemale;
	                        	cutOffPointCreditMale = admissionBachelorCutOffPointRelativesCreditMale;
	                        }
	                        if ("Y".equals(student.getRuralAreaOrigin())) {
                                cutOffPointCreditFemale = cutOffPointCreditRuralAreas.add(cutOffPointCreditFemale);
                                cutOffPointCreditMale = cutOffPointCreditRuralAreas.add(cutOffPointCreditMale);
	                        }
	                        if (studyPlan.passCutOffPointAdmissionBachelor(
	                        		cutOffPointAdmissionBachelor, student.getGenderCode(), 
	                        		cutOffPointCreditFemale, cutOffPointCreditMale
	                        		)) {
	                            pass = true;
	                            // this studyPlan is valid for admission so keep it in the list
	                            selectedStudyPlans.add(studyPlan);
	                            if (log.isDebugEnabled()) {
	                                log.debug(" -- CUTOFFPOINT Admission Bachelor: StudyPlanStatusCode: "
	                                  + studyPlan.getStudyPlanStatusCode() 
	                                  + " passCutOffPoint: TRUE");
	                            }
	                        }   else {
	                            if (log.isDebugEnabled()) {
	                                log.debug(" -- CUTOFFPOINT Admission Bachelor: StudyPlanStatusCode: "
	                                  + studyPlan.getStudyPlanStatusCode() 
	                                  + " passCutOffPoint: FALSE");
	                            }
	                        }
	                    } 
	                }
	                // only keep the relevant studyPlans of the student, that is the ones with
	                // status "waiting for selection"
	                student.setStudyPlans(selectedStudyPlans);
	                
	                if (log.isDebugEnabled()) {
	                    if (plansWithStatusCodeStartAdmission == 0) {                    
	                        log.debug(" -- CUTOFFPOINT Admission Bachelor: (No plans with StatusCode StartAdmission)");
	                    }
	                }
	                // For now assuming that if a student has more studyplans in phase of
	                // initial admission, there is a case of fraude
	                if (plansWithStatusCodeStartAdmission > 1) {
	                    pass = false;
	                    if (log.isDebugEnabled()) {
                            log.debug(" -- CUTOFFPOINT Admission Bachelor: Student : "
                              + student.getFirstnamesFull() 
                              + " passCutOffPoint: FALSE, because he/she has more than one studyplan in initial admission phase");
                        }
	                }
	                
	                if (pass) {
	                    newCounterOfStudents = newCounterOfStudents + 1;
	                    filteredStudents.add(student);
	                }                
	            }
	            studentsForm.setStudentCount(newCounterOfStudents);
	            // order filteredStudents (reverse!) by studyplan.allGradesScore:
	            List <StudyPlan> orderedStudyPlans = new ArrayList <>();
	            for (int x = 0; x < filteredStudents.size(); x++) {
	            	for (int y = 0; y < filteredStudents.get(x).getStudyPlans().size(); y++) {
	            	    StudyPlan studyPlan = filteredStudents.get(x).getStudyPlans().get(y);
	            	    if (studyPlan.getStudyPlanStatusCode().equals(
                                OpusConstants.STUDYPLAN_STATUS_WAITING_FOR_SELECTION)) {
	            	        orderedStudyPlans.add(studyPlan);
	            	    }
	            		if (log.isDebugEnabled()) {
	    	            	log.debug("StudentsController - admission list: unordered studyplans: x =" + x + ", y = " + y + ": " + filteredStudents.get(x).getStudyPlans().get(y).getAllGradesScore());
	    	            }
	            	}
	            }
	            Collections.sort(orderedStudyPlans, new StudyPlanAllGradesScoreComparator());
//	            Collections.reverse(orderedStudyPlans);
	            
	            StudentList orderedStudents = new StudentList(); 
             	for (int a = 0; a < orderedStudyPlans.size(); a++) {
            		for (int b = 0; b < filteredStudents.size(); b++) {
            			if (orderedStudyPlans.get(a).getStudentId() == filteredStudents.get(b).getStudentId()) {
            				orderedStudents.add(filteredStudents.get(b));
            			}
            		}
            		if (log.isDebugEnabled()) {
         	           log.debug("StudentsController - admission list: ordered studyplans: a =" + a + ": " + orderedStudyPlans.get(a).getAllGradesScore());
            		}
	            }
             	filteredStudents = orderedStudents;
        	}



	        // fill the right student selection in the studentsForm:
	        studentsForm.setAllStudents(filteredStudents);
        } else {
            studentsForm.setAllStudents(allStudents);
        }

        // Students can be subscribed to studies that are not in the list of allStudies, therefore get all studies that belong to students' study plans
        List<Integer> studyIds = allStudents.getAllStudyIds();
        List<Study> studyPlanStudies = studyManager.findStudies(studyIds, preferredLanguage);
        studentsForm.setIdToStudyMap(new IdToStudyMap(studyPlanStudies));

        /* fill lookup-tables with right values */
        lookupCacher.getPersonLookups(preferredLanguage, request);
        lookupCacher.getStudentLookups(preferredLanguage, request);
        // only allStudyPlanStatuses needed students overview screen
        lookupCacher.getStudyPlanLookups(preferredLanguage, request);

        studentsForm.setCodeToGradeTypeMap(new CodeToLookupMap(lookupCacher.getAllGradeTypes(preferredLanguage)));
        
        // filter cardinaltimeunitstatuses for part time students:
        if (studyGradeType != null) {
        	if (OpusConstants.STUDY_INTENSITY_PARTTIME.equals(studyGradeType.getStudyIntensityCode())) {
        		List < Lookup > allCardinalTimeUnitStatuses = null;
        		int positionOfCustomizeProgramme = 0;
        		allCardinalTimeUnitStatuses = (List < Lookup >) request.getAttribute("allCardinalTimeUnitStatuses");
                // remove 'customize programme:
                for (int i = 0; i < allCardinalTimeUnitStatuses.size(); i++) {
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
        // Milestone 3.3: hide CARDINALTIMEUNIT_STATUS_REQUEST_FOR_CHANGE:
        List < Lookup > allCardinalTimeUnitStatuses = null;
		Integer positionOfCustomizeProgramme = null;
		allCardinalTimeUnitStatuses = (List < Lookup >) request.getAttribute("allCardinalTimeUnitStatuses");
        // remove 'customize programme:
        for (int i = 0; i < allCardinalTimeUnitStatuses.size(); i++) {
        	if (OpusConstants.CARDINALTIMEUNIT_STATUS_REQUEST_FOR_CHANGE.equals(
        			allCardinalTimeUnitStatuses.get(i).getCode())) {
        		positionOfCustomizeProgramme = i;
        		break;
        	}
        }
        if (log.isDebugEnabled()) {
            log.debug("positionOfCustomizeProgramme=" + positionOfCustomizeProgramme + ", allCardinalTimeUnitStatuses=" + allCardinalTimeUnitStatuses);
        }

        if (positionOfCustomizeProgramme != null) {
            allCardinalTimeUnitStatuses.remove(positionOfCustomizeProgramme);
        }
        request.setAttribute("allCardinalTimeUnitStatuses", allCardinalTimeUnitStatuses);
        
        // here comes the report creation playground..
//        boolean html = WebUtils.hasSubmitParameter(request, "submitStudentsGroupedForm");
        // set attribute for right redirect view form
//        String print = (request.getParameter("print"));       

        // if filter elements selected, then check for registration periods
        AdmissionRegistrationConfig admissionRegistrationConfig = null;
        if (studyGradeType != null) {
        	OrganizationalUnit orgUnit = organizationalUnitManager.findOrganizationalUnitOfStudy(
        			studyGradeType.getStudyId());
        	admissionRegistrationConfig = organizationalUnitManager
                    .findAdmissionRegistrationConfig(orgUnit.getId(), 
                    		studyGradeType.getCurrentAcademicYearId(), true);
        }
        if (admissionRegistrationConfig != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");      
            Date todayWithoutTime = sdf.parse(sdf.format(new Date()));
            Date startOfRegistration = admissionRegistrationConfig.getStartOfRegistration();
            Date endOfRegistration = admissionRegistrationConfig.getEndOfRegistration();
            if ((startOfRegistration != null && todayWithoutTime.compareTo(startOfRegistration) < 0)
                    || (endOfRegistration != null && todayWithoutTime.compareTo(endOfRegistration) > 0)) {
            	request.setAttribute("outsideRegistrationPeriod", true);
            }
            Date startOfAdmission = admissionRegistrationConfig.getStartOfAdmission();
            Date endOfAdmission = admissionRegistrationConfig.getEndOfAdmission();
            if ((startOfAdmission != null && todayWithoutTime.compareTo(startOfAdmission) < 0)
                    || (endOfAdmission != null && todayWithoutTime.compareTo(endOfAdmission) > 0)) {
            	request.setAttribute("outsideAdmissionPeriod", true);
            }
            
        }
        request.setAttribute("admissionRegistrationConfig", admissionRegistrationConfig);
        timer.end("remainder");

        model.addAttribute(FORM, studentsForm);
        return formView; 
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(
    		@ModelAttribute(FORM) StudentsForm studentsForm,
            BindingResult result, SessionStatus status, HttpServletRequest request) {
        
        if (log.isDebugEnabled()) {
            log.debug("StudentsController.processSubmit started...");
        }

        HttpSession session = request.getSession(false);        

        Organization organization = studentsForm.getOrganization();
        NavigationSettings navigationSettings = studentsForm.getNavigationSettings();
        StudySettings studySettings = studentsForm.getStudySettings();
        
        String prevStudyPlanStatusCode = "";
        String nextStudyPlanStatusCode = "";
        String prevCardinalTimeUnitStatusCode = "";
        String nextCardinalTimeUnitStatusCode = "";
        String admissionFlow = "";
        String continuedRegistrationFlow = "";
        
        // overview: put chosen organization on session:
        session.setAttribute("organizationalUnitId", organization.getOrganizationalUnitId());
        session.setAttribute("branchId", organization.getBranchId());
        session.setAttribute("institutionId", organization.getInstitutionId());

        if (!StringUtil.isNullOrEmpty(request.getParameter("admissionFlow"))) {
            admissionFlow = request.getParameter("admissionFlow");
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("continuedRegistrationFlow"))) {
            continuedRegistrationFlow = request.getParameter("continuedRegistrationFlow");
        }

        /* cut-off point Admission BA/BSC */
        if ("true".equals(request.getParameter("setCutOffPointAdmissionBachelor"))) {
            
        	if (log.isDebugEnabled()) {
                log.debug("StudentsController.processSubmit: cut off point admission ba/bsc");
            }
        	if (!"".equals(studentsForm.getCardinalTimeUnitStatusCode())) {
                prevCardinalTimeUnitStatusCode = studentsForm.getCardinalTimeUnitStatusCode();
                if (!StringUtil.isNullOrEmpty(request.getParameter("nextCardinalTimeUnitStatusCode"))) {
                    nextCardinalTimeUnitStatusCode = (request.getParameter("nextCardinalTimeUnitStatusCode"));
                }
            }
            status.setComplete();
            
            String studyPlanStatusCode = studentsForm.getStudySettings().getStudyPlanStatus().getCode();            
            String txtErr = studentsForm.getTxtErr();
            String txtMsg = studentsForm.getTxtMsg();
            studentsForm = null;
            
            return "redirect:students.view?passCutOffPointAdmissionBachelor=" + request.getParameter("cutOffPointAdmissionBachelor")
            	+ "&studyPlanStatusCode=" + studyPlanStatusCode
            	+ "&txtErr=" + txtErr
            	+ "&txtMsg=" + txtMsg
            	+ "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
            	+ "&studyId=" + studySettings.getStudyId()
            	+ "&studyGradeTypeId=" + studySettings.getStudyGradeTypeId()
            	+ "&cardinalTimeUnitNumber=" + studySettings.getCardinalTimeUnitNumber()
            	+ "&admissionFlow=" + admissionFlow;            
        }

        /* cut-off point Continued Registration BA/BSC */
        if ("true".equals(request.getParameter("setCutOffPointContinuedRegistrationBachelor"))) {
            
        	if (log.isDebugEnabled()) {
                log.debug("StudentsController.processSubmit: cut off point continued registration ba/bsc");
            }
            
        	if (!"".equals(studentsForm.getCardinalTimeUnitStatusCode())) {
                prevCardinalTimeUnitStatusCode = studentsForm.getCardinalTimeUnitStatusCode();
                if (!StringUtil.isNullOrEmpty(request.getParameter("nextCardinalTimeUnitStatusCode"))) {
                    nextCardinalTimeUnitStatusCode = (request.getParameter("nextCardinalTimeUnitStatusCode"));
                }
            }
            status.setComplete();
            
            String cardinalTimeUnitStatusCode = studentsForm.getCardinalTimeUnitStatusCode();
            String txtErr = studentsForm.getTxtErr();
            String txtMsg = studentsForm.getTxtMsg();
            studentsForm = null;
            
            return "redirect:students.view?passCutOffPointContinuedRegistrationBachelor=" + request.getParameter("cutOffPointContinuedRegistrationBachelor")
            	+ "&cardinalTimeUnitStatusCode=" + cardinalTimeUnitStatusCode
            	+ "&txtErr=" + txtErr
            	+ "&txtMsg=" + txtMsg
            	+ "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
            	+ "&studyId=" + studySettings.getStudyId()
            	+ "&studyGradeTypeId=" + studySettings.getStudyGradeTypeId()
            	+ "&cardinalTimeUnitNumber=" + studySettings.getCardinalTimeUnitNumber()
            	+ "&admissionFlow=" + admissionFlow 
            	+ "&continuedRegistrationFlow=" + continuedRegistrationFlow;
        }
        
        /* cut-off point Continued Registration MA/MSC */
        if ("true".equals(request.getParameter("setCutOffPointContinuedRegistrationMaster"))) {
            
        	if (log.isDebugEnabled()) {
                log.debug("StudentsController.processSubmit: cut off point continued registration ma/msc");
            }
            if (!"".equals(studentsForm.getCardinalTimeUnitStatusCode())) {
                prevCardinalTimeUnitStatusCode = studentsForm.getCardinalTimeUnitStatusCode();
                if (!StringUtil.isNullOrEmpty(request.getParameter("nextCardinalTimeUnitStatusCode"))) {
                    nextCardinalTimeUnitStatusCode = (request.getParameter("nextCardinalTimeUnitStatusCode"));
                }
            }
            status.setComplete();
            
            String cardinalTimeUnitStatusCode = studentsForm.getCardinalTimeUnitStatusCode();
            String txtErr = studentsForm.getTxtErr();
            String txtMsg = studentsForm.getTxtMsg();
            studentsForm = null;
            
            return "redirect:students.view?passCutOffPointContinuedRegistrationMaster=" + request.getParameter("cutOffPointContinuedRegistrationMaster")
            	+ "&cardinalTimeUnitStatusCode=" + cardinalTimeUnitStatusCode
            	+ "&txtErr=" + txtErr
            	+ "&txtMsg=" + txtMsg
            	+ "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
            	+ "&studyId=" + studySettings.getStudyId()
            	+ "&studyGradeTypeId=" + studySettings.getStudyGradeTypeId()
            	+ "&cardinalTimeUnitNumber=" + studySettings.getCardinalTimeUnitNumber()
            	+ "&continuedRegistrationFlow=" + continuedRegistrationFlow;
        }

        if ("true".equals(request.getParameter("submitStudentSelection")) 
                && (!"".equals(studentsForm.getStudySettings().getStudyPlanStatus().getCode())
                        || !"".equals(studentsForm.getCardinalTimeUnitStatusCode()) 
            )) {
            if (log.isDebugEnabled()) {
                log.debug("StudentsController.processSubmit: entering proceed statuses admission / continued registration");
            }
            
            /* CUT-OFF POINT ADMISSION */
            if (OpusConstants.STUDYPLAN_STATUS_WAITING_FOR_SELECTION.equals(
                        studentsForm.getStudySettings().getStudyPlanStatus().getCode())) {
                prevStudyPlanStatusCode = OpusConstants.STUDYPLAN_STATUS_WAITING_FOR_SELECTION;
                nextStudyPlanStatusCode = OpusConstants.STUDYPLAN_STATUS_APPROVED_ADMISSION;
            } else {
            		/* PROGRESS ADMISSION */
                    if (!"".equals(studentsForm.getStudySettings().getStudyPlanStatus().getCode())) {
                    prevStudyPlanStatusCode = studentsForm.getStudySettings().getStudyPlanStatus().getCode();
                    if (!StringUtil.isNullOrEmpty(request.getParameter("nextStudyPlanStatusCode"))) {
                        nextStudyPlanStatusCode = (request.getParameter("nextStudyPlanStatusCode"));
                    }
                }
            }
            /* CUT-OFF POINT CONTINUED REGISTRATION */
//            if (OpusConstants.CARDINALTIMEUNIT_STATUS_WAITING_FOR_SELECTION.equals(
//                    studentsForm.getCardinalTimeUnitStatusCode())) {
//            	prevCardinalTimeUnitStatusCode = OpusConstants.CARDINALTIMEUNIT_STATUS_WAITING_FOR_SELECTION;
//            	nextCardinalTimeUnitStatusCode = OpusConstants.CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME;
//            } else {
            		/* PROGRESS CONTINUED REGISTRATION */
                    if (!"".equals(studentsForm.getCardinalTimeUnitStatusCode())) {
	                prevCardinalTimeUnitStatusCode = studentsForm.getCardinalTimeUnitStatusCode();
	                if (!StringUtil.isNullOrEmpty(request.getParameter("nextCardinalTimeUnitStatusCode"))) {
	                    nextCardinalTimeUnitStatusCode = (request.getParameter("nextCardinalTimeUnitStatusCode"));
	                }
	            }
//            }

            StudentList students = studentsForm.getAllStudents();
            students = studentManager.filterStudents(students, prevStudyPlanStatusCode, nextStudyPlanStatusCode,
                    prevCardinalTimeUnitStatusCode, nextCardinalTimeUnitStatusCode, request);            
            
            status.setComplete();
            
            return "redirect:students.view?studyPlanStatusCode=" + nextStudyPlanStatusCode
            	+ "&cardinalTimeUnitStatusCode=" + nextCardinalTimeUnitStatusCode
            	+ "&txtErr=" + studentsForm.getTxtErr()
            	+ "&txtMsg=" + studentsForm.getTxtMsg()
            	+ "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
            	+ "&studyId=" + studySettings.getStudyId()
                + "&studyGradeTypeId=" + studySettings.getStudyGradeTypeId()
                + "&cardinalTimeUnitNumber=" + studySettings.getCardinalTimeUnitNumber()
            	+ "&admissionFlow=" + admissionFlow
                + "&continuedRegistrationFlow=" + continuedRegistrationFlow;
        } else {
            if (log.isDebugEnabled()) {
                log.debug("StudentsController.processSubmit: not entering proceed statuses admission / continued registration:"
                        + " studentsForm.getStudySettings().getStudyPlanStatus().getCode() = " + studentsForm.getStudySettings().getStudyPlanStatus().getCode()
                        + ", studentsForm.getCardinalTimeUnitStatusCode() = " + studentsForm.getCardinalTimeUnitStatusCode());
            }
        }
        if (log.isDebugEnabled()) {
            log.debug("StudentsController.processSubmit: simple return to page");
        }
        return "redirect:students.view?"
            + "admissionFlow=" + admissionFlow
            + "&continuedRegistrationFlow=" + continuedRegistrationFlow;
    }

}
