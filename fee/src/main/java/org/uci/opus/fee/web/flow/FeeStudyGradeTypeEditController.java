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

import java.math.BigDecimal;
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
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.fee.util.FeeLookupCacher;
import org.uci.opus.fee.validators.FeeStudyGradeTypeValidator;
import org.uci.opus.fee.web.form.FeeStudyGradeTypeForm;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

@Controller
@SessionAttributes({"feeStudyGradeTypeForm"})
public class FeeStudyGradeTypeEditController {

    private static Logger log = LoggerFactory.getLogger(FeeStudyGradeTypeEditController.class);

    private String formView;

    @Autowired private SecurityChecker securityChecker;    
    @Autowired private FeeManagerInterface feeManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private LookupManagerInterface lookupManager;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private FeeLookupCacher feeLookupCacher;
    @Autowired private FeeStudyGradeTypeValidator feeStudyGradeTypeValidator;
    //    @Autowired private FeeUtil feeUtil;

    public FeeStudyGradeTypeEditController() {
        super();
        this.formView = "fee/fee/feeStudyGradeType";
    }

    /**
     * Adds a property editor for dates to the binder.
     */
    @InitBinder
    public void initBinder(WebDataBinder binder) {

        /* custom date editor */
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        dateFormat.setLenient(false);
        //CustomDateEditor(DateFormat dateFormat, boolean allowEmpty);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(dateFormat, true));
    }


    /**
     * Creates a form object. If the request parameter "id" is set, the
     * specified study grade type is read. Otherwise a new one is created.
     */
    @RequestMapping(value="/fee/feeStudyGradeType.view",method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) 
            throws Exception {

        // declare variables
        HttpSession session = request.getSession(false);        
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject("feeStudyGradeTypeForm", session, model, opusMethods.isNewForm(request));

        String categoryCode = null;

        //        int currentPageNumber = 0;

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        FeeStudyGradeTypeForm feeStudyGradeTypeForm = (FeeStudyGradeTypeForm) session.getAttribute("feeStudyGradeTypeForm");
        if (feeStudyGradeTypeForm == null) {
            feeStudyGradeTypeForm = new FeeStudyGradeTypeForm();
            model.addAttribute("feeStudyGradeTypeForm", feeStudyGradeTypeForm);

            // navigation settings
            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            feeStudyGradeTypeForm.setNavigationSettings(navigationSettings);

            // domain object
            int feeId = ServletUtil.getIntParam(request, "feeId", 0);
            Fee fee;
            if (feeId != 0) {

                fee = feeManager.findFee(feeId);
             //   categoryCode = fee.getCategoryCode();

                Map<String, Object> findDeadlinesMap = new HashMap<String, Object>();

                findDeadlinesMap.put("feeId", feeId);
                findDeadlinesMap.put("lang", preferredLanguage);

                feeStudyGradeTypeForm.setFeeDeadlines(feeManager.findFeeDeadlinesAsMaps(findDeadlinesMap));

            } else {
                fee = new Fee();
                fee.setActive("Y");
                fee.setFeeDue(BigDecimal.valueOf(0.00));
            }
            feeStudyGradeTypeForm.setFee(fee);

            int studyGradeTypeId=fee.getStudyGradeTypeId();
            if (studyGradeTypeId != 0) {
                feeStudyGradeTypeForm.setStudyGradeType(studyManager.findStudyGradeType(studyGradeTypeId));
            }

            // EXISTING STUDY
            int studyId = ServletUtil.getIntParam(request, "studyId", 0);
            if (studyId != 0) {
                feeStudyGradeTypeForm.setStudy(studyManager.findStudy(studyId));
            }

            // lists
            feeStudyGradeTypeForm.setAllFeeCategories(lookupManager.findAllRows(preferredLanguage, "fee_feeCategory"));

            List <? extends Lookup> allStudyForms  = (List <?extends Lookup>) lookupManager.findAllRows(preferredLanguage, "studyForm");
            List <? extends Lookup> allStudyTimes  = (List <?extends Lookup>) lookupManager.findAllRows(preferredLanguage, "studyTime");
            List <? extends Lookup> allNationalityGroups  = (List <?extends Lookup>) lookupManager.findAllRows(preferredLanguage, "nationalityGroup");
            feeStudyGradeTypeForm.setAllStudyForms(allStudyForms);
            feeStudyGradeTypeForm.setAllStudyTimes(allStudyTimes);
            feeStudyGradeTypeForm.setAllNationalityGroups(allNationalityGroups);
            feeStudyGradeTypeForm.setCodeToStudyFormMap(new CodeToLookupMap(allStudyForms));
            feeStudyGradeTypeForm.setCodeToStudyTimeMap(new CodeToLookupMap(allStudyTimes));
//            feeStudyGradeTypeForm.setCodeToNationalityGroupMap(new CodeToLookupMap(allNationalityGroups));
            
            feeStudyGradeTypeForm.setAllStudyIntensities(lookupManager.findAllRows(preferredLanguage, "studyIntensity"));

            List<? extends Lookup> allFeeUnits = feeLookupCacher.getAllFeeUnits(preferredLanguage);
            feeStudyGradeTypeForm.setAllFeeUnits(allFeeUnits);

            List <AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
            feeStudyGradeTypeForm.setAllAcademicYears(allAcademicYears);
            feeStudyGradeTypeForm.setIdToAcademicYearMap(new IdToAcademicYearMap(allAcademicYears));

            List <StudyGradeType> allStudyGradeTypesForFees = null;
            Map<String, Object> findStudyGradeTypesMap = new HashMap<String, Object>();
            findStudyGradeTypesMap.put("studyId", studyId);
            findStudyGradeTypesMap.put("preferredLanguage", preferredLanguage);
            allStudyGradeTypesForFees = feeManager.findStudyGradeTypesForFee(findStudyGradeTypesMap);
            feeStudyGradeTypeForm.setAllStudyGradeTypesForFees(allStudyGradeTypesForFees);

        }

        model.addAttribute("currentDate", new Date());

        return formView;
    }

