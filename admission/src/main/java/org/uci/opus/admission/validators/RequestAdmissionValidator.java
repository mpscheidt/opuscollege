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
 * The Original Code is Opus-College admission module code.
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
package org.uci.opus.admission.validators;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.uci.opus.admission.web.form.RequestAdmissionForm;
import org.uci.opus.config.CountryProperties;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.DateUtil;
import org.uci.opus.util.OpusInit;
import org.uci.opus.util.StringUtil;

/**
 * Validator for {@link RequestAdmissionForm}.
 * 
 * @author MoVe
 */
@Component
public class RequestAdmissionValidator {

    public static final String EMAIL_REGEX = OpusConstants.EMAIL_REGEX;
    
    @Autowired
    private CountryProperties countryProperties;

    @Autowired
    private OpusInit opusInit;

    public boolean supports(final Class<?> clazz) {
        return RequestAdmissionForm.class.isAssignableFrom(clazz);
    }

    /**
     * {@inheritDoc}.
     * 
     * @see org.springframework.validation.Validator#validate( java.lang.Object, org.springframework.validation.Errors)
     */
    public void validate(final Object obj, final Errors errors) {

        this.onBindAndValidate(null, obj, errors);
    }

    /**
     * {@inheritDoc}.
     * 
     * @see org.springframework.validation.Validator#onBindAndValidate( javax.servlet.http.HttpServletRequest, java.lang.Object,
     *      org.springframework.validation.Errors)
     */
    public void onBindAndValidate(HttpServletRequest request, final Object obj, final Errors errors) {

        DateUtil du = new DateUtil();
        RequestAdmissionForm requestAdmissionForm = (RequestAdmissionForm) obj;

        /* surnameFull - required field */
        if ("".equals(errors.getFieldValue("student.surnameFull").toString())) {
            errors.rejectValue("student.surnameFull", "invalid.surnamefull.format");
        }
        /* firstnamesFull - required field */
        if ("".equals(errors.getFieldValue("student.firstnamesFull").toString())) {
            errors.rejectValue("student.firstnamesFull", "invalid.firstnames.format");
        }

        /* gender - required field & validity check */
        if ("".equals(errors.getFieldValue("student.genderCode").toString()) || "0".equals(errors.getFieldValue("student.genderCode").toString())) {
            errors.rejectValue("student.genderCode", "invalid.empty.format");
        } else {
            if (!"1".equals(errors.getFieldValue("student.genderCode").toString()) && !"2".equals(errors.getFieldValue("student.genderCode").toString())) {
                errors.rejectValue("student.genderCode", "invalid.gender.format");
            }
        }
        /* birthdate - validity check */
        if (!(du.isPastDateString((String) errors.getFieldValue("student.birthdate")))) {
            errors.rejectValue("student.birthdate", "invalid.date.past");
        }

        /* identificationTypeCode - required field */
        if ("".equals(errors.getFieldValue("student.identificationTypeCode").toString())
                || "0".equals(errors.getFieldValue("student.identificationTypeCode").toString())) {
            errors.rejectValue("student.identificationTypeCode", "invalid.identificationtype.format");
        }

        /* identificationNumber - required field */
        if ("".equals(errors.getFieldValue("student.identificationNumber").toString())) {
            errors.rejectValue("student.identificationNumber", "invalid.identificationnumber.format");
        }

        /* identificationDateOfIssue - validity check only if not empty */
        if (errors.getFieldValue("student.identificationDateOfIssue") != null && !"".equals(errors.getFieldValue("student.identificationDateOfIssue"))) {
            /*
             * if (!(su.isValidDate((Date) errors.getFieldValue("identificationDateOfIssue")))) {
             * errors.rejectValue("identificationDateOfIssue", "invalid.date.format"); }
             */
            if (!(du.isPastDateString((String) errors.getFieldValue("student.identificationDateOfIssue")))) {
                errors.rejectValue("student.identificationDateOfIssue", "invalid.date.past");
            }
        }
        /* identificationDateOfExpiration - validity check only if not empty */
        if (errors.getFieldValue("student.identificationDateOfExpiration") != null
                && !"".equals(errors.getFieldValue("student.identificationDateOfExpiration"))) {
            if (!(du.isFutureDateString((String) errors.getFieldValue("student.identificationDateOfExpiration")))) {
                errors.rejectValue("student.identificationDateOfExpiration", "invalid.date.future");
            }
        }

        /* primaryStudyId - required field */
        if ("".equals(errors.getFieldValue("student.primaryStudyId").toString()) || "0".equals(errors.getFieldValue("student.primaryStudyId").toString())) {
            errors.rejectValue("student.primaryStudyId", "invalid.study.format");
        }

        if ("".equals(errors.getFieldValue("studyPlanCardinalTimeUnit.studyGradeTypeId").toString())
                || "0".equals(errors.getFieldValue("studyPlanCardinalTimeUnit.studyGradeTypeId").toString())) {
            errors.rejectValue("studyPlanCardinalTimeUnit.studyGradeTypeId", "invalid.studygradetype.format");
        }

        if ("".equals(errors.getFieldValue("studyPlanCardinalTimeUnit.cardinalTimeUnitNumber").toString())
                || "0".equals(errors.getFieldValue("studyPlanCardinalTimeUnit.cardinalTimeUnitNumber").toString())) {
            errors.rejectValue("studyPlanCardinalTimeUnit.cardinalTimeUnitNumber", "invalid.cardinaltimeunitnumber.format");
        }

        /* ADDRESS */
        /* countryCode - required field */
        if (StringUtil.isNullOrEmpty((String) errors.getFieldValue("address.countryCode"), true)
                || "0".equals(errors.getFieldValue("address.countryCode").toString())) {
            errors.rejectValue("address.countryCode", "invalid.country.format");
        }
        /* provinceCode - required field except for foreign students, then the value is 0 */
        if (StringUtil.isNullOrEmpty((String) errors.getFieldValue("address.provinceCode"), true)) {
            errors.rejectValue("address.provinceCode", "invalid.province.format");
        }

        /* either the city, street, number and zipCode are required OR the POBox */
        /* city - required field */
        if (StringUtil.isNullOrEmpty((String) errors.getFieldValue("address.POBox"), true)) {

            if (StringUtil.isNullOrEmpty((String) errors.getFieldValue("address.city"), true)
                    || StringUtil.isNullOrEmpty((String) errors.getFieldValue("address.street"), true)
            // ||
            // "".equals(errors.getFieldValue("address.number").toString())
            // ||
            // "0".equals(errors.getFieldValue("address.number").toString())
            // ||
            // StringUtil.isNullOrEmpty((String)errors.getFieldValue("address.zipCode"), true)
            ) {
                errors.rejectValue("address.POBox", "jsp.requestadmission.error.address.or.po.box.required");
            }
        }

        /* number format validation - not required */
        if (!"".equals(errors.getFieldValue("address.number").toString()) && !"0".equals(errors.getFieldValue("address.number").toString())) {
            String addressNumber = String.valueOf(errors.getFieldValue("address.number"));
            if (StringUtil.checkValidInt(addressNumber) == -1) {
                errors.rejectValue("address.number", "invalid.housenumber.format");
            }
        }

        /* zipCode format validation - not required */
        String zipCodeRegex = countryProperties.getZipCodeRegex();
        if (errors.getFieldValue("address.zipCode") != null && !"".equals(errors.getFieldValue("address.zipCode"))) {
            if (!((String) errors.getFieldValue("address.zipCode")).matches(zipCodeRegex)) {
                errors.rejectValue("address.zipCode", "invalid.zipcode.format");
            }
        }

        /* phone and fax format validation */
        // String phoneRegex = countryProperties.getPhoneRegex();
        // if (errors.getFieldValue("address.telephone") != null
        // && !"".equals(errors.getFieldValue("address.telephone"))) {
        // if (!((String) errors.getFieldValue("address.telephone")).matches(phoneRegex)) {
        // errors.rejectValue("address.telephone", "invalid.telephone.format");
        // }
        // }
        // if (errors.getFieldValue("address.faxNumber") != null
        // && !"".equals(errors.getFieldValue("address.faxNumber"))) {
        // if (!((String) errors.getFieldValue("address.faxNumber")).matches(phoneRegex)) {
        // errors.rejectValue("address.faxNumber", "invalid.faxnumber.format");
        // }
        // }

        /* mobile phone - required field for ?? (if not organization) + format validation */
        // String mobilePhoneRegex = countryProperties.getMobilePhoneRegex();
        // if ("Y".equals((String)session.getAttribute("iMobilePhoneRequired"))
        // && errors.getFieldValue("address.addressTypeCode") != "4"
        // && errors.getFieldValue("address.addressTypeCode") != "5") {
        // if (errors.getFieldValue("address.mobilePhone") == null
        // || "".equals(errors.getFieldValue("address.mobilePhone"))) {
        // errors.rejectValue("address.mobilePhone", "invalid.mobilephone.format");
        // }
        // }
        // if (errors.getFieldValue("address.mobilePhone") != null
        // && !"".equals(errors.getFieldValue("address.mobilePhone"))) {
        // if (!((String) errors.getFieldValue("address.mobilePhone")).matches(mobilePhoneRegex)) {
        // errors.rejectValue("address.mobilePhone", "invalid.mobilephone.format");
        // }
        // }

        /* emailAddress - required field for ?? (if not organization) + format validation */
        // if ("Y".equals((String)session.getAttribute("iEmailAddressRequired"))
        if (opusInit.getEmailAddressRequired() && errors.getFieldValue("address.addressTypeCode") != "4"
                && errors.getFieldValue("address.addressTypeCode") != "5") {
            if (errors.getFieldValue("address.emailAddress") == null || "".equals(errors.getFieldValue("address.emailAddress"))) {
                errors.rejectValue("address.emailAddress", "invalid.email.format");
            }
        }
        if (errors.getFieldValue("address.emailAddress") != null && !"".equals(errors.getFieldValue("address.emailAddress"))) {
            if (!((String) errors.getFieldValue("address.emailAddress")).matches(EMAIL_REGEX)) {
                errors.rejectValue("address.emailAddress", "invalid.email.format");
            }
        }

        /*
         * if requesting admission for a master, 1st CTU, then a former discipline with endgrade is required
         */
        if (requestAdmissionForm.isGradeTypeIsMaster() && requestAdmissionForm.getStudyPlanCardinalTimeUnit().getCardinalTimeUnitNumber() == 1) {
            if (StringUtil.isNullOrEmpty((String) errors.getFieldValue("studyPlan.previousDiscipline.code"))) {
                errors.rejectValue("studyPlan.previousDiscipline.code", "invalid.empty.format");
            }
            // not always possible to make required?
            // if (StringUtil.isNullOrEmpty((String) errors.getFieldValue("studyPlan.previousDisciplineGrade") )) {
            // errors.rejectValue("studyPlan.previousDisciplineGrade", "invalid.empty.format");
            // }
        }
        du = null;

    }

}
