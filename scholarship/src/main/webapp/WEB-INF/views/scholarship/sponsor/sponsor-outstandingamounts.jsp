<div class="Accordion" id="Accordion1" tabindex="0">
	<div class="AccordionPanel">
		<div class="AccordionPanelTab"><fmt:message key="scholarship.outstandingamounts" /></div>
			<div class="AccordionPanelContent">

		
		<table id="outstandingAmountsTblData">

            <th><fmt:message key="scholarship.invoicenumber" /></th>
            <th><fmt:message key="scholarship.invoicedate" /></th>
            <th><fmt:message key="jsp.general.amount" /></th>
            <th><fmt:message key="scholarship.outstanding" /></th>
            
        	<c:forEach var="sponsorInvoice" items="${sponsorForm.outstandingSponsorInvoices}" >
                <tr>
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
                </tr>
            </c:forEach>
        </table>
        <script type="text/javascript">alternate('outstandingAmountsTblData',true)</script>


		</div><%-- AccordionPanelContent --%>
	</div><%-- AccordionPanel --%>
</div><%-- Accordion0 --%>

 <script type="text/javascript">
                        var Accordion${accordion} = new Spry.Widget.Accordion("Accordion1",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });
                        
</script>