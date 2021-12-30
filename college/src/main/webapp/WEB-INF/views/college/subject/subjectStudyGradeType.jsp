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

    <!-- necessary spring binds for organization and navigationSettings
         regarding form handling through includes -->
    <spring:bind path="subjectStudyGradeTypeForm.organization">
        <c:set var="organization" value="${status.value}" scope="page" />
    </spring:bind>

    <spring:bind path="subjectStudyGradeTypeForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectStudyGradeTypeForm.subjectStudyGradeType">
        <c:set var="subjectStudyGradeType" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectStudyGradeTypeForm.subject">
        <c:set var="subject" value="${status.value}" scope="page" />
     </spring:bind>
    
     <spring:bind path="subjectStudyGradeTypeForm.subjectStudyGradeType.gradeTypeCode">
        <c:set var="gradeTypeCode" value="${status.value}" scope="page" />
     </spring:bind>
     
     <spring:bind path="subjectStudyGradeTypeForm.currentStudyGradeTypeId">
        <c:set var="currentStudyGradeTypeId" value="${status.value}" scope="page" />
    </spring:bind>
        
<div id="tabcontent">

<fieldset>
    <legend> 
        <a href="<c:url value='/college/subjects.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt; 
            <a href="<c:url value='/college/subject.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;subjectId=${subject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"> 
            <c:choose>
            <c:when test="${subject.subjectDescription != null && subject.subjectDescription != ''}">
                <c:out value="${fn:substring(subject.subjectDescription,0,initParam.iTitleLength)}"/>
            </c:when>
            <c:otherwise>
                <fmt:message key="jsp.href.new" />
            </c:otherwise>
        </c:choose>
        </a> 
        &nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.subjectstudygradetype" /> 
    </legend>
</fieldset>

