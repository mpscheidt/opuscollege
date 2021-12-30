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

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.uci.opus.college.domain.OpusPrivilege;
import org.uci.opus.college.persistence.StudyplanMapper;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.util.OpusMethods;

@Controller
@RequestMapping("/college/start.view")
public class StartController {

    private static Logger log = LoggerFactory.getLogger(StartController.class);
    private static final String viewName = "college/start";

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private AppConfigManagerInterface appConfigManager;

    @Autowired
    private StudyplanMapper studyplanMapper;

    public StartController() {
        super();
    }

    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap m) {

        if (log.isDebugEnabled()) {
            log.debug("setupForm entered");
        }

        m.put("administratorMailAddress", appConfigManager.getAdministratorMailAddress());

        // moved to opusMethods since the startController is not always called on start up:
        // if a student logs in, other views are directly approached
        opusMethods.fillParamsAtStartUp(request);

        setStatisticsInModel(request, m);

        return viewName;
    }

    private void setStatisticsInModel(HttpServletRequest request, ModelMap m) {

        if (request.isUserInRole(OpusPrivilege.CREATE_INSTITUTIONS)) {
            m.put("numberOfActiveStudyPlans", studyplanMapper.findNumberOfActiveStudyPlans());
            m.put("totalNumberOfStudyPlans", studyplanMapper.findTotalNumberOfStudyPlans());
        }

    }

}
