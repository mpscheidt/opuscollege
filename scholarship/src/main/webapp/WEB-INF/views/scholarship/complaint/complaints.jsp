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
 * Copyright (c) 2008 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
--%>

<%@ include file="../../header.jsp"%>

<%@ include file="../../includes/javascriptfunctions.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <div id="tabcontent">
    
        <fieldset>
        <legend>
            <fmt:message key="jsp.complaints.header" />
        </legend>
        <p align="left">
        <table>
	        <tr>
	        <td>
	            <%@ include file="../../includes/institutionBranchOrganizationalUnitSelect.jsp"%>
	        </td>
	        <td>
	        <table id="complaintFilters">
	            <form name="sponsors" method="POST" action="<c:url value='${action}'/>">    
	            <tr>
	                <input type="hidden" name="institutionId" value="${institutionId}" />
	                <input type="hidden" name="branchId" value="${branchId}" />
	                <input type="hidden" id="organizationalunitId" name="organizationalunitId" value="${organizationalunitId }" />
	                <input type="hidden" name="selectedAcademicYearId" value="${selectedAcademicYearId}" />    
                    <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />
	                <td><fmt:message key="scholarship.sponsor" />
	                </td>      
	                <td>                
	                    
	                    <select id="sponsorId" name="sponsorId" onchange="document.sponsors.submit()">
	                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
	                        <c:forEach var="oneSponsor" items="${allSponsors}">
	                            <c:choose>
	                                <c:when test="${ sponsorId == oneSponsor.id }"> 
	                                    <option value="${oneSponsor.id}" selected="selected">${oneSponsor.name}</option>
	                                </c:when>
	                                <c:otherwise>
	                                    <option value="${oneSponsor.id}">${oneSponsor.name}</option>
	                                </c:otherwise>
	                            </c:choose>
	                        </c:forEach>
	                    </select>
	                </td>
	             </tr>
	             </form>
	             <form name="academicyears" method="POST" action="<c:url value='${action}'/>">
	                <input type="hidden" name="tab" value="0" /> 
	                <input type="hidden" name="panel" value="0" />
	                <input type="hidden" name="institutionId" value="${institutionId}" />
	                <input type="hidden" name="branchId" value="${branchId}" />
	                <input type="hidden" id="organizationalunitId" name="organizationalunitId" value="${organizationalunitId }" />  
	                <input type="hidden" name="sponsorId" value="${sponsorId}" />
                    <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />
	
	                <tr>
	                <td><fmt:message key="jsp.general.academicyear" /></td>
	                <td>
	                    <select name="selectedAcademicYearId" id="selectedAcademicYearId" onchange="document.academicyears.submit();">
	                        <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
	                        <c:forEach var="oneAcademicYear" items="${academicYearsForSponsor}">
	                             <c:choose>
	                                 <c:when test="${selectedAcademicYearId == oneAcademicYear.id}">
	                                     <option value="${oneAcademicYear.id}" selected="selected">${oneAcademicYear.description}</option> 
	                                 </c:when>
	                                 <c:otherwise>
	                                     <option value="${oneAcademicYear.id}">${oneAcademicYear.description}</option> 
	                                 </c:otherwise>
	                             </c:choose>
	                        </c:forEach>
	                    </select>
	                </td>
	                </tr>
	            </form>
                </table>
            </td></tr>
            </table>          
            </p>
            <c:choose>
                <c:when test="${(not empty showError)}">             
                <p align="left" class="error">
                    <fmt:message key="jsp.error.complaint.delete" />
               </c:when>
            </c:choose>
                            
    </fieldset>
        
        <c:set var="allEntities" value="${allComplaints}" scope="page" />
        <c:set var="redirView" value="complaints" scope="page" />
        <c:set var="entityNumber" value="0" scope="page" />

        <%@ include file="../../includes/pagingHeader.jsp"%>

        <table class="tabledata" id="TblData">
            <th><fmt:message key="jsp.general.scholarship" /> / <fmt:message key="scholarship.sponsor" /> / <fmt:message key="jsp.general.academicyear" /></th>
            <th><fmt:message key="jsp.general.surname" />, <fmt:message key="jsp.general.firstnames" /></th>
            <th><fmt:message key="jsp.general.complaintdate" /> / <fmt:message key="jsp.general.reason" /> / <fmt:message key="jsp.general.complaintstatus" /></th>
            
            <c:forEach var="scholarshipApplicationComplaints" items="${allScholarshipApplicationComplaints}">
                <c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
                <c:choose>
                    <c:when test="${(entityNumber < (currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
                    <c:if test="${ (opusUserRole.role == 'student' && opusUser.personId == student.personId)
                        || opusUserRole.role != 'student' && opusUserRole.role != 'guest' }" >
                    <tr>
                        <td>
                            <c:forEach var="scholarship" items="${allScholarships}">
                                <c:choose>
                                    <c:when test="${scholarshipApplicationComplaints.scholarshipAppliedForId == scholarship.id}">
                                        ${scholarship.scholarshipType.description} / ${scholarship.sponsor.name} / 
                                        <c:forEach var="oneAcademicYear" items="${allAcademicYears}">
                                             <c:choose>
                                                 <c:when test="${scholarship.sponsor.academicYearId == oneAcademicYear.id}">
                                                    ${oneAcademicYear.description}
                                                 </c:when>
                                             </c:choose>
                                        </c:forEach>
                                    </c:when>
                                </c:choose>
                            </c:forEach>
                        </td>   
                        <td>
                            <c:forEach var="scholarshipStudent" items="${allScholarshipStudents}">
                                <c:choose>
                                    <c:when test="${scholarshipApplicationComplaints.scholarshipStudentId == scholarshipStudent.scholarshipStudentId}">
                                        ${scholarshipStudent.surnameFull},&nbsp;${scholarshipStudent.firstnamesFull}
                                        <c:set var="studentId" value="${scholarshipStudent.studentId}" scope="page" />
                                    </c:when>
                                </c:choose>
                            </c:forEach>
                        
                            <a href="<c:url value='/scholarship/scholarshipapplication.view?newForm=true&tab=1&panel=0&studentId=${studentId}&scholarshipApplicationId=${scholarshipApplicationComplaints.id}&scholarshipStudentId=${scholarshipApplicationComplaints.scholarshipStudentId}&currentPageNumber=${currentPageNumber}'/>" />
                               <img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" />
                            </a>
                        </td>
                        <td width="350">
                            <table>
                                <!--  list of complaints -->
                                <c:forEach var="complaint" items="${scholarshipApplicationComplaints.complaints}">
                                        <tr>
                                            <td width="80">
                                                <fmt:formatDate pattern="dd/MM/yyyy" value="${complaint.complaintDate}" />
                                            </td>
                                            <td width="200">
                                                ${complaint.reason}
                                            </td>       
                                            <td width="90">&nbsp;
                                                <!-- Criteria for rejection or acceptance of the scholarship  -->
                                                <c:forEach var="complaintStatus" items="${allComplaintStatuses}">
                                                    <c:choose>
                                                        <c:when test="${complaintStatus.code == complaint.complaintStatusCode}">
                                                            ${complaintStatus.description}
                                                        </c:when>
                                                    </c:choose>
                                                </c:forEach>
                                            </td>
                                            <td class="buttonsCell">
                                                <a href="<c:url value='/scholarship/complaint.view?tab=1&panel=0&studentId=${studentId}&scholarshipApplicationId=${scholarshipApplicationComplaints.id}&scholarshipStudentId=${scholarshipApplicationComplaints.scholarshipStudentId}&complaintId=${complaint.id}&currentPageNumber=${currentPageNumber}'/>">
                                                    <img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                                &nbsp;&nbsp;
                                                <a href="<c:url value='/scholarship/complaint_delete.view?tab=1&panel=0&studentId=${studentId}&scholarshipApplicationId=${scholarshipApplicationComplaints.id}&scholarshipStudentId=${scholarshipApplicationComplaints.scholarshipStudentId}&complaintId=${complaint.id}&currentPageNumber=${currentPageNumber}'/>" onclick="return confirm('<fmt:message key="jsp.complaint.delete.confirm" />')">
                                                    <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                </a>
                                            </td>
                                        </tr>
                                     </c:forEach>
                                </table>
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
