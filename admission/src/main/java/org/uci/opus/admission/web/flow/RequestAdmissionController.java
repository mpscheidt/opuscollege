/*******************************************************************************
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
 * The Original Code is Opus-College admission module code.
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
package org.uci.opus.admission.web.flow;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.admission.validators.RequestAdmissionValidator;
import org.uci.opus.admission.web.form.RequestAdmissionForm;
import org.uci.opus.college.domain.Address;
import org.uci.opus.college.domain.AppConfigAttribute;
import org.uci.opus.college.domain.CareerPosition;
import org.uci.opus.college.domain.DisciplineGroup;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup9;
import org.uci.opus.college.domain.ObtainedQualification;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.Referee;
import org.uci.opus.college.domain.SecondarySchoolSubject;
import org.uci.opus.college.domain.SecondarySchoolSubjectGroup;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.college.domain.StudyPlanDetail;
import org.uci.opus.college.net.OpusMailSender;
import org.uci.opus.college.persistence.DisciplineGroupMapper;
import org.uci.opus.college.service.AddressManagerInterface;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudentNumberGeneratorInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.extpoint.CollegeServiceExtensions;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.ListUtil;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ReportUtils;
import org.uci.opus.util.StringUtil;

import net.sf.jasperreports.engine.JRException;

/**
 * @author move
 * Servlet implementation class for Servlet: RequestAdmissionController.
 * Handles initial student admission
 */
@Controller
@RequestMapping("/request_admission.view")
@SessionAttributes({RequestAdmissionController.REQUEST_ADMISSION_FORM})
public class RequestAdmissionController {

    public static final String REQUEST_ADMISSION_FORM = "requestAdmissionForm";

    private static Logger log = LoggerFactory.getLogger(RequestAdmissionController.class);
    private String formView = "admission/requestAdmission";
    RequestAdmissionForm requestAdmissionForm = null;
    @Autowired private AddressManagerInterface addressManager;
    @Autowired private AppConfigManagerInterface appConfigManager;
    @Autowired private CollegeServiceExtensions collegeServiceExtensions;
    @Autowired private DisciplineGroupMapper disciplineGroupMapper;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private MessageSource messageSource;
    @Autowired private RequestAdmissionValidator requestAdmissionValidator;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private DataSource dataSource;
    @Autowired private OpusInit opusInit;
    
    /**
     * If newForm=true and preferrendLanguage is not specified, then determine the default language and redirect.
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(method=RequestMethod.GET, params = "!preferredLanguage")
    public String setUpLocale(ModelMap model, HttpServletRequest request) {
        
        // Note: It should be possible to specify both "newForm=true" and !preferredLanguage in the params clause of the @RequestMapping.
        //   However, this didn't work, so checking one of the conditions in source code should provide the same result.

        if (opusMethods.isNewForm(request)) {
            return "redirect:/request_admission.view?newForm=true&preferredLanguage=" + appConfigManager.getAppLanguages().get(0);
        } else {
            return setUpForm(model, request);
        }
        
    }

    /**
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {
        
        if (log.isDebugEnabled()) {
            log.debug("RequestAdmissionController.setUpForm entered...");  
        }
        
    	/* This controller may be entered by the "request admission" link on the login page, 
    	 * by a submit in the obtainedQualification or in the careerPosition page
    	 */
        NavigationSettings navigationSettings = null;

        Student student = null;
        Address address = null;
        StudyPlan studyPlan = null;
        StudyPlan secondStudyPlan = null;
        StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit = null;

        OpusUserRole opusUserRole = null;
        OpusUser opusUser = null;
        String preferredLanguage = "";

        /* start new session and retrieve context from session */
        HttpSession session = request.getSession(false);
        ServletContext context = session.getServletContext();
        WebApplicationContext webContext = 
        	WebApplicationContextUtils.getWebApplicationContext(context);

        opusMethods.setInitParams(webContext, context, session);

        opusMethods.removeSessionFormObject(REQUEST_ADMISSION_FORM, session, model, opusMethods.isNewForm(request));

        requestAdmissionForm = (RequestAdmissionForm) model.get(REQUEST_ADMISSION_FORM);
        
