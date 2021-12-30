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

<c:set var="screentitlekey">jsp.general.subscribe.to.subjects</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

<%@ include file="../../menu.jsp"%>

<%-- <c:set var="authSetActivelyRegistered" value="${false}"/> --%>
<%-- <sec:authorize access="hasRole('FINALIZE_CONTINUED_REGISTRATION_FLOW')"> --%>
<%--     <c:set var="authSetActivelyRegistered" value="${true}"/> --%>
<%-- </sec:authorize> --%>

<c:set var="authApprove" value="${false}"/>
<sec:authorize access="hasRole('APPROVE_SUBJECT_SUBSCRIPTIONS')">
    <c:set var="authApprove" value="${not outsideRegistrationPeriod}"/>
</sec:authorize>

<c:set var="authSubscribeMany" value="${false}"/>
<sec:authorize access="hasRole('CREATE_STUDYPLANDETAILS_PENDING_APPROVAL')">
    <c:set var="authSubscribeMany" value="${not outsideRegistrationPeriod}"/>
</sec:authorize>

<!-- students are authorized to change their elective subject(Blocks)
    extra condition to check: the status of the CTU must be "customize programme"
-->
<c:set var="authSubscribeOwn" value="${false}"/>
<c:if test="${not authSubscribeMany}">
	<sec:authorize access="hasRole('CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL')">
	    <c:set var="authSubscribeOwn" value="${not outsideRegistrationPeriod}"/>
	</sec:authorize>
</c:if>

<!-- for convenience -->
<c:set var="authSubscribeOwnOrMany" value="${authSubscribeOwn || authSubscribeMany}"/> 

<!-- flag indicating if panels are visible (when all filters have been selected) -->
<c:set var="panelsVisible" value="${not empty studentGroupToStudentsMap}" />

<c:set var="subjectsAndBlocks" value="${filterForm.allSubjectsAndBlocks}" />

<div id="tabcontent">

<fieldset>
    <legend>
        <a href="#" onclick="openPopupWindow('<b><fmt:message key="jsp.href.info" />: <fmt:message key="jsp.general.subscribe.to.subjects" /></b><br/><fmt:message key="jsp.help.subscribe.to.subjects" />');" >
            <img src="<c:url value='/images/info.gif' />" alt="<fmt:message key="jsp.href.info" />" title="<fmt:message key="jsp.href.info" />" />
        </a>
        &nbsp;<fmt:message key="jsp.general.subscribe.to.subjects" />
    </legend>

    <form:form modelAttribute="filterForm" name="organizationAndStudySettings" method="post">
        <input type="hidden" name="action" value="filter" />
        <%@ include file="../../includes/organizationAndStudySettings.jsp"%>

        <!-- show CTUs that have already been handled -->
        <table>
            <tr>
                <td class="label" width="200"><fmt:message key="jsp.subscribetosubjects.show.processed" /></td>
                <td>
                    <form:checkbox path="showProcessed" onchange="document.organizationAndStudySettings.submit();"/>
                </td>
            </tr>
        </table>
        <!-- end of show CTUs that have already been handled -->

    </form:form>
    <!-- end of filter form -->

</fieldset>

