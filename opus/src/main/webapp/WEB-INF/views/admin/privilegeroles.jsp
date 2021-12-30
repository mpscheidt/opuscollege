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

<%@ include file="../header.jsp"%>
<jwr:script src="/bundles/jquerycomp.js" />

<body>

<div id="tabwrapper">

    <%@ include file="../menu.jsp"%>

    
    <div id="tabcontent">
        <fieldset>
            <legend>
                    <a href="<c:url value='/college/privileges.view?currentPageNumber=${currentPageNumber}'/>">
                        <fmt:message key="jsp.general.backtooverview" />
                    </a>&nbsp;>
                    <a href="<c:url value='/college/privilege.view?privilegeId=${privilege.id}&currentPageNumber=${currentPageNumber}'/>">
                        ${privilegeForm.privilege.code}:
                        ${privilege.description}
                    </a>&nbsp;>
                    <fmt:message key="jsp.general.roles"/>
            </legend>
          
     </fieldset>
     
     
     <form:form  method="post">
     
        <input type="hidden" name="currentPageNumber" value="${currentPageNumber}"/>
        <input type="hidden" name="privilegeId" value="${privilege.id}"/>
         <form:hidden path="role"/>
         <form:hidden path="active"/>
         <form:hidden path="privilegeCode"/>              
     

    <h4 style="display:inline"> <fmt:message key="jsp.general.roles"/></h4>  
    &nbsp;&nbsp;&nbsp;
        
        <input type="submit" value="<fmt:message key='jsp.button.addselected'/>" class="button" id="addRolesButton" disabled="true"/>
    <%@ include file="../includes/pagingHeader.jsp"%>
       <table class="tabledata" id="TblData">
            
            <th style="width:3%">
                <input type="checkbox" name="checker" id="checker" 
                    onclick="javascript:toggleGroup(this.checked,'privilegeRoles');"
                    onchange="jQuery('#addRolesButton').attr('disabled', !this.checked);"
                />
            </th>          
            <th><fmt:message key="jsp.general.role" /></th>
            <th><fmt:message key="jsp.general.description" /></th>
            <th><fmt:message key="jsp.general.active" /></th>
            
            <c:forEach var="availableRole" items="${availableRoles}">
            <!-- This variable will be used with lookupCells.jsp file -->
                        <tr>
                        <td style="width:3%">
                            <input type="checkbox" id="roleCheckBox${availableRole.role}" 
                                    name="privilegeRoles"  value="${availableRole.role}"
                                    onchange="jQuery('#addRolesButton').attr('disabled', !anySelected('privilegeRoles',null));"
                             />
                        </td>
                           
                           <td>
                                ${availableRole.role}
                           </td>
                           <td>
                                ${availableRole.roleDescription}
                           </td>
                           <td style="width:7%;text-align: center">
                            <c:choose>
                                <c:when test="${availableRole.active == 'Y'}">
                                    <fmt:message key="jsp.general.yes" />
                                </c:when>
                                <c:otherwise>
                                    <fmt:message key="jsp.general.no" />
                                </c:otherwise>
                            </c:choose>
                           </td>
                        </tr>
            </c:forEach>
        </table>
    </form:form>

        <script type="text/javascript">alternate('TblData',true)</script>
<fmt:message key="jsp.general.totalnumberof" /> <fmt:message key="jsp.menu.roles" />: ${fn:length(availableRoles)}&nbsp;

    </div><%--tabcontent --%>
</div><%--tabwrapper --%>

<%@ include file="../footer.jsp"%>