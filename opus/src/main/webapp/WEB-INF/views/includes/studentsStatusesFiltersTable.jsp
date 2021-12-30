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

<table>
      <c:if test="${showInstitutions}">
          <tr>
              <td class="label"><b><fmt:message key="jsp.general.university" /></b></td>
              <td class="required">
               <form name="universities" id="universities" action="<c:url value='${action}'/>" 
                          method="post" 
                          target="_self">
                        <input type="hidden" name="branchId" value="0" />
                        <input type="hidden" name="organizationalUnitId" value="0" />
                        <input type="hidden" name="primaryStudyId" value="0" />
                        <input type="hidden" name="branchId" value="0" />
                        <input type="hidden" name="organizationalUnitId" value="0" /> 
                        <input type="hidden" name="primaryStudyId" value="0" />
                        <input type="hidden" name="studyId" value="0" />
                        <input type="hidden" name="studyGradeTypeId" value="0" />
                        <!-- <input type="hidden" name="studyYearId" value="0" /> -->
                        <input type="hidden" name="registrationYear" value="${registrationYear}" />
                        <input type="hidden" name="academicYearId" value="${academicYearId}" />
                        <input type="hidden" name="studentStatusCode" value="${studentStatusCode}" />
                        <input type="hidden" name="searchValue" value="${searchValue}" />
                        <input type="hidden" name="orderBy" value="${orderBy}" />
                        
                         <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />
              <select name="institutionId" id="institutionId" onchange="this.form.submit();">
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
              </form>
              </td>
                <c:choose>
                    <c:when test="${dataError == 'institution'}">
                        <td class="error">
                          <fmt:message key="invalid.institutionId.format" />
                       </td>
                    </c:when>
                </c:choose>
            </tr>
    </c:if>

    <c:if test="${showBranches}">
            <tr>
                <td class="label"><b><fmt:message key="jsp.general.branch" /></b></td>
                <td class="required">
                 <form name="branches" id="branches" action="<c:url value='${action}'/>" method="post" target="_self">
                    <input type="hidden" name="institutionId" value="${institutionId}" />
                    <input type="hidden" name="organizationalUnitId" value="0" /> 
                    <input type="hidden" name="primaryStudyId" value="0" />
                    <input type="hidden" name="studyId" value="0" />
                    <input type="hidden" name="studyGradeTypeId" value="0" />
                    <!-- <input type="hidden" name="studyYearId" value="0" /> -->
                    <input type="hidden" name="registrationYear" value="${registrationYear}" />
                    <input type="hidden" name="academicYearId" value="${academicYearId}" />
                    <input type="hidden" name="studentStatusCode" value="${studentStatusCode}" />
                    <input type="hidden" name="orderBy" value="${orderBy}" />
                    <input type="hidden" name="searchValue" value="${searchValue}" />                
                    <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />
                   
                   <select name="branchId" id="branchId" onchange="this.form.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="oneBranch" items="${allBranches}">
                            <c:choose>
                            <c:when test="${(institutionId == null) }"> 
                                <c:choose>
                                    <c:when test="${(branchId == null && oneBranch.id == branch.id) 
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
                                            <c:when test="${(branchId == null && oneBranch.id == branch.id) 
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
              <c:choose>
                    <c:when test="${dataError == 'branch'}">
                        <td class="error">
                          <fmt:message key="invalid.branchId.format" />
                       </td>
                    </c:when>
                </c:choose>
           </tr>
    </c:if>
        
    <c:if test="${showOrgUnits}">
             <tr>
                 <td class="label"><b><fmt:message key="jsp.general.organizationalunit" /></b></td>
                 <td class="required">
                   <form name="organizationalunits" id="organizationalunits" action="<c:url value='${action}'/>" method="post" target="_self">
                    <input type="hidden" name="institutionId" value="${institutionId}" />
                   <input type="hidden" name="branchId" value="${branchId}" />
                    <input type="hidden" name="primaryStudyId" value="0" />
                    <input type="hidden" name="studyId" value="0" />
                    <input type="hidden" name="studyGradeTypeId" value="0" />
                  <!--  <input type="hidden" name="studyYearId" value="0" /> -->
                    <input type="hidden" name="registrationYear" value="${registrationYear}" />
                    <input type="hidden" name="academicYearId" value="${academicYearId}" />
                    <input type="hidden" name="orderBy" value="${orderBy}" />
                    <input type="hidden" name="studentStatusCode" value="${studentStatusCode}" />
                    <input type="hidden" name="searchValue" value="${searchValue}" />
                    
                    
                    <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />

                  <select name="organizationalUnitId" id="organizationalUnitId" onchange="this.form.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="oneOrganizationalUnit" items="${allOrganizationalUnits}">
                            <c:choose>
                            <c:when test="${(branchId == null) }"> 
                                <c:choose>
                                    <c:when test="${(organizationalUnitId == null && oneOrganizationalUnit.id == organizationalUnit.id) 
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
                                            <c:when test="${(organizationalUnitId == null && oneOrganizationalUnit.id == organizationalUnit.id)
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
                <c:choose>
                <c:when test="${dataError == 'organizationalunit'}">
                        <td class="error">
                          <fmt:message key="invalid.organizationalUnitId.format" />
                       </td>
                    </c:when>
                </c:choose>
            </tr>
    </c:if>