        // NEW FORM OBJECT
        // not true when entering from ObtainedQualification or careerPosition
        if (requestAdmissionForm == null) {
            requestAdmissionForm = new RequestAdmissionForm();
            
            /* choose the initial language of the application - set the base language (2 letter code): */
            preferredLanguage = OpusMethods.getPreferredLanguage(request);
            requestAdmissionForm.setPreferredLanguage(preferredLanguage);
            
            // NEW STUDENT
            student = new Student();
    
            // default values:
            student.addStudentStudentStatus(new Date(), OpusConstants.STUDENTSTATUS_ACTIVE);
            student.setActive(OpusConstants.PERSON_ACTIVE);
            student.setPublicHomepage("N");
            student.setScholarship("N");
            student.setRegistrationDate(new Date());
            student.setDateOfEnrolment(new Date());
            student.setSubscriptionRequirementsFulfilled("N");

            requestAdmissionForm.setStudent(student);

            // NEW OPUSUSER
            opusUser = new OpusUser();
            opusUser.setLang(appConfigManager.getAppLanguages().get(0));       
            requestAdmissionForm.setOpusUser(opusUser);

            opusUserRole = new OpusUserRole();
            opusUserRole.setRole("student");
            requestAdmissionForm.setOpusUserRole(opusUserRole);

            // STUDYPLANCTU
            studyPlanCardinalTimeUnit = new StudyPlanCardinalTimeUnit();
            studyPlanCardinalTimeUnit.setCardinalTimeUnitStatusCode(
                    appConfigManager.getCntdRegistrationInitialCardinalTimeUnitStatus());
            studyPlanCardinalTimeUnit.setActive("Y");
            studyPlanCardinalTimeUnit.setTuitionWaiver("N");
            studyPlanCardinalTimeUnit.setStudyIntensityCode(OpusConstants.STUDY_INTENSITY_FULLTIME);
            requestAdmissionForm.setStudyPlanCardinalTimeUnit(studyPlanCardinalTimeUnit);
            
            // STUDYPLAN
            studyPlan = new StudyPlan();
            studyPlan.setActive("Y");
            studyPlan.setStudyPlanStatusCode(appConfigManager.getAdmissionInitialStudyPlanStatus());
            // needs to be added to the student because it is checked in the 
            // CbuStudentNumberGenerator.getOnSubmitValidator
            List<StudyPlan> studyPlans = new ArrayList<>();
            studyPlans.add(0, studyPlan);
    
            // add studyPlan to form for easy access
            requestAdmissionForm.setStudyPlan(studyPlan);
            
            if (opusInit.isSecondStudy()) {

                // second studyPlan
                secondStudyPlan = new StudyPlan();
                secondStudyPlan.setActive("Y");
                // study of second choice, so this should be changed manually if needed
                secondStudyPlan.setStudyPlanStatusCode(OpusConstants
                                                    .STUDYPLAN_STATUS_TEMPORARILY_INACTIVE);
                
                // CTU of second studyPlan
                StudyPlanCardinalTimeUnit secondStudyPlanCTU = new StudyPlanCardinalTimeUnit();
                secondStudyPlanCTU.setCardinalTimeUnitStatusCode(
                        OpusConstants.CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT );
                secondStudyPlanCTU.setActive("Y");
                secondStudyPlanCTU.setTuitionWaiver("N");
                
                // add studyPlan and studyPlanCTU to form for easy access
                requestAdmissionForm.setSecondStudyPlan(secondStudyPlan);
                requestAdmissionForm.setSecondStudyPlanCardinalTimeUnit(secondStudyPlanCTU);

                studyPlans.add(1, secondStudyPlan);
            }
            // needs to be added to the student because it is checked in the 
            // CbuStudentNumberGenerator.getOnSubmitValidator
            student.setStudyPlans(studyPlans);
            
            // NEW ADDRESS
        	address = new Address();
        	address.setAddressTypeCode(OpusConstants.FORMAL_ADDRESS_STUDENT);
          	// initially choose the default countryCode
            address.setCountryCode(appConfigManager.getCountryCode());
 
            // put the constructed address in the form:
            requestAdmissionForm.setAddress(address);
            
            /* requestAdmissionForm.NAVIGATIONSETTINGS - fetch or create the object */
          	navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, "/register.view");
            requestAdmissionForm.setNavigationSettings(navigationSettings);
            
            /* study domain attributes */
            Map<String, Object> academicYearMap = new HashMap<>();
            requestAdmissionForm.setAllAcademicYears(studyManager.findAllAcademicYears(academicYearMap));
            
            // requestAdmissionForm.setAllStudies(studyManager.findStudiesForAdmission(preferredLanguage));
            requestAdmissionForm.setAllStudyGradeTypes(studyManager.findStudyGradeTypesForAdmission(preferredLanguage));

