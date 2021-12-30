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

<c:set var="screentitlekey">jsp.general.transferstudents</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <c:set var="authUpdateProgressStatus" value="${false}"/>
    <sec:authorize access="hasRole('UPDATE_PROGRESS_STATUS')">
        <c:set var="authUpdateProgressStatus" value="${true}"/>
    </sec:authorize>

    <sec:authorize access="hasRole('ACCESS_CONTEXT_HELP')">
        <c:set var="accessContextHelp" value="${true}"/>
    </sec:authorize>

    <%@ include file="../../menu.jsp"%>

<div id="tabcontent">

<c:url var="formUrl" value="/college/person/transferStudents"/>
<form:form modelAttribute="transferStudentsForm" method="post" action="${formUrl}">

<fieldset>
    <legend>
        <a class="imageLink" href="#" onclick="openPopupWindow('<b><fmt:message key="jsp.href.info" />: <fmt:message key="jsp.general.transferstudents" /></b><br/><fmt:message key="jsp.help.transferstudents" />');">
            <img src="<c:url value='/images/info.gif' />" alt="<fmt:message key="jsp.href.info" />" title="<fmt:message key="jsp.href.info" />" />
        </a>
        &nbsp;<fmt:message key="jsp.general.transferstudents" />
        &nbsp;&nbsp;&nbsp;
        <c:if test="${accessContextHelp}">
             <a class="white" href="<c:url value='/help/TransferStudents.pdf'/>" target="_blank">
                <img src="<c:url value='/images/help.png' />" alt="<fmt:message key="jsp.general.message.help" />" title="<fmt:message key="jsp.general.message.help" />" /> 
             </a>&nbsp;
        </c:if>
        
    </legend>

    <%@ include file="../../includes/organizationAndStudySettings.jsp"%>

</fieldset>


<%-- give feedback if student successfully created --%>
<c:if test="${not empty successfullyTransferredStudyPlanIds}">
    <table width="735" >
        <tr><td class="successful">
            <fmt:message key="jsp.transferstudents.success"> 
                <fmt:param><c:out value="${fn:length(successfullyTransferredStudyPlanIds)}"/></fmt:param>
            </fmt:message>
<%--                     <a href="<c:url value='/college/person/subscribeToSubjects.view'/>?<c:out value='academicYearId=${subscribeToAcademicYearId}&studyGradeTypeId=${subscribeToStudyGradeTypeId}&cardinalTimeUnitNumber=${subscribeToCardinalTimeUnitNumber}'/>"><fmt:message key="jsp.transferstudents.subscribe.subjects"/></a> --%>
        </td></tr>
        <tr/>
    </table>
</c:if>

<c:if test="${transferStudentsForm.studySettings.academicYearId != 0 && empty transferStudentsForm.nextAcademicYears}">
    <p class="msgwide">
        <fmt:message key="jsp.error.transferstudents.nonextacademicyear">
            <fmt:param><c:out value="${transferStudentsForm.idToAcademicYearMap[transferStudentsForm.studySettings.academicYearId].description}"/></fmt:param>
        </fmt:message>
    </p>
</c:if>


