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

<c:set var="readInstitutions" value="${false}"/>
<sec:authorize access="hasRole('READ_INSTITUTIONS')">
    <c:set var="readInstitutions" value="${true}"/>
</sec:authorize>

<c:set var="readBranches" value="${false}"/>
<sec:authorize access="hasRole('READ_BRANCHES')">
    <c:set var="readBranches" value="${true}"/>
</sec:authorize>


<c:set var="readOrgUnits" value="${false}"/>
<sec:authorize access="hasAnyRole('READ_PRIMARY_AND_CHILD_ORG_UNITS', 'READ_ORG_UNITS')">
    <c:set var="readOrgUnits" value="${true}"/>
</sec:authorize>


<table width="100%">

    <tr>
        <td><label><fmt:message key="jsp.general.institution" /></label></td>
        <td>
            <c:choose>
                <c:when test="${readInstitutions}">
                    <select  
                            name="institutionId" 
                            id="institutionId"
                            onchange="
                            document.getElementById('branchId').value='0';
                            document.getElementById('organizationalUnitId').value='0';
                            document.getElementById('primaryStudyId').value='0';
                            document.getElementById('studyGradeTypeId').value='0';                                
                            document.mainForm.submit();                                
                            "
                    >
                        <option value="0"><fmt:message
                            key="jsp.selectbox.choose" /></option>
                        <c:forEach var="university" items="${allInstitutions}">
                            <c:choose>
                                <c:when
                                    test="${(institutionId == null && university.id == institution.id) || (institutionId != null && institutionId != 0 && university.id == institutionId) }">
                                    <option value="<c:out value='${university.id}' />" selected="selected"><c:out value='${university.institutionDescription}' /></option>
                                </c:when>
                                <c:otherwise>
                                    <option value="<c:out value='${university.id}' />"><c:out value='${university.institutionDescription}' /></option>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </select>
                </c:when>
                <c:otherwise>
                        <c:out value='${institution.institutionDescription}' />
                </c:otherwise>
            </c:choose>
        </td>
        <td><label><fmt:message key="jsp.general.grade" /></label></td>
        <td>
            <select 
                name="studyGradeTypeId"
                id="studyGradeTypeId"
                onchange="document.mainForm.submit();"
                >
                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                <c:forEach var="studyGradeType" items="${allStudyGradeTypes}">
                    <c:choose>
                        <c:when
                            test="${(studyGradeTypeId != null && studyGradeTypeId != 0 
                                        && studyGradeType.id == studyGradeTypeId) }">
                            <option value="<c:out value='${studyGradeType.id}' />" selected="selected">
                        </c:when>
                        <c:otherwise>
                            <option value="<c:out value='${studyGradeType.id}' />">
                        </c:otherwise>
                    </c:choose>
                    <c:forEach var="study" items="${allStudies}">
                        <c:choose>
                            <c:when test="${study.id == studyGradeType.studyId}">
                                <c:out value='${study.studyDescription}' />
                            </c:when>
                        </c:choose>
                    </c:forEach>
                    <c:forEach var="gradeType" items="${allGradeTypes}">
                        <c:choose>
                            <c:when test="${gradeType.code == studyGradeType.gradeTypeCode}">
                                <c:out value='- ${gradeType.description}' /></option>
                            </c:when>
                        </c:choose>
                    </c:forEach>
                </c:forEach>
            </select>
        </td>
    </tr>
    
    <tr>
        <td><label><fmt:message key="jsp.general.branch" /></label></td>
        <td>
            <c:choose>
                <c:when test="${readBranches || readInstitutions}">
                    <select  
                        name="branchId" 
                        id="branchId"
                        onchange="
                            document.getElementById('organizationalUnitId').value='0';
                            document.getElementById('primaryStudyId').value='0';
                            document.getElementById('studyGradeTypeId').value='0';                                
                            document.mainForm.submit();                                
                            "
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
                                            <option value="<c:out value='${oneBranch.id}' />" selected="selected"><c:out value='${oneBranch.branchDescription}' /></option>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="<c:out value='${oneBranch.id}' />"><c:out value='${oneBranch.branchDescription}' /></option>
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
                                                    <option value="<c:out value='${oneBranch.id}' />" selected="selected"><c:out value='${oneBranch.branchDescription}' /></option>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="<c:out value='${oneBranch.id}' />"><c:out value='${oneBranch.branchDescription}' /></option>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </select>
                </c:when>
                <c:otherwise>
                    <c:out value='${branch.branchDescription}' />
                </c:otherwise>
            </c:choose>
        </td>
        <td><label><fmt:message key="jsp.general.cardinaltimeunit.number" /></label></td>
        <td width="200">
            <!-- make one option for each cardinalTimeUnit -->
            <select name="cardinalTimeUnitNumber" id="cardinalTimeUnitNumber" onchange="document.mainForm.submit();">
                <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                <c:forEach var="studyGradeType" items="${allStudyGradeTypes}">
                   <c:choose>
                        <c:when test="${(studyGradeTypeId != null && studyGradeTypeId != 0) }"> 
                           <c:choose>
                               <c:when test="${studyGradeType.id == studyGradeTypeId}"> 
                                    <c:forEach var="i" begin="1" end="${studyGradeType.numberOfCardinalTimeUnits}" varStatus="varStatus">
                                        <c:choose>
                                            <c:when test="${(cardinalTimeUnitNumber == i) }"> 
                                               <option value="<c:out value='${i}' />" selected="selected"><c:out value='${i}' /></option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="<c:out value='${i}' />"><c:out value='${i}' /></option>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </c:when>
                            </c:choose>
                        </c:when>
                    </c:choose>
                </c:forEach>
            </select>
        </td>
    </tr>
       
    <tr>
        <td><label><fmt:message key="jsp.general.organizationalunit" /></label></td>
        <td>
            <c:choose>
                <c:when test="${readOrgUnits}">
                    <select name="organizationalUnitId"
                        id="organizationalUnitId"
                        onchange="
                                    document.getElementById('primaryStudyId').value='0';
                                    document.getElementById('studyGradeTypeId').value='0';                                
                                    document.mainForm.submit();                                
                                    "
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
                                            <option value="<c:out value='${oneOrganizationalUnit.id}' />" selected="selected"><c:out value='${oneOrganizationalUnit.organizationalUnitDescription}' /></option>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="<c:out value='${oneOrganizationalUnit.id}' />"><c:out value='${oneOrganizationalUnit.organizationalUnitDescription}' /></option>
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
                                                    <option value="<c:out value='${oneOrganizationalUnit.id}' />" selected="selected"><c:out value='${oneOrganizationalUnit.organizationalUnitDescription}' /></option>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="<c:out value='${oneOrganizationalUnit.id}' />"><c:out value='${oneOrganizationalUnit.organizationalUnitDescription}' /></option>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </select>
                </c:when>
                <c:otherwise>
                	<c:out value='${organizationalUnit.organizationalUnitDescription}' />
                </c:otherwise>
            </c:choose>
        </td>

        <td><label><fmt:message key="jsp.general.studyplanstatus" /></label></td>
        <td>
            <select
                name="studyPlanStatusCode" id="studyPlanStatusCode"
                class="reportParam"
                onchange="document.mainForm.submit();"                 
            >
                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                <c:forEach var="oneStatus" items="${allStudyPlanStatuses}">
                    <c:choose>
                        <c:when test="${oneStatus.code == studyPlanStatusCode}">
                            <option value="<c:out value='${oneStatus.code}' />" selected="selected"><c:out value='${oneStatus.description}' /></option>
                        </c:when>
                        <c:otherwise>
                            <option value="<c:out value='${oneStatus.code}' />"><c:out value='${oneStatus.description}' /></option>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </select>
        </td>
    </tr>
    <tr>
        <td><label><fmt:message key="jsp.general.study" /></label></td>
        <td>
            <select id="primaryStudyId" name="primaryStudyId" onchange="
                                document.getElementById('studyGradeTypeId').value='0';                                
                                document.mainForm.submit();                                
                                "
            >
                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                <c:forEach var="oneStudy" items="${allStudies}">
                    <c:choose>
                        <c:when test="${(primaryStudyId != null && primaryStudyId != 0) }">
                            <c:choose>
                                <c:when test="${oneStudy.id == primaryStudyId}">
                                    <option value="<c:out value='${oneStudy.id}' />" selected="selected"><c:out value='${oneStudy.studyDescription}' /></option>
                                </c:when>
                                <c:otherwise>
                                    <option value="<c:out value='${oneStudy.id}' />"><c:out value='${oneStudy.studyDescription}' /></option>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <option value="<c:out value='${oneStudy.id}' />"><c:out value='${oneStudy.studyDescription}' /></option>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </select>
        </td>
        <td class="label"><fmt:message key="jsp.general.gender" /></td>
                   <td>
                    <select name="genderCode" id="genderCode" onchange="document.mainForm.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="gender" items="${allGenders}">
                             <c:choose>
                                  <c:when test="${(genderCode != null && genderCode != 0 
                                          && gender.code == genderCode) }"> 
                                      <option value="<c:out value='${gender.code}' />" selected="selected"><c:out value='${gender.description}' /></option>
                                  </c:when>
                                  <c:otherwise>
                                      <option value="<c:out value='${gender.code}' />"><c:out value='${gender.description}' /></option>
                                  </c:otherwise>
                              </c:choose>
                        </c:forEach>
                    </select>
                    </td>
        
    </tr>

    <tr>
        <td><label><fmt:message key="jsp.general.academicyear" /></label></td>
        <td>
            <select name="academicYearId" id="academicYearId" onchange="
                          document.getElementById('studyGradeTypeId').value='0';                                
                          document.mainForm.submit();                                
                         "
            >
                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                <c:forEach var="academicYear" items="${allAcademicYears}">
                    <c:choose>
                        <c:when test="${academicYear.id == academicYearId}">
                            <option value="<c:out value='${academicYear.id}' />" selected="selected"><c:out value='${academicYear.description}' /></option>
                        </c:when>
                        <c:otherwise>
                            <option value="<c:out value='${academicYear.id}' />"><c:out value='${academicYear.description}' /></option>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </select>
        </td>
    </tr>
    
</table>
