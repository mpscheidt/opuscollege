<%@ include file="../../header.jsp"%>

<body>
	<div id="tabwrapper">
		<%@ include file="../../menu.jsp"%>
		<div id="tabcontent">
			<form:form method="get" modelAttribute="hostelBlocksForm">
				<fieldset>
					<legend>
						<fmt:message key="jsp.accommodation.blockOverview" />
					</legend>
					<input type="hidden" name="newForm" value="true" />
					<table>
						<tr>
							<td><fmt:message key="jsp.accommodation.hostelType" /></td>
							<td>
                                <form:select path="hostelTypeCode" onchange="form.submit()">
									<option value="0">
										<fmt:message key="jsp.accommodation.chooseOption" />
									</option>
									<c:forEach var="hostelType" items="${hostelBlocksForm.allHostelTypes}">
                                        <form:option value="${hostelType.code}"><c:out value='${hostelType.description}' /></form:option>
<%--										<c:if test="${param.hostelTypeCode== hostelType.code}">
											<option value="${hostelType.code }" selected="selected">${hostelType.description}</option>
										</c:if>
										<c:if test="${param.hostelTypeCode != hostelType.code}">
											<option value="${hostelType.code }">${hostelType.description}</option>
										</c:if> --%>
									</c:forEach>
                                </form:select>
                            </td>
						</tr>
						<tr>
							<td><fmt:message key="jsp.accommodation.hostel" /></td>
							<td>
                                <form:select path="hostelId" onchange="form.submit()">
									<option value="0">
										<fmt:message key="jsp.accommodation.chooseOption" />
									</option>
									<c:forEach items="${hostelBlocksForm.allHostels}" var="hostel">
                                        <form:option value="${hostel.id}"><c:out value='${hostel.code} ${hostel.description}' /></form:option>
									</c:forEach>
                                </form:select>
                            </td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td></td>
						</tr>
					</table>
				</fieldset>

                <p><form:errors path="" cssClass="errorwide"/></p>

			</form:form>

			<c:set var="allEntities" value="${hostelBlocksForm.allHostelBlocks}" scope="page" />
			<c:set var="redirView" value="blocks" scope="page" />
			<c:set var="entityNumber" value="0" scope="page" />
            
            <sec:authorize access="hasRole('CREATE_ACCOMMODATION_DATA')">
                <p align="right">    
                    <a class="button" href="<c:url value='hostelBlock.view?newForm=true&fromView=blockOverview'/>' />">
                        <fmt:message key="jsp.href.add" />
                    </a>
                </p>
            </sec:authorize>

			<%@ include file="../../includes/pagingHeader.jsp"%>
			<table id="tblListBlocks" class="tabledata">
				<tr>
					<th>&nbsp;</th>
					<th><fmt:message key="jsp.accommodation.code" /></th>
					<th><fmt:message key="jsp.accommodation.description" /></th>
					<th><fmt:message key="jsp.accommodation.hostel" /></th>
					<th><fmt:message key="jsp.accommodation.numberOfFloors" /></th>
					<th><fmt:message key="jsp.accommodation.active" /></th>
					<th class="buttonsCell">&nbsp;</th>
				</tr>
				<c:set var="rowCount" value="0" />

				<c:forEach items="${hostelBlocksForm.allHostelBlocks}" var="block">
					<c:set var="rowCount" value="${rowCount + 1 }" />
					<tr>
						<td><c:out value='${rowCount }' /></td>
						<td><c:out value='${block.code }' /></td>
						<td><c:out value='${block.description }' /></td>
						<td><c:out value='${block.hostel.description}' /></td>
						<td><c:out value='${block.numberOfFloors}' /></td>
						<td>
                            <c:choose>
								<c:when test="${block.active == 'Y'}">
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
									href="<c:url value='hostelBlock.view'/>?<c:out value='newForm=true&hostelBlockId=${block.id}&fromView=blockOverview' />"><img
									src="<c:url value='/images/edit.gif' />"
									alt="<fmt:message key="jsp.href.edit" />"
									title="<fmt:message key="jsp.href.edit" />" /></a>
							</sec:authorize>
							<sec:authorize access="hasRole('DELETE_ACCOMMODATION_DATA')">
								<a
									href="<c:url value='hostelBlocks.view'/>?<c:out value='delete=true&hostelBlockId=${block.id}' />"
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
				alternate('tblListBlocks', true)
			</script>
			<%@ include file="../../includes/pagingFooter.jsp"%>
			<br />
			<br />
		</div>
	</div>

	<%@ include file="../../footer.jsp"%>