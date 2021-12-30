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
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
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
import org.uci.opus.college.domain.Address;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.service.AddressManagerInterface;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.PersonManagerInterface;
import org.uci.opus.college.service.StaffMemberManagerInterface;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.validator.AddressValidator;
import org.uci.opus.college.web.form.AddressForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.ExtendedArrayList;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * @author J.Nooitgedagt
 * Servlet implementation class for Servlet: AddressEditController.
 *
 */
@Controller
@RequestMapping("/college/address.view")
@SessionAttributes({"addressForm"})
public class AddressEditController {

    private static Logger log = LoggerFactory.getLogger(OrganizationalUnitEditController.class);
    private String formView;
    @Autowired private AppConfigManagerInterface appConfigManager;    
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private AddressManagerInterface addressManager;
    @Autowired private StaffMemberManagerInterface staffMemberManager;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired private PersonManagerInterface personManager;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private LookupManagerInterface lookupManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private AddressValidator addressValidator;

    /**
     * @see javax.servlet.http.HttpServlet#HttpServlet()
     */
    public AddressEditController() {
        super();
        this.formView = "college/address/address";
    }

    /**
     * @param model
     * @param request
     * @return
     * @throws ServletRequestBindingException 
     */
    @PreAuthorize("hasRole('READ_STUDENT_ADDRESSES') or principal.personId.toString()  == #request.getParameter('personId')")
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) throws ServletRequestBindingException {

        // declare variables
        Organization organization = null;
        NavigationSettings navigationSettings = null;

        int addressId = 0;

        int institutionId = 0;
        int branchId = 0;
        int organizationalUnitId = 0;

        int personId = 0;

        Address address = null;
        StaffMember staffMember = null;
        Student student = null;
        OrganizationalUnit organizationalUnit = null;
        Study study = null;
        int studyId = 0;
        ExtendedArrayList allAddressTypesForEntity = new ExtendedArrayList();

        HttpSession session = request.getSession(false);        

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        // if adding a new study, destroy any existing one on the session
        opusMethods.removeSessionFormObject("addressForm", session, model, opusMethods.isNewForm(request));

        /* set menu to studies */
        session.setAttribute("menuChoice", "studies");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        /* ADDRESSFORM - fetch or create the form object and fill it with address */
        AddressForm addressForm = (AddressForm) model.get("addressForm");
        if (addressForm == null) {
            addressForm = new AddressForm();
        }

        if (addressForm.getAddress() == null) {
            if (!StringUtil.isNullOrEmpty(request.getParameter("addressId"))) {
                addressId = Integer.parseInt(request.getParameter("addressId"));
            }
            if (!StringUtil.isNullOrEmpty(request.getParameter("from"))) {
                addressForm.setFrom(request.getParameter("from"));
            }

            if (addressId != 0) {
                // EXISTING ADDRESS
                address = addressManager.findAddress(addressId);

                personId = address.getPersonId();
                studyId = address.getStudyId();

                /* fill organizationalUnitId only if the address belongs to an organizational unit
                 * not for a student, study or staffmember
                 */
                if ("organizationalunit".equals(addressForm.getFrom())) {
                    // find organization id's matching with the study
                    if (address.getOrganizationalUnitId() != 0) {
                        organizationalUnitId = address.getOrganizationalUnitId();
                    } else {
                        if (!StringUtil.isNullOrEmpty(request.getParameter("organizationalUnitId"))) {
                            organizationalUnitId = Integer.parseInt(request.getParameter("organizationalUnitId"));
                        } else {
                            organizationalUnitId = ((Integer) session.getAttribute("organizationalUnitId"));
                        }
                        address.setOrganizationalUnitId(organizationalUnitId);
                    }
                }
            } else {
                // NEW ADDRESS
                address = new Address();

                // initially choose the default countryCode
                address.setCountryCode(appConfigManager.getCountryCode());

                if ("staffmember".equals(addressForm.getFrom()) 
                        || "student".equals(addressForm.getFrom())) {
                    personId = Integer.parseInt(request.getParameter("personId"));
                }
                if ("study".equals(addressForm.getFrom())) {
                    studyId = Integer.parseInt(request.getParameter("studyId"));
                }

                // fetch organization from session
                if ("organizationalunit".equals(addressForm.getFrom())) {
                    organizationalUnitId = Integer.parseInt(request.getParameter("organizationalUnitId"));
                    address.setOrganizationalUnitId(organizationalUnitId);
                    address.setAddressTypeCode(OpusConstants.FORMAL_ADDRESS_ORGANIZATIONAL_UNIT);
                }

                if (personId != 0) {
                    address.setPersonId(personId);
                }
                if (studyId != 0) {
                    address.setStudyId(studyId);
                    address.setAddressTypeCode(OpusConstants.FORMAL_ADDRESS_STUDY);
                }
            }
            // put the constructed address in the form:
            addressForm.setAddress(address);
        } else {
            if ("organizationalunit".equals(addressForm.getFrom())) {
                if (addressForm.getAddress().getOrganizationalUnitId() != 0) {
                    organizationalUnitId = addressForm.getAddress().getOrganizationalUnitId();
                } else {
                    organizationalUnitId = Integer.parseInt(request.getParameter("organizationalUnitId"));
                    addressForm.getAddress().setOrganizationalUnitId(organizationalUnitId);
                }
            }
        }
        //address = addressForm.getAddress(); 
        personId = addressForm.getAddress().getPersonId();
        studyId = addressForm.getAddress().getStudyId();
        // fill branch and institution corresponding organizationalUnitId);
        if ("organizationalunit".equals(addressForm.getFrom())) {
            branchId = branchManager.findBranchOfOrganizationalUnit(organizationalUnitId);
            institutionId = institutionManager.findInstitutionOfBranch(branchId);

            /* STUDYFORM.ORGANIZATION - fetch or create the object */
            if (addressForm.getOrganization() != null) {
                organization = addressForm.getOrganization();
            } else {
                organization = new Organization();

                // get the organization values from study:
                organization = opusMethods.fillOrganization(session, request, organization, 
                        organizationalUnitId, branchId, institutionId);
            }
            addressForm.setOrganization(organization);
        }

        /* STUDYFORM.NAVIGATIONSETTINGS - fetch or create the object */
        if (addressForm.getNavigationSettings() != null) {
            navigationSettings = addressForm.getNavigationSettings();
        } else {
            navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
        }
        addressForm.setNavigationSettings(navigationSettings);

        // MoVe - fetch errors & messages:
        if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(
                request, "txtErr"))) {
            addressForm.setTxtErr(addressForm.getTxtErr() + 
                    ServletRequestUtils.getStringParameter(
                            request, "txtErr"));
        }

        if (!StringUtil.isNullOrEmpty(ServletRequestUtils.getStringParameter(
                request, "txtMsg"))) {
            addressForm.setTxtMsg(addressForm.getTxtErr() + 
                    ServletRequestUtils.getStringParameter(
                            request, "txtMsg"));
        }

        if ("organizationalunit".equals(addressForm.getFrom())) {
            // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
            opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                    session, request, organization.getInstitutionTypeCode(),
                    organization.getInstitutionId(), organization.getBranchId(), 
                    organization.getOrganizationalUnitId());
        }

        /* fill lookup-tables with right values */
        // don't remove the request attributes
        request.setAttribute("countryCode", addressForm.getAddress().getCountryCode());
        request.setAttribute("provinceCode", addressForm.getAddress().getProvinceCode());
        request.setAttribute("districtCode", addressForm.getAddress().getDistrictCode());
        request.setAttribute("administrativePostCoce", addressForm.getAddress().getAdministrativePostCode());
        lookupCacher.getAddressLookups(preferredLanguage, request);

        /* get address domain lookups */

        // used to show the link with the name of the organizational unit in the header
        if ("organizationalunit".equals(addressForm.getFrom())) {
            organizationalUnit = organizationalUnitManager
                    .findOrganizationalUnit(organizationalUnitId);
            addressForm.setOrganizationalUnit(organizationalUnit);
        }


        // variables needed to find the correct list of addresstypes
        Map<String, Object> findAddressTypesMap = new HashMap<>();
        findAddressTypesMap.put("preferredLanguage", preferredLanguage);
        findAddressTypesMap.put("tableName", "addressType");

        if (personId != 0) {
            // needed to find the correct list of addresstypes for a staffmember or student
            findAddressTypesMap.put("id", personId);

            if ("staffmember".equals(addressForm.getFrom())) {
                // needed to find the list of addresstypes for the correct entity
                findAddressTypesMap.put("entity", "staffmember");
                // used in crumbs path
                staffMember = staffMemberManager.findStaffMemberByPersonId(
                        addressForm.getAddress().getPersonId());
                addressForm.setStaffMember(staffMember);
            }
            if ("student".equals(addressForm.getFrom())) {
                // needed to find the list of addresstypes for the correct entity
                findAddressTypesMap.put("entity", "student");
                // used in crumbs path
                student = studentManager.findStudentByPersonId(
                        addressForm.getAddress().getPersonId());
                addressForm.setStudent(student);
            }
        }
        if ("organizationalunit".equals(addressForm.getFrom()) && organizationalUnitId != 0) {
            // needed to find the correct list of addresstypes for the correct entity
            findAddressTypesMap.put("entity", "organizationalunit");
            findAddressTypesMap.put("id", organizationalUnitId);

        }
        if ("study".equals(addressForm.getFrom()) && studyId != 0) {
            // used in crumbs path
            study = studyManager.findStudy(studyId);
            addressForm.setStudy(study);
            // needed to find the correct list of addresstypes for the correct entity
            findAddressTypesMap.put("entity", "study");
            findAddressTypesMap.put("id", studyId);

        }
        // create a list of addresstypes to show in the pulldown 
        allAddressTypesForEntity = (ExtendedArrayList) 
                addressManager.findUnboundAddressTypes(findAddressTypesMap);

        // existing address: add the addresstype of this address to the list of addresstypes
        // shown in the pulldown
        if (addressForm.getAddress().getId() != 0) {
            // add adrestype to list of adrestypes
            Lookup addresstype = (Lookup) lookupManager.findLookup(preferredLanguage
                    , addressForm.getAddress().getAddressTypeCode(), "addressType");
            allAddressTypesForEntity.insertLookupByDescription(addresstype);
        }        
        addressForm.setAllAddressTypesForEntity(allAddressTypesForEntity);

        // ADDRESS LOOKUPS FOR COUNTRY, PROVINCE, DISTRICT AND ADMINISTRATIVE POST
        // PLUS THE SELECTED CODES

        // first get codes from the address object
        String countryCode = addressForm.getAddress().getCountryCode();
        String provinceCode = addressForm.getAddress().getProvinceCode();
        String districtCode = addressForm.getAddress().getDistrictCode();

        // lookups: if higher level codes are empty, set lower ones also to empty
        if (StringUtil.isNullOrEmpty(countryCode) || "0".equals(countryCode)) {
            addressForm.getAddress().setProvinceCode("");
            addressForm.getAddress().setDistrictCode("");
            addressForm.getAddress().setAdministrativePostCode("");
            request.setAttribute("allProvinces", null);
            request.setAttribute("allDistricts", null);
            request.setAttribute("allAdministrativePosts", null);
        }
        if (StringUtil.isNullOrEmpty(provinceCode) || "0".equals(provinceCode)) {
            addressForm.getAddress().setDistrictCode("");
            addressForm.getAddress().setAdministrativePostCode("");
            request.setAttribute("allDistricts", null);
            request.setAttribute("allAdministrativePosts", null);
        }
        if (StringUtil.isNullOrEmpty(districtCode) || "0".equals(districtCode)) {
            addressForm.getAddress().setAdministrativePostCode("");
            request.setAttribute("allAdministrativePosts", null);
        }

        model.addAttribute("addressForm", addressForm);        
        return formView;
    }

    /**
     * @param addressForm
     * @param result
     * @param status
     * @param request
     * @return
     */
    @PreAuthorize("hasAnyRole('CREATE_STUDENT_ADDRESSES', 'UPDATE_STUDENT_ADDRESSES') or principal.personId.toString()  == #request.getParameter('personId')")
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
            @ModelAttribute("addressForm") AddressForm addressForm,
            BindingResult result, SessionStatus status, HttpServletRequest request) { 

        Address address = addressForm.getAddress();
        Organization organization = addressForm.getOrganization();
        NavigationSettings navigationSettings = addressForm.getNavigationSettings();

        String submitFormObject = "";

        Address oldAddress = null;
        Address changedAddress = null;
        OrganizationalUnit organizationalUnit = null;

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        if (!StringUtil.isNullOrEmpty(request.getParameter("submitFormObject"))) {
            submitFormObject = request.getParameter("submitFormObject");
        }

        // personId needs to be added to redirects so that the GET can verify PreAuthorize clause
        int personId = address.getPersonId();

        if ("true".equals(submitFormObject)) {

            addressValidator.onBindAndValidate(request, addressForm, result);
            if (result.hasErrors()) {
                /* fill lookup-tables with right values */
                lookupCacher.getAddressLookups(preferredLanguage, request);

                return formView;
            }

            if (address.getId() == 0) {
                oldAddress = new Address();
                log.info("adding address " + address);
                addressManager.addAddress(address);
            } else {
                oldAddress = addressManager.findAddress(address.getId());
                log.info("updating address " + address);
                addressManager.updateAddress(address);
            }

            if ((address.getCountryCode() == null) 
                    || (oldAddress.getCountryCode() != null 
                    && !oldAddress.getCountryCode().equals(address.getCountryCode()))
                    || (address.getProvinceCode() == null)
                    || (oldAddress.getProvinceCode() != null 
                    && !oldAddress.getProvinceCode().equals(address.getProvinceCode()))
                    //	                || (address.getDistrictCode() == null) 
                    //	                	|| (oldAddress.getDistrictCode() != null 
                    //	                        && !oldAddress.getDistrictCode().equals(address.getDistrictCode()))
                    //	                || (address.getAdministrativePostCode() == null) 
                    //	                	|| (oldAddress.getAdministrativePostCode() != null) 
                    //	                        && !oldAddress.getAdministrativePostCode()
                    //	                                .equals(address.getAdministrativePostCode()))
                    || (address.getCity() == null || "".equals(address.getCity()))
                    ) {

                if (personId != 0) {
                    changedAddress = addressManager.findAddressByPersonId(
                            address.getAddressTypeCode(), personId);
                    // STAFFMEMBER
                    if (personManager.isStaffMember(personId)) {

                        //	                    StaffMember staffMember = staffMemberManager.findStaffMemberByPersonId(
                        //	                                                                    preferredLanguage, personId);

                        return "redirect:/college/address.view?newForm=true&tab=" + navigationSettings.getTab()
                                + "&panel=" + navigationSettings.getPanel()  
                                + "&from=staffmember&personId=" + personId
                                + "&addressId=" + changedAddress.getId()
                                + "&txtErr=" + addressForm.getTxtErr()
                                + "&txtMsg=" + addressForm.getTxtMsg()
                                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
                    } 
                    // STUDENT
                    if (personManager.isStudent(personId)) {
                        //	                    Student student = studentManager.findStudentByPersonId(
                        //	                                            preferredLanguage, personId);

                        return "redirect:/college/address.view?newForm=true&tab=" + navigationSettings.getTab()
                                + "&panel=" + navigationSettings.getPanel()  
                                + "&from=student&personId=" + personId
                                + "&addressId=" + changedAddress.getId()
                                + "&txtErr=" + addressForm.getTxtErr()
                                + "&txtMsg=" + addressForm.getTxtMsg()
                                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
                    }
                }

                // STUDY
                if (address.getStudyId() != 0) {

                    /* put the updated study back on the request as 'command' */
                    int studyId = address.getStudyId();
                    changedAddress = addressManager.findAddressByStudyId(
                            address.getAddressTypeCode(), studyId);

                    //	                Study study = studyManager.findStudy(studyId);

                    return "redirect:/college/address.view?newForm=true&tab=" + navigationSettings.getTab()
                            + "&panel=" + navigationSettings.getPanel() 
                            + "&from=study&studyId=" + studyId
                            + "&addressId=" + changedAddress.getId()
                            + "&txtErr=" + addressForm.getTxtErr()
                            + "&txtMsg=" + addressForm.getTxtMsg()
                            + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
                }

                // ORGANIZATIONAL UNIT
                if (address.getOrganizationalUnitId() != 0) {
                    /* put the updated organizationalUnit back on the request as 'command' */
                    int organizationalUnitId = address.getOrganizationalUnitId();
                    changedAddress = addressManager.findAddressByOrganizationalUnitId(
                            address.getAddressTypeCode(), organizationalUnitId);
                    organizationalUnit = organizationalUnitManager.findOrganizationalUnit(
                            organizationalUnitId);

                    return "redirect:/college/address.view?newForm=true&tab=" + navigationSettings.getTab()
                            + "&panel=" + navigationSettings.getPanel() 
                            + "&from=organizationalunit&organizationalUnitId=" 
                            + organizationalUnit.getId()
                            +  "&addressId=" + changedAddress.getId()
                            + "&txtErr=" + addressForm.getTxtErr()
                            + "&txtMsg=" + addressForm.getTxtMsg()
                            + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
                }

            } else {

                // ready, redirect to correct entity
                status.setComplete();

                if (personId != 0) {
                    // STAFFMEMBER
                    if (personManager.isStaffMember(personId)) {
                        StaffMember staffMember = staffMemberManager.findStaffMemberByPersonId(
                                personId);
                        return "redirect:/college/staffmember.view?newForm=true&tab=" + navigationSettings.getTab()
                                + "&panel=" + navigationSettings.getPanel() 
                                + "&from=staffmember"
                                + "&staffMemberId=" + staffMember.getStaffMemberId()
                                + "&txtErr=" + addressForm.getTxtErr()
                                + "&txtMsg=" + addressForm.getTxtMsg()
                                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();

                    } 
                    // STUDENT
                    if (personManager.isStudent(personId)) {
                        Student student = studentManager.findStudentByPersonId(personId);

                        return "redirect:/college/student-addresses.view?newForm=true&tab=" + navigationSettings.getTab()
                                + "&panel=" + navigationSettings.getPanel()  
                                + "&from=student&studentId=" + student.getStudentId()
                                + "&txtErr=" + addressForm.getTxtErr()
                                + "&txtMsg=" + addressForm.getTxtMsg()
                                + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
                    }
                }
                // STUDY
                if (address.getStudyId() != 0) {
                    return "redirect:/college/study.view?newForm=true&tab=" + navigationSettings.getTab()
                            + "&panel=" + navigationSettings.getPanel()  
                            + "&from=study&studyId=" + address.getStudyId()
                            + "&txtErr=" + addressForm.getTxtErr()
                            + "&txtMsg=" + addressForm.getTxtMsg()
                            + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
                }
                // ORGANIZATIONAL UNIT
                if (address.getOrganizationalUnitId() != 0) {
                    return "redirect:/college/organizationalunit.view?newForm=true&tab=" + navigationSettings.getTab() 
                            + "&panel=" + navigationSettings.getPanel() 
                            + "&from=organizationalunit"
                            + "&organizationalUnitId=" + address.getOrganizationalUnitId()
                            + "&educationTypeCode=" + organization.getInstitutionTypeCode()
                            + "&txtErr=" + addressForm.getTxtErr()
                            + "&txtMsg=" + addressForm.getTxtMsg()
                            + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
                }

            }
        } else {
            //status.setComplete();

            return "redirect:address.view?personId=" + personId;
        }
        // catch loose ends
        //status.setComplete();
        return formView;
    }

}
