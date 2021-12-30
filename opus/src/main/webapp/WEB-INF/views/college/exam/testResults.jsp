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

<c:set var="form" value="${testResultsForm}" />

<c:set var="test" value="${testResultsForm.test}" />
<c:set var="examination" value="${testResultsForm.examination}" />
<c:set var="subject" value="${testResultsForm.subject}" />
<c:set var="classgroupId" value="${form.classgroupId}" />
<c:set var="staffMember" value="${testResultsForm.staffMember}" />
<c:set var="teachers" value="${testResultsForm.teachers}" />
<c:set var="idToTestTeacherMap" value="${testResultsForm.idToTestTeacherMap}" />
<c:set var="assessmentStructurePrivilege" value="${examinationResultsForm.assessmentStructurePrivilege}" />

<c:set var="tab" value="${testResultsForm.navigationSettings.tab}" />
<c:set var="panel" value="${testResultsForm.navigationSettings.panel}" />
<c:set var="currentPageNumber" value="${testResultsForm.navigationSettings.currentPageNumber}" />

<div id="tabcontent">

<fieldset>
	<legend>
        <a href="<c:url value='/college/subjectsresults.view'/>?<c:out value='currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
		<a href="<c:url value='/college/subjectresults.view'/>?<c:out value='newForm=true&subjectId=${subject.id}&currentPageNumber=${currentPageNumber}'/>">
            <c:out value="${fn:substring(subject.subjectDescription,0,initParam.iTitleLength)}"/>
		</a>
		&nbsp;&gt;&nbsp;
        <a href="<c:url value='/college/examinationresults.view'/>?<c:out value='newForm=true&examinationId=${examination.id}&currentPageNumber=${currentPageNumber}'/>">
            <c:out value="${fn:substring(examination.examinationDescription,0,initParam.iTitleLength)}"/>
        </a>
            &nbsp;>&nbsp;<c:out value="${fn:substring(test.testDescription,0,initParam.iTitleLength)}"/>
		&nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" /> / <fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.test" />&nbsp;<fmt:message key="jsp.general.results" /> 
	</legend>

    <br />

    <!-- TEST INFORMATION -->
    <table>                                                            

        <!-- TEST CODE -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.code" /></td>
            <td >
                <c:out value="${test.testCode}"/>
            </td>
            <td rowspan="8" align="center" width="100" >
            <td rowspan="8" align="left" width="250" class="label"> 
                <fmt:message key="jsp.general.structure" />

                <fmt:message var="pdfreport" key="jsp.button.pdfreport" />
                <fmt:message var="xlsreport" key="jsp.button.xlsreport" />
                <table>
                    <tr>
                        <td>
                            > <a href="<c:url value='/college/subjectresults.view'/>?<c:out value='newForm=true&subjectId=${subject.id}&classgroupId=${classgroupId}&currentPageNumber=${currentPageNumber}'/>">
                                   <c:out value="${fn:substring(subject.subjectDescription,0,initParam.iTitleLength)}"/>
        					</a>
                            <c:if test="${assessmentStructurePrivilege.subjectAccess}">
                                <td>
                                <a href="<c:url value='/college/examinationresults/subjectResults/pdf'/>" target="_blank"><img src="<c:url value='/images/pdf-16.png' />" alt="${pdfreport}" title="${pdfreport}" /></a>
                                </td>
                                <td>
                                <a href="<c:url value='/college/examinationresults/subjectResults/xls'/>" target="_blank"><img src="<c:url value='/images/xls-16.png' />" alt="${xlsreport}" title="${xlsreport}" /></a>
                                </td>
                            </c:if>
                        </td>
                    </tr>

                    <c:forEach var="examination" items="${subject.examinations}">
                        <tr>
                            <td>
                                &nbsp;&nbsp;>  <a href="<c:url value='/college/examinationresults.view'/>?<c:out value='newForm=true&examinationId=${examination.id}&classgroupId=${classgroupId}&currentPageNumber=${currentPageNumber}'/>">
                   		            <c:out value="${examination.examinationDescription}"/>
                                </a>
                                <c:if test="${assessmentStructurePrivilege.examinationAccess[examination.id]}">
                                    <td>
                                    <a href="<c:url value='/college/examinationresults/examinationResults/${examination.id}/pdf'/>" target="_blank"><img src="<c:url value='/images/pdf-16.png' />" alt="${pdfreport}" title="${pdfreport}" /></a>
                                    </td>
                                    <td>
                                    <a href="<c:url value='/college/examinationresults/examinationResults/${examination.id}/xls'/>" target="_blank"><img src="<c:url value='/images/xls-16.png' />" alt="${xlsreport}" title="${xlsreport}" /></a>
                                    </td>
                                </c:if>
                            </td>
                        </tr>

                        <c:forEach var="oneTest" items="${examination.tests}">
                            <tr>
                                <td>
                                    &nbsp;&nbsp;&nbsp;&nbsp;>
                                    <c:choose>
                                        <c:when test="${oneTest.id == test.id}">
                                            <c:out value="${oneTest.testDescription}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="<c:url value='/college/testresults.view'/>?<c:out value='newForm=true&testId=${oneTest.id}&classgroupId=${classgroupId}&currentPageNumber=${currentPageNumber}'/>">
                                             <c:out value="${oneTest.testDescription}"/>
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${assessmentStructurePrivilege.testAccess[oneTest.id]}">
                                        <td>
                                            <a href="<c:url value='/college/examinationresults/testResults/${oneTest.id}/pdf'/>" target="_blank"><img src="<c:url value='/images/pdf-16.png' />" alt="${pdfreport}" title="${pdfreport}" /></a>
                                        </td>
                                        <td>
                                            <a href="<c:url value='/college/examinationresults/testResults/${oneTest.id}/xls'/>" target="_blank"><img src="<c:url value='/images/xls-16.png' />" alt="${xlsreport}" title="${xlsreport}" /></a>
                                        </td>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:forEach>
                </table>
           	</td>
        </tr>

        <tr>
            <!-- TEST DESCRIPTION -->
            <td class="label"><fmt:message key="jsp.general.description" /></td>
            <td >
                <c:out value="${test.testDescription}"/>
            </td>
        </tr>
        
        <tr>
            <td class="label"><fmt:message key="jsp.general.academicyear" /></td>
            <td>
                <c:out value="${subject.academicYear.description}" />
            </td>
        </tr>

        <!-- EXAMINATION TYPE CODE -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.examinationtype" /></td>
            <td>
                <c:out value="${testResultsForm.codeToExaminationTypeMap[test.examinationTypeCode].description}"/>
            </td> 
        </tr>
        
        <tr>
        <!--  NUMBER OF ATTEMPTS -->
            <td class="label"><fmt:message key="jsp.general.numberofattempts" /></td>
            <td >
            <c:out value="${test.numberOfAttempts}"/>
            </td>
        </tr>

        <!-- WEIGHING FACTOR -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.weighingfactor" /></td>
            <td >
            <c:out value="${test.weighingFactor}"/>
          
            </tr><tr>

        <!-- BR's PASSING EXAMINATION -->
            <td class="label"><fmt:message key="jsp.general.brspassing" /></td>
            <td >
            <c:out value="${testResultsForm.brsPassing}"/>
            &nbsp;
            (<fmt:message key="jsp.general.minimummark" />: <c:out value="${testResultsForm.minimumMarkValue}"/>,
            <fmt:message key="jsp.general.maximummark" />: <c:out value="${testResultsForm.maximumMarkValue}"/>)
            </td>
        </tr>

        <!-- TEST DATE -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.testdate" /></td>
            <td>
                <fmt:formatDate value="${test.testDate}"/>
            </td> 
        </tr>

        <!-- ACTIVE -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.active" /></td>
            <td >
                <fmt:message key="${stringToYesNoMap[test.active]}"/>
            </td>
            </tr><tr>
            
            <!--  TEACHERS -->
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
<div class="AccordionPanelTab"><fmt:message key="jsp.general.test" />&nbsp;<fmt:message key="jsp.general.results" /></div>
<div class="AccordionPanelContent">

