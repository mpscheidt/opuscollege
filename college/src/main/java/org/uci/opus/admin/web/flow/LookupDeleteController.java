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

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.uci.opus.admin.domain.LookupTable;
import org.uci.opus.admin.domain.TableDependency;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.ServletUtil;

/**
 * @author Stelio Macumbe
 * 
 */
@Controller
public class LookupDeleteController {

    private static Logger log = LoggerFactory.getLogger(LookupDeleteController.class);
    private String viewName = "admin/lookups";
    
    @Autowired
    private LookupManagerInterface lookupManager;

    @Autowired
    private LookupCacher lookupCacher;

    public LookupDeleteController() {
        super();
    }

    @RequestMapping("/college/lookupdelete")
    public String setupForm(HttpServletRequest request) {

        String lookupCode = ServletUtil.getParamSetAttrAsString(request, "code", "");
        String lookupTable = ServletUtil.getParamSetAttrAsString(request, "lookupTable", "");

        log.info("attempting to delete lookup with code '" + lookupCode + "' from table " + lookupTable);
        
        int currentPageNumber = ServletUtil.getParamSetAttrAsInt(request, "currentPageNumber", 1);
        String institutionTypeCode = ServletUtil.getParamSetAttrAsString(request, "institutionTypeCode", OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION);
        String v;

        v = "redirect:/college/lookups.view?lookupTable=" + lookupTable + "&institutionTypeCode=" + institutionTypeCode + "&currentPageNumber="
                + currentPageNumber;
        
        String lookupDescription = request.getParameter("description");
        List<String> deps = hasDependentValues(lookupTable, lookupCode, lookupDescription);
        if (deps.isEmpty()) {
            lookupManager.deleteLookupByCode(null, lookupCode, lookupTable);

            // reset cached lookups
            lookupCacher.resetLookups();

        } else {
            v += "&showError=dependencyerror" + "&dependenttable=" + deps + "&description=" + lookupDescription;
        }

        return v;
    }

    /**
     * Checks if the lookup is being used by any table This method also changes the view for the error page in case the lookup is being
     * used. This is done in this method because it is necessary to know what are the tables involved in this dependency when displaying the
     * error message to the user
     * 
     * @param lookupTable
     * @param lookupCode
     * @param lookupDescritpion
     *            - useful when building error message
     * @return
     */
    private List<String> hasDependentValues(String lookupTable, String lookupCode, String lookupDescription) {

        List<String> deps = new ArrayList<>();

        LookupTable table = (LookupTable) lookupManager.findLookupTableByName(lookupTable);
        TableDependency[] dependencies = table.getDependencies();
        boolean hasDependentValues = false;

        // checks if this table has any known dependency
        if ((dependencies != null) && (dependencies.length != 0)) {
            // checks if the dependencies have values
            for (int i = 0; i < dependencies.length; i++) {
                TableDependency dep = dependencies[i];

                hasDependentValues = lookupManager.hasDependentValues(dep.getDependentTable(), dep.getDependentTableColumn(), lookupCode);
                if (hasDependentValues) {
                    deps.add(dep.getDependentTable());
                    // break;
                }

            }

        }

        return deps;
    }

}
