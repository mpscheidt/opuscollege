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

    <form:input type="hidden" path="student.personCode" size="40" />
    <c:set var="relativeOfStaffMember" value="${requestAdmissionForm.student.relativeOfStaffMember}" />
    <c:set var="ruralAreaOrigin" value="${requestAdmissionForm.student.ruralAreaOrigin}" />

    <tr>
        <td class="label"><fmt:message key="jsp.general.foreignstudent" /></td>
        <td>
            <form:select path="student.foreignStudent" onchange="document.getElementById('navigationSettings.panel').value='0';document.formdata.submit();">
                <form:option value="N"><fmt:message key="jsp.general.no" /></form:option>
                <form:option value="Y"><fmt:message key="jsp.general.yes" /></form:option>
            </form:select>
        </td>
    </tr>
    
    <c:if test="${foreignStudent == 'Y'}">
        <tr>
            <td class="label"><fmt:message key="jsp.general.nationalitygroup" /></td>
            <td>
               <form:select path="student.nationalityGroupCode">
                    <form:option value="0"><fmt:message key="jsp.selectbox.choose" /></form:option>
                    <form:options items="${allNationalityGroups}" itemValue="code" itemLabel="description" />
                </form:select>
            </td>
        </tr>
    </c:if>

    <c:if test="${ruralAreaOrigin == 'N'}">
        
        <tr>
            <td class="label"><fmt:message key="jsp.general.relativeofstaffmember" /></td>
            <td>
                <form:select path="student.relativeOfStaffMember" onchange="document.getElementById('navigationSettings.panel').value='0';document.formdata.submit();">
                    <form:option value="N"><fmt:message key="jsp.general.no" /></form:option>
                    <form:option value="Y"><fmt:message key="jsp.general.yes" /></form:option>
                </form:select>
            </td>
        </tr>
        
        <c:if test="${relativeOfStaffMember == 'Y'}">
            <tr>
                <td class="label"><fmt:message key="jsp.general.staffmembercode" /></td>
                <td>
                    <form:input path="student.employeeNumberOfRelative"  size="40" /> 
                </td>
            </tr>
        </c:if>
    </c:if>

    <c:if test="${relativeOfStaffMember == 'N'}">
        <tr>
            <td class="label"><fmt:message key="jsp.general.ruralareaorigin" /></td>
            <td>
                <form:select path="student.ruralAreaOrigin" onchange="document.getElementById('navigationSettings.panel').value='0';document.formdata.submit();">
                    <form:option value="N"><fmt:message key="jsp.general.no" /></form:option>
                    <form:option value="Y"><fmt:message key="jsp.general.yes" /></form:option>
                </form:select>
            </td>
        </tr>
    </c:if>

    <%-- do not show, students don't know
    <spring:bind path="requestAdmissionForm.student.studentCode">
    <tr>
        <td class="label"><fmt:message key="jsp.general.studentcode" /></td>
        <td><input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
    </tr>
    </spring:bind> --%>

    <tr>
        <td class="label"><fmt:message key="jsp.general.surname" /></td>
        <td class="required"><form:input path="student.surnameFull" size="40" /></td>
        <form:errors path="student.surnameFull" cssClass="error" element="td"/>
    </tr>
    <tr>
        <td class="label"><fmt:message key="jsp.general.firstnames" /></td>
        <td class="required"><form:input path="student.firstnamesFull" size="40" /></td>
        <form:errors path="student.firstnamesFull" cssClass="error" element="td"/>
    </tr>
    <tr>
        <td class="label"><fmt:message key="jsp.general.aliasfirstnames" /></td>
        <td><form:input path="student.firstnamesAlias" size="40" /></td>
    </tr>
    <!-- nationalRegistrationNumber -->
    <tr>
        <td class="label"><fmt:message key="jsp.general.nationalregistrationnumber" /></td>
        <td><form:input path="student.nationalRegistrationNumber" size="40" /></td>
    </tr>
    <!-- civilTitle -->
    <tr>
        <td class="label"><fmt:message key="jsp.general.civiltitle" /></td>
        <td>
           <form:select path="student.civilTitleCode">
                <form:option value="0"><fmt:message key="jsp.selectbox.choose" /></form:option>
                <form:options items="${allCivilTitles}" itemValue="code" itemLabel="description" />
            </form:select>
        </td>
    </tr>  
    <tr>
        <td class="label"><fmt:message key="jsp.general.academictitle" /></td>
        <td>
            <select name="student.gradeTypeCode">
                <option value="0"><fmt:message key="jsp.selectbox.choose.ifapplicable" /></option>
                <c:forEach var="gradeType" items="${requestAdmissionForm.allGradeTypes}">
                    <c:choose>
                        <c:when test="${gradeType.code == student.gradeTypeCode && gradeType.title != ''}">
                            <option value="<c:out value='${gradeType.code}'/>" selected="selected"><c:out value='${gradeType.title}'/></option>
                        </c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${gradeType.title != ''}">
                                    <option value="<c:out value='${gradeType.code}'/>"><c:out value='${gradeType.title}'/></option>
                                </c:when>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </select>
        </td>
    </tr>
    <spring:bind path="requestAdmissionForm.student.genderCode">
    <tr>
        <td class="label"><fmt:message key="jsp.general.gender" /></td>
        <td class="required">
            <form:select path="student.genderCode">
                <form:option value="0"><fmt:message key="jsp.selectbox.choose" /></form:option>
                <form:options items="${allGenders}" itemValue="code" itemLabel="description" />
            </form:select>
        </td>
        <form:errors path="student.firstnamesFull" cssClass="error" element="td"/>
    </tr>
    </spring:bind>
    <spring:bind path="requestAdmissionForm.student.birthdate">
    <tr>
        <td class="label"><fmt:message key="jsp.general.birthdate" /></td>
        <td class="required">
            <table>
            <tr>
                <td><fmt:message key="jsp.general.day" /></td>
                <td><fmt:message key="jsp.general.month" /></td>
                <td><fmt:message key="jsp.general.year" /></td>
            </tr>
            <tr>
                <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />">
                <td><input class="numericField" type="text" id="birth_day" name="birth_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />"  onchange="updateFullDate('student.birthdate','day',document.getElementById('birth_day').value);"  /></td>
                <td><input class="numericField" type="text" id="birth_month" name="birth_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('student.birthdate','month',document.getElementById('birth_month').value);" /></td>
                <td><input class="numericField" type="text" id="birth_year" name="birth_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />"  onchange="updateFullDate('student.birthdate','year',document.getElementById('birth_year').value);" /></td>
            </tr>
            </table>
        </td>
        <td><%@ include file="../includes/errorMessages.jsp" %></td>
    </tr>
    </spring:bind>
    
    <%-- scholarship flag --%>
    <tr>
        <td class="label"><fmt:message key="jsp.general.scholarship.appliedfor" /></td>
        <td>
            <form:select path="student.scholarship">
                <form:option value="N"><fmt:message key="jsp.general.no" /></form:option>
                <form:option value="Y"><fmt:message key="jsp.general.yes" /></form:option>
            </form:select>
        </td>
    </tr>
                        
    <tr>
        <td class="label"><fmt:message key="jsp.general.civilstatus" /></td>
        <td>
           <form:select path="student.civilStatusCode">
                <form:option value="0"><fmt:message key="jsp.selectbox.choose" /></form:option>
                <form:options items="${allCivilStatuses}" itemValue="code" itemLabel="description" />
            </form:select>
        </td>
    </tr>
    
    <tr>
        <td class="label"><fmt:message key="jsp.general.housingoncampus" /></td>
        <td>
            <form:select path="student.housingOnCampus">
                <form:option value="N"><fmt:message key="jsp.general.no" /></form:option>
                <form:option value="Y"><fmt:message key="jsp.general.yes" /></form:option>
            </form:select>
        </td>
    </tr>
    <tr>
        <td class="label"><fmt:message key="jsp.general.healthissues"/></td>
        <td><form:textarea path="student.healthIssues" rows="6" cols="25" /></td>
    </tr>
    <tr>
        <td class="label"><fmt:message key="jsp.general.motivation"/></td>
        <td><form:textarea path="student.motivation" rows="6" cols="25" /></td>
    </tr>
    <%--<c:choose>
        <c:when test="${ not empty requestAdmissionForm.txtErr }">       
            <tr class="error" align="center">
                <td colspan="3" align="center">
                    ${requestAdmissionForm.txtErr}
                </td>
            </tr>
        </c:when>
    </c:choose> --%>
</table>
