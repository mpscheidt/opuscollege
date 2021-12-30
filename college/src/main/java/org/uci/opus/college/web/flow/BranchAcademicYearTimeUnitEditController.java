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
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.BranchAcademicYearTimeUnit;
import org.uci.opus.college.domain.util.DomainUtil;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.service.AcademicYearManager;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.util.TimeUnit;
import org.uci.opus.college.util.TimeUnitInYear;
import org.uci.opus.college.validator.BranchAcademicYearTimeUnitValidator;
import org.uci.opus.college.web.form.BranchAcademicYearTimeUnitForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

@Controller
@RequestMapping("/college/branchAcademicYearTimeUnit.view")
@SessionAttributes({BranchAcademicYearTimeUnitEditController.FORM})
public class BranchAcademicYearTimeUnitEditController {

    public static final String FORM = "branchAcademicYearTimeUnitForm";

    @SuppressWarnings("unused")
    private static Logger log = LoggerFactory.getLogger(BranchAcademicYearTimeUnitEditController.class);

    private final String formView = "college/organization/branchAcademicYearTimeUnit";

    @Autowired private SecurityChecker securityChecker;
    @Autowired private InstitutionManagerInterface institutionManager;
    @Autowired private AcademicYearManager academicYearManager;
    @Autowired private BranchManagerInterface branchManager;
    @Autowired private BranchAcademicYearTimeUnitValidator branchAcademicYearTimeUnitValidator;
    @Autowired private LookupManagerInterface lookupManager;
    @Autowired private MessageSource messageSource;
    @Autowired private OpusMethods opusMethods;

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

    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(HttpServletRequest request, ModelMap model) {

        BranchAcademicYearTimeUnit branchAcademicYearTimeUnit;

        HttpSession session = request.getSession(false);
        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject(FORM, session, model, opusMethods.isNewForm(request));

        BranchAcademicYearTimeUnitForm form = (BranchAcademicYearTimeUnitForm) model.get(FORM);
        if (form == null) {
            form = new BranchAcademicYearTimeUnitForm();
            model.put(FORM, form);

            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request,  navigationSettings, null);
            form.setNavigationSettings(navigationSettings);

            int branchAcademicYearTimeUnitId = ServletUtil.getIntParam(request, "branchAcademicYearTimeUnitId", 0);
            int branchId;

            if (branchAcademicYearTimeUnitId != 0) {
                // EXISTING
                branchAcademicYearTimeUnit = branchManager.findBranchAcademicYearTimeUnitById(branchAcademicYearTimeUnitId);
                branchId = branchAcademicYearTimeUnit.getBranchId();
                form.setTimeUnitId(TimeUnit.makeCode(branchAcademicYearTimeUnit.getCardinalTimeUnitCode(), branchAcademicYearTimeUnit.getCardinalTimeUnitNumber()));
                
            } else {
                // NEW
                branchAcademicYearTimeUnit = new BranchAcademicYearTimeUnit();

                // in this case we need to know to which branch the new item belongs
                branchId = ServletUtil.getIntParam(request, "branchId", 0);
                branchAcademicYearTimeUnit.setBranchId(branchId);
            }
            form.setBranchAcademicYearTimeUnit(branchAcademicYearTimeUnit);
            form.setBranch(branchManager.findBranch(branchId));
            
            List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
            form.setAllAcademicYears(allAcademicYears);
            form.setIdToAcademicYearMap(new IdToAcademicYearMap(allAcademicYears));

            List<TimeUnitInYear> allTimeUnits = lookupManager.getAllTimeUnitsInYear(preferredLanguage);
            form.setAllTimeUnits(allTimeUnits);
        }

        return formView;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String onSubmit(HttpServletRequest request, @ModelAttribute(FORM) BranchAcademicYearTimeUnitForm form, BindingResult result, ModelMap model) {

        BranchAcademicYearTimeUnit branchAcademicYearTimeUnit = form.getBranchAcademicYearTimeUnit();
        TimeUnitInYear timeUnit = (TimeUnitInYear) DomainUtil.getObjectByPropertyValue(form.getAllTimeUnits(), "code", form.getTimeUnitId());
        if (timeUnit != null) {
            branchAcademicYearTimeUnit.setCardinalTimeUnitCode(timeUnit.getCardinalTimeUnit().getCode());
            branchAcademicYearTimeUnit.setCardinalTimeUnitNumber(timeUnit.getCardinalTimeUnitNumber());
        }
        
        result.pushNestedPath("branchAcademicYearTimeUnit");
        branchAcademicYearTimeUnitValidator.validate(branchAcademicYearTimeUnit, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            return formView;
        }

        // In case of new record, test if it already exists
        if (branchAcademicYearTimeUnit.getId() == 0) {
            if (branchManager.findBranchAcademicYearTimeUnit(branchAcademicYearTimeUnit.getBranchId(),
                    branchAcademicYearTimeUnit.getAcademicYearId(),
                    branchAcademicYearTimeUnit.getCardinalTimeUnitCode(),
                    branchAcademicYearTimeUnit.getCardinalTimeUnitNumber()) != null) {
                result.reject("jsp.error.general.alreadyexists");
            }
        }
        
        if (result.hasErrors()) {
            return formView;
        }
        
        // -- all validation before here --

//        HttpSession session = request.getSession(false);      

        // NEW UNIT
        if (branchAcademicYearTimeUnit.getId() == 0) {
            
            // add the new item
            branchManager.addBranchAcademicYearTimeUnit(branchAcademicYearTimeUnit);

        // UPDATE BRANCH
        } else {
            
           // update the branch
            branchManager.updateBranchAcademicYearTimeUnit(branchAcademicYearTimeUnit);
        }

        return "redirect:/college/branch.view?newForm=true"
                + "&branchId=" + branchAcademicYearTimeUnit.getBranchId()
                + "&currentPageNumber=" + form.getNavigationSettings().getCurrentPageNumber()
                + "&tab=" + form.getNavigationSettings().getTab() 
                        + "&panel=" + form.getNavigationSettings().getPanel();
    }

}
