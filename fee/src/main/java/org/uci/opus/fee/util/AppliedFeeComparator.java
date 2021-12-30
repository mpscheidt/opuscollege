package org.uci.opus.fee.util;

import java.util.Comparator;

import org.uci.opus.fee.domain.AppliedFee;
import org.uci.opus.util.AcademicYearComparator;

// Comparator for appliedFees, for sorting on academicYear and ctuNumber descending
public class AppliedFeeComparator implements Comparator<AppliedFee> {
    
    private AcademicYearComparator academicYearComparator = new AcademicYearComparator();

    @Override
    public int compare(AppliedFee o1, AppliedFee o2) {
        int compare = 0;
        Integer ctuNumber1 = Integer.valueOf(o1.getCtuNumber());
        Integer ctuNumber2 = Integer.valueOf(o2.getCtuNumber());
 
        compare = academicYearComparator.compare(o2.getAcademicYear(), o1.getAcademicYear());
           
        // academicYear1 equals academicYear2
        if (compare == 0) {
            compare = ctuNumber2.compareTo(ctuNumber1);
        }
        return compare;
    }
}

