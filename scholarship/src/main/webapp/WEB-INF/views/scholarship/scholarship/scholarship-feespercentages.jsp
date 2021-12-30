<div class="Accordion" id="Accordion1" tabindex="0">
	<div class="AccordionPanel">
		<div class="AccordionPanelTab"><fmt:message key="general.feespercentages" /></div>
			<div class="AccordionPanelContent">

		
		<div style="padding:10px;text-align: right; width:98%">		
        	<a class="button" 
           		href="<c:url value='/scholarship/scholarshipFeePercentage.view?scholarshipId=${scholarship.id}&amp;newForm=true&amp;tab=1&amp;panel=0&amp;from=sponsor&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"
         	>
        	<fmt:message key="jsp.href.add" />
        	</a>
		</div>
		
		<table  id="TblData">
    
            <th><fmt:message key="jsp.general.category" /></th>
            <th><fmt:message key="jsp.general.percentage" /></th>
            <th><fmt:message key="jsp.general.active" /></th>

            	<c:forEach var="feePercentage" items="${scholarship.feesPercentages}">
                        <tr>
                           <td>
                                ${scholarshipForm.codeToFeeCategoryMap[feePercentage.feeCategoryCode].description }
                           </td>

                          <td style="width:20%;text-align: center">
                                 ${feePercentage.percentage}   
                           </td>

                       	  <td style="width:7%;text-align: center">
                                <fmt:message key="${stringToYesNoMap[feePercentage.active]}"/>
                           </td>
                           
                           <td class="buttonsCell" style="width:7%;text-align: center">
                                    <a href="<c:url value='/scholarship/scholarshipFeePercentage.view?scholarshipId=${scholarshipForm.scholarship.id}&amp;tab=1&amp;panel=0&amp;from=sponsor&amp;feePercentageId=${feePercentage.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                    &nbsp;&nbsp;<a href="<c:url value='/scholarship/scholarshipFeePercentage_delete.view?scholarshipId=${scholarshipForm.scholarship.id}&amp;feePercentageId=${feePercentage.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}&amp;tab=1'/>"
                                   	    onclick="return confirm('<fmt:message key="jsp.general.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
		                    </td>
                        </tr>
            </c:forEach>
        </table>
        <script type="text/javascript">alternate('TblData',true)</script>


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