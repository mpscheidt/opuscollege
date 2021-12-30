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

The Original Code is Opus-College college module code.

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

<!-- start of tabbedpanelscontent (= start of tab one) -->
<div class="TabbedPanelsContent">
    <div class="Accordion" id="Accordion0" tabindex="0">
        <div class="AccordionPanel">
        <div class="AccordionPanelTab"><fmt:message key="jsp.general.myexams" /></div>
        
            <div class="AccordionPanelContent">
                <spring:bind path="command.studyPlans"> 
                <c:forEach var="studyPlan" items="${command.studyPlans}">
                    <table>
                        <tr>
                            <td class="header">${studyPlan.studyPlanDescription }</td>
                            <c:forEach var="oneStudy" items="${allStudies}">
                                <c:choose>
                                    <c:when test="${studyPlan.studyId == oneStudy.id}">
                                        <td class="header">
                                            (${study.studyDescription}
                                        </td>
                                    </c:when>
                                </c:choose>
                            </c:forEach>    
                        </tr>
                        
                        <!-- exam date -->
                        <tr>
                            <td colspan="2">
                            <table class="tabledata2">
                                <tr>
                                    <td class="label"><fmt:message key="jsp.general.examdate" /></td>
                                    <td>
                                        <fmt:formatDate pattern="dd-MM-yyyy" value="${studyPlan.studyPlanResult.examDate}" />
                                    </td>
                                    <td class="label"><fmt:message key="jsp.general.mark" /></td>
                                    <td>${studyPlan.studyPlanResult.mark}</td>
                                </tr>
                                <tr>
                                    <td class="label"><fmt:message key="jsp.general.passed" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${'Y' == studyPlan.studyPlanResult.passed}">
                                                <fmt:message key="jsp.general.yes" />
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:message key="jsp.general.no" />
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="label"><fmt:message key="jsp.general.finalmark" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${'Y' == studyPlan.studyPlanResult.finalMark}">
                                                <fmt:message key="jsp.general.yes" />
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:message key="jsp.general.no" />
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                            </table>
                            <td>
                        </tr>
                    </table>
                    
                    <!--  SUBJECTRESULTS LIST -->
                    <table class="tabledata2">
                         <tr>
                             <th><fmt:message key="jsp.general.academicyear" /></th>
                             <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                                <th><fmt:message key="jsp.general.subjectblock" /></th>
                             </c:if>
                             <th><fmt:message key="jsp.general.subject" /></th>
                             <th><fmt:message key="jsp.general.subjectresult" /></th>
                        </tr>
                        <c:forEach var="studyPlanDetail" items="${studyPlan.studyPlanDetails}">
                            
                            <!-- SUBJECTBLOCK -->
                            <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                                <c:if test="${studyPlanDetail.subjectBlockId != 0}">
                                    <c:forEach var="subjectBlock" items="${allSubjectBlocks}" >
                                        <c:choose>
                                            <c:when test="${subjectBlock.id == studyPlanDetail.subjectBlockId}" >
                                                 <c:forEach var="subjectSubjectBlock" items="${allSubjectSubjectBlocks}"  >
                                                  <c:choose>
                                                        <c:when test="${studyPlanDetail.subjectBlockId == subjectSubjectBlock.subjectBlockId}" >
                                                            <c:forEach var="subject" items="${allSubjects}" >
                                                                <c:set var="subjectResultSave" value="" scope="page" />
                                                                <c:choose>
                                                                    <c:when test="${subject.id == subjectSubjectBlock.subject.id}" >
                                                                        <tr>
                                                                        <td>
                                                                            <c:forEach var="studyGradeType" items="${allStudyGradeTypes}">
											                                     <c:choose>
											                                         <c:when test="${oneStudyPlanDetail.studyGradeTypeId != 0
											                                                      && studyGradeType.id == studyGradeTypeId}">
														                                  <c:forEach var="academicYear" items="${allAcademicYears}">
								                                                            <c:choose>
								                                                               <c:when test="${studyGradeType.academicYearId != ''
								                                                                            && academicYear.id == studyGradeType.academicYearId}">
								                                                                  ${academicYear.description}
								                                                               </c:when>
								                                                            </c:choose>
								                                                          </c:forEach>
								                                                      </c:when>
								                                                  </c:choose>
								                                              </c:forEach>
					                                                      </td>
	                                                                        <td>${subjectBlock.subjectBlockDescription} <%-- (${subjectBlock.subjectBlockStructureValidFromYear} - ${subjectBlock.subjectBlockStructureValidThroughYear}) --%></td>
	                                             							<td>${subject.subjectDescription}</td>
	                                                                        <td>
		                                                                        <table>
		                                                                        <c:forEach var="subjectResult" items="${allSubjectResults}">
		                                                                            <c:choose>
		                                                                                <c:when test="${subjectResult.subjectId == subject.id 
		                                                                                            && subjectResult.studyPlanDetailId == studyPlanDetail.id}">
		                                                                                    <c:set var="subjectResultSave" value="${subjectResult.id}" scope="page" />
		                                                                                    <tr>
		                                                                                    	<td>
																								<fmt:formatDate pattern="dd/MM/yyyy" value="${subjectResult.subjectResultDate}" /> (<fmt:message key="jsp.general.mark" />: ${subjectResult.mark}) 
		                                                                                    	</td>
																							</tr>
		                                                                                </c:when>
		                                                                            </c:choose>
		                                                                        </c:forEach>
		                                                                    </table>
                                                                        </td>
                                                                     	</tr>
                                                                    </c:when>
                                                                </c:choose>
                                                            </c:forEach>
                                                        </c:when>
                                                    </c:choose>
                                                </c:forEach>
                                            </c:when>
                                        </c:choose>
                                    </c:forEach>
                                </c:if>
                            </c:if>
                            
							<!--  SUBJECT -->		
                            <c:choose>
                                <c:when test="${studyPlanDetail.subjectId != 0}">
                                    <c:forEach var="subject" items="${allSubjects}" >
                                        <c:set var="subjectResultSave" value="" scope="page" />
                                        <c:choose>
                                            <c:when test="${subject.id == studyPlanDetail.subjectId}" >
                                                <tr>
                                                <td>
                                                   <c:forEach var="studyGradeType" items="${allStudyGradeTypes}">
				                                     	<c:choose>
				                                        	<c:when test="${oneStudyPlanDetail.studyGradeTypeId != 0
				                                                      && studyGradeType.id == studyGradeTypeId}">
			                                                    <c:forEach var="academicYear" items="${allAcademicYears}">
			                                                      <c:choose>
			                                                         <c:when test="${studyGradeType.academicYearId != 0
			                                                                      && academicYear.id == studyGradeType.academicYearId}">
			                                                            ${academicYear.description}
			                                                         </c:when>
			                                                      </c:choose>
			                                                    </c:forEach>
			                                                </c:when>
			                                            </c:choose>
			                                        </c:forEach>
                                                </td>
                                                <td>&nbsp;</td>
                                                <td>${subject.subjectDescription}</td>
                                                <td>
	                                                <table>
	                                                <c:forEach var="subjectResult" items="${allSubjectResults}">
	                                                    <c:choose>
	                                                        <c:when test="${subjectResult.subjectId == subject.id
	                                                                 && subjectResult.studyPlanDetailId == studyPlanDetail.id}">
	                                                            <c:set var="subjectResultSave" value="${subjectResult.id}" scope="page" />
	                                                            <tr>
	                                                            <td>
	                                                            <fmt:formatDate pattern="dd/MM/yyyy" value="${subjectResult.subjectResultDate}" /> (<fmt:message key="jsp.general.mark" />: ${subjectResult.mark})
	                                                            </td>
	                                                          </tr>
	                                                        </c:when>   
	                                                    </c:choose>
	                                                </c:forEach>
	                                                </table>
                                                </td>
                                            </tr>
                                            </c:when>
                                        </c:choose>
                                    </c:forEach>
                                </c:when>
                            </c:choose>
                    	</c:forEach>
                    	<tr><td colspan="4"><hr /></td></tr>
                	</table>                        
                </c:forEach>
                </spring:bind>
            </div>
        </div>
    </div>
</div>
