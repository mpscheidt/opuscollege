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

    <%-- Shortcut to the form object --%>
    <c:set var="form" value="${studyPlanCardinalTimeUnitForm}" scope="page" />

	<c:set var="organization" value="${studyPlanCardinalTimeUnitForm.organization}" scope="page" />
	<c:set var="navigationSettings" value="${studyPlanCardinalTimeUnitForm.navigationSettings}" scope="page" />

	<%--  page vars --%>
	<c:set var="personId" value="${studyPlanCardinalTimeUnitForm.student.personId}" scope="page" />
	<c:set var="studyPlanCardinalTimeUnit" value="${studyPlanCardinalTimeUnitForm.studyPlanCardinalTimeUnit}" scope="page" />
	<c:set var="student" value="${studyPlanCardinalTimeUnitForm.student}" scope="page" />
	<c:set var="studyPlan" value="${studyPlanCardinalTimeUnitForm.studyPlan}" scope="page" />
	<c:set var="studyGradeType" value="${studyPlanCardinalTimeUnitForm.studyGradeType}" scope="page" />
	<c:set var="cardinalTimeUnitStudyGradeType" value="${studyPlanCardinalTimeUnitForm.cardinalTimeUnitStudyGradeType}" scope="page" />

	<!-- authorizations -->
	<sec:authorize access="hasAnyRole('UPDATE_STUDENT_SUBSCRIPTION_DATA','CREATE_STUDENT_SUBSCRIPTION_DATA')">
		<c:set var="editSubscriptionData" value="${true}" />
	</sec:authorize>
	<c:if test="${not editSubscriptionData}">
		<sec:authorize access="hasRole('READ_STUDYPLAN_RESULTS')">
			<c:set var="showSubscriptionData" value="${true}" />
		</sec:authorize>
	</c:if>
	<sec:authorize access="hasRole('REVERSE_PROGRESS_STATUS')">
		<c:set var="reverseProgressStatus" value="${true}" />
	</sec:authorize>

	<%-- MP todo
    <c:set var="authApproveSubscriptions" value="${false}"/>
    <sec:authorize access="hasRole('APPROVE_SUBJECT_SUBSCRIPTIONS')">
        <c:set var="authApproveSubscriptions" value="${true}"/>
    </sec:authorize>
    
    <c:set var="authSubscribeMany" value="${false}"/>
    <sec:authorize access="hasRole('CREATE_STUDYPLANDETAILS_PENDING_APPROVAL')">
        <c:set var="authSubscribeMany" value="${true}"/>
    </sec:authorize>
    
    <c:set var="authSubscribeOwn" value="${false}"/>
    <sec:authorize access="hasRole('CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL')">
        <c:set var="authSubscribeOwn" value="${true}"/>
    </sec:authorize>
    
    <!-- for convenience -->
    <c:set var="authSubscribeOwnOrMany" value="${authSubscribeOwn || authSubscribeMany}"/> 
--%>


<div id="tabcontent">

<fieldset>
	<legend>
		<a href="<c:url value='/college/students.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message
				key="jsp.students.header" />
        </a>&nbsp;>&nbsp;
        <a href="<c:url value='/college/student/subscription.view?newForm=true&amp;tab=2&amp;panel=0&amp;studentId=${student.studentId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
			<c:choose>
				<c:when test="${not empty student.surnameFull}">
					<c:set var="studentName" value="${fn:trim(student.studentCode)} ${fn:trim(student.surnameFull)}, ${fn:trim(student.firstnamesFull)}" scope="page" />
                    <c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}"/>
                </c:when>
				<c:otherwise>
					<fmt:message key="jsp.href.new" />
				</c:otherwise>
			</c:choose>
		</a>
        <br />&nbsp;&nbsp;&nbsp;&nbsp;
        <a href="<c:url value='/college/studyplan.view?newForm=true&amp;tab=1&amp;panel=0&amp;studyPlanId=${studyPlan.id}&amp;studentId=${student.studentId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
            <c:out value="${studyPlan.study.studyDescription}" /> <c:out value="${studyPlan.gradeTypeCode}" />
		</a> &nbsp;>&nbsp;
		<fmt:message key="jsp.general.add" />
		/
		<fmt:message key="jsp.general.edit" />
		&nbsp;
		<fmt:message key="jsp.general.studyplancardinaltimeunit" />
	</legend>
</fieldset>

<div id="tp1" class="TabbedPanel">
<ul class="TabbedPanelsTabGroup">
	<li class="TabbedPanelsTab"><fmt:message key="jsp.general.edit" /></li>
</ul>

<div class="TabbedPanelsContentGroup">
<div class="TabbedPanelsContent">
<div class="Accordion" id="Accordion1">
<div class="AccordionPanel">
<div class="AccordionPanelTab">
	<fmt:message key="jsp.general.studyplancardinaltimeunit" />
