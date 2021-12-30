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

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
import org.uci.opus.accommodation.service.AccommodationLookupCacher;
import org.uci.opus.accommodationfee.domain.AccommodationFee;
import org.uci.opus.accommodationfee.service.AccommodationFeeManagerInterface;
import org.uci.opus.accommodationfee.validator.AccommodationFeeValidator;
import org.uci.opus.accommodationfee.web.form.AccommodationFeeForm;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.fee.config.FeeConstants;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.fee.util.FeeLookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.lookup.LookupUtil;

/**
 * Servlet implementation class for Servlet: AccommodationsController.
 *
 */

@Controller
@RequestMapping(value="/accommodation/fees/fee.view")
@SessionAttributes({"accommodationFeeForm"})
public class AccommodationFeeController {
	
    private String formView;

    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private AccommodationFeeManagerInterface accommodationFeeManager;
    @Autowired private AccommodationLookupCacher accommodationLookupCacher;
    @Autowired private AccommodationFeeValidator accommodationFeeValidator;
    @Autowired private OpusMethods opusMethods;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private FeeManagerInterface feeManager;
    @Autowired private FeeLookupCacher feeLookupCacher;
    
    private static Logger log = LoggerFactory.getLogger(AccommodationFeeController.class);

	public AccommodationFeeController() {
		super();
		this.formView = "accommodationfee/fees/fee";
	}

    @InitBinder
    public void initBinder(WebDataBinder binder){
        DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(df, true));
    }


	@RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) throws Exception {
	    
	    HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject("accommodationFeeForm", session, model, opusMethods.isNewForm(request));
        session.setAttribute("menuChoice", "accommodation");

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);
        
        AccommodationFeeForm accommodationFeeForm = (AccommodationFeeForm) session.getAttribute("accommodationFeeForm");
        
        if (accommodationFeeForm == null) {
            accommodationFeeForm = new AccommodationFeeForm();
            model.addAttribute("accommodationFeeForm", accommodationFeeForm);

            // navigation settings
            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            accommodationFeeForm.setNavigationSettings(navigationSettings);

            // domain object
            int accommodationFeeId = ServletUtil.getIntParam(request, "accommodationFeeId", 0);
            
            AccommodationFee accommodationFee;
            
            if (accommodationFeeId != 0) {
                accommodationFee = accommodationFeeManager.findAccommodationFee(accommodationFeeId);

                Map<String, Object> findDeadlinesMap = new HashMap<String, Object>();
                findDeadlinesMap.put("feeId", accommodationFee.getId());
                findDeadlinesMap.put("lang", preferredLanguage);
             
                accommodationFeeForm.setFeeDeadlines(feeManager.findFeeDeadlinesAsMaps(findDeadlinesMap));
             
            } else {
                accommodationFee = new AccommodationFee();
            }
            
            accommodationFeeForm.setAccommodationFee(accommodationFee);

            // lists
            String lang = OpusMethods.getPreferredLanguage(request);
        
            accommodationFeeForm.setAllHostelTypes(accommodationLookupCacher.getAllHostelTypes(lang));
            accommodationFeeForm.setAllRoomTypes(accommodationLookupCacher.getAllRoomTypes(lang));
            accommodationFeeForm.setAllAcademicYears(academicYearManager.findAllAcademicYears());

            List<Lookup> allFeeUnits = feeLookupCacher.getAllFeeUnits(lang);
            allFeeUnits = new ArrayList<Lookup>(allFeeUnits);   // make it modifiable
            LookupUtil.removeByCode(allFeeUnits, FeeConstants.FEE_UNIT_SUBJECT);
            accommodationFeeForm.setAllFeeUnits(allFeeUnits);

        }
        
        model.addAttribute("currentDate", new Date());
        
        return formView; 
 	}
	
	@RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
    		@ModelAttribute("accommodationFeeForm") AccommodationFeeForm accommodationFeeForm,
            BindingResult result, SessionStatus status, HttpServletRequest request,ModelMap model) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        AccommodationFee accommodationFee = accommodationFeeForm.getAccommodationFee();
        
        // validate
        result.pushNestedPath("accommodationFee");
        accommodationFeeValidator.validate(accommodationFee, result);
        result.popNestedPath();

        if (accommodationFee.getAccommodationFeeId() == 0) { // new accommodation fee
            Map<String,Object> params = new HashMap<String, Object>();
            params.put("academicYearId", accommodationFee.getAcademicYearId());
            params.put("hostelTypeCode", accommodationFee.getHostelTypeCode());
            params.put("roomTypeCode", accommodationFee.getRoomTypeCode());
            List<AccommodationFee> accommodationFees = accommodationFeeManager.findAccommodationFeesByParams(params);
            if (accommodationFees != null && !accommodationFees.isEmpty()) {
                result.reject("jsp.accommodation.error.accommodationFeeExist");
            }
        }
        
        // cancel in case of validation errors
        if (result.hasErrors()) {
            return formView;
        }

        // database operations
        accommodationFee.setWriteWho(opusMethods.getWriteWho(request));
        
        if (accommodationFee.getAccommodationFeeId() != 0) {
            feeManager.updateFee(accommodationFee);     // AccommodationFee extends Fee
            accommodationFeeManager.updateAccommodationFee(accommodationFee);
        } else {
            feeManager.addFee(accommodationFee);        // AccommodationFee extends Fee
            accommodationFeeManager.addAccommodationFee(accommodationFee);
        }
        status.setComplete();

        return "redirect:fees.view?newForm=true";

        
        
