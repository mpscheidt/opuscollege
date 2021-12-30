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

<c:set var="screentitlekey">jsp.general.testresult</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="wrapper">

<%@ include file="../../menu.jsp"%>

<c:set var="student" value="${testResultForm.student}" />
<c:set var="studyPlan" value="${testResultForm.studyPlan}" />
<c:set var="studyPlanDetailId" value="${testResultForm.studyPlanDetailId}" />
<c:set var="studyPlanCardinalTimeUnit" value="${testResultForm.studyPlanCardinalTimeUnit}" />
<c:set var="subject" value="${testResultForm.subject}" />
<c:set var="examination" value="${testResultForm.examination}" />
<c:set var="test" value="${testResultForm.test}" />
<c:set var="minimumMarkValue" value="${testResultForm.minimumMarkValue}" />
<c:set var="maximumMarkValue" value="${testResultForm.maximumMarkValue}" />

<c:set var="tab" value="${testResultForm.navigationSettings.tab}" />
<c:set var="panel" value="${testResultForm.navigationSettings.panel}" />
<c:set var="currentPageNumber" value="${testResultForm.navigationSettings.currentPageNumber}" />

<!-- authorizations -->
<c:set var="showEditStudyPlanResult" value="${false}"/>
<sec:authorize access="hasRole('UPDATE_STUDYPLAN_RESULTS')">
	<c:set var="showEditStudyPlanResult" value="${true}"/>
</sec:authorize>

<%--     <spring:bind path="command.id"> --%>
<%--         <c:set var="commandId" value="${status.value}" scope="page" /> --%>
<%--     </spring:bind> --%>

<div id="tabcontent">

<fieldset>
	<legend>
	 <a href="<c:url value='/college/studyplanresults.view?newForm=true&amp;currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
     &nbsp;&gt;&nbsp;<a href="<c:url value='/college/studyplanresult.view?newForm=true&amp;tab=${tab}&amp;panel=${panel}&amp;studentId=${student.studentId}&amp;studyPlanId=${studyPlan.id}&amp;currentPageNumber=${currentPageNumber}'/>">
        <c:choose>
            <c:when test="${student.surnameFull != null and student.surnameFull != ''}" >
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
			<c:when test="${studyPlanCardinalTimeUnit.cardinalTimeUnitNumber != null and studyPlanCardinalTimeUnit.cardinalTimeUnitNumber != ''}" >
				<fmt:message key="jsp.general.cardinaltimeunit.number" /> ${studyPlanCardinalTimeUnit.cardinalTimeUnitNumber}
			</c:when>
		</c:choose>
		</a>
		&nbsp;&gt;&nbsp;<a href="<c:url value='/college/subjectresult.view?newForm=true?tab=${tab}&amp;panel=${panel}&amp;studentId=${student.studentId}&amp;subjectResultId=${subjectResultId}&amp;studyPlanDetailId=${studyPlanDetailId}&amp;subjectId=${subject.id}&amp;currentPageNumber=${currentPageNumber}'/>">
			<c:out value="${fn:substring(subject.subjectDescription,0,initParam.iTitleLength)}"/>
		</a>
        <br />&nbsp;&nbsp;&nbsp;&nbsp;&gt;&nbsp;<a href="<c:url value='/college/examinationresult.view?newForm=true&amp;tab=${tab}&amp;panel=${panel}&amp;studentId=${student.studentId}&amp;examinationResultId=${testResultForm.examinationResultId}&amp;studyPlanDetailId=${studyPlanDetailId}&amp;subjectId=${subject.id}&amp;examinationId=${examination.id }&amp;currentPageNumber=${currentPageNumber}'/>">
            <c:out value="${fn:substring(examination.examinationDescription,0,initParam.iTitleLength)}"/>
        </a>
        &nbsp;&gt;&nbsp;<c:out value="${fn:substring(test.testDescription,0,initParam.iTitleLength)}"/>
		&nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.testresult" /> 

	</legend>
</fieldset>

<div id="tp1" class="TabbedPanel">
   <!--  <ul class="TabbedPanelsTabGroup">
        <li class="TabbedPanelsTab"><fmt:message key="jsp.general.testresult" /></li>               
    </ul> -->

<div class="TabbedPanelsContentGroup">   
<div class="TabbedPanelsContent">
<div class="Accordion" id="Accordion0">
<div class="AccordionPanel">
<div class="AccordionPanelTab"><fmt:message key="jsp.general.testresult" /></div>
<div class="AccordionPanelContent">


<form:errors cssClass="errorwide" element="p"/> <%-- only print global errors if any --%>

