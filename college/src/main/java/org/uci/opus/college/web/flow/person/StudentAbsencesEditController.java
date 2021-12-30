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

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.college.domain.Penalty;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudentExpulsion;
import org.uci.opus.college.module.Module;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.web.form.person.StudentAbsencesForm;
import org.uci.opus.college.web.form.person.StudentFormShared;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

@Controller
@RequestMapping("/college/student-absences")
@SessionAttributes({ StudentAbsencesEditController.FORM_NAME, AbstractStudentEditController.FORM_NAME_SHARED })
public class StudentAbsencesEditController extends AbstractStudentEditController<StudentAbsencesForm> {

    static final String FORM_NAME = "studentAbsencesForm";

    private static Logger log = LoggerFactory.getLogger(StudentAbsencesEditController.class);
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private StudentManagerInterface studentManager;

    @Autowired private List <Module> modules;

    public StudentAbsencesEditController() {
        super();
    }

    @Override
    protected StudentAbsencesForm newFormInstance() {
        return new StudentAbsencesForm();
    }
    
    /**
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) 
            {

        if (log.isDebugEnabled()) {
            log.debug("StudentAbsencesEditController.setUpForm entered...");
        }

        HttpSession session = request.getSession(false);        
        securityChecker.checkSessionValid(session);

        StudentAbsencesForm studentForm = super.setupFormShared(FORM_NAME, model, request);
        StudentFormShared shared = studentForm.getStudentFormShared();

        Student student = shared.getStudent();
        if (student == null) {
            throw new RuntimeException("No student given. Note: This screen is not applicable for the creation of new students.");
        }

        /* set menu to students */
        session.setAttribute("menuChoice", "students");
        
        /* with each call the preferred language may be changed */
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
//        String opusUserLanguage = (String) session.getAttribute("opusUserLanguage");
        
        /* STUDENTFORM - fetch or create the form object and fill it with student */
        
//        StudentForm form = getStudentForm(model);
//        if (form == null) {
//        	form = new StudentForm();
//        }
//        if (form.getStudent() == null) {
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
//
////            } else {
////            	// NEW STUDENT
////                student = new Student();
////
////                // fetch organization from session
////                institutionId = OpusMethods.getInstitutionId(session, request);
////                branchId = OpusMethods.getBranchId(session, request);
////                organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
////                
////                /* generate personCode and studentCode */
////                String personCode = StringUtil.createUniqueCode("P", "" + organization.getOrganizationalUnitId());
////                student.setPersonCode(personCode);
////                
//////                String studentCode = createUniqueStudentNumberOnScreen(organization.getOrganizationalUnitId(), student);
//////                student.setStudentCode(studentCode);
////                
////                // default values:
////                student.setPrimaryStudyId(studyId);
////                student.setSecondaryStudyId(0);
////                student.setActive("Y");
////                student.setScholarship("N");
////                
//////                student.setStatusCode(OpusConstants.STATUS_REGISTERED);
////                student.addStudentStudentStatus(new Date(), OpusConstants.STUDENTSTATUS_ACTIVE);
////                student.setPublicHomepage("N");
////                student.setForeignStudent("N");
////                student.setRelativeOfStaffMember("N");
////                student.setRuralAreaOrigin("N");
////                student.setRegistrationDate(new Date());
////                student.setDateOfEnrolment(new Date());
////                student.setSubscriptionRequirementsFulfilled("Y");
////                studentOpusUserRole = new OpusUserRole();
////                studentOpusUserRole.setRole("student");
////                studentOpusUser = new OpusUser();
////                studentOpusUser.setLang(opusUserLanguage); 
//            }
//        } else {
//            student = form.getStudent(); 
//        }
        
        if (super.isNewForm()) {
            
            // add possible list of expulsions
            List <StudentExpulsion> studentExpulsions = null;
            studentExpulsions = studentManager.findStudentExpulsions(student.getStudentId(), preferredLanguage);
            student.setStudentExpulsions(studentExpulsions);

            // if module Fee is implemented, add possible list of penalties
            for(Module module:modules){
                if ("fee".equals(module.getModule())) {
                    // add possible list of penalties
                    List <Penalty> penalties = null;
                    penalties = studentManager.findPenalties(student.getStudentId(), preferredLanguage);
                    student.setPenalties(penalties);
                }
            }
            
        }
        

//        String writeWho = opusMethods.getWriteWho(request);
//        student.setWriteWho(writeWho);
//        student.setStudentWriteWho(writeWho);
        
//        form.setStudent(student);

