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

<%--
 * Copyright (c) 2007 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
--%>

<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <%-- authorizations --%>
    <sec:authorize access="hasAnyRole('CREATE_SUBJECT_STUDYGRADETYPES','UPDATE_SUBJECT_STUDYGRADETYPES')">
        <c:set var="editStudyGradeTypes" value="${true}"/>
    </sec:authorize>
    <c:if test="${not editStudyGradeTypes}">
        <sec:authorize access="hasRole('READ_SUBJECT_STUDYGRADETYPES')">
            <c:set var="showStudyGradeTypes" value="${true}"/>
        </sec:authorize>
    </c:if>
        
    <!-- necessary spring binds for organization and navigationSettings
         regarding form handling through includes -->
    <spring:bind path="studyGradeTypeSubjectForm.organization">
        <c:set var="organization" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="studyGradeTypeSubjectForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="studyGradeTypeSubjectForm.subjectStudyGradeType">
        <c:set var="subjectStudyGradeType" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="studyGradeTypeSubjectForm.studyGradeType">
        <c:set var="studyGradeType" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="studyGradeTypeSubjectForm.subject">
        <c:set var="subject" value="${status.value}" scope="page" />
     </spring:bind>
    
     <spring:bind path="studyGradeTypeSubjectForm.subjectStudyGradeType.gradeTypeCode">
        <c:set var="gradeTypeCode" value="${status.value}" scope="page" />
     </spring:bind>
     
    <div id="tabcontent">

        <form>
            <fieldset>
                <legend>
                    <a href="<c:url value='/college/studies.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
                    <a href="<c:url value='/college/study.view?tab=0&panel=0&studyId=${studyGradeType.studyId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                    <c:choose>
                        <c:when test="${studyGradeType.studyDescription != null && studyGradeType.studyDescription != ''}" >
                            ${fn:substring(studyGradeType.studyDescription,0,initParam.iTitleLength)}
                        </c:when>
                        <c:otherwise>
                            <fmt:message key="jsp.href.new" />
                        </c:otherwise>
                    </c:choose>
                    </a> /
                    <a href="<c:url value='/college/studygradetype.view?tab=0&panel=0&studyGradeTypeId=${studyGradeType.id}&studyId=${studyGradeType.studyId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                    <c:choose>
                        <c:when test="${studyGradeType.gradeTypeCode != null && studyGradeType.gradeTypeCode != ''}" >
                            ${studyGradeType.gradeTypeDescription}
                        </c:when>
                        <c:otherwise>
                            <fmt:message key="jsp.href.new" />
                        </c:otherwise>
                    </c:choose>
                    </a>
                    &nbsp;(${studyGradeTypeSubjectForm.academicYear.description})
                    &nbsp;>&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.subject" />
                </legend>
            </fieldset>
        </form>


        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.edit" /></li>               
            </ul>

            <div class="TabbedPanelsContentGroup">   
                    <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion1" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab"><fmt:message key="jsp.general.subjectstudygradetype" /></div>
                                <div class="AccordionPanelContent">
                                    <c:choose>        
                                          <c:when test="${ not empty showStudyGradeTypeSubjectError }">       
                                             <p align="left" class="error">
                                                    ${showStudyGradeTypeSubjectError}
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
                                        <c:choose>
                                           <c:when test="${editStudyGradeTypes}"> 
                                               <spring:bind path="studyGradeTypeSubjectForm.subjectStudyGradeType.studyId">  
                                                    <c:set var="studyId" value="${status.value}" scope="page" />
                                                     <tr>
                                                        <td class="label"><fmt:message key="jsp.general.study" /></td>
                                                        <td class="required">
                                                            <select id="${status.expression}" name="${status.expression}" onchange="
                                                                document.formdata.submit();">
                                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                                <c:forEach var="oneStudy" items="${studyGradeTypeSubjectForm.allStudies}">
                                                                    <c:choose>
                                                                        <c:when test="${(status.value == oneStudy.id)}">
                                                                            <option value="${oneStudy.id}" selected="selected">${oneStudy.studyDescription}</option>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <option value="${oneStudy.id}">${oneStudy.studyDescription}</option>
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
                                            </c:when>
                                        </c:choose>
 
                                        <!--  SUBJECT ID -->
                                        <tr>
                                            <td width="200" class="label"><fmt:message key="jsp.general.subject" /></td>
                                            <spring:bind path="studyGradeTypeSubjectForm.subjectStudyGradeType.subjectId">
                                            <td class="required">
                                                <select name="${status.expression}" id="${status.expression}">
                                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    <!-- loop through all subjects linked to the selected study -->
                                                    <c:forEach var="oneSubject" items="${studyGradeTypeSubjectForm.allSubjects}">
                                                        <c:set var="subjectText" value="${oneSubject.subjectCode}: ${oneSubject.subjectDescription}"/>
                                                        <c:choose>
                                                            <c:when test="${status.value == oneSubject.id}">
                                                                <option value="${oneSubject.id}" selected="selected">${subjectText}</option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${oneSubject.id}">${subjectText}</option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td>
                                                <c:if test="${ not empty studyGradeTypeSubjectForm.txtErr }">       
                                                    <p align="left" class="errorwide">
                                                        ${studyGradeTypeSubjectForm.txtErr}
                                                    </p>
                                                </c:if>
                                                <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                </c:forEach>
                                            </td>
                                            </spring:bind> 
                                         </tr>
                                         
                                         <!--  CARDINAL TIME UNIT NUMBER -->
                                         <tr>
                                            <td class="label"><fmt:message key="jsp.general.cardinaltimeunit.number" /></td>
                                            <spring:bind path="studyGradeTypeSubjectForm.subjectStudyGradeType.cardinalTimeUnitNumber">
                                            <td>
                                            <select name="${status.expression}" id="${status.expression}">
                                                <option value="0"><fmt:message key="jsp.general.any" /></option>
                                                <c:forEach begin="1" end="${studyGradeTypeSubjectForm.maxNumberOfCardinalTimeUnits}" var="current">
                                                    <c:choose>
                                                        <c:when test="${status.value == current}">
                                                           <option value="${current}" selected="selected">${current}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${current}">${current}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                            </td> 
                                            <td> <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                 </c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>

                                        <!-- RIGIDITYTYPE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.subject.rigiditytype" /></td>
                                            <spring:bind path="studyGradeTypeSubjectForm.subjectStudyGradeType.rigidityTypeCode">
                                            <td class="required">
                                                <c:choose>
                                                    <c:when test="${opusUserRole.role != 'student' && opusUserRole.role != 'guest'}">
                                                        <select name="${status.expression}" id="${status.expression}">
                                                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    </c:when>
                                                </c:choose>
                                                    <c:forEach var="rigidityType" items="${studyGradeTypeSubjectForm.allRigidityTypes}">
                                                        <c:choose>
                                                            <c:when test="${opusUserRole.role != 'student' && opusUserRole.role != 'guest'}">
                                                                <c:choose>
                                                                    <c:when test="${rigidityType.code == status.value}">
                                                                        <option value="${rigidityType.code}" selected="selected">${rigidityType.description}</option>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <option value="${rigidityType.code}">${rigidityType.description}</option>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:choose>
                                                                    <c:when test="${rigidityType.code == status.value}">
                                                                        ${rigidityType.description}
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
                                        
                                        <!-- IMPORTANCETYPE -->
                                        <c:if test="${initParam.iMajorMinor == 'Y'}">
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.importancetype" /></td>
                                            <spring:bind path="studyGradeTypeSubjectForm.subjectStudyGradeType.importanceTypeCode">
                                            <td class="required">
                                                <c:choose>
                                                    <c:when test="${opusUserRole.role != 'student' && opusUserRole.role != 'guest'}">
                                                        <select name="${status.expression}" id="${status.expression}">
                                                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    </c:when>
                                                </c:choose>
                                                    <c:forEach var="importanceType" items="${studyGradeTypeSubjectForm.allImportanceTypes}">
                                                        <c:choose>
                                                            <c:when test="${opusUserRole.role != 'student' && opusUserRole.role != 'guest'}">
                                                                <c:choose>
                                                                    <c:when test="${importanceType.code == status.value}">
                                                                        <option value="${importanceType.code}" selected="selected">${importanceType.description}</option>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <option value="${importanceType.code}">${importanceType.description}</option>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:choose>
                                                                    <c:when test="${importanceType.code == status.value}">
                                                                        ${importanceType.description}
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
                                        </c:if>
                                        
                                        <!-- ACTIVE -->
                                        <tr>
                                            <td width="200" class="label"><fmt:message key="jsp.general.active" /></td>
                                            <spring:bind path="studyGradeTypeSubjectForm.subjectStudyGradeType.active">
                                            <td>
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
                                            </td>
                                            <td>
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">
                                                ${error}</span></c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>
                                     
                                    <tr>
                                        <td class="label">&nbsp;</td>
                                        <td><input type="submit" name="submitformdata" value="<fmt:message key="jsp.button.submit" />" onclick="document.getElementById('submitFormObject').value='true';document.formdata.submit();" /></td>
                                    </tr>

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
        tp1.showPanel(<%=request.getParameter("tab")%>);
    </script>
</div>

<%@ include file="../../footer.jsp"%>

