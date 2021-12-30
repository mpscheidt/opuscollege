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

The Original Code is Opus-College scholarship module code.

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

<%@ taglib tagdir="/WEB-INF/tags" prefix="opus" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://jawr.net/tags" prefix="jwr" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

<%@ include file="../../menu.jsp"%>

<c:set var="navigationSettings" value="${sponsorInvoicesForm.navigationSettings}" scope="page" />

<div id="tabcontent">

<fieldset>
    <legend>
        <fmt:message key="scholarship.sponsorinvoices" />
    </legend>

    <%--Display Error Messages because it must be visible if an error occurred in any tab --%>
    <form:errors path="sponsorInvoicesForm.*" cssClass="errorwide" element="p"/>

    <%-- FILTER ELEMENTS --%>
    <form:form modelAttribute="sponsorInvoicesForm" method="post">

    <table>
        <tr>
            <input type="hidden" name="academicYearIdChanged" id="academicYearIdChanged" value="" />
            <td class="label"><form:label for="academicYearId" path="academicYearId"><fmt:message key="jsp.general.academicyear" /></form:label></td>
            <td><form:select path="academicYearId" onchange="
                    document.getElementById('academicYearIdChanged').value='true';
                    this.form.submit();">
                <form:option value="0"><fmt:message key='jsp.selectbox.choose' /></form:option>
                <form:options items="${sponsorInvoicesForm.allAcademicYears}" itemValue="id" itemLabel="description"/>
            </form:select></td>
            <td><form:errors path="academicYearId" cssClass="error"/></td>
        </tr>

        <tr>
            <input type="hidden" name="sponsorIdChanged" id="sponsorIdChanged" value="" />
            <td class="label"><form:label for="sponsorId" path="sponsorId"><fmt:message key="scholarship.sponsor" /></form:label></td>
            <td><form:select path="sponsorId" onchange="
                    document.getElementById('sponsorIdChanged').value='true';
                    this.form.submit();">
                <form:option value="0"><fmt:message key='jsp.selectbox.choose' /></form:option>
                <c:forEach var="sponsor" items="${sponsorInvoicesForm.allSponsors}">
                    <form:option value="${sponsor.id}">${sponsor.code} - ${sponsor.name}</form:option>
                </c:forEach>    
            </form:select></td>
            <td><form:errors path="sponsorId" cssClass="error"/></td>
        </tr>

        <tr>
            <td class="label"><form:label for="scholarshipId" path="scholarshipId"><fmt:message key="jsp.general.scholarship" /></form:label></td>
            <td><form:select path="scholarshipId" onchange="this.form.submit();">
                <form:option value="0"><fmt:message key='jsp.selectbox.choose' /></form:option>
                <form:options items="${sponsorInvoicesForm.allScholarships}" itemValue="id" itemLabel="description"/>
            </form:select></td>
            <td><form:errors path="scholarshipId" cssClass="error"/></td>
        </tr>
        
        <tr>
            <td class="label"><form:label for="scholarshipId" path="cleared"><fmt:message key="scholarship.cleared" /></form:label></td>
            <td><form:select path="cleared" onchange="this.form.submit();">
                <form:option value=""><fmt:message key='jsp.selectbox.choose' /></form:option>
                <form:option value="${true}"><fmt:message key='jsp.general.yes' /></form:option>
                <form:option value="${false}"><fmt:message key='jsp.general.no' /></form:option>
            </form:select></td>
            <td><form:errors path="cleared" cssClass="error"/></td>
        </tr>
        
    </table>
    
    
    </form:form>
 </fieldset>

<sec:authorize access="hasRole('CREATE_SPONSORINVOICES')">
    <p align="right">    
        <a class="button" href="<c:url value='/scholarship/sponsorinvoice.view?newForm=true'/>">
            <fmt:message key="jsp.href.add" />
        </a>
    </p>
</sec:authorize>
    
<%-- TABLE STARTS HERE --%>

<c:set var="allEntities" value="${sponsorInvoicesForm.allSponsorInvoices}" scope="page" />
<c:set var="redirView" value="sponsorinvoices" scope="page" />
<c:set var="entityNumber" value="0" scope="page" />

