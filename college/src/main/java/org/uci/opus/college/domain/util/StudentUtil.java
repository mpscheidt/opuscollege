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

package org.uci.opus.college.domain.util;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.uci.opus.college.domain.Address;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.StudyPlan;
import org.uci.opus.college.domain.StudyPlanCardinalTimeUnit;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.StringUtil;

public abstract class StudentUtil {
   
	public static Student getStudentForStudentId(List < Student > allStudents, int studentId) {
		Student result = null;
		for (Iterator<Student> it = allStudents.iterator(); it.hasNext(); ) {
			Student st = it.next();
			if (st.getStudentId() == studentId) {
				result = st;
				break;
			}
		}
		return result;
	}

	public static StudyPlan getStudyPlanForStudyPlanId(List < StudyPlan > allStudyPlans, int studyPlanId) {
		StudyPlan result = null;
		for (Iterator<StudyPlan> it = allStudyPlans.iterator(); it.hasNext(); ) {
			StudyPlan sp = it.next();
			if (sp.getId() == studyPlanId) {
				result = sp;
				break;
			}
		}
		return result;
	}

    /**
     * Create a student object with an Address object,
     * both with some default values.
     * @return
     */
    public static Student newStudentWithStudyPlanAndAddress() {
        Student student = new Student();

        Address address = new Address();
        List<Address> addresses = new ArrayList<Address>(1);
        
        StudyPlan studyPlan = new StudyPlan();
        List<StudyPlan> studyPlans = new ArrayList<StudyPlan>(1);
        studyPlans.add(studyPlan);
        
        addresses.add(address);
        student.setAddresses(addresses);
        student.setStudyPlans(studyPlans);

        return student;
    }
    
    /* check used for students, conditions copied from studyPlan.jsp: 
     * - studyPlanStatus must be: approved admission or graduated
     * - studyPlanCTU progressStatus must be empty
     * - user must have role: UPDATE_STUDENT_SUBSCRIPTION_DATA or CREATE_STUDENT_SUBSCRIPTION_DATA or REVERSE_PROGRESS_STATUS
     *   or
     *   user must be the student and CTUstatus must be on of the following:
     *     - waiting for payment
     *     - customize programme
     *     - actively registered
     * 
     */
    public static boolean isEditableStudyPlanCTU(HttpServletRequest request, String studyPlanStatusCode, StudyPlanCardinalTimeUnit studyPlanCTU, boolean isOpusUserThisStudent ) {
        boolean isEditableStudyPlanCTU = false;
        
        if (
                (studyPlanStatusCode.equals(OpusConstants.STUDYPLAN_STATUS_APPROVED_ADMISSION)
                || studyPlanStatusCode.equals(OpusConstants.STUDYPLAN_STATUS_GRADUATED)
                )
            && (
                    (request.isUserInRole("UPDATE_STUDENT_SUBSCRIPTION_DATA") 
                            || request.isUserInRole("CREATE_STUDENT_SUBSCRIPTION_DATA")
                            || request.isUserInRole("REVERSE_PROGRESS_STATUS"))
                    || 
                    (isOpusUserThisStudent     
                            && (studyPlanCTU.getCardinalTimeUnitStatusCode().equals(OpusConstants.CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT)
                                ||studyPlanCTU.getCardinalTimeUnitStatusCode().equals(OpusConstants.CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME)
                                ||studyPlanCTU.getCardinalTimeUnitStatusCode().equals(OpusConstants.CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED)
                                ) 
                     )
               )
            && StringUtil.isNullOrEmpty(studyPlanCTU.getProgressStatusCode())
           ) {
            isEditableStudyPlanCTU = true;
        }
        return isEditableStudyPlanCTU;
    }

    /**
     * This method sets common default values on the given student
     * if they are null.
     * @param student
     */
    public static void setDefaultValues(Student student) {
        if (student.getActive() == null) student.setActive("Y");
        if (student.getForeignStudent() == null) student.setForeignStudent("N");
        if (student.getRelativeOfStaffMember() == null) student.setRelativeOfStaffMember("N");
        if (student.getRuralAreaOrigin() == null) student.setRuralAreaOrigin("N");
        if (student.getScholarship() == null) student.setScholarship("N");
        if (student.getRegistrationDate() == null) student.setRegistrationDate(new Date());
        if (student.getDateOfEnrolment() == null) student.setDateOfEnrolment(new Date());
        if (student.getSubscriptionRequirementsFulfilled() == null) student.setSubscriptionRequirementsFulfilled("Y");
    }

    /**
     * This method sets common default values on the given address
     * if they are null.
     * @param student
     */
    public static void setDefaultValues(Address address) {
        if (address.getAddressTypeCode() == null) address.setAddressTypeCode("1");
        if (address.getProvinceCode() == null) address.setProvinceCode("0");
        if (address.getDistrictCode() == null) address.setDistrictCode("0");
        if (address.getCountryCode() == null) address.setCountryCode("0");
        if (address.getEmailAddress() == null) address.setEmailAddress("");
        if (address.getTelephone() == null) address.setTelephone("");
        if (address.getZipCode() == null) address.setZipCode("");
        if (address.getFaxNumber() == null) address.setFaxNumber("");
        if (address.getMobilePhone() == null)  address.setMobilePhone("");
    }
    
}
