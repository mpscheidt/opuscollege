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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.validator.StudyGradeTypeSubjectValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.StudyGradeTypeSubjectForm;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;


@Controller
@RequestMapping("/college/studygradetypesubject.view")
@SessionAttributes("studyGradeTypeSubjectForm")
public class StudyGradeTypeSubjectEditController {

     private static Logger log = LoggerFactory.getLogger(StudyGradeTypeSubjectEditController.class);
     private String formView;
     @Autowired private SecurityChecker securityChecker;    
     @Autowired private StudyManagerInterface studyManager;
     @Autowired private SubjectManagerInterface subjectManager;
     @Autowired private AcademicYearManagerInterface academicYearManager;
     @Autowired private OpusMethods opusMethods;
     @Autowired private InstitutionManagerInterface institutionManager;
     @Autowired private BranchManagerInterface branchManager;
     @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
     @Autowired private LookupManagerInterface lookupManager;
     @Autowired MessageSource messageSource;
     @Autowired StudyGradeTypeSubjectValidator studyGradeTypeSubjectValidator;

     /** 
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */     
    public StudyGradeTypeSubjectEditController() {
        super();
        this.formView = "college/study/studyGradeTypeSubject";
    }


    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(HttpServletRequest request, ModelMap model) {
        
        if (log.isDebugEnabled()) {
            log.debug("StudyGradeTypeSubjectEditController.setUpForm entered...");
        }
        
        HttpSession session = request.getSession(false);
        StudyGradeTypeSubjectForm studyGradeTypeSubjectForm = null;
        SubjectStudyGradeType subjectStudyGradeType = null;
        Organization organization = null;
        NavigationSettings navigationSettings = null;
        StudyGradeType studyGradeType = null;
        int studyId = 0;
        
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        
        int maxNumberOfCardinalTimeUnits = 0;
        int numberOfCardinalTimeUnits = 0;
        
        List < ? extends Subject > allSubjectsForStudy = null;
        List < Integer > allSubjectIdsForStudyGradeType = null;
        List < ? extends Lookup > allRigidityTypes = null;
        List < ? extends Lookup > allImportanceTypes = null;
        int studyGradeTypeId = 0;

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // if adding or editing a new subjectStudyGradeType, destroy existing ones on the session
        opusMethods.removeSessionFormObject("studyGradeTypeSubjectForm", session, opusMethods.isNewForm(request));

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
        studyGradeTypeSubjectForm = new StudyGradeTypeSubjectForm();
        
        // should always exist, we are adding a subject to a studygradetype
        if (!StringUtil.isNullOrEmpty(request.getParameter("studyGradeTypeId"))) {
            studyGradeTypeId = Integer.parseInt(
                    request.getParameter("studyGradeTypeId"));
        }
        
        HashMap<String, Object > map = new HashMap< >();
        map.put("studyGradeTypeId", studyGradeTypeId);
        map.put("preferredLanguage", preferredLanguage);
        studyGradeType = studyManager.findStudyGradeTypeConsiderLanguage(map);
        
        studyGradeTypeSubjectForm.setStudyGradeType(studyGradeType);
        
        subjectStudyGradeType = new SubjectStudyGradeType();
        subjectStudyGradeType.setActive(OpusConstants.GENERAL_YES);
        subjectStudyGradeType.setStudyGradeType(studyGradeType);
        subjectStudyGradeType.setStudyGradeTypeId(studyGradeType.getId());
        subjectStudyGradeType.setStudyId(studyGradeType.getStudyId());
                      
        studyGradeTypeSubjectForm.setSubjectStudyGradeType(subjectStudyGradeType);
        
        if (subjectStudyGradeType.getStudyGradeType() != null
                && subjectStudyGradeType.getStudyGradeType().getId() != 0) {
            maxNumberOfCardinalTimeUnits = studyGradeType.getMaxNumberOfCardinalTimeUnits();
            numberOfCardinalTimeUnits = studyGradeType.getNumberOfCardinalTimeUnits();
            if (maxNumberOfCardinalTimeUnits != 0) {
                studyGradeTypeSubjectForm.setMaxNumberOfCardinalTimeUnits(maxNumberOfCardinalTimeUnits);
            } else {
                studyGradeTypeSubjectForm.setMaxNumberOfCardinalTimeUnits(numberOfCardinalTimeUnits);
            }
            studyGradeTypeSubjectForm.setNumberOfCardinalTimeUnits(numberOfCardinalTimeUnits);
        }

        studyId = studyGradeType.getStudyId();
        organizationalUnitId = (organizationalUnitManager.findOrganizationalUnitOfStudy(
                                                                        studyId)).getId();
        branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
        institutionId = institutionManager.findInstitutionOfBranch(branchId);
        
        organization = new Organization();
        // organization id's determined before: based on existing subject
        opusMethods.fillOrganization(session, request, organization, organizationalUnitId
                                    , branchId, institutionId);
        studyGradeTypeSubjectForm.setOrganization(organization);
        
        navigationSettings = new NavigationSettings();
        opusMethods.fillNavigationSettings(request, navigationSettings, null);
        studyGradeTypeSubjectForm.setNavigationSettings(navigationSettings);
       
        /*
         *  retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
         *  find a LIST OF INSTITUTIONS of the correct educationtype
         *  for now studies are only registered for universities; in the future this could change
         */
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                studyGradeTypeSubjectForm.getOrganization(), session, request
                , organization.getInstitutionTypeCode(), organization.getInstitutionId()
                , organization.getBranchId(), organization.getOrganizationalUnitId());

