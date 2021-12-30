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

<c:set var="form" value="${examinationResultsForm}" />

<c:set var="examination" value="${form.examination}" />
<c:set var="subject" value="${form.subject}" />
<c:set var="classgroupId" value="${form.classgroupId}" />
<c:set var="staffMember" value="${form.staffMember}" />
<c:set var="teachers" value="${form.teachers}" />
<c:set var="idToExaminationTeacherMap" value="${form.idToExaminationTeacherMap}" />
<c:set var="brsPassing" value="${form.brsPassing}" />
<c:set var="minimumMarkValue" value="${form.minimumMarkValue}" />
<c:set var="maximumMarkValue" value="${form.maximumMarkValue}" />
<c:set var="assessmentStructurePrivilege" value="${form.assessmentStructurePrivilege}" />

<c:set var="tab" value="${form.navigationSettings.tab}" />
<c:set var="panel" value="${form.navigationSettings.panel}" />
<c:set var="currentPageNumber" value="${form.navigationSettings.currentPageNumber}" />


<%-- authorizations --%>
<%-- <sec:authorize access="hasAnyRole('CREATE_STUDYPLAN_RESULTS','UPDATE_STUDYPLAN_RESULTS')">
    <c:set var="editExaminationResults" value="${true}"/>
</sec:authorize>

<c:if test="${not editExaminationResults}">
    <sec:authorize access="hasRole('READ_STUDYPLAN_RESULTS')">
        <c:set var="showExaminationResults" value="${true}"/>
    </sec:authorize>
</c:if>

<!-- first check if logged in teacher is in examination teachers list -->
<c:set var="teacherHasAccess" value="${false}" scope="page" />
<c:forEach var="examinationTeacher" items="${teachers}">
    <c:if test="${examinationTeacher.staffMemberId == staffMember.staffMemberId}">
        <c:set var="teacherHasAccess"  value="${true}" scope="page" />
    </c:if>
</c:forEach>

<!--  if so, check if the teacher has edit rights -->
<c:set var="teacherHasEditAcces" value="${false}" scope="page" />
<c:if test="${teacherHasAccess}">
    <sec:authorize access="hasRole('UPDATE_STUDYPLAN_RESULTS_ASIGNED_EXAM')">
        <c:set var="teacherHasEditAcces" value="${true}"/>
    </sec:authorize>
</c:if>
--%>

<%-- messages --%>
<c:set var="strMinimumGrade"><fmt:message key="jsp.general.minimummark" /></c:set>
<c:set var="strMaximumGrade"><fmt:message key="jsp.general.maximummark" /></c:set>
<c:set var="strHigherThanGivenGrade"><fmt:message key="jsp.validity.string.higherthangivengrade" /></c:set>
<c:set var="strLowerThanGivenGrade"><fmt:message key="jsp.validity.string.lowerthangivengrade" /></c:set>
<c:set var="strConflictingScales"><fmt:message key="jsp.validity.string.conflictingscales" /></c:set>

<div id="tabcontent">