    @RequestMapping(value="/fee/feeStudyGradeType.view",method=RequestMethod.POST)
    public String processSubmit(
            @ModelAttribute("feeStudyGradeTypeForm") FeeStudyGradeTypeForm feeStudyGradeTypeForm,
            BindingResult result, SessionStatus status, HttpServletRequest request, ModelMap model) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        Fee fee = feeStudyGradeTypeForm.getFee();

        // validate
        result.pushNestedPath("fee");
        feeStudyGradeTypeValidator.validate(fee, result);
        result.popNestedPath();

        if (fee.getId() == 0) { // new fee
            Map<String,Object> params = new HashMap<String, Object>();
            params.put("categoryCode", fee.getCategoryCode());
            params.put("studyGradeTypeId", fee.getStudyGradeTypeId());
            params.put("cardinalTimeUnitNumber", fee.getCardinalTimeUnitNumber());
            params.put("studyIntensityCode", fee.getStudyIntensityCode());
            List<Fee> fees = feeManager.findFeesByParams(params);
            if (fees != null && !fees.isEmpty()) {
                result.reject("jsp.error.general.alreadyexists");
            }
        }

        // cancel in case of validation errors
        if (result.hasErrors()) {
            return formView;
        }

        // database operations
        fee.setWriteWho(opusMethods.getWriteWho(request));

        if (fee.getId() != 0) {
            feeManager.updateFee(fee);
        } else {
            feeManager.addFee(fee);
        }
        status.setComplete();

        return "redirect:/fee/feeStudyGradeType.view?newForm=true"
            + "&feeId=" + fee.getId()
            + "&studyId=" + feeStudyGradeTypeForm.getStudy().getId()
            + "&tab=0&panel=0"
            + "&currentPageNumber=" + feeStudyGradeTypeForm.getNavigationSettings().getCurrentPageNumber();
    }

    @RequestMapping(value = "/fee/feeStudyGradeTypeDeadline_delete.view", method = RequestMethod.GET)
    public String deleteFeeDeadline(
            @RequestParam("feeDeadlineId") int feeDeadlineId
            , @RequestParam("feeId") int feeId
            , @RequestParam("studyId") int studyId
            , ModelMap model, HttpServletRequest request){

        HttpSession session = request.getSession(false);        

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        FeeStudyGradeTypeForm feeStudyGradeTypeForm = (FeeStudyGradeTypeForm) session.getAttribute("feeStudyGradeTypeForm");

        NavigationSettings navigationSettings = feeStudyGradeTypeForm.getNavigationSettings();

        feeManager.deleteFeeDeadline(feeDeadlineId, opusMethods.getWriteWho(request));

        return "redirect:/fee/feeStudyGradeType.view?newForm=true" 
            + "&feeId=" + feeId
            + "&studyId=" + studyId
            + "&currentPageNumber="	+ navigationSettings.getCurrentPageNumber()
            + "&tab=1"
            + "&panel=0";

    }

}
