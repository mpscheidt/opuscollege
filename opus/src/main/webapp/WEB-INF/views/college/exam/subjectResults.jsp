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

<c:set var="screentitlekey">jsp.general.subjectresults</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

<%@ include file="../../menu.jsp"%>

<c:set var="form" value="${subjectResultsForm}" />

<c:set var="subject" value="${form.subject}" />
<c:set var="classgroupId" value="${form.classgroupId}" />
<c:set var="staffMember" value="${form.staffMember}" />
<c:set var="teachers" value="${form.teachers}" />
<c:set var="idToSubjectTeacherMap" value="${form.idToSubjectTeacherMap}" />
<c:set var="brsPassing" value="${form.brsPassing}" />
<c:set var="endGradesPerGradeType" value="${form.endGradesPerGradeType}" />
<c:set var="minimumMarkValue" value="${form.minimumMarkValue}" />
<c:set var="maximumMarkValue" value="${form.maximumMarkValue}" />
<c:set var="dateNow" value="${form.dateNow}" />
<c:set var="subjectResultFormatter" value="${form.subjectResultFormatter}" />
<c:set var="assessmentStructurePrivilege" value="${form.assessmentStructurePrivilege}" />

<c:set var="tab" value="${form.navigationSettings.tab}" />
<c:set var="panel" value="${form.navigationSettings.panel}" />
<c:set var="currentPageNumber" value="${form.navigationSettings.currentPageNumber}" />


<%-- AUTHORIZATIONS --%>

<%-- check if logged in user is in subject teachers list, ie. one of the assigned teachers --%>
<c:set var="possibleTeacher" value="${not empty idToSubjectTeacherMap[staffMember.staffMemberId]}" />


<%-- BEGIN: create/edit subjectResults --%>

<%-- Has general privileges to alter any result within the study plan? --%>
<c:set var="createSubjectResults" value="${false}"/>
<sec:authorize access="hasAnyRole('CREATE_SUBJECTS_RESULTS')">
    <c:set var="createSubjectResults" value="${true}"/>
</sec:authorize>

<c:set var="editSubjectResults" value="${false}"/>
<sec:authorize access="hasAnyRole('UPDATE_SUBJECTS_RESULTS')">
	<c:set var="editSubjectResults" value="${true}"/>
</sec:authorize>


<%-- messages --%>
<c:set var="strMinimumGrade"><fmt:message key="jsp.general.minimummark" /></c:set>
<c:set var="strMaximumGrade"><fmt:message key="jsp.general.maximummark" /></c:set>
<c:set var="strHigherThanGivenGrade"><fmt:message key="jsp.validity.string.higherthangivengrade" /></c:set>
<c:set var="strLowerThanGivenGrade"><fmt:message key="jsp.validity.string.lowerthangivengrade" /></c:set>
<c:set var="strConflictingScales"><fmt:message key="jsp.validity.string.conflictingscales" /></c:set>


<div id="tabcontent">

