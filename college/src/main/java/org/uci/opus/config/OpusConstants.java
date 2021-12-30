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

package org.uci.opus.config;


/**
 * @author jano
 * Constants used throughout the application are maintained in this class
 */
public class OpusConstants {
    
    public static final String LANGUAGE_EN = "en";
    public static final String LANGUAGE_PT = "pt";
    public static final String DEFAULT_LANGUAGE = LANGUAGE_EN;
    
    public static final String DEFAULT_YEAR_FROM    = "1950";
    public static final String DEFAULT_YEAR_THROUGH = "2050";
    public static final int    DEFAULT_YEAR_FROM_INT = 
              Integer.parseInt(DEFAULT_YEAR_FROM);
    public static final int    DEFAULT_YEAR_THROUGH_INT = 
              Integer.parseInt(DEFAULT_YEAR_THROUGH);

    // Determine a maximum allowed number of rows in a helplist:
    // if a search in a helplist gives too much records, this might create 
    // a problem for the browser memory. Therefore we set a maximum.
    public static final int MAX_ROWCOUNT_ALLOWED = 500;
    public static final int MAX_JOURNAL_COUNT = MAX_ROWCOUNT_ALLOWED;
    public static final int MAX_AUTHORSHIP_COUNT = MAX_ROWCOUNT_ALLOWED;
    public static final int MAX_RESEARCH_COUNT = MAX_ROWCOUNT_ALLOWED;
    public static final int MAX_BOOKTITLE_COUNT = MAX_ROWCOUNT_ALLOWED;
    
    
    public static final String INSTITUTION_TYPE_HIGHER_EDUCATION = "3";
    public static final String INSTITUTION_TYPE_SECONDARY_SCHOOL = "1";
    public static final String INSTITUTION_TYPE_DEFAULT = INSTITUTION_TYPE_HIGHER_EDUCATION;
    
    public static final String GRADE_TYPE_SECONDARY_SCHOOL = "SEC";
/*    public static final String GRADE_TYPE_BACHELOR_OF_SCIENCE = "BSC";
    public static final String GRADE_TYPE_LICENTIATE = "LIC";
    public static final String GRADE_TYPE_MASTER_OF_SCIENCE = "MSC";
    public static final String GRADE_TYPE_MASTER_OF_BUSINESS_ADMINISTRATION = "MBA";
    public static final String GRADE_TYPE_DOCTOR = "PHD";
    public static final String GRADE_TYPE_BACHELOR_OF_ART = "BA";
    public static final String GRADE_TYPE_MASTER_OF_ART = "MA";
    public static final String GRADE_TYPE_DIPLOMA_OTHER_THAN_MATHS_AND_SCIENCE = "DA";
    public static final String GRADE_TYPE_DIPLOMA_MATHS_AND_SCIENCE = "DSC";
    public static final String GRADE_TYPE_BACHELOR_OF_ENGINEERING = "BEng";
    public static final String GRADE_TYPE_MASTER_OF_ENGINEERING_SCIENCE = "MEngSc";
    public static final String GRADE_TYPE_MASTER_OF_SCIENCE_ENGINEERING = "MScEng";
*/
    public static final String GRADE_TYPE_BACHELOR = "B";
    public static final String GRADE_TYPE_MASTER = "M";
    // specific for CBU:
/*    public static final String GRADE_TYPE_ADVANCED_TECHNOLOGY = "ADVTECH";
    public static final String GRADE_TYPE_ADVANCED_CERTIFICATE = "ADVCERT";
*/   
    
//    public static final int CREDIT_AMOUNT_PRACTICE = 50;
//    public static final int CREDIT_AMOUNT_THEORY = 50;
    public static final int HOURS_TO_INVEST = 40;
    public static final double CREDIT_AMOUNT_MAX = 999.9;
    public static final int CREDIT_AMOUNT_DECIMAL_PLACES = 1;

    public static final String HOME_ADDRESS = "1";
    public static final String FORMAL_ADDRESS_STUDENT = "2";
    public static final String FORMAL_ADDRESS_STUDY = "4";
    public static final String FORMAL_ADDRESS_ORGANIZATIONAL_UNIT = "5";
    public static final String FORMAL_ADDRESS_WORK = "6";

    public static final String STUDENTSTATUS_ACTIVE = "1";

    /**
     * Waiting for payment of admission fees for the study program.
     */
    public static final String STUDYPLAN_STATUS_WAITING_FOR_PAYMENT = "1";

