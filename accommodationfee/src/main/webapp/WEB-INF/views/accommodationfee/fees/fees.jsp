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
			<form:form method="get" modelAttribute="accommodationFeesForm">
                <input type="hidden" name="newForm" value="true" />
				<fieldset>
					<legend>
						<fmt:message key="jsp.accommodation.accommodationFeeOverview" />
					</legend>
					<c:set var="rowCount" value="0" />
					<table>
						<tr>
							<td><fmt:message key="jsp.accommodation.hostelType" /></td>
                            <td><form:select path="hostelTypeCode" onchange="form.submit()">
                                    <option value="0">
                                        <fmt:message key="jsp.accommodation.chooseOption" />
                                    </option>
                                    <c:forEach var="hostelType" items="${accommodationFeesForm.allHostelTypes}" >
                                        <form:option value="${hostelType.code}"><c:out value='${hostelType.description}'/></form:option>
									</c:forEach>
							</form:select></td>
						</tr>
						<tr>
							<td><fmt:message key="jsp.accommodation.roomtype" /></td>
                            <td><form:select path="roomTypeCode" onchange="form.submit()">
                                    <option value="0">
                                        <fmt:message key="jsp.accommodation.chooseOption" />
                                    </option>
                                    <c:forEach var="roomType" items="${accommodationFeesForm.allRoomTypes}" >
                                        <form:option value="${roomType.code}"><c:out value='${roomType.description}'/></form:option>
                                    </c:forEach>
                            </form:select></td>
						</tr>
                        <tr>
                            <td><fmt:message key="jsp.accommodation.academicYear" /></td>
                            <td><form:select path="academicYearId" onchange="form.submit()">
                                    <option value="0">
                                        <fmt:message key="jsp.accommodation.chooseOption" />
                                    </option>
                                    <c:forEach var="academicYear" items="${accommodationFeesForm.allAcademicYears}" >
                                        <form:option value="${academicYear.id}"><c:out value='${academicYear.description}'/></form:option>
                                    </c:forEach>
                            </form:select></td>
                        </tr>
					</table>
				</fieldset>
                <p><form:errors path="" cssClass="errorwide"/></p>
			</form:form>

			<c:set var="allEntities" value="${accommodationFeesForm.allAccommodationFees}" scope="page" />
			<c:set var="redirView" value="accommodationFees" scope="page" />
			<c:set var="entityNumber" value="0" scope="page" />
			
			<sec:authorize access="hasRole('CREATE_ACCOMMODATION_DATA')">
                <p align="right">
                 <a class="button" href="fee.view?newForm=true&fromView=fees.view">
                    <fmt:message key="jsp.href.add" /></a>
                </p>
            </sec:authorize>

            <%@ include file="../../includes/pagingHeader.jsp"%>

			<c:set var="rowCount" value="0" />
			<table id="tblListRoomCharges" class="tabledata">
                
                
				<tr>
					<th></th>
					<th><fmt:message key="jsp.accommodation.hostelType" /></th>
                    <th><fmt:message key="jsp.accommodation.roomtype" /></th>
					<th><fmt:message key="jsp.accommodation.academicYear" /></th>
					<th><fmt:message key="jsp.accommodation.amount" /></th>
                    <th><fmt:message key="jsp.accommodation.feeunit" /></th>
					<th><fmt:message key="general.deadlines" /></th>
					<th><fmt:message key="jsp.accommodation.numberOfInstallments" /></th>
					<th><fmt:message key="jsp.accommodation.active" /></th>
					<th>&nbsp;</th>
				</tr>
				<c:forEach var="accommodationFee" items="${accommodationFeesForm.allAccommodationFees}" varStatus="row">
					<tr>
						<td style="text-align:center"><c:out value='${row.index + 1}'/></td>
						<td><c:out value='${accommodationFeesForm.codeToHostelTypeMap[accommodationFee.hostelTypeCode].description}'/></td>
                        <td><c:out value='${accommodationFeesForm.codeToRoomTypeMap[accommodationFee.roomTypeCode].description}'/></td>
						<td style="text-align:center"><c:out value='${accommodationFeesForm.idToAcademicYearMap[accommodationFee.academicYearId].description}'/></td>
						<td style="text-align:center"><c:out value='${accommodationFee.feeDue }'/></td>
                        <td><c:out value='${accommodationFeesForm.codeToFeeUnitMap[accommodationFee.feeUnitCode].description }'/></td>
						<td style="text-align: center">
                        <c:forEach items="${accommodationFee.deadlines}" var="feeDeadline">
						  <c:choose>
                              <c:when test="${not empty feeDeadline.deadline && (feeDeadline.deadline < currentDate)}">
                                        <span style="color:#bf1616;">
                                        	<fmt:formatDate pattern="dd/MM/yyyy" value="${feeDeadline.deadline}" />
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                    <span style="color:#036f43;">
                                    	<fmt:formatDate pattern="dd/MM/yyyy" value="${feeDeadline.deadline}" />
                                    </span> 
                                    </c:otherwise>
                          </c:choose>
                             	<br/>
                       </c:forEach> 
                    </td>
						<td style="text-align: center"><c:out value='${accommodationFee.numberOfInstallments }'/></td>
						<td style="text-align: center">
                      		<c:choose>
                    			<c:when test="${'Y' == accommodationFee.active}">
                        			<fmt:message key="jsp.general.yes" />
                    			</c:when>
                    			<c:when test="${'N' == accommodationFee.active}">
                        			<fmt:message key="jsp.general.no" />
                    			</c:when>
                   			</c:choose>
                    	</td>
						<td class="buttonsCell" style="text-align:center">
							<sec:authorize access="hasRole('UPDATE_ACCOMMODATION_DATA')">
								<a
									href="<c:url value='fee.view?newForm=true&accommodationFeeId=${accommodationFee.accommodationFeeId}&fromView=fees.view'/>"><img
									src="<c:url value='/images/edit.gif' />"
									alt="<fmt:message key="jsp.href.edit" />"
									title="<fmt:message key="jsp.href.edit" />" /></a>
							</sec:authorize>
							<sec:authorize access="hasRole('DELETE_ACCOMMODATION_DATA')">
								<a
									href="<c:url value='?delete=true&accommodationFeeId=${accommodationFee.accommodationFeeId}&fromView=fees.view'/>"
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
				alternate('tblListRoomCharges', true)
			</script>
			<%@ include file="../../includes/pagingFooter.jsp"%>
			<br /> <br />
		</div>
	</div>

	<%@ include file="../../footer.jsp"%>