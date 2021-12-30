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

<%--
 * Copyright (c) 2007 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
--%>

<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>
    
    <spring:bind path="subjectBlockForm.subjectBlock">
        <c:set var="subjectBlock" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectBlockForm.organization">
        <c:set var="organization" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectBlockForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>

    <%-- decide whether to display read-only or allow to edit --%>
    <c:set var="authorizedToEdit" value="${false}"/>
    <sec:authorize access="hasRole('UPDATE_SUBJECTBLOCKS')">
        <c:set var="authorizedToEdit" value="${true}"/>
    </sec:authorize>

    <div id="tabcontent">

        <form>
        <fieldset>
            <legend>
                <a href="<c:url value='/college/subjectblocks.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
                <c:choose>
                    <c:when test="${subjectBlock.subjectBlockDescription != null && subjectBlock.subjectBlockDescription != ''}" >
                    ${fn:substring(subjectBlock.subjectBlockDescription,0,initParam.iTitleLength)}
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="jsp.href.new" />
                    </c:otherwise>
                </c:choose>
            </legend>

            <%--Display Error Messages because it must be visible if an error occurred in any tab --%>
            <form:errors path="subjectBlockForm.*" cssClass="errorwide" element="p"/>

<%--            <c:choose>        
                <c:when test="${ not empty showSubjectBlockError }">       
                    <p align="left" class="errorwide">
                        ${subjectBlockForm.showSubjectBlockError}
                    </p>
                </c:when>
            </c:choose> --%>

            </fieldset>
        </form>

        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab compulsoryTab"><fmt:message key="jsp.general.subjectblock" /></li>    
                <c:choose>
                    <c:when test="${'' != subjectBlock.id && 0 != subjectBlock.id}">
	                    <li class="TabbedPanelsTab compulsoryTab"><fmt:message key="jsp.general.study" />&nbsp;<fmt:message key="jsp.general.gradetypes" /></li>                           
                		<li class="TabbedPanelsTab compulsoryTab"><fmt:message key="jsp.general.subjects" /></li>
                    </c:when>
                </c:choose>
            </ul>

            <div class="TabbedPanelsContentGroup">
               
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion0" tabindex="0">

                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.general.subjectblock" /></div>
                            <div class="AccordionPanelContent">
								
								<c:choose>
                                      <c:when test="${(not empty subjectBlockForm.showSubjectBlockError) && authorizedToEdit}">             
                                          <p align="left" class="msg">
                                               ${subjectBlockForm.showSubjectBlockError }
                                          </p>
                                      </c:when>
                                </c:choose>
								
                                <form name="formdata" method="post">
                                    <input type="hidden" name="submitFormObject" id="submitFormObject" value="" />
                                    
                                    <%@ include file="../../includes/organizationAndNavigationDetail.jsp"%>

    								<table>
                                        <!-- PRIMARY STUDY -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.primarystudy" /></td>
                                            <spring:bind path="subjectBlockForm.subjectBlock.primaryStudyId">
                                            <td class="required">
                                            <c:choose>
                                                <c:when test="${authorizedToEdit}">
                                                    <select name="${status.expression}" id="${status.expression}" onchange="document.formdata.submit();">
                                                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                </c:when>
                                                </c:choose>
                                                    <c:forEach var="oneStudy" items="${subjectBlockForm.allPrimaryStudies}">
                                                        <c:choose>
                                                            <c:when test="${authorizedToEdit}">
                                                                <c:choose>
                                                                    <c:when test="${oneStudy.id == status.value}">
                                                                        <option value="${oneStudy.id}" selected="selected">${oneStudy.studyDescription}</option>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <option value="${oneStudy.id}">${oneStudy.studyDescription}</option>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:choose>
                                                                    <c:when test="${oneStudy.id == status.value}">
                                                                        ${oneStudy.studyDescription}
                                                                    </c:when>
                                                                </c:choose>
                                                            </c:otherwise>
                                                            </c:choose>
                                                    </c:forEach>
                                                <c:choose>
                                                <c:when test="${authorizedToEdit}">
                                                    </select>
                                                </c:when>
                                            </c:choose>
                                            </td>
                                            <td colspan="2"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </spring:bind>
                                        </tr>
                                        
                                        <!-- CODE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.code" /></td>
                                            <td>
                                            
					               	 		<c:choose>
					               				<c:when test="${authorizedToEdit}">
                                               		<input type="text" name="subjectBlock.subjectBlockCode" size="40" maxlength="255" value="<c:out value="${subjectBlock.subjectBlockCode}" />"/>
                                               	</c:when>
                                               	<c:otherwise>
                                               		${subjectBlock.subjectBlockCode}
                                               	</c:otherwise>
                                            </c:choose>
                                            </td> 
                                            <td>
					               	 		<c:choose>
					               				<c:when test="${authorizedToEdit}">
                                            		<fmt:message key="jsp.general.message.codegenerated" />
                                               	</c:when>
                                            </c:choose>
                                            </td>
                                        </tr>

                                        <!-- DESCRIPTION -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.description" /></td>
                                            <spring:bind path="subjectBlockForm.subjectBlock.subjectBlockDescription">
                                            <td class="required">
					               	 		<c:choose>
					               				<c:when test="${authorizedToEdit}">
                                               		<input type="text" name="${status.expression}" size="40" maxlength="255" value="<c:out value="${status.value}" />"/>
                                               	</c:when>
                                               	<c:otherwise>
                                               		${status.value}
                                               	</c:otherwise>
                                            </c:choose>
                                            </td>
                                            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </spring:bind>
                                        </tr>

                                  		<!--  CURRENT ACADEMIC YEAR -->
                                      	<tr>
                                		<td class="label"><fmt:message key="jsp.general.academicyear" /></td>
                                		<spring:bind path="subjectBlockForm.subjectBlock.currentAcademicYearId">
                                		<td class="required">
						               	 	<c:choose>
						               			<c:when test="${authorizedToEdit}">
                                            		<select name="${status.expression}" id="${status.expression}" 
                                            		<%--onchange="alert('<fmt:message key="jsp.warning.academicyearchange.subjectblockstudygradetypes" />');" --%>
                                            		>
                                                		<option value="-"><fmt:message key="jsp.selectbox.choose" /></option>
                                                        <c:forEach var="academicYear" items="${subjectBlockForm.allAcademicYears}">
            						               	 		<c:choose>
            						               				<c:when test="${authorizedToEdit}">
            	                                                     <c:choose>
            	                                                         <c:when test="${academicYear.id != 0
            	                                                                      && academicYear.id == status.value}">
            	                                                             <option value="${academicYear.id}" selected="selected">${academicYear.description}</option> 
            	                                                         </c:when>
            	                                                         <c:otherwise>
            	                                                             <option value="${academicYear.id}">${academicYear.description}</option> 
            	                                                         </c:otherwise>
            	                                                     </c:choose>
            	                                                 </c:when>
            	                                                 <c:otherwise>
            	                                                 	${academicYear.description}
            	                                                 </c:otherwise>
            	                                             </c:choose>
                                                        </c:forEach>
                                            		</select>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:choose>
                                                        <c:when test="${not empty subjectBlockForm.idToAcademicYearMap[status.value]}">
                                                            ${subjectBlockForm.idToAcademicYearMap[status.value].description}
                                                        </c:when>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>	
                                		</td>
                                        <td>
                                        	<c:forEach var="error" items="${status.errorMessages}"><span class="error">
                                            ${error}</span></c:forEach>
                                        </td>
                                        </spring:bind>
                                	</tr>

				                       <!-- STUDY TIME -->
				                        <tr>
				                            <td class="label"><fmt:message key="jsp.general.studytime" /></td>
                                            <spring:bind path="subjectBlockForm.subjectBlock.studyTimeCode">
                                            <td class="required">
    						               	 	<c:choose>
    						               			<c:when test="${authorizedToEdit}">
                                                		<select name="${status.expression}">
                                                    		<option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    </c:when>
                                                </c:choose>	
    				                            <c:forEach var="studyTime" items="${subjectBlockForm.allStudyTimes}">
    						               	 		<c:choose>
    						               				<c:when test="${authorizedToEdit}">
    				                                       <c:choose>
    				                                           <c:when test="${studyTime.code == status.value}">
    				                                               <option value="${studyTime.code}" selected="selected">${studyTime.description}</option>
    				                                           </c:when>
    				                                           <c:otherwise>
    				                                           		<option value="${studyTime.code}">${studyTime.description}</option>
    				                                           </c:otherwise>
    				                                       </c:choose>
    				                                   </c:when>
    				                                   <c:otherwise>
    				                                   		${studyTime.description}
    				                                   </c:otherwise>
    				                               </c:choose>
    				                            </c:forEach>
    						               	 	<c:choose>
    						               			<c:when test="${authorizedToEdit}">
                                          				</select>
                                                    </c:when>
                                                </c:choose>	
                                            </td> 
                                          	<td>
                                          		<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                </c:forEach>
                                            </td>
                                            </spring:bind>
				                       </tr>

                                        
				                        <tr>
				                            <td class="label"><fmt:message key="jsp.general.blockType" /></td>
                                            <td>
						               	 	<c:choose>
						               			<c:when test="${authorizedToEdit}">
                                            		<select name="subjectBlock.blockTypeCode">
                                                		<option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                </c:when>
                                            </c:choose>	
				                            <c:forEach var="blockType" items="${subjectBlockForm.allBlockTypes}">
						               	 		<c:choose>
						               				<c:when test="${authorizedToEdit}">
				                                       <c:choose>
				                                           <c:when test="${blockType.code == subjectBlock.blockTypeCode}">
				                                               <option value="${blockType.code}" selected="selected">${blockType.description}</option>
				                                           </c:when>
				                                           <c:otherwise>
				                                           		<option value="${blockType.code}">${blockType.description}</option>
				                                           </c:otherwise>
				                                       </c:choose>
				                                    </c:when>
				                                    <c:otherwise>
				                                    	${blockType.description}
				                                    </c:otherwise>
				                                </c:choose>
				                            </c:forEach>
						               	 	<c:choose>
						               			<c:when test="${authorizedToEdit}">
		                                      		</select>
                                                </c:when>
                                            </c:choose>	
                                            </td> 
                                          	<td></td>
				                       </tr>

                                        <!-- BRs MAX CONTACT HOURS -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.brsmaxcontacthours" /></td>
                                            <td>
					               	 		<c:choose>
					               				<c:when test="${authorizedToEdit}">
                                               		<input type="text" name="subjectBlock.brsMaxContactHours" size="10" maxlength="10" value="<c:out value="${subjectBlock.brsMaxContactHours}" />"/>
                                               	</c:when>
                                               	<c:otherwise>
                                               		${subjectBlock.brsMaxContactHours}
                                               	</c:otherwise>
                                            </c:choose>
                                            </td>
                                            <td></td>
                                        </tr>

										<!-- BRs PASSING SUBJECTBLOCK -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.brspassing" /></td>
                                            <td>
					               	 		<c:choose>
					               				<c:when test="${authorizedToEdit}">
                                               		<input type="text" name="subjectBlock.brsPassingSubjectBlock" size="3" maxlength="6" value="<c:out value="${subjectBlock.brsPassingSubjectBlock}" />"/>
                                               	</c:when>
                                               	<c:otherwise>
                                               		${subjectBlock.brsPassingSubjectBlock}
                                               	</c:otherwise>
                                            </c:choose>
                                            <td></td>
                                        </tr>

                                        <!-- SUBMIT BUTTON -->
                                       <tr>
                                            <td class="label">&nbsp;</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${authorizedToEdit}">
                                                        <input type="submit" name="submitformdata" value="<fmt:message key="jsp.button.submit" />" onclick="document.getElementById('submitFormObject').value='true';document.formdata.submit();" />
                                                    </c:when>
                                               </c:choose>
                                            </td>
                                        </tr>

                                    </table>
                                </form>
                                
                            <!--  end accordionpanelcontent -->
                            </div>
                        <!--  end accordionpanel -->
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
                        
                    </script>
                <!--  end tabbedpanelscontent -->
                </div>


