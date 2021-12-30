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

<c:set var="screentitlekey">jsp.student.header</c:set>
<%@ include file="../../header.jsp"%>
<script type="text/javascript">
function copiar() {
	
	var checks = document.getElementsByClassName('checks');
	var str = '';
	
	for ( i = 0; i < 5; i++) {
		
		if ( checks[i].checked === true ) {
			str += checks[i].value + "|";
			cc.value = str;
		}
	}
	
}
</script>

<body>

<%@page import="org.uci.opus.config.OpusConstants" %>
<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <%-- NB: using scope="request" to make variables available in jsp:include'd files --%>

    <c:set var="navigationSettings" value="${studentFormShared.navigationSettings}" scope="page" />

    <c:set var="student" value="${studentFormShared.student}" scope="request" />
    <c:set var="personId" value="${student.personId}" scope="request" />
    <c:set var="studentId" value="${student.studentId}" scope="request" />

    <%--  authorizations --%>

    <%-- To modify any student data, either update privilege is present for org-unit of primarystudy or editing a new student (that hasn't set a primaryStudyId yet) --%>
    <c:if test="${empty organizationAuthorizationForUpdate.organizationalUnitId or organizationAuthorizationForUpdate.organizationalUnitId == studentFormShared.primaryStudy.organizationalUnitId or student.primaryStudyId == 0}">
        <c:set var="updateWithinOrgUnit" value="${true}" scope="request"/>
    </c:if>

    <sec:authorize access="hasAnyRole('CREATE_STUDENTS','UPDATE_STUDENTS')">
        <c:set var="editPersonalData" value="${updateWithinOrgUnit}" scope="request"/>
    </sec:authorize>

    <c:if test="${not editPersonalData}">
        <sec:authorize access="hasRole('READ_STUDENTS') or ${personId == opusUser.personId}">
            <c:set var="showPersonalData" value="${true}" scope="request"/>
        </sec:authorize>
    </c:if>

    <sec:authorize access="hasAnyRole('CREATE_ACCOMMODATION','UPDATE_ACCOMMODATION')">
        <c:set var="editAccommodationData" value="${updateWithinOrgUnit}" scope="request"/>
    </sec:authorize>

    <c:if test="${not editAccommodationData}">
        <sec:authorize access="hasRole('READ_ACCOMMODATION') or ${personId == opusUser.personId}">
            <c:set var="showAccommodationData" value="${true}" scope="request"/>
        </sec:authorize>
    </c:if>

    <sec:authorize access="hasAnyRole('CREATE_STUDENT_NOTES','UPDATE_STUDENT_NOTES')">
        <c:set var="editStudentNotes" value="${updateWithinOrgUnit}" scope="request"/>
    </sec:authorize>

    <c:if test="${not editStudentNotes}">
        <sec:authorize access="hasRole('READ_STUDENT_NOTES') or ${personId == opusUser.personId}">
            <c:set var="showStudentNotes" value="${true}" scope="request"/>
        </sec:authorize>
    </c:if>
    
    <sec:authorize access="hasAnyRole('CREATE_STUDENT_COUNSELING','UPDATE_STUDENT_COUNSELING')">
        <c:set var="editStudentCounseling" value="${updateWithinOrgUnit}" scope="request"/>
    </sec:authorize>
    
    <c:if test="${not editStudentCounseling}">
        <sec:authorize access="hasRole('READ_STUDENT_COUNSELING')">
            <c:set var="showStudentCounseling" value="${true}" scope="request"/>
        </sec:authorize>
    </c:if>

    <sec:authorize access="!hasAnyRole('UPDATE_OPUSUSER')">
        <sec:authorize access="hasRole('READ_OPUSUSER') or ${personId == opusUser.personId}">
            <c:set var="showOpusUserData" value="${true}" scope="request"/>
        </sec:authorize>
    </sec:authorize>

    <sec:authorize access="hasRole('UPDATE_OPUSUSER')">
        <c:set var="editOpusUserData" value="${updateWithinOrgUnit}" scope="request"/>
    </sec:authorize>

    <sec:authorize access="!hasAnyRole('UPDATE_STUDENT_SUBSCRIPTION_DATA')">
        <sec:authorize access="hasRole('READ_STUDENT_SUBSCRIPTION_DATA') or ${personId == opusUser.personId}">
            <c:set var="showSubscriptionData" value="${true}" scope="request"/>
        </sec:authorize>
    </sec:authorize>

    <sec:authorize access="hasAnyRole('UPDATE_STUDENT_SUBSCRIPTION_DATA','UPDATE_STUDY_PLANS')">
        <c:set var="editSubscriptionData" value="${updateWithinOrgUnit}" scope="request"/>
    </sec:authorize>

    <sec:authorize access="hasAnyRole('CREATE_IDENTIFICATION_DATA','UPDATE_IDENTIFICATION_DATA')">
        <c:set var="editIdentificationData" value="${updateWithinOrgUnit}" scope="request"/>
    </sec:authorize>

    <%-- showIdentificationData: 
         (1) READ_IDENTIFICATION_DATA: privilege allowing to read identification data of all persons (students and staff mambers)
         (2) a student may read his own data (check desired personId against logged in user)
        --%>
    <c:if test="${not editIdentificationData}">
        <sec:authorize access="hasRole('READ_IDENTIFICATION_DATA') or ${personId == opusUser.personId}">
            <c:set var="showIdentificationData" value="${true}"/>
        </sec:authorize>
    </c:if>

    <sec:authorize access="!hasAnyRole('UPDATE_STUDENT_ABSENCES')">
        <sec:authorize access="hasRole('READ_STUDENT_ABSENCES') or ${personId == opusUser.personId}">
            <c:set var="showAbsences" value="${true}" scope="request"/>
        </sec:authorize>
    </sec:authorize>

    <sec:authorize access="hasAnyRole('UPDATE_STUDENT_ABSENCES','CREATE_STUDENT_ABSENCES')">
        <c:set var="editAbsences" value="${updateWithinOrgUnit}" scope="request"/>
    </sec:authorize>

    <sec:authorize access="hasRole('UPDATE_STUDENT_ABSENCES')">
        <c:set var="authorizedToEditAbsence" value="${updateWithinOrgUnit}" scope="request"/>
    </sec:authorize>
    
    <sec:authorize access="hasRole('DELETE_STUDENT_ABSENCES')">
        <c:set var="authorizedToDeleteAbsence" value="${true}" scope="request"/>
    </sec:authorize>

    <sec:authorize access="hasRole('CREATE_STUDENT_ADDRESSES') or ${personId == opusUser.personId}">
        <c:set var="authorizedToCreateAddress" value="${true}" scope="request"/>
    </sec:authorize>

    <sec:authorize access="!hasAnyRole('UPDATE_STUDENT_ADDRESSES')">
        <sec:authorize access="hasRole('READ_STUDENT_ADDRESSES') or ${personId == opusUser.personId}">
            <c:set var="showAddresses" value="${true}" scope="request"/>
        </sec:authorize>
    </sec:authorize>
    
    <sec:authorize access="hasRole('UPDATE_STUDENT_ADDRESSES')">
        <c:set var="editAddresses" value="${updateWithinOrgUnit}" scope="request"/>
    </sec:authorize>

    <sec:authorize access="hasRole('UPDATE_STUDENT_ADDRESSES') or ${personId == opusUser.personId}">
        <c:set var="authorizedToEditAddress" value="${updateWithinOrgUnit}" scope="request"/>
    </sec:authorize>
    
     <sec:authorize access="hasRole('DELETE_STUDENT_ADDRESSES') or ${personId == opusUser.personId}">
        <c:set var="authorizedToDeleteAddress" value="${true}" scope="request"/>
    </sec:authorize>

    <sec:authorize access="hasAnyRole('READ_CLASSGROUPS')">
        <c:set var="showClassgroups" value="${true}" scope="request"/>
    </sec:authorize>

	<sec:authorize access="hasAnyRole('CREATE_STUDENT_CLASSGROUPS', 'DELETE_STUDENT_CLASSGROUPS')">
        <c:set var="editClassgroups" value="${true}" scope="request"/>
    </sec:authorize>

    <div id="tabcontent">
        <fieldset>
            <legend>
                <a href="<c:url value='/college/students.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.students.header" /></a>&nbsp;&gt;
    
                <c:choose>
                    <c:when test="${student.id ne 0}" >
                        <!-- scope is request because studentName is needed in included jsp files -->
                        <c:set var="studentName" value="${fn:trim(student.studentCode)} ${fn:trim(student.surnameFull)}, ${student.firstnamesFull}" scope="request" />
                        <c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}" />
                        &nbsp;&nbsp;&nbsp;
                        <img src="<c:url value='/images/guest.gif' />" alt="<fmt:message key="jsp.general.report" />" title="<fmt:message key="jsp.general.report" />" /> 
                        <a href="<c:url value='/college/reports.view?reportName=person/student.pdf&amp;where.student.studentId=${studentId}'/>" target="otherwindow">PDF</a>
    
                        <c:forEach var="studentEditHeaderItem" items="${collegeWebExtensions.studentEditHeaderItems}">
                            |
                            <c:set var="url"><jsp:include page="${studentEditHeaderItem.href}" flush="true"/></c:set>
                            <c:set var="safeUrl"><c:url value="${url}"/></c:set>
                            <a href="<c:out value='${safeUrl}'/>" title="<fmt:message key='${studentEditHeaderItem.descriptionKey}' />" target="otherwindow"><fmt:message key="${studentEditHeaderItem.titleKey}" /></a>
                        </c:forEach>
    
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="jsp.href.new" />
                    </c:otherwise>
                </c:choose>
            </legend>
    
            <%--Display Error Messages because it must be visible if an error occurred in any tab --%>
            <form:errors path="studentForm.*" cssClass="errorwide" element="p"/>

        </fieldset>

