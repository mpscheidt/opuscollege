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
                <a href="<c:url value='/college/appconfig.view?currentPageNumber=${overviewPageNumber}'/>">
                    <fmt:message key="jsp.general.backtooverview" /> </a> &nbsp; > &nbsp;
                    ${appConfigAttributeForm.appConfigAttribute.appConfigAttributeName}
            </legend>
        </fieldset>      
        

    <form name="formdata" method="post" >       
        <input type="hidden" name="submitFormObject" id="submitFormObject" value="" />  
    <table>
        <tr>
            <td class="label">
                <fmt:message key="jsp.general.name"/>
            </td>
            <td>
                <spring:bind path="appConfigAttributeForm.appConfigAttribute.appConfigAttributeName">
                    ${status.value}
                </spring:bind>
            </td>
        </tr>
        <tr>
            <td class="label">
                <fmt:message key="jsp.general.branch"/>
            </td>
            <td>
                <spring:bind path="appConfigAttributeForm.appConfigAttribute.branchId">
                    ${status.value}
                </spring:bind>
            </td>
        </tr>
        <tr>
            <td class="label">
                <fmt:message key="jsp.general.value"/>
            </td>           
            <td class="required">
                <spring:bind path="appConfigAttributeForm.appConfigAttribute.appConfigAttributeValue">
                    <input name="${status.expression}" value="${status.value}"/>
                </spring:bind>
            </td>
        </tr>
        <tr>
            <td class="label">
                <fmt:message key="jsp.general.startdate"/>
            </td>           
            <td>
                <spring:bind path="appConfigAttributeForm.appConfigAttribute.startDate">
                    ${status.value}
                </spring:bind>
            </td>
        </tr>
        
        <!-- END DATE -->
        <tr>
            <td class="label"><fmt:message key="jsp.general.enddate" /></td>
            <td><spring:bind path="appConfigAttributeForm.appConfigAttribute.endDate">
            <input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
            <table>
                <tr>
                    <td><fmt:message key="jsp.general.day" /></td>
                    <td><fmt:message key="jsp.general.month" /></td>
                    <td><fmt:message key="jsp.general.year" /></td>
                </tr>
                <tr>
                    <td><input type="text" id="end_day" name="end_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />"  onchange="updateFullDate('appConfigAttribute.endDate','day',document.getElementById('end_day').value);" /></td>
                    <td><input type="text" id="end_month" name="end_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('appConfigAttribute.endDate','month',document.getElementById('end_month').value);" /></td>
                    <td><input type="text" id="end_year" name="end_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('appConfigAttribute.endDate','year',document.getElementById('end_year').value);" /></td>
                </tr>
            </table>
            <td>
                <fmt:message key="jsp.general.message.dateformat.month" />
                <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></spring:bind>
            </td>
        </tr>
        
        
        
        
        <tr><td>&nbsp;</td></tr>
    <tr>
        <td colspan="5" align="center">
            <input type="button" 
                    name="submitformdata" 
                    value="<fmt:message key="jsp.button.submit" />" 
                    onclick="document.getElementById('submitFormObject').value='true';document.formdata.submit();" 
            />
        </td>
    </tr>
    
    </table>    
        
    </form>
            
    </div><!-- tabcontent -->    
</div><!-- tabwrapper -->

<%@ include file="../footer.jsp"%>