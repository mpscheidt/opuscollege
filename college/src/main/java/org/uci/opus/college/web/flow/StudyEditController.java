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
import java.util.Collections;
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
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestBindingException;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup9;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.util.StudyGradeTypeComparator;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.validator.StudyValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.StudyForm;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.TimeTrack;

@Controller
@RequestMapping("/college/study")
@SessionAttributes({ "studyForm" })
public class StudyEditController {

    private static Logger log = LoggerFactory.getLogger(StudyEditController.class);
    private String formView;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private StaffMemberManagerInterface staffMemberManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private MessageSource messageSource;

    public StudyEditController() {
        super();
        this.formView = "college/study/study";
    }

    /**
     * @param model
     * @param request
     * @return
     * @throws ServletRequestBindingException 
     */
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) throws ServletRequestBindingException {
    	TimeTrack timer = new TimeTrack("StudyEditController.setupForm");
        
        // declare variables
        StudyForm studyForm = null;
        Study study = null;
        Organization organization = null;
        NavigationSettings navigationSettings = null;

        int studyId = 0;

        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;
        
        HttpSession session = request.getSession(false);
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        // if adding a new study, destroy any existing one on the session
        opusMethods.removeSessionFormObject("studyForm", session, model, opusMethods.isNewForm(request));

        /* set menu to studies */
        session.setAttribute("menuChoice", "studies");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        // get the StudyId if it exists (requestMethos = GET)
        if (!StringUtil.isNullOrEmpty(request.getParameter("studyId"))) {
            studyId = Integer.parseInt(request.getParameter("studyId"));
        }

        /* STUDYFORM - fetch or create the form object and fill it with study */
        if ((StudyForm) session.getAttribute("studyForm") != null) {
            studyForm = (StudyForm) session.getAttribute("studyForm");
        } else {
            studyForm = new StudyForm();
            
            studyForm.setCodeToCardinalTimeUnitMap(new CodeToLookupMap(lookupCacher.getAllCardinalTimeUnits(preferredLanguage)));

        }
        if (studyForm.getStudy() == null) {
            // EXISTING STUDY
            if (studyId != 0) {
                study = studyManager.findStudy(studyId);
                // find organization id's matching with the study
                organizationalUnitId = study.getOrganizationalUnitId();
                branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
                institutionId = institutionManager.findInstitutionOfBranch(branchId);
            // NEW STUDY
            } else {
                study = new Study();
                // fetch organization from session
                institutionId = OpusMethods.getInstitutionId(session, request);
                branchId = OpusMethods.getBranchId(session, request);
                organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
                
                study.setOrganizationalUnitId(organizationalUnitId);
                study.setActive("Y");
                study.setDateOfEstablishment(null);
                // set default organization id's
            }
        } else {
            study = studyForm.getStudy(); 
        }
        studyForm.setStudy(study);

        /* STUDYFORM.ORGANIZATION - fetch or create the object */
        if (studyForm.getOrganization() != null) {
        	organization = studyForm.getOrganization();
        } else {
        	organization = new Organization();

        	// get the organization values from study:
            organization = opusMethods.fillOrganization(session, request, organization, 
            		organizationalUnitId, branchId, institutionId);
        }
        studyForm.setOrganization(organization);

        /* STUDYFORM.NAVIGATIONSETTINGS - fetch or create the object */
        if (studyForm.getNavigationSettings() != null) {
        	navigationSettings = studyForm.getNavigationSettings();
        } else {
        	navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
        }
        studyForm.setNavigationSettings(navigationSettings);

        // MoVe - also possible to get request parameters / attributes like this:
        if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(
                request, "showStudyGradeTypeError"))) {
            studyForm.setTxtErr(ServletRequestUtils.getStringParameter(
                            request, "showStudyGradeTypeError"));
        }
        if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(
                request, "showSubjectStudyGradeTypeError"))) {
        	studyForm.setTxtErr(studyForm.getTxtErr() 
        			+ ServletRequestUtils.getStringParameter(
                            request, "showSubjectStudyGradeTypeError"));
        }
        if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(
                request, "txtErr"))) {
        	studyForm.setTxtErr(studyForm.getTxtErr() 
        			+ ServletRequestUtils.getStringParameter(
                            request, "txtErr"));
        }

        if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(
                request, "txtMsg"))) {
        	studyForm.setTxtMsg(studyForm.getTxtErr() + 
        			ServletRequestUtils.getStringParameter(
                            request, "txtMsg"));
        }

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(studyForm.getOrganization(),
                session, request, organization.getInstitutionTypeCode(),
                organization.getInstitutionId(), organization.getBranchId(), 
                organization.getOrganizationalUnitId());
        
        loadLookupTables(request, preferredLanguage);

        /* get study domain lookups */
        List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
        studyForm.setAllAcademicYears(allAcademicYears);

        // see if the endGrades are defined on studygradetype level:
        String endGradesPerGradeType = studyManager.findEndGradeType(0);
        log.debug("StudyEditController: endGradesPerGradeType 1 = " + endGradesPerGradeType);
        if (endGradesPerGradeType == null || "".equals(endGradesPerGradeType)) {
            endGradesPerGradeType = "N";
        } else {
            endGradesPerGradeType = "Y";
        }
        studyForm.setEndGradesPerGradeType(endGradesPerGradeType); 

        /* work around the addresstypes */
        List < ? extends Lookup > allAddressTypes = (List < ? extends Lookup >
                                                    ) request.getAttribute("allAddressTypes");
        List<Lookup> allAddressTypesActual = new ArrayList<>();
        Lookup aType = null;
        int ix = 0;
        model.addAttribute("allAddressTypes", null);
        for (int i = 0; i < allAddressTypes.size(); i++) {
            //formal communication address study = code 4
            if ("4".equals(allAddressTypes.get(i).getCode())) {
                aType = allAddressTypes.get(i);
                allAddressTypesActual.add(ix, aType);
                ix = ix + 1;
            }
        }
        studyForm.setAllAddressTypes(
        		(List < ? extends Lookup >) allAddressTypesActual);

        studyForm.setAllContacts(staffMemberManager.findAllContacts(
        		study.getOrganizationalUnitId()));

        studyForm.setAllStudyGradeTypes(studyManager.findAllStudyGradeTypes());
        
        // sort study grade types
        if (study.getStudyGradeTypes() != null) {
            List<? extends Lookup9> allGradeTypes = lookupCacher.getAllGradeTypes();
            StudyGradeTypeComparator comparator = new StudyGradeTypeComparator(allAcademicYears, allGradeTypes);
            comparator.setAscendingAcademicYear(false);
            Collections.sort(study.getStudyGradeTypes(), comparator);
        }

        model.addAttribute("studyForm", studyForm);
        timer.end();
        return formView;
    }

    /**
     * @param studyForm
     * @param result
     * @param status
     * @param request
     * @return
     */
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
    		@ModelAttribute("studyForm") StudyForm studyForm,
            BindingResult result, SessionStatus status, HttpServletRequest request) { 

    	Organization organization = studyForm.getOrganization();
    	NavigationSettings navigationSettings = studyForm.getNavigationSettings();

        HttpSession session = request.getSession(false);        

        String submitFormObject = "";

        Locale currentLoc = RequestContextUtils.getLocale(request);
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        studyForm.getStudy().setOrganizationalUnitId(
        			organization.getOrganizationalUnitId());
        
        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }

        if ("true".equals(submitFormObject)) {
            
            new StudyValidator().validate(studyForm, result);
            if (result.hasErrors()) {

            	/* fill lookup-tables with right values */
                loadLookupTables(request, preferredLanguage);

            	return formView;
            }
            
            if (studyForm.getStudy().getId() == 0) {
                // NEW STUDY
                /* test if the combination already exists */
// TODO do this check also when updating the study, e.g. studyDescription or orgUnitId might have changed
                Map<String, Object> findStudyMap = new HashMap<String, Object>();
                findStudyMap.put("studyDescription", studyForm.getStudy().getStudyDescription());
                findStudyMap.put("organizationalUnitId", studyForm.getStudy().getOrganizationalUnitId());
                if (studyManager.findStudyByNameUnit(findStudyMap) != null) {

                	studyForm.setTxtErr(studyForm.getTxtErr() 
                    	+ studyForm.getStudy().getStudyDescription() + ". "
                        + messageSource.getMessage("jsp.error.general.alreadyexists"
                                                    , null, currentLoc));

                	//status.setComplete();

                	loadLookupTables(request, preferredLanguage);
                	
                	//return "redirect:study.view";
                	return formView;
                	
                } else {

                    // add the new study AND straight away fetch last id from table:
                    studyManager.addStudy(studyForm.getStudy());
                    studyForm.setTxtMsg(messageSource.getMessage(
                            "jsp.message.submissionsuccess", null, currentLoc));

                    status.setComplete();
                    
                    return "redirect:study.view?tab=" + navigationSettings.getTab() 
                    	+ "&panel=" + navigationSettings.getPanel() 
                    	+ "&studyId=" + studyForm.getStudy().getId() 
                    	+ "&txtErr=" + studyForm.getTxtErr()
                    	+ "&txtMsg=" + studyForm.getTxtMsg()
                        + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
                } 

            } else {
                // UPDATE STUDY
                studyManager.updateStudy(studyForm.getStudy());
                status.setComplete();

                return "redirect:/college/studies.view?newForm=true&"
                  + "educationTypeCode=" + organization.getInstitutionTypeCode()
                  + "&txtErr=" + studyForm.getTxtErr()
                  + "&txtMsg=" + studyForm.getTxtMsg()
                  + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
            }
        } else {
            // submit but no save
            //status.setComplete();
            session.setAttribute("institutionId", organization.getInstitutionId());
            session.setAttribute("branchId", organization.getBranchId());
            session.setAttribute("organizationalUnitId", organization.getOrganizationalUnitId());
            
            return "redirect:/college/study.view";
        }

    }

    private void loadLookupTables(HttpServletRequest request, String preferredLanguage) {
        lookupCacher.getPersonLookups(preferredLanguage, request);
        lookupCacher.getStudyLookups(preferredLanguage, request);
        lookupCacher.getAddressLookups(preferredLanguage, request);
    }
}
