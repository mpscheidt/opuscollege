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

<%@ include file="../../includes/standardincludes.jsp"%>

<c:set var="screentitlekey">jsp.general.subject</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <c:set var="subject" value="${subjectForm.subject}" scope="page" />
    <c:set var="organization" value="${subjectForm.organization}" scope="page" />
    <c:set var="navigationSettings" value="${subjectForm.navigationSettings}" scope="page" />

    <%-- decide whether to display read-only or allow to edit --%>
    <c:set var="authorizedToEdit" value="${false}"/>
    <sec:authorize access="hasAnyRole('CREATE_SUBJECTS','UPDATE_SUBJECTS')">
        <c:set var="authorizedToEdit" value="${true}"/>
    </sec:authorize>

    <div id="tabcontent">
        <fieldset>
            <legend>
                <a href="<c:url value='/college/subjects.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.subjects.header" /></a>&nbsp;&gt;
                <c:choose>
                    <c:when test="${not empty subject.subjectDescription}" >
                        <c:out value="${fn:substring(subject.subjectDescription,0,initParam.iTitleLength)}"/>
                        <c:out value="(${subject.academicYear.description})"/>
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="general.add.subject" />
                    </c:otherwise>
                </c:choose>
            </legend>

            <%--Display Error Messages because it must be visible if an error occurred in any tab --%>
            <form:errors path="subjectForm.*" cssClass="errorwide" element="p"/>

            <c:if test="${subject.id != 0}">
                <div class="crosslinkbartop">
                    <a class="button" href="<c:url value='/college/subjectresults.view'/>?<c:out value='newForm=true&subjectId=${subject.id}'/>">
                        <fmt:message key="jsp.general.resultsoverview" />
                    </a>
                </div>
            </c:if>

        </fieldset>

        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab compulsoryTab"><fmt:message key="jsp.general.subject" /></li>    
                <spring:bind path="subjectForm.subject.id">
                <c:choose>
                    <c:when test="${'' != status.value && 0 != status.value}">
	                    <li class="TabbedPanelsTab"><fmt:message key="jsp.general.content" /></li>  
                    	<li class="TabbedPanelsTab compulsoryTab"><fmt:message key="jsp.general.teachers" /></li>  
                        <li class="TabbedPanelsTab"><fmt:message key="jsp.general.studytypes" /></li>  

                        <%-- study grade types compulsoryTab if no subject blocks used --%>
                        <c:set var="bAppUseOfSubjectBlocks" value="${appUseOfSubjectBlocks == 'Y'}"></c:set>
                        <li class="TabbedPanelsTab <c:if test='${!bAppUseOfSubjectBlocks}'>compulsoryTab</c:if>">
                            <fmt:message key="jsp.general.studygradetypes" />
                        </li>

                        <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                            <li class="TabbedPanelsTab compulsoryTab"><fmt:message key="jsp.general.subjectblocks" /></li>
	                	</c:if>
                		<li class="TabbedPanelsTab"><fmt:message key="jsp.general.examinations" /></li>  
                    </c:when>
                </c:choose>
                </spring:bind>  
            </ul>

            <div class="TabbedPanelsContentGroup">
               
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion0" tabindex="0">

                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.general.subject" /></div>
                            <div class="AccordionPanelContent">

                             	<c:choose>
                                    <c:when test="${(not empty subjectForm.showSubjectEditError) && authorizedToEdit}">             
                                        <p align="left" class="msg">
                                           <c:out value="${subjectForm.showSubjectEditError}"/>
                                        </p>
                                    </c:when>
                                </c:choose>

                            <form name="formdata" method="post">
                                <input type="hidden" name="navigationSettings.tab" value="0" />
                                <input type="hidden" name="navigationSettings.panel" value="0" />
                                <input type="hidden" name="submitFormObject" id="submitFormObject" value="" />
                                   
                                <%@ include file="../../includes/organization.jsp"%>

                                <table>
                                    <%-- organizational unit of subject 
                                    <tr><td colspan="2">&nbsp;</td></tr>
                                    <tr>
                                        <td class="label">
                                            <b>
                                                <fmt:message key="jsp.general.organizationalunit" />
                                                <fmt:message key="jsp.general.of" />
                                                <fmt:message key="jsp.general.primarystudy" />
                                            </b>
                                        </td>
                                        <td>${unitStudyDescription}</td>
                                    </tr>
                                    <tr><td colspan="2">&nbsp;</td></tr>--%>

                                        <!-- PRIMARY STUDY -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.primarystudy" /></td>
                                            
                                            <spring:bind path="subjectForm.subject.primaryStudyId">
                                            <td class="required">
                                                <c:choose>
                                                    <c:when test="${authorizedToEdit}">
                                                    	<select name="${status.expression}" id="${status.expression}" onchange="document.formdata.submit();">
                                                        	<option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                            <c:forEach var="oneStudy" items="${subjectForm.allStudies}">
                                                                <c:choose>
                                                                    <c:when test="${oneStudy.id == status.value}">
                                                                        <option value="${oneStudy.id}" selected="selected"><c:out value="${oneStudy.studyDescription}"/></option>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <option value="${oneStudy.id}"><c:out value="${oneStudy.studyDescription}"/></option>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:forEach>
                                                    	</select>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:choose>
                                                            <c:when test="${not empty idToStudyMap[status.value]}">
                                                                <c:out value="${idToStudyMap[status.value].studyDescription}"/>
                                                            </c:when>
                                                        </c:choose>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </spring:bind>
                                        </tr>
                            
                                        <!-- CODE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.code" /></td>
                                            <spring:bind path="subjectForm.subject.subjectCode">
                                            <td>
												<c:choose>
                                                    <c:when test="${authorizedToEdit}">
                                                		<input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
                                               		</c:when>
                                               		<c:otherwise>
                                               			<c:out value="${subject.subjectCode}"/>
                                               		</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><fmt:message key="jsp.general.message.codegenerated" />
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                            </td>
                                            </spring:bind>
                                            
                                        </tr>
                            
                                        <!-- DESCRIPTION -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.name" /></td>
                                            <spring:bind path="subjectForm.subject.subjectDescription">
                                            <td class="required">
												<c:choose>
                                                    <c:when test="${authorizedToEdit}">
                                                		<input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
                                               		</c:when>
                                               		<c:otherwise>
                                               			<c:out value="${status.value}"/>
                                               		</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            </spring:bind>
                                        </tr>
                                        
                                        <!-- CREDIT AMOUNT -->
                                        <spring:bind path="subjectForm.subject.creditAmount">
                                        
                                        <c:choose>
                                            <c:when test="${initParam.iCreditAmountVisible == 'Y'}">
                                                    
		                                            <tr>
		                                            <td class="label"><fmt:message key="jsp.subject.credit" /></td>
		                                            <td class="required">
														<c:choose>
		                                                    <c:when test="${authorizedToEdit}">
		                                                		<input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" onchange="javascript: if (this.value=='') this.value=0;" />
		                                               		</c:when>
		                                               		<c:otherwise>
		                                               			<c:out value="${status.value}"/>
		                                               		</c:otherwise>
		                                                </c:choose>
		                                            </td>
		                                            <td>
		                                                <fmt:message key="jsp.general.message.creditamountformat" />
		                                                <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
		                                            </td>
		                                           </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <input type="hidden" name="${status.expression}" id="${status.expression}" value="1.0" />
                                            </c:otherwise>
                                        </c:choose>
                                        </spring:bind>

                                        <!-- FREQUENCY -->
                                        <c:if test="${modules != null && modules != ''}">
                                           <c:forEach var="module" items="${modules}">
                                              <c:if test="${fn:toLowerCase(module.module) == 'mozambique'}">
												<spring:bind path="subjectForm.subject.frequencyCode">		                                        
												<tr>
                                                   
		                                            <td class="label"><fmt:message key="jsp.subject.frequency" /></td>
		                                            <td>
														<c:choose>
                                                            <c:when test="${authorizedToEdit}">
		                                                		<select name="${status.expression}" id="${status.expression}">
		                                                    	<option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
		                                                    </c:when>
		                                                </c:choose>
		                                                    <c:forEach var="frequency" items="${subjectForm.allFrequencies}">
																<c:choose>
								                                	<c:when test="${authorizedToEdit}">
				                                                        <c:choose>
				                                                            <c:when test="${frequency.code == status.value}">
				                                                                <option value="${frequency.code}" selected="selected"><c:out value="${frequency.description}"/></option>
				                                                            </c:when>
				                                                            <c:otherwise>
				                                                                <option value="${frequency.code}"><c:out value="${frequency.description}"/></option>
				                                                            </c:otherwise>
				                                                        </c:choose>
				                                                    </c:when>
				                                                    <c:otherwise>
				                                                        <c:choose>
				                                                            <c:when test="${frequency.code == status.value}">
				                                                            	<c:out value="${frequency.description}"/>
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
		                                            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
		                                        </tr>
                                                </spring:bind>
		                                    </c:if>
										  </c:forEach>
										</c:if>
		                                
                                        <!-- STUDY TIME -->
										<spring:bind path="subjectForm.subject.studyTimeCode">                                        
										<tr>
                                            <td class="label"><fmt:message key="jsp.general.studytime" /></td>
                                            
                                            <td class="required">
												<c:choose>
                                                    <c:when test="${authorizedToEdit}">
                                                		<select name="${status.expression}">
                                                    	<option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    </c:when>
                                                </c:choose>
                                                    <c:forEach var="studyTime" items="${subjectForm.allStudyTimes}">
														<c:choose>
                                                            <c:when test="${authorizedToEdit}">
		                                                        <c:choose>
		                                                            <c:when test="${studyTime.code == status.value}">
		                                                                <option value="${studyTime.code}" selected="selected"><c:out value="${studyTime.description}"/></option>
		                                                            </c:when>
		                                                            <c:otherwise>
		                                                                <option value="${studyTime.code}"><c:out value="${studyTime.description}"/></option>
		                                                            </c:otherwise>
		                                                        </c:choose>
		                                                    </c:when>
		                                                    <c:otherwise>
		                                                        <c:choose>
		                                                            <c:when test="${studyTime.code == status.value}">
		                                                            	<c:out value="${studyTime.description}"/>
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
                                            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                            
                                        </tr>
                                        </spring:bind>

                                        <!-- MAXIMUM NUMBER OF PARTICIPANTS -->
                                        <spring:bind path="subjectForm.subject.maximumParticipants">                                            
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.subject.maximumparticipants" /></td>
												<td>
												<c:choose>
                                                    <c:when test="${authorizedToEdit}">
                                                		<input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" onchange="javascript: if (this.value=='') this.value=0;" />
                                               		</c:when>
                                               		<c:otherwise>
                                               			<c:out value="${status.value}"/>
                                               		</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                        </tr>
                                        </spring:bind>

                                  		<!--  CURRENT ACADEMIC YEAR -->
                                      	<tr>
                                		<td class="label"><fmt:message key="jsp.general.academicyear" /></td>
                                        <spring:bind path="subjectForm.subject.currentAcademicYearId">
                                		<td class="required">
						               	 	<c:choose>
                                                <c:when test="${authorizedToEdit}">
                                            		<select name="${status.expression}" >
                                                		<option value="-"><fmt:message key="jsp.selectbox.choose" /></option>
                                                        <c:forEach var="academicYear" items="${subjectForm.allAcademicYears}">
            						               	 		<c:choose>
            						               				<c:when test="${authorizedToEdit}">
            	                                                     <c:choose>
            	                                                         <c:when test="${academicYear.id != 0
            	                                                                      && academicYear.id == status.value}">
            	                                                             <option value="${academicYear.id}" selected="selected"><c:out value="${academicYear.description}"/></option> 
            	                                                         </c:when>
            	                                                         <c:otherwise>
            	                                                             <option value="${academicYear.id}"><c:out value="${academicYear.description}"/></option> 
            	                                                         </c:otherwise>
            	                                                     </c:choose>
            	                                                 </c:when>
            	                                                 <c:otherwise>
            	                                                 	<c:out value="${academicYear.description}"/>
            	                                                 </c:otherwise>
            	                                             </c:choose>
                                                        </c:forEach>
                                            		</select>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:out value="${subject.academicYear.description}"/>
                                                </c:otherwise>
                                            </c:choose>	
                                		</td>
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                        </spring:bind>
                                	</tr>
                                    <!--  RESULT TYPE -->
