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
 * The Original Code is Opus-College fee module code.
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

package org.uci.opus.fee.web.flow;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

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
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.fee.util.FeeLookupCacher;
import org.uci.opus.fee.web.form.FeeBranchForm;
import org.uci.opus.fee.web.form.FeeBranchesForm;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.lookup.LookupUtil;

/**
 * Servlet implementation class for Servlet: ContractEditController.
 * 
 *     http://www.mkyong.com/spring-mvc/spring-mvc-form-handling-annotation-example/
 *     http://levelup.lishman.com/spring/form-processing/controller.php
 * 
 */
@Controller
@RequestMapping("/fee/feebranches.view")
@SessionAttributes({"feeBranchesForm"})
public class FeeBranchesController {
    
    private static Logger log = LoggerFactory.getLogger(FeeBranchesController.class);     
    
    private String formView;

    @Autowired private AcademicYearManagerInterface academicYearManager;
//    @Autowired private BranchManager branchManager;
    @Autowired private FeeLookupCacher feeLookupCacher;
    @Autowired private FeeManagerInterface feeManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private LookupUtil lookupUtil;
    @Autowired private OpusMethods opusMethods;
    @Autowired private SecurityChecker securityChecker;
     
    public FeeBranchesController() {
        super();
        this.formView = "fee/fee/feebranches";
    }

    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) 
            throws Exception {
               
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject("feeBranchesForm", session, model, opusMethods.isNewForm(request));
        
        /* set menu to subjects */
        session.setAttribute("menuChoice", "fees");

        if (log.isDebugEnabled()) {
            log.debug("FeeBranchesController.setUpForm entered...");  
        }
        
        FeeBranchesForm feeBranchesForm = new FeeBranchesForm();
        NavigationSettings navigationSettings = new NavigationSettings();
//        Branch branch = null;
//        int branchId = 0;
 

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

//        if (!StringUtil.isNullOrEmpty(request.getParameter("branchId"))) {
//            branchId = Integer.parseInt(request.getParameter("branchId"));
//        }
//        
//        if (branchId != 0) {
//            branch = branchManager.findBranch(branchId);
//            feeBranchForm.setBranch(branch);
//        }

        /* STUDYFORM.NAVIGATIONSETTINGS - fetch or create the object */
        opusMethods.fillNavigationSettings(request, navigationSettings, null);
        feeBranchesForm.setNavigationSettings(navigationSettings);      
        
        
//        List < ? extends Fee > allFeesForBranch = null;
//        allFeesForBranch= feeManager.findFeesForBranch(branch.getId());
//        feeBranchForm.setAllFeesForBranch(allFeesForBranch);
        
        // get all fees based on areas of education (science/art/medicine based)
        List < ? extends Fee > allFeesForEducationAreas = null;
        HashMap<String, Object> map = new HashMap<String, Object>();
        allFeesForEducationAreas= feeManager.findFeesForEducationAreas(map);
        feeBranchesForm.setAllFeesForEducationAreas(allFeesForEducationAreas);
        
        List <AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
        feeBranchesForm.setAllAcademicYears(allAcademicYears);

        List < ? extends Lookup > allFeeCategories = feeLookupCacher.getAllFeeCategories(preferredLanguage);
//        feeBranchForm.setAllFeeCategories(allFeeCategories);
        feeBranchesForm.setCodeToFeeCategoryMap(new CodeToLookupMap(allFeeCategories));

        List<Lookup> allStudyIntensities = lookupCacher.getAllStudyIntensities(preferredLanguage);
        allStudyIntensities = new ArrayList<Lookup>(allStudyIntensities);   // make it modifyable
        allStudyIntensities.add(lookupUtil.getLookupCalledAny(request));
        feeBranchesForm.setCodeToStudyIntensityMap(new CodeToLookupMap(allStudyIntensities));

        List < ? extends Lookup > allFeeUnits = feeLookupCacher.getAllFeeUnits(preferredLanguage);
        feeBranchesForm.setCodeToFeeUnitMap(new CodeToLookupMap(allFeeUnits));
        
        List <Lookup > allStudyTimes = lookupCacher.getAllStudyTimes(preferredLanguage);
        allStudyTimes = new ArrayList<Lookup>(allStudyTimes);   // make it modifyable
        allStudyTimes.add(lookupUtil.getLookupCalledAny(request));
        feeBranchesForm.setCodeToStudyTimeMap(new CodeToLookupMap(allStudyTimes));
        
        List <Lookup > allStudyForms = lookupCacher.getAllStudyForms(preferredLanguage);
        allStudyForms = new ArrayList<Lookup>(allStudyForms);   // make it modifyable
        allStudyForms.add(lookupUtil.getLookupCalledAny(request));
        feeBranchesForm.setCodeToStudyFormMap(new CodeToLookupMap(allStudyForms));

//        List < IAccommodationFee > allAccommodationFees = new ArrayList<IAccommodationFee>();
//        log.info("feeServiceExtensions.getAccommodationFeeFinders()" 
//                + feeServiceExtensions.getAccommodationFeeFinders());
//        if (feeServiceExtensions.getAccommodationFeeFinders() != null) {
//            Map<String, Object> params = new HashMap<String, Object>();
//            params.put("active", "Y");
//            for (AccommodationFeeFinder accommodationFeeFinder : feeServiceExtensions.getAccommodationFeeFinders()) {
//                List fees = accommodationFeeFinder.findAccommodationFeesByParams(params);
//                if (fees != null) {
//                    allAccommodationFees.addAll(fees);
//                }
//            }
//        }
//        feeBranchForm.setAllAccommodationFees(allAccommodationFees);
        
        model.addAttribute("currentDate", new Date());
        model.addAttribute("feeBranchesForm", feeBranchesForm);        
        
        return formView;
    }

    // never entered
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
            @ModelAttribute("feeBranchForm") FeeBranchForm feeBranchForm,
            BindingResult result, SessionStatus status, HttpServletRequest request) {

            return formView;
    }   
}
