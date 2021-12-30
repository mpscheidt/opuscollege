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

<c:set var="screentitlekey">jsp.general.studyplanoverview</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

<%@ include file="../../menu.jsp"%>

<!-- necessary spring binds for organization and navigationSettings regarding form handling through includes -->
<c:set var="organization" value="${studyPlanForm.organization}" scope="page" />
<c:set var="navigationSettings" value="${studyPlanForm.navigationSettings}" scope="page" />

<%--  page vars --%>
<c:set var="personId" value="${studyPlanForm.student.personId}" scope="page" />
<c:set var="studyPlan" value="${studyPlanForm.studyPlan}" scope="page" />
<c:set var="studyPlanStatusCode" value="${studyPlanForm.studyPlan.studyPlanStatusCode}" scope="page" />
<c:set var="student" value="${studyPlanForm.student}" scope="page" />
<c:set var="allObtainedQualifications" value="${studyPlanForm.studyPlan.allObtainedQualifications}" scope="page" />
<c:set var="allCareerPositions" value="${studyPlanForm.studyPlan.allCareerPositions}" scope="page" />
<c:set var="allReferees" value="${studyPlanForm.studyPlan.allReferees}" scope="page" />
<c:set var="thesis" value="${studyPlanForm.studyPlan.thesis}" scope="page" />
<c:set var="studyPlanGradeTypeCode" value="${studyPlanForm.studyPlan.gradeTypeCode}" scope="page" />
<c:set var="secondarySchoolSubjectGroups" value="${studyPlanForm.studyPlan.secondarySchoolSubjectGroups}" scope="page" />
<c:set var="gradedSecondarySchoolSubjects" value="${studyPlanForm.studyPlan.gradedSecondarySchoolSubjects}" scope="page" />
<c:set var="ungroupedSecondarySchoolSubjects" value="${studyPlanForm.studyPlan.ungroupedSecondarySchoolSubjects}" scope="page" />

<%-- "form" variable used in include --%>
<c:set var="form" value="${studyPlanForm}" scope="page" />

<!-- authorizations -->
<sec:authorize access="hasAnyRole('UPDATE_STUDENT_SUBSCRIPTION_DATA','CREATE_STUDENT_SUBSCRIPTION_DATA')">
    <c:set var="editSubscriptionData" value="${true}"/>
</sec:authorize>
<c:if test="${not editSubscriptionData}">
    <sec:authorize access="hasRole('READ_STUDENT_SUBSCRIPTION_DATA') or ${personId == opusUser.personId}">
        <c:set var="showSubscriptionData" value="${true}"/>
    </sec:authorize>
</c:if>
<sec:authorize access="hasRole('REVERSE_PROGRESS_STATUS')">
    <c:set var="reverseProgressStatus" value="${true}"/>
</sec:authorize>            

<div id="tabcontent">

<form>
    <fieldset>
        <legend>
            <a href="<c:url value='/college/students.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.students.header" /></a>&nbsp;&gt;
            <a href="<c:url value='/college/student/subscription.view'/>?<c:out value='newForm=true&tab=2&panel=0&studentId=${student.studentId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
            <c:choose>
                <c:when test="${not empty student.surnameFull}" >
                    <c:set var="studentName" value="${fn:trim(student.studentCode)} ${fn:trim(student.surnameFull)}, ${fn:trim(student.firstnamesFull)}" scope="page" />
                    <c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}"/>
                </c:when>
                <c:otherwise>
                    <fmt:message key="jsp.href.new" />
                </c:otherwise>
            </c:choose>
            </a>
            &nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.studyplans" /> 
        </legend>
        
        <form:errors path="studyPlanForm.*" cssClass="errorwide" element="p"/>

        <c:choose>        
            <c:when test="${ not empty studyPlanForm.txtMsg }">       
               <p align="right" class="msg">
                    <c:out value="${studyPlanForm.txtMsg}"/>
               </p>
            </c:when>
        </c:choose>
        <c:choose>        
            <c:when test="${ not empty showTxtMsg }">       
               <p align="right" class="msg">
                    <c:out value="${showTxtMsg}"/>
               </p>
            </c:when>
        </c:choose>

    </fieldset>
</form>


<div id="tp1" class="TabbedPanel">
<ul class="TabbedPanelsTabGroup">
    <li class="TabbedPanelsTab compulsoryTab"><fmt:message key="jsp.general.general" /></li>               
    <li class="TabbedPanelsTab"><fmt:message key="jsp.general.studyplancardinaltimeunits" /></li>               
</ul>

<div class="TabbedPanelsContentGroup">

<%-- --------------------- General tab --------------------- --%>
<div class="TabbedPanelsContent">
<div class="Accordion" id="Accordion0" tabindex="0">
<div class="AccordionPanel">
<div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.general.studyplan" /></div>
<div class="AccordionPanelContent">

   <form name="formdata" method="post">
	<input type="hidden" name="submitFormObject" id="submitFormObject" value="" />
    <input type="hidden" name="tab" value="0" /> 
    <input type="hidden" name="panel" value="0" />
                                       	
    <table>
		
<%--		 <!--  APPPLICATION NUMBER -->
        <c:if test="${opusInit.iApplicationNumber == 'Y'}">
            <tr>
                <td class="label"><b><fmt:message key="jsp.general.applicationnumber" /></b></td>
                <spring:bind path="studyPlanForm.studyPlan.applicationNumber">
                <td width="273">
                    <c:if test="${editSubscriptionData}">
                        <input type="text" name="${status.expression}" size="10" maxlength="25" value="<c:out value="${status.value}" />" />
                    </c:if>
                    <c:if test="${showSubscriptionData}">
                        ${status.value}
                    </c:if>
                </td>
                <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                </spring:bind>
            </tr>
        </c:if> --%>

        <!--  STUDY PLAN DESCRIPTION -->
        <tr>
            <td class="label"><b><fmt:message key="jsp.general.description" /></b></td>
            <spring:bind path="studyPlanForm.studyPlan.studyPlanDescription">
            <td width="273" >
                <c:if test="${editSubscriptionData}">
                    <input type="text" name="${status.expression}" size="50" maxlength="255" value="<c:out value="${status.value}" />" />
                </c:if>
            </td>
            <c:if test="${showSubscriptionData}">
                <c:out value="${status.value}"/>
            </c:if>
            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
            </spring:bind>
        </tr>

        <!-- APPLICANT CATEGORY -->
         <spring:bind path="studyPlanForm.studyPlan.applicantCategoryCode">
            <tr>
                <td class="label"><b><fmt:message key="jsp.general.applicantcategory" /></b></td>
                <td>
                    <c:if test="${editSubscriptionData}">
                        <select name="${status.expression}" id="${status.expression}">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="oneApplicantCategory" items="${studyPlanForm.allApplicantCategories}">
                            <c:choose>
                                <c:when test="${oneApplicantCategory.code == status.value}">
                                    <option value="${oneApplicantCategory.code}" selected="selected"><c:out value="${oneApplicantCategory.description}"/></option>
                                </c:when>
                                <c:otherwise>
                                    <option value="${oneApplicantCategory.code}"><c:out value="${oneApplicantCategory.description}"/></option>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        </select>
                    </c:if>
                    <c:if test="${showSubscriptionData}">
                        <c:forEach var="oneApplicantCategory" items="${studyPlanForm.allApplicantCategories}">
                        <c:if test="${oneApplicantCategory.code == status.value}">
                            <c:out value="${oneApplicantCategory.description}"/>
                        </c:if>
                        </c:forEach>
                    </c:if>
                </td> 
                <td>
                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                </td>
            </tr>
    	</spring:bind>

        <!--  STUDY ID / MAJOR ID -->

        <tr><td class="label">
            <c:choose>
                <c:when test="${initParam.iMajorMinor == 'Y'}">
                <fmt:message key="jsp.general.major" /> / <fmt:message key="jsp.general.minor" />
                </c:when>
                <c:otherwise>
                    <fmt:message key="jsp.general.study" />
                </c:otherwise>
            </c:choose>
            </td>
            <spring:bind path="studyPlanForm.studyPlan.studyId">
            <td class="required">
            <c:if test="${editSubscriptionData}">
            <select name="${status.expression}">
                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                
                <c:forEach var="oneStudy" items="${studyPlanForm.allStudies}">
                    <c:set var="optionText"><c:out value="${oneStudy.studyDescription} (${studyPlanForm.idToOrganizationalUnitMap[oneStudy.organizationalUnitId].organizationalUnitDescription})"/></c:set>
                    <c:choose>
                        <c:when test="${oneStudy.id == status.value}">
                            <option value="${oneStudy.id}" selected="selected" title="${optionText}">
                            <c:set var="chosenStudyId" value="${oneStudy.id}" scope="page" />
                        </c:when>
                        <c:otherwise>
                            <option value="${oneStudy.id}" title="${optionText}">
                        </c:otherwise>
                    </c:choose>
                    ${optionText}
                    </option>
                </c:forEach>
            </select>
            </c:if>
            <c:if test="${showSubscriptionData}">
                <c:set var="oneStudy" value="${form.idToStudyMap[form.studyPlan.studyId]}" />
                <c:out value="${oneStudy.studyDescription} (${studyPlanForm.idToOrganizationalUnitMap[oneStudy.organizationalUnitId].organizationalUnitDescription})"/>
<%--                 <c:forEach var="oneStudy" items="${studyPlanForm.allStudies}"> --%>
<%--                     <c:set var="optionText"><c:out value="${oneStudy.studyDescription} (${studyPlanForm.idToOrganizationalUnitMap[oneStudy.organizationalUnitId].organizationalUnitDescription})"/></c:set> --%>
<%--                     <c:if test="${oneStudy.id == status.value}"> --%>
<%--                         ${optionText} --%>
<%--                     </c:if> --%>
<%--                 </c:forEach> --%>
            </c:if>
            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
            </td> 
            </spring:bind>
            <!--  MINOR ID -->
            <td>
                <c:choose>
                    <c:when test="${initParam.iMajorMinor == 'Y'}">
                    <spring:bind path="studyPlanForm.studyPlan.minor1Id">
                        <c:if test="${editSubscriptionData}">
                            <select name="${status.expression}">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                
                                <c:forEach var="oneStudy" items="${studyPlanForm.allStudies}">
                                    <c:set var="optionText"><c:out value="${oneStudy.studyDescription} (${studyPlanForm.idToOrganizationalUnitMap[oneStudy.organizationalUnitId].organizationalUnitDescription})"/></c:set>
                                    <c:choose>
                                        <c:when test="${oneStudy.id == status.value}">
                                            <option value="${oneStudy.id}" selected="selected">${optionText}</option>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="${oneStudy.id}">${optionText}</option>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </select>
                        </c:if>
                        <c:if test="${showSubscriptionData}">
                            <c:set var="oneStudy" value="${form.idToStudyMap[form.studyPlan.minor1Id]}" />
                            <c:out value="${oneStudy.studyDescription} (${studyPlanForm.idToOrganizationalUnitMap[oneStudy.organizationalUnitId].organizationalUnitDescription})"/>