<!------------- SUBJECTBLOCK STUDYGRADETYPES ------------------------------------------------->
                <spring:bind path="subjectBlockForm.subjectBlock.primaryStudyId">
                    <c:set var="primaryStudyId" value="${status.value}" scope="page" />
                </spring:bind>
                <spring:bind path="subjectBlockForm.subjectBlock.currentAcademicYearId">
                    <c:set var="currentAcademicYearId" value="${status.value}" scope="page" />
                </spring:bind>

                <!--  show tabs only when subjectblock already exists -->
                <c:choose>
                <c:when test="${'' != subjectBlock.id && 0 != subjectBlock.id}">
                <sec:authorize access="hasRole('READ_SUBJECTBLOCK_STUDYGRADETYPES')">
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion1" tabindex="0">

                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab compulsoryPanel">
                                <fmt:message key="jsp.subjectblock.message.studygradetype" />
                            </div>
                            <div class="AccordionPanelContent">
                              
                            <table class="tabledata2" id="TblData2_subjectblockstudygradetypes">
                                <sec:authorize access="hasRole('CREATE_SUBJECTBLOCK_STUDYGRADETYPES')">
	                                <tr>
                                        <th colspan="8" align="right">
	                                        <a class="button" href="<c:url value='/college/subjectblockstudygradetype.view?newForm=true&tab=1&panel=0&subjectBlockId=${subjectBlock.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
	                                    </th>
	                                </tr>
                                </sec:authorize>
                   
                                    <c:choose>
                                        <c:when test="${(not empty subjectBlockForm.showSubjectBlockStudyGradeTypeError)}">             
                                            <tr>
                                                <td colspan="7" class="error">
                                                    ${subjectBlockForm.showSubjectBlockStudyGradeTypeError }
                                                </td>
                                            </tr>
                                        </c:when>
                                    </c:choose>

                             	    <c:if test="${not empty subjectBlock.subjectBlockStudyGradeTypes}">
                                      	<tr>
                                           	<th><fmt:message key="jsp.general.studygradetype" /></th>
                                           	<th><fmt:message key="jsp.general.academicyear" /></th>
                                           	<th><fmt:message key="jsp.general.cardinaltimeunit" /></th>
                                		   	<th><fmt:message key="jsp.general.studytime" /></th>
                                			<th><fmt:message key="jsp.general.studyform" /></th>
                                            <th><fmt:message key="jsp.subject.rigiditytype" /></th>
                                			<c:if test="${initParam.iMajorMinor == 'Y'}">
                                                <th><fmt:message key="jsp.general.major" /> / <fmt:message key="jsp.general.minor" /></th>
                                            </c:if>
                                            <th><fmt:message key="jsp.general.active" /></th>
                                           	<th>&nbsp;</th>
                                      	</tr>
                                    </c:if>
	                                <c:forEach var="subjectBlockStudyGradeType" items="${subjectBlock.subjectBlockStudyGradeTypes}">
                                      <tr>
                                          <td>
                                            <c:out value="${subjectBlockStudyGradeType.studyGradeType.studyDescription }"/> - 
                                            <c:out value="${subjectBlockForm.codeToGradeTypeMap[subjectBlockStudyGradeType.studyGradeType.gradeTypeCode].description}"/>
                                          </td>
                                          <c:forEach var="studyGradeType" items="${subjectBlockForm.allStudyGradeTypes}">
                                            <c:choose>
                                               <c:when test="${studyGradeType.id == subjectBlockStudyGradeType.studyGradeType.id}">
                                               		<c:set var="currentAcademicYearId" value="${studyGradeType.currentAcademicYearId}" /> 
                                               		<c:set var="primaryStudyId" value="${studyGradeType.studyId}" />
                                               		<td>
