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

    <sec:authorize access="hasRole('UPDATE_FEE_PAYMENTS')">
        <c:set var="updatePayments" value="${true}"/>
    </sec:authorize>
    
    <%@ include file="../../menu.jsp"%>
    <div id="tabcontent">
        <form>
            <fieldset><legend>
                <a href="<c:url value='/fee/paymentsstudents.view?currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
                <c:choose>
                    <c:when test="${student.surnameFull != null && student.surnameFull != ''}" >
                        <c:set var="studentLastname" value="${student.surnameFull}" scope="page" />
                        <c:set var="studentFirstname" value="${student.firstnamesFull}" scope="page" />
                        <c:set var="studentName" value="${studentLastname}, ${studentFirstname}" scope="page" />
                        <c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}" />
                    </c:when>
                </c:choose>
            </legend>
                <c:choose>        
                    <c:when test="${ not empty showPaymentError }">       
                        <p align="left" class="error">
                            ${showPaymentError}
                        </p>
                    </c:when>
                </c:choose>
                <c:choose>       
                <c:when test="${ not empty txtMsg }">       
                <p align="right" class="msg">
                    ${txtMsg}
                </p>
                 </c:when>
                </c:choose>
            
            </fieldset>
        </form>
        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.payments" /></li>               
            </ul>
            
            <div class="TabbedPanelsContentGroup">
                <div class="TabbedPanelsContent">
                
                    <div class="Accordion" id="Accordion0" tabindex="0">
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.payments" /></div>
                            <div class="AccordionPanelContent">

                                    <table>
                                    
                                    <sec:authorize access="hasRole('UPDATE_INSTITUTIONS')">
                                            <tr>
                                                <td class="label"><b><fmt:message key="jsp.general.university" /></b></td>
                                                <td >
                                                    <c:forEach var="oneInstitution" items="${allInstitutions}">
                                                       <c:choose>
                                                       <c:when test="${ oneInstitution.id == institutionId }"> 
                                                           ${oneInstitution.institutionDescription}
                                                        </c:when>
                                                       </c:choose>
                                                    </c:forEach>
                                                </td> 
                                                <td></td>
                                           </tr>
                                    </sec:authorize>     
                                      
                                    <sec:authorize access="hasAnyRole('UPDATE_BRANCHES','UPDATE_INSTITUTIONS')">
                                            <tr>
                                                <td class="label"><b><fmt:message key="jsp.general.branch" /></b></td>
                                                <td>
                                                    <c:forEach var="oneBranch" items="${allBranches}">
                                                        <c:choose>
                                                            <c:when test="${ oneBranch.id == branchId }"> 
                                                                ${oneBranch.branchDescription}
                                                            </c:when>
                                                        </c:choose>
                                                    </c:forEach>
                                                </td> 
                                                <td></td>
                                           </tr>
                                      </sec:authorize>        
                    
                                    
                                            <tr>
                                                <td class="label"><b><fmt:message key="jsp.general.organizationalunit" /></b></td>
                                                <td>
                                                    <c:forEach var="oneOrganizationalUnit" items="${allOrganizationalUnits}">
                                                        <c:choose>
                                                            <c:when test="${ oneOrganizationalUnit.id == organizationalUnitId }"> 
                                                                ${oneOrganizationalUnit.organizationalUnitDescription}
                                                            </c:when>
                                                        </c:choose>
                                                    </c:forEach>
                                                </td> 
                                                <td></td>
                                           </tr>
                                    
                                        <tr>
                                            <td class="label"><b><fmt:message key="jsp.general.primarystudy" /></b></td>
                                            <td>
                                                
                                                <c:forEach var="oneStudy" items="${allStudies}">
                                                    <c:choose>
                                                        <c:when test="${oneStudy.id == student.primaryStudyId}">
                                                            ${oneStudy.studyDescription}
                                                        </c:when>
                                                    </c:choose>
                                                </c:forEach>
                                            </td> 
                                            <td>                                              
                                            </td>
                                       </tr>
                                      
                                       <tr>
                                            <td class="label"><fmt:message key="jsp.general.studentcode" /></td>
                                            <td>${student.studentCode}</td>
                                            <td></td>
                                        </tr>
                                    
                                <tr><td colspan=3><br /><br /></td></tr>
                                 </table>
                                 

                            <!-- PAYMENTS -->
                                <c:set var="isCancelled" value="false" />
                                <c:forEach var="appliedFee" items="${allAppliedFees}">
                                    <c:set var="fee" value="${appliedFee.fee}" />
                                    <!-- cancellation fee already exist: don't show button -->
                                    <c:if test="${fee.categoryCode == 10}" >
                                    	<c:set var="isCancelled" value="true" />
                                    </c:if>
                                </c:forEach>
                               
                            
                                <table class="tabledata2" id="TblData_paymentsstudent">
	                                <tr>
	                                    <td colspan="2" >&nbsp;</td>
	                                    <td colspan="2" align="right"><a class="button" href="<c:url value='/fee/studentfee.view?tab=0&panel=0&studentId=${student.studentId}&currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.studentbalance.add" /></a></td>
	                                    <td  colspan="3" align="right">
	                                    <c:if test="${isCancelled == false }">
	                                    <a class="button" href="<c:url value='/fee/cancelstudentfee.view?tab=0&panel=0&studentId=${student.studentId}&currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.cancellationfee.add" /></a>
	                                    </c:if>
	                                    </td>
	                                    <td>&nbsp;</td>
	                                </tr>
                                       <c:set var="ctuOfPreviousFee" value="-1" />
                                       <c:set var="academicYearOfPreviousFee" value="0" />
                                       <c:set var="appliedFeesCounted" value="0" />
                                       <tr>
                                            <th><fmt:message key="jsp.general.academicyear" /></th>
                                            <th><fmt:message key="jsp.general.cardinaltimeunit" /></th>
                                            <th><fmt:message key="jsp.general.category" /></th>
                                            <th><fmt:message key="jsp.general.exemption" /></th>
                                            <th><fmt:message key="jsp.general.feedue" /></th>  
                                            <th><fmt:message key="jsp.general.sumpaid" /></th>
                                            <th><fmt:message key="jsp.payments.balance.outstanding" /></th>                                 
                                            <th>&nbsp;</th> 
                                            <sec:authorize access="hasRole('CREATE_FEE_PAYMENTS')">
                                                <th></th>
                                            </sec:authorize>
                                        </tr>

                                        <c:forEach var="appliedFee" items="${allAppliedFees}">
                                            
                                            <c:set var="fee" value="${appliedFee.fee}" />
                                            <c:set var="appliedFeesCounted" value="${appliedFeesCounted + 1}" />
                                            
                                               <c:set var="tSumPaid" value="0" scope="page" />  
                                               <c:if test="${(((appliedFee.academicYear.description != academicYearOfPreviousFee 
                                                || appliedFee.ctuNumber != ctuOfPreviousFee)
                                                && appliedFeesCounted != 1)
                                                )
                                                }">
                                                <tr>
                                                    <td colspan="3">&nbsp;</td>
                                                    <td class="label"><fmt:message key="jsp.general.totals" /></td>
                                                    <td>${totalAmount }</td><td>${totalAmountPaid }</td>
                                                    <td>
                                                    	<c:choose>
                                                    	<c:when test="${balanceBFwd >= 0 }">
                                                    		${totalAmount - totalAmountPaid }
                                                    	</c:when>
                                                    	<c:otherwise>
                                                    		${totalAmount -balanceBFwd - totalAmountPaid}
                                                    	</c:otherwise>
                                                    	</c:choose>
                                                    </td>
                                                </tr>   
                                                <tr><td colspan="7">&nbsp;</td></tr>
                                                <c:set var="totalAmount" value="0" scope="page" />
                                                <c:set var="totalAmountPaid" value="0" scope="page" />
                                                <c:set var="balanceBFwd" value="0" scope="page" />
                                                </c:if>
                                                <tr>
                                                     <td>
                                                       <c:if test="${appliedFee.academicYear.description != academicYearOfPreviousFee }">
                                                       ${appliedFee.academicYear.description }                                                       
                                                       </c:if>
                                                    </td>
                                                    <td>
                                                       <c:if test="${appliedFee.ctuNumber != ctuOfPreviousFee }">
                                                           ${appliedFee.ctuNumber }
                                                       </c:if>
                                                    </td>
                                                    
                                                    <td>
                                                        <c:forEach var="category" items="${allFeeCategories}">
                                                            <c:choose>
                                                                <c:when test="${category.code == fee.categoryCode}">
                                                                    ${category.description}
                                                                 </c:when>
                                                            </c:choose>
                                                        </c:forEach>  
                                                    </td>
                                                    <td width="100">
                                                    <c:choose>
                                                        <c:when test="${updatePayments}">
                                                            <a href="<c:url value='/fee/studentbalance.view?studentId=${student.studentId}&studentBalanceId=${appliedFee.studentBalanceId}&currentPageNumber=${currentPageNumber}'/>">${appliedFee.exemption}</a>&nbsp;(<fmt:message key="jsp.general.changeme" />)</td>    
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${appliedFee.exemption}
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <td>
                                                       <%-- ${appliedFee.discountedFeeDue} --%>
                                                       <c:set var="totalFee" value="${appliedFee.fee.feeDue + appliedFee.amount }" scope="page" />
                                                        ${totalFee}
                                                        <c:set var="totalAmount" value="${totalAmount + totalFee}" scope="page" />
                                                        
                                                    </td>
                                                    <td>
                                                        ${appliedFee.amountPaid}
                                                        <c:set var="totalAmountPaid" value="${totalAmountPaid + appliedFee.amountPaid}" scope="page" />
                                                    </td>
                                                    <c:if test="${fee.categoryCode == 9 }" >
                                                    	<c:set var="balanceBFwd" value="${totalAmount}" />
                                                    </c:if>
                                                    <td>
                                                        <table valign="top">
                                                        <c:forEach var="paymentForStudent" items="${allPaymentsForStudent}">
                                                            <c:choose>
                                                                <c:when test="${paymentForStudent.feeId == studentFeeForStudyGradeType.id && paymentForStudent.studentBalanceId == studentBalance.id}">
                                                                     <tr>
                                                                        <td>
                                                                            <fmt:formatDate pattern="dd/MM/yyyy" value="${paymentForStudent.payDate}" />
                                                                        </td>
                                                                        <td>
                                                                            ${paymentForStudent.sumPaid}
                                                                        </td>
                                                                        <td>
                                                                            <c:set var="tSumPaid" value="${tSumPaid + paymentForStudent.sumPaid}" scope="page" />
                                                                                   ${tSumPaid}
                                                                        </td>
                                                                        <td align="right">
                                                                        <a href="<c:url value='/fee/payment.view?studentId=${student.studentId}&feeId=${studentFeeForStudyGradeType.id}&paymentId=${paymentForStudent.id}&studyPlanCardinalTimeUnitId=${studentBalance.studyPlanCardinalTimeUnitId}&studentBalanceId=${studentBalance.id}&feeDue=${discountedFee.discountedFeeDue}&currentPageNumber=${currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" />
                                                                        </a>
                                                                        &nbsp;&nbsp;
                                                                        <a href="<c:url value='/fee/payment_delete.view?tab=0&panel=0&studentId=${student.studentId}&feeId=${studentFeeForStudyGradeType.id}&paymentId=${paymentForStudent.id}&currentPageNumber=${currentPageNumber}'/>" 
                                                                            onclick="return confirm('<fmt:message key="jsp.payments.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                                        </a>
                                                                        </td>
                                                                    </tr>
                                                                </c:when>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </table>
                                                    </td>
                                                    <sec:authorize access="hasRole('CREATE_FEE_PAYMENTS')">
                                                        <td>
                                                            <a class="button" href="<c:url value='/fee/payment.view?studentId=${student.studentId}&feeId=${appliedFee.fee.id}&studyPlanCardinalTimeUnitId=${appliedFee.studyPlanCardinalTimeUnitId}&studentBalanceId=${appliedFee.studentBalanceId}&feeDue=${appliedFee.discountedFeeDue}&currentPageNumber=${currentPageNumber}'/>">
                                                                <fmt:message key="jsp.href.add" />
                                                            </a>
                                                        </td>
                                                    </sec:authorize>
                                                </tr>
                                               
                                            <c:set var="academicYearOfPreviousFee" value="${appliedFee.academicYear.description}" scope="page"/> 
                                            <c:set var="ctuOfPreviousFee" value="${appliedFee.ctuNumber }" scope="page"/>                                      
                                        </c:forEach>
                                        <tr>
	                                        <td colspan="3">&nbsp;</td>
	                                        <td class="label"><fmt:message key="jsp.general.totals" /></td>
	                                        <td>${totalAmount }</td><td>${totalAmountPaid }</td>
											<td>
	                                        	<c:choose>
	                                        	<c:when test="${balanceBFwd >= 0 }">
	                                        		${totalAmount - totalAmountPaid }
	                                        	</c:when>
	                                        	<c:otherwise>
	                                        		${totalAmount -balanceBFwd - totalAmountPaid}
	                                        	</c:otherwise>
	                                        	</c:choose>
	                                        </td>
                                    	</tr>    
                             </table>
                            <script type="text/javascript">alternate('TblData_paymentsstudent',true)</script>
                            
                               
                            <!--  einde accordionpanelcontent -->
                            </div>
                        <!--  einde accordionpanel -->
                        </div>
                    
                    <!-- end of accordion 1 -->
                    </div>
                    <script type="text/javascript">
                        var Accordion0 = new Spry.Widget.Accordion("Accordion0",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });
                         var tp1 = new Spry.Widget.TabbedPanels("tp1");
                        tp1.showPanel(<%=request.getParameter("tab")%>);
                        Accordion<%=request.getParameter("tab")%>.defaultPanel = <%=request.getParameter("panel")%>;
                        Accordion<%=request.getParameter("tab")%>.openPanelNumber(<%=request.getParameter("panel")%>);
                    </script>
                <!--  einde tabbedpanelscontent -->
                </div>
                
            <!--  einde tabbed panelscontentgroup -->    
            </div>
            
        <!--  einde tabbed panel -->    
        </div>
        
    <!-- einde tabcontent -->
    </div>   
    

                                 
<!-- einde tabwrapper -->    
</div>

<%@ include file="../../footer.jsp"%>