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
    
    <spring:bind path="subjectClassgroupForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>

    <spring:bind path="subjectClassgroupForm.subject">
        <c:set var="mainSubject" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectClassgroupForm.studyGradeType">
        <c:set var="studyGradeType" value="${status.value}" scope="page" />
    </spring:bind>
    
    <sec:authorize access="hasRole('ACCESS_CONTEXT_HELP')">
        <c:set var="accessContextHelp" value="${true}"/>
    </sec:authorize>
				
    <div id="tabcontent">
        
	    <sec:authorize access="hasRole('READ_CLASSGROUPS')">
    
	        <form:form modelAttribute="subjectClassgroupForm" name="organizationandnavigation" method="post">
	    		<input type="hidden" name="submitFormObject" id="submitFormObject" value="" />
	    		
	    		<form:errors cssClass="error" element="p" />
	    		
		            <fieldset>
						<legend> 
					        <!--  back to overview -->
					        <a href="<c:url value='/college/subjects.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
					        <!--back to subject -->
					        <a href="<c:url value='/college/subject.view?newForm=true&amp;tab=4&amp;panel=0&amp;subjectId=${mainSubject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
					            <c:choose>
					            <c:when test="${mainSubject.subjectDescription != null && mainSubject.subjectDescription != ''}">
					                <c:out value="${fn:substring(mainSubject.subjectDescription,0,initParam.iTitleLength)}"/>
					            </c:when>
					            <c:otherwise>
					                <fmt:message key="jsp.href.new" />
					            </c:otherwise>
					        </c:choose>
					        </a> 
					        &nbsp;&gt;&nbsp;
					        <!-- back to studyGradeType -->
					        <a href="<c:url value='/college/subjectstudygradetype.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}
					                                                                    &amp;subjectStudyGradeTypeId=${subjectClassgroupForm.subjectStudyGradeTypeId}
					                                                                    &amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
					            <c:choose>
					                <c:when test="${studyGradeType.studyDescription != null && studyGradeType.studyDescription != ''}">
					                    <c:out value="${fn:substring(studyGradeType.studyDescription,0,initParam.iTitleLength)}"/>
					                </c:when>
					            </c:choose> 
					            <c:choose>
					                <c:when test="${studyGradeType.gradeTypeDescription != null && studyGradeType.gradeTypeDescription != ''}">
					                   / <c:out value="${fn:substring(studyGradeType.gradeTypeDescription,0,initParam.iTitleLength)}"/>
					                </c:when>
					            </c:choose>        
					        </a>
					        &nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />&nbsp;<fmt:message key="general.classgroup" /> 
					    </legend>

						<table>
							<!-- classgroup -->
							<tr>
								<td class="label" width="200">
									<fmt:message key="general.classgroup" />
								</td>
								<td class="required">
									<form:select path="classgroupId">
										<option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
										<c:forEach var="oneClassgroup" items="${subjectClassgroupForm.allClassgroups}">
											<option value="${oneClassgroup.id}" ${subjectClassgroupForm.classgroupId == oneClassgroup.id ? 'selected="selected"' : ''}>
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
