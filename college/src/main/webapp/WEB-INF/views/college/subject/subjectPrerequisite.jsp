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
    <spring:bind path="subjectPrerequisiteForm.organization">
        <c:set var="organization" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectPrerequisiteForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectPrerequisiteForm.subjectPrerequisite">
        <c:set var="subjectPrerequisite" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectPrerequisiteForm.subject">
        <c:set var="mainSubject" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectPrerequisiteForm.studyGradeType">
        <c:set var="studyGradeType" value="${status.value}" scope="page" />
    </spring:bind>
    
    <%-- authorizations --%>
    <c:set var="authorizedToEdit" value="${false}"/>
    <sec:authorize access="hasRole('UPDATE_SUBJECTS')">
        <c:set var="authorizedToEdit" value="${true}"/>
    </sec:authorize>
        

<div id="tabcontent">

<form>
    <fieldset><legend> 
        <!--  back to overview -->
        <a href="<c:url value='/college/subjects.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;&nbsp;
        <!--back to subject -->
        <a href="<c:url value='/college/subject.view?newForm=true&amp;tab=4&amp;panel=0&amp;subjectId=${mainSubject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
            <c:choose>
            <c:when test="${mainSubject.subjectDescription != null && mainSubject.subjectDescription != ''}">
                <c:out value="${fn:substring(mainSubject.subjectDescription,0,initParam.iTitleLength)}"/>
            </c:when>
            <c:otherwise>
                <fmt:message key="jsp.href.new" />
            </c:otherwise>
        </c:choose>
        </a>
        &nbsp;&gt;&nbsp;
        <!-- back to studyGradeType -->
        <a href="<c:url value='/college/subjectstudygradetype.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}
                                                                    &amp;subjectStudyGradeTypeId=${subjectPrerequisite.subjectStudyGradeTypeId}
                                                                    &amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
            <c:choose>
                <c:when test="${studyGradeType.studyDescription != null && studyGradeType.studyDescription != ''}">
                    <c:out value="${fn:substring(studyGradeType.studyDescription,0,initParam.iTitleLength)}"/>
                </c:when>
            </c:choose> 
            <c:choose>
                <c:when test="${studyGradeType.gradeTypeDescription != null && studyGradeType.gradeTypeDescription != ''}">
                   / <c:out value="${fn:substring(studyGradeType.gradeTypeDescription,0,initParam.iTitleLength)}"/>
                </c:when>
            </c:choose>        
        </a>
        &nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.subjectprerequisite" /> 
    </legend></fieldset>
</form>

<div id="tp1" class="TabbedPanel">
    <ul class="TabbedPanelsTabGroup">
        <li class="TabbedPanelsTab"><fmt:message key="jsp.general.edit" /></li>
    </ul>
    <div class="TabbedPanelsContentGroup">
        <div class="TabbedPanelsContent">
            <div class="Accordion" id="Accordion1" tabindex="0">
                <div class="AccordionPanel">
                    <div class="AccordionPanelTab"><fmt:message key="jsp.general.subjectprerequisite" /></div>
                        <div class="AccordionPanelContent">
                        
                           <form name="formdata" method="post">
                            <input type="hidden" name="submitFormObject" id="submitFormObject" value="" />
                           
                           <table>
                            <tr>
                                <td colspan="3">
                                    <%@ include file="../../includes/organizationAndNavigationDetail.jsp"%>
                                </td>
                            </tr> 

                            <!--  STUDY ID -->
                            <c:choose>
                            <c:when test="${authorizedToEdit}">

                                <spring:bind path="subjectPrerequisiteForm.study.id">  
                                    <tr>
                                        <td width="200" class="label"><fmt:message key="jsp.general.study" /></td>
                                       
                                        <td>
                                            <select id="${status.expression}" name="${status.expression}" onchange="document.getElementById('subjectPrerequisite.requiredSubjectCode').value='';
                                                                                                    document.formdata.submit();
                                                                                                    ">
                                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                            <c:forEach var="oneStudy" items="${subjectPrerequisiteForm.allStudies}">
                                                <c:choose>
                                                    <c:when test="${(status.value == oneStudy.id)}">
                                                        <option value="${oneStudy.id}" selected="selected"><c:out value="${oneStudy.studyDescription}"/></option>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <option value="${oneStudy.id}"><c:out value="${oneStudy.studyDescription}"/></option>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </select></td>
                                        
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                    </tr>
                                </spring:bind>
                            </c:when>
                            </c:choose>
                            
                            <!--  SUBJECT -->
                            <spring:bind path="subjectPrerequisiteForm.subjectPrerequisite.requiredSubjectCode">  
                            <tr>
                                <td width="200" class="label"><fmt:message key="jsp.general.subject" /></td>
                                <td class="required">
                                <select id="${status.expression}" name="${status.expression}">
                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                    <!-- loop through all subjects linked to the selected study -->
                                    <c:forEach var="oneSubject" items="${subjectPrerequisiteForm.allSubjectsForStudy}">
                                        <c:set var="disabled" value="" scope="page" />
                                        <c:choose>
                                            <c:when test="${status.value == oneSubject.subjectCode}">
                                                <option value='<c:out value="${oneSubject.subjectCode}"/>' selected="selected"><c:out value="${oneSubject.subjectDescription}"/></option>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- if subject is already a prerequisite to the subjectStudyGradeType: don't show the subject -->
                                                <c:forEach var="prerequisite" items="${subjectPrerequisiteForm.allPrerequisiteSubjects}">
                                                    <c:choose>
                                                        <c:when test="${prerequisite.requiredSubjectCode == oneSubject.subjectCode}">
                                                            <c:set var="disabled" value="disabled" scope="page" />
                                                        </c:when>
                                                    </c:choose>
                                                </c:forEach>
                                                <!-- don't show subject of subjectStudyGradeType: a subject can not be a prerequisite for itself -->
                                                <c:choose>
                                                    <c:when test="${oneSubject.subjectCode == mainSubject.subjectCode }">
                                                        <c:set var="disabled" value="disabled" scope="page" />
                                                    </c:when>
                                                </c:choose>
                                                <c:choose>
                                                    <c:when test="${disabled == ''}">
                                                        <option value='<c:out value="${oneSubject.subjectCode}"/>'><c:out value="${oneSubject.subjectDescription}"/></option>
                                                    </c:when>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </select>
                                </td>
                                <td width="35%">
                                    <c:forEach var="error" items="${status.errorMessages}">
                                        <span class="error"> ${error}</span>
                                    </c:forEach>
                                </td>
                            </tr>
                            </spring:bind>
                                
                            <!--  ACTIVE -->
                            <tr>
                                <td class="label"><fmt:message key="jsp.general.active" /></td>
                                <td>
                                    <select name="subjectPrerequisite.active">
                                        <c:choose>
                                            <c:when test="${'Y' == subjectPrerequisite.active}">
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