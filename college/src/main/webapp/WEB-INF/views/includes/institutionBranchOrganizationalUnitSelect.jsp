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

<%@ include file="navigation_privileges.jsp"%>

<c:if test="${showInstitutions}">
            <form name="universities" action="<c:url value='${action}'/>" method="post" target="_self">
            <input type="hidden" name="branchId" value="0" />
            <input type="hidden" name="organizationalUnitId" value="0" />
            <input type="hidden" id="searchValue" name="searchValue" value="" />
            <input type="hidden" name="currentPageNumber" id="currentPageNumber" value="${currentPageNumber}" />

            <table>
                <tr>
                    <td width="200"><fmt:message key="jsp.general.university" /></td>
                    <td>
                    <select name="institutionId" onchange="document.universities.currentPageNumber.value='1';document.getElementById('branchId').value='0';document.getElementById('organizationalUnitId').value='0';document.getElementById('searchValue').value='';document.universities.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="university" items="${allInstitutions}">
                           <c:choose>
                           <c:when test="${(institutionId == null && university.id == institution.id) || (institutionId != null && institutionId != 0 && university.id == institutionId) }"> 
                                <option value="${university.id}" selected="selected"><c:out value="${university.institutionDescription}"/></option>
                            </c:when>
                            <c:otherwise>
                                <option value="${university.id}"><c:out value="${university.institutionDescription}"/></option>
                            </c:otherwise>
                           </c:choose>
                        </c:forEach>
                    </select>
                    </td> 
                    <td></td>
               </tr>
            </table>
            </form>
</c:if>

<c:if test="${showBranches}">
            <form name="branches" action="<c:url value='${action}'/>" method="post" target="_self">
            <input type="hidden" name="institutionId" value="${institutionId}" />
            <input type="hidden" name="organizationalUnitId" value="0" />
            <input type="hidden" id="searchValue" name="searchValue" value="" />
            <input type="hidden" name="currentPageNumber" id="currentPageNumber" value="${currentPageNumber}" />
            
            <table>
                <tr>
                    <td width="200"><fmt:message key="jsp.general.branch" /></td>
                    <td>
                    <select name="branchId" id="branchId" onchange="document.getElementById('organizationalUnitId').value='0';
                                                                    document.branches.currentPageNumber.value='1';
                                                                    document.getElementById('searchValue').value='';document.branches.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="oneBranch" items="${allBranches}">
                            <c:choose>
                            <c:when test="${(institutionId == null) }"> 
                                <c:choose>
                                    <c:when test="${(branchId == null && oneBranch.id == branch.id) 
                                        || (branchId != null && oneBranch.id == branchId) }"> 
                                        <option value="${oneBranch.id}" selected="selected"><c:out value="${oneBranch.branchDescription}"/></option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${oneBranch.id}"><c:out value="${oneBranch.branchDescription}"/></option>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${(institutionId == oneBranch.institutionId) }"> 
                                        <c:choose>
                                            <c:when test="${(branchId == null && oneBranch.id == branch.id) 
                                                || (branchId != null && oneBranch.id == branchId) }"> 
                                                <option value="${oneBranch.id}" selected="selected"><c:out value="${oneBranch.branchDescription}"/></option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="${oneBranch.id}"><c:out value="${oneBranch.branchDescription}"/></option>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                </c:choose>
                           </c:otherwise>
                           </c:choose>
                        </c:forEach>
                    </select>
                    </td> 
                    <td></td>
               </tr>
            </table>
            </form>
</c:if>  
<c:if test="${showOrgUnits}">
            <form name="organizationalunits" action="<c:url value='${action}'/>" method="post" target="_self">
            <input type="hidden" name="institutionId" value="${institutionId}" />
            <input type="hidden" name="branchId" value="${branchId}" />
            <input type="hidden" id="searchValue" name="searchValue" value="" />
            <input type="hidden" name="currentPageNumber" id="currentPageNumber" value="${currentPageNumber}" />
            
            <table>
                <tr>
                    <td width="200"><fmt:message key="jsp.general.organizationalunit" /></td>
                    <td>
                    <select name="organizationalUnitId" id="organizationalUnitId" onchange="document.getElementById('searchValue').value='';
                                                                                            document.organizationalunits.currentPageNumber.value='1';
                                                                                            document.organizationalunits.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="oneOrganizationalUnit" items="${allOrganizationalUnits}">
                            <c:choose>
                            <c:when test="${(branchId == null) }"> 
                                <c:choose>
                                    <c:when test="${(organizationalUnitId == null && oneOrganizationalUnit.id == organizationalUnit.id) 
                                        || (organizationalUnitId != null && oneOrganizationalUnit.id == organizationalUnitId) }"> 
                                        <option value="${oneOrganizationalUnit.id}" selected="selected"><c:out value="${oneOrganizationalUnit.organizationalUnitDescription}"/></option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${oneOrganizationalUnit.id}"><c:out value="${oneOrganizationalUnit.organizationalUnitDescription}"/></option>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${(branchId == oneOrganizationalUnit.branchId) }"> 
                                        <c:choose>
                                            <c:when test="${(organizationalUnitId == null && oneOrganizationalUnit.id == organizationalUnit.id)
                                                || (organizationalUnitId != null && oneOrganizationalUnit.id == organizationalUnitId) }"> 
                                                <option value="${oneOrganizationalUnit.id}" selected="selected"><c:out value="${oneOrganizationalUnit.organizationalUnitDescription}"/></option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="${oneOrganizationalUnit.id}"><c:out value="${oneOrganizationalUnit.organizationalUnitDescription}"/></option>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                </c:choose>
                           </c:otherwise>
                           </c:choose>
                        </c:forEach>
                    </select>
                    </td> 
                    <td>
                    </td>
                </tr>
            </table>
            </form>
</c:if>
        