</div>
<div class="AccordionPanelContent">

    <form:errors path="studyPlanCardinalTimeUnitForm.*" cssClass="errorwide" element="p"/>

	<c:choose>
		<c:when
			test="${ not empty studyPlanCardinalTimeUnitForm.txtMsg }">
			<p align="right" class="msg">
				<c:out value="${studyPlanCardinalTimeUnitForm.txtMsg}"/>
            </p>
		</c:when>
	</c:choose>

    <form name="formdata" method="post">
        <input type="hidden" name="submitFormObject" id="submitFormObject" value="" />
        <input type="hidden" name="tab" value="${navigationSettings.tab}" />
        <input type="hidden" name="panel" value="${navigationSettings.panel}" />

        <c:if test="${studyPlanCardinalTimeUnitForm.studyPlanCardinalTimeUnit.id != '' && studyPlanCardinalTimeUnitForm.studyPlanCardinalTimeUnit.id != '0'}">
            <div class="crosslinkbar">
                <sec:authorize access="hasAnyRole('CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL','CREATE_STUDYPLANDETAILS_PENDING_APPROVAL','APPROVE_SUBJECT_SUBSCRIPTIONS', 'FINALIZE_ADMISSION_FLOW')">
                    <a class="button"
                        href="<c:url value='/college/person/subscribeToSubjects.view?newForm=true&amp;tab=0&amp;panel=0&amp;primaryStudyId=${studyPlan.studyId}&amp;studyGradeTypeId=${studyGradeType.id}&amp;cardinalTimeUnitNumber=${studyPlanCardinalTimeUnit.cardinalTimeUnitNumber}&amp;academicYearId=${studyGradeType.currentAcademicYearId}'/>"
                        ><fmt:message key="jsp.menu.subscribe.to.subjects"/></a>
                </sec:authorize>
                <a class="button"
                    href="<c:url value='/college/cardinaltimeunitresult.view?newForm=true&amp;studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&amp;tab=0&amp;panel=0'/>"
                    ><fmt:message key="jsp.general.resultsoverview"/></a>
            </div>
        </c:if>

		<table>

			<!--  CARDINAL TIME UNIT NUMBER -->
			<tr>
				<td class="label" width="200"><fmt:message key="jsp.general.cardinaltimeunit" /></td>
				<td>
                    <c:choose>
						<c:when test="${studyPlanCardinalTimeUnit.cardinalTimeUnitNumber != '0' }">
                            <c:out value="${studyPlanCardinalTimeUnit.cardinalTimeUnitNumber}"/>
                        </c:when>
                        <c:otherwise>
                            <fmt:message key="jsp.general.any" />
                        </c:otherwise>
                    </c:choose>
                </td>
			</tr>

			<!--  STUDYGRADETYPE -->
			<tr>
				<td class="label"><fmt:message key="jsp.general.studygradetype" /></td>
				<spring:bind path="studyPlanCardinalTimeUnitForm.studyPlanCardinalTimeUnit.studyGradeTypeId">
					<td colspan="2">
                        <c:choose>
							<c:when test="${studyPlanCardinalTimeUnit.id == 0 || editSubscriptionData}">
								<select class="long" name="${status.expression}"  id="${status.expression}" onchange="document.getElementById('submitFormObject').value='studyGradeTypeIdSelect';document.formdata.submit();">
									<option style="width: auto;" value="0">
										<fmt:message key="jsp.selectbox.choose" />
									</option>
									<c:forEach var="oneStudyGradeType" items="${studyPlanCardinalTimeUnitForm.allStudyGradeTypes}">
										<c:set var="study" value="${studyPlanCardinalTimeUnitForm.idToStudyMap[oneStudyGradeType.studyId]}" />

                                        <c:set var="optionText">
                                            <fmt:message key="format.study.orgunit.gradetype.academicyear.studyform.studytime">
                                                <fmt:param value="${study.studyDescription}" />
                                                <fmt:param value="${form.idToOrganizationalUnitMap[study.organizationalUnitId].organizationalUnitDescription}" />
                                                <fmt:param value="${form.codeToGradeTypeMap[oneStudyGradeType.gradeTypeCode].description}" />
                                                <fmt:param value="${form.idToAcademicYearMap[oneStudyGradeType.currentAcademicYearId].description }" />
                                                <fmt:param value="${form.codeToStudyFormMap[oneStudyGradeType.studyFormCode].description}" />
                                                <fmt:param value="${form.codeToStudyTimeMap[oneStudyGradeType.studyTimeCode].description}" />
                                            </fmt:message>
                                        </c:set>

										<c:choose>
											<c:when test="${oneStudyGradeType.id == status.value}">
												<option style="width: auto;"
													value="${oneStudyGradeType.id}" selected="selected"
													title="${optionText}">
                                                    ${optionText}
                                                </option>
											</c:when>
											<c:otherwise>
												<option style="width: auto;"
													value="${oneStudyGradeType.id}"
													title="${optionText}">
                                                    ${optionText}
                                                </option>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</select>
							</c:when>
							<c:otherwise>
                                <c:set var="oneStudyGradeType" value="${form.idToStudyGradeTypeMap[form.studyPlanCardinalTimeUnit.studyGradeTypeId]}" />
                                <c:out value="${oneStudyGradeType.studyDescription}"/>
                                <c:set var="studyGradeTypeString">
                                    <fmt:message key="format.gradetype.academicyear.studyform.studytime">
                                        <fmt:param value="${oneStudyGradeType.gradeTypeDescription}" />
                                        <fmt:param value="${form.idToAcademicYearMap[oneStudyGradeType.currentAcademicYearId].description}" />
                                        <fmt:param value="${form.codeToStudyFormMap[oneStudyGradeType.studyFormCode].description}" />
                                        <fmt:param value="${form.codeToStudyTimeMap[oneStudyGradeType.studyTimeCode].description}" />
                                    </fmt:message>
                                </c:set>
                                <c:out value="${studyGradeTypeString}"></c:out>
