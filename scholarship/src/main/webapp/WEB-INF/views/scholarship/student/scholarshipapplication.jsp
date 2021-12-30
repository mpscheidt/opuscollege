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

<%@ include file="../../includes/javascriptfunctions.jsp"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<body>

<div id="tabwrapper">

<%@ include file="../../menu.jsp"%>

<sec:authorize access="hasAnyRole('CREATE_SCHOLARSHIPS', 'UPDATE_SCHOLARSHIPS')">
    <c:set var="editScholarships" value="${true}"/>
</sec:authorize>

<%--    <spring:bind path="command.scholarshipStudentId">
        <c:set var="scholarshipStudentId" value="${status.value}" scope="page" />
    </spring:bind> --%>    
<c:set var="scholarshipStudentId" value="${scholarshipApplicationForm.scholarshipApplication.scholarshipStudentId}" scope="page" />

<%--    <spring:bind path="command.id">
        <c:set var="scholarshipApplicationId" value="${status.value}" scope="page" />
    </spring:bind> --%>    
<c:set var="scholarshipApplicationId" value="${scholarshipApplicationForm.scholarshipApplication.id}" scope="page" />

<c:set var="navigationSettings" value="${scholarshipApplicationForm.navigationSettings}" scope="page" />


<div id="tabcontent">       
        
<fieldset><legend>
    <a href="<c:url value='/scholarship/scholarshipapplications.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
        <a href="<c:url value='/scholarship/scholarshipstudent.view?tab=${navigationSettings.tab}&panel=${navigationSettings.panel}&studentId=${scholarshipApplicationForm.student.studentId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
        <c:choose>
            <c:when test="${scholarshipApplicationForm.student.surnameFull != null && scholarshipApplicationForm.student.surnameFull != ''}" >
                <c:set var="studentName" value="${scholarshipApplicationForm.student.surnameFull}, ${scholarshipApplicationForm.student.firstnamesFull}" scope="page" />
                ${fn:substring(studentName,0,initParam.iTitleLength)}
            </c:when>
            <c:otherwise>
                <fmt:message key="jsp.href.new" />
            </c:otherwise>
        </c:choose>
        </a>
<%--        <br />&nbsp;&nbsp;&nbsp;>&nbsp;
        <spring:bind path="scholarshipApplicationForm.scholarshipApplication.scholarshipAppliedForId">
        <c:choose>
            <c:when test="${status.value != null && status.value != ''}" >
                <c:forEach var="scholarship" items="${scholarshipApplicationForm.allScholarships}">
                    <c:choose>
                       <c:when test="${scholarship.id == status.value}">
                           <c:forEach var="scholarshipType" items="${scholarshipApplicationForm.allScholarshipTypes}">
                               
                               <c:choose>
                                   <c:when test="${scholarship.scholarshipType.code == scholarshipType.code}">
                                        <c:forEach var="academicYear" items="${scholarshipApplicationForm.allAcademicYears}">
                                            <c:choose>
                                                <c:when test="${academicYear.id == scholarship.academicYearId}">
                                                       <c:set var="academicYearDescription"  value="${academicYear.description}" scope="page" />
                                                </c:when>
                                            </c:choose>
                                        </c:forEach>      
                                        <c:set var="scholarshipAppDescription"  value="${scholarshipType.description} - ${academicYearDescription}" scope="page" />
                                       ${fn:substring(scholarshipAppDescription,0,initParam.iTitleLength)}
                                       </c:when>
                                   </c:choose>
                               </c:forEach>
                           </c:when>
                        </c:choose>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <fmt:message key="jsp.href.new" />
                </c:otherwise>
            </c:choose>
            </spring:bind> --%>
            &nbsp;>&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.scholarshipapplication" /> 
    </legend>
</fieldset>