<fieldset>
	<legend>
        <a href="<c:url value='/college/subjectsresults.view?currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.menu.resultssubjects" /></a>&nbsp;&gt;
		<c:choose>
			<c:when test="${subject.subjectDescription != null && subject.subjectDescription != ''}" >
				<c:out value="${fn:substring(subject.subjectDescription,0,initParam.iTitleLength)}"/>
			</c:when>
			<c:otherwise>
				<fmt:message key="jsp.href.new" />
			</c:otherwise>
		</c:choose>
		&nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.subjectresults" /> 
	</legend>
    <br />
    
   

    <!-- SUBJECT INFORMATION -->
    <table>                                                            
     <!-- CODE -->
        <tr>
           <td class="label"><fmt:message key="jsp.general.code" /></td>
           
           
            <td>
                <c:out value="${subject.subjectCode}"/>
            </td>
            <td rowspan="7" align="center" width="100" ></td>
            <td rowspan="7" align="left" width="200" class="label"> 
                <fmt:message key="jsp.general.structure" />

                <fmt:message var="pdfreport" key="jsp.button.pdfreport" />
                <fmt:message var="xlsreport" key="jsp.button.xlsreport" />
                <table>
                    <tr>
                    <td>
                    &nbsp;&nbsp;> <c:out value="${subject.subjectDescription}"/>
                    <c:if test="${assessmentStructurePrivilege.subjectAccess}">
                        <td>
                        <a href="<c:url value='/college/subjectresults/subjectResults/pdf'/>" target="_blank"><img src="<c:url value='/images/pdf-16.png' />" alt="${pdfreport}" title="${pdfreport}" /></a>
                        </td>
                        <td>
                        <a href="<c:url value='/college/subjectresults/subjectResults/xls'/>" target="_blank"><img src="<c:url value='/images/xls-16.png' />" alt="${xlsreport}" title="${xlsreport}" /></a>
                        </td>
                    </c:if>
                    </td>
                    </tr>
    
                    <c:forEach var="examination" items="${subject.examinations}">
                        <tr>
                        <td>
                        &nbsp;&nbsp;&nbsp;&nbsp;><a href="<c:url value='/college/examinationresults.view'/>?<c:out value='newForm=true&tab=0&panel=0&examinationId=${examination.id}&classgroupId=${classgroupId}&currentPageNumber=${currentPageNumber}'/>">
                        <c:out value="${examination.examinationDescription}"/>
                        </a>
                        <c:if test="${assessmentStructurePrivilege.examinationAccess[examination.id]}">
                            <td>
                            <a href="<c:url value='/college/subjectresults/examinationResults/${examination.id}/pdf'/>" target="_blank"><img src="<c:url value='/images/pdf-16.png' />" alt="${pdfreport}" title="${pdfreport}" /></a>
                            </td>
                            <td>
                            <a href="<c:url value='/college/subjectresults/examinationResults/${examination.id}/xls'/>" target="_blank"><img src="<c:url value='/images/xls-16.png' />" alt="${xlsreport}" title="${xlsreport}" /></a>
                            </td>
                        </c:if>
                        </td>
                        </tr>

                        <c:forEach var="test" items="${examination.tests}">
                            <tr>
                            <td>
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;> <a href="<c:url value='/college/testresults.view'/>?<c:out value='newForm=true&tab=0&panel=0&studyGradeTypeId=${studyGradeTypeIdForSubject}&subjectId=${subject.id}&examinationId=${examination.id}&testId=${test.id}&chosenAcademicYearId=${subject.currentAcademicYearId}&chosenCardinalTimeUnitNumber=${cardinalTimeUnitNumber}&classgroupId=${classgroupId}&currentPageNumber=${currentPageNumber}'/>">
                                <c:out value="${test.testDescription}"/>
                            </a>
                            <c:if test="${assessmentStructurePrivilege.testAccess[test.id]}">
                                <td>
                                <a href="<c:url value='/college/subjectresults/testResults/${test.id}/pdf'/>" target="_blank"><img src="<c:url value='/images/pdf-16.png' />" alt="${pdfreport}" title="${pdfreport}" /></a>
                                </td>
                                <td>
                                <a href="<c:url value='/college/subjectresults/testResults/${test.id}/xls'/>" target="_blank"><img src="<c:url value='/images/xls-16.png' />" alt="${xlsreport}" title="${xlsreport}" /></a>
                                </td>
                            </c:if>
                            </td>
                            </tr>
                        </c:forEach>
                        <br/>
                    </c:forEach>
                </table>
            </td>
        </tr>
        <!-- DESCRIPTION -->
        <tr>    
           <td class="label"><fmt:message key="jsp.general.name" /> </td>
            <td>
           <a href="<c:url value='/college/subject.view?newForm=true&amp;tab=${tab}&amp;panel=${panel}&amp;from=subjects&amp;subjectId=${subject.id}&amp;currentPageNumber=${currentPageNumber}'/>">
            <c:out value="${subject.subjectDescription}"/>
           </a>
           </td>
          
        </tr>

        <tr>
            <td class="label"><fmt:message key="jsp.general.academicyear" /></td>
            <td>
                <c:out value="${subject.academicYear.description}" />
            </td>
        </tr>

        <!-- CONTENT DESCRIPTION
        <tr>
           <td class="label"><fmt:message key="jsp.general.content" /></td>
           <td>
           ${subject.subjectContentDescription}
           </td> 
        </tr> -->
        
        <!-- TARGET GROUPS -->
        <%--
        in the future there will be a choice in target groups,
        but in this phase a default value is set
        <tr>
           <td class="label"><fmt:message key="jsp.general.targetgroup" /></td>
           <td>
                   <c:forEach var="targetGroup" items="${allTargetGroups}">
                       <c:choose>
                           <c:when test="${targetGroup.code == subject.targetGroupCode}">
                               <option value="${targetGroup.code}" selected="selected">${targetGroup.description}</option>
                           </c:when>
                       </c:choose>
                   </c:forEach>
           </td> 
        </tr> 
        --%>
        
        <!-- MAXIMUM NUMBER OF PARTICIPANTS 
        <tr>
           <td class="label"><fmt:message key="jsp.subject.maximumparticipants" /></td>
           <td>
           ${subject.maximumParticipants}
           </td>
        </tr> -->
        
        <!-- CREDIT AMOUNT -->
        <tr>
           <td class="label"><fmt:message key="jsp.subject.credit" /></td>
            <td>
           <c:out value="${subject.creditAmount}"/>
           </td>
        </tr>

        <!-- HOURS TO INVEST
        <tr>
           <td class="label"><fmt:message key="jsp.subject.hourstoinvest" /></td>
            <td>
           ${subject.hoursToInvest}
           </td>
        </tr>
        -->

        <!-- EXAMTYPE
        <tr>
           <td class="label"><fmt:message key="jsp.subject.examtype" /></td>
           <td>
                   <c:forEach var="examType" items="${allExamTypes}">
                       <c:choose>
                           <c:when test="${examType.code == subject.examTypeCode}">
                               ${examType.description}
                           </c:when>
                       </c:choose>
                   </c:forEach>
            </td>  
        </tr>-->

        <!-- BRs APPLYING TO SUBJECT
        <tr>
           <td class="label"><fmt:message key="jsp.general.brsapplying" /></td>
            <td>
           ${subject.brsApplyingToSubject}
           </td> 
        </tr> -->

        <!-- BRs PASSING SUBJECT -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.brspassing" /></td>
            <td>
                <c:out value="${brsPassing}"/>
                &nbsp;
                (<fmt:message key="jsp.general.minimummark" />: <c:out value="${minimumMarkValue}"/>,
                <fmt:message key="jsp.general.maximummark" />: <c:out value="${maximumMarkValue}"/>)
            </td>
        </tr>
        
        <!--  ACTIVE -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.active" /></td>
            <td>
                <fmt:message key="${stringToYesNoMap[subject.active]}"/>
            </td>
            
        </tr>

        <!--  TEACHERS -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.teachers" /></td>
            <td>
                <c:forEach var="teacher" items="${teachers}">
                    <c:out value="${teacher.surnameFull}"/>,&nbsp;<c:out value="${teacher.firstnamesFull}"/><br />
                </c:forEach>
            </td>
        </tr>
    </table>
