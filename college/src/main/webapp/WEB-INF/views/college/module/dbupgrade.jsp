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
 * author : Markus Pscheidt
--%>


<%@ include file="../../includes/standardincludes.jsp"%>

<c:set var="screentitlekey">jsp.module.dbupgrade.init.header</c:set>
<%@ include file="../../header.jsp"%>

<%-- 
checkall functionality copied from 
http://www.dynamicdrive.com/forums/showthread.php?t=53191 
--%>
<script type="text/javascript">
function checkall(el){
    var ip = document.getElementsByTagName('input'), i = ip.length - 1;
    for (i; i > -1; --i){
        if(ip[i].type && ip[i].type.toLowerCase() === 'checkbox'){
            ip[i].checked = el.checked;
        }
    }
}
</script>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>
        
    <div id="tabcontent">
    
        <fieldset>
            <legend><fmt:message key="jsp.module.dbupgrade.init.header"/></legend>

            <p align="left">
                <fmt:message key="jsp.module.dbupgrade.introduction"/>
            </p>
            <hr/>

            <sec:authorize access="hasRole('ADMINISTER_SYSTEM')">

            <form:form commandName="dbUpgradeModel" name="runUpgrade" method="post" action="dbupgrade.view">

            <table class="tabledata" id="TblData" style="width:98%">
                <tr>
                    <td>Run</td>
                    <td>Order key</td>
                    <td>Module</td>
                    <td>Version</td>
                    <td>Upgrade command</td>
                </tr>
                <c:forEach var="upgrade" items="${dbUpgradeModel.allEligibleUpgrades}" varStatus="status">
                    <tr>
                        <td>
                            <form:checkbox path="selected" checked="checked" value="${status.index}"/>
                        </td>
                        <td>${upgrade.order}</td>
                        <td>${upgrade.module.module}</td>
                        <td>${upgrade.version}</td>
                        <td>${upgrade}</td>
                    </tr>
                </c:forEach>
            </table>
            <script type="text/javascript">alternate('TblData',true)</script>

            <label>Check All: <input type="checkbox" checked="checked" onclick="checkall(this);"></label><br>

            <table>
                <tr>
                    <td width="200"></td>
                    <td align="left">
                        <input type="submit" value="<fmt:message key='jsp.module.dbupgrade.run'/>"/>
                    </td>
                </tr>
            </table>
            </form:form>
            
            </sec:authorize> 

                
            <c:choose>
                <c:when test="${(not empty showError)}">             
                    <p align="left" class="error">
                        <fmt:message key="jsp.error.subject.delete" />
                        <fmt:message key="jsp.error.general.delete.linked.${ showError }" />
                    </p>
                </c:when>
            </c:choose>
            
        </fieldset>
        
        
    </div>
  
</div>

<%@ include file="../../footer.jsp"%>
