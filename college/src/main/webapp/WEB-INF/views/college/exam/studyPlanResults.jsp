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

<c:set var="screentitlekey">jsp.exams.header</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

 	<!-- necessary spring binds for organization and navigationSettings
		 regarding form handling through includes -->
	<spring:bind path="studyPlanResultsForm.organization">
        <c:set var="organization" value="${status.value}" scope="page" />
    </spring:bind>  
    <spring:bind path="studyPlanResultsForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>  
    
    <spring:bind path="studyPlanResultsForm.studySettings">
        <c:set var="studySettings" value="${status.value}" scope="page" />
    </spring:bind>  
    
    <spring:bind path="studyPlanResultsForm.studentStatusCode">
        <c:set var="studentStatusCode" value="${status.value}" scope="page" />
    </spring:bind>  
    
    <spring:bind path="studyPlanResultsForm.dropDownListStudies">
        <c:set var="dropDownListStudies" value="${status.value}" scope="page" />
    </spring:bind>  
    
	<spring:bind path="studyPlanResultsForm.allStudyGradeTypes">
        <c:set var="allStudyGradeTypes" value="${status.value}" scope="page" />
    </spring:bind>  

	<spring:bind path="studyPlanResultsForm.allStudies">
        <c:set var="allStudies" value="${status.value}" scope="page" />
    </spring:bind>  

	<spring:bind path="studyPlanResultsForm.allAcademicYears">
        <c:set var="allAcademicYears" value="${status.value}" scope="page" />
    </spring:bind>  

    <!-- authorizations -->
    <sec:authorize access="hasAnyRole('CREATE_STUDYPLAN_RESULTS','UPDATE_STUDYPLAN_RESULTS')">
        <c:set var="editStudyPlanResult" value="${true}"/>
    </sec:authorize>
    <c:if test="${!editStudyPlanResults}">
        <sec:authorize access="hasRole('READ_STUDYPLAN_RESULTS') or ${personId == opusUser.personId}">
            <c:set var="showStudyPlanResult" value="${true}"/>
        </sec:authorize>
    </c:if>

    <c:set var="deleteStudyPlanResult" value="${false}"/>
    <sec:authorize access="hasRole('DELETE_STUDYPLAN_RESULTS')">
        <c:set var="deleteStudyPlanResult" value="${true}"/>
    </sec:authorize>

    <div id="tabcontent">

		<fieldset>
			<legend><fmt:message key="jsp.exams.header" /> - <fmt:message key="jsp.general.exams" /> <fmt:message key="jsp.general.students" /> </legend>
				<form name="organizationandnavigation" method="post" action="${navigationSettings.action}">
					<table>
						<tr>
							<td>
							<%@ include file="../../includes/organizationAndNavigationAndStudySettings.jsp"%>
							<%@ include file="../../includes/studentStatus.jsp"%>
							</td>
							<td>
	                            <%@ include file="../../includes/studySettings.jsp"%>
							</td>
						</tr>
	         		</table>
		        </form>   

	      	<c:choose>        
	     		<c:when test="${ not empty studyPlanResultsForm.txtErr }">       
	       	       <p align="left" class="error">
	       	            <fmt:message key="jsp.error.student.delete" /> <c:out value="${studyPlanResultsForm.txtErr}"/>
	       	       </p>
	      	 	</c:when>
	    	</c:choose>
	    	<c:choose>        
	     		<c:when test="${ not empty studyPlanResultsForm.txtMsg }">       
	       	       <p align="right" class="msg">
	       	            <c:out value="${studyPlanResultsForm.txtMsg}"/>
	       	       </p>
	      	 	</c:when>
	    	</c:choose>
              

 		</fieldset>
		
<%-- 		<c:set var="allEntities" value="${studyPlanResultsForm.allStudents}" scope="page" /> --%>
		<c:set var="redirView" value="studyplanresults" scope="page" />
