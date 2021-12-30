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

import java.util.HashMap;

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
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.StudyGradeTypePrerequisite;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.validator.StudyGradeTypePrerequisiteValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.StudyGradeTypePrerequisiteForm;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * @author J. Nooitgedagt
 *
 */
@Controller
@RequestMapping("/college/studygradetypeprerequisite.view")
@SessionAttributes("studyGradeTypePrerequisiteForm")
public class StudyGradeTypePrerequisiteEditController {
    
    private static Logger log = LoggerFactory.getLogger(StudyGradeTypePrerequisiteEditController.class);
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    private String formView;

    /** 
    * @see javax.servlet.http.HttpServlet#HttpServlet()
    */     
   public StudyGradeTypePrerequisiteEditController() {
       super();
       this.formView = "college/study/studyGradeTypePrerequisite";
   }

   @RequestMapping(method=RequestMethod.GET)
   public String setUpForm(HttpServletRequest request, ModelMap model) {
       
       if (log.isDebugEnabled()) {
           log.debug("StudyGradeTypePrerequisiteEditController.setUpForm entered...");
       }
       
       HttpSession session = request.getSession(false); 
       
       /* perform session-check. If wrong, this throws an Exception towards ErrorController */
       securityChecker.checkSessionValid(session);
       
       // if adding a new studyGradeTypePrerequisite, destroy any existing "Form" objects on the session
       opusMethods.removeSessionFormObject("studyGradeTypePrerequisiteForm", session, model, opusMethods.isNewForm(request));
       
       StudyGradeTypePrerequisiteForm studyGradeTypePrerequisiteForm = null;
       StudyGradeTypePrerequisite studyGradeTypePrerequisite = null;
       Organization organization = null;
       NavigationSettings navigationSettings = null;
       
       int institutionId = 0;
       int branchId = 0;
       int organizationalUnitId = 0;
       int studyId = 0;
       int requiredStudyId = 0;

       // existing studyGradeType to which a prerequisite is added
       StudyGradeType mainStudyGradeType = null;
       int mainStudyGradeTypeId = 0;

       /* fetch or create the form object */
       if ((StudyGradeTypePrerequisiteForm)
               session.getAttribute("studyGradeTypePrerequisiteForm") != null) {
           studyGradeTypePrerequisiteForm = (StudyGradeTypePrerequisiteForm) 
                                       session.getAttribute("studyGradeTypePrerequisiteForm");
       } else {
           studyGradeTypePrerequisiteForm = new StudyGradeTypePrerequisiteForm();
       }

       String preferredLanguage = OpusMethods.getPreferredLanguage(request);
       
       // entering the form: the studyGradeTypePrerequisiteForm.studyGradeTypePrerequisite
       // does not exist yet
       if (studyGradeTypePrerequisiteForm.getStudyGradeTypePrerequisite() == null) {
           if (!StringUtil.isNullOrEmpty(request.getParameter("studyGradeTypeId"))) {
               mainStudyGradeTypeId = Integer.parseInt(request.getParameter("studyGradeTypeId"));
           }
           
           // studyGradeTypeId should always be filled, since you're adding a required
           // gradeType of a study to an existing studyGradeType
           if (mainStudyGradeTypeId != 0) {
               // main StudyGradeType; does not change; used in crumbs path
               HashMap<String, Object> map = new HashMap<>();
               map.put("preferredLanguage", preferredLanguage);
               map.put("studyGradeTypeId", mainStudyGradeTypeId);
               mainStudyGradeType = studyManager.findStudyGradeTypeConsiderLanguage(map);
               studyGradeTypePrerequisiteForm.setMainStudyGradeType(mainStudyGradeType);
               // same for academicYear
               AcademicYear academicYear = academicYearManager.findAcademicYear(mainStudyGradeType.getCurrentAcademicYearId());
               studyGradeTypePrerequisiteForm.setAcademicYear(academicYear);
               
               studyGradeTypePrerequisite = new StudyGradeTypePrerequisite();
               studyGradeTypePrerequisite.setStudyGradeTypeId(mainStudyGradeTypeId);
               // initial setting
               studyGradeTypePrerequisite.setRequiredStudyId(mainStudyGradeType.getStudyId());
               studyGradeTypePrerequisiteForm.setStudyGradeTypePrerequisite(
                                                       studyGradeTypePrerequisite);
               
               // get all prerequisites already linked to the studyGradeType
               studyGradeTypePrerequisiteForm.setAllStudyGradeTypePrerequisites(
                       studyManager.findStudyGradeTypePrerequisites(
                               studyGradeTypePrerequisiteForm.getMainStudyGradeType().getId()));
               
               studyId = mainStudyGradeType.getStudyId();
               organizationalUnitId = (organizationalUnitManager.findOrganizationalUnitOfStudy(
                                                                               studyId)).getId();
               branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
               institutionId = institutionManager.findInstitutionOfBranch(branchId);
               
           }
       } else {
           studyGradeTypePrerequisite = studyGradeTypePrerequisiteForm
                                           .getStudyGradeTypePrerequisite();
       }
       
       /* ORGANIZATION - fetch or create the object */
       if (studyGradeTypePrerequisiteForm.getOrganization() == null) {
           organization = new Organization();
           // organization id's determined before: based on existing subject
           opusMethods.fillOrganization(session, request, organization, organizationalUnitId
                                       , branchId, institutionId);
           studyGradeTypePrerequisiteForm.setOrganization(organization);

       } else {
           // studyGradeTypePrerequisiteForm.organization exists, no need for setting the id's
           organization = studyGradeTypePrerequisiteForm.getOrganization();
       }
       
       /* NAVIGATIONSETTINGS - fetch or create the object */
       if (studyGradeTypePrerequisiteForm.getNavigationSettings() != null) {
           navigationSettings = studyGradeTypePrerequisiteForm.getNavigationSettings();
       } else {
           navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            studyGradeTypePrerequisiteForm.setNavigationSettings(navigationSettings);
       }
       
       // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
       opusMethods.getInstitutionBranchOrganizationalUnitSelect(studyGradeTypePrerequisiteForm.getOrganization(),
                           session, request, organization.getInstitutionTypeCode()
                               , organization.getInstitutionId(), organization.getBranchId()
                               , organization.getOrganizationalUnitId());

        // get list of studies
        if (organization.getOrganizationalUnitId() != 0) {
            HashMap<String, Object> findStudiesMap = new HashMap<>();

            findStudiesMap.put("institutionId", organization.getInstitutionId());
            findStudiesMap.put("branchId", organization.getBranchId());
            findStudiesMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
            findStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());

            studyGradeTypePrerequisiteForm.setAllStudies(studyManager.findStudies(findStudiesMap));
        } else {
            // the studyGradeTypePrerequisiteForm.study.id is not set to 0 in the jsp when the 
            // organizationalUnitId is set to 0, so it has to be set by hand
            studyGradeTypePrerequisiteForm.getStudyGradeTypePrerequisite().setRequiredStudyId(0);
            studyGradeTypePrerequisiteForm.setAllStudies(null);
        }
        
