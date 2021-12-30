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

<c:set var="subject" value="${resultsForm.subject}" />
<c:set var="staffMember" value="${resultsForm.staffMember}" />
<c:set var="teachers" value="${resultsForm.teachers}" />
<c:set var="idToSubjectTeacherMap" value="${resultsForm.idToSubjectTeacherMap}" />
<c:set var="brsPassing" value="${resultsForm.brsPassing}" />
<c:set var="endGradesPerGradeType" value="${resultsForm.endGradesPerGradeType}" />
<c:set var="minimumMarkValue" value="${resultsForm.minimumMarkValue}" />
<c:set var="maximumMarkValue" value="${resultsForm.maximumMarkValue}" />
<%-- <c:set var="codeToFullEndGradeCommentForGradeType" value="${resultsForm.codeToFullEndGradeCommentForGradeType}" /> --%>
<%-- <c:set var="fullFailGradeCommentsForGradeType" value="${resultsForm.fullFailGradeCommentsForGradeType}" /> --%>
<%-- <c:set var="codeToFullAREndGradeCommentForGradeType" value="${resultsForm.codeToFullAREndGradeCommentForGradeType}" /> --%>
<%-- <c:set var="fullARFailGradeCommentsForGradeType" value="${resultsForm.fullARFailGradeCommentsForGradeType}" /> --%>
<c:set var="dateNow" value="${resultsForm.dateNow}" />
<c:set var="subjectResultFormatter" value="${resultsForm.subjectResultFormatter}" />

<c:set var="tab" value="${resultsForm.navigationSettings.tab}" />
<c:set var="panel" value="${resultsForm.navigationSettings.panel}" />
<c:set var="currentPageNumber" value="${resultsForm.navigationSettings.currentPageNumber}" />


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
	
	<form name="filtersForm" id="filtersForm" method="GET">
		<%@ include file="../../includes/importCedStudentsResultsFilters.jsp"%>
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
           ${resultsForm.subject.subjectCode}
           </td>
        </tr>
        <!-- DESCRIPTION -->
        <tr>    
           <td class="label"><fmt:message key="jsp.general.name" /></td>
            <td>
           <a href="<c:url value='/college/subject.view?newForm=true&amp;tab=${tab}&amp;panel=${panel}&amp;from=subjects&amp;subjectId=${resultsForm.subject.id}&amp;currentPageNumber=${currentPageNumber}'/>">
            ${resultsForm.subject.subjectDescription} (${resultsForm.subject.academicYear.description})
           </a>
           </td>
        </tr>

        <tr>
           <td class="label"><fmt:message key="jsp.subject.credit" /></td>
            <td>
           ${resultsForm.subject.creditAmount}
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
                    <c:when test="${'Y' == resultsForm.subject.active}">
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
	<c:if test="${(empty resultsForm.studentsList) || (fn:length(resultsForm.studentsList) == 0)}"> disabled="disabled" </c:if>>

	<legend><fmt:message key="jsp.general.importation"/></legend>
<form:form method="POST" commandName="resultsForm" enctype="multipart/form-data">
 <input type="hidden" name="task" value="processResults"/>
	<table>
	<tr>
	<td><label><fmt:message key="jsp.general.teacher" /></label></td>
        <td class="required">
            <form:select
                path="teacherId"
                >
                 <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            <c:forEach var="oneTeacher" items="${resultsForm.teachers}">
                <c:choose>
                    <c:when test="${(oneTeacher.staffMemberId == resultsForm.teacherId) }">
                         <option value="${oneTeacher.staffMemberId}" selected="selected">${oneTeacher.surnameFull},${oneTeacher.firstnamesFull}</option>
                    </c:when>
                    <c:otherwise>
                    <option value="${oneTeacher.staffMemberId}">${oneTeacher.surnameFull},${oneTeacher.firstnamesFull}</option>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
                </form:select>
                </td>
                <form:errors path="teacherId" cssClass="error" element="td"/>
	</tr>
	<tr>
		<td><label><fmt:message key="general.model" /></label></td>
		<td class="required">
			
			<c:forEach var="fileModel" items="${resultsForm.fileModels}">
			<spring:message var="radioLabel" code="jsp.${fileModel.value}" /> 
 					<form:radiobutton path="fileModel" value="${fileModel}" 
 						id="${fileModel.value}Radio" label="${radioLabel}"
 						onchange="
 									if(this.value == 'STANDARD_PAUTA') 
 									jQuery('#lnkGetResultsForm').css('visibility','visible');
 									else
 									jQuery('#lnkGetResultsForm').css('visibility','hidden');
 								"
 					/>
			</c:forEach>
		 	<br/>
		 	
		 	 
		 		
		 	<%--Only display "download form" link for standard pauta--%>
		 	<c:choose>
		 		<c:when test="${(resultsForm.fileModel.value == 'STANDARD_PAUTA') && (resultsForm.formStatus == 'FiltersFilled')}">
		 			
		 			<a href="javascript:{}" 
		 			id="lnkGetResultsForm"
		 			onclick="document.getElementById('getResultsFormForm').submit(); return false;"
		 			>
			 			<fmt:message key="jsp.message.donwloadresultsform"/>
			 		</a>
			 		
			 	</c:when>
			 	<c:otherwise>
		 			<a href="javascript:()"
		 			   style="visibility: hidden" 
		 			   onclick="document.getElementById('getResultsFormForm').submit(); return false;"
		 			   id="lnkGetResultsForm">
			 			<fmt:message key="jsp.message.donwloadresultsform"/>
			 		</a>
			 	</c:otherwise>
			 </c:choose>
			 
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
		<tr valign="middle">
		<td>
			<label>
				<fmt:message key="jsp.general.browsefile"/>
			</label>
		</td>
			<td colspan="3" class="required">
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

<form method="POST" id="getResultsFormForm" name="getResultsFormForm">
	<input type="hidden" name="task" value="getResultsForm" />
	<input type="hidden" name="institutionId" value="${institutionId}" />
	<input type="hidden" name="branchId" value="${branchId}" />
	<input type="hidden" name="organizationalUnit.id" value="${organizationalUnitId}" />
	<input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
	<input type="hidden" name="where.studygradeType.currentAcademicYearId" value="${academicYearId}" />
	<input type="hidden" name="where.studyGradeType.Id" value="${studyGradeTypeId}" />
	<input type="hidden" name="where.subject.id" value="${subjectId}" />
	<input type="hidden" name="examinationId" value="${examinationId}" />
	<input type="hidden" name="where.cardinalTimeUnitNumber" value="${cardinalTimeUnitNumber}" />     
</form> 
</fieldset>
<c:if test="${(resultsForm.formStatus == 'FiltersFilled') || (resultsForm.formStatus == 'ResultsProcessed')}">
	<%@ include file="../../includes/subjectResultsResult.jsp"%>
</c:if>

<c:if test="${resultsForm.formStatus == 'Sucess'}">
	 <table width="735" >
	 	<tr>
	 <td class="successful">
		<fmt:message key="jsp.message.resultssuccessfullyimported"/>
	</td>
	</tr>
	</table>
	
</c:if>

</div><%--tabcontent --%>
    

</div><%--tabwrapper --%>

<%@ include file="../../../footer.jsp"%>

 
