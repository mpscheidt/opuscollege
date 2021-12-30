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

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.AppConfigAttribute;
import org.uci.opus.college.persistence.AppConfigMapper;
import org.uci.opus.util.StringUtil;

public class AppConfigManager implements AppConfigManagerInterface {

    @Autowired
    private AppConfigMapper appConfigMapper;

    @Override
    public List<AppConfigAttribute> getAppConfig() {

        List<AppConfigAttribute> appConfig = null;

        appConfig = (List<AppConfigAttribute>) appConfigMapper.getAppConfig();

        return appConfig;
    }

    @Override
    public List<Map<String, Object>> findAppConfigAsMaps(Map<String, Object> map) {
        return appConfigMapper.findAppConfigAsMaps(map);
    }

    // TODO include date into the query: startdate <= date <= enddate 
    //      see AcademicYear.findRequestAdmissionNumberOfSubjectsToGrade query for how to do that
    @Override
    public AppConfigAttribute findAppConfigAttribute(String appConfigAttributeName) {
        return findAppConfigAttribute(appConfigAttributeName, null);
    }
    
    @Override
    public AppConfigAttribute findAppConfigAttribute(String appConfigAttributeName, Integer branchId) {

        Map<String,Object> map = new HashMap<>();
        map.put("appConfigAttributeName", appConfigAttributeName);
        map.put("branchId", branchId);
        AppConfigAttribute appConfig = appConfigMapper.findAppConfigAttribute(map);

        // if nothing was found and branchId was specified, then try without branchId
        if (appConfig == null && branchId != null) {
            return findAppConfigAttribute(appConfigAttributeName);
        }

        return appConfig; 
    }

    @Override
    public AppConfigAttribute findOne(int appConfigAttributeId) {
        return appConfigMapper.findOne(appConfigAttributeId);
    }

    @Override
    public void updateAppConfigAttribute(AppConfigAttribute appConfigAttribute) {
        appConfigMapper.updateAppConfigAttribute(appConfigAttribute);
    }

    @Override
    public void updateAppConfigAttribute(String attributeName, String value) {
        AppConfigAttribute attribute = findAppConfigAttribute(attributeName);
        attribute.setAppConfigAttributeValue(value);
        updateAppConfigAttribute(attribute);
    }
    
    @Override
    public void updateAppConfigAttribute(String attributeName, boolean value) {
        updateAppConfigAttribute(attributeName, String.valueOf(value));
    }

    @Override
    public List<String> getAppLanguages() {
        return getListOfStrings(APP_LANGUAGES, APP_LANGUAGES_DEFAULT);
    }

    @Override
    public List<String> getAppLanguagesShort() {
        List<String> appLanguagesShort = new ArrayList<>();
        
        for (String appLanguage : getAppLanguages()) {
            String langShort = appLanguage.length() > 2 ? appLanguage.substring(0, 2) : appLanguage;
            if (!appLanguagesShort.contains(langShort)) {
                appLanguagesShort.add(langShort);
            }
        }
        
        return appLanguagesShort;
    }

    @Override
    public String getCountryCode() {
        return getString(COUNTRY_CODE, COUNTRY_CODE_DEFAULT);
    }

    @Override
    public AppConfigAttribute getAdmissionInitialStudyPlanStatusAttribute() {
        return findAppConfigAttribute("admissionInitialStudyPlanStatus");
    }

    @Override
    public String getAdmissionInitialStudyPlanStatus() {
        AppConfigAttribute appConfigAttribute = getAdmissionInitialStudyPlanStatusAttribute();
        return appConfigAttribute.getAppConfigAttributeValue();
    }

    @Override
    public boolean getCntdRegistrationAutoApproveDefaultSubjects() {

        AppConfigAttribute appConfigAttribute = findAppConfigAttribute("cntdRegistrationAutoApproveDefaultSubjects");
        String value = appConfigAttribute.getAppConfigAttributeValue();

        // default value: False
        return !StringUtil.isNullOrEmpty(value, true) && "Y".equalsIgnoreCase(value.trim());
    }

    @Override
    public AppConfigAttribute getCntdRegistrationInitialCardinalTimeUnitStatusAttribute() {
        return findAppConfigAttribute("cntdRegistrationInitialCardinalTimeUnitStatus");
    }

