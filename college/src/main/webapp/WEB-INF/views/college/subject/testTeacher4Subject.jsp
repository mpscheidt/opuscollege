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

    <c:set var="form" value="${testTeacher4SubjectForm}" />
    <c:set var="organization" value="${form.organization}" scope="page" />
    <c:set var="navigationSettings" value="${form.navigationSettings}" scope="page" />
    <c:set var="test" value="${form.test}" scope="page" />
    <c:set var="examination" value="${test.examination}" scope="page" />
    <c:set var="subject" value="${examination.subject}" scope="page" />

    <div id="tabcontent">

		<fieldset>
			<legend>
                <a href="<c:url value='/college/subjects.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>
    			&nbsp;&gt;&nbsp;<a href="<c:url value='/college/subject.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;subjectId=${subject.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
    			<c:choose>
    				<c:when test="${subject.subjectDescription != null && subject.subjectDescription != ''}" >
						<c:out value="${fn:substring(subject.subjectDescription,0,initParam.iTitleLength)}"/>
					</c:when>
					<c:otherwise>
						<fmt:message key="jsp.href.new" />
					</c:otherwise>
				</c:choose>
				</a>
    			<br />&nbsp;&nbsp;&nbsp;&gt;&nbsp;<a href="<c:url value='/college/examination.view?newForm=true&amp;tab=${tab}&amp;panel=${panel}&amp;subjectId=${subject.id}&amp;examinationId=${examination.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
    			<c:choose>
    				<c:when test="${examination.examinationDescription != null && examination.examinationDescription != ''}" >
					  <c:out value="${fn:substring(examination.examinationDescription,0,initParam.iTitleLength)}"/>
					</c:when>
					<c:otherwise>
					  <fmt:message key="jsp.href.new" />
					</c:otherwise>
				</c:choose>
				</a>
                    &nbsp;&gt;&nbsp;<a href="<c:url value='/college/test.view?newForm=true&amp;tab=${tab}&amp;panel=${panel}&amp;subjectId=${subject.id}&amp;examinationId=${examination.id}&amp;testId=${test.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
                    <c:out value="${fn:substring(test.testDescription,0,initParam.iTitleLength)}"/>
                </a>
				&nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.tests.teachers" /> 
			</legend>
		</fieldset>

        <form:form modelAttribute="testTeacher4SubjectForm" method="post">

        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.add" /></li>               
            </ul>
            <div class="TabbedPanelsContentGroup">   
                    <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion1" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab"><fmt:message key="jsp.general.tests.teacher" /></div>
                                <div class="AccordionPanelContent">

                                	<form:errors path="testTeacher" cssClass="error" />

                                    <%@ include file="../../includes/organization.jsp"%> 

                                    <table>
                                    	<!-- TEACHER -->                                                            
                                        <tr>
                                            <td width="200" class="label"><fmt:message key="jsp.general.teacher" /></td>
                                            <td class="required">
                                                <form:select path="testTeacher.staffMemberId" onchange="document.getElementById('submitter').value=this.id;this.form.submit();">>
                                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    <c:forEach var="teacher" items="${form.allTeachers}">
                                                        <form:option value="${teacher.staffMemberId}"><c:out value="${teacher.surnameFull}"/>,&nbsp;<c:out value="${teacher.firstnamesFull}"/></form:option>
                                                    </c:forEach>
                                                </form:select>
                                            </td>
                                            <form:errors path="testTeacher.staffMemberId" cssClass="error" element="td"/>
                                        </tr>

                                        <!--  ACTIVE -->
                                        <tr>
                                            <td width="200" class="label"><fmt:message key="jsp.general.active" /></td>
                                            <td>
                                                <form:select path="testTeacher.active">
                                                    <form:option value="Y"><fmt:message key="jsp.general.yes"/></form:option>
                                                    <form:option value="N"><fmt:message key="jsp.general.no"/></form:option>                    
                                                </form:select>
                                            </td>
                                            <form:errors path="testTeacher.active" cssClass="error" element="td"/>
                                        </tr>

		                                <!-- CLASSGROUP -->
		                                <tr>
		                                   	<td width="200" class="label"><fmt:message key="general.classgroup" /></td>
		                               		<td>
		                               			<form:select path="testTeacher.classgroupId">
		                               				<c:forEach var="oneClassgroup" items="${form.allClassgroups}">
		                               					<c:choose>
		                               						<c:when test="${empty oneClassgroup}">
				                                				<option value="0" ${empty form.testTeacher.classgroupId ? 'selected' : ''}>
				                                        			<fmt:message key="jsp.selectbox.choose" />
				                      							</option>
		                               						</c:when>
		                               						<c:otherwise>
				                                				<option value="${oneClassgroup.id}" ${oneClassgroup.id == form.testTeacher.classgroupId ? 'selected' : ''}>
				                                        			<c:out value="${oneClassgroup.description}"/>
				                      							</option>
		                               						</c:otherwise>
		                               					</c:choose>
		                                			</c:forEach>
		                            			</form:select>
		                            		</td>
		                            		<td>
		                            			<form:errors path="testTeacher.classgroupId" cssClass="error" element="td"/>
	                                       </td>
		                               	</tr>

                                        <tr><td class="label">&nbsp;</td><td><input type="submit" value="<fmt:message key="jsp.button.submit" />" /></td></tr>
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

        </form:form>
    </div>
        
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(<%=request.getParameter("tab")%>);
    </script>
</div>

<%@ include file="../../footer.jsp"%>

