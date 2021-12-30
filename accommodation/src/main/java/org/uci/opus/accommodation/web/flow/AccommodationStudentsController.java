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
package org.uci.opus.accommodation.web.flow;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.util.SecurityChecker;

/**
 * Servlet implementation class for Servlet: AccommodationStudentsController.
 *
 */

@Controller
@RequestMapping("/accommodation/students.view")
@SessionAttributes({"accommodationStudentsForm"})
public class AccommodationStudentsController {
	
    private String formView;
    @Autowired private SecurityChecker securityChecker;    
    
    private static Logger log = LoggerFactory.getLogger(AccommodationStudentsController.class);

    /** 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */	 	
	public AccommodationStudentsController() {
		super();
		this.formView = "accommodation/students/students";
	}

    @RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request, 
    		HttpServletResponse response) {
        //model.addAttribute("accommodationForm", accommodationForm);
        return formView; 
	
	}

    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit() {

    	return formView;
   	 	/*return "redirect:accommodationstudents.view?tab=" + navigationSettings.getTab() 
   	 			+ "&panel=" + navigationSettings.getPanel() 
   	 			+ "&txtErr=" + accommodationStudentsForm.getTxtErr()
   	 			+ "&currentPageNumber=" + navigationSettings.getCurrentPageNumber();
   	 	*/
    }

}