<%--                                    <c:if test="${subjectForm.endGradesPerGradeType == 'Y'}">
                                        <tr>
                                        <td class="label"><fmt:message key="jsp.general.resulttype" /></td>
                                        <spring:bind path="subjectForm.subject.resultType">
                                        <td class="required">
                                            <c:choose>
                                                <c:when test="${authorizedToEdit}">
                                                    <select name="${status.expression}" >
                                                        <option value=""><fmt:message key="jsp.general.default" /></option>
                                                        <c:choose>
                                                           <c:when test="${status.value != '' && status.value == 'AR'}">
                                                               <option value="AR" selected="selected"><fmt:message key="jsp.general.attachmentresult" /></option> 
                                                           </c:when>
                                                           <c:otherwise>
                                                               <option value="AR"><fmt:message key="jsp.general.attachmentresult" /></option> 
                                                           </c:otherwise>
                                                       </c:choose>
                                                   </select>
                                                </c:when>
                                                <c:otherwise>
	                                                <c:choose>
		                                                <c:when test="${status.value == 'AR'}">
		                                                    <fmt:message key="jsp.general.attachmentresult" />
		                                                </c:when>
		                                                <c:otherwise>
		                                                      <fmt:message key="jsp.general.default" />
		                                                </c:otherwise>
		                                            </c:choose>
                                                    
                                                </c:otherwise>
                                            </c:choose> 
                                        </td>
                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                        </spring:bind>
                                    </tr>
                                    </c:if>
 --%>
                                     
                                    <!-- BRs PASSING SUBJECT -->
									<c:choose>
                                        <c:when test="${subjectForm.endGradesPerGradeType == 'N'}">
											<spring:bind path="subjectForm.subject.brsPassingSubject">                                        
											<tr>
                                            <td class="label"><fmt:message key="jsp.general.brspassing" /></td>
                                            <td colspan="2">
												<c:choose>
				                                	<c:when test="${authorizedToEdit}">
                                                		<input type="text" name="${status.expression}" size="3" maxlength="6" value="<c:out value="${status.value}" />" />
                                               		</c:when>
                                               		<c:otherwise>
                                               			<c:out value="${status.value}"/>
                                               		</c:otherwise>
                                                </c:choose>
                                            &nbsp;&nbsp;<fmt:message key="jsp.general.minimummark" />: ${study.minimumMarkSubject}, <fmt:message key="jsp.general.maximummark" />: ${study.maximumMarkSubject}
                                            <br /><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                            </td>
                                            </tr>
                                            </spring:bind>
                                        </c:when>
                                    </c:choose>

                                    <!--  ACTIVE -->
    								<spring:bind path="subjectForm.subject.active">                               
    								    <tr>
                                            <td class="label"><fmt:message key="jsp.general.active" /></td>
                                            <td>
 												<c:choose>
					                                <c:when test="${authorizedToEdit}">
                                            			<select name="subject.active" id="subject.active">
			                                                <c:choose>
			                                                    <c:when test="${'Y' == subject.active}">
			                                                        <option value="Y" selected="selected"><fmt:message key="jsp.general.yes" /></option>
			                                                        <option value="N"><fmt:message key="jsp.general.no" /></option>
			                                                    </c:when>
			                                                    <c:otherwise>
			                                                        <option value="Y"><fmt:message key="jsp.general.yes" /></option>
			                                                        <option value="N" selected="selected"><fmt:message key="jsp.general.no" /></option>
			                                                    </c:otherwise>
			                                                 </c:choose>
			                                            </select>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:message key="${stringToYesNoMap[subject.active]}"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                        </tr>
                                    </spring:bind>

                                    <!-- SUBMIT BUTTON -->
                                    <tr><td class="label">&nbsp;</td>
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

