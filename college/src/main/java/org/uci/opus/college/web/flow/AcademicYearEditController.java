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
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.uci.opus.college.domain.AcademicYear;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.validator.AcademicYearValidator;
import org.uci.opus.college.web.form.AcademicYearForm;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

@Controller
@RequestMapping("/college/academicyear.view")
public class AcademicYearEditController {
    
    private final String formView = "admin/academicyear";
    private static Logger log = LoggerFactory.getLogger(AcademicYearEditController.class);
    
    @Autowired private AcademicYearManagerInterface academicYearManager;
    @Autowired private AcademicYearValidator academicYearValidator;
    @Autowired private OpusMethods opusMethods;
    @Autowired private SecurityChecker securityChecker;    

	public AcademicYearEditController() {
		super();
	}

    /**
     * Adds a property editor for dates to the binder.
     */
    @InitBinder
    protected void initBinder(WebDataBinder binder) {
        /* custom date editor */
        DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    /**
     * Read or create an academic year.
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) {

        HttpSession session = request.getSession(false);        
        securityChecker.checkSessionValid(session);
        opusMethods.removeSessionFormObject("academicYearForm", session, model, opusMethods.isNewForm(request));
        session.setAttribute("menuChoice", "studies");

        AcademicYearForm academicYearForm = (AcademicYearForm) model.get("academicYearForm");;
        if (academicYearForm == null) {
            academicYearForm = new AcademicYearForm();
            model.addAttribute("academicYearForm", academicYearForm);
            
            // navigation settings
            NavigationSettings navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
            academicYearForm.setNavigationSettings(navigationSettings);

            // allAcademicYears
            List<AcademicYear> allAcademicYears = academicYearManager.findAllAcademicYears();
            academicYearForm.setAllAcademicYears(allAcademicYears);

            // domain object
            AcademicYear academicYear = null;
            int academicYearId = ServletUtil.getIntParam(request, "academicYearId", 0);
            if (academicYearId != 0) {
                academicYear = academicYearManager.findAcademicYear(academicYearId);
            } else {
                academicYear = new AcademicYear();
            }
            academicYearForm.setAcademicYear(academicYear);
        }
        
        return formView;
    }

    /**
     * Saves the new or updated academicYear.
     */
    @RequestMapping(method=RequestMethod.POST)
    public String onSubmit(
            @ModelAttribute("academicYearForm") AcademicYearForm academicYearForm,
            BindingResult result,
            HttpServletRequest request) {

        AcademicYear academicYear = (AcademicYear) academicYearForm.getAcademicYear();

        // validate
        academicYearValidator.validate(academicYear, result);
        
        if (result.hasErrors()) return formView;

        // write data to database
        if(academicYear.getId() == 0) {
        	academicYearManager.addAcademicYear(academicYear);
        } else {
        	academicYearManager.updateAcademicYear(academicYear);
        }
        
        return "redirect:/college/academicyears.view";
    }

   
}
