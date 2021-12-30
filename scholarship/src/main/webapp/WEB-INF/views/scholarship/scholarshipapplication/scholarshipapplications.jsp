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

The Original Code is Opus-College scholarship module code.

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

<%@ include file="../../header.jsp" %>

<%@ include file="../../includes/javascriptfunctions.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp" %>

    <div id="tabcontent">
        <fieldset>
        <legend>
            <fmt:message key="jsp.general.scholarshipapplications" />
        </legend>
        
        <p align="left">
            <table>
            <tr>
            <td>
            <%@ include file="../../includes/institutionBranchOrganizationalUnitSelect.jsp"%>

            <form name="processStatusForm" method="POST" action="<c:url value='${action}'/>"> 
                <input type="hidden" name="institutionId" value="${institutionId}" />
                <input type="hidden" name="branchId" value="${branchId}" />
                <input type="hidden" id="organizationalUnitId" name="organizationalUnitId" value="${organizationalUnitId }" />
                <input type="hidden" name="academicYearId" value="${academicYearId}" />       
                <input type="hidden" name="sponsorId" value="${sponsorId}" />
                <input type="hidden" name="scholarshipId" value="${scholarshipId}" />
                <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />

                <td width="100">
                    <fmt:message key="jsp.general.scholarship.status" />
                </td>
                <td>
                    <select id="processStatusCode" name="processStatusCode" onchange="document.processStatusForm.submit()">
                        <option value="0"><fmt:message key="scholarship.applied" /></option>
                            <c:choose>
                                <c:when test="${ processStatusCode == 'G' }"> 
                                    <option value="${processStatusCode}" selected="selected"><fmt:message key="scholarship.granted" /></option>
                                </c:when>
                                <c:otherwise>
                                    <option value="G"><fmt:message key="scholarship.granted" /></option>
                                </c:otherwise>
                            </c:choose>
                    </select>
                </td>
             </form>
             </tr>
             </table>
        </p>
        </fieldset>
        
        <c:set var="allEntities" value="${allScholarshipApplications}" scope="page" />
        <c:set var="redirView" value="scholarshipapplications" scope="page" />
        <c:set var="entityNumber" value="0" scope="page" />

        <%@ include file="../../includes/pagingHeader.jsp" %>

        <table class="tabledata" id="TblData">
            <th><fmt:message key="jsp.general.civiltitle" /></th>
            <th><fmt:message key="jsp.general.firstnames" /></th>
            <th><fmt:message key="jsp.general.surname" /></th>
            <th><fmt:message key="jsp.general.birthdate" /></th>
            <th><fmt:message key="jsp.general.primarystudy" /></th>
            <th><fmt:message key="jsp.general.studyplan" /> - <fmt:message key="jsp.general.timeunit" /></th>
            <c:choose>
            	<c:when test="${ processStatusCode == 'G' }">
            	<th><fmt:message key="scholarship.sponsor.granted" /> </th>
            	</c:when>
            	<c:otherwise>
            	<th><fmt:message key="scholarship.sponsor.applied" /> </th>
            	</c:otherwise>
            </c:choose>
            <th><fmt:message key="jsp.general.academicyear" /></th>
            <th></th>

            <c:forEach var="scholarshipApplication" items="${allScholarshipApplications}">
                <c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
                <c:choose>
                    <c:when test="${(entityNumber < (currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
                    <tr>
                        <%-- td>${scholarshipApplication.civilTitleCode }</td --%>
                        <td>
                        <c:forEach var="civilTitle" items="${allCivilTitles}">
                           <c:choose>
                                <c:when test="${civilTitle.code == scholarshipApplication.civilTitleCode }">
                                    ${civilTitle.description}
                                </c:when>
                           </c:choose>
                        </c:forEach>
                        </td>
                        <td>${scholarshipApplication.firstNamesFull }</td>
                        <td>${scholarshipApplication.surnameFull }</td>
                        <td><fmt:formatDate pattern="dd/MM/yyyy" value="${scholarshipApplication.birthdate}" /></td>
                        <td>${scholarshipApplication.studyDescription }</td>
                        <td>${scholarshipApplication.studyPlanDescription } - ${scholarshipApplication.cardinalTimeUnitDescription} ${scholarshipApplication.cardinalTimeUnitNumber}</td>
                        <td>${scholarshipApplication.sponsorName }</td>
                        <td>
                              <c:forEach var="academicYear" items="${allAcademicYears}">
                                    <c:choose>
                                        <c:when test="${academicYear.id != 0
                                                     && academicYear.id == scholarshipApplication.academicYearId}">
                                           ${academicYear.description}
                                        </c:when>
                                    </c:choose>
                               </c:forEach>                        
                        </td>
                        <td class="buttonsCell">
                        <c:choose>
                            <c:when test="${
                                opusUserRole.role != 'student' 
                                && opusUserRole.role != 'guest'
                                }">
                                
                            <a href="<c:url value='/scholarship/scholarshipstudent.view?tab=1&panel=0&studentId=${scholarshipApplication.studentId}&scholarshipApplicationId=${scholarshipApplication.scholarshipApplicationId}&currentPageNumber=${currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>

                            &nbsp;&nbsp;<a href="<c:url value='/scholarship/scholarshipapplication_delete.view?scholarshipApplicationId=${scholarshipApplication.scholarshipApplicationId}&currentPageNumber=${currentPageNumber}'/>"
                            onclick="return confirm('<fmt:message key="jsp.scholarshipapplication.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${opusUser.personId == student.personId}">
                                        <a href="<c:url value='/scholarship/scholarshipstudent.view?newForm=true&tab=1&panel=0&studentId=${scholarshipApplication.studentId}&scholarshipApplicationId=${scholarshipApplication.scholarshipApplicationId}&currentPageNumber=${currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                   </c:when>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                        </td>
                    </tr>
                    </c:when>
                </c:choose>
            </c:forEach>
        </table>
        <script type="text/javascript">alternate('TblData',true)</script>

        <%@ include file="../../includes/pagingFooter.jsp"%>
    
        <br /><br />
    </div>

</div>

<%@ include file="../../footer.jsp"%>
