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
			<form:form method="get" modelAttribute="roomsForm">
                <input type="hidden" name="newForm" value="true" />
				<fieldset>
					<legend>
						<fmt:message key="jsp.accommodation.roomDetailsOverview" />
					</legend>
					<table>
						<tr>
							<td><fmt:message key="jsp.accommodation.hostelType" /></td>
							<td><form:select path="hostelTypeCode" onchange="form.submit()">
									<option value="0">
										<fmt:message key="jsp.accommodation.chooseOption" />
									</option>
									<c:forEach items="${roomsForm.allHostelTypes}" var="hostelType">
                                        <form:option value="${hostelType.code}"><c:out value='${hostelType.description}' /></form:option>
									</c:forEach>
							</form:select></td>
						</tr>
						<tr>
							<td><fmt:message key="jsp.accommodation.hostel" /></td>
							<td><form:select path="hostelId" onchange="form.submit()">
									<option value="0">
										<fmt:message key="jsp.accommodation.chooseOption" />
									</option>
									<c:forEach items="${roomsForm.allHostels}" var="hostel">
                                        <form:option value="${hostel.id}"><c:out value='${hostel.code} ${hostel.description}' /></form:option>
									</c:forEach>
							</form:select></td>
						</tr>

						<%--Check if the institution uses the block. If yes then display the block --%>
						<c:if test="${roomsForm.useHostelBlock}">
							<tr>
								<td><fmt:message key="jsp.accommodation.block" /></td>
								<td><form:select path="hostelBlockId" onchange="form.submit()">
										<option value="0">
											<fmt:message key="jsp.accommodation.chooseOption" />
										</option>
										<c:forEach items="${roomsForm.allHostelBlocks}" var="block">
                                            <form:option value="${block.id}"><c:out value='${block.code} ${block.description}' /></form:option>
										</c:forEach>
								</form:select></td>
							</tr>
						</c:if>
                        <tr>
                            <td><fmt:message key="jsp.accommodation.roomtype" /></td>
                            <td><form:select path="roomTypeCode" onchange="form.submit()">
                                    <option value="0">
                                        <fmt:message key="jsp.accommodation.chooseOption" />
                                    </option>
                                    <c:forEach items="${roomsForm.allRoomTypes}" var="roomType">
                                        <form:option value="${roomType.code}"><c:out value='${roomType.description}' /></form:option>
                                    </c:forEach>
                            </form:select></td>
                        </tr>
					</table>
				</fieldset>

                <p><form:errors path="" cssClass="errorwide"/></p>
            </form:form>


			<c:set var="allEntities" value="${roomsForm.allRooms}" scope="page" />
			<c:set var="redirView" value="rooms" scope="page" />
			<c:set var="entityNumber" value="0" scope="page" />

            <sec:authorize access="hasRole('CREATE_ACCOMMODATION_DATA')">
            <p align="right">
                <a class="button" href="<c:url value='room.view?newForm=true' />">
                    <fmt:message key="jsp.href.add" /></a>
                </p>
            </sec:authorize>

            <%@ include file="../../includes/pagingHeader.jsp"%>
			<c:set var="rowCount" value="0" />
            <table id="tblListRooms" class="tabledata">
                <tr>
					<th><fmt:message key="jsp.accommodation.number" /></th>
					<th><fmt:message key="jsp.accommodation.code" /></th>
					<th><fmt:message key="jsp.accommodation.description" /></th>
                    <th><fmt:message key="jsp.accommodation.roomtype" /></th>
					<th><fmt:message key="jsp.accommodation.hostel" /></th>

					<%--Check if the institution uses the block. If yes then display the block --%>
					<c:if test="${roomsForm.useHostelBlock}">
						<th><fmt:message key="jsp.accommodation.block" /></th>
					</c:if>
					<th><fmt:message key="jsp.accommodation.floorNumber" /></th>
					<th><fmt:message key="jsp.accommodation.numberOfBedSpaces" /></th>
					<th><fmt:message key="jsp.accommodation.availableBedSpace" /></th>
					<th><fmt:message key="jsp.accommodation.active" /></th>
					<th>&nbsp;</th>
				</tr>
				<c:forEach items="${roomsForm.allRooms}" var="room">
					<c:set var="rowCount" value="${rowCount+1 }" />
					<tr>
						<td><c:out value='${rowCount }' /></td>
						<td><c:out value='${room.code }' /></td>
						<td><c:out value='${room.description }' /></td>
                        <td><c:out value='${roomsForm.codeToRoomTypeMap[room.roomTypeCode].description}' /></td>
						<td><c:out value='${room.hostel.code} ${room.hostel.description }' /></td>
						<%--Check if the institution uses the block. If yes then display the block --%>
						<c:if test="${roomsForm.useHostelBlock}">
							<td><c:out value='${room.block.code} ${room.block.description }' /></td>
						</c:if>
						<td><c:out value='${room.floorNumber }' /></td>
						<td><c:out value='${room.numberOfBedSpaces }' /></td>
						<td><c:out value='${room.availableBedSpace }' /></td>
						<td>
                            <c:choose>
								<c:when test="${room.active=='Y' }">
									<fmt:message key="jsp.general.yes" />
								</c:when>
								<c:otherwise>
									<fmt:message key="jsp.general.no" />
								</c:otherwise>
							</c:choose>
                        </td>
						<td class="buttonsCell">
							<sec:authorize access="hasRole('UPDATE_ACCOMMODATION_DATA')">
								<a
									href="<c:url value='room.view'/>?<c:out value='newForm=true&roomId=${room.id}&fromView=roomsOverview' />"><img
									src="<c:url value='/images/edit.gif' />"
									alt="<fmt:message key="jsp.href.edit" />"
									title="<fmt:message key="jsp.href.edit" />" /></a>
							</sec:authorize>
							<sec:authorize access="hasRole('DELETE_ACCOMMODATION_DATA')">
								<a
									href="<c:url value='rooms.view'/>?<c:out value='delete=true&roomId=${room.id}&fromView=roomsOverview' />"
									onclick="return confirm('Are you sure you want to delete this record?')"><img
									src="<c:url value='/images/delete.gif' />"
									alt="<fmt:message key="jsp.href.delete" />"
									title="<fmt:message key="jsp.href.delete" />" /></a>
							</sec:authorize>
                        </td>
					</tr>
				</c:forEach>
			</table>
			<script type="text/javascript">
				alternate('tblListRooms', true);
			</script>

			<%@ include file="../../includes/pagingFooter.jsp"%>
			<br /> <br />
		</div>
	</div>

	<%@ include file="../../footer.jsp"%>