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

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

    <%@ include file="navigation_privileges.jsp"%>
    
            	<input type="hidden" name="navigationSettings.currentPageNumber" id="navigationSettings.currentPageNumber" value="${navigationSettings.currentPageNumber}" />

                    <c:if test="${showInstitutions}">
			            <table>
			                <tr>
			                    <td class="label"><fmt:message key="jsp.general.university" /></td>
			                    <td width="200" align="right">
			                    <select name="organization.institutionId" id="organization.institutionId" onchange="
			                    		document.getElementById('organization.branchId').value='0';
			                    		document.getElementById('organization.organizationalUnitId').value='0';
                    					document.getElementById('studySettings.studyId').value='0';
                    					document.getElementById('studySettings.studyGradeTypeId').value='0';
                    					document.getElementById('studySettings.cardinalTimeUnitNumber').value='';
                                        document.getElementById('navigationSettings.currentPageNumber').value='1';
 			                    		document.organizationandnavigation.submit();">
			                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                    <c:forEach var="institution" items="${allInstitutions}">
                                        <c:choose>
                                        <c:when test="${institution.id == organization.institutionId}"> 
                                             <option value="${institution.id}" selected="selected"><c:out value="${institution.institutionDescription}"/></option>
                                         </c:when>
                                         <c:otherwise>
                                             <option value="${institution.id}"><c:out value="${institution.institutionDescription}"/></option>
                                         </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
			                    </select>
			                    </td> 
			                    <td></td>
			               </tr>
			            </table>
                    </c:if>

                    <c:if test="${showBranches}">
			            <table>
			                <tr>
			                    <td class="label"><fmt:message key="jsp.general.branch" /></td>
			                    <td width="200" align="right">
			                    <select name="organization.branchId" id="organization.branchId" onchange="
			                    		document.getElementById('organization.organizationalUnitId').value='0';
                    					document.getElementById('studySettings.studyId').value='0';
                    					document.getElementById('studySettings.studyGradeTypeId').value='0';
                    					document.getElementById('studySettings.cardinalTimeUnitNumber').value='';
                                        document.getElementById('navigationSettings.currentPageNumber').value='1';
			                    		document.organizationandnavigation.submit();">
                                    <option value="0"><fmt:message key="jsp.selectbox.all" /></option>
                                    <c:choose>
                                        <c:when test="${(organization.institutionId != 0) }"> 
                                            <c:forEach var="oneBranch" items="${allBranches}">
                                                <c:choose>
                                                    <c:when test="${oneBranch.id == organization.branchId}"> 
                                                        <option value="${oneBranch.id}" selected="selected"><c:out value="${oneBranch.branchDescription}"/></option>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <option value="${oneBranch.id}"><c:out value="${oneBranch.branchDescription}"/></option>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </c:when>
                                    </c:choose>
                                </select>
			                    </td> 
			                    <td></td>
			               </tr>
			            </table>
                    </c:if>		           
                    <c:if test="${showOrgUnits}">
			            <table>
			                <tr>
			                    <td class="label"><fmt:message key="jsp.general.organizationalunit" /></td>
			                    <td width="200" align="right">
			                    <select name="organization.organizationalUnitId" id="organization.organizationalUnitId" onchange="
                    					document.getElementById('studySettings.studyId').value='0';
                    					document.getElementById('studySettings.studyGradeTypeId').value='0';
                    					document.getElementById('studySettings.cardinalTimeUnitNumber').value='';
                                        document.getElementById('navigationSettings.currentPageNumber').value='1';
			                    		document.organizationandnavigation.submit();">
			                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                    <c:forEach var="oneOrganizationalUnit" items="${allOrganizationalUnits}">
                                        <c:set var="orgUnitText">${oneOrganizationalUnit.organizationalUnitDescription} (<fmt:message key="jsp.organizationalunit.level" /> ${oneOrganizationalUnit.unitLevel})</c:set>
                                    	<c:choose>
                                        	<c:when test="${(organization.institutionId != 0 && organization.branchId != 0) }"> 
                                            	<c:choose>
		                                              <c:when test="${ oneOrganizationalUnit.id == organization.organizationalUnitId}"> 
		                                                  <option value="${oneOrganizationalUnit.id}" selected="selected"><c:out value="${orgUnitText}"/></option>
		                                              </c:when>
		                                              <c:otherwise>
		                                                  <option value="${oneOrganizationalUnit.id}"><c:out value="${orgUnitText}"/></option>
		                                              </c:otherwise>
		                                        </c:choose>
                                      		</c:when>
                                      	</c:choose>
                                    </c:forEach>
			                    </select>
			                    </td> 
			                    <td>
			                    </td>
			                </tr>
			            </table>
                    </c:if>
			        
