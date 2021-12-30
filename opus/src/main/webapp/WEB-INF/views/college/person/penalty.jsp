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

<%--
 * Copyright (c) 2007 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
--%>

<%@ include file="../../header.jsp"%>

<body>

<div id="wrapper">

    <%@ include file="../../menu.jsp"%>
    
    <spring:bind path="penaltyForm.navigationSettings">
        <c:set var="navSettings" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="penaltyForm.student">
        <c:set var="student" value="${status.value}" scope="page" />
    </spring:bind>
        
    <div id="tabcontent">

        <form>
            <fieldset>
                <legend>
                    <a href="<c:url value='/college/students.view?currentPageNumber=${navSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
                    <a href="<c:url value='/college/student-absences.view?tab=${navSettings.tab}&panel=2&studentId=${student.studentId}&currentPageNumber=${navSettings.currentPageNumber}'/>">
                    <c:choose>
                        <c:when test="${student.surnameFull != null && student.surnameFull != ''}" >
                            <c:set var="studentName" value="${student.surnameFull}, ${student.firstnamesFull}" scope="page" />
                            ${fn:substring(studentName,0,initParam.iTitleLength)}
                        </c:when>
                        <c:otherwise>
                            <fmt:message key="jsp.href.new" />
                        </c:otherwise>
                    </c:choose>
                    </a>
                    &nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.penalty" /> 
                </legend>
            </fieldset>
        </form>


        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.penalties" /></li>               
            </ul>

            <div class="TabbedPanelsContentGroup">   
                    <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion1" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab"><fmt:message key="jsp.general.penalty" /></div>
                                <div class="AccordionPanelContent">

                                <form method="post">
                                <input type="hidden" name="tab" value="${navSettings.tab}" /> 
                                <input type="hidden" name="panel" value="${navSettings.panel}" />
                                <input type="hidden" name="currentPageNumber" value="${navSettings.currentPageNumber}" />
                                
                                    <table>
                                    <spring:bind path="penaltyForm.penalty.penaltyType.code">
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.penalty.type" /></td>
                                        <td class="required">
                                        <select name="${status.expression}">
                                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                            <c:forEach var="penaltyType" items="${penaltyForm.allPenaltyTypes}">
                                               <c:choose>
                                                <c:when test="${penaltyType.code == status.value}">
                                                    <option value="${penaltyType.code}" selected="selected">${penaltyType.description}</option>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="${penaltyType.code}">${penaltyType.description}</option>
                                                </c:otherwise>
                                               </c:choose>
                                            </c:forEach>
                                        </select>
                                        </td> 
                                        <td>
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td>
                                    </tr>
                                    </spring:bind>
                                    <spring:bind path="penaltyForm.penalty.amount">
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.penalty.amount" /></td>
                                        <td class="required">
                                            <input type="text" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                                        </td> 
                                        <td>
                                            <fmt:message key="jsp.penalty.message.amountformat" />
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td>
                                    </tr>
                                    </spring:bind>
                                    <spring:bind path="penaltyForm.penalty.startDate">
                                    <tr>
                                        <td class="label"><b><fmt:message key="jsp.penalty.startdate" /></b></td>
                                        <td class="required">
                                        <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                                        <table>
                                                <tr>
                                                    <td><fmt:message key="jsp.general.day" /></td>
                                                    <td><fmt:message key="jsp.general.month" /></td>
                                                    <td><fmt:message key="jsp.general.year" /></td>
                                                </tr>
                                                <tr>
                                                    <td><input type="text" id="start_ex_day" name="start_ex_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('penalty.startDate','day',document.getElementById('start_ex_day').value);" /></td>
                                                    <td><input type="text" id="start_ex_month" name="start_ex_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('penalty.startDate','month',document.getElementById('start_ex_month').value);" /></td>
                                                    <td><input type="text" id="start_ex_year" name="start_ex_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('penalty.startDate','year',document.getElementById('start_ex_year').value);" /></td>
                                                </tr>
                                        </table>
                                        </td>
                                        <td>
                                            <fmt:message key="jsp.general.message.dateformat" />
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td>
                                    </tr>
                                    </spring:bind>
                                    <spring:bind path="penaltyForm.penalty.endDate">
                                    <tr>
                                        <td class="label"><b><fmt:message key="jsp.penalty.enddate" /></b></td>
                                        <td>
                                        <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                                        <table>
                                                <tr>
                                                    <td><fmt:message key="jsp.general.day" /></td>
                                                    <td><fmt:message key="jsp.general.month" /></td>
                                                    <td><fmt:message key="jsp.general.year" /></td>
                                                </tr>
                                                <tr>
                                                    <td><input type="text" id="end_ex_day" name="end_ex_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('penalty.endDate','day',document.getElementById('end_ex_day').value);" /></td>
                                                    <td><input type="text" id="end_ex_month" name="end_ex_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('penalty.endDate','month',document.getElementById('end_ex_month').value);" /></td>
                                                    <td><input type="text" id="end_ex_year" name="end_ex_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('penalty.endDate','year',document.getElementById('end_ex_year').value);" /></td>
                                                </tr>
                                        </table>
                                        </td>
                                        <td>
                                            <fmt:message key="jsp.general.message.dateformat" />
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td>
                                    </tr>
                                    </spring:bind>
                                    
                                    <spring:bind path="penaltyForm.penalty.remark">
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.remark" /></td>
                                        <td>
                                            <textarea name="${status.expression}" cols="30" rows="10">${status.value}</textarea>
                                        </td> 
                                        <td>
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td>
                                    </tr>
                                    </spring:bind>
                                    <tr>
                                        <td class="label">&nbsp;</td>
                                        <td><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td>
                                    </tr>
                                </table>

                                </form>
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

