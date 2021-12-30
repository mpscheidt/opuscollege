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

The Original Code is Opus-College fee module code.

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
 * Copyright (c) 2007 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
--%>

<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>
        
    <div id="tabcontent">

    	<form>
    		<fieldset>
    			<legend>
                	<a href="<c:url value='/fee/paymentsstudents.view?currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
	    			<a href="<c:url value='/fee/paymentsstudent.view?tab=0&panel=0&from=payments_student&studentId=${student.studentId}&currentPageNumber=${currentPageNumber}'/>">
   						<c:set var="studentLastname" value="${student.surnameFull}" scope="page" />
   						<c:set var="studentFirstname" value="${student.firstnamesFull}" scope="page" />
        				<c:set var="studentName" value="${studentLastname}, ${studentFirstname}" scope="page" />
        				<c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}" />
					</a>
					<br />>&nbsp;
	    			<spring:bind path="command.id">
		    			<c:choose>
		    				<c:when test="${status.value != null && status.value != ''}" >
                                <spring:bind path="command.subjectId">
                                <c:choose>
                                   <c:when test="${status.value != null && status.value != ''}">
                                       ${subject.subjectDescription}
                                   </c:when>
                                </c:choose>
                                </spring:bind>
                                 <spring:bind path="command.subjectBlockId">
                                <c:choose>
                                   <c:when test="${status.value != null && status.value != ''}">
                                       ${subjectBlock.subjectBlockDescription}
                                   </c:when>
                                </c:choose>
                                </spring:bind>
                               <%-- <spring:bind path="command.studyYearId">
                                <c:choose>
                                   <c:when test="${status.value != null && status.value != ''}">
                                       ${studyYear.yearNumberVariation}
                                   </c:when>
                                </c:choose>
                                </spring:bind>--%>
							</c:when>
							<c:otherwise>
								<fmt:message key="jsp.href.new" />
							</c:otherwise>
						</c:choose>
						
					</spring:bind>
					&nbsp;>&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.payments" /> 

				</legend>
				
			</fieldset>
		</form>

        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.edit" /></li>               
            </ul>

            <div class="TabbedPanelsContentGroup">   
                    <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion1" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab"><fmt:message key="jsp.general.payment" /></div>
                                <div class="AccordionPanelContent">

                                <form name="feedata" method="POST">
                                    <input type="hidden" name="tab_payment" value="0" /> 
                                    <input type="hidden" name="panel_payment" value="0" />
                                    
                                    <table>

                                        <!-- STUDY PLAN DETAIL (subject/subjectblock/studyyear) -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.studyplandetail" /></td>
                                           	<td>
	    									<spring:bind path="command.id">
                                           	<c:choose>
							    				<c:when test="${status.value != null && status.value != ''}" >
					                                 ${subject.subjectDescription}
     			                                     ${subjectBlock.subjectBlockDescription}
												</c:when>
											</c:choose>
											</spring:bind>
											</td> 
			                                <td>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.studyplan" /></td>
                                           	<td>${studyPlan.studyPlanDescription}</td> 
			                                <td>&nbsp;</td>
                                        </tr>
                   						<tr>
                                            <td class="label"><fmt:message key="jsp.general.academicyear" /></td>
                                           	<td>${academicYear.description}</td> 
			                                <td>&nbsp;</td>
                                        </tr>
                                        <!-- FEE DUE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.feedue" /></td>
                                            <td>
                                            ${feeDue}
                                            </td> 
                                            <td>&nbsp;</td>
                                        </tr>

                                        <!-- PAYDATE -->
	                                    <tr>
	                                        <td class="label"><fmt:message key="jsp.general.paydate" /></td>
                                            <spring:bind path="command.payDate">
	                                        <td class="required">
	                                        <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
	                        	            <table>
	                                            	<tr>
	                                            		<td><fmt:message key="jsp.general.day" /></td>
	                                            		<td><fmt:message key="jsp.general.month" /></td>
	                                            		<td><fmt:message key="jsp.general.year" /></td>
	                                            	</tr>
	                                                <tr>
	                                            		<td><input type="text" id="paydate_day" name="deadline_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('payDate','day',document.getElementById('paydate_day').value);" /></td>
	                                            		<td><input type="text" id="paydate_month" name="deadline_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('payDate','month',document.getElementById('paydate_month').value);" /></td>
	                                            		<td><input type="text" id="paydate_year" name="deadline_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('payDate','year',document.getElementById('paydate_year').value);" /></td>
	                                            	</tr>
	                                        </table>
	                             			</td>
	                                        <td>
	                                            <fmt:message key="jsp.general.message.dateformat" />
	                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
	                                        </td>
                                            </spring:bind>
	                                    </tr>

                                        <!-- SUM PAID -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.sumpaid" /></td>
                                            <spring:bind path="command.sumPaid">
                                            <td class="required">
                                            <input type="text" name="${status.expression}" size="12" maxlength="12" value="<c:out value="${status.value}" />" />
                                            </td> 
                                            <td>
                                            	<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                </c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>

                                        <!-- ACTIVE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.active" /></td>
                                            <spring:bind path="command.active">
                                            <td>
                                            <select name="${status.expression}">
                                                <c:choose>
                                                    <c:when test="${'Y' == status.value}">
                                                        <option value="Y" selected="selected"><fmt:message key="jsp.general.yes" /></option>
                                                        <option value="N"><fmt:message key="jsp.general.no" /></option>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <option value="Y"><fmt:message key="jsp.general.yes" /></option>
                                                        <option value="N" selected="selected"><fmt:message key="jsp.general.no" /></option>
                                                    </c:otherwise>
                                                   </c:choose>
                                            </select>
                                            </td>
                                            <td>
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">
                                                ${error}</span></c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>
       									<tr>
                                            <td class="label"><fmt:message key="jsp.general.installmentnumber" /></td>
                                            <spring:bind path="command.installmentNumber">
                                           	<td>${command.installmentNumber}</td> 
                                            <td>
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">
                                                ${error}</span></c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>  
	                                    <tr>
                                       	<td class="label">&nbsp;</td>
                                         <td colspan="3"><input type="button" name="submitbutton" value="<fmt:message key="jsp.button.submit" />" onclick="checkRefundPeriodAndPaymentValue('${startOfRefundPeriodTime}','${endOfRefundPeriodTime}',this.form,'<fmt:message key="jsp.payments.refund.confirm"/>')"></td>
	                                    </tr>

	                                </table>
                                </form>
                                </div>
                            </div>
                        </div>
                        <script type="text/javascript">
                            var sampleAccordion = new Spry.Widget.Accordion("Accordion1");
                            function checkRefundPeriodAndPaymentValue(startOfRefundPeriodTime,endOfRefundPeriodTime, form,confirmMessage){
                            	   var payDate   = form.payDate.value;
                            	   if(payDate != null){
	                            	   var dateParts = payDate.split("-");
	                            	   var date = new Date(dateParts[0], (dateParts[1] - 1) ,dateParts[2]); 
	                            	   var dateTime = date.getTime();
	                              	   var sumPaid = form.sumPaid.value;
	                            	   if(sumPaid < 0 ){
	                            		   if(startOfRefundPeriodTime != 0 && endOfRefundPeriodTime != 0){
		                            		   if(dateTime < startOfRefundPeriodTime || dateTime > endOfRefundPeriodTime){
		                            			   if(confirm(confirmMessage)){
		                            			      form.submit();
		                            			      return;
		                            			   }else{
		                            				   return;
		                            			   }
		                            		   }
		                            	   }
	                            	   }
                            	   }   
                            	   form.submit(); 
                            	   return;
                            }
                         </script>
                    </div>     
            </div>
        </div>
    </div>
        
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        //tp1.showPanel(<%//=request.getParameter("tab")%>);
        tp1.showPanel(0);
    </script>
</div>

<%@ include file="../../footer.jsp"%>