<!--------------------------------- SUBJECTCONTENT ------------------------------------->

                <!--  show tabs only when subject already exists -->
                <c:choose>
                <c:when test="${'' != subject.id && 0 != subject.id}">
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion1" tabindex="0">

                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.content" /></div>
                            <div class="AccordionPanelContent">

                                <form name="contentformdata" method="post">
                                    <input type="hidden" name="navigationSettings.tab" value="1" />
                                    <input type="hidden" name="navigationSettings.panel" value="0" />
                                    <input type="hidden" name="submitContentFormObject" id="submitContentFormObject" value="" />
                                    <table>
                                        <tr><td>&nbsp;</td></tr>
                                        
                                        	
                                       
                                        <!-- CONTENT DESCRIPTION -->
                                        
                                        <tr>
                                           
                                           <spring:bind path="subjectForm.subject.subjectContentDescription">  
												 <td height="250">
												<c:choose>
				                                	<c:when test="${authorizedToEdit}">
                                                        <%-- setting rows here to make sure that height is sufficient so that the submit button isn't hidden after clicking submit --%>
	                                                   <textarea id="${status.expression}" name="${status.expression}" rows="25"><c:out value="${status.value}"/></textarea>
                                          		       <script>
	                                                     // Replace the <textarea id="..."> with a CKEditor
	                                                     CKEDITOR.replace( '${status.expression}', {
	                                                         height: 280
	                                                     } );
                                                       </script>
	                                            	</c:when>
	                                            	<c:otherwise>
	                                            		<c:out value="${subject.subjectContentDescription}"/>
	                                            	</c:otherwise>
	                                            </c:choose>
                                            </td>
                                            <td>
                                                <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>
                                        <tr>
                                            <td align="right">
                                                <!-- SUBMIT BUTTON -->
                                                <%-- Position of submit is to the right of the text area because ckEditor sometimes resizes itself so that part below is not visible anymore
                                                     This happens e.g. after submitting a modified text in the text area.
                                                     It should be further investigated. --%>
                                                <c:if test="${authorizedToEdit}">
                                                    <input type="submit" name="contentformdatasubmit" value="<fmt:message key="jsp.button.submit" />" onclick="document.getElementById('submitContentFormObject').value='true';document.contentformdata.submit();" />
                                                </c:if>
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
                        var Accordion1 = new Spry.Widget.Accordion("Accordion1",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });
                        
                    </script>
                <!--  end tabbedpanelscontent -->
                </div>
                <!--  show this tab only when subject already exists -->
                </c:when>
                </c:choose>     