<c:choose>
    <c:when test="${not panelsVisible}">
        <c:choose>
            <c:when test="${not empty filterForm.studySettings.cardinalTimeUnitNumber}">
                <fmt:message key="jsp.subscribetosubjects.no.subscriptions.available"/>
            </c:when>
            <c:otherwise>
                <fmt:message key="jsp.subscribetosubjects.please.use.filters"/>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <!-- if panels are visible -->
            <div id="tp1" class="TabbedPanel">
            <c:if test="${outsideRegistrationPeriod}">
	            <table>
	                <tr>
	                    <td class="msgwide">
	                        <fmt:message key="jsp.subscribetosubjects.outside.registration.period"/>
	                        <br/>
	                        (<fmt:message key="jsp.general.startdate"/>: <fmt:formatDate value="${admissionRegistrationConfig.startOfRegistration}" type="date"/> 
	                        &ndash; <fmt:message key="jsp.general.enddate"/>: <fmt:formatDate value="${admissionRegistrationConfig.endOfRegistration}" type="date"/>)
	                    </td>
	                </tr>
	            </table>
            </c:if>

            <ul class="TabbedPanelsTabGroup">
                <c:forEach var="mapEntry" items="${studentGroupToStudentsMap}">
                    <c:set var="studentGroup" value="${mapEntry.key}"></c:set>
                    <c:set var="editSubscription" value="${authSubscribeOwnOrMany
                        && (CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT == studentGroup.cardinalTimeUnitStatusCode
                         || CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME == studentGroup.cardinalTimeUnitStatusCode
                         || CARDINALTIMEUNIT_STATUS_REQUEST_FOR_CHANGE == studentGroup.cardinalTimeUnitStatusCode)}"/>

                    <%-- determine tab title --%>
                    <c:choose>
                        <c:when test="${authSubscribeOwn}">
                            <c:set var="tabheader" value="${mapEntry.value[0].studentCode}" />
                        </c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${fn:length(mapEntry.value) == 1}">
                                    <fmt:message var="tabheader" key="jsp.subscribetosubjects.oneStudent" />
                                </c:when>
                                <c:otherwise>
                                    <fmt:message var="tabheader" key="jsp.subscribetosubjects.nStudents">
                                        <fmt:param>${fn:length(mapEntry.value)}</fmt:param>
                                    </fmt:message>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>

                    <c:set var="tabtitle">
                        <c:out value="${codeToCardinalTimeUnitStatusMap[studentGroup.cardinalTimeUnitStatusCode].description}"/>
                        <fmt:message key="jsp.subscribetosubjects.nSubjects">
                            <fmt:param>${fn:length(studentGroup.allSubjects)}</fmt:param>
                        </fmt:message>
                        <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                            <fmt:message key="jsp.subscribetosubjects.nSubjectBlocks">
                                <fmt:param>${fn:length(studentGroup.allSubjectBlocks)}</fmt:param>
                            </fmt:message>
                        </c:if>
                        <fmt:message key="jsp.subscribetosubjects.nPassedSubjects">
                            <fmt:param>${fn:length(studentGroup.passedSubjects)}</fmt:param>
                        </fmt:message>
                        <fmt:message key="jsp.subscribetosubjects.nSubscribedSubjects">
                            <fmt:param>${fn:length(studentGroup.subscribedSubjectIds)}</fmt:param>
                        </fmt:message>
                        <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                            <fmt:message key="jsp.subscribetosubjects.nSubscribedSubjectBlocks">
                                <fmt:param>${fn:length(studentGroup.subscribedSubjectBlockIds)}</fmt:param>
                            </fmt:message>
                        </c:if>
                    </c:set>
                    
                    <%-- create tab groups --%>
                    <li class="TabbedPanelsTab" title="${tabtitle}">
                        <c:out value="${tabheader}"/>
                    </li>
                </c:forEach>
            </ul>

            <div class="TabbedPanelsContentGroup">
                <c:forEach var="mapEntry" items="${studentGroupToStudentsMap}" varStatus="studentGroupVarStatus">
                    <c:set var="studentGroup" value="${mapEntry.key}"></c:set>
                    <div class="TabbedPanelsContent">

                        <form:form modelAttribute="subscribeToSubjectsForm${studentGroupVarStatus.index}" method="post">
                            <input type="hidden" name="action" value="add" />
                            <input type="hidden" name="formNumber" value="${studentGroupVarStatus.index}" />
                            <input type="hidden" name="institutionId" value="${institutionId}" />
                            <input type="hidden" name="branchId" value="${branchId}" />
                            <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
                            <input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
                            <input type="hidden" name="academicYearId" value="${academicYearId}" />
                            <input type="hidden" name="studyGradeTypeId" value="${studyGradeTypeId}" />
                            <input type="hidden" name="subjectBlockStudyGradeTypeId" value="${subjectBlockStudyGradeTypeId}" />

                            <%-- we need to know on submit if subjects and blocks were editable -> store in form object --%>
                            <c:set var="formName" value="subscribeToSubjectsForm${studentGroupVarStatus.index}" />
                            <c:set var="form" value="${formName}" />
                            <spring:bind path="subscribeToSubjectsForm${studentGroupVarStatus.index}.editSubscription">
                                <input type="hidden" name="editSubscription" value="${editSubscription}" />
                            </spring:bind>

                            <c:set var="selectedCTU" value="${allCardinalTimeUnitsMap[selectedStudyGradeType.cardinalTimeUnitCode]} ${filterForm.studySettings.cardinalTimeUnitNumber}"/>
                            <fmt:message key='jsp.general.unbound' var="msgUnbound"/>
                            <table style="width:100%;">
                                <tr>
                                    <!-- subject blocks on the left -->
                                    <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                                    <td width="50%">
                                        <fieldset>
                                            <legend>
                                                <fmt:message key="jsp.general.compulsorysubjectblocks"/>
                                            </legend>
                                            <table style="width:100%;">
                                                <tr>
                                                    <th><c:out value="${selectedCTU}"/></th>
                                                </tr>
                                                <tr><td>
                                                    <c:choose>
                                                        <c:when test="${not empty subjectsAndBlocks.compulsorySubjectBlocks}">
                                                            <c:forEach var="subjectBlock" items="${subjectsAndBlocks.compulsorySubjectBlocks}">
                                                                <c:set var="disabled" value="${studentGroup.passedAnySubjectMap[subjectBlock.id] || !editSubscription || authSubscribeOwn}" />
                                                                <spring:bind path="subjectBlockIds">
                                                                    <c:set var="selected" value="${fn:contains(status.value, subjectBlock.id) }" />
                                                                </spring:bind>
                                                                <form:checkbox path="subjectBlockIds"
                                                                               label="${subjectBlock.subjectBlockDescription}"
                                                                               value="${subjectBlock.id}"
                                                                               disabled="${disabled}"/>
                                                                <%-- if checkbox disabled, no form binding will be done -> bind as hidden element --%>
                                                                <c:if test="${disabled && selected}">
                                                                    <input type="hidden" name="subjectBlockIds" value="${subjectBlock.id}"/>
                                                                </c:if>
                                                                <c:forEach var="subjectSubjectBlock" items="${subjectBlock.subjectSubjectBlocks}" varStatus="varStatus">
                                                                    <br/>
                                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    <c:out value="${subjectSubjectBlock.subject.subjectDescription}"/>
                                                                    <c:if test="${studentGroup.passedSubjectMap[subjectSubjectBlock.subject.id]}">
                                                                        <abbr title='<fmt:message key="jsp.general.subject.passed.previously"/>'>(<fmt:message key="jsp.general.passed"/>)</abbr>
                                                                    </c:if>
                                                                </c:forEach>
                                                                <br/>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            &nbsp;
                                                            <fmt:message key="jsp.general.not.available"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td></tr>
                                                <tr>
                                                    <th><c:out value="${msgUnbound}"/></th>
                                                </tr>
                                                <tr><td>
                                                    <c:choose>
                                                        <c:when test="${not empty subjectsAndBlocks.floatingCompulsorySubjectBlocks}">
                                                            <c:forEach var="subjectBlock" items="${subjectsAndBlocks.floatingCompulsorySubjectBlocks}">
                                                                <c:set var="disabled" value="${studentGroup.passedAnySubjectMap[subjectBlock.id] || !editSubscription || authSubscribeOwn}" />
                                                                <spring:bind path="subjectBlockIds">
                                                                    <c:set var="selected" value="${fn:contains(status.value, subjectBlock.id) }" />
                                                                </spring:bind>
                                                                <form:checkbox path="subjectBlockIds" 
                                                                                label="${subjectBlock.subjectBlockDescription} (${msgUnbound})" 
                                                                                value="${subjectBlock.id}"
                                                                                disabled="${disabled}"/>
                                                                <%-- if checkbox disabled, no form binding will be done -> bind as hidden element --%>
                                                                <c:if test="${disabled && selected}">
                                                                    <input type="hidden" name="subjectBlockIds" value="${subjectBlock.id}"/>
                                                                </c:if>
                                                                <c:forEach var="subjectSubjectBlock" items="${subjectBlock.subjectSubjectBlocks}" varStatus="varStatus">
                                                                    <br/>
                                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    <c:out value="${subjectSubjectBlock.subject.subjectDescription}"/>
                                                                </c:forEach>
                                                                <br/>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            &nbsp;
                                                            <fmt:message key="jsp.general.not.available"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td></tr>
                                            </table>
                                        </fieldset>
                                        <fieldset>
                                            <legend>
                                                <fmt:message key="jsp.general.optionalsubjectblocks"/>
                                            </legend>
                                            <table style="width:100%;">
                                                <tr>
                                                    <th><c:out value="${selectedCTU}"/></th>
                                                </tr>
                                                <tr><td>
                                                    <c:choose>
                                                        <c:when test="${not empty subjectsAndBlocks.optionalSubjectBlocks}">
                                                            <c:forEach var="subjectBlock" items="${subjectsAndBlocks.optionalSubjectBlocks}">
                                                                <c:set var="disabled" value="${studentGroup.passedAnySubjectMap[subjectBlock.id] || !editSubscription}" />
                                                                <spring:bind path="subjectBlockIds">
                                                                    <c:set var="selected" value="${fn:contains(status.value, subjectBlock.id) }" />
                                                                </spring:bind>
                                                                <form:checkbox path="subjectBlockIds" 
                                                                                label="${subjectBlock.subjectBlockDescription}" 
                                                                                value="${subjectBlock.id}"
                                                                                disabled="${disabled}"/>
                                                                                <%-- || (authSubscribeOwn && studentGroup.cardinalTimeUnitStatusCode != CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME) --%>
                                                                <%-- if checkbox disabled, no form binding will be done -> bind as hidden element --%>
                                                                <c:if test="${disabled && selected}">
                                                                    <input type="hidden" name="subjectBlockIds" value="${subjectBlock.id}"/>
                                                                </c:if>
                                                                <c:forEach var="subjectSubjectBlock" items="${subjectBlock.subjectSubjectBlocks}" varStatus="varStatus">
                                                                    <br/>
                                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    <c:out value="${subjectSubjectBlock.subject.subjectDescription}"/>
                                                                </c:forEach>
                                                                <br/>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            &nbsp;
                                                            <fmt:message key="jsp.general.not.available"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td></tr>
                                                <tr>
                                                    <th><c:out value="${msgUnbound}"/></th>
                                                </tr>
                                                <tr><td>
                                                    <c:choose>
                                                        <c:when test="${not empty subjectsAndBlocks.floatingOptionalSubjectBlocks}">
                                                            <c:forEach var="subjectBlock" items="${subjectsAndBlocks.floatingOptionalSubjectBlocks}">
                                                                <c:set var="disabled" value="${studentGroup.passedAnySubjectMap[subjectBlock.id] || !editSubscription}" />
                                                                <spring:bind path="subjectBlockIds">
                                                                    <c:set var="selected" value="${fn:contains(status.value, subjectBlock.id) }" />
                                                                </spring:bind>
                                                                <form:checkbox path="subjectBlockIds" 
                                                                                label="${subjectBlock.subjectBlockDescription} (${msgUnbound})" 
                                                                                value="${subjectBlock.id}"
                                                                                disabled="${disabled}"
                                                                                />
                                                                                <%--|| (authSubscribeOwn && studentGroup.cardinalTimeUnitStatusCode != CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME) --%>
                                                                <%-- if checkbox disabled, no form binding will be done -> bind as hidden element --%>
                                                                <c:if test="${disabled && selected}">
                                                                    <input type="hidden" name="subjectBlockIds" value="${subjectBlock.id}"/>
                                                                </c:if>
                                                                <c:forEach var="subjectSubjectBlock" items="${subjectBlock.subjectSubjectBlocks}" varStatus="varStatus">
                                                                    <br/>
                                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    <c:out value="${subjectSubjectBlock.subject.subjectDescription}"/>
                                                                </c:forEach>
                                                                <br/>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            &nbsp;
                                                            <fmt:message key="jsp.general.not.available"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td></tr>
                                            </table>
                                        </fieldset>
                                    </td>
                                    </c:if>
                                    <!-- subjects on the right -->
                                    <td>
                                        <fieldset>
                                            <legend>
                                                <fmt:message key="jsp.general.compulsorysubjects"/>
                                            </legend>
                                            <table style="width:100%;">
                                                <tr>
                                                    <th><c:out value="${selectedCTU}"/></th>
                                                </tr>
                                                <tr><td>
                                                    <c:choose>
                                                        <c:when test="${not empty subjectsAndBlocks.compulsorySubjects}">
                                                            <c:forEach var="subject" items="${subjectsAndBlocks.compulsorySubjects}" varStatus="varStatus">
                                                                <c:set var="passed" value="${studentGroup.passedSubjectMap[subject.id]}" />
                                                                <c:set var="disabled" value="${passed || !editSubscription || authSubscribeOwn}" />
                                                                <c:set var="label" value="${subject.subjectDescription} (${selectedCTU}) ${subjectSelected}" />
                                                                <c:set var="title" value="" />
                                                                <spring:bind path="subjectIds">
                                                                    <c:set var="selected" value="${fn:contains(status.value, subject.id) }" />
                                                                </spring:bind>
                                                                <form:checkbox path="subjectIds"
                                                                               label="${label}" 
                                                                               value="${subject.id}"
                                                                               disabled="${disabled}"/>
                                                                <c:if test="${passed}">
                                                                    <abbr title='<fmt:message key="jsp.general.subject.passed.previously"/>'>(<fmt:message key="jsp.general.passed"/>)</abbr>
                                                                </c:if>
                                                                <%-- if checkbox disabled, no form binding will be done -> bind as hidden element --%>
                                                                <c:if test="${disabled && selected}">
                                                                    <input type="hidden" name="subjectIds" value="${subject.id}"/>
                                                                </c:if>
                                                                <br/>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            &nbsp;
                                                            <fmt:message key="jsp.general.not.available"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td></tr>
                                                <tr>
                                                    <th><c:out value="${msgUnbound}"/></th>
                                                </tr>
                                                <tr><td>
                                                    <c:choose>
                                                        <c:when test="${not empty subjectsAndBlocks.floatingCompulsorySubjects}">
                                                            <c:forEach var="subject" items="${subjectsAndBlocks.floatingCompulsorySubjects}">
                                                                <c:set var="passed" value="${studentGroup.passedSubjectMap[subject.id]}" />
                                                                <c:set var="disabled" value="${passed || !editSubscription || authSubscribeOwn}" />
                                                                <spring:bind path="subjectIds">
                                                                    <c:set var="selected" value="${fn:contains(status.value, subject.id) }" />
                                                                </spring:bind>
                                                                <form:checkbox path="subjectIds"
                                                                               label="${subject.subjectDescription} (${msgUnbound})"
                                                                               value="${subject.id}"
                                                                               disabled="${disabled}"/>
                                                                <c:if test="${passed}">
                                                                    <abbr title='<fmt:message key="jsp.general.subject.passed.previously"/>'>(<fmt:message key="jsp.general.passed"/>)</abbr>
                                                                </c:if>
                                                                <%-- if checkbox disabled, no form binding will be done -> bind as hidden element --%>
                                                                <c:if test="${disabled && selected}">
                                                                    <input type="hidden" name="subjectIds" value="${subject.id}"/>
                                                                </c:if>
                                                                <br/>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            &nbsp;
                                                            <fmt:message key="jsp.general.not.available"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td></tr>
                                            </table>
                                        </fieldset>
                                        <fieldset>
                                            <legend>
                                                <fmt:message key="jsp.general.optionalsubjects"/>
                                            </legend>
                                            <table style="width:100%;">
                                                <tr>
                                                    <th><c:out value="${selectedCTU}"/></th>
                                                </tr>
                                                <tr><td>
                                                    <c:choose>
                                                        <c:when test="${not empty subjectsAndBlocks.optionalSubjects}">
                                                            <c:forEach var="subject" items="${subjectsAndBlocks.optionalSubjects}">
                                                                <c:set var="passed" value="${studentGroup.passedSubjectMap[subject.id]}" />
                                                                <c:set var="disabled" value="${passed || !editSubscription}" />
                                                                <spring:bind path="subjectIds">
                                                                    <c:set var="selected" value="${fn:contains(status.value, subject.id) }" />
                                                                </spring:bind>
                                                                <form:checkbox path="subjectIds"
                                                                               label="${subject.subjectDescription} (${selectedCTU})"
                                                                               value="${subject.id}"
                                                                               disabled="${disabled}"
                                                                               />
                                                                               <%--|| (authSubscribeOwn && studentGroup.cardinalTimeUnitStatusCode != CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME) --%>
                                                                <c:if test="${passed}">
                                                                    <abbr title='<fmt:message key="jsp.general.subject.passed.previously"/>'>(<fmt:message key="jsp.general.passed"/>)</abbr>
                                                                </c:if>
                                                                <%-- if checkbox disabled, no form binding will be done -> bind as hidden element --%>
                                                                <c:if test="${disabled && selected}">
                                                                    <input type="hidden" name="subjectIds" value="${subject.id}"/>
                                                                </c:if>
                                                                <br/>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            &nbsp;
                                                            <fmt:message key="jsp.general.not.available"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td></tr>
                                                <tr>
                                                    <th><c:out value="${msgUnbound}"/></th>
                                                </tr>
                                                <tr><td>
                                                    <c:choose>
                                                        <c:when test="${not empty subjectsAndBlocks.floatingOptionalSubjects}">
                                                            <c:forEach var="subject" items="${subjectsAndBlocks.floatingOptionalSubjects}">
                                                                <c:set var="passed" value="${studentGroup.passedSubjectMap[subject.id]}" />
                                                                <c:set var="disabled" value="${passed || !editSubscription}" />
                                                                <spring:bind path="subjectIds">
                                                                    <c:set var="selected" value="${fn:contains(status.value, subject.id) }" />
                                                                </spring:bind>
                                                                <form:checkbox path="subjectIds"
                                                                               label="${subject.subjectDescription} (${msgUnbound})"
                                                                               value="${subject.id}"
                                                                               disabled="${disabled}"
                                                                               />
                                                                <c:if test="${passed}">
                                                                    <abbr title='<fmt:message key="jsp.general.subject.passed.previously"/>'>(<fmt:message key="jsp.general.passed"/>)</abbr>
                                                                </c:if>
                                                                <%-- if checkbox disabled, no form binding will be done -> bind as hidden element --%>
                                                                <c:if test="${disabled && selected}">
                                                                    <input type="hidden" name="subjectIds" value="${subject.id}"/>
                                                                </c:if>
                                                                <br/>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            &nbsp;
                                                            <fmt:message key="jsp.general.not.available"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td></tr>
                                            </table>
                                        </fieldset>
                                        <c:if test="${not empty studentGroup.outerCurricularSubjects }">
                                            <fieldset>
                                                <legend>
                                                    <fmt:message key="jsp.general.furthersubscribedsubjects"/>
                                                </legend>
                                                <fmt:message key="jsp.general.furthersubscribedsubjects.info" />
                                                <br/>
                                                <table style="width:100%;">
                                                    <tr>
                                                        <td>
                                                            <c:forEach var="subject" items="${studentGroup.outerCurricularSubjects}">
                                                                <b>${subject.subjectCode} ${subject.subjectDescription }</b>
                                                                <br/>
                                                            </c:forEach>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </fieldset>
                                        </c:if>
                                    </td>
                                </tr>
                            </table>

                            <fieldset>
                                <legend>
                                    <fmt:message key="jsp.general.students"/>
                                </legend>
                                <table style="width:100%;" id="TblData${studentGroupVarStatus.index}">
                                    <tr>
                                        <c:choose>
                                            <c:when test="${(authApprove || editSubscription) && !authSubscribeOwn}">
