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

    <c:set var="organization" value="${opusUserRoleForm.organization}" scope="page" />

    <div id="tabcontent">

        <form>
            
            <fieldset>
                <legend>
                    <c:choose>
                        <c:when test="${not empty opusUserRoleForm.staffMember}">
                            <a href="<c:url value='/college/staffmembers.view?currentPageNumber=0'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
                            <a href="<c:url value='/college/staffmember.view?tab=1&amp;panel=2&amp;staffMemberId=${opusUserRoleForm.staffMember.staffMemberId}&amp;currentPageNumber=0'/>">
                            <c:choose>
                                <c:when test="${opusUserRoleForm.staffMember.surnameFull != null && opusUserRoleForm.staffMember.surnameFull != ''}" >
                                    <c:set var="staffMemberName" value="${opusUserRoleForm.staffMember.surnameFull}, ${opusUserRoleForm.staffMember.firstnamesFull}" scope="page" />
                                        <c:out value="${fn:substring(staffMemberName,0,initParam.iTitleLength)}"/>
                                </c:when>
                            </c:choose>
                        </c:when>
                        <c:when test="${not empty opusUserRoleForm.student}">
                            <a href="<c:url value='/college/students.view?currentPageNumber=0'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
                            <a href="<c:url value='/college/student-opususer.view?tab=1&amp;panel=2&amp;studentId=${opusUserRoleForm.student.studentId}&amp;currentPageNumber=0'/>">
                            <c:choose>
                                <c:when test="${opusUserRoleForm.student.surnameFull != null && opusUserRoleForm.student.surnameFull != ''}" >
                                    <c:set var="studentName" value="${opusUserRoleForm.student.surnameFull}, ${opusUserRoleForm.student.firstnamesFull}" scope="page" />
                                        <c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}"/>
                                </c:when>
                            </c:choose>
                        </c:when>
                    </c:choose>
                    </a>
                    &nbsp;>&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.userrole" />
                </legend>
            </fieldset>
        </form>

        <div id="tp1" class="TabbedPanel">
            <ul class="TabbedPanelsTabGroup">
                <li class="TabbedPanelsTab"><fmt:message key="jsp.general.userrole" /></li>               
            </ul>

            <div class="TabbedPanelsContentGroup">   
                    <div class="TabbedPanelsContent">
                        <div class="Accordion" id="Accordion0" tabindex="0">
                            <div class="AccordionPanel">
                                <div class="AccordionPanelTab"><fmt:message key="jsp.general.userrole" /></div>
                                <div class="AccordionPanelContent">
        
        
        <form:form method="post" id="mainForm" name="mainForm" commandName="opusUserRoleForm">
        	
        	<input type="hidden" name="task" id="task" value="submitFormObject"/>
            <form:hidden path="stId" /> 
            <form:hidden path="userType" />
            <form:hidden path="opusUserRole.id"/>

        <table>
        
            <tr>
                <td class="label"><fmt:message key="jsp.general.institution"/></td>
                <td>
                   <sec:authorize access="hasRole('READ_INSTITUTIONS')">
<!--                     <select name="institutionId"  -->
<!--                      onchange="this.form.task.value='updateFormObject'; this.form.submit(); "> -->
<%--                         <option value="0"><fmt:message key="jsp.selectbox.choose" /></option> --%>
<%--                             <c:forEach var="university" items="${allInstitutions}"> --%>
<%--                                 <c:choose> --%>
<%--                                     <c:when test="${(institutionId == null && university.id == institution.id) || (institutionId != null && institutionId != 0 && university.id == institutionId) }">  --%>
<%--                                         <option value="${university.id}" selected="selected"><c:out value="${university.institutionDescription}"/></option> --%>
<%--                                     </c:when> --%>
<%--                                     <c:otherwise> --%>
<%--                                         <option value="${university.id}"><c:out value="${university.institutionDescription}"/></option> --%>
<%--                                     </c:otherwise> --%>
<%--                                 </c:choose> --%>
<%--                             </c:forEach> --%>
<!--                         </select> -->
                            <form:select path="organization.institutionId" onchange="this.form.task.value='institution'; this.form.submit(); ">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <c:forEach var="institution" items="${organization.allInstitutions}">
                                    <form:option value="${institution.id}"><c:out value="${institution.institutionDescription}"/></form:option>
                                </c:forEach>
                            </form:select>
                    </sec:authorize>
                </td>
            </tr>

            <tr>
                <td class="label"><fmt:message key="jsp.general.branch" />
                </td>
                <td>
                    <sec:authorize access="hasRole('READ_BRANCHES')">
