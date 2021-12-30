<%--
***** BEGIN LICENSE BLOCK *****
Version: MPL 1.1/GPL 2.0/LGPL 2.1

The contents of this file are subject to the Mozilla Public License Version
1.1 (the "License"); you may not use this file except in compliance with
the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
for the specific language governing rights and limitations under the
License.

The Original Code is Opus-College admission module code.

The Initial Developer of the Original Code is
Center for Information Services, Radboud University Nijmegen.
Portions created by the Initial Developer are Copyright (C) 2008
the Initial Developer. All Rights Reserved.

Contributor(s):
  For Java files, see Javadoc @author tags.

Alternatively, the contents of this file may be used under the terms of
either the GNU General Public License Version 2 or later (the "GPL"), or
the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
in which case the provisions of the GPL or the LGPL are applicable instead
of those above. If you wish to allow use of your version of this file only
under the terms of either the GPL or the LGPL, and not to allow others to
use your version of this file under the terms of the MPL, indicate your
decision by deleting the provisions above and replace them with the notice
and other provisions required by the GPL or the LGPL. If you do not delete
the provisions above, a recipient may use your version of this file under
the terms of any one of the MPL, the GPL or the LGPL.

***** END LICENSE BLOCK *****
--%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<!--  personal data --> 
<spring:bind path="requestAdmissionForm.student.surnameFull">
<tr>
    <td class="label"><fmt:message key="jsp.general.surname" /></td>
    <td class="required"><input type="text" name="${status.expression}" id="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
    <td><%@ include file="../includes/errorMessages.jsp" %></td>
</tr>
</spring:bind>
<spring:bind path="requestAdmissionForm.student.firstnamesFull">
<tr>
    <td class="label"><fmt:message key="jsp.general.firstnames" /></td>
    <td class="required"><input type="text" name="${status.expression}" id="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
    <td><%@ include file="../includes/errorMessages.jsp" %></td>
</tr>
</spring:bind>
<spring:bind path="requestAdmissionForm.student.firstnamesAlias">
<tr>
    <td class="label"><fmt:message key="jsp.general.aliasfirstnames" /></td>
    <td><input type="text" name="${status.expression}" id="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
    <td><%@ include file="../includes/errorMessages.jsp" %></td>
</tr>
</spring:bind>
<spring:bind path="requestAdmissionForm.student.nationalRegistrationNumber">
<tr>
    <td class="label"><fmt:message key="jsp.general.nationalregistrationnumber" /></td>
    <td class="required"><input type="text" name="${status.expression}" id="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
    <td><%@ include file="../includes/errorMessages.jsp" %></td>
</tr>
</spring:bind>
<spring:bind path="requestAdmissionForm.student.civilTitleCode">
<tr>
    <td class="label"><fmt:message key="jsp.general.civiltitle" /></td>
    <td>
        <select name="${status.expression}" id="${status.expression}">
            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            <c:forEach var="civilTitle" items="${allCivilTitles}">
                <c:choose>
                    <c:when test="${civilTitle.code == status.value}">
                        <option value="${civilTitle.code}" selected="selected">${civilTitle.description}</option>
                    </c:when>
                    <c:otherwise>
                        <option value="${civilTitle.code}">${civilTitle.description}</option>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </select>
    </td>
    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
</tr>
</spring:bind>
<spring:bind path="requestAdmissionForm.student.previousInstitutionFinalGradeTypeCode">
<tr>
    <td class="label"><fmt:message key="jsp.general.academictitle" /></td>
    <td>
        <select name="${status.expression}" id="${status.expression}">
            <option value="0"><fmt:message key="jsp.selectbox.choose.ifapplicable" /></option>
            <c:forEach var="gradeType" items="${requestAdmissionForm.allGradeTypes}">
                <c:choose>
                    <c:when test="${gradeType.code == status.value && gradeType.title != ''}">
                        <option value="${gradeType.code}" selected="selected">${gradeType.title}</option>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${gradeType.title != ''}">
                                <option value="${gradeType.code}">${gradeType.title}</option>
                            </c:when>
                        </c:choose>
                     </c:otherwise>
                </c:choose>
             </c:forEach>
        </select>
    </td>
    <td><%@ include file="../includes/errorMessages.jsp" %></td>
