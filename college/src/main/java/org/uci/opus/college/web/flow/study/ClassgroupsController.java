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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Classgroup;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.flow.OverviewController;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.study.ClassgroupsForm;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.OpusMethods;

@Controller
@SessionAttributes({ ClassgroupsController.FORM_NAME })
public class ClassgroupsController extends OverviewController<Classgroup, ClassgroupsForm> {

    public static final String FORM_NAME = "classgroupsForm";
    private String viewName = "college/study/classgroups";
    
    @Autowired private LookupCacher lookupCacher;
    @Autowired private OpusInit opusInit;
    @Autowired private StudyManagerInterface studyManager;
    
	public ClassgroupsController() {
        super(FORM_NAME, "studies");
    }

	@RequestMapping(value="/college/classgroups.view", method = RequestMethod.GET)
	public String showClassgroups(HttpServletRequest request, ModelMap model) {

	    super.initSetupForm(model, request);

//		HttpSession session = request.getSession(false);
//		securityChecker.checkSessionValid(session);
//		opusMethods.removeSessionFormObject(FORM_NAME, session, model, opusMethods.isNewForm(request));
//
//		/* set menu to classgroups */
//		session.setAttribute("menuChoice", "studies");
//
//		ClassgroupsForm form = null;
//		Organization organization = null;
//		NavigationSettings navigationSettings = null;

//		int institutionId = 0;
//		int branchId = 0;
//		int organizationalUnitId = 0;
//		int studyId = 0;

//		/* fetch or create the form object */
//		form = (ClassgroupsForm) model.get(FORM_NAME);
//		if (form == null) {
//			form = new ClassgroupsForm();
//			if (!StringUtil.isNullOrEmpty(request.getParameter("studyId"))) {
//				studyId = Integer.parseInt(request.getParameter("studyId"));
//				form.setStudyId(studyId);
//			}
//			model.put(FORM_NAME, form);
//		}

		/* ORGANIZATION - fetch or create the object */
//		if (form.getOrganization() != null) {
//			organization = form.getOrganization();
//		} else {
//			organization = new Organization();
//
//			organizationalUnitId = ((Integer) session.getAttribute("organizationalUnitId"));
//			branchId = ((Integer) session.getAttribute("branchId"));
//			institutionId = ((Integer) session.getAttribute("institutionId"));
//			organization = opusMethods.fillOrganization(session, request, organization, organizationalUnitId, branchId, institutionId);
//			form.setOrganization(organization);
//		}

		/* NAVIGATION SETTINGS - fetch or create the object */
//		if (form.getNavigationSettings() != null) {
//			navigationSettings = form.getNavigationSettings();
//		} else {
//			navigationSettings = new NavigationSettings();
//			opusMethods.fillNavigationSettings(request, navigationSettings, null);
//		}
//		form.setNavigationSettings(navigationSettings);

		/*
		 * retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS
		 * 
		 * the institutionTypeCode is used for studies, and therefore subjects,
		 * Studies are only registered for universities; if in the future this
		 * should change, it will be easier to alter the code
		 */
//		opusMethods.getInstitutionBranchOrganizationalUnitSelect(
//				session, request, organization.getInstitutionTypeCode(), organization.getInstitutionId(),
//				organization.getBranchId(), organization.getOrganizationalUnitId());


		return viewName;
	}
	
	@Override
	protected ClassgroupsForm createForm(ModelMap model, HttpServletRequest request) {

        return new ClassgroupsForm();
	}
	
	@Override
	protected void initForm(ClassgroupsForm form, HttpServletRequest request) {

        form.setNavigationSettings(opusMethods.createAndFillNavigationSettings(request));

        Organization organization = opusMethods.createAndFillOrganization(request);
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(organization, request);
        form.setOrganization(organization);

//        NavigationSettings navigationSettings = new NavigationSettings();
//        opusMethods.fillNavigationSettings(request, navigationSettings);
//        form.setNavigationSettings(navigationSettings);

        List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
        form.setIdToAcademicYearMap(new IdToAcademicYearMap(allAcademicYears));
        setCurrentAcademicYear(form, allAcademicYears);
    }
	
	@Override
	protected void loadDynamicLookupTableData(HttpServletRequest request, ClassgroupsForm form) {

        Organization organization = form.getOrganization();
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        Map<String, Object> findStudiesMap = new HashMap<>();
        findStudiesMap.put("institutionId", organization.getInstitutionId());
        findStudiesMap.put("branchId", organization.getBranchId());
        findStudiesMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
        findStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
        findStudiesMap.put("preferredLanguage", preferredLanguage);
        form.setAllStudies(studyManager.findStudies(findStudiesMap));

        findStudiesMap.put("studyId", form.getStudyId());
        findStudiesMap.put("currentAcademicYearId", form.getAcademicYearId());       
        form.setAllStudyGradeTypes(studyManager.findStudyGradeTypes(findStudiesMap));
        
        form.setCodeToGradeTypeMap(new CodeToLookupMap(lookupCacher.getAllGradeTypes(preferredLanguage)));
        form.setCodeToStudyFormMap(new CodeToLookupMap(lookupCacher.getAllStudyForms(preferredLanguage)));
        form.setCodeToStudyTimeMap(new CodeToLookupMap(lookupCacher.getAllStudyTimes(preferredLanguage)));
	}
	
