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
                        <select  
                                name="institutionId" 
                                id="institutionId"
                                whereClauseParam="true"
                                requestParam="true" paramGroup="filter"
                                ignoreValue="0"                                
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

                    </td>
	        <td>&nbsp;</td>
	        <td>&nbsp;</td>
	    </tr>
    </sec:authorize>
    
    
        <tr>
            <td><fmt:message key="jsp.general.branch" />:</td>
            <td>
                <sec:authorize access="hasAnyRole('UPDATE_BRANCHES','UPDATE_INSTITUTIONS')">
                   <select  
                            whereClauseParam="true"
                            requestParam="true" paramGroup="filter"
                            ignoreValue="0"        
                            name="branchId" 
                            id="branchId">
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
                </sec:authorize>   
            </td>
                  
                

        <td><fmt:message key="jsp.general.studyyear" />:</td>
        <td>
        <%--Does not makes part of whereClause has it will be set 
            either by clicking on links or by the checkboxes
         --%>
        <select  
            requestParam="true" paramGroup="filter"
            ignoreValue="0"        
            name="studyYearId" id="studyYearId">
          
            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            <c:forEach var="studyYear" items="${allStudyYears}">
                <c:choose>
                    <c:when test="${(studyGradeTypeId == null) }">
                        <c:choose>
                            <c:when
                                test="${(studyYearId != null && studyYearId != 0 
                                        && studyYear.id == studyYearId) }">
                                <option value="${studyYear.id}" selected="selected">${studyYear.yearNumberVariation}
                                - ${studyYear.yearNumber}</option>
                            </c:when>
                            <c:otherwise>
                                <option value="${studyYear.id}">${studyYear.yearNumberVariation}
                                - ${studyYear.yearNumber}</option>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when
                                test="${(studyGradeTypeId == studyYear.studyGradeTypeId) }">
                                <c:choose>
                                    <c:when
                                        test="${(studyYearId != null && studyYearId != 0 
                                                    && studyYear.id == studyYearId) }">
                                        <option value="${studyYear.id}" selected="selected">${studyYear.yearNumberVariation}
                                        - ${studyYear.yearNumber}</option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${studyYear.id}">${studyYear.yearNumberVariation}
                                        - ${studyYear.yearNumber}</option>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </select></td>
    </tr>
    
    <tr>
        <td><fmt:message key="jsp.general.organizationalunit" />:</td>
        <td>                    
            <sec:authorize access="hasAnyRole('READ_PRIMARY_AND_CHILD_ORG_UNITS','UPDATE_ORG_UNITS','UPDATE_BRANCHES','UPDATE_INSTITUTIONS')">

                <select name="organizationalUnitId"
                    id="organizationalUnitId"
                     requestParam="true" paramGroup="filter"
                     ignoreValue="0"        
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
            </sec:authorize>
        </td>
        
        <td><fmt:message key="jsp.general.academicyear" />:</td>
        <td><select 
            name="academicYearId"
            id="academicYearId"
             requestParam="true" paramGroup="filter"
             ignoreValue="0"        
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

        </select></td>
    </tr>
    
    <tr>
        <td><fmt:message key="jsp.general.study" />:</td>
        <td><select 
             id="primaryStudyId"
            name="primaryStudyId"
             whereClauseParam="true"
             requestParam="true" paramGroup="filter"
             ignoreValue="0"        
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
        </select></td>
        <td><fmt:message key="jsp.general.status" />:</td>
        <td><select 
                name="statusCode" id="statusCode"
                 requestParam="true" paramGroup="filter"
                 ignoreValue="0"        
        >
            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            <c:forEach var="oneStatus" items="${allStudentStatuses}">
                <c:choose>
                    <c:when test="${oneStatus.code == statusCode}">
                        <option value="${oneStatus.code}" selected="selected">${oneStatus.description}</option>
                    </c:when>
                    <c:otherwise>
                        <option value="${oneStatus.code}">${oneStatus.description}</option>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </select></td>
    </tr>

    <tr>
        <td><fmt:message key="jsp.general.grade" />:</td>
        
        <td>
        <select 
            requestParam="true" 
            paramGroup="filter"
            whereClauseParam="studygradetype.id"
            name="studyGradeTypeId"
            ignoreValue="0"
            id="studyGradeTypeId">
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
        </select></td>
        <td><fmt:message key="jsp.general.order" />:</td>
        <td><select 
            name="orderBy" id="orderBy"
             paramGroup="reportParam"
        >
            <c:choose>
                <c:when test="${orderBy == 'person.firstnamesFull' }">
                    <option value="person.firstnamesFull" selected="selected"><fmt:message
                        key="jsp.general.firstnames" /></option>
                </c:when>
                <c:otherwise>
                    <option value="person.firstnamesFull"><fmt:message
                        key="jsp.general.firstnames" /></option>
                </c:otherwise>
            </c:choose>


            <c:choose>
                <c:when test="${orderBy == 'person.surnameFull' }">
                    <option value="person.surnameFull" selected="selected"><fmt:message
                        key="jsp.general.surname" /></option>
                </c:when>
                <c:otherwise>
                    <option value="person.surnameFull"><fmt:message
                        key="jsp.general.surname" /></option>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${orderBy == 'student.studentcode' }">
                    <option value="student.studentcode" selected="selected"><fmt:message
                        key="jsp.general.code" /></option>
                </c:when>
                <c:otherwise>
                    <option value="student.studentcode"><fmt:message
                        key="jsp.general.code" /></option>
                </c:otherwise>
            </c:choose>

        </select></td>
    </tr>


    <tr>
        <td></td>
        <td></td>
        <td><fmt:message key="jsp.general.nameFormat" />:</td>
        <td><select 
             name="nameFormat" id="nameFormat"
             paramGroup="reportParam"
        >
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

        </select></td>
    </tr>

</table>
