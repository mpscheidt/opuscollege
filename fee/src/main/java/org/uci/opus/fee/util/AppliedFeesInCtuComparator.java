package org.uci.opus.fee.util;

import java.util.Comparator;

import org.uci.opus.fee.config.FeeConstants;
import org.uci.opus.fee.domain.AppliedFee;
import org.uci.opus.fee.domain.Fee;

/* Comparator for appliedFees, puts the balanceBroughtForward (BBFwd) on top and 
 * the tuition fee on the bottom for one specific CardinalTimeUnit
 */
public class AppliedFeesInCtuComparator implements Comparator<AppliedFee> {
    
    @Override
    public int compare(AppliedFee appliedFee1, AppliedFee appliedFee2) {

        
        Fee fee1 = appliedFee1.getFee();
        Fee fee2 = appliedFee2.getFee();
            int result = fee1.getCategoryCode().compareTo(fee2.getCategoryCode());
            if (result != 0) {
                /* the balanceBroughtFwd fee must be paid first so must be brought to the top
                 of the list. So, regardless of the actual value of the feeId, it is considered 
                 to be smaller than the other feeId */
                if ((FeeConstants.BALANCE_BROUGHT_FORWARD_CAT).equals(fee1.getCategoryCode())) {
                    result = -1;
                } else if ((FeeConstants.BALANCE_BROUGHT_FORWARD_CAT).equals(fee2.getCategoryCode())) {
                    result = 1;
                }
                /* the tuition fee must be paid last so must be brought to the bottom
                of the list. So, regardless of the actual value of the feeId, it is considered 
                to be bigger than the other feeId */
                if ("1".equals(fee1.getCategoryCode())) {
                    result = 1;
                } else if ("1".equals(fee2.getCategoryCode())) {
                    result = -1;
                }
            }

        return result;
    }
}