<%--         <c:set var="accordion" value="0" scope="request"/> --%>

        <div id="tp1" class="TabbedPanel">

            <%@ include file="includes/studentTabs.jsp"%>

            <div class="TabbedPanelsContentGroup">
<!-- ---------------------------------------------------------------------------------------------------- -->           
                <c:set var="accordion" value="0" scope="request"/>
                <div class="TabbedPanelsContent">
                    <c:if test="${navigationSettings.tab == accordion}">
                        <div class="Accordion" id="Accordion${accordion}" tabindex="0">
                            <jsp:include page="student-personal-content.jsp" flush="true"/>
                        </div>

                        <script type="text/javascript">
                             var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
                              {defaultPanel: 0,
                               useFixedPanelHeights: false,
                               nextPanelKeyCode: 78 /* n key */,
                               previousPanelKeyCode: 80 /* p key */
                              });
                        </script>
                    </c:if>
                </div> <!--  end tabbedpanelscontent -->

                <c:if test="${(showOpusUserData || editOpusUserData) && '' != studentId && 0 != studentId}">
                    <c:set var="accordion" value="${accordion + 1}" scope="request"/>
                    <div class="TabbedPanelsContent">
                        <c:if test="${navigationSettings.tab == accordion}">
                            <div class="Accordion" id="Accordion${accordion}" tabindex="0">
                                <jsp:include page="../../includes/opusUserDataStudent.jsp" flush="true"/>
                            </div>
    
                            <script type="text/javascript">
                                var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
                                  {defaultPanel: 0,
                                   useFixedPanelHeights: false,
                                   nextPanelKeyCode: 78 /* n key */,
                                   previousPanelKeyCode: 80 /* p key */
                                });
                            </script>
                        </c:if>
                    </div> 
                </c:if>

                <c:if test="${(showSubscriptionData || editSubscriptionData)  && '' != studentId && 0 != studentId}">
                    <c:set var="accordion" value="${accordion + 1}" scope="request"/>
                    <div class="TabbedPanelsContent">
                        <c:if test="${navigationSettings.tab == accordion}">

                            <div class="Accordion" id="Accordion${accordion}" tabindex="0">
                                <jsp:include page="../../includes/subscriptionData.jsp" />
                            </div>
    
                            <script type="text/javascript">
                                var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
                                  {defaultPanel: 0,
                                   useFixedPanelHeights: false,
                                   nextPanelKeyCode: 78 /* n key */,
                                   previousPanelKeyCode: 80 /* p key */
                                });
                            </script>
                       </c:if>
                    </div> 
                </c:if>     

                <c:if test="${(showAbsences || editAbsences) && '' != studentId && 0 != studentId}">
                    <c:set var="accordion" value="${accordion + 1}" scope="request"/>
                    <div class="TabbedPanelsContent">
                        <c:if test="${navigationSettings.tab == accordion}">

                            <div class="Accordion" id="Accordion${accordion}" tabindex="0">
                                <jsp:include page="student-absences-content.jsp" />
                            </div>
    
                            <script type="text/javascript">
                                var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
                                  {defaultPanel: 0,
                                   useFixedPanelHeights: false,
                                   nextPanelKeyCode: 78 /* n key */,
                                   previousPanelKeyCode: 80 /* p key */
                                });
                            </script>
                       </c:if>
                    </div>
                </c:if>     

                <c:if test="${(showAddresses || editAddresses) && '' != studentId && 0 != studentId}">
                    <c:set var="accordion" value="${accordion + 1}" scope="request"/>
                    <div class="TabbedPanelsContent">
                        <c:if test="${navigationSettings.tab == accordion}">

                            <div class="Accordion" id="Accordion${accordion}" tabindex="0">
                                <jsp:include page="student-addresses-content.jsp" />
                            </div>
    
                            <script type="text/javascript">
                                var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
                                  {defaultPanel: 0,
                                   useFixedPanelHeights: false,
                                   nextPanelKeyCode: 78 /* n key */,
                                   previousPanelKeyCode: 80 /* p key */
                                });
                            </script>
                       </c:if>
                    </div> 
                </c:if>
         
                <c:if test="${(showClassgroups || editClassgroups) && '' != studentId && 0 != studentId}">
                    <c:set var="accordion" value="${accordion + 1}" scope="request"/>
                    <div class="TabbedPanelsContent">
                        <c:if test="${navigationSettings.tab == accordion}">

                            <div class="Accordion" id="Accordion${accordion}" tabindex="0">
                                <jsp:include page="student-classgroups-content.jsp" />
                            </div>

                            <script type="text/javascript">
                                var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
                                  {defaultPanel: 0,
                                   useFixedPanelHeights: false,
                                   nextPanelKeyCode: 78 /* n key */,
                                   previousPanelKeyCode: 80 /* p key */
                                });
                            </script>
                       </c:if>
                    </div> 
                </c:if>

<%--                 <c:forEach begin="2" end="${fn:length(collegeWebExtensions.studentTabs)}" varStatus="loop"> --%>
                <c:forEach var="studentTab" items="${collegeWebExtensions.studentTabs}">
                    <c:if test="${'' != studentId && 0 != studentId}">
                        <c:set var="accordion" value="${accordion + 1}" scope="request"/>

                        <div class="TabbedPanelsContent">
                            <c:if test="${navigationSettings.tab == accordion}">
                                <div class="Accordion" id="Accordion${accordion}" tabindex="0">

                                    <jsp:include page="${studentTab.contentFile}" />

                                </div> <!-- end of accordion 6 + n -->
                            </c:if>
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

