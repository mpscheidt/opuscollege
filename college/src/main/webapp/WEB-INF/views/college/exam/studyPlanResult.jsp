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

<c:set var="screentitlekey">jsp.general.studyplanresults</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

<%@ include file="../../menu.jsp"%>

<c:set var="navigationSettings" value="${studyPlanResultForm.navigationSettings}" scope="page" />
<c:set var="useEndGrades" value="${appConfigMap['useEndGrades'] == 'Y'}" scope="page" />

<c:set var="studyPlan" value="${studyPlanResultForm.studyPlan}" scope="page" />
<c:set var="thesis" value="${studyPlanResultForm.studyPlan.thesis}" scope="page" />
<c:set var="student" value="${studyPlanResultForm.student}" scope="page" />
<c:set var="studyPlanResult" value="${studyPlanResultForm.studyPlan.studyPlanResult}" scope="page" />


<%-- authorizations --%>
<sec:authorize access="hasAnyRole('CREATE_STUDYPLAN_RESULTS','UPDATE_STUDYPLAN_RESULTS')">
    <c:set var="editStudyPlanResult" value="${true}"/>
</sec:authorize>
<c:if test="${!editStudyPlanResult}">
    <sec:authorize access="hasRole('READ_STUDYPLAN_RESULTS')
            or (${student.personId == opusUser.personId and student.hasMadeSufficientPayments})">
        <c:set var="showStudyPlanCTUResults" value="${true}"/>
    </sec:authorize>
    <c:set var="showStudyPlanResult" value="${showStudyPlanCTUResults and studyPlanResultForm.resultsVisibleToStudentsForStudyPlan}"/>
</c:if>

<div id="tabcontent">

<fieldset>
    <legend>
        <a href="<c:url value='/college/studyplanresults.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.exams.header" /></a>&nbsp;&gt;
        <c:choose>
            <c:when test="${not empty student.surnameFull}" >
                <c:set var="studentName" value="${student.studentCode}: ${student.surnameFull}, ${student.firstnamesFull}" scope="page" />
                <c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}"/>
            </c:when>
            <c:otherwise>
                <fmt:message key="jsp.href.new" />
            </c:otherwise>
        </c:choose>
        &gt;&nbsp;<fmt:message key="jsp.general.edit"/>&nbsp;<fmt:message key="jsp.general.studyplanresults" /> 
    </legend>
    
    <form:errors path="studyPlanResultForm.*" cssClass="errorwide" element="p"/>
<%--    <c:choose>        
 		<c:when test="${ not empty studyPlanResultForm.txtErr }">       
   	       <p align="left" class="error">
   	             ${studyPlanResultForm.txtErr}
   	       </p>
  	 	</c:when>
	</c:choose> --%>
	<c:choose>        
 		<c:when test="${ not empty studyPlanResultForm.txtMsg }">       
   	       <p align="right" class="msg">
   	            <c:out value="${studyPlanResultForm.txtMsg}"/>
   	       </p>
  	 	</c:when>
	</c:choose>
</fieldset>

<c:choose>
<c:when test="${empty studyPlanResultForm.allStudyPlansForStudent}">
    <p class="msgwide">
        <fmt:message key="jsp.student.nostudyplan" />
    </p>
</c:when>
<c:otherwise>

<div id="tp1" class="TabbedPanel">

<div class="TabbedPanelsContentGroup">

<!-- start of tabbedpanelscontent (= start of tab one) -->
<div class="TabbedPanelsContent">
<div class="Accordion" id="Accordion0">