<div id="tp1" class="TabbedPanel">
 <ul class="TabbedPanelsTabGroup">
  <li class="TabbedPanelsTab"><fmt:message key="jsp.general.edit" /></li>
 </ul>
 <div class="TabbedPanelsContentGroup">
  <div class="TabbedPanelsContent">
   <div class="Accordion" id="Accordion1" tabindex="0">
    <div class="AccordionPanel">
     <div class="AccordionPanelTab"><fmt:message    key="jsp.general.subjectstudygradetype" /></div>
      <div class="AccordionPanelContent">
                        
        <c:choose>
            <c:when test="${(not empty subjectStudyGradeTypeForm.showSubjectStudyGradeTypeError)}">             
                <p align="left" class="error">
                    <c:out value="${subjectStudyGradeTypeForm.showSubjectStudyGradeTypeError}"/>
                </p>
            </c:when>
        </c:choose>
        <c:choose>        
            <c:when test="${not empty subjectStudyGradeTypeForm.txtMsg }">       
               <p align="right" class="msg">
                    <c:out value="${subjectStudyGradeTypeForm.txtMsg}"/>
               </p>
            </c:when>
        </c:choose>
        <c:choose>        
            <c:when test="${not empty subjectStudyGradeTypeForm.txtErr }">       
               <p align="right" class="errorwide">
                    <c:out value="${subjectStudyGradeTypeForm.txtErr}"/>
               </p>
            </c:when>
        </c:choose>
        
        <form name="formdata" method="post">
            <input type="hidden" name="submitFormObject" id="submitFormObject" value="" />
       
        <table>
        <tr>
            <td colspan="2">
                <%@ include file="../../includes/organizationAndNavigationDetail.jsp"%>
            </td>
           
        </tr>
          
        <!--  STUDY ID -->
        <sec:authorize access="hasRole('READ_STUDIES')">

            <!--  SUBJECT (not editable) -->
            <tr>
                <td class="label"><fmt:message key="jsp.general.subject" /></td>
                <td><c:out value="${subject.subjectDescription}"/></td>
            </tr>

            <!--  CURRENT ACADEMIC YEAR (not editable) -->
            <tr>
                <td class="label"><fmt:message key="jsp.general.academicyear" /></td>
                <td>
                    <c:forEach var="academicYear" items="${subjectStudyGradeTypeForm.allAcademicYears}">
                         <c:choose>
                             <c:when test="${academicYear.id == subject.currentAcademicYearId}">
                                 <c:out value="${academicYear.description}"/>
                             </c:when>
                             
                         </c:choose>
                    </c:forEach>
                </td>
            </tr>
            <!-- study -->
            <spring:bind path="subjectStudyGradeTypeForm.subjectStudyGradeType.studyId">  
                <c:set var="studyId" value="${status.value}" scope="page" />
                 <tr>
                    <td class="label"><fmt:message key="jsp.general.study" /></td>
                    <td class="required">
                        <select id="${status.expression}" name="${status.expression}" onchange="
                            document.getElementById('subjectStudyGradeType.gradeTypeCode').value='';
                            document.getElementById('subjectStudyGradeType.studyGradeTypeId').value='0';
                            document.getElementById('subjectStudyGradeType.cardinalTimeUnitNumber').value='';
                            document.formdata.submit();">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="oneStudy" items="${subjectStudyGradeTypeForm.allStudies}">
                                <c:choose>
                                    <c:when test="${(status.value == oneStudy.id)}">
                                        <option value="${oneStudy.id}" selected="selected"><c:out value="${oneStudy.studyDescription}"/></option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${oneStudy.id}"><c:out value="${oneStudy.studyDescription}"/></option>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </select>
                    </td>
                    <td width="38%"><c:forEach var="error" items="${status.errorMessages}">
                        <span class="error"> ${error}</span>
                    </c:forEach></td>   
                </tr>
            </spring:bind>
        </sec:authorize>

        <!--  GRADE TYPE CODE -->
        <spring:bind path="subjectStudyGradeTypeForm.subjectStudyGradeType.gradeTypeCode">
            <tr>
                <td class="label"><fmt:message key="jsp.general.gradetypecode" /></td>
                <td class="required">
                    <select id="${status.expression}" name="${status.expression}" onchange="
                            document.getElementById('subjectStudyGradeType.studyGradeTypeId').value='0';
                            document.getElementById('subjectStudyGradeType.cardinalTimeUnitNumber').value='';
                            document.formdata.submit();">
                        <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                        <!-- loop through all gradeTypes linked to the selected study -->
                        <c:forEach var="oneStudyGradeType" items="${subjectStudyGradeTypeForm.distinctStudyGradeTypesForStudy}">
                            <c:choose>
                                <c:when test="${status.value == oneStudyGradeType.gradeTypeCode}">
                                    <option value="${oneStudyGradeType.gradeTypeCode}" selected="selected"><c:out value="${oneStudyGradeType.gradeTypeDescription}"/></option>
                                </c:when>
                                <c:otherwise>
                                    <option value="${oneStudyGradeType.gradeTypeCode}"><c:out value="${oneStudyGradeType.gradeTypeDescription}"/></option>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </select>
                </td>
                <td>
                    <c:forEach var="error" items="${status.errorMessages}">
                        <span class="error"> ${error}</span>
                    </c:forEach>
                </td>
            </tr>
        </spring:bind>

        <spring:bind path="subjectStudyGradeTypeForm.subjectStudyGradeType.studyGradeTypeId">
        <tr>
            <td class="label"><fmt:message key="jsp.general.studyform" />/<fmt:message key="jsp.general.studytime" />
            </td>
            <td class="required">
                 <select name="${status.expression}" id="${status.expression}" onchange="
                            document.getElementById('subjectStudyGradeType.cardinalTimeUnitNumber').value='';
                            document.formdata.submit();">
                     <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                     <c:forEach var="studyGradeType" items="${subjectStudyGradeTypeForm.allStudyGradeTypesForStudy}">
                        <c:set var="disabled" value="" scope="page" /> 
                         <c:choose>
                             <c:when test="${studyGradeType.id != null && studyGradeType.id == status.value}">
                                 <option value="${status.value}" selected="selected">
                                 <c:forEach var="studyForm" items="${allStudyForms}">
                                      <c:choose>
                                          <c:when test="${studyGradeType.studyFormCode != null && 
                                                    studyGradeType.studyFormCode != ''
                                                       && studyForm.code == studyGradeType.studyFormCode}">
                                              <c:out value="${studyForm.description}"/>
                                          </c:when>
                                      </c:choose>
                                 </c:forEach>
                                 <c:forEach var="studyTime" items="${allStudyTimes}">
                                      <c:choose>
                                          <c:when test="${studyGradeType.studyTimeCode != null && 
                                                    studyGradeType.studyTimeCode != ''
                                                       && studyTime.code == studyGradeType.studyTimeCode}">
                                              /<c:out value="${studyTime.description}"/>
                                          </c:when>
                                       </c:choose>
                                 </c:forEach>
                                 </option>
                             </c:when>
                             <c:otherwise>
                                <c:forEach var="studyGradeTypeOfSubject" items="${subjectStudyGradeTypeForm.allStudyGradeTypesForSubject}">
                                    <c:choose>
                                        <c:when test="${studyGradeTypeOfSubject.id == studyGradeType.id && studyGradeTypeOfSubject.id != currentStudyGradeTypeId}">
                                            <c:set var="disabled" value="disabled" scope="page" />
                                        </c:when>
                                    </c:choose>  
                                </c:forEach>
                                <c:choose>
                                    <c:when test="${disabled == ''}">
                                        <option value="${studyGradeType.id}"> 
                                         <c:forEach var="studyForm" items="${allStudyForms}">
                                              <c:choose>
                                                  <c:when test="${studyGradeType.studyFormCode != null && 
                                                            studyGradeType.studyFormCode != ''
                                                               && studyForm.code == studyGradeType.studyFormCode}">
                                                      <c:out value="${studyForm.description}"/>
                                                  </c:when>
                                              </c:choose>
                                         </c:forEach>
                                         <c:forEach var="studyTime" items="${allStudyTimes}">
                                              <c:choose>
                                                  <c:when test="${studyGradeType.studyTimeCode != null && 
                                                            studyGradeType.studyTimeCode != ''
                                                               && studyTime.code == studyGradeType.studyTimeCode}">
                                                      /<c:out value="${studyTime.description}"/>
                                                  </c:when>
                                               </c:choose>
                                         </c:forEach>
                                        </option>
                                    </c:when>
                                </c:choose>
                             </c:otherwise>
                        </c:choose>
                     </c:forEach>
                 </select>
             </td>
             <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                 </c:forEach>
            </td>
        </tr>
        </spring:bind>

        <!--  CARDINAL TIME UNIT NUMBER -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.cardinaltimeunit.number" /></td>
            <td class="required">
                <form:select path="subjectStudyGradeTypeForm.subjectStudyGradeType.cardinalTimeUnitNumber">
                    <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                    <form:option value="0"><fmt:message key='jsp.general.any' /></form:option>
                    <c:forEach begin="1" end="${subjectStudyGradeTypeForm.maxNumberOfCardinalTimeUnits}" var="current">
                        <form:option value="${current}"><c:out value="${current}"/></form:option>
                    </c:forEach>
                </form:select>
            </td> 
            <td>
                <form:errors path="subjectStudyGradeTypeForm.subjectStudyGradeType.cardinalTimeUnitNumber" cssClass="error"/>
            </td>
        </tr>

        <!-- RIGIDITYTYPE -->
        <tr>
            <td class="label"><fmt:message key="jsp.subject.rigiditytype" /></td>
            <spring:bind path="subjectStudyGradeTypeForm.subjectStudyGradeType.rigidityTypeCode">
            <td class="required">
                <c:choose>
                    <c:when test="${opusUserRole.role != 'student' && opusUserRole.role != 'guest'}">
                        <select name="${status.expression}" id="${status.expression}">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                    </c:when>
                </c:choose>
                    <c:forEach var="rigidityType" items="${allRigidityTypes}">
                        <c:choose>
                            <c:when test="${opusUserRole.role != 'student' && opusUserRole.role != 'guest'}">
                                <c:choose>
                                    <c:when test="${rigidityType.code == status.value}">
                                        <option value="${rigidityType.code}" selected="selected"><c:out value="${rigidityType.description}"/></option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${rigidityType.code}"><c:out value="${rigidityType.description}"/></option>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${rigidityType.code == status.value}">
                                        <c:out value="${rigidityType.description}"/>
                                    </c:when>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                <c:choose>
                    <c:when test="${opusUserRole.role != 'student' && opusUserRole.role != 'guest'}">
                        </select>
                    </c:when>
                </c:choose>
            </td>
            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
            </spring:bind>
        </tr>
        <!-- IMPORTANCE CODE -->
        <spring:bind path="subjectStudyGradeTypeForm.subjectStudyGradeType.importanceTypeCode">                                        
        <c:if test="${initParam.iMajorMinor == 'Y'}">
            <tr>
            <td class="label"><fmt:message key="jsp.general.major" /> / <fmt:message key="jsp.general.minor" /></td>
            <td class="required">
                <select name="${status.expression}">
                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                    <c:forEach var="importanceType" items="${allImportanceTypes}">
                        <c:choose>
                          <c:when test="${importanceType.code == status.value}">
                              <option value="${importanceType.code}" selected="selected"><c:out value="${importanceType.description}"/></option>
                          </c:when>
                          <c:otherwise>
                              <option value="${importanceType.code}"><c:out value="${importanceType.description}"/></option>
                          </c:otherwise>
                      </c:choose>
                    </c:forEach>
                </select>
            </td>
            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
            </tr>
        </c:if>
        </spring:bind>
                                
        <!--  ACTIVE -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.active" /></td>
            <td>
                <select name="subjectStudyGradeType.active">
                    <c:choose>
                        <c:when test="${'Y' == subjectStudyGradeType.active}">
                            <option value="Y" selected="selected"><fmt:message key="jsp.general.yes" /></option>
                            <option value="N"><fmt:message key="jsp.general.no" /></option>
                        </c:when>
                        <c:otherwise>
                            <option value="Y"><fmt:message key="jsp.general.yes" /></option>
                            <option value="N" selected="selected"><fmt:message key="jsp.general.no" /></option>
                        </c:otherwise>
                    </c:choose>
                </select>
            </td>
        </tr>

        <!-- SUBMIT BUTTON -->
        <tr>
            <td class="label">&nbsp;</td>
            <td>
                <c:choose>
                    <c:when test="${opusUserRole.role != 'student' && opusUserRole.role != 'guest'}">
                        <input type="submit" name="submitformdata" value="<fmt:message key="jsp.button.submit" />" onclick="document.getElementById('submitFormObject').value='true';document.formdata.submit();" />
                    </c:when>
                </c:choose>
            </td>
        </tr>
            
        <!--  SubjectPrerequisites -->
        <c:choose>
            <c:when test="${ not empty showSubjectPrerequisiteError }">       
                <tr>
                    <td align="left" colspan="3">
                        <p class="error">
                            <fmt:message key="jsp.error.subjectprerequisite.delete" />
                            <c:out value="${showSubjectPrerequisiteError}"/>
                        </p>
                    </td>
                </tr>
            </c:when>
        </c:choose>
        <c:choose>
        <c:when test="${currentStudyGradeTypeId != 0}">
                <tr><td colspan="3">&nbsp;</td></tr>
                <tr>
                    <td class="label"><fmt:message key="jsp.general.subjectPrerequisites" /></td>
                    <td colspan="2" align="right">
                        <sec:authorize access="hasRole('CREATE_SUBJECT_PREREQUISITES')">
                            <a class="button" href="<c:url value='/college/subjectprerequisite.view?newForm=true&amp;tab=0&amp;panel=0&amp;subjectStudyGradeTypeId=${subjectStudyGradeType.id}&amp;mainSubjectId=${subject.id}&amp;primaryStudyId=${studyId }&amp;gradeTypeCode=${gradeTypeCode }&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                        </sec:authorize>
                    </td>
                </tr>
                
                <tr>
                    <td colspan="3">
                        <!-- list of prerequisites -->
                        <table class="tabledata2" id="TblData2_subjectStudyGradeType">
                            <tr>
                                <th width="90"><fmt:message key="jsp.general.code" /></th>
                                <th><fmt:message key="jsp.general.description" /></th>