<!-- start of primary study -->
            <tr>
                <td class="label"><b><fmt:message
                    key="jsp.general.study" /></b></td>
                <td class="required">
                  <form name="studies" id="studies" method="post" target="_self" action="<c:url value='${action}'/>">
                    <input type="hidden" name="institutionId" value="${institutionId}" />
                    <input type="hidden" name="branchId" value="${branchId}" />
                    <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
                    <input type="hidden" name="studyGradeTypeId" value="0" />
                    <!-- <input type="hidden" name="studyYearId" value="0" /> -->
                    <input type="hidden" name="registrationYear" value="${registrationYear}" />
                    <input type="hidden" name="academicYearId" value="${academicYearId}" />
                    <input type="hidden" name="orderBy" value="${orderBy}" />
                    <input type="hidden" name="studentStatusCode" value="${studentStatusCode}" />
                    <input type="hidden" name="searchValue" value="${searchValue}" />
                  
                  <input type="hidden" name="searchValue" value="${searchValue}" />
                  <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />

                    <select name="primaryStudyId"
                        onchange="this.form.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="oneStudy" items="${allStudies}">
                            <c:choose>
                                <c:when test="${oneStudy.id == primaryStudyId}">
                                    <option value="${oneStudy.id}" selected="selected">${oneStudy.studyDescription}</option>
                                </c:when>
                                <c:otherwise>
                                    <option value="${oneStudy.id}">${oneStudy.studyDescription}</option>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </select>
                    </form>
                    </td>
                      <c:choose>
                    <c:when test="${dataError == 'study'}">
                        <td class="error">
                          <fmt:message key="invalid.study.format" />
                       </td>
                    </c:when>
                </c:choose>
            </tr>
    <!-- end of primary study -->

    <!-- start of study gradetypes -->
            <form name="studygradetypes" action="<c:url value='${action}'/>" method="post" target="_self">
            <input type="hidden" name="institutionId" value="${institutionId}" />
                    <input type="hidden" name="branchId" value="${branchId}" />
                    <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
                    <input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
                    <input type="hidden" name="studyId" value="${primaryStudyId}" />
                    <!-- <input type="hidden" name="studyYearId" value="0" /> -->
                    <input type="hidden" name="registrationYear" value="${registrationYear}" />
                    <input type="hidden" name="academicYearId" value="${academicYearId}" />
                    <input type="hidden" name="studentStatusCode" value="${studentStatusCode}" />
                    <input type="hidden" name="orderBy" value="${orderBy}" />
                    <input type="hidden" name="searchValue" value="${searchValue}" />
            <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />
            
                <tr>
                    <td width="200" class="label"><fmt:message key="jsp.general.studygradetype" /></td>
                    <td class="required">
                     <select name="studyGradeTypeId" id="studyGradeTypeId" onchange="this.form.submit();">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="studyGradeType" items="${allStudyGradeTypes}">
                           <c:choose>
                               <c:when test="${(studyGradeTypeId != null && studyGradeTypeId != 0 
                                    && studyGradeType.id == studyGradeTypeId) }"> 
                                    <option value="${studyGradeType.id}" selected="selected">
                                </c:when>
                                <c:otherwise>
                                    <option value="${studyGradeType.id}">
                                </c:otherwise>
                           </c:choose>
                           <c:forEach var="study" items="${allStudies}">
                                <c:choose>
                                    <c:when test="${study.id == studyGradeType.studyId}" >
                                        ${study.studyDescription}
                                    </c:when>
                                </c:choose>
                           </c:forEach>
                           <c:forEach var="gradeType" items="${allGradeTypes}">
                                <c:choose>
                                    <c:when test="${gradeType.code == studyGradeType.gradeTypeCode}" >
                                        - ${gradeType.description}</option>
                                    </c:when>
                                </c:choose>
                           </c:forEach>
                        </c:forEach>
                    </select>
                    </td> 
                <c:choose>
                <c:when test="${dataError == 'studygradetype'}">
                        <td class="error">
                          <fmt:message key="invalid.studygradetype.format" />
                       </td>
                    </c:when>
                </c:choose>
               </tr>
            </form>
        <!-- end of grade types -->
         
        <!-- start of academic year -->
    <tr>
        <td class="label"><fmt:message key="jsp.general.academicyear" />:</td>
        <td class="required">
         <form name="academicYearForm" id="academicYearForm" method="post" target="_self" action="<c:url value='${action}'/>">
            <input type="hidden" name="institutionId" value="${institutionId}" />
            <input type="hidden" name="branchId" value="${branchId}" />
            <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" />
            <input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
            <input type="hidden" name="studyId" value="${primaryStudyId}" />
            <input type="hidden" name="studyGradeTypeId" value="${studyGradeTypeId}"/>
           <!-- <input type="hidden" name="studyYearId" value="${studyYearId}" /> -->
            <input type="hidden" name="registrationYear" value="${registrationYear}"/>
            <input type="hidden" name="orderBy" value="${orderBy}" />
            <input type="hidden" name="studentStatusCode" value="${studentStatusCode}" />
            <input type="hidden" name="searchValue" value="${searchValue}" />
            <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />
        
              <select name="academicYearId" id="academicYearId" onchange="this.form.submit();">
                   <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>                           
                       <c:forEach var="year" items="${allAcademicYears}">                          
                           <c:choose>
                               <c:when test="${year.id == academicYearId}">
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
       <c:choose>
                <c:when test="${dataError == 'academicYearId'}">
                        <td class="error">
                          <fmt:message key="invalid.academicYearId.format" />
                       </td>
                    </c:when>
                </c:choose>
    </tr>
    <!-- end of academic year -->
    
    
    <!-- start of statuses -->
    
     <tr>
                        <td class="label"><fmt:message key="jsp.general.statuscode" />: </td>
                <td>
                                   
                     <form name="statusForm" id="statusForm" action="<c:url value='${action}'/>"  method="post">
                        <input type="hidden" name="institutionId" value="${institutionId}" />
                        <input type="hidden" name="branchId" value="${branchId}" />
                        <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" /> 
                        <input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
                        <input type="hidden" name="studyId" value="${primaryStudyId}" />
                        <input type="hidden" name="studyGradeTypeId" value="${studyGradeTypeId}" />
                        <!-- <input type="hidden" name="studyYearId" value="${studyYearId}" /> -->
                        <input type="hidden" name="searchValue" value="${searchValue}" />
                        <input type="hidden" name="academicYearId" value="${academicYearId}" />
                        <input type="hidden" name="orderBy" value="${orderBy}" />
                       
                        <select name="studentStatusCode" id="studentStatusCode" onchange="this.form.submit();">
                              <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                    <c:forEach var="oneStatus" items="${allStudentStatuses}">
                                           <c:choose>
                                             <c:when test="${oneStatus.code == studentStatusCode}">
                                                    <option value="${oneStatus.code}" selected="selected">${oneStatus.description}</option>
                                             </c:when>
                                             <c:otherwise>
                                                   <option value="${oneStatus.code}">${oneStatus.description}</option>
                                             </c:otherwise>
                                               </c:choose>
                                </c:forEach>
                         </select>
                    </form>
                    
                </td>
               </tr>
    <!-- end of statuses -->
    <!--  start of order -->
    <tr>
     <td class="label">
             <fmt:message key="jsp.general.order" />:
                </td>
                <td>
                    
                <form name="orderingForm" id="orderingForm" action="<c:url value='${action}'/>"  method="post">
                    <input type="hidden" name="institutionId" value="${institutionId}" />
                    <input type="hidden" name="branchId" value="${branchId}" />
                    <input type="hidden" name="organizationalUnitId" value="${organizationalUnitId}" /> 
                    <input type="hidden" name="primaryStudyId" value="${primaryStudyId}" />
                    <input type="hidden" name="studyId" value="${primaryStudyId}" />
                    <input type="hidden" name="studyGradeTypeId" value="${studyGradeTypeId}" />
                    <!-- <input type="hidden" name="studyYearId" value="${studyYearId}" /> -->
                    <input type="hidden" name="registrationYear" value="${registrationYear}" />
                    <input type="hidden" name="academicYearId" value="${academicYearId}" />
                    <input type="hidden" name="studentStatusCode" value="${studentStatusCode}" />
                    <input type="hidden" name="searchValue" value="${searchValue}" />
                    <input type="hidden" name="reportFormat" value="${reportFormat}"/>
                    <input type="hidden" name="reportName" value="${reportName}"/>
                    

                     <select name="orderBy" id="orderBy" onchange="this.form.submit();">
                <c:choose>
                    <c:when test="${orderBy == 'person.firstnamesFull' }">
                       <option value="person.firstnamesFull" selected="selected"><fmt:message key="jsp.general.firstnames"/></option>
                    </c:when>
                    <c:otherwise>
                       <option value="person.firstnamesFull"><fmt:message key="jsp.general.firstnames"/></option>
                    </c:otherwise>
                 </c:choose>
                 
                                  
                <c:choose>
                    <c:when test="${orderBy == 'person.surnameFull' }">
                       <option value="person.surnameFull" selected="selected"><fmt:message key="jsp.general.surname"/></option>
                    </c:when>
                    <c:otherwise>
                       <option value="person.surnameFull"><fmt:message key="jsp.general.surname"/></option>
                    </c:otherwise>
                 </c:choose>
                 
                <c:choose>
                    <c:when test="${orderBy == 'student.studentcode' }">
                       <option value="student.studentcode" selected="selected"><fmt:message key="jsp.general.code"/></option>
                    </c:when>
                    <c:otherwise>
                       <option value="student.studentcode"><fmt:message key="jsp.general.code"/></option>
                    </c:otherwise>
                 </c:choose>
                 
           </select>


             </form>
                </td>
                </tr>
    <!-- end of order -->
</table>
