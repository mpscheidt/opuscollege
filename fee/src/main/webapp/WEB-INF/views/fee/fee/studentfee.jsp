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

The Original Code is Opus-College fee module code.

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

<%--
 * Copyright (c) 2007 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
--%>

<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>
    
    <c:set var="studyPlanCTUs" value="" scope="page" />
    <c:set var="studyPlanDetails" value="" scope="page" />
    
    <spring:bind path="studentFeeForm.existingStudentFees">
        <c:set var="existingStudentFees" value="${status.value}" />
    </spring:bind>
    
    <spring:bind path="studentFeeForm.possibleSubjectStudentFees">
        <c:set var="possibleSubjectStudentFees" value="${status.value}" />
    </spring:bind>
    
    <spring:bind path="studentFeeForm.possibleSubjectBlockStudentFees">
        <c:set var="possibleSubjectBlockStudentFees" value="${status.value}" />
    </spring:bind>
    
    <spring:bind path="studentFeeForm.possibleStudyGradeTypeStudentFees">
        <c:set var="possibleStudyGradeTypeStudentFees" value="${status.value}" />
    </spring:bind>
    
    <spring:bind path="studentFeeForm.possibleEducationAreaFees">
        <c:set var="possibleEducationAreaFees" value="${status.value}" />
    </spring:bind>
    
    <spring:bind path="studentFeeForm.allStudyForms">
        <c:set var="allStudyForms" value="${status.value}" />
    </spring:bind>
    
    <spring:bind path="studentFeeForm.allStudyTimes">
        <c:set var="allStudyTimes" value="${status.value}" />
    </spring:bind>
    
    <spring:bind path="studentFeeForm.allAcademicYears">
        <c:set var="allAcademicYears" value="${status.value}" />
    </spring:bind>
    
    <spring:bind path="studentFeeForm.allFeeCategories">
        <c:set var="allFeeCategories" value="${status.value}" />
    </spring:bind>
    
    <spring:bind path="studentFeeForm.allFeeUnits">
        <c:set var="allFeeUnits" value="${status.value}" />
    </spring:bind>    
    
    <spring:bind path="studentFeeForm.student">
        <c:set var="student" value="${status.value}" />
    </spring:bind>
    
    <spring:bind path="studentFeeForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" />
    </spring:bind>
    
    <div id="tabcontent">
    
        <form name="formdata" method="POST"> 
            <fieldset>
                <legend>
                    <a href="<c:url value='/fee/paymentsstudents.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>
                    &nbsp;>&nbsp;
                    <c:choose>
                        <c:when test="${student.surnameFull != null && student.surnameFull != ''}" >
                            <c:set var="studentLastname" value="${student.surnameFull}" scope="page" />
                            <c:set var="studentFirstname" value="${student.firstnamesFull}" scope="page" />
                            <c:set var="studentName" value="${studentLastname}, ${studentFirstname}" scope="page" />
                            <a href="<c:url value='/fee/paymentsstudent.view?studentId=${student.studentId}&tab=${navigationSettings.tab}&panel=${navigationSettings.panel}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                <c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}" />
                            </a>
                        </c:when>
                    </c:choose>
                    &nbsp;>&nbsp;
                </legend>

                <!-- STUDYPLANS -->
                <table>
                    <tr>
                        <td colspan="3">
                             <input type="hidden" name="submitFormObject" id="submitFormObject" value="" />
                        </td>
                    </tr>
                    <tr>
                        <spring:bind path="studentFeeForm.studyPlan.id">
                            <td class="label"><fmt:message key="jsp.general.studyplan" /></td>
                            <td>
                                <select name="${status.expression}" id="${status.expression}" onchange="document.formdata.submit();">
                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                    <c:forEach var="oneStudyPlan" items="${studentFeeForm.studyPlans}">
                                        <c:choose>
                                            <c:when test="${oneStudyPlan.id == status.value}">
                                                <option value="${oneStudyPlan.id}" selected="selected">${oneStudyPlan.studyPlanDescription}</option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="${oneStudyPlan.id}">${oneStudyPlan.studyPlanDescription}</option>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </select>
                            </td>
                            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                        </spring:bind>
                    </tr>
                </table>
            </fieldset>

            <div id="tp1" class="TabbedPanel">
                <ul class="TabbedPanelsTabGroup">
                    <li class="TabbedPanelsTab"><fmt:message key="jsp.menu.fees" /></li>               
                </ul>

            <div class="TabbedPanelsContentGroup">
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion0" tabindex="0">
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.menu.fees" /></div>
                            <div class="AccordionPanelContent">
 
                            <%@ include file="../../includes/pagingHeader.jsp"%>
                            
                            <table>
                                <tr>
                                    <td class="header"><fmt:message key="jsp.menu.fees.studygradetype" /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table class="tabledata2" id="TblData_feesstudygradetype">
                                        
                                        <!--  StudyGradeType --> 
                                                            
                                        <tr>
                                            <th width="3" class="label"></th>
                                            <th class="label"><fmt:message key="jsp.general.studygradetype" /></th>                                        
                                            <th class="label"><fmt:message key="jsp.general.studyform" /></th> 
                                            <th class="label"><fmt:message key="jsp.general.studytime" /></th>      
                                            <th class="label"><fmt:message key="jsp.general.feedue" /></th>
                                            <th class="label"><fmt:message key="general.deadlines" /></th>
                                            <th class="label"><fmt:message key="jsp.fees.category" /></th>
                                            <c:if test="${modules != null && modules != ''}">
                                                    <c:forEach var="module" items="${modules}">
                                                        <c:if test="${module.module eq 'accommodation'}">
                                                         <th class="label"><fmt:message key="jsp.general.accommodationfee" /></th>
                                                       </c:if>
                                               </c:forEach>
                                            </c:if>
                                            <th class="label"><fmt:message key="jsp.general.active" /></th>
                                        </tr>
                                            
                                        <c:forEach var="possibleStudyGradeTypeFee" items="${possibleStudyGradeTypeStudentFees}" varStatus="row">
                                           
                                            <c:set var="disabled" value="" scope="page"/>
                                            <c:forEach var="existingFee" items="${existingStudentFees}">
                                                <c:if test="${possibleStudyGradeTypeFee.id == existingFee.id }">
                                                    <c:set var="disabled" value="disabled"  scope="page"/>
                                                </c:if>
                                            </c:forEach>
                                            <!-- don't show the fee if it is already linked to the student -->
                                            <c:if test="${disabled == '' }">
                                            <tr>
                                                <td><input type="checkbox" name="possibleStudyGradeTypeFee" id="possibleStudyGradeTypeFee" value="${possibleStudyGradeTypeFee.id }"></td>
                                                <td>    
                                                    <c:forEach var="studyGradeType" items="${studentFeeForm.allStudyGradeTypes}">
                                                        <c:choose>
                                                            <c:when test="${studyGradeType.id == possibleStudyGradeTypeFee.studyGradeTypeId}">
                                                                ${studyGradeType.gradeTypeDescription}
                                                                <c:forEach var="academicYear" items="${allAcademicYears}">
                                                                    <c:choose>
                                                                        <c:when test="${academicYear.id != 0
                                                                                      && academicYear.id == studyGradeType.currentAcademicYearId}">
                                                                            &nbsp;(${academicYear.description})
                                                                        </c:when>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </c:when>
                                                        </c:choose>
                                                    </c:forEach>
                                                </td>
                                                <td>   
                                                    <c:forEach var="studyGradeType" items="${studentFeeForm.allStudyGradeTypes}">
                                                        <c:choose>
                                                            <c:when test="${studyGradeType.id == possibleStudyGradeTypeFee.studyGradeTypeId}">
                                                                <c:forEach var="studyForm" items="${allStudyForms}">
                                                                    <c:choose>
                                                                        <c:when test="${studyForm.code == studyGradeType.studyFormCode}">
                                                                            ${studyForm.description}
                                                                        </c:when>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </c:when>
                                                        </c:choose>
                                                    </c:forEach>
                                                </td>
                                                <td>
                                                    <c:forEach var="studyGradeType" items="${studentFeeForm.allStudyGradeTypes}">
                                                        <c:choose>                                                 
                                                            <c:when test="${studyGradeType.id == possibleStudyGradeTypeFee.studyGradeTypeId}">  
                                                                <c:forEach var="studyTime" items="${allStudyTimes}">
                                                                    <c:choose>
                                                                        <c:when test="${studyTime.code == studyGradeType.studyTimeCode}">
                                                                            ${studyTime.description}
                                                                        </c:when>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </c:when>
                                                        </c:choose>
                                                    </c:forEach>
                                                </td>
                                                <td>
                                                    ${possibleStudyGradeTypeFee.feeDue}
                                                </td>
                                                <td>
                                                    <c:forEach items="${possibleStudyGradeTypeFee.deadlines}" var="feeDeadline">
                                              			 <fmt:formatDate pattern="dd/MM/yyyy" value="${feeDeadline.deadline}" />
                                                  			<br/>
                                               		</c:forEach>
                                                </td>
                                                <td>
                                                    <c:forEach var="feeCategory" items="${allFeeCategories}">
                                                        <c:if test="${feeCategory.code == possibleStudyGradeTypeFee.categoryCode}">
                                                            ${feeCategory.description}
                                                        </c:if>                                                 
                                                    </c:forEach>
                                                </td>
    
                                                <c:if test="${modules != null && modules != ''}">
                                                    <c:forEach var="module" items="${modules}">
                                                        <c:if test="${module.module eq 'accommodation'}">
                                                            <td>
                                                                <c:forEach var="accommodationFee" items="${allAccommodationFees}">
                                                                    <c:if test="${accommodationFee.id == feeForSubjectStudyGradeType.accommodationFeeId}">
                                                                        ${accommodationFee.description}
                                                                    </c:if>
                                                                </c:forEach>
                                                            </td>
                                                        </c:if>
                                                    </c:forEach>
                                                </c:if>
                                                <td>
                                                    ${possibleStudyGradeTypeFee.active}
                                                </td>
                                            </tr>
                                            </c:if>
                                        </c:forEach>
                                        <tr><th colspan="4">&nbsp;</th></tr> 
                                        </table>
                                        <script type="text/javascript">alternate('TblData_feesstudygradetype',true)</script>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="header">
                                        <fmt:message key="jsp.menu.fees.subject" />
                                        <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                                            &nbsp;<fmt:message key="jsp.general.and" />&nbsp;<fmt:message key="jsp.general.subjectblocks" />
                                        </c:if>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <!--  fees on subjects and subjectblocks -->
                                        <table class="tabledata2" id="TblData_feessubjectblock">

                                        <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                                        
                                            <!--  SUBJECTBLOCKS --> 
        
                                            <tr>
                                                <th width="3" class="label"></th>
                                                <th class="label"><fmt:message key="jsp.general.subjectblocks" /></th>
                                                <th class="label"><fmt:message key="jsp.general.studygradetype" /></th>                                        
                                                <th class="label"><fmt:message key="jsp.general.studyform" /></th> 
                                                <th class="label"><fmt:message key="jsp.general.studytime" /></th>
                                                <th class="label"><fmt:message key="jsp.general.cardinaltimeunit.number" /></th>       
                                                <th class="label"><fmt:message key="jsp.general.feedue" /></th>
                                                <th class="label"><fmt:message key="general.deadlines" /></th>
                                                <th class="label"><fmt:message key="jsp.general.active" /></th>
                                            </tr>
                                            
                                            <c:forEach var="possibleSubjectBlockFee" items="${possibleSubjectBlockStudentFees}" varStatus="row">
                                                <c:set var="disabled" value="" scope="page"/>
                                                <c:forEach var="existingFee" items="${existingStudentFees}">
                                                    <c:if test="${possibleSubjectBlockFee.id == existingFee.id }">
                                                        <c:set var="disabled" value="disabled"  scope="page"/>
                                                    </c:if>
                                                </c:forEach>
                                                <!-- don't show the fee if it is already linked to the student -->
                                                <c:if test="${disabled == '' }">
                                                <tr>
                                                    <td><input type="checkbox" name="possibleSubjectBlockFee" id="possibleSubjectBlockFee" value="${possibleSubjectBlockFee.id }"></td>
                                                    <c:forEach var="subjectBlockStudyGradeType" items="${studentFeeForm.allSubjectBlockStudyGradeTypes}">
                                                        <c:choose>
                                                            <c:when test="${subjectBlockStudyGradeType.studyGradeType.id == possibleSubjectBlockFee.studyGradeTypeId
                                                                && subjectBlockStudyGradeType.subjectBlock.id == possibleSubjectBlockFee.subjectBlockId}">
                                                                <td>
                                                                    ${subjectBlockStudyGradeType.subjectBlock.subjectBlockDescription}
                                                                    <c:forEach var="academicYear" items="${allAcademicYears}">
                                                                        <c:choose>
                                                                            <c:when test="${academicYear.id != 0
                                                                                  && academicYear.id == subjectBlockStudyGradeType.subjectBlock.currentAcademicYearId}">
                                                                                &nbsp;(${academicYear.description})
                                                                            </c:when>
                                                                        </c:choose>
                                                                    </c:forEach>
                                                                </td>
                                                                <td>
