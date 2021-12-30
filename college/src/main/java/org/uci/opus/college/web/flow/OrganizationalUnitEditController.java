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

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.college.domain.AdmissionRegistrationConfig;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.persistence.OrganizationalUnitMapper;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.PersonManagerInterface;
import org.uci.opus.college.validator.OrganizationalUnitValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.org.OrganizationalUnitForm;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;
import org.uci.opus.util.TimeTrack;

@Controller
@RequestMapping("/college/organizationalunit")
@SessionAttributes({ OrganizationalUnitEditController.FORM_OBJECT })
public class OrganizationalUnitEditController {

    public static final String FORM_OBJECT = "organizationalUnitForm";
    private static final String FORM_VIEW = "college/organization/organizationalunit";

    private static Logger log = LoggerFactory.getLogger(OrganizationalUnitEditController.class);

    private OrganizationalUnitValidator validator = new OrganizationalUnitValidator();

    @Autowired
    private OrganizationalUnitManagerInterface organizationalUnitManager;

    @Autowired
    private OrganizationalUnitMapper organizationalUnitMapper;

    @Autowired
    private LookupCacher lookupCacher;

    @Autowired
    private PersonManagerInterface personManager;

    @Autowired
    private InstitutionManagerInterface institutionManager;

    @Autowired
    private BranchManagerInterface branchManager;

    @Autowired
    private AcademicYearManagerInterface academicYearManager;

    @Autowired
    private OpusMethods opusMethods;

    public OrganizationalUnitEditController() {
        super();
    }