<%--                                            <c:when test="${authSetActivelyRegistered || authApprove || (editSubscription && !authSubscribeOwn) || (editSubscription && authSubscribeOwn 
                                            && studentGroup.cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME) }"> --%>
                                                <td width="20" style="vertical-align:bottom">
                                                    <input name="checker${studentGroupVarStatus.index}"
                                                           id="checker${studentGroupVarStatus.index}"
                                                           align="bottom"
                                                           onclick="javascript:checkAll2(this.form.selectedStudyPlanCTUIds, this.form.checker${studentGroupVarStatus.index});"
                                                           type="checkbox"
                                                           checked="checked"
                                                           />
                                                </td>
                                            </c:when>
                                        </c:choose>
                                        <th style="vertical-align:bottom"><fmt:message key="jsp.general.code"/></th>
                                        <th style="vertical-align:bottom"><fmt:message key="jsp.general.firstnames"/></th>
                                        <th style="vertical-align:bottom"><fmt:message key="jsp.general.surname"/></th>
                                        <th style="vertical-align:bottom"><fmt:message key="jsp.general.rfc.header"/></th>
                                        <th style="vertical-align:bottom"><fmt:message key="jsp.general.rfc.student.response"/></th>
                                    </tr>

<%--                                     <c:set var="rfcTextDisabled" value="${outsideRegistrationPeriod || studentGroup.cardinalTimeUnitStatusCode != 7}"/> --%>
                                    <c:set var="rfcTextDisabled" value="${outsideRegistrationPeriod || studentGroup.cardinalTimeUnitStatusCode != CARDINALTIMEUNIT_STATUS_REQUEST_FOR_CHANGE}"/>
                                    <c:forEach var="student" items="${mapEntry.value}">
                                        <c:set var="studyPlanCTU" value="${student.studyPlans[0].studyPlanCardinalTimeUnits[0]}"/>
                                        <tr>
                                            <c:choose>