<c:set var="panelValue" value="0" scope="page" />
<c:forEach var="oneStudyPlan" items="${studyPlanResultForm.allStudyPlansForStudent}">

    <div class="AccordionPanel">
    <div class="AccordionPanelTab">

        <a href="<c:url value='/college/studyplanresult.view?newForm=true&amp;studentId=${student.studentId}&amp;studyPlanId=${oneStudyPlan.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}&amp;tab=${navigationSettings.tab}&amp;panel=${panelValue}'/>">
            <c:out value="${oneStudyPlan.studyPlanDescription}:"/>

            <!--  STUDY ID -->
            <c:forEach var="oneStudy" items="${studyPlanResultForm.allStudies}">
                <c:choose>
                    <c:when test="${oneStudy.id == oneStudyPlan.studyId}">
                        <c:out value="${oneStudy.studyDescription}"/>
                    </c:when>
                </c:choose>
            </c:forEach>
            <!--  GRADE TYPE CODE -->
            <c:out value="${studyPlanResultForm.codeToGradeTypeMap[oneStudyPlan.gradeTypeCode].description}"/>
        </a>
    </div>

    <div class="AccordionPanelContent">
      	<!--  SELECTED STUDYPLAN -->
      	<c:choose>
        	<c:when test="${oneStudyPlan.id == studyPlan.id}">

                <form:form modelAttribute="studyPlanResultForm">

                    <%-- invisible default button before any other submit button --%>
                    <input type="submit" class="defaultsink" name="submitstudyplanresult" value="Save" />

                    <div class="crosslinkbar">
                        <!--  CROSSLINK TO STUDYPLAN -->
                        <a class="button" href="<c:url value='/college/studyplan.view?newForm=true&amp;studyPlanId=${studyPlan.id}&amp;studentId=${student.studentId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}&amp;tab=1&amp;panel=0'/>">
                            <fmt:message key="jsp.general.studyplanoverview" /> 
                        </a>
                    </div>

                    <table >

                        <!-- STUDY PLAN DESCRIPTION -->
                        <tr>
                            <td class="label"><b><fmt:message key="jsp.general.description" /></b></td>
                            <td colspan="2"><c:out value="${studyPlan.studyPlanDescription}"/></td>
                        </tr>

                        <!--  STUDY ID / MAJOR 1 ID -->
                        <tr>
                        	<td class="label">
                                <c:choose>
                                    <c:when test="${initParam.iMajorMinor == 'Y'}">
                                    <fmt:message key="jsp.general.importancetype" />
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:message key="jsp.general.study" />
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:forEach var="oneStudy" items="${studyPlanResultForm.allStudies}">
                                	<c:choose>
                                    	<c:when test="${oneStudy.id == studyPlan.studyId}">
                                            <c:out value="${oneStudy.studyDescription}"/>
            							</c:when>
                                   </c:choose>
                                </c:forEach>
                            </td> 
                            
                            <!--  MINOR1 ID -->
                            <td>
                                <c:choose>
                                    <c:when test="${initParam.iMajorMinor == 'Y'}">
                                        <c:forEach var="oneStudy" items="${studyPlanResultForm.allStudies}">
                                            <c:choose>
                                                <c:when test="${oneStudy.id == studyPlan.minor1Id}">
                                                 	&nbsp;/&nbsp;<c:out value="${oneStudy.studyDescription}"/>
                                           		</c:when>
                                			 </c:choose>
                                        </c:forEach>
                                    </c:when>
                                </c:choose>
                            </td>
                        </tr> 

                        <%--  MAJOR2 ID / MINOR2 ID - separate studyplan
                         <c:choose>
                            <c:when test="${appMajorMinor == 'Y'}">
                               	<tr>
                               		<td class="label">
                                    	<fmt:message key="jsp.general.major" /> 2 / <fmt:message key="jsp.general.minor" /> 2
                                    </td>
                                    <td>
                                        <c:forEach var="oneStudy" items="${studyPlanResultForm.allStudies}">
                                        	<c:choose>
                                            	<c:when test="${oneStudy.id == studyPlan.major2Id}">
                                                    ${oneStudy.studyDescription}
                                                </c:when>
                                           </c:choose>
                                        </c:forEach>
                                    </td> 
                                    <td>
                                       <c:forEach var="oneStudy" items="${studyPlanResultForm.allStudies}">
                                            <c:choose>
                                                <c:when test="${oneStudy.id == studyPlan.minor2Id}">
                                                 	${oneStudy.studyDescription}
                                            	</c:when>
                                           </c:choose>
                                        </c:forEach>
                                    </td>
                                </tr> 
                            </c:when>
                        </c:choose> --%>
                                                                                        
                        <!--  GRADE TYPE CODE -->
                        <tr>
                            <td class="label"><fmt:message key="jsp.general.gradetypecode" /></td>
                            <td colspan="2">
                                <c:out value="${studyPlanResultForm.codeToGradeTypeMap[studyPlan.gradeTypeCode].description}"/>
                            </td> 
                        </tr> 

                        <!--  STUDYPLAN STATUS CODE -->
                        <tr>
                            <td class="label"><fmt:message key="jsp.general.studyplanstatus" /></td>
                            <td colspan="2">
                                <c:out value="${studyPlanResultForm.codeToStudyPlanStatusMap[studyPlan.studyPlanStatusCode].description}"/>
                            </td> 
                        </tr>

                        <%-- BR's PASSING STUDYPLAN 
                        <c:choose>
                            <c:when test="${studyPlanResultForm.endGradesPerGradeType == 'N'}">
                                <tr>
                                    <td class="label"><fmt:message key="jsp.general.brspassing" /> <fmt:message key="jsp.general.exam" /></td>
                                    <td colspan="2">${studyPlan.BRsPassingExam}</td>
                                </tr> 
                            </c:when>
                        </c:choose>
                        --%>

                        <!-- ACTIVE -->
                        <tr>
                            <td class="label"><fmt:message key="jsp.general.active" /></td>
                            <td colspan="2">
                               <c:choose>
                                    <c:when test="${'Y' == studyPlan.active}">
                                        <fmt:message key="jsp.general.yes" />
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:message key="jsp.general.no" />
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>

                        <tr>
                            <td class="label"><fmt:message key="jsp.general.examdate" /></td>
                            <c:if test="${editStudyPlanResult}">
                                <spring:bind path="studyPlanResultForm.studyPlan.studyPlanResult.examDate">
                                <c:set var="examdateClass"></c:set>
                                <td class="required">
                                    <table>
                                        <tr>
                                            <td><fmt:message key="jsp.general.day" /></td>
                                            <td><fmt:message key="jsp.general.month" /></td>
                                            <td><fmt:message key="jsp.general.year" /></td>
                                        </tr>
                                        <tr>
                                            <td><input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                                                <input type="text" id="exam_day" name="exam_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('studyPlan.studyPlanResult.examDate','day',document.getElementById('exam_day').value);" /></td>
                                            <td><input type="text" id="exam_month" name="exam_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('studyPlan.studyPlanResult.examDate','month',document.getElementById('exam_month').value);" /></td>
                                            <td><input type="text" id="exam_year" name="exam_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('studyPlan.studyPlanResult.examDate','year',document.getElementById('exam_year').value);" /></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                </td>
                                </spring:bind>
                            </c:if>
                            <c:if test="${showStudyPlanResult}">
                                <td><fmt:formatDate dateStyle="medium" type="date" value="${studyPlanResultForm.studyPlan.studyPlanResult.examDate}"/></td>
                            </c:if>
                        </tr>
                        <tr>
                            <td class="label"><fmt:message key="jsp.general.brspassing" /></td>
                            <td>
                            	<c:out value="${studyPlanResultForm.brsPassing}"/>
                            </td> 
                            <td>
                            	<fmt:message key="jsp.general.minimummark" />: <c:out value="${studyPlanResultForm.minimumMarkValueStudyPlan}"/>,
                                <fmt:message key="jsp.general.maximummark" />: <c:out value="${studyPlanResultForm.maximumMarkValueStudyPlan}"/>
                            </td>
                        </tr>

        				<tr>
                            <td class="label"><b><fmt:message key="jsp.general.mark.value" /></b></td>
                            <td>
                                <c:choose>
                             	 	<c:when test="${editStudyPlanResult}">
                                     	 <spring:bind path="studyPlanResultForm.studyPlan.studyPlanResult.mark">
                                            <input type="text" name="${status.expression}" id="${status.expression}" size="3" maxlength="6" autocomplete="off" value="<c:out value="${status.value}" />" />
                                 		    <c:forEach var="error" items="${status.errorMessages}">
                                            <span class="error">${error}</span>
                                            </c:forEach>
                                 		 </spring:bind>
                                 		 <spring:bind path="studyPlanResultForm.studyPlan.studyPlanResult">
                                           <c:choose>
                                                <c:when test="${status.value != null and status.value != ''}">
                                                    <c:choose>
                                                        <c:when test="${studyPlanResultForm.userIsStudent}">
                                                            <c:out value="${studyPlanResultForm.studyPlanResultFormatterForStudents[studyPlanResultForm.studyPlanResultInDb]}"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:out value="${studyPlanResultForm.studyPlanResultFormatter[studyPlanResultForm.studyPlanResultInDb]}"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                            </c:choose>
                                       </spring:bind>
                                 	</c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${not empty studyPlanResultForm.studyPlan.studyPlanResult.mark}">
                                                <c:choose>
                                                    <c:when test="${not showStudyPlanResult and not editStudyPlanResult}">
                                                        (<fmt:message key="jsp.general.hidden" />)
                                                    </c:when>
                                                    <c:otherwise>
                                                            <c:out value="${studyPlanResultForm.studyPlanResultFormatter[studyPlanResultForm.studyPlanResultInDb]}"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                -
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </td>
							<td>
                                 <input type="hidden" name="generateStudyPlanMark" id="generateStudyPlanMark" value="N" />
                                 <c:if test="${editStudyPlanResult}">
                                   <input type="submit" name="generateResultButton" value="<fmt:message key='jsp.button.generate' />" />
                                 </c:if> 
                            </td>
                        </tr>
                        <tr>
							<td class="label"><fmt:message key="jsp.general.markdecimal"/></td>				
							<td>
									<c:out value="${studyPlanResultForm.studyPlan.studyPlanResult.markDecimal}"></c:out>
							</td>							
							<td></td>										
						</tr>
				        <tr>
                             <td class="label"><fmt:message key="jsp.general.passed" /></td>
                             <spring:bind path="studyPlanResultForm.studyPlan.studyPlanResult.passed">
                             <td>
                                 <c:choose>
                                     <c:when test="${'Y' == status.value}">
                                         <fmt:message key="jsp.general.yes" />
                                     </c:when>
                                     <c:otherwise>
                                         <fmt:message key="jsp.general.no" />
                                     </c:otherwise>
                                 </c:choose>
                             </td>
                             <td>
                                <c:forEach var="error" items="${status.errorMessages}">
                                    <span class="error"><c:out value="${error}"/></span>
                                </c:forEach>
                             </td>
                             </spring:bind>
                        </tr>
            
                        <tr>
                            <td class="label"><fmt:message key="jsp.general.finalmark" /></td>
                            <spring:bind path="studyPlanResultForm.studyPlan.studyPlanResult.finalMark">
                                <td>
                                    <c:if test="${editStudyPlanResult}">
                                        <form:select path="studyPlan.studyPlanResult.finalMark">
                                            <form:option value="N"><fmt:message key="jsp.general.no"/></form:option>                    
                                            <form:option value="Y"><fmt:message key="jsp.general.yes"/></form:option>
                                        </form:select>
