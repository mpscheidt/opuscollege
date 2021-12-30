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

<form:form method="post" modelAttribute="roomAllocationForm">

	<input type="hidden" name="task" id="task" value="submitFormObject"/>
	<form:hidden path="studentAccommodation.id"/>
	
	<fieldset>
		<legend>
			<fmt:message key="jsp.accommodation.studentAccommodation" /> &gt; <a href="<c:url value='allocate.view?task=overview' />"><fmt:message key="jsp.accommodation.backToOverview" /></a>
				<c:if test="${! empty param.reallocate }">
				 	<input type="hidden" value="roomId" value="<c:out value="${studentAccommodation.roomId}" />" />
				 	<input type="hidden" value="reallocate" value="true" />
				</c:if>
		</legend>
		&nbsp;
	</fieldset>
	
	<c:if test="${!empty error}">
		<div class="error">
			<p>
                <fmt:message key="${roomAllocationForm.txtErr}">
                    <fmt:param value="${studyGradeType.gradeTypeDescription} - ${studyGradeType.studyDescription}" />
                </fmt:message>
            </p>
		</div>
	</c:if>
	
	<fieldset>
		<legend>
			<fmt:message key="general.student"/>
		</legend>

        <table width="100%">
            <tr>
                <td>
            		<table>
            			<tr>
            				<td><label><fmt:message key="jsp.accommodation.studentNumber" /></label></td>
            				<td><c:out value='${roomAllocationForm.studentAccommodation.student.studentCode }' /> <input
            					type="hidden" value="<c:out value="${param.studentAccommodationId}" />"
            					name="studentAccommodationId" />
            				</td>
            			</tr>
            			<tr>
            				<td><label><fmt:message key="jsp.accommodation.firstName" /></label></td>
            				<td><c:out value='${roomAllocationForm.studentAccommodation.student.firstnamesFull }' /></td>
            			</tr>
            			<tr>
            				<td><label><fmt:message key="jsp.accommodation.otherNames" /></label></td>
            				<td><c:out value='${roomAllocationForm.studentAccommodation.student.firstnamesAlias }' /></td>
            			</tr>
            			<tr>
            				<td><label><fmt:message key="jsp.accommodation.lastName" /></label></td>
            				<td><c:out value='${roomAllocationForm.studentAccommodation.student.surnameFull }' /></td>
            			</tr>
            			<tr>
            				<td><label><fmt:message key="jsp.accommodation.yearOfStudy" /></label></td>
            				<td><c:out value='${cardinalTimeUnit}' /></td>
            			</tr>
            			<tr>
            			  <td><label><fmt:message key="jsp.accommodation.reasonForApplyingForAccommodation" /></label></td>
            			 </tr>
            			 <tr>
            			  <td colspan="4">
            			  		<textarea rows="6" cols="40" readonly="readonly">
										<c:out value='${roomAllocationForm.studentAccommodation.reasonForApplyingForAccommodation}' />            			  			
            			  		</textarea>
            			  </td>
            		   </tr>
            		</table>
                </td>
                <td>
                    <table>
                        <tr>
                            <td>
                                <fmt:message key="jsp.accommodation.studentHistory"/>:
                            </td>
                        </tr>
                        <c:forEach var="studyplanctu" items="${roomAllocationForm.studyPlanCardinalTimeUnits}">
                            <tr>
                                <td>
                                    <c:set var="studyGradeType" value="${roomAllocationForm.idToStudyGradeTypeMap[studyplanctu.studyGradeTypeId]}" />
                                    <c:out value='${studyGradeType.studyDescription} -
                                    ${studyGradeType.gradeTypeDescription},
                                    ${roomAllocationForm.codeToCardinalTimeUnitMap[studyGradeType.cardinalTimeUnitCode].description} 
                                    ${studyplanctu.cardinalTimeUnitNumber}
                                    (${roomAllocationForm.idToAcademicYearMap[studyGradeType.currentAcademicYearId].description})' />
                                </td>
                                <td>
                                    <c:out value='${roomAllocationForm.codeToStudyIntensityMap[studyplanctu.studyIntensityCode].description }' />
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </td>
            </tr>
        </table>
	</fieldset>

	<fieldset>
		<legend>
			<fmt:message key="jsp.accommodation.roomallocation"/>
		</legend>
		
		<table>
			<tr>
				<td><label><fmt:message key="jsp.accommodation.academicYear" /></label></td>
				<td class="required">
					<form:select path="studentAccommodation.academicYear.id">
						<form:option value="0">
							<fmt:message key="jsp.accommodation.chooseOption" />
						</form:option>
						<form:options items="${roomAllocationForm.academicYears}" itemValue="id"
							itemLabel="description" />
					</form:select>
				</td>
				<form:errors path="studentAccommodation.academicYear.id" cssClass="error" element="td"/>
			</tr>
			
			<tr>
				<td><label><fmt:message key="jsp.accommodation.hostel" /></label></td>
				<td class="required">
					<form:select path="studentAccommodation.room.hostel.id" 
								 onchange="this.form.task.value='updateFormObject'; this.form.submit(); ">
						<form:option value="0">
							<fmt:message key="jsp.accommodation.chooseOption" />
						</form:option>
                        <c:forEach var="hostel" items="${roomAllocationForm.hostels}">
                            <form:option value="${hostel.id}"><c:out value='(${hostel.code}) ${hostel.description}' /></form:option>
                        </c:forEach>
					</form:select>
				</td>
				<form:errors path="studentAccommodation.room.hostel.id" cssClass="error" element="td"/>
			</tr>
			<c:if test="${roomAllocationForm.useHostelBlocks}">
				<tr>
					<td><label><fmt:message key="jsp.accommodation.block" /></label></td>
					<td>
						<form:select path="studentAccommodation.room.block.id" 
									 onchange="this.form.task.value='updateFormObject'; this.form.submit(); ">
							<form:option value="0">
								<fmt:message key="jsp.accommodation.chooseOption" />
							</form:option>
                            <c:forEach var="block" items="${roomAllocationForm.blocks}">
                                <form:option value="${block.id}"><c:out value='(${block.code}) ${block.description}' /></form:option>
                            </c:forEach>
						</form:select>
					</td>
					<form:errors path="studentAccommodation.room.block.id" cssClass="error" element="td"/>
				</tr>
			</c:if>
			<tr>
				<td><label><fmt:message key="jsp.accommodation.room" /></label></td>
				<td class="required">
					<form:select path="studentAccommodation.roomId">
						<form:option value="0">
							<fmt:message key="jsp.accommodation.chooseOption" />
						</form:option>
                        <c:forEach var="room" items="${roomAllocationForm.rooms}">
                            <form:option value="${room.id}"><c:out value='(${room.code}) ${room.description}' /></form:option>
                        </c:forEach>
					</form:select>
				</td>
				<form:errors path="studentAccommodation.roomId" cssClass="error" element="td"/>
			</tr>
            <tr>
              <td><label><fmt:message key="jsp.accommodation.approved" /></label></td>
              <td class="required">
                <form:select path="studentAccommodation.approved">
                  <form:option value="N"><fmt:message key="jsp.general.no" /></form:option>
                  <form:option value="Y"><fmt:message key="jsp.general.yes" /></form:option>
              </form:select>
              </td>
              <form:errors path="studentAccommodation.approved" cssClass="error" element="td"/>
            </tr>
			<tr>
				<td colspan="10" align="center">
					<input type="submit" value="<fmt:message key="jsp.accommodation.save" />" name="save" />
				</td>
			</tr>
		</table>
		
	</fieldset>
</form:form>
<br /> <br />
</div>
</div>
<%@ include file="../../footer.jsp"%>