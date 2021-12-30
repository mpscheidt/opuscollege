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
 * Copyright (c) 2008 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
 @Description: This script is the content for the account information tab wich contains the bank account details
 @Author Stelio Macumbe 16 of May 2008
--%>


<form name="accountdata" method="POST">
    <input type="hidden" name="tab_accountdata" value="${accordion}" /> 
    <input type="hidden" name="panel_accountdata" value="0" />
    <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />

		<table>
		
            <!-- The bank -->    
            <spring:bind path="command.bankId">
            <tr>
                <td class="label"><fmt:message key="scholarship.bankname" /></td>
    
                <td>
                    <select id="${status.expression}" name="${status.expression}" value="${status.value}" >
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="bank" items="${allBanks}" >
                            <c:choose>
                                <c:when test="${status.value == bank.id }"> 
                                    <option value="${bank.id}" selected="selected">
                                </c:when>
                                <c:otherwise>
                                    <option value="${bank.id}">
                                </c:otherwise>
                            </c:choose>
                            ${bank.code} - ${bank.name}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>
                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                </td>
            </tr>
            </spring:bind>
            
			<!-- The bank account number  -->		
			<spring:bind path="command.account">
            <tr>
                <td class="label"><fmt:message key="scholarship.accountnumber" /></td>
                <td>
                    <input type="text" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
				</td>
                <td>
                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                </td>
				
			</tr>
		   </spring:bind>    
		
            <!-- Is the account activated -->       
			<spring:bind path="command.accountActivated">
			<tr>
				<td class="label"><fmt:message key="scholarship.accountactive" /></td>
	
				<td>
					<select id="${status.expression}" name="${status.expression}" value="${status.value}" ">
					<c:choose>
					   <c:when test="${status.value == 'true'}">
					       <option value="true" selected="selected"><fmt:message key="jsp.general.yes" /></option>
                           <option value="false"><fmt:message key="jsp.general.no" /></option>
					   </c:when>
					   <c:otherwise>
                           <option value="true"><fmt:message key="jsp.general.yes" /></option>
                           <option value="false" selected="selected"><fmt:message key="jsp.general.no" /></option>
					   </c:otherwise>
					</c:choose>
					</select>
				</td>
                <td>
                    <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                </td>
			</tr>
            </spring:bind>    

            <tr>
                <td colspan=2>&nbsp;</td>
                <td>
                    <input type="button" name="submitaccountdata" value="<fmt:message key="jsp.button.submit" />" onclick="document.accountdata.submit();" />
                </td>
            </tr>
        </table>

</form>

