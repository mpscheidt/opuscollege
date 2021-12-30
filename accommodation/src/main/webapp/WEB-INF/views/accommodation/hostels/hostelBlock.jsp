<%@ include file="../../header.jsp"%>

<body>
	<div id="tabwrapper">
		<%@ include file="../../menu.jsp"%>
		<div id="tabcontent">
			<form:form method="post" modelAttribute="hostelBlockForm">
				<%-- Check it the request is coming from the overview page. If true then display 'back to overview' message and the name of the hostelType --%>
				<c:if test="${! empty param.fromView }">
					<fieldset>
						<legend>
							<a href="<c:url value='hostelBlocks.view'/>"><fmt:message key="jsp.general.backtooverview" /></a> &gt;
                            <c:out value=' ${hostelBlockForm.hostelBlock.code} ${hostelBlockForm.hostelBlock.description}' />
						</legend>
					</fieldset>
				</c:if>
				<%--Display Error Message at this point --%>
                <p><form:errors path="" cssClass="error"/></p>

				<fieldset>
					<legend>
						<fmt:message key="jsp.accommodation.block" />
					</legend>
					<table>
						<tr>
							<td><fmt:message key="jsp.accommodation.code" /></td>
							<td class="required"><form:input path="hostelBlock.code" /></td>
                            <td><form:errors path="hostelBlock.code" cssClass="error" /></td>
						</tr>
						<tr>
							<td><fmt:message key="jsp.accommodation.description" /></td>
							<td><form:input path="hostelBlock.description" /></td>
                            <td><form:errors path="hostelBlock.description" cssClass="error" /></td>
						</tr>
						<tr>
							<td><fmt:message key="jsp.accommodation.hostel" /></td>
							<td class="required">
                                <form:select path="hostelBlock.hostel.id">
									<option value="0">
										<fmt:message key="jsp.accommodation.chooseOption" />
									</option>
                                    <c:forEach var="hostel" items="${hostelBlockForm.allHostels}">
										<form:option value="${hostel.id}"><c:out value='${hostel.code} ${hostel.description}' /></form:option>
                                    </c:forEach>
								</form:select>
                            </td>
                            <td><form:errors path="hostelBlock.hostel.id" cssClass="error" /></td>
						</tr>
						<tr>
							<td><fmt:message key="jsp.accommodation.numberOfFloors" /></td>
							<td class="required"><form:select path="hostelBlock.numberOfFloors">
									<form:option value="0" label="None" />
									<c:forEach var="i" begin="1" end="100">
										<form:option value="${i}" />
									</c:forEach>
								</form:select>
                            </td>
                            <td><form:errors path="hostelBlock.numberOfFloors" cssClass="error" /></td>
						</tr>
						<tr>
							<td><fmt:message key="jsp.accommodation.active" /></td>
							<td><form:select path="hostelBlock.active">
									<form:option value="N">
										<spring:message code="jsp.general.no" />
									</form:option>
									<form:option value="Y">
										<spring:message code="jsp.general.yes" />
									</form:option>
								</form:select>
                            </td>
                            <td><form:errors path="hostelBlock.active" cssClass="error" /></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>
                                <input type="submit" name="save" value="<fmt:message key="jsp.accommodation.save" />" />
                                <input type="reset" name="reset" value="<fmt:message key="jsp.accommodation.reset" />" />
                            </td>
						</tr>
					</table>
				</fieldset>
			</form:form>
		</div>
	</div>

	<%@ include file="../../footer.jsp"%>