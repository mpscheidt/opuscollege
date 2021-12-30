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
                	<a href="<c:url value='/fee/feesstudies.view?currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
	    			<a href="<c:url value='/fee/feesstudy.view?tab=0&panel=0&from=feeSubjectAndSubjectBlock&studyId=${feeSubjectAndSubjectBlockForm.study.id}&currentPageNumber=${currentPageNumber}'/>">
		    			<c:choose>
		    				<c:when test="${feeSubjectAndSubjectBlockForm.study.studyDescription != null && feeSubjectAndSubjectBlockForm.study.studyDescription != ''}" >
	            				${fn:substring(feeSubjectAndSubjectBlockForm.study.studyDescription,0,initParam.iTitleLength)}
							</c:when>
						</c:choose>
					</a>&nbsp;>
	    			<spring:bind path="feeSubjectAndSubjectBlockForm.fee.id">
		    			<c:choose>
		    				<c:when test="${status.value != null && status.value != ''}" >
	            				<spring:bind path="feeSubjectAndSubjectBlockForm.fee.subjectStudyGradeTypeId">
	            				<c:choose>
	            				   <c:when test="${status.value != null && status.value != ''}">
	            				       ${subject.subjectDescription}
	            				   </c:when>
	            				</c:choose>
	            				</spring:bind>
	            				<c:if test="${appUseOfSubjectBlocks == 'Y'}">
		            				<spring:bind path="feeSubjectAndSubjectBlockForm.fee.subjectBlockStudyGradeTypeId">
	                                <c:choose>
	                                   <c:when test="${status.value != null && status.value != ''}">
	                                       ${subjectBlock.subjectBlockDescription}
	                                   </c:when>
	                                </c:choose>
		            				</spring:bind>
	            				</c:if>
							</c:when>
							<c:otherwise>
								<fmt:message key="jsp.href.new" />
							</c:otherwise>
						</c:choose>
					</spring:bind>
					&nbsp;>&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.menu.fees" /> 
				</legend>
				
                <c:choose>        
                    <c:when test="${ not empty showFeeEditError }">       
                        <p align="left" class="error">
                            ${showFeeEditError}
                        </p>
                    </c:when>
                </c:choose>

			</fieldset>
		</form>

        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.edit" /></li>               
                  
                <c:if test="${feeSubjectAndSubjectBlockForm.fee.id != 0}">
                	<li class="TabbedPanelsTab"><fmt:message key="general.deadlines" /></li>
                </c:if> 
            </ul>

            <div class="TabbedPanelsContentGroup">   
                    <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion1" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab"><fmt:message key="jsp.general.fee" /></div>
                                <div class="AccordionPanelContent">

                                <form name="feedata" method="POST">
                                    <input type="hidden" name="tab_fee" value="0" /> 
                                    <input type="hidden" name="panel_fee" value="0" />
                                    
                                    <table>

                                        <!-- DEADLINE -->
	                                    <tr>
	                                        <%--
	                                        <spring:bind path="feeSubjectAndSubjectBlockForm.fee.deadline">
                                            <td class="required">
	                                        <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
	                        	            <table>
	                                            	<tr>
	                                            		<td><fmt:message key="jsp.general.day" /></td>
	                                            		<td><fmt:message key="jsp.general.month" /></td>
	                                            		<td><fmt:message key="jsp.general.year" /></td>
	                                            	</tr>
	                                                <tr>
	                                            		<td><input type="text" id="deadline_day" name="deadline_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('deadline','day',document.getElementById('deadline_day').value);" /></td>
	                                            		<td><input type="text" id="deadline_month" name="deadline_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('deadline','month',document.getElementById('deadline_month').value);" /></td>
	                                            		<td><input type="text" id="deadline_year" name="deadline_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('deadline','year',document.getElementById('deadline_year').value);" /></td>
	                                            	</tr>
	                                        </table>
	                             			</td>
	                                        <td>
	                                            <fmt:message key="jsp.general.message.dateformat" />
	                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
	                                        </td>
                                            </spring:bind>
                                            --%>
	                                    </tr>

                                        <!-- FEE DUE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.feedue" /></td>
                                            <spring:bind path="feeSubjectAndSubjectBlockForm.fee.feeDue">
                                            <td class="required">
                                            <input type="text" name="${status.expression}" size="12" maxlength="12" value="<c:out value="${status.value}" />" />
                                            </td> 
                                            <td>
                                            	<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                </c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>
                       					<!-- NUMBEROFINSTALMENTS -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.numberofinstallments" /></td>
                                            <spring:bind path="feeSubjectAndSubjectBlockForm.fee.numberOfInstallments">
                                            <td>
                                            <input type="text" name="${status.expression}" size="3" maxlength="10" value="<c:out value="${status.value}" />" onblur="javascript:if (this.value == null || (this.value).trim() == '') this.value=0;" />
                                            </td> 
                                            <td>
                                            	<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                </c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>
										<!-- TUITIONWAIVERDISCOUNTPERCENTAGE -->
