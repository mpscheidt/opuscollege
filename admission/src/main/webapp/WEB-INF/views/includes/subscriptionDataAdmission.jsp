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

The Original Code is Opus-College admission module code.

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
<table>
    <!--  APPLICATION NUMBER -->
    <c:if test="${opusInit.iApplicationNumber == 'Y'}">
        <tr>
            <td class="label"><b><fmt:message key="jsp.general.applicationnumber" /></b></td>
            <td width="273"><form:input path="studyPlan.applicationNumber" size="10" maxlength="25" /></td></td>
        </tr>
    </c:if> 
    
    <spring:bind path="requestAdmissionForm.firstReferee">
        <c:set var="firstReferee" value="${status.value}"  scope="page" /> 
    </spring:bind>
    <spring:bind path="requestAdmissionForm.secondReferee">
        <c:set var="secondReferee" value="${status.value}"  scope="page" /> 
    </spring:bind>
    
    <!-- APPLICANT CATEGORY -->
    <tr>
        <td class="label"><b><fmt:message key="jsp.general.applicantcategory" /></b></td>
        <td>
            <form:select path="studyPlan.applicantCategoryCode">
                <form:option value="0"><fmt:message key="jsp.selectbox.choose" /></form:option>
                <form:options items="${allApplicantCategories}" itemValue="code" itemLabel="description" />
            </form:select>
        </td> 
    </tr>
    
    <!-- STUDY -->
    <spring:bind path="requestAdmissionForm.student.primaryStudyId">
    <tr>
        <td class="label"><b><fmt:message key="jsp.general.study" /></b></td>
        <td class="required">
            <select name="${status.expression}" id="${status.expression}" onchange="document.getElementById('navigationSettings.panel').value='5';
                                                                            document.getElementById('studyPlanCardinalTimeUnit.studyGradeTypeId').value='0';
                                                                            document.getElementById('studyPlanCardinalTimeUnit.cardinalTimeUnitNumber').value='0';
                                                                            document.formdata.submit();">
                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                <c:set var="tmpStudyId" value="0" />
                <c:forEach var="oneStudygradeType" items="${requestAdmissionForm.allStudyGradeTypes}">
                    <c:choose>
                        <c:when test="${oneStudygradeType.studyId != tmpStudyId}">
                            <c:choose>
                                <c:when test="${oneStudygradeType.studyId == status.value}">
                                    <option value="<c:out value='${oneStudygradeType.studyId}'/>" selected="selected"><c:out value='${oneStudygradeType.studyDescription}'/></option>
                                </c:when>
                                <c:otherwise>
                                    <option value="<c:out value='${oneStudygradeType.studyId}'/>"><c:out value='${oneStudygradeType.studyDescription}'/></option>
                                </c:otherwise>
                            </c:choose>
                       </c:when>
                    </c:choose>
                    <c:set var="tmpStudyId" value="${oneStudygradeType.studyId}" />
                </c:forEach>
            </select>
        </td>
        <td><%@ include file="../includes/errorMessages.jsp" %></td>
    </tr>
    </spring:bind>

    <!--  STUDY GRADE TYPE -->
    <spring:bind path="requestAdmissionForm.studyPlanCardinalTimeUnit.studyGradeTypeId">
    <c:choose>
        <c:when test="${requestAdmissionForm.student.primaryStudyId != 0}">
            <tr>
                <td class="label"><fmt:message key="jsp.general.gradetypeallover" /></td>
                <td class="required">
                    <select width="450" name="${status.expression}" id="${status.expression}" onchange="document.getElementById('navigationSettings.panel').value='5';
                                                                    document.getElementById('studyPlanCardinalTimeUnit.cardinalTimeUnitNumber').value='0';
                                                                    document.formdata.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="oneStudyGradeType" items="${requestAdmissionForm.allStudyGradeTypes}">
                           <c:if test="${oneStudyGradeType.studyId == requestAdmissionForm.student.primaryStudyId  }" >
                           <c:forEach var="studyTime" items="${allStudyTimes}">
                               <c:choose>
                                <c:when test="${studyTime.code == oneStudyGradeType.studyTimeCode}">
                                  <c:set var="optionText" value="${oneStudyGradeType.gradeTypeDescription} - ${studyTime.description}"/>
                               </c:when>
                                </c:choose>
                            </c:forEach>
                            <c:forEach var="studyForm" items="${allStudyForms}">
                               <c:choose>
                                <c:when test="${studyForm.code == oneStudyGradeType.studyFormCode}">
                                     <c:set var="optionText" value="${optionText} - ${studyForm.description}"/>                                 
                                </c:when>
                                </c:choose>
                            </c:forEach>
                            <c:forEach var="studyIntensity" items="${allStudyIntensities}">
                               <c:choose>
                                <c:when test="${studyIntensity.code == oneStudyGradeType.studyIntensityCode}">
                                     <c:set var="optionText" value="${optionText} - ${studyIntensity.description}"/>                                     
                                </c:when>
                                </c:choose>
                            </c:forEach>
                            <c:forEach var="academicYear" items="${requestAdmissionForm.allAcademicYears}">
                               <c:choose>
                                   <c:when test="${academicYear.id == oneStudyGradeType.currentAcademicYearId}">
                                       <c:set var="optionText" value="${optionText} - (${academicYear.description})"/>                                     
                                    </c:when>
                               </c:choose>
                           </c:forEach>
                           <c:choose>
                                <c:when test="${oneStudyGradeType.id == status.value}"> 
                                    <c:set var="selectedStudyGradeType" value="${oneStudyGradeType}" scope="page" />
                                    <option value="<c:out value='${oneStudyGradeType.id}'/>" selected title="<c:out value='${optionText}'/>"><c:out value='${optionText}'/></option> 
                                </c:when>
                                <c:otherwise>
                                    <option value="<c:out value='${oneStudyGradeType.id}'/>" title="<c:out value='${optionText}'/>"><c:out value='${optionText}'/></option>
                                </c:otherwise>
                            </c:choose>
                            </c:if>
                        </c:forEach>
                    </select>
                    
                </td>
                <td><%@ include file="../includes/errorMessages.jsp" %></td>
            </tr>
        </c:when>
        <c:otherwise>
            <input type="hidden" name="${status.expression}" id="${status.expression}" value="<c:out value="${status.value}" />" />
        </c:otherwise>
    </c:choose>
    </spring:bind>

    <%-- CARDINAL TIME UNIT --%>
    <spring:bind path="requestAdmissionForm.studyPlanCardinalTimeUnit.cardinalTimeUnitNumber">
    <c:choose>
        <c:when test="${requestAdmissionForm.studyPlanCardinalTimeUnit.studyGradeTypeId != 0}">
            <tr>
                <td class="label">
                 <c:forEach var="cardinalTimeUnit" items="${allCardinalTimeUnits}">
                    <c:if test="${cardinalTimeUnit.code == selectedStudyGradeType.cardinalTimeUnitCode}">
                         <c:out value='${cardinalTimeUnit.description}'/>
                     </c:if>
                 </c:forEach>
                <%-- <fmt:message key="jsp.general.cardinaltimeunit" /> --%>
                </td>
                <td class="required">
                    <select name="${status.expression}" id="${status.expression}" onchange="document.getElementById('navigationSettings.panel').value='5';document.formdata.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach begin="1" end="${selectedStudyGradeType.numberOfCardinalTimeUnits}" var="currentCardinalTimeUnitNumber">
                            <c:choose>
                                <c:when test="${currentCardinalTimeUnitNumber == status.value}">
                                    <option value="<c:out value='${currentCardinalTimeUnitNumber}'/>" selected="selected"><c:out value='${currentCardinalTimeUnitNumber}'/></option>
                                </c:when>
                                <c:otherwise>
                                    <option value="<c:out value='${currentCardinalTimeUnitNumber}'/>"><c:out value='${currentCardinalTimeUnitNumber}'/></option>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </select>
                </td>
                <td><%@ include file="../includes/errorMessages.jsp" %></td>
            </tr>
        </c:when>
        <c:otherwise>
            <input type="hidden" name="${status.expression}" id="${status.expression}" value="<c:out value="${status.value}" />" />
        </c:otherwise>
    </c:choose>
    </spring:bind>

    <c:if test="${cTUNumber != 0}" >
        <c:set var="gradeTypeIsBachelor" value="${false}" />
        <c:set var="gradeTypeIsMaster" value="${false}" />

        <c:forEach var="gradeType" items="${allGradeTypes}">
            <c:if test="${selectedStudyGradeType.gradeTypeCode eq gradeType.code && gradeType.educationLevelCode eq GRADE_TYPE_BACHELOR}" >
                <c:set var="gradeTypeIsBachelor" value="${true}" />
            </c:if>
            <c:if test="${selectedStudyGradeType.gradeTypeCode eq gradeType.code && gradeType.educationLevelCode eq GRADE_TYPE_MASTER}" >
                <c:set var="gradeTypeIsMaster" value="${true}" />
            </c:if>
        </c:forEach>
        
        <!--  ADMISSION FOR MASTERS, 1ST CTU -->
        <c:if test="${gradeTypeIsMaster && cTUNumber == 1}">
            
            <spring:bind path="requestAdmissionForm.studyPlan.previousDiscipline.code">
            <tr>
                <td class="label">
                    <c:if test="${requestAdmissionForm.disciplineGroup.code == DISCIPLINEGROUP_CODE_MA_HRM}">
                        <fmt:message key="jsp.discipline.ma.hrm" />
                    </c:if>
                    <c:if test="${requestAdmissionForm.disciplineGroup.code == DISCIPLINEGROUP_CODE_MBA_GENERAL}">
                        <fmt:message key="jsp.discipline.mba.general" />
                    </c:if>
                    <c:if test="${requestAdmissionForm.disciplineGroup.code == DISCIPLINEGROUP_CODE_MBA_FINANCIAL}">
                        <fmt:message key="jsp.discipline.mba.financial" />
                    </c:if>
                    <c:if test="${requestAdmissionForm.disciplineGroup.code == DISCIPLINEGROUP_CODE_MSC_PM}">
                        <fmt:message key="jsp.discipline.msc.pm" />
                    </c:if>
                    <c:if test="${empty requestAdmissionForm.disciplineGroup.code}">
                        <fmt:message key="jsp.discipline.general.label" />
                    </c:if>
                </td>
                <td class="required" style="width:220px">
                   <form:select path="studyPlan.previousDiscipline.code" onchange="document.getElementById('navigationSettings.panel').value='5';document.formdata.submit();">
                        <form:option value="0"><fmt:message key="jsp.selectbox.choose" /></form:option>
                        <form:options class="xlong" items="${requestAdmissionForm.allDisciplines}" itemValue="code" itemLabel="description" />
                    </form:select>
                </td>
                <form:errors path="studyPlan.previousDiscipline.code" cssClass="error" element="td"/>
                    <c:if test="${ not empty requestAdmissionForm.txtDisciplineErr }">       
                        <p class="error">
                            ${requestAdmissionForm.txtDisciplineErr}
                        </p>
                    </c:if>
                </td>
            </tr>
            </spring:bind>
            <tr>
                <td class="label"><fmt:message key="jsp.discipline.grade" /></td>
                <td><form:input path="studyPlan.previousDisciplineGrade" /></td>
            </tr>
        </c:if>
        
        <!-- SECOND STUDY IF AVAILABLE -->
        <c:if test="${initParam.iSecondStudy == 'Y'}" >
            <spring:bind path="requestAdmissionForm.student.secondaryStudyId">
                <tr><td colspan="3"><hr></td></tr>
                <tr>
                    <td class="label"><b><fmt:message key="jsp.second.study" /></b></td>
                    <td>
                        <select name="${status.expression}" id="${status.expression}" onchange="document.getElementById('navigationSettings.panel').value='5';
                                                                                        document.formdata.submit();">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:set var="tmpStudyId" value="0" />
                            <c:forEach var="oneStudygradeType" items="${requestAdmissionForm.allStudyGradeTypes}">
                                <c:choose>
                                    <c:when test="${oneStudygradeType.studyId != tmpStudyId && oneStudygradeType.studyId != requestAdmissionForm.student.primaryStudyId }">
                                        <c:choose>
                                            <c:when test="${oneStudygradeType.studyId == status.value}">
                                                <option value="<c:out value='${oneStudygradeType.studyId}'/>" selected="selected"><c:out value='${oneStudygradeType.studyDescription}'/></option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="<c:out value='${oneStudygradeType.studyId}'/>"><c:out value='${oneStudygradeType.studyDescription}'/></option>
                                            </c:otherwise>
                                        </c:choose>
                                   </c:when>
                                </c:choose>
                                <c:set var="tmpStudyId" value="${oneStudygradeType.studyId}" />
                            </c:forEach>
                        </select>
                    </td>
                    <td><%@ include file="../includes/errorMessages.jsp" %></td>
                </tr>
            </spring:bind>
        
            <!--  SECOND STUDY GRADE TYPE -->
            <spring:bind path="requestAdmissionForm.secondStudyPlanCardinalTimeUnit.studyGradeTypeId">
            <c:choose>
                <c:when test="${requestAdmissionForm.student.secondaryStudyId != 0}">
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.gradetypeallover" /></td>
                        <td>
                            <select width="450" name="${status.expression}" id="${status.expression}" onchange="document.getElementById('navigationSettings.panel').value='5';
                                                                            document.formdata.submit();">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>                                         
                                <c:forEach var="oneStudyGradeType" items="${requestAdmissionForm.allStudyGradeTypes}">
                                <
                            
                                    <c:if test="${oneStudyGradeType.studyId == requestAdmissionForm.student.secondaryStudyId  }" >
                                        <c:forEach var="studyTime" items="${allStudyTimes}">
                                            <c:choose>
                                                <c:when test="${studyTime.code == oneStudyGradeType.studyTimeCode}">
                                                    <c:set var="optionText" value="${oneStudyGradeType.gradeTypeDescription} - ${studyTime.description}"/>
                                                </c:when>
                                            </c:choose>
                                        </c:forEach>
                                        <c:forEach var="studyForm" items="${allStudyForms}">
                                            <c:choose>
                                            <c:when test="${studyForm.code == oneStudyGradeType.studyFormCode}">
                                                <c:set var="optionText" value="${optionText} - ${studyForm.description}"/>                                 
                                            </c:when>
                                            </c:choose>
                                        </c:forEach>
                                        <c:forEach var="studyIntensity" items="${allStudyIntensities}">
                                            <c:choose>
                                            <c:when test="${studyIntensity.code == oneStudyGradeType.studyIntensityCode}">
                                                <c:set var="optionText" value="${optionText} - ${studyIntensity.description}"/>                                     
                                            </c:when>
                                            </c:choose>
                                        </c:forEach>
                                        <c:forEach var="academicYear" items="${requestAdmissionForm.allAcademicYears}">
                                            <c:choose>
                                                <c:when test="${academicYear.id == oneStudyGradeType.currentAcademicYearId}">
                                                    <c:set var="optionText" value="${optionText} - (${academicYear.description})"/>                                     
                                                </c:when>
                                            </c:choose>
                                        </c:forEach>
                                        <c:choose>
                                            <c:when test="${oneStudyGradeType.id == status.value}"> 
                                                <c:set var="selectedSecondStudyGradeType" value="${oneStudyGradeType}" scope="page" />
                                                <option value="<c:out value='${oneStudyGradeType.id}'/>" selected title="<c:out value='${optionText}'/>"><c:out value='${optionText}'/></option> 
                                            </c:when>
                                            <c:otherwise>
                                                <option value="<c:out value='${oneStudyGradeType.id}'/>" title="<c:out value='${optionText}'/>"><c:out value='${optionText}'/></option>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </c:forEach> 
                            </select>
                        </td> 
                        <td><%@ include file="../includes/errorMessages.jsp" %></td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <input type="hidden" name="${status.expression}" id="${status.expression}" value="<c:out value="${status.value}" />" />
                </c:otherwise>
            </c:choose>
            </spring:bind>
            
            <%-- SECOND CTU --%>
            <spring:bind path="requestAdmissionForm.secondStudyPlanCardinalTimeUnit.cardinalTimeUnitNumber">
            <c:choose>
                <c:when test="${requestAdmissionForm.secondStudyPlanCardinalTimeUnit.studyGradeTypeId != 0}">
       
                    <tr>
                        <td class="label">
                         <c:forEach var="cardinalTimeUnit" items="${allCardinalTimeUnits}">
                            <c:if test="${cardinalTimeUnit.code == selectedSecondStudyGradeType.cardinalTimeUnitCode}">
                                <c:out value=' ${cardinalTimeUnit.description}'/>
                             </c:if>
                         </c:forEach>
                        <%-- <fmt:message key="jsp.general.cardinaltimeunit" /> --%>
                        </td>
                        <td>
                            <select name="${status.expression}" id="${status.expression}" onchange="document.getElementById('navigationSettings.panel').value='5';document.formdata.submit();">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <c:forEach begin="1" end="${selectedSecondStudyGradeType.numberOfCardinalTimeUnits}" var="currentCardinalTimeUnitNumber">
                                    <c:choose>
                                        <c:when test="${currentCardinalTimeUnitNumber == status.value}">
                                            <option value="<c:out value='${currentCardinalTimeUnitNumber}'/>" selected="selected"><c:out value='${currentCardinalTimeUnitNumber}'/></option>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="<c:out value='${currentCardinalTimeUnitNumber}'/>"><c:out value='${currentCardinalTimeUnitNumber}'/></option>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </select>
                        </td>
                        <td><%@ include file="../includes/errorMessages.jsp" %></td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <input type="hidden" name="${status.expression}" id="${status.expression}" value="<c:out value="${status.value}" />" />
                </c:otherwise>
            </c:choose>
            </spring:bind>
        </c:if>
        
        
        <!-- ADMISSION FOR BACHELORS, 1ST CTU -->
        <c:choose>
            <c:when test="${requestAdmissionForm.student.foreignStudent != 'Y'
                && (gradeTypeIsBachelor && cTUNumber == 1)}">
         
                <%-- SECONDARY SCHOOL SUBJECTS --%>
                <tr><td colspan="3">&nbsp;</td></tr>
                <tr>
                    <td class="header" colspan="3">
                       <fmt:message key="jsp.general.secondaryschoolsubjects" />
                    </td>
                </tr>
                
                <c:choose>
                    <c:when test="${ungroupedSecondarySchoolSubjects != null && not empty ungroupedSecondarySchoolSubjects}">  
                        <tr>
                            <td colspan="3" class="compulsoryPanel label">
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
                                                                                                        
                                                <tr>
                                                    <td><c:out value='${ungroupedSecondarySchoolSubject.description}'/><br /></td>
                                                    <td> 
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
                                                        <select id="ungroupedSecondarySchoolSubjects[${rowIndex3.index}].grade" name="ungroupedSecondarySchoolSubjects[${rowIndex3.index}].grade" >
                                                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                                
                                                                <c:forEach begin="${setFrom}" end="${setTo}" varStatus="gradePoint">
                                                                    <c:choose>
                                                                        <c:when test="${gradePoint.count == ungroupedSecondarySchoolSubject.grade}">
                                                                            <option value="<c:out value='${gradePoint.count}'/>" selected="selected"><c:out value='${gradePoint.count}'/></option>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <option value="<c:out value='${gradePoint.count}'/>"><c:out value='${gradePoint.count}'/></option>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:forEach>
                                                        </select>
                                                    </td>
                                                    <td> 
                                                        <select id="ungroupedSecondarySchoolSubjects[${rowIndex3.index}].level" name="ungroupedSecondarySchoolSubjects[${rowIndex3.index}].level" >
                                                            <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                                                <c:choose>
                                                                    <c:when test="${'A' == ungroupedSecondarySchoolSubject.level}">
                                                                         <option value="A" selected="selected"><fmt:message key="jsp.secondaryschoolsubjects.advanced" /></option>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <option value="A"><fmt:message key="jsp.secondaryschoolsubjects.advanced" /></option>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                <<c:choose>
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
                        
                    </c:otherwise>
                </c:choose>
                
                
                
            </c:when> <%-- not foreign student and gradetype = BACHELOR and ctu = 1 --%>
        
            <%-- admission for study higher than bachelor, ctu 1 or for foreign student --%>
            <c:otherwise>
                <%-- QUALIFICATIONS --%>
                <tr>
                    <td colspan="3"><br><hr></td>
                </tr>
                <tr>
                    <td class="label" colspan="3">
                        <fmt:message key="jsp.general.qualifications.obtained" />
                    </td>
                </tr>
                <tr><td colspan="3">&nbsp;</td></tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                    <td><a class="button" href="<c:url value='/obtainedqualification_admission.view'/>?<c:out value='newForm=true&panel=5&studentId=${studentId}'/>"><fmt:message key="jsp.href.add" /></a></td>
                </tr>
                <c:choose>
                    <c:when test="${requestAdmissionForm.allObtainedQualifications != null 
                                            && not empty requestAdmissionForm.allObtainedQualifications}">  
                        <tr>
                            <td colspan="3">
                                <table id="obtainedQualificationTblData">   
                                <tr>
                                    <th><fmt:message key="jsp.qualification.university" /></th>
                                    <th><fmt:message key="jsp.general.startdate" /></th>
                                    <th><fmt:message key="jsp.general.enddate" /></th>
                                    <th><fmt:message key="jsp.qualification.endgrade.date" /></th>
                                    <th><fmt:message key="jsp.qualification.qualification" /></th>
                                    <th><fmt:message key="jsp.qualification.gradetype" /></th>
                                </tr>
                               
                                <input type="hidden" name="deleteQualification" id="deleteQualification" value="" /> 
                                <c:forEach var="obtainedQualification" items="${requestAdmissionForm.allObtainedQualifications}" varStatus="rowIndex">
                                    <tr>
                                        <td><c:out value='${obtainedQualification.university}'/></td>
                                        <td><fmt:formatDate pattern="dd/MM/yyyy" value="${obtainedQualification.startDate}" /></td>
                                        <td><fmt:formatDate pattern="dd/MM/yyyy" value="${obtainedQualification.endDate}" /></td>
                                        <td><fmt:formatDate pattern="dd/MM/yyyy" value="${obtainedQualification.endGradeDate}" /></td>
                                        <td><c:out value='${obtainedQualification.qualification}'/></td>
                                        <td>
                                            <c:forEach var="oneGradeType" items="${requestAdmissionForm.allGradeTypes}">
                                               <c:choose>
                                                    <c:when test="${oneGradeType.code ==obtainedQualification.gradeTypeCode}"> 
                                                        <c:out value='${oneGradeType.description}'/>
                                                    </c:when>
                                                </c:choose>
                                            </c:forEach>    
                                        </td>
                                        <td>
                                            <a href="#" onclick="if (confirm('<fmt:message key="jsp.qualification.obtained.delete.confirm" />')) {document.getElementById('navigationSettings.panel').value='5';document.getElementById('deleteQualification').value=${rowIndex.index};document.formdata.submit();};">
                                                <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                            </a>
                                        </td> 
                                    </tr>
                                </c:forEach>
                                <script type="text/javascript">alternate('obtainedQualificationTblData',true)</script>
                                </table>
                            </td>
                        </tr> 
                    </c:when>
                </c:choose>

                <%-- CAREERPOSITIONS --%>
                <tr>
                    <td colspan="3"><br><hr></td>
                </tr>
                <tr>
                    <td class="label" colspan="3">
                        <fmt:message key="jsp.general.careerpositions" />
                    </td>
                </tr>
                <tr><td colspan="3">&nbsp;</td></tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                    <td><a class="button" href="<c:url value='/careerposition_admission.view'/>?<c:out value='newForm=true&panel=5&studentId=${studentId}'/>"><fmt:message key="jsp.href.add" /></a></td>
                </tr>
                <c:choose>
                    <c:when test="${requestAdmissionForm.allCareerPositions != null && not empty requestAdmissionForm.allCareerPositions}">  
                        <tr>
                            <td colspan="3">
                                <table id="careerPositionTblData">   
                                <tr>
                                    <th><fmt:message key="jsp.careerposition.employer" /></th>
                                    <th><fmt:message key="jsp.general.startdate" /></th>
                                    <th><fmt:message key="jsp.general.enddate" /></th>
                                    <th><fmt:message key="jsp.careerposition.position" /></th>
                                    <th><fmt:message key="jsp.careerposition.responsibility" /></th>
                                </tr>
                               
                                <input type="hidden" name="deleteCareer" id="deleteCareer" value="" /> 
                                <c:forEach var="careerPosition" items="${requestAdmissionForm.allCareerPositions}" varStatus="rowIndex">
                                    <tr>
                                        <td><c:out value='${careerPosition.employer}'/></td>
                                        <td><fmt:formatDate pattern="dd/MM/yyyy" value="${careerPosition.startDate}" /></td>
                                        <td><fmt:formatDate pattern="dd/MM/yyyy" value="${careerPosition.endDate}" /></td>
                                        <td><c:out value='${careerPosition.position}'/></td>
                                        <td><c:out value='${careerPosition.responsibility}'/></td>
                                        <td>
                                            <a href="#" onclick="if (confirm('<fmt:message key="jsp.careerposition.delete.confirm" />')) {document.getElementById('navigationSettings.panel').value='5';document.getElementById('deleteCareer').value=${rowIndex.index};document.formdata.submit();};">
                                                <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                            </a>
                                        </td> 
                                    </tr>
                                </c:forEach>
                                <script type="text/javascript">alternate('careerPositionTblData',true)</script>
                                </table>
                            </td>
                        </tr> 
                    </c:when>
                </c:choose>
        </c:otherwise>
    </c:choose>
    
    <!-- list of 2 referees -->
    <c:if test="${gradeTypeIsMaster}">
        <tr><td colspan="3"><br><hr></td></tr>
        <tr>
            <td class="label" colspan="3">
                <fmt:message key="jsp.general.referees" />
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <table>
                    <tr>
                        <th><fmt:message key="jsp.general.name" /></th>
                        <th><fmt:message key="jsp.general.address" /></th>
                        <th><fmt:message key="jsp.general.telephone" /></th>
                        <th><fmt:message key="jsp.general.email" /></th>
                    </tr>
                    <input type="hidden" id="firstReferee.orderBy" name="firstReferee.orderBy" value="1" />
                    <tr>
                        <td><input type="text" id="firstReferee.name" name="firstReferee.name" size="40" value="<c:out value="${firstReferee.name}" />" /></td>
                        <td><input type="text" id="firstReferee.address" name="firstReferee.address" size="40" value="<c:out value="${firstReferee.address}" />" /></td>
                        <td><input type="text" id="firstReferee.telephone" name="firstReferee.telephone" size="40" value="<c:out value="${firstReferee.telephone}" />" /></td>
                        <td><input type="text" id="firstReferee.email" name="firstReferee.email" size="40" value="<c:out value="${firstReferee.email}" />" /></td>
                    </tr>
                    <input type="hidden" id="secondReferee.orderBy" name="secondReferee.orderBy" value="2" />
                     <tr>
                        <td><input type="text" id="secondReferee.name" name="secondReferee.name" size="40" value="<c:out value="${secondReferee.name}" />" /></td>
                        <td><input type="text" id="secondReferee.address" name="secondReferee.address" size="40" value="<c:out value="${secondReferee.address}" />" /></td>
                        <td><input type="text" id="secondReferee.telephone" name="secondReferee.telephone" size="40" value="<c:out value="${secondReferee.telephone}" />" /></td>
                        <td><input type="text" id="secondReferee.email" name="secondReferee.email" size="40" value="<c:out value="${secondReferee.email}" />" /></td>
                    </tr>
                </table>
            </td>
        </tr>
    </c:if>
    
    </c:if> <%-- CTU number not 0 --%>
    <tr><td colspan="4">&nbsp;</td></tr> 

</table>