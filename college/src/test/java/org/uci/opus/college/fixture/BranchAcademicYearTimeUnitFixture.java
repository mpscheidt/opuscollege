package org.uci.opus.college.fixture;

import java.util.Date;
import java.util.GregorianCalendar;

import org.uci.opus.college.domain.BranchAcademicYearTimeUnit;

/**
 * 
 * @author markus
 *
 */
public class BranchAcademicYearTimeUnitFixture {

    public static final String BAYTU_1_CARDINALTIMEUNITCODE = "01";
    public static final int BAYTU_1_CARDINALTIMEUNITNUMBER = 1;
    public static final Date BAYTU_1_RESULTSPUBLISHDATE = new GregorianCalendar(2014, 6, 1).getTime();

    public static final String BAYTU_2_CARDINALTIMEUNITCODE = "01";
    public static final int BAYTU_2_CARDINALTIMEUNITNUMBER = 2;
    public static final Date BAYTU_2_RESULTSPUBLISHDATE = new GregorianCalendar(2014, 12, 1).getTime();

    public static BranchAcademicYearTimeUnit baytu1(int branchId) {
        return new BranchAcademicYearTimeUnit(branchId, BAYTU_1_CARDINALTIMEUNITCODE, BAYTU_1_CARDINALTIMEUNITNUMBER, BAYTU_1_RESULTSPUBLISHDATE);
    }

    public static BranchAcademicYearTimeUnit baytu2(int branchId) {
        return new BranchAcademicYearTimeUnit(branchId, BAYTU_2_CARDINALTIMEUNITCODE, BAYTU_2_CARDINALTIMEUNITNUMBER, BAYTU_2_RESULTSPUBLISHDATE);
    }

}
