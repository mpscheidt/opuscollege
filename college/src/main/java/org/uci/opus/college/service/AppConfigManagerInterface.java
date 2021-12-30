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
 * Center for Information Services, Radboud University Nijmegen
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

package org.uci.opus.college.service;

import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.uci.opus.college.domain.AppConfigAttribute;

public interface AppConfigManagerInterface {

    public static final String ADMINISTRATOR_MAIL_ADDRESS = "administratorMailAddress";
    public static final String DEFAULT_ADMINISTRATOR_MAIL_ADDRESS = "";

    public static final String APP_LANGUAGES = "app_languages";
    public static final List<String> APP_LANGUAGES_DEFAULT = Arrays.asList("en", "pt");

    public static final String COUNTRY_CODE = "country.code";
    public static final String COUNTRY_CODE_DEFAULT = null;

    /**
     * The default value for {@link #NUMBER_OF_DAYS_TO_ENTER_RESULTS_BY_ASSIGNED_STAFF_MEMBER}
     */
    public static final int DEFAULT_NUMBER_OF_DAYS_TO_ENTER_RESULTS_BY_ASSIGNED_STAFF_MEMBER = 15;

    /**
     * If defined, then the given value is used as business rule to determine if tests have been passed or not, if no test-specific value is
     * specified. Setting this value to 0 has the effect that tests are always passed unless a test-specific business rule is set.
     * 
     * <p>
     * If not defined (or null) then the higher level business rule applies, ie. the rules for passing given by studyGradeType, subject and
     * examination (lowest level specification wins).
     */
    public static final String DEFAULT_BR_PASSING_TEST = "defaultBrPassingTest";

    /**
     * Round examination result to the given number of digits after the comma.
     * Negative values or {@code null} mean no formatting (to avoid loss of precision)
     */
    public static final String EXAMINATION_RESULT_SCALE = "examinationResultScale";

    /**
     * Default value for {@link #EXAMINATION_RESULT_SCALE}.
     */
    public static final int EXAMINATION_RESULT_SCALE_DEFAULT = -1;

    /**
     * Examination results report available in result screens.
     */
    public static final String EXAMINATION_RESULTS_REPORT = "examinationResultsReport";

    /**
     * Default value for {@link #EXAMINATION_RESULTS_REPORT}.
     */
    public static final String EXAMINATION_RESULTS_REPORT_DEFAULT = "result/ExaminationResults";

    /**
     * The number of times a wrong password can be entered before the account is locked.
     */
    public static final String MAX_FAILED_LOGIN_ATTEMPTS = "maxFailedLoginAttempts";

    /**
     * The default value for {@link #MAX_FAILED_LOGIN_ATTEMPTS} if not set.
     */
    public static final int MAX_FAILED_LOGIN_ATTEMPTS_DEFAULT = 5;

    /**
     * The maximum number of failed test results per examination. If more than this number of test results are failed, the examination
     * result will not be calculated.
     * 
     * <p>
     * -1: Unlimited number of failed tests is allowed, ie. the examination result can always be calculated.
     * 
     * <p>
     * 0: A single failed tests will result in the calculation of a negative examination result
     * 
     * <p>
     * n > 0: If more than n tests were failed, the examination result is negative
     */
    public static final String MAX_FAILED_TEST_RESULTS = "maxFailedTestResults";

    /**
     * Default value for {@link #MAX_FAILED_TEST_RESULTS}
     */
    public static final int DEFAULT_MAX_FAILED_TEST_RESULTS = -1;

    /**
     * The number of days that staff Members are allowed to enter results.
     */
    public static final String NUMBER_OF_DAYS_TO_ENTER_RESULTS_BY_ASSIGNED_STAFF_MEMBER = "numberOfDaysToEnterResultsByAssignedStaffMember";

    public static final String SECONDARY_SCHOOL_SUBJECTS_COUNT = "secondarySchoolSubjects.count";
    public static final int SECONDARY_SCHOOL_SUBJECTS_COUNT_DEFAULT = 0;