        // get primary study if not present
//        if (unitStudy != null) {
//            unitStudyDescription = unitStudy.getOrganizationalUnitDescription();
//            session.setAttribute("unitStudyDescription", unitStudyDescription);
//        }

        /* STUDENTFORM.ORGANIZATION - fetch or create the object */
//        if (form.getOrganization() != null) {
//        	organization = form.getOrganization();
//        } else {
//        	organization = new Organization();
//
//        	// get the organization values from study:
//            organization = opusMethods.fillOrganization(session, request, organization, 
//            		organizationalUnitId, branchId, institutionId);
//        }
//        form.setOrganization(organization);

        /* STUDENT.NAVIGATIONSETTINGS - fetch or create the object */
//        if (form.getNavigationSettings() != null) {
//        	navigationSettings = form.getNavigationSettings();
//            if (!StringUtil.isNullOrEmpty(request.getParameter("tab"))) {
//            	navigationSettings.setTab(Integer.parseInt(request.getParameter("tab")));
//            }
//            if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
//            	navigationSettings.setPanel(Integer.parseInt(request.getParameter("panel")));
//            }
//        } else {
//        	navigationSettings = new NavigationSettings();
//            opusMethods.fillNavigationSettings(request, navigationSettings, "/college/student-absences.view");
//        }
//        form.setNavigationSettings(navigationSettings);

        // entering from overview
//        if (StringUtil.isNullOrEmpty((String) session.getAttribute("from")) 
//                && "students".equals(request.getParameter("from"))) {
//            
//        	session.setAttribute("from", "student");
//
//            if (organizationalUnitId == 0 || !StringUtil.isNullOrEmpty(navigationSettings.getSearchValue())) {
//            	study = studyManager.findStudy(student.getPrimaryStudyId());
//            	organizationalUnitId = study.getOrganizationalUnitId();
//                session.setAttribute("organizationalUnitId", organizationalUnitId);
//            }
//
//            if (branchId == 0 || !StringUtil.isNullOrEmpty(navigationSettings.getSearchValue())) {
//                branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
//                session.setAttribute("branchId", branchId);
//            }
//            
//            if (institutionId == 0 || !StringUtil.isNullOrEmpty(navigationSettings.getSearchValue())) {
//                institutionId = institutionManager.findInstitutionOfBranch(branchId);
//                session.setAttribute("institutionId", institutionId);
//            }
//        } else if (
//            // first time pulldown is changed
//            ("students".equals(request.getParameter("from")) 
//            		&& "student".equals(session.getAttribute("from")))
//                  ||
//                    // pulldown has been changed at least once already 
//                    ("student".equals(request.getParameter("from")) 
//                          && StringUtil.isNullOrEmpty((String) session.getAttribute("from"), true))
//                  ) {
//            session.setAttribute("from", null);
//
//            if (institutionId == 0) {
//                branchId = 0;
//                session.setAttribute("branchId", branchId);
//            }
//            
//            if (branchId == 0) {
//                organizationalUnitId = 0;
//                session.setAttribute("organizationalUnitId", organizationalUnitId);   
//            }
//            
//            if (organizationalUnitId == 0) {
//                studyId = 0;
//            }
//        }

      
      /* catch possible other errors */        
//      if (!StringUtil.isNullOrEmpty(request.getParameter("showStudentError"))) {
//          showStudentError = request.getParameter("showStudentError");
//      }
//      request.setAttribute("showStudentError", showStudentError);
//
//      if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(request, "txtMsg"))) {
//          form.setTxtMsg(ServletRequestUtils.getStringParameter(request, "txtMsg"));
//      }

      // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
//      opusMethods.getInstitutionBranchOrganizationalUnitSelect(
//              session, request, organization.getInstitutionTypeCode(),
//              organization.getInstitutionId(), organization.getBranchId(), 
//              organization.getOrganizationalUnitId());
      
      // primary study: select only studies from current organizationalUnitId
//      List < Study > allStudies =  null;
//      Map<String, Object> findStudiesMap = new HashMap<>();
//      findStudiesMap = opusMethods.fillOrganizationMapForReadAuthorization(request, organization);
//      findStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());          
//      allStudies = studyManager.findStudies(findStudiesMap);
//      form.setAllStudies(allStudies);

//      List < ? extends StudyGradeType > allStudyGradeTypes = null;
//      allStudyGradeTypes = opusMethods.getAllStudyGradeTypes(session, request);
//      request.setAttribute("allStudyGradeTypes", allStudyGradeTypes);