<div id="tp1" class="TabbedPanel">
    <ul class="TabbedPanelsTabGroup">
        <li class="TabbedPanelsTab"><fmt:message key="jsp.general.scholarshipapplication"/></li>
    </ul>   

    <div class="TabbedPanelsContentGroup">

    <!-- student tab -->    
    <div class="TabbedPanelsContent">

        <div class="Accordion" id="Accordion0" tabindex="0">
                
            <div class="AccordionPanel">
                <div class="AccordionPanelTab">
                    <fmt:message key="jsp.general.scholarshipapplication" />
                </div><!-- Title -->
                <div class="AccordionPanelContent">


			    <form id="scholarshipapplicationdata" name="scholarshipapplicationdata" method="POST">
                    <input type="hidden" name="tab" value="${tab}" /> 
                    <input type="hidden" name="panel" value="${panel}" />
			
				    <table>
				    
			            <!-- The scholarship and type of scholarship the student applied for -->        
			            <spring:bind path="scholarshipApplicationForm.scholarshipApplication.scholarshipAppliedForId">
                        <tr>
			                <td class="label"><fmt:message key="scholarship.appliedfor" /></td>
			                <td class="required">
			                    <select name="${status.expression}" id="${status.expression}"> 
			                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
			                          <c:forEach var="scholarship" items="${scholarshipApplicationForm.allScholarships}">
                                          <c:choose>
                                               <c:when test="${scholarship.id == status.value}"> 
                                                <option value="${scholarship.id}" selected="selected">
                                                ${scholarship.description} -
                                                <c:forEach var="scholarshipType" items="${scholarshipApplicationForm.allScholarshipTypes}">
                                                   <c:choose>
                                                        <c:when test="${scholarship.scholarshipType.code == scholarshipType.code}">
                                                            ${scholarshipType.description} - 
                                                            <c:forEach var="academicYear" items="${scholarshipApplicationForm.allAcademicYears}">
                                                                <c:choose>
                                                                <c:when test="${academicYear.id == scholarship.sponsor.academicYearId}">
                                                                    ${academicYear.description}
                                                                </c:when>
                                                                </c:choose>
                                                            </c:forEach>
                                                        </c:when>
                                                    </c:choose>  
                                                </c:forEach>
                                                </option>
                                               </c:when>
                                               <c:otherwise>
                                                <option value="${scholarship.id}">
                                                ${scholarship.description} -
                                                <c:forEach var="scholarshipType" items="${scholarshipApplicationForm.allScholarshipTypes}">
                                                   <c:choose>
                                                        <c:when test="${scholarship.scholarshipType.code == scholarshipType.code }">
                                                            ${scholarshipType.description} 
                                                            <c:forEach var="academicYear" items="${scholarshipApplicationForm.allAcademicYears}">
                                           						<c:choose>
				                           							<c:when test="${academicYear.id == scholarship.sponsor.academicYearId}">
				                           								- ${academicYear.description}
				                           							</c:when>
				                           						</c:choose>
                           									</c:forEach>
                                                        </c:when>
                                                   </c:choose>
                                                </c:forEach>
                                                </option>
                                               </c:otherwise>
                                           </c:choose>
			                          </c:forEach>
			                    </select>
			                </td>
			                <td>
			                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
			                </td>
			                
			            </tr>
			            </spring:bind>
			            <c:if test="${editScholarships }" >
			            <spring:bind path="scholarshipApplicationForm.scholarshipApplication.scholarshipGrantedId">
                        <tr>
			                <td class="label"><fmt:message key="scholarship.granted" /></td>
			                    <!-- Is the scholarship granted to the student -->
			                 <td>
			                    <select name="${status.expression}" id="${status.expression}"> 
			                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                      <c:forEach var="scholarship" items="${scholarshipApplicationForm.allScholarships}">
                                          <c:choose>
                                               <c:when test="${scholarship.id == status.value}"> 
                                                <option value="${scholarship.id}" selected="selected">
                                                ${scholarship.description} -
                                                <c:forEach var="scholarshipType" items="${scholarshipApplicationForm.allScholarshipTypes}">
                                                   <c:choose>
                                                        <c:when test="${scholarship.scholarshipType.code == scholarshipType.code}">
                                                            ${scholarshipType.description} - 
                                                            <c:forEach var="academicYear" items="${scholarshipApplicationForm.allAcademicYears}">
                                                               <c:choose>
                                                               <c:when test="${academicYear.id == scholarship.sponsor.academicYearId}">
                                                                    ${academicYear.description}
                                                                </c:when>
                                                               </c:choose>
                                                            </c:forEach>      
                                                            
                                                        </c:when>
                                                    </c:choose>  
                                                </c:forEach>
                                                </option>
                                               </c:when>
                                               <c:otherwise>
                                                    <option value="${scholarship.id}">
                                                    ${scholarship.description} -
                                                    <c:forEach var="scholarshipType" items="${scholarshipApplicationForm.allScholarshipTypes}">
                                                       <c:choose>
                                                            <c:when test="${scholarship.scholarshipType.code == scholarshipType.code }">
                                                                ${scholarshipType.description} -
                                                                <c:forEach var="academicYear" items="${scholarshipApplicationForm.allAcademicYears}">
                                                                    <c:choose>
                                                                        <c:when test="${academicYear.id == scholarship.sponsor.academicYearId}">
                                                                            (${academicYear.description})
                                                                        </c:when>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </c:when>
                                                       </c:choose>
                                                    </c:forEach>
                                                    </option>
                                               </c:otherwise>
                                           </c:choose>
                                      </c:forEach>
			                    </select>
			                </td>
			                <td>
			                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
			                </td>
			                
			            </tr>
			            </spring:bind>
			            </c:if>
			            
			            <c:if test="${appUseOfScholarshipDecisionCriteria == 'Y'}">
				            <spring:bind path="scholarshipApplicationForm.scholarshipApplication.decisionCriteriaCode">
                            <tr>
				            <td class="label"><fmt:message key="jsp.general.scholarship.decisioncriteria" /></td>
				                    <!-- Criteria for rejection or acceptance of the scholarshipApplication  -->
				                <td>
				                    <select name="${status.expression}" id="${status.expression}"> 
				                        <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
				                        <c:forEach var="decisionCriterium" items="${scholarshipApplicationForm.allDecisionCriteria}">
				                            <c:choose>
				                                <c:when test="${decisionCriterium.code == status.value}">
				                                    <option value="${decisionCriterium.code}" selected="selected">
				                                </c:when>
				                                <c:otherwise>
				                                    <option value="${decisionCriterium.code}">
				                                </c:otherwise>
				                            </c:choose>
				                            ${decisionCriterium.description}</option>
				                        </c:forEach>
				                    </select>
				                </td>
				                <td>
				                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
				                </td>
				                
				            </tr>
				            </spring:bind>
				        </c:if>
				         
                        <%--  Study plan CTU --%>
                        <spring:bind path="scholarshipApplicationForm.scholarshipApplication.studyPlanCardinalTimeUnitId"> 
                        <tr>
                            <td class="label"><fmt:message key="jsp.general.studyplan" /> - <fmt:message key="jsp.general.timeunit" /></td>
                            <td class="required">

                                <select name="${status.expression}" id="${status.expression}" >
                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                        <c:forEach var="spctu4Display" items="${scholarshipApplicationForm.allStudyPlanCardinalTimeUnits4Display}">
                                            <c:set var="spctuDescription" value="${spctu4Display.studyPlan.studyPlanDescription} - ${spctu4Display.timeUnit}" scope="page" />
                                            <c:choose>
                                                <c:when test="${spctu4Display.studyPlanCardinalTimeUnit.id == status.value}">
                                                    <option value="${spctu4Display.studyPlanCardinalTimeUnit.id}" selected="selected">${spctuDescription}
                                                    </option>
                                                </c:when>
                                                <c:otherwise>
                                                        <option value="${spctu4Display.studyPlanCardinalTimeUnit.id}">${spctuDescription}
                                                    </option>
                                                </c:otherwise>                                                                      
                                            </c:choose>
                                        </c:forEach>
                                </select>
                            </td> 
                            <td>
                                <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                </c:forEach>
                            </td>
                        </tr>
                        </spring:bind>
                        
                        
                        <%--  Corresponding feeId
                        <c:if test="${allFeeCategories != null && allFeeCategories != ''}">
                        <spring:bind path="command.feeId"> 
                        <tr>
                             <td class="label"><fmt:message key="jsp.general.fee" /></td>
                             <td class="required">
                                 <select name="${status.expression}" id="${status.expression}" onchange="document.getElementById('academicYearId').value=this.value;">
                                     <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                         <c:forEach var="fee" items="${allFees}">
                                             
                                                <c:forEach var="academicYear" items="${allUsedAcademicYears}">
                                                        <c:if test="${fee.academicYearId == academicYear.id}">
                                                     <c:choose>
                                                            <c:when test="${fee.id == status.value}">
                                                                <option value="${fee.id}" selected="selected">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${fee.id}">
                                                            </c:otherwise>                                                                      
                                                        </c:choose>
                                                     ${academicYear.description}
                                                     <c:forEach var="feeCategory" items="${allFeeCategories}">
                                                                      <c:if test="${fee.categoryCode == feeCategory.code}">
                                                                      &nbsp;-&nbsp;${feeCategory.description}
                                                                      </c:if>
                                                                 </c:forEach>
                                                                 </option> 
                                                     </c:if>
                                                </c:forEach>
                                             
                                                <c:forEach var="subjectBlockStudyGradeType" items="${allSubjectBlockStudyGradeTypes}">
                                                              <c:if test="${fee.subjectBlockStudyGradeTypeId == subjectBlockStudyGradeType.id}">
                                                                 <c:forEach var="academicYear" items="${allAcademicYears}">
                                                                  <c:if test="${subjectBlockStudyGradeType.studyGradeType.currentAcademicYearId == academicYear.id}">
                                                                       <c:choose>
                                                                     <c:when test="${fee.id == status.value}">
                                                                         <option value="${fee.id}" selected="selected">
                                                                     </c:when>
                                                                     <c:otherwise>
                                                                         <option value="${fee.id}">
                                                                     </c:otherwise>                                                                      
                                                                 </c:choose>
                                                                     ${academicYear.description}
                                                                  </c:if>
                                                                 </c:forEach>
                                                                  &nbsp;-&nbsp;${subjectBlockStudyGradeType.subjectBlock.subjectBlockDescription} 
                                                                  &nbsp;(${subjectBlockStudyGradeType.studyGradeType.studyDescription} - ${subjectBlockStudyGradeType.studyGradeType.gradeTypeDescription})
                                                                  <c:forEach var="feeCategory" items="${allFeeCategories}">
                                                                      <c:if test="${fee.categoryCode == feeCategory.code}">
                                                                      &nbsp;-&nbsp;${feeCategory.description}
                                                                      </c:if>
                                                                 </c:forEach>
                                                                 </option>   
                                                              </c:if>
                                                          </c:forEach>
                                             
                                                         <c:forEach var="subjectStudyGradeType" items="${allSubjectStudyGradeTypes}">
                                                              <c:if test="${fee.subjectStudyGradeTypeId == subjectStudyGradeType.id}">
                                                                 <c:forEach var="academicYear" items="${allAcademicYears}">
                                                                     <c:if test="${subjectStudyGradeType.studyGradeType.currentAcademicYearId == academicYear.id}">
                                                                        <c:choose>
                                                                              <c:when test="${fee.id == status.value}">
                                                                                  <option value="${fee.id}" selected="selected">
                                                                              </c:when>
                                                                              <c:otherwise>
                                                                                  <option value="${fee.id}">
                                                                              </c:otherwise>                                                                      
                                                                          </c:choose>
                                                                        ${academicYear.description}
                                                                     </c:if>
                                                                 </c:forEach>
                                                                  &nbsp;-&nbsp;${subjectStudyGradeType.subject.subjectDescription} 
                                                                  &nbsp;(${subjectStudyGradeType.studyGradeType.studyDescription} - ${subjectStudyGradeType.studyGradeType.gradeTypeDescription})
                                                                  <c:forEach var="feeCategory" items="${allFeeCategories}">
                                                                      <c:if test="${fee.categoryCode == feeCategory.code}">
                                                                      &nbsp;-&nbsp;${feeCategory.description}
                                                                      </c:if>
                                                                 </c:forEach>
                                                                 </option>  
                                                              </c:if>
                                                          </c:forEach>
                                                     
                                                         <c:forEach var="studyGradeType" items="${allStudyGradeTypes}">
                                                              <c:if test="${fee.studyGradeTypeId == studyGradeType.id}">
                                                                 <c:forEach var="academicYear" items="${allAcademicYears}">
                                                                     <c:if test="${studyGradeType.currentAcademicYearId == academicYear.id}">
                                                                        <c:choose>
                                                                              <c:when test="${fee.id == status.value}">
                                                                                  <option value="${fee.id}" selected="selected">
                                                                              </c:when>
                                                                              <c:otherwise>
                                                                                  <option value="${fee.id}">
                                                                              </c:otherwise>                                                                      
                                                                          </c:choose>
                                                                        ${academicYear.description}
                                                                     </c:if>
                                                                 </c:forEach>
                                                                 &nbsp;-&nbsp;(${studyGradeType.studyDescription} - ${studyGradeType.gradeTypeDescription})
                                                                 <c:forEach var="feeCategory" items="${allFeeCategories}">
                                                             <c:if test="${fee.categoryCode == feeCategory.code}">
                                                             &nbsp;-&nbsp;${feeCategory.description}
                                                             </c:if>
                                                        </c:forEach>
                                                        </option>  
                                                              </c:if>
                                                          </c:forEach>
                                                      
                                         </c:forEach>
                                 </select>
                             </td> 
                             <td>
                                 <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                 </c:forEach>
                             </td>
                        </tr>
                       </spring:bind>
                       </c:if> --%>
                             
                        
                        <!--Observations about the scholarships  -->
				        
				        <spring:bind path="scholarshipApplicationForm.scholarshipApplication.observation">     
			            <tr>
		                     <td class="label"><fmt:message key="jsp.general.observation" /></td>
		                     <td>
		                     
		                     <textarea cols="30" rows="10" id="${status.expression}" name="${status.expression}" >${status.value}</textarea>
		                     </td>
		                     <td>
		                     <c:forEach var="error" items="${status.errorMessages}">
		                     <span class="error">${error}</span></c:forEach>
		                     
		                     </td>
						</tr>
			            </spring:bind>

                        <spring:bind path="scholarshipApplicationForm.scholarshipApplication.active">
                            <tr>
                                <td class="label"><fmt:message key="jsp.general.active" /></td>
                                <c:if test="${editScholarships}">
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
                                </c:if>