<!--------------------------------- END SUBJECTCONTENT ------------------------------------->

<!--------------------------------- SUBJECTTEACHERS ------------------------------------->
                <!--  show the tabs only when subject already exists -->
                <c:if test="${'' != subject.id && 0 != subject.id}">
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion2" tabindex="0">

                        <div class="AccordionPanel">
                          <div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.subject.subjectteachers" /></div>
                            <div class="AccordionPanelContent">
                                <table>
                                    <sec:authorize access="hasRole('CREATE_SUBJECT_TEACHERS')">
                                        <tr>
                                            <td class="buttonsCell" colspan="3" align="right">
                                                <a class="button" href="<c:url value='/college/subjectteacher.view?newForm=true&amp;tab=2&amp;panel=0&amp;from=subject&amp;subjectId=${subject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                            </td>
                                        </tr>
                                    </sec:authorize>

                                    <c:choose>
                                        <c:when test="${(not empty subjectForm.showSubjectTeacherError)}">             
                                            <tr>
                                                <td colspan="2" class="error">
                                                    <c:out value="${subjectForm.showSubjectTeacherError}"/>
                                                </td>
                                                <td>&nbsp;</td>
                                            </tr>
                                       </c:when>
                                    </c:choose>

                                    <tr>
                                        <td colspan="3">
                                            <c:choose>
                                                <c:when test="${not empty subject.subjectTeachers}">
                                                    <table class="tabledata2" id="TblData2_teachers">
                                                        <tr>
                                                            <th><fmt:message key="jsp.general.description" /></th>
                                                            <th width="10"><fmt:message key="jsp.general.active" /></th>
                                                            <th><fmt:message key="general.classgroup" /></th>
                                                            <th width="10">&nbsp;</th>
                                                        </tr>
    		                                            <c:forEach var="oneSubjectTeacher" items="${subject.subjectTeachers}">
                                                            <c:set var="oneTeacher" value="${oneSubjectTeacher.staffMember}" />
<%--     		                                                <c:forEach var="oneTeacher" items="${subjectForm.allTeachers}"> --%>
<%--     		                                                <c:choose> --%>
<%--     		                                                    <c:when test="${(oneSubjectTeacher.staffMemberId == oneTeacher.staffMemberId)}"> --%>
            		                                                <tr>
            		                                                    <td>
            		                                                        <b><c:out value="${oneTeacher.firstnamesFull}"/> <c:out value="${oneTeacher.surnameFull}"/></b>
            		                                                    </td>
            		                                                    <td>
            		                                                        <c:out value="${oneSubjectTeacher.active}"/>
            		                                                    </td>
							                                            <td>
							                                            	<c:forEach var="oneClassgroup" items="${subjectForm.allClassgroups}">
							                                            		<c:if test="${oneClassgroup.id == oneSubjectTeacher.classgroupId}">
							                                            			<c:out value="${oneClassgroup.description}"/>
							                                            		</c:if>
							                                            	</c:forEach>
							                                            </td>
            		                                                    <td class="buttonsCell" align="right">
            		                                                        <sec:authorize access="hasRole('DELETE_SUBJECT_TEACHERS')">
            											                        <a class="imageLink" href="<c:url value='/college/subjectteacher_delete.view?tab=2&amp;panel=0&amp;subjectId=${subject.id}&amp;from=subject&amp;subjectTeacherId=${oneSubjectTeacher.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>" 
            		                                                    		    onclick="return confirm('<fmt:message key="jsp.teachers.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                                                </a>
            		                                                        </sec:authorize>
            		                                                    </td>
            		                                                </tr>
<%--     		                                                    </c:when> --%>
<%--     		                                                </c:choose> --%>
<%--     		                                                </c:forEach>    --%>
    		                                            </c:forEach> 
                                                    </table>
		                                            <script type="text/javascript">alternate('TblData2_teachers',true)</script>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="error">
                                                        <fmt:message key="jsp.error.subjectteacher.nonechosen" />
                                                    </p>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td colspan="2">&nbsp;</td>
                                    </tr>
                                </table>

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
                <!--  show this tab only when subject already exists -->
                </c:if>     
<!--------------------------------- END SUBJECTTEACHERS ------------------------------------->
                
<!--------------------------------- SUBJECTSTUDYTYPES ------------------------------------->
                <!--  show the tabs only when subject already exists -->
                <c:choose>
                <c:when test="${'' != subject.id && 0 != subject.id}">
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion3" tabindex="0">

                        <div class="AccordionPanel">
                          <div class="AccordionPanelTab"><fmt:message key="jsp.subject.subjectstudytypes" /></div>
                            <div class="AccordionPanelContent">
                                <table>
                                   <c:choose>
                                   <c:when test="${authorizedToEdit}">
                                        <tr>
                                            <td class="buttonsCell" colspan="3" align="right">
                                                <a class="button" href="<c:url value='/college/subjectstudytype.view?newForm=true&amp;tab=3&amp;panel=0&amp;subjectId=${subject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                            </td>
                                        </tr>
                                    </c:when>
                                    </c:choose>
                                    
                                    <tr>
                                        <td colspan="3">
                                            <table class="tabledata2" id="TblData2_studytypes">
                                                <c:if test="${not empty subject.subjectStudyTypes}" >
                                                    <tr>
                                                        <th><fmt:message key="jsp.general.description" /></th>
                                                        <th width="20"><b><fmt:message key="jsp.general.active" /></b></th>
                                                        <th></th>
                                                    </tr>   
                                                </c:if>
                                                <c:forEach var="oneSubjectStudyType" items="${subject.subjectStudyTypes}">
                                                    <tr>
                                                        <td class="emptywide">
                                                            <b><c:out value="${oneSubjectStudyType.studyTypeDescription}"/></b>
                                                        </td>
                                                        <td>
                                                            <c:out value="${oneSubjectStudyType.active}"/>
                                                        </td>
                                                        <td align="right">
                                                            <c:choose>
                                                                <c:when test="${authorizedToEdit}">
                                                                    <a class="imageLink" href="<c:url value='/college/subjectstudytype_delete.view?newForm=true&amp;tab=3&amp;panel=0&amp;subjectStudyTypeId=${oneSubjectStudyType.id}&amp;subjectId=${subject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>" 
                                                                    onclick="return confirm('<fmt:message key="jsp.studytypes.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                                                </c:when>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach> 
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">&nbsp;</td>
                                    </tr> 
                                </table>
                                <script type="text/javascript">alternate('TblData2_studytypes',true)</script>
                            <!--  end accordionpanelcontent -->
                            </div>
                        <!--  end accordionpanel -->
                        </div>
                    
                    <!-- end of accordion 3 -->
                    </div>
                    <script type="text/javascript">
                        var Accordion3 = new Spry.Widget.Accordion("Accordion3",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });
                        
                    </script>
                <!--  end tabbedpanelscontent -->
                </div>
                <!--  show this tab only when subject already exists -->
                </c:when>
                </c:choose>
                