<fieldset>
	<legend>
	    <a href="<c:url value='/college/subjectsresults.view?currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
		<a href="<c:url value='/college/subjectresults.view?newForm=true&amp;tab=${tab}&amp;panel=${panel}&amp;subjectId=${subject.id}&amp;examinationId=${examination.id}&amp;currentPageNumber=${currentPageNumber}'/>">
        <c:choose>
            <c:when test="${subject.subjectDescription != null and subject.subjectDescription != ''}" >
                <c:out value="${fn:substring(subject.subjectDescription,0,initParam.iTitleLength)}"/>
            </c:when>
            <c:otherwise>
                <fmt:message key="jsp.href.new" />
            </c:otherwise>
        </c:choose>
		</a>
		&nbsp;&gt;&nbsp;
	    <c:choose>
            <c:when test="${examination.examinationDescription != null and examination.examinationDescription != ''}" >
                <c:out value="${fn:substring(examination.examinationDescription,0,initParam.iTitleLength)}"/>
            </c:when>
        </c:choose>
		&nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.examination" />&nbsp;<fmt:message key="jsp.general.results" /> 
	</legend>
    <br />
    <table>
    	<tr>
    		<td>
    			<!-- EXAMINATION INFORMATION -->
		        <table>                                                            

		            <!-- EXAMINATION CODE -->
		            <tr>
		                <td class="label"><fmt:message key="jsp.general.code" /></td>
		                <td >
		                <c:out value="${examination.examinationCode}"/>
		                     
		                
		            
		            </tr><tr>
		            <!-- EXAMINATION DESCRIPTION -->
		                <td class="label"><fmt:message key="jsp.general.description" /></td>
		                <td>
		                    <a href="<c:url value='/college/examination.view?newForm=true&amp;tab=0&amp;panel=0&amp;examinationId=${examination.id}&amp;currentPageNumber=0'/>">
		                        <c:out value="${examination.examinationDescription}"/>
		                    </a>
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
		                    <c:out value="${form.codeToExaminationTypeMap[examination.examinationTypeCode].description}"/>
		                </td> 
	                </tr>

		            <!--  NUMBER OF ATTEMPTS -->
                    <tr>
		                <td class="label"><fmt:message key="jsp.general.numberofattempts" /></td>
		                <td>
		                    <c:out value="${examination.numberOfAttempts}"/>
		                </td>
		            </tr>
		            
		            <!-- WEIGHING FACTOR -->
		            <tr>
		                <td class="label"><fmt:message key="jsp.general.weighingfactor" /></td>
		                <td>
		                    <c:out value="${examination.weighingFactor} %"/>
		                </td>
	                </tr>

                    <!-- BR's PASSING EXAMINATION -->
                    <tr>

		                <td class="label"><fmt:message key="jsp.general.brspassing" /></td>
		                <td>
		                    <c:out value="${brsPassing}"/>
    		                &nbsp;
    		                (<fmt:message key="jsp.general.minimummark" />: <c:out value="${minimumMarkValue}"/>,
    		                <fmt:message key="jsp.general.maximummark" />: <c:out value="${maximumMarkValue}"/>)
		                </td>
		            </tr>

                    <!-- EXAMINATION DATE -->
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.examdate" /></td>
                        <td>
                            <fmt:formatDate value="${examination.examinationDate}"/>
                        </td> 
                    </tr>

                    <!-- ACTIVE -->
		            <tr>
		                <td class="label"><fmt:message key="jsp.general.active" /></td>
		                <td>
<%--		                    <c:out value="${examination.active}"/> --%>
                            <fmt:message key="${stringToYesNoMap[examination.active]}"/>
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
	        </td>
	        <td>
		        <table>
		        	<tr>
                        <td rowspan="8" width="100"></td>
			            <td class="label" width="200" align="left" > <fmt:message key="jsp.general.structure" />
                            <fmt:message var="pdfreport" key="jsp.button.pdfreport" />
                            <fmt:message var="xlsreport" key="jsp.button.xlsreport" />
                            <table>
                                <tr>
                                    <td>
                                        ><a href="<c:url value='/college/subjectresults.view?newForm=true&amp;&amp;subjectId=${subject.id}&amp;classgroupId=${classgroupId}&amp;currentPageNumber=${currentPageNumber}'/>">
                                            <c:out value="${subject.subjectDescription}"/>
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
            
                                <c:forEach var="oneExamination" items="${subject.examinations}">
                                    <tr>
                                        <td>
                                            &nbsp;&nbsp;>
                                            <c:choose>
                                                <c:when test="${examination.id == oneExamination.id}">
                                                    <c:out value="${oneExamination.examinationDescription}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="<c:url value='/college/examinationresults.view'/>?<c:out value='newForm=true&examinationId=${oneExamination.id}&classgroupId=${classgroupId}&currentPageNumber=${currentPageNumber}'/>">
                                                        <c:out value="${oneExamination.examinationDescription}"/>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:if test="${assessmentStructurePrivilege.examinationAccess[oneExamination.id]}">
                                                <td>
                                                    <a href="<c:url value='/college/examinationresults/examinationResults/${oneExamination.id}/pdf'/>" target="_blank"><img src="<c:url value='/images/pdf-16.png' />" alt="${pdfreport}" title="${pdfreport}" /></a>
                                                </td>   
                                                <td>
                                                    <a href="<c:url value='/college/examinationresults/examinationResults/${oneExamination.id}/xls'/>" target="_blank"><img src="<c:url value='/images/xls-16.png' />" alt="${xlsreport}" title="${xlsreport}" /></a>
                                                </td>
                                            </c:if>
                                        </td>
                                    </tr>
                
                                    <c:forEach var="test" items="${oneExamination.tests}">
                                        <tr>
                                            <td>
                                                &nbsp;&nbsp;&nbsp;&nbsp;> <a href="<c:url value='/college/testresults.view'/>?<c:out value='newForm=true&testId=${test.id}&classgroupId=${classgroupId}&currentPageNumber=${currentPageNumber}'/>">
                                                <c:out value="${test.testDescription}"/>
                                                </a>
                                                <c:if test="${assessmentStructurePrivilege.testAccess[test.id]}">
                                                    <td>
                                                    <a href="<c:url value='/college/examinationresults/testResults/${test.id}/pdf'/>" target="_blank"><img src="<c:url value='/images/pdf-16.png' />" alt="${pdfreport}" title="${pdfreport}" /></a>
                                                    </td>
                                                    <td>
                                                    <a href="<c:url value='/college/examinationresults/testResults/${test.id}/xls'/>" target="_blank"><img src="<c:url value='/images/xls-16.png' />" alt="${xlsreport}" title="${xlsreport}" /></a>
                                                    </td>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:forEach>
                            </table>