    public static final String SECONDARY_SCHOOL_SUBJECTS_HIGHEST_GRADE = "secondarySchoolSubjects.highestGrade";
    public static final int SECONDARY_SCHOOL_SUBJECTS_HIGHEST_GRADE_DEFAULT = 1;

    public static final String SECONDARY_SCHOOL_SUBJECTS_LOWEST_GRADE = "secondarySchoolSubjects.lowestGrade";
    public static final int SECONDARY_SCHOOL_SUBJECTS_LOWEST_GRADE_DEFAULT = 6;

    public static final String SECONDARY_SCHOOL_SUBJECTS_WEIGHT = "secondarySchoolSubjects.weight";
    public static final boolean SECONDARY_SCHOOL_SUBJECTS_WEIGHT_DEFAULT = true;

    /**
     * Round subject result to the given number of digits after the comma.
     */
    public static final String SUBJECT_RESULT_SCALE = "subjectResultScale";

    /**
     * Default value for {@link #SUBJECT_RESULT_SCALE}.
     */
    public static final int SUBJECT_RESULT_SCALE_DEFAULT = 1;

    /**
     * Subject results report available in result screens.
     */
    public static final String SUBJECT_RESULTS_REPORT = "subjectResultsReport";

    /**
     * Default value for {@link #SUBJECT_RESULTS_REPORT}.
     */
    public static final String SUBJECT_RESULTS_REPORT_DEFAULT = "result/StudentsResults";

    /**
     * Test results report available in result screens.
     */
    public static final String TEST_RESULTS_REPORT = "testResultsReport";

    /**
     * Default value for {@link #TEST_RESULTS_REPORT}.
     */
    public static final String TEST_RESULTS_REPORT_DEFAULT = "result/TestResults";

    /**
     * Flag if end grades shall be used at all.
     * 
     * This flag is primarily to speed up things for those instances that do not use end grades by avoiding unnecessary database queries.
     */
    public static final String USE_END_GRADES = "useEndGrades";
    public static final boolean USE_END_GRADES_DEFAULT = true;

    /**
     * Automatically generate the subject result as soon as possible, that is, when all required examination results are available.
     */
    public static final String AUTO_GENERATE_SUBJECT_RESULT = "autoGenerateSubjectResult";
    public static final boolean AUTO_GENERATE_SUBJECT_RESULT_DEFAULT = true;

    /**
     * Find the current application config attributes.
     * 
     * @return list of config attributes
     */
    List<AppConfigAttribute> getAppConfig();

    List<Map<String, Object>> findAppConfigAsMaps(Map<String, Object> map);

    /**
     * Finds appConfigAttribute based on name
     * 
     * @param appConfigAttributeName
     * @return
     */
    AppConfigAttribute findAppConfigAttribute(String appConfigAttributeName);

    /**
     * First look for the specific value for the given branchId, if none found, look for the one without branchId.
     */
    AppConfigAttribute findAppConfigAttribute(String appConfigAttributeName, Integer branchId);

    AppConfigAttribute findOne(int appConfigAttributeId);

    void updateAppConfigAttribute(AppConfigAttribute appConfigAttribute);

    /**
     * Update the appConfig attribute in the database with the given value.
     */
    void updateAppConfigAttribute(String attributeName, String value);

    void updateAppConfigAttribute(String attributeName, boolean value);

    /**
     * @see #APP_LANGUAGES
     */
    List<String> getAppLanguages();

    /**
     * @see #COUNTRY_CODE
     */
    String getCountryCode();
    
    /**
     * Convenience method:
     * Get the different languages made up of two letter codes, e.g. "en", "pt".
     * For example: If "en_ZM" is part of appLanguages, "en" would be returned.
     * If both "en_ZM" and "en" are part of appLanguages, only "en" is be returned.
     * 
     * @see #getAppLanguages()
     */
    List<String> getAppLanguagesShort();

    /**
     * Get the "admissionInitialStudyPlanStatus" attribute
     * 
     * @return
     */
    AppConfigAttribute getAdmissionInitialStudyPlanStatusAttribute();

    /**
     * Get the value of the "admissionInitialStudyPlanStatus" attribute
     * 
     * @return
     */
    String getAdmissionInitialStudyPlanStatus();

