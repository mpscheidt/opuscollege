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
 * The Original Code is Opus-College accommodationfee module code.
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

package org.uci.opus.accommodationfee.web.flow;

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
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.accommodationfee.web.form.FeeDeadlineForm;
import org.uci.opus.college.domain.Lookup8;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.fee.domain.FeeDeadline;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.fee.validators.FeeDeadlineValidator;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.StringUtil;

/**
 * 
 * @author stelio2
 *
 */
@Controller
@RequestMapping(value="/accommodation/fees/feedeadline.view")
@SessionAttributes({"feeDeadlineForm"})
public class AccommodationFeeDeadlineEditController {

    private static Logger log = LoggerFactory.getLogger(AccommodationFeeDeadlineEditController.class);

    private String formView;

    @Autowired private SecurityChecker securityChecker;    
    @Autowired private OpusMethods opusMethods;
    @Autowired private FeeManagerInterface feeManager;
    @Autowired private LookupManagerInterface lookupManager;

    public AccommodationFeeDeadlineEditController() {
        super();

        this.formView = "accommodationfee/fees/feeDeadline";
    }

    @InitBinder
    protected void initBinder(WebDataBinder binder) 
            throws Exception {
        /* custom date editor */
        DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request
            , @RequestParam("accommodationFeeId") int accommodationFeeId
            , @RequestParam("feeId") int feeId) 
                    throws Exception {

        FeeDeadlineForm feeDeadlineForm = null;

        NavigationSettings navigationSettings = null;

        HttpSession session = request.getSession(false);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        // if adding a new feeDeadline, destroy any existing one on the session
        opusMethods.removeSessionFormObject("feeDeadlineForm", session, opusMethods.isNewForm(request));

        /* set menu to admin */
        session.setAttribute("menuChoice", "fee");

        int feeDeadlineId = ServletRequestUtils.getIntParameter(request, "feeDeadlineId", 0); 

        String from = request.getParameter("from");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        /* FeeDeadlineForm - fetch or create the form object and fill it with secondarySchool */
        if ((FeeDeadlineForm) session.getAttribute("feeDeadlineForm") != null) {
            feeDeadlineForm = (FeeDeadlineForm) session.getAttribute("feeDeadlineForm");
        } else {
            feeDeadlineForm = new FeeDeadlineForm();
        }

        if(feeDeadlineId != 0)
            feeDeadlineForm.setFeeDeadline(feeManager.findFeeDeadline(feeDeadlineId));
        else
            feeDeadlineForm.setFeeDeadline(feeDeadlineForm.createNewFeeDeadline(feeId, opusMethods.getWriteWho(request)));

        String cardinalTimeUnitCode = feeDeadlineForm.getFeeDeadline().getCardinalTimeUnitCode();

        if(!StringUtil.isNullOrEmpty(cardinalTimeUnitCode, true))
            feeDeadlineForm.setCardinalTimeUnit((Lookup8)lookupManager.findLookup(preferredLanguage, cardinalTimeUnitCode, "cardinaltimeunit"));

        List<Lookup8> allCardinalTimeUnits = lookupManager.findAllRows(preferredLanguage, "cardinaltimeunit");
        feeDeadlineForm.setCardinalTimeUnits(allCardinalTimeUnits);


        /* FeeDeadlineForm.NAVIGATIONSETTINGS - fetch or create the object */
        if (feeDeadlineForm.getNavigationSettings() != null) {

            navigationSettings = feeDeadlineForm.getNavigationSettings();

        } else {

            navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
        }

        feeDeadlineForm.setNavigationSettings(navigationSettings);
        feeDeadlineForm.setFrom(from);
        feeDeadlineForm.setAccommodationFeeId(accommodationFeeId);
        feeDeadlineForm.setFeeId(feeId);

        model.addAttribute("feeDeadlineForm", feeDeadlineForm);        

        return formView;
    }

    @RequestMapping(method=RequestMethod.POST, params="task=submitFormObject")
    public String processSubmit(
            @ModelAttribute("feeDeadlineForm") FeeDeadlineForm feeDeadlineForm,
            BindingResult result, SessionStatus status, HttpServletRequest request) { 

        NavigationSettings navigationSettings = feeDeadlineForm.getNavigationSettings();

        FeeDeadline feeDeadline = feeDeadlineForm.getFeeDeadline();

        result.pushNestedPath("feeDeadline");

        new FeeDeadlineValidator(feeManager).validate(feeDeadline, result);

        result.popNestedPath();

        if (result.hasErrors()) {

            return formView;

        } else {

            feeDeadline.setWriteWho(opusMethods.getWriteWho(request));

            if(feeDeadline.getId() == 0) {
                feeManager.addFeeDeadline(feeDeadline);
            } else {             	
                feeManager.updateFeeDeadline(feeDeadline);
            }

        }

        return "redirect:/accommodation/fees/fee.view?accommodationFeeId=" + feeDeadlineForm.getAccommodationFeeId()
                + "&tab=" + navigationSettings.getTab()
                + "&fromView=fees.view&newForm=true";
    }

    @RequestMapping(method=RequestMethod.POST, params="task=updateFormObject")
    public String updateForm(
            @ModelAttribute("feeDeadlineForm") FeeDeadlineForm feeDeadlineForm,
            BindingResult result, SessionStatus status, HttpServletRequest request, ModelMap model) {

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        String cardinalTimeUnitCode = feeDeadlineForm.getFeeDeadline().getCardinalTimeUnitCode();

        Lookup8 cardinalTimeUnit = null;

        if(!StringUtil.isNullOrEmpty(cardinalTimeUnitCode, true))
            cardinalTimeUnit = (Lookup8)lookupManager.findLookup(preferredLanguage, cardinalTimeUnitCode, "cardinaltimeunit");

        feeDeadlineForm.setCardinalTimeUnit(cardinalTimeUnit);

        model.addAttribute("feeDeadlineForm", feeDeadlineForm);

        return formView;
    }

}