<%--    			            <br/><br/>
    			            ><a href="<c:url value='/college/subjectresults.view?newForm=true&amp;&amp;subjectId=${subject.id}&amp;currentPageNumber=${currentPageNumber}'/>">
                                <c:choose>
                                    <c:when test="${subject.subjectDescription != null and subject.subjectDescription != ''}" >
                                        <c:out value="${fn:substring(subject.subjectDescription,0,initParam.iTitleLength)}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:message key="jsp.href.new" />
                                    </c:otherwise>
                                </c:choose>
                    		</a>
    
                            <br/>
			            
                            <c:forEach var="oneExamination" items="${subject.examinations}">
                                &nbsp;&nbsp;>
                                <c:choose>
                                    <c:when test="${examination.id == oneExamination.id}">
                                        <c:out value="${oneExamination.examinationDescription}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="<c:url value='/college/examinationresults.view'/>?<c:out value='newForm=true&examinationId=${oneExamination.id}&currentPageNumber=${currentPageNumber}'/>">
                                            <c:out value="${oneExamination.examinationDescription}"/>
                                        </a>
                                    </c:otherwise>
                                </c:choose>

                                <c:forEach var="test" items="${oneExamination.tests}">
		                       		<br />
		                            &nbsp;&nbsp;&nbsp;&nbsp;>  <a href="<c:url value='/college/testresults.view'/>?<c:out value='newForm=true&testId=${test.id}&currentPageNumber=${currentPageNumber}'/>">
		                            <c:out value="${test.testDescription}"/>
		                            </a>
		                        </c:forEach>
		                        <br/>
			                </c:forEach>
 --%>
			            </td>
		            </tr>
	            </table>
       		</td>
        </tr>
	</table>
</fieldset>

<div id="tp1" class="TabbedPanel">

<div class="TabbedPanelsContentGroup">   
<div class="TabbedPanelsContent">
<div class="Accordion" id="Accordion0">
<div class="AccordionPanel">
<div class="AccordionPanelTab"><fmt:message key="jsp.general.examination" />&nbsp;<fmt:message key="jsp.general.results" /></div>
<div class="AccordionPanelContent">

<%-- separate form with augmented URL in order to differntiate from a ordinary post of the results form --%>
<form:form modelAttribute="examinationResultsForm" action="${pageContext.request.contextPath}/college/examinationresults/classgroup" method="post" >
    <table>
        <tr>
            <td>
                <th><fmt:message key="general.classgroup" /></th>
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

<form:errors path="examinationResultsForm.*" cssClass="errorwide" element="p"/>

<c:url var="post_url" value='/college/examinationresults'/>
<form:form modelAttribute="examinationResultsForm" method="post" action="${post_url}" >

