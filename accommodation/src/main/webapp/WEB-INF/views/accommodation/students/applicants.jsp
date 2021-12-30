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

The Original Code is Opus-College accommodation module code.

The Initial Developer of the Original Code is
Computer Centre, Copperbelt University, Zambia.
Portions created by the Initial Developer are Copyright (C) 2012
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
<%@ include file="../../header.jsp"%>

<body>
	<div id="tabwrapper">
		<%@ include file="../../menu.jsp"%>
		<div id="tabcontent">
			<form:form method="post" action="applicants.view"
				commandName="accommodationApplicantsForm"
				name="mainForm"
				id="mainForm">
				<input type="hidden" value="<c:out value="${param.preferredLanguage}" />"
					name="preferredLanguage" />
				<fieldset>
					<legend>
						<fmt:message key="jsp.accommodation.applicantsOverview" />
					</legend>

					<%@ include file="../../includes/applicantsFiltersTable.jsp" %>
					
					 <table align="right">
                		<tr>
                    		<td style="vertical-align:middle;" width="80" align="center">
                    			<fmt:message key="jsp.general.search"/>:
                    		</td>
                    		<td>
                            	<input name="searchValue" id="searchValue" size="20" maxlength="40" type="text" value="<c:out value="${searchValue}" />" />&nbsp;
                            	<input type="image"  src="<c:url value='/images/search.gif' />" />
                    		</td>
                		</tr>
            		</table>

				</fieldset>
			</form:form>
			<c:choose>
				<c:when test="${not empty accommodationApplicantsForm.applicants}">
					<c:set var="allEntities" value="${accommodationApplicantsForm.applicants}" scope="page" />
					<c:set var="redirView" value="studentAccommodation" scope="page" />
					<c:set var="entityNumber" value="0" scope="page" />

					<%@ include file="../../includes/pagingHeader.jsp"%>
					
					<table id="tblListStudentAccommodation" class="tabledata">
						<tr>
							<th><fmt:message key="jsp.accommodation.number" /></th>
							<th><fmt:message key="jsp.accommodation.studentCode" /></th>
							<th><fmt:message key="jsp.accommodation.firstName" /></th>
							<th><fmt:message key="jsp.accommodation.lastName" /></th>
							<th><fmt:message key="jsp.accommodation.dateApplied" /></th>
							<th><fmt:message key="jsp.accommodation.approved" /></th>
							<th><fmt:message key="jsp.accommodation.dateApproved" /></th>
							<th><fmt:message key="jsp.accommodation.academicYear" /></th>
							<th><fmt:message key="jsp.accommodation.room" /></th>
							<sec:authorize access="hasAnyRole('ALLOCATE_ROOM')">
								<th>&nbsp;</th>
							</sec:authorize>
						</tr>
						<c:forEach items="${accommodationApplicantsForm.applicants}" var="studentAccommodation" varStatus="rowNumber">
							<tr>
								<td><c:out value='${rowNumber.index + 1}' /></td>
								<td><c:out value='${studentAccommodation.student.studentCode }' /></td>
								<td><c:out value='${studentAccommodation.student.firstnamesFull }' /></td>
								<td><c:out value='${studentAccommodation.student.surnameFull }' /></td>
								<td><fmt:formatDate
										value="${studentAccommodation.dateApplied }" type="date" /></td>
								<td style="text-align: center"><c:choose>
										<c:when test="${studentAccommodation.approved=='Y'}">
											<fmt:message key="jsp.general.yes" />
										</c:when>
										<c:otherwise>
											<fmt:message key="jsp.general.no" />
										</c:otherwise>
									</c:choose></td>
								<td><fmt:formatDate
										value="${studentAccommodation.dateApproved }" type="date" /></td>
								<td><c:out value='${studentAccommodation.academicYear.description }' /></td>
								<td><c:out value='${studentAccommodation.room.description }' /></td>
								<sec:authorize access="hasRole('ALLOCATE_ROOM')">
									<td><c:if test="${studentAccommodation.allocated=='N'}">
										  <a href="<c:url value='roomallocation.view'/>?<c:out value='newForm=true&studentAccommodationId=${studentAccommodation.id}&preferredLanguage=${param.preferredLanguage}' />">Allocate</a>
										</c:if></td>
								</sec:authorize>
							</tr>
						</c:forEach>
					</table>
					<script type="text/javascript">
						alternate('tblListStudentAccommodation', true);
					</script>
					<%@ include file="../../includes/pagingFooter.jsp"%>
				</c:when>
				<c:otherwise>
					<div class="error">
						<fmt:message key="jsp.accommodation.noRecordsFound" />
					</div>
				</c:otherwise>
			</c:choose>
			<br /> <br />
		</div>
	</div>
	<%@ include file="../../footer.jsp"%>