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
    
    <spring:bind path="subjectBlockSubjectForm.subjectSubjectBlock">
        <c:set var="subjectSubjectBlock" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectBlockSubjectForm.subjectBlock">
        <c:set var="subjectBlock" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectBlockSubjectForm.subjectSubjectBlock.subject">
        <c:set var="subject" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectBlockSubjectForm.organization">
        <c:set var="organization" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectBlockSubjectForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>
    
        
    <div id="tabcontent">

    	<form>
    		<fieldset>
    			<legend>
                    <a href="<c:url value='/college/subjectblocks.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;

	    			<a href="<c:url value='/college/subjectblock.view?newForm=true&tab=2&panel=0&subjectBlockId=${subjectBlock.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
	    			<c:choose>
	    				<c:when test="${subjectBlock.subjectBlockDescription != null && subjectBlock.subjectBlockDescription != ''}" >
	        				${subjectBlock.subjectBlockDescription} 
                            <c:forEach var="academicYear" items="${subjectBlockSubjectForm.allAcademicYears}">
                                <c:choose>
                                  <c:when test="${academicYear.id == subjectBlock.currentAcademicYearId}">
                               		(${academicYear.description})
                                   </c:when>
                                </c:choose>
                            </c:forEach> 	
						</c:when>
						<c:otherwise>
							<fmt:message key="jsp.href.new" />
						</c:otherwise>
					</c:choose>
					</a>
					&nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.subjectblocksubject" />
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
                                <div class="AccordionPanelTab"><fmt:message key="jsp.general.subjectblocksubject" /></div>
                                <div class="AccordionPanelContent">

								<table>
		                         	<c:choose>
                                    	<c:when test="${(not empty subjectBlockSubjectForm.showSubjectBlockSubjectError)}">             
                                        	<tr>
                                            <td colspan="3" class="error">
                                                ${subjectBlockSubjectForm.showSubjectBlockSubjectError }
                                            </td>
                                        	</tr>
                                   		</c:when>
                                	</c:choose>

	                        		<!--  SUBJECTBLOCK (not editable) -->
		                            <tr>
		                         		<td class="label"><fmt:message key="jsp.general.subjectblock" /></td>
		                         		<td>
											${subjectBlock.subjectBlockDescription}
		                         		</td>
		                                 <td>&nbsp;</td>
		                         	</tr>
	
		                        	<!--  CURRENT ACADEMIC YEAR (not editable) -->
		                            <tr>
		                         		<td class="label"><fmt:message key="jsp.general.academicyear" /></td>
		                         		<td>
		                                    <c:forEach var="academicYear" items="${subjectBlockSubjectForm.allAcademicYears}">
		                                         <c:choose>
		                                             <c:when test="${subjectBlock.currentAcademicYearId != 0
		                                                          && academicYear.id == subjectBlock.currentAcademicYearId}">
		                                                 ${academicYear.description}
		                                             </c:when>
		                                             
		                                         </c:choose>
		                                    </c:forEach>
		                         		</td>
		                                 <td>&nbsp;</td>
		                         	</tr>
								</table>
								
                                <form name="formdata" method="post" >
                                    <input type="hidden" name="submitFormObject" id="submitFormObject" value="" />
                                    
                                    <table>
                                        <tr>
                                            <td colspan="3">
                                                <%@ include file="../../includes/organizationAndNavigationDetail.jsp"%>
                                            </td>
                                        </tr>

                                        <!-- PRIMARY STUDY -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.primarystudy" /></td>
                                            <td class="required">
                                            <c:choose>
                                                <c:when test="${opusUserRole.role != 'student' && opusUserRole.role != 'guest'}">
                                                    <select name="subjectSubjectBlock.subject.primaryStudyId" id="subjectSubjectBlock.subject.primaryStudyId"
                                                            onchange="document.getElementById('subjectSubjectBlock.subject.id').value='0';
                                                                        document.formdata.submit();">
                                                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                </c:when>
	                                        </c:choose>
                                            <c:forEach var="oneStudy" items="${subjectBlockSubjectForm.allStudies}">
                                                <c:choose>
                                                    <c:when test="${opusUserRole.role != 'student' && opusUserRole.role != 'guest'}">
                                                        <c:choose>
                                                            <c:when test="${oneStudy.id == subject.primaryStudyId}">
                                                                <option value="${oneStudy.id}" selected="selected">${oneStudy.studyDescription}</option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${oneStudy.id}">${oneStudy.studyDescription}</option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:choose>
                                                            <c:when test="${oneStudy.id == subject.primaryStudyId}">
                                                                ${oneStudy.studyDescription}
                                                            </c:when>
                                                        </c:choose>
                                                    </c:otherwise>
                                                    </c:choose>
                                            </c:forEach>
	                                        <c:choose>
                                                <c:when test="${opusUserRole.role != 'student' && opusUserRole.role != 'guest'}">
                                                    </select>
                                                </c:when>
                                            </c:choose>
                                            </td>
                                            <td colspan="2">&nbsp;</td>
                                        </tr>
 
                                        <!--  SUBJECT ID -->
                                        <tr>
                                            <td width="200" class="label"><fmt:message key="jsp.general.subject" /></td>
                                            <spring:bind path="subjectBlockSubjectForm.subjectSubjectBlock.subject.id">
                                            <td class="required">
                                            <select name="${status.expression}" id="${status.expression}">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                 <c:forEach var="oneSubject" items="${subjectBlockSubjectForm.allSubjectsForStudy}">
                                                    <%--option value="${oneSubject.id}">allSubjectsForStudy: ${oneSubject.subjectDescription} --%>
                                                    <c:set var="disabled" value="" scope="page" />
                                                    <c:choose>
                                                        <c:when test="${oneSubject.id != null && oneSubject.id == status.value}">
                                                             <option value="${status.value}" selected="selected"> ${oneSubject.subjectDescription }</option>
                                                        </c:when>
                                                         <c:otherwise>
                                                            <c:forEach var="subjectForSubjectBlock" items="${subjectBlockSubjectForm.allSubjectsForSubjectBlock}">
                                                                <%--option value="${subjectForSubjectBlock.id}">allSubjectsForSubjectBlock: ${subjectForSubjectBlock.subjectDescription} --%>
                                                            	<c:choose>
                                                                    <c:when test="${subjectForSubjectBlock.id == oneSubject.id 
                                                                    		&& subjectForSubjectBlock.id != subjectBlockSubjectForm.currentSubjectId}">
                                                                        <c:set var="disabled" value="disabled" scope="page" />
                                                                    </c:when>
                                                                </c:choose>
                                                            </c:forEach>
                                                           
                                                            <c:choose>
                                                                <c:when test="${disabled == ''}">
                                                                    <c:choose>
                                                                        <c:when test="${oneSubject.id == status.value}">
                                                                            <option value="${oneSubject.id}" selected="selected">${oneSubject.subjectDescription}</option>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <option value="${oneSubject.id}">${oneSubject.subjectDescription}</option>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                 </c:when>
                                                           </c:choose>
                                                       </c:otherwise>
                                                   </c:choose>
                                                </c:forEach>
                                               
                                            </select>
                                            </td> 
                                            <td>
                                                <c:if test="${(not empty subjectBlockSubjectForm.txtErr)}">
                                                    <p align="left" class="errorwide">          
                                                        ${subjectBlockSubjectForm.txtErr }
                                                    </p>
                                                </c:if>
                                                <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>
                                        
                                        <!--  ACTIVE -->
                                        <tr>
                                            <td width="200" class="label"><fmt:message key="jsp.general.active" /></td>
                                            <td>
                                                <select name="subjectSubjectBlock.active">
                                                    <c:choose>
                                                        <c:when test="${'Y' == subjectSubjectBlock.active}">
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
                                            <td></td>
                                        </tr>

                                        <!-- SUBMIT BUTTON -->
                                        <tr>
                                            <td class="label">&nbsp;</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${opusUserRole.role != 'student' && opusUserRole.role != 'guest'}">
                                                        <input type="submit" name="submitformdata" value="<fmt:message key="jsp.button.submit" />" onclick="document.getElementById('submitFormObject').value='true';document.formdata.submit();" />
                                                    </c:when>
                                               </c:choose>
                                            </td>
                                        </tr>
                                	</table>
                                </form>
                                </div>
                            </div>
                        </div>
                        <script type="text/javascript">
                            var sampleAccordion = new Spry.Widget.Accordion("Accordion1");
                        </script>
                    </div>     
            </div>
        </div>
    </div>
        
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(${navigationSettings.tab});
    </script>
</div>

<%@ include file="../../footer.jsp"%>

