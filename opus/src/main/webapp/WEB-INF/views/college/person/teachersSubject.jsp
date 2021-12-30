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

<!-- necessary spring binds for organization and navigationSettings regarding form handling through includes -->
<c:set var="organization" value="${teachersSubjectForm.organization}" scope="page" />
<c:set var="navigationSettings" value="${teachersSubjectForm.navigationSettings}" scope="page" />
<c:set var="subjectTeacher" value="${teachersSubjectForm.subjectTeacher}" scope="page" />
<c:set var="staffMember" value="${teachersSubjectForm.staffMember}" scope="page" />

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

    <div id="tabcontent">

    	<form>
    		<fieldset>
    			<legend>
                    <a href="<c:url value='/college/staffmembers.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
	    			<a href="<c:url value='/college/staffmember.view?newForm=true&amp;tab=4&amp;panel=0&amp;staffMemberId=${staffMember.staffMemberId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
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
					&nbsp;>&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.subjects.taught" /> 
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
	                        <div class="AccordionPanelTab"><fmt:message key="jsp.general.subjects.taught" /></div>
	                        <div class="AccordionPanelContent">
	
		                        <form:form name="formdata" modelAttribute="teachersSubjectForm" method="post">
		                        
		                        	<form:errors cssClass="error" />

									<spring:bind path="subjectTeacher.staffMemberId">
										<c:forEach var="error" items="${status.errorMessages}">
											<div class="error">
												<fmt:message key="jsp.general.staffmember" />: ${error}
											</div>
										</c:forEach>
									</spring:bind>

			                        <%@ include file="../../includes/organizationAndNavigationDetail.jsp"%>

		                        	<input type="hidden" name="submitFormObject" id="submitFormObject" value="" />

		                            <table>
                                        <!-- PRIMARY STUDY -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.primarystudy" /></td>
                                            <td class="required">
                                                <form:select path="studyId" onchange="this.form.submit();">
                                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                                    <c:forEach var="oneStudy" items="${teachersSubjectForm.allStudies}">
                                                        <form:option value="${oneStudy.id}">${oneStudy.studyDescription}</form:option>
                                                    </c:forEach>
                                                </form:select>
                                            </td>
                                        </tr>

                                        <!-- ACADEMIC YEAR -->
                                        <tr>
                                            <td class="label"><fmt:message key="jsp.general.academicyear" /></td>
                                            <td class="required">
                                                <form:select path="academicYearId" onchange="this.form.submit();">
                                                    <form:option value="0" disabled="${teachersSubjectForm.academicYearId != 0}"><fmt:message key="jsp.selectbox.choose" /></form:option>
                                                    <c:forEach var="y" items="${teachersSubjectForm.allAcademicYears}">
                                                        <form:option value="${y.id}">${y.description}</form:option>
                                                    </c:forEach>
                                                </form:select>
                                            </td>
                                        </tr>

		                            	<!-- subject -->	
		                                <tr>
		                                    <td width="200" class="label"><fmt:message key="jsp.general.subject" /></td>
		                                    <td class="required">
			                                    <form:select path="subjectTeacher.subjectId" onchange="document.formdata.submit();">
			                                         <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>

			                                         <c:forEach var="subject" items="${teachersSubjectForm.allSubjects}">
			                                         	<c:set var="disabled" value="" scope="page" />

			                                         	<c:forEach var="subjectForStaffMember" items="${allSubjectsForStaffMember}">
			                                                 <c:choose>
			                                                     <c:when test="${(subjectForStaffMember.subjectId == subject.id) }">
			                                                         <c:set var="disabled" value="disabled" scope="page" />
			                                                     </c:when>
			                                                 </c:choose>
			                                             </c:forEach>

			                                             <c:choose>
			                                                 <c:when test="${disabled == ''}">
		                                                     	<c:choose>
			                                                   		<c:when test="${subject.id == subjectTeacher.subjectId}">
			                                                       		<option value="${subject.id}"  selected="selected"/>
			                                                   		</c:when>
			                                                   		<c:otherwise>
			                                                       		<option value="${subject.id}">
			                                                   		</c:otherwise>
			                                               		</c:choose> 
                                                                <c:out value="${subject.subjectCode}"/> <c:out value="${subject.subjectDescription}"/>
			                                                    <c:forEach var="academicYear" items="${allAcademicYears}">
			                                                     	<c:choose>
			                          									<c:when test="${academicYear.id == subject.currentAcademicYearId}">
			                          										(<c:out value="${academicYear.description}"/>)
			                          									</c:when>
			                          								</c:choose>
		                         								</c:forEach>
			                                					</option>
			                                           		</c:when>
			                                       		</c:choose>
			                                         </c:forEach>
		                                     	</form:select>
		                                    </td> 
		                                    <td> 
		                                    	<form:errors path="subjectTeacher.subjectId" cssClass="error" />
		                                    </td>
		                                </tr>

		                                <!-- classgroup -->	
		                                <tr>
		                                   	<td width="200" class="label"><fmt:message key="general.classgroup" /></td>
		                               		<td>
		                               			<form:select path="subjectTeacher.classgroupId" onchange="document.formdata.submit();">
	                                				<c:forEach var="oneClassgroup" items="${teachersSubjectForm.allClassgroups}">
	                                					<c:choose>
	                                						<c:when test="${empty oneClassgroup}">
				                                				<option value="0" ${empty subjectTeacher.classgroupId ? 'selected="selected"' : ''}>
				                                        			<fmt:message key="jsp.selectbox.choose" />
				                      							</option>
	                                						</c:when>
	                                						<c:otherwise>
				                                				<option value="${oneClassgroup.id}" ${oneClassgroup.id == subjectTeacher.classgroupId ? 'selected' : ''}>
				                                        			<c:out value="${oneClassgroup.description}"/>
				                      							</option>
	                                						</c:otherwise>
	                                					</c:choose>
		                                			</c:forEach>
		                            			</form:select>
		                            		</td> 
		                            		<td> 
		                            			<form:errors path="subjectTeacher.classgroupId" cssClass="error" />
		                                    </td>
		                               	</tr>
		                               	
		                             	<tr>
			                             	<td class="label">&nbsp;</td>
		                            		<td>
			                             		<input type="submit" value="<fmt:message key='jsp.button.submit' />" onclick="document.getElementById('submitFormObject').value='true';document.formdata.submit();" />
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