<%-- TODO: gradeTypeDescription needs to be replaced by codeToLookupMap, because it is not filled anymore, see subjectblock.jsp for example --%>
                                                                    ${subjectBlockStudyGradeType.studyGradeType.gradeTypeDescription}
                                                                </td>
                                                                <td>
                                                                    <c:forEach var="studyForm" items="${allStudyForms}">
                                                                        <c:if test="${studyForm.code == subjectBlockStudyGradeType.studyGradeType.studyFormCode}">
                                                                            ${studyForm.description}
                                                                        </c:if>
                                                                    </c:forEach>
                                                                </td>
                                                                <td>
                                                                    <c:forEach var="studyTime" items="${allStudyTimes}">
                                                                        <c:if test="${studyTime.code == subjectBlockStudyGradeType.studyGradeType.studyTimeCode}">
                                                                            ${studyTime.description}
                                                                        </c:if>
                                                                    </c:forEach>
                                                                </td>
                                                                <td> 
                                                                    ${subjectBlockStudyGradeType.cardinalTimeUnitNumber}
                                                                </td>
                                                            </c:when>
                                                        </c:choose>
                                                    </c:forEach>
                                                    <td>
                                                        ${possibleSubjectBlockFee.feeDue}
                                                    </td>
                                                    <td style="text-align: center">
                                                     <c:forEach items="${possibleSubjectBlockFee.deadlines}" var="feeDeadline">
                                                    	<fmt:formatDate pattern="dd/MM/yyyy" value="${feeDeadline.deadline}" />
                                                    	<br/>
                                                   </c:forEach>
                                                    </td>
                                                    <td>
                                                        ${possibleSubjectBlockFee.active}
                                                    </td>
                                                </tr>
                                                </c:if>
                                            </c:forEach>
                                            <tr><th colspan="4">&nbsp;</th></tr> 
                                        </c:if>
                                        </table>
                                        <script type="text/javascript">alternate('TblData_feessubjectblock',true)</script>
                                        </td></tr>
                                        <!--  SUBJECTS -->
                                        <tr>
                                    <td>
                                        <table class="tabledata2" id="TblData_feessubject">
                                            <tr>
                                                <th width="3" class="label"></th>
                                                <th class="label"><fmt:message key="jsp.general.subjects" /></th>
                                                <th class="label"><fmt:message key="jsp.general.studygradetype" /></th>                                        
                                                <th class="label"><fmt:message key="jsp.general.studyform" /></th> 
                                                <th class="label"><fmt:message key="jsp.general.studytime" /></th>
                                                <th class="label"><fmt:message key="jsp.general.cardinaltimeunit.number" /></th>                                                                                     
                                                <th class="label"><fmt:message key="jsp.general.feedue" /></th>
                                                <th class="label"><fmt:message key="general.deadlines" /></th>
                                                <th class="label"><fmt:message key="jsp.general.active" /></th>
                                            </tr>
                                            <c:forEach var="possibleSubjectFee" items="${possibleSubjectStudentFees}" varStatus="row">
                                                <c:set var="disabled" value="" scope="page"/>
                                                <c:forEach var="existingFee" items="${existingStudentFees}">
                                                    <c:if test="${possibleSubjectFee.id == existingFee.id }">
                                                        <c:set var="disabled" value="disabled"  scope="page"/>
                                                    </c:if>
                                                </c:forEach>
                                                
                                                <!-- don't show the fee if it is already linked to the student -->
                                                <c:if test="${disabled == '' }">
                                                    <tr>
                                                        <td><input type="checkbox" name="possibleSubjectFee" id="possibleSubjectFee" value="${possibleSubjectFee.id }"></td>
                                                        <c:forEach var="subjectStudyGradeType" items="${studentFeeForm.allSubjectStudyGradeTypes}">
                                                            <c:choose>
                                                                <c:when test="${subjectStudyGradeType.studyGradeType.id == possibleSubjectFee.studyGradeTypeId
                                                                            && subjectStudyGradeType.subject.id == possibleSubjectFee.subjectId}">
                                                                    <td>
                                                                        ${subjectStudyGradeType.subject.subjectDescription}
                                                                        <c:forEach var="academicYear" items="${allAcademicYears}">
                                                                            <c:choose>
                                                                                <c:when test="${academicYear.id != 0
                                                                                        && academicYear.id == subjectStudyGradeType.subject.currentAcademicYearId}">
                                                                                    &nbsp;(${academicYear.description})
                                                                                </c:when>
                                                                            </c:choose>
                                                                        </c:forEach>
                                                                    </td>
                                                                    <td>
