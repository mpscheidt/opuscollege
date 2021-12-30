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
 * The Original Code is Opus-College fee module code.
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
 ******************************************************************************/

package org.uci.opus.fee.util;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.extpoint.DBUpgradeListener;
import org.uci.opus.fee.config.FeeConstants;
import org.uci.opus.util.dbupgrade.DbUpgradeCommandInterface;

/**
 * @author Markus Pscheidt
 *
 */
public class FeeLookupCacher implements DBUpgradeListener {

    private static Logger log = LoggerFactory.getLogger(FeeLookupCacher.class);
    private LookupManagerInterface lookupManager;
    
//    List < ? extends Lookup > allFeeCategories;

    // language -> List<Lookup>
    private Map<String, List<Lookup>> allFeeUnitsMap = new HashMap<String, List<Lookup>>();
    private Map<String, List<Lookup>> allFeeCategoriesMap = new HashMap<String, List<Lookup>>();
    private Map<String, List<Lookup>> allFeeCategoriesWithoutBBFwdAndCancellationMap = new HashMap<String, List<Lookup>>();

    // TODO: refactor to the same way as getAllFeeUnits
/*    public HttpServletRequest getFeeLookups(String preferredLanguage, HttpServletRequest request) {
        
        allFeeCategories = (List < Lookup>) request.getAttribute("allFeeCategories");
        if (allFeeCategories == null) {
            allFeeCategories = (List < ? extends Lookup >
                            ) lookupManager.findAllRows(preferredLanguage, "fee_feeCategory");
        } else {
            if (allFeeCategories.size() == 0 || (allFeeCategories.size() != 0 
                        && !preferredLanguage.equals(allFeeCategories.get(0).getLang()))) {
                allFeeCategories = (List <?extends Lookup>) 
                    lookupManager.findAllRows(preferredLanguage,"fee_feeCategory");
            }
        }
        request.setAttribute("allFeeCategories", allFeeCategories);

        return request;
    }*/

    /**
     * @param newLookupManager
     */
    public void setLookupManager(LookupManagerInterface newLookupManager) {
        lookupManager = newLookupManager;
    }

    @SuppressWarnings("unchecked")
    public List<Lookup> getAllFeeUnits(String language) {
        List<Lookup> allFeeUnits = allFeeUnitsMap.get(language);
        if (allFeeUnits == null) {
            allFeeUnits = (List<Lookup>) lookupManager.findAllRows(language, "fee_unit");
            allFeeUnits = Collections.unmodifiableList(allFeeUnits);
            allFeeUnitsMap.put(language, allFeeUnits);
        }
        return allFeeUnits;
    }

    @SuppressWarnings("unchecked")
    public List<Lookup> getAllFeeCategories(String language) {
        List<Lookup> allFeeCategories = allFeeCategoriesMap.get(language);
        if (allFeeCategories == null) {
            allFeeCategories = (List<Lookup>) lookupManager.findAllRows(language, "fee_feecategory");
            allFeeCategories = Collections.unmodifiableList(allFeeCategories);
            allFeeCategoriesMap.put(language, allFeeCategories);
        }
        return allFeeCategories;
    }

    public List<Lookup> getFeeCategoriesWithoutBBFwdAndCancellation(String language) {
    	List<Lookup> allFeeCategories = allFeeCategoriesMap.get(language);
        List<Lookup> allFeeCategoriesWithoutBBFwdAndCancellation = allFeeCategoriesWithoutBBFwdAndCancellationMap.get(language);
        if (allFeeCategoriesWithoutBBFwdAndCancellation == null) {
        	allFeeCategoriesWithoutBBFwdAndCancellation = new ArrayList<Lookup>();
        	if (allFeeCategories == null) {
        		allFeeCategories = (List<Lookup>) lookupManager.findAllRows(language, "fee_feecategory");
        	}
            
            for (Lookup feeCategory : allFeeCategories) {
            	if (!feeCategory.getCode().equals(FeeConstants.BALANCE_BROUGHT_FORWARD_CAT)
            			&& !feeCategory.getCode().equals(FeeConstants.FEE_CANCELLATION_CAT)) {
            		allFeeCategoriesWithoutBBFwdAndCancellation.add(feeCategory);
            	}
            			
            }
            allFeeCategoriesWithoutBBFwdAndCancellation = Collections.unmodifiableList(
            									allFeeCategoriesWithoutBBFwdAndCancellation);
            allFeeCategoriesWithoutBBFwdAndCancellationMap.put(language, allFeeCategoriesWithoutBBFwdAndCancellation);
        }
        return allFeeCategoriesWithoutBBFwdAndCancellation;
    }
    
    @Override
    public void dbUpgradesExecuted(List<DbUpgradeCommandInterface> upgrades) {
        
        // reset all cached instances
        allFeeUnitsMap.clear();
        allFeeCategoriesMap.clear();
        
    }


}
