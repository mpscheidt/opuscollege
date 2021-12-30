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

package org.uci.opus.scholarship.web.flow;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.domain.util.IdToAcademicYearMap;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.scholarship.service.ScholarshipManagerInterface;
import org.uci.opus.scholarship.web.form.SponsorsForm;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;


/**
 * 
 * @author stelio2
 *
 */
@Controller
@SessionAttributes({"sponsorsForm"})
 public class SponsorsController {

    private static Logger log = LoggerFactory.getLogger(SponsorsController.class);
    
    private final String formView;

    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private OpusMethods opusMethods;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private MessageSource messageSource;
    @Autowired private ScholarshipManagerInterface scholarshipManager;

    /** 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */	 	
    
	public SponsorsController() {
		super();
		
		this.formView = "scholarship/sponsor/sponsors";
	}

	@RequestMapping(value="/scholarship/sponsors.view", method=RequestMethod.GET)
	public String setUpForm(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	throws Exception {
        
        HttpSession session = request.getSession(false);
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        /* set menu to students */
        session.setAttribute("menuChoice", "scholarship");

        SponsorsForm sponsorsForm;
        NavigationSettings navigationSettings = null;

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

        opusMethods.removeSessionFormObject("sponsorsForm", session, model, opusMethods.isNewForm(request));
        
        /* SecondarySchoolFORM - fetch or create the form object and fill it with secondarySchool */
        sponsorsForm = (SponsorsForm) model.get("sponsorsForm");
        if (sponsorsForm == null) {
            sponsorsForm = new SponsorsForm();
            model.addAttribute("sponsorsForm", sponsorsForm);

            List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
            sponsorsForm.setIdToAcademicYearMap(new IdToAcademicYearMap(allAcademicYears));
        }

        
        /* NAVIGATION SETTINGS - fetch or create the object */
        if (sponsorsForm.getNavigationSettings() != null) {
        	navigationSettings = sponsorsForm.getNavigationSettings();
        } else {
        	navigationSettings = new NavigationSettings();
            sponsorsForm.setNavigationSettings(navigationSettings);

            opusMethods.fillNavigationSettings(request, navigationSettings, "/scolarship/sponsors.view");
        }

        String searchValue = ServletUtil.getStringValueSetOnSession(session, request, "searchValue");

        Map<String, Object> findSponsorsMap = new HashMap<String, Object>();
        findSponsorsMap.put("preferredLanguage", preferredLanguage);
        if(! StringUtil.isNullOrEmpty(searchValue, true)) {
            findSponsorsMap.put("searchValue", searchValue);
        }
        sponsorsForm.setSponsors(scholarshipManager.findSponsorsAsMaps(findSponsorsMap));
        

        //clear error messages
        sponsorsForm.setErrorMessages(null);

        return formView; 
    }
	 
	 

	@RequestMapping(value="/scholarship/sponsors.view", method=RequestMethod.POST)
	public String processSubmit(
	        @ModelAttribute("sponsorsForm") SponsorsForm sponsorsForm,
	        BindingResult result, SessionStatus status, HttpServletRequest request) {

	    NavigationSettings navigationSettings = sponsorsForm.getNavigationSettings();

	    String preferredLanguage = OpusMethods.getPreferredLanguage(request);
	    
	    /* fill lookup-tables with right values */
	    lookupCacher.getStudyLookups(preferredLanguage, request);

	    return "redirect:/scholarship/sponsors.view?tab=" + navigationSettings.getTab() 
	    + "&txtErr=" + sponsorsForm.getTxtErr()
	    + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
	}

	@RequestMapping(value="/scholarship/sponsor_delete.view", method=RequestMethod.GET)
	 public String deleteSponsor(@RequestParam("sponsorId") int sponsorId, ModelMap model, HttpServletRequest request){
	 
	     HttpSession session = request.getSession(false);        

	     /* perform session-check. If wrong, this throws an Exception towards ErrorController */
	     securityChecker.checkSessionValid(session);

	     Map<String, Object> dependencies = scholarshipManager.findSponsorDependencies(sponsorId);

	     SponsorsForm sponsorsForm = (SponsorsForm) session.getAttribute("sponsorsForm");

	     Locale currentLoc = RequestContextUtils.getLocale(request);

	     List<String> errorMessages = new ArrayList<String>();

	     //create error messages based on dependencies
	     for(Iterator <Map.Entry<String, Object>> it = dependencies.entrySet().iterator(); it.hasNext();){
	         Map.Entry<String, Object> dependency = (Map.Entry<String,Object>)it.next();


	         long dependingItems = (Long)dependency.getValue(); 

	         //check number of dependencies on a table
	         //only create an error message for those tables which have at least a dependency
	         if(dependingItems != 0) {

	             String tableName = messageSource.getMessage("general." + dependency.getKey().toLowerCase(),null, currentLoc);

	             String errorMessage = messageSource.getMessage("jsp.error.delete.args",
	                     new Object[]{"", dependingItems, tableName},
	                     currentLoc
	             );

	             errorMessages.add(errorMessage);
	         }

	     }

	     String view;
	     if(errorMessages.size() > 0) {	
	         sponsorsForm.setErrorMessages(errorMessages);
	         view = formView;
	     } else {
	         scholarshipManager.deleteSponsor(sponsorId, opusMethods.getWriteWho(request));
	         view =  "redirect:/scholarship/sponsors.view?newForm=true";
	     }

//	     model.addAttribute("sponsorsForm", sponsorsForm);

		 return view;
	 }


}
