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

<c:set var="screentitlekey">jsp.menu.appconfig</c:set>
<%@ include file="../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../menu.jsp"%>

    
    <div id="tabcontent">
        
        <fieldset>
            <legend>
                <fmt:message key="jsp.menu.appconfig" />
            </legend>
                
                <p align="left">
                    <form name="organizationandnavigation" method="post" action="${appConfigForm.navigationSettings.action}">
                        <%@ include file="../includes/searchValue.jsp"%>
                    </form>   
                </p>  
         </fieldset>      
            
        <c:set var="allEntities" value="${appConfigForm.mapAppConfig}" scope="page" />
        <c:set var="redirView" value="appconfig" scope="page" />
        <c:set var="entityNumber" value="0" scope="page" />

            <%-- no calculations needed for the paging header, just the total entity count --%>
        <c:set var="countAllEntities" value="${fn:length(appConfigForm.mapAppConfig)}" scope="page" />
        <%@ include file="../includes/pagingHeaderInterface.jsp"%>           


        <table class="tabledata" id="TblData">
            <tr>
                <th><fmt:message key="jsp.general.name" /></th>
                <th><fmt:message key="jsp.general.branch" /></th>
                <th><fmt:message key="jsp.general.value" /></th>
                <th><fmt:message key="jsp.general.startdate" /></th>
                <th><fmt:message key="jsp.general.enddate" /></th>
                <th>&nbsp;</th>
            </tr>
            <c:forEach var="appConfig" items="${appConfigForm.mapAppConfig}" varStatus="rowIndex">
                <tr>
                    <td>
                    ${appConfig.appconfigattributename}
                    </td>
                    <td>
                    ${appConfig.branchid}
                    </td>
                    <td>
                    ${appConfig.appconfigattributevalue}
                    </td>
                    <td>
                    ${appConfig.startdate}
                    </td>
                    <td>
                    ${appConfig.enddate}
                    </td>
                    
                    <td class="buttonsCell" style="width:10%;text-align: center;">
                        <a href="<c:url value='/college/appconfigattribute.view?tab=0&amp;panel=0&amp;appConfigAttributeId=${appConfig.id}&amp;currentPageNumber=${currentPageNumber}&amp;newForm=true'/>">
                             <img src="<c:url value='/images/edit.gif' />" 
                                alt="<fmt:message key="jsp.href.edit" />" 
                                title="<fmt:message key="jsp.href.edit" />"
                              />
                         </a>                                
                    </td>
                </tr>
            </c:forEach>
        </table>
        <script type="text/javascript">alternate('TblData',true)</script>

        <%@ include file="../includes/pagingFooterNew.jsp"%>

        <br /><br />
            
            
    </div><!-- tabcontent -->    
</div><!-- tabwrapper -->

<%@ include file="../footer.jsp"%>