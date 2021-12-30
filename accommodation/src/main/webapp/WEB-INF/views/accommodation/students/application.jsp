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
			<div class="msg">
				<fmt:message key="jsp.accommodation.dontForget" /> <a href="<c:out value='${pageContext.request.contextPath}/college/student/personal.view?newForm=true&from=application&tab=0&panel=0&studentId=${accommodationStudentsForm.student.studentId}&searchValue=&currentPageNumber=1' />"><fmt:message key="jsp.accommodation.personalDetails" /></a> <fmt:message key="jsp.accommodation.underMiscellaneousSection" />
			</div>
			<c:if test="${!empty error }">
				<div class="error">
					<fmt:message key="${error}" />
				</div>
			</c:if>
			<c:choose>

				<c:when
					test="${(empty( param.task)) || (param.task=='application')}">
					<form:form method="post" commandName="accommodationStudentsForm">
					   <input type="hidden" value="<c:out value="${param.preferredLanguage}" />" name="preferredLanguage" />
						<fieldset>
							<legend>
								<fmt:message key="jsp.accommodation.accommodationApplication" />
							</legend>
							<table>
								<tr>
									<td><fmt:message key="jsp.accommodation.studentCode" /></td>
									<td><c:out value='${accommodationStudentsForm.student.studentCode}' /></td>
								</tr>
								<tr>
									<td><fmt:message key="jsp.accommodation.firstName" /></td>
									<td><c:out value='${accommodationStudentsForm.student.firstnamesFull }' /></td>
								</tr>
								<tr>
									<td><fmt:message key="jsp.accommodation.lastName" /></td>
									<td><c:out value='${accommodationStudentsForm.student.surnameFull}' /></td>
								</tr>
								<tr>
									<td><fmt:message key="jsp.accommodation.otherNames" /></td>
									<td><c:out value='${accommodationStudentsForm.student.firstnamesAlias }' /></td>
								</tr>
								<tr>
									<td><fmt:message key="jsp.accommodation.primaryStudy" /></td>
									<td><c:out value='${accommodationStudentsForm.study.studyDescription }' /></td>
								</tr>
								<tr>
									<td><fmt:message key="jsp.accommodation.academicYear" /></td>
									<td class="required"><form:select path="academicYear.id">
											<form:option value="0">
												<fmt:message key="jsp.accommodation.chooseOption" />
											</form:option>
											<form:options items="${allAcademicYears }"
												itemLabel="description" itemValue="id" />

										</form:select></td>
								</tr>
								<tr>
									<td><fmt:message
											key="jsp.accommodation.reasonForApplyingForAccommodation" /></td>
									<td class="required"><form:textarea
											path="reasonForApplyingForAccommodation" rows="6" cols="40"></form:textarea></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>
                                        <input type="submit" value="<fmt:message key="jsp.accommodation.save" />" name="save" />
                                        <input type="reset" value="<fmt:message key="jsp.accommodation.reset" />" name="reset" />
                                    </td>
								</tr>
							</table>
						</fieldset>
					</form:form>
				</c:when>
				<c:when test="${param.task eq 'overview' }">
					<c:if test="${empty studentAccommodations}">
					<fmt:message key="jsp.accommodation.noApplication1" /> <a
							href="<c:url value='application.view'/>?<c:out value='task=application&preferredLanguage=${param.preferredLanguage}' />"><fmt:message key="jsp.accommodation.here" /></a> <fmt:message key="jsp.accommodation.noApplication2" />
					</c:if>
					<c:if test="${! empty studentAccommodations}">
						<h3 class="heading"><fmt:message key="jsp.accommodation.statusOfApplicationForAccommodation" /></h3>
						<c:set var="allEntities" value="${studentAccommodations}"
							scope="page" />
						<c:set var="redirView" value="studentAccommodation" scope="page" />
						<c:set var="entityNumber" value="0" scope="page" />

						<%@ include file="../../includes/pagingHeader.jsp"%>
						<c:set var="rowCount" value="0" />
						<table id="tblListStudentAccommodation" class="tabledata">
							<tr>
								<th><fmt:message key="jsp.accommodation.number" /></th>
								<th><fmt:message key="jsp.accommodation.dateApplied" /></th>
								<th><fmt:message key="jsp.accommodation.academicYear" /></th>
								<th><fmt:message key="jsp.accommodation.approved" /></th>
								<th><fmt:message key="jsp.accommodation.dateApproved" /></th>
								<th><fmt:message key="jsp.accommodation.hostel" /></th>
								<c:if test="${useHostelBlock}">
									<th><fmt:message key="jsp.accommodation.block" /></th>
								</c:if>
								<th><fmt:message key="jsp.accommodation.room" /></th>
							</tr>
							<c:forEach items="${studentAccommodations }"
								var="studentAccommodation">
								<tr>
									<td><c:set var="rowCount" value="${rowCount+1 }" />
										<c:out value='${rowCount}' /></td>
									<td><fmt:formatDate
											value="${studentAccommodation.dateApplied }" type="date" /></td>
									<td><c:out value='${studentAccommodation.academicYear.description }' /></td>
									<td style="text-align: center"><c:choose>
											<c:when test="${studentAccommodation.approved == 'Y' }">
												<fmt:message key="jsp.general.yes" />
											</c:when>
											<c:otherwise>
												<fmt:message key="jsp.general.no" />
											</c:otherwise>
										</c:choose></td>
									<td><fmt:formatDate
											value="${studentAccommodation.dateApproved }" type="date" /></td>
									<td><c:out value='${studentAccommodation.room.hostel.description }' /></td>
									<c:if test="${useHostelBlock}">
										<td><c:out value='${studentAccommodation.room.block.description }' /></td>
									</c:if>
									<td><c:out value='${studentAccommodation.room.description }' /></td>
								</tr>
							</c:forEach>
						</table>
						<script type="text/javascript">
							alternate('tblListStudentAccommodation', true);
						</script>
						<%@ include file="../../includes/pagingFooter.jsp"%>
					</c:if>
					<br />
					<br />
				</c:when>
			</c:choose>
		</div>
	</div>
	<%@ include file="../../footer.jsp"%>