    /**
     * Adds a property editor for dates to the binder.
     */
    @InitBinder
    public void initBinder(ServletRequestDataBinder binder) {

        /* custom date editor */
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        // CustomDateEditor(DateFormat dateFormat, boolean allowEmpty);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    /**
     * Creates a form backing object. If the request parameter "id" (of the organizationalUnit) is
     * set, the specified organizationalUnit is read. Otherwise a new one is created.
     */
    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {
		TimeTrack timer = new TimeTrack("OrganizationalUnitEditController.setupForm");
        
        HttpSession session = request.getSession(false);

        OrganizationalUnitForm form = new OrganizationalUnitForm();
        model.put(FORM_OBJECT, form);

        NavigationSettings navigationSettings = opusMethods.createAndFillNavigationSettings(request);
        form.setNavigationSettings(navigationSettings);

        Organization organization = opusMethods.createAndFillOrganization(session, request);
        form.setOrganization(organization);

        // declare variables
        /* set menu to institutions */
        session.setAttribute("menuChoice", "institutions");
        
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

//        if (!StringUtil.isNullOrEmpty(request.getParameter("parentAddress"))) {
//            parentAddress = request.getParameter("parentAddress");
//        }
//        request.setAttribute("parentAddress", parentAddress);

//        if (!StringUtil.isNullOrEmpty(request.getParameter("showError"))) {
//            showError = request.getParameter("showError");
//        }
//        request.setAttribute("showError", showError);

        int childOUId = ServletUtil.getIntParam(request, "childOUId", 0);
        form.setChildOUId(childOUId);

        // get the ORGANIZATIONALUNITID if it exists
        int organizationalUnitId = ServletUtil.getIntParam(request, "organizationalUnitId", 0);
//        if (!StringUtil.isNullOrEmpty(request.getParameter("organizationalUnitId"))) {
//            organizationalUnitId = Integer.parseInt(request.getParameter("organizationalUnitId"));
//            session.setAttribute("organizationalUnitId", organizationalUnitId);
//        }

        // get the correct institutionId and set it on the session
//        institutionId = OpusMethods.getInstitutionId(session, request);
//        session.setAttribute("institutionId", institutionId);
//
//        branchId = OpusMethods.getBranchId(session, request);
//        session.setAttribute("branchId", branchId);

        // entering from overview
        // if (StringUtil.isNullOrEmpty((String) session.getAttribute("from"))
        // && "organizationalunits".equals(request.getParameter("from"))) {
        // session.setAttribute("from", "organizationalunit");
        //
        // if (branchId == 0) {
        // branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
        // session.setAttribute("branchId", branchId);
        // }
        //
        // if (institutionId == 0) {
        // institutionId = institutionManager.findInstitutionOfBranch(branchId);
        // session.setAttribute("institutionId", institutionId);
        // }
        // } else if (
        //
        // // first time pulldown is changed
        // ("organizationalunits".equals(request.getParameter("from"))
        // && "organizationalunit".equals(session.getAttribute("from")))
        // ||
        // // pulldown has been changed at least once already
        // ("organizationalunit".equals(request.getParameter("from"))
        // && StringUtil.isNullOrEmpty((String) session.getAttribute("from"), true))
        // ) {
        //
        // session.setAttribute("from", null);
        //
        // if (institutionId == 0) {
        // branchId = 0;
        // session.setAttribute("branchId", branchId);
        // }
        //
        // // check if the combination of branchId and institutionId is a correct one
        // // if not, the institution is leading
        // int tmpInstitutionId = institutionManager.findInstitutionOfBranch(branchId);
        // if (tmpInstitutionId != institutionId) {
        // branchId = 0;
        // session.setAttribute("branchId", branchId);
        // }
        // }

        // find a LIST OF INSTITUTIONS of the correct educationtype
        // institutionTypeCode needed to find the correct list of institutions
//        String institutionTypeCode = "";
//        if (!StringUtil.isNullOrEmpty((String) request.getParameter("institutionTypeCode"))) {
//            institutionTypeCode = request.getParameter("institutionTypeCode");
//        } else if (!StringUtil.isNullOrEmpty((String) request.getAttribute("institutionTypeCode"))) {
//            institutionTypeCode = (String) request.getAttribute("institutionTypeCode");
//        }
//        request.setAttribute("institutionTypeCode", institutionTypeCode);

        // get the institutions of the correct educationType
        Map<String, Object> map = new HashMap<>();
        map.put("institutionTypeCode", organization.getInstitutionTypeCode());
        List<Institution> allInstitutions = institutionManager.findInstitutions(map);
        organization.setAllInstitutions(allInstitutions);

        // get a LIST OF all BRANCHES of the selected institution
        List<Branch> allBranches = null;
        int institutionId = organization.getInstitutionId();
        if (institutionId != 0) {
            Map<String, Object> findBranchesMap = new HashMap<>();
            findBranchesMap.put("institutionId", institutionId);
            allBranches = branchManager.findBranches(findBranchesMap);
        }
        organization.setAllBranches(allBranches);
        timer.measure("all branches");

        OrganizationalUnit organizationalUnit;
        int unitLevel;
        int parentOrganizationalUnitId = ServletUtil.getIntParam(request, "parentOUId", 0);

        if (organizationalUnitId != 0) {

            // EXISTING ORGANIZATIONALUNIT
            organizationalUnit = organizationalUnitManager.findOrganizationalUnit(organizationalUnitId);
            unitLevel = organizationalUnit.getUnitLevel();

        } else {

            // NEW ORGANIZATIONAL UNIT
            organizationalUnit = new OrganizationalUnit();
            /* generate organizationalUnitCode */
            String organizationalUnitCode = StringUtil.createUniqueCode("O", "" + institutionId);
            organizationalUnit.setOrganizationalUnitCode(organizationalUnitCode);

            unitLevel = ServletUtil.getIntParam(request, "unitLevel", 0);
            organizationalUnit.setUnitLevel(unitLevel);
            organizationalUnit.setParentOrganizationalUnitId(parentOrganizationalUnitId);
            organizationalUnit.setBranchId(ServletUtil.getIntParam(request, "branchId", 0));
            organizationalUnit.setActive("Y");
        }
        form.setOrganizationalUnit(organizationalUnit);

        // needed to show the parent's name in the header (bread crumbs path)
        OrganizationalUnit parentOrgUnit = null;
        if (parentOrganizationalUnitId != 0) {
            parentOrgUnit = organizationalUnitManager.findOrganizationalUnit(parentOrganizationalUnitId);
        }
        form.setParentOrgUnit(parentOrgUnit);

        /* work around the address types */
        List<Lookup> allAddressTypes = lookupCacher.getAllAddressTypes(preferredLanguage);
        List<Lookup> allAddressTypesActual = new ArrayList<>();
        Lookup aType = null;
        int ix = 0;
        for (int i = 0; i < allAddressTypes.size(); i++) {
            // formal communication address organizational unit = code 5
            if ("5".equals(allAddressTypes.get(i).getCode())) {
                aType = allAddressTypes.get(i);
                allAddressTypesActual.add(ix, aType);
                ix = ix + 1;
            }
        }
        form.setAllAddressTypes(allAddressTypesActual);
        
        form.setAllUnitTypes(lookupCacher.getAllUnitTypes(preferredLanguage));
        form.setAllAcademicFields(lookupCacher.getAllAcademicFields(preferredLanguage));
        form.setAllUnitAreas(lookupCacher.getAllUnitAreas(preferredLanguage));

        // getting the country/provinces/etc. lists through the lookupCacher logic and then copying into the form object
        lookupCacher.getAddressLookups(preferredLanguage, request);
        form.setAllCountries(lookupCacher.getAllCountries());
        form.setAllProvinces(lookupCacher.getAllProvinces());
        form.setAllDistricts(lookupCacher.getAllDistricts());
        form.setAllAdministrativePosts(lookupCacher.getAllAdministrativePosts());
        timer.measure("lookups");

        // fill domain lists

        // 1. directors:
        int branchId = organization.getBranchId();
        Map<String, Object> findDirectorsMap = new HashMap<>();
        findDirectorsMap.put("institutionId", institutionId);
        findDirectorsMap.put("branchId", branchId);
        findDirectorsMap.put("organizationalUnitId", organizationalUnitId);

        List<StaffMember> allDirectors = personManager.findDirectors(findDirectorsMap);
        form.setAllDirectors(allDirectors);
        timer.measure("all directors");

        // get list of organizational units to loop through,
        // to show the name in the director pulldown
        Map<String, Object> findOrgUnitsMap = new HashMap<>();
        findOrgUnitsMap.put("institutionId", institutionId);
        findOrgUnitsMap.put("institutionTypeCode", organization.getInstitutionTypeCode());
        // allOrganizationalUnits = organizationalUnitManager.findAllOrganizationalUnitsForInstitution(institutionId);
        List<OrganizationalUnit> allOrganizationalUnits = organizationalUnitManager.findOrganizationalUnits(findOrgUnitsMap);
        organization.setAllOrganizationalUnits(allOrganizationalUnits);
        timer.measure("all org units");

        // 2. all possible parent units:
        List<OrganizationalUnit> allParentOrganizationalUnits = null;
        if (unitLevel != 0 && unitLevel != 1) {
            int parentUnitlevel = unitLevel - 1;
            allParentOrganizationalUnits = organizationalUnitManager.findAllOrganizationalUnitAtLevel(parentUnitlevel, branchId);
        }
        form.setAllParentOrganizationalUnits(allParentOrganizationalUnits);

        // 3. child units, if they exist:
        List<OrganizationalUnit> allChildOrganizationalUnits = null;
        if (organizationalUnitId != 0) {
            allChildOrganizationalUnits = organizationalUnitManager.findAllChildrenForOrganizationalUnit(organizationalUnitId);
        }
        form.setAllChildOrganizationalUnits(allChildOrganizationalUnits);

        request.setAttribute("idToAcademicYearMap", new IdToAcademicYearMap(academicYearManager.findAllAcademicYears()));

        timer.end();
        return FORM_VIEW;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request, @ModelAttribute(FORM_OBJECT) OrganizationalUnitForm form, BindingResult result) {

        OrganizationalUnit organizationalUnit = form.getOrganizationalUnit();

        result.pushNestedPath("organizationalUnit");
        validator.validate(organizationalUnit, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            return FORM_VIEW;
        }

        // check if organizationalUnitDescription already exists:  -- TODO: move to validation
        Map<String, Object> findOUMap = new HashMap<>();
        findOUMap.put("organizationalUnitDescription", organizationalUnit.getOrganizationalUnitDescription());
        findOUMap.put("organizationalUnitCode", organizationalUnit.getOrganizationalUnitCode());
        findOUMap.put("id", organizationalUnit.getId());
        if (organizationalUnitMapper.existsDuplicate(findOUMap) != null) {
            result.reject("jsp.error.general.alreadyexists");
            return FORM_VIEW;
        }

//        Address address = null;
//
//        String parentAddress = "N";
//        if (!StringUtil.isNullOrEmpty(request.getParameter("parentAddress"))) {
//            parentAddress = request.getParameter("parentAddress");
//        }
//
//        if ("Y".equals(parentAddress)) {
//            address = addressManager.findParentAddress(address.getOrganizationalUnitId());
//
//        }

        // needed to find the correct list of institutions
        String institutionTypeCode = form.getOrganization().getInstitutionTypeCode();

        // if the organizationalUnitCode is empty, generate a new code
        if (StringUtil.isNullOrEmpty(organizationalUnit.getOrganizationalUnitCode(), true)) {
            String organizationalUnitCode = StringUtil.createUniqueCode("O", request.getParameter("institutionId"));
            organizationalUnit.setOrganizationalUnitCode(organizationalUnitCode);
        }

        if (organizationalUnit.getId() == 0) {
            // NEW UNIT
            log.info("adding " + organizationalUnit);
            organizationalUnitManager.addOrganizationalUnit(organizationalUnit);

        } else {
            // UPDATE UNIT
            // update the organizationalunit
            log.info("updating " + organizationalUnit);
            organizationalUnitManager.updateOrganizationalUnit(organizationalUnit);
        }

//        request.setAttribute("institutionId", null);
//        request.setAttribute("branchId", null);

        NavigationSettings nav = form.getNavigationSettings();
        return "redirect:/college/organizationalunit.view?newForm=true&organizationalUnitId=" + organizationalUnit.getId() + "&tab=0&panel=0"
                    + "&institutionTypeCode=" + institutionTypeCode + "&from=organizationalunit"
//                            + "&childOUId=" + request.getAttribute("childOUId")
                            + "&currentPageNumber=" + nav.getCurrentPageNumber();

    }
    
    @RequestMapping(value = "/deleteAdmissionRegistrationConfig/{admissionRegistrationConfigId}")
    public String delete(HttpServletRequest request, @PathVariable("admissionRegistrationConfigId") int admissionRegistrationConfigId,
            @ModelAttribute(FORM_OBJECT) OrganizationalUnitForm form, BindingResult result) {

//        int admissionRegistrationConfigId = ServletUtil.getIntParam(request, "admissionRegistrationConfigId", 0);
//        int organizationalUnitId = ServletUtil.getIntParam(request, "organizationalUnitId", 0);
//        int currentPageNumber = ServletUtil.getIntParam(request, "currentPageNumber", 0);
//        int tab = ServletUtil.getIntParam(request, "tab", 0);
//        int panel = ServletUtil.getIntParam(request, "panel", 0);
        
        if (admissionRegistrationConfigId == 0) {
            throw new RuntimeException("Cannot delete due to missing value of admissionRegistrationConfigId");
        }
        
        AdmissionRegistrationConfig config = organizationalUnitManager.findAdmissionRegistrationConfig(admissionRegistrationConfigId);
        if (config == null) {
            throw new RuntimeException("Invalid admissionRegistrationConfigId given");
        }
        int organizationalUnitId = config.getOrganizationalUnitId();
        
        organizationalUnitManager.deleteAdmissionRegistrationConfig(admissionRegistrationConfigId);
        
        NavigationSettings nav = form.getNavigationSettings();
        return "redirect:/college/organizationalunit.view?newForm=true&tab=" + nav.getTab() 
                + "&panel=" + nav.getPanel()
                + "&organizationalUnitId=" + organizationalUnitId
                + "&currentPageNumber=" + nav.getCurrentPageNumber();
    }
    
}
