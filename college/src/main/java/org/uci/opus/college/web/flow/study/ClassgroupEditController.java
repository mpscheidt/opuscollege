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

package org.uci.opus.college.web.flow.study;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.persistence.StudyMapper;
import org.uci.opus.college.persistence.SubjectMapper;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.util.MybatisUtil;
import org.uci.opus.college.validator.ClassgroupValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.study.ClassgroupForm;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

@Controller
@SessionAttributes({ ClassgroupEditController.FORM_NAME })
public class ClassgroupEditController {

    private final String viewName = "college/study/classgroup";

    public static final String FORM_NAME = "classgroupForm";

    private static Logger log = LoggerFactory.getLogger(ClassgroupEditController.class);

    @Autowired private LookupCacher lookupCacher;
    @Autowired private OpusMethods opusMethods;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private ClassgroupValidator classgroupValidator;
    @Autowired private StudyMapper studyMapper;
    @Autowired private SubjectMapper subjectMapper;

    @RequestMapping(value="/college/classgroup.view", method=RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(FORM_NAME, session, model, opusMethods.isNewForm(request));

        /* set menu to subjects */
        session.setAttribute("menuChoice", "studies");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        int studyId = 0;
        int academicYearId = 0;
        int studyGradeTypeId = 0;
        Classgroup classgroup;

        ClassgroupForm classgroupForm = (ClassgroupForm) model.get(FORM_NAME);
        if (classgroupForm == null) {
            classgroupForm = new ClassgroupForm();
            model.put(FORM_NAME, classgroupForm);

            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request,  navigationSettings, null);
            classgroupForm.setNavigationSettings(navigationSettings);

            List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
            classgroupForm.setAllAcademicYears(allAcademicYears);
                                           
            classgroupForm.setCodeToGradeTypeMap(new CodeToLookupMap(lookupCacher.getAllGradeTypes(preferredLanguage)));
            classgroupForm.setCodeToStudyFormMap(new CodeToLookupMap(lookupCacher.getAllStudyForms(preferredLanguage)));
            classgroupForm.setCodeToStudyTimeMap(new CodeToLookupMap(lookupCacher.getAllStudyTimes(preferredLanguage)));

            int classgroupId = ServletUtil.getIntParam(request, "classgroupId", 0);
            if (classgroupId != 0) {
                classgroup = studyManager.findClassgroupById(classgroupId);
            } else {
                classgroup = new Classgroup();
            }
            classgroupForm.setClassgroup(classgroup);
            classgroupForm.initSubjectIdsFromSubjectClassgroups();

            // allSubjects has to include all those that are linked via subjectStudygradetype or subjectblockStudygradetype
            Map<String, Object> fsm = MybatisUtil.map("studyGradeTypeId", classgroup.getStudyGradeTypeId());
            classgroupForm.setAllSubjects(subjectMapper.findSubjects(fsm));
        }

        classgroup = classgroupForm.getClassgroup();
        studyGradeTypeId = classgroup.getStudyGradeTypeId();
        Organization organization = null;
        
        if (studyGradeTypeId != 0) {
        	// Get organization, study, academic year based on selected studyGradeTypeId
            StudyGradeType studyGradeType = studyManager.findStudyGradeType(studyGradeTypeId);
            Study study = studyManager.findStudy(studyGradeType.getStudyId());
            int organizationalUnitId = study.getOrganizationalUnitId();
            int branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
            int institutionId = institutionManager.findInstitutionOfBranch(branchId);            
            studyId = studyGradeType.getStudyId();
            academicYearId = studyGradeType.getCurrentAcademicYearId();
            
        	// fill organization values
            organization = new Organization();
            opusMethods.fillOrganization(session, request, organization, organizationalUnitId, branchId, institutionId);
        } else {
	        if (classgroupForm.getOrganization() != null) {
	        	organization = classgroupForm.getOrganization();
	        } else {
	        	organization = new Organization();
	
	            int institutionId = OpusMethods.getInstitutionId(session, request);
	            int branchId = OpusMethods.getBranchId(session, request);
	            int organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
	            
	        	// get the organization values from session:
	            opusMethods.fillOrganization(session, request, organization, organizationalUnitId, branchId, institutionId);
	        }
            studyId = classgroupForm.getStudyId();
            academicYearId = classgroupForm.getAcademicYearId();
        }
        
        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(organization,
                session, request, organization.getInstitutionTypeCode(),
                organization.getInstitutionId(), organization.getBranchId(), 
                organization.getOrganizationalUnitId());        
        
		classgroupForm.setAllStudies(null);
        classgroupForm.setAllStudyGradeTypes(null);

        if (organization.getOrganizationalUnitId() != 0) {
            Map<String, Object> findMap = new HashMap<>();
            
            findMap.put("institutionId", organization.getInstitutionId());
            findMap.put("branchId", organization.getBranchId());
            findMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
            findMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
            
            classgroupForm.setAllStudies(studyManager.findStudies(findMap));

            if (studyId != 0 && academicYearId != 0) {                	
                findMap.put("studyId", studyId);
                findMap.put("preferredLanguage", preferredLanguage);
                findMap.put("currentAcademicYearId", academicYearId);
                
                classgroupForm.setAllStudyGradeTypes(studyManager.findStudyGradeTypes(findMap));
            }
    	}
        
        classgroupForm.setOrganization(organization);
        classgroupForm.setStudyId(studyId);
        classgroupForm.setAcademicYearId(academicYearId);
        
        return viewName;
    }

    @Transactional
    @RequestMapping(value="/college/classgroup.view", method=RequestMethod.POST)
    public String processSubmit(HttpServletRequest request,
            SessionStatus sessionStatus,
            @ModelAttribute(FORM_NAME) ClassgroupForm classgroupForm,
            BindingResult result, ModelMap model) {

    	Organization organization = classgroupForm.getOrganization();
    	NavigationSettings navigationSettings = classgroupForm.getNavigationSettings();
    	
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        
        String submitFormObject = "";
        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }

        if ("true".equals(submitFormObject)) {
            Classgroup classgroup = classgroupForm.getClassgroup();
            
            result.pushNestedPath("classgroup");
            classgroupValidator.validate(classgroup, result);
            result.popNestedPath();
            
            if (result.hasErrors()) {
                return viewName;
            }
            
            String writeWho = opusMethods.getWriteWho(request);
            if (classgroup.getId() != 0) {
                studyManager.updateClassgroup(classgroup, writeWho);

                // add/remove subjectClassgroups
                studyManager.deleteSubjectClassgroups(classgroupForm.getSubjectClassgroupsToDelete());
                studyManager.addSubjectClassgroups(classgroupForm.getSubjectClassgroupsToAdd(), writeWho);
                
            } else {
                studyManager.addClassgroup(classgroup, writeWho);
            }
            
            sessionStatus.setComplete();

            return "redirect:/college/classgroup.view?newForm=true"
                    + "&classgroupId=" + classgroup.getId()
                    + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber()
                    + "&tab=" + navigationSettings.getTab() 
                    + "&panel=" + navigationSettings.getPanel();
        }
        
        session.setAttribute("institutionId", organization.getInstitutionId());
        session.setAttribute("branchId", organization.getBranchId());
        session.setAttribute("organizationalUnitId", organization.getOrganizationalUnitId());
        
        return "redirect:/college/classgroup.view";
    }
    
}