<%-- 								<c:forEach var="oneStudyGradeType" items="${studyPlanCardinalTimeUnitForm.allStudyGradeTypes}"> --%>
<%-- 									<c:choose> --%>
<%-- 										<c:when test="${oneStudyGradeType.id == status.value}"> --%>
<%-- 											<c:forEach var="study" items="${studyPlanCardinalTimeUnitForm.allStudies}"> --%>
<%-- 												<c:choose> --%>
<%-- 													<c:when test="${study.id == oneStudyGradeType.studyId}"> --%>
<%-- 			                           			       <c:out value="${study.studyDescription}"/> --%>
<%-- 			                           		        </c:when> --%>
<%-- 												</c:choose> --%>
<%-- 											</c:forEach> --%>
<%-- <%--                                             - ${form.codeToGradeTypeMap[oneStudyGradeType.gradeTypeCode].description} --%>
<%-- <%-- 											<c:forEach var="gradeType" items="${allGradeTypes}"> --%> 
<%-- <%-- 												<c:choose> --%>
<%-- <%-- 													<c:when test="${gradeType.code == oneStudyGradeType.gradeTypeCode}"> --%> 
<%-- <%-- 			                           			       - <c:out value="${gradeType.description}"/> --%>
<%-- <%-- 					                           		</c:when> --%> 
<%-- <%-- 												</c:choose> --%>
<%-- <%-- 											</c:forEach> --%>
<%-- 											<c:forEach var="academicYear" items="${studyPlanCardinalTimeUnitForm.allAcademicYears}"> --%>
<%-- 												<c:choose> --%>
<%-- 													<c:when test="${academicYear.id == oneStudyGradeType.currentAcademicYearId}"> --%>
<%--                            						       (<c:out value="${academicYear.description}"/> --%>
<%--                            					        </c:when> --%>
<%-- 												</c:choose> --%>
<%-- 											</c:forEach> --%>
<%-- 											<c:forEach var="studyTime" items="${allStudyTimes}"> --%>
<%-- 												<c:choose> --%>
<%-- 													<c:when test="${studyTime.code == oneStudyGradeType.studyTimeCode}"> --%>
<%--                                                         - <c:out value="${studyTime.description}"/>) --%>
<%--                                                     </c:when> --%>
<%-- 												</c:choose> --%>
<%-- 											</c:forEach> --%>
<%-- 										</c:when> --%>
<%-- 									</c:choose> --%>
<%-- 								</c:forEach> --%>
							</c:otherwise>
						</c:choose>
                    </td>
					<td><c:forEach var="error" items="${status.errorMessages}">
							<span class="error">${error}</span>
						</c:forEach>
                    </td>
				</spring:bind>
            </tr>

            <%-- CARDINAL TIME UNIT STATUS --%>
            <%-- only editable for authorized personnel, is automatically edited by student transfer and subject subscription process --%>
            <tr>
                <td class="label"><fmt:message key="jsp.general.cardinaltimeunitstatus" /></td>
                <spring:bind path="studyPlanCardinalTimeUnitForm.studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode">
                    <td>
                        <c:choose>
                            <c:when test="${editSubscriptionData}">
                                <select class="long" id="${status.expression}" name="${status.expression}">
                                    <option value="">
                                        <fmt:message key="jsp.selectbox.choose" />
                                    </option>
                                    <c:forEach var="oneStatus" items="${form.allCardinalTimeUnitStatuses}">
                                        <c:choose>
                                           <c:when test="${oneStatus.code == status.value}">
                                                <option value="${oneStatus.code}" selected="selected"><c:out value="${oneStatus.description}"/></option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="${oneStatus.code}"><c:out value="${oneStatus.description}"/></option>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </select>
                            </c:when>
                            <c:otherwise>
                                <c:out value="${form.codeToCardinalTimeUnitStatusMap[form.studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode].description}"></c:out>
<%--                                 <c:forEach var="oneStatus" items="${allCardinalTimeUnitStatuses}"> --%>
<%--                                     <c:if test="${oneStatus.code == status.value}"> --%>
<%--                                         <c:out value="${oneStatus.description}"/> --%>
<%--                                     </c:if> --%>
<%--                                 </c:forEach> --%>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:forEach var="error" items="${status.errorMessages}">
                            <span class="error">${error}</span>
                        </c:forEach>
                    </td>
				</spring:bind>
            </tr>

            <%-- STUDY INTENSITY --%>
			<c:choose>
				<c:when test="${studyPlanCardinalTimeUnitForm.studyPlanCardinalTimeUnit.id != 0 && editSubscriptionData}">
					<tr>
						<td class="label"><fmt:message key="jsp.general.studyintensity" /></td>
						<td>
                            <form:select path="studyPlanCardinalTimeUnitForm.studyPlanCardinalTimeUnit.studyIntensityCode">
								<option value="">
									<fmt:message key="jsp.selectbox.choose" />
								</option>
								<form:options items="${form.allStudyIntensities}" itemValue="code" itemLabel="description" />
							</form:select>
                        </td>
					</tr>
				</c:when>
				<c:otherwise>
					<tr>
						<td class="label"><fmt:message key="jsp.general.studyintensity" /></td>
						<td>
                            <c:out value="${form.codeToStudyIntensityMap[form.studyPlanCardinalTimeUnit.studyIntensityCode].description}"></c:out>
