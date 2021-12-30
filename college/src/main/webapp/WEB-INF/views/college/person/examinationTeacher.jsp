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
    
    <%-- decide whether to display read-only or allow to edit --%>
    <c:set var="authorizedToEdit" value="${false}"/>
    <sec:authorize access="hasAnyRole('CREATE_STAFFMEMBERS','UPDATE_STAFFMEMBERS')">
        <c:set var="authorizedToEdit" value="${true}"/>
    </sec:authorize>
    
    <spring:bind path="examinationTeacherForm.examination">
        <c:set var="examination"  value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="examinationTeacherForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="examinationTeacherForm.organization">
        <c:set var="organization" value="${status.value}" scope="page" />
    </spring:bind>
    
    <spring:bind path="examinationTeacherForm.staffMember">
        <c:set var="staffMember" value="${status.value}" scope="page" />
    </spring:bind>
    
    <div id="tabcontent">
    	<form>
    		<fieldset>
    			<legend>
                    <a href="<c:url value='/college/staffmembers.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
	    			<a href="<c:url value='/college/staffmember.view?newForm=true&amp;tab=5&amp;panel=0&amp;staffMemberId=${staffMember.staffMemberId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
	    			<c:choose>
	    				<c:when test="${staffMember.surnameFull != null && staffMember.surnameFull != ''}" >
        					<c:set var="staffMemberName" value="${staffMember.surnameFull}, ${staffMember.firstnamesFull}" scope="page" />
        					<c:out value="${fn:substring(staffMemberName,0,initParam.iTitleLength)}"/>
						</c:when>
						<c:otherwise>
							<fmt:message key="jsp.href.new" />
						</c:otherwise>
					</c:choose>
					</a>
					&nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.examinations.taught" /> 
				</legend>
			</fieldset>
		</form>

        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.examinations.taught" /></li>               
            </ul>
            <div class="TabbedPanelsContentGroup">   
                    <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion1" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab"><fmt:message key="jsp.general.examinations.taught" /></div>
                                <div class="AccordionPanelContent">
                                <form name="formdata" method="post">
                                    <input type="hidden" name="submitFormObject" id="submitFormObject" value="" />

                                    <form:errors path="examinationTeacherForm.examinationTeacher" cssClass="error" />

	                                <%@ include file="../../includes/organizationAndNavigationDetail.jsp"%> 

	            	                <table>
	            	                	<!-- study -->
	            	                    <tr>
	            	                        <td width="200"><fmt:message key="jsp.general.study" /></td>
	                                        <spring:bind path="examinationTeacherForm.studyId">
	            	                        <td>
	            	                        <select id="${status.expression}" name="${status.expression}" onchange="document.getElementById('subjectId').value='0';document.formdata.submit();">
	            	                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
	            	                            <c:forEach var="oneStudy" items="${examinationTeacherForm.allStudies}">
	            	                                <c:choose>
	            	    	                            <c:when test="${(status.value == oneStudy.id)  }"> 
	            	        	                            <option value="${oneStudy.id}" selected="selected"><c:out value="${oneStudy.studyDescription}"/></option>
	            	                                    </c:when>
	            	                                    <c:otherwise>
	            	             	                       <option value="${oneStudy.id}"><c:out value="${oneStudy.studyDescription}"/></option>
	            	                                    </c:otherwise>
	            	                                </c:choose>
	            	                            </c:forEach>
	            	                        </select>
	            	                        </td>
	                                        </spring:bind>
	            	                        <td></td>
	            	                   </tr>
	            	                </table>

	                                <table>
	                                	<!-- subject -->
	                                    <tr>
	                                        <td width="200"><fmt:message key="jsp.general.subject" />
	                                        </td>
	                                        <spring:bind path="examinationTeacherForm.subjectId">
	                                        <td>
	                                        <select id="${status.expression}" name="${status.expression}" onchange="document.formdata.submit();">
	                                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
	                                            <c:forEach var="oneSubject" items="${examinationTeacherForm.allSubjects}">
	                                                <c:choose>
	                                                    <c:when test="${(status.value == oneSubject.id)  }"> 
	                                                        <option value="${oneSubject.id}" selected="selected"><c:out value="${oneSubject.subjectDescription}"/>
	                                                    </c:when>
	                                                    <c:otherwise>
	                                                       <option value="${oneSubject.id}"><c:out value="${oneSubject.subjectDescription}"/>
	                                                    </c:otherwise>
	                                                </c:choose>  
	                                                <c:forEach var="academicYear" items="${examinationTeacherForm.allAcademicYears}">
	                                                    <c:choose>
	                                                        <c:when test="${academicYear.id == oneSubject.currentAcademicYearId}">
	                                                            (<c:out value="${academicYear.description}"/>)
	                                                        </c:when>
	                                                    </c:choose>
	                                                </c:forEach>
	                                                </option>      
	                                            </c:forEach>
	                                        </select>
	                                        </td>
	                                        </spring:bind>
	                                        <td></td>
	                                   </tr>
	                                </table>
	                                    
	                                <table>
	                                	<!-- examination -->
	                                    <tr>
	                                        <td class="label"><fmt:message key="jsp.general.examination" /></td>
	                                        <spring:bind path="examinationTeacherForm.examinationTeacher.examinationId">
	                                        <td class="required">
	                                        <select id="${status.expression}" name="${status.expression}" onchange="document.formdata.submit();">
	                                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
	                                            <c:forEach var="examination" items="${examinationTeacherForm.allExaminations}">
                                                    <c:set var="examinationText">${examination.examinationCode} - ${examination.examinationDescription}</c:set>
	                                                <c:choose>
	                                                    <c:when test="${examination.id == status.value}">
	                                                        <option value="${examination.id}"  selected="selected"><c:out value="${examinationText}"/></option>
	                                                    </c:when>
	                                                    <c:otherwise>
	                                                        <option value="${examination.id}"><c:out value="${examinationText}"/></option>
	                                                    </c:otherwise>
	                                                </c:choose> 
	                                            </c:forEach>
	                                        </select>
	                                        </td> 
	                                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
	                                        </spring:bind>
	                                    </tr>
	                                    
		                                <!-- classgroup -->
		                                <tr>
		                                   	<td width="200" class="label"><fmt:message key="general.classgroup" /></td>
		                                   	<spring:bind path="examinationTeacherForm.examinationTeacher.classgroupId">
		                               		<td>
		                               			<select id="${status.expression}" name="${status.expression}">
	                                				<c:forEach var="oneClassgroup" items="${examinationTeacherForm.allClassgroups}">
	                                					<c:choose>
	                                						<c:when test="${empty oneClassgroup}">
				                                				<option value="0" ${empty examinationTeacherForm.examinationTeacher.classgroupId ? 'selected="selected"' : ''}>
				                                        			<fmt:message key="jsp.selectbox.choose" />
				                      							</option>
	                                						</c:when>
	                                						<c:otherwise>
				                                				<option value="${oneClassgroup.id}" ${oneClassgroup.id == examinationTeacherForm.examinationTeacher.classgroupId ? 'selected="selected"' : ''}>
				                                        			<c:out value="${oneClassgroup.description}"/>
				                      							</option>
	                                						</c:otherwise>
	                                					</c:choose>
		                                			</c:forEach>
		                            			</select>
		                            		</td> 
		                            		<td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
	                                        </spring:bind>
		                               	</tr>
	                                    
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

