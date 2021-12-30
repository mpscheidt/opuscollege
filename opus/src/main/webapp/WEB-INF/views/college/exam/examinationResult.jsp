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

<c:set var="screentitlekey">jsp.general.examinationresult</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="wrapper">

<%@ include file="../../menu.jsp"%>

<c:set var="examinationResultId" value="${examinationResultForm.examinationResult.id}" scope="page" />

<c:set var="student" value="${examinationResultForm.student}" />
<c:set var="studyPlan" value="${examinationResultForm.studyPlan}" />
<c:set var="studyPlanDetailId" value="${examinationResultForm.studyPlanDetail.id}" />
<c:set var="studyPlanCardinalTimeUnit" value="${examinationResultForm.studyPlanCardinalTimeUnit}" />
<c:set var="subject" value="${examinationResultForm.subject}" />
<c:set var="examination" value="${examinationResultForm.examination}" />

<c:set var="tab" value="${examinationResultForm.navigationSettings.tab}" />
<c:set var="panel" value="${examinationResultForm.navigationSettings.panel}" />
<c:set var="currentPageNumber" value="${examinationResultForm.navigationSettings.currentPageNumber}" />

<%-- authorizations --%>
<c:set var="examinationResultAuthorization" value="${examinationResultForm.examinationResultAuthorization}" />

<%-- check if logged in user is in subject teachers list, ie. one of the assigned teachers --%>
<c:set var="possibleTeacher" value="${not empty examinationResultForm.idToExaminationTeacherMap[examinationResultForm.loggedInStaffMember.id]}" />

<c:set var="showEditStudyPlanResult" value="${false}"/>
<sec:authorize access="hasRole('UPDATE_STUDYPLAN_RESULTS')">
    <c:set var="showEditStudyPlanResult" value="${true}"/>
</sec:authorize>


<div id="tabcontent">

	<fieldset>
		<legend>
            <a href="<c:url value='/college/studyplanresults.view?newForm=true&amp;currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
           	&nbsp;&gt;&nbsp;<a href="<c:url value='/college/studyplanresult.view?newForm=true&amp;tab=${tab}&amp;panel=${panel}&amp;studentId=${student.studentId}&amp;studyPlanId=${studyPlanDetail.studyPlanId}&amp;currentPageNumber=${currentPageNumber}'/>">
            <c:choose>
                <c:when test="${student.surnameFull != null && student.surnameFull != ''}" >
                    <c:set var="studentName" value="${student.surnameFull}, ${student.firstnamesFull}" scope="page" />
                    <c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}"/>
                </c:when>
                <c:otherwise>
                    <fmt:message key="jsp.href.new" />
                </c:otherwise>
            </c:choose>
            &nbsp;&gt;&nbsp;
            <c:choose>
                <c:when test="${studyPlan.studyPlanDescription != ''}" >
                    <c:out value="${fn:substring(studyPlan.studyPlanDescription,0,initParam.iTitleLength)}"/>
                </c:when>
                <c:otherwise>
                    <fmt:message key="jsp.href.new" />
                </c:otherwise>
            </c:choose> 
            </a>

            <br />&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;<a href="<c:url value='/college/cardinaltimeunitresult.view?newForm=true&amp;studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&amp;currentPageNumber=${currentPageNumber}&amp;tab=${tab}&amp;panel=${panel}'/>">
			<c:choose>
				<c:when test="${studyPlanCardinalTimeUnit.cardinalTimeUnitNumber != null && studyPlanCardinalTimeUnit.cardinalTimeUnitNumber != ''}" >
   					<fmt:message key="jsp.general.cardinaltimeunit.number" /> ${studyPlanCardinalTimeUnit.cardinalTimeUnitNumber}
				</c:when>
			</c:choose>
			</a>
			&nbsp;&gt;&nbsp;<a href="<c:url value='/college/subjectresult.view?newForm=true&amp;from=examinationresult&amp;tab=${tab}&amp;panel=${panel}&amp;studentId=${student.studentId}&amp;studyPlanDetailId=${studyPlanDetailId}&amp;subjectResultId=${examinationResultForm.subjectResultId}&amp;subjectId=${subject.id}'/>">
				<c:out value="${fn:substring(subject.subjectDescription,0,initParam.iTitleLength)}"/>
			</a>
			&nbsp;&gt;&nbsp;<c:out value="${fn:substring(examination.examinationDescription,0,initParam.iTitleLength)}"/>
			&nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.examinationresult" /> 

		</legend>
	</fieldset>
		