<%-- separate form with augmented URL in order to differntiate from a ordinary post of the results form --%>
<form:form modelAttribute="testResultsForm" action="${pageContext.request.contextPath}/college/testresults/classgroup" method="post" >
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

<form:errors path="testResultsForm.*" cssClass="errorwide" element="p"/>

<form:form modelAttribute="testResultsForm" method="post" >
<%--     <input type="hidden" id="submitter" name="submitter" value="" /> --%>

    <%-- invisible default button before any other submit button --%>
    <input type="submit" class="defaultsink" name="submittestresults" value="Save" />
    
    <table class="tabledata2" id="TblData2_testresults">

        <!-- TEST RESULTS -->

        <tr>
            <th><fmt:message key="jsp.general.code" /></th>
            <th ><fmt:message key="jsp.menu.student" /></th>
            <th ><fmt:message key="jsp.general.attemptnr" /></th>
            <th ><fmt:message key="jsp.general.resultdate" /></th>
            <th ><fmt:message key="jsp.general.teacher" /></th>
            <th ><fmt:message key="jsp.general.mark" /></th>
            <th><fmt:message key="jsp.general.comment" /></th>
            <th >&nbsp;</th>
        </tr>

        <c:set var="useDeleteAllButton" value="${false}" />

        <c:forEach var="line" items="${testResultsForm.allLines}" varStatus="lineStatus">

            <%-- make one line for each attempt already made + 1 for the new attempt -> already created by resultLineBuilder --%>
            <c:forEach var="i" begin="0" end="${line.nrOfResults - 1}">

                <c:set var="attemptNr" value="${i + 1}" scope="page" />

                <c:set var="testResult" value="${line.results[i]}" scope="page" />
                <c:set var="testResultId" value="${testResult.id}" />
                <c:set var="hasTestResult" value="${testResultId != 0}" />

                <c:set var="authorizationKey" value="${line.results[0].studyPlanDetailId}-${line.results[0].testId}-${attemptNr}" />
                <c:set var="authorization" value="${testResultsForm.testResultAuthorizationMap[authorizationKey]}" scope="page" />
                <c:set var="authCreate" value="${authorization.create}" />
                <c:set var="authUpdate" value="${authorization.update}" />
                <c:set var="authCreateOrUpdate" value="${authorization.createOrUpdate}" />
                <c:set var="authShow" value="${authorization.read}" />
                <c:set var="authDelete" value="${authorization.delete}" />
                <c:set var="authAny" value="${authShow || authCreateOrUpdate || authDelete}" />

                <tr>
                    <td>
                        <c:out value="${line.studentCode}"></c:out>
                    </td>

                    <!-- STUDENT -->
                    <td>
		               <a href="<c:url value='/college/student/personal.view?newForm=true&amp;from=students&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;studentId=${line.studentId}&amp;searchValue=${navigationSettings.searchValue}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
		                 <c:out value="${line.firstnamesFull} ${line.surnameFull}"/></a>
                    </td>

                    <!-- ATTEMPT NR -->
                    <td>
                        <c:out value="${testResult.attemptNr}"/>
                    </td>

                    <!-- TEST RESULT DATE -->
                    <td>
                        <c:set var="testResultDatePath" value="allLines[${lineStatus.index}].results[${i}].testResultDate" />
                        <c:set var="testResultDateId"   value="allLines${lineStatus.index}.results${i}.testResultDate" />
                        <fmt:formatDate var="resultDate" pattern="yyyy-MM-dd" value='${testResult.testResultDate}' />
                        <form:hidden path="${testResultDatePath}"/>
                        <c:choose>
                            <c:when test="${authCreate}">
                                <table>
                                    <tr>
                                        <td><input type="text" id="${lineStatus.index}_${i}_testresult_year" name="${lineStatus.index}_${i}_testresult_year" size="4" maxlength="4" value="<c:out value="${fn:substring(resultDate,0,4)}" />" onchange="updateFullDate('${testResultDateId}','year',document.getElementById('${lineStatus.index}_${i}_testresult_year').value);" /></td>
                                        <td><input type="text" id="${lineStatus.index}_${i}_testresult_month" name="${lineStatus.index}_${i}_testresult_month" size="2" maxlength="2" value="<c:out value="${fn:substring(resultDate,5,7)}" />" onchange="updateFullDate('${testResultDateId}','month',document.getElementById('${lineStatus.index}_${i}_testresult_month').value);" /></td>
                                        <td><input type="text" id="${lineStatus.index}_${i}_testresult_day" name="${lineStatus.index}_${i}_testresult_day" size="2" maxlength="2" value="<c:out value="${fn:substring(resultDate,8,10)}" />" onchange="updateFullDate('${testResultDateId}','day',document.getElementById('${lineStatus.index}_${i}_testresult_day').value);"  /></td>
                                    </tr>
                                    <tr><td/></tr> <%-- have even number of tr tags in inner table for alternate script to work correctly --%>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <fmt:formatDate value='${testResult.testResultDate}' />
                            </c:otherwise>
                        </c:choose>
                    </td>
