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
			<form:form method="post" action="deallocateResource.view" commandName="studentAccommodationResourceForm">
				<input type="hidden" value="<c:out value="${param.preferredLanguage}" />"	name="preferredLanguage" />
				<fieldset>
					<legend>
						<fmt:message key="jsp.accommodation.allocateResources" />
					</legend>
					<c:set var="accommodationResource" value="${accommodationResourceMap[studentAccommodationResource.accommodationResourceId]}" />
					<c:set var="disabled" value="" />
					<c:if test="${empty accommodationResource }">
						<c:set var="disabled" value='disabled="disabled"' />
					</c:if>
					
					<form:hidden path="studentAccommodationId" value="${studentAccommodationId }" />
					<table>
						<tr>
							<td><fmt:message key="jsp.accommodation.studentCode" /></td>
							<td><c:out value='${student.studentCode}' /></td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><fmt:message key="jsp.accommodation.name" /></td>
							<td><c:out value='${student.firstnamesFull} ${student.firstnamesAlias} ${student.surnameAlias} ${student.surnameFull}' /></td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><fmt:message key="jsp.accommodation.study" /></td>
							<td><c:out value='${study.studyDescription}' /></td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><fmt:message key="jsp.accommodation.accommodationResource" /> </td>
							<td><c:out value='${accommodationResource.name}' /><form:hidden path="accommodationResourceId" /></td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><fmt:message key="jsp.accommodation.commentWhenCollecting" /></td>
							<td><c:out value='${studentAccommodationResourceForm.commentWhenCollecting}' /> <form:hidden path="commentWhenCollecting" /></td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><fmt:message key="jsp.accommodation.commentWhenReturning" /></td>
							<td><form:textarea path="commentWhenReturning" /></td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td><input type="submit" value="Save" name="save" <c:out value='${disabled}' /> /></td>
							<td>&nbsp;</td>
						</tr>
						
					</table>
				</fieldset>
			</form:form>
			<c:choose>
				<c:when test="${not empty studentAccommodationResources}">
					<!-- <fieldset>
						<legend>
							<fmt:message key="jsp.accommodation.allocatedResources" />
					</legend>  -->
						<c:set var="allEntities" value="${studentAccommodationResources}" scope="page" />
						<c:set var="redirView" value="allocatedResources" scope="page" />
						<c:set var="entityNumber" value="0" scope="page" />
	
						<%@ include file="../../includes/pagingHeader.jsp"%>
						<c:set var="rowCount" value="0" />
						<table class="tabledata" id="TblData">
						<tr>
							<th><fmt:message key="jsp.accommodation.number" /></th>
							<th><fmt:message key="jsp.accommodation.name" /></th>
							<th><fmt:message key="jsp.accommodation.dateCollected" /></th>
							<th><fmt:message key="jsp.accommodation.commentWhenCollecting" /></th>
							<th><fmt:message key="jsp.accommodation.commentWhenReturning" /></th>
							
							
							<sec:authorize access="hasRole('ALLOCATE_ROOM')">
								<th>&nbsp;</th>
							</sec:authorize>
						</tr>
						<c:forEach items="${studentAccommodationResources}" var="studentAccommodationResource">
							<c:set var="accommodationResource" value="${accommodationResourceMap[studentAccommodationResource.accommodationResourceId]}" />
							
							<tr>
							<td><c:set var="rowCount" value="#{rowCount+1}" /> <c:out value='${rowCount}' /></td>
							<td><c:out value='${accommodationResource.name}' /></td>
							<td><fmt:formatDate type="date" dateStyle="short" value="${studentAccommodationResource.dateCollected}" /></td>
							<td><c:out value='${studentAccommodationResource.commentWhenCollecting}' /></td>
							<td><c:out value='${studentAccommodationResource.commentWhenReturning}' /></td>
						
							<sec:authorize access="hasRole('ALLOCATE_ROOM')">
								<td>
									<c:if test="${empty studentAccommodationResource.dateReturned}">
										<a
										href="<c:url value='allocateResource.view'/>?<c:out value='task=delete&studentAccommodationId=${studentAccommodationResource.studentAccommodationId}&studentAccommodationResourceId=${studentAccommodationResource.id}&fromView=allocateResource' />"
										onclick="return confirm('Are you sure you want to delete this item?')"><img
										src="<c:url value='/images/delete.gif' />"
										alt="<fmt:message key="jsp.href.delete" />"
										title="<fmt:message key="jsp.href.delete" />" /></a>
									</c:if>
									<c:if test="${empty studentAccommodationResource.dateReturned}">
										<a href="<c:url value='deallocateResource.view'/>?<c:out value='task=deallocate&studentAccommodationId=${studentAccommodationResource.studentAccommodationId}&studentAccommodationResourceId=${studentAccommodationResource.id}&fromView=allocateResource' />"><fmt:message key="jsp.accommodation.deallocate" /></a>
									</c:if>
									
									</td>
							</sec:authorize>
							</tr>
						</c:forEach>
						</table>
						<script type="text/javascript">
							alternate('TblData', true)
						</script>
						<%@ include file="../../includes/pagingFooter.jsp"%>
					<!-- </fieldset> -->
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