<%--                                                <c:when test="${authSetActivelyRegistered || authApprove || (editSubscription && !authSubscribeOwn)
                                                || (editSubscription && authSubscribeOwn 
                                                    && studentGroup.cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME)}"> --%>
                                                <c:when test="${authApprove || editSubscription}">
                                                    <c:choose>
                                                        <c:when test="${authSubscribeOwn}">
                                                            <form:hidden path="selectedStudyPlanCTUIds[0]"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <td>
                                                                <form:checkbox path="selectedStudyPlanCTUIds" value="${studyPlanCTU.id}"/>
                                                            </td>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
<%--                                                 <c:otherwise>
                                                    <form:hidden path="selectedStudyPlanCTUIds[0]"/>
                                                </c:otherwise>--%>
                                            </c:choose>
                                            <td><c:out value="${student.studentCode}"/></td>
                                            <td><c:out value="${student.firstnamesFull}"/></td>
                                            <td>
                                                <a href="<c:url value='/college/studyplancardinaltimeunit.view'/>?<c:out value='newForm=truetab=1&panel=0&currentPageNumber=1&studyPlanCardinalTimeUnitId=${studyPlanCTU.id}&studyPlanId=${studyPlanCTU.studyPlanId}'/>">
                                                <c:out value="${student.surnameFull}"/>
                                                </a></td>
                                            <td>