<c:choose>
    <c:when test="${empty transferStudentsForm.studySettings.cardinalTimeUnitNumber || transferStudentsForm.studySettings.cardinalTimeUnitNumber == 0}">
        <fmt:message key="jsp.transferstudents.please.use.filters"/>
    </c:when>
    <c:otherwise>

        
        <p><form:errors path="" cssClass="errorwide"/></p>

        <%-- MoVe 2011-08-25 - for now hidden
            <table>
                <!-- CTU success filter -->
                  <table style="margin-left:10px;">
                  <tr>
                    <td class="label"><fmt:message key="jsp.transferstudents.student.performance" /></td>
                    <td>
                        <form:select path="ctuSuccessOptionKey" onchange="document.transferStudentsForm.submit();">
                            <option value="0"><fmt:message key="jsp.selectbox.all" /></option>
                            <c:forEach var="entry" items="${transferStudentsForm.ctuSuccessOptions}">
                                <form:option value="${entry.key}" >
                                    <fmt:message key="${entry.value.messageKey}">
                                        <fmt:param>${entry.value.nExpectedSubjectsNotPassed}</fmt:param>
                                    </fmt:message>
                                </form:option>
                            </c:forEach>
                        </form:select>

                    
                    </td>
                  </tr>
                  </table>
                <!-- end of CTU success filter -->
            </table>
            --%>

            <table class="tabledata" id="TblData">
                <tr>
                    <td style="vertical-align:bottom">
                    <form:checkbox id="checker" 
                                path="checker"
                                onclick="javascript:checkAll('selectedStudyPlanCTUIds');"
                                />
                    </td>
                    <th style="vertical-align:bottom"><fmt:message key="jsp.general.code"/></th>
                    <th style="vertical-align:bottom"><fmt:message key="jsp.general.firstnames"/></th>
                    <th style="vertical-align:bottom"><fmt:message key="jsp.general.surname"/></th>
                    <th style="vertical-align:bottom" title='<fmt:message key="jsp.transferstudents.subjectssubscribed.header.title"/>'><fmt:message key="jsp.transferstudents.subjectssubscribed.header"/></th>
                    <th style="vertical-align:bottom" title='<fmt:message key="jsp.transferstudents.finalresult.header.title"><fmt:param value="${allCardinalTimeUnitsMap[selectedStudyGradeType.cardinalTimeUnitCode]}"/></fmt:message>'><fmt:message key="jsp.transferstudents.finalresult.header"/></th>
                    <th style="vertical-align:bottom" title='<fmt:message key="jsp.transferstudents.endgradecomment.header.title"><fmt:param value="${allCardinalTimeUnitsMap[selectedStudyGradeType.cardinalTimeUnitCode]}"/></fmt:message>'><fmt:message key="jsp.transferstudents.endgradecomment.header"/></th>
                    <th style="vertical-align:bottom"><fmt:message key="jsp.general.progressstatus" /></th>
                    <th style="vertical-align:bottom"><fmt:message key="jsp.general.academicyear" /></th>
                    <th style="vertical-align:bottom"><fmt:message key="jsp.transferstudents.onward.study" /></th>
                </tr>

                <c:forEach var="student" items="${transferStudentsForm.allStudents}" varStatus="studentLoopStatus">
                    <c:set var="studyPlan" value="${student.studyPlans[0]}"/>
                    <c:set var="studyPlanCTU" value="${studyPlan.studyPlanCardinalTimeUnits[0]}"/>
                    <c:set var="studyPlanCTUStatistics" value="${studyPlanCTUStatisticsFactory[studyPlanCTU]}" />
                    <tr>
                        <c:choose>
                            <c:when test="${invalidStudyPlanIds[studyPlanCTU.studyPlanId]}">
                                <td class="attention">  <!-- after an attempt to transfer invalid study plans display red border-->
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${successfullyTransferredStudyPlanIds[studyPlanCTU.studyPlanId]}">
                                        <td style="border:1px solid green;">
                                    </c:when>
                                    <c:otherwise>
<%--                                         <c:choose>
                                            <c:when test="${existingTargetStudyPlanIds[studyPlanCTU.studyPlanId]}">
                                                <td style="border:1px solid yellow;">
                                            </c:when>
                                            <c:otherwise> --%> 
                                               <td>