<%-- TODO: gradeTypeDescription needs to be replaced by codeToLookupMap, because it is not filled anymore, see subject.jsp for example --%>
                                                                        ${subjectStudyGradeType.studyGradeType.gradeTypeDescription}
                                                                    </td>
                                                                    <td>
                                                                        <c:forEach var="studyForm" items="${allStudyForms}">
                                                                            <c:choose>
                                                                                <c:when test="${studyForm.code == subjectStudyGradeType.studyGradeType.studyFormCode}">
                                                                                    ${studyForm.description}
                                                                                </c:when>
                                                                            </c:choose>
                                                                        </c:forEach>
                                                                    </td>
                                                                    <td>
                                                                        <c:forEach var="studyTime" items="${allStudyTimes}">
                                                                            <c:choose>
                                                                                <c:when test="${studyTime.code == subjectStudyGradeType.studyGradeType.studyTimeCode}">
                                                                                    ${studyTime.description}
                                                                                </c:when>
                                                                            </c:choose>
                                                                        </c:forEach>
                                                                    </td>
                                                                    <td>
                                                                        ${subjectStudyGradeType.cardinalTimeUnitNumber}
                                                                    </td>
                                                                </c:when>
                                                            </c:choose>
                                                        </c:forEach>       
                                                        <td>
                                                            ${possibleSubjectFee.feeDue}
                                                        </td>
                                                        <td>
                                                            <c:forEach items="${possibleSubjectFee.deadlines}" var="feeDeadline">
                                              			 		<fmt:formatDate pattern="dd/MM/yyyy" value="${feeDeadline.deadline}" />
                                                  				<br/>
                                               				</c:forEach>
                                                        </td>
                                                        <td>
                                                            ${possibleSubjectFee.active}
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </c:forEach>
                                            <tr><td colspan="4"></td></tr>
                                        </table>
                                        <script type="text/javascript">alternate('TblData_feessubject',true)</script>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="header">
                                        <fmt:message key="jsp.menu.fees.branches" />
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td>
                                        <table class="tabledata2" id="TblData_feeseducationarea">
                                            <tr>
                                                <th width="3" class="label">&nbsp;</th>
                                                <th><fmt:message key="jsp.general.category" /></th>
                                                <th><fmt:message key="jsp.general.academicyear" /></th>
                                                <th><fmt:message key="jsp.general.feedue" /></th>
                                                <th><fmt:message key="jsp.fee.feeunit" /></th>
                                                <th><fmt:message key="jsp.general.cardinaltimeunit" /></th>
                                                <th><fmt:message key="jsp.general.active" /></th>
                                                <th colspan="2">&nbsp;</th>
                                            </tr>
                                            <c:forEach var="possibleEducationAreaFee" items="${possibleEducationAreaFees}" varStatus="row">
                                                <c:set var="disabled" value="" scope="page"/>
                                                <c:forEach var="existingFee" items="${existingStudentFees}">
                                                    <c:if test="${possibleEducationAreaFee.id == existingFee.id }">
                                                        <c:set var="disabled" value="disabled"  scope="page"/>
                                                    </c:if>
                                                </c:forEach>
                                                
                                                <!-- don't show the fee if it is already linked to the student -->
                                                <c:if test="${disabled == '' }">
                                                    <tr>
                                                        <td><input type="checkbox" name="possibleEducationAreaFee" id="possibleEducationAreaFee" value="${possibleEducationAreaFee.id }"></td>
                                                        <td>
                                                            <c:forEach var="category" items="${allFeeCategories}">
                                                                <c:choose>
                                                                    <c:when test="${category.code == possibleEducationAreaFee.categoryCode}">
                                                                        ${category.description}
                                                                     </c:when>
                                                                </c:choose>
                                                            </c:forEach>       
                                                        </td>
                                                       
                                                        <td>
                                                           <c:forEach var="academicYear" items="${allAcademicYears}">
                                                                <c:choose>
                                                                    <c:when test="${possibleEducationAreaFee.academicYearId == academicYear.id}">
                                                                        ${academicYear.description}
                                                                     </c:when>
                                                                </c:choose>
                                                            </c:forEach>            
                                                        </td>
                                                        <td>${possibleEducationAreaFee.feeDue}</td>
                                                         <td>
                                                            <c:forEach var="feeUnit" items="${allFeeUnits}">
                                                                <c:choose>
                                                                    <c:when test="${feeUnit.code == possibleEducationAreaFee.feeUnitCode}">
                                                                        ${feeUnit.description}
                                                                     </c:when>
                                                                </c:choose>
                                                            </c:forEach>       
                                                        </td>
                                                        <td>${possibleEducationAreaFee.cardinalTimeUnitNumber }</td>
                                                        <td>${possibleEducationAreaFee.active}</td>
                                                        <td colspan="2">&nbsp;</td>
                                                    </tr>
                                                </c:if>
                                            </c:forEach>                                                
                                        </table>
                                        <script type="text/javascript">alternate('TblData_feeseducationarea',true)</script>
                                    </td>
                                </tr>
                                <!-- SUBMIT BUTTON -->
                                <tr>
                                    <td>
                                        <input type="button" name="submitformdata" value="<fmt:message key="jsp.button.submit" />" onclick="document.getElementById('submitFormObject').value='true';document.formdata.submit();" />
                                    </td>
                                </tr>
                            </table>
                              
                            <!--  einde accordionpanelcontent -->
                            </div>
                        <!--  einde accordionpanel -->
                        </div>
                    
                    <!-- end of accordion 1 -->
                    </div>
                    <script type="text/javascript">
                        var Accordion0 = new Spry.Widget.Accordion("Accordion0",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });
                    </script>
                <!--  end tabbedpanelscontent -->
                </div>
            <!--  end tabbed panelscontentgroup -->    
            </div>
        <!--  end tabbed panel -->    
        </div>
        </form>
    <!-- end tabcontent -->
    </div>   
    
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(<%=request.getParameter("tab")%>);
        Accordion<%=request.getParameter("tab")%>.defaultPanel = <%=request.getParameter("panel")%>;
        Accordion<%=request.getParameter("tab")%>.openPanelNumber(<%=request.getParameter("panel")%>);
    </script>
   
<!-- einde tabwrapper -->    
</div>

<%@ include file="../../footer.jsp"%>

