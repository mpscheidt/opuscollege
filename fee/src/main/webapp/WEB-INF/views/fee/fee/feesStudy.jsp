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


<c:set var="authUpdateFee" value="${false}"/>
<sec:authorize access="hasRole('UPDATE_FEES')">
    <c:set var="authUpdateFee" value="${true}"/>
</sec:authorize>
    

<div id="tabcontent">

	<fieldset><legend>
        <a href="<c:url value='/fee/feesstudies.view?currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
		<c:choose>
			<c:when test="${study.studyDescription != null && study.studyDescription != ''}" >
				${fn:substring(study.studyDescription,0,initParam.iTitleLength)}
			</c:when>
		</c:choose>
	</legend>
	</fieldset>

    <div id="tp1" class="TabbedPanel">
    <ul class="TabbedPanelsTabGroup">
        <li class="TabbedPanelsTab"><fmt:message key="jsp.menu.fees" /></li>               
    </ul>

    <div class="TabbedPanelsContentGroup">
    <div class="TabbedPanelsContent">
    <div class="Accordion" id="Accordion0" tabindex="0">
    <div class="AccordionPanel">
    <div class="AccordionPanelTab"><fmt:message key="jsp.menu.fees" /></div>
    <div class="AccordionPanelContent">

    <table>
        <!-- DESCRIPTION -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.study" /></td>
            <td>
                ${study.studyDescription}
            </td>
            <td></td>
        </tr>

		<sec:authorize access="hasAnyRole('READ_PRIMARY_AND_CHILD_ORG_UNITS','UPDATE_ORG_UNITS','UPDATE_BRANCHES','UPDATE_INSTITUTIONS')">
            <!-- ORG UNIT -->
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

        <!-- ACADEMIC FIELD -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.academicfield" /></td>
            <td>
                    <c:forEach var="academicField" items="${allAcademicFields}">
                        <c:choose>
                            <c:when test="${academicField.code == study.academicFieldCode}">
                                ${academicField.description}
                            </c:when>
                        </c:choose>
                    </c:forEach>
             </td>
            <td></td>
        </tr>

        <!-- DATE OF ESTABLISHMENT -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.dateofestablishment" /></td>
            <td>
            <fmt:formatDate type="date" value="${study.dateOfEstablishment}" />
            </td>
            <td></td>
        </tr>

        <!-- START DATE -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.startdate" /></td>
            <td>
            <fmt:formatDate type="date" value="${study.startDate}" />
            </td>
            <td></td>
        </tr>

        <!-- ACTIVE -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.active" /></td>
            <td>
                <c:choose>
                    <c:when test="${'Y' == study.active}">
                        <fmt:message key="jsp.general.yes" />
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="jsp.general.no" />
                    </c:otherwise>
                   </c:choose>
            </td>
            <td></td>
        </tr>
    <tr><td colspan=3><br /><br /></td></tr>
    </table>

    <!-- FEES -->

    <%@ include file="../../includes/pagingHeader.jsp"%>

    <table class="tabledata2" id="TblData_feesstudy">
        <!--  StudyGradeType -->
        <sec:authorize access="hasRole('CREATE_FEES')">
			<tr>
              	<td colspan="8" class="header"><fmt:message key="jsp.menu.fees.studygradetype" /></td>
                <td align="right">
                <a class="button" href="<c:url value='/fee/feeStudyGradeType.view?newForm=true&tab=0&panel=0&studyId=${study.id}&currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
		        </td>
    		</tr>
        </sec:authorize>
        <tr>
            <td class="label"><fmt:message key="jsp.general.studygradetype" /></td>
            <td class="label"><fmt:message key="jsp.fees.category" /></td>
            <td class="label"><fmt:message key="jsp.general.cardinaltimeunit" /></td>       
            <td class="label"><fmt:message key="jsp.general.studyintensity" /></td>
            <td class="label"><fmt:message key="jsp.general.feedue" /></td>
            <td class="label"><fmt:message key="jsp.fee.feeunit" /></td>
            <td class="label"><fmt:message key="general.deadlines" /></td>
            <td class="label"><fmt:message key="jsp.general.active" /></td>
            <td>&nbsp;</td>
        </tr>
            <c:forEach var="feeForStudyGradeType" items="${allFeesForStudyGradeTypes}">
                <tr>
					<td>
                   	    <c:forEach var="studyGradeType" items="${allStudyGradeTypes}">
                        	<c:choose>
                        		<c:when test="${studyGradeType.id == feeForStudyGradeType.studyGradeTypeId}">

                                <fmt:message key="format.gradetype.academicyear.studyform.studytime">
                                    <fmt:param value="${studyGradeType.gradeTypeDescription}" />
                                    <fmt:param value="${idToAcademicYearMap[studyGradeType.currentAcademicYearId].description}" />
                                    <fmt:param value="${codeToStudyFormMap[studyGradeType.studyFormCode].description}" />
                                    <fmt:param value="${codeToStudyTimeMap[studyGradeType.studyTimeCode].description}" />
                                </fmt:message>

                        		 </c:when>
                        	</c:choose>
                        </c:forEach>
                    </td>

                    <td>
                    	<c:forEach var="feeCategory" items="${allFeeCategories}">
							<c:if test="${feeCategory.code == feeForStudyGradeType.categoryCode}">
								${feeCategory.description}
							</c:if>
                    	</c:forEach>
                    </td>
                    
                    <%-- cardinal time unit number: 0 (any), 1, 2, 3, ... --%>
                    <td>
                        <c:choose>
                            <c:when test="${feeForStudyGradeType.cardinalTimeUnitNumber == 0}">
                                <fmt:message key="jsp.general.any" />
                            </c:when>
                            <c:otherwise>
                                ${feeForStudyGradeType.cardinalTimeUnitNumber }
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <%-- study intensity --%>
                    <td>
                        ${codeToStudyIntensityMap[feeForStudyGradeType.studyIntensityCode].description }
                    </td>

                    <%-- feeDue --%>
                    <td>
                        <c:choose>
                            <c:when test="${authUpdateFee}">
                                <a href="<c:url value='/fee/feeStudyGradeType.view?newForm=true&studyId=${study.id}&feeId=${feeForStudyGradeType.id}&currentPageNumber=${currentPageNumber}'/>">
                                    ${feeForStudyGradeType.feeDue}
                                </a>
                            </c:when>
                            <c:otherwise>
                                ${feeForStudyGradeType.feeDue}
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <%-- fee unit --%>
                    <td>
                        ${allFeeUnitsMap[feeForStudyGradeType.feeUnitCode].description }
                    </td>
                    
                    <%-- deadline --%>
                    <td style="text-align: center">
                        <c:forEach items="${feeForStudyGradeType.deadlines}" var="feeDeadline">
						  <c:choose>
                              <c:when test="${not empty feeDeadline.deadline && (feeDeadline.deadline < currentDate)}">
                                        <span style="color:#bf1616;">
                                        	<fmt:formatDate pattern="dd/MM/yyyy" value="${feeDeadline.deadline}" />
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                    <span style="color:#036f43;">
                                    	<fmt:formatDate pattern="dd/MM/yyyy" value="${feeDeadline.deadline}" />
                                    </span> 
                                    </c:otherwise>
                          </c:choose>
                             	<br/>
                       </c:forEach> 
                    </td>

