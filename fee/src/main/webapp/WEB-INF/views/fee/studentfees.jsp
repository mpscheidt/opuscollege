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

<%@ include file="../header.jsp"%>

<body>
<div id="tabwrapper">
    <%@ include file="../menu.jsp"%>
	<div id="tabcontent">
	        <c:set var="studentName" value="${student.surnameFull}, ${student.firstnamesFull}" scope="request" />
			   <fieldset><legend>
			   
                 <a href="<c:url value='/college/student/personal.view?newForm=true&from=fees&tab=${navigationSettings.tab}&panel=${navigationSettings.panel}&studentId=${student.studentId}&searchValue=${navigationSettings.searchValue}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                	<c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}" />
                </a>&nbsp;>&nbsp;
				<fmt:message key="general.fees"/>                 
                  &nbsp;&nbsp;&nbsp;
                  <%--
                 <img src="<c:url value='/images/guest.gif' />" alt="<fmt:message key="jsp.general.report" />" title="<fmt:message key="jsp.general.report" />" /> 
                 <a href="<c:url value='/college/reports.view?reportName=person/student.pdf&where.student.studentId=${studentId}'/>" target="otherwindow">PDF</a>
                    --%>
            </legend>

				<form style="padding:10px" method="POST" name="mainForm" id="mainForm">
					<%--
					<table>
						<tr>
							<td><label><fmt:message key="jsp.general.studyplan"/></label></td>
							<td>
								<select name="studyPlanId" onchange="this.form.submit();">
									<c:forEach items="${studentFeesForm.allStudyPlans}" var="studyPlan">
										<c:choose>
											<c:when test="${studyPlanId != studyPlan.id}">
											<option value="${studyPlan.id}" >${studyPlan.studyPlanDescription}</option>
											</c:when>
											<c:otherwise>
												<option value="${studyPlan.id}" selected="selected">${studyPlan.studyPlanDescription}</option>
											</c:otherwise>
										</c:choose>
										
									</c:forEach>
								</select>
								</td>
						</tr>
						
						<tr>
							<td><label><fmt:message key="jsp.general.academicyear"/></label></td>
							<td>
								<select name="academicYearId" onchange="this.form.submit();">
									<c:forEach items="${studentFeesForm.allAcademicYears}" var="academicYear">
										<c:choose>
											<c:when test="${academicYearId != academicYear.id}">
											<option value="${academicYear.id}" >${academicYear.description}</option>
											</c:when>
											<c:otherwise>
												<option value="${academicYear.id}" selected="selected">${academicYear.description}</option>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</select>
								</td>
						</tr>
					</table>
				--%>
				</form>            
            
            </fieldset>
		
		<div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="general.fees" /></li>               
            </ul>
            
            <div class="TabbedPanelsContentGroup">
                <div class="TabbedPanelsContent">
                
                    <div class="Accordion" id="Accordion0" tabindex="0">
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="general.fees" /></div>
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
                    
                                    <sec:authorize access="hasAnyRole('READ_PRIMARY_AND_CHILD_ORG_UNITS','UPDATE_ORG_UNITS','UPDATE_BRANCHES','UPDATE_INSTITUTIONS')">
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
                                    </sec:authorize>
                					<c:choose>
                    					<c:when test="${opusUserRole.role != 'student'}">
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
                                      </c:when>
                                      </c:choose>
                                       <tr>
                                            <td class="label"><fmt:message key="jsp.general.studentcode" /></td>
                                            <td>${student.studentCode}</td>
                                            <td></td>
                                        </tr>
  									 <tr>
                                          <td class="label"><b><fmt:message key="jsp.general.totalfeesonsubjectstudygradetypes" /></b></td>
                                          <td>${totalFeesAmountForSubjectStudyGradeTypes}</td>
                                     </tr>
                                     <c:if test="${appUseOfSubjectBlocks == 'Y'}">
										 <tr>
	                                          <td class="label"><b><fmt:message key="jsp.general.totalfeesonsubjectblockstudygradetypes" /></b></td>
	                                          <td>${totalFeesAmountForSubjectBlockStudyGradeTypes}</td>
	                                     </tr>
                                     </c:if>
									 <tr>
                                          <td class="label"><b><fmt:message key="jsp.general.totalfeesonstudygradetypes" /></b></td>
                                          <td>${totalFeesAmountForStudyGradeTypes}</td>
                                     </tr>  
									 <tr>
                                          <td class="label"><b><fmt:message key="jsp.general.totalfeesonacademicyears" /></b></td>
                                          <td>${totalFeesAmountForAcademicYears}</td>
                                     </tr>  
                                <tr><td colspan=3><br /><br /></td></tr>
                                 </table>
                                 

                            <!-- PAYMENTS -->
                                <table>
                                   

     	                                <tr>
                                            <td colspan="11">
                                        <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                                        <table class="tabledata2" id="TblData_subjectblockstudygradetype">
                                        <!-- SUBJECTBLOCKSTUDYGRADETYPES -->
                                        
                                        <tr>
                                            <th colspan="11" class="header">
                                               <br />
                                               <fmt:message key="jsp.general.subjectblock" />
                                            </th>
                                        </tr>
                                        <tr>
                                            <th><fmt:message key="general.deadline" /></th>
                                            <th><fmt:message key="jsp.general.feedue" /></th>
                                            <th><fmt:message key="jsp.general.subjectblock" /></th>
                                            <th><fmt:message key="jsp.general.active" /></th> 
                                            <th><fmt:message key="jsp.general.studyplan" /></th>
                                            <th><fmt:message key="jsp.general.cardinaltimeunit.number" /></th>                                        
                                            <th><fmt:message key="jsp.general.exemption" /></th>                                        
                                            <th><fmt:message key="jsp.general.paydate" /> /
                                                <fmt:message key="jsp.general.sumpaid" /> /
                                                <fmt:message key="jsp.general.totalsumpaid" /></th> 
                                            <th></th>
                                        </tr>

						                <c:set var="lastStudyGradeTypeId" value="0" scope="page" />	                                
                                         <c:forEach var="discountedFee" items="${studentFeesForm.allStudentFeesForSubjectBlockStudyGradeTypes}">
                                            <c:set var="studentFeeForSubjectBlockStudyGradeType" value="${discountedFee.fee}" />
               							    <c:forEach var="studentBalance" items="${allStudentBalances}">
                                            <c:choose>
                                               <c:when test="${studentFeeForSubjectBlockStudyGradeType.id == studentBalance.feeId}">
                                                  <c:if test="${studentFeeForSubjectBlockStudyGradeType.studyGradeTypeId != lastStudyGradeTypeId}">
				                                         <c:set var="lastStudyGradeTypeId" value="${studentFeeForSubjectBlockStudyGradeType.studyGradeTypeId}" scope="page" />
                                                  </c:if>
			                                       <c:set var="tSumPaid" value="0" scope="page" />
	                                               <tr>
	                                                <td>
	                                                    <c:forEach items="${studentFeeForSubjectBlockStudyGradeType.deadlines}" var="feeDeadline">
                                                    			 <fmt:formatDate pattern="dd/MM/yyyy" value="${feeDeadline.deadline}" />
                                                    			<br/>
                                                    		</c:forEach>
	                                                </td>
	                                                <td>
	                                                    ${studentFeeForSubjectBlockStudyGradeType.feeDue}
	                                                </td>
	                                                <td width="200">
	                                                    <c:forEach var="subjectBlockStudyGradeType" items="${allSubjectBlockStudyGradeTypes}">
	                                                        <c:choose>
	                                                            <c:when test="${subjectBlockStudyGradeType.id == studentFeeForSubjectBlockStudyGradeType.subjectBlockStudyGradeTypeId}">
	                                                                ${subjectBlockStudyGradeType.subjectBlock.subjectBlockDescription}
				                                                    <c:forEach var="academicYear" items="${studentFeesForm.allAcademicYears}">
				                                                        <c:choose>
				                                                            <c:when test="${academicYear.id == subjectBlockStudyGradeType.subjectBlock.currentAcademicYearId}">
				                                                                &nbsp;(${academicYear.description})
				                                                            </c:when>
				                                                        </c:choose>
				                                                    </c:forEach>
	                                                            </c:when>
	                                                        </c:choose>
	                                                    </c:forEach>
	                                                </td>
	                                                <td>
	                                                    ${studentFeeForSubjectBlockStudyGradeType.active}
	                                                </td>
                                                    <td>
                                                       <c:forEach var="studyPlanDetail" items="${studentFeesForm.allStudyPlanDetails}">
                                           					<c:choose>
                                               					<c:when test="${studyPlanDetail.id == studentBalance.studyPlanDetailId}">
				                                                    <c:forEach var="studyPlan" items="${studentFeesForm.allStudyPlans}">
				                                                        <c:choose>
				                                                            <c:when test="${studyPlan.id == studyPlanDetail.studyPlanId}">
				                                                                ${studyPlan.studyPlanDescription}
				                                                            </c:when>
				                                                        </c:choose>
				                                                    </c:forEach>
				                                                 </c:when>
				                                            </c:choose>
				                                        </c:forEach>            
                                                    </td>
	                                                <td>
	                                                    <c:forEach var="subjectBlockStudyGradeType" items="${allSubjectBlockStudyGradeTypes}">
	                                                        <c:choose>
	                                                            <c:when test="${subjectBlockStudyGradeType.id == studentFeeForSubjectBlockStudyGradeType.subjectBlockStudyGradeTypeId}">
				                                                    ${subjectBlockStudyGradeType.cardinalTimeUnitNumber}
	                                                            </c:when>
	                                                        </c:choose>
	                                                    </c:forEach>
	                                                </td>                                                    
                                                    <td width="100">${studentBalance.exemption}</td>
	                                                <td>
	                                                    <table valign="top">
	                                                    <c:forEach var="paymentForStudent" items="${allPaymentsForStudent}">
	                                                        <c:choose>
	                                                            <c:when test="${paymentForStudent.feeId == studentFeeForSubjectBlockStudyGradeType.id && paymentForStudent.studentBalanceId == studentBalance.id}">
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
                                                                             </script>    
		                                                                </td>
		                                                                <td align="right">
		                                                                <a href="<c:url value='/fee/payment.view?studentId=${student.studentId}&feeId=${studentFeeForSubjectBlockStudyGradeType.id}&paymentId=${paymentForStudent.id}&studyPlanDetailId=${studentBalance.studyPlanDetailId}&studentBalanceId=${studentBalance.id}&feeDue=${studentFeeForSubjectBlockStudyGradeType.feeDue}&currentPageNumber=${currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" />
		                                                                </a>
		                                                                &nbsp;&nbsp;
		                                                                <a href="<c:url value='/fee/payment_delete.view?tab=0&panel=0&studentId=${student.studentId}&feeId=${studentFeeForSubjectBlockStudyGradeType.id}&paymentId=${paymentForStudent.id}&currentPageNumber=${currentPageNumber}'/>" 
		                                                                    onclick="return confirm('<fmt:message key="jsp.payments.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
		                                                                </a>
		                                                                </td>
		                                                            </tr>
	                                                            </c:when>
	                                                        </c:choose>
	                                                    </c:forEach>
	                                                </table>
	                                                </td>
	                                            </tr>
	                                            <tr>
                                                    <td colspan="5">&nbsp;<td>
                                                    <td colspan="2">
                                                    <p align="right" class="tablecellmsg">
	                                                <c:choose>
	                                                    <c:when test="${tSumPaid >  studentFeeForSubjectBlockStudyGradeType.feeDue} " >
	                                                             <fmt:message key="jsp.general.payments.toomuch" />
	                                                    </c:when>
	                                                    <c:otherwise>
	                                                        <fmt:message key="jsp.general.restpayment" />: 
                                                                         <script type="text/javascript">
                                                                                   ${studentFeeForSubjectBlockStudyGradeType.feeDue - tSumPaid}
                                                                         </script>    	                                                        
	                                                    </c:otherwise>
	                                                </c:choose>
	                                                </p>
	                                                </td>
	                                            </tr>
                                               </c:when>
	                                           </c:choose>
	                                        </c:forEach>	                                            
                                        </c:forEach>
                                    </table>
                                         
                            <script type="text/javascript">alternate('TblData_subjectblockstudygradetype',true)</script>
                               </c:if>
                               </td></tr></table>
                                <table class="tabledata2" id="TblData_paymentsstudent">
                               <!-- SUBJECTSTUDYGRADETYPES -->
                               <tr>
                                    <td class="header" colspan="8">
                                    <br />
                                    <fmt:message key="jsp.general.subject" />
                                    </td>
                               </tr>
                                    <tr>
                                        <th><fmt:message key="jsp.general.deadline" /></th>
                                        <th><fmt:message key="jsp.general.feedue" /></th>
                                        <th><fmt:message key="jsp.general.subject" /></th>
                                        <th><fmt:message key="jsp.general.active" /></th> 
                                        <th><fmt:message key="jsp.general.studyplan" /></th>
                                        <th><fmt:message key="jsp.general.cardinaltimeunit.number" /></th>                                        
                                        <th><fmt:message key="jsp.general.exemption" /></th>                                        
                                        <th><fmt:message key="jsp.general.paydate" /> /
                                            <fmt:message key="jsp.general.sumpaid" /> /
                                            <fmt:message key="jsp.general.totalsumpaid" /></th> 
                                        <th></th>
                                    </tr>
						                <c:set var="lastStudyGradeTypeId" value="0" scope="page" />                               
                                        <c:forEach var="discountedFee" items="${studentFeesForm.allStudentFeesForSubjectStudyGradeTypes}">
                                            <c:set var="studentFeeForSubjectStudyGradeType" value="${discountedFee.fee}" />
                                            <c:forEach var="studentBalance" items="${allStudentBalances}">
                                            <c:choose>

                                               <c:when test="${studentFeeForSubjectStudyGradeType.id == studentBalance.feeId}">
                                                    <c:if test="${studentFeeForSubjectStudyGradeType.studyGradeTypeId != lastStudyGradeTypeId}">
                            					             <c:set var="lastStudyGradeTypeId" value="${studentFeeForSubjectStudyGradeType.studyGradeTypeId}" scope="page" />
		                                             </c:if>
                                                  <c:set var="tSumPaid" value="0" scope="page" />
	                                               <tr>
	                                                <td>
	                                                    <c:forEach items="${studentFeeForSubjectStudyGradeType.deadlines}" var="feeDeadline">
                                                    			<fmt:formatDate pattern="dd/MM/yyyy" value="${feeDeadline.deadline}" />
                                                    			<br/>
                                                    		</c:forEach>
	                                                </td>
	                                                <td>
	                                                    ${studentFeeForSubjectStudyGradeType.feeDue}
	                                                </td>
	                                                <td width="200">
	                                                    <c:forEach var="subjectStudyGradeType" items="${allSubjectStudyGradeTypes}">
	                                                        <c:choose>
	                                                            <c:when test="${subjectStudyGradeType.id == studentFeeForSubjectStudyGradeType.subjectStudyGradeTypeId}">
	                                                                ${subjectStudyGradeType.subject.subjectDescription}
				                                                    <c:forEach var="academicYear" items="${studentFeesForm.allAcademicYears}">
				                                                        <c:choose>
				                                                            <c:when test="${academicYear.id == subjectStudyGradeType.subject.currentAcademicYearId}">
				                                                                &nbsp;(${academicYear.description})
				                                                            </c:when>
				                                                        </c:choose>
				                                                    </c:forEach>	                                                                
	                                                            </c:when>
	                                                        </c:choose>
	                                                    </c:forEach>
	                                                </td>
	                                                <td>
	                                                    ${studentFeeForSubjectStudyGradeType.active}
	                                                </td>
                                                   <td>
                                                       <c:forEach var="studyPlanDetail" items="${studentFeesForm.allStudyPlanDetails}">
                                           					<c:choose>
                                               					<c:when test="${studyPlanDetail.id == studentBalance.studyPlanDetailId}">
				                                                    <c:forEach var="studyPlan" items="${studentFeesForm.allStudyPlans}">
				                                                        <c:choose>
				                                                            <c:when test="${studyPlan.id == studyPlanDetail.studyPlanId}">
				                                                                ${studyPlan.studyPlanDescription}
				                                                            </c:when>
				                                                        </c:choose>
				                                                    </c:forEach>
				                                                 </c:when>
				                                            </c:choose>
				                                        </c:forEach>            
                                                    </td>	                                                
 	                                                <td>
	                                                    <c:forEach var="subjectStudyGradeType" items="${allSubjectStudyGradeTypes}">
	                                                        <c:choose>
	                                                            <c:when test="${subjectStudyGradeType.id == studentFeeForSubjectStudyGradeType.subjectStudyGradeTypeId}">
				                                                    ${subjectStudyGradeType.cardinalTimeUnitNumber}
	                                                            </c:when>
	                                                        </c:choose>
	                                                    </c:forEach>
	                                                </td>                                                      
                                                    <td width="100">${studentBalance.exemption}</td>                                                    
	                                                <td>
	                                                    <table valign="top">
	                                                    <c:forEach var="paymentForStudent" items="${allPaymentsForStudent}">
	                                                        <c:choose>
	                                                            <c:when test="${paymentForStudent.feeId == studentFeeForSubjectStudyGradeType.id && paymentForStudent.studentBalanceId == studentBalance.id}">
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
		                                                                <a href="<c:url value='/fee/payment.view?studentId=${student.studentId}&feeId=${studentFeeForSubjectStudyGradeType.id}&paymentId=${paymentForStudent.id}&studyPlanDetailId=${studentBalance.studyPlanDetailId}&studentBalanceId=${studentBalance.id}&feeDue=${studentFeeForSubjectStudyGradeType.feeDue}&currentPageNumber=${currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" />
		                                                                </a>
		                                                                &nbsp;&nbsp;
		                                                                <a href="<c:url value='/fee/payment_delete.view?tab=0&panel=0&studentId=${student.studentId}&feeId=${studentFeeForSubjectStudyGradeType.id}&paymentId=${paymentForStudent.id}&currentPageNumber=${currentPageNumber}'/>" 
		                                                                    onclick="return confirm('<fmt:message key="jsp.payments.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
		                                                                </a>
		                                                                </td>
		                                                            </tr>
	                                                            </c:when>
	                                                        </c:choose>
	                                                    </c:forEach>
	                                                </table>
	                                                </td>
	                                            </tr>
	                                            <tr>
                                                    <td colspan="5">&nbsp;<th>
                                                    <td colspan="2">
                                                    <p align="right" class="tablecellmsg">
	                                                <c:choose>
	                                                    <c:when test="${tSumPaid >  studentFeeForSubjectStudyGradeType.feeDue} " >
	                                                             <fmt:message key="jsp.general.payments.toomuch" />
	                                                    </c:when>
	                                                    <c:otherwise>
	                                                        <fmt:message key="jsp.general.restpayment" />: 
                                                                         ${studentFeeForSubjectStudyGradeType.feeDue - tSumPaid}
		                                                    </c:otherwise>
	                                                </c:choose>
                                                    </p>
                                                    </th>
	                                            </tr>
                                               </c:when>
	                                           </c:choose>
	                                        </c:forEach>	                                            
                                        </c:forEach>
                                     
                                    <!-- STUDYGRADETYPES --> 
                                    <tr>
                                    	<td class="header" colspan="8">
                                    	<br />
                                    	<fmt:message key="jsp.general.studygradetype" />
                                    	</td>
                               		</tr> 
                                    <tr>
                                        <th><fmt:message key="jsp.general.deadline" /></th>
                                        <th><fmt:message key="jsp.general.feedue" /></th>
                                        <th><fmt:message key="jsp.general.active" /></th> 
                                        <th><fmt:message key="jsp.general.studyplan" /></th>
                                        <th><fmt:message key="jsp.general.category" /></th>
                                        <th><fmt:message key="jsp.general.exemption" /></th> 
                                        <th>&nbsp;</th>                                        
                                        <th><fmt:message key="jsp.general.paydate" /> / 
                                            <fmt:message key="jsp.general.sumpaid" /> / 
                                            <fmt:message key="jsp.general.totalsumpaid" /></th> 
                                        <th></th>
                                    </tr>
           								<c:set var="lastStudyGradeTypeId" value="0" scope="page" />  
                                         <c:forEach var="discountedFee" items="${studentFeesForm.allStudentFeesForStudyGradeTypes}">
                                            <c:set var="studentFeeForStudyGradeType" value="${discountedFee.fee}" />
                                            <c:forEach var="studentBalance" items="${allStudentBalances}">
                                            <c:choose>
                                               <c:when test="${studentFeeForStudyGradeType.id == studentBalance.feeId}">
                                               <c:set var="tSumPaid" value="0" scope="page" />
                                               <c:if test="${studentFeeForStudyGradeType1.studyGradeTypeId != lastStudyGradeTypeId}">
                                                    <c:set var="lastStudyGradeTypeId" value="${studentFeeForStudyGradeType.studyGradeTypeId}" scope="page" />
                                               	</c:if>	  
	                                            <tr>
	                                                <td>
	                                                    <c:forEach items="${studentFeeForStudyGradeType.deadlines}" var="feeDeadline">
                                                    			<fmt:formatDate pattern="dd/MM/yyyy" value="${feeDeadline.deadline}" />
                                                    			<br/>
                                                    		</c:forEach>
	                                                </td>
	                                                <td>
	                                                    ${studentFeeForStudyGradeType.feeDue}
	                                                </td>
	                                                <td>
	                                                    ${studentFeeForStudyGradeType.active}
	                                                </td>
                                                    <td>
                                                       <c:forEach var="studyPlan" items="${studentFeesForm.allStudyPlans}">
                                           					<c:forEach var="studyPlanCardinalTimeUnit" items="${studentFeesForm.allStudyPlanCardinalTimeUnits}">
                                           					<c:choose>
                                               					<c:when test="${studyPlanCardinalTimeUnit.id == studentBalance.studyPlanCardinalTimeUnitId && studyPlanCardinalTimeUnit.studyPlanId == studyPlan.id}">
	                                                                ${studyPlan.studyPlanDescription}
			          												<c:forEach var="studyGradeType" items="${allStudyGradeTypes}">
			                                           					<c:choose>
			                                               					<c:when test="${studyGradeType.id == studentFeeForStudyGradeType.studyGradeTypeId}">
							                                                    <c:forEach var="academicYear" items="${studentFeesForm.allAcademicYears}">
							                                                        <c:choose>
							                                                            <c:when test="${academicYear.id == studyGradeType.currentAcademicYearId}">
							                                                                &nbsp;(${academicYear.description})
							                                                            </c:when>
							                                                        </c:choose>
							                                                    </c:forEach>
							                                                 </c:when>
							                                            </c:choose>
							                                        </c:forEach>				                                                                
				                                                 </c:when>
				                                            </c:choose>
				                                        </c:forEach>
                                                      </c:forEach>  				                                                    
                                                    </td>
                                                    <td>
                                                        <c:forEach var="category" items="${studentFeesForm.allFeeCategories}">
                                           					<c:choose>
                                               					<c:when test="${category.code == studentFeeForStudyGradeType.categoryCode}">
																	${category.description}
				                                                 </c:when>
				                                            </c:choose>
				                                        </c:forEach>  
                                                    </td>
                                                     <td width="100">${studentBalance.exemption}</td>
	                                                <td>&nbsp;</td>
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
		                                                                <a href="<c:url value='/fee/payment.view?studentId=${student.studentId}&feeId=${studentFeeForStudyGradeType.id}&paymentId=${paymentForStudent.id}&studyPlanCardinalTimeUnitId=${studentBalance.studyPlanCardinalTimeUnitId}&studentBalanceId=${studentBalance.id}&feeDue=${studentFeeForStudyGradeType.feeDue}&currentPageNumber=${currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" />
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
	                                            </tr>
	                                            <tr>
                                                    <td colspan="5">&nbsp;<td>
                                                    <td colspan="2">
                                                    <p align="right" class="tablecellmsg">	                                            
 	                                                <c:choose>
	                                                    <c:when test="${tSumPaid >  studentFeeForStudyGradeType.feeDue} " >
	                                                             <fmt:message key="jsp.general.payments.toomuch" />
	                                                    </c:when>
	                                                    <c:otherwise>
	                                                        <fmt:message key="jsp.general.restpayment" />: 
                                                                       ${studentFeeForStudyGradeType.feeDue - tSumPaid}
	                                                    </c:otherwise>
	                                                </c:choose>
	                                                </p>
	                                                </td>
	                                            </tr>
                                               </c:when>
	                                           </c:choose>
	                                        </c:forEach>	                                            
                                        </c:forEach>
                                    
                                    <!-- ON BRANCH LEVEL --> 
                                    <tr>
                                    	<td class="header" colspan="8">
                                    	<br />
                                    	<fmt:message key="jsp.general.branch" />
                                    	</td>
                               		</tr> 
                                    <tr>
                                        <th><fmt:message key="jsp.general.deadline" /></th>
                                        <th><fmt:message key="jsp.general.feedue" /></th>
                                        <th><fmt:message key="jsp.general.active" /></th> 
                                        <th><fmt:message key="jsp.general.academicyear" /></th>
                                        <th><fmt:message key="jsp.general.category" /></th>
                                        <th><fmt:message key="jsp.general.exemption" /></th>
                                        <th>&nbsp;</th>
                                        <th><fmt:message key="jsp.general.paydate" /> /
                                            <fmt:message key="jsp.general.sumpaid" /> /
                                            <fmt:message key="jsp.general.totalsumpaid" /></th> 
                                        <th></th>
                                    </tr>
                                         <c:forEach var="discountedFee" items="${studentFeesForm.allStudentFeesForAcademicYears}">
                                            <c:set var="studentFeeForAcademicYear" value="${discountedFee.fee}" />
                                            <c:forEach var="studentBalance" items="${allStudentBalances}">
                                            <c:choose>
                                               <c:when test="${studentFeeForAcademicYear.id == studentBalance.feeId}">
                                               <c:set var="tSumPaid" value="0" scope="page" />
	                                           <c:if test="${studentFeeForAcademicYear.academicYearId != lastStudyGradeTypeId}">
		                                         <c:set var="lastStudyGradeTypeId" value="${studentFeeForAcademicYear.academicYearId}" scope="page" />
	                                             </c:if>
	                                            <tr>
	                                                <td>
	                                                	<c:forEach items="${studentFeeForAcademicYear.deadlines}" var="feeDeadline">
                                                    			 <fmt:formatDate pattern="dd/MM/yyyy" value="${feeDeadline.deadline}" />
                                                    			<br/>
                                                    		</c:forEach>
	                                                </td>
	                                                <td>
	                                                    ${studentFeeForAcademicYear.feeDue}
	                                                </td>
	                                                <td>
	                                                    ${studentFeeForAcademicYear.active}
	                                                </td>
                                                    <td>
                                                       <c:forEach var="academicYear" items="${studentFeesForm.allAcademicYears}">
                                           					<c:choose>
                                               					<c:when test="${studentFeeForAcademicYear.academicYearId == academicYear.id}">
																	${academicYear.description}
				                                                 </c:when>
				                                            </c:choose>
				                                        </c:forEach>            
                                                    </td>
                                                    <td>
                                                        <c:forEach var="category" items="${studentFeesForm.allFeeCategories}">
                                           					<c:choose>
                                               					<c:when test="${category.code == studentFeeForAcademicYear.categoryCode}">
																	${category.description}
				                                                 </c:when>
				                                            </c:choose>
				                                        </c:forEach>       
                                                    </td>
                                                    <td width="100">${studentBalance.exemption}</td>
                                                    <td>&nbsp;</td>
	                                                <td>
	                                                    <table valign="top">
	                                                    <c:forEach var="paymentForStudent" items="${allPaymentsForStudent}">
	                                                        <c:choose>
	                                                            <c:when test="${paymentForStudent.feeId == studentFeeForAcademicYear.id && paymentForStudent.studentBalanceId == studentBalance.id}">
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
		                                                                <a href="<c:url value='/fee/payment.view?studentId=${student.studentId}&feeId=${studentFeeForAcademicYear.id}&paymentId=${paymentForStudent.id}&studentBalanceId=${studentBalance.id}&feeDue=${studentFeeForAcademicYear.feeDue}&currentPageNumber=${currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" />
		                                                                </a>
		                                                                &nbsp;&nbsp;
		                                                                <a href="<c:url value='/fee/payment_delete.view?tab=0&panel=0&studentId=${student.studentId}&feeId=${studentFeeForAcademicYear.id}&paymentId=${paymentForStudent.id}&currentPageNumber=${currentPageNumber}'/>" 
		                                                                    onclick="return confirm('<fmt:message key="jsp.payments.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
		                                                                </a>
		                                                                </td>
		                                                            </tr>
	                                                            </c:when>
	                                                        </c:choose>
	                                                    </c:forEach>
	                                                </table>
	                                                </td>
	                                            </tr>
	                                            <tr>
                                                    <td colspan="5">&nbsp;<td>
                                                    <td colspan="2">
	                                                <p align="right" class="tablecellmsg">
	                                                <c:choose>
	                                                    <c:when test="${tSumPaid >  studentFeeForAcademicYear.feeDue} " >
	                                                             <fmt:message key="jsp.general.payments.toomuch" />
	                                                    </c:when>
	                                                    <c:otherwise>
	                                                        <fmt:message key="jsp.general.restpayment" />: 
                                                                        ${studentFeeForAcademicYear.feeDue - tSumPaid}
	                                                    </c:otherwise>
	                                                </c:choose>
	                                                </p>
	                                                </td>
	                                            </tr>
                                               </c:when>
	                                           </c:choose>
	                                        </c:forEach>	                                            
                                        </c:forEach>
                                     <tr><td colspan="8">&nbsp;</td></tr>                                                                                                            
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
                        tp1.showPanel(0);
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

<%@ include file="../footer.jsp"%>

