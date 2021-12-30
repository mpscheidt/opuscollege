<div class="Accordion" id="Accordion1" tabindex="0">
	<div class="AccordionPanel">
		<div class="AccordionPanelTab"><fmt:message key="general.deadlines" /></div>
			<div class="AccordionPanelContent">

		
		<div style="padding:10px;text-align: right; width:98%">		
        	<a class="button" 
           		href="<c:url value='/fee/feedeadline.view?feeId=${feeStudyGradeTypeForm.fee.id}&amp;studyId=${feeStudyGradeTypeForm.study.id}&amp;newForm=true&amp;tab=1&amp;panel=0&amp;from=feeStudyGradeType&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"
         	>
        	<fmt:message key="jsp.href.add" />
        	</a>
		</div>
		
		<table  id="TblData">
    
			<th><fmt:message key="jsp.general.deadline" /></th>
            <th><fmt:message key="jsp.general.timeunit" /></th>
            <th><fmt:message key="jsp.general.status" /></th>
            <th><fmt:message key="jsp.general.active" /></th>
            
            	<c:forEach items="${feeStudyGradeTypeForm.feeDeadlines}" var="feeDeadline">
                        <tr>
                           <td>
                           		<fmt:formatDate pattern="dd/MM/yyyy" value="${feeDeadline.deadline}" />
                           </td>
                           <td>
                           		${feeDeadline.cardinalTimeUnit}
                                <c:if test="${feeDeadline.nrOfUnitsPerYear > 1}" >
                           		   ${feeDeadline.cardinalTimeUnitNumber}
                               </c:if>
                           </td>
                           <td style="font-weight:bold;width: 20%">
                                <c:choose>
                                    <c:when test="${not empty feeDeadline.deadline && (feeDeadline.deadline < currentDate)}">
                                        <span style="color:#bf1616;"><fmt:message key="jsp.general.expired"/></span>
                                    </c:when>
                                    <c:otherwise>
                                    <span style="color:#036f43;"><fmt:message key="jsp.general.active"/></span> 
                                    </c:otherwise>
                                </c:choose> 
                            </td>
                       	  <td style="width:7%;">
                                <c:choose>
                                	<c:when test="${feeDeadline.active == 'Y'}">
                                		<fmt:message key="jsp.general.yes"/>
                                	</c:when>
                                	<c:otherwise>
                                		<fmt:message key="jsp.general.no"/>
                                	</c:otherwise>
                                </c:choose>
                           </td>
                           
                           <td class="buttonsCell"">
                                    <a 
                                    href="<c:url value='/fee/feedeadline.view?feeId=${feeStudyGradeTypeForm.fee.id}&amp;feeDeadlineId=${feeDeadline.id}&amp;newForm=true&amp;tab=1&amp;panel=0&amp;from=feeStudyGradeType&amp;studyId=${feeStudyGradeTypeForm.study.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"
                                    ><img src="<c:url value='/images/edit.gif' />" 
                                    		 alt="<fmt:message key="jsp.href.edit" />" 
                                    		 title="<fmt:message key="jsp.href.edit" />" /></a>
                                    &nbsp;&nbsp;
                                    <a href="<c:url value='/fee/feeStudyGradeTypeDeadline_delete.view?feeId=${feeStudyGradeTypeForm.fee.id}&amp;feeDeadlineId=${feeDeadline.id}&amp;studyId=${feeStudyGradeTypeForm.study.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}&amp;tab=1&amp;from=feeStudyGradeType'/>"
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