    /**
     * Waiting for selection. If the applicants is higher than the number of available places for the study program,
     * then a selection needs to be made, e.g. cut-off-point selection. 
     */
    public static final String STUDYPLAN_STATUS_WAITING_FOR_SELECTION = "2";

    /**
     * Approved admission. Student has been admitted to the study program.
     */
    public static final String STUDYPLAN_STATUS_APPROVED_ADMISSION = "3";

    /**
     * Student has been rejected from starting with the given study program.
     */
    public static final String STUDYPLAN_STATUS_REJECTED_ADMISSION = "4";

    /**
     * Student is currently inactive, but is expected to return and continue with the given study program.
     */
    public static final String STUDYPLAN_STATUS_TEMPORARILY_INACTIVE = "10";

    /**
     * Student has graduated from this study program.
     */
    public static final String STUDYPLAN_STATUS_GRADUATED = "11";

    /**
     * Student has withdrawn from the given study program.
     */
    public static final String STUDYPLAN_STATUS_WITHDRAWN = "12";

    /**
     * Waiting for payment of the fees for the time unit (e.g. semester)
     */
    public static final String CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT = "5";

    /**
     * Waiting for the student to customize the subject selection at the beginning of the time unit. 
     */
    public static final String CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME = "7";

    /**
     * Waiting for the staff to approve/reject/request for change of the student's subjects selection. 
     */
    public static final String CARDINALTIMEUNIT_STATUS_WAITING_FOR_APPROVAL_OF_REGISTRATION = "8";

    /**
     * The subjects selection made by the student were rejected by the staff. The student may not make any further changes to the subjects selection.
     */
    public static final String CARDINALTIMEUNIT_STATUS_REJECTED_REGISTRATION = "9";

    /**
     * The student is correctly registered for the time unit. This is the normal state for active students.
     */
    public static final String CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED = "10";

    /**
     * The student is required to make modifications to the subjects selection for this time unit, before the selection can be approved.
     */
    public static final String CARDINALTIMEUNIT_STATUS_REQUEST_FOR_CHANGE = "20";

    public static final String STUDY_INTENSITY_PARTTIME = "P";
    public static final String STUDY_INTENSITY_FULLTIME = "F";

    public static final String ACTIVE = "Y";
    public static final String INACTIVE = "N";

    // TODO replace with ACTIVE / INACTIVE
    public static final String PERSON_ACTIVE = ACTIVE;
    public static final String PERSON_INACTIVE = INACTIVE;
    
    public static final String GENERAL_YES = "Y";
    public static final String GENERAL_NO = "N";
    
    public static final String RIGIDITY_COMPULSORY = "1";
    public static final String RIGIDITY_ELECTIVE = "3";
    
    public static final String RFC_ENTITY_TYPE_STUDY = "study";
    public static final String RFC_ENTITY_TYPE_STUDYGRADETYPE = "studygradetype";
    public static final String RFC_ENTITY_TYPE_STUDENT = "student";
    public static final String RFC_ENTITY_TYPE_STUDYPLANCARDINALTIMEUNIT = "studyplancardinaltimeunit";
    
    public static final String RFC_STATUS_CODE_NEW = "1";
    public static final String RFC_STATUS_CODE_RESOLVED = "2";
    public static final String RFC_STATUS_CODE_REFUSED = "3";

    /* NOTE: specific progress statuses moved to country specific constants file */
    public static final String PROGRESS_STATUS_CLEAR_PASS = "01";
    public static final String PROGRESS_STATUS_REPEAT = "03";
    public static final String PROGRESS_STATUS_AT_PARTTIME = "19";
    public static final String PROGRESS_STATUS_EXCLUDE_UNIVERSITY = "22";
    public static final String PROGRESS_STATUS_WITHDRAWN_WITH_PERMISSION = "23";
    public static final String PROGRESS_STATUS_GRADUATE = "25";
    public static final String PROGRESS_STATUS_PROCEED_AND_REPEAT = "27";
    public static final String PROGRESS_STATUS_TO_PARTTIME = "29";
    public static final String PROGRESS_STATUS_TO_FULLTIME = "31";
    public static final String PROGRESS_STATUS_EXCLUDE_SCHOOL = "34";
    public static final String PROGRESS_STATUS_EXCLUDE_PROGRAM = "35";
    public static final String PROGRESS_STATUS_WAITING_FOR_RESULTS = "54";
    
    public static final String FAILGRADE_INCOMPLETE = "IN";
    public static final String ATTACHMENT_RESULT = "AR";

