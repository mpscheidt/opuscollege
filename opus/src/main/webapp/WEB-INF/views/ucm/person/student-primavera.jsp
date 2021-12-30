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

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://jawr.net/tags" prefix="jwr" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<c:set var="screentitlekey">jsp.student.header</c:set>
<%@ include file="../../header.jsp"%>

<body>

<%@page import="org.uci.opus.config.OpusConstants" %>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <c:set var="form" value="${studentPrimaveraForm}" />

    <!-- necessary spring binds for organization and navigationSettings
         regarding form handling through includes -->
    <c:set var="navigationSettings" value="${form.navigationSettings}" scope="page" />

    <%--  page vars --%>   
    <c:set var="student" value="${form.student}" scope="page" />
    <c:set var="personId" value="${form.student.personId}" scope="page" />
    <c:set var="studentId" value="${form.student.studentId}" scope="page" />


    <sec:authorize access="!hasAnyRole('UPDATE_OPUSUSER')">
        <sec:authorize access="hasRole('READ_OPUSUSER') or ${personId == opusUser.personId}">
            <c:set var="showOpusUserData" value="${true}"/>
        </sec:authorize>
    </sec:authorize>

    <sec:authorize access="hasRole('UPDATE_OPUSUSER')">
        <c:set var="editOpusUserData" value="${true}"/>
    </sec:authorize>

    <sec:authorize access="!hasAnyRole('UPDATE_STUDENT_SUBSCRIPTION_DATA')">
        <sec:authorize access="hasRole('READ_STUDENT_SUBSCRIPTION_DATA') or ${personId == opusUser.personId}">
            <c:set var="showSubscriptionData" value="${true}"/>
        </sec:authorize>
    </sec:authorize>

    <sec:authorize access="hasAnyRole('UPDATE_STUDENT_SUBSCRIPTION_DATA','UPDATE_STUDY_PLANS')">
        <c:set var="editSubscriptionData" value="${true}"/>
    </sec:authorize>

    <sec:authorize access="!hasAnyRole('UPDATE_STUDENT_ABSENCES')">
        <sec:authorize access="hasRole('READ_STUDENT_ABSENCES') or ${personId == opusUser.personId}">
            <c:set var="showAbsences" value="${true}"/>
        </sec:authorize>
    </sec:authorize>
    
     <sec:authorize access="hasAnyRole('UPDATE_STUDENT_ABSENCES','CREATE_STUDENT_ABSENCES')">
        <c:set var="editAbsences" value="${true}"/>
    </sec:authorize>

    <sec:authorize access="!hasAnyRole('UPDATE_STUDENT_ADDRESSES')">
        <sec:authorize access="hasRole('READ_STUDENT_ADDRESSES') or ${personId == opusUser.personId}">
            <c:set var="showAddresses" value="${true}"/>
        </sec:authorize>
    </sec:authorize>
    
    <sec:authorize access="hasRole('UPDATE_STUDENT_ADDRESSES')">
        <c:set var="editAddresses" value="${true}"/>
    </sec:authorize>

    <sec:authorize access="hasAnyRole('READ_CLASSGROUPS')">
        <c:set var="showClassgroups" value="${true}"/>
    </sec:authorize>

    <sec:authorize access="hasAnyRole('CREATE_STUDENT_CLASSGROUPS', 'DELETE_STUDENT_CLASSGROUPS')">
        <c:set var="editClassgroups" value="${true}"/>
    </sec:authorize>


    <div id="tabcontent">
        <form>
            <fieldset><legend>
                <a href="<c:url value='/college/students.view'/>?<c:out value='currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.students.header" /></a>&nbsp;&gt;

                <c:choose>
                    <c:when test="${student.surnameFull != null && student.surnameFull != ''}" >
                        <!-- scope is request because studentName is needed in included jsp files -->
                        <c:set var="studentName" value="${fn:trim(student.studentCode)} ${fn:trim(student.surnameFull)}, ${fn:trim(student.firstnamesFull)}" scope="request" />
                        <c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}" />
                        &nbsp;&nbsp;&nbsp;
                        <img src="<c:url value='/images/guest.gif' />" alt="<fmt:message key="jsp.general.report" />" title="<fmt:message key="jsp.general.report" />" /> 
                        <a href="<c:url value='/college/reports.view'/>?<c:out value='reportName=person/student.pdf&where.student.studentId=${studentId}'/>" target="otherwindow">PDF</a>
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="jsp.href.new" />
                    </c:otherwise>
                </c:choose>
            </legend>

            <%--Display Error Messages because it must be visible if an error occurred in any tab --%>
            <form:errors path="studentPrimaveraForm.*" cssClass="errorwide" element="p"/>

            </fieldset>
        </form>

        <div id="tp1" class="TabbedPanel">
            <%@ include file="../../college/person/includes/studentTabs.jsp"%>

 
            <div class="TabbedPanelsContentGroup">
                <c:set var="accordion" value="0"/>

                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion${accordion}" tabindex="0"></div>
                </div>

                <c:if test="${(showOpusUserData || editOpusUserData) && '' != studentId && 0 != studentId}">
                    <c:set var="accordion" value="${accordion + 1}"/>
                    <div class="TabbedPanelsContent"></div>
                </c:if>

                <c:if test="${(showSubscriptionData || editSubscriptionData)  && '' != studentId && 0 != studentId}">
                   <c:set var="accordion" value="${accordion + 1}"/>
                   <div class="TabbedPanelsContent"></div> 
                </c:if>     

                <c:if test="${(showAbsences || editAbsences) && '' != studentId && 0 != studentId}">
                    <c:set var="accordion" value="${accordion + 1}"/>
                    <div class="TabbedPanelsContent"></div> 
                </c:if>     
         
                <c:if test="${(showAddresses || editAddresses) && '' != studentId && 0 != studentId}">
                    <c:set var="accordion" value="${accordion + 1}"/>
                    <div class="TabbedPanelsContent"></div> 
                </c:if>
         
                <c:if test="${(showClassgroups || editClassgroups) && '' != studentId && 0 != studentId}">
                    <c:set var="accordion" value="${accordion + 1}"/>
                    <div class="TabbedPanelsContent"></div> 
                </c:if>

