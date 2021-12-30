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

<div id="wrapper">

    <%@ include file="../../menu.jsp"%>
    
    <spring:bind path="subjectBlockStudyGradeTypeForm.subjectBlockStudyGradeType">
        <c:set var="subjectBlockStudyGradeType" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectBlockStudyGradeTypeForm.subjectBlockStudyGradeType.subjectBlock">
        <c:set var="subjectBlock" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectBlockStudyGradeTypeForm.subjectBlockStudyGradeType.studyGradeType">
        <c:set var="studyGradeType" value="${status.value}" scope="page" />
    </spring:bind>
    
    
    <spring:bind path="subjectBlockStudyGradeTypeForm.organization">
        <c:set var="organization" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="subjectBlockStudyGradeTypeForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>

    <%-- authorizations --%>
    <sec:authorize access="hasAnyRole('CREATE_SUBJECTBLOCK_STUDYGRADETYPES','UPDATE_SUBJECTBLOCK_STUDYGRADETYPES')">
        <c:set var="authorizedToEdit" value="${true}"/>
    </sec:authorize>

<div id="tabcontent">

<form>
    <fieldset>
 		<legend>
            <a href="<c:url value='/college/subjectblocks.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
  			<a href="<c:url value='/college/subjectblock.view?newForm=true&tab=${navigationSettings.tab}&panel=${navigationSettings.panel}&subjectBlockId=${subjectBlock.id}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
  			<c:choose>
  				<c:when test="${subjectBlock.subjectBlockDescription != null && subjectBlock.subjectBlockDescription != ''}" >
      				${subjectBlock.subjectBlockDescription} 
                         <c:forEach var="academicYear" items="${subjectBlockStudyGradeTypeForm.allAcademicYears}">
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
        &nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.subjectblockstudygradetype" /> 
    </legend></fieldset>
</form>

