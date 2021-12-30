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
<jwr:script src="/bundles/jquerycomp.js" />

<%-- TODO remove --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://jawr.net/tags" prefix="jwr" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>


<body>

<div id="tabwrapper">

<%@ include file="../../menu.jsp"%>

<c:set var="navigationSettings" value="${sponsorPaymentForm.navigationSettings}" scope="page" />

<%-- Invoice number (and related fields acad.year, sponsor, scholarship) shall only be editable for new payments.
     Otherwise cleared flag would have to be updated for both old and new sponsorInvoice. --%>
<c:set var="editInvoiceNumber" value="${sponsorPaymentForm.sponsorPayment.id == 0}" />

<div id="tabcontent">

<fieldset>
	<legend>
    	<a href="<c:url value='/scholarship/sponsorpayments.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
        <fmt:message key="scholarship.sponsorpayment"/>
	</legend>
</fieldset>

<div id="tp1" class="TabbedPanel">
<ul class="TabbedPanelsTabGroup">
    <li class="TabbedPanelsTab compulsoryTab">
    	<fmt:message key="jsp.general.details" />
    </li>  
    
</ul><%--tabpanel tabs--%>


<div class="TabbedPanelsContentGroup">

  <%--details tab --%>
  <div class="TabbedPanelsContent">
    <div class="Accordion" id="Accordion0" tabindex="0">
      <div class="AccordionPanel">
        <div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.general.details" /></div>
        <div class="AccordionPanelContent">

            <form:form method="POST" commandName="sponsorPaymentForm" cssStyle="padding-top:20px">
                <table cellspacing="5">        

                    <tr>
                        <input type="hidden" name="academicYearIdChanged" id="academicYearIdChanged" value="" />
                        <td class="label"><form:label for="academicYearId" path="academicYearId"><fmt:message key="jsp.general.academicyear" /></form:label></td>
                        <td><form:select path="academicYearId" disabled="${!editInvoiceNumber}" onchange="
                                document.getElementById('academicYearIdChanged').value='true';
                                this.form.submit();">
                            <form:option value="0"><fmt:message key='jsp.selectbox.choose' /></form:option>
                            <form:options items="${sponsorPaymentForm.allAcademicYears}" itemValue="id" itemLabel="description"/>
                        </form:select></td>
                        <td><form:errors path="academicYearId" cssClass="error"/></td>
                    </tr>

                    <tr>
                        <input type="hidden" name="sponsorIdChanged" id="sponsorIdChanged" value="" />
                        <td class="label"><form:label for="sponsorId" path="sponsorId"><fmt:message key="scholarship.sponsor" /></form:label></td>
                        <td><form:select path="sponsorId" disabled="${!editInvoiceNumber}" onchange="
                                document.getElementById('sponsorIdChanged').value='true';
                                this.form.submit();">
                            <form:option value="0"><fmt:message key='jsp.selectbox.choose' /></form:option>
                            <c:forEach var="sponsor" items="${sponsorPaymentForm.allSponsors}">
                                <form:option value="${sponsor.id}">${sponsor.code} - ${sponsor.name}</form:option>
                            </c:forEach>
                        </form:select></td>
                        <td><form:errors path="sponsorId" cssClass="error"/></td>
                    </tr>

                    <tr>
                        <input type="hidden" name="scholarshipIdChanged" id="scholarshipIdChanged" value="" />
                        <td class="label"><fmt:message key="jsp.general.scholarship" /></td>
                        <td>
                            <form:select path="scholarshipId" disabled="${!editInvoiceNumber}" onchange="
                                document.getElementById('scholarshipIdChanged').value='true';
                                this.form.submit();">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <form:options items="${sponsorPaymentForm.allScholarships}" itemValue="id" itemLabel="description"/>
                            </form:select>
                        </td>
                        <form:errors path="scholarshipId" cssClass="error" element="td"/>
                    </tr>

                    <tr>
                        <td class="label"><fmt:message key="scholarship.invoicenumber" /></td>
                        <td class="required">
                            <form:select path="sponsorPayment.sponsorInvoiceId" disabled="${!editInvoiceNumber}" >
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <c:forEach var="sponsorInvoice" items="${sponsorPaymentForm.allSponsorInvoices}">
                                    <form:option value="${sponsorInvoice.id}">${sponsorInvoice.invoiceNumber} -- <fmt:message key="scholarship.outstanding"/>: ${sponsorInvoice.outstandingAmount} / ${sponsorInvoice.amount}</form:option>
                                </c:forEach>
                            </form:select>
                        </td>
                        <form:errors path="sponsorPayment.sponsorInvoiceId" cssClass="error" element="td"/>
                    </tr>

                    <tr>
                        <td class="label"><fmt:message key="scholarship.receiptnumber" /></td>
                        <td class="required">
                            <form:input path="sponsorPayment.receiptNumber" size="50"/>
                        </td>
                        <td>
                            <c:if test="${sponsorPaymentForm.sponsorReceiptNumberWillBeGenerated}">
                                <fmt:message key="scholarship.numbergenerated"/>
                            </c:if>
                            <form:errors path="sponsorPayment.receiptNumber" cssClass="error"/>
                        </td>
                    </tr>
            
                    <tr>
                        <td class="label"><fmt:message key="scholarship.paymentreceiveddate" /></td>
                        <td class="required">
                            <form:input path="sponsorPayment.paymentReceivedDate" cssClass="datePicker" />
                            <span style="font-size:smaller">(dd/MM/yyyy)</span>
                        </td>
                        <form:errors path="sponsorPayment.paymentReceivedDate" cssClass="error" element="td"/>
                    </tr>

                    <tr>
                        <td class="label"><fmt:message key="jsp.general.amount" /></td>
                        <td class="required">
                            <form:input path="sponsorPayment.amount" size="50"/>
                        </td>
                        <form:errors path="sponsorPayment.amount" cssClass="error" element="td"/>
                    </tr>

                    <tr>
                        <td colspan="4" align="center" style="padding:20px">
                            <input type="submit" value="<fmt:message key="jsp.button.submit" />" />
                        </td>
                    </tr>
                </table>
            </form:form>
            
            
        </div><%-- AccordionPanelContent --%>
      </div><%-- AccordionPanel --%>
    </div><%-- Accordion0 --%>

        <script type="text/javascript">
            var Accordion${accordion} = new Spry.Widget.Accordion("Accordion0",
                  {defaultPanel: 0,
                  useFixedPanelHeights: false,
                  nextPanelKeyCode: 78 /* n key */,
                  previousPanelKeyCode: 80 /* p key */
                 });
                                
        </script>
  </div><%-- TabbedPanelsContent detailstab--%>

</div><%-- TabbedPanelsContentGroup--%>
</div><%--TabbedPanel --%>


<script type="text/javascript">
    var tp1 = new Spry.Widget.TabbedPanels("tp1");
    tp1.showPanel(${navigationSettings.tab});
    Accordion${navigationSettings.tab}.defaultPanel = ${navigationSettings.panel};
    Accordion${navigationSettings.tab}.openPanelNumber(${navigationSettings.panel});
</script>
</div><%--tabcontent --%>
</div><%--tabwrapper --%>

<%@ include file="../../footer.jsp"%>
