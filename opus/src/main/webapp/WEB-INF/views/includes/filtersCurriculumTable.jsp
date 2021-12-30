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

The Original Code is Opus-College report module code.

The Initial Developer of the Original Code is
Center for Information Services, Radboud University Nijmegen
and Universidade Catolica de Mocambique.
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

<table cellspacing="10p">
    <sec:authorize access="hasRole('UPDATE_INSTITUTIONS')">
        <tr>
            <td><fmt:message key="jsp.general.institution" />:</td>
            <td>
                <form name="institutionFilterForm" >
                    <input type="hidden" name="branchId" value="0" />
                    <input type="hidden" name="organizationalUnitId" value="0" />
                    <input type="hidden" name="primaryStudyId" value="0" />
                    <input type="hidden" name="academicYearId" value="0" />
                    <input type="hidden" name="studyGradeTypeId" value="0" />
                    <select name="institutionId" id="institutionId" onchange="this.form.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="university" items="${allInstitutions}">
                            <c:choose>
                                <c:when
                                    test="${(institutionId == null && university.id == institution.id) || (institutionId != null && institutionId != 0 && university.id == institutionId) }">
                                    <option value="${university.id}" selected="selected">${university.institutionDescription}</option>
                                </c:when>
                                <c:otherwise>
                                    <option value="${university.id}">${university.institutionDescription}</option>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </select>
                </form>
            </td>
	        <td>&nbsp;</td>
	        <td>&nbsp;</td>
	    </tr>
    </sec:authorize>
    
    <sec:authorize access="hasAnyRole('UPDATE_BRANCHES','UPDATE_INSTITUTIONS')">
        <tr>
                <td><fmt:message key="jsp.general.branch" />:</td>
                <td>
                        <form name="branchFilterForm" method="get" >
                        <input type="hidden" name="organizationalUnitId" value="0" />
                        <input type="hidden" name="primaryStudyId" value="0" />
                        <input type="hidden" name="academicYearId" value="0" />
                        <input type="hidden" name="studyGradeTypeId" value="0" />
                        <select  
                            name="branchId" 
                            id="branchId"
                            onchange="document.branchFilterForm.submit();"
                            >
                            <option value="0"><fmt:message
                                key="jsp.selectbox.choose" /></option>
                            <c:forEach var="oneBranch" items="${allBranches}">
                                <c:choose>
                                    <c:when test="${(institutionId == null) }">
                                        <c:choose>
                                            <c:when
                                                test="${(branchId == null && oneBranch.id == branch.id) 
                                        || (branchId != null && oneBranch.id == branchId) }">
                                                <option value="${oneBranch.id}" selected="selected">${oneBranch.branchDescription}</option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="${oneBranch.id}">${oneBranch.branchDescription}</option>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${(institutionId == oneBranch.institutionId) }">
                                                <c:choose>
                                                    <c:when
                                                        test="${(branchId == null && oneBranch.id == branch.id) 
                                                || (branchId != null && oneBranch.id == branchId) }">
                                                        <option value="${oneBranch.id}" selected="selected">${oneBranch.branchDescription}</option>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <option value="${oneBranch.id}">${oneBranch.branchDescription}</option>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </select>
				</form>
                    </td>
            </tr>
    </sec:authorize>
        
    <sec:authorize access="hasAnyRole('READ_PRIMARY_AND_CHILD_ORG_UNITS','UPDATE_ORG_UNITS','UPDATE_BRANCHES','UPDATE_INSTITUTIONS')">
        <tr>
            <td><fmt:message key="jsp.general.organizationalunit" />:</td>
            <td>
                <form name="organizationalUnitFilterForm" method="get" >
                <input type="hidden" name="primaryStudyId" value="0" />
                <input type="hidden" name="academicYearId" value="0" />
                <input type="hidden" name="studyGradeTypeId" value="0" />
                <select name="organizationalUnitId"
                    id="organizationalUnitId"
                    onchange="document.organizationalUnitFilterForm.submit();"
                    >
                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                    <c:forEach var="oneOrganizationalUnit"
                        items="${allOrganizationalUnits}">
                        <c:choose>
                            <c:when test="${(branchId == null) }">
                                <c:choose>
                                    <c:when
                                        test="${(organizationalUnitId == null && oneOrganizationalUnit.id == organizationalUnit.id) 
                                        || (organizationalUnitId != null && oneOrganizationalUnit.id == organizationalUnitId) }">
                                        <option value="${oneOrganizationalUnit.id}" selected="selected">${oneOrganizationalUnit.organizationalUnitDescription}</option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${oneOrganizationalUnit.id}">${oneOrganizationalUnit.organizationalUnitDescription}</option>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${(branchId == oneOrganizationalUnit.branchId) }">
                                        <c:choose>
                                            <c:when
                                                test="${(organizationalUnitId == null && oneOrganizationalUnit.id == organizationalUnit.id)
                                                || (organizationalUnitId != null && oneOrganizationalUnit.id == organizationalUnitId) }">
                                                <option value="${oneOrganizationalUnit.id}" selected="selected">${oneOrganizationalUnit.organizationalUnitDescription}</option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="${oneOrganizationalUnit.id}">${oneOrganizationalUnit.organizationalUnitDescription}</option>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </select>
                </form>
            </td>
        </tr>
    </sec:authorize>
    
    <tr>
        <td><fmt:message key="jsp.general.study" />:</td>
        <td>
            <form name="primaryStudyFilterForm" method="get" >
            <input type="hidden" name="academicYearId" value="0" />
            <input type="hidden" name="studyGradeTypeId" value="0" />
            <select 
                id="primaryStudyId"
                name="primaryStudyId"
                onchange="document.primaryStudyFilterForm.submit();"
            >
            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            <c:forEach var="oneStudy" items="${allStudies}">
                <c:choose>
                    <c:when test="${(primaryStudyId != null && primaryStudyId != 0) }">
                        <c:choose>
                            <c:when test="${oneStudy.id == primaryStudyId}">
                                <option value="${oneStudy.id}" selected="selected">${oneStudy.studyDescription}</option>
                            </c:when>
                            <c:otherwise>
                                <option value="${oneStudy.id}">${oneStudy.studyDescription}</option>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <option value="${oneStudy.id}">${oneStudy.studyDescription}</option>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </select>
        </form>
        </td>
       
       
    </tr>

    <tr>
        <td><fmt:message key="jsp.general.academicyear" />:</td>
        <td>
        <form name="academicYearFilterForm" method="get" >
        <input type="hidden" name="studyGradeTypeId" value="0" />
        <select name="academicYearId" id="academicYearId" onchange="document.academicYearFilterForm.submit();">
            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            <c:forEach var="academicYear" items="${allAcademicYears}">
                <c:choose>
                    <c:when test="${academicYear.id == academicYearId}">
                        <option value="${academicYear.id}" selected="selected">${academicYear.description}</option>
                    </c:when>
                    <c:otherwise>
                        <option value="${academicYear.id}">${academicYear.description}</option>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </select>
        </form>
        </td>
        
    </tr>
	
	<tr>
	<td><fmt:message key="jsp.general.grade" />:</td>
        
        <td>
        <form name="studyGradeTypeFilterForm" method="get" >
        <select 
            name="studyGradeTypeId"
            id="studyGradeTypeId"
            onchange="document.studyGradeTypeFilterForm.submit();"
            >
            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            <c:forEach var="studyGradeType" items="${allStudyGradeTypes}">
                <c:choose>
                    <c:when
                        test="${(studyGradeTypeId != null && studyGradeTypeId != 0 
                                    && studyGradeType.id == studyGradeTypeId) }">
                        <option value="${studyGradeType.id}" selected="selected">
                    </c:when>
                    <c:otherwise>
                        <option value="${studyGradeType.id}">
                    </c:otherwise>
                </c:choose>
                <c:forEach var="study" items="${allStudies}">
                    <c:choose>
                        <c:when test="${study.id == studyGradeType.studyId}">
                                        ${study.studyDescription}
                                    </c:when>
                    </c:choose>
                </c:forEach>
                <c:forEach var="gradeType" items="${allGradeTypes}">
                    <c:choose>
                        <c:when test="${gradeType.code == studyGradeType.gradeTypeCode}">
                                        - ${gradeType.description}</option>
                        </c:when>
                    </c:choose>
                </c:forEach>
            </c:forEach>
        </select>
        </form>
        </td>
	</tr>

    <tr>
        <td></td>
        <td></td>
    </tr>

</table>