<form:form modelAttribute="testResultForm">
    <table>
        <tr>
            <td class="label"><fmt:message key="jsp.general.resultdate" /></td>
            <spring:bind path="testResultForm.testResult.testResultDate">
            <td class="required">
            <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
            <table>
                	<tr>
                		<td><fmt:message key="jsp.general.day" /></td>
                		<td><fmt:message key="jsp.general.month" /></td>
                		<td><fmt:message key="jsp.general.year" /></td>
                	</tr>
                    <tr>
                		<td><input type="text" id="testresult_day" name="testresult_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('testResultDate','day',document.getElementById('testresult_day').value);" /></td>
                		<td><input type="text" id="testresult_month" name="testresult_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('testResultDate','month',document.getElementById('testresult_month').value);" /></td>
                		<td><input type="text" id="testresult_year" name="testresult_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('testResultDate','year',document.getElementById('testresult_year').value);" /></td>
                	</tr>
            </table>
 			</td>
            <td>
                <fmt:message key="jsp.general.message.dateformat" />
                <c:forEach var="error" items="${status.errorMessages}"><span class="error"><c:out value="${error}"/></span></c:forEach>
            </td>
            </spring:bind>
        </tr>

        <tr>
            <td class="label"><fmt:message key="jsp.general.brspassing" /></td>
            <td class="label" >
               <c:out value="${brsPassing}"/>
            </td> 
            <td>
                <fmt:message key="jsp.general.minimummark" />: <c:out value="${minimumMarkValue}"/>,
                <fmt:message key="jsp.general.maximummark" />: <c:out value="${maximumMarkValue}"/>
            </td>
        </tr>

        <tr>
            <td class="label"><b><fmt:message key="jsp.general.mark" /></b></td>
            <td class="required">
                <spring:bind path="testResultForm.testResult.mark">
                    <input type="text" id="${status.expression}" name="${status.expression}" size="3" maxlength="6" autocomplete="off" value="<c:out value='${status.value}' />"  />
                	<c:forEach var="error" items="${status.errorMessages}"><span class="error"><c:out value="${error}"/></span></c:forEach>
	             </spring:bind>
	             <spring:bind path="testResultForm.testResult.endGrade">
                	<c:choose>
                 		<c:when test="${status.value != null and status.value != ''}">
                 			&nbsp;(<fmt:message key="jsp.general.endgrade" />: <c:out value="${status.value}"/>)
                 		</c:when>
                 	</c:choose>
	            </spring:bind>
            </td>
         </tr>

         <tr>
             <td class="label"><fmt:message key="jsp.general.passed" /></td>
             <td>
                 <c:choose>
                     <c:when test="${'Y' == testResultForm.testResult.passed}">
                         <fmt:message key="jsp.general.yes" />
                     </c:when>
                     <c:otherwise>
                         <fmt:message key="jsp.general.no" />
                     </c:otherwise>
                 </c:choose>
             </td>
          </tr>

        <tr>
            <td class="label"><b><fmt:message key="jsp.general.attemptnr" /></b></td>
            <td>
                <c:out value="${testResultForm.testResult.attemptNr}"/>
            </td>
        </tr>

        <tr>
            <td class="label"><fmt:message key="jsp.menu.staffmember" /></td>
            <td class="required">
                <form:select path="testResult.staffMemberId">
                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                    <c:forEach var="testTeacher" items="${test.teachersForTest}">
                        <c:set var="staffMember" value="${testResultForm.idToTestTeacherMap[testTeacher.staffMemberId]}" />
                        <form:option value="${staffMember.staffMemberId}"><c:out value="${staffMember.surnameFull}, ${staffMember.firstnamesFull}"/></form:option>
                    </c:forEach>
                </form:select>
            </td> 
            <td>
                <form:errors path="testResult.staffMemberId" cssClass="error"/>
            </td>
        </tr>
        <!--  do not show active -> default is active 
        <tr>
            <td class="label"><fmt:message key="jsp.general.active" /></td>
            <td><spring:bind path="testResultForm.testResult.active">
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
        </tr>-->

        <tr><td>&nbsp;</td>
            <td align="right" colspan="2"><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td>
        </tr>

    </table>
    </br>
   <sec:authorize access="hasAnyRole('RESULT_HISTORY')">
	 <table class="tabledata2" id="TblData">
		  <tr>
		    	<th class="label"><fmt:message key="jsp.general.writewho"/></th>
		    	<th class="label"><fmt:message key="jsp.general.staffmember"/></th>
		    	<th class="label"><fmt:message key="jsp.general.operation"/></th>
		    	<th class="label"><fmt:message key="jsp.general.mark"/></th>
		    	<th class="label"><fmt:message key="jsp.general.passed"/></th>
		    	<th class="label"><fmt:message key="jsp.general.writewhen"/></th>
		   </tr>
		    
		  <c:forEach var="history" items="${testResultForm.testResultHistories}">
		    <tr>
		    		<td><c:out value="${history.writewho}"/></td>
		    		<td><c:out value="${history.firstnamesFull}
		    						  ${history.surnameFull}"/>
		    						  </td>
		    		<td><fmt:message key="general.history.operation.${fn:toLowerCase(history.operation)}" /></td>
		    		<td><c:out value="${history.mark}"/></td>
		    		<td><fmt:message key="general.history.passed.${fn:toLowerCase(history.passed)}" /></td>
		    		<td><fmt:formatDate type="both" dateStyle="medium" timeStyle="medium" value="${history.writewhen}" /></td>
		    </tr>
		 </c:forEach>
	</table>
	<script type="text/javascript">alternate('TblData', false)</script>
  </sec:authorize>
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

