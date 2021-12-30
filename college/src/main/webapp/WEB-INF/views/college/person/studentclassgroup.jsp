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

<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>
    
    <spring:bind path="studentClassgroupForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>

    <sec:authorize access="hasRole('ACCESS_CONTEXT_HELP')">
        <c:set var="accessContextHelp" value="${true}"/>
    </sec:authorize>
				
    <div id="tabcontent">
        
	    <sec:authorize access="hasRole('READ_CLASSGROUPS')">
    
	        <form:form modelAttribute="studentClassgroupForm" name="organizationandnavigation" method="post">
	    		<input type="hidden" name="submitFormObject" id="submitFormObject" value="" />
	    		
	    		<form:errors cssClass="error" element="p" />
	    		
				<fieldset>
        			<legend>
                        <a href="<c:url value='/college/students.view'/>?<c:out value='currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
        				    <a href="<c:url value='/college/student-classgroups.view'/>?<c:out value='newForm=true&tab=${navigationSettings.tab}&panel=${navigationSettings.panel}&studentId=${studentClassgroupForm.student.studentId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
        					<c:set var="studentName" value="${studentClassgroupForm.student.surnameFull}, ${studentClassgroupForm.student.firstnamesFull}" scope="page" />
        					<c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}"/>
        				</a>
        				&nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="general.classgroup" /> 
        			</legend>
		        
					<table>
						<!-- study -->
						<tr>
							<td class="label" width="200">
								<fmt:message key="jsp.general.study" />
							</td>
							<td class="required">
								<form:select path="studyId" onchange="document.organizationandnavigation.submit();">
									<option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
									<c:forEach var="oneStudy" items="${studentClassgroupForm.allStudies}">
										<option value="${oneStudy.id}" ${studentClassgroupForm.studyId == oneStudy.id ? 'selected="selected"' : ''}><c:out value="${oneStudy.studyDescription}"/></option>
									</c:forEach>
								</form:select>
							</td>
							<td>&nbsp;</td>
						</tr>
						
						<!-- academic year -->
						<tr>
							<td class="label" width="200">
								<fmt:message key="jsp.general.academicyear" />
							</td>
							<td class="required">
								<form:select path="academicYearId" onchange="document.organizationandnavigation.submit();">
									<option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
									<c:forEach var="year" items="${studentClassgroupForm.allAcademicYears}">
										<c:choose>
											<c:when test="${year.id == studentClassgroupForm.academicYearId}">
												<option value="${year.id}" selected="selected"><c:out value="${year.description}"/></option>
											</c:when>
											<c:otherwise>
												<option value="${year.id}"><c:out value="${year.description}"/></option>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</form:select>
							</td>
						</tr>

						<!-- studyGradeType -->
						<tr>
							<td class="label" width="200">
								<fmt:message key="jsp.general.studygradetype" />
							</td>
							<td class="required">
								<form:select path="studyGradeTypeId" onchange="document.organizationandnavigation.submit();">
									<option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
									<c:if test="${studentClassgroupForm.studyId != 0 && studentClassgroupForm.academicYearId != 0}">
										<c:forEach var="oneStudyGradeType" items="${studentClassgroupForm.allStudyGradeTypes}">
											<option value="${oneStudyGradeType.id}" ${studentClassgroupForm.studyGradeTypeId == oneStudyGradeType.id ? 'selected="selected"' : ''}>
												<c:out value="${studentClassgroupForm.codeToGradeTypeMap[oneStudyGradeType.gradeTypeCode].description}"/>
											</option>
										</c:forEach>
									</c:if>
								</form:select>
							</td>
							<td>&nbsp;</td>
						</tr>
						
						<!-- classgroup -->
						<tr>
							<td class="label" width="200">
								<fmt:message key="general.classgroup" />
							</td>
							<td class="required">
								<form:select path="classgroupId">
									<option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
									<c:forEach var="oneClassgroup" items="${studentClassgroupForm.allClassgroups}">
										<option value="${oneClassgroup.id}" ${studentClassgroupForm.classgroupId == oneClassgroup.id ? 'selected="selected"' : ''}>
											<c:out value="${oneClassgroup.description}"/>
										</option>
									</c:forEach>
								</form:select>
							</td>
							<td>
								<form:errors path="classgroupId" cssClass="error" />
							</td>
						</tr>

						<!-- SUBMIT BUTTON -->
						<tr>
							<td class="label">&nbsp;</td>
							<td><input type="submit" value="<fmt:message key='jsp.button.submit' />" onclick="document.getElementById('submitFormObject').value='true';document.organizationandnavigation.submit();" /></td>
						</tr>
					</table>

			   </fieldset>
	
	        </form:form>

		</sec:authorize>

    </div>
</div>

<%@ include file="../../footer.jsp"%>