<%-- invisible default button before any other submit button --%>
<input type="submit" class="defaultsink" name="submitexaminationresults" value="Save" />

    <!-- EXAMINATION RESULTS -->
    <table class="tabledata2" id="TblData2_examinationresults">

        <tr>
            <th><fmt:message key="jsp.general.code" /></th>
            <th><fmt:message key="jsp.menu.student" /></th>
            <th class="width1"><fmt:message key="jsp.general.attemptnr" /></th>
            <th class="width1"><fmt:message key="jsp.general.resultdate" /></th>
            <th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="jsp.general.mark" /></th>
            <c:if test="${fn:length(examination.tests) > 0}">
                <%-- "Generate" column only makes sense if there are lower level results --%>
                <th></th>
            </c:if>
            <th><fmt:message key="jsp.general.comment" /></th>
            <th><fmt:message key="jsp.general.teacher" /></th>
            <c:if test="${fn:length(examination.tests) > 0}">
                <%-- "Test results" column only makes sense if there are lower level results --%>
                <th><fmt:message key="jsp.general.testresults" /></th>
            </c:if>
        </tr>

        <c:set var="useGenerateAllButton" value="${false}" />
        <c:set var="useDeleteAllButton" value="${false}" />

        <c:forEach var="line" items="${form.allLines}" varStatus="lineStatus">

            <%-- make one line for each attempt already made + 1 for the new attempt -> already created by resultLineBuilder --%>
            <c:forEach var="i" begin="0" end="${line.nrOfResults - 1}">
                <c:set var="attemptNr" value="${i + 1}" scope="page" />

                <c:set var="examinationResult" value="${line.results[i]}" scope="page" />
                <c:set var="examinationResultId" value="${examinationResult.id}" />
                <c:set var="hasExaminationResult" value="${examinationResultId != 0}" />

                <c:set var="authorizationKey" value="${line.results[0].studyPlanDetailId}-${line.results[0].examinationId}-${attemptNr}" />
                <c:set var="authorization" value="${form.examinationResultAuthorizationMap[authorizationKey]}" scope="page" />
                <c:set var="authCreate" value="${authorization.create}" />
                <c:set var="authUpdate" value="${authorization.update}" />
                <c:set var="authCreateOrUpdate" value="${authorization.createOrUpdate}" />
                <c:set var="authShow" value="${authorization.read}" />
                <c:set var="authDelete" value="${authorization.delete}" />
                <c:set var="authAny" value="${authShow || authCreateOrUpdate || authDelete}" />

                <tr>
                    <td>
                        <c:out value="${line.studentCode }"></c:out>
                    </td>

                    <!-- STUDENT -->
                    <td width="40%">
<%--                         <c:choose> --%>
<%-- 			        <c:when test="${opususer.personid == student.personid}"> --%>
			        <a href="<c:url value='/college/student/personal.view?newForm=true&amp;from=students&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;studentId=${line.studentId}&amp;searchValue=${navigationSettings.searchValue}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
			        <c:out value="${line.firstnamesFull} ${line.surnameFull}"/></a>