<!--------- END SUBJECTSTUDYTYPES ------------------------------------------------->
                                       

<!------------- SUBJECTSTUDYGRADETYPES ------------------------------------------------->
<%--                 <c:set var="primaryStudyId" value="${subject.primaryStudyId}" scope="page" /> --%>
<%--                 <c:set var="currentAcademicYearId" value="${subject.currentAcademicYearId}" scope="page" /> --%>

                <!--  show tabs only when subject already exists -->
                <c:choose>
                <c:when test="${'' != subject.id && 0 != subject.id}">
                <sec:authorize access="hasRole('READ_SUBJECT_STUDYGRADETYPES')">
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion4" tabindex="0">

                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab <c:if test='${!bAppUseOfSubjectBlocks}'>compulsoryTab</c:if>">
                                <fmt:message key="jsp.subject.message.studygradetype" />
                            </div>
                            <div class="AccordionPanelContent">

                                <c:choose>
                                    <c:when test="${(not empty subjectForm.showSubjectStudyGradeTypeError) && authorizedToEdit}">             
                                        <p align="left" class="msg">
                                           <c:out value="${subjectForm.showSubjectStudyGradeTypeError}"/>
                                        </p>
                                    </c:when>
                                </c:choose>

                                <table>
                                    <sec:authorize access="hasRole('CREATE_SUBJECT_STUDYGRADETYPES')">
                                        <c:choose>
                                            <c:when test="${subject.linkSubjectAndStudyGradeTypeIsAllowed }">
                                                <tr>
                                                    <td class="label" align="right">
                                                        <a class="button" href="<c:url value='/college/subjectstudygradetype.view?newForm=true&amp;tab=4&amp;panel=0&amp;subjectId=${subject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <p align="right" class="msgwide">
                                                    <fmt:message key="jsp.error.link.subject.studygradetype.teacher.missing" />
                                                </p>
                                            </c:otherwise>
                                        </c:choose>
                                    </sec:authorize>
                                    <tr>
                                        <td>
                                            <table class="tabledata2" id="TblData2_studygradetypes">
                                                <c:if test="${ not empty subject.subjectStudyGradeTypes}" >
                                                    <tr>
                                                        <th><fmt:message key="jsp.general.description" /></th>
                                                        <th><fmt:message key="jsp.general.academicyear" /></th>
                                                        <th><fmt:message key="jsp.general.cardinaltimeunit" /></th>
                                                        <th><fmt:message key="jsp.general.studytime" /></th>
                                                        <th><fmt:message key="jsp.general.studyform" /></th>
                                                        <th><fmt:message key="jsp.subject.rigiditytype" /></th>
                                                        <c:if test="${initParam.iMajorMinor == 'Y'}">
                                                            <th><fmt:message key="jsp.general.major" /> / <fmt:message key="jsp.general.minor" /></th>
                                                        </c:if>
                                                        <th><fmt:message key="jsp.general.subjectPrerequisites" /></th>
                                                        <th><fmt:message key="jsp.general.active" /></th>
                                                        <th></th>
                                                        <th></th>
                                                    </tr>      
                                                </c:if>
                                                <c:forEach var="oneSubjectStudyGradeType" items="${subject.subjectStudyGradeTypes}">
                                                    <tr>
                                                        <td>
                                                            <b>
                                                                <c:out value="${oneSubjectStudyGradeType.studyDescription}"/> -
                                                                <c:out value="${subjectForm.codeToGradeTypeMap[oneSubjectStudyGradeType.gradeTypeCode].description}"/>