    public static final String IMPORTANCE_TYPE_MAJOR = "1";
    public static final String IMPORTANCE_TYPE_MINOR = "2";
    
    public static final String STUDY_TIME_DAYTIME = "1";
    public static final String STUDY_TIME_EVENING = "2";
    public static final String STUDY_TIME_DAYTIME_EVENING = "3";
    
    public static final String STUDY_FORM_REGULAR = "1";
    public static final String STUDY_FORM_PARALLEL = "2";
    public static final String STUDY_FORM_DISTANT = "3";
    public static final String STUDY_FORM_VARIOUS_FORMS = "4";
    
    public static final String EMAIL_REGEX = 
        "^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*$"; 
    
    public static final String NOTETYPE_ACTIVITY_SHORT = "A";
    public static final String NOTETYPE_CAREER_SHORT = "C";
    public static final String NOTETYPE_PLACEMENT_SHORT = "P";
    public static final String NOTETYPE_COUNSELING_SHORT = "O";

    public static final String NOTETYPE_ACTIVITY = "StudentActivity";
    public static final String NOTETYPE_CAREER = "StudentCareer";
    public static final String NOTETYPE_PLACEMENT = "StudentPlacement";
    public static final String NOTETYPE_COUNSELING = "StudentCounseling";
    
    public static final String DISCIPLINEGROUP_CODE_MA_HRM = "1";
    public static final String DISCIPLINEGROUP_CODE_MBA_GENERAL = "2";
    public static final String DISCIPLINEGROUP_CODE_MBA_FINANCIAL = "3";
    public static final String DISCIPLINEGROUP_CODE_MSC_PM = "4";
    
    public static final String ROLE_STUDENT = "student";

    // ------------------------------------------------------------------------
    // NB: country specific settings such as phone, mobile phone and zip code
    // have been moved to country.properties
    // ------------------------------------------------------------------------
    
    
    /* 
     * Telephone (and fax) numbers (country-specific)
     * Mozambique: telephone (and fax) numbers exist of 8 numbers and do not start with a 0 (zero).
     */
    //public static final String PHONE_REGEX = "[0-9-]{9}";

    /* 
     * Telephone (and fax) numbers (country-specific)
     * Zambia: telephone (and fax) numbers exist of 9 numbers and do not start with a 0 (zero).
     */
//    public static final String PHONE_REGEX = "[0-9-]{10}";

    /* 
     * Telephone (and fax) numbers (country-specific)
     * Netherlands: telephone (and fax) numbers exist of 10 numbers and have a hyphen at third or fourth position
     */
    //public static final String PHONE_REGEX = "[0-9-]{11}";

    /* 
     * Mobile phone numbers (country-specific)
     * Mozambique: mobile phone numbers exist of 9 numbers and do not start with a 0 (zero).
     */
    //public static final String MOBILE_PHONE_REGEX = "[0-9-]{10}";

    /* 
     * Mobile phone numbers (country-specific)
     * Zambia: mobile phone numbers exist of 9 numbers and do not start with a 0 (zero).
     */
//    public static final String MOBILE_PHONE_REGEX = "[0-9-]{10}";

    /* 
     * Mobile phone numbers (country-specific)
     * Netherlands: mobile phone numbers exist of 10 numbers and have a hyphen at third position
     */
    //public static final String MOBILE_PHONE_REGEX = "[0-9-]{11}";

    /*
     * Zipcode ranges (country-specific)
     * Mozambique: zipcode ranges:
     * 		1100-1125, 1200-1211, 1300-1314, 2100-2116, 2200-2209,
     * 		2300-2313, 2400-2416, 3100-3120, 3200-3219, 3300-3314
     */
    //public static final String ZIP_CODE_REGEX =
    //    "11[0-1][0-9]|112[0-5]|120[0-9]|121[0-1]|130[0-9]|131[0-4]|210[0-9]|211[0-6]|220[0-9]|"
    //    + "230[0-9]|231[0-3]|240[0-9]|241[0-6]|31[0-1][0-9]|3120|32[0-1][0-9]|330[0-9]|331[0-4]";

    /*
     * Zipcode ranges (country-specific)
     * Zambia: zipcode format (5 digits): 19345
     */
//    public static final String ZIP_CODE_REGEX =
//    	"[0-9][0-9][0-9][0-9][0-9]";

    /*
     * Zipcode ranges (country-specific)
     * Netherlands: zipcode format: 1234AB 
     */
    //public static final String ZIP_CODE_REGEX = "[0-9][0-9][0-9][0-9][A-Za-z][A-Za-z]";

}