<%--                             <c:forEach var="oneStudy" items="${studyPlanForm.allStudies}"> --%>
<%--                                 <c:if test="${oneStudy.id == status.value}"> --%>
<%--                                     <c:out value="${oneStudy.studyDescription} (${studyPlanForm.idToOrganizationalUnitMap[oneStudy.organizationalUnitId].organizationalUnitDescription})"/> --%>
<%--                                 </c:if> --%>
<%--                             </c:forEach> --%>
                        </c:if>
                        <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                    </spring:bind>
                    </c:when>
                 </c:choose>
            </td>
        </tr> 
                                                    
        <!--  GRADE TYPE CODE -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.gradetypecode" /></td>
            <spring:bind path="studyPlanForm.studyPlan.gradeTypeCode">
            <td class="required">
            <c:if test="${editSubscriptionData}">
            <select name="${status.expression}" id="${status.expression}" onchange="document.formdata.submit();">
                <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                <c:forEach var="oneGradeType" items="${studyPlanForm.allGradeTypes}">
                    <c:choose>
                        <c:when test="${oneGradeType.code == status.value}">
                            <option value="${oneGradeType.code}" selected="selected"><c:out value="${oneGradeType.description}"/></option>
                            <c:set var="chosenGradeTypeCode" value="${oneGradeType.code}" scope="page" />
                        </c:when>
                        <c:otherwise>
                            <option value="${oneGradeType.code}"><c:out value="${oneGradeType.description}"/></option>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
        </select>
            </c:if>
            <c:if test="${showSubscriptionData}">
                <c:forEach var="oneGradeType" items="${studyPlanForm.allGradeTypes}">
                <c:if test="${oneGradeType.code == status.value}">
                    <c:out value="${oneGradeType.description}"/>
                </c:if>
                </c:forEach>
            </c:if>
            </td> 
            <td>
            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
            </spring:bind>
        </tr>

        <!--  ADMISSION FOR MASTERS, 1ST CTU -->
        <c:if test="${studyPlanForm.gradeTypeIsMaster && studyPlanForm.firstCTU}">
            <spring:bind path="studyPlanForm.studyPlan.previousDiscipline.code">
            <tr>
                <td class="label">
                    <c:out value="${studyPlanForm.disciplinesLabel}"/>
                </td>
                <td style="width:220px">
                    <c:if test="${editSubscriptionData}">
                    <select name="${status.expression}" id="${status.expression}" onchange="document.formdata.submit();">
                        <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="discipline" items="${studyPlanForm.allDisciplines}">
                            <c:choose>
                                <c:when test="${discipline.code == status.value}">
                                    <option class="xlong" value="${discipline.code}" selected="selected"><c:out value="${discipline.description}"/></option>
                                </c:when>
                                <c:otherwise>
                                    <option class="xlong" value="${discipline.code}"><c:out value="${discipline.description}"/></option>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </select>
                    </c:if>
                    <c:if test="${showSubscriptionData}">
                        <c:forEach var="discipline" items="${studyPlanForm.allDisciplines}">
                            <c:if test="${discipline.code == status.value}">
                                <c:out value="${discipline.description}"/>
                            </c:if>
                        </c:forEach>
                    </c:if>
                </td>
                <td> <c:forEach var="error" items="${status.errorMessages}">
                        <span class="error">${error}</span>
                    </c:forEach>
                </td>
            </tr>
            </spring:bind>
            
            <spring:bind path="studyPlanForm.studyPlan.previousDisciplineGrade">
            <tr>
                <td class="label"><fmt:message key="jsp.discipline.grade" /></td>
                <td>
                    <c:if test="${editSubscriptionData}">
                        <input type="text" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                    </c:if>
                    <c:if test="${showSubscriptionData}">
                        <c:out value="${status.value}"/>
                    </c:if>
               </td>
               <td>
                    <c:forEach var="error" items="${status.errorMessages}">
                        <span class="error">${error}</span>
                    </c:forEach>
               </td>
            </tr>
            </spring:bind>
        </c:if>

        <!--  STUDYPLAN STATUS CODE -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.studyplanstatus" /></td>
            <spring:bind path="studyPlanForm.studyPlan.studyPlanStatusCode">
            <td>
            <c:if test="${editSubscriptionData}">
            <select name="${status.expression}">
                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                <c:forEach var="oneStatus" items="${studyPlanForm.allStudyPlanStatuses}">
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
            </c:if>
            <c:if test="${showSubscriptionData}">
                <c:forEach var="oneStatus" items="${studyPlanForm.allStudyPlanStatuses}">
                    <c:if test="${oneStatus.code == status.value}">
                   <c:out value="${oneStatus.description}"/>
                   </c:if>
               </c:forEach>
            </c:if>                                          
            </td> 
           
            <c:if test="${studyPlanForm.studyPlan.studyPlanStatusCode == STUDYPLAN_STATUS_APPROVED_ADMISSION && editSubscriptionData}">
           		<td>
           		<a href="<c:url value='/college/report/admissionletter.view?studyPlanId=${studyPlanForm.studyPlan.id}'/>"
                    target="otherwindow"
           			class="button">
           			<fmt:message key="jsp.report.admissionletter"/>
           		</a>
           		</td>
            </c:if>
                                        
            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
            </td></spring:bind>
        </tr>
        
       <%-- Missing Documents 
       <tr>
       <td class="label"><fmt:message key="jsp.general.missingdocuments"/></td>
        <td>
        <spring:bind path="studyPlanForm.studyPlan.missingDocuments">
        <textarea name="${status.expression}"><c:out value="${status.value}"/></textarea>     
        </spring:bind>          
        </td>    
        </tr>
        --%>

        <%-- BR's PASSING STUDYPLAN 
        <c:choose>
            <c:when test="${studyPlanForm.endGradesPerGradeType == 'N'}">
                <tr>
                    <td class="label"><fmt:message key="jsp.general.brspassing" /> <fmt:message key="jsp.general.exam" /></td>
                    <spring:bind path="studyPlanForm.studyPlan.BRsPassingExam">
                    <td>
                    <input type="text" name="${status.expression}" size="2" maxlength="2" value="<c:out value="${status.value}" />" /></td>
                    <td>
                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                    </td>
                    </spring:bind>
                </tr> 
            </c:when>
        </c:choose>
        --%>
         
        <!-- ACTIVE -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.active" /></td>
            <spring:bind path="studyPlanForm.studyPlan.active">
            <td>
            <c:choose>
                <c:when test="${editSubscriptionData}">
                    <select name="${status.expression}">
                        <c:choose>
                            <c:when test="${'Y' == status.value}">
                                <option value="Y" selected="selected"><fmt:message key="jsp.general.yes" /></option>
                                <option value="N"><fmt:message key="jsp.general.no" /></option>
                            </c:when>
                            <c:otherwise>
                                <option value="Y"><fmt:message key="jsp.general.yes" /></option>
                                <option value="N" selected="selected"><fmt:message key="jsp.general.no" /></option>
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
            <c:forEach var="error" items="${status.errorMessages}"><span class="error">
                ${error}</span></c:forEach>
            </td>
            </spring:bind>
        </tr>
        <tr><td colspan="3">&nbsp;</td></tr>
        <tr><td colspan="3"><hr /></td></tr>

        
        <!--   ONWARD STUDIES (QUOTA ALLOCATION)   -->
        <!--   1st choice onward study grade type id   -->
        <tr><td colspan="3" class="header"><fmt:message key="jsp.general.onward.study" /> (<fmt:message key="jsp.general.elective" />)</td></tr>
        <tr><td class="label">
                <fmt:message key="jsp.studyplan.1st.choice.onwardstudy" />
            </td>
            <spring:bind path="studyPlanForm.studyPlan.firstChoiceOnwardStudyId">
            <td>
            <c:if test="${editSubscriptionData}">
            <select name="${status.expression}">
                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>

                <c:forEach var="oneStudy" items="${studyPlanForm.allStudies}">
                    <c:set var="optionText"><c:out value="${oneStudy.studyDescription} (${studyPlanForm.idToOrganizationalUnitMap[oneStudy.organizationalUnitId].organizationalUnitDescription})"/></c:set>
                        <c:choose>
                            <c:when test="${oneStudy.id == status.value}">
                                <option value="${oneStudy.id}" selected="selected">${optionText}</option>
                            </c:when>
                            <c:otherwise>
                                <option value="${oneStudy.id}">${optionText}</option>
                            </c:otherwise>
                        </c:choose>
                </c:forEach>
            </select>
            </c:if>
            <c:if test="${showSubscriptionData}">
                <c:set var="oneStudy" value="${form.idToStudyMap[form.studyPlan.firstChoiceOnwardStudyId]}" />
                <c:out value="${oneStudy.studyDescription} (${studyPlanForm.idToOrganizationalUnitMap[oneStudy.organizationalUnitId].organizationalUnitDescription})"/>
