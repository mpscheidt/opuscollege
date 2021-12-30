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

<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

<%@ include file="../../menu.jsp"%>

<c:set var="navigationSettings" value="${sponsorPaymentsForm.navigationSettings}" scope="page" />
 
<div id="tabcontent">

<fieldset>
    <legend>
        <fmt:message key="scholarship.sponsorpayments" />
    </legend>
        
    <%--Display Error Messages because it must be visible if an error occurred in any tab --%>
    <form:errors path="sponsorPaymentsForm.*" cssClass="errorwide" element="p"/>
    
    <%-- FILTER ELEMENTS --%>
    <form:form modelAttribute="sponsorPaymentsForm" method="post">
    
    <table>
        <tr>
            <input type="hidden" name="academicYearIdChanged" id="academicYearIdChanged" value="" />
            <td class="label"><form:label for="academicYearId" path="academicYearId"><fmt:message key="jsp.general.academicyear" /></form:label></td>
            <td><form:select path="academicYearId" onchange="
                    document.getElementById('academicYearIdChanged').value='true';
                    this.form.submit();">
                <form:option value="0"><fmt:message key='jsp.selectbox.choose' /></form:option>
                <form:options items="${sponsorPaymentsForm.allAcademicYears}" itemValue="id" itemLabel="description"/>
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
                <c:forEach var="sponsor" items="${sponsorPaymentsForm.allSponsors}">
                    <form:option value="${sponsor.id}">${sponsor.code} - ${sponsor.name}</form:option>
                </c:forEach>    
            </form:select></td>
            <td><form:errors path="sponsorId" cssClass="error"/></td>
        </tr>

        <tr>
            <input type="hidden" name="scholarshipIdChanged" id="scholarshipIdChanged" value="" />
            <td class="label"><form:label for="scholarshipId" path="scholarshipId"><fmt:message key="jsp.general.scholarship" /></form:label></td>
            <td><form:select path="scholarshipId" onchange="
                    document.getElementById('scholarshipIdChanged').value='true';
                    this.form.submit();">
                <form:option value="0"><fmt:message key='jsp.selectbox.choose' /></form:option>
                <form:options items="${sponsorPaymentsForm.allScholarships}" itemValue="id" itemLabel="description"/>
            </form:select></td>
            <td><form:errors path="scholarshipId" cssClass="error"/></td>
        </tr>

        <tr>
            <td class="label"><fmt:message key="scholarship.invoicenumber" /></td>
            <td>
                <form:select path="sponsorInvoiceId" onchange="this.form.submit();">
                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
<%--                                 <form:options items="${sponsorPaymentsForm.allSponsorInvoices}" itemValue="id" itemLabel="invoiceNumber"/> --%>
                    <c:forEach var="sponsorInvoice" items="${sponsorPaymentsForm.allSponsorInvoices}">
                        <form:option value="${sponsorInvoice.id}">${sponsorInvoice.invoiceNumber} -- <fmt:message key="scholarship.outstanding"/>: ${sponsorInvoice.outstandingAmount} / ${sponsorInvoice.amount}</form:option>
                    </c:forEach>
                </form:select>
            </td>
            <form:errors path="sponsorInvoiceId" cssClass="error" element="td"/>
        </tr>
    </table>
    
    
    </form:form>
 </fieldset>

<sec:authorize access="hasRole('CREATE_SPONSORPAYMENTS')">
    <p align="right">    
        <a class="button" href="<c:url value='/scholarship/sponsorpayment.view?newForm=true'/>">
            <fmt:message key="jsp.href.add" />
        </a>
    </p>
</sec:authorize>
    
<%-- TABLE STARTS HERE --%>

<c:set var="allEntities" value="${sponsorPaymentsForm.allSponsorPayments}" scope="page" />
<c:set var="redirView" value="sponsorpayments" scope="page" />
<c:set var="entityNumber" value="0" scope="page" />

<%@ include file="../../includes/pagingHeaderNew.jsp"%>

<table class="tabledata" id="TblData">
    <th><fmt:message key="jsp.general.academicyear" /></th>
    <th><fmt:message key="scholarship.sponsor" /></th>
    <th><fmt:message key="jsp.general.scholarship" /></th>
    <th><fmt:message key="scholarship.invoicenumber" /></th>
    <th><fmt:message key="scholarship.invoicedate" /></th>
    <th><fmt:message key="scholarship.invoiceamount" /></th>
    <th><fmt:message key="scholarship.outstanding" /></th>
    <th><fmt:message key="scholarship.cleared" /></th>
    <th><fmt:message key="scholarship.receiptnumber" /></th>
    <th><fmt:message key="scholarship.paymentreceiveddate" /></th>
    <th><fmt:message key="scholarship.amountpaid" /></th>
    <th>&nbsp;</th>

    <c:forEach var="sponsorPayment" items="${sponsorPaymentsForm.allSponsorPayments}">
		<c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
    	<c:choose>
    		<c:when test="${(entityNumber < (navigationSettings.currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((navigationSettings.currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
                <c:set var="sponsorInvoice" value="${sponsorPayment.sponsorInvoice}" />
                <c:set var="scholarship" value="${sponsorInvoice.scholarship}" />
                <c:set var="sponsor" value="${scholarship.sponsor}" />
                <tr>
                    <td>
                        ${sponsorPaymentsForm.idToAcademicYearMap[sponsor.academicYearId].description}
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
                        ${sponsorPayment.receiptNumber}
                    </td>
                    <td>
                        <fmt:formatDate value="${sponsorPayment.paymentReceivedDate}" type="date"/>
                    </td>
                    <td>
                        ${sponsorPayment.amount}
                	</td>

                    <td class="buttonsCell" style="width:7%;text-align: center">
                        <sec:authorize access="hasRole('UPDATE_SPONSORPAYMENTS')">
                            <a href="<c:url value='/scholarship/sponsorpayment.view?newForm=true&sponsorPaymentId=${sponsorPayment.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                        </sec:authorize>
                        <sec:authorize access="hasRole('DELETE_SPONSORPAYMENTS')">
                            &nbsp;&nbsp;<a href="<c:url value='/scholarship/sponsorpayments.view?delete=true&sponsorPaymentId=${sponsorPayment.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"
                           	    onclick="return confirm('<fmt:message key="jsp.general.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                        </sec:authorize>
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