<%--                                                 <c:forEach var="rfc" items="${studyPlanCTU.rfcs}">   there should be 0 or 1 "new" rfcs
                                                     ${rfc.text}
                                                 </c:forEach>--%>
                                                <c:if test="${not empty studyPlanCTU.latestRfc}">
                                                    <c:choose>
                                                        <c:when test="${authApprove}">
                                                            <form:textarea cssClass="rfcText${studentGroupVarStatus.index}" 
                                                                        rows="1" path="rfcTexts[${studyPlanCTU.id}]"
                                                                        disabled="${rfcTextDisabled}"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:out value="${studyPlanCTU.latestRfc.text}"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${not empty studyPlanCTU.latestRfc}">
                                                    <c:choose>
                                                        <c:when test="${editSubscription}">
                                                            <form:textarea rows="1" path="rfcComments[${studyPlanCTU.id}]"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:out value="${studyPlanCTU.latestRfc.comments}"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </table>
                                <script type="text/javascript">alternate('TblData${studentGroupVarStatus.index}',true)</script>
                            </fieldset>


                            <table>
                                <!-- begin of cardinalTimeUnitStatus -->
                                <tr>
                                    <td class="label" width="200"><fmt:message key="jsp.general.cardinaltimeunitstatus" /></td>
                                    <c:choose>
                                        <c:when test="${authApprove || editSubscription}">
