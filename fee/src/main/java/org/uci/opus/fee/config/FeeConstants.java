package org.uci.opus.fee.config;


public abstract class FeeConstants {

    
    public static final String FEE_UNIT_NONE = "0"; // for fees on specific subjects and blocks (fee_fee.subjectStudyGradeTypeId != 0)
    public static final String FEE_UNIT_SUBJECT = "1";
    public static final String FEE_UNIT_CARDINALTIMEUNIT = "2";
    public static final String FEE_UNIT_STUDYGRADETYPE = "4";

    public static final String FEE_CATEGORY_ACCOMMODATION = "2";

    public static final String FEE_APPLICATION_MANUAL = "M";
    public static final String FEE_APPLICATION_AUTOMATIC = "A";
    public static final String BALANCE_BROUGHT_FORWARD_CAT = "9";
    public static final String FEE_CANCELLATION_CAT = "10";

}
