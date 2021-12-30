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
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ include file="../../../header.jsp"%>

<body>

<div id="tabwrapper">

<%@ include file="../../../menu.jsp"%>

<c:set var="subject" value="${subjectResultsForm.subject}" />
<c:set var="staffMember" value="${subjectResultsForm.staffMember}" />
<c:set var="teachers" value="${subjectResultsForm.teachers}" />
<c:set var="idToSubjectTeacherMap" value="${subjectResultsForm.idToSubjectTeacherMap}" />
<c:set var="brsPassing" value="${subjectResultsForm.brsPassing}" />
<c:set var="endGradesPerGradeType" value="${subjectResultsForm.endGradesPerGradeType}" />
<c:set var="minimumMarkValue" value="${subjectResultsForm.minimumMarkValue}" />
<c:set var="maximumMarkValue" value="${subjectResultsForm.maximumMarkValue}" />
<%-- <c:set var="codeToFullEndGradeCommentForGradeType" value="${subjectResultsForm.codeToFullEndGradeCommentForGradeType}" /> --%>
<%-- <c:set var="fullFailGradeCommentsForGradeType" value="${subjectResultsForm.fullFailGradeCommentsForGradeType}" /> --%>
<%-- <c:set var="codeToFullAREndGradeCommentForGradeType" value="${subjectResultsForm.codeToFullAREndGradeCommentForGradeType}" /> --%>
<%-- <c:set var="fullARFailGradeCommentsForGradeType" value="${subjectResultsForm.fullARFailGradeCommentsForGradeType}" /> --%>
<c:set var="dateNow" value="${subjectResultsForm.dateNow}" />
<c:set var="subjectResultFormatter" value="${subjectResultsForm.subjectResultFormatter}" />

<c:set var="tab" value="${subjectResultsForm.navigationSettings.tab}" />
<c:set var="panel" value="${subjectResultsForm.navigationSettings.panel}" />
<c:set var="currentPageNumber" value="${subjectResultsForm.navigationSettings.currentPageNumber}" />


<%-- AUTHORIZATIONS --%>

<%-- check if logged in user is in subject teachers list, ie. one of the assigned teachers --%>
<c:set var="possibleTeacher" value="${not empty idToSubjectTeacherMap[staffMember.staffMemberId]}" />


<%-- BEGIN: create/edit subjectResults --%>

<%-- Has general privileges to alter any result within the study plan? --%>
<c:set var="createSubjectResults" value="${false}"/>
<sec:authorize access="hasAnyRole('CREATE_SUBJECTS_RESULTS')">
    <c:set var="createSubjectResults" value="${true}"/>
</sec:authorize>

<c:set var="editSubjectResults" value="${false}"/>
<sec:authorize access="hasAnyRole('UPDATE_SUBJECTS_RESULTS')">
	<c:set var="editSubjectResults" value="${true}"/>
</sec:authorize>


<%-- messages --%>
<c:set var="strMinimumGrade"><fmt:message key="jsp.general.minimummark" /></c:set>
<c:set var="strMaximumGrade"><fmt:message key="jsp.general.maximummark" /></c:set>
<c:set var="strHigherThanGivenGrade"><fmt:message key="jsp.validity.string.higherthangivengrade" /></c:set>
<c:set var="strLowerThanGivenGrade"><fmt:message key="jsp.validity.string.lowerthangivengrade" /></c:set>
<c:set var="strConflictingScales"><fmt:message key="jsp.validity.string.conflictingscales" /></c:set>


<div id="tabcontent">

<fieldset>
	<legend>
        <a href="<c:url value='/college/subjectsresults.view?currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
		<fmt:message key="jsp.general.importation" /> 
	</legend>
	
	<form name="filtersForm" id="filtersForm" method="get">
		<%@ include file="../../includes/subjectResultsFilters.jsp"%>
	</form>
</fieldset>
<fieldset>
	<legend>
		<fmt:message key="jsp.general.subject" />
	</legend>

    <!-- SUBJECT INFORMATION -->
    <table>                                                            
        <!-- CODE -->
        <tr>
           <td class="label"><fmt:message key="jsp.general.code" /></td>
           <td>
           ${subjectResultsForm.subject.subjectCode}
           </td>
        </tr>
        <!-- DESCRIPTION -->
        <tr>    
           <td class="label"><fmt:message key="jsp.general.name" /></td>
            <td>
           <a href="<c:url value='/college/subject.view?newForm=true&amp;tab=${tab}&amp;panel=${panel}&amp;from=subjects&amp;subjectId=${subjectResultsForm.subject.id}&amp;currentPageNumber=${currentPageNumber}'/>">
            ${subjectResultsForm.subject.subjectDescription} (${subjectResultsForm.subject.academicYear.description})
           </a>
           </td>
        </tr>

        <tr>
           <td class="label"><fmt:message key="jsp.subject.credit" /></td>
            <td>
           ${subjectResultsForm.subject.creditAmount}
           </td>
        </tr>

        <!-- BRs PASSING SUBJECT -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.brspassing" /></td>
            <td>
                ${brsPassing}
                &nbsp;(<fmt:message key="jsp.general.minimummark" />: ${minimumMarkValue}, <fmt:message key="jsp.general.maximummark" />: ${maximumMarkValue})
            </td>
        </tr>
        
        <!--  ACTIVE -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.active" /></td>
            <td>
                <c:choose>
                    <c:when test="${'Y' == subjectResultsForm.subject.active}">
                        <fmt:message key="jsp.general.yes" />
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="jsp.general.no" />
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>

        <!--  TEACHERS -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.teachers" /></td>
            <td>
                <c:forEach var="teacher" items="${teachers}">
                    ${teacher.surnameFull},&nbsp;${teacher.firstnamesFull}<br />
                </c:forEach>
            </td>
        </tr>
    </table>
</fieldset>


<fieldset   
	<c:if test="${examinationId == 0}"> disabled="disabled" </c:if>
>
	<legend><fmt:message key="jsp.general.importation"/></legend>
<form:form method="POST" commandName="subjectResultsForm" enctype="multipart/form-data">

	<table>
	<tr>
		<td><label><fmt:message key="general.model"/></label></td>
		<td>
			<label for="eSURAModel"><a href="#">eSURA</a></label>
			<form:radiobutton path="fileModel" value="eSURA" />
		</td>
		<td>
			<label for="cedModel"><a href="#">CED</a></label>
			<form:radiobutton path="fileModel" value="CED" />
		</td>
		<%-- 
		<td>
			<input type="button" 
			value="<fmt:message key='jsp.general.downloadmodel'/>" 
			name="btnDownloadModel"
			id="btnDownloadModel" /> 
		</td>
		--%>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
		<td>
			<label>
				<fmt:message key="jsp.general.browsefile"/>
			</label>
		</td>
			<td colspan="3">
				<form:input type="file" path="studentsResultsFile"/>
			</td>		
			<form:errors path="studentsResultsFile" cssClass="error" element="td"/>
		</tr>
		
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="4" align="center">
				<input type="submit" 
				name="submitsubjectresults" 
				value="<fmt:message key="jsp.button.submit" />" />
			</td>		
		</tr>
	</table>
	
	
</form:form>
</fieldset>

<c:if test="${subjectResultsForm.formStatus == 'ResultsProcessed'}">
<%@ include file="../../includes/subjectResultsResult.jsp"%>

</c:if>


</div><%--tabcontent --%>
    

</div><%--tabwrapper --%>

<%@ include file="../../../footer.jsp"%>

 