<%--                                        <c:when test="${(authSetActivelyRegistered || authApprove || editSubscription) && !authSubscribeOwn}"> --%>
                                            <td class="required">
                                                <form:select cssClass="compressoneoption" id="cardinalTimeUnitStatusCode${studentGroupVarStatus.index}" path="cardinalTimeUnitStatusCode" 
                                                            onchange="enableDisableBySelector('.rfcText${studentGroupVarStatus.index}', this.value != ${CARDINALTIMEUNIT_STATUS_REQUEST_FOR_CHANGE})">
<%--                                                             onchange="enableDisableBySelector('.rfcText${studentGroupVarStatus.index}', ${outsideRegistrationPeriod} || this.value != 20)"> --%>
                                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    <c:forEach var="cardinalTimeUnitStatus" items="${availableCardinalTimeUnitStatuses}">
<%-- MP 2013-04-09 commented out because it is unclear why statusCodes should be filtered here when they are already built up (correctly?) in the controller
                                                       <c:if test="${cardinalTimeUnitStatus.code ==  CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME
                                                                || cardinalTimeUnitStatus.code == CARDINALTIMEUNIT_STATUS_WAITING_FOR_APPROVAL_OF_REGISTRATION 
                                                                || cardinalTimeUnitStatus.code == CARDINALTIMEUNIT_STATUS_REJECTED_REGISTRATION
                                                                || cardinalTimeUnitStatus.code == CARDINALTIMEUNIT_STATUS_REQUEST_FOR_CHANGE
                                                                }"> --%>
                                                            <form:option value="${cardinalTimeUnitStatus.code}"><c:out value="${cardinalTimeUnitStatus.description}"/></form:option>
