<%--
***** BEGIN LICENSE BLOCK *****
Version: MPL 1.1/GPL 2.0/LGPL 2.1

The contents of this file are subject to the Mozilla Public License Version 
1.1 (the "License"), you may not use this file except in compliance with 
the License. You may obtain a copy of the License at 
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
for the specific language governing rights and limitations under the
License.

The Original Code is Opus-College accommodation module code.

The Initial Developer of the Original Code is
Center for Information Services, Radboud University Nijmegen
and Copperbelt University, Zambia.
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

<%@ include file="../../header.jsp"%>

<body>
    <div id="tabwrapper">
        <%@ include file="../../menu.jsp"%>
        <div id="tabcontent">
            <form:form method="get" modelAttribute="hostelsForm">
                <input type="hidden" name="newForm" id="newForm" value="<c:out value='${true}' />" />
                <fieldset>
                    <legend>
                        <fmt:message key="jsp.accommodation.hostelOverview" />
                    </legend>
                    <table>
                        <tr>
                            <td><fmt:message key="jsp.accommodation.hostelType" /></td>
                            <td>
                                <select name="hostelTypeCode" id="hostelTypeCode" onchange="form.submit()">
                                    <option value="0">
                                        <fmt:message key="jsp.accommodation.chooseOption" />
                                    </option>
                                    <c:forEach items="${hostelsForm.allHostelTypes}" var="hostelType">
                                        <c:if test="${param.hostelTypeCode == hostelType.code}">
                                            <option value="<c:out value='${hostelType.code }' />" selected="selected"><c:out value='${hostelType.description}' /></option>
                                        </c:if>
                                        <c:if test="${param.hostelTypeCode != hostelType.code}">
                                            <option value="<c:out value='${hostelType.code }' />"><c:out value='${hostelType.description}' /></option>
                                        </c:if>
                                    </c:forEach>
                                </select>
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

            <c:set var="allEntities" value="${hostelsForm.allHostels}" scope="page" />
            <c:set var="redirView" value="hostels" scope="page" />
            <c:set var="entityNumber" value="0" scope="page" />

            <sec:authorize access="hasRole('CREATE_ACCOMMODATION_DATA')">
                <p align="right">    
                    <a class="button" href="<c:out value='hostel.view?newForm=true&fromView=hostels.view'/>">
                    <fmt:message key="jsp.href.add" /></a>                                 
                </p>
            </sec:authorize>

            <%@ include file="../../includes/pagingHeader.jsp"%>
            <table id="tblListHostels" class="tabledata">
                
                <tr>
                    <th><fmt:message key="jsp.accommodation.code" /></th>
                    <th><fmt:message key="jsp.accommodation.description" /></th>
                    <th><fmt:message key="jsp.accommodation.hostelType" /></th>
                    <th><fmt:message key="jsp.accommodation.numberOfFloors" /></th>
                    <th><fmt:message key="jsp.accommodation.active" /></th>
                    <th>&nbsp;</th>
                </tr>

                <c:forEach items="${hostelsForm.allHostels}" var="hostel">
                    <tr>
                        <td><c:out value='${hostel.code }' /></td>
                        <td><c:out value='${hostel.description }' /></td>
                        <td><c:out value='${hostelsForm.codeToHostelTypeMap[hostel.hostelTypeCode].description }' /></td>
                        <td><c:out value='${hostel.numberOfFloors}' /></td>
                        <td><c:choose>
                                <c:when test="${hostel.active == 'Y'}">
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
                                    href="<c:url value='hostel.view'/>?<c:out value='newForm=true&hostelId=${hostel.id}&fromView=hostels.view' />"><img
                                    src="<c:url value='/images/edit.gif' />"
                                    alt="<fmt:message key="jsp.href.edit" />"
                                    title="<fmt:message key="jsp.href.edit" />" /></a>
                            </sec:authorize>
                            <sec:authorize access="hasRole('DELETE_ACCOMMODATION_DATA')">
                                <a
                                    href="<c:url value='hostels.view'/>?<c:out value='delete=true&hostelId=${hostel.id}' />"
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
                alternate('tblListHostels', true);
            </script>
            <%@ include file="../../includes/pagingFooter.jsp"%>
            <br />
            <br />
        </div>
    </div>

    <%@ include file="../../footer.jsp"%>