</tr>
</spring:bind>
<spring:bind path="requestAdmissionForm.student.genderCode">
<tr>
    <td class="label"><fmt:message key="jsp.general.gender" /></td>
    <td class="required">
        <select name="${status.expression}">
            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            <c:forEach var="gender" items="${allGenders}">
                <c:choose>
                    <c:when test="${gender.code == status.value}">
                        <option value="${gender.code}" selected="selected">${gender.description}</option>
                    </c:when>
                    <c:otherwise>
                        <option value="${gender.code}">${gender.description}</option>
                    </c:otherwise>
                </c:choose>
             </c:forEach>
        </select>
    </td>
    <td><%@ include file="../includes/errorMessages.jsp" %></td>
</tr>
</spring:bind>
<spring:bind path="requestAdmissionForm.student.birthdate">
<tr>
    <td class="label"><fmt:message key="jsp.general.birthdate" /></td>
    <td class="required">
        <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
        <table>
        <tr>
        	<td><fmt:message key="jsp.general.day" /></td>
        	<td><fmt:message key="jsp.general.month" /></td>
        	<td><fmt:message key="jsp.general.year" /></td>
        </tr>
         <tr>
        	<td><input type="text" id="birth_day" name="birth_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />"  onchange="updateFullDate('student.birthdate','day',document.getElementById('birth_day').value);"  /></td>
            <td><input type="text" id="birth_month" name="birth_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('student.birthdate','month',document.getElementById('birth_month').value);" /></td>
            <td><input type="text" id="birth_year" name="birth_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />"  onchange="updateFullDate('student.birthdate','year',document.getElementById('birth_year').value);" /></td>
        </tr>
        </table>
    </td>
    <td>
        <fmt:message key="jsp.general.message.dateformat" />
        <td><%@ include file="../includes/errorMessages.jsp" %></td>
    </td>
</tr>
</spring:bind>

<!--  background -->
<spring:bind path="requestAdmissionForm.student.nationalityCode">
<tr>
    <td class="label"><fmt:message key="jsp.general.nationality" /></td>
    <td>
        <select name="${status.expression}" id="${status.expression}">
            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            <c:forEach var="nationality" items="${allNationalities}">
                <c:choose>
                    <c:when test="${nationality.code == status.value}">
                        <option value="${nationality.code}" selected="selected">${nationality.description}</option>
                    </c:when>
                    <c:otherwise>
                        <option value="${nationality.code}">${nationality.description}</option>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </select>
    </td>
    <td><%@ include file="../includes/errorMessages.jsp" %></td>
</tr>
</spring:bind>

<!-- identification --> 
<spring:bind path="requestAdmissionForm.student.identificationTypeCode">
<tr>
    <td class="label"><fmt:message key="jsp.general.identificationtype" /></td>
    <td class="required">
        <select name="${status.expression}" id="${status.expression}">
            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            <c:forEach var="identificationType" items="${allIdentificationTypes}">
                <c:choose>
                    <c:when test="${identificationType.code == status.value}">
                        <option value="${identificationType.code}" selected="selected">${identificationType.description}</option>
                    </c:when>
                    <c:otherwise>
                        <option value="${identificationType.code}">${identificationType.description}</option>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </select>
    </td> 
    <td><%@ include file="../includes/errorMessages.jsp" %></td>
</tr>
</spring:bind>
<spring:bind path="requestAdmissionForm.student.identificationNumber">
<tr>
    <td class="label"><fmt:message key="jsp.general.identificationnumber" /></td>
    <td class="required"><input type="text" name="${status.expression}" id="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
    <td><%@ include file="../includes/errorMessages.jsp" %></td>
</tr>
</spring:bind>
<spring:bind path="requestAdmissionForm.student.identificationPlaceOfIssue">
<tr>
    <td class="label"><fmt:message key="jsp.general.placeofissue" /></td>
    <td><input type="text" name="${status.expression}" id="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
    <td><%@ include file="../includes/errorMessages.jsp" %></td>
</tr>
</spring:bind>