<%--                                                              <c:out value="${oneSubjectStudyGradeType.gradeTypeDescription}"/> --%>
                                                            </b>
                                                        </td>
                                                          
                                                        <c:forEach var="studyGradeType" items="${subjectForm.allStudyGradeTypes}">
                                                            <c:choose>
                                                                <c:when test="${studyGradeType.id == oneSubjectStudyGradeType.studyGradeTypeId}">
            	                                                    <td>
            	                                                       <c:choose>
            	                                                      	<c:when test="${studyGradeType.currentAcademicYearId != 0}">
            		                                                      	<c:forEach var="academicYear" items="${subjectForm.allAcademicYears}">
            			                                                      	<c:choose>
            			                                                      		<c:when test="${academicYear.id == studyGradeType.currentAcademicYearId}">
            			                                                   				<c:out value="${academicYear.description}"/>
            			                                                       		</c:when>
            			                                                      	</c:choose>
            			                                                  	</c:forEach> 
            			                                                  </c:when>
            			                                               </c:choose> 
            			                                            </td>
            			                                            <td>
                                                                        <c:out value="${oneSubjectStudyGradeType.cardinalTimeUnitNumber}"/>
                                                         			</td>
            	                                                    <td>
                                                                        <c:choose>
                	                                                      	<c:when test="${studyGradeType.studyTimeCode != ''}">
                			                                                   <c:forEach var="studyTime" items="${subjectForm.allStudyTimes}">
                			                                                      <c:choose>
                    			                                                      <c:when test="${studyTime.code == studyGradeType.studyTimeCode}">
                    			                                                   	     <c:out value="${studyTime.description}"/>
                    			                                                      </c:when>
                			                                                      </c:choose>
                			                                                   </c:forEach> 
                			                                                </c:when>
                			                                                <c:otherwise>
                			                                                	&nbsp;
                			                                                </c:otherwise>
                                                                        </c:choose>
            			                                            </td>
            	                                                    <td>
                                                                        <c:choose>
                	                                                      	<c:when test="${studyGradeType.studyFormCode != '' }">
                			                                                   <c:forEach var="studyForm" items="${subjectForm.allStudyForms}">
                			                                                      <c:choose>
                			                                                      <c:when test="${studyForm.code == studyGradeType.studyFormCode}">
                			                                                   		<c:out value="${studyForm.description}"/>
                			                                                       </c:when>
                			                                                      </c:choose>
                			                                                   </c:forEach> 
                			                                                 </c:when>
                                                                             <c:otherwise>
                                                                                &nbsp;
                                                                            </c:otherwise>
            			                                                </c:choose>   
            			                                            </td>
                                                                    <td>
                                                                       <c:forEach var="rigidityType" items="${subjectForm.allRigidityTypes}">
                                                                          <c:choose>
                                                                              <c:when test="${rigidityType.code == oneSubjectStudyGradeType.rigidityTypeCode}">
                                                                                <c:out value="${rigidityType.description}"/>
                                                                              </c:when>
                                                                          </c:choose>
                                                                       </c:forEach> 
                                                                    </td>
            	                                                </c:when>
            	                                            </c:choose>
            	                                        </c:forEach>	
                                                        <c:if test="${initParam.iMajorMinor == 'Y'}">
                                                            <td>
                                                                <c:forEach var="importanceType" items="${subjectForm.allImportanceTypes}">
                                                                    <c:choose>
                                                                        <c:when test="${importanceType.code == oneSubjectStudyGradeType.importanceTypeCode}">
                                                                          <c:out value="${importanceType.description}"/>
                                                                        </c:when>
                                                                    </c:choose>
                                                               </c:forEach> 
                                                           </td>
                                                        </c:if>
                                                        <td>
                                                              <c:forEach var="onePrerequisite" items="${oneSubjectStudyGradeType.subjectPrerequisites}">
                                                                  - <c:out value="${onePrerequisite.requiredSubjectDescription}"/><br/> 
                                                              </c:forEach>
                                                        </td>
                                                        <td>
                                                              <c:out value="${oneSubjectStudyGradeType.active}"/>
                                                        </td>
                                                        <td class="buttonsCell">
                                                            <sec:authorize access="hasRole('UPDATE_SUBJECT_STUDYGRADETYPES')">
                                                          		<a class="imageLink" href="<c:url value='/college/subjectstudygradetype.view?newForm=true&amp;tab=4&amp;panel=0&amp;subjectStudyGradeTypeId=${oneSubjectStudyGradeType.id}&amp;subjectId=${subject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                                            </sec:authorize>
                                                        </td>
                                                        <td class="buttonsCell">
                                                            <sec:authorize access="hasRole('DELETE_SUBJECT_STUDYGRADETYPES')">
                                                          		<a class="imageLink" href="<c:url value='/college/subjectstudygradetype_delete.view?newForm=true&amp;tab=4&amp;panel=0&amp;subjectStudyGradeTypeId=${oneSubjectStudyGradeType.id}&amp;subjectId=${subject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>" 
                                                          		onclick="return confirm('<fmt:message key="jsp.subjectstudygradetypes.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                                            </sec:authorize>
                                                        </td>
                                                    </tr>
                                                </c:forEach> 
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                <script type="text/javascript">alternate('TblData2_studygradetypes',true)</script>
                            <!--  end accordionpanelcontent -->
                            </div>
                        <!--  end accordionpanel -->
                        </div>
                    
                    <!-- end of accordion 4 -->
                    </div>
                    <script type="text/javascript">
                        var Accordion4 = new Spry.Widget.Accordion("Accordion4",
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

    <!--------- END SUBJECTSTUDYGRADETYPES ------------------------------------------------->


    <!--------------------------------- SUBJECT SUBJECTBLOCKS ------------------------------------->
                <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                <!--  show tab only when subject already exists -->
                <c:choose>
                <c:when test="${'' != subject.id && 0 != subject.id}">
                <sec:authorize access="hasRole('READ_SUBJECT_SUBJECTBLOCKS')">
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion5" tabindex="0">

                        <div class="AccordionPanel">
                          <div class="AccordionPanelTab compulsoryTab"><fmt:message key="jsp.subject.subjectsubjectblocks" /></div>
                            <div class="AccordionPanelContent">
                                <table>
                                    <sec:authorize access="hasRole('CREATE_SUBJECT_SUBJECTBLOCKS')">
                                        <c:choose>
                                            <c:when test="${subject.linkSubjectAndStudyGradeTypeIsAllowed }">
                                                <tr>
                                                    <td class="label" colspan="2" align="right">
                                                        <a class="button" href="<c:url value='/college/subjectsubjectblock.view?newForm=true&amp;tab=5&amp;panel=0&amp;subjectId=${subject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                                    </td>
                                                </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                    <tr>
                                                    <td colspan="2">
                                                        <p align="right" class="msgwide">
                                                            <fmt:message key="jsp.error.link.subject.subjectblock.teacher.missing" />
                                                        </p>
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </sec:authorize>

                                    <c:choose>
                                        <c:when test="${(not empty subjectForm.showSubjectSubjectBlockError)}">             
                                            <tr>
                                                <td class="error">
                                                    <c:out value="${subjectForm.showSubjectSubjectBlockError}"/>
                                                </td>
                                                <td>&nbsp;</td>
                                            </tr>
                                       </c:when>
                                    </c:choose>
                                    <tr>
                                        <td colspan="2">
                                            <table class="tabledata2" id="TblData2_studyblocks">
                                                <c:if test="${not empty subject.subjectSubjectBlocks}">
                                                    <tr>
                                                        <th><fmt:message key="jsp.general.primarystudy" /></th>
                                                        <th><fmt:message key="jsp.general.academicyear" /></th>
                                                        <th><fmt:message key="jsp.general.description" /></th>
                                                        <th><fmt:message key="jsp.general.active" /></th>
                                                        <th></th>
                                                    </tr>
                                                </c:if>
                                                <c:forEach var="oneSubjectSubjectBlock" items="${subject.subjectSubjectBlocks}">
                                                    <c:set var="oneSubjectBlock" value="${oneSubjectSubjectBlock.subjectBlock}" />
<%--                                                     <c:forEach var="oneSubjectBlock" items="${subjectForm.allSubjectBlocks}"> --%>
<%--                                                         <c:choose> --%>
<%--                                                             <c:when test="${(oneSubjectSubjectBlock.subjectBlockId == oneSubjectBlock.id)}"> --%>
                                                                <tr>
                                                                <td>
                                                                <c:forEach var="oneStudy" items="${subjectForm.allStudies}">
                                                                    <c:choose>
                                                                        <c:when test="${oneSubjectBlock.primaryStudyId == oneStudy.id}">
                                                                            <c:out value="${oneStudy.studyDescription}"/>
                                                                        </c:when>
                                                                    </c:choose>
                                                                </c:forEach>
                                                                </td>
                                                                <td>
                                                        		<c:forEach var="academicYear" items="${subjectForm.allAcademicYears}">
            	                                                     <c:choose>
            	                                                         <c:when test="${academicYear.id != 0
            	                                                                      && academicYear.id == oneSubjectBlock.currentAcademicYearId}">
            	                                                             <c:out value="${academicYear.description}"/>
            	                                                         </c:when>
            	                                                     </c:choose>
                                                        		</c:forEach>
                                                                </td>
                                                                <td>
                                                                    <c:set var="authorizedToUpdateSubjectSubjectBlock" value="${false}"/>
                                                                    <sec:authorize access="hasRole('UPDATE_SUBJECT_SUBJECTBLOCKS')">
                                                                        <c:set var="authorizedToUpdateSubjectSubjectBlock" value="${true}"/>
                                                                    </sec:authorize>
                                                                    <c:choose>
                                                                        <c:when test="${authorizedToUpdateSubjectSubjectBlock}">
                                                                            <a href="<c:url value='/college/subjectsubjectblock.view?newForm=true&amp;tab=5&amp;panel=0&amp;subjectSubjectBlockId=${oneSubjectSubjectBlock.id}&amp;subjectId=${subject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                                            <c:out value="${oneSubjectBlock.subjectBlockDescription}"/></a>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <c:out value="${oneSubjectBlock.subjectBlockDescription}"/>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:out value="${oneSubjectSubjectBlock.active}"/>
                                                                </td>
                                                                <td class="buttonsCell">
                                                                    <c:choose>
                                                                        <c:when test="${authorizedToUpdateSubjectSubjectBlock}">
                                                                            <a class="imageLink" href="<c:url value='/college/subjectsubjectblock.view?newForm=true&amp;tab=5&amp;panel=0&amp;subjectSubjectBlockId=${oneSubjectSubjectBlock.id}&amp;subjectId=${subject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                                                        </c:when>
                                                                    </c:choose>
                                                                    <sec:authorize access="hasRole('DELETE_SUBJECT_SUBJECTBLOCKS')">
                                                                		<a class="imageLinkPaddingLeft" href="<c:url value='/college/subjectsubjectblock_delete.view?newForm=true&amp;tab=5&amp;panel=0&amp;subjectSubjectBlockId=${oneSubjectSubjectBlock.id}&amp;subjectId=${subject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>" 
                                                                		onclick="return confirm('<fmt:message key="jsp.subjectblocks.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                                                    </sec:authorize>
                                                                </td>
                                                                </tr>
