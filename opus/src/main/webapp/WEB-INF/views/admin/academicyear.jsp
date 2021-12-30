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

<%@ include file="../includes/standardincludes.jsp"%>

<c:set var="screentitlekey">jsp.general.academicyear</c:set>
<%@ include file="../header.jsp"%>
<jwr:script src="/bundles/jquerycomp.js" />  <%-- date picker --%>


<body>

<div id="tabwrapper">

    <%@ include file="../menu.jsp"%>

    <div id="tabcontent">
    <fieldset>
    <legend>
        <a href="<c:url value='/college/academicyears.view?currentPageNumber=${academicYearForm.navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.academicyears.header" /></a>&nbsp;&gt;
        <c:choose>
            <c:when test="${not empty academicYearForm.academicYear.description}" >
                <c:out value="${fn:substring(academicYearForm.academicYear.description,0,initParam.iTitleLength)}"/>
            </c:when>
            <c:otherwise>
                <fmt:message key="general.add.academicyear"/>
            </c:otherwise>
        </c:choose>
    </legend>
 
        
    <form method="post">
        <spring:bind path="academicYearForm.academicYear.id">
            <input type="hidden" name="${status.expression}" value="<c:out value="${status.value}" />" />
        </spring:bind>
        <table cellspacing="5">
        	<tr>
        		<td><fmt:message key="jsp.general.description"/></td>
                <spring:bind path="academicYearForm.academicYear.description">
            		<td class="required">
                        <input type="text" name="${status.expression}" value="<c:out value="${status.value}" />" class="required" />
                    </td>
                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                </spring:bind>
        	</tr>
        	<tr>
        		<td><fmt:message key="jsp.general.startdate"/></td>
        		<td>
        			<spring:bind path="academicYearForm.academicYear.startDate">
        				<input type="text" name="${status.expression}" class="datePicker" value="${status.value}" />
        			</spring:bind>
        		</td>
        		<td>(dd/MM/yyyy)</td>
        	</tr>
        	<tr>
        		<td><fmt:message key="jsp.general.enddate"/></td>
        		<td>
        			<spring:bind path="academicYearForm.academicYear.endDate">
        				<input type="text" name="${status.expression}" class="datePicker" value="${status.value}" /> 
        			</spring:bind>
        		</td>
        		<td>(dd/MM/yyyy)</td>
        	</tr>
            <tr>
                <td><fmt:message key="jsp.academicyear.nextacademicyear"/></td>
                <td>
                    <form:select path="academicYearForm.academicYear.nextAcademicYearId">
                        <form:option value="0"><fmt:message key='jsp.selectbox.choose' /></form:option>
                        <c:forEach var="academicYear" items="${academicYearForm.allAcademicYears}">
                            <form:option value="${academicYear.id}" disabled="${academicYear.id == academicYearForm.academicYear.id}">
                                <c:out value="${academicYear.description}"/>
                                <c:if test="${! empty academicYear.startDate and ! empty academicYear.endDate}">
                                &nbsp; &nbsp; &nbsp;(
                                <fmt:formatDate dateStyle="medium" type="date" value="${academicYear.startDate}"/>
                                -
                                <fmt:formatDate dateStyle="medium" type="date" value="${academicYear.endDate}"/>
                                )
                                </c:if>
                            </form:option>
                        </c:forEach>
                    </form:select>
                </td>
            </tr>
        	<tr><td>&nbsp;</td></tr>
        	<tr>
        		<td colspan="4" align="center">
        			<input type="submit" value="<fmt:message key="jsp.button.submit" />" />
        		</td>
        	</tr>
        </table>
    </form>
	
    </fieldset>
    </div><%--tabcontent --%>
</div><%--tabwrapper --%>

<%@ include file="../footer.jsp"%>