<%-- 		<c:set var="entityNumber" value="0" scope="page" /> --%>

        <%-- no calculations needed for the paging header, just the total entity count --%>
        <c:set var="countAllEntities" value="${studyPlanResultsForm.studentCount}" scope="page" />
        <%@ include file="../../includes/pagingHeaderInterface.jsp"%>           


        <table class="tabledata" id="TblData">
            <tr>
                <th><fmt:message key="jsp.general.code" /></th>
                <th><fmt:message key="jsp.general.title" /></th>
                <th><fmt:message key="jsp.general.firstnames" /></th>
                <th><fmt:message key="jsp.general.surname" /></th>
                <th><fmt:message key="jsp.general.birthdate" /></th>
                <th><fmt:message key="jsp.general.primarystudy" /></th>
                <th><fmt:message key="jsp.general.active" /></th>
                <th><fmt:message key="jsp.general.studyplans" />/<fmt:message key="jsp.general.exam" /> (<fmt:message key="jsp.general.active" />)</th>
            </tr>

            <c:forEach var="student" items="${studyPlanResultsForm.allStudents}">
				<c:set var="panelValue" value="0" scope="page" />
                <tr>
                    <%-- STUDENT CODE --%>
                    <td><c:out value="${student.studentCode}"/></td>

                    <td>
                    <c:forEach var="civilTitle" items="${allCivilTitles}">
                       <c:choose>
                            <c:when test="${civilTitle.code == student.civilTitleCode }">
                                <c:out value="${civilTitle.description}"/>
                            </c:when>
                       </c:choose>
                    </c:forEach>
                    </td>
                    <td><c:out value="${student.firstnamesFull}"/></td>
                    <td>
                        <c:choose>
                            <c:when test="${showStudyPlanResult || editStudyPlanResult}">
                                <a href="<c:url value='/college/studyplanresult.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;studentId=${student.studentId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                <c:out value="${student.surnameFull}"/></a>
                            </c:when>
                            <c:otherwise>
                                <c:out value="${student.surnameFull}"/>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td><fmt:formatDate type="date" value="${student.birthdate}" /></td>
                    <td>
                        <c:forEach var="study" items="${allStudies}">
                            <c:choose>
                                <c:when test="${study.id == student.primaryStudyId}">
                                    <c:out value="${study.studyDescription}"/>
                                </c:when>
                            </c:choose>
                         </c:forEach>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${student.active == 'Y'}">
                                <fmt:message key="jsp.general.yes" />
                            </c:when>
                            <c:otherwise>
                                <fmt:message key="jsp.general.no" />
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td style="width: 40%">
                    <c:choose>
                    	<c:when test="${showStudyPlanResult || EditStudyPlanResult}" >
	                        
	                        <c:choose>
	                            <c:when test="${student.studyPlans[0] != null}">
	                            	<table style="width: 100%">
	                            	<c:forEach var="studyPlan" items="${student.studyPlans}">
	                            		<tr>
	                            			<td>
	                            			    <a href="<c:url value='/college/studyplanresult.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${panelValue}&amp;studentId=${student.studentId}&amp;studyPlanId=${studyPlan.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
	                            				   <c:out value="${studyPlan.study.studyDescription} ${studyPlan.gradeTypeCode} (${studyPlan.active})"/>
                                                </a>
	                            			</td>
	                            			<td style="width: 20%; text-align: center;">
						                        <c:choose>
						                            <c:when test="${not empty studyPlan.studyPlanResult.id}">
				                            			<c:out value="${studyPlanResultsForm.studyPlanResultFormatter[studyPlan.studyPlanResult]}"/>
						                            </c:when>
						                        </c:choose>
	                            			</td>
	                            			<td class="buttonsCell" width="40px">
							                	<a class="imageLink" href="<c:url value='/college/studyplanresult.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${panelValue}&amp;studentId=${student.studentId}&amp;studyPlanId=${studyPlan.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                                <c:if test="${deleteStudyPlanResult and not empty studyPlan.studyPlanResult.id}">
                                                    <a class="imageLinkPaddingLeft" href="<c:url value='/college/studyplanresults.view?delete=true&amp;tab=${navigationSettings.tab}&amp;panel=${panelValue}&amp;studyPlanResultId=${studyPlan.studyPlanResult.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                                </c:if>
							                </td>
	                            		</tr>
	                            	<c:set var="panelValue" value="${panelValue + 1}" scope="page" />	
	                            	</c:forEach>
	                            	</table>
	                            </c:when>
	                        </c:choose>
                    	</c:when>
                    </c:choose>
                    </td> 
                </tr>
	            
            </c:forEach>
        </table>
		<script type="text/javascript">alternate('TblData',true)</script>

        <%@ include file="../../includes/pagingFooterNew.jsp"%>
    
        <br /><br />
    </div>

</div>

<%@ include file="../../footer.jsp"%>