<%--                                                          </c:when> --%>
<%--                                                         </c:choose> --%>
<%--                                                     </c:forEach> --%>
                                                </c:forEach> 
                                            </table>
                                            <script type="text/javascript">alternate('TblData2_studyblocks',true)</script>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td colspan="2">&nbsp;</td>
                                    </tr>
                                </table>

                            <!--  end accordionpanelcontent -->
                            </div>
                        <!--  end accordionpanel -->
                        </div>
                    
                    <!-- end of accordion 5 -->
                    </div>
                    <script type="text/javascript">
                        var Accordion5 = new Spry.Widget.Accordion("Accordion5",
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
                </c:if>     
<!--------------------------------- END SUBJECT SUBJECTBLOCKS ------------------------------------->        

<!--------------------------------- SUBJECT EXAMINATIONS ------------------------------------->
                <!--  show tabs only when subject already exists -->
                <c:if test="${'' != subject.id && 0 != subject.id}">
                    <c:choose>
                        <c:when test="${appUseOfSubjectBlocks == 'Y'}">
                            <c:set var="accordion" value="6" />
                        </c:when>
                        <c:otherwise>
                            <c:set var="accordion" value="5" />
                        </c:otherwise>
                    </c:choose>

                <div class="TabbedPanelsContent">

                    <div class="Accordion" id="Accordion${accordion}" tabindex="0">
                        <div class="AccordionPanel">
                          <div class="AccordionPanelTab"><fmt:message key="jsp.subject.subjectexaminations" /></div>
                            <div class="AccordionPanelContent">
                                <table>
                                    <sec:authorize access="hasRole('CREATE_EXAMINATIONS')">
                                        <c:if test="${subjectForm.totalWeighingFactor < 100}" >
                                            <tr>
                                                <td class="buttonsCell" colspan="2" align="right">
                                                    <a class="button" href="<c:url value='/college/examination.view?newForm=true&amp;tab=${accordion}&amp;panel=0&amp;examinationSubjectId=${subject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </sec:authorize>
                                    <c:choose>
                                        <c:when test="${(not empty subjectForm.showExaminationError)}">             
                                            <tr>
                                                <td class="errorwide">
                                                    <c:out value="${subjectForm.showExaminationError}"/>
                                                </td>
                                                <td>&nbsp;</td>
                                            </tr>
                                       </c:when>
                                    </c:choose>

                                    <tr>
                                        <td colspan="2">  
                                            <table class="tabledata2" id="TblData2_examinations">
                                                <c:if test="${not empty subject.examinations}"> 
                                                    <tr>
                                                        <th><fmt:message key="jsp.general.code" /></th>
                                                        <th><fmt:message key="jsp.general.description" /></th>
                                                        <th><fmt:message key="jsp.general.weighingfactor" /></th> 
                                                        <th><fmt:message key="jsp.general.teachers" /></th> 
                                                        <th><fmt:message key="jsp.general.examdate"/></th>
                                                        <th width="20"><b><fmt:message key="jsp.general.active" /></b></th>
                                                        <th></th>
                                                    </tr>
                                                </c:if> 
                                                <c:forEach var="examination" items="${subject.examinations}">
                                                    <tr>
                                                        <td>
                                                            <c:out value="${examination.examinationCode}"/>
                                                        </td>
                                                        <td>
                                                           <a href="<c:url value='/college/examination.view?newForm=true&amp;tab=${accordion}&amp;panel=0&amp;examinationId=${examination.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                                <c:out value="${examination.examinationDescription}"/>
                                                           </a>
                                                        </td>
                                                        <td>
                                                           <c:out value="${examination.weighingFactor} %"/>
                                                        </td>
                                                        <td>
                                                            <c:forEach var="examinationTeacher" items="${examination.teachersForExamination}" varStatus="loopStatus">
<%--                                                                 <c:set var="staffMember" value="${idToStaffMemberMap[examinationTeacher.staffMemberId]}" /> --%>
                                                                <c:set var="staffMember" value="${examinationTeacher.staffMember}" />
                                                                <c:out value="${staffMember.firstnamesFull} ${staffMember.surnameFull}"/><c:if test="${!loopStatus.last}">, </c:if>
                                                            </c:forEach>
                                                        </td>
                                                        <td>
                                                        <fmt:formatDate value="${examination.examinationDate}"/>
                                                        </td>
                                                        <td>
                                                            <fmt:message key="${stringToYesNoMap[examination.active]}"/>
                                                        </td>
                                                        <c:if test="${authorizedToEdit}">
                                                            <td align="right">
                                                                <a class="imageLink" href="<c:url value='/college/examination.view?newForm=true&amp;tab=${accordion}&amp;panel=0&amp;examinationId=${examination.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                                    <img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                                                <sec:authorize access="hasRole('DELETE_EXAMINATIONS')">
                                                                    <a class="imageLinkPaddingLeft" href="<c:url value='/college/examination_delete.view?newForm=true&amp;tab=${accordion}&amp;panel=0&amp;subjectId=${subject.id}&amp;examinationId=${examination.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>" 
                                                                        onclick="return confirm('<fmt:message key="jsp.examinations.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                                                </sec:authorize>
                                                            </td>
                                                        </c:if>
                                                    </tr>
                                                    <c:forEach var="test" items="${examination.tests}">
                                                        <tr>
                                                            <td>
                                                                |- <c:out value="${test.testCode}"/>
                                                            </td>
                                                            <td>
                                                                &nbsp;
                                                                <a href="<c:url value= '/college/test.view?newForm=true&amp;tab=${accordion}&amp;panel=0&amp;from=subject&amp;testId=${test.id}&amp;subjectId=${subject.id}&amp;examinationId=${examination.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                                    <c:out value="${test.testDescription}"/>
                                                                </a>
                                                            </td>
                                                            <td>
                                                                &nbsp;
                                                                <c:out value="${test.weighingFactor} %"/>
                                                            </td>
                                                            <td>
                                                                &nbsp;
                                                                <c:forEach var="testTeacher" items="${test.teachersForTest}" varStatus="loopStatus">
<%--                                                                     <c:set var="staffMember" value="${idToStaffMemberMap[testTeacher.staffMemberId]}" /> --%>
                                                                    <c:set var="staffMember" value="${testTeacher.staffMember}" />
                                                                    <c:out value="${staffMember.firstnamesFull} ${staffMember.surnameFull}"/><c:if test="${!loopStatus.last}">, </c:if>
                                                                </c:forEach>
                                                            </td>
                                                            <td>
                                                                &nbsp;
                                                                <fmt:formatDate value="${test.testDate}"/>
                                                            </td>
                                                            <td>
                                                                &nbsp;
                                                                <fmt:message key="${stringToYesNoMap[test.active]}"/>
                                                            </td>
                                                            <c:if test="${authorizedToEdit}">
                                                                <td align="right">
                                                                    <a class="imageLink" href="<c:url value='/college/test.view?newForm=true&amp;tab=${accordion}&amp;panel=0&amp;from=subject&amp;testId=${test.id}&amp;subjectId=${subject.id}&amp;examinationId=${examination.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                                                                        <img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                                                </td>
                                                            </c:if>
                                                            </tr>
                                                    </c:forEach>
                                                </c:forEach>
                                            </table>
                                            <script type="text/javascript">alternate('TblData2_examinations',true)</script>
                                        </td>
                                    </tr>
                                   <tr><td colspan="2">&nbsp;</td></tr>
                                </table>

                            <!--  end accordionpanelcontent -->
                            </div>
                        <!--  end accordionpanel -->
                        </div>
                    
                    <!-- end of accordion 7 -->
                    </div>
                    <script type="text/javascript">
                        var Accordion${accordion} = new Spry.Widget.Accordion("Accordion${accordion}",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });
                        
                    </script>
                <!--  end tabbedpanelscontent -->
                </div>
                <!--  show this tab only when subject already exists -->
                </c:if>     
<!--------------------------------- END SUBJECT EXAMINATIONS ------------------------------------->
                 
<!--------------------------------- END SUBJECT ------------------------------------->        
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

