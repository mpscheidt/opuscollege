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

    <c:set var="student" value="${studentAbsenceForm.student}" />

    <div id="tabcontent">

		<fieldset>
			<legend>
                <a href="<c:url value='/college/students.view'/>?<c:out value='currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
                <a href="<c:url value='/college/student-absences.view'/>?<c:out value='tab=${tab}&panel=0&studentId=${student.studentId}&currentPageNumber=${currentPageNumber}'/>">
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
				&nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.studentabsences" /> 
			</legend>
		</fieldset>

        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.studentabsences" /></li>               
            </ul>

            <div class="TabbedPanelsContentGroup">   
                    <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion1" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab"><fmt:message key="jsp.general.studentabsence" /></div>
                                <div class="AccordionPanelContent">

                                <form:form modelAttribute="studentAbsenceForm" method="post">

                                    <table>
                                    <tr>
                                        <td class="label"><b><fmt:message key="jsp.general.startdatetemporaryinactivity" /></b></td>
                                        <td class="required"><form:hidden path="studentAbsence.startdateTemporaryInactivity"/>
                                            <table>
                                                <tr>
                                                    <td><fmt:message key="jsp.general.day" /></td>
                                                    <td><fmt:message key="jsp.general.month" /></td>
                                                    <td><fmt:message key="jsp.general.year" /></td>
                                                </tr>
                                                <tr>
                                                    <spring:bind path="studentAbsence.startdateTemporaryInactivity">
                                                    <td><input type="text" id="start_ti_day" name="start_ti_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('studentAbsence.startdateTemporaryInactivity','day',document.getElementById('start_ti_day').value);" /></td>
                                                    <td><input type="text" id="start_ti_month" name="start_ti_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('studentAbsence.startdateTemporaryInactivity','month',document.getElementById('start_ti_month').value);" /></td>
                                                    <td><input type="text" id="start_ti_year" name="start_ti_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('studentAbsence.startdateTemporaryInactivity','year',document.getElementById('start_ti_year').value);" /></td>
                                                    </spring:bind>
                                                </tr>
                                            </table>
                                        </td>
                                        <td>
                                            <fmt:message key="jsp.general.message.dateformat" />
                                            <form:errors path="studentAbsence.startdateTemporaryInactivity" cssClass="error"/>
                                        </td>
                                        
<%--                                        <spring:bind path="studentAbsence.startdateTemporaryInactivity">
                                        <td class="required">
                                            <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                 	                        <table>
                                            	<tr>
                                            		<td><fmt:message key="jsp.general.day" /></td>
                                            		<td><fmt:message key="jsp.general.month" /></td>
                                            		<td><fmt:message key="jsp.general.year" /></td>
                                            	</tr>
                                                <tr>
                                            		<td><input type="text" id="start_ti_day" name="start_ti_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('startdateTemporaryInactivity','day',document.getElementById('start_ti_day').value);" /></td>
                                            		<td><input type="text" id="start_ti_month" name="start_ti_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('startdateTemporaryInactivity','month',document.getElementById('start_ti_month').value);" /></td>
                                            		<td><input type="text" id="start_ti_year" name="start_ti_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('startdateTemporaryInactivity','year',document.getElementById('start_ti_year').value);" /></td>
                                            	</tr>
                                            </table>
                           				</td>
                                        <td>
                                            <fmt:message key="jsp.general.message.dateformat" />
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td>
                                        </spring:bind> --%>
                                    </tr>
                                    <tr>
                                        <td class="label"><b><fmt:message key="jsp.general.enddatetemporaryinactivity" /></b></td>
                                        <spring:bind path="studentAbsence.enddateTemporaryInactivity">
                                        <td>
                                        <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
             	                        <table>
                                            	<tr>
                                            		<td><fmt:message key="jsp.general.day" /></td>
                                            		<td><fmt:message key="jsp.general.month" /></td>
                                            		<td><fmt:message key="jsp.general.year" /></td>
                                            	</tr>
                                                <tr>
                                            		<td><input type="text" id="end_ti_day" name="end_ti_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('studentAbsence.enddateTemporaryInactivity','day',document.getElementById('end_ti_day').value);" /></td>
                                            		<td><input type="text" id="end_ti_month" name="end_ti_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('studentAbsence.enddateTemporaryInactivity','month',document.getElementById('end_ti_month').value);" /></td>
                                            		<td><input type="text" id="end_ti_year" name="end_ti_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('studentAbsence.enddateTemporaryInactivity','year',document.getElementById('end_ti_year').value);" /></td>
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
                                        <td class="label"><fmt:message key="jsp.general.reasonforabsence" /></td>
                                        <spring:bind path="studentAbsence.reasonForAbsence">
                                        <td class="required">
                                            <textarea name="${status.expression}" cols="30" rows="8"><c:out value="${status.value}"/></textarea>
                                        </td> 
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td>
                                        </spring:bind>
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