<spring:bind path="requestAdmissionForm.student.identificationDateOfIssue">
<tr>
    <td class="label"><fmt:message key="jsp.general.dateofissue" /></td>
    <td>
        <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
        <table>
            <tr>
            	<td><fmt:message key="jsp.general.day" /></td>
            	<td><fmt:message key="jsp.general.month" /></td>
            	<td><fmt:message key="jsp.general.year" /></td>
            </tr>
              <tr>
            	<td><input type="text" id="identification_issue_day" name="identification_issue_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('student.identificationDateOfIssue','day',document.getElementById('identification_issue_day').value);" /></td>
            <td><input type="text" id="identification_issue_month" name="identification_issue_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('student.identificationDateOfIssue','month',document.getElementById('identification_issue_month').value);" /></td>
            <td><input type="text" id="identification_issue_year" name="identification_issue_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('student.identificationDateOfIssue','year',document.getElementById('identification_issue_year').value);" /></td>
            </tr>
        </table>
    </td>
    <td>
        <fmt:message key="jsp.general.message.dateformat" />
        <td><%@ include file="../includes/errorMessages.jsp" %></td>
    </td>
</tr>
</spring:bind>

<spring:bind path="requestAdmissionForm.student.identificationDateOfExpiration">
<tr>
    <td class="label"><fmt:message key="jsp.general.dateofexpiration" /></td>
    <td>
        <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
        <table>
        <tr>
        	<td><fmt:message key="jsp.general.day" /></td>
        	<td><fmt:message key="jsp.general.month" /></td>
        	<td><fmt:message key="jsp.general.year" /></td>
        </tr>
        <tr>
        	<td><input type="text" id="identification_expiration_day" name="identification_expiration_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('student.identificationDateOfExpiration','day',document.getElementById('identification_expiration_day').value);" /></td>
            <td><input type="text" id="identification_expiration_month" name="identification_expiration_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('student.identificationDateOfExpiration','month',document.getElementById('identification_expiration_month').value);" /></td>
            <td><input type="text" id="identification_expiration_year" name="identification_expiration_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('student.identificationDateOfExpiration','year',document.getElementById('identification_expiration_year').value);" /></td>
      	</tr>
        </table>
    </td>
</tr>
</spring:bind>

<!-- formal communication address student -->
<tr>
<spring:bind path="requestAdmissionForm.address.countryCode">
    <td class="label"><fmt:message key="jsp.general.country" /></td>
    <td class="required">
        <select id="${status.expression}" name="${status.expression}" onchange="updateEmptyNumber('address.number','0');">
            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            <c:forEach var="country" items="${allCountries}">
                <c:choose>
                    <c:when test="${country.code == status.value}">
                        <option value="${country.code}" selected="selected">${country.description}</option>
                    </c:when>
                    <c:otherwise>
                        <option value="${country.code}">${country.description}</option>
                    </c:otherwise>
                </c:choose>
            </c:forEach> 
        </select>
    </td>
    <td><%@ include file="../includes/errorMessages.jsp" %></td>
</spring:bind>
</tr>

<tr>
<spring:bind path="requestAdmissionForm.address.city">
    <td class="label"><fmt:message key="jsp.general.city" /></td>
    <td class="required">
        <input type="text" id="${status.expression}" name="${status.expression}" size="40" value="" />
    </td>
    <td><%@ include file="../includes/errorMessages.jsp" %></td>
</spring:bind>
</tr>
<tr>
<spring:bind path="requestAdmissionForm.address.street">
    <td class="label"><fmt:message key="jsp.general.address.street" /></td>
    <td>
        <input type="text" id="${status.expression}" name="${status.expression}" size="40" value="" />
    </td>
    <td><%@ include file="../includes/errorMessages.jsp" %></td>
</spring:bind>
</tr>

<tr>
    
    <td class="label"><fmt:message key="jsp.general.address.numberextension" /></td>
    <td>
    	<spring:bind path="requestAdmissionForm.address.number">
    	    <input type="text" id="${status.expression}" name="${status.expression}" size="3" value="<c:out value="${status.value}" />" />
        	<%@ include file="../includes/errorMessages.jsp" %>
	    </spring:bind>
        <spring:bind path="requestAdmissionForm.address.numberExtension">
	        &nbsp;&nbsp;<input type="text" name="${status.expression}" size="10" value="<c:out value="${status.value}" />" />
        	<%@ include file="../includes/errorMessages.jsp" %>
	    </spring:bind>
    </td>
    <td>
    </td>