<%@ include file="../../includes/pagingHeaderNew.jsp"%>

<table class="tabledata" id="TblData">
    <th><fmt:message key="jsp.general.academicyear" /></th>
    <th><fmt:message key="scholarship.sponsor" /></th>
    <th><fmt:message key="jsp.general.scholarship" /></th>
    <th><fmt:message key="scholarship.invoicenumber" /></th>
    <th><fmt:message key="scholarship.invoicedate" /></th>
    <th><fmt:message key="jsp.general.amount" /></th>
    <th><fmt:message key="scholarship.outstanding" /></th>
    <th><fmt:message key="scholarship.cleared" /></th>
    <th><fmt:message key="jsp.general.active" /></th>
    <th>&nbsp;</th>

    <c:forEach var="sponsorInvoice" items="${sponsorInvoicesForm.allSponsorInvoices}" >
		<c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
    	<c:choose>
    		<c:when test="${(entityNumber < (navigationSettings.currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((navigationSettings.currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
                <c:set var="scholarship" value="${sponsorInvoice.scholarship}" />
                <c:set var="sponsor" value="${scholarship.sponsor}" />
                <tr>
                    <td>
                        ${sponsorInvoicesForm.idToAcademicYearMap[sponsor.academicYearId].description}
                    </td>
	                <td>
                        ${sponsor.code} - ${sponsor.name}
	                </td>
                    <td>
                        ${scholarship.description}
                    </td>
                    <td>
                        ${sponsorInvoice.invoiceNumber}
                    </td>
                	<td>
                        <fmt:formatDate value="${sponsorInvoice.invoiceDate}" type="date"/>
                	</td>
                    <td>
                        ${sponsorInvoice.amount}
                    </td>
                    <td>
                        ${sponsorInvoice.outstandingAmount}
                    </td>
                    <td>
                        <fmt:message key="${booleanToYesNoMap[sponsorInvoice.cleared]}"/>
                    </td>
                    <td>
                        <fmt:message key="${stringToYesNoMap[sponsorInvoice.active]}"/>
                    </td>

                    <td class="buttonsCell">
                        <sec:authorize access="hasRole('UPDATE_SPONSORINVOICES')">
                            <a href="<c:url value='/scholarship/sponsorinvoice.view?newForm=true&sponsorInvoiceId=${sponsorInvoice.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                        </sec:authorize>
                        <sec:authorize access="hasRole('DELETE_SPONSORINVOICES')">
                            <a href="<c:url value='/scholarship/sponsorinvoices.view?delete=true&sponsorInvoiceId=${sponsorInvoice.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"
                           	    onclick="return confirm('<fmt:message key="jsp.general.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                        </sec:authorize>
                        <c:forEach var="sponsorsButtonsCellReport" items="${scholarshipWebExtensions.sponsorsButtonsCellReports}">
                            <c:set var="sponsorInvoice" value="${sponsorInvoice}" scope="request"/>
                            <opus:htmlButton htmlButton="${sponsorsButtonsCellReport}" />
<%--
                            <sec:authorize access="${sponsorsButtonsCellReport.access}">
                                <spring:url value="${sponsorsButtonsCellReport.url}" var="resourceUrl">
                                    <c:forEach var="urlParam" items="${sponsorsButtonsCellReport.urlParams}">
                                        <spring:param name="${urlParam.key}"><spring:eval expression="${urlParam.value}"/></spring:param>
                                    </c:forEach>
                                </spring:url>
                                &nbsp;<a href="${resourceUrl}" target="otherwindow"><img src="<c:url value='/images/next.gif' />" alt="<fmt:message key="${sponsorsButtonsCellReport.titleKey}" />" title="<fmt:message key="${sponsorsButtonsCellReport.titleKey}" />" /></a>
                            </sec:authorize>
 --%>
                        </c:forEach>
                    </td>
                </tr>
            </c:when>
        </c:choose>
    </c:forEach>
</table>
<script type="text/javascript">alternate('TblData',true)</script>

<%@ include file="../../includes/pagingFooterNew.jsp"%>

<br /><br />
</div>

</div>

<%@ include file="../../footer.jsp"%>
