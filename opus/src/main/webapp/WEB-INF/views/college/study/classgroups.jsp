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

<%@ include file="../../includes/standardincludes.jsp"%>

<c:set var="screentitlekey">jsp.classgroups.header</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>
    
	<!-- necessary spring binds for organization and navigationSettings
		 regarding form handling through includes -->
    <spring:bind path="classgroupsForm.organization">
        <c:set var="organization" value="${status.value}" />
    </spring:bind>
    
    <spring:bind path="classgroupsForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" />
    </spring:bind>

    <sec:authorize access="hasRole('ACCESS_CONTEXT_HELP')">
        <c:set var="accessContextHelp" value="${true}"/>
    </sec:authorize>
				
    <div id="tabcontent">
        
	    <sec:authorize access="hasRole('READ_CLASSGROUPS')">
    
	        <form:form modelAttribute="classgroupsForm" name="organizationandnavigation" method="post">
	    
				<fieldset>
					<legend>
						<fmt:message key="jsp.classgroups.header" />
						&nbsp;&nbsp;&nbsp;
				        <c:if test="${accessContextHelp}">
				             <a class="white" href="<c:url value='/help/Classgroups.pdf'/>" target="_blank">
				             	<img src="<c:url value='/images/help.png' />" alt="<fmt:message key="jsp.general.message.help" />" title="<fmt:message key="jsp.general.message.help" />" /> 
				             </a>&nbsp;
				        </c:if>
					</legend>

                    <table style="width:100%;">
                    <tr>
                    <td>
	                    <%@ include file="../../includes/organizationAndNavigation.jsp"%>
	
						<table>
							<!-- study -->
							<tr>
								<td class="label" width="200">
									<fmt:message key="jsp.general.study" />
								</td>
								<td>
									<form:select path="studyId" onchange="document.getElementById('navigationSettings.currentPageNumber').value=1; document.organizationandnavigation.submit();">
										<option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
										<c:if test="${classgroupsForm.organization.organizationalUnitId != 0}">
											<c:forEach var="oneStudy" items="${classgroupsForm.allStudies}">
												<option value="${oneStudy.id}" ${classgroupsForm.studyId == oneStudy.id ? 'selected="selected"' : ''}><c:out value="${oneStudy.studyDescription}"/></option>
											</c:forEach>
										</c:if>
									</form:select>
								</td>
								<td>&nbsp;</td>
							</tr>
							
							<!-- academic year -->
							<tr>
								<td class="label" width="200">
									<fmt:message key="jsp.general.academicyear" />
								</td>
								<td>
									<select id="academicYearId" name="academicYearId" onchange="document.getElementById('navigationSettings.currentPageNumber').value=1; document.organizationandnavigation.submit();">
										<option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
										<c:forEach var="year" items="${classgroupsForm.allAcademicYears}">
											<c:choose>
												<c:when test="${year.id == classgroupsForm.academicYearId}">
													<option value="${year.id}" selected="selected"><c:out value="${year.description}"/></option>
												</c:when>
												<c:otherwise>
													<option value="${year.id}"><c:out value="${year.description}"/></option>
												</c:otherwise>
											</c:choose>
										</c:forEach>
									</select>
								</td>
							</tr>

							<!-- studyGradeType -->
							<tr>
								<td class="label" width="200">
									<fmt:message key="jsp.general.studygradetype" />
								</td>
								<td>
									<select id="studyGradeTypeId" name="studyGradeTypeId" onchange="document.getElementById('navigationSettings.currentPageNumber').value=1; document.organizationandnavigation.submit();">
										<option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
										<c:if test="${classgroupsForm.studyId != 0 && classgroupsForm.academicYearId != 0}">
											<c:forEach var="oneStudyGradeType" items="${classgroupsForm.allStudyGradeTypes}">
												<option value="${oneStudyGradeType.id}" ${classgroupsForm.studyGradeTypeId == oneStudyGradeType.id ? 'selected="selected"' : ''}>
													<c:out value="${classgroupsForm.codeToGradeTypeMap[oneStudyGradeType.gradeTypeCode].description}"/>,
                                                    <c:out value="${classgroupsForm.codeToStudyFormMap[oneStudyGradeType.studyFormCode].description}"/>,
                                                    <c:out value="${classgroupsForm.codeToStudyTimeMap[oneStudyGradeType.studyTimeCode].description}"/>
												</option>
											</c:forEach>
										</c:if>
									</select>
								</td>
								<td>&nbsp;</td>
							</tr>
							
						</table>
                    </td>
                    <td>
                        <%@ include file="../../includes/searchValue.jsp"%>
                        <sec:authorize access="hasRole('CREATE_STUDIES')">
                            <table style="width:100%;">
                                <tr><td height="65">&nbsp;</td></tr>
                                <tr>
                                    <td class="addbutton" align="right">
                                        <a style="vertical-align:bottom;" class="button" href="<c:url value='/college/classgroup.view?tab=0&amp;panel=0&amp;searchValue=&amp;newForm=true'/>">
                                            <fmt:message key="general.add.classgroup"/>
                                        </a>
                                    </td>
                                </tr>
                            </table>
                        </sec:authorize>
					</td>
                    </tr>
                    </table>

		            <c:if test="${!empty param['showError']}">
		                <p align="left" class="error">
		                    ${param['showError']}
		                </p>
		            </c:if>
	
			   </fieldset>
	
	        </form:form>
		        
	        <%-- no calculations needed for the paging header, just the total entity count --%>
	        <c:set var="countAllEntities" value="${classgroupsForm.classgroupCount}" />
            <c:set var="currentPageNumber" value="${navigationSettings.currentPageNumber}" />
			<c:set var="redirView" value="classgroups" />
	        <%@ include file="../../includes/pagingHeader.jsp"%>
       
	        <c:set var="authorizedToEdit" value="${false}"/>
	        <sec:authorize access="hasRole('UPDATE_CLASSGROUPS')">
	            <c:set var="authorizedToEdit" value="${true}"/>
	        </sec:authorize>
	        
	        <table class="tabledata" id="TblData">
                <tr>
    	            <th><fmt:message key="jsp.general.name" /></th>
    	            <th><fmt:message key="jsp.general.academicyear" /></th>
    	            <th><fmt:message key="jsp.general.study" /></th>
    	            <th><fmt:message key="jsp.general.studygradetype" /></th>
                </tr>
	            
	            <c:forEach var="oneClassgroup" items="${classgroupsForm.allClassgroups}">
	              	<c:forEach var="studygradytype" items="${classgroupsForm.allStudyGradeTypes}">
	                  	<c:if test="${studygradytype.id == oneClassgroup.studyGradeTypeId}">
                      		<c:set var="oneStudyGradeType" value="${studygradytype}"/>
	                  	</c:if>
	               	</c:forEach>
	            
	                <tr>
	                   <td>
		                    <a href="<c:url value='/college/classgroup.view?newForm=true&tab=0&panel=0&classgroupId=${oneClassgroup.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
		                        <c:out value="${oneClassgroup.description}"/>
		                    </a>
	                    </td>
	                    <td>
	                    	<c:out value="${classgroupsForm.idToAcademicYearMap[oneStudyGradeType.currentAcademicYearId].description}"/>
	                    </td>
	                    <td>
	                    	<c:if test="${!empty oneStudyGradeType}">
								<c:forEach var="study" items="${classgroupsForm.allStudies}">
									<c:if test="${study.id == oneStudyGradeType.studyId}">
	                                    <c:out value="${study.studyDescription}"/>
	                                </c:if>
								</c:forEach>
							</c:if>
						</td>
	                    <td>
	                  		<c:out value="${classgroupsForm.codeToGradeTypeMap[oneStudyGradeType.gradeTypeCode].description}"/>
						</td>
	                    <td class="buttonsCell">
	                    	<c:if test="${authorizedToEdit}">
	                        	<a class="imageLink" href="<c:url value='/college/classgroup.view?newForm=true&tab=0&panel=0&classgroupId=${oneClassgroup.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
			                </c:if>
	                        <sec:authorize access="hasRole('DELETE_CLASSGROUPS')">
	                        	<a class="imageLinkPaddingLeft" href="<c:url value='/college/classgroup_delete.view?classgroupId=${oneClassgroup.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"
	                        	onclick="return confirm('<fmt:message key="jsp.classgroup.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
	                        </sec:authorize>
	                    </td>
	                </tr>
	            </c:forEach>
	        </table>
			<script type="text/javascript">alternate('TblData',true)</script>
			
	        <%@ include file="../../includes/pagingFooter.jsp"%>
			
	        <br /><br />

		</sec:authorize>

    </div>
</div>

<%@ include file="../../footer.jsp"%>
