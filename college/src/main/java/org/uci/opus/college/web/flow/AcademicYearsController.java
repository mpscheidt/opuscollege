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
import org.uci.opus.college.web.form.AcademicYearsForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;


/**
 * 
 * @author stelio2
 *
 */
@Controller
@RequestMapping("/college/academicyears.view")
@SessionAttributes({"academicYearsForm"})
 public class AcademicYearsController {

    private static Logger log = LoggerFactory.getLogger(AcademicYearsController.class);
    
    private final String formView;
    
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private OpusMethods opusMethods;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private MessageSource messageSource;

    /** 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */	 	
    
	public AcademicYearsController() {
		super();
		
		this.formView = "admin/academicyears";
	}

	@RequestMapping(method=RequestMethod.GET)
	public String setUpForm(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
        
        HttpSession session = request.getSession(false);        
        String searchValue = ServletUtil.getStringValueSetOnSession(session, request, "searchValue");
        
        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        /* set menu to students */
        session.setAttribute("menuChoice", "studies");

        AcademicYearsForm academicYearsForm;
        NavigationSettings navigationSettings = null;
        
        opusMethods.removeSessionFormObject("academicYearsForm", session, opusMethods.isNewForm(request));
        
        /* SecondarySchoolFORM - fetch or create the form object and fill it with secondarySchool */
        if ((AcademicYearsForm) session.getAttribute("academicYearsForm") != null) {
            academicYearsForm = (AcademicYearsForm) session.getAttribute("academicYearsForm");
        } else {
            academicYearsForm = new AcademicYearsForm();
        }

        
        /* NAVIGATION SETTINGS - fetch or create the object */
        if (academicYearsForm.getNavigationSettings() != null) {
        	navigationSettings = academicYearsForm.getNavigationSettings();
        } else {
        	navigationSettings = new NavigationSettings();
        }

        opusMethods.fillNavigationSettings(request, navigationSettings, "/college/academicyears.view");
        
        academicYearsForm.setNavigationSettings(navigationSettings);
        
        Map<String, Object> findacademicYearsMap = new HashMap<>();

        findacademicYearsMap.put("searchValue", searchValue);

//        Map<Integer, String> allAcademicYearsMap = academicYearManager.findAllAcademicYearsAsIdToDescriptionMap();
        List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();

        //clear error messages
        academicYearsForm.setErrorMessages(null);

        academicYearsForm.setAcademicYears(academicYearManager.findAcademicYears(findacademicYearsMap));
        academicYearsForm.setAcademicYearsMap(new IdToAcademicYearMap(allAcademicYears));
        
        model.addAttribute("academicYearsForm", academicYearsForm);
        
        return formView; 
    }
	 
	 

	@RequestMapping(method=RequestMethod.POST)
	public String processSubmit(
	        @ModelAttribute("academicYearsForm") AcademicYearsForm academicYearsForm,
	        BindingResult result, SessionStatus status, HttpServletRequest request) {

	    NavigationSettings navigationSettings = academicYearsForm.getNavigationSettings();

	    String preferredLanguage = OpusMethods.getPreferredLanguage(request);
	    
	    /* fill lookup-tables with right values */
	    lookupCacher.getStudyLookups(preferredLanguage, request);

	    return "redirect:/college/academicyears.view?tab=" + navigationSettings.getTab() 
	    + "&txtErr=" + academicYearsForm.getTxtErr()
	    + "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
	}


	 
    @RequestMapping(method = RequestMethod.GET, params = "delete=true")
    public String deleteAcademicYear(@RequestParam("academicYearId") int academicYearId, AcademicYearsForm academicYearsForm, BindingResult result, HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        Map<String, Object> dependencies = academicYearManager.findDependencies(academicYearId);
        Locale currentLoc = RequestContextUtils.getLocale(request);
        List<String> errorMessages = new ArrayList<>();

        for (Iterator<Map.Entry<String, Object>> it = dependencies.entrySet().iterator(); it.hasNext();) {
            Map.Entry<String, Object> dependency = (Map.Entry<String, Object>) it.next();

            long dependingItems = (Long) dependency.getValue();

            // check number of dependencies on a table
            // only create an error message for those tables which have at least a dependency
            if (dependingItems != 0) {
                String tableName = messageSource.getMessage("jsp.general." + dependency.getKey().toLowerCase(), null, currentLoc);
                String errorMessage = messageSource.getMessage("jsp.error.academicyear.delete.args", new Object[] { "", dependingItems, tableName }, currentLoc);
                errorMessages.add(errorMessage);
            }

        }

        String view;
        if (errorMessages.size() > 0) {
            academicYearsForm.setErrorMessages(errorMessages);
            view = formView;
        } else {
            academicYearManager.deleteAcademicYear(academicYearId);
            view = "redirect:/college/academicyears.view?newForm=true";
        }

        // model.addAttribute("academicYearsForm", academicYearsForm);

        return view;
    }

}