<%--     		                                             <c:choose> --%>
<%--     		                                             	<c:when test="${studyGradeType.currentAcademicYearId != 0}"> --%>
<%--     		                                              	<c:forEach var="academicYear" items="${subjectBlockForm.allAcademicYears}"> --%>
<%--     		                                               	<c:choose> --%>
<%--     		                                               		<c:when test="${academicYear.id == studyGradeType.currentAcademicYearId}"> --%>
<%--     		                                            				${academicYear.description} --%>
<%--     		                                                		</c:when> --%>
<%--     		                                               	</c:choose> --%>
<%--     		                                           	</c:forEach> --%>
<%--     		                                           </c:when> --%>
<%--     		                                         </c:choose>  --%>
                                                    <c:choose>
                                                        <c:when test="${not empty subjectBlockForm.idToAcademicYearMap[studyGradeType.currentAcademicYearId]}">
                                                            ${subjectBlockForm.idToAcademicYearMap[studyGradeType.currentAcademicYearId].description}
                                                        </c:when>
                                                    </c:choose>
                                             	</td> 
                                             	<td>
                                             		${subjectBlockStudyGradeType.cardinalTimeUnitNumber }
                                             	</td>
                                             	<td>
                                                 <c:choose>
                                                 	<c:when test="${studyGradeType.studyTimeCode != ''}">
    	                                             <c:forEach var="studyTime" items="${subjectBlockForm.allStudyTimes}">
    	                                               <c:choose>
    	                                               		<c:when test="${studyTime.code == studyGradeType.studyTimeCode}">
    	                                            	 	${studyTime.description}
                                                    		</c:when>
                                                   		</c:choose>
                                                   	</c:forEach> 
                                                   	</c:when>
                                                 </c:choose>
                                                </td>
                                         		<td>
                                                 <c:choose>
                                                 	<c:when test="${studyGradeType.studyFormCode != '' }">
    		                                            <c:forEach var="studyForm" items="${subjectBlockForm.allStudyForms}">
    		                                               <c:choose>
    		                                               <c:when test="${studyForm.code == studyGradeType.studyFormCode}">
    		                                            		${studyForm.description}
    		                                                </c:when>
    		                                               </c:choose>
    		                                            </c:forEach> 
                                              		</c:when>
                                           		</c:choose>
                                   				</td>
                                                <td>
                                                   <c:forEach var="rigidityType" items="${subjectBlockForm.allRigidityTypes}">
                                                      <c:choose>
                                                          <c:when test="${rigidityType.code == subjectBlockStudyGradeType.rigidityTypeCode}">
                                                            ${rigidityType.description}
                                                          </c:when>
                                                      </c:choose>
                                                   </c:forEach> 
                                                </td>
                                                <c:if test="${initParam.iMajorMinor == 'Y'}">
                                                <td>
                                                    <c:forEach var="importanceType" items="${subjectBlockForm.allImportanceTypes}">
                                                        <c:choose>
                                                            <c:when test="${importanceType.code == subjectBlockStudyGradeType.importanceTypeCode}">
                                                              ${importanceType.description}
                                                            </c:when>
                                                        </c:choose>
                                                   </c:forEach> 
                                               </td>
                                            </c:if>
                                    		  </c:when>
                                 			</c:choose>
                             			</c:forEach>
                             				
                                     <td>
                              			${subjectBlockStudyGradeType.active}
                          			 </td>
                                     <td class="buttonsCell">
                                        <sec:authorize access="hasRole('UPDATE_SUBJECTBLOCK_STUDYGRADETYPES')">
                                            <a class="imageLink" href="<c:url value='/college/subjectblockstudygradetype.view?newForm=true&tab=1&panel=0&subjectBlockId=${subjectBlock.id}&subjectBlockStudyGradeTypeId=${subjectBlockStudyGradeType.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                <img src="<c:url value='/images/edit.gif' />" 
                                                alt="<fmt:message key="jsp.href.edit" />" 
                                                title="<fmt:message key="jsp.href.edit" />" />
                                            </a>
                                        </sec:authorize>
                                        <sec:authorize access="hasRole('DELETE_SUBJECTBLOCK_STUDYGRADETYPES')">
                                            <a class="imageLinkPaddingLeft" href="<c:url value='/college/subjectblockstudygradetype_delete.view?newForm=true&tab=1&panel=0&subjectBlockStudyGradeTypeId=${subjectBlockStudyGradeType.id}&subjectBlockId=${subjectBlock.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"  
                                            onclick="return confirm('<fmt:message key="jsp.studygradetype.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                        </sec:authorize>
                                     </td> 
                                  </tr>                
		                       	</c:forEach>
                           </table>
                           <script type="text/javascript">alternate('TblData2_subjectblockstudygradetypes',true)</script>
                           <table>
                           	   <tr>
	                               <td colspan="6"></td>
	                            </tr>
	                        </table> 
                                       	
                           <!--  end accordionpanelcontent -->
                            </div>
                        <!--  end accordionpanel -->
                        </div>
                    
                    <!-- end of accordion 1 -->
                    </div>
                    <script type="text/javascript">
                        var Accordion1 = new Spry.Widget.Accordion("Accordion1",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });
                    </script>
                <!--  end tabbedpanelscontent -->
                </div>
                </sec:authorize>
                <!--  show this tab only when subject already exists -->
                </c:when>
                </c:choose>     
    <!--------- END SUBJECTBLOCKSTUDYGRADETYPES ------------------------------------------------->


     <!--------------------------------- SUBJECT SUBJECTBLOCKS ------------------------------------->
                <!--  show tab only when subjectBlock already exists -->
                <c:choose>
                <c:when test="${'' != subjectBlock.id && 0 != subjectBlock.id}">
                <sec:authorize access="hasRole('READ_SUBJECT_SUBJECTBLOCKS')">
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion2" tabindex="0">

                        <div class="AccordionPanel">
                          <div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.subjectblock.subjectsubjectblocks" /></div>
                            <div class="AccordionPanelContent">
                                        
                                <!--  SUBJECTS FOR SUBJECT BLOCK -->
                                <table>
                                    <sec:authorize access="hasRole('CREATE_SUBJECT_SUBJECTBLOCKS')">
                                        <tr>
                                            <th align="right">
                                                <a class="button" href="<c:url value='/college/subjectblocksubject.view?newForm=true&tab=2&panel=0&subjectBlockId=${subjectBlock.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                            </th>
                                        </tr>
                                    </sec:authorize>

                                    <c:choose>
                                        <c:when test="${(not empty subjectBlockForm.showSubjectBlockSubjectError)}">
                                            <tr>
                                                <td class="errorwide">
                                                    ${subjectBlockForm.showSubjectBlockSubjectError }
                                                </td>
                                            </tr>
                                        </c:when>
                                    </c:choose>
                                    <tr>
                                    <td>
                                    <table class="tabledata2" id="TblData2_subjectssubjectblock">
                                    <c:if test="${not empty subjectBlock.subjectSubjectBlocks}">
                                    <tr>
                                        <th><fmt:message key="jsp.general.code" /></th>
                                        <th><fmt:message key="jsp.general.description" /></th>
                                        <th><fmt:message key="jsp.general.primarystudy" /></th>
                                        <th><fmt:message key="jsp.general.active" /></th>
                                        <th>&nbsp;</th>
                                    </tr>
                                    </c:if>
                                    <c:forEach var="oneSubjectSubjectBlock" items="${subjectBlock.subjectSubjectBlocks}">
                                        <tr>
                                            <td>${oneSubjectSubjectBlock.subject.subjectCode }</td>
                                            <td nowrap="nowrap">${oneSubjectSubjectBlock.subject.subjectDescription }</td>
                                            <td>
    <%--                                             <c:forEach var="study" items="${subjectBlockForm.allStudies}" > --%>
    <%--                                                 <c:choose> --%>
    <%--                                                     <c:when test="${study.id == oneSubjectSubjectBlock.subject.primaryStudyId}" > --%>
    <%--                                                         ${study.studyDescription } --%>
    <%--                                                     </c:when> --%>
    <%--                                                 </c:choose> --%>
    <%--                                             </c:forEach> --%>
                                                ${idToStudyDescriptionMap[oneSubjectSubjectBlock.subject.primaryStudyId]}
                                            </td>
                                            <td>${oneSubjectSubjectBlock.subject.active }</td>
                                            <td class="buttonsCell">
                                                <sec:authorize access="hasRole('UPDATE_SUBJECT_SUBJECTBLOCKS')">
                                                    <a class="imageLink" href="<c:url value='/college/subjectblocksubject.view?newForm=true&tab=2&panel=0&subjectBlockId=${subjectBlock.id}&subjectSubjectBlockId=${oneSubjectSubjectBlock.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                        <img src="<c:url value='/images/edit.gif' />" 
                                                        alt="<fmt:message key="jsp.href.edit" />" 
                                                        title="<fmt:message key="jsp.href.edit" />" />
                                                    </a>
                                                </sec:authorize>
                                                <sec:authorize access="hasRole('DELETE_SUBJECT_SUBJECTBLOCKS')">
                                                    <a class="imageLinkPaddingLeft" href="<c:url value='/college/subjectblocksubject_delete.view?newForm=true&tab=2&panel=0&subjectSubjectBlockId=${oneSubjectSubjectBlock.id}&subjectBlockId=${subjectBlock.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"  
                                                    onclick="return confirm('<fmt:message key="jsp.subjects.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                                </sec:authorize>
                                            </td>
                                        </tr>
                                  </c:forEach>
                              </table>
                            <script type="text/javascript">alternate('TblData2_subjectssubjectblock',true)</script>
                            </td></tr></table>
                            <!--  end accordionpanelcontent -->
                            </div>
                        <!--  end accordionpanel -->
                        </div>
                    
                    <!-- end of accordion 2 -->
                    </div>
                    <script type="text/javascript">
                        var Accordion2 = new Spry.Widget.Accordion("Accordion2",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });
                        
                    </script>
                <!--  end tabbedpanelscontent -->
                </div>
                </sec:authorize>
                <!--  show this tab only when subject already exists -->
                </c:when>
                </c:choose>     
        
<!--------------------------------- END SUBJECT SUBJECTBLOCKS ---------------------------------->        
            <!--  end tabbed panelscontentgroup -->    
            </div>
            
        <!--  end tabbed panel -->    
        </div>
        
    <!-- end tabcontent -->
    </div>   
    
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(${navigationSettings.tab});
        Accordion${navigationSettings.tab}.defaultPanel = ${navigationSettings.panel};
        Accordion${navigationSettings.tab}.openPanelNumber(${navigationSettings.panel});
    </script>
   
<!-- end tabwrapper -->    
</div>

<%@ include file="../../footer.jsp"%>