<%--                                                <c:if test="${modules != null && modules != ''}">
                                                    <c:forEach var="module" items="${modules}">
                                                        <c:if test="${module.module eq 'accommodation'}">
                                                            <td>
                                                                <c:forEach var="accommodationFee" items="${allAccommodationFees}">
                                                                  <c:if test="${accommodationFee.id == feeForSubjectStudyGradeType.accommodationFeeId}">
                                                                      ${accommodationFee.description}
                                                                    </c:if>
                                                                </c:forEach>
                                                            </td>
                                                        </c:if>
                                                    </c:forEach>
                                                </c:if> --%>
                    <td style="text-align: center">
                      <c:choose>
                    	<c:when test="${'Y' == feeForStudyGrade.active}">
                        	<fmt:message key="jsp.general.yes" />
                    	</c:when>
                    	<c:otherwise>
                        	<fmt:message key="jsp.general.no" />
                    	</c:otherwise>
                   	</c:choose>
                    </td>
                     <td class="buttonsCell" >
                        <c:if test="${authUpdateFee}">
                            <a href="<c:url value='/fee/feeStudyGradeType.view?newForm=true&studyId=${study.id}&feeId=${feeForStudyGradeType.id}&currentPageNumber=${currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                        </c:if>
                        &nbsp;&nbsp;
                        <sec:authorize access="hasRole('UPDATE_FEES')">
                            <a href="<c:url value='/fee/fee_delete.view?tab=1&panel=0&studyId=${study.id}&feeId=${feeForStudyGradeType.id}&currentPageNumber=${currentPageNumber}'/>"
                                onclick="return confirm('<fmt:message key="jsp.fees.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                        </sec:authorize>
                     </td>
                </tr>
            </c:forEach>

            <tr><th colspan="4">&nbsp;</th></tr>

            <!--  fees on subjects and subjectblocks -->
            <tr>
              	<td colspan="8" class="header">
              	<fmt:message key="jsp.menu.fees.subject" />
              	<c:if test="${appUseOfSubjectBlocks == 'Y'}">
              	   &nbsp;<fmt:message key="jsp.general.and" />&nbsp;<fmt:message key="jsp.general.subjectblocks" />
              	</c:if>
              	</td>
                <td align="right">
                    <a class="button" href="<c:url value='/fee/feeSubjectAndSubjectBlock.view?tab=0&panel=0&studyId=${study.id}&currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                </td>
            </tr>
            
            <c:if test="${appUseOfSubjectBlocks == 'Y'}">
            
                <!--  SUBJECTBLOCKS --> 

                <tr>
                    <td class="label"><fmt:message key="jsp.general.subjectblock" /></td>
                    <td class="label"><fmt:message key="jsp.general.studygradetype" /></td>
                    <td class="label"><fmt:message key="jsp.general.studyform" /></td>
					<td class="label"><fmt:message key="jsp.general.studytime" /></td>
					<td class="label"><fmt:message key="jsp.general.cardinaltimeunit.number" /></td>       
                	<td class="label"><fmt:message key="jsp.general.feedue" /></td>
                    <td class="label"><fmt:message key="general.deadlines" /></td>
                    <td class="label"><fmt:message key="jsp.general.active" /></td> 
                    <td>&nbsp;</td>                                        
                </tr>
                
                <c:forEach var="feeForSubjectStudyGradeTypeBlock" items="${allFeesForSubjectBlockStudyGradeTypes}">
                <tr>
					<td>	
                   	    <c:forEach var="subjectBlockStudyGradeType" items="${allSubjectBlockStudyGradeTypes}">
                        	<c:choose>
                        		<c:when test="${subjectBlockStudyGradeType.id == feeForSubjectStudyGradeTypeBlock.subjectBlockStudyGradeTypeId}">
                        			${subjectBlockStudyGradeType.subjectBlock.subjectBlockDescription}
                        			<c:forEach var="academicYear" items="${allAcademicYears}">
                                         <c:choose>
                                             <c:when test="${academicYear.id != 0
                                                          && academicYear.id == subjectBlockStudyGradeType.subjectBlock.currentAcademicYearId}">
                                                &nbsp;(${academicYear.description})
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
                        		<c:when test="${subjectBlockStudyGradeType.id == feeForSubjectStudyGradeTypeBlock.subjectBlockStudyGradeTypeId}">               			