	@Override
	protected void loadFilterContents(HttpServletRequest request, ClassgroupsForm form) {
	    
        Organization organization = form.getOrganization();
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(organization, request);

        if (form.getOrganization().getOrganizationalUnitId() == 0) {
            form.setStudyId(0);
        }
        
        // academic years combo
        Map<String, Object> map = new HashMap<>();
        map.put("organizationalUnitId", organization.getOrganizationalUnitId());
        map.put("studyId", form.getStudyId());
        List<AcademicYear> allAcademicYears = studyManager.findAllAcademicYears(map);
        form.setAllAcademicYears(allAcademicYears);

        // reset academicYearId if not in list of available academic years (e.g. after changing study filter selection)
        List<Integer> allAcademicYearIds = DomainUtil.getIds(allAcademicYears);
        if (!allAcademicYearIds.contains(form.getAcademicYearId())) {
            setCurrentAcademicYearIfUnset(form, allAcademicYears);
        }

	}
	
	@Override
	protected void loadOverviewList(HttpServletRequest request, ClassgroupsForm form) {

        Organization organization = form.getOrganization();
        NavigationSettings navigationSettings = form.getNavigationSettings();

        // List of Classgroups
        List<Classgroup> allClassgroups = null;
        Map<String, Object> findClassgroupsMap = new HashMap<>();
        findClassgroupsMap.put("institutionId", organization.getInstitutionId());
        /* perform role check. */
//        OpusUserRole opusUserRole = (OpusUserRole) session.getAttribute("opusUserRole");
//      if ("finance".equals(opusUserRole.getRole()) || "audit".equals(opusUserRole.getRole())) {
//          findClassgroupsMap.put("branchId", 0);
//          findClassgroupsMap.put("organizationalUnitId", 0);
//      } else {
            findClassgroupsMap.put("branchId", organization.getBranchId());
            findClassgroupsMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
//      }
        findClassgroupsMap.put("studyId", form.getStudyId());
        findClassgroupsMap.put("studyGradeTypeId", form.getStudyGradeTypeId());
        findClassgroupsMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
        findClassgroupsMap.put("searchValue", navigationSettings.getSearchValue());
        findClassgroupsMap.put("currentAcademicYearId", form.getAcademicYearId());
//        findClassgroupsMap.put("orderBy", form.getOrderBy());

        // get the total count that apply to the filter criteria
        int classgroupCount = studyManager.findClassgroupCount(findClassgroupsMap);
        form.setClassgroupCount(classgroupCount);

        int iPaging = opusInit.getPaging();
        findClassgroupsMap.put("offset", (navigationSettings.getCurrentPageNumber() - 1) * iPaging);
        findClassgroupsMap.put("limit", iPaging);

        allClassgroups = studyManager.findClassgroups(findClassgroupsMap);

        form.setAllClassgroups(allClassgroups);
	}

	@RequestMapping(value="/college/classgroups.view", method = RequestMethod.POST)
	public String processSubmit(
			@ModelAttribute(FORM_NAME) ClassgroupsForm form,
			BindingResult result,
			HttpServletRequest request) {

        processSubmitGeneric(form, request);

        return viewName;
	}

	@RequestMapping(value="/college/classgroup_delete.view", method = RequestMethod.GET)
    @PreAuthorize("hasRole('DELETE_CLASSGROUPS')")
	public String processDelete(
			@ModelAttribute(FORM_NAME) ClassgroupsForm classgroupsForm,
			BindingResult bindingResult,
			SessionStatus status,
			HttpServletRequest request,
			ModelMap model) {

        HttpSession session = request.getSession(false);        
        securityChecker.checkSessionValid(session);
        
    	Organization organization = classgroupsForm.getOrganization();
    	if (organization != null) {
			opusMethods.getInstitutionBranchOrganizationalUnitSelect(
					session, request, organization.getInstitutionTypeCode(), organization.getInstitutionId(),
					organization.getBranchId(), organization.getOrganizationalUnitId());
    	}

        int classgroupId = Integer.parseInt(request.getParameter("classgroupId"));
        if (classgroupId != 0) {
        	// TODO: clarify if there are any conditions which prevent the deletion of a class.
            // Use bindingResult to set any problematic conditions

            if (bindingResult.hasErrors()) {
            	return viewName;
            } 
            
            studyManager.deleteClassgroup(classgroupId);
        }

        return "redirect:/college/classgroups.view";
    }
}