<%--                                                        </c:if> --%>
                                                    </c:forEach>
                                                </form:select>
                                            </td>
<!--                                             <td> -->
<%--                                                 <fmt:message key="jsp.subscribetosubjects.currentStatus"/>: --%>
<%--                                                 ${codeToCardinalTimeUnitStatusMap[studentGroup.cardinalTimeUnitStatusCode].description} --%>
<!--                                             </td> -->
                                        </c:when>
                                        <c:otherwise>
                                            <td>
                                                <c:out value="${codeToCardinalTimeUnitStatusMap[studentGroup.cardinalTimeUnitStatusCode].description}"/>
                                            </td>
                                        </c:otherwise>
                                    </c:choose>
                                    <td>
                                        <form:errors path="cardinalTimeUnitStatusCode" cssClass="error"/>
                                    </td>
                                </tr>
                                <!-- end of cardinalTimeUnitStatus -->
                                
                                <%-- begin of RFC text --%>
                                <c:choose>
                                    <c:when test="${authApprove}">
                                        <tr>
                                            <td class="label" width="200"><fmt:message key="jsp.general.rfc.header" /></td>
                                            <td>
                                                <form:textarea id="rfcText${studentGroupVarStatus.index}" path="rfcText"
                                                    cssClass="rfcText${studentGroupVarStatus.index}"
                                                    rows="3" cols="30" 
                                                    disabled="${rfcTextDisabled}"/>
                                            </td>
                                            <td>
                                                <form:errors path="rfcText" cssClass="error"/>
                                            </td>
                                        </tr>
                                    </c:when>
                                </c:choose>
                                <%-- end of RFC text --%>

                                <%-- begin of submit button --%>
                                <tr>
                                    <td></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${authApprove || editSubscription}">
                                                <input type="submit" value="<fmt:message key='jsp.subscribetosubjects.updateSubscription'/>" />
                                            </c:when>
                                            <c:otherwise>
                                                <input type="submit" disabled="disabled" value="<fmt:message key='jsp.subscribetosubjects.updateSubscription'/>" />
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <%-- end of submit button --%>
                            </table>

                        </form:form>


                    </div> <%-- end TabbedPanelsContent --%>
                    <c:set var="accordion" value="${accordion + 1}"/>
                </c:forEach>
            </div> <%-- end TabbedPanelsContentGroup --%>
        </div> <%-- end TabbedPanel --%>
    </c:otherwise>
</c:choose>
    


</div> <%-- end tabcontent --%>

<c:if test="${panelsVisible}">
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(0);
    </script>
</c:if>

</div> <%-- end tabwrapper --%>

<jwr:script src="/bundles/jquerycomp.js" /> <%-- for enableDisableBySelector method in javascriptfunctions.jsp --%>
<%@ include file="../../includes/javascriptfunctions.jsp"%>
<%@ include file="../../footer.jsp"%>
