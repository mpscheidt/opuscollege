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
<table>
    <!--  select identificationType -->
     <tr>
        <td class="label"><fmt:message key="jsp.general.identificationtype" /></td>
        <td class="required">
            <form:select path="student.identificationTypeCode">
                <form:option value="0">
                    <fmt:message key="jsp.selectbox.choose" />
                </form:option>
                <form:options items="${allIdentificationTypes}" itemValue="id" itemLabel="description" />
            </form:select>
        </td>
        <form:errors path="student.identificationTypeCode" cssClass="error" element="td"/>
    </tr>
        
    <tr>
        <td class="label"><fmt:message key="jsp.general.identificationnumber" /></td>
        <td class="required">
            <form:input path="student.identificationNumber" size="50"/>
        </td>
        <form:errors path="student.identificationNumber" cssClass="error" element="td"/>
    </tr>
    
    <tr>
        <td class="label"><fmt:message key="jsp.general.placeofissue" /></td>
        <td><input type="text" name="student.identificationPlaceOfIssue" size="40" value="<c:out value='${student.identificationPlaceOfIssue}'/>" /></td>
    </tr>
    
    <spring:bind path="requestAdmissionForm.student.identificationDateOfIssue">
    <tr>
        <td class="label"><fmt:message key="jsp.general.dateofissue" /></td>
        <td>
            <table>
                <tr>
                    <td><fmt:message key="jsp.general.day" /></td>
                    <td><fmt:message key="jsp.general.month" /></td>
                    <td><fmt:message key="jsp.general.year" /></td>
                </tr>
                <tr>
                    <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />">
                    <td><input class="numericField" type="text" id="identification_issue_day" name="identification_issue_day" size="2" maxlength=2 value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('student.identificationDateOfIssue','day',document.getElementById('identification_issue_day').value);" /></td>
                    <td><input class="numericField" type="text" id="identification_issue_month" name="identification_issue_month" size="2" maxlength=2 value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('student.identificationDateOfIssue','month',document.getElementById('identification_issue_month').value);" /></td>
                    <td><input class="numericField" type="text" id="identification_issue_year" name="identification_issue_year" size="4" maxlength=4 value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('student.identificationDateOfIssue','year',document.getElementById('identification_issue_year').value);" /></td>
                </tr>
            </table>
        </td>
        <td><%@ include file="../includes/errorMessages.jsp" %></td>
    </tr>
    </spring:bind>
    
    <spring:bind path="requestAdmissionForm.student.identificationDateOfExpiration">
    <tr>
        <td class="label"><fmt:message key="jsp.general.dateofexpiration" /></td>
        <td>
            <table>
                <tr>
                    <td><fmt:message key="jsp.general.day" /></td>
                    <td><fmt:message key="jsp.general.month" /></td>
                    <td><fmt:message key="jsp.general.year" /></td>
                </tr>
                <tr>
                    <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />">
                    <td><input class="numericField" type="text" id="identification_expiration_day" name="identification_expiration_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('student.identificationDateOfExpiration','day',document.getElementById('identification_expiration_day').value);" /></td>
                    <td><input class="numericField" type="text" id="identification_expiration_month" name="identification_expiration_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('student.identificationDateOfExpiration','month',document.getElementById('identification_expiration_month').value);" /></td>
                    <td><input class="numericField" type="text" id="identification_expiration_year" name="identification_expiration_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('student.identificationDateOfExpiration','year',document.getElementById('identification_expiration_year').value);" /></td>
                </tr>
            </table>
        </td>
        <td><%@ include file="../includes/errorMessages.jsp" %></td>
    </tr>
    </spring:bind>
    
    <%-- <c:choose>
        <c:when test="${ not empty requestAdmissionForm.txtErr }">       
            <tr class="error" align="center">
                <td colspan="3" align="center">
                    ${requestAdmissionForm.txtErr}
                </td>
            </tr>
        </c:when>
    </c:choose> --%>
</table>
