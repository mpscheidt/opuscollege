/*******************************************************************************
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
 ******************************************************************************/
package org.uci.opus.fee.web.flow;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
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
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.fee.util.FeeLookupCacher;
import org.uci.opus.fee.validators.FeeAcademicYearValidator;
import org.uci.opus.fee.web.form.FeeAcademicYearForm;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;


@Controller
@SessionAttributes({"feeAcademicYearForm"})
public class FeeAcademicYearEditController  {

    private static Logger log = LoggerFactory.getLogger(FeeAcademicYearEditController.class);
    
    private String formView;
    
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private FeeLookupCacher feeLookupCacher;
    @Autowired private FeeManagerInterface feeManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private LookupManagerInterface lookupManager;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private AcademicYearManagerInterface academicYearManager;
//    @Autowired private FeeServiceExtensions feeServiceExtensions;
    @Autowired private FeeAcademicYearValidator feeAcademicYearValidator; 
    
    public FeeAcademicYearEditController() {
        super();
        
        this.formView = "fee/fee/feeAcademicYear";
    }

    /**
     * Adds a property editor for dates to the binder.
     */
    @InitBinder
    protected void initBinder(HttpServletRequest request, ServletRequestDataBinder binder)
    throws Exception {
        /* custom date editor */
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }
    
    @RequestMapping(value="/fee/feeAcademicYear.view", method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) 
            throws Exception {
    
    	FeeAcademicYearForm feeAcademicYearForm = null;
         
         NavigationSettings navigationSettings = null;
         
         HttpSession session = request.getSession(false);
         
         /* perform session-check. If wrong, this throws an Exception towards ErrorController */
         securityChecker.checkSessionValid(session);
         
         // if adding a new feeAcademicYearForm, destroy any existing one on the session
         opusMethods.removeSessionFormObject("feeAcademicYearForm", session, opusMethods.isNewForm(request));

         /* set menu to fee */
         session.setAttribute("menuChoice", "fee");

//         ServletUtil.getIntValueSetOnSession(session, request, "branchId", OpusMethods.getBranchId(session, request));
         int feeId = ServletRequestUtils.getIntParameter(request, "feeId", 0); 
         Fee fee;
         
         String preferredLanguage = OpusMethods.getPreferredLanguage(request);

         /* FeeAcademicYearForm - fetch or create the form object and fill it with secondarySchool */
         if ((FeeAcademicYearForm) session.getAttribute("feeAcademicYearForm") != null) {
             feeAcademicYearForm = (FeeAcademicYearForm) session.getAttribute("feeAcademicYearForm");
         } else {
             feeAcademicYearForm = new FeeAcademicYearForm();
         }

         if(feeId != 0) {
        	 
        	 fee = feeManager.findFee(feeId);
        	 
        	 Map<String, Object> findDeadlinesMap = new HashMap<String, Object>();
        	 findDeadlinesMap.put("feeId", feeId);
        	 findDeadlinesMap.put("lang", preferredLanguage);
        	 
        	 feeAcademicYearForm.setFeeDeadlines(feeManager.findFeeDeadlinesAsMaps(findDeadlinesMap));
        	 
         } else {
        	 
        	 fee = new Fee();
        	// fee.setBranchId(branchId);
         }
         
         feeAcademicYearForm.setFee(fee);
         feeAcademicYearForm.setFeeCategories(feeLookupCacher.getFeeCategoriesWithoutBBFwdAndCancellation(preferredLanguage));
         feeAcademicYearForm.setAllAcademicYears(academicYearManager.findAllAcademicYears());
         feeAcademicYearForm.setAllStudyIntensities(lookupCacher.getAllStudyIntensities(preferredLanguage));
         feeAcademicYearForm.setAllStudyForms(lookupCacher.getAllStudyForms(preferredLanguage));
         feeAcademicYearForm.setAllStudyTimes(lookupCacher.getAllStudyTimes(preferredLanguage));
         feeAcademicYearForm.setAllNationalityGroups(lookupCacher.getAllNationalityGroups(preferredLanguage));
         feeAcademicYearForm.setAllEducationAreas(lookupCacher.getAllEducationAreas(preferredLanguage));
         feeAcademicYearForm.setAllEducationLevels(lookupCacher.getAllEducationLevels(preferredLanguage));
         
         List<? extends Lookup> allFeeUnits = feeLookupCacher.getAllFeeUnits(preferredLanguage);
         feeAcademicYearForm.setAllFeeUnits(allFeeUnits);
         
         int academicYearId = fee.getAcademicYearId();
         
         if(academicYearId != 0) {
         	feeAcademicYearForm.setAcademicYear(academicYearManager.findAcademicYear(academicYearId));
         }
                  
//           feeAcademicYearForm.setBranch(branchManager.findBranch(branchId));
         
         /* FeeAcademicYearForm.NAVIGATIONSETTINGS - fetch or create the object */
         if (feeAcademicYearForm.getNavigationSettings() != null) {
        	 
         	navigationSettings = feeAcademicYearForm.getNavigationSettings();
         	
         } else {
        	 
         	navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
         }
         
         feeAcademicYearForm.setNavigationSettings(navigationSettings);
         
         model.addAttribute("currentDate", new Date());
         model.addAttribute("feeAcademicYearForm", feeAcademicYearForm);        
         
    	
    	return formView;   	
    }
    
