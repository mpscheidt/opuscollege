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

<%@ include file="../header.jsp"%>
<jwr:script src="/bundles/jquerycomp.js" />

<body>

<div id="tabwrapper">

    <%@ include file="../menu.jsp"%>

    
    <div id="tabcontent">
        <fieldset>
            <legend>
                    <a href="<c:url value='/college/roles.view?currentPageNumber=${currentPageNumber}'/>">
                        <fmt:message key="jsp.general.backtooverview" />
                    </a>&nbsp;>&nbsp;
                <c:choose>
                    <c:when test="${command.id != 0}">
                        ${command.role} (${command.roleDescription})
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="jsp.href.new" />
                    </c:otherwise>
                </c:choose>
            </legend>
            
           <form:form method="post"> 
            <table style="padding: 10px">
            <form:hidden path="id"/>
            <form:hidden path="lang"/>
            <form:errors cssStyle="color:red;font-weight:bold;background-color:#FFF;border:1px solid red;" path="*"/>
            <tr>
                <td class="label"><fmt:message key="jsp.general.role" /></td>
                <td >
                    <%--Do not allow edition of role names --%>
                    <c:choose>
                        <c:when test="${command.id != 0}">
                            <form:input path="role" size="40" disabled="true" cssClass="disabled"/>     
                        </c:when>
                        <c:otherwise>
                        <form:input path="role" size="40"/>
                        </c:otherwise>
                    </c:choose>
                </td>
                <form:errors path="role" cssClass="error" element="td" />
             </tr>
            <tr>
                 <td class="label"><fmt:message key="jsp.general.description" /></td>
                 <td ><form:input path="roleDescription" size="40" /></td>
            </tr>
            <tr>
                 <td class="label"><fmt:message key="jsp.general.level" /></td>
                 <td>
                    <form:select path="level">
                        <%--only allow user to add roles equal or below his category --%>
                        <c:forEach begin="${loggedInRole.level + 1}" end="20" var="lvl">
                                    <form:option value="${lvl}"/>
                        </c:forEach>
                    </form:select>                  
                 </td>
            </tr>
                        <tr>
                 <td class="label"><fmt:message key="jsp.general.active" /></td>
                 <td>
                    <form:select path="active">
                        <form:option value="Y" label="Y"/>
                        <form:option value="N" label="N"/>
                    </form:select>                  
                 </td>
            </tr>
      
      <tr>
        <td align="center" colspan="2" style="padding-top:15px">
            <input type="submit" value="<fmt:message key='jsp.button.submit'/>"/>
        </td>
      </tr>
    </table>
    </form:form>
     <spring:hasBindErrors name="command">  
                     <c:forEach items="${status.errorMessages}" var="errorMessage">  
                         <li>  
                             <c:out value="${errorMessage}" />  
                             <br />  
                         </li>  
                     </c:forEach>  
                 </spring:hasBindErrors> 
          
     </fieldset>
    
     <c:choose>
        <c:when test="${command.id != 0}">
     <form method="post" action="<c:url value='/college/roleprivileges_delete.view'/>" onSubmit="return confirm('<fmt:message key="jsp.general.delete.confirm" />')">
     
        <input type="hidden" name="roleName" value="${command.role}"/>
        <input type="hidden" name="currentPageNumber" value="${currentPageNumber}"/>
     

    <h4 style="display:inline"> <fmt:message key="jsp.privileges.header"/></h4>  
    &nbsp;&nbsp;&nbsp;
        
        <input type="submit" value="<fmt:message key='jsp.button.deleteselected'/>" class="button" id="deletePrivilegesButton" disabled="true"/>
        
        <input type="button" value="<fmt:message key="jsp.href.add" />" onclick="window.location='<c:url value='/college/roleprivileges.view?roleName=${command.role}&currentPageNumber=${currentPageNumber}'/>'"/>
    <%@ include file="../includes/pagingHeader.jsp"%>
       <table class="tabledata" id="TblData">
            
            <th style="width:3%">
                <input type="checkbox" name="checker" id="checker" 
                    onclick="javascript:toggleGroup('privilegesCodes',this.checked);"
                    onchange="jQuery('#deletePrivilegesButton').attr('disabled', !this.checked);"
                />
                
            </th>
            <th><fmt:message key="jsp.general.code" /></th>
            <th><fmt:message key="jsp.general.description" /></th>
            <th><fmt:message key="jsp.general.active" /></th>
            <th>&nbsp;</th>

            <c:forEach var="rolePrivilege" items="${rolePrivileges}">
            <!-- This variable will be used with lookupCells.jsp file -->
                <tr <c:if test="${rolePrivilege.active != 'Y'}">class="inactiveRow"</c:if>>
                    <td style="width:3%">
                        <input type="checkbox" id="privilegeCheckBox${rolePrivilege_id}" 
                                name="privilegesCodes"  value="${rolePrivilege.privilegeCode}"
                                onchange="jQuery('#deletePrivilegesButton').attr('disabled', !anySelected('privilegesCodes',null));"
                         />
                    </td>
                    <td>
                        <a href="<c:url value='/college/privilege.view?privilegeId=${rolePrivilege.privilegeId}'/>">
                            ${rolePrivilege.privilegeCode}
                           </a>
                    </td>
                    <td>
                        ${rolePrivilege.privilegeDescription}
                    </td>
                    <td style="width:7%;text-align: center">
                        <c:choose>
                            <c:when test="${rolePrivilege.active == 'Y'}">
                                <fmt:message key="jsp.general.yes" />
                            </c:when>
                            <c:otherwise>
                                <fmt:message key="jsp.general.no" />
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td style="width:10%;text-align: center">
                    
                        <a href="<c:url value='/college/roleprivileges_delete.view'/>?roleName=${command.role}&privilegesCodes=${rolePrivilege.privilegeCode}&currentPageNumber=${currentPageNumber}"
                        onclick="return confirm('<fmt:message key="jsp.general.delete.confirm" />')">
                            <img src="<c:url value='/images/delete.gif' />" 
                               alt="<fmt:message key="jsp.href.delete" />" 
                               title="<fmt:message key="jsp.href.delete" />" 
                            />
                        </a>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </form>

        <script type="text/javascript">alternate('TblData',true)</script>
<fmt:message key="jsp.general.totalnumberof" /> <fmt:message key="jsp.menu.privileges" />: ${fn:length(rolePrivileges)}&nbsp;
    </c:when>
</c:choose><%-- test="${command.id != 0}" --%>

    </div><%--tabcontent --%>
</div><%--tabwrapper --%>

<%@ include file="../footer.jsp"%>