<%--                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.tuitionwaiverdiscountpercentage" /></td>
                                            <spring:bind path="feeSubjectAndSubjectBlockForm.fee.tuitionWaiverDiscountPercentage">
                                            <td class="required">
                                            <input type="text" name="${status.expression}" size="3" maxlength="10" value="<c:out value="${status.value}" />" />
                                            </td> 
                                            <td>
                                            	<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                </c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>
										<!-- FULLTIMESTUDENTDISCOUNTPERCENTAGE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.fulltimestudentdiscountpercentage" /></td>
                                            <spring:bind path="feeSubjectAndSubjectBlockForm.fee.fulltimeStudentDiscountPercentage">
                                            <td class="required">
                                            <input type="text" name="${status.expression}" size="3" maxlength="10" value="<c:out value="${status.value}" />" />
                                            </td> 
                                            <td>
                                            	<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                </c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>
										<!-- LOCALSTUDENTDISCOUNTPERCENTAGE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.localstudentdiscountpercentage" /></td>
                                            <spring:bind path="feeSubjectAndSubjectBlockForm.fee.localStudentDiscountPercentage">
                                            <td class="required">
                                            <input type="text" name="${status.expression}" size="3" maxlength="10" value="<c:out value="${status.value}" />" />
                                            </td> 
                                            <td>
                                            	<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                </c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>                                                                                
										<!-- CONTINUEDREGISTRATIONDISCOUNTPERCENTAGE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.continuedregistrationdiscountpercentage" /></td>
                                            <spring:bind path="feeSubjectAndSubjectBlockForm.fee.continuedRegistrationDiscountPercentage">
                                            <td class="required">
                                            <input type="text" name="${status.expression}" size="3" maxlength="10" value="<c:out value="${status.value}" />" />
                                            </td> 
                                            <td>
                                            	<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                </c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>
										<!-- POSTGRADUATEDISCOUNTPERCENTAGE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.postgraduatediscountpercentage" /></td>
                                            <spring:bind path="feeSubjectAndSubjectBlockForm.fee.postgraduateDiscountPercentage">
                                            <td class="required">
                                            <input type="text" name="${status.expression}" size="3" maxlength="10" value="<c:out value="${status.value}" />" />
                                            </td> 
                                            <td>
                                            	<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                </c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr> 
 --%>
                                         
                                        <%-- ACCOMMODATION FEE 
                                        <c:if test="${allAccommodationFees != null && allAccommodationFees != ''}">
                                        
                                            <spring:bind path="feeSubjectAndSubjectBlockForm.fee.accommodationFeeId">
                                            <tr>
                                                <td class="label"><fmt:message key="jsp.general.accommodationfee" /></td>
                                                <td>
                                                <select id="${status.expression}" name="${status.expression}" >
                                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    <c:forEach var="accommodationFee" items="${allAccommodationFees}">
                                                      <c:choose>
                                                        <c:when test="${accommodationFee.id != status.value}">
                                                          <option value="${accommodationFee.id}">${accommodationFee.description}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${accommodationFee.id}" selected="selected">${accommodationFee.description}</option>
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
                                        </c:if>
                                        --%>
                                        <tr>
                                            <td class="label">&nbsp;</td>

                                            <c:if test="${appUseOfSubjectBlocks == 'Y'}">
	                                        <%--  SUBJECTBLOCKSTUDYGRADETYPES --%>
	                                        <td valign="top">
	                                        	<table>
	                                        	 <tr>
		                                            <td class="label"><fmt:message key="jsp.general.subjectblockstudygradetype" />&nbsp;<fmt:message key="jsp.general.or" />:&nbsp;&nbsp;&nbsp;</td>
		                                        </tr>
                                                <spring:bind path="feeSubjectAndSubjectBlockForm.fee.subjectBlockStudyGradeTypeId">
		                                        <tr>
		                                            <td>
		                                            <select name="${status.expression}" id="${status.expression}" onchange="document.getElementById('subjectBlockStudyGradeTypeId').value=this.value;document.getElementById('subjectStudyGradeTypeId').value='0';" style="width: 300px">
		                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
														<c:choose>
										    				<c:when test="${status.value != 0 && status.value != ''}" >
				                                                <c:forEach var="subjectBlockStudyGradeType" items="${feeSubjectAndSubjectBlockForm.allSubjectBlockStudyGradeTypes}">
				                                                    <c:choose>
				                                                        <c:when test="${subjectBlockStudyGradeType.id == status.value}">
				                                                            <option value="${subjectBlockStudyGradeType.id}" selected="selected">${subjectBlockStudyGradeType.subjectBlock.subjectBlockDescription}
				                                                    			<c:forEach var="academicYear" items="${feeSubjectAndSubjectBlockForm.allAcademicYears}">
								                                                     <c:choose>
								                                                         <c:when test="${academicYear.id != 0
								                                                                      && academicYear.id == subjectBlockStudyGradeType.subjectBlock.currentAcademicYearId}">
								                                                            ,(${academicYear.description}),${subjectBlockStudyGradeType.cardinalTimeUnitNumber}
								                                                         </c:when>
								                                                     </c:choose>
								                                                </c:forEach>