    @Override
    public String getCntdRegistrationInitialCardinalTimeUnitStatus() {
        AppConfigAttribute appConfigAttribute = getCntdRegistrationInitialCardinalTimeUnitStatusAttribute();
        return appConfigAttribute.getAppConfigAttributeValue();
    }
    
    @Override
    public int getExaminationResultScale() {
    	return getInt(EXAMINATION_RESULT_SCALE, EXAMINATION_RESULT_SCALE_DEFAULT);
    }

    @Override
    public AppConfigAttribute getMaxUploadSizeImageAttribute() {
        return findAppConfigAttribute("maxUploadSizeImage");
    }

    @Override
    public int getMaxUploadSizeImage() {
        AppConfigAttribute appConfigAttribute = getMaxUploadSizeImageAttribute();
        return Integer.parseInt(appConfigAttribute.getAppConfigAttributeValue());
    }

    @Override
    public AppConfigAttribute getMaxUploadSizeDocAttribute() {
        return findAppConfigAttribute("maxUploadSizeDoc");
    }

    @Override
    public int getMaxUploadSizeDoc() {
        AppConfigAttribute appConfigAttribute = getMaxUploadSizeDocAttribute();
        return Integer.parseInt(appConfigAttribute.getAppConfigAttributeValue());
    }

    @Override
    public Date getDefaultResultsPublishDate() {
        AppConfigAttribute appConfigAttribute = findAppConfigAttribute("defaultResultsPublishDate");
        SimpleDateFormat parserSDF = new SimpleDateFormat("yyyy-MM-dd");
        try {
            return parserSDF.parse(appConfigAttribute.getAppConfigAttributeValue());
        } catch (ParseException e) {
            throw new AppConfigRuntimeException("Unable to convert attribute value to Date", e);
        }
    }

    @Override
    public AppConfigAttribute getMaxFailedLoginAttemptsAttribute() {
        return findAppConfigAttribute(AppConfigManagerInterface.MAX_FAILED_LOGIN_ATTEMPTS);
    }

    @Override
    public int getMaxFailedLoginAttempts() {
        AppConfigAttribute appConfigAttribute = getMaxFailedLoginAttemptsAttribute();
        return appConfigAttribute == null ? AppConfigManagerInterface.MAX_FAILED_LOGIN_ATTEMPTS_DEFAULT : Integer.parseInt(appConfigAttribute.getAppConfigAttributeValue());
    }

    @Override
    public AppConfigAttribute getSubjectResultScaleAttribute() {
        return findAppConfigAttribute(AppConfigManagerInterface.SUBJECT_RESULT_SCALE);
    }

    @Override
    public int getSubjectResultScale() {
        AppConfigAttribute appConfigAttribute = getSubjectResultScaleAttribute();
        return appConfigAttribute == null ? AppConfigManagerInterface.SUBJECT_RESULT_SCALE_DEFAULT : Integer.parseInt(appConfigAttribute.getAppConfigAttributeValue());
    }

	@Override
	public AppConfigAttribute getNumberOfDaysToEnterResultsByAssignedStaffMemberAttribute() {
		return findAppConfigAttribute(NUMBER_OF_DAYS_TO_ENTER_RESULTS_BY_ASSIGNED_STAFF_MEMBER);
	}

	@Override
	public int getNumberOfDaysToEnterResultsByAssignedStaffMember() {
		AppConfigAttribute appConfigAttribute = getNumberOfDaysToEnterResultsByAssignedStaffMemberAttribute();
        return appConfigAttribute == null ? AppConfigManagerInterface.DEFAULT_NUMBER_OF_DAYS_TO_ENTER_RESULTS_BY_ASSIGNED_STAFF_MEMBER : Integer.parseInt(appConfigAttribute.getAppConfigAttributeValue());
	}

	@Override
	public AppConfigAttribute getAdministratorMailAddressAttribute() {
	    return findAppConfigAttribute(ADMINISTRATOR_MAIL_ADDRESS);
	}

