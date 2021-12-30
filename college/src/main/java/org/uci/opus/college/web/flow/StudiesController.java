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
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.OpusUserRole;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToBranchMap;
import org.uci.opus.college.domain.util.IdToOrganizationalUnitMap;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.StudiesForm;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.TimeTrack;

@Controller
@RequestMapping("/college/studies.view")
@SessionAttributes({"studiesForm"})
public class StudiesController {

    private Logger log = LoggerFactory.getLogger(StudiesController.class);

    private String formView;

    @Autowired private SecurityChecker securityChecker;    
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private StaffMemberManagerInterface staffMemberManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private OpusMethods opusMethods;

    public StudiesController() {
        super();
        this.formView = "college/study/studies";
    }

    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {
    	TimeTrack timer = new TimeTrack("StudiesController.setupForm");

        HttpSession session = request.getSession(false);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        opusMethods.removeSessionFormObject("studiesForm", session, model, opusMethods.isNewForm(request));

        /* set menu to studies */
        session.setAttribute("menuChoice", "studies");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        OpusUserRole opusUserRole = (OpusUserRole) session.getAttribute("opusUserRole");

        /* studiesForm - fetch or create the form object and fill it 
         *     with organization and navigationSettings */
        StudiesForm studiesForm = (StudiesForm) model.get("studiesForm");
        if (studiesForm == null) {
            studiesForm = new StudiesForm();
            model.put("studiesForm", studiesForm);
        }

        Organization organization = new Organization();
        int organizationalUnitId = (Integer) session.getAttribute("organizationalUnitId");
        int branchId = (Integer) session.getAttribute("branchId");
        int institutionId = (Integer) session.getAttribute("institutionId");
        organization = opusMethods.fillOrganization(session, request, organization, 
                organizationalUnitId, branchId, institutionId);
        studiesForm.setOrganization(organization);

        NavigationSettings navigationSettings = new NavigationSettings();
        opusMethods.fillNavigationSettings(request, navigationSettings, "studies.view");
        studiesForm.setNavigationSettings(navigationSettings);

        /* Catch errormessages */ // TODO replace with binding result
        if (!StringUtil.isNullOrEmpty(request.getParameter("txtErr"))) {
            studiesForm.setTxtErr(request.getParameter("txtErr"));
        }


        /* fill lookup-tables with right values */
        lookupCacher.getStudyLookups(preferredLanguage, request);
        timer.measure("lookups");

        /* retrieve all domain lookups for Study */
        // LIST OF STUDIES
        Map<String, Object> findStudiesMap = new HashMap<>();
        findStudiesMap.put("institutionId", organization.getInstitutionId());
        /* perform role check. */
        if ("finance".equals(opusUserRole.getRole()) || "audit".equals(opusUserRole.getRole())) {
            findStudiesMap.put("branchId", 0);
            findStudiesMap.put("organizationalUnitId", 0);
        } else {
            findStudiesMap.put("branchId", organization.getBranchId());
            findStudiesMap.put("organizationalUnitId", organization.getOrganizationalUnitId());
        }
        findStudiesMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
        findStudiesMap.put("searchValue", navigationSettings.getSearchValue());
        List<Study> studies = studyManager.findStudies(findStudiesMap);
        studiesForm.setAllStudies(studies);
        timer.measure("find studies");

        // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
        opusMethods.getInstitutionBranchOrganizationalUnitSelect(organization,
                session, request, organization.getInstitutionTypeCode(),
                organization.getInstitutionId(), organization.getBranchId(), 
                organization.getOrganizationalUnitId());

        List<OrganizationalUnit> organizationalUnits = new ArrayList<>();
        if (!studies.isEmpty()) {
            List<Integer> organizationalUnitIds = DomainUtil.getIntProperties(studies, "organizationalUnitId");
            organizationalUnits = organizationalUnitManager.findOrganizationalUnitsByIds(organizationalUnitIds);
        }
        studiesForm.setIdToOrganizationalUnitMap(new IdToOrganizationalUnitMap(organizationalUnits));

        List<Branch> branches = new ArrayList<>();
        if (!organizationalUnits.isEmpty()) {
            List<Integer> branchIds = DomainUtil.getIntProperties(organizationalUnits, "branchId");
            branches = branchManager.findBranchesByIds(branchIds);
        }
        studiesForm.setIdToBranchMap(new IdToBranchMap(branches));
        timer.end();

        return formView; 
    }

    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
            @ModelAttribute("studiesForm") StudiesForm studiesForm,
            BindingResult result, SessionStatus status, HttpServletRequest request) {

        NavigationSettings navigationSettings = studiesForm.getNavigationSettings();

        Organization organization = studiesForm.getOrganization();
        HttpSession session = request.getSession(false);        

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        // overview: put chosen organization on session:
        session.setAttribute("organizationalUnitId",organization.getOrganizationalUnitId());
        session.setAttribute("branchId",organization.getBranchId());
        session.setAttribute("institutionId",organization.getInstitutionId());


        /* fill lookup-tables with right values */
        lookupCacher.getStudyLookups(preferredLanguage, request);

        return "redirect:studies.view?tab=" + navigationSettings.getTab() 
                + "&panel=" + navigationSettings.getPanel() 
                + "&txtErr=" + studiesForm.getTxtErr()
                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
    }

}
