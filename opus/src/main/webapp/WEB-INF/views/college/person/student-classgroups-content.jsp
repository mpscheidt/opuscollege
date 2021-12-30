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

<div class="AccordionPanel">
  <div class="AccordionPanelTab"><fmt:message key="general.classgroups" /></div>
    <div class="AccordionPanelContent">

        <c:if test="${! empty param['showError']}">
            <p align="left" class="error">${param['showError']}</p>
        </c:if> &nbsp;
        
        <table>
            <!-- CLASSGROUPS -->
                <tr>
                    <td class="header" colspan="2">
                        <fmt:message key="general.classgroups" />
                    </td>
                    <td align="right">
                        <sec:authorize access="hasRole('CREATE_STUDENT_CLASSGROUPS')">
                            <a class="button" href="<c:url value='/college/person/studentclassgroup.view'/>?<c:out value='newForm=true&tab=5&panel=0&studentId=${studentId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                <fmt:message key="jsp.href.add" />
                            </a>
                        </sec:authorize>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <table class="tabledata2" id="TblData2_classgroups">
                            <tr>
                                <th><fmt:message key="jsp.general.name" /></th>
                                <th><fmt:message key="jsp.general.academicyear" /></th>
                                <th><fmt:message key="jsp.general.study" /></th>
                                <th><fmt:message key="jsp.general.studygradetype" /></th>
                                <th>&nbsp;</th>
                            </tr>

                            <c:forEach var="oneClassgroup" items="${student.classgroups}">
                                <c:forEach var="studygradytype" items="${studentClassgroupsForm.studyGradeTypes}">
                                    <c:choose>
                                        <c:when test="${studygradytype.id == oneClassgroup.studyGradeTypeId}">
                                            <c:set var="oneStudyGradeType" value="${studygradytype}"/>
                                        </c:when>
                                    </c:choose>
                                </c:forEach>

                                <tr>
                                   <td>
                                        <c:out value="${oneClassgroup.description}"/>
                                    </td>
                                    <td>
                                        <c:out value="${studentClassgroupsForm.idToAcademicYearMap[oneStudyGradeType.currentAcademicYearId].description}"/>
                                    </td>
                                    <td>
                                        <c:if test="${!empty oneStudyGradeType}">
                                            <c:out value="${oneStudyGradeType.studyDescription}"></c:out>
<%--                                             <c:forEach var="study" items="${studentForm.allStudies}"> --%>
<%--                                                 <c:choose> --%>
<%--                                                     <c:when test="${study.id == oneStudyGradeType.studyId}"> --%>
<%--                                                         <c:out value="${study.studyDescription}"/> --%>
<%--                                                     </c:when> --%>
<%--                                                 </c:choose> --%>
<%--                                             </c:forEach> --%>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:forEach var="oneGradeType" items="${studentClassgroupsForm.allGradeTypes}">
                                            <c:choose>
                                                <c:when test="${oneStudyGradeType.gradeTypeCode == oneGradeType.code}">
                                                    <c:out value="${oneGradeType.description}"/>
                                                </c:when>
                                            </c:choose>
                                        </c:forEach>
                                    </td>
                                    <td class="buttonsCell">
                                        <sec:authorize access="hasRole('DELETE_STUDENT_CLASSGROUPS')">
                                            <a href="<c:url value='/college/person/studentclassgroup_delete.view'/>?<c:out value='tab=5&panel=0&studentId=${studentId}&classgroupId=${oneClassgroup.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>" onclick="return confirm('<fmt:message key="jsp.studentclassgroup.delete.confirm" />')">
                                                <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                            </a>
                                        </sec:authorize>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                        <script type="text/javascript">alternate('TblData2_classgroups',true)</script>
                    </td>
                </tr>
        </table>

    </div> 
</div>