</tr>

<tr>
<spring:bind path="requestAdmissionForm.address.zipCode">
    <td class="label"><fmt:message key="jsp.general.address.zipcode" /></td>
    <td>
        <input type="text" id="${status.expression}" name="${status.expression}" size="40" maxlength="4" value="" />
    </td>
    <td><%@ include file="../includes/errorMessages.jsp" %></td>
</spring:bind>
</tr>
<tr>
<spring:bind path="requestAdmissionForm.address.POBox">
    <td class="label"><fmt:message key="jsp.general.address.POBox" /></td>
    <td>
        <input type="text" id="${status.expression}" name="${status.expression}" size="40" value="" />
    </td>
    <td><%@ include file="../includes/errorMessages.jsp" %></td>
</spring:bind>
</tr>

<tr>
<spring:bind path="requestAdmissionForm.address.telephone">
    <td class="label"><fmt:message key="jsp.general.telephone" /></td>
    <td>
        <input type="text" id="${status.expression}" name="${status.expression}" size="20" maxlength="15" value="" />
    </td>
    <td><%@ include file="../includes/errorMessages.jsp" %></td>
</spring:bind>
</tr>

<tr>
<spring:bind path="requestAdmissionForm.address.mobilePhone">
    <td class="label"><fmt:message key="jsp.general.mobile" /></td>
    <c:choose>
        <c:when test="${initParam. iMobilePhoneRequired}">
            <td class="required">
        </c:when>
        <c:otherwise>
            <td>
        </c:otherwise>
    </c:choose>
    <input type="text" id="${status.expression}" name="${status.expression}" size="20" maxlength="15" value="" />
    </td>
    <td><%@ include file="../includes/errorMessages.jsp" %></td>
</spring:bind>
</tr>

<tr>
<spring:bind path="requestAdmissionForm.address.faxNumber">
    <td class="label"><fmt:message key="jsp.general.fax" /></td>
    <td>
        <input type="text" id="${status.expression}" name="${status.expression}" size="20" maxlength="15" value="" />
    </td>
    <td><%@ include file="../includes/errorMessages.jsp" %></td>
</spring:bind>
</tr>

<tr>
<spring:bind path="requestAdmissionForm.address.emailAddress">
    <td class="label"><fmt:message key="jsp.general.email" /></td>
        <c:choose>
            <c:when test="${initParam.iEmailAddressRequired}">
                <td class="required">
            </c:when>
            <c:otherwise>
                <td>
            </c:otherwise>
        </c:choose>
        <input type="text" id="${status.expression}" name="${status.expression}" size="40" value="" />
    </td>
    <td><%@ include file="../includes/errorMessages.jsp" %></td>
</spring:bind>
</tr>

<!--  study data -->
<spring:bind path="requestAdmissionForm.student.primaryStudyId">
<tr>
    <td class="label"><b><fmt:message key="jsp.general.primarystudy" /></b></td>
    <td class="required">
        <select name="${status.expression}" id="${status.expression}" >
            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            <c:forEach var="oneStudy" items="${requestAdmissionForm.allStudies}">
                <option value="${oneStudy.id}">${oneStudy.studyDescription}</option>
            </c:forEach>
        </select>
    </td>
</tr>
<tr>    
    <td colspan="2"><%@ include file="../includes/errorMessages.jsp" %></td>
</tr>
</spring:bind>
 
<c:choose>
    <c:when test="${initParam.iSecondStudy == 'Y'}">
        <spring:bind path="requestAdmissionForm.student.secondaryStudyId">
        <tr>
            <td class="label"><b><fmt:message key="jsp.general.secondarystudy" /></b></td>
            <td>
                <select name="${status.expression}" id="${status.expression}" >
                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                    <c:forEach var="oneStudy" items="${requestAdmissionForm.allStudies}">
                        <option value="${oneStudy.id}">${oneStudy.studyDescription}</option>
                    </c:forEach>
                </select>
            </td>
        </tr>
        <tr>    
            <td colspan="2"><%@ include file="../includes/errorMessages.jsp" %></td>
        </tr>
        </spring:bind>
    </c:when>
</c:choose>
						