<%-- TODO: gradeTypeDescription needs to be replaced by codeToLookupMap, because it is not filled anymore, see subjectblock.jsp for example --%>
                        			${subjectBlockStudyGradeType.studyGradeType.gradeTypeDescription}
                        		 </c:when>
                        	</c:choose>
                     </c:forEach>
                    </td>
                    <td>   
                        <c:forEach var="subjectBlockStudyGradeType" items="${allSubjectBlockStudyGradeTypes}">
                        	<c:if test="${subjectBlockStudyGradeType.id == feeForSubjectStudyGradeTypeBlock.subjectBlockStudyGradeTypeId}">
				                 <c:forEach var="studyForm" items="${allStudyForms}">
			                       <c:if test="${studyForm.code == subjectBlockStudyGradeType.studyGradeType.studyFormCode}">
			                           ${studyForm.description}
			                        </c:if>
			                    </c:forEach>
                    	   </c:if>
                        </c:forEach>
                     </td>
                     <td>
                 	    <c:forEach var="subjectBlockStudyGradeType" items="${allSubjectBlockStudyGradeTypes}">
                           <c:if test="${subjectBlockStudyGradeType.id == feeForSubjectStudyGradeTypeBlock.subjectBlockStudyGradeTypeId}">	
	 		                   <c:forEach var="studyTime" items="${allStudyTimes}">
		                           <c:if test="${studyTime.code == subjectBlockStudyGradeType.studyGradeType.studyTimeCode}">
		                               ${studyTime.description}
		                           </c:if>
		                       </c:forEach>
							</c:if>
                        </c:forEach>
                     </td>
                     <td>
                      	<c:forEach var="subjectBlockStudyGradeType" items="${allSubjectBlockStudyGradeTypes}">
                            	<c:choose>
                            		<c:when test="${subjectBlockStudyGradeType.id == feeForSubjectStudyGradeTypeBlock.subjectBlockStudyGradeTypeId}">
                            			${subjectBlockStudyGradeType.cardinalTimeUnitNumber}
                            		 </c:when>
                            	</c:choose>
                          </c:forEach>
                    </td>
					<td>
                      	<a href="<c:url value='/fee/feeSubjectAndSubjectBlock.view?studyId=${study.id}&feeId=${feeForSubjectStudyGradeTypeBlock.id}&currentPageNumber=${currentPageNumber}'/>">
                      		${feeForSubjectStudyGradeTypeBlock.feeDue}
                       	</a>
                    </td>
                    <td style="text-align: center">
                    <c:forEach items="${feeForSubjectStudyGradeTypeBlock.deadlines}" var="feeDeadline">
                     	<fmt:formatDate pattern="dd/MM/yyyy" value="${feeDeadline.deadline}" />
                          <br/>
					</c:forEach>
                    <%-- 
                    	<fmt:formatDate type="date" value="${feeForSubjectStudyGradeTypeBlock.deadline}" />
                    	--%>
                    </td>

                    <td style="text-align: center">
                      <c:choose>
                    	<c:when test="${'Y' == feeForSubjectStudyGradeTypeBlock.active}">
                        	<fmt:message key="jsp.general.yes" />
                    	</c:when>
                    	<c:otherwise>
                        	<fmt:message key="jsp.general.no" />
                    	</c:otherwise>
                   	</c:choose>
                    </td>
                    <td class="buttonsCell"><a href="<c:url value='/fee/feeSubjectAndSubjectBlock.view?studyId=${study.id}&feeId=${feeForSubjectStudyGradeTypeBlock.id}&currentPageNumber=${currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                       &nbsp;&nbsp;
						<a href="<c:url value='/fee/fee_delete.view?tab=1&panel=0&studyId=${study.id}&feeId=${feeForSubjectStudyGradeTypeBlock.id}&currentPageNumber=${currentPageNumber}'/>" 
                           onclick="return confirm('<fmt:message key="jsp.fees.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                     </td>
                </tr>
            </c:forEach>
            <tr><th colspan="4">&nbsp;</th></tr> 
        </c:if>
			
        <!--  SUBJECTS -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.subject" /></td>
            <td class="label"><fmt:message key="jsp.general.studygradetype" /></td>                                        
            <td class="label"><fmt:message key="jsp.general.studyform" /></td> 
            <td class="label"><fmt:message key="jsp.general.studytime" /></td>
            <td class="label"><fmt:message key="jsp.general.cardinaltimeunit.number" /></td>                                                                                     
        	<td class="label"><fmt:message key="jsp.general.feedue" /></td>
            <td class="label"><fmt:message key="general.deadlines" /></td>
            <td class="label"><fmt:message key="jsp.general.active" /></td>
            <td>&nbsp;</td>
        </tr>
        <c:forEach var="feeForSubjectStudyGradeType" items="${allFeesForSubjectStudyGradeTypes}">
        <tr>                                        
	        <td>	
               	<c:forEach var="subjectStudyGradeType" items="${allSubjectStudyGradeTypes}">
                    	<c:choose>
                    		<c:when test="${subjectStudyGradeType.id == feeForSubjectStudyGradeType.subjectStudyGradeTypeId}">
                    			${subjectStudyGradeType.subject.subjectDescription}
                    			<c:forEach var="academicYear" items="${allAcademicYears}">
                         <c:choose>
                             <c:when test="${academicYear.id != 0
                                          && academicYear.id == subjectStudyGradeType.subject.currentAcademicYearId}">
                                &nbsp;(${academicYear.description})
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
                    		<c:when test="${subjectStudyGradeType.id == feeForSubjectStudyGradeType.subjectStudyGradeTypeId}">               			