<%--                                        <select name="${status.expression}">
                                            <c:choose>
                                                <c:when test="${'Y' == status.value}">
                                                   <option value="Y" selected="selected"><fmt:message key="jsp.general.yes" /></option>
                                                   <option value="N"><fmt:message key="jsp.general.no" /></option>
                                               </c:when>
                                               <c:otherwise>
                                                   <option value="Y"><fmt:message key="jsp.general.yes" /></option>
                                                   <option value="N" selected="selected"><fmt:message key="jsp.general.no" /></option>
                                               </c:otherwise>
                                            </c:choose>
                                       </select> --%>
                                    </c:if>
                                    <c:if test="${showStudyPlanResult}">
                                        <c:choose>
                                            <c:when test="${'Y' == status.value}">
                                                <fmt:message key="jsp.general.yes" />
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:message key="jsp.general.no" />
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                    <c:if test="${not showStudyPlanResult and not editStudyPlanResult}">
                                        (<fmt:message key="jsp.general.hidden" />)
                                    </c:if>
                                </td>
                                <td>
                                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                </td>
                            </spring:bind>
                        </tr>


                        <!-- do not show active -> default = Y 
                        <tr>
                                 <td class="label"><fmt:message key="jsp.general.active" /></td>
                                 <td><spring:bind path="studyPlanResultForm.studyPlan.studyPlanResult.active">
                                 <select name="${status.expression}">
                                     <c:choose>
                                         <c:when test="${'Y' == status.value}">
                                             <option value="Y" selected="selected"><fmt:message key="jsp.general.yes" /></option>
                                             <option value="N"><fmt:message key="jsp.general.no" /></option>
                                         </c:when>
                                         <c:otherwise>
                                             <option value="Y"><fmt:message key="jsp.general.yes" /></option>
                                             <option value="N" selected="selected"><fmt:message key="jsp.general.no" /></option>
                                         </c:otherwise>
                                        </c:choose>
                                 </select>
                                 </td>
                                 <td colspan=3>
                                 <c:forEach var="error" items="${status.errorMessages}"><span class="error">
                                     ${error}</span></c:forEach></spring:bind>
                                 </td>
                        </tr> -->
            
                        <c:if test="${editStudyPlanResult}">
                           <tr>
                                <td colspan="2">&nbsp;</td>
                                <td align="right">
                                      <input type="submit" name="submitstudyplanresult" value="<fmt:message key='jsp.button.submit' />" />
                               </td>
                           </tr>
                        </c:if>
    				</table>

            		<!--  THESIS -->
             		<c:choose>
				    	<c:when test="${thesis != null and thesis != ''}">
              				<br />
              				<hr width="500" align ="center" />
              				<br />
                     		<table>
                      			<tr>
           							<td class="header" colspan="4">
           							<fmt:message key="jsp.general.thesisresult" />
           							</td>
           							<td class="buttonsCell">
           								<c:if test="${editStudyPlanResult}">
           								   <a href="<c:url value='/college/thesisresult_delete.view?newForm=true&amp;thesisResultId=${studyPlanResult.thesisResult.id}&amp;studentId=${student.studentId}&amp;studyPlanId=${studyPlan.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}&amp;tab=${navigationSettings.tab}&amp;panel=${panelValue}'/>"
		                				   onclick="return confirm('<fmt:message key="jsp.thesisresult.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
		                				</c:if>
		      						</td>
           						</tr> 
                       			<tr>
		                        	<td class="label" >
                                        <fmt:message key="jsp.general.code" /> 
		                        	</td>
		                        	<td colspan="4">
                                        <c:out value="${thesis.thesisCode}"/>
		                        	</td>
		                        </tr>
		                        <tr>
		                        	<td class="label" >
		                        	<fmt:message key="jsp.general.description" /> 
		                        	</td>
		                        	<td colspan="4">
                                        <c:out value="${thesis.thesisDescription}"/>
		                        	</td>
		                        </tr>
		                         <tr>
		                        	<td class="label" >
		                        	<fmt:message key="jsp.general.creditamountoverall" /> 
		                        	</td>
		                        	<td colspan="4">
                                        <c:out value="${thesis.creditAmount}"/>
		                        	</td>
		                        </tr>
		                        
		                        <tr>
		                        	<td class="label"><b><fmt:message key="jsp.general.mark.value" /></b></td>
                         			<td colspan="2">
                         	 	 		<c:if test="${editStudyPlanResult}">
                                 			 <spring:bind path="studyPlanResultForm.studyPlan.studyPlanResult.thesisResult.mark">
                                                <input type="text" name="${status.expression}" id="${status.expression}" size="3" maxlength="6" value="<c:out value='${status.value}' />" />
			                        	        <c:forEach var="error" items="${status.errorMessages}">
                                                <span class="error">${error}</span>
                                                </c:forEach>
			                        	     </spring:bind>
			                        	     <spring:bind path="studyPlanResultForm.studyPlan.studyPlanResult.thesisResult">
				                        	     <c:choose>
                                                    <c:when test="${status.value != null and status.value != ''}">
                                                        <c:out value="${studyPlanResultForm.thesisResultFormatter[status.value]}"/>
                                                    </c:when>
                                                </c:choose>
                                            </spring:bind>
			                            </c:if>
			                        	<c:if test="${showStudyPlanResult}">
			                        	    <spring:bind path="studyPlanResultForm.studyPlan.studyPlanResult.thesisResult">
				                        	    <c:choose>
                                                <c:when test="${status.value != ''}">
                                                    <c:out value="${studyPlanResultForm.thesisResultFormatter[status.value]}"/>
                                                </c:when>
                                                <c:otherwise>
                                                -
                                                </c:otherwise>
                                               </c:choose>
                                               <c:forEach var="error" items="${status.errorMessages}">
                                               <span class="error">${error}</span>
                                               </c:forEach>
                                            </spring:bind>
			                        	 </c:if>
                                    </td>
		                        	<td colspan="2">
                                 		<c:if test="${editStudyPlanResult}">
                                 		   <input type="submit" name="setThesisMark" value="<fmt:message key='jsp.button.submit' />" />
                                 		</c:if>
                         			</td>
                    			</tr>

                                <tr>
                                     <td class="label"><fmt:message key="jsp.general.passed" /></td>
                                     <spring:bind path="studyPlanResultForm.studyPlan.studyPlanResult.thesisResult.passed">
                                     <td colspan="4">
                                         <c:choose>
                                             <c:when test="${'Y' == status.value}">
                                                 <fmt:message key="jsp.general.yes" />
                                             </c:when>
                                             <c:otherwise>
                                                 <fmt:message key="jsp.general.no" />
                                             </c:otherwise>
                                         </c:choose>
                                     </td>
                                     </spring:bind>
                                </tr>
                            </table>
                			<!-- END THESIS -->
			            </c:when>
			        </c:choose>
					
    				<br />
              		<hr width="500" align ="center" />
              		<br />
                        
                    <%--   STUDYPLAN CARDINAL TIME UNITs ONE by ONE --%>

                    <c:forEach var="oneStudyPlanCardinalTimeUnit" items="${studyPlanResultForm.allStudyPlanCardinalTimeUnits}">
						<c:set var="currentStudyGradeType" value="" scope="page" />
                    	<c:remove var="currentCardinalTimeUnitResult" scope="page" />
						<c:set var="currentCardinalTimeUnitResultCurrentAcademicYearId" value="0" scope="page" />
						<c:set var="studyPlanDetailsForCardinalTimeUnitFound" value="N" scope="page" />
		                <c:set var="currentCardinalTimeUnitResultDate" value="" />
						<c:set var="currentCardinalTimeUnitResultMark" value="" scope="page" />
			            <c:set var="currentCardinalTimeUnitResultEndGrade" value="" scope="page" />
			            <c:set var="currentCardinalTimeUnitResultEndGradeComment" value="" scope="page" />
                        <c:set var="currentCardinalTimeUnitResultPassed" value="N" scope="page" />
                        <c:set var="ctuResultAuthorization" value="${studyPlanResultForm.cardinalTimeUnitResultAuthorizationMap[oneStudyPlanCardinalTimeUnit.id]}" scope="page" />

                        <c:set var="ctuResultsPublished" value="${oneStudyPlanCardinalTimeUnit.resultsPublished}" />

			            <!-- fetch corresponding studygradetype -->
               			<c:forEach var="oneStudyGradeType" items="${studyPlanResultForm.allStudyGradeTypes}">
               				<c:choose>
               					<c:when test="${oneStudyGradeType.id == oneStudyPlanCardinalTimeUnit.studyGradeTypeId}">
               						<c:set var="currentStudyGradeType" value="${oneStudyGradeType}" scope="page" />
               					</c:when>
               				</c:choose>
               			</c:forEach>
               			
                        <c:choose>
                            <c:when test="${currentStudyGradeType != ''}">
					
						        <c:forEach var="cardinalTimeUnitResult" items="${studyPlanResultForm.allCardinalTimeUnitResults}">    <%-- TODO loop not necessary; cardinalTimeUnitResult available from studyPlanCardinalTimeUnit --%>

		                           	<%-- existing cardinalTimeUnitResult for this studyplancardinaltimeunit --%>
		                           	<c:choose>
		                            	<c:when test="${cardinalTimeUnitResult.studyPlanCardinalTimeUnitId == oneStudyPlanCardinalTimeUnit.id }" >

		                            		<c:set var="currentCardinalTimeUnitResult" value="${cardinalTimeUnitResult}" scope="page" />

           									<c:choose>
							                	<c:when test="${not empty currentCardinalTimeUnitResult}"> 
							                     	<c:set var="currentCardinalTimeUnitResultDate" value="${currentCardinalTimeUnitResult.cardinalTimeUnitResultDate}" scope="page" />
							                     	<c:set var="currentCardinalTimeUnitResultMark" value="${currentCardinalTimeUnitResult.mark}" scope="page" />
							                     	<c:set var="currentCardinalTimeUnitResultEndGrade" value="${currentCardinalTimeUnitResult.endGrade}" scope="page" />
							                     	<c:set var="currentCardinalTimeUnitResultEndGradeComment" value="${currentCardinalTimeUnitResult.endGradeComment}" scope="page" />
							                     	<c:set var="currentCardinalTimeUnitResultPassed" value="${currentCardinalTimeUnitResult.passed}" scope="page" />
			                                    </c:when>
		                                     </c:choose>
																				
		                            	</c:when>
	                               	</c:choose>

                            	</c:forEach> <%-- end of for each cardinal time unit result within studyplancardinaltimeunit --%>

                                <c:set var="ctuDescription"><c:out value="${studyPlanResultForm.codeToCardinalTimeUnitMap[currentStudyGradeType.cardinalTimeUnitCode].description}"/></c:set>
                                <c:set var="ctuNr"><c:out value="${oneStudyPlanCardinalTimeUnit.cardinalTimeUnitNumber}"/></c:set>
                                <c:set var="studyDescription">
                                    <c:forEach var="oneStudy" items="${studyPlanResultForm.allStudies}">
                                        <c:choose>
                                            <c:when test="${oneStudy.id == currentStudyGradeType.studyId}">
                                                <c:out value="${oneStudy.studyDescription}"/>
                                            </c:when>
                                       </c:choose>
                                    </c:forEach>
                                </c:set>
                                <c:set var="endgrade">
                                    <c:out value="${studyPlanResultForm.codeToGradeTypeMap[currentStudyGradeType.gradeTypeCode].description}"/>
                                </c:set>
                                <c:set var="academicYearDescription">
                                     <c:forEach var="academicYear" items="${studyPlanResultForm.allAcademicYears}">
                                        <c:choose>
                                            <c:when test="${academicYear.id == currentStudyGradeType.currentAcademicYearId}">
                                                <c:out value="${academicYear.description}"/>
                                            </c:when>
                                       </c:choose>
                                    </c:forEach>
                                </c:set>
                                <%-- Important for confirm dialog to have all values in same line, an enter would wreak havoc --%>
                                <c:set var="timeunitDescription">
                                    ${ctuDescription} ${ctuNr} - ${studyDescription} ${endgrade} - ${academicYearDescription}
                                </c:set>

                                <table>
                                    <tr>
			                        	<td class="header" colspan="4">
                                            <fmt:message var="cturesultTitle" key="results.view.edit.param">
                                                <fmt:param>${timeunitDescription}</fmt:param>
                                            </fmt:message>
                                            <c:url var="editCtuResultUrl" value='/college/cardinaltimeunitresult.view'>
                                                <c:param name="newForm" value="${true}"/>
                                                <c:param name="studyPlanCardinalTimeUnitId" value="${oneStudyPlanCardinalTimeUnit.id}"/>
                                                <c:param name="currentPageNumber" value="${navigationSettings.currentPageNumber}"/>
                                                <c:param name="tab" value="${navigationSettings.tab}"/>
                                                <c:param name="panel" value="${panelValue}"/>
                                            </c:url>
                                            <a title='${cturesultTitle}' href='<c:out value="${editCtuResultUrl}"></c:out>'>
                                                <c:out value="${timeunitDescription}"></c:out>
                                            </a>
			                        	</td>
			                        </tr>
                                </table>

                                <table>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.cardinaltimeunitstatus" /></td>
                                        <td colspan="4">
                                            <c:out value="${studyPlanResultForm.codeToCardinalTimeUnitStatusMap[oneStudyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode].description}"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label">
                                            <fmt:message key="jsp.general.progressstatus" />
                                        </td>
                                        <td colspan="4">
                                            <c:if test="${not empty oneStudyPlanCardinalTimeUnit.progressStatusCode}">
                                                <c:if test="${ctuResultAuthorization.read}">
                                                    <c:out value="${studyPlanResultForm.codeToProgressStatusMap[oneStudyPlanCardinalTimeUnit.progressStatusCode].description}"/>
                                                </c:if>
                                                <c:if test="${not ctuResultAuthorization.read and not ctuResultsPublished}">
                                                    (<fmt:message key="jsp.general.hidden" />)
                                                </c:if>
                                            </c:if>
                                        </td>
