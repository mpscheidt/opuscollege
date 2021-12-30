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

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.StudentBalance;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.fee.domain.DiscountedFee;

//@Component
public class FeeUtil {
    
    @Autowired private StudyManagerInterface studyManager;
    
	public static double getTotalFeeAmount(List<DiscountedFee> allStudentFees, List <? extends StudentBalance>allStudentBalances){
		double totalFee = 0.0;
		for(DiscountedFee fee : allStudentFees){
			for(StudentBalance studentBalance: allStudentBalances){
				if(fee.getFee().getId()==studentBalance.getFeeId()){
					totalFee= totalFee+fee.getDiscountedFeeDue();
				}
			}
		}
		return totalFee;
	}

	/**
	 * If CTU = year, then CTU is the same as academic year, so remove one of the two
     * (it doesn't make sense to offer the same twice to the user).
     * If CTU != year, then replace the text "cardinal time unit" with "semester", "trimester", etc.
	 * @param allCardinalTimeunits
	 * @param allFeeUnits
	 * @return map: cardinalTimeUnitCode -> list of fee units
	 */
/*	public Map<String, List<Lookup>> getUserFriendlyFeeUnitsMap(List<Lookup8> allCardinalTimeunits, List<Lookup> allFeeUnits) {
	    Map<String, List<Lookup>> allFeeUnitsMap = new HashMap<String, List<Lookup>>();

	    for (Lookup8 cardinalTimeUnit : allCardinalTimeunits) {

	        List<Lookup> feeUnits = new ArrayList<Lookup>(allFeeUnits);
	        Lookup ctuUnit = LookupUtil.getLookupByCode(feeUnits, FeeConstants.FEE_UNIT_CARDINALTIMEUNIT);

	        // either remove (if CTU is year), or replace "ctu" with "semester", "trimester", ...
	        if (cardinalTimeUnit.getNrOfUnitsPerYear() == 1) {
	            feeUnits.remove(ctuUnit);
	        } else {
	            ctuUnit.setDescription(cardinalTimeUnit.getDescription());
	        }
            allFeeUnitsMap.put(cardinalTimeUnit.getCode(), feeUnits);
	    }
	    return allFeeUnitsMap;
	}*/
	
}