        requiredStudyId = studyGradeTypePrerequisiteForm.getStudyGradeTypePrerequisite().getRequiredStudyId();

        // Get all gradetypes of this study that might be a prerequisite and get all that are already a prerequisite
        if (requiredStudyId != 0) {
            
            HashMap<String, Object> findGradeTypesForStudyMap = new HashMap<>();
            findGradeTypesForStudyMap.put("preferredLanguage", preferredLanguage);
            findGradeTypesForStudyMap.put("studyId", requiredStudyId);
            studyGradeTypePrerequisiteForm.setDistinctStudyGradeTypesForStudy(
                        studyManager.findDistinctStudyGradeTypesForStudy(findGradeTypesForStudyMap));
        } else {
            studyGradeTypePrerequisiteForm.setDistinctStudyGradeTypesForStudy(null);
        }

        model.addAttribute("studyGradeTypePrerequisiteForm", studyGradeTypePrerequisiteForm);        
        return formView;
   }

   /**
    * Saves the new StudyGradeTypePrerequisite.
    */
   @RequestMapping(method=RequestMethod.POST)
   public String processSubmit(@ModelAttribute("studyGradeTypePrerequisiteForm") 
                                    StudyGradeTypePrerequisiteForm studyGradeTypePrerequisiteForm
                                    , BindingResult result, HttpServletRequest request
                                    , SessionStatus status) {

        if (log.isDebugEnabled()) {
            log.debug("StudyGradeTypePrerequisiteEditController.processSubmit entered...");
        }

        StudyGradeTypePrerequisite studyGradeTypePrerequisite = studyGradeTypePrerequisiteForm
                                                                .getStudyGradeTypePrerequisite();
        
        StudyGradeType studyGradeType = 
            studyManager.findStudyGradeType(studyGradeTypePrerequisite.getStudyGradeTypeId());
        
        NavigationSettings navigationSettings = studyGradeTypePrerequisiteForm
                                                .getNavigationSettings();
        
        String submitFormObject = "";
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }
        
        if ("true".equals(submitFormObject)) {
            new StudyGradeTypePrerequisiteValidator().validate(studyGradeTypePrerequisite, result);
            if (result.hasErrors()) {
                
                /* if an error is detected by the Validator, then the setUpForm is not called. Therefore
                 * the lookup tables need to be filled in this method as well
                 */
                String preferredLanguage = OpusMethods.getPreferredLanguage(request);
                lookupCacher.getStudyLookups(preferredLanguage, request);
                return formView;
            }

            studyManager.addStudyGradeTypePrerequisite(studyGradeTypePrerequisite);
    
            status.setComplete();
            
            return "redirect:/college/studygradetype.view?newForm=true&tab="
                            + navigationSettings.getTab()
                            + "&panel=" + navigationSettings.getPanel()
                            + "&studyGradeTypeId=" + studyGradeTypePrerequisite.getStudyGradeTypeId()
                            + "&studyId=" + studyGradeType.getStudyId()
                            + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
        // submit but no save
        } else {
            return "redirect:/college/studygradetypeprerequisite.view";
       }
    }
}
