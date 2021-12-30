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
                            document.getElementById('academicYearId').value='0';
                            document.getElementById('studyGradeTypeId').value='0';
                            document.getElementById('subjectId').value='0';
                            document.getElementById('examinationId').value='0';
                            document.getElementById('cardinalTimeUnitNumber').value='0';                                   
                            document.filtersForm.submit();                                
                            "
                    >
                        <option value="0"><fmt:message
                            key="jsp.selectbox.choose" /></option>
                        <c:forEach var="university" items="${allInstitutions}">
                            <c:choose>
                                <c:when
                                    test="${(institutionId == null && university.id == institution.id) || (institutionId != null && institutionId != 0 && university.id == institutionId) }">
                                    <option value="${university.id}" selected>${university.institutionDescription}</option>
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
                onchange="
                document.getElementById('subjectId').value='0';
                document.getElementById('examinationId').value='0';
                document.getElementById('cardinalTimeUnitNumber').value='0';
                document.filtersForm.submit();
                "
                >
                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                <c:forEach var="studyGradeType" items="${allStudyGradeTypes}">
                    <c:choose>
                        <c:when
                            test="${(studyGradeTypeId != null && studyGradeTypeId != 0 
                                        && studyGradeType.id == studyGradeTypeId) }">
                            <option value="${studyGradeType.id}" selected>
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
                            document.getElementById('academicYearId').value='0';
                            document.getElementById('studyGradeTypeId').value='0';
                            document.getElementById('subjectId').value='0';
                            document.getElementById('examinationId').value='0';  
                            document.getElementById('cardinalTimeUnitNumber').value='0';                              
                            document.filtersForm.submit();                                
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
                                            <option value="${oneBranch.id}" selected>${oneBranch.branchDescription}</option>
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
                                                    <option value="${oneBranch.id}" selected>${oneBranch.branchDescription}</option>
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
        
         <td width="200"><label><fmt:message key="jsp.general.cardinaltimeunit" /></label></td>
                        <td>
                        <select name="cardinalTimeUnitNumber" id="cardinalTimeUnitNumber" 
                        onchange="
                                    document.getElementById('subjectId').value='0';
                                    document.getElementById('examinationId').value='0';                                
                                    document.filtersForm.submit();                                
                                    "
                        >
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="ctusgt" items="${allCardinalTimeUnitStudyGradeTypes}">
                                <c:choose>
                                    <c:when test="${(cardinalTimeUnitNumber == ctusgt.cardinalTimeUnitNumber)}"> 
                                        <option value="${ctusgt.cardinalTimeUnitNumber}" selected="selected">
                                    </c:when>
                                    <c:otherwise>
                                       <option value="${ctusgt.cardinalTimeUnitNumber}">
                                    </c:otherwise>
                                </c:choose>
                                ${allCardinalTimeUnitsMap[selectedStudyGradeType.cardinalTimeUnitCode]}
                                ${ctusgt.cardinalTimeUnitNumber}
                                </option>   
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
                                    document.getElementById('academicYearId').value='0';
                                    document.getElementById('studyGradeTypeId').value='0';
                                    document.getElementById('subjectId').value='0';
                                    document.getElementById('examinationId').value='0';    
                                    document.getElementById('cardinalTimeUnitNumber').value='0';                            
                                    document.filtersForm.submit();                                
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
                                            <option value="${oneOrganizationalUnit.id}" selected>${oneOrganizationalUnit.organizationalUnitDescription}</option>
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
                                                    <option value="${oneOrganizationalUnit.id}" selected>${oneOrganizationalUnit.organizationalUnitDescription}</option>
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
        <td><label><fmt:message key="jsp.general.subject" /></label></td>
        <td>
        <select
            name="subjectId"
            id="subjectId"
            onchange="document.getElementById('examinationId').value='0';
            document.filtersForm.submit();"
        >
            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            <c:forEach var="subject" items="${allSubjects}">
                <c:choose>
                    <c:when test="${subject.id == subjectId}">
                        <option value="${subject.id}" selected="selected">${subject.subjectDescription}</option>
                    </c:when>
                    <c:otherwise>
                        <option value="${subject.id}">${subject.subjectDescription}</option>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </select>
        </td>
        
        
        
    </tr>
    <tr>
        <td><label><fmt:message key="jsp.general.study" /></label></td>
        <td>
            <select 
                id="primaryStudyId"
                name="primaryStudyId"
					onchange="
                                document.getElementById('academicYearId').value='0';
                                document.getElementById('studyGradeTypeId').value='0';
                                document.getElementById('subjectId').value='0';        
                                document.getElementById('examinationId').value='0';  
                                document.getElementById('cardinalTimeUnitNumber').value='0';                      
                                document.filtersForm.submit();                                
                                "
            >
            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            <c:forEach var="oneStudy" items="${allStudies}">
                <c:choose>
                    <c:when test="${(primaryStudyId != null && primaryStudyId != 0) }">
                        <c:choose>
                            <c:when test="${oneStudy.id == primaryStudyId}">
                                <option value="${oneStudy.id}" selected>${oneStudy.studyDescription}</option>
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
        <td><label><fmt:message key="jsp.general.resulttype" /></label></td>
        <td>
            <select 
                id="examinationId"
                name="examinationId"
				onchange="document.filtersForm.submit();"
            >
               <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
               
               <c:if test="${not empty resultsForm.subject}">
            <optgroup label="Notas finais">
            	<c:forEach var="examination" items="${resultsForm.defaultExaminations}">
            		<c:choose>
                    <c:when test="${examination.id == examinationId}">
                        <option value="${examination.id}" selected="selected">${examination.examinationCode} - ${examination.examinationDescription}</option>
                    </c:when>
                    <c:otherwise>
                        <option value="${examination.id}">${examination.examinationCode} - ${examination.examinationDescription}</option>
                    </c:otherwise>
                </c:choose>
            	</c:forEach>
            </optgroup>
            
            <optgroup label="Exames e testes">
            <c:forEach var="examination" items="${resultsForm.subject.examinations}">
             <c:choose>
                    <c:when test="${examination.id == examinationId}">
                        <option value="${examination.id}" selected="selected">${examination.examinationCode} - ${examination.examinationDescription}</option>
                    </c:when>
                    <c:otherwise>
                        <option value="${examination.id}">${examination.examinationCode} - ${examination.examinationDescription}</option>
                    </c:otherwise>
                </c:choose>
        	</c:forEach>
        	</optgroup>
        	</c:if>
        </select>
        </td>
    <tr>
    </tr>

    <tr>
      
    </tr>
<td><label><fmt:message key="jsp.general.academicyear" /></label></td>
        <td>
        <select
            name="academicYearId"
            id="academicYearId"
			onchange="
                      document.getElementById('studyGradeTypeId').value='0';   
                      document.getElementById('subjectId').value='0';              
                      document.getElementById('examinationId').value='0';       
                      document.getElementById('cardinalTimeUnitNumber').value='0';        
                      document.filtersForm.submit();                                
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


        <td></td>
        <td></td>
    </tr>

</table>
