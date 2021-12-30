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

<%@ include file="../header.jsp"%>

<%@ include file="../includes/javascriptfunctions.jsp"%>

<body>
<div id="tabwrapper">

    <%@ include file="../menu.jsp"%>
    
    <div id="tabcontent">
	
	<fieldset>
        <legend><fmt:message key="jsp.menu.financialrequests" /></legend>
        
            <c:choose>        
                <c:when test="${ not empty showError }">       
                   <p align="left" class="error">
                        ${showError }
                   </p>
                </c:when>
            </c:choose>
    </fieldset>
       
        <form name="financialRequestsForm" id="financialRequestsForm" method="POST" >
        <input type="hidden" name="submitPressed" id="submitPressed" value="false" />
        <input type="hidden" name="formRequest" id="formRequest" value="true" />
        <c:set var="allEntities" value="${allFinancialRequests}" scope="page" />
        <c:set var="redirView" value="financialRequests" scope="page" />
        <c:set var="params" value="statusCodeSelection=${statusCodeSelection}&errorCodeSelection=${errorCodeSelection}&fromRecivedDate=${fromRecivedDate}&untilRecivedDate=${untilRecivedDate}&studentId=${studentId}<%--&tuitionFee75ProcentPaid=${tuitionFee75ProcentPaid}--%>" scope="page" />
        <c:set var="entityNumber" value="0" scope="page" />
                        
        <%@ include file="../includes/pagingHeader.jsp"%>
        <p align="left">
                <%@ include file="../includes/selectionRequestsFilter.jsp"%>
        </p>  

        <table class="tabledata" id="TblData" cellspacing="5">

            <c:set var="lastAcademicYear" value="0" scope="page" />             
            <c:forEach var="financialRequest" items="${allFinancialRequests}">
                <c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
                <c:choose>
                    <c:when test="${(entityNumber < (currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
                       <c:if test="${financialRequest.academicYear != lastAcademicYear}">
                            <tr>
                                <th>
                                    ${financialRequest.academicYear}                                      
                                </th>
                             </tr>
				            <tr>
                                <th>&nbsp;</th> 
 				                <th><fmt:message key="jsp.finance.requestid" /></th>
                                <th><fmt:message key="jsp.finance.type" /></th>
                                <th><fmt:message key="jsp.finance.financialrequestid" /></th>
				                <th><fmt:message key="jsp.finance.status" /></th>
                                <th><fmt:message key="jsp.finance.requeststring" /></th>
				                <th><fmt:message key="jsp.finance.timestampreceived" /></th>
                                <th><fmt:message key="jsp.finance.version" /></th>				                
				                <th><fmt:message key="jsp.finance.timestampmodified" /></th>
				                <th><fmt:message key="jsp.finance.errorcode" /></th>
				                <th><fmt:message key="jsp.finance.processedtofintrans" /></th>                                                                                                                
                                <th><fmt:message key="jsp.finance.errorreported" /></th> 
				                <th></th>
				            </tr>
                            <c:set var="lastAcademicYear" value="${financialRequest.academicYear}" scope="page" />				            
                        </c:if>
	                    <tr>
                       <td>
                            <input  type="checkbox" name="financialRequestId" checked="checked" value="${financialRequest.financialRequestId}" />
                        </td>
                        <td>
                           ${financialRequest.requestId}
                        </td>
                        <td>
                           ${financialRequest.requestTypeMessage}
                        </td>
	                    <td>
	                       ${financialRequest.financialRequestId}
	                    </a>
	                    </td>
	                    <td>
                           ${financialRequest.statusMessage}
                        </td>
                        <td>
                            <a href="#" onclick="openPopupWindow('${financialRequest.requestString}');" title="${financialRequest.requestString}"><c:out value="${fn:substring(financialRequest.requestString,0,initParam.iTitleLength)}" /></a>
                        </td>                        
                        <td>
                           ${financialRequest.timestampReceived}
                        </td>
                        <td>
                           ${financialRequest.requestVersion}
                        </td>
                        <td>
                           ${financialRequest.timestampModified}
                        </td> 
                        <td>
                           ${financialRequest.errorMessage}
                        </td>                   
                         <td>
                           ${financialRequest.processedToFinanceTransaction}
                        </td>
                        <td>
                           ${financialRequest.errorReportedToFinancialSystem}
                        </td>                                                                                                   
	                    </tr>
                    </c:when>
                </c:choose>
            </c:forEach>
             <th>
               <td><label for="checker"><fmt:message key="jsp.general.selectall" /></label></td>
                <td><input name="checker" 
                       id="checker" 
                       checked="checked" 
                       onclick="javascript:checkAll('financialRequestId');" 
                       type="checkbox"></td>
                 <td>
                 <td><label for="progress"><fmt:message key="jsp.finance.progresstotransaction" /></label></td>   
                 <td>
                       <input  type="checkbox" name="progressToTransaction" checked="checked" />
                 </td>
                 <td>&nbsp;</td>
                 <td><label for="errorreported"><fmt:message key="jsp.finance.errorreported" /></label></td>   
                 <td>
                       <input  type="checkbox" name="errorReported" checked="checked" />
                 </td>                                                      
           </th>          
          </table>
                   <tr>
                       <td class="label">&nbsp;</td>
                       <td colspan="3"><input type="button" name="submitbutton" value="<fmt:message key="jsp.button.submit" />" onclick="document.getElementById('submitPressed').value='true';document.financialRequestsForm.submit();" /></td>
         <!--          <td colspan=3><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td>
          -->        </tr>           
            <script type="text/javascript">alternate('TblData',true)</script>
           </form>
           
            <%@ include file="../includes/pagingFooter.jsp"%>
    
        <br /><br />
       
        </div><!-- End of tabcontent-->        
    </div><!-- tabwrapper -->
  <%@ include file="../footer.jsp"%>
