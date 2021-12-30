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

The Original Code is Opus-College fee module code.

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

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <div id="tabcontent">
    
		<fieldset>
		<legend>
			<fmt:message key="jsp.fees.header.payments" />
		</legend>

        <p align="left">

        	<%@ include file="../../includes/institutionBranchOrganizationalUnitStudySelect.jsp"%>

        	<form name="studies" action="<c:url value='${action}'/>" method="POST" target="_self">
                <input type="hidden" name="institutionId" value="${institutionId}" />
                <input type="hidden" name="branchId" value="${branchId}" />
                <input type="hidden" name="organizationalUnitid" value="${organizationalUnitid}" />
            	<input type="hidden" name="studyGradeTypeId" value="0" />
            	<!-- <input type="hidden" name="studyYearId" value="0" /> 
            	<input type="hidden" name="yearNumber" value="0" /> -->
                <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />
                
                <table>
                    <tr>
                        <td width="200"><fmt:message key="jsp.general.study" /></td>
                        <td>
                        <select id="studyId" name="primaryStudyId" onchange="document.studies.submit();">
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
         	
            <%@ include file="../../includes/studyGradeTypeCardinalTimeUnitNumberSelect.jsp"%>

        </p>      
		</fieldset>
		
<%-- 		<c:set var="allEntities" value="${allStudents}" scope="page" /> --%>
		<c:set var="redirView" value="paymentsstudents" scope="page" />
<!-- 		<c:set var="entityNumber" value="0" scope="page" /> -->

<%--         <%@ include file="../../includes/pagingHeader.jsp"%> --%>

        <%-- no calculations needed for the paging header, just the total entity count --%>
        <c:set var="countAllEntities" value="${studentCount}" scope="page" />
        <%@ include file="../../includes/pagingHeaderInterface.jsp"%>           

        <table class="tabledata" id="TblData">
            <th><fmt:message key="jsp.general.code" /></th>
            <th><fmt:message key="jsp.general.title" /></th>
            <th><fmt:message key="jsp.general.firstnames" /></th>
            <th><fmt:message key="jsp.general.surname" /></th>
            <th><fmt:message key="jsp.general.birthdate" /></th>
            <th><fmt:message key="jsp.general.primarystudy" /></th>
            <th><fmt:message key="jsp.general.active" /></th>
            <th><fmt:message key="jsp.general.studyplans" /></th>

            <c:forEach var="student" items="${allStudents}">
<%-- 				<c:set var="entityNumber" value="${entityNumber + 1}" scope="page" /> --%>
<%--             	<c:choose> --%>
<%--             		<c:when test="${(entityNumber < (currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" > --%>
	                <tr>
                        <td>${student.studentCode}</td>
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
	                            <c:when test="${
	                               (opusUser.personId == student.personId
	                                   || (opusUserRole.role != 'student' 
	                                   && opusUserRole.role != 'guest'))
	                                   && student.studyPlans[0] != null}">
                                    <a href="<c:url value='/fee/paymentsstudent.view?tab=0&panel=0&from=payments_students&studentId=${student.studentId}&currentPageNumber=${currentPageNumber}'/>">
                                      		${student.surnameFull}
                                   	</a>
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
	                        <c:choose>
	                            <c:when test="${student.active == 'Y'}">
	                                <fmt:message key="jsp.general.yes" />
	                            </c:when>
	                            <c:otherwise>
	                                <fmt:message key="jsp.general.no" />
	                            </c:otherwise>
	                        </c:choose>
	                    </td>
		                    <td class="buttonsCell">
		                    	<c:choose>
			                    	<c:when test="${(
			                    		opusUserRole.role != 'teacher'
		                            	&& opusUserRole.role != 'student' 
	                   					&& opusUserRole.role != 'guest'
	           							&& student.studyPlans[0] != null)}">
										  <a href="<c:url value='/fee/paymentsstudent.view?tab=0&panel=0&from=payments_students&studentId=${student.studentId}&currentPageNumber=${currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
			                    	</c:when>
		                    	</c:choose>       
		                    </td>
	                </tr>
<%-- 	            	</c:when> --%>
<%-- 	            </c:choose> --%>
            </c:forEach>
        </table>
		<script type="text/javascript">alternate('TblData',true)</script>

        <%@ include file="../../includes/pagingFooter.jsp"%>
    
        <br /><br />
    </div>

</div>

<%@ include file="../../footer.jsp"%>
