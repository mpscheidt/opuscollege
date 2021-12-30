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

    <c:set var="form" value="${examinationForm}" />

    <c:set var="navigationSettings" value="${form.navigationSettings}" />
    <c:set var="currentPageNumber" value="${navigationSettings.currentPageNumber}" />
    <c:set var="tab" value="${navigationSettings.tab}" />
    <c:set var="panel" value="${navigationSettings.panel}" />

    <c:set var="subjectId"  value="${form.examination.subjectId}" scope="page" />
    <c:set var="examinationId"  value="${form.examination.id}" scope="page" />

    <c:set var="subject"  value="${form.subject}" scope="page" />

    <%-- decide whether to display read-only or allow to edit --%>
    <c:set var="authorizedToEdit" value="${false}"/>
    <sec:authorize access="hasAnyRole('CREATE_EXAMINATIONS','UPDATE_EXAMINATIONS')">
        <c:set var="authorizedToEdit" value="${true}"/>
    </sec:authorize>

    <div id="tabcontent">

		<fieldset>
			<legend>
                <a href="<c:url value='/college/subjects.view?currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
    			<a href="<c:url value='/college/subject.view?newForm=true&amp;tab=${tab}&amp;panel=${panel}&amp;subjectId=${subject.id}&amp;currentPageNumber=${currentPageNumber}'/>">
    			<c:choose>
    				<c:when test="${not empty subject.subjectDescription}" >
        				<c:out value="${fn:substring(subject.subjectDescription,0,initParam.iTitleLength)}"/>
                        <c:out value="(${subject.academicYear.description})"/>
					</c:when>
					<c:otherwise>
						<fmt:message key="jsp.href.new" />
					</c:otherwise>
				</c:choose>
				</a>
				&nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.examination" /> 
			</legend>

            <form:errors path="examinationForm" cssClass="errorwide"  element="p"/>

		</fieldset>

        <div id="tp1" class="TabbedPanel">
           <!--  <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.edit" /></li>               
            </ul> -->

            <div class="TabbedPanelsContentGroup">   
                    <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion1" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab"><fmt:message key="jsp.general.examination" /></div>
                                <div class="AccordionPanelContent">

                                <form:form modelAttribute="examinationForm.examination" method="post">
                              
                                    <table>  

                    					<!-- EXAMINATION CODE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.code" /></td>
                                            <c:choose>
                                                <c:when test="${authorizedToEdit}">
                                                    <spring:bind path="examinationCode">
                                                    	<td class="required">
                                                    		<input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
                                                        </td>
                                                    	<td>
                                                            <fmt:message key="jsp.general.message.codegenerated" />
                                                    		<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                                    	</td>
                                                    </spring:bind>
                                                </c:when>
                                                <c:otherwise>
                                                    <td>
                                                        <c:out value="${form.examination.examinationCode}" />
                                                    </td>
                                                </c:otherwise>
                                            </c:choose>
                                        </tr>

                                        <!-- EXAMINATION DESCRIPTION -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.description" /></td>
                                            <c:choose>
                                                <c:when test="${authorizedToEdit}">
                                                	<spring:bind path="examinationDescription">
                                                    	<td class="required">
                                                        	<input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
                                                    	<td>
                                                        	<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                                    	</td>
                                                    </spring:bind>
                                                </c:when>
                                                <c:otherwise>
                                                    <td>
                                                        <c:out value="${form.examination.examinationDescription}" />
                                                    </td>
                                                </c:otherwise>
                                            </c:choose>
                                        </tr>

                                        <!-- EXAMINATION TYPE CODE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.examinationtype" /></td>
                                            <c:choose>
                                                <c:when test="${authorizedToEdit}">
                                                	<spring:bind path="examinationTypeCode">
                                                    	<td class="required">
                	                                        <select name="${status.expression}">
                	                                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                	                                            <c:forEach var="examinationType" items="${form.allExaminationTypes}">
                	                                               <c:choose>
                	                                                <c:when test="${examinationType.code == status.value}">
                	                                                    <option value="${examinationType.code}" selected="selected"><c:out value="${examinationType.description}"/></option>
                	                                                </c:when>
                	                                                <c:otherwise>
                	                                                    <option value="${examinationType.code}"><c:out value="${examinationType.description}"/></option>
                	                                                </c:otherwise>
                	                                               </c:choose>
                	                                            </c:forEach>
                	                                        </select>
                                                    	</td> 
                                                    	<td>
                                                        	<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                                    	</td>
                                                    </spring:bind>
                                                </c:when>
                                                <c:otherwise>
                                                    <td>
                                                        <c:out value="${form.allExaminationTypesMap[form.examination.examinationTypeCode].description}" />
                                                    </td>
                                                </c:otherwise>
                                            </c:choose>
                                        </tr>
                                        
                                        <!--  NUMBER OF ATTEMPTS -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.numberofattempts" /></td>
                                            <c:choose>
                                                <c:when test="${authorizedToEdit}">
                                                    <spring:bind path="numberOfAttempts">
                                                        <td class="required">
                                                            <select name="${status.expression}">
                                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                                <c:forEach begin="1" end="5" var="current">
                                                                    <c:choose>
                                                                        <c:when test="${status.value == current}">
                                                                           <option value="${current}" selected="selected"><c:out value="${current}"/></option>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <option value="${current}"><c:out value="${current}"/></option>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </select>
                                                        </td> 
                                                        <td>
                                                        	<c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                                        </td>
                                                    </spring:bind>
                                                </c:when>
                                                <c:otherwise>
                                                    <td>
                                                        <c:out value="${form.examination.numberOfAttempts}" />
                                                    </td>
                                                </c:otherwise>
                                            </c:choose>
                                        </tr>

                                        <!-- WEIGHING FACTOR -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.weighingfactor" /></td>
                                            <c:choose>
                                                <c:when test="${authorizedToEdit}">
                                                	<spring:bind path="weighingFactor">
                                                    	<td class="required">
                                                    	   <input type="text" name="${status.expression}" size="3" value="<c:out value="${status.value}" />" /> %</td>
                                                    	<td>
                                                    	   <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                                    	</td>
                                                    </spring:bind>
                                                </c:when>
                                                <c:otherwise>
                                                    <td>
                                                        <c:out value="${form.examination.weighingFactor} %" />
                                                    </td>
                                                </c:otherwise>
                                            </c:choose>
                                        </tr>

                                        <!-- EXAM DATE -->
							            <tr>
							        		<td class="label"><fmt:message key="jsp.general.examdate"/></td>
                                            <c:choose>
                                                <c:when test="${authorizedToEdit}">
    								        		<td>
    								        		<spring:bind path="examinationDate">
    								        		<input type="text" class="datePicker" name="<c:out value="${status.expression}"/>" value="<c:out value="${status.value}"/>"/>
    								        		</spring:bind>
    								        		</td>
    								        		<td>(dd/MM/yyyy)</td>
                                                </c:when>
                                                <c:otherwise>
                                                    <td>
                                                        <fmt:formatDate value="${form.examination.examinationDate}"/>
                                                    </td>
                                                </c:otherwise>
                                            </c:choose>
							        	</tr>                                   

                                        <!-- BR's PASSING EXAMINATION -->
                                       	<c:choose>
                                       		<c:when test="${!form.endGradesPerGradeType}">
		                                        <tr>
		                                            <td class="label"><fmt:message key="jsp.general.brs.passingexamination" /></td>
		                                        	<spring:bind path="BRsPassingExamination">
		                                        	<td>
		                                        	<c:choose>
					                                	<c:when test="${authorizedToEdit}">
	                                                		<input type="text" name="${status.expression}" size="3" maxlength="6" value="<c:out value="${status.value}" />" />
	                                               		</c:when>
	                                               		<c:otherwise>
	                                               			${status.value}
	                                               		</c:otherwise>
                                                	</c:choose>
		                                        	&nbsp;&nbsp;<fmt:message key="jsp.general.minimummark" />: <c:out value="${study.minimumMarkSubject}"/>, <fmt:message key="jsp.general.maximummark" />: <c:out value="${study.maximumMarkSubject}"/>
		                                        	</td>
		                                        	<td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
		                                            </spring:bind>
		                                        </tr>
											</c:when>
										</c:choose>

                                        <!--  ACTIVE -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.active" /></td>
                                            <c:choose>
                                                <c:when test="${authorizedToEdit}">
                                                    <spring:bind path="active">
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
                                                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                                                    </spring:bind>
                                                </c:when>
                                                <c:otherwise>
                                                    <td>
                                                        <fmt:message key="${stringToYesNoMap[form.examination.active]}"/>
                                                    </td>
                                                </c:otherwise>
                                            </c:choose>
                                        </tr>
                                    
                                        <tr>
                                            <td class="label">&nbsp;</td>
                                            <c:choose>
                                                <c:when test="${authorizedToEdit}">
                                                    <td colspan="2"><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td>
                                                </c:when>
                                            </c:choose>
                                        </tr>
                                    </table>

                                    <c:if test="${examinationId != 0}">
                                        <p>&nbsp;</p>
                                        <hr/>
                                        <p>&nbsp;</p>
                                    
										<c:if test="${ not empty showExaminationTeacherError }">       
                                            <p class="errorwide">
                                                <fmt:message key="jsp.error.examinationteacher.delete" />
                                                <fmt:message key="jsp.error.general.delete.linked.${showExaminationTeacherError}" />
                                            </p>
                                        </c:if>

                                        <table class="tabledata2">
    										<!-- EXAMINATION SUPERVISORS -->
    	                                    <tr>
    	                                        <td colspan="2" class="header"><fmt:message key="jsp.general.examination.teachers" /></td>
                                                <sec:authorize access="hasRole('CREATE_EXAMINATION_SUPERVISORS')">
        	                                        <td align="right">
        	                                            <a class="button" href="<c:url value='/college/examinationteacher.view?newForm=true&amp;tab=${tab}&amp;panel=${panel}&amp;from=subject&amp;subjectId=${subjectId}&amp;examinationId=${examinationId}&amp;currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
        	                                        </td>
                                                </sec:authorize>
    	                                    </tr>
                                        </table>

                                        <c:choose>
                                            <c:when test="${not empty form.examination.teachersForExamination}">   
                                                <table class="tabledata2" id="TblData_supervisors">
    		                                        <tr>
    		                                            <th><fmt:message key="jsp.general.description" /></th>
    		                                            <th><fmt:message key="jsp.general.active" /></th>
    		                                            <th><fmt:message key="general.classgroup" /></th>
    	                                            </tr>
		                                            <c:forEach var="oneExaminationTeacher" items="${form.examination.teachersForExamination}">
		                                                <tr>
		                                                    <td>
	                                                            <b><c:out value="${oneExaminationTeacher.staffMember.firstnamesFull}"/>&nbsp;<c:out value="${oneExaminationTeacher.staffMember.surnameFull}"/></b>
		                                                    </td>
		                                                    <td>
                                                                <fmt:message key="${stringToYesNoMap[oneExaminationTeacher.active]}"/>
		                                                    </td>
				                                            <td>
				                                            	<c:forEach var="oneClassgroup" items="${form.allClassgroups}">
				                                            		<c:if test="${oneClassgroup.id == oneExaminationTeacher.classgroupId}">
				                                            			<c:out value="${oneClassgroup.description}"/>
				                                            		</c:if>
				                                            	</c:forEach>
				                                            </td>

                                                            <sec:authorize access="hasRole('DELETE_EXAMINATION_SUPERVISORS')">
                                                                <td align="right">
        		                                                    <a href="<c:url value='/college/examinationteacher_delete.view?tab=${tab}&amp;panel=${panel}&amp;subjectId=${subjectId}&amp;examinationId=${examinationId}&amp;from=subject&amp;examinationTeacherId=${oneExaminationTeacher.id}&amp;currentPageNumber=${currentPageNumber}'/>" 
        		                                                    onclick="return confirm('<fmt:message key="jsp.teachers.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
                                                                </td>
                                                            </sec:authorize>
		                                                </tr>
	                                                </c:forEach>   
	                                            </table>
                                               <script type="text/javascript">alternate('TblData_supervisors',true)</script>
                                           </c:when>
                                           <c:otherwise>
                                               <p class="error">
                                                   <fmt:message key="jsp.error.examinationteacher.nonechosen" />
                                               </p>
                                           </c:otherwise>
                                        </c:choose>

                                        <p>&nbsp;</p>
                                        <hr/>
                                        <p>&nbsp;</p>
                                        
	                                    <!-- TESTS -->

                                        <c:if test="${form.percentageTotal != 0 && form.percentageTotal != 100 }">
                                           <p class="errorwide">
                                            <fmt:message key="jsp.error.percentagetotal" />
                                           </p>
                                        </c:if>

                                        <sec:authorize access="hasRole('CREATE_TESTS')">
                                            <table class="tabledata2">
        	                                    <tr>
        	                                        <td colspan="2" class="header"><fmt:message key="jsp.general.tests" /></td>
        	                                        <td align="right">
                                                    &nbsp;
                                                    <c:if test="${form.percentageTotal < 100 }">
        	                                            <a class="button" href="<c:url value='/college/test.view?newForm=true&amp;tab=${tab}&amp;panel=${panel}&amp;from=subject&amp;subjectId=${subjectId}&amp;examinationId=${examinationId}&amp;currentPageNumber=${currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                                    </c:if>
        	                                        </td>
        	                                    </tr>
                                            </table>
                                        </sec:authorize>

	                                    <c:choose>
	                                        <c:when test="${not empty form.examination.tests}" >
                                                <table class="tabledata2" id="TblData_tests">
                                                    <tr>
			                                            <th><fmt:message key="jsp.general.code" /></th>
			                                            <th><fmt:message key="jsp.general.description" /></th>
			                                            <th><fmt:message key="jsp.general.weighingfactor" /></th> 
                                                        <th><fmt:message key="jsp.general.tests.teachers"/></th>
                                                        <th><fmt:message key="jsp.general.testdate"/></th>
			                                            <th><fmt:message key="jsp.general.active" /></th>
                                                        <th><fmt:message key="jsp.general.numberofattempts" /></th>
	                                                    <th>&nbsp;</th>
                                                    </tr>      
		                                            <c:forEach var="test" items="${form.examination.tests}">
		                                                <tr>
		                                                    <td>
		                                                       <c:out value="${test.testCode}"/>
		                                                    </td>
		                                                    <td>
		                                                       <a href="<c:url value='/college/test.view?newForm=true&amp;tab=${tab}&amp;panel=${panel}&amp;testId=${test.id}&amp;examinationId=${examinationId}&amp;subjectId=${subject.id}&amp;currentPageNumber=${currentPageNumber}'/>">
		                                                            <c:out value="${test.testDescription}"/>
		                                                       </a>
		                                                    </td>
		                                                    <td>
		                                                       <c:out value="${test.weighingFactor} %"/>
		                                                    </td>
                                                            <td>
                                                                <c:forEach var="testTeacher" items="${test.teachersForTest}" varStatus="loopStatus">
                                                                    <c:out value="${testTeacher.staffMember.firstnamesFull} ${testTeacher.staffMember.surnameFull}"/><c:if test="${!loopStatus.last}">, </c:if>
                                                                </c:forEach>
                                                            </td>
                                                            <td>
                                                                <fmt:formatDate value="${test.testDate}"/>
                                                            </td>
		                                                    <td width="20">
                                                                <fmt:message key="${stringToYesNoMap[test.active]}"/>
                                                            </td>
                                                            <td>
                                                                <c:out value="${test.numberOfAttempts}"/>
                                                            </td>
                                                            <c:if test="${authorizedToEdit}">
    		                                                    <td class="buttonsCell">
    			                                                    <a class="imageLink" href="<c:url value='/college/test.view?newForm=true&amp;tab=${tab}&amp;panel=${panel}&amp;testId=${test.id}&amp;examinationId=${examinationId}&amp;subjectId=${subject.id}&amp;currentPageNumber=${currentPageNumber}'/>">
    			                                                        <img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                                                    <sec:authorize access="hasRole('DELETE_TESTS')">
                                                                        <a class="imageLinkPaddingLeft" href="<c:url value='/college/test_delete.view?tab=${tab}&amp;panel=${panel}&amp;subjectId=${subject.id}&amp;examinationId=${examinationId}&amp;testId=${test.id}&amp;currentPageNumber=${currentPageNumber}'/>" 
                                                                            onclick="return confirm('<fmt:message key="jsp.test.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                                                        </a>
                                                                    </sec:authorize>
                                                                </td>
                                                            </c:if>
		                                                </tr>
		                                            </c:forEach>
                                                </table>
                                                <script type="text/javascript">alternate('TblData_tests',true)</script>
		                                    </c:when>
		                                </c:choose>
                                    </c:if>

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

