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

<c:set var="organization" value="${cardinalTimeUnitResultForm.organization}" scope="page" />
<c:set var="navigationSettings" value="${cardinalTimeUnitResultForm.navigationSettings}" scope="page" />

<c:set var="student" value="${cardinalTimeUnitResultForm.student}" scope="page" />
<c:set var="studyPlan" value="${cardinalTimeUnitResultForm.studyPlan}" scope="page" />
<c:set var="studyGradeType" value="${cardinalTimeUnitResultForm.studyGradeType}" scope="page" />
<c:set var="studyPlanCardinalTimeUnit" value="${cardinalTimeUnitResultForm.studyPlanCardinalTimeUnit}" scope="page" />
<c:set var="cardinalTimeUnitResult" value="${cardinalTimeUnitResultForm.studyPlanCardinalTimeUnit.cardinalTimeUnitResult}" scope="page" />

<%-- authorizations --%>
<c:set var="cardinalTimeUnitResultAuthorization" value="${cardinalTimeUnitResultForm.cardinalTimeUnitResultAuthorization}" />


<div id="tabcontent">

<fieldset>
    <legend>
        <a href="<c:url value='/college/studyplanresults.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>

        &nbsp;&gt;&nbsp;<a href="<c:url value='/college/studyplanresult.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;studentId=${student.studentId}&amp;studyPlanId=${studyPlan.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
        <c:choose>
            <c:when test="${not empty student.surnameFull}" >
                <c:set var="studentName" value="${student.studentCode}: ${student.surnameFull}, ${student.firstnamesFull}" scope="page" />
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

        <br />&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.cardinaltimeunitresults" /> 
    </legend>

    <form:errors path="cardinalTimeUnitResultForm.*" cssClass="errorwide" element="p"/>
	<c:choose>        
 		<c:when test="${ not empty cardinalTimeUnitResultForm.txtMsg }">       
   	       <p align="right" class="msg">
   	            <c:out value="${cardinalTimeUnitResultForm.txtMsg}"/>
   	       </p>
  	 	</c:when>
	</c:choose>
</fieldset>


<div id="tp1" class="TabbedPanel">

<div class="TabbedPanelsContentGroup">   
<div class="TabbedPanelsContent">
<div class="Accordion" id="Accordion0">
<div class="AccordionPanel">
<div class="AccordionPanelTab"><fmt:message key="jsp.general.studyplancardinaltimeunit" />&nbsp;<fmt:message key="jsp.general.results" /></div>
<div class="AccordionPanelContent">

