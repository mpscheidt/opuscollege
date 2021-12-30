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
<jwr:script src="/bundles/jquerycomp.js" />  <%-- date picker --%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <c:set var="form" value="${testForm}" />

    <c:set var="navigationSettings" value="${form.navigationSettings}" scope="page" />

    <c:set var="examinationId" value="${form.test.examinationId}" scope="page" />
    <c:set var="testId" value="${form.test.id}" scope="page" />
    <c:set var="subject" value="${form.subject}" scope="page" />
    <c:set var="examination" value="${form.examination}" scope="page" />

    <%-- decide whether to display read-only or allow to edit --%>
    <c:set var="authorizedToEdit" value="${false}"/>
    <sec:authorize access="hasAnyRole('CREATE_TESTS','UPDATE_TESTS')">
        <c:set var="authorizedToEdit" value="${true}"/>
    </sec:authorize>

    <div id="tabcontent">

		<fieldset>
			<legend>
                <a href="<c:url value='/college/subjects.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>
    			&nbsp;&gt;&nbsp;<a href="<c:url value='/college/subject.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;subjectId=${subject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
    			<c:choose>
    				<c:when test="${subject.subjectDescription != null && subject.subjectDescription != ''}" >
        				<c:out value="${fn:substring(subject.subjectDescription,0,initParam.iTitleLength)}"/>
                        <c:out value="(${subject.academicYear.description})"/>
					</c:when>
					<c:otherwise>
						<fmt:message key="jsp.href.new" />
					</c:otherwise>
				</c:choose>
				</a>
                &nbsp;&gt;&nbsp;<a href="<c:url value='/college/examination.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;examinationId=${examination.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                <c:choose>
                    <c:when test="${examination.examinationDescription != null && examination.examinationDescription != ''}" >
                        <c:out value="${fn:substring(examination.examinationDescription,0,initParam.iTitleLength)}"/>
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="jsp.href.new" />
                    </c:otherwise>
                </c:choose>
                </a>
				&nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.test" /> 
			</legend>

            <%--Display error messages --%>
            <form:errors path="testForm" cssClass="errorwide" element="p"/>

		</fieldset>

        <div id="tp1" class="TabbedPanel">
           <!--  <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.edit" /></li>               
            </ul> -->

            <div class="TabbedPanelsContentGroup">   
                    <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion1" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab"><fmt:message key="jsp.general.test" /></div>
                                <div class="AccordionPanelContent">

                                <form:form modelAttribute="testForm" method="post" >

                                    <table>

                    					<!-- TEST CODE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.code" /></td>
                                            <c:choose>
                                                <c:when test="${authorizedToEdit}">
                                                	<td class="required">
                                                	   <form:input path="test.testCode" size="40" />
                                                    </td>
                                                	<td>
                                                        <fmt:message key="jsp.general.message.codegenerated" />
                                                        <form:errors path="test.testCode" cssClass="error"/>
                                                	</td>
                                                </c:when>
                                                <c:otherwise>
                                                    <td>
                                                        <c:out value="${testForm.test.testCode}" />
                                                    </td>
                                                </c:otherwise>
                                            </c:choose>
                                        </tr>

                                        <!-- TEST DESCRIPTION -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.description" /></td>
                                            <c:choose>
                                                <c:when test="${authorizedToEdit}">
                                                	<td class="required">
                                                       <form:input path="test.testDescription" size="40" />
                                                    </td>
                                                	<td>
                                                        <form:errors path="test.testDescription" cssClass="error"/>
                                                    </td>
                                                </c:when>
                                                <c:otherwise>
                                                    <td>
                                                        <c:out value="${testForm.test.testDescription}" />
                                                    </td>
                                                </c:otherwise>
                                            </c:choose>
                                        </tr>

                                        <!-- EXAMINATION TYPE CODE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.examinationtype" /></td>
                                            <c:choose>
                                                <c:when test="${authorizedToEdit}">
                                                	<td class="required">
            	                                        <form:select path="test.examinationTypeCode">
            	                                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
            	                                            <c:forEach var="examinationType" items="${testForm.allExaminationTypes}">
            	                                               <c:choose>
                                                                <c:when test="${examinationType.code != '100' && examinationType.code != '101'}">
                                                                    <form:option value="${examinationType.code}" label="${examinationType.description}" />
