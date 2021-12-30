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
<jwr:script src="/bundles/jquerycomp.js" /> <%-- for the date picker --%>

<body>

<div id="tabwrapper">

<%@ include file="../../menu.jsp"%>

<c:set var="navigationSettings" value="${sponsorInvoiceForm.navigationSettings}" scope="page" />

<div id="tabcontent">

<fieldset>
	<legend>
    	<a href="<c:url value='/scholarship/sponsorinvoices.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
        <fmt:message key="scholarship.sponsorinvoice"/>
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

            <form:form method="POST" commandName="sponsorInvoiceForm" cssStyle="padding-top:20px">
                <table cellspacing="5">        
    
                    <tr>
                        <input type="hidden" name="academicYearIdChanged" id="academicYearIdChanged" value="" />
                        <td class="label"><form:label for="academicYearId" path="academicYearId"><fmt:message key="jsp.general.academicyear" /></form:label></td>
                        <td><form:select path="academicYearId" onchange="
                                document.getElementById('academicYearIdChanged').value='true';
                                this.form.submit();">
                            <form:option value="0"><fmt:message key='jsp.selectbox.choose' /></form:option>
                            <form:options items="${sponsorInvoiceForm.allAcademicYears}" itemValue="id" itemLabel="description"/>
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
                            <c:forEach var="sponsor" items="${sponsorInvoiceForm.allSponsors}">
                                <form:option value="${sponsor.id}">${sponsor.code} - ${sponsor.name}</form:option>
                            </c:forEach>
                        </form:select></td>
                        <td><form:errors path="sponsorId" cssClass="error"/></td>
                    </tr>

                    <tr>
                        <td class="label"><fmt:message key="jsp.general.scholarship" /></td>
                        <td class="required">
                            <form:select path="sponsorInvoice.scholarshipId">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <form:options items="${sponsorInvoiceForm.allScholarships}" itemValue="id" itemLabel="description"/>
                            </form:select>
                        </td>
                        <form:errors path="sponsorInvoice.scholarshipId" cssClass="error" element="td"/>
                    </tr>

                    <tr>
                        <td class="label"><fmt:message key="scholarship.invoicenumber" /></td>
                        <td class="required">
                            <form:input path="sponsorInvoice.invoiceNumber" size="50"/>
                        </td>
                        <td>
                            <c:if test="${sponsorInvoiceForm.sponsorInvoiceNumberWillBeGenerated}">
                                <fmt:message key="scholarship.numbergenerated"/>
                            </c:if>
                            <form:errors path="sponsorInvoice.invoiceNumber" cssClass="error"/>
                        </td>
                    </tr>
            
                    <tr>
                        <td class="label"><fmt:message key="scholarship.invoicedate" /></td>
                        <td class="required">
                            <form:input path="sponsorInvoice.invoiceDate" cssClass="datePicker" />
                            <span style="font-size:smaller">(dd/MM/yyyy)</span>
                        </td>
                        <form:errors path="sponsorInvoice.invoiceDate" cssClass="error" element="td"/>
                    </tr>

                    <tr>
                        <td class="label"><fmt:message key="jsp.general.amount" /></td>
                        <td class="required">
                            <form:input path="sponsorInvoice.amount" size="50"/>
                        </td>
                        <form:errors path="sponsorInvoice.amount" cssClass="error" element="td"/>
                    </tr>

                    <tr>
                        <td class="label"><fmt:message key="scholarship.cleared" /></td>
                        <td>
                            <fmt:message key="${booleanToYesNoMap[sponsorInvoiceForm.sponsorInvoice.cleared]}" />
                        </td>
                        <form:errors path="sponsorInvoice.cleared" cssClass="error" element="td"/>
                    </tr>

                    <tr>
                        <td class="label"><fmt:message key="jsp.general.active"/></td>
                        <td>
                          <form:select path="sponsorInvoice.active">
                             <form:option value="Y"><fmt:message key="jsp.general.yes"/></form:option>
                             <form:option value="N"><fmt:message key="jsp.general.no"/></form:option>                    
                          </form:select>
                        </td>
                        <form:errors path="sponsorInvoice.active" cssClass="error" element="td"/>
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