<%-- Current implementation of transferring to next time unit is buggy:
     1. The maxStudyPlanCardinalTimeUnit is wrong: it is not the newest time unit,
        but the last in the shown list. But the newest is on top.
     2. There is only selection for target year, not for e.g. semester 1 or 2,
        which would be fine if semester selection would be automatic 
     -> Transfer functionality would only make sense in this screen
        if it worked the same way as in the transfer students screen.

                                        <td colspan="2">
                                            <c:choose>
                                                <c:when test="${ctuResultAuthorization.createOrUpdate and oneStudyPlanCardinalTimeUnit.id == maxStudyPlanCardinalTimeUnit}">
                                                    <c:choose>
                                                        <c:when test="${(empty oneStudyPlanCardinalTimeUnit.progressStatusCode
                                                           or (updateStudyPlanResultsOnAppeal and not empty oneStudyPlanCardinalTimeUnit.progressStatusCode and oneStudyPlanCardinalTimeUnit.progressStatusCode != PROGRESS_STATUS_GRADUATE))
                                                               and oneStudyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED}">
                                                            <b><fmt:message key="jsp.general.progressstatus" /></b><br />
                                                            <input type="hidden" name="changeLastProgressStatus" id="changeLastProgressStatus" value="N" />
                                                            <select name="progressStatus_${oneStudyPlanCardinalTimeUnit.id}" id="progressStatus_${oneStudyPlanCardinalTimeUnit.id}"
                                                              onchange="document.getElementById('submitFormObject').value='true';
                                                              document.getElementById('changeLastProgressStatus').value ='Y';
                                                              if (document.getElementById('newAcademicYear_${oneStudyPlanCardinalTimeUnit.id}').value != '') {
                                                                  this.form.submit(); 
                                                              }">
                                                                <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                                                <c:forEach var="progressStatus" items="${studyPlanResultForm.allProgressStatuses}">
                                                                    <c:choose>
                                                                       <c:when test="${oneStudyPlanCardinalTimeUnit.progressStatusCode != '' and progressStatus.code == oneStudyPlanCardinalTimeUnit.progressStatusCode}">
                                                                            <option value="${progressStatus.code}" selected="selected">${progressStatus.description}</option> 
                                                                       </c:when>
                                                                       <c:otherwise>
                                                                            <option value="${progressStatus.code}">${progressStatus.description}</option> 
                                                                       </c:otherwise>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </select>
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${studyPlanResultForm.codeToProgressStatusMap[oneStudyPlanCardinalTimeUnit.progressStatusCode].description}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:if test="${not empty oneStudyPlanCardinalTimeUnit.progressStatusCode}">
                                                        <c:if test="${ctuResultAuthorization.createOrUpdate or ctuResultsPublished}">
                                                            ${studyPlanResultForm.codeToProgressStatusMap[oneStudyPlanCardinalTimeUnit.progressStatusCode].description}
                                                        </c:if>
                                                        <c:if test="${not ctuResultAuthorization.createOrUpdate and not ctuResultsPublished}">
                                                            (<fmt:message key="jsp.general.hidden" />)
                                                        </c:if>
                                                    </c:if>
                                                </c:otherwise>
                                            </c:choose>
                                       </td>
                                       <td colspan="2">
                                           <c:if test="${ctuResultAuthorization.createOrUpdate and oneStudyPlanCardinalTimeUnit.id == maxStudyPlanCardinalTimeUnit}">
                                              <c:if test="${(empty oneStudyPlanCardinalTimeUnit.progressStatusCode
                                                       or (updateStudyPlanResultsOnAppeal and not empty oneStudyPlanCardinalTimeUnit.progressStatusCode && oneStudyPlanCardinalTimeUnit.progressStatusCode != PROGRESS_STATUS_GRADUATE))
                                                           and oneStudyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED}">
                                                  <b><fmt:message key="jsp.button.next" /> <fmt:message key="jsp.general.academicyear" /><br/></b>
                                                   <select name="newAcademicYear_${oneStudyPlanCardinalTimeUnit.id}" id="newAcademicYear_${oneStudyPlanCardinalTimeUnit.id}"
                                                      onchange="document.getElementById('submitFormObject').value='true';
                                                        document.getElementById('changeLastProgressStatus').value ='Y'; 
                                                        if (document.getElementById('progressStatus_${oneStudyPlanCardinalTimeUnit.id}').value != '') {
                                                            this.form.submit();
                                                        }">    
                                                        <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                                        <option value="0"><fmt:message key="jsp.general.not.available" /></option>
                                                        <c:forEach var="academicYear" items="${studyPlanResultForm.allAcademicYears}">
                                                            <option value="${academicYear.id}">${academicYear.description}</option> 
                                                        </c:forEach>
                                                    </select>
                                                </c:if>
                                           </c:if>
                                       </td> --%>
                                    </tr>