</fieldset>

<div id="tp1" class="TabbedPanel">

<div class="TabbedPanelsContentGroup">
<div class="TabbedPanelsContent">
<div class="Accordion" id="Accordion0" tabindex="0">
<div class="AccordionPanel">
<div class="AccordionPanelTab"><fmt:message key="jsp.general.subject" />&nbsp;<fmt:message key="jsp.general.results" /></div>
<div class="AccordionPanelContent">

<%-- separate form with augmented URL in order to differntiate from a ordinary post of the results form --%>
<form:form modelAttribute="subjectResultsForm" action="${pageContext.request.contextPath}/college/subjectresults/classgroup" method="post" >
    <table>
        <tr>
            <td>
                <fmt:message key="general.classgroup" />
            </td>
            <td>
                 <form:select path="classgroupId" onchange="this.form.submit();">
                    <form:option value=""><fmt:message key="jsp.selectbox.choose"/></form:option>
                    <form:options items="${form.allClassgroups}" itemLabel="description" itemValue="id"/>
                </form:select>
            </td>
        </tr>
    </table>
</form:form>

    <form:errors path="subjectResultsForm.*" cssClass="errorwide" element="p"/>

    <c:url var="post_url" value='/college/subjectresults'/>
    <form:form modelAttribute="subjectResultsForm" method="post" action="${post_url}" >
    
        <%-- invisible default button before any other submit button --%>
        <input type="submit" class="defaultsink" name="submitsubjectresults" value="Save" />

        <table class="tabledata2" id="TblData2_subjectresults">
    
            <tr>
                <th><fmt:message key="jsp.general.code" /></th>
                <th style="width: 200px"><fmt:message key="jsp.menu.student" /><%--<br />(<fmt:message key="jsp.general.studyplan" />) --%></th>
                <th><fmt:message key="jsp.general.resultdate" /><br />(yyyy-MM-dd)</th>
                <th><fmt:message key="jsp.general.mark" /></th>
                <c:if test="${fn:length(subject.examinations) > 0}">
                    <%-- "Generate" column only makes sense if there are lower level results --%>
                    <th></th>
                </c:if>
				<c:if test="${endGradesPerGradeType}">
                    <th><fmt:message key="jsp.general.endgrade.comment" /></th>
				</c:if>
                <th><fmt:message key="jsp.general.teacher" /></th>
                <c:if test="${fn:length(subject.examinations) > 0}">
                    <%-- "Examination results" column only makes sense if there are lower level results --%>
                    <th>
                        <fmt:message key="jsp.general.examinationresults" />
                    </th>
                </c:if>
                <th></th>
            </tr>

            <c:set var="useGenerateAllButton" value="${false}" />

			<c:forEach var="line" items="${form.allLines}" varStatus="lineStatus">
			    <tr>
			        <!-- STUDENT -->
			        <td>${line.studentCode }</td>
			        <td>
