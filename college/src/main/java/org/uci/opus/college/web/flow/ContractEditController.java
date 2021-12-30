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
import java.util.Date;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.college.domain.Contract;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.persistence.StaffMemberMapper;
import org.uci.opus.college.service.ContractManagerInterface;
import org.uci.opus.college.validator.ContractValidator;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.person.ContractForm;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/contract")
@SessionAttributes({ ContractEditController.FORM_OBJECT })
public class ContractEditController {

    public static final String FORM_OBJECT = "contractForm";
    private static final String FORM_VIEW = "college/person/contract";

    private static Logger log = LoggerFactory.getLogger(ContractEditController.class);

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private ContractManagerInterface contractManager;

    @Autowired
    private LookupCacher lookupCacher;

    @Autowired
    private StaffMemberMapper staffMemberMapper;

    private ContractValidator contractValidator = new ContractValidator();

    /**
     * Adds a property editor for dates to the binder.
     */
    @InitBinder
    public void initBinder(ServletRequestDataBinder binder) {
        /* custom date editor */
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    /**
     * Creates a form backing object. If the request parameter "staff_member_ID" is set, the
     * specified staff member is read. Otherwise a new one is created.
     */
    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {

        HttpSession session = request.getSession(false);
        
        ContractForm form = new ContractForm();
        model.put(FORM_OBJECT, form);
        
        form.setNavigationSettings(opusMethods.createAndFillNavigationSettings(request));

        int contractId = ServletUtil.getIntParam(request, "contractId", 0);

        /* with each call the preferred language may be changed */
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        form.setAllContractTypes(lookupCacher.getAllContractTypes());
        form.setAllContractDurations(lookupCacher.getAllContractDurations());

        int staffMemberId;
        
        Contract contract;
        if (contractId != 0) {
            contract = contractManager.findContract(contractId);
            staffMemberId = contract.getStaffMemberId();
        } else {
            contract = new Contract();
            
            staffMemberId = Integer.parseInt(request.getParameter("staffMemberId"));
            contract.setStaffMemberId(staffMemberId);
            OrganizationalUnit organizationalUnit = (OrganizationalUnit) session.getAttribute("organizationalUnit");
            String contractCode = StringUtil.createUniqueCode("C", "" + organizationalUnit.getId());
            contract.setContractCode(contractCode);
        }
        form.setContract(contract);

        StaffMember staffMember = staffMemberMapper.findStaffMember(preferredLanguage, staffMemberId);
        form.setStaffMember(staffMember);

        return FORM_VIEW;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request, @ModelAttribute(FORM_OBJECT) ContractForm form, BindingResult result) {

        Contract contract = form.getContract();
        
        result.pushNestedPath("contract");
        contractValidator.validate(contract, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            return FORM_VIEW;
        }

        HttpSession session = request.getSession(false);

        int staffMemberId = contract.getStaffMemberId();
        String showContractError = "";

        /* if contractCode is made empty, give default values */
        if (StringUtil.isNullOrEmpty(contract.getContractCode())) {
            OrganizationalUnit organizationalUnit = (OrganizationalUnit) session.getAttribute("organizationalUnit");
            String contractCode = StringUtil.createUniqueCode("C", "" + organizationalUnit.getId());
            contract.setContractCode(contractCode);
        }

        /* new contract - test if the combination already exists */
        if (contract.getId() == 0) {
            Map<String, Object> findContractMap = new HashMap<String, Object>();
            findContractMap.put("contractCode", contract.getContractCode());
            findContractMap.put("contractTypeCode", contract.getContractTypeCode());
            findContractMap.put("contractDurationCode", contract.getContractDurationCode());
            findContractMap.put("contractStartDate", contract.getContractStartDate());
            if (contractManager.findContractByParams(findContractMap) != null) {

                result.rejectValue("contractCode", "jsp.error.general.alreadyexists");
                return FORM_VIEW;
            }

            log.info("Adding " + contract);
            contractManager.addContract(contract);

        } else {

            /* update contract */
            log.info("Updating " + contract);
            contractManager.updateContract(contract);
        }

        NavigationSettings nav = form.getNavigationSettings();
        return "redirect:/college/staffmember.view?newForm=true&tab=" + nav.getTab() + "&panel=" + nav.getPanel() + "&staffMemberId=" + staffMemberId + "&showContractError="
                + showContractError + "&currentPageNumber=" + nav.getCurrentPageNumber();
    }

}
