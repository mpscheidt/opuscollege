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
 * Center for Information Services, Radboud University Nijmegen
 * and Universidade Catolica de Mocambique.
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

package org.uci.opus.admin.web.flow;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.admin.domain.MailConfigItem;
import org.uci.opus.college.service.MailConfigItemManagerInterface;
import org.uci.opus.college.validator.MailConfigItemValidator;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

//@SessionAttributes({"studyForm"})
@Controller
@RequestMapping(value="/college/mailconfigitem.view")
@SessionAttributes({"mailConfigItem"})
public class MailConfigItemEditController {

	private static Logger log = LoggerFactory.getLogger(MailConfigItemEditController.class);
    private String formView;
    
    @Autowired private MailConfigItemManagerInterface mailConfigItemManager;
    @Autowired private SecurityChecker securityChecker;
    
    public MailConfigItemEditController() {
            super();
            this.formView = "/admin/mailconfigitem";
	}
    
    @RequestMapping(method=RequestMethod.GET)
	    public String setUpForm(ModelMap model, HttpServletRequest request) {
	  
    	HttpSession session = request.getSession(false);
    	
    	/* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        session.setAttribute("menuChoice", "admin");
    	
        int mailConfigItemId = ServletUtil.getIntParam(request, "mailConfigItemId", 0);
        int currentPageNumber = ServletUtil.getParamSetAttrAsInt(request, "currentPageNumber", 0);
        
        model.addAttribute("mailConfigItem", mailConfigItemManager.findMailConfigItemById(mailConfigItemId));
        
    	return formView;
	  }
    
    
    @RequestMapping(method=RequestMethod.POST)
    public String processSubmit(
    		@ModelAttribute("mailConfigItem") MailConfigItem mailConfigItem,
            BindingResult result, SessionStatus status, HttpServletRequest request) {
    	
    	 new MailConfigItemValidator().validate(mailConfigItem, result);
    	 
         if (result.hasErrors()) {
        	 return formView;
         }
         else
         {        	 
        	 mailConfigItemManager.updateMailConfigItem(mailConfigItem);
             status.setComplete();         
         }
    
    	return "redirect:/college/mailconfigitems.view?mailConfigItem=" + mailConfigItem.getId()
    	+ "&currentPageNumber=" + ServletUtil.getIntParam(request, "currentPageNumber", 0);
    }
}