        // enter from ObtainedQualification or careerPosition
        } else {
            preferredLanguage = requestAdmissionForm.getPreferredLanguage();
        }
        
        /* fill the lookups and request attributes needed to fill the lookups and other lists */
        request = fillLookupsAndLists(request, preferredLanguage, requestAdmissionForm.getStudent()
                , requestAdmissionForm.getAddress());

        model.addAttribute(REQUEST_ADMISSION_FORM, requestAdmissionForm);        
        return formView;
    }

    /**
     * @param requestAdmissionForm
     * @param result
     * @param status
     * @param request
     * @return
     * @throws IOException 
     * @throws SQLException 
     * @throws JRException 
     */
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
            @ModelAttribute(REQUEST_ADMISSION_FORM) RequestAdmissionForm requestAdmissionForm,
            BindingResult result, SessionStatus status, HttpServletRequest request,
            @RequestParam("previousDiplomaFile") MultipartFile previousDiplomaFile) throws IOException, JRException, SQLException {
  
        if (log.isDebugEnabled()) {
            log.debug("RequestAdmissionController.processSubmit entered...");  
            log.debug("RequestAdmissionController.processSubmit - File = " 
                                        + previousDiplomaFile.getOriginalFilename() + " / " 
                                        + previousDiplomaFile.getContentType());
        }

        HttpSession session = request.getSession(false);
        boolean showSecondarySchoolSubjects = false;
        requestAdmissionForm.setTxtErr("");
        NavigationSettings navigationSettings = requestAdmissionForm.getNavigationSettings();

        Address address = requestAdmissionForm.getAddress();
        Student student = requestAdmissionForm.getStudent();
        if (student.getRelativeOfStaffMember().equalsIgnoreCase(OpusConstants.GENERAL_NO)) {
            student.setEmployeeNumberOfRelative(null); 
        }
        StudyPlan studyPlan = requestAdmissionForm.getStudyPlan();
        StudyPlanCardinalTimeUnit studyPlanCardinalTimeUnit =
                                        requestAdmissionForm.getStudyPlanCardinalTimeUnit();
        
        // in case of secondary study
        StudyPlan secondStudyPlan = null;
        StudyPlanCardinalTimeUnit secondStudyPlanCardinalTimeUnit = null;
        
        List < SecondarySchoolSubjectGroup > secondarySchoolSubjectGroups =
                requestAdmissionForm.getSecondarySchoolSubjectGroups();
        List < SecondarySchoolSubject > groupedSecondarySchoolSubjects = new ArrayList<>();
        List < ObtainedQualification > allObtainedQualifications =
                                        requestAdmissionForm.getAllObtainedQualifications();
        List < CareerPosition > allCareerPositions =
                                requestAdmissionForm.getAllCareerPositions();
        Referee firstReferee = requestAdmissionForm.getFirstReferee();
        Referee secondReferee = requestAdmissionForm.getSecondReferee();
        int opusUserOrganizationalUnitId = 0;
        StudyGradeType selectedStudyGradeType = null;
        boolean gradeTypeIsBachelor = false;
        boolean gradeTypeIsMaster = false;
        String mailEnabled = null;

        /* fetch needed appconfig attributes */
        List <? extends AppConfigAttribute> appConfig = opusMethods.getAppConfig();       
	    for (int i=0;i<appConfig.size();i++) {
        	if ("mailEnabled".equals(appConfig.get(i).getAppConfigAttributeName())) {
        		mailEnabled = appConfig.get(i).getAppConfigAttributeValue();
        	}
        }
	    
        /* fill opusUserRole and opusUser */
        OpusUserRole opusUserRole = requestAdmissionForm.getOpusUserRole();
        OpusUser opusUser = requestAdmissionForm.getOpusUser();
        
        Locale currentLoc = RequestContextUtils.getLocale(request);
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
        String submitFormObject = "";
        String deleteQualification = "";
        String deleteCareer = "";
        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("deleteQualification"))) {
            deleteQualification = request.getParameter("deleteQualification");
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("deleteCareer"))) {
            deleteCareer = request.getParameter("deleteCareer");
        }

        // give a temporary description to the studyPlan
        String studyPlanDescription = "";

        if (student.getPrimaryStudyId() != 0) {
            
            // get the organizationalUnitId from the study
            studyPlan.setStudyId(student.getPrimaryStudyId());
            opusUserOrganizationalUnitId = studyManager.findStudy(student.getPrimaryStudyId())
                                                                    .getOrganizationalUnitId();
            // extend opususer and opususerrole with this orgunit:
            opusUserRole.setOrganizationalUnitId(opusUserOrganizationalUnitId);
            opusUser.setPreferredOrganizationalUnitId(opusUserOrganizationalUnitId);
            requestAdmissionForm.setOpusUserRole(opusUserRole);
            requestAdmissionForm.setOpusUser(opusUser);

            /* generate personCode */
            String personCode = StringUtil.createUniqueCode("P", "" 
                                                            + opusUserOrganizationalUnitId);
            student.setPersonCode(personCode);
            
            // start filling the studyPlanDescription
            studyPlanDescription = studyManager.findStudy(studyPlan.getStudyId())
                                                                .getStudyDescription();
        }
        
        // PREV. INSTITUTION DIPLOMA PHOTOGRAPH
        // validate previous diploma (if one has been chosen)
        boolean bPreviousDiplomaFile = !previousDiplomaFile.isEmpty();
        if (bPreviousDiplomaFile) {
            List<String> imageMimeTypes = OpusMethods.getImageMimeTypes(session);
            List<String> docMimeTypes = OpusMethods.getDocMimeTypes(session);
            String previousDiplomaContentType = previousDiplomaFile.getContentType();
            if (!imageMimeTypes.contains(previousDiplomaContentType) &&
                    !docMimeTypes.contains(previousDiplomaContentType)) {
                result.rejectValue("student.previousInstitutionDiplomaPhotograph"
                                                            , "invalid.doctype.format");
            }
        }
        
        // put the diploma image into the Student object
        if (bPreviousDiplomaFile) {
			student.setPreviousInstitutionDiplomaPhotograph(previousDiplomaFile.getBytes());
            student.setPreviousInstitutionDiplomaPhotographName(previousDiplomaFile.getName());
            student.setPreviousInstitutionDiplomaPhotographMimeType(
                                                        previousDiplomaFile.getContentType());
        }

        if (studyPlanCardinalTimeUnit.getStudyGradeTypeId() != 0) {

        	selectedStudyGradeType = studyManager.findStudyGradeType(
        			studyPlanCardinalTimeUnit.getStudyGradeTypeId());
        	gradeTypeIsBachelor = opusMethods.isGradeTypeIsBachelor(preferredLanguage
        										, selectedStudyGradeType.getGradeTypeCode());
        	requestAdmissionForm.setGradeTypeIsBachelor(gradeTypeIsBachelor);
        	
        	gradeTypeIsMaster = opusMethods.isGradeTypeIsMaster(preferredLanguage
        										, selectedStudyGradeType.getGradeTypeCode());
        	requestAdmissionForm.setGradeTypeIsMaster(gradeTypeIsMaster);
            // get the gradeTypeCode
            Lookup gradeType = studyManager.findGradeTypeByStudyGradeTypeId(
                                            studyPlanCardinalTimeUnit.getStudyGradeTypeId()
                                            , preferredLanguage);
            studyPlan.setGradeTypeCode(gradeType.getCode());
            studyPlanDescription = studyPlanDescription + " - " + gradeType.getDescription();
            
        } else {
           requestAdmissionForm.setSecondarySchoolSubjectGroups(null);
            requestAdmissionForm.setUngroupedSecondarySchoolSubjects(null);
        }

        studyPlan.setStudyPlanDescription(studyPlanDescription);
        requestAdmissionForm.setStudyPlan(studyPlan);  
        
        if (studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber() != 0) {
            // if "Y" then add a second study choice
            if (opusInit.isSecondStudy()) {
               // second study chosen
               if (requestAdmissionForm.getStudent().getSecondaryStudyId() != 0) {
                   // set the studyId in the second studyplan 
                   secondStudyPlan = requestAdmissionForm.getSecondStudyPlan();
                   StudyPlanCardinalTimeUnit secondStudyPlanCTU =
                                                   requestAdmissionForm.getSecondStudyPlanCardinalTimeUnit();
                   secondStudyPlan.setStudyId(requestAdmissionForm.getStudent().getSecondaryStudyId());
                   String secondStudyPlanDescription = studyManager.findStudy(
                                                       requestAdmissionForm.getStudent().getSecondaryStudyId())
                                                       .getStudyDescription();
                   // second gradeType chosen
                   if (secondStudyPlanCTU.getStudyGradeTypeId() != 0) {
                       // get the gradeTypeCode
                       Lookup secondGradeType = studyManager.findGradeTypeByStudyGradeTypeId(
                               secondStudyPlanCTU.getStudyGradeTypeId()
                               , preferredLanguage);
                       secondStudyPlan.setGradeTypeCode(secondGradeType.getCode());
                       secondStudyPlanDescription = secondStudyPlanDescription
                                                   + " - " + secondGradeType.getDescription();

                  }
                   secondStudyPlan.setStudyPlanDescription(secondStudyPlanDescription);
                   requestAdmissionForm.setSecondStudyPlan(secondStudyPlan);  
                   
               }
            }
            
            int CTUnumber = studyPlanCardinalTimeUnit.getCardinalTimeUnitNumber();
            
            // ADMISSION CRITERIA MASTERS, CTU 1 
            if(gradeTypeIsMaster && CTUnumber == 1) {
                if (!StringUtil.isNullOrEmpty(selectedStudyGradeType.getDisciplineGroupCode(), true)) {
                    String groupCode = selectedStudyGradeType.getDisciplineGroupCode();

                    DisciplineGroup disciplineGroup = disciplineGroupMapper.findByCode(groupCode);
                    requestAdmissionForm.setDisciplineGroup(disciplineGroup);

                    // show disciplines to choose from
                    Map<String, Object> map = new HashMap<>();
                    map.put("code", groupCode);
                    requestAdmissionForm.setAllDisciplines(studyManager.findDisciplinesForGroup(map));
                    
                /* if requesting admission for a master in the first CTU, a previous
                 * discipline must be chosen. This studyGradeType has no discipline group 
                 * (which contains disciplines) connected, so there are no disciplines to 
                 * choose from for the prospective student.
                 */
                } else {
                    // show error
                    requestAdmissionForm.setTxtDisciplineErr(messageSource.getMessage(
                            "jsp.error.missing.disciplinegroup", null, currentLoc));

                    return formView;
                }
            } else {
                requestAdmissionForm.setDisciplineGroup(null);
                requestAdmissionForm.setAllDisciplines(null);
            }
            
            // SUBSCRIPTION DATA - SECONDARY SCHOOLSUBJECTS GROUP (only for BSC and BA gradetypes)
        	if (!"Y".equals(student.getForeignStudent())
                && gradeTypeIsBachelor && CTUnumber == 1) {
        	    showSecondarySchoolSubjects = true;
        	    
        		if (log.isDebugEnabled()) {
                	log.debug("requestAdmissionForm.BA / BSC and not foreign students"
                	                    + " - fetch the secondaryschoolsubjectgroups" );
                }
        	}
        	
        	if (showSecondarySchoolSubjects) {
        		if (requestAdmissionForm.getSecondarySchoolSubjectGroups() != null 
        		        && requestAdmissionForm.getSecondarySchoolSubjectGroups().size() > 0) {
	                secondarySchoolSubjectGroups = requestAdmissionForm
	                                                    .getSecondarySchoolSubjectGroups();
	        	} else {
	            	// get the groups
	                secondarySchoolSubjectGroups = studyManager.findSecondarySchoolSubjectGroups(
	                        studyPlanCardinalTimeUnit.getStudyGradeTypeId(), preferredLanguage);
	                requestAdmissionForm.setSecondarySchoolSubjectGroups(
	                                                        secondarySchoolSubjectGroups);
	            	for (int i = 0 ; i < secondarySchoolSubjectGroups.size();i++) {
	                	groupedSecondarySchoolSubjects.addAll(
	            				secondarySchoolSubjectGroups.get(i).getSecondarySchoolSubjects());
	            	}
	                    
	                /* removed: test if there are enough subjects in every group so the
	                 correct number can be graded */

	            	// get the subjects ungrouped
	                int lowestGradeOfSecondarySchoolSubjects  = appConfigManager.getSecondarySchoolSubjectsLowestGrade();
	                int highestGradeOfSecondarySchoolSubjects = appConfigManager.getSecondarySchoolSubjectsHighestGrade();
	            	
	            	Map<String, Object> map = new HashMap<>();
	                map.put("studyPlanId", studyPlan.getId());
	                
	                map.put("preferredLanguage", preferredLanguage);
	                map.put("defaultMaximumGradePoint", highestGradeOfSecondarySchoolSubjects);
	                map.put("defaultMinimumGradePoint", lowestGradeOfSecondarySchoolSubjects);
	                map.put("defaultWeight", 1);

	                // add all secondarySchoolSubjects for this studyplan:
	                List < SecondarySchoolSubject > allSecondarySchoolSubjects =
	                	studyManager.findUngroupedSecondarySchoolSubjectsForStudyPlan(map);
	                // if the subject exists in a group, replace it with the grouped version
	                SecondarySchoolSubject allSubject = null;
                    List<SecondarySchoolSubject> showListSecondarySchoolSubjects = new ArrayList<>();
	                showListSecondarySchoolSubjects.addAll(groupedSecondarySchoolSubjects);
	                for (int i = 0; i < allSecondarySchoolSubjects.size(); i++) {
	                	allSubject = allSecondarySchoolSubjects.get(i);
	                	for (int j = 0; j < groupedSecondarySchoolSubjects.size();j++) {
	            			if (allSecondarySchoolSubjects.get(i).getId() != 
	            						groupedSecondarySchoolSubjects.get(j).getId()) {
	            				// continue
	            				
	            			/* if the subject already exists in the grouped subjects, and
	            		       therefore in the showListSubjects do not add it again */
	            			} else {
	            				allSubject = null;
	            				break;
	            			}
	            		}
	                	// subject was not found in the existing list, so add it
	            		if (allSubject != null) {
	            			showListSecondarySchoolSubjects.add(allSubject);
	            		}
	                }
	                
	                requestAdmissionForm.setUngroupedSecondarySchoolSubjects(
	                		showListSecondarySchoolSubjects);
	            }
        	}
        } else { // CardinalTimeUnitNumber = 0

            if (opusInit.isSecondStudy()) {
                requestAdmissionForm.getStudent().setSecondaryStudyId(0);
                requestAdmissionForm.getSecondStudyPlanCardinalTimeUnit().setStudyGradeTypeId(0);
                requestAdmissionForm.getSecondStudyPlanCardinalTimeUnit().setCardinalTimeUnitNumber(0);
            }
            
            requestAdmissionForm.setSecondarySchoolSubjectGroups(null);
            requestAdmissionForm.setUngroupedSecondarySchoolSubjects(null);
            requestAdmissionForm.setDisciplineGroup(null);
            requestAdmissionForm.setAllDisciplines(null);
        }

        // lookups
        request = fillLookupsAndLists(request, preferredLanguage, student, address);

        // update the requestAdmissionForm with the changed student
        requestAdmissionForm.setStudent(student);

        if (!"".equals(deleteQualification)) {
            int index = Integer.parseInt(deleteQualification);
            requestAdmissionForm.getAllObtainedQualifications().remove(index);
        }
        
        if (!"".equals(deleteCareer)) {
            int index = Integer.parseInt(deleteCareer);
            requestAdmissionForm.getAllCareerPositions().remove(index);
        }

        if ("true".equals(submitFormObject)) {
            // validator checks
            requestAdmissionValidator.onBindAndValidate(request, requestAdmissionForm, result);
            if (result.hasErrors()) {
                requestAdmissionForm.setTxtErr(
                        messageSource.getMessage(
                         "jsp.error.requestadmission", null, currentLoc)
                );
                return formView;
            }
            
            // other checks
            
            /* test if the combination already exists */
            Map<String, Object> findStudentMap = new HashMap<>();
            findStudentMap.put("surnameFull", student.getSurnameFull());
            findStudentMap.put("firstNamesFull", student.getFirstnamesFull());
            findStudentMap.put("birthdate", student.getBirthdate());
            findStudentMap.put("primaryStudyId", student.getPrimaryStudyId());
            findStudentMap.put("nationalRegistrationNumber", student
                                                            .getNationalRegistrationNumber());
            if (studentManager.findStudentByParams(findStudentMap) != null) {
                requestAdmissionForm.setTxtErr(
                        messageSource.getMessage(
                                "jsp.error.student.edit", null, currentLoc)
                        + messageSource.getMessage(
                                "jsp.error.general.alreadyexists", null, currentLoc)
                    );
            }
            
            /* secondary schoolsubject grades need to be entered by request for admission
             * for a bachelor study, first CTU, but not by foreign students
             */
            if (showSecondarySchoolSubjects) {
                // removed: test if there are enough subjects so the correct number can be graded
                // removed: check if the correct number of subjects is graded
    
                if (StringUtil.isNullOrEmpty(requestAdmissionForm.getTxtErr(), true)) {
                	
                	// check validity grouped secondary school subjects before adding student:
                	if (secondarySchoolSubjectGroups != null && secondarySchoolSubjectGroups.size() > 0) {
                		
                		List < SecondarySchoolSubject > compareSubjects = new ArrayList<>();
                		
                		for (SecondarySchoolSubjectGroup subjectGroup : secondarySchoolSubjectGroups) {
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
    	                            			countSubject = countSubject+1;
    	                            		}
                                		}
                                	}
                                	if (countSubject > 1) {
                            			requestAdmissionForm.setTxtErr(
                                             messageSource.getMessage(
                                                 "jsp.error.student.edit", null, currentLoc)
                                             + messageSource.getMessage(
                                                "jsp.error.secondaryschoolsubject.already.graded"
                                                                             , null, currentLoc)
                                        );
                            			break;
                            		}
                            	}
                            }
                        }
                	}
                }
            }  // end showSecondarySchoolSubjects
    
            
            /* retrieve updated or new student for its studentId, only if no error occurred */
            if (StringUtil.isNullOrEmpty(requestAdmissionForm.getTxtErr(), true)) {

                // Allow the number generator the create a studentCode
                String studentCode = collegeServiceExtensions.createUniqueStudentCode(
                		StudentNumberGeneratorInterface.KEY_SUBMIT, opusUserOrganizationalUnitId
                		, student);
                student.setStudentCode(studentCode);

                // opusUser object is needed for write operations - set dummy userName 
                // add to the session
                opusUser.setUserName("admission");
                String writeWho = "admission";      // there is no logged in user during admission
                request.setAttribute("writeWho", writeWho);
                
                // ADD
                // student
                student.setWriteWho(writeWho);
                student.setStudentWriteWho(writeWho);
                studentManager.addStudent(student, opusUserRole, opusUser);
                int newStudentId = student.getStudentId();
                // in order to add the address, we need the personId of the student
//                int personId = studentManager.findStudent(preferredLanguage, newStudentId).getPersonId();
                
                address.setPersonId(student.getPersonId());
                addressManager.addAddress(address);
                
                // studyPlan
                studyPlan.setStudentId(newStudentId);
                studentManager.addStudyPlanToStudent(studyPlan, writeWho);
                int newStudyPlanId = studyPlan.getId();

                // studyPlanCardinalTimeUnit
                studyPlanCardinalTimeUnit.setStudyPlanId(newStudyPlanId);
                studentManager.addStudyPlanCardinalTimeUnit(requestAdmissionForm.getStudyPlanCardinalTimeUnit(), null, request);
                
                // create compulsory studyplandetails for new studyplanctu:
                String iMajorMinor = opusInit.getMajorMinor();
				String iUseOfPartTimeStudyGradeTypes = (String) session.getAttribute("iUseOfPartTimeStudyGradeTypes");
				
				List <StudyPlanDetail> allNewStudyPlanDetails = 
                	studentManager.createCompulsoryNewStudyPlanDetailsForNextStudyPlanCTU(
                		studyPlanCardinalTimeUnit, currentLoc,
                		preferredLanguage, iMajorMinor, iUseOfPartTimeStudyGradeTypes);
                StudyPlanDetail newStudyPlanDetail = null;
                
                if (allNewStudyPlanDetails != null && allNewStudyPlanDetails.size() != 0) {
        			// final step: insert the list of studyplandetails into the database:
        			for (int x = 0; x < allNewStudyPlanDetails.size(); x++) {
        				newStudyPlanDetail = allNewStudyPlanDetails.get(x);
        				
        				studentManager.addStudyPlanDetail(newStudyPlanDetail, request);
        			}
        		}
                
                // if available add second study of choice
                if (opusInit.isSecondStudy()) {
                	    
            	    secondStudyPlan = requestAdmissionForm.getSecondStudyPlan();
                    if (secondStudyPlan != null
                    		&& secondStudyPlan.getStudyId() != 0) {

                        // add second studyPlan
                        secondStudyPlan.setStudentId(newStudentId);
                        studentManager.addStudyPlanToStudent(secondStudyPlan, writeWho);
                        int newSecondStudyPlanId = secondStudyPlan.getId();

                        // add second studyPlanCardinalTimeUnit
                        secondStudyPlanCardinalTimeUnit = requestAdmissionForm.getSecondStudyPlanCardinalTimeUnit();
                        secondStudyPlanCardinalTimeUnit.setStudyPlanId(newSecondStudyPlanId);
                        studentManager.addStudyPlanCardinalTimeUnit(secondStudyPlanCardinalTimeUnit, null, request);
                        
                        // create compulsory studyPlandetails for new secondstudyplanctu:
                                                    
                        List <StudyPlanDetail> allNewSecondStudyPlanDetails = 
                            studentManager.createCompulsoryNewStudyPlanDetailsForNextStudyPlanCTU(
                                secondStudyPlanCardinalTimeUnit, currentLoc,
                                preferredLanguage, iMajorMinor, iUseOfPartTimeStudyGradeTypes);
                        StudyPlanDetail newSecondStudyPlanDetail = null;
                        
                        if (allNewSecondStudyPlanDetails != null && allNewSecondStudyPlanDetails.size() != 0) {
                            // final step: insert the list of studyplandetails into the database:
                            for (int x = 0; x < allNewSecondStudyPlanDetails.size(); x++) {
                                newSecondStudyPlanDetail = allNewSecondStudyPlanDetails.get(x);
                                
                                studentManager.addStudyPlanDetail(newSecondStudyPlanDetail, request);
                            }
                        }                            
                    }
                }
                
                if (!ListUtil.isNullOrEmpty(allObtainedQualifications)) {
                    for (int i = 0; i < allObtainedQualifications.size(); i++) {
                        ObtainedQualification obtainedQualification = allObtainedQualifications.get(i);
                        obtainedQualification.setStudyPlanId(newStudyPlanId);
                        studyManager.addObtainedQualification(obtainedQualification);
                    }
                }
                
                if (!ListUtil.isNullOrEmpty(allCareerPositions)) {
                    for (int i = 0; i < allCareerPositions.size(); i++) {
                        CareerPosition careerPosition = allCareerPositions.get(i);
                        careerPosition.setStudyPlanId(newStudyPlanId);
                        studyManager.addCareerPosition(careerPosition);
                    }
                }
                
                if (firstReferee != null && !firstReferee.isEmpty()) {
                    firstReferee.setStudyPlanId(newStudyPlanId);
                    studyManager.addReferee(firstReferee);
                    if (secondReferee != null && !secondReferee.isEmpty()) {
                        secondReferee.setStudyPlanId(newStudyPlanId);
                        studyManager.addReferee(secondReferee);
                    }
                } else {
                    if (secondReferee != null && !secondReferee.isEmpty()) {
                        secondReferee.setStudyPlanId(newStudyPlanId);
                        secondReferee.setOrderBy(1);
                        studyManager.addReferee(secondReferee);
                    }
                }
                
                if (showSecondarySchoolSubjects) {

                    // GradedUngroupedSecondarySchoolSubjects
                    if (requestAdmissionForm.getUngroupedSecondarySchoolSubjects() != null 
                    	&& requestAdmissionForm.getUngroupedSecondarySchoolSubjects().size() > 0) {
                         for (SecondarySchoolSubject ungroupedSubject : requestAdmissionForm.getUngroupedSecondarySchoolSubjects()) {
                            if (ungroupedSubject.getGradedSecondarySchoolSubjectId() == 0) {
                            	if (!StringUtil.isNullOrEmpty(ungroupedSubject.getGrade(), true) 
                                		&& !"0".equals(ungroupedSubject.getGrade())) {
                                    // add gradedSecondarySchoolSubject
                                	studyManager.addGradedSecondarySchoolSubject(ungroupedSubject,
                                			newStudyPlanId, ungroupedSubject
                                			.getSecondarySchoolSubjectGroupId()
                                			, opusMethods.getWriteWho(request));
                                }
                            }
                        }
                      
                    }
                }
               
                // SHOW NEW ACCOUNT DATA IN TEXT FILE
                String admittedText = opusMethods.generateAdmittedText(
                		currentLoc, opusUser, student.getPersonCode(), studyPlan.getApplicationNumber(), session);
                
                if (!StringUtil.isNullOrEmpty(admittedText, true)) {
                    
                    // leave the object on the session:
                    status.setComplete();
                    
                    if ("Y".equals(mailEnabled)) {
                    	String msgType = "waitingforpayment_admission";
                    	 String[] recipients = new String[1];
                    	 
                    	if (!StringUtil.isNullOrEmpty(address.getEmailAddress(), true)) {
                			recipients[0] = address.getEmailAddress();
                	
	                    	String reportPath =  request.getSession().getServletContext().getRealPath("/WEB-INF/reports/jasper/person/WaitingForPaymentLetter.jasper");
	                    	String fileSeparator = System.getProperty("file.separator" , "/");
	                    	String outputFile = System.getProperty("java.io.tmpdir", ".") + fileSeparator + "WaitingForPaymentLetter.pdf";
	                    	
	                    	Map<String, Object> reportParams = new HashMap<>();
	                    	
	                    	String whereClause = " AND studyPlan.id= " + studyPlan.getId();
	                    	
	                    	reportParams.put("whereClause", whereClause);
	                    	reportParams.put("lang", preferredLanguage);
	                        
	                    	//generate and export report to temporary folder
	                    	ReportUtils.exportReportToPdfFile(reportPath
	                    			, outputFile
	                    			, new HashMap<String, Object>()
	                    			, dataSource.getConnection());
	
	
	                    	//attach and email file
	                    	OpusMailSender mailSender = new OpusMailSender();
	                		               		   
	               		    opusMethods.sendOpusMail(mailSender, msgType, recipients
	            		    , preferredLanguage, null, new String[]{outputFile});
               		   
                    	} else {
                			recipients[0] = student.getSurnameFull();
                		}
                    	
                    }
                    // show new opusUser password in new screen;
                    return "redirect:/approved_admission.view?admittedText=" + admittedText
                        +"&tab=" + navigationSettings.getTab() + "&panel=" + navigationSettings.getPanel()
                        + "&studentId=" + newStudentId
                        + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
                } else {
                    return formView;
                }
            } else {               // txtErr found
                return formView;
            }
        } else {  // submitFormObject = false
            return formView;
        }
    }
    
    private HttpServletRequest fillLookupsAndLists(HttpServletRequest request, String preferredLanguage
            , Student student, Address address) {
        
        if (student != null) {
            /* if no country of origin is chosen,  then also province and district have to be empty */
            if (StringUtil.isNullOrEmpty(student.getCountryOfBirthCode())
                || "0".equals(student.getCountryOfBirthCode())) {
                student.setProvinceOfBirthCode("");
                student.setDistrictOfBirthCode("");
            } else {
                if ("".equals(student.getProvinceOfBirthCode()) 
                    || "0".equals(student.getProvinceOfBirthCode())) {
                    student.setDistrictOfBirthCode("");
                }
            }
            /* if a country of origin is chosen, but no province then also district has to be empty */
            if (StringUtil.isNullOrEmpty(student.getCountryOfOriginCode()) 
                    || "0".equals(student.getCountryOfOriginCode())) {
                student.setProvinceOfOriginCode("");
                student.setDistrictOfOriginCode("");
            } else {
                if ("".equals(student.getProvinceOfOriginCode()) 
                        || "0".equals(student.getProvinceOfOriginCode())) {
                    student.setDistrictOfOriginCode("");
                }
            }
        }
        
        // needed to fill the lookups correctly
        request.setAttribute("countryCode", address.getCountryCode());
        request.setAttribute("provinceCode", address.getProvinceCode());
        request.setAttribute("districtCode", address.getDistrictCode());
        request.setAttribute("administrativePostCode", address.getAdministrativePostCode());        
        request.setAttribute("countryOfBirthCode", student.getCountryOfBirthCode());
        request.setAttribute("provinceOfBirthCode", student.getProvinceOfBirthCode());
        request.setAttribute("districtOfBirthCode", student.getDistrictOfBirthCode());
        request.setAttribute("countryOfOriginCode", student.getCountryOfOriginCode());
        request.setAttribute("provinceOfOriginCode", student.getProvinceOfOriginCode());
        request.setAttribute("districtOfOriginCode", student.getDistrictOfOriginCode());
        
        request.setAttribute("previousInstitutionCountryCode", student.getPreviousInstitutionCountryCode());
        request.setAttribute("previousInstitutionProvinceCode", student.getPreviousInstitutionProvinceCode());
        
        lookupCacher.getPersonLookups(preferredLanguage, request);
        lookupCacher.getStudyLookups(preferredLanguage, request);
        lookupCacher.getStudentLookups(preferredLanguage, request);
        lookupCacher.getStudyPlanLookups(preferredLanguage, request);
        lookupCacher.getRequestAdmissionLookups(preferredLanguage, request);
        
        // other lists
        if (ListUtil.isNullOrEmpty(requestAdmissionForm.getAllGradeTypes())) {
            List < ? extends Lookup9 > allGradeTypes = (List<? extends Lookup9>) 
                                                    request.getAttribute("allGradeTypes");
            requestAdmissionForm.setAllGradeTypes(allGradeTypes);
        }
        
        // set initial lists for previousIntitution
        if (ListUtil.isNullOrEmpty(requestAdmissionForm.getAllPreviousInstitutions())) {
            List < Institution > allPreviousInstitutions = null;
            allPreviousInstitutions = (ArrayList < Institution >)
                                    institutionManager.findInstitutions(new HashMap<String, Object>());
            requestAdmissionForm.setAllPreviousInstitutions(allPreviousInstitutions);
        }
        return request;
        
    }
}
