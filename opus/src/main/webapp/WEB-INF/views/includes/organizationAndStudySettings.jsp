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

The Original Code is Opus-College college module code.

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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://jawr.net/tags" prefix="jwr" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

    <%--
        Note: A part of this has been implemented in a similar fashion in studyPlanDetail.jsp
     --%>

    <%-- 
        Note: this include needs the form object with organization
        and studySettings objects.
    --%>
    
    <%@ include file="navigation_privileges.jsp"%>

    <!-- start of institution -->
    <c:if test="${showInstitutions}">
        <table>
            <tr>
                <td class="label"><fmt:message key="jsp.general.university" /></td>
                <td width="200" align="right">
                    <form:select path="organization.institutionId" onchange="
                            document.getElementById('organization.branchId').value='0';
                            document.getElementById('organization.organizationalUnitId').value='0';
                            document.getElementById('studySettings.studyId').value='0';
                            document.getElementById('studySettings.academicYearId').value='0';
                            document.getElementById('studySettings.studyGradeTypeId').value='0';
                            document.getElementById('studySettings.cardinalTimeUnitNumber').value='0';
                            this.form.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="institution" items="${allInstitutions}">
                            <form:option value="${institution.id}"><c:out value="${institution.institutionDescription}"/></form:option>
                        </c:forEach>
                    </form:select>
                </td>
           </tr>
        </table>
    </c:if>

    <!-- start of branch -->
    <c:if test="${showBranches}">
        <table>
            <tr>
                <td class="label"><fmt:message key="jsp.general.branch" /></td>
                <td width="200" align="right">
                    <form:select path="organization.branchId" onchange="
                    		document.getElementById('organization.organizationalUnitId').value='0';
        					document.getElementById('studySettings.studyId').value='0';
                            document.getElementById('studySettings.academicYearId').value='0';
        					document.getElementById('studySettings.studyGradeTypeId').value='0';
        					document.getElementById('studySettings.cardinalTimeUnitNumber').value='0';
                    		this.form.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:choose>
                            <c:when test="${(institutionId != 0) }"> 
                                <c:forEach var="branch" items="${allBranches}">
                                    <form:option value="${branch.id}"><c:out value="${branch.branchDescription}"/></form:option>
                                </c:forEach>
                            </c:when>
                        </c:choose>
                    </form:select>
                </td>
            </tr>
        </table>
    </c:if>

    <!-- start of organizational unit -->
    <c:if test="${showOrgUnits}">
        <table>
            <tr>
                <td class="label"><fmt:message key="jsp.general.organizationalunit" /></td>
                <td width="200" align="right">
                    <form:select path="organization.organizationalUnitId" onchange="
        					document.getElementById('studySettings.studyId').value='0';
                            document.getElementById('studySettings.academicYearId').value='0';
        					document.getElementById('studySettings.studyGradeTypeId').value='0';
        					document.getElementById('studySettings.cardinalTimeUnitNumber').value='0';
                    		this.form.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="organizationalUnit" items="${allOrganizationalUnits}">
                            <form:option value="${organizationalUnit.id}">
                                <c:out value="${organizationalUnit.organizationalUnitDescription}"/> (<fmt:message key="jsp.organizationalunit.level" /> <c:out value="${organizationalUnit.unitLevel})"/>
                            </form:option>
                        </c:forEach>
                    </form:select>
                </td>
            </tr>
        </table>
    </c:if>

    <!-- start of study -->
    <table>
        <tr>
            <td class="label"><fmt:message key="jsp.general.study" /></td>
            <td width="200" align="right">
                <form:select path="studySettings.studyId" onchange="
                    document.getElementById('studySettings.academicYearId').value='0';
                    document.getElementById('studySettings.studyGradeTypeId').value='0';
                    document.getElementById('studySettings.cardinalTimeUnitNumber').value='0';
                    this.form.submit();">
                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                    <c:forEach var="oneStudy" items="${dropDownListStudies}">
                        <form:option value="${oneStudy.id}"><c:out value="${oneStudy.studyDescription}"/></form:option>
                    </c:forEach>
                </form:select>
            </td> 
        </tr>
    </table>
    <!-- end of study -->

    <!-- start of academic year -->
    <table>
    <tr>
        <td class="label" width="200"><fmt:message key="jsp.general.academicyear" /></td>
        <td width="200" align="right">
            <form:select path="studySettings.academicYearId" onchange="
                document.getElementById('studySettings.studyGradeTypeId').value='0';
                document.getElementById('studySettings.cardinalTimeUnitNumber').value='0';
                this.form.submit();">
    
                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                <c:forEach var="year" items="${allAcademicYears}">                          
                    <form:option value="${year.id}"><c:out value="${year.description}"/></form:option>
                </c:forEach>
            </form:select>
        </td>
    </tr>
    </table>
    <!-- end of academic year -->

    <!-- start of study grade types -->
    <table>
        <tr>
            <td class="label"><fmt:message key="jsp.general.studygradetype" /></td>
            <td width="200" align="right">
                <form:select path="studySettings.studyGradeTypeId" onchange="
                    document.getElementById('studySettings.cardinalTimeUnitNumber').value='0';
                    this.form.submit();">
                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                    <c:forEach var="studyGradeType" items="${allStudyGradeTypes}">
                        <form:option value="${studyGradeType.id}">
                        <spring:bind path="studySettings.studyGradeTypeId">
                            <c:if test="${status.value == studyGradeType.id}">
                                <c:set var="selectedStudyGradeType" value="${studyGradeType}"/>
                            </c:if>
                            
                        </spring:bind>
                            <c:out value="
                            ${allGradeTypesMap[studyGradeType.gradeTypeCode]} -
                            ${allStudyFormsMap[studyGradeType.studyFormCode]} -
                            ${allStudyTimesMap[studyGradeType.studyTimeCode]}
                            "/>
                        </form:option>
                    </c:forEach>
                </form:select>
            </td>
            <td></td>
       </tr>
    </table>
    <!-- end of grade types -->

    <!-- cardinal time units -->
    <table>
        <tr>
            <td class="label"><fmt:message key="jsp.general.cardinaltimeunit.number" /></td>
            <td width="200" align="right">
                <!-- make one option for each cardinalTimeUnit -->
                <form:select path="studySettings.cardinalTimeUnitNumber" onchange="
                    this.form.submit();">
                    <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                    <c:forEach begin="1" end="${selectedStudyGradeType.numberOfCardinalTimeUnits}" varStatus="status">
                        <form:option value="${status.count}">
                            <c:out value="${allCardinalTimeUnitsMap[selectedStudyGradeType.cardinalTimeUnitCode]} ${status.count}"/>
                        </form:option>
                    </c:forEach>
                </form:select>
            </td>
            <td></td>
       </tr>
    </table>
    <!-- end of cardinal time units -->