        // get list of studies
        if (organization.getInstitutionId() != 0) {
            HashMap<String, Object > findStudiesMap = new HashMap< >();
            findStudiesMap.put("institutionId", organization.getInstitutionId());
            findStudiesMap.put("branchId", organization.getBranchId());
            findStudiesMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
            findStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());

            studyGradeTypeSubjectForm.setAllStudies(studyManager.findStudies(findStudiesMap));
        }
        
        // get list of subjects for selected study
        if (studyGradeTypeSubjectForm.getSubjectStudyGradeType().getStudyId() != 0) {
            HashMap<String, Object > findSubjectsMap = new HashMap< >();
            findSubjectsMap.put("institutionId", organization.getInstitutionId());
            findSubjectsMap.put("branchId", organization.getBranchId());
            findSubjectsMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
            findSubjectsMap.put("studyId", studyGradeTypeSubjectForm.getSubjectStudyGradeType().getStudyId());
            findSubjectsMap.put("currentAcademicYearId",studyGradeType.getCurrentAcademicYearId());
            findSubjectsMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
            findSubjectsMap.put("active", "");
            allSubjectsForStudy = subjectManager.findSubjects(findSubjectsMap);

            // get all subjects already linked to this studyGradeType, so they can be excluded
            // from the selection
            allSubjectIdsForStudyGradeType = 
                                    subjectManager.findSubjectsByStudyGradeType(studyGradeType);
            studyGradeTypeSubjectForm.setAllSubjectIdsForStudyGradeType(allSubjectIdsForStudyGradeType);
        
            List < Subject > allSubjects = new ArrayList<>();
            for (int i = 0; i < allSubjectsForStudy.size(); i++) {
            
                boolean showSubject = true;
                for (int j = 0; j < allSubjectIdsForStudyGradeType.size(); j++) {
                    if (allSubjectsForStudy.get(i).getId() == allSubjectIdsForStudyGradeType.get(j)) {
                        showSubject = false;
                    }
                }
                if (showSubject) {
                    allSubjects.add(allSubjectsForStudy.get(i));
                }
            }
       
            studyGradeTypeSubjectForm.setAllSubjects(allSubjects);
        }
        
        // show academicYear in crumbs path
        AcademicYear academicYear = academicYearManager.findAcademicYear(
        								studyGradeType.getCurrentAcademicYearId());
        studyGradeTypeSubjectForm.setAcademicYear(academicYear);
        
        allRigidityTypes = (List < ? extends Lookup >)
        lookupManager.findAllRows(preferredLanguage, "rigidityType");
        studyGradeTypeSubjectForm.setAllRigidityTypes(allRigidityTypes);
        
        allImportanceTypes = (List < ? extends Lookup >)
        lookupManager.findAllRows(preferredLanguage, "importanceType");
        studyGradeTypeSubjectForm.setAllImportanceTypes(allImportanceTypes);
        
        model.addAttribute("studyGradeTypeSubjectForm", studyGradeTypeSubjectForm);        
        return formView;
    }


    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(@ModelAttribute("studyGradeTypeSubjectForm") StudyGradeTypeSubjectForm studyGradeTypeSubjectForm, 
            BindingResult result, HttpServletRequest request, SessionStatus status) { 
        
        if (log.isDebugEnabled()) {
            log.debug("StudyGradeTypeSubjectEditController.processSubmit entered...");                                                                         
        }
        HttpSession session = request.getSession(false); 
        SubjectStudyGradeType subjectStudyGradeType = studyGradeTypeSubjectForm.getSubjectStudyGradeType();
        StudyGradeType studyGradeType = studyGradeTypeSubjectForm.getStudyGradeType();
        studyGradeTypeSubjectForm.setTxtErr("");
        Subject subject = null;
        int subjectId = subjectStudyGradeType.getSubjectId();
        NavigationSettings navSettings = studyGradeTypeSubjectForm.getNavigationSettings();
        Organization organization = studyGradeTypeSubjectForm.getOrganization();
        List < ? extends Subject > allSubjectsForStudy = null;
        List < Integer > allSubjectIdsForStudyGradeType = null;
        List < Subject > allSubjects = new ArrayList<>();

        opusMethods.getInstitutionBranchOrganizationalUnitSelect(session, request
                , organization.getInstitutionTypeCode(), organization.getInstitutionId()
                , organization.getBranchId(), organization.getOrganizationalUnitId());
        
        if (organization.getInstitutionId() != 0) {
            HashMap<String, Object > findStudiesMap = new HashMap< >();
            findStudiesMap.put("institutionId", organization.getInstitutionId());
            findStudiesMap.put("branchId", organization.getBranchId());
            findStudiesMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
            findStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());

            studyGradeTypeSubjectForm.setAllStudies(studyManager.findStudies(findStudiesMap));
        } else {
            studyGradeTypeSubjectForm.setAllStudies(null); 
        }
        
        // get list of subjects for selected study
        if (studyGradeTypeSubjectForm.getSubjectStudyGradeType().getStudyId() != 0) {
           
          HashMap<String, Object > findSubjectsMap = new HashMap< >();
          findSubjectsMap.put("institutionId", organization.getInstitutionId());
          findSubjectsMap.put("branchId", organization.getBranchId());
          findSubjectsMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
          findSubjectsMap.put("studyId", studyGradeTypeSubjectForm.getSubjectStudyGradeType().getStudyId());
          findSubjectsMap.put("currentAcademicYearId",studyGradeType.getCurrentAcademicYearId());
          findSubjectsMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
          findSubjectsMap.put("active", "");
          allSubjectsForStudy = subjectManager.findSubjects(findSubjectsMap);
          allSubjectIdsForStudyGradeType = studyGradeTypeSubjectForm.getAllSubjectIdsForStudyGradeType();
          
          for (int i = 0; i < allSubjectsForStudy.size(); i++) {
              
              boolean showSubject = true;
              for (int j = 0; j < allSubjectIdsForStudyGradeType.size(); j++) {
                  if (allSubjectsForStudy.get(i).getId() == allSubjectIdsForStudyGradeType.get(j)) {
                      showSubject = false;
                  }
              }
              if (showSubject) {
                  allSubjects.add(allSubjectsForStudy.get(i));
              }
          }
          
          studyGradeTypeSubjectForm.setAllSubjects(allSubjects);
        } else {
            studyGradeTypeSubjectForm.setAllSubjects(null);
        }

        String txtErr = "";
        String submitFormObject = "";
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }

        if ("true".equals(submitFormObject)) {
            studyGradeTypeSubjectValidator.onBindAndValidate(request, subjectStudyGradeType, result);
            if (result.hasErrors()) {
                return formView;
            }
            
            Locale currentLoc = RequestContextUtils.getLocale(request);

            // fill Subject completely
            subject = subjectManager.findSubject(subjectId);
        
            // check if the subject has a teacher and if examinations, if present, have teachers
            if (!subject.isLinkSubjectAndStudyGradeTypeIsAllowed()) {
                txtErr = messageSource.getMessage(
                      "jsp.error.link.subject.studygradetype.teacher.missing", null, currentLoc);
                studyGradeTypeSubjectForm.setTxtErr(txtErr);
                return formView;
            } else {
                // insert new or update
                if (subjectStudyGradeType.getId() == 0) {
                    subjectManager.addSubjectStudyGradeType(subjectStudyGradeType);
                } else {
                    subjectManager.updateSubjectStudyGradeType(subjectStudyGradeType);
                }
  
                return "redirect:/college/studygradetype.view?newForm=true&tab=" + navSettings.getTab()
                          + "&panel=" + navSettings.getPanel() 
                          + "&studyGradeTypeId=" + subjectStudyGradeType.getStudyGradeType().getId()
                          + "&studyId=" + studyGradeType.getStudyId()
                          + "&currentPageNumber="
                          + navSettings.getCurrentPageNumber();
            }

        // submit but no save
        } else {
            return formView;
        }
    }
}
