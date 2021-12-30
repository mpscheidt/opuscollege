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
			<form:form method="post" action="allocate.view"
				commandName="studentsForm">
				<input type="hidden" value="<c:out value="${param.preferredLanguage}" />"
					name="preferredLanguage" />
				<fieldset>
					<legend>
						<fmt:message key="jsp.accommodation.studentsAccommodationOverview" />
					</legend>
					<table>
						<tr>
							<td><fmt:message key="jsp.accommodation.higherEducation" /></td>
							<td><form:select path="institutionId"
									onchange="form.submit()">
									<form:options items="${allInstitutions}"
										itemLabel="institutionDescription" itemValue="id" />
								</form:select></td>
							<td>&nbsp;</td>
							<td><fmt:message key="jsp.accommodation.study" /></td>
							<td><form:select path="studyId" onchange="form.submit()">
									<form:option value="0">
										<fmt:message key="jsp.accommodation.chooseOption" />
									</form:option>
									<form:options items="${allStudies}" itemValue="id"
										itemLabel="studyDescription" />
								</form:select></td>
						</tr>

						<tr>
							<td><fmt:message key="jsp.accommodation.firstLevelUnit" /></td>
							<td><form:select path="firstLevelUnitId"
									onchange="form.submit()">
									<form:option value="0">
										<fmt:message key="jsp.accommodation.chooseOption" />
									</form:option>
									<form:options items="${allFirstLevelUnits}" itemValue="id"
										itemLabel="branchDescription" />
								</form:select></td>
							<td>&nbsp;</td>
							<td><fmt:message key="jsp.accommodation.programmeOfStudy" /></td>
							<td><form:select path="studyGradeTypeId"
									onchange="form.submit()">
									<form:option value="0">
										<fmt:message key="jsp.accommodation.chooseOption" />
									</form:option>
									<c:forEach items="${allStudyGradeTypes}" var="studyGradeType">
										<form:option value="${studyGradeType.id }"><c:out value='${studyGradeType.gradeTypeDescription} - ${studyGradeType.studyDescription } (${mapAcademicYear[studyGradeType.currentAcademicYearId]})' /></form:option>
									</c:forEach>
								</form:select></td>
						</tr>
						<tr>
							<td><fmt:message key="jsp.accommodation.secondLevelUnit" /></td>
							<td><form:select path="secondLevelUnitId"
									onchange="form.submit()">
									<form:option value="0">
										<fmt:message key="jsp.accommodation.chooseOption" />
									</form:option>
									<form:options items="${allSecondLevelUnits}" itemValue="id"
										itemLabel="organizationalUnitDescription" />
								</form:select></td>
							<td>&nbsp;</td>
							<td><fmt:message
									key="jsp.accommodation.cardinalTimeUnitNumber" /></td>
							<td><form:select path="cardinalTimeUnitNumber"
									onchange="form.submit()">
									<form:option value="0">
										<fmt:message key="jsp.accommodation.chooseOption" />
									</form:option>
									<c:forEach begin="1" end="${maxCardinalTimeUnit}"
										var="cardinalTimeUnit">
										<form:option value="${cardinalTimeUnit }"><c:out value='${cardinalTimeUnit}' /></form:option>
									</c:forEach>
								</form:select></td>
						</tr>
						<tr>
							<td><fmt:message key="jsp.accommodation.hostel" /></td>
							<td><form:select path="hostelId" onchange="form.submit()">
									<option value="0">
										<fmt:message key="jsp.accommodation.chooseOption" />
									</option>
									<form:options items="${allHostels}" itemValue="id"
										itemLabel="description" />
								</form:select></td>
							<td>&nbsp;</td>
							<td><fmt:message key="jsp.accommodation.progressStatus" /></td>
							<td><form:select path="progressStatus"
									onchange="form.submit()">
									<form:option value="0">
										<fmt:message key="jsp.accommodation.chooseOption" />
									</form:option>
									<form:option value="FT">
										<fmt:message key="jsp.accommodation.fullTime" />
									</form:option>
									<form:option value="PT">
										<fmt:message key="jsp.accommodation.partTime" />
									</form:option>
								</form:select></td>
						</tr>
						<tr>
							<c:if test="${useHostelBlocks}">
								<td><fmt:message key="jsp.accommodation.block" /></td>
								<td><form:select path="blockId" onchange="form.submit()">
										<form:option value="0">
											<fmt:message key="jsp.accommodation.chooseOption" />
										</form:option>
										<form:options items="${allBlocks}" itemValue="id"
											itemLabel="description" />
									</form:select></td>
							</c:if>
							<c:if test="${!useHostelBlocks}">
								<td><fmt:message key="jsp.accommodation.room" /></td>
								<td><form:select path="roomId" onchange="form.submit()">
										<form:option value="0">
											<fmt:message key="jsp.accommodation.chooseOption" />
										</form:option>
										<form:options items="${allRooms}" itemValue="id"
											itemLabel="description" />
									</form:select></td>
							</c:if>
							<td>&nbsp;</td>
							<td><fmt:message key="jsp.accommodation.academicYear" /></td>
							<td><form:select path="academicYearId"
									onchange="form.submit()">
									<form:option value="0">
										<fmt:message key="jsp.accommodation.chooseOption" />
									</form:option>
									<form:options items="${allAcademicYears}" itemValue="id"
										itemLabel="description" />
								</form:select></td>
						</tr>
						<tr>
							<c:if test="${useHostelBlocks}">
								<td><fmt:message key="jsp.accommodation.room" /></td>
								<td><form:select path="roomId" onchange="form.submit()">
										<form:option value="0">
											<fmt:message key="jsp.accommodation.chooseOption" />
										</form:option>
										<form:options items="${allRooms}" itemValue="id"
											itemLabel="description" />
									</form:select></td>
							</c:if>
							<c:if test="${!useHostelBlocks}">
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</c:if>
							<td>&nbsp;</td>
							<td>Status</td>
							<td><form:select path="status" onchange="form.submit()">
									<form:option value="0">
										<fmt:message key="jsp.accommodation.chooseOption" />
									</form:option>
									<form:option value="applicants">Applied for Accommodation</form:option>
									<form:option value="accommodated">Already Accommodated</form:option>
									<!-- <form:option value="owing">Owing</form:option>  -->
									<!-- <form:option value="paidUp">Paid Up</form:option>  -->
								</form:select></td>
						</tr>
					</table>
				</fieldset>
			</form:form>
			<c:choose>
				<c:when test="${not empty applicants}">
					<c:set var="allEntities" value="${applicants}" scope="page" />
					<c:set var="redirView" value="studentAccommodation" scope="page" />
					<c:set var="entityNumber" value="0" scope="page" />

					<%@ include file="../../includes/pagingHeader.jsp"%>
					<c:set var="rowCount" value="0" />
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
							<sec:authorize access="hasRole('ALLOCATE_ROOM')">
								<th>&nbsp;</th>
							</sec:authorize>
						</tr>
						<c:forEach items="${applicants }" var="studentAccommodation">
							<tr>
								<td><c:set var="rowCount" value="${rowCount+1 }" />
									<c:out value='${rowCount}' /></td>
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
									<td><c:choose>
											<c:when test="${studentAccommodation.allocated=='Y'}">
												<a href="<c:url value='roomallocation.view'/>?<c:out value='newForm=true&studentAccommodationId=${studentAccommodation.id}&task=deallocate&preferredLanguage=${param.preferredLanguage}' />">Deallocate</a>
												<a href="<c:url value='roomallocation.view'/>?<c:out value='newForm=true&studentAccommodationId=${studentAccommodation.id}&reallocate=true&preferredLanguage=${param.preferredLanguage}' />">Reallocate</a>
											</c:when>
											<c:otherwise>
												<a href="<c:url value='roomallocation.view'/>?<c:out value='newForm=true&studentAccommodationId=${studentAccommodation.id}&preferredLanguage=${param.preferredLanguage}' />">Allocate</a>
											</c:otherwise>
										</c:choose></td>
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