<%-- TODO: gradeTypeDescription needs to be replaced by codeToLookupMap, because it is not filled anymore, see subjectblock.jsp for example --%>
								                                                ,${subjectBlockStudyGradeType.studyGradeType.gradeTypeDescription},
															                    <c:forEach var="studyForm" items="${feeSubjectAndSubjectBlockForm.allStudyForms}">
																		                 <c:choose>
																		                        <c:when test="${studyForm.code == subjectBlockStudyGradeType.studyGradeType.studyFormCode}">
																		                            ${studyForm.description},
																		                        </c:when>
																		                  </c:choose>
																		        </c:forEach>
													 		                    <c:forEach var="studyTime" items="${feeSubjectAndSubjectBlockForm.allStudyTimes}">
															                       <c:choose>
															                        	<c:when test="${studyTime.code == subjectBlockStudyGradeType.studyGradeType.studyTimeCode}">
															                            	${studyTime.description}
															                        	</c:when>
															                        </c:choose>
															                    </c:forEach>									                                                
				                                                            </option>
				                                                        </c:when>
				                                                    </c:choose>
				                                                </c:forEach>
										    				</c:when>
										    			</c:choose>
		                                    
		                                                <c:forEach var="subjectBlockStudyGradeType" items="${feeSubjectAndSubjectBlockForm.allSubjectBlockStudyGradeTypesWithoutFees}">
		                                                    <c:choose>
		                                                        <c:when test="${subjectBlockStudyGradeType.id == status.value}">
		                                                            <option value="${subjectBlockStudyGradeType.id}" selected="selected">
		                                                        </c:when>
		                                                        <c:otherwise>
		                                                            <option value="${subjectBlockStudyGradeType.id}">
		                                                        </c:otherwise>
		                                                    </c:choose>
		                                                    ${subjectBlockStudyGradeType.subjectBlock.subjectBlockDescription}
                                                   			<c:forEach var="academicYear" items="${feeSubjectAndSubjectBlockForm.allAcademicYears}">
			                                                     <c:choose>
			                                                         <c:when test="${academicYear.id != 0
			                                                                      && academicYear.id == subjectBlockStudyGradeType.subjectBlock.currentAcademicYearId}">
			                                                            ,(${academicYear.description}),${subjectBlockStudyGradeType.cardinalTimeUnitNumber}
			                                                         </c:when>
			                                                     </c:choose>
			                                                </c:forEach>
