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
                <a href="<c:url value='/college/roles.view'/>">
                    <fmt:message key="jsp.general.backtooverview" />
                </a>&nbsp;>&nbsp;
                <a href="<c:url value='/college/role.view?roleName=${rolePrivilegesForm.role.role}'/>">
                    ${rolePrivilegesForm.role.role}
                </a>&nbsp;>&nbsp;
                <fmt:message key="jsp.general.privileges"/> - <fmt:message key="jsp.general.add"/>
                
        </legend>
    </fieldset>

    <form:form modelAttribute="rolePrivilegesForm" method="post">
        <fieldset id="copyPrivilegesForm">
            <form:label path="copyPrivileges"><fmt:message key="jsp.general.copyprivilegesfrom"/></form:label>
<%--             <label for="copyPrivilegesCheckBox"><fmt:message key="jsp.general.copyprivilegesfrom"/></label> --%>
<%--               <input type="checkbox" name="copyPrivileges" value="true" id="copyPrivilegesCheckBox" --%>
            <form:checkbox path="copyPrivileges" onclick="
                            jQuery('input,select', '#copyPrivilegesForm').not('#copyPrivilegesCheckBox').attr('disabled',!this.checked);
                            jQuery('input', '#privilegesForm').not('#addPrivilegesButton').attr({disabled:this.checked});
                            jQuery('#addPrivilegesButton').attr('disabled',(jQuery('#checker').attr('disabled') || !anySelected('privilegesCodes')));
                          "
              />
            <br />

            <form:select path="sourceRole">
                <c:forEach var="availableRole" items="${rolePrivilegesForm.availableRoles}" >
                    <form:option value="${availableRole.role}" label="${availableRole.role}"></form:option>
                </c:forEach>
            </form:select>
<%--            <select name="sourceRole" disabled="disabled">
                <c:forEach items="${rolePrivilegesForm.availableRoles}" var="availableRole">
                    <option>${availableRole.role}</option>
                </c:forEach>
            </select> --%>

            <br/>
            <input type="submit" value="<fmt:message key='jsp.general.copy'/>" disabled="disabled"/>
        
        </fieldset>

		<div id="privilegesForm">
            <c:set var="allEntities" value="${privilegesNotInRole}" scope="page" />
            <c:set var="redirView" value="privileges" scope="page" />
            <c:set var="entityNumber" value="0" scope="page" />
    
            <input type="submit" value="<fmt:message key='jsp.button.addselected'/>" 
                    id="addPrivilegesButton" disabled="true">
        
        
            <%-- Header with no navigational buttons--%>
            <div id="abc">&nbsp;</div>
            <table class="tabledata" id="TblData">
                
                <th style="width:5%">
                    <input type="checkbox" name="checker" 
                            id="checker" onclick="javascript:toggleGroup('privilegesCodes',this.checked);"
    			onchange="jQuery('#addPrivilegesButton').attr('disabled', !this.checked || !anySelected('privilegesCodes',null));"
                            />
                </th>
                <th><fmt:message key="jsp.general.code" /></th>
                <th><fmt:message key="jsp.general.description" /></th>
                <th style="width:7%"><fmt:message key="jsp.general.active" /></th>
                
                <c:forEach var="privilege" items="${rolePrivilegesForm.privilegesNotInRole}">
                
                    <tr>
                        <td style="width:7%">
                            <input type="checkbox" id="privilegeCheckBox${privilege_id}" 
                                   name="privilegesCodes"  value="${privilege.code}"
                                   onchange="jQuery('#addPrivilegesButton').attr('disabled', !anySelected('privilegesCodes',null));"
                                   />
                        </td>
                        <td>
                            <a href="<c:url value='/college/privilege.view?privilegeId=${privilege.id}'/>" title="<fmt:message key='jsp.general.viewdetails'/>">
                                ${privilege.code}
                            </a>
                        </td>
                        <td>
                            ${privilege.description}
                        </td>
                        <td style="text-align: center">
                            ${privilege.active}
                        </td>
                    </tr>
                        
                </c:forEach>
            </table>
        </div>
    </form:form>

    <script type="text/javascript">alternate('TblData',true)</script>
    <%@ include file="../includes/footerWithNoPaging.jsp"%>

    <br /><br />
</div><%-- tabcontent --%>
</div><%-- tabwrapper --%>

<%@ include file="../footer.jsp"%>
