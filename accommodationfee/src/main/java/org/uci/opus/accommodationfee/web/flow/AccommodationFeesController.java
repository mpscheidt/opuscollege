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
 * The Original Code is Opus-College accommodation module code.
 * 
 * The Initial Developer of the Original Code is
 * Computer Centre, Copperbelt University, Zambia.
 * Portions created by the Initial Developer are Copyright (C) 2012
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
package org.uci.opus.accommodationfee.web.flow;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.accommodation.service.AccommodationLookupCacher;
import org.uci.opus.accommodationfee.domain.AccommodationFee;
import org.uci.opus.accommodationfee.service.AccommodationFeeManagerInterface;
import org.uci.opus.accommodationfee.web.form.AccommodationFeesForm;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.fee.domain.Payment;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.fee.service.PaymentManagerInterface;
import org.uci.opus.fee.util.FeeLookupCacher;
import org.uci.opus.util.CodeToLookupMap;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;


@Controller
@RequestMapping("/accommodation/fees/fees.view")
@SessionAttributes({"accommodationFeesForm"})
public class AccommodationFeesController {
	
    private static Logger log = LoggerFactory.getLogger(AccommodationFeesController.class);

    private final String formView;

    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private AccommodationFeeManagerInterface accommodationFeeManager;
    @Autowired private AccommodationLookupCacher accommodationLookupCacher;
    @Autowired private FeeManagerInterface feeManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private PaymentManagerInterface paymentManager;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private FeeLookupCacher feeLookupCacher;


	public AccommodationFeesController() {
		super();
		this.formView = "accommodationfee/fees/fees";
	}

	@RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) throws Exception {
    	
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject("accommodationFeesForm", session, model, opusMethods.isNewForm(request));
        session.setAttribute("menuChoice", "accommodation");

        AccommodationFeesForm accommodationFeesForm = (AccommodationFeesForm) session.getAttribute("accommodationFeesForm");;
        if (accommodationFeesForm == null) {
            accommodationFeesForm = new AccommodationFeesForm();
            model.addAttribute("accommodationFeesForm", accommodationFeesForm);

            // navigation settings
            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            accommodationFeesForm.setNavigationSettings(navigationSettings);

            // filter values
            String hostelTypeCode=request.getParameter("hostelTypeCode");
            accommodationFeesForm.setHostelTypeCode(hostelTypeCode);

            int academicYearId = ServletUtil.getIntParam(request, "academicYearId", 0);
            accommodationFeesForm.setAcademicYearId(academicYearId);

            String roomTypeCode=request.getParameter("roomTypeCode");
            accommodationFeesForm.setRoomTypeCode(roomTypeCode);

            // filter lists
            String preferredLanguage=OpusMethods.getPreferredLanguage(request);
            accommodationFeesForm.setAllHostelTypes(accommodationLookupCacher.getAllHostelTypes(preferredLanguage));
            accommodationFeesForm.setCodeToHostelTypeMap(new CodeToLookupMap(accommodationFeesForm.getAllHostelTypes()));
            
            accommodationFeesForm.setAllRoomTypes(accommodationLookupCacher.getAllRoomTypes(preferredLanguage));
            accommodationFeesForm.setCodeToRoomTypeMap(new CodeToLookupMap(accommodationFeesForm.getAllRoomTypes()));

            accommodationFeesForm.setAllAcademicYears(academicYearManager.findAllAcademicYears());
            accommodationFeesForm.setIdToAcademicYearMap(new IdToAcademicYearMap(accommodationFeesForm.getAllAcademicYears()));

            accommodationFeesForm.setCodeToFeeUnitMap(new CodeToLookupMap(feeLookupCacher.getAllFeeUnits(preferredLanguage)));

            // primary list (accommodation fees)
            Map<String,Object> params = new HashMap<String, Object>();
            if(hostelTypeCode!=null && !hostelTypeCode.equals("0")) params.put("hostelTypeCode",hostelTypeCode);
            if (roomTypeCode!=null && !"0".equals(roomTypeCode)) params.put("roomTypeCode",roomTypeCode);
            if (academicYearId != 0) params.put("academicYearId", academicYearId);
            accommodationFeesForm.setAllAccommodationFees(accommodationFeeManager.findAccommodationFeesByParams(params));

        }
        
        model.addAttribute("currentDate", new Date());
        
        return formView;
    }
	
    
    // delete=true request parameter triggers this method
    @RequestMapping(method=RequestMethod.GET, params = "delete=true")
    public String delete(@RequestParam("accommodationFeeId") int accommodationFeeId,
            AccommodationFeesForm accommodationFeesForm, BindingResult result, HttpServletRequest request) throws Exception {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        // validate
        AccommodationFee accommodationFee = accommodationFeeManager.findAccommodationFee(accommodationFeeId);
        int feeId = accommodationFee.getId();
        
        validate(result, feeId);
        
        // database operation
        String view;
        if(result.hasErrors()) { 
            view = formView;
        } else {
            // TODO make this a transactional method in the new accommodationFeeManager
            String writeWho = opusMethods.getWriteWho(request);
            feeManager.deleteFee(feeId, writeWho);
            accommodationFeeManager.deleteAccommodationFee(accommodationFeeId, writeWho);
            feeManager.deleteStudentBalancesByFeeId(feeId, writeWho);
            view =  "redirect:fees.view?newForm=true";
        }
        return view;
    }

    // can also be used when deleting any fee (but problems with module borders need to be resolved first)
    public void validate(BindingResult result, int feeId) {
        
        // if student payments already made -> error message
        // if only student balances made: OK; they will be deleted together with the fee

//        List<StudentBalance> studentBalances = studentManager.findStudentBalancesByFeeId(feeId);
//        if (studentBalances != null && !studentBalances.isEmpty()) {
//            result.reject("jsp.fee.error.cannotDeleteFee", studentBalances.toArray(), "");
//        }

        Map<String,Object> params=new HashMap<String, Object>();
        params.put("feeId", feeId);

        List<Payment> payments = paymentManager.findPaymentsByParams(params);
        if (payments != null && !payments.isEmpty()) {
            result.reject("jsp.fee.error.cannotDeleteFee", payments.toArray(), "");
        }
    }
    
}