<%--                         <c:choose> --%>
<%-- 			             <c:when test="${opususer.personid == student.personid}"> --%>
			             <a href="<c:url value='/college/student/personal.view?newForm=true&amp;from=students&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;studentId=${line.studentId}&amp;searchValue=${navigationSettings.searchValue}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
			                 <c:out value="${line.firstnamesFull} ${line.surnameFull}"/>
                         </a>
<%-- 			             </c:when> --%>
<%--                                 <c:otherwise> --%>
<%--                                     <c:out value="${line.firstnamesFull} ${line.surnameFull}"/> --%>
<%--                                 </c:otherwise> --%>
<%--                         </c:choose> --%>
                   </td>

                    <%-- If there is already a subject result, we have a subjectResultId, otherwise use 0 --%>
                    <c:set var="subjectResultId" value="${line.subjectResult.id}" />
                    <c:set var="hasSubjectResult" value="${subjectResultId != 0}" />
                    <c:set var="authorizationKey" value="${line.subjectResult.studyPlanDetailId}-${line.subjectResult.subjectId}" />
                    <c:set var="authorization" value="${form.subjectResultAuthorizationMap[authorizationKey]}" scope="page" />
                    <c:set var="authCreate" value="${authorization.create}" />
                    <c:set var="authCreateOrUpdate" value="${authorization.createOrUpdate}" />
                    <c:set var="authShow" value="${authorization.read}" />
                    <c:set var="authDelete" value="${authorization.delete}" />
                    <c:set var="authAny" value="${authShow || authCreateOrUpdate || authDelete}" />

                    <!-- SUBJECT RESULT DATE -->
                    <%-- Only editable for new resuls, otherwise read-only --%>
                    <td>
                        <c:set var="subjectResultDatePath" value="allLines[${lineStatus.index}].subjectResult.subjectResultDate" />
                        <c:set var="subjectResultDateId"   value="allLines${lineStatus.index}.subjectResult.subjectResultDate" />
                        <form:hidden path="${subjectResultDatePath}"/>
                        <c:choose>
                            <c:when test="${authCreate}" >
                                <table>
                                    <tr>
                                        <%-- TODO also rename the ids in the following lines, or use jquery-Date-Element --%>
                                        <td><input type="text" id="${lineStatus.index}_subjectresult_year" name="${lineStatus.index}_subjectresult_year" size="4" maxlength="4" value="<c:out value="${fn:substring(dateNow,0,4)}" />" onchange="updateFullDate('${subjectResultDateId}','year',document.getElementById('${lineStatus.index}_subjectresult_year').value);" /></td>
                                        <td><input type="text" id="${lineStatus.index}_subjectresult_month" name="${lineStatus.index}_subjectresult_month" size="2" maxlength="2" value="<c:out value="${fn:substring(dateNow,5,7)}" />" onchange="updateFullDate('${subjectResultDateId}','month',document.getElementById('${lineStatus.index}_subjectresult_month').value);" /></td>
                                        <td><input type="text" id="${lineStatus.index}_subjectresult_day" name="${lineStatus.index}_subjectresult_day" size="2" maxlength="2" value="<c:out value="${fn:substring(dateNow,8,10)}" />" onchange="updateFullDate('${subjectResultDateId}','day',document.getElementById('${lineStatus.index}_subjectresult_day').value);" /></td>
                                    </tr>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <fmt:formatDate pattern="yyyy-MM-dd" value="${line.subjectResult.subjectResultDate}" />
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <!-- MARK / GRADE -->
                    <%-- Display failed indicator only if privilege to read/edit result --%>
                    <c:set var="markClass" value="" />
                    <c:if test="${authAny && fn:trim(line.subjectResult.passed) == 'N'}">
                        <c:set var="markClass" value='class="required"' />  <%-- TODO make dedicated CSS class, don't reuse the required class, which has different meaning --%>
                    </c:if>
                    <td ${markClass}>
                        <c:if test="${line.exempted}">
                            <fmt:message key="general.exempted"/>
                        </c:if>
                        <%-- for information purposes indicate why mark is not editable --%>
                        <c:if test="${line.studyPlanStatusCode ne STUDYPLAN_STATUS_APPROVED_ADMISSION}">
                            <c:out value="${form.codeToStudyPlanStatusMap[line.studyPlanStatusCode].description}"/>
                        </c:if>
                        <c:choose>
                            <c:when test="${authCreateOrUpdate}">
                                <form:input path="allLines[${lineStatus.index}].subjectResult.mark" size="3" maxlength="6"  autocomplete="off"/>
                                <form:errors path="allLines[${lineStatus.index}].subjectResult.mark" cssClass="errornarrow"/>
                                <c:if test="${hasSubjectResult}">
                                    <c:out value="${subjectResultFormatter[line.subjectResultInDB]}"/>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${authShow}">
                                    <c:out value="${subjectResultFormatter[line.subjectResult]}"/>
                                </c:if>
                                <!-- this code is used to show message when subjectresultcommentid=1 -->
                                <c:if test="${authShow}">
			                		<fmt:message key="${form.idToSubjectResultCommentMap[line.subjectResult.subjectResultCommentId].commentKey}"/>
                       			 </c:if>
                            </c:otherwise>
                        </c:choose>
                        
                    </td>

                    <!-- GENERATE BUTTON -->
                    <c:if test="${fn:length(subject.examinations) > 0}">
                        <td style="vertical-align: middle; text-align:center;" >
                            <c:choose>
                                <%-- Note MP: Change in behavior: only allow generation if no result yet exists (if result exists no need for re-generation in this screen).
                                     Otherwise unclear how to behave in case of generate all (really re-generate all existing results??)
                                     and in case a problem occurs during generation (up to now mark was set to "-" but not stored -> confusing) --%>
                                <c:when test="${authCreate && line.examinationResultsFound}"> <%-- change to *All*ExaminationResultsFound --%>
                                    <a class="button" href="<c:url value='/college/subjectresults.view?generate=${lineStatus.index}&amp;currentPageNumber=${currentPageNumber}'/>">
                                        <fmt:message key="jsp.button.generate" />
                                    </a>
                                    <c:set var="useGenerateAllButton" value="${true}" />
                                </c:when>
                            </c:choose>
                        </td>
                    </c:if>

                    <!-- ENDGRADECOMMENT -->
                    <c:if test="${endGradesPerGradeType}">
	                    <td>
	                        <%-- This is when user enters deliberately a value of 0 to indicate failure and be able to select a fail mark
	                             This only applies when end grades are used. --%>
	                        <c:if test="${hasSubjectResult}">
	                            <c:choose>
	                                <c:when test="${authCreateOrUpdate &&
	                                    (line.subjectResult.mark == '0.0'
	                                    || line.subjectResult.mark == '0')
	                                   }">
	                                    <form:select path="allLines[${lineStatus.index}].subjectResult.endGradeComment">
	                                        <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
	                                        <c:forEach var="failGrade" items="${form.endGradeTypeCodeToFailGradesMap[line.subjectResult.endGradeTypeCode]}">
	                                            <form:option value="${failGrade.code}"><c:out value="${failGrade.comment}"/></form:option>
	                                        </c:forEach>
	                                    </form:select>
	                                </c:when>
	                                <c:otherwise>
	                                    <c:if test="${authShow}">
	                                        <c:out value="${line.subjectResult.endGradeObject.comment}"/>    <%-- TODO deal with the AR case (see SubjectResultLineBuilder: setting endGradeObject) --%>
	                                    </c:if>
	                               </c:otherwise>
	                           </c:choose>
	                        </c:if>
	                    </td>
                    </c:if>

                    <!-- SUBJECT TEACHERS -->
                    <td>
                        <c:choose>
                            <c:when test="${authCreateOrUpdate}">
                                <form:select cssClass="auto compressoneoption" path="allLines[${lineStatus.index}].subjectResult.staffMemberId">
                                    <option class="auto" value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                    <c:forEach var="teacher" items="${teachers}">
                                        <c:if test="${not authorization.staffMemberLimitedToSelf or teacher.staffMemberId eq staffMember.staffMemberId}">
                                            <form:option cssClass="auto" value="${teacher.staffMemberId}"><c:out value="${teacher.firstnamesFull} ${teacher.surnameFull}"/></form:option>
                                        </c:if>
                                    </c:forEach>
                                </form:select>
                                <form:errors path="allLines[${lineStatus.index}].subjectResult.staffMemberId" cssClass="errornarrow"/>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${authShow}">
                                    <c:set var="teacher" value="${idToSubjectTeacherMap[line.subjectResult.staffMemberId]}" />