<%--                             <spring:bind path="studyPlanCardinalTimeUnitForm.studyPlanCardinalTimeUnit.studyIntensityCode"> --%>
<%-- 								<c:forEach var="oneStudyintensity" items="${allStudyIntensities}"> --%>
<%-- 									<c:choose> --%>
<%-- 										<c:when test="${oneStudyintensity.code == status.value}"> --%>
<%--                                             <c:out value="${oneStudyintensity.description}"/> --%>
<%--                                         </c:when> --%>
<%-- 									</c:choose> --%>
<%-- 								</c:forEach> --%>
<%-- 							</spring:bind> --%>
                        </td>
					</tr>
				</c:otherwise>
			</c:choose>
            
            <%-- PROGRESS STATUS --%>
            <%-- only show, is edited within exams / results --%>
            
            <tr>
                <td class="label"><fmt:message key="jsp.general.progressstatuscode" /></td>
                <spring:bind path="studyPlanCardinalTimeUnitForm.studyPlanCardinalTimeUnit.progressStatusCode">
                    <td>
                        <c:choose>
                            <c:when test="${reverseProgressStatus}">
                                <select class="long" id="${status.expression}" name="${status.expression}">
                                    <option value="">
                                        <fmt:message key="jsp.selectbox.choose" />
                                    </option>
                                    <c:forEach var="oneStatus" items="${form.allProgressStatuses}">
                                        <c:choose>
                                            <c:when test="${oneStatus.code == status.value}">
                                                <option value="${oneStatus.code}" selected="selected"><c:out value="${oneStatus.description}"/></option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="${oneStatus.code}"><c:out value="${oneStatus.description}"/></option>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </select>
                            </c:when>
                            <c:otherwise>
                                <c:out value="${form.codeToProgressStatusMap[form.studyPlanCardinalTimeUnit.progressStatusCode].description}"></c:out>