<div id="tp1" class="TabbedPanel">
<!--<ul class="TabbedPanelsTabGroup">
      <li class="TabbedPanelsTab"><fmt:message key="jsp.general.examinationresult" /></li>             
</ul>-->

<div class="TabbedPanelsContentGroup">   
<div class="TabbedPanelsContent">
<div class="Accordion" id="Accordion0">
<div class="AccordionPanel">
<div class="AccordionPanelTab"><fmt:message key="jsp.menu.student" /> <fmt:message key="jsp.general.examinationresult" /></div>
<div class="AccordionPanelContent">


<form:form modelAttribute="examinationResultForm">

<form:errors cssClass="errorwide" element="p"/>

<%-- invisible default button before any other submit button --%>
<input type="submit" class="defaultsink" name="submitexaminationresult" value="Save" />

<table>
    <tr>
        <td class="label"><fmt:message key="jsp.general.resultdate" /></td>
        <c:choose>
            <c:when test="${examinationResultAuthorization.createOrUpdate}">
                <td class="required">
                    <form:hidden path="examinationResult.examinationResultDate"/>
                    <table>
                        	<tr>
                        		<td><fmt:message key="jsp.general.day" /></td>
                        		<td><fmt:message key="jsp.general.month" /></td>
                        		<td><fmt:message key="jsp.general.year" /></td>
                        	</tr>
                            <tr>
                        		<td><input type="text" id="examinationresult_day" name="examinationresult_day" size="2" maxlength="2" value="<fmt:formatDate value='${examinationResultForm.examinationResult.examinationResultDate}' pattern='dd'/>" onchange="updateFullDate('examinationResult.examinationResultDate','day',document.getElementById('examinationresult_day').value);" /></td>
                        		<td><input type="text" id="examinationresult_month" name="examinationresult_month" size="2" maxlength="2" value="<fmt:formatDate value='${examinationResultForm.examinationResult.examinationResultDate}' pattern='MM'/>" onchange="updateFullDate('examinationResult.examinationResultDate','month',document.getElementById('examinationresult_month').value);" /></td>
                        		<td><input type="text" id="examinationresult_year" name="examinationresult_year" size="4" maxlength="4" value="<fmt:formatDate value='${examinationResultForm.examinationResult.examinationResultDate}' pattern='yyyy'/>" onchange="updateFullDate('examinationResult.examinationResultDate','year',document.getElementById('examinationresult_year').value);" /></td>
                        	</tr>
                    </table>
        		</td>
                <td>
                    <fmt:message key="jsp.general.message.dateformat" />
                    <form:errors path="examinationResult.examinationResultDate" cssClass="error"/>
                </td>
            </c:when>
            <c:otherwise>
                <c:if test="${examinationResultAuthorization.read}">
                    <td>
                        <fmt:formatDate value="${examinationResultForm.examinationResult.examinationResultDate}" />
                    </td>
                </c:if>
            </c:otherwise>
        </c:choose>
    </tr>

    <tr>
        <td class="label"><fmt:message key="jsp.general.brspassing" /></td>
        <td class="label" >
           <c:out value="${examinationResultForm.brsPassing}"/>
        </td> 
        <td>
            <fmt:message key="jsp.general.minimummark" />: <c:out value="${examinationResultForm.minimumMarkValue}"/>,
            <fmt:message key="jsp.general.maximummark" />: <c:out value="${examinationResultForm.maximumMarkValue}"/>
        </td>
    </tr>

    <tr>
        <td class="label"><b><fmt:message key="jsp.general.endgrade" /></b></td>
        <c:choose>
            <c:when test="${examinationResultAuthorization.createOrUpdate}">
                <td class="required">
                    <form:input path="examinationResult.mark" size="3" maxlength="6" autocomplete="off" />
                    <form:errors path="examinationResult.mark" cssClass="error"/>
                    	<c:choose>
                     		<c:when test="${examinationResultForm.examinationResult.endGrade != null && examinationResultForm.examinationResult.endGrade != ''}">
                     			&nbsp;(<fmt:message key="jsp.general.endgrade" />: <c:out value="${examinationResultForm.examinationResult.endGrade})"/>
                     		</c:when>
                     	</c:choose>
                </td>
                <td>
                    <input type="submit" name="generateExaminationResult" value="* <fmt:message key="jsp.button.generate" />" />
                </td>
            </c:when>
            <c:otherwise>
                <c:if test="${examinationResultAuthorization.read}">
                    <td>
                        <c:out value="${examinationResultForm.examinationResult.mark}"/> (<fmt:message key="jsp.general.endgrade" />: <c:out value="${examinationResultForm.examinationResult.endGrade}"/>)
                    </td>
                </c:if>
            </c:otherwise>
        </c:choose>
    </tr>

    <tr>
        <td class="label"><fmt:message key="jsp.general.passed" /></td>
        <c:if test="${examinationResultAuthorization.read}">
            <td>
                <fmt:message key="${stringToYesNoMap[examinationResultForm.examinationResult.passed]}"/>
            </td>
        </c:if>
    </tr>
    <tr>
        <td class="label"><b><fmt:message key="jsp.general.attemptnr" /></b></td>
        <c:if test="${examinationResultAuthorization.read}">
            <td>
                <c:out value="${examinationResultForm.examinationResult.attemptNr}"/>
            </td>
        </c:if>
    </tr>

    <tr>
        <td class="label"><fmt:message key="jsp.menu.staffmember" /></td>
        <c:choose>
            <c:when test="${examinationResultAuthorization.createOrUpdate}">
                <td class="required">
                    <form:select path="examinationResult.staffMemberId">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="examinationTeacher" items="${examination.teachersForExamination}">
                            <c:set var="staffMember" value="${examinationResultForm.idToExaminationTeacherMap[examinationTeacher.staffMemberId]}" />
                            <form:option value="${staffMember.staffMemberId}"><c:out value="${staffMember.surnameFull}, ${staffMember.firstnamesFull}"/></form:option>
                        </c:forEach>
                    </form:select>
                </td> 
                <td>
                    <form:errors path="examinationResult.staffMemberId" cssClass="error"/>
                </td>
            </c:when>
            <c:otherwise>
                <c:if test="${examinationResultAuthorization.read}">
                    <td>
                        <c:set var="staffMember" value="${examinationResultForm.idToExaminationTeacherMap[examinationResultForm.examinationResult.staffMemberId]}" />
                        <c:out value="${staffMember.firstnamesFull} ${staffMember.surnameFull}"/>
                    </td>
                </c:if>
            </c:otherwise>
        </c:choose>
    </tr>
    <%--  do not show active -> default is active 
    <tr>
        <td class="label"><fmt:message key="jsp.general.active" /></td>
        <td><spring:bind path="command.active">
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
        <td>
        <c:forEach var="error" items="${status.errorMessages}"><span class="error">
            ${error}</span></c:forEach></spring:bind>
        </td>
    </tr>--%>

    <c:if test="${examinationResultAuthorization.createOrUpdate}">
        <tr><td>&nbsp;</td>
            <td align="right" colspan="2">
                <input type="submit" name="submitexaminationresult" value="<fmt:message key="jsp.button.submit" />" />
            </td>
        </tr>
    </c:if>
    
    <!-- EXAMINATION RESULT HISTORY -->
	 <sec:authorize access="hasAnyRole('RESULT_HISTORY')">
	    <table class="tabledata2" id="TblData">
	
		  <tr>
		    	<th class="label"><fmt:message key="jsp.general.writewho"/></th>
		    	<th class="label"><fmt:message key="jsp.general.staffmember"/></th>
		    	<th class="label"><fmt:message key="jsp.general.operation"/></th>
		    	<th class="label"><fmt:message key="jsp.general.mark"/></th>
		    	<th class="label"><fmt:message key="jsp.general.passed"/></th>
		    	<th class="label"><fmt:message key="jsp.general.endgradecomment"/></th>	    	
		    	<th class="label"><fmt:message key="jsp.general.writewhen"/></th>
		   </tr>
		    
		  <c:forEach var="history" items="${examinationResultForm.examinationResultHistories}">
		    <tr>
		    		<td><c:out value="${history.writewho}"/></td>
		    		<td><c:out value="${history.firstnamesFull}
		    						  ${history.surnameFull}"/>
		    						  </td>
		    		<td><fmt:message key="general.history.operation.${fn:toLowerCase(history.operation)}" /></td>
		    		<td><c:out value="${history.mark}"/></td>
		    		<td><fmt:message key="general.history.passed.${fn:toLowerCase(history.passed)}" /></td>
		    		<td>
		    			<c:if test="${not empty history.examinationResultCommentId}">
		                	<fmt:message key="${examinationResultForm.idToExaminationResultCommentMap[history.examinationResultCommentId].commentKey}"/>
		                </c:if>
		    		</td>
		    		<td><fmt:formatDate type="both" dateStyle="medium" timeStyle="medium" value="${history.writewhen}" /></td>
		    </tr>
		 </c:forEach>
	   </table>
	   <script type="text/javascript">alternate('TblData', false)</script>
	   <hr/>
	 </sec:authorize>

    <!-- TESTS & TESTRESULTS -->

    <c:choose>
        <c:when test="${showEditStudyPlanResult || possibleTeacher}">
             <tr>
                <td class="label" colspan="3"><fmt:message key="jsp.general.active" /> <fmt:message key="jsp.general.tests" /></td>
             </tr><br/>
            <tr>
                <td colspan="3">
                    <fmt:message key="general.percentagetotal" />:
                    <c:out value="${examinationResultForm.percentageTotal}"/>
                </td>
            </tr>
            <c:choose>
                <c:when test="${examinationResultForm.percentageTotal ne 0 && examinationResultForm.percentageTotal ne 100}">       
                    <tr>
                        <td align="left" colspan="3">
                            <p class="errorwide">
                                <fmt:message key="jsp.error.percentagetotal" />
                            </p>
                         </td>
                    </tr>
                </c:when>
            </c:choose>
    
             <c:choose>        
                <c:when test="${ not empty showTestResultsError }">       <%-- TODO get rid of --%>
                   <tr>
                       <td align="left" colspan="3">
                           <p class="error">
                               <c:out value="${showTestResultsError}"/>
                           </p>
                        </td>
                   </tr>
               </c:when>
            </c:choose>

            <c:choose>
                <c:when test="${not empty examination.tests}">
                    <tr>
                        <td colspan="3">
                            <table>
                                <tr>
                                    <th>&nbsp;</th>
                                    <th><fmt:message key="jsp.general.weighingfactor" />
                                        <br />/<fmt:message key="jsp.general.resultdate" />
                                    </th>
                                    <th style="width: 100px;"><fmt:message key="jsp.general.mark" /></th>
                                    <th><fmt:message key="jsp.general.attemptnr" /></th>
                                     <!--  <td class="label"><fmt:message key="jsp.general.active" /></td>-->
                                    <th>&nbsp;</th>
                                </tr>
                                <c:forEach var="test" items="${examination.tests}">
                                    <c:set var="numberOfAttempts" value="${test.numberOfAttempts}" scope="page" />
                                    <c:set var="testResultSave" value="" scope="page" />
                        			<c:set var="maxAttemptNr" value="0" scope="page" />

                                    <tr>
                                        <td class="label">
                                            <c:out value="${test.testCode}"/><br/>(<c:out value="${test.testDescription}"/>)
                                        </td>
                                        <td class="label">
                                            <c:out value="${test.weighingFactor} %"/>
                                        </td>
                                        <td colspan="5">&nbsp;</td>
                                    </tr>

<%--                                     <spring:bind path="command.testResults"> --%>

                                    <%-- first count number of attempts made for display style --%>
                                    <c:forEach var="testResult" items="${examinationResultForm.examinationResult.testResults}">
                                        <c:choose>
                                            <c:when test="${testResult.testId == test.id}">
                                            	<c:set var="maxAttemptNr" value="${testResult.attemptNr}" scope="page" />
                                     		</c:when>
                                     	</c:choose>
                                    </c:forEach>

                                    <c:forEach var="testResult" items="${examinationResultForm.examinationResult.testResults}">
                                        <c:choose>
                                            <c:when test="${testResult.testId == test.id}">
                                    			<c:set var="testResultSave" value="${testResult.id}" scope="page" />
                                    			
                                                <c:choose>
    												<c:when test="${testResult.attemptNr != maxAttemptNr}"> 
                                                		<c:set var="testResultClass" value='class="grey"'/>
                                                	</c:when>
                                                	<c:otherwise>
                                                		<c:set var="testResultClass" value=''/>
                                                	</c:otherwise>
                                                </c:choose>
                                                <tr ${testResultClass}>
                                                    <td>&nbsp;</td>
                                                    <td>
                                                        <fmt:formatDate pattern="dd/MM/yyyy" value="${testResult.testResultDate}" />
                                                    </td>
                                                    <td>
                                                        <c:out value="${testResult.mark}"/>
                                                    </td>
                                                    <td>
                                                        <c:out value="${testResult.attemptNr}"/>
                                                    </td>
                                                    <!-- 
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${'Y' == testResult.active}">
                                                                <fmt:message key="jsp.general.yes" />
                                                            </c:when>
                                                            <c:otherwise>
                                                               <fmt:message key="jsp.general.no" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td> -->
                                                    <td class="buttonsCell">
    					                                <c:choose>
    					                                    <c:when test="${showEditStudyPlanResult || possibleTeacher}">
                                                                <c:choose>
    																<c:when test="${testResult.attemptNr == maxAttemptNr}"> 
                                                                		<a class="imageLink" href="<c:url value='/college/testresult.view?newForm=true&amp;tab=${tab}&amp;panel=${panel}&amp;studyPlanDetailId=${studyPlanDetailId}&amp;examinationResultId=${examinationResultId}&amp;studentId=${student.studentId}&amp;testResultId=${testResultSave}&amp;examinationId=${examination.id}&amp;testId=${test.id}&amp;currentPageNumber=${currentPageNumber}'/>">
                                                                   			<img src="<c:url value='/images/edit.gif'/>" alt="<fmt:message key='jsp.href.edit' />" title="<fmt:message key='jsp.href.edit' />" />
                                                                   		</a>
                                                                        <a class="imageLinkPaddingLeft" href="<c:url value='/college/examinationresult/deletetestresult.view?newForm=true&amp;tab=${tab}&amp;panel=${panel}&amp;examinationResultId=${examinationResultId}&amp;studentId=${student.studentId}&amp;testResultId=${testResultSave}&amp;currentPageNumber=${currentPageNumber}'/>"  
                                                                        onclick="return confirm('<fmt:message key="jsp.testresult.delete.confirm" />')">
                                                                        <img src="<c:url value='/images/delete.gif'/>" alt="<fmt:message key='jsp.href.delete' />" title="<fmt:message key='jsp.href.delete' />" /> 
                                                                    	</a>
                                                                	</c:when>
                                                                </c:choose>
    						                                 </c:when>
    						                            </c:choose>
                                                    </td>
                                                </tr>
                                            </c:when>
                                        </c:choose>
                                    </c:forEach>
<%--                                     </spring:bind> --%>

                                    <c:choose>
                                        <c:when test="${maxAttemptNr == null 
                                            || ( maxAttemptNr != null && numberOfAttempts > maxAttemptNr )
                                                }">
                                            <tr>
                                                <td colspan="5">&nbsp;</td>
                                                <td class="buttonsCell">
                                                    <a class="button" href="<c:url value='/college/testresult.view?newForm=true&amp;tab=${tab}&amp;panel=${panel}&amp;studyPlanDetailId=${studyPlanDetailId}&amp;examinationResultId=${examinationResultId}&amp;studentId=${student.studentId}&amp;examinationId=${examination.id}&amp;testId=${test.id}&amp;currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                                </td>
                                            </tr>
                                        </c:when>
                                    </c:choose>
        
                                </c:forEach>
                            </table>
                        </td>
                    </tr>

                </c:when>
            </c:choose>

        </c:when>
    </c:choose>
    
</table>
</form:form>
</div>
</div>
</div>
<script type="text/javascript">
    var Accordion0 = new Spry.Widget.Accordion("Accordion0",
      {defaultPanel: 0,
      useFixedPanelHeights: false,
      nextPanelKeyCode: 78 /* n key */,
      previousPanelKeyCode: 80 /* p key */
     });
    
</script>
</div>     
</div>
</div>
</div>
    
<script type="text/javascript">
    var tp1 = new Spry.Widget.TabbedPanels("tp1");
    //tp1.showPanel(<%=request.getParameter("tab")%>);
    tp1.showPanel(0);
</script>
</div>

<%@ include file="../../footer.jsp"%>

