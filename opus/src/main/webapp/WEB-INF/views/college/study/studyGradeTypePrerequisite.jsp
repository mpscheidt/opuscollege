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
    <spring:bind path="studyGradeTypePrerequisiteForm.organization">
        <c:set var="organization" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="studyGradeTypePrerequisiteForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="studyGradeTypePrerequisiteForm.studyGradeTypePrerequisite">
        <c:set var="studyGradeTypePrerequisite" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="studyGradeTypePrerequisiteForm.mainStudyGradeType">
        <c:set var="mainStudyGradeType" value="${status.value}" scope="page" />
    </spring:bind>

    <%-- authorizations --%>
    <sec:authorize access="hasAnyRole('CREATE_STUDYGRADETYPES','UPDATE_STUDYGRADETYPES')">
        <c:set var="editStudyGradeTypes" value="${true}"/>
    </sec:authorize>
    <c:if test="${not editStudyGradeTypes}">
        <sec:authorize access="hasRole('READ_STUDYGRADETYPES')">
            <c:set var="showStudyGradeTypes" value="${true}"/>
        </sec:authorize>
    </c:if>
    
    
<div id="tabcontent">

<!-- bread crumbs path -->
<form>
    <fieldset>
        <legend> 
            <a href="<c:url value='/college/studies.view?newForm=true&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;&nbsp;
            <a href="<c:url value='/college/study.view?newForm=true&amp;tab=0&amp;panel=0&amp;studyId=${mainStudyGradeType.studyId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                <c:choose>
                    <c:when test="${mainStudyGradeType.studyDescription != null && mainStudyGradeType.studyDescription != ''}" >
                        <c:out value="${fn:substring(mainStudyGradeType.studyDescription,0,initParam.iTitleLength)}"/>
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="jsp.href.new" />
                    </c:otherwise>
                </c:choose>
            </a>
            &nbsp;&gt;&nbsp;
            <a href="<c:url value='/college/studygradetype.view?newForm=true&amp;tab=0&amp;panel=0&amp;studyId=${mainStudyGradeType.studyId}&amp;studyGradeTypeId=${mainStudyGradeType.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
            <c:choose>
                <c:when test="${mainStudyGradeType.gradeTypeDescription != null && mainStudyGradeType.gradeTypeDescription != ''}" >
                    <c:out value="${fn:substring(mainStudyGradeType.gradeTypeDescription,0,initParam.iTitleLength)}"/> (<c:out value="${studyGradeTypePrerequisiteForm.academicYear.description}"/>)
                </c:when>
                <c:otherwise>
                    <fmt:message key="jsp.href.new" />
                </c:otherwise>
            </c:choose>
            </a>
            &nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.studygradetypeprerequisite" /> 
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
                    <div class="AccordionPanelTab"><fmt:message key="jsp.general.studygradetype" /></div>
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
                            <c:when test="${editStudyGradeTypes}">
                          
                               <spring:bind path="studyGradeTypePrerequisiteForm.studyGradeTypePrerequisite.requiredStudyId">  
                                    <tr>
                                        <td width="200" class="label"><fmt:message key="jsp.general.study" /></td>
                                       
                                        <td>
                                            <select id="${status.expression}" name="${status.expression}" onchange="
                                                                                                    document.getElementById('studyGradeTypePrerequisite.requiredGradeTypeCode').value='';
                                                                                                    document.formdata.submit();
                                                                                                    ">
                                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                            <c:forEach var="oneStudy" items="${studyGradeTypePrerequisiteForm.allStudies}">
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
                                   
                            <!--  GRADE TYPE CODE -->
                            <spring:bind path="studyGradeTypePrerequisiteForm.studyGradeTypePrerequisite.requiredGradeTypeCode">
                                <tr>
                                    <td class="label"><fmt:message key="jsp.general.gradetypecode" /></td>
                                    <td class="required">
                                        <select id="${status.expression}" name="${status.expression}" onchange="document.formdata.submit();">
                                            <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                            <!-- loop through all gradeTypes linked to the selected study -->
                                            <c:forEach var="oneStudyGradeType" items="${studyGradeTypePrerequisiteForm.distinctStudyGradeTypesForStudy}">
                                                <c:set var="disabled" value="" scope="page" /> 
                                                <c:choose>
                                                    <c:when test="${status.value == oneStudyGradeType.gradeTypeCode}">
                                                        <option value="${oneStudyGradeType.gradeTypeCode}" selected="selected"><c:out value="${oneStudyGradeType.gradeTypeDescription}"/></option>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <!-- if study/gradetype is already a prerequisite: don't show it-->
                                                        <c:forEach var="prerequisite" items="${studyGradeTypePrerequisiteForm.allStudyGradeTypePrerequisites}">
                                                            <c:choose>
                                                                <c:when test="${prerequisite.requiredStudyId == studyGradeTypePrerequisite.requiredStudyId
                                                                && prerequisite.requiredGradeTypeCode == oneStudyGradeType.gradeTypeCode}">
                                                                    <c:set var="disabled" value="disabled" scope="page" />
                                                                </c:when>
                                                            </c:choose>
                                                        </c:forEach>
                                                        <!-- don't show study/gradetype of mainStudyGradeType: a studyGradeType can not be a prerequisite for itself -->
                                                        <c:choose>
                                                            <c:when test="${ mainStudyGradeType.studyId == studyGradeTypePrerequisite.requiredStudyId
                                                                        && oneStudyGradeType.gradeTypeCode == mainStudyGradeType.gradeTypeCode}">
                                                                <c:set var="disabled" value="disabled" scope="page" />
                                                            </c:when>
                                                        </c:choose>
                                                        <c:choose>
                                                            <c:when test="${disabled == ''}">
                                                                <option value="${oneStudyGradeType.gradeTypeCode}"><c:out value="${oneStudyGradeType.gradeTypeDescription}"/></option>
                                                            </c:when>
                                                        </c:choose>
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
                            <!--  ACTIVE -->
                            <tr>
                                <td width="200" class="label"><fmt:message key="jsp.general.active" /></td>
                                <td>
                                    <select name="studyGradeTypePrerequisite.active">
                                        <c:choose>
                                            <c:when test="${'Y' == studyGradeTypePrerequisite.active}">
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
                                <td>&nbsp;</td>
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