<%--            	                                                   <c:choose>
            	                                                       <c:when test="${examinationType.code == status.value}">
            	                                                           <option value="${examinationType.code}" selected="selected"><c:out value="${examinationType.description}"/></option>
            	                                                       </c:when>
            	                                                       <c:otherwise>
            	                                                           <option value="${examinationType.code}"><c:out value="${examinationType.description}"/></option>
            	                                                       </c:otherwise>
            	                                                       </c:choose> --%>
            	                                                 </c:when>
            	                                               </c:choose>
            	                                            </c:forEach>
            	                                        </form:select>
                                                	</td>
                                                	<td>
                                                        <form:errors path="test.examinationTypeCode" cssClass="error"/>
                                            	   </td>
                                                </c:when>
                                                <c:otherwise>
                                                    <td>
                                                        <c:out value="${allExaminationTypesMap[testForm.test.examinationTypeCode].description}" />
                                                    </td>
                                                </c:otherwise>
                                            </c:choose>
                                        </tr>
                                        
                                        <!--  NUMBER OF ATTEMPTS -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.numberofattempts" /></td>
                                            <c:choose>
                                                <c:when test="${authorizedToEdit}">
                                                    <td class="required">
                                                        <form:select path="test.numberOfAttempts">
                                                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                            <c:forEach begin="1" end="5" var="current">
                                                                <form:option value="${current}" label="${current}" />
<%--                                                                    <c:choose>
                                                                        <c:when test="${status.value == current}">
                                                                           <option value="${current}" selected="selected">${current}</option>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <option value="${current}">${current}</option>
                                                                        </c:otherwise>
                                                                    </c:choose> --%>
                                                            </c:forEach>
                                                        </form:select>
                                                    </td> 
                                                    <td>
                                                        <form:errors path="test.numberOfAttempts" cssClass="error"/>
                                                    </td>
                                                </c:when>
                                                <c:otherwise>
                                                    <td>
                                                        <c:out value="${testForm.test.numberOfAttempts}" />
                                                    </td>
                                                </c:otherwise>
                                            </c:choose>
                                        </tr>

                                        <!-- WEIGHING FACTOR -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.weighingfactor" /></td>
                                            <c:choose>
                                                <c:when test="${authorizedToEdit}">
                                                	<td><form:input path="test.weighingFactor" size="3" /> %</td>
                                                	<td>
                                                        <form:errors path="test.weighingFactor" cssClass="error"/>
                                                	</td>
                                                </c:when>
                                                <c:otherwise>
                                                    <td>
                                                        <c:out value="${testForm.test.weighingFactor} %" />
                                                    </td>
                                                </c:otherwise>
                                            </c:choose>
                                        </tr>
                                        
                                        
                                        <!-- TEST DATE -->     
							            <tr>
							        		<td class="label"><fmt:message key="jsp.general.testdate"/></td>
                                            <c:choose>
                                                <c:when test="${authorizedToEdit}">
    								        		<td><form:input path="test.testDate" cssClass="datePicker"/>
<%--        								        		<spring:bind path="test.testDate">
            								        		<input type="text" class="datePicker" name="<c:out value="${status.expression}"/>" value="<c:out value="${status.value}"/>"/>
        								        		</spring:bind> --%>
    								        		</td>
    								        		<td>(dd/MM/yyyy)</td>
                                                </c:when>
                                                <c:otherwise>
                                                    <td>
                                                        <fmt:formatDate value="${testForm.test.testDate}"/>
                                                    </td>
                                                </c:otherwise>
                                            </c:choose>
							        	</tr>                


                                        <!-- BR's PASSING TEST -->
                                        <c:choose>
                                       		<c:when test="${endGradesPerGradeType == 'N'}">
				                                <tr>
		                                            <td class="label"><fmt:message key="jsp.general.brspassing" /></td>
		                                        	<td>
		                                        	<c:choose>
					                                	<c:when test="${authorizedToEdit}">
                                                            <form:input path="test.BRsPassingTest" size="3" maxlength="6"/>
