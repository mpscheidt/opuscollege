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

<c:set var="screentitlekey">jsp.general.subjectresult</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="wrapper">

<%@ include file="../../menu.jsp"%>

<c:set var="subjectResult" value="${subjectResultForm.subjectResult}" />
<c:set var="subjectResultId" value="${subjectResult.id}" />
<c:set var="hasSubjectResult" value="${subjectResultId != 0}" />

<c:set var="student" value="${subjectResultForm.student}" />
<c:set var="studyPlan" value="${subjectResultForm.studyPlan}" />
<c:set var="studyPlanDetail" value="${subjectResultForm.studyPlanDetail}" />
<c:set var="studyPlanCardinalTimeUnit" value="${subjectResultForm.studyPlanCardinalTimeUnit}" />
<c:set var="subject" value="${subjectResultForm.subject}" />

<c:set var="brsPassing" value="${subjectResultForm.brsPassing}" />
<c:set var="endGradesPerGradeType" value="${subjectResultForm.endGradesPerGradeType}" />
<c:set var="minimumMarkValue" value="${subjectResultForm.minimumMarkValue}" />
<c:set var="maximumMarkValue" value="${subjectResultForm.maximumMarkValue}" />
<c:set var="fullEndGradeCommentsForGradeType" value="${subjectResultForm.fullEndGradeCommentsForGradeType}" />
<c:set var="fullFailGradeCommentsForGradeType" value="${subjectResultForm.fullFailGradeCommentsForGradeType}" />
<%-- <c:set var="fullAREndGradeCommentsForGradeType" value="${subjectResultForm.fullAREndGradeCommentsForGradeType}" /> --%>
<%-- <c:set var="fullARFailGradeCommentsForGradeType" value="${subjectResultForm.fullARFailGradeCommentsForGradeType}" /> --%>

<c:set var="tab" value="${subjectResultForm.navigationSettings.tab}" />
<c:set var="panel" value="${subjectResultForm.navigationSettings.panel}" />
<c:set var="currentPageNumber" value="${subjectResultForm.navigationSettings.currentPageNumber}" />

<%-- Authorizations --%>
<c:set var="subjectResultAuthorization" value="${subjectResultForm.subjectResultAuthorization}" />

<div id="tabcontent">

<fieldset>
	<legend>
       <a href="<c:url value='/college/studyplanresults.view?newForm=true&amp;currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
       
       &nbsp;&gt;&nbsp;<a href="<c:url value='/college/studyplanresult.view?newForm=true&amp;tab=${tab}&amp;panel=${panel}&amp;studentId=${student.studentId}&amp;studyPlanId=${studyPlanDetail.studyPlanId}&amp;currentPageNumber=${currentPageNumber}'/>">
        <c:choose>
            <c:when test="${not empty student.surnameFull}" >
                <c:set var="studentName" value="${student.studentCode}: ${student.surnameFull}, ${student.firstnamesFull}" scope="page" />
                <c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}"/>
            </c:when>
            <c:otherwise>
                <fmt:message key="jsp.href.new" />
            </c:otherwise>
        </c:choose>
        &nbsp;&gt;&nbsp;
        <c:choose>
            <c:when test="${studyPlan.studyPlanDescription != ''}" >
                <c:out value="${fn:substring(studyPlan.studyPlanDescription,0,initParam.iTitleLength)}"/>
            </c:when>
            <c:otherwise>
                <fmt:message key="jsp.href.new" />
            </c:otherwise>
        </c:choose> 
        </a>
        <br />&nbsp;&nbsp;&nbsp;&nbsp;>&nbsp;
        &nbsp;>&nbsp;<a href="<c:url value='/college/cardinaltimeunitresult.view?newForm=true&amp;studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&amp;currentPageNumber=${currentPageNumber}&amp;tab=${tab}&amp;panel=${panel}'/>">
		<c:choose>
			<c:when test="${studyPlanCardinalTimeUnit.cardinalTimeUnitNumber != null && studyPlanCardinalTimeUnit.cardinalTimeUnitNumber != ''}" >
				<fmt:message key="jsp.general.cardinaltimeunit.number" /> <c:out value="${studyPlanCardinalTimeUnit.cardinalTimeUnitNumber}"/>
			</c:when>
		</c:choose>
		</a>
		&nbsp;>&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.cardinaltimeunitresult" /> 

	</legend>