<%-- 			         </c:when> --%>
<%--                                 <c:otherwise> --%>
<%--                                     <c:out value="${line.firstnamesFull} ${line.surnameFull}"/> --%>
<%--                                 </c:otherwise> --%>
<%--                             </c:choose> --%>
                    </td>   
                   
                    <!-- ATTEMPT NUMBER -->
                    <td>
                         
                         <%-- Old <c:if test="${hasExaminationResult}">
                            <c:out value="${examinationResult.attemptNr}"/>
                            <fmt:message key="jsp.general.examination" />
                        </c:if>
                        --%>

                        <%-- TODO create a table "examinationType-Attempt" that specifies the text that shall be written for a specific attempt (empty texts needed for case 'combined tests') --%>                        
                        <c:if test="${examinationResult.attemptNr == 1}">
                        	<c:if test="${examination.examinationTypeCode == '100'}">
                        	</c:if>
                            <c:if test="${examination.examinationTypeCode == '101'}">
                            	<c:out value="${examinationResult.attemptNr}"/>-
                            	<fmt:message key="jsp.general.examination" />
                        	</c:if>

                        </c:if>
                        
                        <c:if test="${examinationResult.attemptNr == 2}">
                            <c:out value="${examinationResult.attemptNr}"/>-
                            <fmt:message key="general.exam.resit" />
                        </c:if>
                        <c:if test="${examinationResult.attemptNr == 3}">
                            <c:out value="${examinationResult.attemptNr}"/>-
                            <fmt:message key="jsp.general.externalexamination" />
                        </c:if>
                         <c:if test="${examinationResult.attemptNr == 4}">
                            <c:out value="${examinationResult.attemptNr}"/>-
                            <fmt:message key="jsp.general.externalexaminationresit" />
                        </c:if>      
                        
                    </td>

                    <!-- EXAMINATION RESULT DATE -->
                    <td>
                        <c:set var="examinationResultDatePath" value="allLines[${lineStatus.index}].results[${i}].examinationResultDate" />
                        <c:set var="examinationResultDateId"   value="allLines${lineStatus.index}.results${i}.examinationResultDate" />
                        <fmt:formatDate var="resultDate" pattern="yyyy-MM-dd" value='${examinationResult.examinationResultDate}' />
                        <form:hidden path="${examinationResultDatePath}"/>
                        <c:choose>
                            <c:when test="${authCreate}">
                                <table>
                                    <tr>
                                        <td><input type="text" id="${lineStatus.index}_${i}_examinationresult_year" name="${lineStatus.index}_${i}_examinationresult_year" size="4" maxlength="4" value="<c:out value="${fn:substring(resultDate,0,4)}" />" onchange="updateFullDate('${examinationResultDateId}','year',document.getElementById('${lineStatus.index}_${i}_examinationresult_year').value);" /></td>
                                        <td><input type="text" id="${lineStatus.index}_${i}_examinationresult_month" name="${lineStatus.index}_${i}_examinationresult_month" size="2" maxlength="2" value="<c:out value="${fn:substring(resultDate,5,7)}" />" onchange="updateFullDate('${examinationResultDateId}','month',document.getElementById('${lineStatus.index}_${i}_examinationresult_month').value);" /></td>
                                        <td><input type="text" id="${lineStatus.index}_${i}_examinationresult_day" name="${lineStatus.index}_${i}_examinationresult_day" size="2" maxlength="2" value="<c:out value="${fn:substring(resultDate,8,10)}" />" onchange="updateFullDate('${examinationResultDateId}','day',document.getElementById('${lineStatus.index}_${i}_examinationresult_day').value);"  /></td>
                                    </tr>
                                    <tr><td/></tr> <%-- have even number of tr tags in inner table for alternate script to work correctly --%>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <fmt:formatDate pattern='yyyy-MM-dd' value='${examinationResult.examinationResultDate}' />
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <!-- MARK -->

                    <c:set var="markClass" value="" />
                    <c:if test="${authAny && fn:trim(examinationResult.passed) == 'N'}">
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
                                <form:input path="allLines[${lineStatus.index}].results[${i}].mark" size="3" maxlength="6" autocomplete="off" />
                                <form:errors path="allLines[${lineStatus.index}].results[${i}].mark" cssClass="errornarrow"/>
                                <c:if test="${hasExaminationResult}">
                                    <c:out value="${examinationResult.mark}"/>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${authShow}">
                                    <c:out value="${examinationResult.mark}"/>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <!-- GENERATE BUTTON -->
                    <c:if test="${fn:length(examination.tests) > 0}">
                        <td style="vertical-align: middle; text-align:center;" >
                            <c:choose>
                                <%-- Note MP: Change in behavior: only allow generation if no result yet exists (if result exists no need for re-generation in this screen).
                                     Otherwise unclear how to behave in case of generate all (really re-generate all existing results??)
                                     and in case a problem occurs during generation (up to now mark was set to "-" but not stored -> confusing) --%>
                                <c:when test="${authCreate && line.subResultsFound}"> <%-- change to *All*ExaminationResultsFound --%>
                                    <a class="button" href="<c:url value='/college/examinationresults.view?generate=${lineStatus.index}&amp;currentPageNumber=${currentPageNumber}'/>">
                                        <fmt:message key="jsp.button.generate" />
                                    </a>
                                    <c:set var="useGenerateAllButton" value="${true}" />
                                </c:when>
                            </c:choose>
                            
                             <!-- Examination description comment (optional) -->
                            <c:if test="${(examinationResult.passed) == 'N' && (examination.examinationTypeCode) == '100'}">
                                <fmt:message key="general.message.frequency"/>
                            </c:if>
                          
                                                
                        </td>
                    </c:if>

                    <!-- Examination result comment (optional) -->
                    <td>
                        <c:if test="${authCreateOrUpdate}">
                            <form:select cssClass="auto" path="allLines[${lineStatus.index}].results[${i}].examinationResultCommentId">
                                <option class="auto" value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                <c:forEach var="comment" items="${form.examinationResultComments}">
                                    <form:option cssClass="auto" value="${comment.id}"><fmt:message key="${comment.commentKey}"/></form:option>
                                </c:forEach>
                            </form:select>
                        </c:if>
                    </td>

                    <!-- EXAMINATION TEACHERS -->
                    <td>
                        <c:choose>
                            <c:when test="${authCreateOrUpdate}">
                                <form:select cssClass="auto compressoneoption" path="allLines[${lineStatus.index}].results[${i}].staffMemberId">
                                    <option class="auto" value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                    <c:forEach var="teacher" items="${teachers}">
                                        <form:option cssClass="auto" value="${teacher.staffMemberId}"><c:out value="${teacher.firstnamesFull} ${teacher.surnameFull}"/></form:option>
                                    </c:forEach>
                                </form:select>
                                <form:errors path="allLines[${lineStatus.index}].results[${i}].staffMemberId" cssClass="errornarrow"/>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${authShow}">
                                    <c:set var="teacher" value="${idToExaminationTeacherMap[examinationResult.staffMemberId]}" />
                                    <c:out value="${teacher.firstnamesFull} ${teacher.surnameFull}"/>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <!-- TEST RESULTS -->
                    <c:if test="${fn:length(examination.tests) > 0}">
                        <td>
                            <c:if test="${line.subResultsFound and i eq 0}">
