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

<div id="wrapper">

    <%@ include file="../../menu.jsp"%>

    <c:set var="student" value="${studentStudentStatusForm.student}" />
    <c:set var="navigationSettings" value="${studentStudentStatusForm.navigationSettings}" scope="page" />

    <div id="tabcontent">

		<fieldset>
			<legend>
                <a href="<c:url value='/college/students.view'/>?<c:out value='currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
                <c:choose>
                    <c:when test="${
                            opusUserRole.role == 'student' 
                            || opusUserRole.role == 'guest'
                            || opusUserRole.role == 'staffmember'
                            }">
		                <a href="<c:url value='/college/student/subscription.view'/>?<c:out value='tab=${navigationSettings.tab}&panel=${navigationSettings.panel}&studentId=${student.studentId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                    </c:when>
                    <c:otherwise>
                        <a href="<c:url value='/college/student/subscription.view'/>?<c:out value='tab=${navigationSettings.tab}&panel=${navigationSettings.panel}&studentId=${student.studentId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                    </c:otherwise>
                </c:choose>
    			<c:choose>
    				<c:when test="${student.surnameFull != null && student.surnameFull != ''}" >
    					<c:set var="studentName" value="${student.surnameFull}, ${student.firstnamesFull}" scope="page" />
    					<c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}"/>
					</c:when>
					<c:otherwise>
						<fmt:message key="jsp.href.new" />
					</c:otherwise>
				</c:choose>
				</a>
				&nbsp;>&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.studentstatus" /> 
			</legend>
		</fieldset>


        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.studentstatus" /></li>               
            </ul>

            <div class="TabbedPanelsContentGroup">   
                    <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion1" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab"><fmt:message key="jsp.general.studentstatus" /></div>
                                <div class="AccordionPanelContent">

                                <form:form modelAttribute="studentStudentStatusForm" method="post">
                                
                                    <table>
                                    <tr>
                                        <td class="label"><b><fmt:message key="jsp.general.startdate" /></b></td>
                                        <spring:bind path="studentStudentStatus.startDate">
                                        <td class="required">
                                        <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
             	                        <table>
                                            	<tr>
                                            		<td><fmt:message key="jsp.general.day" /></td>
                                            		<td><fmt:message key="jsp.general.month" /></td>
                                            		<td><fmt:message key="jsp.general.year" /></td>
                                            	</tr>
                                                <tr>
                                            		<td><input type="text" id="start_ti_day" name="start_ti_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('studentStudentStatus.startDate','day',document.getElementById('start_ti_day').value);" /></td>
                                            		<td><input type="text" id="start_ti_month" name="start_ti_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('studentStudentStatus.startDate','month',document.getElementById('start_ti_month').value);" /></td>
                                            		<td><input type="text" id="start_ti_year" name="start_ti_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('studentStudentStatus.startDate','year',document.getElementById('start_ti_year').value);" /></td>
                                            	</tr>
                                        </table>
                           				</td>
                                        <td>
                                            <fmt:message key="jsp.general.message.dateformat" />
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td>
                                        </spring:bind>
                                    </tr>
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.statuscode" /></td>
                                        <td class="required">
                                            <form:select path="studentStudentStatus.studentStatusCode">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach var="oneStatus" items="${studentStudentStatusForm.allStudentStatuses}">
                                                    <form:option value="${oneStatus.code}"><c:out value="${oneStatus.description}"/></form:option>
<%--                                                   <c:choose>
                                                    <c:when test="${oneStatus.code == status.value}">
                                                        <option value="${oneStatus.code}" selected="selected"><c:out value="${oneStatus.description}"/></option>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <option value="${oneStatus.code}"><c:out value="${oneStatus.description}"/></option>
                                                    </c:otherwise>
                                                   </c:choose> --%>
                                                </c:forEach>
                                            </form:select>
                                        </td>
                                        <td>
                                            <form:errors path="studentStudentStatus.studentStatusCode" cssClass="error"/>
<%--                                         <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach> --%>
                                        </td>
                                    </tr>
 
                                    <tr><td class="label">&nbsp;</td><td><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td></tr>

                                </table>

                                </form:form>
                                </div>
                            </div>
                        </div>
                        <script type="text/javascript">
                            var sampleAccordion = new Spry.Widget.Accordion("Accordion1",
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
        tp1.showPanel(<%=request.getParameter("tab")%>);
    </script>
</div>

<%@ include file="../../footer.jsp"%>