<%--                                 <c:set var="progressStatusDescription" value="-" scope="page" /> --%>
<%--                                 <c:forEach var="oneStatus" items="${allProgressStatuses}"> --%>
<%--                                     <c:choose> --%>
<%--                                         <c:when test="${oneStatus.code == status.value}"> --%>
<%--                                             <c:set var="progressStatusDescription" value="${oneStatus.description}" scope="page" /> --%>
<%--                                         </c:when> --%>
<%--                                     </c:choose> --%>
<%--                                 </c:forEach> --%>
<%--                                 <c:out value="${progressStatusDescription}"/> --%>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:forEach var="error" items="${status.errorMessages}">
                            <span class="error">${error}</span>
                        </c:forEach>
                    </td>
                </spring:bind>
            </tr>

			<!-- ACTIVE -->
            <tr>
                <td class="label"><fmt:message key="jsp.general.active" /></td>
                <spring:bind path="studyPlanCardinalTimeUnitForm.studyPlanCardinalTimeUnit.active">
                    <td>
                        <c:choose>
                            <c:when test="${editSubscriptionData}">
                                <select id="${status.expression}" name="${status.expression}">
                                    <c:choose>
                                        <c:when test="${'Y' == status.value}">
                                            <option value="Y" selected="selected">
                                                <fmt:message key="jsp.general.yes" />
                                            </option>
                                            <option value="N">
                                                <fmt:message key="jsp.general.no" />
                                            </option>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="Y">
                                                <fmt:message key="jsp.general.yes" />
                                            </option>
                                            <option value="N" selected="selected">
                                                <fmt:message key="jsp.general.no" />
                                            </option>
                                        </c:otherwise>
                                    </c:choose>
                                </select>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${'Y' == status.value}">
                                        <fmt:message key="jsp.general.yes" />
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:message key="jsp.general.no" />
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:forEach var="error" items="${status.errorMessages}">
                            <span class="error"> ${error}</span>
                        </c:forEach>
                    </td>
                </spring:bind>
            </tr>

            <!-- TUITIONWAIVER -->
            <tr>
                <td class="label"><fmt:message key="jsp.general.tuitionWaiver" /></td>
                <spring:bind path="studyPlanCardinalTimeUnitForm.studyPlanCardinalTimeUnit.tuitionWaiver">
                    <td>
                        <c:choose>
                            <c:when test="${editSubscriptionData}">
                                <select id="${status.expression}" name="${status.expression}">
                                    <c:choose>
                                        <c:when test="${'Y' == status.value}">
                                            <option value="Y" selected="selected">
                                                <fmt:message key="jsp.general.yes" />
                                            </option>
                                            <option value="N">
                                                <fmt:message key="jsp.general.no" />
                                            </option>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="Y">
                                                <fmt:message key="jsp.general.yes" />
                                            </option>
                                            <option value="N" selected="selected">
                                                <fmt:message key="jsp.general.no" />
                                            </option>
                                        </c:otherwise>
                                    </c:choose>
                                </select>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${'Y' == status.value}">
                                        <fmt:message key="jsp.general.yes" />
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:message key="jsp.general.no" />
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:forEach var="error" items="${status.errorMessages}">
                            <span class="error"> ${error}</span>
                        </c:forEach>
                    </td>
                </spring:bind>
            </tr>


			<!-- SUBMIT BUTTON -->
			<c:choose>
				<c:when test="${editSubscriptionData || reverseProgressStatus}">
					<tr>
						<td class="label">&nbsp;</td>
						<td colspan="2" align="right"><input type="button" name="submitformdata"
							value="<fmt:message key="jsp.button.submit" />"
							onclick="document.getElementById('submitFormObject').value='true';document.formdata.submit();" />
						</td>
					</tr>
				</c:when>
			</c:choose>

			<!--  METADATA STUDY PLAN DETAILS -->

			<c:choose>
				<c:when test="${studyPlanCardinalTimeUnit.id != 0}">

					<tr>
						<td colspan="3"><hr /></td>
					</tr>

					<tr>
						<td class="label"><fmt:message
								key="jsp.general.numberofsubjects.cardinaltimeunit" /></td>
						<td colspan="2">
							<c:out value="${studyGradeType.numberOfSubjectsPerCardinalTimeUnit}"/>
                            <c:choose>
								<c:when test="${editSubscriptionData}">
								(<fmt:message key="jsp.general.max.numberofsubjects.cardinaltimeunit" />: <c:out value="${studyPlanCardinalTimeUnitForm.maxNumberOfSubjectsPerCardinalTimeUnit}"/>)
							    </c:when>
							</c:choose>
						</td>
					</tr>
					<c:if test="${appUseOfSubjectBlocks == 'Y'}">
						<tr>
							<td class="label"><fmt:message key="jsp.general.electivesubjectblocks" /></td>
							<td colspan="2">
								<c:out value="${cardinalTimeUnitStudyGradeType.numberOfElectiveSubjectBlocks}"/>
							</td>
						</tr>
					</c:if>
					<tr>
						<td class="label"><fmt:message
								key="jsp.general.electivesubjects" /></td>
						<td colspan="2">
							<c:out value="${cardinalTimeUnitStudyGradeType.numberOfElectiveSubjects}"/>
						</td>
					</tr>
					<tr>
						<td class="label">
                            <fmt:message key="jsp.general.totalnumberof" />
                            <fmt:message key="jsp.general.subjects" />
                        </td>
						<td colspan="2">
							<c:out value="${studyPlanCardinalTimeUnitForm.totalNumberOfSubjects}"/>
                        </td>
					</tr>
				</c:when>
			</c:choose>

			<c:choose>
				<c:when test="${studyPlanCardinalTimeUnitForm.studyPlanCardinalTimeUnit.id != '' 
				    && studyPlanCardinalTimeUnitForm.studyPlanCardinalTimeUnit.id != '0'}">

					<tr>
						<td colspan="3"><hr /></td>
					</tr>

					<!--  COMPULSORY STUDY PLAN DETAILS -->

					<tr>
						<td class="header" colspan="3">
                            <fmt:message key="jsp.general.studyplandetails" />
                        </td>
					</tr>

					<tr>
						<td class="label">&nbsp;</td>
						<td colspan="2" align="right"><c:choose>
								<c:when test="${editSubscriptionData}">
									<c:choose>
										<c:when test="${(studyGradeType.maxNumberOfSubjectsPerCardinalTimeUnit != '0' && studyPlanCardinalTimeUnitForm.totalNumberOfSubjects < studyGradeType.maxNumberOfSubjectsPerCardinalTimeUnit)
                            		           || (studyPlanCardinalTimeUnitForm.totalNumberOfSubjects < iMaxSubjectsPerCardinalTimeUnit)}">
											<a class="button" href="<c:url value='/college/studyplandetail.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;from=student&amp;studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                <fmt:message key="general.add.studyplandetails" />
                                            </a>
<%--                                             <a class="button" href="<c:url value='/college/studyplandetail.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;from=student&amp;studyPlanId=${studyPlan.id}&amp;studentId=${student.studentId}&amp;studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&amp;rigidityTypeCode=3&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"> --%>
<%--                                                 <fmt:message key="general.add.electivestudyplandetails" /> --%>
<%--                                             </a> --%>
										</c:when>
									</c:choose>
								</c:when>
							</c:choose>
                        </td>
					</tr>


					<tr>
						<td colspan="3">

							<!-- list of studyplandetails -->
							<table class="tabledata2" id="TblData2_studyplandetails_compulsory">

                                <!-- prepare variables for include -->
                                <c:set var="studyPlanDetails" value="${form.studyPlanCardinalTimeUnit.studyPlanDetails}" />

                                <%@ include file="../../includes/studyPlanDetailsForStudyPlanCTU.jsp"%>

                                <spring:bind path="studyPlanCardinalTimeUnitForm.studyPlanCardinalTimeUnit.studyPlanDetails">
    								<tr>
    									<td colspan="4"><c:forEach var="error" items="${status.errorMessages}">
    											<span class="error">${error}</span>
    										</c:forEach>
                                        </td>
    								</tr>
                                </spring:bind>

							</table>
                            <script type="text/javascript">alternate('TblData2_studyplandetails_compulsory',true)</script>
                        </td>
					</tr>
				</c:when>
			</c:choose>

			<c:choose>
				<c:when test="${studyPlanCardinalTimeUnitForm.studyPlanCardinalTimeUnit.id != '' && studyPlanCardinalTimeUnitForm.studyPlanCardinalTimeUnit.id != '0'}">
