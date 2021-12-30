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

import java.util.Date;

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
import org.uci.opus.college.domain.AdmissionRegistrationConfig;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.web.form.AdmissionRegistrationConfigForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ServletUtil;

@Controller
@RequestMapping("/college/admissionregistrationconfig.view")
@SessionAttributes("admissionRegistrationConfigForm")
public class AdmissionRegistrationConfigController {

    private static final String VIEW_NAME = "college/organization/admissionRegistrationConfig";
    private static Logger log = LoggerFactory.getLogger(AdmissionRegistrationConfigController.class);
    @Autowired private OrganizationalUnitManagerInterface organizationalUnitManager;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private OpusMethods opusMethods;

    @RequestMapping(method=RequestMethod.GET)
    public String edit(HttpServletRequest request, ModelMap model) {

        int admissionRegistrationConfigId = ServletUtil.getIntParam(request, "admissionRegistrationConfigId", 0);
//        ServletUtil.getParamSetAttrAsInt(request, "currentPageNumber", 0);
//        ServletUtil.getParamSetAttrAsInt(request, "tab", 0);
//        ServletUtil.getParamSetAttrAsInt(request, "panel", 0);
        
        int organizationalUnitId;
        AdmissionRegistrationConfig admissionRegistrationConfig;
        if (admissionRegistrationConfigId == 0) {
            // new
        	admissionRegistrationConfig = new AdmissionRegistrationConfig();
            organizationalUnitId = ServletUtil.getIntParam(request, "organizationalUnitId", 0);
            admissionRegistrationConfig.setOrganizationalUnitId(organizationalUnitId);
        } else {
            // edit existing
        	admissionRegistrationConfig = organizationalUnitManager.findAdmissionRegistrationConfig(admissionRegistrationConfigId);
            organizationalUnitId = admissionRegistrationConfig.getOrganizationalUnitId();
        }
        
        AdmissionRegistrationConfigForm form = new AdmissionRegistrationConfigForm();
        model.addAttribute("admissionRegistrationConfigForm", form);
        
        form.setNavigationSettings(opusMethods.createAndFillNavigationSettings(request));

        form.setAdmissionRegistrationConfig(admissionRegistrationConfig);
        form.setOrganizationalUnit(organizationalUnitManager.findOrganizationalUnit(organizationalUnitId));
        form.setAllAcademicYears(academicYearManager.findAllAcademicYears());
        
        return VIEW_NAME; // point to the jsp file
    }

    @RequestMapping(method=RequestMethod.POST)
    public String submit(
            HttpServletRequest request,
            SessionStatus sessionStatus,
            @ModelAttribute("admissionRegistrationConfigForm") AdmissionRegistrationConfigForm form,
            BindingResult result,
            ModelMap model) {

        // validate
        AdmissionRegistrationConfig admissionRegistrationConfig = form.getAdmissionRegistrationConfig();
        AdmissionRegistrationConfig existingRecord = organizationalUnitManager.findAdmissionRegistrationConfig(admissionRegistrationConfig.getOrganizationalUnitId(), admissionRegistrationConfig.getAcademicYearId(), false);
        if (existingRecord != null && existingRecord.getId() != form.getAdmissionRegistrationConfig().getId()) {
            result.rejectValue("admissionRegistrationConfig.academicYearId", "sql.error.duplicatekey");
        }
        
        if (admissionRegistrationConfig.getAcademicYearId() == 0) {
            result.rejectValue("admissionRegistrationConfig.academicYearId", "jsp.error.academicyear.blank");
        }
        Date startOfRegistration = admissionRegistrationConfig.getStartOfRegistration();
        if (startOfRegistration == null) {
            result.rejectValue("admissionRegistrationConfig.startOfRegistration", "jsp.error.organizationalunit.startOfRegistration");
        }
        Date endOfRegistration = admissionRegistrationConfig.getEndOfRegistration();
        if (endOfRegistration == null) {
            result.rejectValue("admissionRegistrationConfig.endOfRegistration", "jsp.error.organizationalunit.endOfRegistration");
        }
        if (startOfRegistration != null && endOfRegistration != null && startOfRegistration.compareTo(endOfRegistration) > 0) {
            result.rejectValue("admissionRegistrationConfig.endOfRegistration", "jsp.error.organizationalunit.endOfRegistrationBeforeStart");
        }
        // do not validate admissiondates and refundperiod dates: modules might not be there
        
        if (result.hasErrors()) {
            return VIEW_NAME;
        }

        // store
        HttpSession session = request.getSession(false);
        opusMethods.setWriteWhoWhen(admissionRegistrationConfig, session);
        log.info("updating or adding " + admissionRegistrationConfig);
        organizationalUnitManager.updateOrAddAdmissionRegistrationConfig(admissionRegistrationConfig);
        sessionStatus.setComplete();
        
        NavigationSettings nav = form.getNavigationSettings();
        return "redirect:/college/organizationalunit.view?newForm=true&tab=" + nav.getTab() 
                + "&panel=" + nav.getPanel()
                + "&organizationalUnitId=" + admissionRegistrationConfig.getOrganizationalUnitId()
                + "&currentPageNumber=" + nav.getCurrentPageNumber()
                ;
    }

}
