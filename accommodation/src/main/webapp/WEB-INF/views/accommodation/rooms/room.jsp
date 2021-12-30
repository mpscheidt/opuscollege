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
            <%-- Check it the request is coming from the overview page. If true then display 'back to overview' message and the name of the hostelType --%>
            <c:if test="${! empty param.fromView }">
                <fieldset>
                    <legend>
                        <a href="<c:url value='rooms.view' />"><fmt:message key="jsp.general.backtooverview" /></a> &gt; 
                        <c:out value='${roomForm.room.code} ${roomForm.room.description}' />
                    </legend>
                </fieldset>
            </c:if>

            <form:form method="post" modelAttribute="roomForm">

                <%--Display Error Message at this point --%>
                <p><form:errors path="" cssClass="errorwide"/></p>

                <fieldset><legend><fmt:message key="jsp.accommodation.roomDetails" /></legend>
                    <table>
                        <tr>
                            <td><fmt:message key="jsp.accommodation.code" /></td><td class="required"><form:input path="room.code" /></td>
                            <td><form:errors path="room.code" cssClass="error" /></td>
                        </tr>
                        <tr>
                            <td><fmt:message key="jsp.accommodation.description" /></td><td><form:input path="room.description" /></td>
                            <td><form:errors path="room.description" cssClass="error" /></td>
                        </tr>
                        <tr>
                            <td><fmt:message key="jsp.accommodation.roomtype" /></td>
                            <td class="required">
                                <form:select path="room.roomTypeCode">
                                    <form:option value="0"><fmt:message key="jsp.accommodation.chooseOption" /></form:option>
                                    <form:options items="${roomForm.allRoomTypes}" itemLabel="description" itemValue="code" />
                                </form:select>
                            </td>
                            <td><form:errors path="room.roomTypeCode" cssClass="error" /></td>
                        </tr>
                        <tr>
                            <td><fmt:message key="jsp.accommodation.hostel" /></td>
                            <td class="required">
                                <input type="hidden" name="hostelChanged" id="hostelChanged" value="" />
                                <form:select path="room.hostel.id" onchange="document.getElementById('hostelChanged').value='true';form.submit()">
                                <form:option value="0"><fmt:message key="jsp.accommodation.chooseOption" /></form:option>
                                <c:forEach var="hostel" items="${roomForm.allHostels}">
                                    <form:option value="${hostel.id}"><c:out value='${hostel.code} ${hostel.description}' /></form:option>
                                </c:forEach>
                                </form:select>
                            </td>
                            <td><form:errors path="room.hostel.id" cssClass="error" /></td>
                        </tr>
                        <%--If the institution uses the Blocks then show this dropdown list--%>
                        <c:if test="${roomForm.useHostelBlock}">
                            <tr>
                                <td><fmt:message key="jsp.accommodation.block" /></td>
                                <td><form:select path="room.block.id">
                                        <form:option value="0"><fmt:message key="jsp.accommodation.chooseOption" /></form:option>
                                        <c:forEach var="block" items="${roomForm.allHostelBlocks}">
                                            <form:option value="${block.id}"><c:out value='${block.code} ${block.description}' /></form:option>
                                        </c:forEach>
                                    </form:select>
                                </td>
                                <td><form:errors path="room.block.id" cssClass="error" /></td>
                            </tr>
                        </c:if>
                        <tr>
                            <td><fmt:message key="jsp.accommodation.floorNumber" /></td>
                            <td>
                                <form:select path="room.floorNumber">
                                    <option value="0"><fmt:message key="jsp.accommodation.chooseOption" /></option>
                                    <c:forEach var="num" begin="1" end="20"><form:option value="${num }"><c:out value='${num}' /></form:option></c:forEach>
                                </form:select>
                            </td>
                            <td><form:errors path="room.floorNumber" cssClass="error" /></td>
                        </tr>
                        <tr>
                            <td><fmt:message key="jsp.accommodation.numberOfBedSpaces" /></td>
                            <td class="required">
                                <form:select path="room.numberOfBedSpaces">
                                    <option value="0"><fmt:message key="jsp.accommodation.chooseOption" /></option>
                                    <c:forEach var="num2" begin="1" end="20"><form:option value="${num2 }"><c:out value='${num2}' /></form:option></c:forEach>
                                </form:select>
                            </td>
                            <td><form:errors path="room.numberOfBedSpaces" cssClass="error" /></td>
                        </tr>
                        <tr>
                            <td><fmt:message key="jsp.accommodation.active" /></td>
                            <td>
                                <form:select path="room.active">
                                    <form:option value="0"><fmt:message key="jsp.accommodation.chooseOption" /></form:option>
                                    <form:option value="Y"><fmt:message key="jsp.general.yes" /></form:option>
                                    <form:option value="N"><fmt:message key="jsp.general.no" /></form:option>
                                </form:select>
                            </td>
                            <td><form:errors path="room.active" cssClass="error" /></td>
                        </tr>
                        <tr><td>&nbsp;</td><td><input type="submit" value="<fmt:message key="jsp.accommodation.save" />" name="save" /><input type="reset" value="<fmt:message key="jsp.accommodation.reset" />" name="reset" /></td></tr>
                    </table>
                </fieldset>
            </form:form>        
        </div>
    </div>

<%@ include file="../../footer.jsp"%>