<%--                         <c:choose> --%>
<%--                             <c:when test="${(editTestResults || teacherHasAccess)}">   --%>
<%--                                 <c:choose> --%>
<%--                                     <c:when test="${not varStatus.last}"> --%>
<!--                                         <td> -->
<%--                                             <input type="hidden" id="${idPrefix}testResultDate" name="${idPrefix}testResultDate" value="<fmt:formatDate pattern='yyyy-MM-dd' value='${testResult.testResultDate}' />" /> --%>
<%--                                             <fmt:formatDate value='${testResult.testResultDate}' /> --%>
<!--                                         </td> -->
<%--                                     </c:when> --%>
<%--                                     <c:otherwise> --%>
<!--                                         <td> -->
<%--                                             <input type="hidden" id="${idPrefix}testResultDate" name="${idPrefix}testResultDate" value="${testResult.testResultDate}" /> --%>
<!--                                             <table> -->
<!--                                                 <tr> -->
<%--                                                   <td><input type="text" id="${idPrefix}testresult_year" name="${idPrefix}testresult_year" size="4" maxlength="4" value="<c:out value="${fn:substring(testResult.testResultDate,0,4)}" />" onchange="updateFullDate('${idPrefix}testResultdate','year',document.getElementById('${idPrefix}testresult_year').value);" /></td> --%>
<%--                                                   <td><input type="text" id="${idPrefix}testresult_month" name="${idPrefix}testresult_month" size="2" maxlength="2" value="<c:out value="${fn:substring(testResult.testResultDate,5,7)}" />" onchange="updateFullDate('${idPrefix}testResultdate','month',document.getElementById('${idPrefix}testresult_month').value);" /></td> --%>
<%--                                                   <td><input type="text" id="${idPrefix}testresult_day" name="${idPrefix}testresult_day" size="2" maxlength="2" value="<c:out value="${fn:substring(testResult.testResultDate,8,10)}" />" onchange="updateFullDate('${idPrefix}testResultdate','day',document.getElementById('${idPrefix}testresult_day').value);"  /></td> --%>
<!--                                                 </tr> -->
<%--                                                 <tr></tr> have even number of tr tags in inner table for alternate script to work correctly --%>
<!--                                             </table> -->
<!--                                         </td> -->
<%--                                     </c:otherwise> --%>
<%--                                 </c:choose> --%>
<%--                             </c:when> --%>
<%--                             <c:otherwise> --%>
<!--                                 <td> -->
<%--                                     <fmt:formatDate value='${testResult.testResultDate}' /> --%>
<!--                                 </td> -->
<%--                             </c:otherwise> --%>
<%--                         </c:choose> --%>

                    <!-- TEST TEACHERS -->
                    <td>
                        <c:choose>
                            <c:when test="${authCreateOrUpdate}">
                                <form:select cssClass="auto compressoneoption" path="allLines[${lineStatus.index}].results[${i}].staffMemberId">
                                    <option class="auto" value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                    <c:forEach var="teacher" items="${teachers}">
                                        <form:option cssClass="auto" value="${teacher.staffMemberId}"><c:out value="${teacher.firstnamesFull} ${teacher.surnameFull}"/></form:option>
                                    </c:forEach>
                                </form:select>
                                <form:errors path="allLines[${lineStatus.index}].results[${i}].staffMemberId" cssClass="error"/>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${authShow}">
                                    <c:set var="teacher" value="${idToTestTeacherMap[testResult.staffMemberId]}" />
                                    <c:out value="${teacher.firstnamesFull} ${teacher.surnameFull}"/>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
