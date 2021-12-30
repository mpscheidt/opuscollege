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
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectPrerequisite;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.validator.SubjectPrerequisiteValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.SubjectPrerequisiteForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/subjectprerequisite.view")
@SessionAttributes("subjectPrerequisiteForm")
public class SubjectPrerequisiteEditController {

    private static Logger log = LoggerFactory.getLogger(SubjectPrerequisiteEditController.class);
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;

    private String formView;

    public SubjectPrerequisiteEditController() {
        super();
        this.formView = "college/subject/subjectPrerequisite";
    }

    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(HttpServletRequest request, ModelMap model) {

        if (log.isDebugEnabled()) {
            log.debug("SubjectPrerequisiteEditController.setUpForm entered...");
        }

        HttpSession session = request.getSession(false);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        // if adding a new subjectPrerequisite, destroy any existing "Form" objects on the session
        opusMethods.removeSessionFormObject("subjectPrerequisiteForm", session, model, opusMethods.isNewForm(request));

        // declare variables
        SubjectPrerequisiteForm subjectPrerequisiteForm = null;
        int subjectStudyGradeTypeId = 0;
        SubjectPrerequisite subjectPrerequisite = null;
        Subject subject = null;
        int mainSubjectId = 0;
        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;

        Study study = null;
        StudyGradeType studyGradeType = null;
        Organization organization = null;
        NavigationSettings navigationSettings = null;

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        /* fetch or create the form object */
        if ((SubjectPrerequisiteForm) session.getAttribute("subjectPrerequisiteForm") != null) {
            subjectPrerequisiteForm = (SubjectPrerequisiteForm) 
                    session.getAttribute("subjectPrerequisiteForm");
        } else {
            subjectPrerequisiteForm = new SubjectPrerequisiteForm();
        }

        // entering the form: the subjectPrerequisiteForm.subjectPrerequisite does not exist yet
        if (subjectPrerequisiteForm.getSubjectPrerequisite() == null) {

            if (!StringUtil.isNullOrEmpty(request.getParameter("subjectStudyGradeTypeId"))) {
                subjectStudyGradeTypeId = Integer.parseInt(request.getParameter("subjectStudyGradeTypeId"));
            }

            if (!StringUtil.isNullOrEmpty(request.getParameter("mainSubjectId"))) {
                mainSubjectId = Integer.parseInt(request.getParameter("mainSubjectId"));
            }

            // subjectStudyGradeTypeId should always be filled, since you're adding a required
            // subject to an existing subjectStudyGradeType
            if (subjectStudyGradeTypeId != 0) {
                // subjectTeachers are only inserted, never updated
                subjectPrerequisite = new SubjectPrerequisite();
                subjectPrerequisite.setSubjectStudyGradeTypeId(subjectStudyGradeTypeId);
                subjectPrerequisite.setActive("Y");
                subjectPrerequisiteForm.setSubjectPrerequisite(subjectPrerequisite);

                // get study for the selectbox
                // first get the subjectStudyGradeType
                HashMap<String, Object> map = new HashMap<String, Object>();
                map.put("subjectStudyGradeTypeId", subjectStudyGradeTypeId);
                map.put("preferredLanguage", preferredLanguage);
                SubjectStudyGradeType subjectStudyGradeType = subjectManager.findSubjectStudyGradeType(map);
                // then the study and set to the form
                study = studyManager.findStudy(subjectStudyGradeType.getStudyGradeType().getStudyId());
                subjectPrerequisiteForm.setStudy(study);
                // needed to show the subject's name in the header (bread crumbs path)
                subject = subjectManager.findSubject(mainSubjectId);
                subjectPrerequisiteForm.setSubject(subject);
                // needed to show the studygradeType in the header (bread crumbs path)
                studyGradeType = studyManager.findStudyGradeType(subjectStudyGradeType.getStudyGradeTypeId());
                subjectPrerequisiteForm.setStudyGradeType(studyGradeType);         
                // show initially the organizations of the subject, not the ones on the session
                // find organization id's matching with the subject
                int studyId = study.getId();
                organizationalUnitId = (organizationalUnitManager.findOrganizationalUnitOfStudy(
                        studyId)).getId();
                branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
                institutionId = institutionManager.findInstitutionOfBranch(branchId);

            }
        } else {
            subjectPrerequisite = subjectPrerequisiteForm.getSubjectPrerequisite();
        }

        /* ORGANIZATION - fetch or create the object */
        if (subjectPrerequisiteForm.getOrganization() == null) {
            organization = new Organization();
            // organization id's determined before: based on existing subject
            opusMethods.fillOrganization(session, request, organization, organizationalUnitId
                    , branchId, institutionId);
            subjectPrerequisiteForm.setOrganization(organization);

        } else {
            // subjectForm.organization exists, no need for setting the id's
            organization = subjectPrerequisiteForm.getOrganization();
        }

        /* NAVIGATIONSETTINGS - fetch or create the object */
        if (subjectPrerequisiteForm.getNavigationSettings() != null) {
            navigationSettings = subjectPrerequisiteForm.getNavigationSettings();
        } else {
            navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
        }
        subjectPrerequisiteForm.setNavigationSettings(navigationSettings);

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(subjectPrerequisiteForm.getOrganization(),
                session, request, organization.getInstitutionTypeCode()
                , organization.getInstitutionId(), organization.getBranchId()
                , organization.getOrganizationalUnitId());

        // get list of studies
        if (organization.getOrganizationalUnitId() != 0) {
            HashMap<String, Object> findStudiesMap = new HashMap<String, Object>();

            findStudiesMap.put("institutionId", organization.getInstitutionId());
            findStudiesMap.put("branchId", organization.getBranchId());
            findStudiesMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
            findStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());

            subjectPrerequisiteForm.setAllStudies(studyManager.findStudies(findStudiesMap));
        } else {
            // the subjectPrerequisiteForm.study.id is not set to 0 in the jsp when the 
            // organizationalUnitId is set to 0, so it has to be set by hand
            subjectPrerequisiteForm.getStudy().setId(0);
            subjectPrerequisiteForm.setAllStudies(null);
        }