</fieldset>
	
<div id="tp1" class="TabbedPanel">
   <!--   <ul class="TabbedPanelsTabGroup">
        <li class="TabbedPanelsTab"><fmt:message key="jsp.general.cardinaltimeunitsresults" /></li>               
    </ul> -->

<div class="TabbedPanelsContentGroup">   
<div class="TabbedPanelsContent">
<div class="Accordion" id="Accordion0">
<div class="AccordionPanel">
<div class="AccordionPanelTab"><fmt:message key="jsp.general.cardinaltimeunitresult" /></div>
<div class="AccordionPanelContent">

<form:form modelAttribute="subjectResultForm">

	<form:errors cssClass="errorwide" element="p"/> <%-- show global errors here only --%>

    <%-- invisible default button before any other submit button --%>
    <input type="submit" class="defaultsink" name="submitcardinaltimeunitresult" value="Save" />

    <table>
        <tr>
            <td class="label"><b><fmt:message key="jsp.general.studyplan" /></b></td>
            <td colspan="2">
                 <c:out value="${studyPlan.studyPlanDescription}"/>
            </td>
        </tr>

        <c:if test="${appUseOfSubjectBlocks == 'Y'}">
            <tr>
                <td class="label"><b><fmt:message key="jsp.general.subjectblock" /></b></td>
                <td colspan="2">
                	<c:out value="${studyPlanDetail.subjectBlock.subjectBlockDescription}"/>
                </td>
            </tr>
        </c:if>

        <tr>
            <td class="label"><fmt:message key="jsp.general.subject" /></td>
            <td colspan="2">
                <c:url var="subjectUrl" value='/college/subject.view?newForm=true&amp;subjectId=${subject.id}'/>
                <a href="${subjectUrl}">
                    <c:out value="${subject.subjectCode}"/>: <c:out value="${subject.subjectDescription}"/>
                </a>
               <c:if test="${subject.resultType eq ATTACHMENT_RESULT}">
               &nbsp;<b>(<fmt:message key="jsp.general.attachmentresult" />)</b>
               </c:if>
            </td> 
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="label"><fmt:message key="jsp.general.academicyear" /></td>
            <td><c:out value="${subjectResultForm.academicYear.description}"></c:out></td>
		</tr>
        <tr>
            <td class="label"><fmt:message key="jsp.general.brspassing" /></td>
            <td >
                <c:out value="${brsPassing}"/>
           </td>
           <td>
                <fmt:message key="jsp.general.minimummark" />: ${minimumMarkValue}, <fmt:message key="jsp.general.maximummark" />: ${maximumMarkValue}
           </td>
        </tr>

        <tr>
            <td class="label"><fmt:message key="jsp.general.resultdate" /></td>
            <c:choose>
                <c:when test="${subjectResultAuthorization.createOrUpdate}">
                    <td class="required">
                        <form:hidden path="subjectResult.subjectResultDate"/>
                        <table>
                            <tr>
                                <td><fmt:message key="jsp.general.day" /></td>
                                <td><fmt:message key="jsp.general.month" /></td>
                                <td><fmt:message key="jsp.general.year" /></td>
                            </tr>
                            <tr>
                                <td><input type="text" id="subjectresult_day" name="subjectresult_day" size="2" maxlength="2" value="<fmt:formatDate value='${subjectResultForm.subjectResult.subjectResultDate}' pattern='dd'/>" onchange="updateFullDate('subjectResult.subjectResultDate','day',document.getElementById('subjectresult_day').value);" /></td>
                                <td><input type="text" id="subjectresult_month" name="subjectresult_month" size="2" maxlength="2" value="<fmt:formatDate value='${subjectResultForm.subjectResult.subjectResultDate}' pattern='MM'/>" onchange="updateFullDate('subjectResult.subjectResultDate','month',document.getElementById('subjectresult_month').value);" /></td>
                                <td><input type="text" id="subjectresult_year" name="subjectresult_year" size="4" maxlength="4" value="<fmt:formatDate value='${subjectResultForm.subjectResult.subjectResultDate}' pattern='yyyy'/>" onchange="updateFullDate('subjectResult.subjectResultDate','year',document.getElementById('subjectresult_year').value);" /></td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <form:errors path="subjectResult.subjectResultDate" cssClass="error"/>
                    </td>
                </c:when>
                <c:otherwise>
                    <c:if test="${subjectResultAuthorization.read}">
                        <td>
                            <fmt:formatDate value="${subjectResult.subjectResultDate}" />
                        </td>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </tr>
        
        <tr>
            <td class="label"><b><fmt:message key="jsp.general.mark.value" /></b></td>
            <c:choose>
            	<%-- only allow editing if mark hasn't been generated --%>
                <c:when test="${subjectResultAuthorization.createOrUpdate && empty subjectResultForm.resultGenerator}">
                    <td class="required">
                        <form:input path="subjectResult.mark" size="3" maxlength="6" autocomplete="off" />
                        <form:errors path="subjectResult.mark" cssClass="error"/>

                    	<c:choose>
                     		<c:when test="${hasSubjectResult}">
                     			<c:out value="${subjectResultForm.subjectResultFormatter[subjectResultForm.subjectResultInDb]}"/>
                     		</c:when>
                     	</c:choose>
                    </td>
                    <td>
                    	<%-- to be consistent, same behaviour as for subjectResults generate button:
                    		 only allow generate if no result exists --%>
                    	<c:if test="${subjectResultAuthorization.create}">
	                        <input type="submit" name="generate" value="* <fmt:message key='jsp.button.generate' />" />
                        </c:if>
                    </td>
                </c:when>
                <c:otherwise>
                    <c:if test="${subjectResultAuthorization.read}">
                        <td>
                            <c:out value="${subjectResultForm.subjectResultFormatter[subjectResultForm.subjectResultInDb]}"/>
                        </td>
                    </c:if>
                </c:otherwise>
            </c:choose>

            <%-- DELETE BUTTON --%>
            <td>
                <c:if test="${subjectResultAuthorization.delete}">
                    <a onclick="return confirm('<fmt:message key="jsp.subjectresult.delete.confirm" />')" href="<c:url value='/college/subjectresult/deleteSubjectResult'/>">
                    <img src="<c:url value='/images/delete.gif'/>" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                </c:if>
            </td>
        </tr>

        <c:if test="${endGradesPerGradeType}">
            <tr>
                <td class="label"><b><fmt:message key="jsp.general.endgrade.comment" /></b></td>
                <td>
                    <c:choose>
                        <c:when test="${subjectResultAuthorization.createOrUpdate &&
                            (subjectResultForm.subjectResult.mark == '0.0' || subjectResultForm.subjectResult.mark == '0')
                            }">
                            <form:select path="subjectResult.endGradeComment">
                                <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                <c:choose>
                                    <c:when test="${subject.resultType eq ATTACHMENT_RESULT}">
                                        <c:forEach var="failGrade" items="${subjectResultForm.fullARFailGradeCommentsForGradeType}">
                                            <form:option value="${failGrade.code}"><c:out value="${failGrade.comment}"/></form:option>
                                          </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="failGrade" items="${subjectResultForm.fullFailGradeCommentsForGradeType}">
                                            <form:option value="${failGrade.code}"><c:out value="${failGrade.comment}"/></form:option>
                                          </c:forEach>
                                     </c:otherwise>
                                </c:choose>
                            </form:select>
                        </c:when>
                        <c:otherwise>
                            <c:if test="${subjectResultAuthorization.read}">
                                <c:forEach var="endGrade" items="${subjectResultForm.fullEndGradeCommentsForGradeType}">
                                    <c:if test="${endGrade.code == subjectResultForm.subjectResult.endGradeComment}">
                                        <c:out value="${endGrade.comment}"/>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td colspan="3"></td>
            </tr>
        </c:if>

        <tr>
            <td class="label"><fmt:message key="jsp.general.passed" /></td>
            <%-- when no result yet exists, there is no read authorization, but there might be create --%>
            <c:if test="${subjectResultAuthorization.read or subjectResultAuthorization.create}">
                <td>
                	<c:if test="${not empty subjectResultForm.subjectResult.passed}">
	                	<fmt:message key="${stringToYesNoMap[subjectResultForm.subjectResult.passed]}"/>
	                </c:if>
                </td>
            </c:if>
  		</tr>

        <tr>
            <td class="label"><fmt:message key="jsp.general.comment" /></td>
            <c:if test="${subjectResultAuthorization.read or subjectResultAuthorization.create}">
                <td>
                	<c:if test="${not empty subjectResultForm.subjectResult.subjectResultCommentId}">
	                	<fmt:message key="${subjectResultForm.idToSubjectResultCommentMap[subjectResultForm.subjectResult.subjectResultCommentId].commentKey}"/>
	                </c:if>
                </td>
            </c:if>
  		</tr>

        <tr>
            <td class="label"><fmt:message key="jsp.menu.staffmember" /></td>
            <c:choose>
                <c:when test="${subjectResultAuthorization.createOrUpdate}">
                    <td class="required">
                        <form:select cssClass="compressoneoption" path="subjectResult.staffMemberId">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="subjectTeacher" items="${subject.subjectTeachers}">
                                <c:set var="staffMember" value="${subjectResultForm.idToSubjectTeacherMap[subjectTeacher.staffMemberId]}" />
                                <form:option value="${staffMember.staffMemberId}"><c:out value="${staffMember.firstnamesFull} ${staffMember.surnameFull}"/></form:option>
                            </c:forEach>
                        </form:select>
                    </td>
                    <td>
                        <form:errors path="subjectResult.staffMemberId" cssClass="error"/>
                    </td>
                </c:when>
                <c:otherwise>
                    <c:if test="${subjectResultAuthorization.read}">
                        <td>
                            <c:set var="staffMember" value="${subjectResultForm.idToSubjectTeacherMap[subjectResultForm.subjectResult.staffMemberId]}" />
                            <c:out value="${staffMember.firstnamesFull} ${staffMember.surnameFull}"/>
                        </td>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </tr>

        <tr>
            <td class="label"><fmt:message key="jsp.general.active" /></td>
            <c:choose>
                <c:when test="${subjectResultAuthorization.createOrUpdate}">
                    <td>
                        <form:select path="subjectResult.active">
                            <form:option value="Y"><fmt:message key="jsp.general.yes"/></form:option>
                            <form:option value="N"><fmt:message key="jsp.general.no"/></form:option>                    
                        </form:select>
                    </td>
                    <td>
                        <form:errors path="subjectResult.active" cssClass="error"/>
                    </td>
                </c:when>
                <c:otherwise>
                    <c:if test="${subjectResultAuthorization.read}">
                        <td>
                            <fmt:message key="${stringToYesNoMap[subjectResultForm.subjectResult.active]}"/>
                        </td>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </tr>
        
        <c:if test="${subjectResultAuthorization.createOrUpdate}">
            <tr>
                <td>&nbsp;</td>
            	<td align="right" colspan="2">
            	   <input type="submit" name="submitcardinaltimeunitresult" value="<fmt:message key='jsp.button.submit' />" />
            	</td>
            </tr>
        </c:if>

		<tr><td colspan="3">&nbsp;</td></tr>

		<!-- SUBJECT RESULT HISTORY -->
		<sec:authorize access="hasAnyRole('RESULT_HISTORY')">
	      <table class="tabledata2" id="TblData">
		    <tr>
		    	<th class="label"><fmt:message key="jsp.general.writewho"/></th>
		    	<th class="label"><fmt:message key="jsp.general.staffmember"/></th>
		    	<th class="label"><fmt:message key="jsp.general.operation"/></th>
		    	<th class="label"><fmt:message key="jsp.general.mark"/></th>
		    	<th class="label"><fmt:message key="jsp.general.passed"/></th>
		    	<th class="label"><fmt:message key="jsp.general.endgradecomment"/></th>
		    	<th class="label"><fmt:message key="jsp.general.writewhen"/></th>
		    </tr>
		    
		    <c:forEach var="history" items="${subjectResultForm.subjectResultHistories}">
		    	<tr>
		    		<td><c:out value="${history.writewho}"/></td>
		    		<td><c:out value="${history.firstnamesFull}
		    						  ${history.surnameFull}"/>
		    						  </td>
		    		<td><fmt:message key="general.history.operation.${fn:toLowerCase(history.operation)}" /></td>
		    		<td><c:out value="${history.mark}"/></td>
					<td><fmt:message key="general.history.passed.${fn:toLowerCase(history.passed)}" /></td>
					<td>
						<c:if test="${not empty history.subjectResultCommentId}">
		                	<fmt:message key="${subjectResultForm.idToSubjectResultCommentMap[history.subjectResultCommentId].commentKey}"/>
		                </c:if>
					</td>
		    		<td><fmt:formatDate type="both" dateStyle="medium" timeStyle="medium" value="${history.writewhen}" /></td>
		    	</tr>
		    </c:forEach>
	      </table>
	      <script type="text/javascript">alternate('TblData', false)</script>
	      <hr/>
	   </sec:authorize>

        <!-- EXAMINATIONS & RESULTS -->
        
        <tr>
           	<td class="label" colspan="3"><fmt:message key="jsp.general.active" /> <fmt:message key="jsp.general.examinations" /></td>
        </tr></br>
        <tr>
            <td colspan="3">
                <fmt:message key="general.percentagetotal" />:
                ${subjectResultForm.percentageTotal}
            </td>
        </tr>
        <c:choose>
            <c:when test="${subjectResultForm.percentageTotal ne 0 && subjectResultForm.percentageTotal ne 100}">       
                <tr>
                    <td align="left" colspan="3">
                        <p class="errorwide">
                            <fmt:message key="jsp.error.percentagetotal" />
                        </p>
                     </td>
                </tr>
            </c:when>
        </c:choose>

        <c:choose>
            <c:when test="${not empty subject.examinations}">
                <tr>
                    <td colspan="3">
                        <table>
                            <tr>
                                <th>&nbsp;</th>
                                <th><fmt:message key="jsp.general.weighingfactor" />
                                   <br />/<fmt:message key="jsp.general.resultdate" /></th>
                                <th style="width: 100px;"><fmt:message key="jsp.general.mark" /></th>
                                <th><fmt:message key="jsp.general.attemptnr" /></th>
                              <!--  <td class="label"><fmt:message key="jsp.general.active" /></td>-->
                                <th>&nbsp;</th>
                            </tr>
                            <c:forEach var="examination" items="${subject.examinations}">
                                <c:set var="numberOfAttempts" value="${examination.numberOfAttempts}" scope="page" />
                                <c:set var="examinationResultId" value="" scope="page" />
                                <c:set var="maxAttemptNr" value="0" scope="page" />

                                <tr>
                                    <td class="label">
                                      <c:out value="${examination.examinationCode}"/><br /><c:out value="(${examination.examinationDescription})"/>
                                    </td>
                                    <td class="label">
                                      <c:out value="${examination.weighingFactor}"/> %
                                    </td>
                                    <td colspan="5">&nbsp;</td>
                                </tr>

            					<%-- first count number of attempts made for display style --%>
                                <c:forEach var="examinationResult" items="${subjectResultForm.subjectResult.examinationResults}">
                                	<c:choose>
                                		<c:when test="${examinationResult.examinationId == examination.id}">
            								<c:set var="maxAttemptNr" value="${examinationResult.attemptNr}" scope="page" />
            							</c:when>
            						</c:choose>
            					</c:forEach>

            					<c:forEach var="examinationResult" items="${subjectResultForm.subjectResult.examinationResults}">
                                    <c:choose>
                                        <c:when test="${examinationResult.examinationId == examination.id}">
                                            <c:set var="examinationResultId" value="${examinationResult.id}" scope="page" />

                                            <c:set var="authorizationKey" value="${studyPlanDetail.id}-${examination.id}-${examinationResult.attemptNr}" />
                                            <c:set var="examinationResultAuthorization" value="${subjectResultForm.examinationResultAuthorizationMap[authorizationKey]}" scope="page" />

                                            <c:choose>
                                                <c:when test="${examinationResultAuthorization.update}">
                                                    <fmt:message var="linkText" key="result.edit"></fmt:message>
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:message var="linkText" key="result.view.details"></fmt:message>
                                                </c:otherwise>
                                            </c:choose>

                                            <c:if test="${examinationResultAuthorization.read}">
                								<c:choose>
                									<c:when test="${examinationResult.attemptNr != maxAttemptNr}"> 
                                                        <c:set var="examinationResultClass" value='class="grey"'/>
                                                	</c:when>
                                                	<c:otherwise>
                                                        <c:set var="testResultClass" value=''/>
                                                	</c:otherwise>
                                                </c:choose>
                                                <tr ${examinationResultClass}>
    
                                                    <td class="label">&nbsp;</td>
                                                    <td>
                                                        <fmt:formatDate pattern="dd/MM/yyyy" value="${examinationResult.examinationResultDate}" />
                                                    </td>
                                                    <td>
                                                        <c:out value="${examinationResult.mark}"/>
                                                    </td>
                                                    <td>
                                                        <c:out value="${examinationResult.attemptNr}"/>
                                                    </td>
                                                    <%-- 
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${'Y' == examinationResult.active}">
                                                                <fmt:message key="jsp.general.yes" />
                                                            </c:when>
                                                            <c:otherwise>
                                                               <fmt:message key="jsp.general.no" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td> --%>
                                                    <td class="buttonsCell">
                                                        <c:if test="${examinationResultAuthorization.read or examinationResultAuthorization.update}">
                                                    		<a class="imageLink" href="<c:url value='/college/examinationresult.view?newForm=true&amp;examinationResultId=${examinationResultId}&amp;studyPlanDetailId=${studyPlanDetail.id}&amp;subjectResultId=${subjectResultId}&amp;studentId=${student.studentId}&amp;subjectId=${subject.id}&amp;currentPageNumber=${currentPageNumber}&amp;tab=${tab}&amp;panel=${panel}'/>">
                                                       			<img src="<c:url value='/images/edit.gif'/>" alt="${linkText}" title="${linkText}" />
                                                       		</a>
                                                        </c:if>
                                                        <c:if test="${examinationResultAuthorization.delete}">
                                                           	<a class="imageLinkPaddingLeft" href="<c:url value='/college/subjectresult/delete.view?newForm=true&amp;examinationResultId=${examinationResultId}&amp;studyPlanDetailId=${studyPlanDetail.id}&amp;subjectResultId=${subjectResultId}&amp;studentId=${student.studentId}&amp;subjectId=${subject.id}&amp;currentPageNumber=${currentPageNumber}&amp;tab=${tab}&amp;panel=${panel}'/>"
                                                                onclick="return confirm('<fmt:message key="jsp.examinationresult.delete.confirm" />')"><img src="<c:url value='/images/delete.gif'/>" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                        	</a>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:when>
                                    </c:choose>

                                </c:forEach>
                                <tr>
                                <td colspan="5">&nbsp;</td>
                                    <td class="buttonsCell">

                                        <c:set var="authorizationKey" value="${studyPlanDetail.id}-${examination.id}-${maxAttemptNr + 1}" />
                                        <c:set var="examinationResultAuthorization" value="${subjectResultForm.examinationResultAuthorizationMap[authorizationKey]}" scope="page" />
                                        <c:if test="${examinationResultAuthorization.create}">
                                            <a class="button" href="<c:url value='/college/examinationresult.view?newForm=true&amp;examinationId=${examination.id}&amp;studyPlanDetailId=${studyPlanDetail.id}&amp;subjectResultId=${subjectResultId}&amp;studentId=${student.studentId}&amp;subjectId=${subject.id}&amp;currentPageNumber=${currentPageNumber}&amp;tab=${tab}&amp;panel=${panel}'/>"><fmt:message key="jsp.href.add" /></a>
                                        </c:if>
                                    </td>
                                 </tr>
                            </c:forEach>
                        </table>
                    </td>
                </tr>

            </c:when>
        </c:choose>

    </table>
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
    //tp1.showPanel(<%//=request.getParameter("tab")%>);
    tp1.showPanel(0);
</script>
</div>

<%@ include file="../../footer.jsp"%>