<%-- 	                                                		<input type="text" name="${status.expression}" size="3" maxlength="6" value="<c:out value="${status.value}" />"  /> --%>
	                                               		</c:when>
	                                               		<c:otherwise>
	                                               			<c:out value="${testForm.test.BRsPassingTest}" />
	                                               		</c:otherwise>
		                                            </c:choose>
		                                            &nbsp;&nbsp;<fmt:message key="jsp.general.minimummark" />: <c:out value="${study.minimumMarkSubject}"/>, <fmt:message key="jsp.general.maximummark" />: <c:out value="${study.maximumMarkSubject}"/>
		                                        	</td>
		                                        	<td>
                                                        <form:errors path="test.BRsPassingTest" cssClass="error"/>
                                                    </td>
		                                        </tr>
											</c:when>
										</c:choose>

                                        <!--  ACTIVE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.active" /></td>
                                            <c:choose>
                                                <c:when test="${authorizedToEdit}">
                                                    <td>
                                                        <form:select path="test.active">
                                                            <form:option value="Y"><fmt:message key="jsp.general.yes" /></form:option>
                                                            <form:option value="N"><fmt:message key="jsp.general.no" /></form:option>
                                                        </form:select>
                                                    </td>
                                                    <td>
                                                        <form:errors path="test.active" cssClass="error"/>
                                                    </td>
                                                </c:when>
                                                <c:otherwise>
                                                    <td>
                                                        <fmt:message key="${stringToYesNoMap[testForm.test.active]}"/>
                                                    </td>
                                                </c:otherwise>
                                            </c:choose>
                                        </tr>

                                        <c:if test="${authorizedToEdit}">
                                            <tr><td class="label">&nbsp;</td><td><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td></tr>
                                        </c:if>

    									<c:if test="${testId != 0}">
    
    										<!-- TEST SUPERVISORS -->
    	                                    <tr>
    	                                        <td colspan="2" class="header"><fmt:message key="jsp.general.tests.teachers" /></td>
                                                <sec:authorize access="hasRole('CREATE_TEST_SUPERVISORS')">
        	                                        <td align="right">
        	                                            <a class="button" href="<c:url value='/college/subject/testTeacher4Subject.view?newForm=true&amp;testId=${testId}&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
        	                                        </td>
                                                </sec:authorize>
    	                                    </tr>
    
                                        
    	                                    <tr>
    	                                    	<td colspan="3">
    	                                            <table class="tabledata_large" id="TblData_teachers">
                                                    <tr>
    	                                              	<th><fmt:message key="jsp.general.description" /></th>
    	                                              	<th><fmt:message key="jsp.general.active" /></th>
                                           				<th><fmt:message key="general.classgroup" /></th>
                                                    </tr>
    	                                            <c:forEach var="oneTestTeacher" items="${testForm.test.teachersForTest}">
    	                                                <c:forEach var="oneTeacher" items="${testForm.allTeachers}">
    
    	                                                <c:choose>
    	                                                    <c:when test="${(oneTestTeacher.staffMemberId == oneTeacher.staffMemberId)}">
    	                                                <tr>
    	                                                    <td>
                                                                <b><c:out value="${oneTeacher.firstnamesFull}"/>&nbsp;<c:out value="${oneTeacher.surnameFull}"/></b>
    	                                                    </td>
    	                                                    <td>
    	                                                    	<c:out value="${oneTestTeacher.active}"/>
    	                                                    </td>
    			                                            <td>
    			                                            	<c:forEach var="oneClassgroup" items="${form.allClassgroups}">
    			                                            		<c:if test="${oneClassgroup.id == oneTestTeacher.classgroupId}">
    			                                            			<c:out value="${oneClassgroup.description}"/>
    			                                            		</c:if>
    			                                            	</c:forEach>
    			                                            </td>
    
                                                            <sec:authorize access="hasRole('DELETE_TEST_SUPERVISORS')">
        	                                                    <td align="right">
        	                                                    <a href="<c:url value='/college/testteacher_delete.view?tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;subjectId=${subject.id}&amp;examinationId=${examinationId}&amp;testId=${testId}&amp;from=subject&amp;testTeacherId=${oneTestTeacher.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>" 
        	                                                    onclick="return confirm('<fmt:message key="jsp.teachers.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a></td>
                                                            </sec:authorize>
    	                                                </tr>
    	                                                 </c:when>
    	                                                </c:choose>
    	                                                </c:forEach>   
    	                                            </c:forEach> 
    	                                            </table>
    	                                            <script type="text/javascript">alternate('TblData_teachers',true)</script>
    	                                        </td>
    	                                    </tr>
    	                                    <tr>
    	                                        <td colspan="3">
                                                    <form:errors path="test.teachersForTest" cssClass="error"/>
                                                </td>
    	                                    </tr>
                                        </c:if>

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
        tp1.showPanel(<%=request.getParameter("tab")%>);
    </script>
</div>

<%@ include file="../../footer.jsp"%>

