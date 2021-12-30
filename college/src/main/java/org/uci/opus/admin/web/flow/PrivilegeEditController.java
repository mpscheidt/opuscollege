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

package org.uci.opus.admin.web.flow;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.college.domain.OpusPrivilege;
import org.uci.opus.college.service.OpusUserManagerInterface;
import org.uci.opus.college.web.form.PrivilegeForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;

/**
 * 
 * @author stelio2
 *
 */

@Controller
@RequestMapping(value="/college/privilege.view")
@SessionAttributes({"privilegeForm"})
public class PrivilegeEditController {
    
     private static Logger log = LoggerFactory.getLogger(PrivilegeEditController.class);
     
     private String formView;
     
     @Autowired private SecurityChecker securityChecker;    
     @Autowired private OpusUserManagerInterface opusUserManager;
     @Autowired private OpusMethods opusMethods;
    
     
     public PrivilegeEditController() {
		this.formView = "admin/privilege";
	}
     
    @InitBinder
    protected void initBinder(WebDataBinder binder) {
        /* custom date editor */
        DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }      
     
	@RequestMapping(method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request, @RequestParam("privilegeId") int privilegeId) {

        HttpSession session = request.getSession(false);        

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);
        
        session.setAttribute("menuChoice", "admin");
        
        // if adding a new privilege , destroy any existing one on the session
        opusMethods.removeSessionFormObject("privilegeForm", session, opusMethods.isNewForm(request));

        String preferredLanguage = OpusMethods.getPreferredLanguage(request);

//        OpusUserRole opusUserRole = (OpusUserRole) session.getAttribute("opusUserRole");
//        Role loggedInRole = opusUserManager.findRole(preferredLanguage, opusUserRole.getRole());

        OpusPrivilege opusPrivilege = null;
        PrivilegeForm privilegeForm = null;        


        /* PrivilegeForm - fetch or create the form object and fill it*/
        if ((PrivilegeForm) session.getAttribute("privilegeForm") != null) {
            privilegeForm = (PrivilegeForm) session.getAttribute("privilegeForm");
        } else {
            privilegeForm = new PrivilegeForm();
        }

       	opusPrivilege = opusUserManager.findOpusPrivilegeById(privilegeId, preferredLanguage);

        Map<String, Object> map = new HashMap<>();

        map.put("privilegeId", privilegeId);
        map.put("lang" , preferredLanguage);
        
      	privilegeForm.setRoles(opusUserManager.findOpusRolePrivileges(map));
      	privilegeForm.setPrivilege(opusPrivilege);
      	
      	model.addAttribute("privilegeForm", privilegeForm);
        
        return formView;
    }
}