<%--
					<tr>
						<td colspan="3"><hr /></td>
					</tr>

					<!--  ELECTIVE STUDY PLAN DETAILS -->

					<tr>
						<td class="header" colspan="3"><fmt:message key="jsp.general.electivestudyplandetails" /></td>
					</tr>

					<tr>
						<td class="label">&nbsp;</td>
						<td colspan="2" align="right"><c:choose>
								<c:when test="${editSubscriptionData}">
									<c:choose>
										<c:when test="${(studyGradeType.maxNumberOfSubjectsPerCardinalTimeUnit != '0' && studyPlanCardinalTimeUnitForm.totalNumberOfSubjects < studyGradeType.maxNumberOfSubjectsPerCardinalTimeUnit)
                                               || (studyPlanCardinalTimeUnitForm.totalNumberOfSubjects < iMaxSubjectsPerCardinalTimeUnit)}">
											<a class="button" href="<c:url value='/college/studyplandetail.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;from=student&amp;studyPlanId=${studyPlan.id}&amp;studentId=${student.studentId}&amp;studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&amp;rigidityTypeCode=3&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                <fmt:message key="jsp.href.add" />
                                            </a>
										</c:when>
									</c:choose>
								</c:when>
								<c:otherwise>
									<c:choose>
										<c:when test="${((studyGradeType.numberOfSubjectsPerCardinalTimeUnit != '0' && studyPlanCardinalTimeUnitForm.totalNumberOfSubjects < studyGradeType.numberOfSubjectsPerCardinalTimeUnit)
                                        || (studyPlanCardinalTimeUnitForm.totalNumberOfSubjects < iMaxSubjectsPerCardinalTimeUnit))
                                        && personId == opusUser.personId 
                                        && studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME
                                        }">
											<a class="button" href="<c:url value='/college/studyplandetail.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;from=student&amp;studyPlanId=${studyPlan.id}&amp;studentId=${student.studentId}&amp;studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&amp;rigidityTypeCode=3&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                <fmt:message key="jsp.href.add" />
                                            </a>
										</c:when>
									</c:choose>
								</c:otherwise>
							</c:choose>
                        </td>
					</tr>

					<tr>
						<td colspan="3">

								<!-- list of studyplandetails -->
							<table class="tabledata2" id="TblData2_studyplandetails_elective">
								<tr>
									<c:if test="${appUseOfSubjectBlocks == 'Y'}">
										<th><fmt:message key="jsp.general.subjectblock" /></th>
									</c:if>
									<th><fmt:message key="jsp.general.subject" /></th>
									<c:if test="${initParam.iMajorMinor == 'Y'}">
										<th><fmt:message key="jsp.general.importancetype" /></th>
									</c:if>
									<th><fmt:message key="jsp.general.studygradetype" /></th>
									<th>&nbsp;</th>
								</tr>

								<c:forEach var="electiveStudyPlanDetail" items="${studyPlanCardinalTimeUnitForm.studyPlanCardinalTimeUnit.studyPlanDetails}">

									<c:if test="${appUseOfSubjectBlocks == 'Y'}">
										<!-- elective subjectblock -->
										<c:forEach var="electiveSubjectBlock" items="${studyPlanCardinalTimeUnitForm.allElectiveSubjectBlocks}">
											<c:choose>
												<c:when test="${electiveStudyPlanDetail.subjectBlockId != 0 && electiveSubjectBlock.id == electiveStudyPlanDetail.subjectBlockId}">

													<c:forEach var="electiveSubjectBlockStudyGradeType" items="${studyPlanCardinalTimeUnitForm.allElectiveSubjectBlockStudyGradeTypes}">

														<c:choose>
															<c:when test="${(electiveStudyPlanDetail.subjectBlockId == electiveSubjectBlockStudyGradeType.subjectBlock.id)
                                        						&& (electiveStudyPlanDetail.studyGradeTypeId == electiveSubjectBlockStudyGradeType.studyGradeType.id)}">
																<c:set var="electiveSubjectBlockStudyGradeTypeSave" value="${electiveSubjectBlockStudyGradeType}" scope="page" />

																<c:forEach var="oneStudyGradeType" items="${studyPlanCardinalTimeUnitForm.allStudyGradeTypes}">
																	<c:choose>
																		<c:when test="${oneStudyGradeType.id == electiveStudyPlanDetail.studyGradeTypeId}">
																			<c:set var="electiveStudyGradeType" value="${oneStudyGradeType}" scope="page" />
																		</c:when>
																	</c:choose>
																</c:forEach>

																<tr>
																	<td>
                                                                        <c:choose>
																			<c:when test="${editSubscriptionData}">
																				<a href="<c:url value='/college/subjectblock.view?newForm=true&amp;tab=0&amp;panel=0&amp;from=student&amp;subjectBlockId=${electiveSubjectBlock.id}'/>">
																					<c:out value="${electiveSubjectBlock.subjectBlockDescription}"/>
                                                                                </a>
																			</c:when>
																			<c:otherwise>
																				<c:choose>
																					<c:when test="${showSubscriptionData || personId == opusUser.personId}">
                                                                                        <c:out value="${electiveSubjectBlock.subjectBlockDescription}"/>
                                                                                    </c:when>
																				</c:choose>
																			</c:otherwise>
																		</c:choose>
                                                                            <c:forEach var="academicYear" items="${studyPlanCardinalTimeUnitForm.allAcademicYears}">
																			<c:choose>
																				<c:when test="${academicYear.id == electiveSubjectBlock.currentAcademicYearId}">
            		                                                        		<c:out value="(${academicYear.description}"/>
            		                                                            </c:when>
																			</c:choose>
																		</c:forEach>
                                                                        <c:forEach var="studyTime" items="${allStudyTimes}">
																			<c:choose>
																				<c:when test="${studyTime.code == electiveSubjectBlock.studyTimeCode}">
                                                                                    <c:out value="- ${studyTime.description})"/>
                                                                                </c:when>
																			</c:choose>
																		</c:forEach>
                                                                    </td>
																	<td/>
																	<c:if test="${initParam.iMajorMinor == 'Y'}">
																		<td>
                                                                            <c:forEach var="importanceType" items="${allImportanceTypes}">
																				<c:choose>
																					<c:when test="${importanceType.code == electiveSubjectBlockStudyGradeTypeSave.importanceTypeCode}">
                                                                                        <c:out value="${importanceType.description}"/>
                                                                                    </c:when>
																				</c:choose>
																			</c:forEach>
                                                                        </td>
																	</c:if>

																	<td width="350"><c:forEach var="study" items="${studyPlanCardinalTimeUnitForm.allStudies}">
																			<c:choose>
																				<c:when test="${study.id == electiveStudyGradeType.studyId}">
        										                           			<c:out value="${study.studyDescription}"/>
        										                           		</c:when>
																			</c:choose>
																		</c:forEach>
                                                                        <c:forEach var="gradeType" items="${allGradeTypes}">
																			<c:choose>
																				<c:when test="${gradeType.code == electiveStudyGradeType.gradeTypeCode}">
        										                           			<c:out value="- ${gradeType.description}"/>
        										                           		</c:when>
																			</c:choose>
																		</c:forEach> <c:forEach var="academicYear" items="${studyPlanCardinalTimeUnitForm.allAcademicYears}">
																			<c:choose>
																				<c:when test="${academicYear.id == electiveStudyGradeType.currentAcademicYearId}">
                                                                                    <c:out value="(${academicYear.description}"/>
                                                                                </c:when>
																			</c:choose>
																		</c:forEach> <c:forEach var="studyTime" items="${allStudyTimes}">
																			<c:choose>
                                                                                <c:when test="${studyTime.code == electiveStudyGradeType.studyTimeCode}">
						                                                            <c:out value="- ${studyTime.description})"/>
                                                                                </c:when>
																			</c:choose>
																		</c:forEach>
                                                                    </td>

																	<!--  edit and delete button -->
																	<td class="buttonsCell"><c:choose>
																			<c:when test="${(editSubscriptionData || personId == opusUser.personId) 
                                                                              && ( studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT)}">

																				<a href="<c:url value='/college/studyplandetail_delete.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;from=student&amp;studyPlanDetailId=${electiveStudyPlanDetail.id}&amp;studentId=${student.studentId}&amp;studyPlanId=${studyPlan.id}&amp;studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"
																					onclick="return confirm('<fmt:message key="jsp.studyplandetail.delete.confirm" />')">
                                                                                    <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                                                </a>
																			</c:when>
																		</c:choose>
                                                                    </td>
																</tr>

															</c:when>
														</c:choose>
													</c:forEach>

												</c:when>
											</c:choose>
										</c:forEach>
									</c:if>

									<!-- elective subject -->
									<c:forEach var="electiveSubject"
										items="${studyPlanCardinalTimeUnitForm.allElectiveSubjects}">
										<c:choose>
											<c:when test="${electiveStudyPlanDetail.subjectId != 0 && electiveSubject.id == electiveStudyPlanDetail.subjectId}">

												<c:forEach var="electiveSubjectStudyGradeType" items="${studyPlanCardinalTimeUnitForm.allElectiveSubjectStudyGradeTypes}">
													<c:choose>
														<c:when test="${electiveStudyPlanDetail.subjectId == electiveSubjectStudyGradeType.subjectId
                                        						&& electiveStudyPlanDetail.studyGradeTypeId == electiveSubjectStudyGradeType.studyGradeTypeId}">
															<c:set var="electiveSubjectStudyGradeTypeSave" value="${electiveSubjectStudyGradeType}" scope="page" />

															<c:forEach var="oneStudyGradeType" items="${studyPlanCardinalTimeUnitForm.allStudyGradeTypes}">
																<c:choose>
																	<c:when test="${oneStudyGradeType.id == electiveStudyPlanDetail.studyGradeTypeId}">
																		<c:set var="electiveStudyGradeType" value="${oneStudyGradeType}" scope="page" />
																	</c:when>
																</c:choose>
															</c:forEach>
															<tr>
                                                                <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                                                                    <td/>
                                                                </c:if>
																<td>
                                                                    <c:choose>
																		<c:when test="${editSubscriptionData}">
																			<a href="<c:url value='/college/subject.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;from=student&amp;subjectId=${electiveSubject.id}'/>">
																				<c:out value="${electiveSubject.subjectDescription}"/>
                                                                            </a>
																		</c:when>
																		<c:otherwise>
																			<c:choose>
																				<c:when test="${showSubscriptionData || personId == opusUser.personId}">
                                                                                    <c:out value="${electiveSubject.subjectDescription}"/>
                                                                                </c:when>
																			</c:choose>
																		</c:otherwise>
																	</c:choose>
                                                                    <c:forEach var="academicYear" items="${studyPlanCardinalTimeUnitForm.allAcademicYears}">
																		<c:choose>
																			<c:when test="${academicYear.id == electiveSubject.currentAcademicYearId}">
	                                                        		            <c:out value="(${academicYear.description}"/>
	                                                                        </c:when>
																		</c:choose>
																	</c:forEach> <c:forEach var="studyTime" items="${allStudyTimes}">
																		<c:choose>
																			<c:when test="${studyTime.code == electiveSubject.studyTimeCode}">
                                                                                <c:out value="- ${studyTime.description})"/>
                                                                            </c:when>
																		</c:choose>
																	</c:forEach>
                                                                </td>
																<c:if test="${initParam.iMajorMinor == 'Y'}">
																	<td>
                                                                        <c:forEach var="importanceType" items="${allImportanceTypes}">
																			<c:choose>
																				<c:when test="${importanceType.code == electiveSubjectStudyGradeTypeSave.importanceTypeCode}">
                                                                                    <c:out value="${importanceType.description}"/>
                                                                                </c:when>
																			</c:choose>
																		</c:forEach>
                                                                    </td>
																</c:if>

																<td width="350">
                                                                    <c:forEach var="study" items="${studyPlanCardinalTimeUnitForm.allStudies}">
																		<c:choose>
																			<c:when test="${study.id == electiveStudyGradeType.studyId}">
											                           			<c:out value="${study.studyDescription}"/>
											                           		</c:when>
																		</c:choose>
																	</c:forEach>
                                                                    <c:forEach var="gradeType" items="${allGradeTypes}">
																		<c:choose>
																			<c:when test="${gradeType.code == electiveStudyGradeType.gradeTypeCode}">
											                           			<c:out value="- ${gradeType.description}"/>
											                           		</c:when>
																		</c:choose>
																	</c:forEach>
                                                                    <c:forEach var="academicYear" items="${studyPlanCardinalTimeUnitForm.allAcademicYears}">
																		<c:choose>
																			<c:when test="${academicYear.id == electiveStudyGradeType.currentAcademicYearId}">
								                           						<c:out value="(${academicYear.description}"/>
								                           					</c:when>
																		</c:choose>
																	</c:forEach>
                                                                    <c:forEach var="studyTime" items="${allStudyTimes}">
																		<c:choose>
																			<c:when test="${studyTime.code == electiveStudyGradeType.studyTimeCode}">
    								                                            <c:out value="- ${studyTime.description})"/>
    								                                        </c:when>
																		</c:choose>
																	</c:forEach>
                                                                </td>

																<!--  edit and delete button -->
																<td class="buttonsCell">
                                                                    <c:choose>
																		<c:when test="${(editSubscriptionData || personId == opusUser.personId) 
                                                                              && ( studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT)}">

																			<a href="<c:url value='/college/studyplandetail_delete.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;studyPlanDetailId=${electiveStudyPlanDetail.id}&amp;studyPlanId=${studyPlan.id}&amp;cardinalTimeUnitNumber=${studyPlanCardinalTimeUnit.cardinalTimeUnitNumber}&amp;studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"
																				onclick="return confirm('<fmt:message key="jsp.studyplandetail.delete.confirm" />')">
                                                                                <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                                            </a>
																		</c:when>
																	</c:choose>
                                                                </td>
															</tr>

														</c:when>
													</c:choose>
												</c:forEach>
											</c:when>
										</c:choose>
									</c:forEach>
								</c:forEach>
                                <spring:bind path="studyPlanCardinalTimeUnitForm.studyPlanCardinalTimeUnit.studyPlanDetails">
    								<c:if test="${status.errorMessages != null}">
    									<tr>
    										<td colspan="4">
                                                <c:forEach var="error" items="${status.errorMessages}">
    												<span class="error">${error}</span>
    											</c:forEach>
                                            </td>
    									</tr>
    								</c:if>
                                </spring:bind>
							</table>
							<script type="text/javascript">alternate('TblData2_studyplandetails_elective',true)</script>
                        </td>
					</tr> --%>

					<%-- MP todo
                                            <tr>
                                                <table class="tabledata2" >
                                                <tr><td colspan="3"><br /><hr /></td></tr>
                                            
                                                <tr>
                                                    <td colspan="2" class="header"><fmt:message key="jsp.general.rfc.header" /></td>
                                                    <td align="right">
< % --                                                     <c:choose> - - % >
< % --                                                     <c:when test="${authApproveSubscriptions}"> -- % >
                                                        <a href="#" class="button" onclick="showHideAll();return false;" style="margin-bottom : 4px;"/><fmt:message key="jsp.href.add" /> <fmt:message key="jsp.general.rfc" /></a>&nbsp;
< % --                                                     </c:when> -- % >
< % --                                                     </c:choose> -- % >
                                                    </td>    
                                                </tr>
                                                </table>
												</tr>
--%>
				</c:when>
			</c:choose>

	   </table>

   </form>

</div>
</div>
</div>
<script type="text/javascript">
    var sampleAccordion = new Spry.Widget.Accordion("Accordion1");
</script>
</div>
</div>
</div>
</div>

<script type="text/javascript">
var tp1 = new Spry.Widget.TabbedPanels("tp1");
tp1.showPanel(${navigationSettings.tab});
</script>
</div>

<%@ include file="../../footer.jsp"%>