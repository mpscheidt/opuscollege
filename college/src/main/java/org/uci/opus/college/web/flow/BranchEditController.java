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
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.context.MessageSource;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.BranchAcademicYearTimeUnit;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.persistence.AcademicYearMapper;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.validator.BranchValidator;
import org.uci.opus.college.web.form.BranchForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/branch.view")
@SessionAttributes({ BranchEditController.BRANCH_FORM })
public class BranchEditController {

    public static final String BRANCH_FORM = "branchForm";

    private static Logger log = LoggerFactory.getLogger(BranchEditController.class);

    private final String formView = "college/organization/branch";

    @Autowired
    private SecurityChecker securityChecker;
    @Autowired
    private InstitutionManagerInterface institutionManager;
    @Autowired
    private AcademicYearMapper academicYearDao;
    @Autowired
    private BranchManagerInterface branchManager;
    @Autowired
    private BranchValidator branchValidator;
    @Autowired
    private LookupManagerInterface lookupManager;
    @Autowired
    private MessageSource messageSource;
    @Autowired
    private OpusMethods opusMethods;

    /**
     * Adds a property editor for dates to the binder.
     */
    @InitBinder
    public void initBinder(HttpServletRequest request, ServletRequestDataBinder binder) {
        /* custom date editor */
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    @PreAuthorize("hasRole('READ_BRANCHES')")
    @RequestMapping(method = RequestMethod.GET)
    public String setUpForm(HttpServletRequest request, ModelMap model) {

        // declare variables
        HttpSession session = request.getSession(false);
        Branch branch = null;

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(BRANCH_FORM, session, model, opusMethods.isNewForm(request));

        /* set menu to institutions */
        session.setAttribute("menuChoice", "institutions");

        NavigationSettings navigationSettings;
        String institutionTypeCode;

        BranchForm branchForm = (BranchForm) model.get(BRANCH_FORM);
        if (branchForm == null) {
            branchForm = new BranchForm();
            model.put(BRANCH_FORM, branchForm);

            navigationSettings = new NavigationSettings();
            branchForm.setNavigationSettings(navigationSettings);

            // GET THE BRANCH OR CREATE A NEW ONE

            // get the BranchId if it exists
            int branchId = ServletUtil.getIntParam(request, "branchId", 0);

            if (branchId != 0) {
                // EXISTING BRANCH
                branch = branchManager.findBranch(branchId);

                // result visibility
                Map<String, Object> baMap = new HashMap<>();
                baMap.put("branchId", branchId);
                List<BranchAcademicYearTimeUnit> allBranchAcademicYearTimeUnits = branchManager.findBranchAcademicYearTimeUnits(baMap);
                branchForm.setAllBranchAcademicYearTimeUnits(allBranchAcademicYearTimeUnits);

                List<AcademicYear> allAcademicYears = academicYearDao.findAllAcademicYears();
                branchForm.setIdToAcademicYearMap(new IdToAcademicYearMap(allAcademicYears));

                String preferredLanguage = OpusMethods.getPreferredLanguage(request);
                branchForm.setCodeToTimeUnitMap(lookupManager.getCodeToTimeUnitMap(preferredLanguage));

                Institution institution = institutionManager.findInstitution(branch.getInstitutionId());
                institutionTypeCode = institution.getInstitutionTypeCode();

            } else {
                // NEW BRANCH
                branch = new Branch();
                branch.setInstitutionId(OpusMethods.getInstitutionId(session, request));
                /* generate branchCode */
                Double tmpDouble = Math.random();
                Integer tmpInteger = tmpDouble.intValue();
                String strRandomCode = tmpInteger.toString();
                String branchCode = StringUtil.createUniqueCode("B", strRandomCode);
                branch.setBranchCode(branchCode);
                branch.setActive("Y");

                // needed to find the correct list of institutions
                institutionTypeCode = request.getParameter("institutionTypeCode");
            }
            branchForm.setBranch(branch);

            // get a list of all institutions of the correct educationType
            List<Institution> allInstitutions;
            Map<String, Object> map = new HashMap<>();
            map.put("institutionTypeCode", institutionTypeCode != null ? institutionTypeCode : OpusConstants.INSTITUTION_TYPE_DEFAULT);
            allInstitutions = institutionManager.findInstitutions(map);
            branchForm.setAllInstitutions(allInstitutions);

        } else {
            navigationSettings = branchForm.getNavigationSettings();
        }
        opusMethods.fillNavigationSettings(request, navigationSettings, null);

        return formView;
    }

//    @Transactional
    @PreAuthorize("hasAnyRole('CREATE_BRANCHES','UPDATE_BRANCHES')")
    @RequestMapping(method = RequestMethod.POST)
    public String onSubmit(HttpServletRequest request, @ModelAttribute(BRANCH_FORM) BranchForm branchForm, BindingResult result,
            ModelMap model) {

        Branch branch = branchForm.getBranch();
        result.pushNestedPath("branch");
        branchValidator.validate(branch, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            return formView;
        }

        HttpSession session = request.getSession(false);

        String showBranchError = "";

        // if empty, create unique branchCode
        if (StringUtil.isNullOrEmpty(branch.getBranchCode(), true)) {
            Double tmpDouble = Math.random();
            Integer tmpInteger = tmpDouble.intValue();
            String strRandomCode = tmpInteger.toString();
            String branchCode = StringUtil.createUniqueCode("B", strRandomCode);
            branch.setBranchCode(branchCode);
        }
        // NEW UNIT
        if (branch.getId() == 0) {

            if (branch.getInstitutionId() == 0) {
                int institutionId = OpusMethods.getInstitutionId(session, request);
                branch.setInstitutionId(institutionId);
            }
            /* test if the combination already exists */
            Map<String, Object> findBranchMap = new HashMap<>();
            findBranchMap.put("institutionId", branch.getInstitutionId());
            findBranchMap.put("branchDescription", branch.getBranchDescription());
            findBranchMap.put("branchCode", branch.getBranchCode());
            if (branchManager.findBranchByParams(findBranchMap) != null) {
                Locale currentLoc = RequestContextUtils.getLocale(request);

                showBranchError = branch.getBranchDescription() + ". "
                        + messageSource.getMessage("jsp.error.branch.edit", null, currentLoc)
                        + messageSource.getMessage("jsp.error.general.alreadyexists", null, currentLoc);
            } else {
                // add the new branch
                branchManager.addBranch(branch);
            }

            // UPDATE BRANCH
        } else {

            // update the branch
            branchManager.updateBranch(branch);
        }

        return "redirect:/college/branches.view?newForm=true" + "&institutionId=" + branch.getInstitutionId() + "&showBranchError="
                + showBranchError + "&currentPageNumber=" + branchForm.getNavigationSettings().getCurrentPageNumber();
    }

//    @Transactional
    @PreAuthorize("hasRole('DELETE_STUDENT_ADDRESSES')")
    @RequestMapping(method = RequestMethod.GET, params = "delete=branchAcademicYearTimeUnit")
    public String deleteBranchAcademicYearTimeUnit(HttpServletRequest request,
            @RequestParam("branchAcademicYearTimeUnitId") int branchAcademicYearTimeUnitId,
            @ModelAttribute(BRANCH_FORM) BranchForm branchForm, BindingResult result, ModelMap model) {

        BranchAcademicYearTimeUnit branchAcademicYearTimeUnit = branchManager
                .findBranchAcademicYearTimeUnitById(branchAcademicYearTimeUnitId);
        if (branchAcademicYearTimeUnit == null) {
            return formView;
        }

        int branchId = branchAcademicYearTimeUnit.getBranchId();

        branchManager.deleteBranchAcademicYearTimeUnit(branchAcademicYearTimeUnitId);

        return "redirect:/college/branch.view?newForm=true" + "&branchId=" + branchId + "&tab=1" + "&currentPageNumber="
                + branchForm.getNavigationSettings().getCurrentPageNumber();

    }

}