	@Override
	public String getAdministratorMailAddress() {
        AppConfigAttribute appConfigAttribute = getAdministratorMailAddressAttribute();
        return appConfigAttribute == null ? AppConfigManagerInterface.DEFAULT_ADMINISTRATOR_MAIL_ADDRESS : appConfigAttribute.getAppConfigAttributeValue();
	}

	@Override
	public String getDefaultBrPassingTest() {
	    AppConfigAttribute appConfigAttribute = findAppConfigAttribute(DEFAULT_BR_PASSING_TEST);
	    return appConfigAttribute == null ? null : appConfigAttribute.getAppConfigAttributeValue();
	}

    @Override
    public int getMaxFailedTestResults() {
        return getInt(MAX_FAILED_TEST_RESULTS, DEFAULT_MAX_FAILED_TEST_RESULTS);
    }

	private Integer getInt(String attr, Integer defaultValue) {
	    String value = getString(attr);
	    return value == null ? defaultValue : Integer.parseInt(value);
	}

    private Boolean getBoolean(String attr, boolean defaultValue) {
        String value = getString(attr);
        return value == null ? defaultValue : "Y".equalsIgnoreCase(value.trim());
    }

    private Boolean getBoolean(String attr, int branchId, boolean defaultValue) {
        String value = getString(attr, branchId);
        return value == null ? defaultValue : "Y".equalsIgnoreCase(value.trim());
    }

    private List<String> getListOfStrings(String attr, List<String> defaultValue) {
        String value = getString(attr);
        
        // regular expression ",[ ]*" will trim the split values
        // see: http://stackoverflow.com/a/10631738/606662
        return value == null ? defaultValue : Arrays.asList(value.split(",[ ]*"));
    }

    private String getString(String attr, String defaultValue) {
        String value = getString(attr);
        return value == null ? defaultValue : value;
    }

	private String getString(String attr) {
        AppConfigAttribute appConfigAttribute = findAppConfigAttribute(attr);
        return appConfigAttribute == null ? null : appConfigAttribute.getAppConfigAttributeValue();
	}

    private String getString(String attr, Integer branchId) {
        AppConfigAttribute appConfigAttribute = findAppConfigAttribute(attr, branchId);
        return appConfigAttribute == null ? null : appConfigAttribute.getAppConfigAttributeValue();
    }

    @Override
    public String getSubjectResultsReport() {
        return getString(SUBJECT_RESULTS_REPORT, SUBJECT_RESULTS_REPORT_DEFAULT);
    }

    @Override
    public String getExaminationResultsReport() {
        return getString(EXAMINATION_RESULTS_REPORT, EXAMINATION_RESULTS_REPORT_DEFAULT);
    }

    @Override
    public String getTestResultsReport() {
        return getString(TEST_RESULTS_REPORT, TEST_RESULTS_REPORT_DEFAULT);
    }

    @Override
    public boolean getUseEndGrades() {
        return getBoolean(USE_END_GRADES, USE_END_GRADES_DEFAULT);
    }

    @Override
    public boolean getAutoGenerateSubjectResult() {
        return getBoolean(AUTO_GENERATE_SUBJECT_RESULT, AUTO_GENERATE_SUBJECT_RESULT_DEFAULT);
    }

    @Override
    public int getSecondarySchoolSubjectsCount() {
        return getInt(SECONDARY_SCHOOL_SUBJECTS_COUNT, SECONDARY_SCHOOL_SUBJECTS_COUNT_DEFAULT);
    }

    @Override
    public int getSecondarySchoolSubjectsHighestGrade() {
        return getInt(SECONDARY_SCHOOL_SUBJECTS_HIGHEST_GRADE, SECONDARY_SCHOOL_SUBJECTS_HIGHEST_GRADE_DEFAULT);
    }

    @Override
    public int getSecondarySchoolSubjectsLowestGrade() {
        return getInt(SECONDARY_SCHOOL_SUBJECTS_LOWEST_GRADE, SECONDARY_SCHOOL_SUBJECTS_LOWEST_GRADE_DEFAULT);
    }

    @Override
    public boolean isSecondarySchoolSubjectsWeight() {
        return getBoolean(SECONDARY_SCHOOL_SUBJECTS_WEIGHT, SECONDARY_SCHOOL_SUBJECTS_WEIGHT_DEFAULT);
    }

}