<%--                 <c:forEach var="oneStudy" items="${studyPlanForm.allStudies}"> --%>
<%--                    <c:if test="${oneStudy.id == status.value}"> --%>
<%--                        <c:out value="${oneStudy.studyDescription} (${studyPlanForm.idToOrganizationalUnitMap[oneStudy.organizationalUnitId].organizationalUnitDescription})"/> --%>
<%--                    </c:if> --%>
<%--                 </c:forEach> --%>
            </c:if>
            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
            </td> 
            </spring:bind>
        </tr>

        <!--  1st choice onward study GRADE TYPE CODE -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.gradetypecode" /></td>
            <spring:bind path="studyPlanForm.studyPlan.firstChoiceOnwardGradeTypeCode">
            <td>
            <c:if test="${editSubscriptionData}">
            <select name="${status.expression}">
                <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                 <c:forEach var="oneGradeType" items="${studyPlanForm.allGradeTypes}">
                    <c:choose>
                        <c:when test="${oneGradeType.code == status.value}">
                            <option value="${oneGradeType.code}" selected="selected"><c:out value="${oneGradeType.description}"/></option>
                        </c:when>
                        <c:otherwise>
                            <option value="${oneGradeType.code}"><c:out value="${oneGradeType.description}"/></option>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </select>
            </c:if>
            <c:if test="${showSubscriptionData}">
                <c:forEach var="oneGradeType" items="${studyPlanForm.allGradeTypes}">
                    <c:if test="${oneGradeType.code == status.value}">
                         <c:out value="${oneGradeType.description}"/>
                    </c:if>
                </c:forEach>
            </c:if>
            </td> 
            <td>
            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
            </spring:bind>
        </tr> 

        <!--   2nd choice onward study grade type id   -->
        <tr><td class="label">
                <fmt:message key="jsp.studyplan.2nd.choice.onwardstudy" />
            </td>
            <spring:bind path="studyPlanForm.studyPlan.secondChoiceOnwardStudyId">
            <td>
            <c:if test="${editSubscriptionData}">
            <select name="${status.expression}">
                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                <c:forEach var="oneStudy" items="${studyPlanForm.allStudies}">
                    <c:set var="optionText"><c:out value="${oneStudy.studyDescription} (${studyPlanForm.idToOrganizationalUnitMap[oneStudy.organizationalUnitId].organizationalUnitDescription})"/></c:set>
                    <c:choose>
                        <c:when test="${oneStudy.id == status.value}">
                            <option value="${oneStudy.id}" selected="selected">${optionText}</option>
                        </c:when>
                        <c:otherwise>
                            <option value="${oneStudy.id}">${optionText}</option>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </select>
            </c:if>
            <c:if test="${showSubscriptionData}">
                <c:set var="oneStudy" value="${form.idToStudyMap[form.studyPlan.secondChoiceOnwardStudyId]}" />
                <c:out value="${oneStudy.studyDescription} (${studyPlanForm.idToOrganizationalUnitMap[oneStudy.organizationalUnitId].organizationalUnitDescription})"/>
<%--                 <c:forEach var="oneStudy" items="${studyPlanForm.allStudies}"> --%>
<%--                     <c:if test="${oneStudy.id == status.value}"> --%>
<%--                         <c:out value="${oneStudy.studyDescription} (${studyPlanForm.idToOrganizationalUnitMap[oneStudy.organizationalUnitId].organizationalUnitDescription})"/> --%>
<%--                     </c:if> --%>
<%--                 </c:forEach> --%>
            </c:if>
            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
            </td> 
            </spring:bind>
        </tr> 

        <!--  2nd choice onward study GRADE TYPE CODE -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.gradetypecode" /></td>
            <spring:bind path="studyPlanForm.studyPlan.secondChoiceOnwardGradeTypeCode">
            <td>
            <c:if test="${editSubscriptionData}">
            <select name="${status.expression}">
                <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                 <c:forEach var="oneGradeType" items="${studyPlanForm.allGradeTypes}">
                            <c:choose>
                                <c:when test="${oneGradeType.code == status.value}">
                                    <option value="${oneGradeType.code}" selected="selected"><c:out value="${oneGradeType.description}"/></option>
                                </c:when>
                                <c:otherwise>
                                    <option value="${oneGradeType.code}"><c:out value="${oneGradeType.description}"/></option>
                                </c:otherwise>
                            </c:choose>
                </c:forEach>
            </select>
            </c:if>
            <c:if test="${showSubscriptionData}">
            <c:forEach var="oneGradeType" items="${studyPlanForm.allGradeTypes}">
                <c:if test="${oneGradeType.code == status.value}">
                    <c:out value="${oneGradeType.description}"/>
                </c:if>
            </c:forEach>
            </c:if>
            </td> 
            <td>
            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
            </spring:bind>
        </tr> 

        <!--   3rd choice onward study grade type id   -->
        <tr><td class="label">
                <fmt:message key="jsp.studyplan.3rd.choice.onwardstudy" />
            </td>
            <spring:bind path="studyPlanForm.studyPlan.thirdChoiceOnwardStudyId">
            <td>
            <c:if test="${editSubscriptionData}">
            <select name="${status.expression}">
                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                
                <c:forEach var="oneStudy" items="${studyPlanForm.allStudies}">
                    <c:set var="optionText"><c:out value="${oneStudy.studyDescription} (${studyPlanForm.idToOrganizationalUnitMap[oneStudy.organizationalUnitId].organizationalUnitDescription})"/></c:set>
                    <c:choose>
                        <c:when test="${oneStudy.id == status.value}">
                            <option value="${oneStudy.id}" selected="selected">${optionText}</option>
                        </c:when>
                        <c:otherwise>
                            <option value="${oneStudy.id}">${optionText}</option>
                        </c:otherwise>
                    </c:choose>
                            
                </c:forEach>
            </select>
            </c:if>
            <c:if test="${showSubscriptionData}">
                <c:set var="oneStudy" value="${form.idToStudyMap[form.studyPlan.thirdChoiceOnwardStudyId]}" />
                <c:out value="${oneStudy.studyDescription} (${studyPlanForm.idToOrganizationalUnitMap[oneStudy.organizationalUnitId].organizationalUnitDescription})"/>