<%--                                             </c:otherwise>
                                        </c:choose> --%>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose> <!-- end of creation of td opening tag -->
                            <c:set var="graduating" value="${not studyPlanCTU.progressStatusPreselect
                                            && not empty studyPlanCTU.progressStatusCode
                                            && 'Y' eq transferStudentsForm.codeToProgressStatusMap[studyPlanCTU.progressStatusCode].graduating}">
                            </c:set>
                            <!-- if graduating then it's possible to transfer to another study grade type -->
	                        <c:set var="eligibleToTransfer" value="${not studyPlanCTU.progressStatusPreselect
                                            && not empty studyPlanCTU.progressStatusCode
	                                        && 'Y' eq transferStudentsForm.codeToProgressStatusMap[studyPlanCTU.progressStatusCode].continuing}">
	                        </c:set>
                            <c:if test="${eligibleToTransfer || graduating}">
                                <form:checkbox path="selectedStudyPlanCTUIds" value="${studyPlanCTU.id}"/>
                            </c:if>
                        </td>
                        <td><c:out value="${student.studentCode}"/></td>
                        <td><c:out value="${student.firstnamesFull}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${opusUser.personId == student.personId
                                 || (opusUserRole.role != 'student' 
                                 && opusUserRole.role != 'guest'
                                 && opusUserRole.role != 'staff')
                                }">
                                    <a href="<c:url value='/college/student/personal.view'/>?<c:out value='newForm=true&tab=0&panel=0&from=students&studentId=${student.studentId}'/>">
                                    <c:out value="${student.surnameFull}"/></a>
                                </c:when>
                                <c:otherwise>
                                    <c:out value="${student.surnameFull}"/>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a class="infobox" href="#INFO">
                                ${fn:length(studyPlanCTUStatistics.subscribedSubjects)}
                                / ${fn:length(studyPlanCTUStatistics.passedSubjectResults)}
                                / ${fn:length(studyPlanCTUStatistics.failedSubjectResults)}
                                / ${fn:length(studyPlanCTUStatistics.subjectsWithoutResult)}
                                <span>
                                    <b><fmt:message key="jsp.transferstudents.subscribedsubjects"/>:</b><br />
                                    <c:forEach var="line" items="${studyPlanCTUStatistics.subscribedSubjectsInfo}">
                                        <c:out value="${line}"/><br/>
                                    </c:forEach>
                                    <b><fmt:message key="jsp.transferstudents.resulthistory"/>:</b><br />
                                    <c:forEach var="line" items="${studyPlanCTUStatistics.subjectResultHistory}">
                                        <c:out value="${line}"/><br/>
                                    </c:forEach>
                                </span>
                            </a>
                        </td>
                        <c:set var="ctuResult" value="${studyPlanCTU.cardinalTimeUnitResult}" />
                        <td>
                            <%-- Using "white-space: nowrap" so that the refresh button right next to the combo box --%>
                            <div style="white-space: nowrap">
                                <c:out value="${transferStudentsForm.ctuResultFormatter[ctuResult]} - ${ctuResult.passed}"/>
                                <a class="imageLink" href="<c:url value='/college/person/transferStudents/generateEndGrade/${studentLoopStatus.index}'/>" >
                                    <img alt="(Re-)generate end grade and comment" src="<c:url value='/images/refresh57.svg' />" width="10" />
                                </a>
                            </div>
                            <form:errors path="allStudents[${studentLoopStatus.index}].studyPlans[0].studyPlanCardinalTimeUnits[0].cardinalTimeUnitResult.mark" cssClass="errornarrow"/>
                        </td>
                        <td>
                            <c:forEach var="endGrade" items="${transferStudentsForm.fullEndGradeCommentsForGradeType}">
                               <c:if test="${endGrade.code == ctuResult.endGradeComment}">  <%-- TODO change to codeToLookupMap --%>
                                   <c:out value="${endGrade.comment}"/>
                               </c:if>
                            </c:forEach>
                        </td>
                        <td>
                            <%-- Using class auto on select and option elements to avoid the default width of of 220px defined (see main1024.css) --%>
                            <c:choose>
                                <c:when test="${authUpdateProgressStatus}">
                                    <%-- Using "white-space: nowrap" so that the refresh button right next to the combo box --%>
                                    <div style="white-space: nowrap">
                                        <form:select cssClass="auto" path="progressStatusCodes[${studyPlanCTU.id}]">
                                            <option class="auto" value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                            <c:forEach var="progressStatus" items="${transferStudentsForm.allProgressStatuses}">
                                                <form:option cssClass="auto" value="${progressStatus.code}" >
                                                    <c:if test="${studyPlanCTU.progressStatusPreselect}">
                                                        *
                                                    </c:if>
                                                    <c:out value="${allProgressStatusesMap[progressStatus.code]}"/>
                                                    <c:set var="unitAndYear" value="${transferStudentsForm.progressStatusToTimeUnitMap[progressStatus.code]}"/>
                                                    <c:if test="${not empty unitAndYear}">
                                                        ( &rarr;
                                                        <c:out value="
                                                        ${allCardinalTimeUnitsMap[unitAndYear.cardinalTimeUnitCode]}
                                                        ${unitAndYear.cardinalTimeUnitNumber}
                                                        "/>
                                                        )
                                                    </c:if>
                                                </form:option>
                                            </c:forEach>
                                        </form:select>
                                        <a class="imageLink" href="<c:url value='/college/person/transferStudents/preselectProgressStatus/${studentLoopStatus.index}'/>" >
                                            <img alt="(Re-)generate progress status" src="<c:url value='/images/refresh57.svg' />" width="10" />
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    ${allProgressStatusesMap[studyPlanCTU.progressStatusCode]}
                                    <c:set var="unitAndYear" value="${transferStudentsForm.progressStatusToTimeUnitMap[studyPlanCTU.progressStatusCode]}"/>
                                    <c:if test="${unitAndYear.cardinalTimeUnitNumber != 0}">
                                        ( &rarr;
                                        <c:out value="
                                        ${allCardinalTimeUnitsMap[unitAndYear.cardinalTimeUnitCode]}
                                        ${unitAndYear.cardinalTimeUnitNumber}
                                        "/>
                                        )
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <%-- Using class auto on select and option elements to avoid the default width of of 220px defined (see main1024.css) --%>
                            <c:if test="${eligibleToTransfer}">
				                <form:select cssClass="auto" path="targetAcademicYearIds[${studyPlanCTU.id}]">
                                    <option class="auto" value="0"><fmt:message key="jsp.selectbox.choose" /></option>
				                    <form:options cssClass="auto" items="${transferStudentsForm.allTargetAcademicYears}"
				                        itemLabel="description" itemValue="id"/>
				                </form:select>
                            </c:if>
                        </td>
                        <td>
                            <%-- Using class auto on select and option elements to avoid the default width of of 220px defined (see main1024.css) --%>
                            <c:if test="${graduating}">
                                <form:select cssClass="auto" path="targetStudyGradeTypeIds[${studyPlanCTU.id}]" >
                                    <option class="auto" value="0"><fmt:message key="jsp.selectbox.choose" /></option>

                                    <c:set var="firstChoiceSGT" value="${transferStudentsForm.firstChoiceStudyGradeTypes[studyPlanCTU.id]}"/>
                                    <c:if test="${not empty firstChoiceSGT}">
                                        <c:set var="optionText">
                                            1. <fmt:message key="format.study.orgunit.gradetype.academicyear.studyform.studytime">
                                                  <fmt:param value="${firstChoiceSGT.studyDescription}"/>
												  <fmt:param value="${transferStudentsForm.idToOrganizationalUnitMap[transferStudentsForm.idToStudyMap[firstChoiceSGT.studyId].organizationalUnitId].organizationalUnitDescription}"/>
												  <fmt:param value="${firstChoiceSGT.gradeTypeDescription}"/>
												  <fmt:param value="${transferStudentsForm.idToAcademicYearMap[firstChoiceSGT.currentAcademicYearId].description}"/>
												  <fmt:param value="${transferStudentsForm.codeToStudyFormMap[firstChoiceSGT.studyFormCode].description}"/>
                                                  <fmt:param value="${transferStudentsForm.codeToStudyTimeMap[firstChoiceSGT.studyTimeCode].description}"/>
                                               </fmt:message>
                                        </c:set>
                                        <%-- Set the title attribute so that long texts are readable in a mouse popup --%>
                                        <form:option cssClass="auto" value="${firstChoiceSGT.id}" title="${optionText}">${optionText}</form:option>
                                    </c:if>
                                    
                                    <c:set var="secondChoiceSGT" value="${transferStudentsForm.secondChoiceStudyGradeTypes[studyPlanCTU.id]}"/>
                                    <c:if test="${not empty secondChoiceSGT}">
                                        <c:set var="optionText">
                                            2. <fmt:message key="format.study.orgunit.gradetype.academicyear.studyform.studytime">
                                                	<fmt:param value="${secondChoiceSGT.studyDescription}"/> 
                                                	<fmt:param value="${transferStudentsForm.idToOrganizationalUnitMap[transferStudentsForm.idToStudyMap[secondChoiceSGT.studyId].organizationalUnitId].organizationalUnitDescription}"/>
                                                	<fmt:param value="${secondChoiceSGT.gradeTypeDescription}"/>
                                                	<fmt:param value="${transferStudentsForm.idToAcademicYearMap[secondChoiceSGT.currentAcademicYearId].description}"/>
                                                	<fmt:param value="${transferStudentsForm.codeToStudyFormMap[secondChoiceSGT.studyFormCode].description}"/> 
                                                	<fmt:param value="${transferStudentsForm.codeToStudyTimeMap[secondChoiceSGT.studyTimeCode].description}"/> 
                                               </fmt:message>
                                        </c:set>
                                        <%-- Set the title attribute so that long texts are readable in a mouse popup --%>
                                        <form:option cssClass="auto" value="${secondChoiceSGT.id}" title="${optionText}">${optionText}</form:option>
                                    </c:if>
                                    
                                    <c:set var="thirdChoiceSGT" value="${transferStudentsForm.thirdChoiceStudyGradeTypes[studyPlanCTU.id]}"/>
                                    <c:if test="${not empty thirdChoiceSGT}">
                                        <c:set var="optionText">
                                            3. <fmt:message key="format.study.orgunit.gradetype.academicyear.studyform.studytime">
                                                  <fmt:param value="${thirdChoiceSGT.studyDescription}"/>
												  <fmt:param value="${transferStudentsForm.idToOrganizationalUnitMap[transferStudentsForm.idToStudyMap[thirdChoiceSGT.studyId].organizationalUnitId].organizationalUnitDescription}"/>
												  <fmt:param value="${thirdChoiceSGT.gradeTypeDescription}"/>
												  <fmt:param value="${transferStudentsForm.idToAcademicYearMap[thirdChoiceSGT.currentAcademicYearId].description}"/>
												  <fmt:param value="${transferStudentsForm.codeToStudyFormMap[thirdChoiceSGT.studyFormCode].description}"/>
                                                  <fmt:param value="${transferStudentsForm.codeToStudyTimeMap[thirdChoiceSGT.studyTimeCode].description}"/>
                                               </fmt:message>
                                        </c:set>
                                        <%-- Set the title attribute so that long texts are readable in a mouse popup --%>
                                        <form:option cssClass="auto" value="${thirdChoiceSGT.id}" title="${optionText}">${optionText}</form:option>
                                    </c:if>
                                    
                                    <c:if test="${not empty firstChoiceSGT
                                                || not empty secondChoiceSGT
                                                || not empty thirdChoiceSGT}">
                                        <option class="auto"disabled="disabled" value="-1">------------------</option>
                                    </c:if>
                                    
                                    <c:forEach var="oneSGT" items="${transferStudentsForm.allStudyGradeTypes}">
                                        <%-- do not repeat the 1./2./3. choice and do not show the same study as the currently graduated one --%>
                                        <c:if test="${oneSGT.id != firstChoiceSGT.id
                                                    && oneSGT.id != secondChoiceSGT.id
                                                    && oneSGT.id != thirdChoiceSGT.id
                                                    && !(oneSGT.studyId == selectedStudyGradeType.studyId && fn:trim(oneSGT.gradeTypeCode) == fn:trim(selectedStudyGradeType.gradeTypeCode))
                                                    }">
                                            <c:set var="optionText">
                                               <fmt:message key="format.study.orgunit.gradetype.academicyear.studyform.studytime">
                                                  <fmt:param value="${oneSGT.studyDescription}"/>
												  <fmt:param value="${transferStudentsForm.idToOrganizationalUnitMap[transferStudentsForm.idToStudyMap[oneSGT.studyId].organizationalUnitId].organizationalUnitDescription}"/>
												  <fmt:param value="${oneSGT.gradeTypeDescription}"/>
												  <fmt:param value="${transferStudentsForm.idToAcademicYearMap[oneSGT.currentAcademicYearId].description}"/>
												  <fmt:param value="${transferStudentsForm.codeToStudyFormMap[oneSGT.studyFormCode].description}"/>
                                                  <fmt:param value="${transferStudentsForm.codeToStudyTimeMap[oneSGT.studyTimeCode].description}"/>
                                               </fmt:message>
                                            </c:set>
                                            
                                            <%-- Set the title attribute so that long texts are readable in a mouse popup --%>
                                            <form:option cssClass="auto" value="${oneSGT.id}" title="${optionText}">${optionText}</form:option>
                                        </c:if>
                                    </c:forEach>
                                </form:select>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>

                <tr>
                    <%-- Using th (not td) so that the background color is not alternated for the buttons --%>
                <th style="vertical-align: baseline;" colspan="3">
                    <sec:authorize access="hasRole('TRANSFER_STUDENTS')">
                        <!-- submit button -->
                        <input type="submit" id="transfer_button" name="transferStudents" value="<fmt:message key='jsp.button.transferstudents' />" />
                    </sec:authorize>
                </th>
                <th />
                <th style="vertical-align: baseline;" colspan="2">
                    <sec:authorize access="hasAnyRole('CREATE_STUDYPLAN_RESULTS', 'UPDATE_STUDYPLAN_RESULTS','UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL')">
                        <!-- submit button -->
                        <input type="submit" id="generate_endgrades_button" name="generateEndGrades" value="<fmt:message key='jsp.button.generate.endgrades' />" />
                    </sec:authorize> 
                </th>
                <th />
                <th style="vertical-align: baseline;">
                    <sec:authorize access="hasRole('UPDATE_PROGRESS_STATUS')">
                        <!-- submit button -->
                        <input type="submit" id="preselect_progress_button" name="preSelectProgress" value="* <fmt:message key='jsp.button.preselect.progress.status' />" />
                    </sec:authorize>
                    <sec:authorize access="hasRole('UPDATE_PROGRESS_STATUS')">
                        <!-- submit button -->
                        <input type="submit" id="update_progress_button" name="updateProgress" value="<fmt:message key='jsp.button.update.progress.status' />" />
                    </sec:authorize>
                </th>
                <th>
                </th>
                
                <th>
                </th>
                </tr>
            </table>
            <script type="text/javascript">alternate('TblData',true)</script>

            <fmt:message key="jsp.general.numberofstudents" />: ${fn:length(transferStudentsForm.allStudents)}