<%--                                            <c:if test="${showPersonalData}">
                                                  <c:choose>
                                                    <c:when test="${'Y' == status.value}">
                                                        <td><fmt:message key="jsp.general.yes" /></td>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <td><fmt:message key="jsp.general.no" /></td>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if> --%>
                                <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                            </tr>
                        </spring:bind>


                        <tr>
                            <td colspan=2>&nbsp;</td>
                            <td>
                                <input type="button" name="submitscholarshipapplicationdata" value="<fmt:message key="jsp.button.submit" />" onclick="document.scholarshipapplicationdata.submit();" />
                            </td>
                        </tr>
                    </table>
                    
                    <c:if test="${scholarshipApplicationId != 0 }" >
                    <!-- SPONSOR PAYMENTS -->
<%--                                 <table>
                                 <tr><td colspan="5"><hr></td></tr>
                                 <tr>
                                    <td class="header" colspan="4"><fmt:message key="scholarship.sponsorPayments" /></td>
                                    <td align="right">
                                        <a class="button" href="<c:url value='/scholarship/sponsorpayment.view?tab=1&panel=0&studentId=${student.studentId}&scholarshipStudentId=${scholarshipStudentId}&scholarshipApplicationId=${scholarshipApplicationId}&currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>  
                                    </td>
                                 </tr>
                                 
                                 <tr>
                                 <td colspan="5">
                                 <table class="tabledata2" id="TblData_sponsorPayments">
                                 <tr>
                                     <th><fmt:message key="jsp.general.academicyear" /></th>
                                     <th><fmt:message key="jsp.sponsorpayment.paymentduedate" /></th>
                                     <th><fmt:message key="jsp.sponsorpayment.paymentreceiveddate" /></th>
                                     <th><fmt:message key="jsp.sponsorpayment.latepayment" /></th>
                                     <th></th>
                                 </tr> 
                                  <spring:bind path="command.sponsorPayments">    
                                    <!--  list of sponsorPayments -->
                                    <c:forEach var="sponsorPayment" items="${status.value}">
                                        <tr>
                                            <td>
                                                <c:forEach var="academicYear" items="${allAcademicYears}">
                                                     <c:choose>
                                                         <c:when test="${academicYear.id != 0
                                                                      && academicYear.id == sponsorPayment.academicYearId}">
                                                            ${academicYear.description}
                                                         </c:when>
                                                     </c:choose>
                                                </c:forEach>
                                            </td>
                                            <td>
                                                <c:if test="${sponsorPayment.paymentDueDate != null && sponsorPayment.paymentDueDate != ''}">
                                                   <c:set var="paymentDueDate" value="${sponsorPayment.paymentDueDate}" scope="page" />
                                                   <%
                                                        Date paymentDueDate = (Date) pageContext.getAttribute("paymentDueDate");
                                                        SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");
                                                        out.write(format.format(paymentDueDate));
                                                   %> 
                                                   </c:if> &nbsp;
                                            </td>
                                            <td>       
                                                <c:if test="${sponsorPayment.paymentReceivedDate != null && sponsorPayment.paymentReceivedDate != ''}">
                                                    <c:set var="paymentReceivedDate" value="${sponsorPayment.paymentReceivedDate}" scope="page" />
                                                  <%
                                                        Date paymentReceivedDate = (Date) pageContext.getAttribute("paymentReceivedDate");
                                                        SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");
                                                        out.write(format.format(paymentReceivedDate));
                                                   %> 
                                                 </c:if> &nbsp;
                                            </td>  
                                           <td>
                                                ${sponsorPayment.latePayment}
                                            </td>
                                            <td colspan=4 align="right">
                                                <a href="<c:url value='/scholarship/sponsorpayment.view?tab=1&panel=0&studentId=${student.studentId}&scholarshipStudentId=${scholarshipStudentId}&scholarshipApplicationId=${scholarshipApplicationId}&sponsorPaymentId=${sponsorPayment.id}&currentPageNumber=${currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                            </td>
                                        </c:forEach>
                                    </spring:bind>
                                </table>  
                                <script type="text/javascript">alternate('TblData_sponsorPayments',true)</script>
                                </td>
                                </tr>
                                </table>--%>
                    
                    <!-- COMPLAINTS -->                                                                                                                                                                                                     
                    <table>
                     <tr><td colspan="7">&nbsp;</td></tr>
				     <tr>
				         <td class="header" colspan="6"><fmt:message key="jsp.general.complaints" /></td>
				         <td align="right">
					        <a class="button" href="<c:url value='/scholarship/complaint.view?tab=1&panel=0&studentId=${scholarshipApplicationForm.student.studentId}&scholarshipStudentId=${scholarshipStudentId}&scholarshipApplicationId=${scholarshipApplicationId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
					    </td>
					 </tr>
                     <tr> 
                     <td colspan="7">
                     <table class="tabledata2" id="TblData_complaints">
					 <tr>
					        <th><fmt:message key="jsp.general.complaintdate" /></th>
					        <th><fmt:message key="jsp.general.reason" /></th>
					        <th><fmt:message key="jsp.general.result" /></th>
					        <th><fmt:message key="jsp.general.complaintstatus" /></th>
					        <th><fmt:message key="jsp.general.active" /></th>
					        <th></th>
					  </tr> 
					  
					  <spring:bind path="scholarshipApplicationForm.scholarshipApplication.complaints">    
					    <!--  list of complaints -->
					    <c:forEach var="complaint" items="${status.value}">
					        <tr>
					            <td>
					                <fmt:formatDate pattern="dd/MM/yyyy" value="${complaint.complaintDate}" />
					            </td>
					            <td>
					                ${complaint.reason}
					            </td>       
					            <td>
					                ${complaint.result}
					            </td>       
					            <td>
					                <!-- Criteria for rejection or acceptance of the scholarship  -->
					                <c:forEach var="complaintStatus" items="${scholarshipApplicationForm.allComplaintStatuses}">
					                    <c:choose>
					                        <c:when test="${complaintStatus.code == complaint.complaintStatusCode}">
					                            ${complaintStatus.description}
					                        </c:when>
					                    </c:choose>
					                </c:forEach>
					            </td>
					            <td>
                                    <fmt:message key="${stringToYesNoMap[complaint.active]}"/>
					            </td>
					            
					            <td class="buttonsCell">
					                <a href="<c:url value='/scholarship/complaint.view?tab=1&panel=0&studentId=${scholarshipApplicationForm.student.studentId}&scholarshipStudentId=${scholarshipStudentId}&scholarshipApplicationId=${scholarshipApplicationId}&complaintId=${complaint.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
					                    <img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
					                &nbsp;&nbsp;
					                <a href="<c:url value='/scholarship/complaint_delete.view?tab=1&panel=0&from=scholarshipstudent&studentId=${scholarshipApplicationForm.student.studentId}&scholarshipStudentId=${scholarshipStudentId}&scholarshipApplicationId=${scholarshipApplicationId}&complaintId=${complaint.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>" onclick="return confirm('<fmt:message key="jsp.complaint.delete.confirm" />')">
					                    <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
					                </a>
					            </td>
					        </tr>
					    
					    </c:forEach>
					    </spring:bind>
			        </table>
                    <script type="text/javascript">alternate('TblData_complaints',true)</script>
                    </td>
                    </tr>
                    </table>
                    </c:if>

                    </form>

                
                </div><!-- Content -->
            
            </div><!-- AccordionPanel -->
            
        </div><!-- Accordion -->    
            
        <script type="text/javascript">
                                    var Accordion0 = new Spry.Widget.Accordion("Accordion0",
                                      {defaultPanel: 0,
                                      useFixedPanelHeights: false,
                                      nextPanelKeyCode: 78 /* n key */,
                                      previousPanelKeyCode: 80 /* p key */
                                     });
                                    
                            </script>
    </div><!-- TabbedPanelsContent -->
    
</div><!-- End of TabbedPanelsContentGroup -->
</div><!-- End of TabbedPanel tp1-->
        
<!-- end of tabcontent -->
</div>   
    
 <script type="text/javascript">
    var tp1 = new Spry.Widget.TabbedPanels("tp1");
    //tp1.showPanel(${param.tab});
    tp1.showPanel(0);
    Accordion0.defaultPanel = 0;
    Accordion0.openPanelNumber(0);
</script>
   
  
</div>

<%@ include file="../../footer.jsp"%>