<%--                     <c:choose> --%>
<%--                          <c:when test="${editTestResults}">       --%>
<%--                             <select class="compressoneoption" name="${idPrefix}staffMemberId" id="${idPrefix}staffMemberId"> --%>
<%--                             <option value="0"><fmt:message key="jsp.selectbox.choose" /></option> --%>
<%--                             <c:forEach var="teacher" items="${teachers}"> --%>
<%--                                 <c:choose> --%>
<%--                                     <c:when test="${teacher.staffMemberId == testResult.staffMemberId}"> --%>
<%--                                         <option value="${teacher.staffMemberId}" selected="selected"><c:out value="${teacher.firstnamesFull} ${teacher.surnameFull}"/></option>  --%>
<%--                                     </c:when> --%>
<%--                                     <c:otherwise> --%>
<%--                                         <option value="${teacher.staffMemberId}"><c:out value="${teacher.firstnamesFull} ${teacher.surnameFull}"/></option>  --%>
<%--                                     </c:otherwise> --%>
<%--                                 </c:choose> --%>
<%--                             </c:forEach> --%>
<!--                             </select> -->
<%--                         </c:when> --%>
<%--                         no edit rights --%>
<%--                         <c:otherwise> --%>
<%--                             <c:choose> --%>
<%--                                 <c:when test="${teacherHasAccess}"> --%>
<%--                                     <c:set var="showOtherName" value="${false}"/> --%>
<%--                                     <c:forEach var="teacher" items="${teachers}"> --%>
<%--                                         <c:choose> --%>
<%--                                             <c:when test="${teacher.staffMemberId==testResult.staffMemberId}"> --%>
<%--                                                 <input type="hidden" name="${idPrefix}staffMemberId" id="${idPrefix}staffMemberId" value="<c:out value="${teacher.staffMemberId}" />" /> --%>
<%--                                                 <c:set var="showOtherName" value="${true}"/> --%>
<%--                                                 <c:out value="${teacher.firstnamesFull} ${teacher.surnameFull}"/> --%>
<%--                                             </c:when> --%>
<%--                                         </c:choose> --%>
<%--                                     </c:forEach> --%>
<%--                                     <c:if test="${showOtherName == false }"> --%>
<%--                                         <input type="hidden" name="${idPrefix}staffMemberId" id="${idPrefix}staffMemberId" value="<c:out value="${staffMember.staffMemberId}" />" /> --%>
<%--                                         <c:out value="${staffMember.firstnamesFull} ${staffMember.surnameFull}"/> --%>
<%--                                     </c:if> --%>
<%--                                 </c:when> --%>
<%--                                 <c:otherwise> --%>
<%--                                     <c:forEach var="teacher" items="${teachers}">  --%>
<%--                                         <c:if test="${teacher.staffMemberId == testResult.staffMemberId}">  --%>
<%--                                             <input type="hidden" name="${idPrefix}staffMemberId" id="${idPrefix}staffMemberId" value="<c:out value="${teacher.staffMemberId}" />"  /> --%>
<%--                                             <c:out value="${teacher.firstnamesFull} ${teacher.surnameFull}"/> --%>
<%--                                         </c:if>  --%>
<%--                                     </c:forEach> --%>
<%--                                 </c:otherwise> --%>
<%--                             </c:choose>    --%>
<%--                         </c:otherwise> --%>
<%--                     </c:choose> --%>
                    </td>

                    <!-- MARK -->
                    <c:set var="markClass" value="" />
                    <c:if test="${authAny && fn:trim(testResult.passed) == 'N'}">
                        <c:set var="markClass" value='class="required"' />  <%-- TODO make dedicated CSS class, don't reuse the required class, which has different meaning --%>
                    </c:if>
                    <td ${markClass}>
                        <c:if test="${line.exempted}">
                            <fmt:message key="general.exempted"/>
                        </c:if>
                        <%-- for information purposes indicate why mark is not editable --%>
                        <c:if test="${line.studyPlanStatusCode ne STUDYPLAN_STATUS_APPROVED_ADMISSION}">
                            <c:out value="${testResultsForm.codeToStudyPlanStatusMap[line.studyPlanStatusCode].description}"/>
                        </c:if>
                        <c:choose>
                            <c:when test="${authCreateOrUpdate}">
                                <form:input path="allLines[${lineStatus.index}].results[${i}].mark" size="3" maxlength="6" autocomplete="off" />
                                <form:errors path="allLines[${lineStatus.index}].results[${i}].mark" cssClass="error"/>
                                <c:if test="${hasTestResult}">
                                    <c:out value="${testResult.mark}"/>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${authShow}">
                                    <c:out value="${testResult.mark}"/>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </td>
