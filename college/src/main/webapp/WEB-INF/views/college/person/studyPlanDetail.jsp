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

<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

 	<!-- necessary spring binds for organization and navigationSettings
		 regarding form handling through includes -->
    <c:set var="organization" value="${studyPlanDetailForm.organization}" scope="page" />
    <c:set var="navigationSettings" value="${studyPlanDetailForm.navigationSettings}" scope="page" />

    <c:set var="studyPlanCardinalTimeUnit" value="${studyPlanDetailForm.studyPlanCardinalTimeUnit}" scope="page" />
    <c:set var="student" value="${studyPlanDetailForm.student}" scope="page" />
    <c:set var="studyPlan" value="${studyPlanDetailForm.studyPlan}" scope="page" />
    <c:set var="studyGradeType" value="${studyPlanDetailForm.studyGradeType}" scope="page" />

    <div id="tabcontent">

		<fieldset>
			<legend>
                <a href="<c:url value='/college/students.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
    			<a href="<c:url value='/college/student/subscription.view'/>?<c:out value='tab=2&panel=0&studentId=${student.studentId}'/>">
    			<c:choose>
    				<c:when test="${not empty student.surnameFull}" >
    					<c:set var="studentName">${fn:trim(student.studentCode)} ${fn:trim(student.surnameFull)}, ${fn:trim(student.firstnamesFull)}</c:set>
    					<c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}"/>
					</c:when>
					<c:otherwise>
						<fmt:message key="jsp.href.new" />
					</c:otherwise>
				</c:choose>
				</a>
    			<br />&nbsp;&nbsp;&nbsp;>&nbsp;<a href="<c:url value='/college/studyplan.view'/>?<c:out value='tab=${navigationSettings.tab}&panel=${navigationSettings.panel}&studyPlanId=${studyPlanDetailForm.studyPlan.id}&studentId=${student.studentId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                    <c:out value="${studyPlanDetailForm.studyPlan.study.studyDescription}" /> <c:out value="${studyPlanDetailForm.studyPlan.gradeTypeCode}" />
				</a>
    			&nbsp;>&nbsp;<a href="<c:url value='/college/studyplancardinaltimeunit.view'/>?<c:out value='tab=${navigationSettings.tab}&panel=${navigationSettings.panel}&studyPlanCardinalTimeUnitId=${studyPlanCardinalTimeUnit.id}&studentId=${student.studentId}&currentPageNumber=${nvaigationSettings.currentPageNumber}'/>">
    			<c:choose>
    				<c:when test="${studyPlanCardinalTimeUnit.id != null && studyPlanCardinalTimeUnit.id != ''}" >
    					<fmt:message key="jsp.general.cardinaltimeunit" /> <c:out value="${studyPlanCardinalTimeUnit.cardinalTimeUnitNumber}"/>
					</c:when>
					<c:otherwise>
						<fmt:message key="jsp.href.new" />
					</c:otherwise>
				</c:choose>
				</a>
				&nbsp;>&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.studyplandetails" />
			</legend>
            
            <table>
                <!-- Student -->
                <tr>
                    <td class="label"><fmt:message key="jsp.general.studentcode" /></td>
                    <td>
                        <c:out value="${student.studentCode}" />
                    </td>
                </tr>
                <tr>
                    <td class="label"><fmt:message key="jsp.general.firstnames" /></td>
                    <td>
                        <c:out value="${student.firstnamesFull}" />
                    </td>
                </tr>
                <tr>
                    <td class="label"><fmt:message key="jsp.general.surname" /></td>
                    <td>
                        <c:out value="${student.surnameFull}" />
                    </td>
                </tr>

                <!--  STUDYGRADETYPE -->
                <tr>
                    <td class="label"><fmt:message key="jsp.general.studygradetype" /></td>
                    <td>
                        <c:out value="${studyGradeType.studyDescription }" />,
                        <c:out value="${idToStudyMap[studyGradeType.studyId].studyDescription}"></c:out>
                        <c:out value="${studyPlanDetailForm.codeToGradeTypeMap[studyGradeType.gradeTypeCode].description}" />
                        <c:out value="- ${studyPlanDetailForm.idToAcademicYearMap[studyGradeType.currentAcademicYearId].description}"/>
                        <c:out value="- ${studyPlanDetailForm.codeToStudyTimeMap[studyGradeType.studyTimeCode].description}"/>
                        <c:out value="- ${studyPlanDetailForm.codeToStudyFormMap[studyGradeType.studyFormCode].description}"/>
                    </td>
                </tr>
                <!--  CARDINAL TIME UNIT NUMBER -->
                <tr>
                    <td width="200" class="label"><fmt:message key="jsp.general.cardinaltimeunit" /></td>
                    <td><c:out value="${studyPlanCardinalTimeUnit.cardinalTimeUnitNumber}"/></td>
                </tr>

            </table>
            
		</fieldset>

        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.edit" /></li>               
            </ul>

            <div class="TabbedPanelsContentGroup">   
                <div class="TabbedPanelsContent">
                    <div class="Accordion" id="Accordion1">
                        <div class="AccordionPanel">
                            <div class="AccordionPanelTab"><fmt:message key="jsp.general.studyplandetails" /></div>
                            <div class="AccordionPanelContent">

                                <form:errors path="studyPlanDetailForm.*" cssClass="errorwide" element="p"/>

                                <form:form modelAttribute="studyPlanDetailForm" method="post" name="studyPlanDetailForm">
                           		<input type="hidden" name="submitFormObject" id="submitFormObject" value="normal" />

                                <%@ include file="../../includes/navigation_privileges.jsp"%>

								<table>
                                    <!-- Institution -->
                                    <c:if test="${showInstitutions}">
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.university" /></td>
                                            <td>
                                                <form:select path="organization.institutionId" onchange="
                                                        document.getElementById('organization.branchId').value='0';
                                                        document.getElementById('organization.organizationalUnitId').value='0';
                                                        document.getElementById('chosenStudyGradeTypeId').value='0';
                                                        document.getElementById('chosenCardinalTimeUnitNumber').value='0';
                                                        document.getElementById('submitFormObject').value='institutionId';
                                                        this.form.submit();">
                                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    <c:forEach var="institution" items="${organization.allInstitutions}">
                                                        <form:option value="${institution.id}"><c:out value="${institution.institutionDescription}"/></form:option>
                                                    </c:forEach>
                                                </form:select>
                                            </td>
                                       </tr>
                                    </c:if>

                                    <!-- start of branch -->
                                    <c:if test="${showBranches}">
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.branch" /></td>
                                            <td>
                                                <form:select path="organization.branchId" onchange="
                                                        document.getElementById('organization.organizationalUnitId').value='0';
                                                        document.getElementById('chosenStudyGradeTypeId').value='0';
                                                        document.getElementById('chosenCardinalTimeUnitNumber').value='0';
                                                        document.getElementById('submitFormObject').value='branchId';
                                                        this.form.submit();">
                                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    <c:choose>
                                                        <c:when test="${(institutionId != 0) }"> 
                                                            <c:forEach var="branch" items="${organization.allBranches}">
                                                                <form:option value="${branch.id}"><c:out value="${branch.branchDescription}"/></form:option>
                                                            </c:forEach>
                                                        </c:when>
                                                    </c:choose>
                                                </form:select>
                                            </td>
                                        </tr>
                                    </c:if>

                                    <!-- start of organizational unit -->
                                    <c:if test="${showOrgUnits}">
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.organizationalunit" /></td>
                                            <td>
                                                <form:select path="organization.organizationalUnitId" onchange="
                                                        document.getElementById('chosenStudyGradeTypeId').value='0';
                                                        document.getElementById('chosenCardinalTimeUnitNumber').value='0';
                                                        document.getElementById('submitFormObject').value='organizationalUnitId';
                                                        this.form.submit();">
                                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    <c:forEach var="organizationalUnit" items="${organization.allOrganizationalUnits}">
                                                        <form:option value="${organizationalUnit.id}">
                                                            <c:out value="${organizationalUnit.organizationalUnitDescription}"/> (<fmt:message key="jsp.organizationalunit.level" /> <c:out value="${organizationalUnit.unitLevel})"/>
                                                        </form:option>
                                                    </c:forEach>
                                                </form:select>
                                            </td>
                                        </tr>
                                    </c:if>                                
                                    <!--  STUDYGRADETYPE -->
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.studygradetype" /></td>
                                        <td>
                                            <form:select path="chosenStudyGradeTypeId" onchange="document.getElementById('submitFormObject').value='chosenStudyGradeTypeId';this.form.submit();">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach var="sgt" items="${studyPlanDetailForm.allStudyGradeTypes}">
                                                    <c:set var="line"><c:out value="${sgt.studyDescription}
                                                    - ${sgt.gradeTypeDescription}
                                                    - ${studyPlanDetailForm.codeToStudyTimeMap[sgt.studyTimeCode].description}
                                                    - ${studyPlanDetailForm.codeToStudyFormMap[studyGradeType.studyFormCode].description}"/></c:set>
                                                    <form:option value="${sgt.id}" title="${line}">${line}</form:option>
                                                </c:forEach>
                                            </form:select>
                                        </td>
                                        <td><form:errors path="chosenStudyGradeTypeId" cssClass="error"/></td>
                                    </tr>

                                    <!--  CARDINAL TIME UNIT NUMBER -->
                                    <tr>
                                        <td class="label"><fmt:message key="jsp.general.cardinaltimeunit" /></td>
                                        <td>
                                            <form:select path="chosenCardinalTimeUnitNumber" onchange="document.getElementById('submitFormObject').value='chosenCardinalTimeUnitNumber';this.form.submit();">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach var="ctusgt" items="${studyPlanDetailForm.allCardinalTimeUnitStudyGradeTypes}">
                                                    <form:option value="${ctusgt.cardinalTimeUnitNumber}">${ctusgt.cardinalTimeUnitNumber}</form:option>
                                                </c:forEach>
                                            </form:select>
                                        </td>
                                        <td><form:errors path="chosenCardinalTimeUnitNumber" cssClass="error"/></td>
                                    </tr>

                                    <!--  EXEMPTED -->
                                    <tr>
                                        <td class="label"><fmt:message key="general.exempted" /></td>
                                        <td>
                                            <form:checkbox path="exempted"  />
                                        </td>
                                    </tr>
                                </table>
                                <fieldset>
                                    <legend>
                                        <fmt:message key="jsp.fastinput.subscription"/>
                                    </legend>
                                    <table style="width:100%;">
                                        <tr>
                            
                                            <c:set var="subjectAndBlockSelection" value="${studyPlanDetailForm.subjectAndBlockSelection}" />
                                            <%@ include file="includes/subjectAndBlockSelection.jsp"%>
                                        </tr>
                                    </table>
                                </fieldset>


<%--                                     <tr>
                                    	<td width="200">&nbsp;</td>
                                    	<c:if test="${appUseOfSubjectBlocks == 'Y'}">
                                    	   <td width="200" class="label"><fmt:message key="jsp.general.subjectblock" />
                                           &nbsp;<fmt:message key="jsp.general.or" /></td>
                                    	</c:if>
                                    	<td width="200" class="label"><fmt:message key="jsp.general.subject" /></td>
                                    </tr>
                                    <tr>
                                    	<td width="200">&nbsp;</td>

                                        <c:if test="${appUseOfSubjectBlocks == 'Y'}">
                                        <!--  SUBJECT BLOCK ID -->
                                       	<td valign="top">
                                       	<spring:bind path="studyPlanDetailForm.studyPlanDetail.subjectBlockId">
                                        	<table>
                                        	<tr>
                                        	<td nowrap valign="top">
                                            <select name="${status.expression}" id="${status.expression}" onchange="
                                                                        document.getElementById('studyPlanDetail.subjectId').value='0';" class="long">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                 <c:forEach var="oneSubjectBlock" items="${studyPlanDetailForm.allSubjectBlocks}">
                                                    <c:set var="currentImportanceTypeDescription" value="" scope="page" />
                                                    <c:set var="currentSubjectBlockStudyGradeType" value="" scope="page" />

                                                    <c:set var="disabled" value="" scope="page" />

                                                    < % - -  only disable when a new studyplandetail is made - - % >
                                                    <c:choose>
                                                       <c:when test="${'' == studyPlanDetail.id || 0 == studyPlanDetail.id}">
		                                                    <c:forEach var="subjectBlockForStudyPlanCardinalTimeUnit" items="${studyPlanDetailForm.allSubjectBlocksForStudyPlanCardinalTimeUnit}">
		                                                    	<c:choose>
		                                                            <c:when test="${(subjectBlockForStudyPlanCardinalTimeUnit.id == oneSubjectBlock.id)}">
		                                                                <c:set var="disabled" value="disabled" scope="page" />
		                                                            </c:when>
		                                                        </c:choose>
		                                                    </c:forEach>
                                                        </c:when>
                                                    </c:choose>

                                                    <c:choose>
                                                        <c:when test="${disabled == ''}">
                                                            <c:set var="optionText" value="${oneSubjectBlock.subjectBlockDescription} (${idToStudyMap[oneSubjectBlock.primaryStudyId].studyDescription}, ${studyPlanDetailForm.idToOrganizationalUnitMap[study.organizationalUnitId].organizationalUnitDescription})" />
                                                            <c:set var="optionText" value="${optionText} - ${studyPlanDetailForm.codeToStudyTimeMap[oneSubjectBlock.studyTimeCode].description}"/>
                                                            <c:set var="optionText"><c:out value="${optionText}"/></c:set>
                                                        	<c:choose>
									                        	<c:when test="${studyPlanDetail.subjectBlockId == oneSubjectBlock.id}">
                                                       			      <option value="${oneSubjectBlock.id}" selected title="${optionText}">
		                                                        </c:when>
	                                                            <c:otherwise>
	                                                                <option value="${oneSubjectBlock.id}" title="${optionText}">
	                                                            </c:otherwise>
	                                                        </c:choose>
                                                            ${optionText}
	                                               		</c:when>
                                                   	</c:choose>
                                                </c:forEach>
                                            </select>
                                            </td>
                                            </tr>
                                                   
                                            <tr> 
                                            <td></td>
 											</tr>
											</table>
 										</spring:bind>
										</td>
                                        </c:if>
                                        
                                      	<!--  SUBJECT ID -->
										<td valign="top">
                                        <spring:bind path="studyPlanDetailForm.studyPlanDetail.subjectId">
                                        	<table>
                                        	<tr>
                                        	<td valign="top">
                                            <select name="${status.expression}" id="${status.expression}" onchange="
                                                                        document.getElementById('studyPlanDetail.subjectBlockId').value='0';" class="long">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                 <c:forEach var="oneSubject" items="${studyPlanDetailForm.allSubjects}">

                                                    <c:set var="disabled" value="" scope="page" />

                                                    <!--  only disable when a new studyplandetail is made -->
                                                    <c:choose>
                                                       <c:when test="${'' == studyPlanDetail.id || 0 == studyPlanDetail.id}">
		                                                    <c:forEach var="subjectForStudyPlan" items="${studyPlanDetailForm.allSubjectsForStudyPlanCardinalTimeUnit}">
		                                                    	<c:choose>
		                                                            <c:when test="${(subjectForStudyPlan.id == oneSubject.id)}">
		                                                                <c:set var="disabled" value="disabled" scope="page" />
		                                                            </c:when>
		                                                        </c:choose>
		                                                    </c:forEach>
                                                        </c:when>
                                                    </c:choose>

                                                    <c:choose>
                                                        <c:when test="${disabled == ''}">
                                                            <c:set var="optionText" value="${oneSubject.subjectDescription} (${idToStudyMap[oneSubject.primaryStudyId].studyDescription}, ${studyPlanDetailForm.idToOrganizationalUnitMap[study.organizationalUnitId].organizationalUnitDescription})"/>
                                                            <c:set var="optionText" value="${optionText} - ${studyPlanDetailForm.codeToStudyTimeMap[oneSubject.studyTimeCode].description}"/>
                                                            <c:set var="optionText"><c:out value="${optionText}"/></c:set>
                                                            <c:choose>
										                        <c:when test="${studyPlanDetail.subjectId == oneSubject.id}">
                                                                    <option value="${oneSubject.id}" selected title="${optionText}">
	                                                            </c:when>
	                                                            <c:otherwise>
	                                                                    <option value="${oneSubject.id}" title="${optionText}">
	                                                            </c:otherwise>
	                                                        </c:choose>
                                                            ${optionText}
                                                            </option>
		                                                </c:when>
                                                   </c:choose>
                                                </c:forEach>
                                               
                                            </select>
                                            </td>
                                            </tr>
                                           	<tr> 
                                            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                            </td>
 											</tr>
 											</table>
										</td>
 										</spring:bind>
									</tr>
--%>

                                    <!-- ACTIVE -->
<!--                                     <tr> -->
<%--                                         <td width="200" class="label"><fmt:message key="jsp.general.active" /></td> --%>
<%--                                         <spring:bind path="studyPlanDetailForm.studyPlanDetail.active"> --%>
<!--                                         <td > -->
<%--                                             <select name="${status.expression}"> --%>
<%--                                                 <c:choose> --%>
<%--                                                     <c:when test="${'Y' == status.value}"> --%>
<%--                                                         <option value="Y" selected="selected"><fmt:message key="jsp.general.yes" /></option> --%>
<%--                                                         <option value="N"><fmt:message key="jsp.general.no" /></option> --%>
<%--                                                     </c:when> --%>
<%--                                                     <c:otherwise> --%>
<%--                                                         <option value="Y"><fmt:message key="jsp.general.yes" /></option> --%>
<%--                                                         <option value="N" selected="selected"><fmt:message key="jsp.general.no" /></option> --%>
<%--                                                     </c:otherwise> --%>
<%--                                                    </c:choose> --%>
<!--                                             </select> -->
<!--                                         </td> -->
<!--                                         <td> -->
<%--                                         <c:forEach var="error" items="${status.errorMessages}"><span class="error"> --%>
<%--                                             ${error}</span> --%>
<%--                                         </c:forEach> --%>
<!--                                         </td> -->
<%--                                         </spring:bind> --%>
<!--                                     </tr> -->
                                    
                                <table>
                                    <!-- SUBMIT BUTTON -->
                                    <tr>
                                    	<td class="label">&nbsp;</td>
                                    	<td colspan="2" align="right">
                                    		<input type="button" value="<fmt:message key="jsp.button.submit" />" onclick="document.getElementById('submitFormObject').value='true';this.form.submit();" />
                                    	</td>
                                    </tr>    
 	                               	
                                </table>
	                            </form:form>
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