<div id="tp1" class="TabbedPanel">
    <ul class="TabbedPanelsTabGroup">
        <li class="TabbedPanelsTab"><fmt:message key="jsp.general.edit" /></li>
    </ul>
    <div class="TabbedPanelsContentGroup">
        <div class="TabbedPanelsContent">
            <div class="Accordion" id="Accordion1" tabindex="0">
                <div class="AccordionPanel">
                    <div class="AccordionPanelTab"><fmt:message key="jsp.general.subjectblockstudygradetype" /></div>
                        <div class="AccordionPanelContent">
                            <table>
                                  <c:choose>
                                      <c:when test="${(not empty subjectBlockStudyGradeTypeForm.showSubjectBlockStudyGradeTypeError)}">             
                                          <tr>
                                              <td colspan="3" class="error">
                                                  ${subjectBlockStudyGradeTypeForm.showSubjectBlockStudyGradeTypeError }
                                              </td>
                                          </tr>
                                     </c:when>
                                  </c:choose>

	                       		<!--  SUBJECTBLOCK (not editable) -->
	                            <tr>
	                         		<td width="200"  class="label"><fmt:message key="jsp.general.subjectblock" /></td>
	                         		<td>
										${subjectBlock.subjectBlockDescription}
	                         		</td>
	                                 <td>&nbsp;</td>
	                         	</tr>
	
	                        	<!--  CURRENT ACADEMIC YEAR (not editable) -->
	                            <tr>
	                         		<td width="200" class="label"><fmt:message key="jsp.general.academicyear" /></td>
	                         		<td>
	                                    <c:forEach var="academicYear" items="${subjectBlockStudyGradeTypeForm.allAcademicYears}">
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
                                <tr><td colspan="3">
                               	<form name="formdata" method="post">
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
                                                    <select name="subjectBlockStudyGradeType.studyGradeType.studyId" id="subjectBlockStudyGradeType.studyGradeType.studyId" onchange="
                                                        document.getElementById('subjectBlockStudyGradeType.studyGradeType.gradeTypeCode').value='';
                                                    	document.getElementById('subjectBlockStudyGradeType.studyGradeType.id').value='0';
                                                        document.getElementById('subjectBlockStudyGradeType.cardinalTimeUnitNumber').value='0';
                                                    	document.formdata.submit();">
                                                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                </c:when>
	                                        </c:choose>
                                            <c:forEach var="oneStudy" items="${subjectBlockStudyGradeTypeForm.allStudies}">
                                                <c:choose>
                                                    <c:when test="${opusUserRole.role != 'student' && opusUserRole.role != 'guest'}">
                                                        <c:choose>
                                                            <c:when test="${oneStudy.id == studyGradeType.studyId}">
                                                                <option value="${oneStudy.id}" selected="selected">${oneStudy.studyDescription}</option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${oneStudy.id}">${oneStudy.studyDescription}</option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:choose>
                                                            <c:when test="${oneStudy.id == studyGradeType.studyId}">
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
                                            <td>&nbsp;</td>
                                        </tr>

                                        <!--  GRADE TYPE CODE -->
                                        <spring:bind path="subjectBlockStudyGradeTypeForm.subjectBlockStudyGradeType.studyGradeType.gradeTypeCode">
                                            <tr>
                                                <td class="label"><fmt:message key="jsp.general.gradetypecode" /></td>
                                                <td class="required">
                                                    <select id="${status.expression}" name="${status.expression}" onchange="
                                                            document.getElementById('subjectBlockStudyGradeType.studyGradeType.id').value='0';
                                                            document.getElementById('subjectBlockStudyGradeType.cardinalTimeUnitNumber').value='0';
                                                            document.formdata.submit();">
                                                        <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                                        <!-- loop through all gradeTypes linked to the selected study -->
                                                        <c:forEach var="oneStudyGradeType" items="${subjectBlockStudyGradeTypeForm.distinctStudyGradeTypesForStudy}">
                                                            <c:choose>
                                                                <c:when test="${status.value == oneStudyGradeType.gradeTypeCode}">
                                                                    <option value="${oneStudyGradeType.gradeTypeCode}" selected="selected">${oneStudyGradeType.gradeTypeDescription}</option>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <option value="${oneStudyGradeType.gradeTypeCode}">${oneStudyGradeType.gradeTypeDescription}</option>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                                <td>
                                                    <c:forEach var="error" items="${status.errorMessages}">
                                                        <span class="error"> ${error}</span>
                                                    </c:forEach>
                                                </td>
                                            </tr>
                                        </spring:bind>

                                    <spring:bind path="subjectBlockStudyGradeTypeForm.subjectBlockStudyGradeType.studyGradeType.id">
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.studyform" />/<fmt:message key="jsp.general.studytime" />
                                        </td>
                                        <td class="required">
                                             <select name="${status.expression}" id="${status.expression}"  onchange="
                                                            document.getElementById('subjectBlockStudyGradeType.cardinalTimeUnitNumber').value='0';
                                                            document.formdata.submit();">
                                                 <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                 <c:forEach var="oneStudyGradeType" items="${subjectBlockStudyGradeTypeForm.allStudyGradeTypesForStudy}">
                                                    <c:set var="disabled" value="" scope="page" /> 
                                                     <c:choose>
                                                         <c:when test="${oneStudyGradeType.id != null && oneStudyGradeType.id == status.value}">
                                                             <option value="${status.value}" selected="selected">
                                                             <c:forEach var="studyForm" items="${allStudyForms}">
                                                                  <c:choose>
                                                                      <c:when test="${oneStudyGradeType.studyFormCode != null && 
                                                                                oneStudyGradeType.studyFormCode != ''
                                                                                   && studyForm.code == oneStudyGradeType.studyFormCode}">
                                                                          ${studyForm.description}
                                                                      </c:when>
                                                                  </c:choose>
                                                             </c:forEach>
                                                             <c:forEach var="studyTime" items="${allStudyTimes}">
                                                                  <c:choose>
                                                                      <c:when test="${oneStudyGradeType.studyTimeCode != null && 
                                                                                oneStudyGradeType.studyTimeCode != ''
                                                                                   && studyTime.code == oneStudyGradeType.studyTimeCode}">
                                                                          /${studyTime.description}
                                                                      </c:when>
                                                                   </c:choose>
                                                             </c:forEach>
                                                         </c:when>
                                                         <c:otherwise>
                                                            <c:forEach var="studyGradeTypeOfSubjectBlock" items="${subjectBlockStudyGradeTypeForm.allStudyGradeTypesForSubjectBlock}">
                                                                <c:choose>
                                                                    <c:when test="${studyGradeTypeOfSubjectBlock.id == oneStudyGradeType.id && studyGradeTypeOfSubjectBlock.id != subjectBlockStudyGradeTypeForm.currentStudyGradeTypeId}">
                                                                        <c:set var="disabled" value="disabled" scope="page" />
                                                                    </c:when>
                                                                </c:choose>  
                                                            </c:forEach>
                                                            <c:choose>
                                                                <c:when test="${disabled == ''}">
                                                                    <option value="${oneStudyGradeType.id}"> 
                                                                     <c:forEach var="studyForm" items="${allStudyForms}">
                                                                          <c:choose>
                                                                              <c:when test="${oneStudyGradeType.studyFormCode != null && 
                                                                                        oneStudyGradeType.studyFormCode != ''
                                                                                           && studyForm.code == oneStudyGradeType.studyFormCode}">
                                                                                  ${studyForm.description}
                                                                              </c:when>
                                                                          </c:choose>
                                                                     </c:forEach>
                                                                     <c:forEach var="studyTime" items="${allStudyTimes}">
                                                                          <c:choose>
                                                                              <c:when test="${oneStudyGradeType.studyTimeCode != null && 
                                                                                        oneStudyGradeType.studyTimeCode != ''
                                                                                           && studyTime.code == oneStudyGradeType.studyTimeCode}">
                                                                                  /${studyTime.description}
                                                                              </c:when>
                                                                           </c:choose>
                                                                     </c:forEach>
                                                                </c:when>
                                                            </c:choose>
                                                         </c:otherwise>
                                                    </c:choose>
                                                 </c:forEach>
                                             </select>
                                         </td>
                                         <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                             </c:forEach>
                                        </td>
                                    </tr>
                                    </spring:bind>

                             		<!--  CARDINAL TIME UNIT NUMBER -->
                                  
                                    <c:choose>
                                        <c:when test="${authorizedToEdit}">
                                            <c:set var="listOfCardinalTimeUnits" value="${studyGradeType.numberOfCardinalTimeUnits}" scope="page" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="listOfCardinalTimeUnits" value="${studyGradeType.numberOfCardinalTimeUnits}" scope="page" />
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <spring:bind path="subjectBlockStudyGradeTypeForm.subjectBlockStudyGradeType.cardinalTimeUnitNumber">
		                             <tr>
		                                <td class="label"><fmt:message key="jsp.general.cardinaltimeunit.number" /></td>
		                                <td class="required">
		                                <select name="${status.expression}" id="${status.expression}">
		                                    <option value="0"><fmt:message key="jsp.general.any" /></option>
		                                    <c:forEach begin="1" end="${listOfCardinalTimeUnits}" var="current">
		                                        <c:choose>
		                                            <c:when test="${status.value == current}">
		                                               <option value="${current}" selected="selected">${current}</option>
		                                            </c:when>
		                                            <c:otherwise>
		                                                <option value="${current}">${current}</option>
		                                            </c:otherwise>
		                                        </c:choose>
		                                    </c:forEach>
		                                </select>
		                                </td> 
		                                <td> <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
		                                     </c:forEach>
		                                </td>
		                            </tr>
                                    </spring:bind>
                                    
		                            <!-- RIGIDITYTYPE -->
		                            <tr>
		                                <td class="label"><fmt:message key="jsp.subject.rigiditytype" /></td>
		                                <spring:bind path="subjectBlockStudyGradeTypeForm.subjectBlockStudyGradeType.rigidityTypeCode">
		                                <td class="required">
		                                    <c:choose>
		                                        <c:when test="${opusUserRole.role != 'student' && opusUserRole.role != 'guest'}">
		                                            <select name="${status.expression}">
		                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
		                                        </c:when>
		                                    </c:choose>
		                                        <c:forEach var="rigidityType" items="${allRigidityTypes}">
		                                            <c:choose>
		                                                <c:when test="${opusUserRole.role != 'student' && opusUserRole.role != 'guest'}">
		                                                    <c:choose>
		                                                        <c:when test="${rigidityType.code == status.value}">
		                                                            <option value="${rigidityType.code}" selected="selected">${rigidityType.description}</option>
		                                                        </c:when>
		                                                        <c:otherwise>
		                                                            <option value="${rigidityType.code}">${rigidityType.description}</option>
		                                                        </c:otherwise>
		                                                    </c:choose>
		                                                </c:when>
		                                                <c:otherwise>
		                                                    <c:choose>
		                                                        <c:when test="${rigidityType.code == status.value}">
		                                                            ${rigidityType.description}
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
		                                <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
		                                </spring:bind>
		                            </tr>

                                    <!-- IMPORTANCE -->
                                    <spring:bind path="subjectBlockStudyGradeTypeForm.subjectBlockStudyGradeType.importanceTypeCode">                                        
                                        <c:if test="${initParam.iMajorMinor == 'Y'}">
                                        <tr>
                                        <td class="label"><fmt:message key="jsp.subject.importance" /></td>
                                       
                                        <td>
                                           <select name="${status.expression}">
                                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                
                                                <c:forEach var="importanceType" items="${allImportanceTypes}">
                                                         <c:choose>
                                                            <c:when test="${importanceType.code == status.value}">
                                                                <option value="${importanceType.code}" selected="selected">${importanceType.description}</option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${importanceType.code}">${importanceType.description}</option>
                                                            </c:otherwise>
                                                        </c:choose>
                                            </c:forEach>
                                           </select>
                                        </td>
                                        <td></td>
                                    </tr>
                                    </c:if>
                                     </spring:bind>
                                     
                                    <!-- BLOCK TYPE -->
                                    
		                            <!--  ACTIVE -->
		                            
		                                <tr>
		                                    <td width="200" class="label"><fmt:message key="jsp.general.active" /></td>
		                                    <td>
		                                        <select name="subjectBlockStudyGradeType.active">
		                                            <c:choose>
		                                                <c:when test="${'Y' == subjectBlockStudyGradeType.active}">
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
                                        </td></tr>
                                        
                                        
                                        <!--  SubjectBlockPrerequisites, show only if subjectBlockStudyGradeType exists -->
                                        <c:choose>
                                            <c:when test="${subjectBlockStudyGradeTypeForm.subjectBlockStudyGradeType.id != 0}">
                                                <spring:bind path="subjectBlockStudyGradeTypeForm.subjectBlockStudyGradeType.subjectBlockPrerequisites">
                                                    <tr><td colspan="3">&nbsp;</td></tr>
                                                    <tr>
                                                        <td class="header"><fmt:message key="jsp.general.subjectblockprerequisites" /></td>
                                                        <td colspan="2" align="right">
                                                            <sec:authorize access="hasRole('CREATE_SUBJECTBLOCK_PREREQUISITES')">
                                                                <a class="button" href="<c:url value='/college/subjectblockprerequisite.view?newForm=true&tab=${navigationSettings.tab }&panel=${navigationSettings.panel }&subjectBlockStudyGradeTypeId=${subjectBlockStudyGradeType.id}&mainSubjectBlockId=${subjectBlock.id}&primaryStudyId=${studyId }&gradeTypeCode=${gradeTypeCode }&currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                                            </sec:authorize>
                                                        </td>
                                                    </tr>
                                                    
                                                    <tr>
                                                        <td colspan="3">
                                                            <!-- list of prerequisites -->
                                                            <table class="tabledata2" id="TblData2_subjectBlockStudyGradeType">
                                                                <tr>
                                                                    <th width="90"><fmt:message key="jsp.general.code" /></th>
                                                                    <th><fmt:message key="jsp.general.description" /></th>
                                                                    <th><fmt:message key="jsp.general.active" /></th>
                                                                    <td width="30">&nbsp;</td>
                                                                </tr>
                                                                <c:forEach var="oneSubjectBlockPrerequisite" items="${status.value}">
                                                                    <tr>
                                                                        <td>
                                                                            ${oneSubjectBlockPrerequisite.requiredSubjectBlockCode}
                                                                        </td>
                                                                        <td>
                                                                            ${oneSubjectBlockPrerequisite.requiredSubjectBlockDescription}
                                                                        </td>
                                                                        <td>
                                                                            ${oneSubjectBlockPrerequisite.active}
                                                                        </td>
                                                                        <!-- delete button -->
                                                                        <td class="buttonsCell">
                                                                           <sec:authorize access="hasRole('DELETE_SUBJECTBLOCK_PREREQUISITES')">
                                                                                <a href="<c:url value='/college/subjectblockprerequisite_delete.view?newForm=true&tab=2&panel=0&subjectBlockStudyGradeTypeId=${oneSubjectBlockPrerequisite.subjectBlockStudyGradeTypeId}&requiredSubjectBlockCode=${oneSubjectBlockPrerequisite.requiredSubjectBlockCode}&currentPageNumber=${navigationSettings.currentPageNumber}'/>"  
                                                                                onclick="return confirm('<fmt:message key="jsp.subjectblockprerequisite.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                                                            </sec:authorize>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                                <tr>
                                                                    <td colspan="4">
                                                                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <script type="text/javascript">alternate('TblData2_subjectBlockStudyGradeType',true)</script>
                                                        </td>
                                                    </tr>
                                                </spring:bind>
                                            </c:when>
                                        </c:choose>
                            		</table>
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
    </script></div>

<%@ include file="../../footer.jsp"%>

