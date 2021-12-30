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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestBindingException;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OpusUserManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudentNumberGeneratorInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.validator.StudentValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.person.StudentForm;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

/**
 * Servlet implementation class for Servlet: StudentSubscriptionEditController.
 *
 */
//@Controller
//@RequestMapping("/college/student-subscription")
//@SessionAttributes({ "studentForm" })
// TODO remove this file - only exists in case something has been forgotten to integrate into StudentPersonalEditCotroller
@Deprecated
public class StudentSubscriptionEditController {
    
    private static Logger log = LoggerFactory.getLogger(StudentSubscriptionEditController.class);
    private String formView;
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private OpusUserManagerInterface opusUserManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private MessageSource messageSource;
    @Autowired private StaffMemberManagerInterface staffMemberManager;

    // studentnumbergenerator must be autowired because of primary flag:
    @Autowired private StudentNumberGeneratorInterface studentNumberGenerator;
    @Autowired private StudentValidator studentValidator;     

    /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */
    public StudentSubscriptionEditController() {
        super();
        this.formView = "college/person/student-subscription";
    }

    /**
     * @param model
     * @param request
     * @return
     * @throws ServletRequestBindingException 
     */
//    @RequestMapping(method = RequestMethod.GET)
//    public String setUpForm(ModelMap model, HttpServletRequest request) throws ServletRequestBindingException 
//            {
//
//        if (log.isDebugEnabled()) {
//            log.debug("StudentSubscriptionEditController.setUpForm entered...");
//        }
//
//        // declare variables
//        StudentForm studentForm = null;
//        Student student = null;
//        Organization organization = null;
//        NavigationSettings navigationSettings = null;
//        
//        HttpSession session = request.getSession(false);        
//
//        int institutionId = 0;
//        int branchId = 0;
//        int organizationalUnitId = 0;
//
//        String showStudyPlanError = "";
//        String showStudentError = "";
//
//        int studyId = 0;
//        // the organizational unit of the study and its description
//        OrganizationalUnit unitStudy = null;
//        String unitStudyDescription = "";
//        Study study = null;
//        int studentId = 0;
//
//        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
//        securityChecker.checkSessionValid(session);
//        
//        // if adding a new student, destroy any existing one on the session
//        opusMethods.removeSessionFormObject("studentForm", session, model, opusMethods.isNewForm(request));
//        
//        /* set menu to students */
//        session.setAttribute("menuChoice", "students");
//
//        /* with each call the preferred language may be changed */
//        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
//
//        if (!StringUtil.isNullOrEmpty(request.getParameter("studentId"))) {
//            studentId = Integer.parseInt(request.getParameter("studentId"));
//        }
//
//        /* STUDENTFORM - fetch or create the form object and fill it with student */
//        studentForm = (StudentForm) model.get("studentForm");
//        if (studentForm == null) {
//        	studentForm = new StudentForm();
//        }
//        if (studentForm.getStudent() == null) {
//            // EXISTING STUDENT
//            if (studentId != 0) {
//                if (studyId == 0) {
//                    studyId = studentManager.findStudent(preferredLanguage, studentId).getPrimaryStudyId();
//                }
//                if (studyId != 0) {
//                	unitStudy = (OrganizationalUnit)
//                		organizationalUnitManager.findOrganizationalUnitOfStudy(studyId);
//                    study = studyManager.findStudy(studyId);
//                    
//	                // find organization id's matching with the study
//	                organizationalUnitId = study.getOrganizationalUnitId();
//	                branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
//	                institutionId = institutionManager.findInstitutionOfBranch(branchId);
//                }
//
//                // TODO: preferredLanguage not used, can be removed
//                student = studentManager.findStudent(preferredLanguage, studentId);
//            }
//        } else {
//            student = studentForm.getStudent(); 
//        }
//
//        String writeWho = opusMethods.getWriteWho(request);
//        student.setWriteWho(writeWho);
//        student.setStudentWriteWho(writeWho);
//        
//        studentForm.setStudent(student);
// 
//        // get primary study if not present
//        if (unitStudy != null) {
//            unitStudyDescription = unitStudy.getOrganizationalUnitDescription();
//            session.setAttribute("unitStudyDescription", unitStudyDescription);
//        }
//
//        /* STUDENTFORM.ORGANIZATION - fetch or create the object */
//        if (studentForm.getOrganization() != null) {
//        	organization = studentForm.getOrganization();
//        } else {
//        	organization = new Organization();
//
//        	// get the organization values from study:
//            organization = opusMethods.fillOrganization(session, request, organization, 
//            		organizationalUnitId, branchId, institutionId);
//        }
//        studentForm.setOrganization(organization);
//
//        /* STUDENT.NAVIGATIONSETTINGS - fetch or create the object */
//        if (studentForm.getNavigationSettings() != null) {
//        	navigationSettings = studentForm.getNavigationSettings();
//            if (!StringUtil.isNullOrEmpty(request.getParameter("tab"))) {
//            	navigationSettings.setTab(Integer.parseInt(request.getParameter("tab")));
//            }
//            if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
//            	navigationSettings.setPanel(Integer.parseInt(request.getParameter("panel")));
//            }
//        } else {
//        	navigationSettings = new NavigationSettings();
//            opusMethods.fillNavigationSettings(request, navigationSettings, "/college/student/personal.view");
//        }
//        studentForm.setNavigationSettings(navigationSettings);
//
//        // entering from overview
////        if (StringUtil.isNullOrEmpty((String) session.getAttribute("from")) 
////                && "students".equals(request.getParameter("from"))) {
////            
////        	session.setAttribute("from", "student");
////
////            if (organizationalUnitId == 0 || !StringUtil.isNullOrEmpty(navigationSettings.getSearchValue())) {
////            	study = studyManager.findStudy(student.getPrimaryStudyId());
////            	organizationalUnitId = study.getOrganizationalUnitId();
////                session.setAttribute("organizationalUnitId", organizationalUnitId);
////            }
////
////            if (branchId == 0 || !StringUtil.isNullOrEmpty(navigationSettings.getSearchValue())) {
////                branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
////                session.setAttribute("branchId", branchId);
////            }
////            
////            if (institutionId == 0 || !StringUtil.isNullOrEmpty(navigationSettings.getSearchValue())) {
////                institutionId = institutionManager.findInstitutionOfBranch(branchId);
////                session.setAttribute("institutionId", institutionId);
////            }
////        } else if (
////            // first time pulldown is changed
////            ("students".equals(request.getParameter("from")) 
////            		&& "student".equals(session.getAttribute("from")))
////                  ||
////                    // pulldown has been changed at least once already 
////                    ("student".equals(request.getParameter("from")) 
////                          && StringUtil.isNullOrEmpty((String) session.getAttribute("from"), true))
////                  ) {
////            session.setAttribute("from", null);
////
////            if (institutionId == 0) {
////                branchId = 0;
////                session.setAttribute("branchId", branchId);
////            }
////            
////            if (branchId == 0) {
////                organizationalUnitId = 0;
////                session.setAttribute("organizationalUnitId", organizationalUnitId);   
////            }
////            
////            if (organizationalUnitId == 0) {
////                studyId = 0;
////            }
////        }
//      
//      /* catch possible other errors */        
//      if (!StringUtil.isNullOrEmpty(request.getParameter("showStudyPlanError"))) {
//      	showStudyPlanError = request.getParameter("showStudyPlanError");
//      }
//      request.setAttribute("showStudyPlanError", showStudyPlanError);
//
//      if (!StringUtil.isNullOrEmpty(request.getParameter("showStudentError"))) {
//          showStudentError = request.getParameter("showStudentError");
//      }
//      request.setAttribute("showStudentError", showStudentError);
//
////      if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(
////              request, "txtErr"))) {
////      	studentForm.setTxtErr(studentForm.getTxtErr() + ServletRequestUtils.getStringParameter(
////              request, "txtErr"));
////      }
//
//      if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(request, "txtMsg"))) {
//          studentForm.setTxtMsg(ServletRequestUtils.getStringParameter(request, "txtMsg"));
//      }
//
//      // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
//      opusMethods.getInstitutionBranchOrganizationalUnitSelect(
//              session, request, organization.getInstitutionTypeCode(),
//              organization.getInstitutionId(), organization.getBranchId(), 
//              organization.getOrganizationalUnitId());
//      
//      // primary study: select only studies from current organizationalUnitId
//      List < Study > allStudies =  null;
//      Map<String, Object> findStudiesMap = new HashMap<String, Object>();
//      findStudiesMap = opusMethods.fillOrganizationMapForReadAuthorization(request, organization);
//      findStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());          
//      allStudies = studyManager.findStudies(findStudiesMap);
//      studentForm.setAllStudies(allStudies);
//      
//      // Studies for study plan studies
//      List<Integer> studyIds = DomainUtil.getIntProperties(student.getStudyPlans(), "studyId");
//      List<Study> studyPlanStudies = studyManager.findStudies(studyIds, preferredLanguage);
//      studentForm.setStudyPlanStudies(studyPlanStudies);
//
//      List < ? extends StudyGradeType > allStudyGradeTypes = null;
//      allStudyGradeTypes = opusMethods.getAllStudyGradeTypes(session, request);
//      request.setAttribute("allStudyGradeTypes", allStudyGradeTypes);
//
//      // secondary study: select all studies from current institution for selection
//      Map<String, Object> findSecondaryStudiesMap = new HashMap<String, Object>();
//      findSecondaryStudiesMap = opusMethods.fillOrganizationMapForReadAuthorization(request, organization);
//      findSecondaryStudiesMap.put("institutionId", organization.getInstitutionId());
//      findSecondaryStudiesMap.put("branchId", 0);          
//      findSecondaryStudiesMap.put("organizationalUnitId", 0);          
//      findSecondaryStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());          
//      studentForm.setAllSecondaryStudies(studyManager.findStudies(findSecondaryStudiesMap));
//
//        lookupCacher.getPersonLookups(preferredLanguage, request);
//        lookupCacher.getAddressLookups(preferredLanguage, request);
//        lookupCacher.getStudyLookups(preferredLanguage, request);
//        lookupCacher.getStudyPlanLookups(preferredLanguage, request);
//
//        Map<String, Object> findStaffMembersMap = new HashMap<String, Object>();
//        findStaffMembersMap.put("institutionId", 0);
//        findStaffMembersMap.put("branchId", 0);
//        findStaffMembersMap.put("organizationalUnitId", 0);
//        findStaffMembersMap.put("institutionTypeCode", OpusConstants.INSTITUTION_TYPE_DEFAULT);
//        studentForm.setAllStaffMembers(staffMemberManager.findStaffMembers(findStaffMembersMap));
//
//        request.setAttribute("previousInstitutionCountryCode", 
//        		student.getPreviousInstitutionCountryCode());
//        request.setAttribute("previousInstitutionProvinceCode", 
//        		student.getPreviousInstitutionProvinceCode());
//        lookupCacher.getStudentLookups(preferredLanguage, request);
//
//        // list of previous institutions (secondary, higher education, university)
//        Map<String, Object> map = new HashMap<String, Object>();
//        
//        studentForm.setAllPreviousInstitutions((ArrayList < Institution >)
//        		institutionManager.findInstitutions(map));
//
//        model.addAttribute("studentForm", studentForm);        
//        return formView;
//    }
//
//    @PreAuthorize("hasRole('student')")
//    @RequestMapping(value = "/mydetails", method = RequestMethod.GET)
//    public String setupFormForLoggedInStudent(ModelMap model, HttpServletRequest request) {
//
//        OpusUser opusUser = opusMethods.getOpusUser();
//        Student student = opusUser.getStudent();
//        if (student == null) {
//            throw new RuntimeException("Logged-in user is not a student");
//        }
//
//        boolean newForm = opusMethods.isNewForm(request);
//        int tab = ServletUtil.getIntParam(request, "tab", 2);
//        return "redirect:/college/student-subscription.view?newForm=" + newForm + "&studentId=" + student.getStudentId() + "&tab=" + tab;
//    }
//
//    /**
//     * @param studentForm
//     * @param result
//     * @param status
//     * @param request
//     * @return
//     */
//    @RequestMapping(method = RequestMethod.POST)
//    public String processSubmit(
//    		@ModelAttribute("studentForm") StudentForm studentForm,
//            BindingResult result, SessionStatus status, HttpServletRequest request) { 
//
//    	Organization organization = studentForm.getOrganization();
//    	NavigationSettings navigationSettings = studentForm.getNavigationSettings();
//    	Student student = studentForm.getStudent();
//        
//        HttpSession session = request.getSession(false);   
//        Student changedStudent = null;
//        int tab = 0;
//        int panel = 0;
//        String dbPw = "";
//        String submitFormObject = "";
//        
//        if (log.isDebugEnabled()) {
//            log.debug("StudentSubscriptionEditController.processSubmit entered...");
//        }
//        
//        /* used to create personCode and studentCode if necessary.
//         * DO NOT use the name "organizationalUnitId" in this instance:
//         * it will create errors in the application. 
//         */
//        int tmpOrganizationalUnitId = 0;
//        String showStudentError = "";
//        
//        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
//
//        Locale currentLoc = RequestContextUtils.getLocale(request);
//
//        OpusUserRole studentOpusUserRole = studentForm.getPersonOpusUserRole();
//        OpusUser studentOpusUser = studentForm.getOpusUser();
//
//        if (!StringUtil.isNullOrEmpty(request.getParameter("panel_studyplan"))) {
//            panel = Integer.parseInt(request.getParameter("panel_studyplan"));
//            if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject_studyplandata"))) {
//                submitFormObject = request.getParameter("submitFormObject_studyplandata");
//            }
//        } else {
//            if (!StringUtil.isNullOrEmpty(request.getParameter("panel_previousinstitutiondata"))) {
//                panel = Integer.parseInt(request.getParameter("panel_previousinstitutiondata"));
//	            if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject_previousinstitutiondata"))) {
//	                  submitFormObject = request.getParameter("submitFormObject_previousinstitutiondata");
//	            }
//            } else {
//                if (!StringUtil.isNullOrEmpty(request.getParameter("panel_previnstdiplomaphotographdata"))) {
//                    panel = Integer.parseInt(request.getParameter("panel_previnstdiplomaphotographdata"));
//                    if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject_previnstdiplomaphotographdata"))) {
//                    	submitFormObject = request.getParameter("submitFormObject_previnstdiplomaphotographdata");
//                    }
//	          } else {
//	              if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
//	              	panel = Integer.parseInt(request.getParameter("panel"));
//		            if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
//		                submitFormObject = request.getParameter("submitFormObject");
//		            }
//	        	  }
//	          }
//            }
//	    }
//        studentForm.getNavigationSettings().setPanel(panel);
//        
//	    if (!StringUtil.isNullOrEmpty(request.getParameter("tab_studyplan"))) {
//	        tab = Integer.parseInt(request.getParameter("tab_studyplan"));
//	    } else {
//	    	if (!StringUtil.isNullOrEmpty(request.getParameter("tab"))) {
//	    		tab = Integer.parseInt(request.getParameter("tab"));
//	    	}
//	    }
//        studentForm.getNavigationSettings().setTab(tab);
//
//        /* if a country of birth is chosen, but no province then also district has to be empty */
//        if ("".equals(student.getCountryOfBirthCode()) || "0".equals(student.getCountryOfBirthCode())) {
//            student.setProvinceOfBirthCode("");
//            student.setDistrictOfBirthCode("");
//        } else {
//            if ("".equals(student.getProvinceOfBirthCode()) || "0".equals(student.getProvinceOfBirthCode())) {
//                student.setDistrictOfBirthCode("");
//            }
//        }
//        /* if a country of origin is chosen, but no province then also district has to be empty */
//        if ("".equals(student.getCountryOfOriginCode()) || "0".equals(student.getCountryOfOriginCode())) {
//            student.setProvinceOfOriginCode("");
//            student.setDistrictOfOriginCode("");
//        } else {
//            if ("".equals(student.getProvinceOfOriginCode()) || "0".equals(student.getProvinceOfOriginCode())) {
//                student.setDistrictOfOriginCode("");
//            }
//        }
//        
//        /* if a previous institution is chosen from the list, then empty the previous institution name */
//        if (student.getPreviousInstitutionId() != 0) {
//            student.setPreviousInstitutionName("");
//            student.setPreviousInstitutionCountryCode("0");
//            student.setPreviousInstitutionProvinceCode("0");
//            student.setPreviousInstitutionDistrictCode("0");
//            student.setPreviousInstitutionTypeCode("0");
//        }
//        
//        /* if personCode or studentCode are made empty, give default values */
//        tmpOrganizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
//        if (StringUtil.isNullOrEmpty(student.getPersonCode())) {
//            /* generate personCode */
//            String personCode = StringUtil.createUniqueCode("P", "" + tmpOrganizationalUnitId);
//            student.setPersonCode(personCode);
//
//        }
//        if (StringUtil.isNullOrEmpty(student.getStudentCode())) {
//            /* generate studentCode */
//            // TODO: temporarily reactivated old student code creation, because CBU situation not clear
//            String studentCode = StringUtil.createUniqueCode("STU", "" + tmpOrganizationalUnitId);
//            student.setStudentCode(studentCode);
//            // --------------> end of temporary code
//
//        }
//
//        if ("true".equals(submitFormObject)) {
//
//            if (log.isDebugEnabled()) {
//                log.debug("StudentSubscriptionEditController.processSubmit submitFormObject = true");
//            }
//
//    		result.pushNestedPath("student");
//	        studentValidator.validate(student, result);
//	        result.popNestedPath();
//
//	        if (result.hasErrors()) {
//	            // put lookups on the request again
//	        	lookupCacher.getPersonLookups(preferredLanguage, request);
//	            lookupCacher.getAddressLookups(preferredLanguage, request);
//	            lookupCacher.getStudyLookups(preferredLanguage, request);
//	            lookupCacher.getStudyPlanLookups(preferredLanguage, request);
//	            
//	            request.setAttribute("previousInstitutionCountryCode", 
//	            		student.getPreviousInstitutionCountryCode());
//	            request.setAttribute("previousInstitutionProvinceCode", 
//	            		student.getPreviousInstitutionProvinceCode());
//	            lookupCacher.getStudentLookups(preferredLanguage, request);
//	
//	        	request.setAttribute("from", "student");
//	            request.setAttribute("command", student);
//	
//	        	return formView;
//	        }
//	        
//	        // add student
//	        if (student.getStudentId() == 0) {
//	            
//	            String showStudentErrorCode = studentManager.validateNewStudent(student, currentLoc);
//	            if (!StringUtil.isNullOrEmpty(showStudentErrorCode)) {
//	                showStudentError = messageSource.getMessage(showStudentErrorCode, null, currentLoc);
//	            }
//	            if (StringUtil.isNullOrEmpty(showStudentError)) {
//	                studentManager.addStudent(student, studentOpusUserRole, studentOpusUser);
//	
//	            }
//	        // update student
//	        } else {
//	            // don't change the opusUserRole
//	            studentOpusUserRole = null;
//	            studentOpusUser = null; 
//	                
//	            studentManager.updateStudent(student, studentOpusUserRole,
//	                        studentOpusUser, dbPw);
//	        }
//	
//	        /* retrieve updated or new student for its studentId, only if no error occurred */
//	        changedStudent = studentManager.findStudentByCode(student.getStudentCode());
//	        
//            //status.setComplete();
//            
//            return "redirect:/college/student-subscription.view?tab=" + navigationSettings.getTab() 
//            				+ "&panel=" + navigationSettings.getPanel() 
//                            + "&studentId=" + changedStudent.getStudentId() 
//                            + "&from=student"
//                            + "&showStudentError=" + showStudentError
//                            + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
//        } else {
//            if (log.isDebugEnabled()) {
//                log.debug("StudentSubscriptionEditController.processSubmit submitFormObject = false");
//            }
//
//        	// submit but no save
//            //status.setComplete();
//            session.setAttribute("institutionId", organization.getInstitutionId());
//            session.setAttribute("branchId", organization.getBranchId());
//            session.setAttribute("organizationalUnitId", organization.getOrganizationalUnitId());
//                        
//            return "redirect:/college/student-subscription.view";
//        	
//        }
//    }
}