<%--             <c:forEach var="oneStudy" items="${studyPlanForm.allStudies}"> --%>
<%--                 <c:if test="${oneStudy.id == status.value}"> --%>
<%--                     <c:out value="${oneStudy.studyDescription} (${studyPlanForm.idToOrganizationalUnitMap[oneStudy.organizationalUnitId].organizationalUnitDescription})"/> --%>
<%--                 </c:if> --%>
<%--             </c:forEach> --%>
            </c:if>
            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
            </td> 
            </spring:bind>
        </tr> 

        <!--  3rd choice onward study GRADE TYPE CODE -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.gradetypecode" /></td>
            <spring:bind path="studyPlanForm.studyPlan.thirdChoiceOnwardGradeTypeCode">
            <td>
            <c:if test="${editSubscriptionData}">
            <select name="${status.expression}">
                <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                 <c:forEach var="oneGradeType" items="${studyPlanForm.allGradeTypes}">
                            <c:choose>
                                <c:when test="${oneGradeType.code == status.value}">
                                    <option value="${oneGradeType.code}" selected="selected"><c:out value="${oneGradeType.description}"/></option>
                                </c:when>
                                <c:otherwise>
                                    <option value="${oneGradeType.code}"><c:out value="${oneGradeType.description}"/></option>
                                </c:otherwise>
                            </c:choose>
                            
                </c:forEach>
            </select>
            </c:if>
            <c:if test="${showSubscriptionData}">
            <c:forEach var="oneGradeType" items="${studyPlanForm.allGradeTypes}">
                <c:if test="${oneGradeType.code == status.value}">
                    <c:out value="${oneGradeType.description}"/>
                </c:if>
            </c:forEach>
            </c:if>
            </td> 
            <td>
            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
            </spring:bind>
        </tr> 
        <tr><td colspan="3">&nbsp;</td></tr>

        <!-- SECONDARYSCHOOL SUBJECTGROUPS -->
        <!-- show for bachelor, with ctu=1 and not a foreign student -->
        <c:if test="${student.foreignStudent != 'Y' && studyPlanForm.gradeTypeIsBachelor && studyPlanForm.firstCTU}">
            <tr><td colspan="3"><hr /></td></tr>
            <tr>
            <td class="header" colspan="3"><fmt:message key="jsp.general.secondaryschoolsubjects" /> (<fmt:message key="jsp.register" />)</td>
            </tr>

            <c:set var="gradedSecondarySchoolSubjectGrade" value="" scope="page"/>
            <c:set var="gradedSecondarySchoolSubjectLevel" value="" scope="page"/>
            <c:choose>
                <c:when test="${editSubscriptionData}">
                    <tr><td colspan="3"></td></tr>
                        <c:choose>
                            <c:when test="${secondarySchoolSubjectGroups != null && not empty secondarySchoolSubjectGroups }">  
                                <tr>
                                    <td colspan="3"  class="label">
                                        <fmt:message key="jsp.msg.totalgrades.msg1" /> <c:out value="${appConfigManager.secondarySchoolSubjectsCount}"/> <fmt:message key="jsp.msg.totalgrades.msg2" /> 
                                    </td>
                                </tr>
                                <tr><td colspan="3">&nbsp;</td></tr>
                                <tr>
                                    <td colspan="3">
                                       <table>     
                                        <c:forEach var="secondarySchoolSubjectGroup" items="${secondarySchoolSubjectGroups}" varStatus="rowIndex">
                                            <tr>
                                                <td>
                                                    <input type="hidden" name="studyPlan.secondarySchoolSubjectGroups[${rowIndex.index}].id" id="studyPlan.secondarySchoolSubjectGroups[${rowIndex.index}].id" value="<c:out value="${secondarySchoolSubjectGroup.id}" />"/>
                                                    <fmt:message key="jsp.msg.minmaxgrades.msg1" /> ${secondarySchoolSubjectGroup.minNumberToGrade} <fmt:message key="jsp.msg.minmaxgrades.msg2" /> ${secondarySchoolSubjectGroup.maxNumberToGrade} <fmt:message key="jsp.msg.minmaxgrades.msg3" /> 
                                                    <fmt:message key="jsp.msg.minmaxgrades.secondaryschoolsubjects" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table class="tabledata2" id="secondarySchoolSubjectGroupTblData_${secondarySchoolSubjectGroup.id}">   
                                                    <tr>
                                                        <th><fmt:message key="jsp.general.subject" /></th>
                                                        <th><fmt:message key="jsp.general.grade" /></th>
                                                        <th><fmt:message key="jsp.general.level" /></th>
                                                    </tr>
                                                    <c:forEach var="secondarySchoolSubject" items="${secondarySchoolSubjectGroup.secondarySchoolSubjects}" varStatus="rowIndex2">
                                                    
                                                    	<c:choose>
                                                    		<c:when  test="${secondarySchoolSubject.maximumGradePoint > secondarySchoolSubject.minimumGradePoint }" >
	                                                    		<c:set var="setFrom" value="${ secondarySchoolSubject.minimumGradePoint }" />
	                                                    		<c:set var="setTo" value="${ secondarySchoolSubject.maximumGradePoint }" />
	                                                  		</c:when>
	                                                  		<c:otherwise>
	                                                  			<c:set var="setFrom" value="${ secondarySchoolSubject.maximumGradePoint }" />
	                                                    		<c:set var="setTo" value="${ secondarySchoolSubject.minimumGradePoint }" />
	                                                  		</c:otherwise>
                                                    	</c:choose>
                                                        <tr>
                                                            <td>
                                                                <c:out value="${secondarySchoolSubject.description}"/>
                                                                <br/>
                                                            </td>
                                                            <td> 

                                                                <input type="hidden" id="studyPlan.secondarySchoolSubjectGroups[${rowIndex.index}].secondarySchoolSubjects[${rowIndex2.index}].id"  name="studyPlan.secondarySchoolSubjectGroups[${rowIndex.index}].secondarySchoolSubjects[${rowIndex2.index}].id" value="<c:out value="${secondarySchoolSubject.id}" />"  />
                                                                <input type="hidden" id="studyPlan.secondarySchoolSubjectGroups[${rowIndex.index}].secondarySchoolSubjects[${rowIndex2.index}].secondarySchoolSubjectGroupId"  name="studyPlan.secondarySchoolSubjectGroups[${rowIndex.index}].secondarySchoolSubjects[${rowIndex2.index}].secondarySchoolSubjectGroupId" value="<c:out value="${secondarySchoolSubjectGroup.id}" />"  />

                                                                <select id="studyPlan.secondarySchoolSubjectGroups[${rowIndex.index}].secondarySchoolSubjects[${rowIndex2.index}].grade" name="studyPlan.secondarySchoolSubjectGroups[${rowIndex.index}].secondarySchoolSubjects[${rowIndex2.index}].grade" >
                                                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                                        <c:forEach begin="${setFrom}" end="${setTo}" varStatus="gradePoint">
                                                                            <c:choose>
                                                                                 <c:when test="${gradePoint.count == secondarySchoolSubject.grade}">
                                                                                     <option value="${gradePoint.count}" selected="selected"><c:out value="${gradePoint.count}"/></option>
                                                                                 </c:when>
                                                                                 <c:otherwise>
                                                                                     <option value="${gradePoint.count}"><c:out value="${gradePoint.count}"/></option>
                                                                                 </c:otherwise>
                                                                            </c:choose>
                                                                      </c:forEach>
                                                                </select>
                                                            </td>
                                                            <td> 

                                                                <select id="studyPlan.secondarySchoolSubjectGroups[${rowIndex.index}].secondarySchoolSubjects[${rowIndex2.index}].level" name="studyPlan.secondarySchoolSubjectGroups[${rowIndex.index}].secondarySchoolSubjects[${rowIndex2.index}].level" >
                                                                    <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                                                        <c:choose>
                                                                            <c:when test="${'A' == secondarySchoolSubject.level}">
                                                                                 <option value="A" selected="selected"><fmt:message key="jsp.secondaryschoolsubjects.advanced" /></option>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <option value="A"><fmt:message key="jsp.secondaryschoolsubjects.advanced" /></option>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                        <c:choose>
                                                                            <c:when test="${'O' == secondarySchoolSubject.level}">
                                                                                 <option value="O" selected="selected"><fmt:message key="jsp.secondaryschoolsubjects.ordinary" /></option>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <option value="O"><fmt:message key="jsp.secondaryschoolsubjects.ordinary" /></option>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                </select>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                    </table>
                                                    <script type="text/javascript">alternate('secondarySchoolSubjectGroupTblData_${secondarySchoolSubjectGroup.id}',true)</script>
                                                </td>
                                            </tr> 
                                        </c:forEach>
                                        </table>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="3">
                                        <fmt:message key="jsp.msg.secondaryschools.not.shown" />
                                    </td>
                                </tr>  
                                <tr>
                                    <td colspan="3">&nbsp;</td>
                                </tr>  
                            </c:otherwise>
                        </c:choose>
                </c:when>
                <c:otherwise>
                   <c:choose>
                            <c:when test="${secondarySchoolSubjectGroups != null && not empty secondarySchoolSubjectGroups }">  
                                <tr><td colspan="3">&nbsp;</td></tr>
                                <tr>
                                    <td colspan="3">
                                       <table>     
                                            <tr>
                                                <td>
                                                <table class="tabledata2" id="secondarySchoolSubjectGroupTblData">   
                                                <tr>
                                                    <th><fmt:message key="jsp.general.subject" /></th>
                                                    <th><fmt:message key="jsp.general.grade" /></th>
                                                    <th><fmt:message key="jsp.general.level" /></th>
                                                </tr>
                                                <c:forEach var="secondarySchoolSubjectGroup" items="${secondarySchoolSubjectGroups}">
                                                    
                                                    <c:forEach var="secondarySchoolSubject" items="${secondarySchoolSubjectGroup.secondarySchoolSubjects}">
                                                        <c:if test="${not empty secondarySchoolSubject.grade}">
                                                            <tr>
                                                                <td>
                                                                    <c:out value="${secondarySchoolSubject.description}"/>
                                                                    <br/>
                                                                </td>
                                                                <td> 
                                                                    <c:forEach begin="${secondarySchoolSubject.minimumGradePoint}" end="${secondarySchoolSubject.maximumGradePoint}" varStatus="gradePoint">
                                                                            <c:choose>
                                                                                  <c:when test="${gradePoint.count == secondarySchoolSubject.grade }">
                                                                                      <c:out value="${gradePoint.count}"/>
                                                                                  </c:when>
                                                                            </c:choose>
                                                                    </c:forEach>
                                                                </td>
                                                                <td> 
                                                                    <c:if test="${'A' == secondarySchoolSubject.level}">
                                                                        <fmt:message key="jsp.secondaryschoolsubjects.advanced" />
                                                                    </c:if>
                                                                    <c:if test="${'O' == secondarySchoolSubject.level}">
                                                                        <fmt:message key="jsp.secondaryschoolsubjects.ordinary" />
                                                                    </c:if>
                                                                </td>
                                                            </tr>
                                                         </c:if>  
                                                        
                                                    </c:forEach>
                                                </c:forEach>
                                                </table>
                                                <script type="text/javascript">alternate('secondarySchoolSubjectGroupTblData',true)</script>
                                                </td>
                                            </tr> 
                                        
                                        </table>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="4">
                                        <fmt:message key="jsp.msg.secondaryschools.not.shown" />
                                    </td>
                                </tr>  
                                <tr><td colspan="4">&nbsp;</td></tr>  
                            </c:otherwise>
                        </c:choose>
                </c:otherwise>
            </c:choose>

            <!--  UNGROUPED SECONDARY SCHOOL SUBJECTS -->
            <tr>
            <td class="header" colspan="3"><fmt:message key="jsp.general.ungroupedsecondaryschoolsubjects" /> (<fmt:message key="jsp.register" />)</td>
            </tr>
            <c:choose>
                <c:when test="${editSubscriptionData}">
                    <tr><td colspan="3"></td></tr>
                    <c:choose>
                        <c:when test="${ungroupedSecondarySchoolSubjects != null && not empty ungroupedSecondarySchoolSubjects}">  
                            <tr>
                                <td colspan="3"  class="label">
                                    <fmt:message key="jsp.msg.totalgrades.msg3" />  
                                </td>
                            </tr>
                            <tr><td colspan="3">&nbsp;</td></tr>
                            <tr>
                                <td colspan="3">
                                   <table>     
                                        <tr>
                                            <td>
                                                <table class="tabledata2" id="ungroupedSecondarySchoolSubjectTblData">   
                                                <tr>
                                                    <th><fmt:message key="jsp.general.subject" /></th>
                                                    <th><fmt:message key="jsp.general.grade" /></th>
                                                    <th><fmt:message key="jsp.general.level" /></th>
                                                </tr>
                                                <c:forEach var="ungroupedSecondarySchoolSubject" items="${ungroupedSecondarySchoolSubjects}" varStatus="rowIndex3">
                                                
                                                	<c:choose>
                                                		<c:when  test="${ungroupedSecondarySchoolSubject.maximumGradePoint > ungroupedSecondarySchoolSubject.minimumGradePoint }" >
                                                    		<c:set var="setFrom" value="${ ungroupedSecondarySchoolSubject.minimumGradePoint }" />
                                                    		<c:set var="setTo" value="${ ungroupedSecondarySchoolSubject.maximumGradePoint }" />
                                                  		</c:when>
                                                  		<c:otherwise>
                                                  			<c:set var="setFrom" value="${ ungroupedSecondarySchoolSubject.maximumGradePoint }" />
                                                    		<c:set var="setTo" value="${ ungroupedSecondarySchoolSubject.minimumGradePoint }" />
                                                  		</c:otherwise>
                                                	</c:choose>
                                                    <tr>
                                                        <td>
                                                            <c:out value="${ungroupedSecondarySchoolSubject.description}"/>
                                                            <br/>
                                                        </td>
                                                        <td> 

                                                            <input type="hidden" id="studyPlan.ungroupedSecondarySchoolSubjects[${rowIndex3.index}].id"  name="studyPlan.ungroupedSecondarySchoolSubjects[${rowIndex3.index}].id" value="<c:out value="${ungroupedSecondarySchoolSubject.id}" />"  />
                                                            <input type="hidden" id="studyPlan.ungroupedSecondarySchoolSubjects[${rowIndex3.index}].secondarySchoolSubjectGroupId"  name="studyPlan.ungroupedSecondarySchoolSubjects[${rowIndex3.index}].secondarySchoolSubjectGroupId" value="<c:out value="${ungroupedSecondarySchoolSubject.id}" />"  />

                                                            <select id="studyPlan.ungroupedSecondarySchoolSubjects[${rowIndex3.index}].grade" name="studyPlan.ungroupedSecondarySchoolSubjects[${rowIndex3.index}].grade" >
                                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                                <c:forEach begin="${ungroupedSecondarySchoolSubject.maximumGradePoint}" end="${ungroupedSecondarySchoolSubject.minimumGradePoint}" varStatus="gradePoint">
                                                                    <c:choose>
                                                                         <c:when test="${gradePoint.count == ungroupedSecondarySchoolSubject.grade}">
                                                                             <option value="${gradePoint.count}" selected="selected"><c:out value="${gradePoint.count}"/></option>
                                                                         </c:when>
                                                                         <c:otherwise>
                                                                             <option value="${gradePoint.count}"><c:out value="${gradePoint.count}"/></option>
                                                                         </c:otherwise>
                                                                    </c:choose>
                                                              </c:forEach>
                                                            </select>
                                                        </td>
                                                        
                                                        <td> 
                                                            <select id="studyPlan.ungroupedSecondarySchoolSubjects[${rowIndex3.index}].level" name="studyPlan.ungroupedSecondarySchoolSubjects[${rowIndex3.index}].level" >
                                                                <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                                                    <c:choose>
                                                                        <c:when test="${'A' == ungroupedSecondarySchoolSubject.level}">
                                                                             <option value="A" selected="selected"><fmt:message key="jsp.secondaryschoolsubjects.advanced" /></option>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <option value="A"><fmt:message key="jsp.secondaryschoolsubjects.advanced" /></option>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                    <c:choose>
                                                                        <c:when test="${'O' == ungroupedSecondarySchoolSubject.level}">
                                                                             <option value="O" selected="selected"><fmt:message key="jsp.secondaryschoolsubjects.ordinary" /></option>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <option value="O"><fmt:message key="jsp.secondaryschoolsubjects.ordinary" /></option>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                </table>
                                                <script type="text/javascript">alternate('ungroupedSecondarySchoolSubjectTblData',true)</script>
                                            </td>
                                        </tr> 
                                    </table>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="4">
                                    <fmt:message key="jsp.msg.secondaryschools.not.shown" />
                                </td>
                            </tr>  
                            <tr><td colspan="4">&nbsp;</td></tr>  
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:otherwise>
                   <tr><td colspan="3"></td></tr>
                    <c:choose>
                        <c:when test="${ungroupedSecondarySchoolSubjects != null && not empty ungroupedSecondarySchoolSubjects }">  
                            <tr><td colspan="3">&nbsp;</td></tr>
                            <tr>
                                <td colspan="3">
                                   <table>     
                                        <tr>
                                            <td>
                                                <table class="tabledata2" id="ungroupedSecondarySchoolSubjectTblData">   
                                                <tr>
                                                    <th><fmt:message key="jsp.general.subject" /></th>
                                                    <th><fmt:message key="jsp.general.grade" /></th>
                                                    <th><fmt:message key="jsp.general.level" /></th>
                                                </tr>
                                                <c:forEach var="ungroupedSecondarySchoolSubject" items="${ungroupedSecondarySchoolSubjects}">
                                                   <c:if test="${not empty ungroupedSecondarySchoolSubject.grade}">
                                                       <tr>
                                                            <td>
                                                                <c:out value="${ungroupedSecondarySchoolSubject.description}"/>
                                                                <br/>
                                                            </td>
                                                            <td> 
                                                                <c:forEach begin="${ungroupedSecondarySchoolSubject.maximumGradePoint}" end="${ungroupedSecondarySchoolSubject.minimumGradePoint}" varStatus="gradePoint">
                                                                        <c:choose>
                                                                              <c:when test="${gradePoint.count == ungroupedSecondarySchoolSubject.grade}">
                                                                                  <c:out value="${gradePoint.count}"/>
                                                                              </c:when>
                                                                        </c:choose>
                                                                </c:forEach>
                                                            </td>
                                                            <td> 
                                                                <c:if test="${'A' == secondarySchoolSubject.level}">
                                                                    <fmt:message key="jsp.secondaryschoolsubjects.advanced" />
                                                                </c:if>
                                                                <c:if test="${'O' == secondarySchoolSubject.level}">
                                                                    <fmt:message key="jsp.secondaryschoolsubjects.ordinary" />
                                                                </c:if>
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                    
                                                </c:forEach>
                                                </table>
                                                <script type="text/javascript">alternate('ungroupedSecondarySchoolSubjectTblData',true)</script>
                                            </td>
                                        </tr> 
                                    
                                    </table>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="4">
                                    <fmt:message key="jsp.msg.secondaryschools.not.shown" />
                                </td>
                            </tr>  
                            <tr><td colspan="4">&nbsp;</td></tr>  
                        </c:otherwise>
                    </c:choose>
                     
                </c:otherwise>
            </c:choose>
        
        </c:if> <!--  not foreign student etc. -->
        
        <!-- REFEREES -->
        <!-- show for all masters -->
        <c:if test="${studyPlanForm.gradeTypeIsMaster}">
        <tr><td colspan="3"><hr /></td></tr>
        <tr>
            <td class="header" colspan="3">
                <fmt:message key="jsp.general.referees" />
            </td>
        </tr>
        <tr><td colspan="3">&nbsp;</td></tr>
        <tr>
            <td colspan="3">
                <table>
                    <tr>
                        <th><fmt:message key="jsp.general.name" /></th>
                        <th><fmt:message key="jsp.general.address" /></th>
                        <th><fmt:message key="jsp.general.telephone" /></th>
                        <th><fmt:message key="jsp.general.email" /></th>
                    </tr>
                    <c:forEach var="referee" items="${allReferees}" varStatus="rowIndex">
                        <tr>
                         <c:if test="${editSubscriptionData}">   
                            <td>
                                <input type="hidden" id="studyPlan.allReferees[${rowIndex.index}].id" name="studyPlan.allReferees[${rowIndex.index}].id" value="<c:out value="${allReferees[rowIndex.index].id}" />" />
                                <input type="hidden" id="studyPlan.allReferees[${rowIndex.index}].studyPlanId" name="studyPlan.allReferees[${rowIndex.index}].studyPlanId" value="<c:out value="${allReferees[rowIndex.index].studyPlanId}" />" />
                                <input type="hidden" id="studyPlan.allReferees[${rowIndex.index}].orderBy" name="studyPlan.allReferees[${rowIndex.index}].orderBy" value="<c:out value="${rowIndex.index + 1}" />" />
                                <input type="text" id="studyPlan.allReferees[${rowIndex.index}].name" name="studyPlan.allReferees[${rowIndex.index}].name" size="40" value="<c:out value="${allReferees[rowIndex.index].name}" />" /></td>
                            <td><input type="text" id="studyPlan.allReferees[${rowIndex.index}].address" name="studyPlan.allReferees[${rowIndex.index}].address" size="40" value="<c:out value="${allReferees[rowIndex.index].address}" />" /></td>
                            <td><input type="text" id="studyPlan.allReferees[${rowIndex.index}].telephone" name="studyPlan.allReferees[${rowIndex.index}].telephone" size="40" value="<c:out value="${allReferees[rowIndex.index].telephone}" />" /></td>
                            <td><input type="text" id="studyPlan.allReferees[${rowIndex.index}].email" name="studyPlan.allReferees[${rowIndex.index}].email" size="40" value="<c:out value="${allReferees[rowIndex.index].email}" />" /></td>
                        </c:if>
                        <c:if test="${showSubscriptionData}">  
                            <td><c:out value="${allReferees[rowIndex.index].name}"/></td>
                            <td><c:out value="${allReferees[rowIndex.index].address}"/></td>
                            <td><c:out value="${allReferees[rowIndex.index].telephone}"/></td>
                            <td><c:out value="${allReferees[rowIndex.index].email}"/></td>
                        </c:if>
                        </tr>
                    </c:forEach>
                    
                </table>
            </td>
        </tr>
        </c:if>

        <!-- SUBMIT BUTTON -->
        <c:if test="${editSubscriptionData}"> 
            <tr><td class="label">&nbsp;</td>

            <td colspan="2" align="right"><input type="button" name="submitformdata" value="<fmt:message key="jsp.button.submit" />" onclick="document.getElementById('submitFormObject').value='true';document.formdata.submit();" />
            </td></tr>
        </c:if>

        <tr><td colspan="3"><hr /></td></tr>
        <!-- show for bachelor with CTU higer than 1, master and foreign student -->
         <c:if test="${(studyPlanForm.gradeTypeIsBachelor&& not studyPlanForm.firstCTU) || studyPlanForm.gradeTypeIsMaster || student.foreignStudent == 'Y'}">                  
        <!-- OBTAINED QUALIFICATIONS -->
        <tr>
            <td class="header" colspan="3">
                <fmt:message key="jsp.general.qualification.obtained" />
            </td>
        </tr>
        <tr><td colspan="3">&nbsp;</td></tr>
        <tr>
            <td colspan="2">&nbsp;</td>
            <td align="right"><a class="button"  href="<c:url value='/obtained_qualification.view'/>?<c:out value='newForm=true&panel=5&studentId=${student.id}&studyPlanId=${studyPlan.id}'/>"><fmt:message key="jsp.href.add" /></a></td>
        </tr>
        <c:choose>
            <c:when test="${allObtainedQualifications != null 
                                    && not empty allObtainedQualifications}">  
                <tr>
                    <td colspan="3">
                        <table class="tabledata2" id="obtainedQualificationTblData">   
                        <tr>
                            <th><fmt:message key="jsp.qualification.university" /></th>
                            <th><fmt:message key="jsp.general.startdate" /></th>
                            <th><fmt:message key="jsp.general.enddate" /></th>
                            <th><fmt:message key="jsp.qualification.endgrade.date" /></th>
                            <th><fmt:message key="jsp.qualification.qualification" /></th>
                            <th><fmt:message key="jsp.qualification.gradetype" /></th>
                        </tr>
                        <c:forEach var="obtainedQualification" items="${allObtainedQualifications}" varStatus="rowIndex">
                            <tr>
                                <td><c:out value="${obtainedQualification.university}"/></td>
                                <td><fmt:formatDate pattern="dd/MM/yyyy" value="${obtainedQualification.startDate}" /></td>
                                <td><fmt:formatDate pattern="dd/MM/yyyy" value="${obtainedQualification.endDate}" /></td>
                                <td><fmt:formatDate pattern="dd/MM/yyyy" value="${obtainedQualification.endGradeDate}" /></td>
                                <td><c:out value="${obtainedQualification.qualification}"/></td>
                                <td>
                                    <c:forEach var="oneGradeType" items="${studyPlanForm.allGradeTypes}">
                                       <c:choose>
                                            <c:when test="${oneGradeType.code ==obtainedQualification.gradeTypeCode}"> 
                                                <c:out value="${oneGradeType.description}"/>
                                            </c:when>
                                        </c:choose>
                                    </c:forEach>
                                </td>
                                <td>
                                    <c:if test="${editSubscriptionData}"> 
                                    <a href="<c:url value='/college/obtainedqualification_delete.view'/>?<c:out value='tab=2&panel=0&studentId=${student.id}&studyPlanId=${studyPlan.id}&currentPageNumber=${navigationSettings.currentPageNumber}&obtainedQualificationId=${obtainedQualification.id}'/>" onclick="return confirm('<fmt:message key="jsp.qualification.obtained.delete.confirm" />')">
                                        <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                    </a>
                                    </c:if>
                                </td> 
                            </tr>
                        </c:forEach>
                        </table>
                        <script type="text/javascript">alternate('obtainedQualificationTblData',true)</script>
                    </td>
                </tr> 
            </c:when>
        </c:choose>

        <tr><td colspan="3"><hr /></td></tr>

        <!-- CAREER POSITIONS -->
        <tr>
            <td class="header" colspan="3">
                <fmt:message key="jsp.general.careerpositions" />
            </td>
        </tr>
        <tr><td colspan="3">&nbsp;</td></tr>
        <tr>
            <td colspan="2">&nbsp;</td>
            <td align="right"><a class="button" href="<c:url value='/career_position.view'/>?<c:out value='newForm=true&panel=5&studentId=${student.id}&studyPlanId=${studyPlan.id}'/>"><fmt:message key="jsp.href.add" /></a></td>
        </tr>
        <c:choose>
            <c:when test="${allCareerPositions != null && not empty allCareerPositions}">  
                <tr>
                    <td colspan="3">
                        <table class="tabledata2" id="careerPositionTblData">   
                        <tr>
                            <th><fmt:message key="jsp.careerposition.employer" /></th>
                            <th><fmt:message key="jsp.general.startdate" /></th>
                            <th><fmt:message key="jsp.general.enddate" /></th>
                            <th><fmt:message key="jsp.careerposition.position" /></th>
                            <th><fmt:message key="jsp.careerposition.responsibility" /></th>
                        </tr> 
                        <c:forEach var="careerPosition" 
                                        items="${allCareerPositions}" varStatus="rowIndex">
                            <tr>
                                <td><c:out value="${careerPosition.employer}"/></td>
                                <td><fmt:formatDate pattern="dd/MM/yyyy" value="${careerPosition.startDate}" /></td>
                                <td><fmt:formatDate pattern="dd/MM/yyyy" value="${careerPosition.endDate}" /></td>
                                <td><c:out value="${careerPosition.position}"/></td>
                                <td><c:out value="${careerPosition.responsibility}"/></td>
                                <td>
                                    <c:if test="${editSubscriptionData}"> 
                                    <a href="<c:url value='/college/careerposition_delete.view'/>?<c:out value='tab=2&panel=0&studentId=${student.id}&studyPlanId=${studyPlan.id}&currentPageNumber=${navigationSettings.currentPageNumber}&careerPositionId=${careerPosition.id}'/>" onclick="return confirm('<fmt:message key="jsp.careerposition.delete.confirm" />')">
                                        <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                    </a>
                                    </c:if>
                                </td> 
                            </tr>
                        </c:forEach>
                        </table>
                        <script type="text/javascript">alternate('careerPositionTblData',true)</script>
                    </td>
                </tr> 
            </c:when>
        </c:choose>
        
        <tr><td colspan="3"><hr></td></tr>
        </c:if>

        <!-- THESIS -->
        <tr>
            <td class="header"><fmt:message key="jsp.general.thesis" /></td>
            <c:choose>
                <c:when test="${thesis.id == null}">
                    <td colspan="2" align="right">
                        <c:if test="${editSubscriptionData}">
                            <a class="button" href="<c:url value='/college/thesis.view'/>?<c:out value='newForm=true&tab=0&panel=0&currentPageNumber=${navigationSettings.currentPageNumber}&studyPlanId=${studyPlanForm.studyPlan.id}&studentId=${student.studentId}'/>"><fmt:message key="jsp.href.add" /></a>
                        </c:if>
                    </td>
                </c:when>
            </c:choose>
        </tr>
        
        <tr>
            <td colspan="3">
                <!-- show thesis if present; there can be only one -->
                <table class="tabledata2" id="TblData2_thesis">
                    <c:choose>
                        <c:when test="${thesis.id != null}">
                            <tr>
                                <td width="90"><b><fmt:message key="jsp.general.academicyear" /></b></td>
                                <th><fmt:message key="jsp.general.title" /></th>
                                <td width="30">&nbsp;</td>
                            </tr>
                            <tr>
                                <td>
                                <c:forEach var="academicYear" items="${studyPlanForm.allAcademicYears}">
                                     <c:choose>
                                         <c:when test="${thesis.startAcademicYearId != 0 && academicYear.id == thesis.startAcademicYearId}">
                                            <c:out value="${academicYear.description}"/>
                                         </c:when>
                                     </c:choose>
                                </c:forEach>
                                </td>
                                <!-- thesis title/description -->
                                <td>
                                    <c:if test="${editSubscriptionData || personId == opusUser.personId}">
                                        <a href="<c:url value='/college/thesis.view'/>?<c:out value='newForm=true&tab=0&panel=0&currentPageNumber=${navigationSettings.currentPageNumber}&studentId=${student.studentId}&studyPlanId=${studyPlanForm.studyPlan.id}&thesisId=${thesis.id}'/>">
                                            <c:out value="${thesis.thesisDescription }"/>
                                        </a>
                                    </c:if>
                                    <c:if test="${showSubscriptionData}">
                                        ${thesis.thesisDescription }
                                    </c:if>
                                </td>
                                <td></td>
                                <!--  edit and delete button -->
                                <td class="buttonsCell">
                                <c:if test="${editSubscriptionData || personId == opusUser.personId}">
                                    <a class="imageLink" href="<c:url value='/college/thesis.view'/>?<c:out value='newForm=true&tab=0&panel=0&currentPageNumber=${navigationSettings.currentPageNumber}&studentId=${student.studentId}&studyPlanId=${studyPlanForm.studyPlan.id}&thesisId=${thesis.id}'/>">
                                        <img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                </c:if>
                                <c:if test="${editSubscriptionData}">
                                    <a class="imageLinkPaddingLeft" href="<c:url value='/college/thesis_delete.view'/>?<c:out value='newForm=true&tab=${navigationSettings.tab}&panel=${navigationSettings.panel}&currentPageNumber=${navigationSettings.currentPageNumber}&from=student&studentId=${student.studentId}&studyPlanId=${studyPlanForm.studyPlan.id}&thesisId=${thesis.id}'/>"  
                                    onclick="return confirm('<fmt:message key="jsp.thesis.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                </c:if>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                </td>
                            </tr>
                        </c:when>
                    </c:choose>
                </table>
                <script type="text/javascript">alternate('TblData2_thesis',true)</script>
            </td>
        </tr>
        <!-- END THESIS -->

		<tr><td colspan="3"><hr /></td></tr>
	</table>
    </form>
    
