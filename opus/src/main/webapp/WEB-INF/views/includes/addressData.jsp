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

<%@ include file="standardincludes.jsp"%>


<tr>
   <td class="label"><fmt:message key="jsp.general.country" /></td>
   <td colspan="2">
       <c:forEach var="country" items="${allCountries}">
   	 	<c:choose>
        		<c:when test="${country.code == address.countryCode}">
            		<c:out value="${country.description }"/>
        		</c:when>
        	</c:choose>
       </c:forEach>
   </td>
</tr>
<tr>
   <td class="label"><fmt:message key="jsp.general.province" /></td>
   <td colspan="2">
       <c:forEach var="province" items="${allProvinces }">
           <c:choose>
               <c:when test="${province.code == address.provinceCode }">
                   <c:out value="${province.description }"/>
               </c:when>
           </c:choose>
       </c:forEach>
       
   </td>
</tr>
<tr>
    <td class="label"><fmt:message key="jsp.general.district" /></td>
    <td colspan="2">
        <c:forEach var="district" items="${allDistricts}">
            <c:choose>
                <c:when test="${district.code == address.districtCode }">
                  <c:out value="${district.description }"/>
                </c:when>
            </c:choose>
        </c:forEach>
    </td>
 </tr>
 <tr>
    <td class="label"><fmt:message key="jsp.general.address.administrativepost" /></td>
    <td>
    <c:forEach var="administrativePost" items="${allAdministrativePosts }">
        <c:choose>
            <c:when test="${administrativePost.code == address.administrativePostCode }">
                <c:out value="${administrativePost.description }"/>
            </c:when>
        </c:choose>
    </c:forEach>
    </td>
 </tr>
 <tr>
    <td class="label"><fmt:message key="jsp.general.city" /></td>
    <td colspan="2"><c:out value="${address.city }"/></td>
 </tr>
 <tr>
    <td class="label"><fmt:message key="jsp.general.address.street" />
        <br /><fmt:message key="jsp.general.address.numberextension" /></td>
    <td colspan="2"><c:out value="${address.street}"/>&nbsp;<c:out value="${address.number}"/>&nbsp;<c:out value="${address.numberExtension}"/></td>
 </tr>
<tr>
     <td class="label"><fmt:message key="jsp.general.address.zipcode" /></td>
     <td colspan="2"><c:out value="${address.zipCode}"/></td>
  </tr>
  <tr>
     <td class="label"><fmt:message key="jsp.general.address.POBox" /></td>
     <td colspan="2"><c:out value="${address.POBox}"/></td>
  </tr>
   <tr>
     <td class="label"><fmt:message key="jsp.general.telephone" /></td>
     <td colspan="2"><c:out value="${address.telephone}"/></td>
  </tr>
  <tr>
     <td class="label"><fmt:message key="jsp.general.mobile" /></td>
     <td colspan="2"><c:out value="${address.mobilePhone}"/></td>
  </tr>
   <tr>
     <td class="label"><fmt:message key="jsp.general.fax" /></td>
     <td colspan="2"><c:out value="${address.faxNumber}"/></td>
  </tr>
   <tr>
     <td class="label"><fmt:message key="jsp.general.email" /></td>
     <td colspan="2"><c:out value="${address.emailAddress}"/></td>
  </tr>
  <tr><td colspan="3"></td></tr>
                                    
