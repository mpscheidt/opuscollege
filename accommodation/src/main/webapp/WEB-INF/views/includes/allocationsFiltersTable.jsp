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

The Original Code is Opus-College report module code.

The Initial Developer of the Original Code is
Center for Information Services, Radboud University Nijmegen
and Universidade Catolica de Mocambique.
Portions created by the Initial Developer are Copyright (C) 2008
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

<c:set var="readInstitutions" value="${false}"/>
<sec:authorize access="hasRole('READ_INSTITUTIONS')">
    <c:set var="readInstitutions" value="${true}"/>
</sec:authorize>

<c:set var="readBranches" value="${false}"/>
<sec:authorize access="hasRole('READ_BRANCHES')">
    <c:set var="readBranches" value="${true}"/>
</sec:authorize>


<c:set var="readOrgUnits" value="${false}"/>
<sec:authorize access="hasAnyRole('READ_PRIMARY_AND_CHILD_ORG_UNITS', 'READ_ORG_UNITS')">
    <c:set var="readOrgUnits" value="${true}"/>
</sec:authorize>


<table width="100%">

		<tr>
				<td><label><fmt:message key="jsp.accommodation.hostel" /></label></td>
				<td>
					<select name="hostelId" id="hostelId" 
								 onchange="document.mainForm.submit(); ">
						<option value="0">
							<fmt:message key="jsp.accommodation.chooseOption" />
						</option>
                        <c:forEach var="hostel" items="${allocationsForm.hostels}">
                        	<c:choose>
                        		<c:when test="${hostelId != hostel.id}">
                            		<option value="<c:out value='${hostel.id}' />"><c:out value='(${hostel.code}) ${hostel.description}' /></option>
                            	</c:when>
                            	<c:otherwise>
                            		<option value="<c:out value='${hostel.id}' />" selected="selected"><c:out value='(${hostel.code}) ${hostel.description}' /></option>
                            	</c:otherwise>
                            </c:choose>
                        </c:forEach>
					</select>
				</td>
		</tr>
			<c:if test="${allocationsForm.useHostelBlocks}">
				<tr>
					<td><label><fmt:message key="jsp.accommodation.block" /></label></td>
					<td>
						<select name="blockId" id="blockId" 
									 onchange="document.mainForm.submit(); ">
							<option value="0">
								<fmt:message key="jsp.accommodation.chooseOption" />
							</option>
                            <c:forEach var="block" items="${allocationsForm.blocks}">
                            	<c:choose>
                            		<c:when test="${blockId != block.id}">
                                		<option value="<c:out value='${block.id}' />"><c:out value='(${block.code}) ${block.description}' /></option>
                                	</c:when>
                                	<c:otherwise>
                                		<option value="<c:out value='${block.id}' />" selected="selected"><c:out value='(${block.code}) ${block.description}' /></option>
                                	</c:otherwise>
                                </c:choose>
                            </c:forEach>
						</select>
					</td>
				</tr>
			</c:if>
			<tr>
				<td><label><fmt:message key="jsp.accommodation.room" /></label></td>
				<td >
					<select name="roomId" id="roomId"
							onchange="document.mainForm.submit(); ">
						<option value="0"><fmt:message key="jsp.accommodation.chooseOption" /></option>
                        <c:forEach var="room" items="${allocationsForm.rooms}">
                        	<c:choose>
                        		<c:when test="${roomId != room.id}">
                            		<option value="<c:out value='${room.id}' />"><c:out value='(${room.code}) ${room.description}' /></option>
                            	</c:when>
                            	<c:otherwise>
                            		<option value="<c:out value='${room.id}' />" selected="selected"><c:out value='(${room.code}) ${room.description}' /></option>
                            	</c:otherwise>
                            </c:choose>
                        </c:forEach>
					</select>
				</td>
			</tr>    
</table>
