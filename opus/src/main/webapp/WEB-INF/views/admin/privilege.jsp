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

<%@ include file="../includes/standardincludes.jsp"%>

<c:set var="screentitlekey">jsp.general.privilege</c:set>
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
                    </a>&nbsp;>&nbsp;
                        ${privilegeForm.privilege.code}:
                        ${privilegeForm.privilege.description}
            </legend>
          
     </fieldset>
     
     <form method="get" action="<c:url value='/college/privilegeroles_delete.view'/>" onSubmit="return confirm('<fmt:message key="jsp.general.delete.confirm" />')">
     
        <input type="hidden" name="currentPageNumber" value="${currentPageNumber}"/>
        <input type="hidden" name="privilegeId" value="${privilegeForm.privilege.id}"/> 
     

    <h4 style="display:inline"> <fmt:message key="jsp.general.roles"/></h4>  
    &nbsp;&nbsp;&nbsp;
        
        <input type="submit" value="<fmt:message key='jsp.button.deleteselected'/>" class="button" id="deleteRolesButton" disabled="true"/>
        <a href="<c:url value='/college/privilegeroles?privilegeId=${privilegeForm.privilege.id}&currentPageNumber=${currentPageNumber}'/>" class="button">
            <fmt:message key="jsp.href.add" />
        </a>
    <%@ include file="../includes/pagingHeader.jsp"%>
       <table class="tabledata" id="TblData">
            
            <th style="width:3%">
                <input type="checkbox" name="checker" id="checker" 
                    onclick="javascript:toggleGroup(this.checked,'ids');"
                    onchange="jQuery('#deleteRolesButton').attr('disabled', !this.checked);"
                />
            </th>          
            <th><fmt:message key="jsp.general.role" /></th>
            <th><fmt:message key="jsp.general.active" /></th>
            <th>&nbsp;</th>
            
            <c:forEach var="privilegeRole" items="${privilegeForm.roles}">
            <!-- This variable will be used with lookupCells.jsp file -->
                        <tr>
                        
                        <td style="width:3%">
                        <%-- admin role must not be changed--%>
                            <c:if test="${privilegeRole.role != 'admin'}">
                        
                            <input type="checkbox" id="roleCheckBox${privilegeRole.role}" 
                                    name="ids"  value="${privilegeRole.id}"
                                    onchange="jQuery('#deleteRolesButton').attr('disabled', !anySelected('ids',null));"
                             />
                             </c:if>
                        </td>
                           
                           <td>
                                ${privilegeRole.role}
                           </td>
                           <td style="width:7%;text-align: center">
                            <c:choose>
                                <c:when test="${privilegeRole.active == 'Y'}">
                                    <fmt:message key="jsp.general.yes" />
                                </c:when>
                                <c:otherwise>
                                    <fmt:message key="jsp.general.no" />
                                </c:otherwise>
                            </c:choose>
                           </td>
                           <td style="width:10%;text-align: center">
                        
                        <%-- admin role must not be changed--%>
                            <c:if test="${privilegeRole.role != 'admin'}">                            
                             <a href="<c:url value='/college/privilegeroles_delete.view'/>?ids=${privilegeRole.id}&currentPageNumber=${currentPageNumber}&privilegeId=${privilegeForm.privilege.id}"
                                onclick="return confirm('<fmt:message key="jsp.general.delete.confirm" />')">
                                 <img src="<c:url value='/images/delete.gif' />" 
                                       alt="<fmt:message key="jsp.href.delete" />" 
                                       title="<fmt:message key="jsp.href.delete" />" 
                                 />
                                </a>
                                </c:if>
                           </td>
                        </tr>
            </c:forEach>
        </table>
    </form>

        <script type="text/javascript">alternate('TblData',true)</script>
<fmt:message key="jsp.general.totalnumberof" /> <fmt:message key="jsp.menu.roles" />: ${fn:length(privilegeForm.roles)}&nbsp;

    </div><%--tabcontent --%>
</div><%--tabwrapper --%>

<%@ include file="../footer.jsp"%>