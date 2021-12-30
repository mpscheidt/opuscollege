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

<body>

<div id="tabwrapper">

    <%@ include file="../menu.jsp"%>

	
    <div id="tabcontent">

<fieldset>
    <legend>
        <fmt:message key="jsp.logmailerrors.header" />
    </legend>
    <form name="searchform" id="searchform" method="get">
    <input type="hidden" name="reportFormat" value="${reportFormat}">
    <input type="hidden" name="reportName" value="${reportName}">
        <table>
            <tr>
            <td class="label"><fmt:message key="jsp.general.search" /></td>
                <td width="700" align="left">
                   <img src="<c:url value='/images/trans.gif' />" width="10"/>            
                    <input type="text" name="searchValue" id="searchValue"  value="${searchValue}"/>&nbsp;
                    <!-- input type="submit" name="search" value="search" /-->
                   <img src="<c:url value='/images/search.gif'/>" 
                   alt="<fmt:message key='jsp.general.search'/>"
                   title="<fmt:message key='jsp.general.search'/>"
                   style="cursor:pointer; cursor:hand;"
                    onclick="document.searchform.submit()"/>
                </td>
            <td>
            
            </td>
            </tr>
        </table>

    </form>
    
    <form name="reportForm" id="reportForm" method="get" target="_blank" action="<c:url value='/college/reports.view'/>">
    
 		<table style="padding:20px 0px 10px  0px" >
                    <tr>
                     <td class="label"><fmt:message key="jsp.general.report"/></td>
                    <td>
                    <select name="reportName">                    
                    	<option value="LogMailErrors"z>
                    		<fmt:message key="jsp.general.list"/>
                    	</option>
                    	<option value="LogMailError" <c:if test="${reportName == 'LogMailError'}"> selected="selected"</c:if>>
                    		<fmt:message key="jsp.general.details"/>
                    	</option>
                    
                    </select>
                    </td>
                    </tr>
                    <tr>
                    <td style="vertical-align:bottom;" width="100">
                        <fmt:message key="jsp.reports.OutPutReport"/>
                    </td>
                        <%@ include file="../includes/ReportFormatsScreenPdfExcel.jsp"%>
                    </tr>
				<tr >
                 <td colspan="10" align="center" style="padding:20px 0px 10px 0px">
                     <button id="reportButton">
                         <fmt:message key='jsp.general.create.report' />
                     </button>
                    </td>
                    </tr>
            </table>


 </fieldset>
        
		<c:set var="allEntities" value="${logMailErrors}" scope="page" />
		<c:set var="redirView" value="logmailerrors" scope="page" />
		<c:set var="entityNumber" value="0" scope="page" />

        <%@ include file="../includes/pagingHeader.jsp"%>

        <table class="tabledata" id="TblData">
        	
            <th><fmt:message key="jsp.general.id" /></th>
            <th><fmt:message key="report.logmailerrors.subject" /></th>
            <th><fmt:message key="report.logmailerrors.sender" /></th>
            <th><fmt:message key="report.logmailerrors.recipients" /></th>      
            <th><fmt:message key="report.general.date" /></th>
            <th><fmt:message key="report.logmailerrors.errormessage" /></th>
            <th>&nbsp;</th>
            <c:forEach var="logMailError" items="${logMailErrors}">
				<c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
            	<c:choose>
            		<c:when test="${(entityNumber < (currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
		                <tr>
		                
		                <td>${logMailError.id}</td>
		                <td>${logMailError.subject}</td>
		                <td>${logMailError.sender}</td>
		                <td>${logMailError.recipients}</td>
		                <td style="text-align: center"><fmt:formatDate value="${logMailError.date}" dateStyle="SHORT"/></td>
		                <td>
		                <c:choose>
                          <%-- show only the 30 first characters, so it doesn't take to much space on screen --%>
                          <c:when test="${fn:length(logMailError.errorMessage) > 30}">
                          	${fn:substring(fn:escapeXml(logMailError.errorMessage), 0, 30)}...
                           </c:when>
                           	<c:otherwise>
                           		${fn:escapeXml(logMailError.errorMessage)}                      			
                            </c:otherwise>
                          </c:choose>
		                </td>
		                
		                <td style="text-align:center;text-decoration: none">
		                <a href="<c:url value='/college/reports.view'/>?reportName=LogMailError&reportFormat=pdf&where.id=${logMailError.id}"
		                target="_blank"
		                title="<fmt:message key='jsp.href.title.createdetailsexscel'/>"
		                style="text-align:center;text-decoration: none"
		                >
		              PDF
                    </a>
                    |
                    <a href="<c:url value='/college/reports.view'/>?reportName=LogMailError&reportFormat=xls&where.id=${logMailError.id}"
                    target="_blank"
                    title="<fmt:message key='jsp.href.title.createdetailspdf'/>"
                    style="text-align:center;text-decoration: none"
                    >                    
                    Excel
                    </a>
		                </td>
		                </tr>
	                </c:when>
	            </c:choose>
            </c:forEach>
        </table>
        </form>
		<script type="text/javascript">alternate('TblData',true)</script>

        <%@ include file="../includes/pagingFooter.jsp"%>

        <br /><br />
    </div>
    
</div>

<%@ include file="../footer.jsp"%>
