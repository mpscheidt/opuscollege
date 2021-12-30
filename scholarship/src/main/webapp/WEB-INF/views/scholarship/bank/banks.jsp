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

The Original Code is Opus-College scholarship module code.

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
 @author Monique in het Veld - September 2008
--%>

<%@ include file="../../header.jsp"%>

<%@ include file="../../includes/javascriptfunctions.jsp"%>

<body>
<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>
    
    <div id="tabcontent">
	
	<fieldset>
        <legend><fmt:message key="jsp.menu.banks" /></legend>
        
            <c:choose>        
                <c:when test="${ not empty showBanksError }">       
                   <p align="left" class="error">
                        ${showBanksError }
                   </p>
                </c:when>
            </c:choose>
        
    </fieldset>

        <c:set var="allEntities" value="${allBanks}" scope="page" />
        <c:set var="redirView" value="banks" scope="page" />
        <c:set var="entityNumber" value="0" scope="page" />
                        
        <%@ include file="../../includes/pagingHeader.jsp"%>

        <table class="tabledata" id="TblData" cellspacing="5">
            <tr>
                <th><fmt:message key="jsp.general.code" /></th> 
                <th><fmt:message key="jsp.general.name" /></th>
                <th><fmt:message key="jsp.general.active" /></th>
                <th></th>
            </tr>
            <c:forEach var="bank" items="${allBanks}">
                <c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
                <c:choose>
                    <c:when test="${(entityNumber < (currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
	                    <tr>
	                    <td>
	                    <a href="<c:url value='/scholarship/bank.view?bankId=${bank.id}&currentPageNumber=${currentPageNumber}'/>">
	                    ${bank.code}
	                    </a>
	                    </td>
	                    <td>
	                    ${bank.name}
	                    </td>
	                    <td>
	                    ${bank.active}
	                    </td>
	                    <td class="buttonsCell">
		                    <a href="<c:url value='/scholarship/bank.view?bankId=${bank.id}&currentPageNumber=${currentPageNumber}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
		                    &nbsp;&nbsp;<a href="<c:url value='/scholarship/bank_delete.view?bankId=${bank.id}&currentPageNumber=${currentPageNumber}'/>"
		                    onclick="return confirm('<fmt:message key="jsp.bank.delete.confirm" />')"><img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" /></a>
	                    </td>
	                    </tr>
                    </c:when>
                </c:choose>
            </c:forEach>
           </table>
            <script type="text/javascript">alternate('TblData',true)</script>

            <%@ include file="../../includes/pagingFooter.jsp"%>
    
        <br /><br />
       
        </div><!-- End of tabcontent-->        
    </div><!-- tabwrapper -->
    
<%@ include file="../../footer.jsp"%>
