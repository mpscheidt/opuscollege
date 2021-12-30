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
    
    <div id="tabwrapper">
        <%@ include file="../../menu.jsp"%>

        <div id="tabcontent">
            <spring:bind path="thesisStatusForm.thesisStatus">
                <c:set var="thesisStatus" value="${status.value}" />
            </spring:bind>
            <spring:bind path="thesisStatusForm.navigationSettings">
                <c:set var="navSettings" value="${status.value}" />
            </spring:bind>
            <spring:bind path="thesisStatusForm.student">
                <c:set var="student" value="${status.value}" />
            </spring:bind>
            <spring:bind path="thesisStatusForm.studyPlan">
                <c:set var="studyPlan" value="${status.value}" />
            </spring:bind>
            <spring:bind path="thesisStatusForm.thesis">
                <c:set var="thesis" value="${status.value}" />
            </spring:bind>
            <form>
                <fieldset>
                    <legend>
                        <a href="<c:url value='/college/students.view?currentPageNumber=${navSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
                        <a href="<c:url value='/college/student.view?newForm=true&tab=${navSettings.tab}&panel=${navSettings.panel}&studentId=${student.studentId}&currentPageNumber=${navSettings.currentPageNumber}'/>">
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
                        &nbsp;>&nbsp;<a href="<c:url value='/college/studyplan.view?newForm=true&tab=0&panel=0&studyPlanId=${studyPlan.id}&studentId=${student.studentId}&currentPageNumber=${navSettings.currentPageNumber}'/>">
                        <c:choose>
                            <c:when test="${studyPlan.studyPlanDescription != null && studyPlan.studyPlanDescription != ''}" >
                                ${fn:substring(studyPlan.studyPlanDescription,0,initParam.iTitleLength)}
                            </c:when>
                            <c:otherwise>
                                <fmt:message key="jsp.href.new" />
                            </c:otherwise>
                        </c:choose>
                        </a>
                        &nbsp;>&nbsp;<a href="<c:url value='/college/thesis.view?newForm=true&tab=2&panel=1&thesisId=${thesis.id}&studyPlanId=${studyPlan.id}&studentId=${student.studentId}&currentPageNumber=${navSettings.currentPageNumber}'/>">
                        <c:choose>
                            <c:when test="${thesis.thesisDescription != null && thesis.thesisDescription != ''}" >
                                ${fn:substring(thesis.thesisDescription,0,initParam.iTitleLength)}
                            </c:when>
                            <c:otherwise>
                                <fmt:message key="jsp.href.new" />
                            </c:otherwise>
                        </c:choose>
                        </a>
                        &nbsp;>&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.thesissupervisor" />
                    </legend>
                </fieldset>
            </form>
        
            <c:set var="accordion" value="0"/>
            <form name="formdata" method="post">
            <div id="tp1" class="TabbedPanel">
                <div class="TabbedPanelsContentGroup">           
                    <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion${accordion}" tabindex="0">
                        <!-- thesis supervisor -->
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.thesis.supervisor" /></div>
                            <div class="AccordionPanelContent">    
                                
                                <table>
                                <spring:bind path="thesisStatusForm.thesisStatus.startDate">
                                
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.startdate" /></td>
                                        <td class="required">
                                        <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                                        <table>
                                                <tr>
                                                    <td><fmt:message key="jsp.general.day" /></td>
                                                    <td><fmt:message key="jsp.general.month" /></td>
                                                    <td><fmt:message key="jsp.general.year" /></td>
                                                </tr>
                                                <tr>
                                                    <td><input type="text" id="start_ti_day" name="start_ti_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('thesisStatus.startDate','day',document.getElementById('start_ti_day').value);" /></td>
                                                    <td><input type="text" id="start_ti_month" name="start_ti_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('thesisStatus.startDate','month',document.getElementById('start_ti_month').value);" /></td>
                                                    <td><input type="text" id="start_ti_year" name="start_ti_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('thesisStatus.startDate','year',document.getElementById('start_ti_year').value);" /></td>
                                                </tr>
                                        </table>
                                        </td>
                                        <td>
                                            <fmt:message key="jsp.general.message.dateformat" />
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                        </td>
                                    </tr>
                                
                                </spring:bind>
                                <spring:bind path="thesisStatusForm.thesisStatus.status.code">
                                    <tr>
                                        <td class="label">**<fmt:message key="jsp.general.statuscode" /></td>
                                        <td class="required">
                                            <select id="${status.expression}" name="${status.expression}">
                                                <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach var="oneStatus" items="${thesisStatusForm.allThesisStatuses}">
                                                   <c:choose>
                                                    <c:when test="${oneStatus.code == status.value}">
                                                        <option value="${oneStatus.code}" selected="selected">${oneStatus.description}</option>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <option value="${oneStatus.code}">${oneStatus.description}</option>
                                                    </c:otherwise>
                                                   </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                       </td>
                                    </tr>
                                </spring:bind>
                                
                                </table>   
                                <table>
                                    <tr>
                                        <td class="label">&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td><input type="button" name="submitRequestData" value="<fmt:message key="jsp.button.submit" />" onclick="document.formdata.submit();" /></td>
                                    </tr>
                                </table>
                            </div>  <!-- end AccordionPanelContent -->
                        </div>  <!-- end AccordionPanel -->
                    </div> <!-- Accordion -->
                    </div>  <!-- end TabbedPanelsContent -->
                </div> <!-- tabbedPanelsContentGroup -->
            </div>  <!-- end tabbedPanel -->
            </form>   
        </div>  <!-- end tabcontent --> 
                        
    </div> <!-- end tabwrapper -->

   <%@ include file="../../footer.jsp"%>