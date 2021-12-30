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

<table>
<tr>
     <td class="label"><fmt:message key="jsp.general.surname" /></td>
     <td><spring:bind path="command.surnameFull">${status.value}</td>
     <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></spring:bind></td>
 </tr>
 <tr>
     <td class="label"><fmt:message key="jsp.general.firstnames" /></td>
     <td><spring:bind path="command.firstnamesFull">${status.value}</td>
     <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></spring:bind></td>
 </tr>
 <tr>
     <td class="label"><fmt:message key="jsp.general.nationalregistrationnumber" /></td>
     <td><spring:bind path="command.nationalRegistrationNumber">${status.value}</td>
     <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></spring:bind></td>
 </tr>
 <tr>
     <td class="label"><fmt:message key="jsp.general.gender" /></td>
     <td><spring:bind path="command.genderCode">
         <c:forEach var="gender" items="${allGenders}">
            <c:choose>
                <c:when test="${gender.code == status.value}">
                    ${gender.description}
                </c:when>
            </c:choose>
         </c:forEach>
     </td>
     <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></spring:bind></td>
 </tr>
 <tr>
     <td class="label"><fmt:message key="jsp.general.birthdate" /></td>
     <td><spring:bind path="command.birthdate">
     <table>
         <tr>
            <td>${fn:substring(status.value,8,10)}</td>
            <td>${fn:substring(status.value,5,7)}</td>
            <td>${fn:substring(status.value,0,4)}</td>
        </tr>
     </table>
     </td>
     <td>
         <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></spring:bind></td>
 </tr>
            <tr>
                <td class="label"><fmt:message key="jsp.general.nationality" /></td>
                <td>
                    <spring:bind path="command.nationalityCode">
                        <c:forEach var="nationality" items="${allNationalities}">
                         <c:choose>
                            <c:when test="${nationality.code == status.value}">
                                 ${nationality.description}
                             </c:when>
                         </c:choose>
                   </c:forEach>
           </td> 
              <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></spring:bind></td>
          </tr>
          <tr>
              <td class="label"><fmt:message key="jsp.general.countryofbirth" /></td>
              <td><spring:bind path="command.countryOfBirthCode">
                <c:forEach var="country" items="${allCountries}">
                    <c:choose>
                       <c:when test="${(country.code == status.value)}">
                           ${country.description}
                       </c:when>
                     </c:choose>
                </c:forEach> 
            </td>
            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></spring:bind></td>
        </tr>
        <tr>
            <td class="label"><fmt:message key="jsp.general.provinceofbirth" /></td>
            <td><spring:bind path="command.provinceOfBirthCode">
                <c:forEach var="provinceOfBirth" items="${allProvincesOfBirth}">
                        <c:choose>
                            <c:when test="${(provinceOfBirth.code == status.value) }">
                                ${provinceOfBirth.description}
                            </c:when>
                        </c:choose>
                </c:forEach> 
            </td>
            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></spring:bind></td>
        </tr>
        <tr>
            <td class="label"><fmt:message key="jsp.general.districtofbirth" /></td>
            <td><spring:bind path="command.districtOfBirthCode">
                <c:forEach var="districtOfBirth" items="${allDistrictsOfBirth}">
                        <c:choose>
                            <c:when test="${(districtOfBirth.code == status.value)}">
                                ${districtOfBirth.description}
                            </c:when>
                        </c:choose>
                </c:forEach> 
            </td>
            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></spring:bind></td>
        </tr>
          <tr>
                 <td class="label"><fmt:message key="jsp.general.placeofbirth" /></td>
                 <td><spring:bind path="command.placeOfBirth">${status.value}</td>
                 <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></spring:bind></td>
             </tr>
             <tr>
                 <td class="label"><fmt:message key="jsp.general.countryoforigin" /></td>
                 <td><spring:bind path="command.countryOfOriginCode">
                 <c:forEach var="country" items="${allCountries}">
                  <c:choose>
                   <c:when test="${(country.code == status.value)}">
                       ${country.description}
                   </c:when>
                </c:choose>
                </c:forEach> 
         </td>
         <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></spring:bind></td>
     </tr>

    <tr><td colspan=2 align="right">
       <input type="button" name="editmyprofile" value="<fmt:message key="jsp.button.edit" />" onclick="javascript:document.location.href='../college/student/personal.view?tab=0&panel=0&from=opusUserPortal&studentId=${studentId}'" />
    </td>
</tr>
</table>
 
    

                      
