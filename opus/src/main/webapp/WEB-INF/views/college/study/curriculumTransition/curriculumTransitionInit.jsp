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

<%--
 * author : Markus Pscheidt
--%>

<%@ include file="../../../includes/standardincludes.jsp"%>

<c:set var="screentitlekey">jsp.curriculumtransition.init.header</c:set>
<%@ include file="../../../header.jsp"%>

<body>

<div id="tabwrapper">

    <c:set var="organization" value="${curriculumTransitionForm.organization}" scope="page" />

    <sec:authorize access="hasRole('ACCESS_CONTEXT_HELP')">
        <c:set var="accessContextHelp" value="${true}"/>
    </sec:authorize>

    <%@ include file="../../../menu.jsp"%>

    <div id="tabcontent">

        <fieldset>
            <legend>
            <fmt:message key="jsp.curriculumtransition.init.header"/>
            &nbsp;&nbsp;&nbsp;
            <c:if test="${accessContextHelp}">
                 <a class="white" href="<c:url value='/help/TransferCurriculum.pdf'/>" target="_blank">
                    <img src="<c:url value='/images/help.png' />" alt="<fmt:message key="jsp.general.message.help" />" title="<fmt:message key="jsp.general.message.help" />" /> 
                 </a>&nbsp;
            </c:if>
            
            </legend>

            <p align="center">
                <fmt:message key="jsp.curriculumtransition.introduction"/>
            </p>

            <form:form modelAttribute="curriculumTransitionForm" method="post" name="curriculumTransitionForm">
            <table>
            <tr>
            <td>

                <%@ include file="../../../includes/navigation_privileges.jsp"%>
                <!-- start of institution -->
                <c:if test="${showInstitutions}">
                    <table>
                        <tr>
                            <td class="label"><fmt:message key="jsp.general.university" /></td>
                            <td width="200">
                                <form:select path="organization.institutionId" onchange="
                                        document.getElementById('organization.branchId').value='0';
                                        document.getElementById('organization.organizationalUnitId').value='0';
                                        document.getElementById('studyId').value='0';
                                        this.form.submit();">
                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                    <c:forEach var="institution" items="${organization.allInstitutions}">
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
                            <td width="200">
                                <form:select path="organization.branchId" onchange="
                                        document.getElementById('organization.organizationalUnitId').value='0';
                                        document.getElementById('studyId').value='0';
                                        this.form.submit();">
                                    <option value="0"><fmt:message key="jsp.selectbox.all" /></option>
                                    <c:choose>
                                        <c:when test="${(institutionId != 0) }"> 
                                            <c:forEach var="branch" items="${organization.allBranches}">
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
                            <td width="200">
                                <form:select path="organization.organizationalUnitId" onchange="
                                        document.getElementById('studyId').value='0';
                                        this.form.submit();">
                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                    <c:forEach var="organizationalUnit" items="${organization.allOrganizationalUnits}">
                                        <form:option value="${organizationalUnit.id}">
                                            <c:out value="${organizationalUnit.organizationalUnitDescription}"/> (<fmt:message key="jsp.organizationalunit.level" /> <c:out value="${organizationalUnit.unitLevel}"/>)
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
                        <td width="200">
                            <form:select path="studyId" onchange="
                                this.form.submit();">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <c:forEach var="oneStudy" items="${curriculumTransitionForm.allStudies}">
                                    <form:option value="${oneStudy.id}"><c:out value="${oneStudy.studyDescription}"/></form:option>
                                </c:forEach>
                            </form:select>
                        </td> 
                    </tr>
                </table>
                <!-- end of study -->
            </td>
            <td align="right">
                  <table>
                  <tr>
                    <td class="label"><fmt:message key="jsp.curriculumtransition.academicyear.from" /></td>
                    <td class="required">
                        <form:select path="data.fromAcademicYearId" onchange="this.form.submit();">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="year" items="${curriculumTransitionForm.fromAcademicYears}">
                                <form:option value="${year.id}"><c:out value="${year.description}"/></form:option>
                            </c:forEach>
                        </form:select>
                    </td>
                    <form:errors path="data.fromAcademicYearId" cssClass="error" element="td"/>
                  </tr>
                  </table>
                  <table>
                  <tr>
                    <td class="label"><fmt:message key="jsp.curriculumtransition.academicyear.to" /></td>
                    <td class="required">
                        <form:select path="data.toAcademicYearId" onchange="this.form.submit();">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="year" items="${curriculumTransitionForm.toAcademicYears}">
                                <form:option value="${year.id}"><c:out value="${year.description}"/></form:option>
                            </c:forEach>
                        </form:select>
                    </td>
                    <form:errors path="data.toAcademicYearId" cssClass="error" element="td"/>
                  </tr>
                  </table>
            </td>
            </tr>
            </table>

            <table width="100%">
                <tr>
                    <td align="center">
                        <input type="submit" id="preview_button" name="previewButton" value="<fmt:message key='jsp.curriculumtransition.preview'/>"
                        <c:if test="${curriculumTransitionForm.data.eligibleStudyGradeTypeCount==0 
                            && curriculumTransitionForm.data.eligibleSubjectBlockCount==0 
                            && curriculumTransitionForm.data.eligibleSubjectCount==0
                            && curriculumTransitionForm.data.nrOfGradesEligibleForTransfer==0}">
                            disabled="disabled"
                        </c:if>
                        />
                    </td>
                </tr>
            </table>
            </form:form>
                
            <c:choose>
                <c:when test="${(not empty showError)}">             
                    <p align="left" class="error">
                        <fmt:message key="jsp.error.subject.delete" />
                        <fmt:message key="jsp.error.general.delete.linked.${ showError }" />
                    </p>
                </c:when>
            </c:choose>
            
        </fieldset>
        
        <table class="tabledata" id="TblData">
            <tr>
                <th>&nbsp;</th>
                <th>eligible for transition</th>
            </tr>
            <tr>
                <th><fmt:message key="jsp.general.studygradetypes" /></th>
                <td>
                <c:out value="${curriculumTransitionForm.data.eligibleStudyGradeTypeCount}"/>
                    of <c:out value="${curriculumTransitionForm.data.totalStudyGradeTypeCount}"/>
                </td>
            </tr>
            <c:if test="${appUseOfSubjectBlocks == 'Y'}">
	            <tr>
	                <th><fmt:message key="jsp.general.subjectblocks" /></th>
	                <td><c:out value="${curriculumTransitionForm.data.eligibleSubjectBlockCount}"/>
	                    of <c:out value="${curriculumTransitionForm.data.totalSubjectBlockCount}"/>
	                </td>
	            </tr>
            </c:if>
            <tr>
                <th><fmt:message key="jsp.general.subjects" /></th>
                <td><c:out value="${curriculumTransitionForm.data.eligibleSubjectCount}"/>
                    of <c:out value="${curriculumTransitionForm.data.totalSubjectCount}"/>
                </td>
            </tr>
            <tr>
                <th><fmt:message key="jsp.general.endgrades" /></th>
                <td><c:out value="${curriculumTransitionForm.data.nrOfGradesEligibleForTransfer}"/>
                </td>
            </tr>
        </table>
        
    </div>
  
</div>

<%@ include file="../../../footer.jsp"%>
