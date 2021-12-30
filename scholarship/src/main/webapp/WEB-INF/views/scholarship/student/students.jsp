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
 * Copyright (c) 2007 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
--%>

<%@ include file="../../header.jsp"%>

<%@ include file="../../includes/javascriptfunctions.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <div id="tabcontent">
    
        <fieldset>
        <legend>
            <fmt:message key="jsp.scholarshipstudents.header" />

            <c:choose>
                <c:when test="${
                    opusUserRole.role != 'student' 
                    && opusUserRole.role != 'guest'
                    }">
                        <c:set var="reportQueryString" value="" scope="page" />
                        <c:choose>
                            <c:when test="${institutionId != null && institutionId != '' && institutionId != '0' }">
                                <c:set var="reportQueryString" value="${reportQueryString}&where.institution.id=${institutionId}" scope="page" />
                            </c:when>
                        </c:choose>
                        <c:choose>
                            <c:when test="${branchId != null && branchId != '' && branchId != '0' }">
                                <c:set var="reportQueryString" value="${reportQueryString}&where.branch.id=${branchId}" scope="page" />
                            </c:when>
                        </c:choose>
                        <c:choose>
                            <c:when test="${organizationalUnitId != null && organizationalUnitId != '' && organizationalUnitId != '0' }">
                                <c:set var="reportQueryString" value="${reportQueryString}&where.organizationalUnit.id=${organizationalUnitId}" scope="page" />
                            </c:when>
                        </c:choose>
                        <c:choose>
                            <c:when test="${primaryStudyId != null && primaryStudyId != '' && primaryStudyId != '0' }">
                                <c:set var="reportQueryString" value="${reportQueryString}&where.study.id=${primaryStudyId}" scope="page" />
                            </c:when>
                        </c:choose>
                        <c:choose>
                            <c:when test="${studyGradeTypeId != null && studyGradeTypeId != '' && studyGradeTypeId != '0' }">
                                <c:set var="reportQueryString" value="${reportQueryString}&where.studyGradeType.id=${studyGradeTypeId}" scope="page" />
                            </c:when>
                        </c:choose>
                        
                        <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                       	 <c:choose>
                            <c:when test="${subjectBlockId != null && subjectBlockId != '' && subjectBlockId != '0' }">
                                <c:set var="reportQueryString" value="${reportQueryString}&where.subjectBlock.id=${subjectBlockId}" scope="page" />
                            </c:when>
                        </c:choose>
                        </c:if>
                        
                        <c:choose>
                            <c:when test="${cardinalTimeUnitNumber != null && cardinalTimeUnitNumber != '' && cardinalTimeUnitNumber != '0' }">
                                <c:set var="reportQueryString" value="${reportQueryString}&where.subjectBlock.cardinalTimeUnitNumberr=${cardinalTimeUnitNumber}" scope="page" />
                            </c:when>
                        </c:choose>
                        
                        <img src="<c:url value='/images/guest.gif' />" alt="<fmt:message key="jsp.general.report" />" title="<fmt:message key="jsp.general.report" />" /> 
                        <a href="<c:url value='/college/reports.view?reportName=students.pdf${reportQueryString}'/>" target="otherwindow">PDF</a>
                        <%--a href="<c:url value='/college/reports.view?reportName=students.html${reportQueryString}'/>" target="otherwindow">HMTL</a>
                        <a href="<c:url value='/college/reports.view?reportName=students.xls${reportQueryString}'/>">Excel</a --%>
                </c:when>
             </c:choose> 
        
        
        </legend>
        <p align="left">
            <table>
            <tr>
            <td>
            <%@ include file="../../includes/institutionBranchOrganizationalUnitStudySelect.jsp"%>
        <c:choose>
            <c:when test="${
                opusUserRole.role != 'student' 
                && opusUserRole.role != 'guest'
                }">
            <form name="studies" action="${action}" method="POST" target="_self" onchange="document.studies.submit();">
                <input type="hidden" name="institutionId" value="${institutionId}" />
                <input type="hidden" name="branchId" value="${branchId}" />
                <input type="hidden" name="organizationalUnitid" value="${organizationalUnitid}" />
                <input type="hidden" name="studyGradeTypeId" value="0" />
                <!-- <input type="hidden" name="studyYearId" value="0" />
                <input type="hidden" name="yearNumber" value="0" /> -->
                <input type="hidden" name="cardinalTimeUnitNumber" value="0" />
                <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />
                
                <table>
                    <tr>
                        <td width="200"><fmt:message key="jsp.general.study" /></td>
                        <td>
                        <select id="studyId" name="primaryStudyId" onchange="document.getElementById('searchValue').value='';document.studies.submit();">
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
                        <td></td>
                   </tr>
                </table>
            </form>
            </td>
            <td>
                 <%@ include file="../../includes/studyGradeTypeCardinalTimeUnitNumberSelect.jsp"%>
	             <%@ include file="../../includes/appliedScholarshipStudentSelect.jsp"%>
	             <%@ include file="../../includes/grantedScholarshipStudentSelect.jsp"%>
	             <%@ include file="../../includes/grantedSubsidyStudentSelect.jsp"%>
            </c:when>
         </c:choose> 
        </td>
        </tr>
        </table>
        </p>      
        </fieldset>
        
        <c:set var="allEntities" value="${allStudents}" scope="page" />
        <c:set var="redirView" value="students" scope="page" />
        <c:set var="entityNumber" value="0" scope="page" />

        <%@ include file="../../includes/pagingHeader.jsp"%>

        <table class="tabledata" id="TblData">
            <th><fmt:message key="jsp.general.title" /></th>
            <th><fmt:message key="jsp.general.firstnames" /></th>
            <th><fmt:message key="jsp.general.surname" /></th>
            <th><fmt:message key="jsp.general.birthdate" /></th>
            <th><fmt:message key="jsp.general.primarystudy" /></th>
            <th><fmt:message key="jsp.general.scholarship.appliedfor" /></th>
           <!--   <th><fmt:message key="jsp.general.scholarship" /> <fmt:message key="scholarship.granted" /></th>
            <th><fmt:message key="jsp.general.subsidy" />  <fmt:message key="scholarship.granted" /></th>
            -->
            <th><fmt:message key="jsp.general.active" /></th><th></th>

            <c:forEach var="student" items="${allStudents}">
                <c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
                <c:choose>
                    <c:when test="${(entityNumber < (currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
                    <c:if test="${ (opusUserRole.role == 'student' && opusUser.personId == student.personId)
                        || opusUserRole.role != 'student' && opusUserRole.role != 'guest' }" >
                    <tr>
                        <td>
                        <c:forEach var="civilTitle" items="${allCivilTitles}">
                           <c:choose>
                                <c:when test="${civilTitle.code == student.civilTitleCode }">
                                    ${civilTitle.description}
                                </c:when>
                           </c:choose>
                        </c:forEach>
                        </td>
                        <td>${student.firstnamesFull}</td>
                        <td>
                            <c:choose>
                                <c:when test="${opusUser.personId == student.personId
                                 || (opusUserRole.role != 'student' 
                                 && opusUserRole.role != 'guest')
                                }">
                                    <a href="<c:url value='/scholarship/scholarshipstudent.view?tab=0&panel=0&studentId=${student.studentId}&currentPageNumber=${currentPageNumber}'/>" 
                                        title='<fmt:message key="jsp.href.edit" /> ${student.firstnamesFull} ${student.surnameFull} <fmt:message key="jsp.general.scholarship" />'>

                                    ${student.surnameFull}</a>
                                </c:when>
                                <c:otherwise>
                                    ${student.surnameFull}
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatDate type="date" value="${student.birthdate}" /></td>
                        <td>
                            <c:forEach var="study" items="${allStudies}">
                                <c:choose>
                                    <c:when test="${study.id == student.primaryStudyId}">
                                        ${study.studyDescription}
                                    </c:when>
                                </c:choose>
                             </c:forEach>
                        </td>
                        <td>
                            <fmt:message key="${stringToYesNoMap[student.scholarship]}"/>
                       </td>
          <!--             <td>
                            <c:choose>
                                <c:when test="${student.scholarship == 'Y'}">
		                            <c:forEach var="schStudent" items="${allScholarshipStudents}">
		                               <c:choose>
		                                   <c:when test="${schStudent.studentId == student.studentId}"> 
					                            <c:choose>
					                                <c:when test="${schStudent.scholarships[0] != null}">
					                                    <fmt:message key="jsp.general.yes" />
					                                </c:when>
					                                <c:otherwise>
					                                    <fmt:message key="jsp.general.no" />
					                                </c:otherwise>
					                            </c:choose>
	                                        </c:when>
	                                    </c:choose>
	                                </c:forEach>
	                            </c:when>
	                        </c:choose>
                       </td>
                        <td>
                            <c:choose>
                                <c:when test="${student.scholarship == 'Y'}">
                                    <c:forEach var="schStudent" items="${allScholarshipStudents}">
                                       <c:choose>
                                           <c:when test="${schStudent.studentId == student.studentId}"> 
					                            <c:choose>
					                                <c:when test="${schStudent.subsidies[0] != null}">
					                                    <fmt:message key="jsp.general.yes" />
					                                </c:when>
					                                <c:otherwise>
					                                    <fmt:message key="jsp.general.no" />
					                                </c:otherwise>
					                            </c:choose>
                                            </c:when>
                                        </c:choose>
                                    </c:forEach>
                                </c:when>
                            </c:choose>
                        </td>-->
                        <td>
                            <fmt:message key="${stringToYesNoMap[student.active]}"/>
                        </td>
                        <td>
                        <a href="<c:url value='/scholarship/scholarshipstudent.view?tab=1&panel=0&studentId=${student.studentId}&currentPageNumber=${currentPageNumber}'/>" 
                            title='<fmt:message key="jsp.href.edit" /> ${student.firstnamesFull} ${student.surnameFull} <fmt:message key="jsp.general.scholarship" />'>
                        	<img src="<c:url value='/images/edit.gif' />" alt='<fmt:message key="jsp.href.edit" />' title='<fmt:message key="jsp.href.edit" />' /></a>
                        </td>
                    </tr>
                    </c:if>
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
