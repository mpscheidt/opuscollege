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

<c:set var="screentitlekey">jsp.subjectblocks.header</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>
    
    <!-- necessary spring binds for organization and navigationSettings
         regarding form handling through includes -->
    <spring:bind path="subjectBlocksForm.organization">
        <c:set var="organization" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectBlocksForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>
        
    <div id="tabcontent">
    
        <fieldset>
            <legend><fmt:message key="jsp.subjectblocks.header" /></legend>
        
            <p align="left">
                
                <sec:authorize access="hasRole('READ_STUDIES')">
                <form name="organizationandnavigation" method="post">
                    <%@ include file="../../includes/organizationAndNavigation.jsp"%>
                   
                    <table>
                        <tr>
                            <td class="label" width="200"><fmt:message key="jsp.general.study" /></td>
                            <td>
                            <select id="studyId" name="studyId" onchange="document.organizationandnavigation.submit();">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <c:forEach var="oneStudy" items="${subjectBlocksForm.dropDownListStudies}">
                                    <c:choose>
                                        <c:when test="${(subjectBlocksForm.studyId == oneStudy.id)  }"> 
                                            <option value="${oneStudy.id}" selected="selected">${oneStudy.studyDescription}</option>
                                        </c:when>
                                        <c:otherwise>
                                           <option value="${oneStudy.id}">${oneStudy.studyDescription}</option>
                                        </c:otherwise>
                                    </c:choose>        
                                </c:forEach>
                            </select>
                            </td>
                        </tr>
                        <!-- start of academic year -->
                        <tr>
                            <td class="label" width="200"><fmt:message key="jsp.general.academicyear" /></td>
                            <td>
                            <select id="academicYearId" name="academicYearId" onchange="document.organizationandnavigation.submit();">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <c:forEach var="year" items="${subjectBlocksForm.allAcademicYears}">                          
                                    <c:choose>
                                        <c:when test="${year.id == subjectBlocksForm.academicYearId}">
                                            <option value="${year.id}" selected="selected">${year.description}</option>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="${year.id}">${year.description}</option>                            
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </select>
                            </td>
                        </tr>
                        <!-- end of academic year -->
                    </table>
                    <%@ include file="../../includes/searchValue.jsp"%>
                </form>
                </sec:authorize>
            </p>
            
            <!-- delete error -->
            <c:choose>        
                <c:when test="${ not empty subjectBlocksForm.subjectBlockError }">       
                    <p align="left" class="error">
                        ${subjectBlocksForm.subjectBlockError}
                    </p>
                </c:when>
            </c:choose>
        </fieldset>
        
        <c:set var="allEntities" value="${subjectBlocksForm.allSubjectBlocks}" scope="page" />
        <c:set var="redirView" value="subjectblocks" scope="page" />
        <c:set var="entityNumber" value="0" scope="page" />

        <%@ include file="../../includes/pagingHeaderNew.jsp"%>
       
        <table class="tabledata" id="TblData">
            <tr>
               <!--  <th><fmt:message key="jsp.general.id" /></th> -->
                <th><fmt:message key="jsp.general.code" /></th>
                <th><fmt:message key="jsp.general.name" /></th>
                <th><fmt:message key="jsp.general.primarystudy" /></th>
                <th><fmt:message key="jsp.general.academicyear" /></th>
                <th><fmt:message key="jsp.general.studytime" /></th>
                <th><fmt:message key="jsp.subject.assigned" /></th>
                <th><fmt:message key="jsp.general.active" /></th>
                <th></th>
            </tr>
            
            <c:forEach var="oneSubjectBlock" items="${subjectBlocksForm.allSubjectBlocks}">
                <c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
                <c:choose>
                    <c:when test="${(entityNumber < (navigationSettings.currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((navigationSettings.currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
                        <tr>
                         <!-- <td>${oneSubjectBlock.id}</td> -->
                           <td>${oneSubjectBlock.subjectBlockCode}</td>
                           <td>
<%--                                 <c:choose> --%>
<%--                                     <c:when test="${ --%>
<%--                                         opusUser.personId == student.personId --%>
<%--                                         || ( --%>
<%--                                             opusUserRole.role != 'student'  --%>
<%--                                             && opusUserRole.role != 'guest' --%>
<%--                                             && opusUserRole.role != 'staff') --%>
<%--                                             }"> --%>
                                        <a href="<c:url value='/college/subjectblock.view?newForm=true&tab=0&panel=0&subjectBlockId=${oneSubjectBlock.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                            ${oneSubjectBlock.subjectBlockDescription}
                                        </a>
<%--                                     </c:when> --%>
<%--                                     <c:otherwise> --%>
<%--                                         ${oneSubjectBlock.subjectBlockDescription} --%>
<%--                                     </c:otherwise> --%>
<%--                                 </c:choose> --%>
                            </td>
                            <td>
                                <c:forEach var="study" items="${subjectBlocksForm.allStudies}">
                                    <c:choose>
                                        <c:when test="${study.id == oneSubjectBlock.primaryStudyId}">
                                            ${study.studyDescription}
                                        </c:when>
                                    </c:choose>
                                 </c:forEach>
                            </td>
                            <td>
                                ${subjectBlocksForm.idToAcademicYearMap[oneSubjectBlock.currentAcademicYearId].description}
                            </td>
                            <td>
                                <c:forEach var="studyTime" items="${allStudyTimes}">
                                   <c:choose>
                                   <c:when test="${studyTime.code == oneSubjectBlock.studyTimeCode}">
                                        ${studyTime.description}
                                    </c:when>
                                   </c:choose>
                                </c:forEach>          
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${(not empty oneSubjectBlock.subjectBlockStudyGradeTypes) || (not empty oneSubjectBlock.subjectSubjectBlocks)}">
                                        <fmt:message key="jsp.general.yes" />
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:message key="jsp.general.no" />
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${oneSubjectBlock.active}</td>
                            <td class="buttonsCell">
<%--                                 <c:choose> --%>
<%--                                     <c:when test="${( --%>
<%--                                         opusUserRole.role != 'student'  --%>
<%--                                         && opusUserRole.role != 'guest' --%>
<%--                                         && opusUserRole.role != 'staff' --%>
<%--                                         )}"> --%>
                                    <sec:authorize access="hasRole('UPDATE_SUBJECTBLOCKS')">
                                        <a href="<c:url value='/college/subjectblock.view?newForm=true&tab=0&panel=0&subjectBlockId=${oneSubjectBlock.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                    </sec:authorize>
                                    <sec:authorize access="hasRole('DELETE_SUBJECTBLOCKS')">
                                        &nbsp;&nbsp;<a href="<c:url value='/college/subjectblocks/delete/${oneSubjectBlock.id}'/>"
                                        onclick="return confirm('<fmt:message key="jsp.subjects.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                    </sec:authorize>
<%--                                     </c:when> --%>
<%--                                 </c:choose>        --%>
                            </td>
                        </tr>
                    </c:when>
                </c:choose>
            </c:forEach>
        </table>
        <script type="text/javascript">alternate('TblData',true)</script>
        
        <%@ include file="../../includes/pagingFooterNew.jsp"%>
        <br /><br />
    </div>  
</div>

<%@ include file="../../footer.jsp"%>