/*        String task=request.getParameter("task");
       	String save=request.getParameter("save");
       	String fromView = request.getParameter("fromView");

       	String formView = "accommodation/fees/fee";
        
        
        if(save !=null){
        	if(accommodationFee.getHostel().getId()!=0){
	        		if(accommodationFee.getAmountDue()!=null){
	        			if(accommodationFee.getDescription()!=null || !accommodationFee.getDescription().trim().equals("")){
	        				if(accommodationFee.getAcademicYear().getId()!=0){
	        					
	        					params.put("academicYearId", accommodationFee.getAcademicYear().getId());
	        					params.put("hostelId", accommodationFee.getHostel().getId());
	        					
	        					if(useHostelBlocks()) params.put("blockId", accommodationFee.getBlock().getId());
	        					//check if task is not for updating and that accommodationFee does not exist
	        					//if it doesn't exist then add a new one
	        					if((task==null || task.equals("add")) && accommodationManager.findAccommodationFeeByParams(params)==null){
	        						accommodationManager.addAccommodationFee(accommodationFee);
	        						accommodationFee=accommodationManager.findAccommodationFeeByParams(params);
	        						
	        						Fee fee=new Fee();
	        						fee.setCategoryCode("2");
	        						fee.setFeeDue(accommodationFee.getAmountDue());
	        						fee.setAcademicYearId(accommodationFee.getAcademicYear().getId());
	        						fee.setAccommodationFeeId(accommodationFee.getId());
	        						fee.setDeadline(accommodationFee.getDeadline());
	        						fee.setActive(accommodationFee.getActive());
	        						fee.setWriteWho(((OpusUser)request.getSession().getAttribute("opusUser")).getUsername());
	        						feeManager.addFee(fee);
	        						
	        						formView="redirect:fees.view?task=overview";
	        						status.setComplete();
	        					}else if(task!=null && task.equals("edit")){
	        						accommodationManager.updateAccommodationFee(accommodationFee);
	        						
	        						Fee fee=accommodationManager.findFeeByAccommodationFeeId(accommodationFee.getId());
	        						fee.setFeeDue(accommodationFee.getAmountDue());
	        						fee.setAcademicYearId(accommodationFee.getAcademicYear().getId());
	        						fee.setAccommodationFeeId(accommodationFee.getId());
	        						fee.setDeadline(accommodationFee.getDeadline());
	        						fee.setActive(accommodationFee.getActive());
	        						fee.setWriteWho(((OpusUser)request.getSession().getAttribute("opusUser")).getUsername());
	        						feeManager.updateFee(fee);
	        						
	        						formView="redirect:fees.view?task=overview";
	        						status.setComplete();
	        					}else{
	        						accommodationFeeForm.setTxtErr("jsp.accommodation.error.accommodationFeeExist");
	            		    		model.addAttribute("error",accommodationFeeForm.getTxtErr());
	        					}
	        				}else{
	        					accommodationFeeForm.setTxtErr("jsp.accommodation.error.chooseAcademicYear");
	        		    		model.addAttribute("error",accommodationFeeForm.getTxtErr());
	        				}
	        			}else{
	        				accommodationFeeForm.setTxtErr("jsp.accommodation.error.enterDescription");
	        	    		model.addAttribute("error",accommodationFeeForm.getTxtErr());
	        			}
	        		}else{
	        			accommodationFeeForm.setTxtErr("jsp.accommodation.error.enterAmount");
	            		model.addAttribute("error",accommodationFeeForm.getTxtErr());
	        		}
	        }else{
	    		accommodationFeeForm.setTxtErr("jsp.accommodation.error.chooseHostel");
	    		model.addAttribute("error",accommodationFeeForm.getTxtErr());
	        }
        }else{
        	
        	if(accommodationFee.getHostel().getId()!=0){
        		params.clear();
        		params.put("hostelId",accommodationFee.getHostel().getId());
        		params.put("lang", OpusMethods.getPreferredLanguage(request));
        		//load blocks if the useHostelBlocks is true
        		if (useHostelBlocks()) {
        			allBlocks=hostelManager.findBlocksByParams(params);
        		}
        	} 
        }
       
        if (fromView != null) {
            formView += "&fromView=" + fromView;
        }

        setDefaultData(model,accommodationFeeForm);
        return formView;*/
    }
    
