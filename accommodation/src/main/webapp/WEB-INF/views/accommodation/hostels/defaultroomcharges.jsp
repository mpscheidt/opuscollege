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
Computer Center, Copperbelt University, Zambia
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

			<c:choose>
				<c:when test="${param.task!='overview' }">
					<%-- Check it the request is coming from the overview page. If true then display 'back to overview' message and the name of the hostelType --%>
					<c:if test="${! empty param.fromView }">
						<fieldset>
							<legend>
								<a
									href="<c:url value='defaultroomcharges.view'/>?<c:out value='task=overview&preferredLanguage=${param.preferredLanguage}' />"><fmt:message
										key="jsp.general.backtooverview" /></a> &gt;
								<c:out value='${jsp.accommodation.defaultRoomChages}'/>
							</legend>
						</fieldset>
					</c:if>
					<%--Display Error Message at this point --%>
					<c:if test="${! empty param.error or !empty error}">
						<div class="error">
							<p>
								<fmt:message key="${accommodationForm.txtErr}" />
							</p>
						</div>
					</c:if>

					<form:form method="post" action="defaultroomcharges.view"
						commandName="accommodationForm">
						<input type="hidden" value="<c:out value="${param.preferredLanguage}" />"
							name="preferredLanguage" />
						<fieldset>
							<legend>
								<fmt:message key="jsp.accommodation.defaultRoomCharges" />
							</legend>
							<table>
								<tr>
									<td><fmt:message key="jsp.accommodation.hostel" /></td>
									<td><form:select path="accommodationFee.hostel.id">
											<form:option value="0">
												<fmt:message key="jsp.accommodation.chooseOption" />
											</form:option>
											<form:options items="${allHostels}" itemValue="id"
												itemLabel="description" />

										</form:select></td>
								</tr>
								<tr>
									<td><fmt:message key="jsp.accommodation.block" /></td>
									<td><form:select path="accommodationFee.block.id">
											<form:option value="0">
												<fmt:message key="jsp.accommodation.chooseOption" />
											</form:option>
											<form:options items="${allBlocks}" itemValue="id"
												itemLabel="description" />
										</form:select></td>
								</tr>
								<tr>
									<td><fmt:message key="jsp.accommodation.academicYear" /></td>
									<td><form:select path="accommodationFee.academicYear.id">
											<form:option value="0">
												<fmt:message key="jsp.accommodation.chooseOption" />
											</form:option>
											<form:options items="${allAcademicYears}" itemValue="id"
												itemLabel="description" />

										</form:select></td>
								</tr>
								<tr>
									<td><fmt:message key="jsp.accommodation.amount" /></td>
									<td><form:input path="accommodationFee.amountDue" /></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>
                                        <input type="submit" value="<fmt:message key="jsp.accommodation.save" />" name="save" />
                                        <input type="reset" value="<fmt:message key="jsp.accommodation.reset" />" name="reset" />
                                    </td>
								</tr>
							</table>
							<c:if test="${param.task== 'edit' }">
								<input type="hidden" value="edit" name="task" />
								<form:hidden path="accommodationFee.id" />
							</c:if>
						</fieldset>
					</form:form>
				</c:when>

				<c:otherwise>
					<form method="get" action="defaultroomcharges.view">
						<input type="hidden" value="<c:out value="${param.preferredLanguage}" />"
							name="preferredLanguage" />
						<fieldset>
							<legend>
								<fmt:message key="jsp.accommodation.defaultRoomChargesOverview" />
							</legend>
							<c:set var="rowCount" value="0" />
							<table>
								<tr>
									<td><fmt:message key="jsp.accommodation.hostel" /></td>
									<td><select name="hostelId" id="hostelId"
										onchange="form.submit()">
											<option value="0">
												<fmt:message key="jsp.accommodation.chooseOption" />
											</option>
											<c:forEach items="${allHostels}" var="hostel">
												<c:if test="${param.hostelId == hostel.id }">
													<option value="<c:out value='${hostel.id }' />" selected="selected"><c:out value='${hostel.description}' /> </option>
												</c:if>
												<c:if test="${param.hostelId != hostel.id }">
													<option value="<c:out value='${hostel.id }' />"><c:out value='${hostel.description}' /> </option>
												</c:if>
											</c:forEach>
									</select></td>
								</tr>

								<tr>
									<td><fmt:message key="jsp.accommodation.academicYear" /></td>
									<td><select name="academicYearId" id="academicYearId"
										onchange="form.submit()">
											<option value="0">
												<fmt:message key="jsp.accommodation.chooseOption" />
											</option>
											<c:forEach items="${allAcademicYears}" var="academicYear">
												<c:if test="${param.academicYearId == academicYear.id }">
													<option value="<c:out value='${academicYear.id }' />" selected="selected"><c:out value='${academicYear.description}' /></option>
												</c:if>
												<c:if test="${param.academicYearId != academicYear.id }">
													<option value="<c:out value='${academicYear.id }' />"><c:out value='${academicYear.description}' /></option>
												</c:if>
											</c:forEach>
									</select></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td></td>
								</tr>
							</table>
						</fieldset>
						<input type="hidden" name="task" value="overview" />
					</form>
					<c:set var="allEntities" value="${allAccommodationFees}"
						scope="page" />
					<c:set var="redirView" value="defaultroomcharges" scope="page" />
					<c:set var="entityNumber" value="0" scope="page" />

					<%@ include file="../../includes/pagingHeader.jsp"%>
					<c:set var="rowCount" value="0" />
					<table id="tblListDefaultRoomCharges" class="tableData">

						<tr>
							<th><fmt:message key="jsp.accommodation.number" /></th>
							<th><fmt:message key="jsp.accommodation.hostel" /></th>
							<th><fmt:message key="jsp.accommodation.block" /></th>
							<th><fmt:message key="jsp.accommodation.academicYear" /></th>
							<th><fmt:message key="jsp.accommodation.amount" /></th>
							<sec:authorize
								access="hasAnyRole('CREATE_ACCOMMODATION_DATA','UPDATE_ACCOMMODATION_DATA','DELETE_ACCOMMODATION_DATA')">
								<th>&nbsp;</th>
							</sec:authorize>
						</tr>
						<c:forEach items="${allAccommodationFees}" var="accommodationFee">
							<c:set var="rowCount" value="${rowCount + 1 }" />
							<tr>
								<td><c:out value='${rowCount }'/></td>
								<td><c:out value='${accommodationFee.hostel.description }' /></td>
								<td><c:out value='${accommodationFee.block.description }' /></td>
								<td><c:out value='${accommodationFee.academicYear.description }' /></td>
								<td><c:out value='${accommodationFee.amountDue }' /></td>
								<sec:authorize
									access="hasAnyRole('CREATE_ACCOMMODATION_DATA','UPDATE_ACCOMMODATION_DATA','DELETE_ACCOMMODATION_DATA')">
									<td class="buttonsCell">
										<sec:authorize access="hasRole('CREATE_ACCOMMODATION_DATA')">
											<a
												href="<c:url value='defaultroomcharges.view'/>?<c:out value='task=add&fromView=defaultRoomChargesOverview&preferredLanguage=${param.preferredLanguage}' />"><img
												src="<c:url value='/images/add.gif' />"
												alt="<fmt:message key="jsp.href.add" />"
												title="<fmt:message key="jsp.href.add" />" /></a>
										</sec:authorize>
										<sec:authorize access="hasRole('UPDATE_ACCOMMODATION_DATA')">
											<a
												href="<c:url value='defaultroomcharges.view'/>?<c:out value='task=edit&accommodationFeeId=${accommodationFee.id}&fromView=defaultRoomChargesOverview&preferredLanguage=${param.preferredLanguage}' />"><img
												src="<c:url value='/images/edit.gif' />"
												alt="<fmt:message key="jsp.href.edit" />"
												title="<fmt:message key="jsp.href.edit" />" /></a>
										</sec:authorize>
										<sec:authorize access="hasRole('DELETE_ACCOMMODATION_DATA')">
											<a
												href="<c:url value='defaultroomcharges.view'/>?<c:out value='task=delete&accommodationFeeId=${accommodationFee.id}&fromView=defaultRoomChargesOverview&preferredLanguage=${param.preferredLanguage}' />"
												onclick="return confirm('Are you sure you want to delete this record?')"><img
												src="<c:url value='/images/delete.gif' />"
												alt="<fmt:message key="jsp.href.delete" />"
												title="<fmt:message key="jsp.href.delete" />" /></a>
										</sec:authorize>
                                    </td>
								</sec:authorize>
							</tr>
						</c:forEach>
					</table>

					<script type="text/javascript">
						alternate('tblListDefaultRoomCharges', true)
					</script>
					<%@ include file="../../includes/pagingFooter.jsp"%>
					<br />
					<br />
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<%@ include file="../../footer.jsp"%>