<%--                         <select name="branchId" id="branchId" --%>
<!--                           onchange="this.form.task.value='updateFormObject'; this.form.submit(); "> -->
<%--                             <option value="0"><fmt:message key="jsp.selectbox.choose" /></option> --%>
<%--                             <c:forEach var="oneBranch" items="${allBranches}"> --%>
<%--                                 <c:choose> --%>
<%--                                     <c:when test="${(institutionId == null) }"> --%>
<%--                                         <c:choose> --%>
<%--                                             <c:when --%>
<%--                                                 test="${(branchId == null && oneBranch.id == branch.id) || (branchId != null && oneBranch.id == branchId) }"> --%>
<%--                                                 <option value="${oneBranch.id}" selected="selected"><c:out value="${oneBranch.branchDescription}"/></option> --%>
<%--                                             </c:when> --%>
<%--                                             <c:otherwise> --%>
<%--                                                 <option value="${oneBranch.id}"><c:out value="${oneBranch.branchDescription}"/></option> --%>
<%--                                             </c:otherwise> --%>
<%--                                         </c:choose> --%>
<%--                                     </c:when> --%>
<%--                                     <c:otherwise> --%>
<%--                                         <c:choose> --%>
<%--                                             <c:when test="${(institutionId == oneBranch.institutionId) }"> --%>
<%--                                                 <c:choose> --%>
<%--                                                     <c:when --%>
<%--                                                         test="${(branchId == null && oneBranch.id == branch.id)  --%>
<%--                                     || (branchId != null && oneBranch.id == branchId) }"> --%>
<%--                                                         <option value="${oneBranch.id}" selected="selected"><c:out value="${oneBranch.branchDescription}"/></option> --%>
<%--                                                     </c:when> --%>
<%--                                                     <c:otherwise> --%>
<%--                                                         <option value="${oneBranch.id}"><c:out value="${oneBranch.branchDescription}"/></option> --%>
<%--                                                     </c:otherwise> --%>
<%--                                                 </c:choose> --%>
<%--                                             </c:when> --%>
<%--                                         </c:choose> --%>
<%--                                     </c:otherwise> --%>
<%--                                 </c:choose> --%>
<%--                             </c:forEach> --%>
<%--                         </select> --%>
                        <form:select path="organization.branchId" id="branchId" onchange="this.form.task.value='branch'; this.form.submit(); ">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="branch" items="${organization.allBranches}">
                                    <form:option value="${branch.id}">
                                        <c:out value="${branch.branchDescription}"/>
                                    </form:option>
                            </c:forEach>
                        </form:select>
                    </sec:authorize>
                    <sec:authorize access="!hasRole('READ_BRANCHES')">
                        <c:out value="${roleBranch.branchDescription}"/>
                    </sec:authorize>
                </td>
            </tr>

        	<tr>
            	<td class="label"><fmt:message key="jsp.general.organizationalunit"/></td>
            	<td class="required">
                 	<form:select path="organization.organizationalUnitId" id="organizationalUnitId">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="organizationalUnit" items="${organization.allOrganizationalUnits}">
                            <form:option value="${organizationalUnit.id}">
                            	<c:out value="${organizationalUnit.organizationalUnitDescription}"/>
                            </form:option>
                        </c:forEach>
                    </form:select>
            	</td>       
				<form:errors path="opusUserRole.organizationalUnitId" cssClass="error" element="td"/>
        	</tr>
        	<tr>
            	<td class="label"><fmt:message key="jsp.general.role"/></td>
            
            	<td class="required">
                	<form:select path="opusUserRole.role">
                		<form:option value=""><fmt:message key="jsp.selectbox.choose" /></form:option>
                    	
                    	<c:forEach var="oneRole" items="${opusUserRoleForm.allRoles}">
                    		<form:option value="${oneRole.role}">
                         		<c:out value="${oneRole.roleDescription} (${oneRole.role})"/>
                         	</form:option>
                    	</c:forEach>
                	</form:select>
             	</td>
            	<form:errors path="opusUserRole.role" cssClass="error" element="td"/>
        	</tr>
        	<tr>
            	<td class="label"><fmt:message key="jsp.general.validfrom"/></td>
            	<td class="required">            
                	<form:input  path="opusUserRole.validFrom" cssClass="datePicker"/>                  
            	</td>
            	<form:errors path="opusUserRole.validFrom" cssClass="error" element="td"/>
        	</tr>
        	<tr>
            	<td class="label"><fmt:message key="jsp.general.validthrough" /></td>
            	<td>
                	<form:input  path="opusUserRole.validThrough" cssClass="datePicker"/>                  
            	</td>
            	<form:errors path="opusUserRole.validThrough" cssClass="error" element="td"/>
        	</tr>
        	<tr>
        		<td class="label"><fmt:message key="jsp.general.default" /></td>
        		<td>
        		<%--user must always a default role
        			if user only has one it must be the default role
        		 --%>
        			<c:choose>
        				<c:when test="${(fn:length(opusUserRoleForm.userRoles) == 1) && (opusUserRoleForm.opusUserRole.id != 0)}">
							<form:checkbox path="isPreferredOrganizationalUnit" readOnly="true" checked="true"/>
						</c:when>
						<c:otherwise>
							<form:checkbox path="isPreferredOrganizationalUnit"	/>
						</c:otherwise>
					</c:choose>
        		</td>
        	</tr>
        	<tr>
        		<td align="right" colspan="2" style="padding:15px">
        			<input type="submit" value="<fmt:message key="jsp.button.submit"/>"/>
        		</td>
        	</tr>
        </table>        
        
        </form:form>

                       </div> <!-- AccordionPanelContent -->
                            </div>  <!-- AccordionPanel -->
                        </div>   <!-- Accordion1 -->     
    
                        <script type="text/javascript">
                            var Accordion0 = new Spry.Widget.Accordion("Accordion0",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });
                            
                        </script>
                    </div>     
            </div>
        </div>
    </div>
        
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        //tp1.showPanel(<%//=request.getParameter("tab")%>);
        tp1.showPanel(0);
    </script>
</div>

<%@ include file="../../footer.jsp"%>