      // secondary study: select all studies from current institution for selection
//      Map<String, Object> findSecondaryStudiesMap = new HashMap<>();
//      findSecondaryStudiesMap = opusMethods.fillOrganizationMapForReadAuthorization(request, organization);
//      findSecondaryStudiesMap.put("institutionId", organization.getInstitutionId());
//      findSecondaryStudiesMap.put("branchId", 0);          
//      findSecondaryStudiesMap.put("organizationalUnitId", 0);          
//      findSecondaryStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());          
//      form.setAllSecondaryStudies(studyManager.findStudies(findSecondaryStudiesMap));

//        lookupCacher.getPersonLookups(preferredLanguage, request);
//        lookupCacher.getAddressLookups(preferredLanguage, request);

//        Map<String, Object> findStaffMembersMap = new HashMap<>();
//        findStaffMembersMap.put("institutionId", 0);
//        findStaffMembersMap.put("branchId", 0);
//        findStaffMembersMap.put("organizationalUnitId", 0);
//        findStaffMembersMap.put("institutionTypeCode", OpusConstants.INSTITUTION_TYPE_DEFAULT);
//        form.setAllStaffMembers(staffMemberManager.findStaffMembers(findStaffMembersMap));
//
//        model.addAttribute(FORM_NAME, form);        
        return FORM_VIEW;
    }

//    @RequestMapping(method=RequestMethod.POST)
//    public String processSubmit(
//    		@ModelAttribute(FORM_NAME) StudentAnomaliesForm form,
//            BindingResult result, SessionStatus status, HttpServletRequest request) { 
//
//        StudentFormShared shared = form.getStudentFormShared();
//        NavigationSettings navigationSettings = shared.getNavigationSettings();
//        Student student = shared.getStudent();
//
//    	NavigationSettings navigationSettings = shared.getNavigationSettings();
//
//        HttpSession session = request.getSession(false);   
////        Student student = (Student) form.getStudent();
////        Student changedStudent = null;
////        int tab = 0;
////        int panel = 0;
////        String dbPw = "";
////        String submitFormObject = "";
//        
//        if (log.isDebugEnabled()) {
//            log.debug("StudentAbsencesEditController.processSubmit entered...");
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
//	    if (!StringUtil.isNullOrEmpty(request.getParameter("panel"))) {
//          	panel = Integer.parseInt(request.getParameter("panel"));
//            if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
//                submitFormObject = request.getParameter("submitFormObject");
//            }
//		}
//        form.getNavigationSettings().setPanel(panel);
//        
//    	if (!StringUtil.isNullOrEmpty(request.getParameter("tab"))) {
//    		tab = Integer.parseInt(request.getParameter("tab"));
//    	}
//        form.getNavigationSettings().setTab(tab);
//
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
//                log.debug("StudentAbsencesEditController.processSubmit submitFormObject = true");
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
////	            String showStudentErrorCode = studentManager.validateNewStudent(student, currentLoc);
////	            if (!StringUtil.isNullOrEmpty(showStudentErrorCode)) {
////	                showStudentError = messageSource.getMessage(showStudentErrorCode, null, currentLoc);
////	            }
////	            if (StringUtil.isNullOrEmpty(showStudentError)) {
////	                studentManager.addStudent(student, studentOpusUserRole, studentOpusUser);
//	
////	            }
//	        // update student
//	        } else {
//	            // don't change the opusUserRole
//	            studentManager.updateStudent(student, null, null, dbPw);
//	        }
//
//	        /* retrieve updated or new student for its studentId, only if no error occurred */
//	        changedStudent = studentManager.findStudentByCode(student.getStudentCode());
//	            
//            //status.setComplete();
//            
//            return "redirect:/college/student-absences.view?tab=" + navigationSettings.getTab() 
//            				+ "&panel=" + navigationSettings.getPanel() 
//                            + "&studentId=" + changedStudent.getStudentId() 
//                            + "&from=student"
//                            + "&showStudentError=" +showStudentError
//                            + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
//        } else {
//            if (log.isDebugEnabled()) {
//                log.debug("StudentAbsencesEditController.processSubmit submitFormObject = false");
//            }
//
//            // submit but no save
//            //status.setComplete();
//            session.setAttribute("institutionId", organization.getInstitutionId());
//            session.setAttribute("branchId", organization.getBranchId());
//            session.setAttribute("organizationalUnitId", organization.getOrganizationalUnitId());
//                        
//            return "redirect:/college/student-absences.view";
//        }
//    }
}
