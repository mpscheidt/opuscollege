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

<div id="wrapper">

    <%@ include file="../../menu.jsp"%>
    
    <!-- necessary spring binds for organization and navigationSettings
         regarding form handling through includes -->
    <spring:bind path="subjectBlockPrerequisiteForm.organization">
        <c:set var="organization" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectBlockPrerequisiteForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectBlockPrerequisiteForm.subjectBlockPrerequisite">
        <c:set var="subjectBlockPrerequisite" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectBlockPrerequisiteForm.subjectBlock">
        <c:set var="mainSubjectBlock" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectBlockPrerequisiteForm.studyGradeType">
        <c:set var="studyGradeType" value="${status.value}" scope="page" />
    </spring:bind>

     <%-- decide whether to display read-only or allow to edit --%>
    <c:set var="authorizedToEdit" value="${false}"/>
    <sec:authorize access="hasAnyRole('CREATE_SUBJECTBLOCK_PREREQUISITES','UPDATE_SUBJECTBLOCK_PREREQUISITES')">
        <c:set var="authorizedToEdit" value="${true}"/>
    </sec:authorize>
        

<div id="tabcontent">

<form>
    <fieldset><legend> 
        <!--  back to overview -->
        <a href="<c:url value='/college/subjectblocks.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
        <!--back to subjectBlock --> <!-- &subjectBlockStudyGradeTypeId=${subjectBlockStudyGradeTypeId } -->
        <a href="<c:url value='/college/subjectblock.view?newForm=true&tab=${navigationSettings.tab}&panel=${navigationSettings.panel}&subjectBlockId=${mainSubjectBlock.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
            <c:choose>
            <c:when test="${mainSubjectBlock.subjectBlockDescription != null && mainSubjectBlock.subjectBlockDescription != ''}">
                ${fn:substring(mainSubjectBlock.subjectBlockDescription,0,initParam.iTitleLength)} (${academicYear.description})
            </c:when>
            <c:otherwise>
                <fmt:message key="jsp.href.new" />
            </c:otherwise>
        </c:choose>
        </a>
        &nbsp;&gt;&nbsp;
        <!-- back to studyGradeType 
        <a href="<c:url value='/college/subjectblockstudygradetype.view?tab=${tab}&panel=${panel}&from=subjectblockstudygradetype
                                                                    &subjectBlockStudyGradeTypeId=${subjectBlockStudyGradeTypeId}
                                                                    &studyGradeTypeId=${studyGradeType.id}
                                                                    &studyId=${studyGradeType.studyId}
                                                                    &gradeTypeCode=${studyGradeType.gradeTypeCode}
                                                                    &mainsubjectBlockId=${mainsubjectBlock.id}&currentPageNumber=${currentPageNumber}'/>">
                                                                    -->
                                                                    
         <a href="<c:url value='/college/subjectblockstudygradetype.view?newForm=true&tab=${navigationSettings.tab}&panel=${navigationSettings.panel}
                                                                    &subjectBlockStudyGradeTypeId=${subjectBlockPrerequisite.subjectBlockStudyGradeTypeId}
                                                                    &currentPageNumber=${navigationSettings.currentPageNumber}'/>">
            <c:choose>
                <c:when test="${studyGradeType.studyDescription != null && studyGradeType.studyDescription != ''}">
                    ${fn:substring(studyGradeType.studyDescription,0,initParam.iTitleLength)}
                </c:when>
            </c:choose> 
            <c:choose>
                <c:when test="${studyGradeType.gradeTypeDescription != null && studyGradeType.gradeTypeDescription != ''}">
                   / ${fn:substring(studyGradeType.gradeTypeDescription,0,initParam.iTitleLength)}
                </c:when>
            </c:choose>        
        </a>
        
        &nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.subjectblockprerequisite" /> 
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
                    <div class="AccordionPanelTab"><fmt:message key="jsp.general.subjectblockprerequisite" /></div>
                        <div class="AccordionPanelContent">
                        
                           <form name="formdata" method="post">
                           
                           <input type="hidden" name="submitFormObject" id="submitFormObject" value="" />
                           
                           <table>
                           
                           <c:choose>        
                                <c:when test="${ not empty subjectBlockStudyGradeTypeForm.showSubjectBlockPrerequisiteError }">       
                                    <tr>
                                        <td align="left" colspan="3">
                                            <p class="error">
                                                <fmt:message key="jsp.error.subjectblockprerequisite.delete" />
                                                ${subjectBlockStudyGradeTypeForm.showSubjectBlockPrerequisiteError}
                                            </p>
                                        </td>
                                    </tr>
                                </c:when>
                            </c:choose>
                            
                            <tr>
                                <td colspan="3">
                                    <%@ include file="../../includes/organizationAndNavigationDetail.jsp"%>
                                </td>
                            </tr> 
                            
                            <!--  STUDY ID -->
                            <c:choose>
                            <c:when test="${authorizedToEdit}">
                                <spring:bind path="subjectBlockPrerequisiteForm.study.id">  
                                    <tr>
                                        <td width="200" class="label"><fmt:message key="jsp.general.study" /></td>
                                       
                                        <td>
                                            <select id="${status.expression}" name="${status.expression}" onchange="document.getElementById('subjectBlockPrerequisite.requiredSubjectBlockCode').value='';
                                                                                                    document.formdata.submit();
                                                                                                    ">
                                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                            <c:forEach var="oneStudy" items="${subjectBlockPrerequisiteForm.allStudies}">
                                                <c:choose>
                                                    <c:when test="${(status.value == oneStudy.id)}">
                                                        <option value="${oneStudy.id}" selected="selected">${oneStudy.studyDescription}</option>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <option value="${oneStudy.id}">${oneStudy.studyDescription}</option>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </select></td>
                                        
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                    </tr>
                                </spring:bind>
                            </c:when>
                            </c:choose>

                            <!--  SUBJECTBLOCK -->
                            <spring:bind path="subjectBlockPrerequisiteForm.subjectBlockPrerequisite.requiredSubjectBlockCode">  
                            <tr>
                                <td width="200" class="label"><fmt:message key="jsp.general.subjectblock" /></td>
                                <td class="required">
                                <select id="${status.expression}" name="${status.expression}">
                                    <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                    <!-- loop through all subjectBlocks linked to the selected study -->
                                    <c:forEach var="oneSubjectBlock" items="${subjectBlockPrerequisiteForm.allSubjectBlocksForStudy}">
                                        <c:set var="disabled" value="" scope="page" />
                                        <c:choose>
                                            <c:when test="${status.value == oneSubjectBlock.subjectBlockCode}">
                                                <option value='<c:out value="${oneSubjectBlock.subjectBlockCode}"/>' selected="selected">${oneSubjectBlock.subjectBlockCode} ${oneSubjectBlock.subjectBlockDescription}</option>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- if subjectBlock is already a prerequisite to the subjectBlockStudyGradeType: don't show the subjectBlock -->
                                                <c:forEach var="prerequisite" items="${subjectBlockPrerequisiteForm.allPrerequisiteSubjectBlocks}">
                                                    <c:choose>
                                                        <c:when test="${prerequisite.requiredSubjectBlockCode == oneSubjectBlock.subjectBlockCode}">
                                                            <c:set var="disabled" value="disabled" scope="page" />
                                                        </c:when>
                                                    </c:choose>
                                                </c:forEach>
                                                <!-- don't show subjectBlock of subjectBlockStudyGradeType: a subjectBlock can not be a prerequisite for itself -->
                                                <c:choose>
                                                    <c:when test="${oneSubjectBlock.subjectBlockCode == mainSubjectBlock.subjectBlockCode }">
                                                        <c:set var="disabled" value="disabled" scope="page" />
                                                    </c:when>
                                                </c:choose>
                                                <c:choose>
                                                    <c:when test="${disabled == ''}">
                                                        <option value='<c:out value="${oneSubjectBlock.subjectBlockCode}"/>'>${oneSubjectBlock.subjectBlockCode} ${oneSubjectBlock.subjectBlockDescription}</option>
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
                                <td width="200" class="label"><fmt:message key="jsp.general.active" /></td>
                                <spring:bind path="subjectBlockPrerequisiteForm.subjectBlockPrerequisite.active">
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
                                <td><c:forEach var="error" items="${status.errorMessages}">
                                    <span class="error"> ${error}</span>
                                </c:forEach></td>
                            </spring:bind>
                            </tr>
                            <!-- SUBMIT BUTTON -->
                            <tr>
                                <td class="label">&nbsp;</td>
                                <td><input type="button" name="submitformdata"
                                    value="<fmt:message key="jsp.button.submit" />"
                                    onclick="document.getElementById('submitFormObject').value='true';document.formdata.submit();" /></td>
                                <td>&nbsp;</td>
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
    </script></div>

<%@ include file="../../footer.jsp"%>

 