	@RequestMapping(value = "/fee/feeAcademicYear.view", method = RequestMethod.POST)
	public String processSubmit(
			@ModelAttribute("feeAcademicYearForm") FeeAcademicYearForm feeAcademicYearForm,
			BindingResult result, SessionStatus status,
			HttpServletRequest request) {

		HttpSession session = request.getSession();
        securityChecker.checkSessionValid(session);
		
		NavigationSettings navigationSettings = feeAcademicYearForm
				.getNavigationSettings();

		Fee fee = feeAcademicYearForm.getFee();

		result.pushNestedPath("fee");

		feeAcademicYearValidator.validate(fee, result);

		result.popNestedPath();

		if (result.hasErrors()) {

			return formView;

		} else {
			
			fee.setWriteWho(opusMethods.getWriteWho(request));

			if (fee.getId() == 0) {
				feeManager.addFee(fee);
			} else {
				feeManager.updateFee(fee);
			}

			status.setComplete();
		}

		return "redirect:/fee/feeAcademicYear.view?newForm=true&feeId="
				+ fee.getId() + "&currentPageNumber="
				+ navigationSettings.getCurrentPageNumber();
	}
	
	
	@RequestMapping(value = "/fee/feeAcademicYearDeadline_delete.view", method = RequestMethod.GET)
	public String deleteFeeDeadline(@RequestParam("feeDeadlineId") int feeDeadlineId
			 								, @RequestParam("feeId") int feeId
//			 								, @RequestParam("branchId") int branchId
			 								, ModelMap model, HttpServletRequest request){

	    HttpSession session = request.getSession(false);

	    /* perform session-check. If wrong, this throws an Exception towards ErrorController */
	    securityChecker.checkSessionValid(session);

	    FeeAcademicYearForm feeAcademicYearForm = (FeeAcademicYearForm) session.getAttribute("feeAcademicYearForm");

        NavigationSettings navigationSettings = feeAcademicYearForm.getNavigationSettings();
        
        feeManager.deleteFeeDeadline(feeDeadlineId, opusMethods.getWriteWho(request));
        
//	     model.addAttribute("feeAcademicYearsForm", feeAcademicYearsForm);

        return "redirect:/fee/feeAcademicYear.view?newForm=true" 
        + "&feeId=" + feeId 
//        + "&branchId=" + branchId
		+ "&currentPageNumber="	+ navigationSettings.getCurrentPageNumber()
		+ "&tab=1"
		+ "&panel=0"
		;

	 }


}