/*    private String loadData(accommodationFeeForm accommodationFeeForm, ModelMap model, HttpServletRequest request){
    	String task=request.getParameter("task");
    	String accommodationFeeId=request.getParameter("accommodationFeeId");
    	accommodationFeeForm.setAccommodationFee(new AccommodationFee());
    	String formView="accommodation/fees/fee";
    	String preferredLanguage=OpusMethods.getPreferredLanguage(request);
    	
    	if(task!=null){
    		//delete accommodationFee
    		if(task!=null && task.toLowerCase().trim().equals("delete")){
    			accommodationManager.deleteAccommodationFee(Integer.valueOf(accommodationFeeId));
            	formView="redirect:fees.view?task=overview";
    		}else if (task.toLowerCase().trim().equals("edit")){
    			
    			if(accommodationFeeId!=null){
    				try{
    					//load accommodationFee object for editing
    		    		AccommodationFee accommodationFee = accommodationManager.findAccommodationFee(Integer.parseInt(accommodationFeeId));
    		    		// block is not compulsory, so may be null; but form needs a block to bind block.id
    		    		if (accommodationFee.getBlock() == null) accommodationFee.setBlock(new HostelBlock());
                        accommodationFeeForm.setAccommodationFee(accommodationFee);
    				}catch(Exception e){
    					accommodationFeeForm.setTxtErr("jsp.accommodation.error.feeIdNotValid");
    				}
    			}
    		}
    	}
    	
    	Map<String,Object> params=new HashMap<String, Object>();
		params.put("hostelId",hostelManager.findAllHostels().get(0).getId());
		params.put("lang", OpusMethods.getPreferredLanguage(request));
		allBlocks=hostelManager.findBlocksByParams(params);
		
    	setDefaultData(model,accommodationFeeForm);
    	return formView;
    }
    
    private void setDefaultData(ModelMap model,accommodationFeeForm accommodationFeeForm){
    	model.addAttribute("allHostels", hostelManager.findAllHostels());
    	model.addAttribute("allBlocks",allBlocks);
    	model.addAttribute("allAcademicYears", academicYearManager.findAllAcademicYears());
    	model.addAttribute("useHostelBlocks",useHostelBlocks());
    	model.addAttribute("accommodationFeeForm",accommodationFeeForm);
    }
    
    private boolean useHostelBlocks(){
    	AppConfigAttribute config=appConfigManager.findAppConfigAttribute("USE_HOSTELBLOCKS");
       	if (config!=null && config.getAppConfigAttributeName().equals("USE_HOSTELBLOCKS") && config.getAppConfigAttributeValue().equals("Y")){
       		return true;
       	}
       	return false;
    }*/
    
    
    @RequestMapping(method = RequestMethod.GET, params="task=deleteDeadline")
	public String deleteFeeDeadline(@RequestParam("feeDeadlineId") int feeDeadlineId
			 								, ModelMap model, HttpServletRequest request){
	 
        HttpSession session = request.getSession(false);        
        securityChecker.checkSessionValid(session);

        AccommodationFeeForm accommodationFeeForm = (AccommodationFeeForm) session.getAttribute("accommodationFeeForm");

        NavigationSettings navigationSettings = accommodationFeeForm.getNavigationSettings();

        feeManager.deleteFeeDeadline(feeDeadlineId, opusMethods.getWriteWho(request));

        return "redirect:/accommodation/fees/fee.view?newForm=true&tab=1&panel=0&fromView=fees.view" 
        + "&accommodationFeeId=" + accommodationFeeForm.getAccommodationFee().getAccommodationFeeId() 
        + "&currentPageNumber="	+ navigationSettings.getCurrentPageNumber()
        ;

    }

}