</div> <!--  end accordionpanelcontent -->
</div> <!--  end accordionpanel -->

</div> <!-- end of accordion 1 -->
<script type="text/javascript">
     var Accordion0 = new Spry.Widget.Accordion("Accordion0",
      {defaultPanel: 0,
       useFixedPanelHeights: false,
       nextPanelKeyCode: 78 /* n key */,
       previousPanelKeyCode: 80 /* p key */
      });
</script>
</div> <!--  end tabbedpanelscontent -->

<!------------------------------- studyplan cardinaltimeunits ------------------------------------------------- -->

<div class="TabbedPanelsContent">
<div class="Accordion" id="Accordion1" tabindex="0">
<div class="AccordionPanel">
<div class="AccordionPanelTab"><fmt:message key="jsp.general.studyplancardinaltimeunits" /></div>
<div class="AccordionPanelContent">

	<!--  STUDY PLAN CARDINAL TIME UNITS -->
	<c:choose>
		<c:when test="${studyPlanForm.studyPlan.id != '' && studyPlanForm.studyPlan.id != '0'}">
			<c:set var="previousStudyPlanCTUIncremented" value="N" scope="page" />

            <%-- CROSS LINK STUDYPLAN RESULT --%>
            <c:if test="${studyPlanForm.studyPlan.id != '' && studyPlanForm.studyPlan.id != '0'}">

                <div class="crosslinkbar">
                    <a class="button" href="<c:url value='/college/studyplanresult.view'/>?<c:out value='newForm=true&tab=0&panel=0&from=student&studentId=${student.studentId}&studyPlanId=${studyPlan.id}'/>">
                        <fmt:message key="jsp.general.resultsoverview" />
                    </a>
                </div>

            </c:if>

            <table>
			   	<spring:bind path="studyPlanForm.studyPlan.studyPlanCardinalTimeUnits">
				      <c:choose>
               		  <c:when test="${status.value == '' || status.value== '[]'}">
               			 <c:forEach begin="1" end="${studyPlanForm.maxNumberOfCardinalTimeUnits}" var="emptyCardinalTimeUnitNumber">
                            <tr>
                   			     <td class="header" colspan="2">
								      <fmt:message key="jsp.general.cardinaltimeunit.number" /> <c:out value="${emptyCardinalTimeUnitNumber}"/>
							     </td>
							     <td align="right">
	                             <c:if test="${studyPlanForm.studyPlan.studyPlanStatusCode == STUDYPLAN_STATUS_APPROVED_ADMISSION 
	                                 && (editSubscriptionData || personId == opusUser.personId) 
                                        && (studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode == null
                                            || studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode == ''
                                            || studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT)
                                              
                                    }" >
				            	     <a class="button" href="<c:url value='/college/studyplancardinaltimeunit.view'/>?<c:out value='newForm=true&tab=1&panel=0&studyPlanId=${studyPlanForm.studyPlan.id}&cardinalTimeUnitNumber=${emptyCardinalTimeUnitNumber}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
			                      </c:if>
			                   </td>
			                </tr>
		                </c:forEach>
               		  </c:when>
               	      </c:choose>
               </spring:bind>   		
			
                <!--  start with ctu number 0 to catch all free subjects and subjectblocks directly underneath study / gradetype (cardinaltimeunitnumber = 0) -->		
		        <c:forEach var="currentCardinalTimeUnitNumber" begin="1" end="${studyPlanForm.maxNumberOfCardinalTimeUnits}">
					<c:set var="headersDrawnForCTUNumber" value="N" scope="page" />
					<c:set var="TableForCTUNumberOpened" value="N" scope="page" />
					<c:set var="previousEmptyCTUNumberDrawn" value="N" scope="page" />
					
                    <%-- first find max used ctu number --%>
                    <c:forEach var="studyPlanCardinalTimeUnit" items="${studyPlanForm.studyPlan.studyPlanCardinalTimeUnits}">
                        <c:set var="maxUsedCardinalTimeUnitNumber" value="${studyPlanCardinalTimeUnit.cardinalTimeUnitNumber}" scope="page" />
                    </c:forEach>
                    
                    <%-- now loop through the studyplan ctu's and show the details --%>
                   	<c:forEach var="studyPlanCardinalTimeUnit" items="${studyPlanForm.studyPlan.studyPlanCardinalTimeUnits}">
                   	    <c:set var="currentStudyGradeType" value="" scope="page" />
						<c:set var="currentStudyPlanCTURepeated" value="N" scope="page" />

                        <c:set var="currentStudyGradeType" value="${form.idToStudyGradeTypeMap[studyPlanCardinalTimeUnit.studyGradeTypeId]}" />

                        <c:set var="editStudyPlanCardinalTimeUnitURL" value="" />
                        <c:set var="deleteStudyPlanCardinalTimeUnitURL" value="" />
                        <c:if test="${currentCardinalTimeUnitNumber == studyPlanCardinalTimeUnit.cardinalTimeUnitNumber}">
                            <c:if test="${
                                (   studyPlanForm.studyPlan.studyPlanStatusCode == STUDYPLAN_STATUS_APPROVED_ADMISSION
                                 || studyPlanForm.studyPlan.studyPlanStatusCode == STUDYPLAN_STATUS_GRADUATED
                                ) 
                                && (editSubscriptionData 
                                    || (personId == opusUser.personId 
                                        && (   studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT
                                            || studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME
                                            || studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED)))}" >
                                <c:if test="${empty studyPlanCardinalTimeUnit.progressStatusCode || reverseProgressStatus}">
                                    <c:set var="editStudyPlanCardinalTimeUnitURL">
                                        <c:url value='/college/studyplancardinaltimeunit.view'/>?<c:out value='newForm=true&tab=1&panel=0&studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&studyPlanId=${studyPlanForm.studyPlan.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>
                                    </c:set>
                                </c:if>
                                <c:if test="${editSubscriptionData}">
                                    <c:if test="${empty studyPlanCardinalTimeUnit.progressStatusCode}">
                                        <c:set var="deleteStudyPlanCardinalTimeUnitURL">
                                            <c:url value='/college/studyplan.view'/>?<c:out value='delete=true&tab=1&panel=0&studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&studyPlanId=${studyPlanForm.studyPlan.id}&studentId=${student.studentId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>
                                        </c:set>
                                     </c:if>
                                 </c:if>
                            </c:if>
                        </c:if>

						<c:choose>
                			<c:when test="${headersDrawnForCTUNumber == 'N'}">

                                <c:if test="${currentCardinalTimeUnitNumber eq 1 || currentCardinalTimeUnitNumber < (maxUsedCardinalTimeUnitNumber + 1) }">
                                    <tr>
                                        <td class="header" colspan="2">
                                            <c:set var="timeUnitString">
                                                <c:out value="${studyPlanForm.codeToCardinalTimeUnitMap[currentStudyGradeType.cardinalTimeUnitCode].description }"></c:out>
                                                <c:out value="${currentCardinalTimeUnitNumber}"/>
                                            </c:set>
                                            <c:choose>
                                                <c:when test="${not empty editStudyPlanCardinalTimeUnitURL}">
                                                    <a href='${editStudyPlanCardinalTimeUnitURL}'>${timeUnitString}</a>
                                                </c:when>
                                                <c:otherwise>
                                                    ${timeUnitString}
                                                </c:otherwise>
                                            </c:choose>
                                            <c:if test="${not empty deleteStudyPlanCardinalTimeUnitURL}">
                                                <a class="imageLinkPaddingLeft" href='${deleteStudyPlanCardinalTimeUnitURL}'>
                                                    <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                </a>
                                            </c:if>
                                        </td>
                                        <td align="right">&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <table class="tabledata2" id="TblData2_studyplancardinaltimeunits_${currentCardinalTimeUnitNumber}">
                                                <tr>
                                                	<th><fmt:message key="jsp.general.studytime" /></th>
                                                    <th><fmt:message key="jsp.general.studygradetype" /></th>
                                                    <th><fmt:message key="jsp.general.studyform" /></th>
                                                    <th><fmt:message key="jsp.general.cardinaltimeunitstatus" /></th>
                                                    <th><fmt:message key="jsp.general.studyintensity" /></th>
                                                    <th><fmt:message key="jsp.general.progressstatus" /></th>
                                                    <th><fmt:message key="jsp.general.active" /></th>
                                                    <th>&nbsp;</th>
                                               </tr>
                                               <%-- Note that this table is closed further down --%>
                                     
                                     <c:set var="TableForCTUNumberOpened" value="Y" scope="page" />
                                </c:if>
                                      
                                <!--  reset vars -->
								<c:set var="headersDrawnForCTUNumber" value="Y" scope="page" />
								<c:set var="currentStudyPlanCTURepeated" value="N" scope="page" />
								<c:set var="previousStudyPlanCTUIncremented" value="N" scope="page" />
							</c:when>
						</c:choose>
						
						<c:choose>
                        	<c:when test="${editSubscriptionData && currentStudyGradeType != null 
                        	    && currentCardinalTimeUnitNumber < studyPlanCardinalTimeUnit.cardinalTimeUnitNumber
                        	    && previousEmptyCTUNumberDrawn == 'N'}">
                        	    <tr>
                        	        <td colspan="6">&nbsp;</td>
                                    <td align="right">
                                        <%-- Add spctu button --%>
                                        <a class="button" href="<c:url value='/college/studyplancardinaltimeunit.view'/>?<c:out value='newForm=true&tab=1&panel=0&studyPlanId=${studyPlanForm.studyPlan.id}&cardinalTimeUnitNumber=${currentCardinalTimeUnitNumber}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                    </td>
                                </tr>
                                <c:set var="previousEmptyCTUNumberDrawn" value="Y" scope="page" />
                        	</c:when>
                        	<c:otherwise>
                        	    <c:if test="${currentCardinalTimeUnitNumber == studyPlanCardinalTimeUnit.cardinalTimeUnitNumber}">
									    <c:set var="previousEmptyCTUNumberDrawn" value="Y" scope="page" />
    									
    									<%-- save repeat / increment status of the current studyplanCTU --%>
                                        <c:choose>
                                            <c:when test="${not empty studyPlanCardinalTimeUnit.progressStatusCode}">  
                                                <c:forEach var="progressStatus" items="${studyPlanForm.allProgressStatuses}">
                                                    <c:if test="${studyPlanCardinalTimeUnit.progressStatusCode == progressStatus.code}">
                                                        <c:choose>
                                                            <c:when test="${progressStatus.increment == 'N'}">
                                                                <c:set var="currentStudyPlanCTURepeated" value="Y" scope="page" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:set var="currentStudyPlanCTURepeated" value="N" scope="page" />
                                                            </c:otherwise>
                                                         </c:choose>
                                                    </c:if>     
                                                 </c:forEach>
                                           </c:when>
                                           <c:otherwise>
                                                <c:set var="currentStudyPlanCTURepeated" value="N" scope="page" />
                                           </c:otherwise>
                                        </c:choose> 
                                        
                                     	<c:if test="${(previousStudyPlanCTUIncremented == 'Y' && (currentCardinalTimeUnitNumber == (maxUsedCardinalTimeUnitNumber + 1)))
    									       || (currentStudyPlanCTURepeated == 'Y' && (currentCardinalTimeUnitNumber == maxUsedCardinalTimeUnitNumber))
    									       }"> 
                                            <tr>
                                                <td colspan="6">&nbsp;</td>
        									    <td align="right">
                                                    <%-- Add spctu button --%>
        									       <a class="button" href="<c:url value='/college/studyplancardinaltimeunit.view'/>?<c:out value='newForm=true&tab=1&panel=0&studyPlanId=${studyPlanForm.studyPlan.id}&cardinalTimeUnitNumber=${currentCardinalTimeUnitNumber}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                                </td>
        									</tr>
    									</c:if>
    									
    									<%-- save repeat / increment status of this studyplanCTU for the next studyplanctu --%>
                                        <c:choose>
                                            <c:when test="${not empty studyPlanCardinalTimeUnit.progressStatusCode}">  
                                                <c:forEach var="progressStatus" items="${studyPlanForm.allProgressStatuses}">
                                                    <c:if test="${studyPlanCardinalTimeUnit.progressStatusCode == progressStatus.code}">
                                                        <c:choose>
                                                            <c:when test="${progressStatus.increment == 'Y'}">
                                                                <c:set var="previousStudyPlanCTUIncremented" value="Y" scope="page" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:set var="previousStudyPlanCTUIncremented" value="N" scope="page" />
                                                            </c:otherwise>
                                                         </c:choose>
                                                    </c:if>     
                                                 </c:forEach>
                                           </c:when>
                                           <c:otherwise>
                                                <c:set var="previousStudyPlanCTUIncremented" value="N" scope="page" />
                                           </c:otherwise>
                                        </c:choose>

                                        <!-- METADATA STUDYGRADETYPE -->
                                        <c:remove var="metastudy"/>
                                        <c:if test="${not empty currentStudyGradeType}">
                                            <c:set var="metastudy" value="${form.idToStudyMap[currentStudyGradeType.studyId]}" />
                                        </c:if>

    									<tr>
                                            <c:choose>
                                                <c:when test="${not empty metastudy}">
                                                   <td class="subheader" width="100">
                                                        <c:out value="${form.idToAcademicYearMap[currentStudyGradeType.currentAcademicYearId].description}"></c:out>
                                                        <c:out value="-${form.codeToStudyTimeMap[currentStudyGradeType.studyTimeCode].description}"/>
                                                    </td>
                                                        
				                           			<td class="subheader">
					                           			<%--<a href="<c:url value='/college/studygradetype.view'/>?<c:out value='newForm=true&tab=1&panel=0&studyId=${study.id}&studyGradeTypeId=${currentStudyGradeType.id}&currentPageNumber=${studyPlanForm.navigationSettings.currentPageNumber}'/>">--%>
					                           			<c:out value="${metastudy.studyDescription}"/>
	                           							<c:forEach var="gradeType" items="${studyPlanForm.allGradeTypes}">
							                           		<c:choose>
							                           			<c:when test="${gradeType.code == currentStudyGradeType.gradeTypeCode}" >
								                           			<c:out value="- ${gradeType.description}"/>
								                           		</c:when>
								                           	</c:choose>
							                            </c:forEach>
                                                    </td>
                                                    <td class="subheader">
                                                            <c:out value="${form.codeToStudyFormMap[currentStudyGradeType.studyFormCode].description}"></c:out>
                                                        <c:if test="${appUseOfPartTimeStudyGradeTypes == 'Y'}">
                                                            <c:forEach var="studyIntensity" items="${studyPlanForm.allStudyIntensities}">
                                                                <c:choose>
                                                                    <c:when test="${studyIntensity.code == currentStudyGradeType.studyIntensityCode}">
                                                                         <c:out value="/${studyIntensity.description}"/>
                                                                    </c:when>
                                                                </c:choose>
                                                            </c:forEach>
                                                        </c:if>
				                           			</td>
                                                </c:when>
                                                <c:otherwise>
                                                    <td/>
                                                    <td/>
                                                    <td/>
                                                </c:otherwise>
                                            </c:choose>

                                            <!--  CTU STATUS CODE -->
                                            <td class="subheader">
                                                <c:forEach var="oneCardinalTimeUnitStatus" items="${studyPlanForm.allCardinalTimeUnitStatuses}">
                                                   <c:choose>
                                                    <c:when test="${oneCardinalTimeUnitStatus.code == studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode}">
                                                        <c:out value="${oneCardinalTimeUnitStatus.description}"/>
                                                    </c:when>
                                                   </c:choose>
                                                </c:forEach>
                                            </td> 
                                            
                                            <!-- STUDY INTENSITY -->
                                            <td class="subheader">
                                                <c:out value="${studyPlanForm.codeToStudyIntensityMap[studyPlanCardinalTimeUnit.studyIntensityCode].description }"/>
                                            </td>

                       						<!--  PROGRESS STATUS CODE -->
                       						<td class="subheader">
                                                <c:forEach var="oneProgressStatus" items="${studyPlanForm.allProgressStatuses}">
                                                   <c:choose>
                                                    <c:when test="${oneProgressStatus.code == studyPlanCardinalTimeUnit.progressStatusCode}">
														<c:out value="${oneProgressStatus.description}"/>
                                                    </c:when>
                                                   </c:choose>
                                                </c:forEach>
                                            </td> 

                                        	<!-- ACTIVE -->
                                            <td width="50" class="subheader">
                                            <c:choose>
                                                    <c:when test="${'Y' == studyPlanCardinalTimeUnit.active}">
                                                        <fmt:message key="jsp.general.yes" />
                                                    </c:when>
                                                    <c:otherwise>
                                                       <fmt:message key="jsp.general.no" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        	
                                         	<td colspan="3" class="buttonsCell">
                                                <c:if test="${not empty editStudyPlanCardinalTimeUnitURL}">
                                                    <a class="imageLink" href='${editStudyPlanCardinalTimeUnitURL}'>
                                                        <img src="<c:url value='/images/edit.gif' />" alt='<fmt:message key="jsp.href.edit" />' title='<fmt:message key="jsp.href.edit" />' />
                                                    </a>
                                                </c:if>
                                                <c:if test="${not empty deleteStudyPlanCardinalTimeUnitURL}">
                                                    <a class="imageLinkPaddingLeft" href='${deleteStudyPlanCardinalTimeUnitURL}'>
                                                        <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                    </a>
                                                </c:if>

                                         	     <%--c:if test="${
                                                    (   studyPlanForm.studyPlan.studyPlanStatusCode == STUDYPLAN_STATUS_APPROVED_ADMISSION
                                                     || studyPlanForm.studyPlan.studyPlanStatusCode == STUDYPLAN_STATUS_GRADUATED
                                                    ) 
                                                    && (editSubscriptionData 
                                                        || (personId == opusUser.personId 
                                                            && (   studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_WAITING_FOR_PAYMENT
                                                                || studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_CUSTOMIZE_PROGRAMME
                                                                || studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED)))}" >
                                                    <c:if test="${empty studyPlanCardinalTimeUnit.progressStatusCode || reverseProgressStatus}">
                                                         <a href="<c:url value='/college/studyplancardinaltimeunit.view'/>?<c:out value='newForm=true&tab=1&panel=0&studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&studyPlanId=${studyPlanForm.studyPlan.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                            		</c:if>
                                            		<c:if test="${editSubscriptionData}">
                                                		<c:if test="${empty studyPlanCardinalTimeUnit.progressStatusCode}">
                                                            &nbsp;&nbsp;
                                                		     <a href="<c:url value='/college/studyplan.view'/>?<c:out value='delete=true&tab=1&panel=0&studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&studyPlanId=${studyPlanForm.studyPlan.id}&studentId=${student.studentId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>" onclick="return confirm('<fmt:message key="jsp.studyplancardinaltimeunit.delete.confirm" />')">
                                                    	     <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                             </a>
                                                         </c:if>
                                                     </c:if>
                                                 </c:if --%>
                                                 <c:if test="${(studyPlanForm.studyPlan.studyPlanStatusCode == STUDYPLAN_STATUS_APPROVED_ADMISSION
                                                    || studyPlanForm.studyPlan.studyPlanStatusCode == STUDYPLAN_STATUS_GRADUATED) 
                                                    && (editSubscriptionData || personId == opusUser.personId)
                                                    && studyPlanCardinalTimeUnit.cardinalTimeUnitStatusCode == CARDINALTIMEUNIT_STATUS_ACTIVELY_REGISTERED}">
                                                    <a href="<c:url value='/college/reports.view'/>?<c:out value='reportName=ExamSlip.pdf&where.studyplancardinaltimeunit.id=${studyPlanCardinalTimeUnit.id}'/>" target="otherwindow"><img src="<c:url value='/images/guest.gif' />" alt="<fmt:message key="jsp.general.report" />" title="<fmt:message key="jsp.report.examslip" />" /></a>
                                        	        &nbsp;<a href="<c:url value='/college/report/activeregistration.view'/>?<c:out value='where.studyplancardinaltimeunit.id = ${studyPlanCardinalTimeUnit.id}'/>" 
                                                            title="<fmt:message key='js.href.activeregistration'/>"
                                                            target="_blank">
                                                            <fmt:message key="jsp.report.activeregistration"/>
                                                      </a>
                                        	     </c:if>
                                        	</td>
	                                    </tr>
                                        
                                        <!-- prepare variables for include -->
                                        <c:set var="studyPlanDetails" value="${studyPlanCardinalTimeUnit.studyPlanDetails}" />

										<%@ include file="../../includes/studyPlanDetailsForStudyPlanCTU.jsp"%>
										
								     </c:if>
                            </c:otherwise>
                    	</c:choose> <!-- currentCardinalTimeUnitNumber == studyPlanCardinalTimeUnit.cardinalTimeUnitNumber -->

                    </c:forEach> <!-- studyplan cardinal time unit -->	
                   
                  
                    <!-- optionally add next studyplan ctu add-button -->
                    <c:if test="${editSubscriptionData && maxUsedCardinalTimeUnitNumber < studyPlanForm.maxNumberOfCardinalTimeUnits  
                                && (
                                    (previousStudyPlanCTUIncremented == 'Y' && currentCardinalTimeUnitNumber == maxUsedCardinalTimeUnitNumber)
                                    || 
                                    (currentStudyPlanCTURepeated == 'Y' && currentCardinalTimeUnitNumber == maxUsedCardinalTimeUnitNumber)
                                )}"> 
                           <c:if test="${previousStudyPlanCTUIncremented == 'Y'}">
                                <c:set var="cardinalTimeUnitNumberToAdd" value="${currentCardinalTimeUnitNumber +1}" />
                           </c:if>
                        <tr>
                            <td colspan="6">&nbsp;</td>
                            <td align="right">
                               <a class="button" href="<c:url value='/college/studyplancardinaltimeunit.view'/>?<c:out value='newForm=true&tab=1&panel=0&studyPlanId=${studyPlanForm.studyPlan.id}&cardinalTimeUnitNumber=${cardinalTimeUnitNumberToAdd}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                            </td>
                        </tr>
                    </c:if>

                    <spring:bind path="studyPlanForm.studyPlan.studyPlanCardinalTimeUnits">
                        <c:choose>
                        	<c:when test="${status.errorMessages != ''}">
                                <tr>
                                	<td colspan="7">
                                    	<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                	</td>
                                </tr>
                        	</c:when>
                        </c:choose>
                    </spring:bind>

					<c:choose>
                		<c:when test="${TableForCTUNumberOpened == 'Y'}">
                            <%-- Note that this table has been defined further up --%>
		                  	</table>
                          	<script type="text/javascript">alternate('TblData2_studyplancardinaltimeunits_${currentCardinalTimeUnitNumber}',true)</script>
                      		</td></tr>
	                    	<c:set var="TableForCTUNumberOpened" value="N" scope="page" />
                      	</c:when>
                    </c:choose>
                    
                </c:forEach> <!-- cardinal time unit number -->
			</table>

        </c:when>
    </c:choose>  <!-- studyplan id != 0 -->
    
</div> <!--  end accordionpanelcontent -->
</div> <!--  end accordionpanel -->

</div> <!-- end of accordion 2 -->
<script type="text/javascript">
var Accordion1 = new Spry.Widget.Accordion("Accordion1",
        {defaultPanel: 0,
        useFixedPanelHeights: false,
        nextPanelKeyCode: 78 /* n key */,
        previousPanelKeyCode: 80 /* p key */
       });
</script>
</div> <!-- tabbedPanelsContent -->
             
</div> <!-- tabbedPanelsContentGroup -->
</div>  <!-- end tabbedPanel -->
</div>  <!-- tabcontent --> 
    
<script type="text/javascript">
    var tp1 = new Spry.Widget.TabbedPanels("tp1");
    //tp1.showPanel(${param.tab});
    tp1.showPanel(<%=request.getParameter("tab")%>);
    Accordion<%=request.getParameter("tab")%>.defaultPanel = <%=request.getParameter("panel")%>;
    Accordion<%=request.getParameter("tab")%>.openPanelNumber(<%=request.getParameter("panel")%>);
</script>
<!-- end tabwrapper -->    
</div>

<%@ include file="../../footer.jsp"%>