<%--                    <c:choose>
                        <c:when test="${line.exempted || line.studyPlanStatusCode ne STUDYPLAN_STATUS_APPROVED_ADMISSION}">
                            <td>
                                <c:if test="${line.exempted}">
                                    <fmt:message key="general.exempted"/>
                                </c:if>
                                <c:if test="${line.studyPlanStatusCode ne STUDYPLAN_STATUS_APPROVED_ADMISSION}">
                                    <c:out value="${codeToStudyPlanStatusMap[line.studyPlanStatusCode].description}"/>
                                </c:if>
                            </td>
                            <td></td>
                        </c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${editTestResults}">      
                                    <c:choose>
                                        <c:when test="${not varStatus.last}">
                                            <c:choose>
                                                <c:when test="${fn:trim(testResult.passed) != 'N'}">
                                                  <td>
                                                </c:when>
                                                <c:otherwise>
                                                    <td class="required">
                                                </c:otherwise>
                                            </c:choose>
                                            <input type="text" name="${idPrefix}mark" id="${idPrefix}mark" size="3" maxlength="6" value="<c:out value='${testResult.mark}' />" />
                                            </td>
                                        </c:when>
                                        <c:otherwise>
                                            <td>
                                               <input type="text" name="${idPrefix}mark" id="${idPrefix}mark" size="3" maxlength="6" value="" />
                                            </td>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${teacherHasAccess}">      
                                            <c:choose>
                                                <c:when test="${not varStatus.last}">
                                                    <c:choose>
                                                        <c:when test="${fn:trim(testResult.passed) != 'N'}">
                                                            <td>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <td class="required">
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <c:choose>
                                                        <c:when test="${teacherHasEditAcces || (empty testResult)}">
                                                            <input type="text" name="${idPrefix}mark" id="${idPrefix}mark" size="3" maxlength="6" value="<c:out value='${testResult.mark}' />" />
                                                        </c:when>                                                                        
                                                        <c:otherwise>
                                                            <c:out value="${testResult.mark}"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    </td>
                                                </c:when>
                                                <c:otherwise>
                                                    <td>
                                                       <input type="text" name="${idPrefix}mark" id="${idPrefix}mark" size="3" maxlength="6" value="" />
                                                    </td>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <td><c:out value="${testResult.mark}"/></td>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                    <td> --%>

                    <!-- Examination result comment (optional) -->
                    <td>
                    </td>

                    <td>                    
                        <c:if test="${authDelete}">
                            <a href="<c:url value='/college/testresult_delete.view'/>?<c:out value='from=testresults&studyGradetypeId=${studyGradeTypeId}&studentId=${studentSave.studentId}&studyPlanDetailId=${testResult.studyPlanDetailId}&testResultId=${testResult.id}&subjectId=${examinationResult.subjectId}&examinationId=${examination.id}&testId=${test.id}&currentPageNumber=${currentPageNumber}'/>">
                                  <img src="<c:url value='/images/delete.gif'/>" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                            </a>
                            <c:set var="useDeleteAllButton" value="${true}" />
                        </c:if>
                    </td>
                </tr>
<%--                 <c:remove var="testResult" /> --%>
            </c:forEach> <%-- nr of results --%>
        </c:forEach>

        <tr><td colspan="5">&nbsp;</td>
            <td align="left">
                <c:if test="${useDeleteAllButton}">
                    <input type="submit" name="deleteAll" onclick="return confirm('<fmt:message key="jsp.testresults.deleteall.confirm"/>');" value="<fmt:message key='jsp.button.delete.all' />" />
                </c:if>
            </td>
            <td colspan="2" align="right">
                <input type="submit" name="submittestresults" value="<fmt:message key="jsp.button.submit" />" />
            </td>
        </tr>

    </table>
    <script type="text/javascript">alternate('TblData2_testresults',true)</script>

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