        // list of subjects
        if (subjectPrerequisiteForm.getStudy() != null && subjectPrerequisiteForm.getStudy().getId() != 0) {
            study = subjectPrerequisiteForm.getStudy();
            subjectPrerequisiteForm.setAllSubjectsForStudy(
                    subjectManager.findSubjectsByStudy(subjectPrerequisiteForm.getStudy().getId()));
        } else {
            subjectPrerequisiteForm.setAllSubjectsForStudy(null);
        }

        if (subjectPrerequisiteForm.getAllPrerequisiteSubjects() == null) {
            // find the list of prerequisites of this subject(StudyGradeType)
            subjectPrerequisiteForm.setAllPrerequisiteSubjects(
                    subjectManager.findSubjectPrerequisites(
                            subjectPrerequisite.getSubjectStudyGradeTypeId()));
        }

        model.addAttribute("subjectPrerequisiteForm", subjectPrerequisiteForm);        
        return formView;
    }

    /**
     * Saves the new SubjectPrerequisite.
     */
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(@ModelAttribute("subjectPrerequisiteForm") 
    SubjectPrerequisiteForm subjectPrerequisiteForm
    , BindingResult result, HttpServletRequest request
    , SessionStatus status) {

        if (log.isDebugEnabled()) {
            log.debug("SubjectPrerequisiteEditController.processSubmit entered...");
        }

        SubjectPrerequisite subjectPrerequisite = subjectPrerequisiteForm.getSubjectPrerequisite();

        NavigationSettings navigationSettings = subjectPrerequisiteForm.getNavigationSettings();

        String submitFormObject = "";

        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }

        if ("true".equals(submitFormObject)) {
            new SubjectPrerequisiteValidator().validate(subjectPrerequisite, result);
            if (result.hasErrors()) {
                return formView;
            }

            subjectManager.addSubjectPrerequisite(subjectPrerequisite);

            status.setComplete();

            return "redirect:/college/subjectstudygradetype.view?newForm=true&tab="
            + navigationSettings.getTab()
            + "&panel=" + navigationSettings.getPanel()
            + "&subjectStudyGradeTypeId=" 
            + subjectPrerequisite.getSubjectStudyGradeTypeId()
            + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
        } else {
            return "redirect:/college/subjectprerequisite.view";
        }
    }
}