<form:form modelAttribute="cardinalTimeUnitResultForm">

    <%-- invisible default button before any other submit button --%>
    <input type="submit" class="defaultsink" name="submitcardinaltimeunitresultdata" value="Save" />

    <!--  CROSSLINK TO STUDYPLANCARDINALTIMEUNIT -->
    <div class="crosslinkbar">
        <a class="button" href="<c:url value='/college/studyplancardinaltimeunit.view?newForm=true&amp;tab=0&amp;panel=0&amp;studyPlanId=${studyPlan.id}&amp;studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&amp;currentPageNumber=1'/>">
            <fmt:message key="jsp.general.studyplancardinaltimeunitoverview" /> 
        </a>
    </div>

    <table>

 		<tr>
         	<td class="label" colspan="2">

                <c:out value="${studyGradeType.studyDescription}"/>
                <c:out value="${cardinalTimeUnitResultForm.codeToGradeTypeMap[studyGradeType.gradeTypeCode].description}"/>
                <c:forEach var="academicYear" items="${cardinalTimeUnitResultForm.allAcademicYears}">
               	<c:choose>
                   	<c:when test="${academicYear.id == studyGradeType.currentAcademicYearId}">
                       <c:out value="${academicYear.description}"/>
					</c:when>
                  </c:choose>
               </c:forEach>
            </td>
            <td>
         		<fmt:message key="jsp.general.minimummark" />: <c:out value="${cardinalTimeUnitResultForm.minimumMarkValue}"/>,
                <fmt:message key="jsp.general.maximummark" />: <c:out value="${cardinalTimeUnitResultForm.maximumMarkValue}"/>
            </td>
         </tr>
		<tr>
			<td class="label"><fmt:message key="jsp.general.cardinaltimeunit.number" /></td>
			<td>
				<c:out value="${studyPlanCardinalTimeUnit.cardinalTimeUnitNumber}"/>
			 </td>
			 <td>&nbsp;</td>
	    </tr>
		<tr>
			<td class="label"><fmt:message key="jsp.general.cardinaltimeunit" /></td>
			<td>
                <c:out value="${cardinalTimeUnitResultForm.codeToCardinalTimeUnitMap[cardinalTimeUnitResultForm.studyGradeType.cardinalTimeUnitCode].description}"/>
			 </td>
	    </tr>
	    <tr>
            <td class="label"><fmt:message key="jsp.general.cardinaltimeunitstatus" /></td>
            <td>
                <c:out value="${cardinalTimeUnitResultForm.codeToCardinalTimeUnitStatusMap[studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode].description}"/>
            </td>
        </tr>
        <tr>
            <td class="label"><fmt:message key="jsp.general.progressstatus" /></td>
            <td>
                <c:out value="${cardinalTimeUnitResultForm.codeToProgressStatusMap[studyPlanCardinalTimeUnit.progressStatusCode].description}"/>
           </td>
        </tr>
        <tr>
            <td class="label"><fmt:message key="jsp.general.dateofendgrade" /></td>
            <c:choose>
                <c:when test="${cardinalTimeUnitResultAuthorization.createOrUpdate}">
                    <spring:bind path="studyPlanCardinalTimeUnit.cardinalTimeUnitResult.cardinalTimeUnitResultDate">
                    <td class="required">
                     	<input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                         <table>
                             <tr>
                                 <td><fmt:message key="jsp.general.day" /></td>
                                 <td><fmt:message key="jsp.general.month" /></td>
                                 <td><fmt:message key="jsp.general.year" /></td>
                             </tr>
                             <c:choose>
                                <c:when test="${empty studyPlanCardinalTimeUnit.progressStatusCode
                                      and studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED}">
                                     <tr>
                                         <td><input type="text" id="ctu_day" name="ctu_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('studyPlanCardinalTimeUnit.cardinalTimeUnitResult.cardinalTimeUnitResultDate','day',document.getElementById('ctu_day').value);" /></td>
                                         <td><input type="text" id="ctu_month" name="ctu_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('studyPlanCardinalTimeUnit.cardinalTimeUnitResult.cardinalTimeUnitResultDate','month',document.getElementById('ctu_month').value);" /></td>
                                         <td><input type="text" id="ctu_year" name="ctu_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('studyPlanCardinalTimeUnit.cardinalTimeUnitResult.cardinalTimeUnitResultDate','year',document.getElementById('ctu_year').value);" /></td>
                                     </tr>
                                 </c:when>
                                 <c:otherwise>
                                     <tr>
                                         <td>${fn:substring(status.value,8,10)}</td>
                                         <td>${fn:substring(status.value,5,7)}</td>
                                         <td>${fn:substring(status.value,0,4)}</td>
                                     </tr>
                                 </c:otherwise>
                             </c:choose>
                         </table>
                    </td>
                    <td colspan="3">
                         <fmt:message key="jsp.general.message.dateformat" />
                         <c:forEach var="error" items="${status.errorMessages}"><span class="error"><c:out value="${error}"/></span></c:forEach>
                    </td>
                    </spring:bind>
                </c:when>
                <c:otherwise>
                    <c:if test="${cardinalTimeUnitResultAuthorization.read}">
                        <td>
                            <fmt:formatDate value="${cardinalTimeUnitResultForm.studyPlanCardinalTimeUnit.cardinalTimeUnitResult.cardinalTimeUnitResultDate}" />
                        </td>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </tr>

        <tr>
            <td class="label"><b><fmt:message key="jsp.general.mark.value" /></b></td>
            <c:choose>
                <c:when test="${cardinalTimeUnitResultAuthorization.createOrUpdate}">
                    <td class="required">
                        <spring:bind path="studyPlanCardinalTimeUnit.cardinalTimeUnitResult.mark">
                	        <input type="text" name="${status.expression}" id="${status.expression}" size="3" maxlength="6" autocomplete="off" value="<c:out value='${status.value}' />" />
                         	<c:forEach var="error" items="${status.errorMessages}">
                                <span class="error"><c:out value="${error}"/></span>
                            </c:forEach>
                        </spring:bind>
             			<c:out value="${cardinalTimeUnitResultForm.ctuResultFormatter[cardinalTimeUnitResultForm.cardinalTimeUnitResultInDb]}"/>
                    </td>
                    <td colspan="3">
                         <input type="submit" name="generateResultButton" value="* <fmt:message key='jsp.button.generate' />" />
                    </td>
                </c:when>
                <c:otherwise>
                    <c:if test="${cardinalTimeUnitResultAuthorization.read}">
                        <td>
                            <c:out value="${cardinalTimeUnitResultForm.ctuResultFormatter[cardinalTimeUnitResult]}"/>
                        </td>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </tr>

        <c:if test="${cardinalTimeUnitResultForm.endGradesPerGradeType == 'Y'}">
             <tr>
                <td class="label"><b><fmt:message key="jsp.general.endgrade.comment" /></b></td>
                <td>
                    <spring:bind path="studyPlanCardinalTimeUnit.cardinalTimeUnitResult.endGradeComment">
                        <c:choose>
                            <c:when test="${cardinalTimeUnitResultAuthorization.createOrUpdate && 
                                        ( cardinalTimeUnitResultForm.studyPlanCardinalTimeUnit.cardinalTimeUnitResult.mark == '0.0'
                                       || cardinalTimeUnitResultForm.studyPlanCardinalTimeUnit.cardinalTimeUnitResult.mark == '0' )
                               }">
                               <select name="${status.expression}" id="${status.expression}">
                                 <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                 <c:forEach var="endGrade" items="${cardinalTimeUnitResultForm.fullFailGradeCommentsForGradeType}">
                                         <c:choose>
                                             <c:when test="${endGrade != '' and endGrade.code == status.value}">
                                                 <option value="${endGrade.code}" selected="selected"><c:out value="${endGrade.comment}"/></option> 
                                             </c:when>
                                             <c:otherwise>
                                                 <option value="${endGrade.code}"><c:out value="${endGrade.comment}"/></option> 
                                             </c:otherwise>
                                         </c:choose>
                                  </c:forEach>
                              </select>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="endGrade" items="${cardinalTimeUnitResultForm.fullEndGradeCommentsForGradeType}">
                                    <c:if test="${endGrade.code == status.value}">
                                        <c:out value="${endGrade.comment}"/>
                                    </c:if>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </spring:bind>
                </td>
                <td colspan="3"></td>
            </tr>
        </c:if>

        <tr>
            <td class="label"><fmt:message key="jsp.general.passed" /></td>
            <c:if test="${cardinalTimeUnitResultAuthorization.read}">
                <spring:bind path="studyPlanCardinalTimeUnit.cardinalTimeUnitResult.passed">
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
                <td colspan="3">
                    <c:forEach var="error" items="${status.errorMessages}"><span class="error"><c:out value="${error}"/></span></c:forEach>
                </td>
                </spring:bind>
            </c:if>
        </tr>

             <%-- do not show active -> default = Y 
             <tr>
                 <td class="label"><fmt:message key="jsp.general.active" /></td>
                 <td><spring:bind path="cardinalTimeUnitResultForm.cardinalTimeUnitResult.active">
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
             </tr> --%>

        <c:if test="${cardinalTimeUnitResultAuthorization.createOrUpdate}">
            <tr>
                <td align="right" colspan="5">
                    <input type="submit" name="submitcardinaltimeunitresultdata" value="<fmt:message key='jsp.button.submit' />" />
                </td>
            </tr>
        </c:if>

	</table>
</form:form>

<table>
    <tr>
    	<td class="header"><fmt:message key="jsp.general.subject" />&nbsp;<fmt:message key="jsp.general.results" /></td>
    </tr>
</table>

	<%@ include file="../../includes/studyPlanDetailsForCTUResult.jsp"%>

<%--
    	</c:when>
    	<c:otherwise>
             <tr>
             <td colspan="6">
              ${opusUserRole.role } - 
                 <fmt:message key="jsp.general.authorization.issue" />: <fmt:message key="jsp.general.exams" /> <fmt:message key="jsp.general.not.editable" />
                 </td>
             </tr>
             <tr><td colspan="6">&nbsp;</td></tr>
        </c:otherwise>
    </c:choose> --%>
		
</div> <!-- end of accordionpanelcontent --> 
</div> <!-- end of accordionpanel -->  

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
    
<!-- end of tabcontent -->
</div>   

<script type="text/javascript">
    var tp1 = new Spry.Widget.TabbedPanels("tp1");
    //tp1.showPanel(<%=request.getParameter("tab")%>);
    tp1.showPanel(0);
</script>
   
<!-- end of tabwrapper -->    
</div>

<%@ include file="../../footer.jsp"%>