<%--                 <c:forEach begin="2" end="${fn:length(collegeWebExtensions.studentTabs)}" varStatus="loop"> --%>
                <c:forEach var="studentTab" items="${collegeWebExtensions.studentTabs}">
                    <c:if test="${'' != studentId && 0 != studentId}">
                        <c:set var="accordion" value="${accordion + 1}"/>

                        <div class="TabbedPanelsContent">
                            <div class="Accordion" id="Accordion${accordion}" tabindex="0">

                                <jsp:include page="${studentTab.contentFile}" />

                            </div> <!-- end of accordion 6 + n -->
                            <script type="text/javascript">
                                var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
                                      {defaultPanel: 0,
                                      useFixedPanelHeights: false,
                                      nextPanelKeyCode: 78 /* n key */,
                                      previousPanelKeyCode: 80 /* p key */
                                     });
                            </script>
                        <!--  end tabbedpanelscontent -->
                        </div> 

                    </c:if>
                </c:forEach>





<%--                        <c:set var="accordion" value="${accordion + 1}"/>
                      
                        <div class="TabbedPanelsContent">
                            <div class="Accordion" id="Accordion${accordion}" tabindex="0">
                                <div class="AccordionPanel">
                                  <div class="AccordionPanelTab"><fmt:message key="general.primavera" /></div>
                                    <div class="AccordionPanelContent">

                                        <table>
                                            <tr>
                                            <td>
                                                Here are all the strictly sensitive infos on student named ${studentPrimaveraForm.student.firstnamesFull}
                                            </td>
                                            </tr>
                                        </table>

                                    </div> 
                                </div> 
                            </div>
                            <script type="text/javascript">
                                var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
                                      {defaultPanel: 0,
                                      useFixedPanelHeights: false,
                                      nextPanelKeyCode: 78 /* n key */,
                                      previousPanelKeyCode: 80 /* p key */
                                     });
                            </script>
                        </div><!-- TabbedPanelsContent -->
 --%>

            </div> <!-- tabbedPanelsContentGroup -->
        </div>  <!-- end tabbedPanel -->
    </div>  <!-- tabcontent --> 
    <script type="text/javascript">
	    var tp1 = new Spry.Widget.TabbedPanels("tp1");
	    tp1.showPanel(${navigationSettings.tab});
	    Accordion${navigationSettings.tab}.defaultPanel = ${navigationSettings.panel};
	    Accordion${navigationSettings.tab}.openPanelNumber(${navigationSettings.panel});
    </script>
<!-- end tabwrapper -->    
</div>

<%@ include file="../../footer.jsp" %>