<%--                                 <a href="#" onclick="openPopupWindow('<c:out value="${line.subResultsString}"/>');" ><fmt:message key="jsp.general.testresults" /></a> --%>
                                <a class="infobox" href="#INFO">
                                    <fmt:message key="jsp.general.testresults" />
                                    <span>
                                        <b>
                                            <fmt:message key="jsp.general.testresultdate" />:
                                            <fmt:message key="jsp.general.description" /> (<fmt:message key="jsp.general.attemptnr" />):
                                            <fmt:message key="jsp.general.mark" /> (<fmt:message key="jsp.general.passed" />)
                                        </b>
                                        <%-- NB: line.subResultsString is not to be put inside a c:out element, because it contains html tags --%>
                                        ${line.subResultsString}
                                    </span>
                                </a>
                            </c:if>
                        </td>
                    </c:if>

                    <%-- DELETE BUTTON --%>
                    <td>
                        <c:if test="${authDelete}">
                            <a href="<c:url value='/college/examinationresults/delete/${lineStatus.index}/${i}'/>">
                              <img src="<c:url value='/images/delete.gif'/>" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                            <c:set var="useDeleteAllButton" value="${true}" />
                        </c:if>
                    </td>

                </tr>
            </c:forEach>

        </c:forEach> <%-- result line --%>

        <tr>
            <td></td>
            <td colspan="2" class="label">
                <fmt:message key="jsp.general.mark.adjustment" /> +/-
            </td>
            <td align="right">
                <input type="text" id="adjustmentMark" name="adjustmentMark" size="3" maxlength="6" value="0.0" />
            </td>
            <td align="right">
                <input type="submit" name="adjustexaminationresults" value="<fmt:message key="jsp.general.adjustall" />" onclick="document.getElementById('adjustAllExaminationResults').value='Y';document.examinationresultsdata.submit();" />
            </td>
            <td align="right">
                <c:if test="${fn:length(examination.tests) > 0}">
                    <c:if test="${useGenerateAllButton}">
                        <input type="submit" name="generateAll" ${generateAllDisabled} value="<fmt:message key='jsp.button.generate.all' />" />
                    </c:if>
                </c:if>
            </td>
            <td align="left">
                <c:if test="${useDeleteAllButton}">
                    <input type="submit" name="deleteAll" onclick="return confirm('<fmt:message key="jsp.examinationresults.deleteall.confirm"/>');" value="<fmt:message key='jsp.button.delete.all' />" />
                </c:if>
            </td>

            <td colspan="1" align="right">
                <input type="submit" name="submitexaminationresults" value="<fmt:message key='jsp.button.submit' />" />
            </td>
        </tr>

    </table>
<script type="text/javascript">alternate('TblData2_examinationresults',true)</script>

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