<%--
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.cardinaltimeunit" /></td>
    		               				<td colspan="4">
                                            ${studyPlanResultForm.codeToCardinalTimeUnitMap[currentStudyGradeType.cardinalTimeUnitCode].description}
                                        </td>
    		               		    </tr> --%>                        
    		                        <tr>
                                        <td class="label"><b><fmt:message key="jsp.general.mark.value" /></b></td>
                                        <td colspan="4">
                                        
                                            <c:choose>
                                                <c:when test="${not empty currentCardinalTimeUnitResult}">
                                                    <c:if test="${not ctuResultAuthorization.read and not ctuResultsPublished}">
                                                        (<fmt:message key="jsp.general.hidden" />)
                                                    </c:if>
                                                    <c:if test="${ctuResultAuthorization.read}">
                                                        ${studyPlanResultForm.ctuResultFormatter[currentCardinalTimeUnitResult]}
                                                    </c:if>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td class="buttonsCell">
                                            <a class="imageLink"' href="<c:out value='${editCtuResultUrl}'/>">
                                                <img src="<c:url value='/images/edit.gif' />" alt="${cturesultTitle}" title="${cturesultTitle}" />
                                            </a>
                                            <c:if test="${ctuResultAuthorization.delete}">
                                                <fmt:message var="confirmDeleteMsg" key="jsp.result.delete.confirm.param" >
                                                    <fmt:param><c:out value="\n${timeunitDescription}"></c:out> </fmt:param>
                                                </fmt:message>
                                                <a class="imageLinkPaddingLeft" onclick="return confirm('${confirmDeleteMsg}')" href="<c:url value='/college/studyplanresult.view?deleteCardinalTimeUnit=true&amp;tab=${navigationSettings.tab}&amp;panel=${panelValue}&amp;cardinalTimeUnitResultId=${currentCardinalTimeUnitResult.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                    <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="result.delete" />" title="<fmt:message key="result.delete" />" />
                                                </a>
                                            </c:if>
                                        </td>
                                    </tr>
                                    <c:if test="${useEndGrades}">
                                        <tr>
                                            <td class="label"><b><fmt:message key="jsp.general.endgrade.comment" /></b></td>
                                            <td colspan="4">
                                                <c:choose>
                                                    <c:when test="${not empty currentCardinalTimeUnitResultEndGradeComment}">
                                                        <c:if test="${not ctuResultAuthorization.read and not ctuResultsPublished}">
                                                            (<fmt:message key="jsp.general.hidden" />)
                                                        </c:if>
                                                        <c:if test="${ctuResultAuthorization.read}">
                                                            <c:forEach var="endGrade" items="${studyPlanResultForm.fullEndGradeCommentsForGradeType}">
    
                                                                <c:if test="${endGrade.code == currentCardinalTimeUnitResultEndGradeComment}">
                                                                    <c:out value="${endGrade.comment}"/>
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:if>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:if>
                        			<tr>
                                        <td class="label"><fmt:message key="jsp.general.dateofendgrade" /></td>
                                        <td colspan="4">
                                            <c:choose>
                                                <c:when test="${not empty currentCardinalTimeUnitResultDate}">
                                                    <c:if test="${not ctuResultAuthorization.read and not ctuResultsPublished}">
                                                        (<fmt:message key="jsp.general.hidden" />)
                                                    </c:if>
                                                    <c:if test="${ctuResultAuthorization.read}">
				                                     	<fmt:formatDate pattern="dd-MM-yyyy" value="${currentCardinalTimeUnitResultDate}" />
                                                    </c:if>
                                                </c:when>
                                            </c:choose>
    			                        </td>
                                    </tr>
    	                            <tr>
                                         <td class="label"><fmt:message key="jsp.general.passed" /></td>
                                         <td  colspan="4">
                                             <c:choose>
                                                 <c:when test="${'Y' == currentCardinalTimeUnitResultPassed}">
                                                     <fmt:message key="jsp.general.yes" />
                                                 </c:when>
                                                 <c:otherwise>
                                                     <fmt:message key="jsp.general.no" />
                                                 </c:otherwise>
                                             </c:choose>
                                         </td>
    	                            </tr>
                            	</table>
											
								<%-- all studyplandetails with their subjectresults for this studyplancardinaltimeunit --%>

                                <c:forEach var="oneStudyPlanDetail" items="${studyPlanResultForm.allStudyPlanDetails}">

                        			<c:choose>
                            			<c:when test="${oneStudyPlanDetail.studyPlanId == studyPlan.id 
                                        		and oneStudyPlanDetail.studyPlanCardinalTimeUnitId == oneStudyPlanCardinalTimeUnit.id}" >

                                			<c:if test="${appUseOfSubjectBlocks == 'Y'}">
	                                			<c:choose>
                                            		<c:when test="${oneStudyPlanDetail.subjectBlockId != 0}">
                                            			<c:forEach var="oneSubjectBlockStudyGradeType" items="${studyPlanResultForm.allSubjectBlockStudyGradeTypes}" >
                                                    		<c:choose>
                                                        		<c:when test="${oneSubjectBlockStudyGradeType.subjectBlock.id == oneStudyPlanDetail.subjectBlockId 
							                                       and oneStudyPlanDetail.studyGradeTypeId == oneSubjectBlockStudyGradeType.studyGradeType.id}" >
                                                        			<c:set var="studyPlanDetailsForCardinalTimeUnitFound" value="Y" scope="page" />
                                                        		</c:when>
                                                        	</c:choose>
                                                        </c:forEach>
	                                            	</c:when>
                                            	</c:choose>
                                        	</c:if>
                                        	<c:choose>
	                                            <c:when test="${oneStudyPlanDetail.subjectId != 0}">
	                                                <c:forEach var="oneSubjectStudyGradeType" items="${studyPlanResultForm.allSubjectStudyGradeTypes}" >
	                                                    <c:choose>
	                                                        <c:when test="${oneSubjectStudyGradeType.subjectId == oneStudyPlanDetail.subjectId
	                                                        	and oneSubjectStudyGradeType.studyGradeTypeId == oneStudyPlanDetail.studyGradeTypeId}" >
                                                    			<c:set var="studyPlanDetailsForCardinalTimeUnitFound" value="Y" scope="page" />
                                                    		</c:when>
                                                    	</c:choose>
                                                    </c:forEach>
                                            	</c:when>
                                        	</c:choose>
                                    	</c:when>
                                    </c:choose>
                                </c:forEach>
                                    
								<table>
                                    <tr>
                                        <td colspan="6" class="header">
                                            <fmt:message key="jsp.general.subjectresults" />
                                        </td>
                                    </tr>
                                </table>

                         		<%@ include file="../../includes/studyPlanDetailsForStudyPlanResult.jsp"%>

								<c:set var="studyPlanDetailsForCardinalTimeUnitFound" value="N" scope="page" />

							</c:when>
						</c:choose> <%--currentStudyGradeType != '' oneStudyPlanCardinalTimeUnit.cardinalTimeUnitNumber  --%>

		            </c:forEach> <%-- end of each studyplan cardinal time unit --%>        									                           
                </form:form>

           	</c:when>
        </c:choose> <!-- oneStudyPlan.id == studyPlan.id -->

	</div> <!-- end of accordionpanelcontent --> 
   	</div> <!-- end of accordionpanel -->  

	<c:set var="panelValue" value="${panelValue + 1}" scope="page" /> 

</c:forEach> <!--  end of allStudyPlansForStudent -->

<!-- end of accordion 1 -->
    </div>


<script type="text/javascript">
    var Accordion0 = new Spry.Widget.Accordion("Accordion0",
     {defaultPanel: 0,
      useFixedPanelHeights: false,
      nextPanelKeyCode: 78 /* n key */,
      previousPanelKeyCode: 80 /* p key */
     });

</script>
    

<!--  end of tabbedpanelscontent (= end of tab one) -->
</div>

<!-- end of TabbedPanelsContentGroup -->
</div>

<!--  end of TabbedPanel -->    
</div>

</c:otherwise>  <%-- if not empty studyPlans --%>
</c:choose>

<!-- end of tabcontent -->
</div>   

<script type="text/javascript">
var tp1 = new Spry.Widget.TabbedPanels("tp1");
tp1.showPanel(<%=request.getParameter("tab")%>);
Accordion<%=request.getParameter("tab")%>.defaultPanel = <%=request.getParameter("panel")%>;
Accordion<%=request.getParameter("tab")%>.openPanelNumber(<%=request.getParameter("panel")%>);
</script>
   
<!-- end of tabwrapper -->    
</div>

<%@ include file="../../footer.jsp"%>