    /**
     * Get the "cntdRegistrationInitialCardinalTimeUnitStatus" attribute
     * 
     * @return
     */
    AppConfigAttribute getCntdRegistrationInitialCardinalTimeUnitStatusAttribute();

    /**
     * True (Y) if the (dean) approval is required even if student subscribes to default set of subjects.
     * 
     * <p>
     * False (N) if approval is only required when student makes changes to default set of subjects, e.g. adding elective subjects.
     * 
     * @return
     */
    boolean getCntdRegistrationAutoApproveDefaultSubjects();

    /**
     * Initial status of a studyplancardinaltimeunit in continued registration (depending on codes in status table)
     * 
     * @return
     */
    String getCntdRegistrationInitialCardinalTimeUnitStatus();

    /**
     * Round examination result to the given number of digits after the comma.
     * 
     * @see #EXAMINATION_RESULT_SCALE
     */
    int getExaminationResultScale();

    /**
     * Get the "maxUploadSizeImage" attribute
     * 
     * @return
     */
    AppConfigAttribute getMaxUploadSizeImageAttribute();

    /**
     * Max upload size images
     * 
     * @return
     */
    int getMaxUploadSizeImage();

    /**
     * Get the "maxUploadSizeDoc" attribute
     * 
     * @return
     */
    AppConfigAttribute getMaxUploadSizeDocAttribute();

    /**
     * Max upload size documents.
     * 
     * @return
     */
    int getMaxUploadSizeDoc();

    /**
     * Get the default date from when on are results visible to students if no result visibility date has (yet) been defined per school.
     * Example values: 1970-01-01: always visible 2099-01-01: never visible
     * 
     * @return
     */
    Date getDefaultResultsPublishDate();

    /**
     * @return the {@link AppConfigManagerInterface#MAX_FAILED_LOGIN_ATTEMPTS} attribute.
     */
    AppConfigAttribute getMaxFailedLoginAttemptsAttribute();

    /**
     * The value of {@link #MAX_FAILED_LOGIN_ATTEMPTS}.
     * 
     * @return
     */
    int getMaxFailedLoginAttempts();

    /**
     * Round subject result to the given number of digits after the comma.
     * 
     * @return
     * @see #SUBJECT_RESULT_SCALE
     */
    AppConfigAttribute getSubjectResultScaleAttribute();

    /**
     * @see #SUBJECT_RESULT_SCALE
     */
    int getSubjectResultScale();

    /**
     * 
     * @return
     */
    AppConfigAttribute getNumberOfDaysToEnterResultsByAssignedStaffMemberAttribute();

    /**
     * The number of days that staff Members are allowed to enter results.
     * 
     * @return
     */
    int getNumberOfDaysToEnterResultsByAssignedStaffMember();

    /**
     * 
     * @return
     */
    AppConfigAttribute getAdministratorMailAddressAttribute();

    /**
     * 
     * @return
     */
    String getAdministratorMailAddress();

    /**
     * Get the value of the sysoption {@link #DEFAULT_BR_PASSING_TEST}.
     * 
     * @return
     */
    String getDefaultBrPassingTest();

    /**
     * @see #MAX_FAILED_TEST_RESULTS
     */
    int getMaxFailedTestResults();

    /**
     * @see #SUBJECT_RESULTS_REPORT
     */
    String getSubjectResultsReport();

    /**
     * @see #EXAMINATION_RESULTS_REPORT
     */
    String getExaminationResultsReport();

    /**
     * @see #TEST_RESULTS_REPORT
     */
    String getTestResultsReport();

    /**
     * @see #USE_END_GRADES
     */
    boolean getUseEndGrades();

    /**
     * @see #AUTO_GENERATE_SUBJECT_RESULT
     */
    boolean getAutoGenerateSubjectResult();
    
    int getSecondarySchoolSubjectsCount();
    int getSecondarySchoolSubjectsHighestGrade();
    int getSecondarySchoolSubjectsLowestGrade();
    boolean isSecondarySchoolSubjectsWeight();

}
