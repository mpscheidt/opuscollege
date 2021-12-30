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
        <div id="tabcontent">
            <spring:bind path="thesisSupervisorForm.thesisSupervisor">
                <c:set var="thesisSupervisor" value="${status.value}" />
            </spring:bind>
            <spring:bind path="thesisSupervisorForm.navigationSettings">
                <c:set var="navSettings" value="${status.value}" />
            </spring:bind>
            <spring:bind path="thesisSupervisorForm.student">
                <c:set var="student" value="${status.value}" />
            </spring:bind>
            <spring:bind path="thesisSupervisorForm.studyPlan">
                <c:set var="studyPlan" value="${status.value}" />
            </spring:bind>
            <spring:bind path="thesisSupervisorForm.thesis">
                <c:set var="thesis" value="${status.value}" />
            </spring:bind>
            <form>
                <fieldset>
                    <legend>
                        <a href="<c:url value='/college/students.view'/>?<c:out value='currentPageNumber=${navSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
                        <a href="<c:url value='/college/student/subscription.view'/>?<c:out value='newForm=true&tab=2&panel=0&studentId=${student.studentId}&currentPageNumber=${navSettings.currentPageNumber}'/>">
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
                        &nbsp;>&nbsp;<a href="<c:url value='/college/studyplan.view'/>?<c:out value='newForm=true&tab=0&panel=0&studyPlanId=${studyPlan.id}&studentId=${student.studentId}&currentPageNumber=${navSettings.currentPageNumber}'/>">
                        <c:choose>
                            <c:when test="${studyPlan.studyPlanDescription != null && studyPlan.studyPlanDescription != ''}" >
                                <c:out value="${fn:substring(studyPlan.studyPlanDescription,0,initParam.iTitleLength)}"/>
                            </c:when>
                            <c:otherwise>
                                <fmt:message key="jsp.href.new" />
                            </c:otherwise>
                        </c:choose>
                        </a>
                        &nbsp;>&nbsp;<a href="<c:url value='/college/thesis.view'/>?<c:out value='newForm=true&tab=2&panel=1&thesisId=${thesis.id}&studyPlanId=${studyPlan.id}&studentId=${student.studentId}&currentPageNumber=${navSettings.currentPageNumber}'/>">
                        <c:choose>
                            <c:when test="${thesis.thesisDescription != null && thesis.thesisDescription != ''}" >
                                <c:out value="${fn:substring(thesis.thesisDescription,0,initParam.iTitleLength)}"/>
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
                                <p class="msgwide">
                                    <fmt:message key="jsp.msg.one.principal" />
                                </p>
                                <table>
                                <spring:bind path="thesisSupervisorForm.thesisSupervisor.name">
                                <tr>
                                    <td class="label"><fmt:message key="jsp.general.name" /></td>
                                    <td><input type="text" class="long" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" /></td>
                                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                </tr>
                                </spring:bind>
                                <spring:bind path="thesisSupervisorForm.thesisSupervisor.address">
                                <tr>
                                    <td class="label"><fmt:message key="jsp.general.address" /></td>
                                    <td><input type="text" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" /></td>
                                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                </tr>
                                </spring:bind>
                                <spring:bind path="thesisSupervisorForm.thesisSupervisor.telephone">
                                <tr>
                                    <td class="label"><fmt:message key="jsp.general.telephone" /></td>
                                    <td><input type="text" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" /></td>
                                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                </tr>
                                </spring:bind>
                                <spring:bind path="thesisSupervisorForm.thesisSupervisor.email">
                                <tr>
                                    <td class="label"><fmt:message key="jsp.general.email" /></td>
                                    <td><input type="text" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" /></td>
                                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                </tr>
                                </spring:bind>

                                <!-- Principal supervisor -->
                                <spring:bind path="thesisSupervisorForm.thesisSupervisor.principal">
                                <tr>
                                    <td class="label"><fmt:message key="jsp.thesis.principal.supervisor" /></td>
                                    <td colspan="2">
                                       <select name="${status.expression}" class="xshort">
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
                                </tr>
                                </spring:bind>

                                <!-- ACTIVE -->
                                <spring:bind path="thesisSupervisorForm.thesisSupervisor.active">
                                <tr>
                                    <td class="label"><fmt:message key="jsp.general.active" /></td>
                                    <td colspan="2">
                                        <select name="${status.expression}" class="xshort">
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