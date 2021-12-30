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

<c:set var="updateInstitutions" value="${false}"/>
<sec:authorize access="hasRole('UPDATE_INSTITUTIONS')">
    <c:set var="updateInstitutions" value="${true}"/>
</sec:authorize>

<c:set var="updateBranches" value="${false}"/>
<sec:authorize access="hasRole('UPDATE_BRANCHES')">
    <c:set var="updateBranches" value="${true}"/>
</sec:authorize>


<c:set var="readUpdateOrgUnits" value="${false}"/>
<sec:authorize access="hasAnyRole('READ_PRIMARY_AND_CHILD_ORG_UNITS','UPDATE_ORG_UNITS')">
    <c:set var="readUpdateOrgUnits" value="${true}"/>
</sec:authorize>


<table width="100%">

    <tr>
        <td><label><fmt:message key="jsp.general.institution" /></label></td>
        <td>
            <c:choose>
                <c:when test="${updateInstitutions}">
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
                                    <option value="${university.id}" selected="selected">${university.institutionDescription}</option>
                                </c:when>
                                <c:otherwise>
                                    <option value="${university.id}">${university.institutionDescription}</option>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </select>
                </c:when>
                <c:otherwise>
                        ${institution.institutionDescription}
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
                            <option value="${studyGradeType.id}" selected="selected">
                        </c:when>
                        <c:otherwise>
                            <option value="${studyGradeType.id}">
                        </c:otherwise>
                    </c:choose>
                    <c:forEach var="gradeType" items="${allGradeTypes}">
                        <c:choose>
                            <c:when test="${gradeType.code == studyGradeType.gradeTypeCode}">
                                            ${gradeType.description}
                            </c:when>
                        </c:choose>
                    </c:forEach>
                    <c:forEach var="studyForm" items="${allStudyForms}">
                        <c:choose>
                            <c:when test="${studyForm.code == studyGradeType.studyFormCode}">
                                            - ${studyForm.description}
                            </c:when>
                        </c:choose>
                    </c:forEach>
                    <c:forEach var="studyTime" items="${allStudyTimes}">
                        <c:choose>
                            <c:when test="${studyTime.code == studyGradeType.studyTimeCode}">
                                            - ${studyTime.description}
                            </c:when>
                        </c:choose>
                    </c:forEach>
                    </option>
                </c:forEach>
            </select>
        </td>
    </tr>
    
    <tr>
        <td><label><fmt:message key="jsp.general.branch" /></label></td>
        <td>
            <c:choose>
                <c:when test="${updateBranches || updateInstitutions}">
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
                </c:when>
                <c:otherwise>
                        ${branch.branchDescription}
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
		                                       <option value="${i}" selected="selected">${i}</option>
		                                    </c:when>
		                                    <c:otherwise>
		                                        <option value="${i}">${i}</option>
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
                <c:when test="${readUpdateOrgUnits}">
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
                </c:when>
                <c:otherwise>
                        ${organizationalUnit.organizationalUnitDescription}
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
                            <option value="${oneStatus.code}" selected="selected">${oneStatus.description}</option>
                        </c:when>
                        <c:otherwise>
                            <option value="${oneStatus.code}">${oneStatus.description}</option>
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
        </td>
        <td class="label"><fmt:message key="jsp.general.gender" /></td>
                   <td>
                    <select name="genderCode" id="genderCode" onchange="document.mainForm.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="gender" items="${allGenders}">
                             <c:choose>
                                  <c:when test="${(genderCode != null && genderCode != 0 
                                          && gender.code == genderCode) }"> 
                                      <option value="${gender.code}" selected="selected">${gender.description}</option>
                                  </c:when>
                                  <c:otherwise>
                                      <option value="${gender.code}">${gender.description}</option>
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
                            <option value="${academicYear.id}" selected="selected">${academicYear.description}</option>
                        </c:when>
                        <c:otherwise>
                            <option value="${academicYear.id}">${academicYear.description}</option>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </select>
        </td>
        <td><label><fmt:message key="jsp.general.order" /></label></td>
        <td>
            <select name="orderBy" id="orderBy" class="reportParam">
                <c:choose>
                    <c:when test="${orderBy == 'person_firstnamesFull' }">
                        <option value="person_firstnamesFull" selected="selected"><fmt:message
                            key="jsp.general.firstnames" /></option>
                    </c:when>
                    <c:otherwise>
                        <option value="person_firstnamesFull"><fmt:message
                            key="jsp.general.firstnames" /></option>
                    </c:otherwise>
                </c:choose>

                <c:choose>
                    <c:when test="${orderBy == 'person_surnameFull' }">
                        <option value="person_surnameFull" selected="selected"><fmt:message
                            key="jsp.general.surname" /></option>
                    </c:when>
                    <c:otherwise>
                        <option value="person_surnameFull"><fmt:message
                            key="jsp.general.surname" /></option>
                    </c:otherwise>
                </c:choose>

                <c:choose>
                    <c:when test="${orderBy == 'student_studentcode' }">
                        <option value="student_studentcode" selected="selected"><fmt:message
                            key="jsp.general.code" /></option>
                    </c:when>
                    <c:otherwise>
                        <option value="student_studentcode"><fmt:message
                            key="jsp.general.code" /></option>
                    </c:otherwise>
                </c:choose>
            </select>
        </td>
    </tr>
    
     <tr>
     	<td>&nbsp;</td>
     	<td>&nbsp;</td>
     	
     	<td><label><fmt:message key="jsp.general.nameFormat" /></label></td>
        <td>
            <select name="nameFormat" id="nameFormat" class="reportParam">
                <c:choose>
                    <c:when
                        test="${nameFormat == 'jasper.nameformat.surname_firstnames' }">
                        <option value="jasper.nameformat.surname_firstnames"
                            selected="selected"><fmt:message
                            key="jsp.general.nameFormat.surname_firstnames" /></option>
                    </c:when>
                    <c:otherwise>
                        <option value="jasper.nameformat.surname_firstnames"><fmt:message
                            key="jsp.general.nameFormat.surname_firstnames" /></option>
                    </c:otherwise>
                </c:choose>
    
                <c:choose>
                    <c:when
                        test="${nameFormat == 'jasper.nameformat.firstnames_surname' }">
                        <option value="jasper.nameformat.firstnames_surname"
                            selected="selected"><fmt:message
                            key="jsp.general.nameFormat.firstnames_surname" /></option>
                    </c:when>
                    <c:otherwise>
                        <option value="jasper.nameformat.firstnames_surname"><fmt:message
                            key="jsp.general.nameFormat.firstnames_surname" /></option>
                    </c:otherwise>
                </c:choose>
    
            </select>
        </td>
                 
  </tr>

    <tr>
        <td></td>
        <td></td>
    </tr>

</table>
