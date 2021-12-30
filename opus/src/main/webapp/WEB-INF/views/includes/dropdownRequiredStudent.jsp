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

The Original Code is Opus-College college module code.

The Initial Developer of the Original Code is
Center for Information Services, Radboud University Nijmegen.
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

<%-- 
   Markus 2012-05-18: this has been copied from dropDownRequired.jsp,
   because if student is edited, command.staffMemberId doesn't exist and would result in HTTP500
   --%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

       <tr>
            <td class="label"><fmt:message key="${label }" /></td>
                <%-- edit allowed with the right privileges --%>
               <sec:authorize access="hasAnyRole('CREATE_LOOKUPS','UPDATE_LOOKUPS','CREATE_STUDENTS','UPDATE_STUDENTS')">
                <c:set var="editRequiredDropdownData" value="${true}" scope="page" />
                <td class="required">
                    <select name="${status.expression}">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="lookup" items="${allLookups}">
                            <c:choose>
                                <c:when test="${lookup.code == status.value}">
                                    <option value="${lookup.code}" selected="selected"><c:out value="${lookup.description}"/></option>
                                </c:when>
                                <c:otherwise>
                                    <option value="${lookup.code}"><c:out value="${lookup.description}"/></option>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </select>
                </td>
                <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
            </sec:authorize>
            <c:if test="${not editRequiredDropdownData}">
                <sec:authorize access="hasAnyRole('READ_LOOKUPS','READ_STUDENTS') or ${personId == opusUser.personId}">
	                  <c:forEach var="lookup" items="${allLookups}">
	                    <c:choose>
	                        <c:when test="${lookup.code == status.value}">
	                            <td><c:out value="${lookup.description}"/></td>
	                        </c:when>
	                    </c:choose>
	                </c:forEach>
	                <td></td>
	          </sec:authorize>
	        </c:if>
        </tr>
