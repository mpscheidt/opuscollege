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
 * Copyright (c) 2008 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
 @Description: This script is the content for the subsidies tab
 @Author Stelio Macumbe 13 of May 2008
--%>

<%@ include file="../../header.jsp"%>

<%@ include file="../../includes/javascriptfunctions.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <div id="tabcontent">
    
        <fieldset>
        <legend>
            <fmt:message key="jsp.subsidies.header" />
        </legend>
        <p align="left">
        <table>
        <tr>
        <td>
            <%@ include file="../../includes/institutionBranchOrganizationalUnitSelect.jsp"%>
        </td>
        <td>
        <table id="subsidyFilters">
            <form name="sponsors" method="POST" action="<c:url value='${action}'/>">    
                <input type="hidden" name="institutionId" value="${institutionId}" />
                <input type="hidden" name="branchId" value="${branchId}" />
                <input type="hidden" id="organizationalunitId" name="organizationalunitId" value="${organizationalunitId }" />    
                <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />
            <tr>
                <td><fmt:message key="scholarship.sponsor" />
                </td>      
                <td>                
                    <select id="sponsorId" name="sponsorId" onchange="document.sponsors.submit()">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="oneSponsor" items="${allSponsors}">
                            <c:choose>
                                <c:when test="${ sponsorId == oneSponsor.id }"> 
                                    <option value="${oneSponsor.id}" selected="selected">${oneSponsor.name}</option>
                                </c:when>
                                <c:otherwise>
                                    <option value="${oneSponsor.id}">${oneSponsor.name}</option>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </select>
                </td>
             </tr>
             </form>
                      
        </table>
        </td></tr></table>          
        </p>
        <c:choose>
            <c:when test="${(not empty showError)}">             
            <p align="left" class="error">
                <fmt:message key="jsp.error.subsidy.delete" />
           </c:when>
        </c:choose>
                            
    </fieldset>
        
        <c:set var="allEntities" value="${allSubsidies}" scope="page" />
        <c:set var="redirView" value="subsidies" scope="page" />
        <c:set var="entityNumber" value="0" scope="page" />

        <%@ include file="../../includes/pagingHeader.jsp"%>

        <table class="tabledata" id="TblData">
            <th><fmt:message key="jsp.general.title" /></th>
            <th><fmt:message key="jsp.general.firstnames" /></th>
            <th><fmt:message key="jsp.general.surname" /></th>
            <th><fmt:message key="jsp.general.birthdate" /></th>
            <th><fmt:message key="jsp.general.subsidy" /></th>
            <th><fmt:message key="scholarship.sponsor" /></th>
            <th><fmt:message key="jsp.general.date" /></th><th></th>

            <c:forEach var="subsidy" items="${allSubsidies}">
                <c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
                <c:choose>
                    <c:when test="${(entityNumber < (currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
                    <tr>
                        <td>
                        <c:forEach var="civilTitle" items="${allCivilTitles}">
                           <c:choose>
                                <c:when test="${civilTitle.code == subsidy.civilTitleCode}">
                                    ${civilTitle.description}
                                </c:when>
                           </c:choose>
                        </c:forEach>
                        </td>
                        <td>${subsidy.firstnamesFull}</td>
                        <td>
                            <a href="<c:url value='/scholarship/scholarshipstudent.view?tab=2&panel=0&studentId=${subsidy.studentId}&currentPageNumber=${currentPageNumber}'/>" 
                                        title='<fmt:message key="jsp.href.edit" /> ${subsidy.firstnamesFull} ${subsidy.surnameFull} <fmt:message key="jsp.general.subsidy" />'>
                                ${subsidy.surnameFull}</a>
                        </td>
                        <td><fmt:formatDate type="date" value="${subsidy.birthdate}" /></td>
                        <td>${subsidy.subsidyTypeDescription}</td>
                        <td>${subsidy.sponsorName}</td>
                        <td>${subsidy.subsidyDate}</td>
                        <td>
                            <a href="<c:url value='/scholarship/subsidy.view?tab=2&panel=0&studentId=${subsidy.studentId}&scholarshipStudentId=${subsidy.scholarshipStudentId}&subsidyId=${subsidy.subsidyId}&currentPageNumber=${currentPageNumber}'/>" 
                                    title='<fmt:message key="jsp.href.edit" /> ${subsidy.firstnamesFull} ${subsidy.surnameFull} <fmt:message key="jsp.general.subsidy" />'>
                                <img src="<c:url value='/images/edit.gif' />" alt='<fmt:message key="jsp.href.edit" />' title='<fmt:message key="jsp.href.edit" />' /></a>
                                &nbsp;&nbsp;<a href="<c:url value='/scholarship/subsidy_delete.view?tab=2&panel=0&studentId=${subsidy.studentId}&scholarshipStudentId=${subsidy.scholarshipStudentId}&subsidyId=${subsidy.subsidyId}&currentPageNumber=${currentPageNumber}'/>"
                        onclick="return confirm('<fmt:message key="jsp.subsidy.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
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
