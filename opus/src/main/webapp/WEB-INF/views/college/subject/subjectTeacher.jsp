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

    <spring:bind path="subjectTeacherForm.subjectTeacher">
        <c:set var="subjectTeacher" value="${status.value}" scope="page" />
    </spring:bind>

    <spring:bind path="subjectTeacherForm.organization">
        <c:set var="organization" value="${status.value}" scope="page" />
    </spring:bind>

    <spring:bind path="subjectTeacherForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>

    <spring:bind path="subjectTeacherForm.subject">
        <c:set var="subject" value="${status.value}" scope="page" />
    </spring:bind>


    <div id="tabcontent">

    	<form>
    		<fieldset>
    			<legend>
                    <a href="<c:url value='/college/subjects.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;&gt;
	    			<a href="<c:url value='/college/subject.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;subjectId=${subject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
	    			<c:choose>
	    				<c:when test="${subject.subjectDescription != null && subject.subjectDescription != ''}" >
							<c:out value="${fn:substring(subject.subjectDescription,0,initParam.iTitleLength)}"/>
						</c:when>
						<c:otherwise>
							<fmt:message key="jsp.href.new" />
						</c:otherwise>
					</c:choose>
					</a>
					&nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.subjects.taught" /> 
				</legend>
			</fieldset>
		</form>

        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab">add</li>               
            </ul>

            <div class="TabbedPanelsContentGroup">   
                    <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion1" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab"><fmt:message key="jsp.subject.subjectteacher" /></div>
                                <div class="AccordionPanelContent">
                                
                                <form name="formdata" method="post">
                                    <input type="hidden" name="submitFormObject" id="submitFormObject" value="" />
                                    
                                    <form:errors path="subjectTeacherForm.subjectTeacher" cssClass="error" />

                                    <%@ include file="../../includes/organizationAndNavigationDetail.jsp"%> 

                                    <table>
                                    	<!-- TEACHER -->
                                        <tr>
                                            <spring:bind path="subjectTeacherForm.subjectTeacher.staffMemberId">
                                            <td width="200" class="label"><fmt:message key="jsp.general.teacher" /></td>
                                            <td class="required">

                                            <select name="${status.expression}" onchange="document.formdata.submit();">
                                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                <c:forEach var="teacher" items="${subjectTeacherForm.allUnboundTeachers}">
													<option value="${teacher.staffMemberId}" ${teacher.staffMemberId == status.value ? 'selected="selected"' : ''}>
														<c:out value="${teacher.surnameFull}"/>,&nbsp;<c:out value="${teacher.firstnamesFull}"/>
													</option>
                                                </c:forEach>
                                            </select>
                                            </td> 
                                            <td> <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span>
                                                 </c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>

                                        <!--  ACTIVE -->
                                        <tr>
                                            <spring:bind path="subjectTeacherForm.subjectTeacher.active">
                                            <td width="200" class="label"><fmt:message key="jsp.general.active" /></td>
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
                                            <td>
                                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">
                                                ${error}</span></c:forEach>
                                            </td>
                                            </spring:bind>
                                        </tr>

		                                <!-- CLASSGROUP -->
		                                <tr>
		                                   	<td width="200" class="label"><fmt:message key="general.classgroup" /></td>
		                                   	<spring:bind path="subjectTeacherForm.subjectTeacher.classgroupId">
		                               		<td>
		                               			<select id="${status.expression}" name="${status.expression}">
		                               				<c:forEach var="oneClassgroup" items="${subjectTeacherForm.allClassgroups}">
		                               					<c:choose>
		                               						<c:when test="${empty oneClassgroup}">
				                                				<option value="0" ${empty subjectTeacherForm.subjectTeacher.classgroupId ? 'selected="selected"' : ''}>
				                                        			<fmt:message key="jsp.selectbox.choose" />
				                      							</option>
		                               						</c:when>
		                               						<c:otherwise>
				                                				<option value="${oneClassgroup.id}" ${oneClassgroup.id == subjectTeacherForm.subjectTeacher.classgroupId ? 'selected="selected"' : ''}>
				                                        			<c:out value="${oneClassgroup.description}"/>
				                      							</option>
		                               						</c:otherwise>
		                               					</c:choose>
		                                			</c:forEach>
		                            			</select>
		                            		</td>
		                            		<td>
		                            			<c:forEach var="error" items="${status.errorMessages}">
		                            				<span class="error">${error}</span>
	                                            </c:forEach>
	                                       </td>
	                                       </spring:bind>
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