<%--                                                    <th><fmt:message key="jsp.general.academicyear" /></th> --%>
                                <th><fmt:message key="jsp.general.active" /></th>
                                <td width="30">&nbsp;</td>
                            </tr>
                            <c:forEach var="oneSubjectPrerequisite" items="${subjectStudyGradeType.subjectPrerequisites}">
                                <tr>
                                    <td>
                                        <c:out value="${oneSubjectPrerequisite.requiredSubjectCode}"/>
                                    </td>
                                    <td>
                                        <c:out value="${oneSubjectPrerequisite.requiredSubjectDescription}"/>
                                    </td>
<%--                                                        <td>
                                                            ${oneSubjectPrerequisite.requiredSubjectAcademicYear.description}
                                                        </td> --%>
                                    <td>
                                        <c:out value="${oneSubjectPrerequisite.active}"/>
                                    </td>
                                    <!-- delete button -->
                                    <td class="buttonsCell">
                                        <sec:authorize access="hasRole('DELETE_SUBJECT_PREREQUISITES')">
                                            <a href="<c:url value='/college/subjectprerequisite_delete.view?newForm=true&amp;tab=2&amp;panel=0&amp;subjectStudyGradeTypeId=${oneSubjectPrerequisite.subjectStudyGradeTypeId}&amp;requiredSubjectCode=${oneSubjectPrerequisite.requiredSubjectCode}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"  
                                            onclick="return confirm('<fmt:message key="jsp.subjectprerequisite.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                        </sec:authorize>
                                    </td>
                                </tr>
                            </c:forEach>
                           
                        </table>
                        <script type="text/javascript">alternate('TblData2_subjectStudyGradeType',true)</script>
                    </td>
                </tr>
        </c:when>
        </c:choose>

            <!--  Classgroups -->
            <c:if test="${!empty param['showSubjectClassgroupError']}">
                <tr>
                    <td align="left" colspan="3">
                        <p class="error">
                            <c:out value="${param['showSubjectClassgroupError']}"/>
                        </p>
                    </td>
                </tr>
            </c:if>
            
            
            <c:if test="${currentStudyGradeTypeId != 0}">
                <tr>
                    <td colspan="3">&nbsp;</td>
                </tr>
                <tr>
                    <td class="label"><fmt:message key="general.classgroups" /></td>
                    <td colspan="2" align="right">
                        <sec:authorize access="hasRole('CREATE_SUBJECT_CLASSGROUPS')">
                            <c:if test="${subjectStudyGradeType.studyGradeTypeId != 0}"> 
                                <a class="button" href="<c:url value='/college/subject/subjectclassgroup.view?newForm=true&amp;tab=0&amp;panel=0&amp;subjectStudyGradeTypeId=${subjectStudyGradeType.id}&amp;studyGradeTypeId=${subjectStudyGradeType.studyGradeTypeId}&amp;subjectId=${subject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                    <fmt:message key="jsp.href.add" />
                                </a>
                            </c:if>
                        </sec:authorize>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                    
                        <!-- list of classgroups -->
                        <table class="tabledata2" id="TblData2_subjectClassgroup">
                            <tr>
                            <th><fmt:message key="jsp.general.name" /></th>
                            <th><fmt:message key="jsp.general.academicyear" /></th>
                            <th><fmt:message key="jsp.general.study" /></th>
                            <th><fmt:message key="jsp.general.studygradetype" /></th>
                            </tr>

                            <c:forEach var="oneClassgroup" items="${subjectStudyGradeTypeForm.allClassgroups}">
                                <tr>
                                    <td>
                                        <c:out value="${oneClassgroup.description}"/>
                                    </td>
                                    <td>
                                        <c:forEach var="academicYear" items="${subjectStudyGradeTypeForm.allAcademicYears}">
                                             <c:choose>
                                                 <c:when test="${academicYear.id == subject.currentAcademicYearId}">
                                                     <c:out value="${academicYear.description}"/>
                                                 </c:when>
                                             </c:choose>
                                        </c:forEach>
                                    </td>
                                    <td>
                                        <c:forEach var="oneStudy" items="${subjectStudyGradeTypeForm.allStudies}">
                                            <c:if test="${subjectStudyGradeTypeForm.subjectStudyGradeType.studyId == oneStudy.id}">
                                                <c:out value="${oneStudy.studyDescription}"/>
                                            </c:if>
                                        </c:forEach>
                                    </td>
                                    <td>
                                        <c:forEach var="oneStudyGradeType" items="${subjectStudyGradeTypeForm.distinctStudyGradeTypesForStudy}">
                                            <c:if test="${subjectStudyGradeTypeForm.subjectStudyGradeType.gradeTypeCode == oneStudyGradeType.gradeTypeCode}">
                                                <c:out value="${oneStudyGradeType.gradeTypeDescription}"/>
                                            </c:if>
                                        </c:forEach>
                                    </td>
                                    <td class="buttonsCell">
                                        <sec:authorize access="hasRole('DELETE_SUBJECT_CLASSGROUPS')">
                                            <a class="imageLink" href="<c:url value='/college/subject/subjectclassgroup_delete.view?newForm=true&amp;tab=0&amp;panel=0&amp;subjectStudyGradeTypeId=${subjectStudyGradeType.id}&amp;subjectId=${subject.id}&amp;classgroupId=${oneClassgroup.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>" 
                                            onclick="return confirm('<fmt:message key="jsp.subjectclassgroup.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                        </sec:authorize>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table> 
                        <script type="text/javascript">alternate('TblData2_subjectClassgroup',true)</script>

                        <%--
                                    <td class="buttonsCell"><sec:authorize access="hasRole('DELETE_SUBJECT_PREREQUISITES')">
                                            <a
                                                href="<c:url value='/college/subjectprerequisite_delete.view?newForm=true&amp;tab=2&amp;panel=0&amp;subjectStudyGradeTypeId=${oneSubjectPrerequisite.subjectStudyGradeTypeId}&amp;requiredSubjectCode=${oneSubjectPrerequisite.requiredSubjectCode}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"
                                                onclick="return confirm('<fmt:message key="jsp.subjectprerequisite.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />"
                                                alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                        </sec:authorize></td>
                        --%>

                    </td>
                </tr>
            </c:if>

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
    </script></div>

<%@ include file="../../footer.jsp"%>

