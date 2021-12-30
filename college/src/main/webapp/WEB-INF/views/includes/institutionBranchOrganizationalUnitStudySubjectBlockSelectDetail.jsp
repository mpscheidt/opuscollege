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
          <tr>
              <td class="label"><b><fmt:message key="jsp.general.university" /></b></td>
              <td class="required">
              <select name="institutionId" onchange="document.getElementById('branchId').value='0';
                                                    document.getElementById('organizationalUnitId').value='0';
                                                    document.getElementById('chosenStudyId').value='0';
                                                    document.getElementById('studyIdSelect').value='0';
                                                    document.getElementById('chosenGradeTypeCode').value='';
                                                    document.getElementById('subjectBlock.id').value='0';
                                                    this.form.submit();">
                  <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                  <c:forEach var="oneInstitution" items="${allInstitutions}">
                     <c:choose>
                     <c:when test="${ oneInstitution.id == institutionId }"> 
                         <option value="${oneInstitution.id}" selected="selected">${oneInstitution.institutionDescription}</option>
                      </c:when>
                      <c:otherwise>
                          <option value="${oneInstitution.id}">${oneInstitution.institutionDescription}</option>
                      </c:otherwise>
                     </c:choose>
                  </c:forEach>
              </select>
              </td> 
              <td></td>
         </tr>
</c:if>

<c:if test="${showBranches}">
            <tr>
                <td class="label"><b><fmt:message key="jsp.general.branch" /></b></td>
                <td class="required">
                <select name="branchId" id="branchId" onchange="document.getElementById('organizationalUnitId').value='0';
                                                    document.getElementById('chosenStudyId').value='0';
                                                    document.getElementById('studyIdSelect').value='0';
                                                    document.getElementById('chosenGradeTypeCode').value='';
                                                    document.getElementById('subjectBlock.id').value='0';
                                                    this.form.submit();">
                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                    <c:forEach var="oneBranch" items="${allBranches}">
                        <c:choose>
                            <c:when test="${ oneBranch.id == branchId }"> 
                                <option value="${oneBranch.id}" selected="true">${oneBranch.branchDescription}</option>
                            </c:when>
                            <c:otherwise>
                                <option value="${oneBranch.id}">${oneBranch.branchDescription}</option>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </select>
                </td> 
                <td></td>
           </tr>
</c:if>
        
<c:if test="${showOrgUnits}">
	         <tr>
	             <td class="label"><b><fmt:message key="jsp.general.organizationalunit" /></b></td>
	             <td class="required">
	             <select name="organizationalUnitId" id="organizationalUnitId" onchange="document.getElementById('chosenStudyId').value='0';
                                                                                        document.getElementById('studyIdSelect').value='0';
                                                                                        document.getElementById('chosenGradeTypeCode').value='0';
                                                                                        document.getElementById('subjectBlock.id').value='0';
                                                                                        this.form.submit();">
	                 <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
	                 <c:forEach var="oneOrganizationalUnit" items="${allOrganizationalUnits}">
	                     <c:choose>
	                         <c:when test="${ oneOrganizationalUnit.id == organizationalUnitId }"> 
	                             <option value="${oneOrganizationalUnit.id}" selected="selected">${oneOrganizationalUnit.organizationalUnitDescription}</option>
	                         </c:when>
	                         <c:otherwise>
	                             <option value="${oneOrganizationalUnit.id}">${oneOrganizationalUnit.organizationalUnitDescription}</option>
	                         </c:otherwise>
	                     </c:choose>
	                 </c:forEach>
	             </select>
	             </td> 
	             <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
	        </tr>
</c:if>
