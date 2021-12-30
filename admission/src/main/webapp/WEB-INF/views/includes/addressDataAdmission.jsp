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

The Original Code is Opus-College admission module code.

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
<table>
    <input type="hidden" name="address.addressTypeCode" size="40" value="<c:out value='${address.addressTypeCode}'/>" />
    <tr>
        <td class="label"><fmt:message key="jsp.general.country" /></td>
        <td class="required">
            <select name="address.countryCode" id="address.countryCode" onchange="document.getElementById('navigationSettings.panel').value='1';updateEmptyNumber('address.number','0');document.getElementById('address.provinceCode').value='0';document.getElementById('address.districtCode').value='0';document.getElementById('address.administrativePostCode').value='0';document.formdata.submit();">
                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                <c:forEach var="country" items="${allCountries}">
                    <c:choose>
                        <c:when test="${country.code == address.countryCode}">
                            <option value="<c:out value='${country.code}'/>" selected="selected"><c:out value='${country.description}'/></option>
                        </c:when>
                        <c:otherwise>
                            <option value="<c:out value='${country.code}'/>"><c:out value='${country.description}'/></option>
                        </c:otherwise>
                    </c:choose>
                </c:forEach> 
            </select>
        </td>
    </tr>
    
    <!-- provinceCode -->
    <spring:bind path="requestAdmissionForm.address.provinceCode">
    <tr>
        <td class="label"><fmt:message key="jsp.general.province" /></td>
        <c:choose>
        <c:when test="${student.foreignStudent == 'N'}">
            <td class="required">
                <select name="${status.expression}" id="${status.expression}" onchange="document.getElementById('navigationSettings.panel').value='1';updateEmptyNumber('address.number','0');document.getElementById('address.administrativePostCode').value='0';document.getElementById('address.districtCode').value='0';document.formdata.submit();">
                <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                <c:forEach var="province" items="${allProvinces}">
                    <c:choose>
                        <c:when test="${province.code == status.value}">
                            <option value="<c:out value='${province.code}'/>" selected="selected"><c:out value='${province.description}'/></option>
                        </c:when>
                        <c:otherwise>
                            <option value="<c:out value='${province.code}'/>"><c:out value='${province.description}'/></option>
                        </c:otherwise>
                    </c:choose>
                </c:forEach> 
            </select>
        </td>
        <td><%@ include file="../includes/errorMessages.jsp" %></td>
        </c:when>
        <c:otherwise>
            <td>
                <select name="${status.expression}" id="${status.expression}" onchange="document.getElementById('navigationSettings.panel').value='1';updateEmptyNumber('address.number','0');document.getElementById('address.administrativePostCode').value='0';document.getElementById('address.districtCode').value='0';document.formdata.submit();">
                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                <c:forEach var="province" items="${allProvinces}">
                    <c:choose>
                        <c:when test="${province.code == status.value}">
                            <option value="<c:out value='${province.code}'/>" selected="selected"><c:out value='${province.description}'/></option>
                        </c:when>
                        <c:otherwise>
                            <option value="<c:out value='${province.code}'/>"><c:out value='${province.description}'/></option>
                        </c:otherwise>
                    </c:choose>
                </c:forEach> 
            </select>
        </td>
        <td><%@ include file="../includes/errorMessages.jsp" %></td>

        </c:otherwise>
        </c:choose>
    </tr>
    </spring:bind>
    
    <!-- districtCode -->
    <tr>
        <td class="label"><fmt:message key="jsp.general.district" /></td>
        <td>
            <form:select path="address.districtCode" onchange="document.getElementById('navigationSettings.panel').value='1';updateEmptyNumber('address.number','0');document.getElementById('address.administrativePostCode').value='0';document.formdata.submit();">
                <form:option value="0">
                    <fmt:message key="jsp.selectbox.choose" />
                </form:option>
                <form:options items="${allDistricts}" itemValue="code" itemLabel="description" />
            </form:select>
        </td>
    </tr>

    <!-- administrativePostCode -->
    <tr>
        <td class="label"><fmt:message key="jsp.general.address.administrativepost" /></td>
        <td>
            <form:select path="address.administrativePostCode" onchange="document.getElementById('navigationSettings.panel').value='1';updateEmptyNumber('address.number','0');">
                <form:option value="0">
                    <fmt:message key="jsp.selectbox.choose" />
                </form:option>
                <form:options items="${allAdministrativePosts}" itemValue="code" itemLabel="description" />
            </form:select>
        </td>
    </tr>
    
    <tr><td colspn="3">&nbsp;</td></tr>
    <tr>
        <td colspan="3" class="label">
            <fmt:message key="jsp.streetpobox.address.header" />
        </td>
    </tr>
    <tr>
        <td colspan="2" class="required">
        <table valign="top">
		    <!-- city -->
		    <spring:bind path="requestAdmissionForm.address.city">
		    <tr>
		        <td class="label"><fmt:message key="jsp.general.city" /></td>
		        <td class="required">
		            <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
		        </td>
		        <td><%@ include file="../includes/errorMessages.jsp" %></td>
		    </tr>
	       </spring:bind>
        
		    <!-- street -->
		    <spring:bind path="requestAdmissionForm.address.street">
		    <tr>
		        <td class="label"><fmt:message key="jsp.general.address.street" /></td>
		        <td class="required">
		            <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
		        </td>
		    </tr>
            <tr>
		        <td colspan="2"><%@ include file="../includes/errorMessages.jsp" %></td>
		    </tr>
		    </spring:bind>
		    <!-- number -->
             <tr>
		        <td class="label" colspan="3"><fmt:message key="jsp.general.address.numberextension" /></td>
            </tr>
		     <tr>    
                <td>
                    <spring:bind path="requestAdmissionForm.address.number">
                    <input type="text" id="${status.expression}" name="${status.expression}" size="3" value="<c:out value="${status.value}" />" />
                    <%@ include file="../includes/errorMessages.jsp" %>
                    </spring:bind>               
                </td>              
                <td colspan="2">
                     <spring:bind path="requestAdmissionForm.address.numberExtension"> 
                     <input type="text" name="${status.expression}" size="10" value="<c:out value="${status.value}" />" />   
                     <%@ include file="../includes/errorMessages.jsp" %>		        
                    </spring:bind>             
                </td>
		    </tr>
		    <!-- zipCode -->
		    <tr>
		        <spring:bind path="requestAdmissionForm.address.zipCode">
		        <td class="label" colspan="3"><fmt:message key="jsp.general.address.zipcode" /></td>
            </tr>
            <tr>
		        <td>
		            <input type="text" name="${status.expression}" size="15" maxlength="15" value="<c:out value="${status.value}" />" />
		        </td>
		        <td colspan="2">
		            <fmt:message key="jsp.message.format.zipcode" />
		            <br /><a href="http://www.geopostcodes.com/"><fmt:message key="jsp.general.address.zipcode.url" /></a>&nbsp;
		            <%@ include file="../includes/errorMessages.jsp" %>
		        </td>
		        </spring:bind>
		    </tr>
		</table>
		</td>
       
        <td class="required">
        <table valign="top">
 		    <!-- POBox -->
		    <tr>
               <td class="label"><fmt:message key="jsp.general.address.POBox" /></td>
                <spring:bind path="requestAdmissionForm.address.POBox">
		        <td class="required">
		            <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
		        </td>
		     </tr>
		     <tr>
		        <td colspan="2"><%@ include file="../includes/errorMessages.jsp" %></td>
		        </spring:bind>
		    </tr>
		 </table>
		 </td>
    </tr>
	<tr><td colspn="3">&nbsp;</td></tr>    
    <!-- telephone -->
    <tr>
        <spring:bind path="requestAdmissionForm.address.telephone">
        <td class="label"><fmt:message key="jsp.general.telephone" /></td>
        <td>
            <input type="text" name="${status.expression}" size="20" maxlength="15" value="<c:out value="${status.value}" />" />
        </td>
        <td>
            <fmt:message key="jsp.message.format.telephone" />&nbsp;
            <%@ include file="../includes/errorMessages.jsp" %>
        </td>
        </spring:bind>
    </tr>
    <!-- mobilePhone -->       
    <tr>
        <spring:bind path="requestAdmissionForm.address.mobilePhone">
        <td class="label"><fmt:message key="jsp.general.mobile" /></td>
        <c:choose>
            <c:when test="${initParam. iMobilePhoneRequired && address.addressTypeCode != '4' 
                            && address.addressTypeCode != '5'}">
                <td class="required">
            </c:when>
            <c:otherwise>
                <td>
            </c:otherwise>
        </c:choose>
        <input type="text" name="${status.expression}" size="20" maxlength="15" value="<c:out value="${status.value}" />" />
        </td>
        <td>
            <fmt:message key="jsp.message.format.mobilephone" />&nbsp;
            <%@ include file="../includes/errorMessages.jsp" %>
        </td>
        </spring:bind>
    </tr>
    <!-- faxNumber -->
    <tr>
        <spring:bind path="requestAdmissionForm.address.faxNumber">
        <td class="label"><fmt:message key="jsp.general.fax" /></td>
        <td>
            
            <input type="text" name="${status.expression}" size="20" maxlength="15" value="<c:out value="${status.value}" />" />
        </td>
        <td>
        <fmt:message key="jsp.message.format.telephone" />&nbsp;
        <%@ include file="../includes/errorMessages.jsp" %></td>
        </spring:bind>
    </tr>
    <!-- emailAddress -->
    <tr>
        <spring:bind path="requestAdmissionForm.address.emailAddress">
        <td class="label"><fmt:message key="jsp.general.email" /></td>
            <c:choose>
                <c:when test="${initParam.iEmailAddressRequired && address.addressTypeCode != '4' 
                                && address.addressTypeCode != '5'}">
                    <td class="required">
                </c:when>
                <c:otherwise>
                    <td>
                </c:otherwise>
            </c:choose>
            <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
        </td>
        <td><%@ include file="../includes/errorMessages.jsp" %></td>
        </spring:bind>
    </tr>
    <%-- <c:choose>
        <c:when test="${ not empty requestAdmissionForm.txtErr }">       
            <tr class="error" align="center">
                <td colspan="3" align="center">
                    ${requestAdmissionForm.txtErr}
                </td>
            </tr>
        </c:when>
    </c:choose> --%>
</table>