<%-- TODO: gradeTypeDescription needs to be replaced by codeToLookupMap, because it is not filled anymore, see subjectblock.jsp for example --%>
                                   							,${subjectBlockStudyGradeType.studyGradeType.gradeTypeDescription},
										                    <c:forEach var="studyForm" items="${feeSubjectAndSubjectBlockForm.allStudyForms}">
													                 <c:choose>
													                        <c:when test="${studyForm.code == subjectBlockStudyGradeType.studyGradeType.studyFormCode}">
													                            ${studyForm.description},
													                        </c:when>
													                  </c:choose>
													        </c:forEach>
								 		                    <c:forEach var="studyTime" items="${feeSubjectAndSubjectBlockForm.allStudyTimes}">
										                       <c:choose>
										                        	<c:when test="${studyTime.code == subjectBlockStudyGradeType.studyGradeType.studyTimeCode}">
										                            	${studyTime.description}
										                        	</c:when>
										                        </c:choose>
										                    </c:forEach>		                                   							
		                                                    </option> 
		                                                </c:forEach>
		                                            </select>
		                                            </td> 
		                                        </tr> 
		                                        <tr>
		                                            <td>
		                                            	<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
		                                                </c:forEach>
		                                            </td>
	                                        	</tr>
                                                </spring:bind>
	                                        	</table>
	                                        </td>
                                            </c:if>
                                            
                                            <!--  SUBJECT -->
                                            <td valign="top">
                                                
                                                <table>
                                                <tr>
                                                 <td class="label">
                                                 <fmt:message key="jsp.general.subject" /></td>
                                                </tr> 
                                                <spring:bind path="feeSubjectAndSubjectBlockForm.fee.subjectStudyGradeTypeId">
                                                <tr>
                                                    <td>
                                                    <select name="${status.expression}" id="${status.expression}" onchange="document.getElementById('subjectBlockStudyGradeTypeId').value='0';document.getElementById('subjectStudyGradeTypeId').value=this.value;" style="width: 300px">
                                                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
 														<c:choose>
										    				<c:when test="${status.value != 0 && status.value != ''}" >
				                                                <c:forEach var="subjectStudyGradeType" items="${feeSubjectAndSubjectBlockForm.allSubjectStudyGradeTypes}">
				                                                    <c:choose>
				                                                        <c:when test="${subjectStudyGradeType.id == status.value}">
				                                                            <option value="${subjectStudyGradeType.id}" selected="selected">${subjectStudyGradeType.subject.subjectDescription}
				                                                    			<c:forEach var="academicYear" items="${feeSubjectAndSubjectBlockForm.allAcademicYears}">
								                                                     <c:choose>
								                                                         <c:when test="${academicYear.id != 0
								                                                                      && academicYear.id == subjectStudyGradeType.subject.currentAcademicYearId}">
								                                                            ,(${academicYear.description}),${subjectStudyGradeType.cardinalTimeUnitNumber}
								                                                         </c:when>
								                                                     </c:choose>
								                                                </c:forEach>
