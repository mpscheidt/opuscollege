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

<%@ include file="../../header.jsp"%>

<%@ include file="../../includes/javascriptfunctions.jsp"%>

<body>
<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>
    
    <div id="tabcontent">
	
	<fieldset>
        <legend><fmt:message key="jsp.menu.financialtransactions" /></legend>
            <c:choose>        
                <c:when test="${ not empty showError }">       
                   <p align="left" class="error">
                        ${showError }
                   </p>
                </c:when>
            </c:choose>
    </fieldset>
    
        <form name="financialTransactionsForm" id="financialTransactionsForm" method="POST" >
         <c:set var="allEntities" value="${allFinancialTransactions}" scope="page" />
        <c:set var="redirView" value="studentFinancialTransactions" scope="page" />
        <c:set var="params" value="statusCodeSelection=${statusCodeSelection}&studentId=${studentId}&errorCodeSelection=${errorCodeSelection}&fromRecivedDate=${fromRecivedDate}&untilRecivedDate=${untilRecivedDate}&studentId=${studentId}&tuitionFee75ProcentPaid=${tuitionFee75ProcentPaid}" scope="page" />
        <c:set var="entityNumber" value="0" scope="page" />
                        
        <%@ include file="../../includes/pagingHeader.jsp"%>

        <table class="tabledata" id="TblData" cellspacing="5">

            <c:set var="lastAcademicYearId" value="0" scope="page" />             
            <c:forEach var="financialTransaction" items="${allFinancialTransactions}">
                <c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
                <c:choose>
                    <c:when test="${(entityNumber < (currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
                        <c:if test="${financialTranaction.academicYearId != lastAcademicYearId}">
	                        <tr>
	                            <th>
	                                 <c:forEach var="academicYear" items="${allAcademicYears}">
	                                     <c:choose>
	                                         <c:when test="${academicYear.id == financialTransaction.academicYearId}">
	                                             &nbsp;(${academicYear.description})
	                                         </c:when>
	                                     </c:choose>
	                                 </c:forEach>                                        
	                            </th>
	                            <c:if test="${lastAcademicYearId == 0}">
	                               <th>${studentName}</th>
	                               <th>${NRC}</th>
	                            </c:if>   
		                    </tr>
				            <tr>
                                <th>&nbsp;</th> 
				                <th><fmt:message key="jsp.finance.financialrequestid" /></th> 
				                <th><fmt:message key="jsp.finance.type" /></th>
				                <th><fmt:message key="jsp.finance.requestid" /></th>
				                <th><fmt:message key="jsp.finance.status" /></th>
				                <th><fmt:message key="jsp.finance.timestamp" /></th>
				                <th><fmt:message key="jsp.finance.amount" /></th>
		    	                <th><fmt:message key="jsp.finance.errorcode" /></th>
				                <th><fmt:message key="jsp.finance.processedtosb" /></th>                                                                                                                
				                <th></th>
				            </tr>
	                    </c:if>
                        <c:set var="lastAcademicYearId" value="${financialRequest.academicYearId}" scope="page" />
                      <tr>
                       <td>
                            <input  type="checkbox" name="financialTransactionId" checked="checked" value="${financialTransaction.financialRequestId}" />
                        </td>
	                    <td>
	                       ${financialTransaction.financialRequestId}
	                    </td>
	                    <td>
	                       ${financialTransaction.transactionTypeMessage}
	                    </td>
	                    <td>
	                       ${financialTransaction.requestId}
	                    </td>
                        <td>
                           ${financialTransaction.statusMessage}
                        </td>
                        <td>
                           ${financialTransaction.timestampProcessed}
                        </td>
                        <td>
                           ${financialTransaction.amount}
                        </td>
                        <td>
                           ${financialTransaction.errorMessage}
                        </td>
                        <td>
                           ${financialTransaction.processedToStudentbalance}
                        </td>                                                                                                   
	                    </tr>
                    </c:when>
                </c:choose>
            </c:forEach>
            <tr>
               <td><label for="checker"><fmt:message key="jsp.general.selectall" /></label></td>
                <td><input name="checker" 
                       id="checker" 
                       checked="checked" 
                       onclick="javascript:checkAll('financialTransactionId');" 
                       type="checkbox"></td>
                 <td>&nbsp;</td>
                 <td><label for="progress"><fmt:message key="jsp.finance.progresstostudentbalance" /></label></td>   
                 <td>
                       <input  type="checkbox" name="progressToStudentBalance" checked="checked" />
                 </td>
           </tr>              
           </table>
           <tr>
                  <td class="label">&nbsp;</td>
                  <td colspan=3><input type="submit" name="submit" value="<fmt:message key="jsp.button.submit" />" /></td>
           </tr>           
            <script type="text/javascript">alternate('TblData',true)</script>
            </form>
            <%@ include file="../../includes/pagingFooter.jsp"%>
    
        <br /><br />
       
        </div><!-- End of tabcontent-->        
    </div><!-- tabwrapper -->
    
<%@ include file="../../footer.jsp"%>