<%-- TODO: gradeTypeDescription needs to be replaced by codeToLookupMap, because it is not filled anymore, see subject.jsp for example --%>
                    			${subjectStudyGradeType.studyGradeType.gradeTypeDescription}
                    		 </c:when>
                    	</c:choose>
                 </c:forEach>
                </td>
                <td>   
              	<c:forEach var="subjectStudyGradeType" items="${allSubjectStudyGradeTypes}">
                    	<c:choose>
                     		 <c:when test="${subjectStudyGradeType.id == feeForSubjectStudyGradeType.subjectStudyGradeTypeId}">
                    <c:forEach var="studyForm" items="${allStudyForms}">
                       <c:choose>
                        <c:when test="${studyForm.code == subjectStudyGradeType.studyGradeType.studyFormCode}">
                            ${studyForm.description}
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
                    		 <c:when test="${subjectStudyGradeType.id == feeForSubjectStudyGradeType.subjectStudyGradeTypeId}">	
                    <c:forEach var="studyTime" items="${allStudyTimes}">
                       <c:choose>
                        <c:when test="${studyTime.code == subjectStudyGradeType.studyGradeType.studyTimeCode}">
                            ${studyTime.description}
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
                    		 <c:when test="${subjectStudyGradeType.id == feeForSubjectStudyGradeType.subjectStudyGradeTypeId}">	
						${subjectStudyGradeType.cardinalTimeUnitNumber}
				</c:when>
                		</c:choose>
                 </c:forEach>
                 </td>          
				<td>
                  	<a href="<c:url value='/fee/feeSubjectAndSubjectBlock.view?studyId=${study.id}&feeId=${feeForSubjectStudyGradeType.id}&currentPageNumber=${currentPageNumber}'/>">
                  		${feeForSubjectStudyGradeType.feeDue}
                   	</a>
                </td>
                <td style="text-align: center">
                <c:forEach items="${feeForSubjectStudyGradeType.deadlines}" var="feeDeadline">
                     	<fmt:formatDate pattern="dd/MM/yyyy" value="${feeDeadline.deadline}" />
                          <br/>
				</c:forEach>
                </td>
               
                <td style="text-align: center">
                      <c:choose>
                    	<c:when test="${'Y' == feeForSubjectStudyGradeType.active}">
                        	<fmt:message key="jsp.general.yes" />
                    	</c:when>
                    	<c:otherwise>
                        	<fmt:message key="jsp.general.no" />
                    	</c:otherwise>
                   	</c:choose>
                    </td>
                <td align="right"><a href="<c:url value='/fee/feeSubjectAndSubjectBlock.view?studyId=${study.id}&feeId=${feeForSubjectStudyGradeType.id}&currentPageNumber=${currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                   &nbsp;&nbsp;
		           <a href="<c:url value='/fee/fee_delete.view?tab=1&panel=0&studyId=${study.id}&feeId=${feeForSubjectStudyGradeType.id}&currentPageNumber=${currentPageNumber}'/>" 
                       onclick="return confirm('<fmt:message key="jsp.fees.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                 </td>
            </tr>
        </c:forEach>
        <tr><td colspan="4"></td></tr> 
    </table>
    <script type="text/javascript">alternate('TblData_feesstudy',true)</script>

    <%--  end accordionpanelcontent --%>
    </div>
    <%--  end accordionpanel --%>
    </div>
    <%-- end of accordion 1 --%>
    </div>
    <script type="text/javascript">
        var Accordion0 = new Spry.Widget.Accordion("Accordion0",
              {defaultPanel: 0,
              useFixedPanelHeights: false,
              nextPanelKeyCode: 78 /* n key */,
              previousPanelKeyCode: 80 /* p key */
             });
    </script>
    <%--  end tabbedpanelscontent --%>
    </div>
    <%--  end tabbed panelscontentgroup --%>    
    </div>
    <%--  end tabbed panel --%>    
    </div>
        
    <%-- end tabcontent --%>
    </div>   
    
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(<%=request.getParameter("tab")%>);
       	Accordion<%=request.getParameter("tab")%>.defaultPanel = <%=request.getParameter("panel")%>;
       	Accordion<%=request.getParameter("tab")%>.openPanelNumber(<%=request.getParameter("panel")%>);
    </script>

<!-- end tabwrapper -->    
</div>

<%@ include file="../../footer.jsp"%>