<%--                                     <input type="hidden" name="${staffMemberIdName}" id="${staffMemberIdName}" value="<c:out value="${teacher.staffMemberId}" />" /> --%>
                                    <c:out value="${teacher.firstnamesFull} ${teacher.surnameFull}"/>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <!-- EXAMINATION RESULTS -->
                    <c:if test="${fn:length(subject.examinations) > 0}">
                        <td>
                            <c:if test="${line.examinationResultsFound}">
                                <a class="infobox" href="#INFO">
                                    <fmt:message key="jsp.general.examinationresults" />
                                    <span>
                                        <b>
                                            <fmt:message key="jsp.general.examinationresultdate" />:
                                            <fmt:message key="jsp.general.description" /> (<fmt:message key="jsp.general.attemptnr" />):
                                            <fmt:message key="jsp.general.mark" /> (<fmt:message key="jsp.general.passed" />)
                                        </b>
                                        <%-- NB: line.examinationResultsString is not to be put inside a c:out element, because it contains html tags --%>
                                        ${line.examinationResultsString}
                                    </span>
                                </a>
                            </c:if>
                        </td>
                    </c:if>

                    <%-- DELETE BUTTON --%>
                    <%-- delete button of course only exists if a result exists --%>
                    <td>
                        <c:if test="${hasSubjectResult and authDelete}">
                            <a onclick="return confirm('<fmt:message key="jsp.subjectresult.delete.confirm" />')" href="<c:url value='/college/subjectresults/delete/${lineStatus.index}'/>">
                            <img src="<c:url value='/images/delete.gif'/>" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                        </c:if>
                    </td>

			    </tr>
			</c:forEach>

            <c:if test="${editSubjectResults || possibleTeacher}">

                <tr>
                    <td colspan="2" class="label">
                        <fmt:message key="jsp.general.mark.adjustment" /> +/-
                    </td>
                    <td align="right">
                        <form:input path="adjustmentMark" size="3" maxlength="6" />
                        <form:errors path="adjustmentMark" cssClass="errornarrow"/>
                    </td>
                    <td align="right">
                       <input type="submit" name="adjustAll" value="<fmt:message key='jsp.general.adjustall' />" />
                    </td>
                       
                    <c:if test="${fn:length(subject.examinations) > 0}">
                        <td align="right">
                            <c:if test="${useGenerateAllButton}">
                                <input type="submit" name="generateAll" ${generateAllDisabled} value="<fmt:message key='jsp.button.generate.all' />" />
                            </c:if>
                        </td>
                    </c:if>
                    <td>&nbsp;</td>
                    <td align="right">
                        <input type="submit" name="submitsubjectresults" value="<fmt:message key="jsp.button.submit" />" />
                    </td>
                </tr>
            </c:if>

        </table>
        <script type="text/javascript">alternate('TblData2_subjectresults',true)</script>
    </form:form>
</div>
</div>
</div>
<script type="text/javascript">
    var Accordion0 = new Spry.Widget.Accordion("Accordion0",
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
    //tp1.showPanel(<%=request.getParameter("tab")%>);
    tp1.showPanel(0);
</script>
</div>

<%@ include file="../../footer.jsp"%>

 