<%--            <table style="margin-left:10px;">
                <tr>
                <td width="180">
< %--                <sec:authorize access="hasAnyRole('CREATE_STUDYPLAN_RESULTS', 'UPDATE_STUDYPLAN_RESULTS','UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL')">
                    <!-- submit button -->
                    <input type="submit" id="generate_endgrades_button" name="generateEndGrades" value="<fmt:message key='jsp.button.generate' /> <fmt:message key='jsp.general.endgrades' />" />
                </sec:authorize>--% > 
                </td> 
                <td width="180">
< %--                <sec:authorize access="hasRole('UPDATE_PROGRESS_STATUS')">
                    <!-- submit button -->
                    <input type="submit" id="update_progress_button" name="updateProgress" value="<fmt:message key='jsp.button.update.progress.status' />" />
                </sec:authorize>--% >
                </td>
                <td width="180">
                <sec:authorize access="hasRole('TRANSFER_STUDENTS')">
                    <!-- submit button -->
                    <input type="submit" id="transfer_button" name="transferStudents" value="<fmt:message key='jsp.button.transferstudents' />" />
                </sec:authorize>
                </td>
                </tr>
            </table> --%>
        
    </c:otherwise>
</c:choose>
</form:form>

<%-- Inform once about successfully transferred students, afterwards discard information --%>
<c:remove var="successfullyTransferredStudyPlanIds" scope="session"/>
<c:remove var="subscribeToAcademicYearId" scope="session"/>
<c:remove var="subscribeToStudyGradeTypeId" scope="session"/>
<c:remove var="subscribeToCardinalTimeUnitNumber" scope="session"/>

</div>

</div>

<%@ include file="../../includes/javascriptfunctions.jsp"%>
<%@ include file="../../footer.jsp"%>
