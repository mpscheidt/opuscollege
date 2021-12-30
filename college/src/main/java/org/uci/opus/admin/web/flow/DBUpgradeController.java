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

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.college.service.dbupgrade.DbUpgradeException;
import org.uci.opus.college.service.dbupgrade.DbUpgradeManagerInterface;
import org.uci.opus.college.service.dbupgrade.DbUpgradeModelFactory;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.dbupgrade.DbUpgradeModel;

/**
 * A view that shows available database upgrades and allows to execute them.
 * 
 * @author markus
 *
 */

@Controller
@RequestMapping(value = "/college/module/dbupgrade.view")
@SessionAttributes("dbUpgradeModel")
public class DBUpgradeController {

    private static Logger log = LogManager.getLogger(DBUpgradeController.class);

    @Autowired
    private SecurityChecker securityChecker;

    @Autowired
    private DbUpgradeManagerInterface dbUpgradeManager;

    @Autowired
    private DbUpgradeModelFactory dbUpgradeModelFactory;

    @RequestMapping(method = RequestMethod.GET)
    public String prepareView(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);
        session.setAttribute("menuChoice", "admin");

        Map<String, Object> map = referenceData(request);
        model.addAllAttributes(map);
        return "/college/module/dbupgrade"; // point to the jsp file (init.jsp)
    }

    protected Map<String, Object> referenceData(HttpServletRequest request) {

        DbUpgradeModel dbUpgradeModel = dbUpgradeModelFactory.newDbUpgradeModel();

        // --- Build the model ---
        Map<String, Object> model = new HashMap<>();
        model.put("dbUpgradeModel", dbUpgradeModel);

        return model;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String runDbUpgrades(HttpServletRequest request, DbUpgradeModel dbUpgradeModel, Model model) throws DbUpgradeException {
        HttpSession session = request.getSession(false);
        securityChecker.checkSessionValid(session);

        dbUpgradeManager.runDbUpgrades(dbUpgradeModel);
        return "redirect:/college/module/dbupgrade.view?newForm=true";
    }

}