<%-- TODO: gradeTypeDescription needs to be replaced by codeToLookupMap, because it is not filled anymore, see subject.jsp for example --%>
								                                                ,${subjectStudyGradeType.studyGradeType.gradeTypeDescription},
															                    <c:forEach var="studyForm" items="${feeSubjectAndSubjectBlockForm.allStudyForms}">
																		                 <c:choose>
																		                        <c:when test="${studyForm.code == subjectStudyGradeType.studyGradeType.studyFormCode}">
																		                            ${studyForm.description},
																		                        </c:when>
																		                  </c:choose>
																		        </c:forEach>
													 		                    <c:forEach var="studyTime" items="${feeSubjectAndSubjectBlockForm.allStudyTimes}">
															                       <c:choose>
															                        	<c:when test="${studyTime.code == subjectStudyGradeType.studyGradeType.studyTimeCode}">
															                            	${studyTime.description}
															                        	</c:when>
															                        </c:choose>
															                    </c:forEach>										                                                
				                                                            </option>
				                                                        </c:when>
				                                                    </c:choose>
				                                                </c:forEach>
										    				</c:when>
										    			</c:choose>

		                                                <c:forEach var="subjectStudyGradeType" items="${feeSubjectAndSubjectBlockForm.allSubjectStudyGradeTypesWithoutFees}">
		                                                    <c:choose>
		                                                        <c:when test="${subjectStudyGradeType.id == status.value}">
		                                                            <option value="${subjectStudyGradeType.id}" selected="selected">
		                                                        </c:when>
		                                                        <c:otherwise>
		                                                            <option value="${subjectStudyGradeType.id}">
		                                                        </c:otherwise>
		                                                    </c:choose>
		                                                    ${subjectStudyGradeType.subject.subjectDescription}
                                                   			<c:forEach var="academicYear" items="${feeSubjectAndSubjectBlockForm.allAcademicYears}">
			                                                     <c:choose>
			                                                         <c:when test="${academicYear.id != 0
			                                                                      && academicYear.id == subjectStudyGradeType.subject.currentAcademicYearId}">
			                                                            ,(${academicYear.description}),${subjectStudyGradeType.cardinalTimeUnitNumber}
			                                                         </c:when>
			                                                     </c:choose>
			                                                </c:forEach>
<%-- TODO: gradeTypeDescription needs to be replaced by codeToLookupMap, because it is not filled anymore, see subject.jsp for example --%>
                                   							,${subjectStudyGradeType.studyGradeType.gradeTypeDescription},
										                    <c:forEach var="studyForm" items="${feeSubjectAndSubjectBlockForm.allStudyForms}">
													                 <c:choose>
													                        <c:when test="${studyForm.code == subjectStudyGradeType.studyGradeType.studyFormCode}">
													                            ${studyForm.description},
													                        </c:when>
													                  </c:choose>
													        </c:forEach>
								 		                    <c:forEach var="studyTime" items="${feeSubjectAndSubjectBlockForm.allStudyTimes}">
										                       <c:choose>
										                        	<c:when test="${studyTime.code == subjectStudyGradeType.studyGradeType.studyTimeCode}">
										                            	${studyTime.description}
										                        	</c:when>
										                        </c:choose>
										                    </c:forEach>	                                   							
		                                                    </option> 
		                                                </c:forEach>
                                                    </select>
                                                    </td>
                                                  </tr> 
                                                <tr>
                                                    <td>
                                                        <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                        </c:forEach>
                                                    </td>
                                                </tr>
                                                </spring:bind>
                                                </table>
                                            </td>
                                        </tr>

                                        <!-- ACTIVE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.active" /></td>
                                            <spring:bind path="feeSubjectAndSubjectBlockForm.fee.active">
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
	                                       	<td class="label">&nbsp;</td>
	                                    	<td colspan="3"><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td>
	                                    </tr>

	                                </table>
                                </form>
                                </div>
                            </div>
                        </div>
                        <script type="text/javascript">
                            var sampleAccordion = new Spry.Widget.Accordion("Accordion1");
                        </script>
                    </div>     <%--details tab --%>
                    
                    
                    <div class="TabbedPanelsContent">
                    	<c:if test="${feeSubjectAndSubjectBlockForm.fee.id != 0}">
 							<%@ include file="feeSubjectAndSubjectBlock-deadlines.jsp"%>
 						</c:if>
     				</div><%-- TabbedPanelsContent dead lines tab--%>
            </div>
        </div>
    </div>
        
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        //tp1.showPanel(<%//=request.getParameter("tab")%>);
        tp1.showPanel(feeSubjectAndSubjectBlockForm.navigationSettings.tab);
    </script>
</div>

<%@ include file="../../footer.jsp"%>

