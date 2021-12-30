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

 <input type="hidden" value="selectionValue" value="false" />
<table>
    <tr>
        <td class="label" ><fmt:message key="jsp.finance.status" /></td>
        <td >
         <select name="statusCodeSelection" id="statusCodeSelection" >
        	<c:choose>
        	<c:when test="${statusCodeSelection == -1}">
			   	<option value="-1" selected="selected"><fmt:message key="jsp.selectbox.choose"/></option>
			   	<option value="0"><fmt:message key="jsp.statuscode.ok" /></option> 
			   	<option value="1"><fmt:message key="jsp.statuscode.errorinterface" /></option> 
			   	<option value="2"><fmt:message key="jsp.statuscode.erroropus" /></option>
			   	<option value="4"><fmt:message key="jsp.statuscode.errorignored" /></option>
   	        </c:when>
            <c:when test="${statusCodeSelection == 0}">
                <option value="-1"><fmt:message key="jsp.selectbox.choose" /></option>
                <option value="0" selected="selected"><fmt:message key="jsp.statuscode.ok"/></option> 
                <option value="1"><fmt:message key="jsp.statuscode.errorinterface" /></option> 
                <option value="2"><fmt:message key="jsp.statuscode.erroropus" /></option>
                <option value="4"><fmt:message key="jsp.statuscode.errorignored" /></option>
              </c:when>
             <c:when test="${statusCodeSelection == 1}">
                <option value="-1"><fmt:message key="jsp.selectbox.choose" /></option>
                 <option value="0"><fmt:message key="jsp.statuscode.ok" /></option> 
                <option value="1" selected="selected"><fmt:message key="jsp.statuscode.errorinterface"/></option> 
                <option value="2"><fmt:message key="jsp.statuscode.erroropus" /></option>
                 <option value="4"><fmt:message key="jsp.statuscode.errorignored" /></option>
              </c:when>
             <c:when test="${statusCodeSelection == 2}">
                <option value="-1"><fmt:message key="jsp.selectbox.choose" /></option>
                <option value="0"><fmt:message key="jsp.statuscode.ok" /></option> 
                <option value="1"><fmt:message key="jsp.statuscode.errorinterface" /></option> 
                <option value="2" selected="selected"><fmt:message key="jsp.statuscode.erroropus"/></option>
                <option value="4"><fmt:message key="jsp.statuscode.errorignored" /></option>
              </c:when>
            <c:when test="${statusCodeSelection == 4}">
                <option value="-1"><fmt:message key="jsp.selectbox.choose" /></option>
                <option value="0"><fmt:message key="jsp.statuscode.ok" /></option> 
                <option value="1"><fmt:message key="jsp.statuscode.errorinterface" /></option> 
                <option value="2"><fmt:message key="jsp.statuscode.erroropus" /></option>
                <option value="4" selected="selected" ><fmt:message key="jsp.statuscode.errorignored" /></option>
              </c:when>
             </c:choose>
     </select>
    </td> 
    <td class="label" ><fmt:message key="jsp.finance.errorcode" /></td>
         <td>
         <select name="errorCodeSelection" id="errorCodeSelection" >
             <c:choose>
             <c:when test="${errorCodeSelection == -1}">
              <option value="-1" selected="selected"><fmt:message key="jsp.selectbox.choose"/></option>
              <option value="0"><fmt:message key="jsp.errorcode.noerror" /></option>
              <option value="1"><fmt:message key="jsp.errorcode.generalfailure" /></option>
              <option value="2"><fmt:message key="jsp.errorcode.studentidinvalid" /></option>
              <option value="3"><fmt:message key="jsp.errorcode.transactionnotfound" /></option>
              <option value="4"><fmt:message key="jsp.errorcode.studentnotexist" /></option>
              <option value="5"><fmt:message key="jsp.errorcode.amountinvalid" /></option>
              <option value="6"><fmt:message key="jsp.errorcode.studentnotregistered" /></option>              
              <option value="7"><fmt:message key="jsp.errorcode.unpareablecsvdata" /></option>
              <option value="8"><fmt:message key="jsp.errorcode.missingfields" /></option>
              <option value="9"><fmt:message key="jsp.errorcode.duplicaterequestid" /></option>
              <option value="10"><fmt:message key="jsp.errorcode.missingtransactionid" /></option>
              <option value="11"><fmt:message key="jsp.errorcode.missingrequestid" /></option>
              <option value="12"><fmt:message key="jsp.errorcode.invalidkey" /></option> 
               <option value="13"><fmt:message key="jsp.errorcode.missingstudentfees" /></option>              
             </c:when>
            <c:when test="${errorCodeSelection == 0}">
                 <option value="-1"><fmt:message key="jsp.selectbox.choose"/></option>
                 <option value="0" selected="selected"><fmt:message key="jsp.errorcode.noerror" /></option>
                 <option value="1"><fmt:message key="jsp.errorcode.generalfailure" /></option>
                 <option value="2"><fmt:message key="jsp.errorcode.studentidinvalid" /></option>
                 <option value="3"><fmt:message key="jsp.errorcode.transactionnotfound" /></option>
                 <option value="4"><fmt:message key="jsp.errorcode.studentnotexist" /></option>
                 <option value="5"><fmt:message key="jsp.errorcode.amountinvalid" /></option>
                 <option value="6"><fmt:message key="jsp.errorcode.studentnotregistered" /></option> 
                 <option value="7"><fmt:message key="jsp.errorcode.unpareablecsvdata" /></option>
                 <option value="8"><fmt:message key="jsp.errorcode.missingfields" /></option>
                 <option value="9"><fmt:message key="jsp.errorcode.duplicaterequestid" /></option>
                 <option value="10"><fmt:message key="jsp.errorcode.missingtransactionid" /></option>
                 <option value="11"><fmt:message key="jsp.errorcode.missingrequestid" /></option>
                 <option value="12"><fmt:message key="jsp.errorcode.invalidkey" /></option> 
                 <option value="13"><fmt:message key="jsp.errorcode.missingstudentfees" /></option>                   
             </c:when>
            <c:when test="${errorCodeSelection == 1}">
                 <option value="-1"><fmt:message key="jsp.selectbox.choose"/></option>
                 <option value="0"><fmt:message key="jsp.errorcode.noerror" /></option>
                 <option value="1" selected="selected"><fmt:message key="jsp.errorcode.generalfailure" /></option>
                 <option value="2"><fmt:message key="jsp.errorcode.studentidinvalid" /></option>
                 <option value="3"><fmt:message key="jsp.errorcode.transactionnotfound" /></option>
                 <option value="4"><fmt:message key="jsp.errorcode.studentnotexist" /></option>
                 <option value="5"><fmt:message key="jsp.errorcode.amountinvalid" /></option>
                 <option value="6"><fmt:message key="jsp.errorcode.studentnotregistered" /></option> 
                 <option value="7"><fmt:message key="jsp.errorcode.unpareablecsvdata" /></option>
                 <option value="8"><fmt:message key="jsp.errorcode.missingfields" /></option>
                 <option value="9"><fmt:message key="jsp.errorcode.duplicaterequestid" /></option>
                 <option value="10"><fmt:message key="jsp.errorcode.missingtransactionid" /></option>
                 <option value="11"><fmt:message key="jsp.errorcode.missingrequestid" /></option>
                 <option value="12"><fmt:message key="jsp.errorcode.invalidkey" /></option> 
                 <option value="13"><fmt:message key="jsp.errorcode.missingstudentfees" /></option>                   
             </c:when>
            <c:when test="${errorCodeSelection == 2}">
                 <option value="-1"><fmt:message key="jsp.selectbox.choose"/></option>
                 <option value="0"><fmt:message key="jsp.errorcode.noerror" /></option>
                 <option value="1"><fmt:message key="jsp.errorcode.generalfailure" /></option>
                 <option value="2" selected="selected"><fmt:message key="jsp.errorcode.studentidinvalid" /></option>
                 <option value="3"><fmt:message key="jsp.errorcode.transactionnotfound" /></option>
                 <option value="4"><fmt:message key="jsp.errorcode.studentnotexist" /></option>
                 <option value="5"><fmt:message key="jsp.errorcode.amountinvalid" /></option>
                 <option value="6"><fmt:message key="jsp.errorcode.studentnotregistered" /></option> 
                 <option value="7"><fmt:message key="jsp.errorcode.unpareablecsvdata" /></option>
                 <option value="8"><fmt:message key="jsp.errorcode.missingfields" /></option>
                 <option value="9"><fmt:message key="jsp.errorcode.duplicaterequestid" /></option>
                 <option value="10"><fmt:message key="jsp.errorcode.missingtransactionid" /></option>
                 <option value="11"><fmt:message key="jsp.errorcode.missingrequestid" /></option>
                 <option value="12"><fmt:message key="jsp.errorcode.invalidkey" /></option> 
                 <option value="13"><fmt:message key="jsp.errorcode.missingstudentfees" /></option>   
             </c:when>
            <c:when test="${errorCodeSelection == 3}">
                 <option value="-1"><fmt:message key="jsp.selectbox.choose"/></option>
                 <option value="0"><fmt:message key="jsp.errorcode.noerror" /></option>
                 <option value="1"><fmt:message key="jsp.errorcode.generalfailure" /></option>
                 <option value="2"><fmt:message key="jsp.errorcode.studentidinvalid" /></option>
                 <option value="3" selected="selected"><fmt:message key="jsp.errorcode.transactionnotfound" /></option>
                 <option value="4"><fmt:message key="jsp.errorcode.studentnotexist" /></option>
                 <option value="5"><fmt:message key="jsp.errorcode.amountinvalid" /></option>
                 <option value="6"><fmt:message key="jsp.errorcode.studentnotregistered" /></option> 
                 <option value="7"><fmt:message key="jsp.errorcode.unpareablecsvdata" /></option>
                 <option value="8"><fmt:message key="jsp.errorcode.missingfields" /></option>
                 <option value="9"><fmt:message key="jsp.errorcode.duplicaterequestid" /></option>
                 <option value="10"><fmt:message key="jsp.errorcode.missingtransactionid" /></option>
                 <option value="11"><fmt:message key="jsp.errorcode.missingrequestid" /></option>
                 <option value="12"><fmt:message key="jsp.errorcode.invalidkey" /></option> 
                 <option value="13"><fmt:message key="jsp.errorcode.missingstudentfees" /></option>   
             </c:when>
            <c:when test="${errorCodeSelection == 4}">
                 <option value="-1"><fmt:message key="jsp.selectbox.choose"/></option>
                 <option value="0"><fmt:message key="jsp.errorcode.noerror" /></option>
                 <option value="1"><fmt:message key="jsp.errorcode.generalfailure" /></option>
                 <option value="2"><fmt:message key="jsp.errorcode.studentidinvalid" /></option>
                 <option value="3"><fmt:message key="jsp.errorcode.transactionnotfound" /></option>
                 <option value="4" selected="selected"><fmt:message key="jsp.errorcode.studentnotexist" /></option>
                 <option value="5"><fmt:message key="jsp.errorcode.amountinvalid" /></option>
                 <option value="6"><fmt:message key="jsp.errorcode.studentnotregistered" /></option> 
                 <option value="7"><fmt:message key="jsp.errorcode.unpareablecsvdata" /></option>
                 <option value="8"><fmt:message key="jsp.errorcode.missingfields" /></option>
                 <option value="9"><fmt:message key="jsp.errorcode.duplicaterequestid" /></option>
                 <option value="10"><fmt:message key="jsp.errorcode.missingtransactionid" /></option>
                 <option value="11"><fmt:message key="jsp.errorcode.missingrequestid" /></option>
                 <option value="12"><fmt:message key="jsp.errorcode.invalidkey" /></option> 
                 <option value="13"><fmt:message key="jsp.errorcode.missingstudentfees" /></option>   
             </c:when>             
            <c:when test="${errorCodeSelection == 5}">
                 <option value="-1"><fmt:message key="jsp.selectbox.choose"/></option>
                 <option value="0"><fmt:message key="jsp.errorcode.noerror" /></option>
                 <option value="1"><fmt:message key="jsp.errorcode.generalfailure" /></option>
                 <option value="2"><fmt:message key="jsp.errorcode.studentidinvalid" /></option>
                 <option value="3"><fmt:message key="jsp.errorcode.transactionnotfound" /></option>
                 <option value="4"><fmt:message key="jsp.errorcode.studentnotexist" /></option>
                 <option value="5" selected="selected"><fmt:message key="jsp.errorcode.amountinvalid" /></option>
                 <option value="6"><fmt:message key="jsp.errorcode.studentnotregistered" /></option> 
                 <option value="7"><fmt:message key="jsp.errorcode.unpareablecsvdata" /></option>
                 <option value="8"><fmt:message key="jsp.errorcode.missingfields" /></option>
                 <option value="9"><fmt:message key="jsp.errorcode.duplicaterequestid" /></option>
                 <option value="10"><fmt:message key="jsp.errorcode.missingtransactionid" /></option>
                 <option value="11"><fmt:message key="jsp.errorcode.missingrequestid" /></option>
                 <option value="12"><fmt:message key="jsp.errorcode.invalidkey" /></option> 
                 <option value="13"><fmt:message key="jsp.errorcode.missingstudentfees" /></option>   
             </c:when>
           <c:when test="${errorCodeSelection == 6}">
                 <option value="-1"><fmt:message key="jsp.selectbox.choose"/></option>
                 <option value="0"><fmt:message key="jsp.errorcode.noerror" /></option>
                 <option value="1"><fmt:message key="jsp.errorcode.generalfailure" /></option>
                 <option value="2"><fmt:message key="jsp.errorcode.studentidinvalid" /></option>
                 <option value="3"><fmt:message key="jsp.errorcode.transactionnotfound" /></option>
                 <option value="4"><fmt:message key="jsp.errorcode.studentnotexist" /></option>
                 <option value="5"><fmt:message key="jsp.errorcode.amountinvalid" /></option>
                 <option value="6" selected="selected"><fmt:message key="jsp.errorcode.studentnotregistered" /></option> 
                 <option value="7"><fmt:message key="jsp.errorcode.unpareablecsvdata" /></option>
                 <option value="8"><fmt:message key="jsp.errorcode.missingfields" /></option>
                 <option value="9"><fmt:message key="jsp.errorcode.duplicaterequestid" /></option>
                 <option value="10"><fmt:message key="jsp.errorcode.missingtransactionid" /></option>
                 <option value="11"><fmt:message key="jsp.errorcode.missingrequestid" /></option>
                 <option value="12"><fmt:message key="jsp.errorcode.invalidkey" /></option> 
                 <option value="13"><fmt:message key="jsp.errorcode.missingstudentfees" /></option>   
             </c:when>             
            <c:when test="${errorCodeSelection == 7}">
                <option value="-1"><fmt:message key="jsp.selectbox.choose"/></option>
                 <option value="0"><fmt:message key="jsp.errorcode.noerror" /></option>
                 <option value="1"><fmt:message key="jsp.errorcode.generalfailure" /></option>
                 <option value="2"><fmt:message key="jsp.errorcode.studentidinvalid" /></option>
                 <option value="3"><fmt:message key="jsp.errorcode.transactionnotfound" /></option>
                 <option value="4"><fmt:message key="jsp.errorcode.studentnotexist" /></option>
                 <option value="5"><fmt:message key="jsp.errorcode.amountinvalid" /></option>
                 <option value="6"><fmt:message key="jsp.errorcode.studentnotregistered" /></option> 
                 <option value="7" selected="selected"><fmt:message key="jsp.errorcode.unpareablecsvdata" /></option>
                 <option value="8"><fmt:message key="jsp.errorcode.missingfields" /></option>
                 <option value="9"><fmt:message key="jsp.errorcode.duplicaterequestid" /></option>
                 <option value="10"><fmt:message key="jsp.errorcode.missingtransactionid" /></option>
                 <option value="11"><fmt:message key="jsp.errorcode.missingrequestid" /></option>
                 <option value="12"><fmt:message key="jsp.errorcode.invalidkey" /></option> 
                 <option value="13"><fmt:message key="jsp.errorcode.missingstudentfees" /></option>   
             </c:when>
            <c:when test="${errorCodeSelection == 8}">
                <option value="-1"><fmt:message key="jsp.selectbox.choose"/></option>
                 <option value="0"><fmt:message key="jsp.errorcode.noerror" /></option>
                 <option value="1"><fmt:message key="jsp.errorcode.generalfailure" /></option>
                 <option value="2"><fmt:message key="jsp.errorcode.studentidinvalid" /></option>
                 <option value="3"><fmt:message key="jsp.errorcode.transactionnotfound" /></option>
                 <option value="4"><fmt:message key="jsp.errorcode.studentnotexist" /></option>
                 <option value="5"><fmt:message key="jsp.errorcode.amountinvalid" /></option>
                 <option value="6"><fmt:message key="jsp.errorcode.studentnotregistered" /></option> 
                 <option value="7"><fmt:message key="jsp.errorcode.unpareablecsvdata" /></option>
                 <option value="8" selected="selected"><fmt:message key="jsp.errorcode.missingfields" /></option>
                 <option value="9"><fmt:message key="jsp.errorcode.duplicaterequestid" /></option>
                 <option value="10"><fmt:message key="jsp.errorcode.missingtransactionid" /></option>
                 <option value="11"><fmt:message key="jsp.errorcode.missingrequestid" /></option>
                 <option value="12"><fmt:message key="jsp.errorcode.invalidkey" /></option> 
                 <option value="13"><fmt:message key="jsp.errorcode.missingstudentfees" /></option>   
             </c:when>
            <c:when test="${errorCodeSelection == 9}">
                <option value="-1"><fmt:message key="jsp.selectbox.choose"/></option>
                 <option value="0"><fmt:message key="jsp.errorcode.noerror" /></option>
                 <option value="1"><fmt:message key="jsp.errorcode.generalfailure" /></option>
                 <option value="2"><fmt:message key="jsp.errorcode.studentidinvalid" /></option>
                 <option value="3"><fmt:message key="jsp.errorcode.transactionnotfound" /></option>
                 <option value="4"><fmt:message key="jsp.errorcode.studentnotexist" /></option>
                 <option value="5"><fmt:message key="jsp.errorcode.amountinvalid" /></option>
                 <option value="6"><fmt:message key="jsp.errorcode.studentnotregistered" /></option> 
                 <option value="7"><fmt:message key="jsp.errorcode.unpareablecsvdata" /></option>
                 <option value="8"><fmt:message key="jsp.errorcode.missingfields" /></option>
                 <option value="9" selected="selected"><fmt:message key="jsp.errorcode.duplicaterequestid" /></option>
                 <option value="10"><fmt:message key="jsp.errorcode.missingtransactionid" /></option>
                 <option value="11"><fmt:message key="jsp.errorcode.missingrequestid" /></option>
                 <option value="12"><fmt:message key="jsp.errorcode.invalidkey" /></option> 
                 <option value="13"><fmt:message key="jsp.errorcode.missingstudentfees" /></option>    
             </c:when>
            <c:when test="${errorCodeSelection == 10}">
                 <option value="-1"><fmt:message key="jsp.selectbox.choose"/></option>
                 <option value="0"><fmt:message key="jsp.errorcode.noerror" /></option>
                 <option value="1"><fmt:message key="jsp.errorcode.generalfailure" /></option>
                 <option value="2"><fmt:message key="jsp.errorcode.studentidinvalid" /></option>
                 <option value="3"><fmt:message key="jsp.errorcode.transactionnotfound" /></option>
                 <option value="4"><fmt:message key="jsp.errorcode.studentnotexist" /></option>
                 <option value="5"><fmt:message key="jsp.errorcode.amountinvalid" /></option>
                 <option value="6"><fmt:message key="jsp.errorcode.studentnotregistered" /></option> 
                 <option value="7"><fmt:message key="jsp.errorcode.unpareablecsvdata" /></option>
                 <option value="8"><fmt:message key="jsp.errorcode.missingfields" /></option>
                 <option value="9"><fmt:message key="jsp.errorcode.duplicaterequestid" /></option>
                 <option value="10" selected="selected"><fmt:message key="jsp.errorcode.missingtransactionid" /></option>
                 <option value="11"><fmt:message key="jsp.errorcode.missingrequestid" /></option>
                 <option value="12"><fmt:message key="jsp.errorcode.invalidkey" /></option> 
                 <option value="13"><fmt:message key="jsp.errorcode.missingstudentfees" /></option>   
             </c:when>
            <c:when test="${errorCodeSelection == 11}">
                <option value="-1"><fmt:message key="jsp.selectbox.choose"/></option>
                 <option value="0"><fmt:message key="jsp.errorcode.noerror" /></option>
                 <option value="1"><fmt:message key="jsp.errorcode.generalfailure" /></option>
                 <option value="2"><fmt:message key="jsp.errorcode.studentidinvalid" /></option>
                 <option value="3"><fmt:message key="jsp.errorcode.transactionnotfound" /></option>
                 <option value="4"><fmt:message key="jsp.errorcode.studentnotexist" /></option>
                 <option value="5"><fmt:message key="jsp.errorcode.amountinvalid" /></option>
                 <option value="6"><fmt:message key="jsp.errorcode.studentnotregistered" /></option> 
                 <option value="7"><fmt:message key="jsp.errorcode.unpareablecsvdata" /></option>
                 <option value="8"><fmt:message key="jsp.errorcode.missingfields" /></option>
                 <option value="9"><fmt:message key="jsp.errorcode.duplicaterequestid" /></option>
                 <option value="10"><fmt:message key="jsp.errorcode.missingtransactionid" /></option>
                 <option value="11" selected="selected"><fmt:message key="jsp.errorcode.missingrequestid" /></option>
                 <option value="12"><fmt:message key="jsp.errorcode.invalidkey" /></option> 
                 <option value="13"><fmt:message key="jsp.errorcode.missingstudentfees" /></option>   
             </c:when>
            <c:when test="${errorCodeSelection == 12}">
                <option value="-1"><fmt:message key="jsp.selectbox.choose"/></option>
                 <option value="0"><fmt:message key="jsp.errorcode.noerror" /></option>
                 <option value="1"><fmt:message key="jsp.errorcode.generalfailure" /></option>
                 <option value="2"><fmt:message key="jsp.errorcode.studentidinvalid" /></option>
                 <option value="3"><fmt:message key="jsp.errorcode.transactionnotfound" /></option>
                 <option value="4"><fmt:message key="jsp.errorcode.studentnotexist" /></option>
                 <option value="5"><fmt:message key="jsp.errorcode.amountinvalid" /></option>
                 <option value="6"><fmt:message key="jsp.errorcode.studentnotregistered" /></option> 
                 <option value="7"><fmt:message key="jsp.errorcode.unpareablecsvdata" /></option>
                 <option value="8"><fmt:message key="jsp.errorcode.missingfields" /></option>
                 <option value="9"><fmt:message key="jsp.errorcode.duplicaterequestid" /></option>
                 <option value="10"><fmt:message key="jsp.errorcode.missingtransactionid" /></option>
                 <option value="11"><fmt:message key="jsp.errorcode.missingrequestid" /></option>
                 <option value="12" selected="selected"><fmt:message key="jsp.errorcode.invalidkey" /></option> 
                 <option value="13"><fmt:message key="jsp.errorcode.missingstudentfees" /></option>    
             </c:when>
            <c:when test="${errorCodeSelection == 13}">
                <option value="-1"><fmt:message key="jsp.selectbox.choose"/></option>
                 <option value="0"><fmt:message key="jsp.errorcode.noerror" /></option>
                 <option value="1"><fmt:message key="jsp.errorcode.generalfailure" /></option>
                 <option value="2"><fmt:message key="jsp.errorcode.studentidinvalid" /></option>
                 <option value="3"><fmt:message key="jsp.errorcode.transactionnotfound" /></option>
                 <option value="4"><fmt:message key="jsp.errorcode.studentnotexist" /></option>
                 <option value="5"><fmt:message key="jsp.errorcode.amountinvalid" /></option>
                 <option value="6"><fmt:message key="jsp.errorcode.studentnotregistered" /></option> 
                 <option value="7"><fmt:message key="jsp.errorcode.unpareablecsvdata" /></option>
                 <option value="8"><fmt:message key="jsp.errorcode.missingfields" /></option>
                 <option value="9"><fmt:message key="jsp.errorcode.duplicaterequestid" /></option>
                 <option value="10"><fmt:message key="jsp.errorcode.missingtransactionid" /></option>
                 <option value="11"><fmt:message key="jsp.errorcode.missingrequestid" /></option>
                 <option value="12"><fmt:message key="jsp.errorcode.invalidkey" /></option> 
                 <option value="13" selected="selected"><fmt:message key="jsp.errorcode.missingstudentfees" /></option>    
             </c:when>
            </c:choose> 
         </select>
         </td> 
        </tr>
       
       <tr>
             <td class="label"><fmt:message key="jsp.finance.financialrequestid" /></td>
             <td width="150" align="left">
                <img src="<c:url value='/images/trans.gif' />" width="10"/>            
                 <input type="text" name="financialRequestIdParam" id="financialRequestIdParam"  value="${financialRequestIdParam}" />&nbsp;
              </td> 
             <td class="label"><fmt:message key="jsp.finance.studentCode" />&nbsp</td>
          <td width="150" align="left">
          <img src="<c:url value='/images/trans.gif' />" width="10"/>            
           <input type="text" name="studentCode" id="studentCode"  value="${studentCode}" />&nbsp;
       </td>                           
      </tr>
    
      <tr>                               
       <td class="label" ><fmt:message key="jsp.finance.fromDate" />&nbspDD/MM/YYYY</td>
       <td width="150" align="left">
          <img src="<c:url value='/images/trans.gif' />" width="10"/>            
           <input type="text" name="fromReceivedDate" id="fromReceivedDate"  value="${fromReceivedDate}" />&nbsp;
       </td>
       <td class="label" ><fmt:message key="jsp.finance.toDate" />&nbspDD/MM/YYYY</td>
       <td width="150" align="left">
          <img src="<c:url value='/images/trans.gif' />" width="10"/>            
           <input type="text" name="untilReceivedDate" id="untilReceivedDate"  value="${untilReceivedDate}" />&nbsp;
       </td>
     </tr>
<%--    <tr>
       <td><label for="progress" ><fmt:message key="jsp.finance.tuitionfee75procentpaid" /></label></td>   
       <td>
           <input type="checkbox" name="tuitionFee75Procent" checked="checked" />
        </td>
        <td colspan="2"></td>
    </tr> --%>
     <tr>
        <td colspan=4" align="right">
        <img src="<c:url value='/images/search.gif' />" onclick="document.financialTransactionsForm.submit()"/>
        </td>
     </tr>
    </table>		
