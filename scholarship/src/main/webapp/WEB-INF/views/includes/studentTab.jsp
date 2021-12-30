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
 @Description: This script is the content for the student tab
 @Author Stelio Macumbe 16 of May 2008
--%>

<sec:authorize access="hasAnyRole('UPDATE_SCHOLARSHIP_FLAG')">
    <c:set var="updateScholarshipFlag" value="${true}"/>
</sec:authorize>

<form name="personaldata" method="POST">
    <input type="hidden" name="tab_personaldata" value="${accordion}" /> 
    <input type="hidden" name="panel_personaldata" value="0" />
    <input type="hidden" name="currentPageNumber" value="${currentPageNumber}" />

	<table>
			
	<tr>
	<td class="label">
	        <fmt:message key="jsp.general.organizationalunit" />
	</td>
	<td>${unitStudyDescription}</td>
	</tr>

          <tr>
              <td class="label"><b><fmt:message key="jsp.general.primarystudy" /></b></td>
              <td>
                  <spring:bind path="command.primaryStudyId">
                  <c:forEach var="oneStudy" items="${allStudies}">
                      <c:choose>
                          <c:when test="${oneStudy.id == status.value}">
                             ${oneStudy.studyDescription}
                          </c:when>
                       </c:choose>
                  </c:forEach>
                  </spring:bind>
              </td> 
         </tr>
         <tr>
              <td class="label"><fmt:message key="jsp.general.studentcode" /></td>
              <td><spring:bind path="command.studentCode">${status.value}</spring:bind></td>
          </tr>
		

    <tr>
     <td class="label"><fmt:message key="jsp.general.surname" /></td>
     <td><spring:bind path="command.surnameFull">
        <a href="<c:url value='/college/student/personal.view?newForm=true&studentId=${command.studentId}'/>">
            ${status.value}
        </a>
     </spring:bind>
     </td>
     
    </tr>
<%--  not needed in Mozambique, but left in the system<tr>
     <td class="label"><fmt:message key="jsp.general.aliassurname" /></td>
     <td><spring:bind path="command.surnameAlias">
      ${status.value}
     </spring:bind>
     </td>
    </tr> --%>
    <tr>
     <td class="label"><fmt:message key="jsp.general.firstnames" /></td>
     <td><spring:bind path="command.firstnamesFull">
      ${status.value}
     </spring:bind>
     </td>
    </tr>
    <tr>
     <td class="label"><fmt:message key="jsp.general.aliasfirstnames" /></td>
     <td><spring:bind path="command.firstnamesAlias">
      ${status.value}
     </spring:bind>
     </td>
    </tr>
    <tr>
     <td class="label"><fmt:message key="jsp.general.nationalregistrationnumber" /></td>
     <td><spring:bind path="command.nationalRegistrationNumber">
      ${status.value}
     </spring:bind>
     </td>
    </tr>
    <tr>
     <td class="label"><fmt:message key="jsp.general.civiltitle" /></td>
     <td><spring:bind path="command.civilTitleCode">
         <c:forEach var="civilTitle" items="${allCivilTitles}">
            <c:choose>
             <c:when test="${civilTitle.code == status.value}">
                 <option value="${civilTitle.code}" selected="selected">${civilTitle.description}</option>
             </c:when>
            </c:choose>
         </c:forEach>
     </spring:bind>
     </td>
    </tr>
    <tr>
     <td class="label"><fmt:message key="jsp.general.academictitle" /></td>
     <td><spring:bind path="command.gradeTypeCode">
         <c:forEach var="gradeType" items="${allGradeTypes}">
            <c:choose>
             <c:when test="${gradeType.code == status.value && gradeType.title != ''}">
                 <option value="${gradeType.code}" selected="selected">${gradeType.title}</option>
             </c:when>
            </c:choose>
         </c:forEach>
     </spring:bind>
     </td>
    </tr>
    <tr>
     <td class="label"><fmt:message key="jsp.general.gender" /></td>
     <td><spring:bind path="command.genderCode">
         <c:forEach var="gender" items="${allGenders}">
            <c:choose>
             <c:when test="${gender.code == status.value}">
                 <option value="${gender.code}" selected="selected">${gender.description}</option>
             </c:when>
            </c:choose>
         </c:forEach>
     </spring:bind>
     </td>
    </tr>
    <tr>
     <td class="label"><fmt:message key="jsp.general.birthdate" /></td>
     <td><spring:bind path="command.birthdate">
     <input type="hidden" id="${status.expression}" name="${status.expression}" value="${status.value}">
     <table>
         <tr>
            <td>${fn:substring(status.value,8,10)}</td>
            <td>${fn:substring(status.value,5,7)}</td>
            <td>${fn:substring(status.value,0,4)}</td>
        </tr>
     </table>
     </spring:bind>
     </td>
    </tr>
 
    <tr>
     <td class="label"><fmt:message key="jsp.general.civilstatus" /></td><td><spring:bind path="command.civilStatusCode">
         <c:forEach var="civilStatus" items="${allCivilStatuses}">
            <c:choose>
             <c:when test="${civilStatus.code == status.value}">
                 <option value="${civilStatus.code}" selected="selected">${civilStatus.description}</option>
             </c:when>
            </c:choose>
         </c:forEach>
     </spring:bind>
     </td>
    </tr>
    <tr>
     <td class="label"><fmt:message key="jsp.general.housingoncampus" /></td>
     <td>
        <fmt:message key="${stringToYesNoMap[command.housingOnCampus]}"/>
     </td>
    </tr> 
    <tr>
            <td class="label"><fmt:message key="jsp.general.nationality" /></td>
            <td>
                <spring:bind path="command.nationalityCode">
                    <c:forEach var="nationality" items="${allNationalities}">
                     <c:choose>
                        <c:when test="${status.value == null || status.value == ''}">
                            <c:choose>
                               <c:when test="${nationality.code == iNationality}">
                                    ${nationality.description}
                                </c:when>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${nationality.code == status.value}">
                                     ${nationality.description}
                                 </c:when>
                             </c:choose>
                         </c:otherwise>
                     </c:choose>
               </c:forEach>
      </spring:bind>
      </td>
      </tr>
      <tr>
          <td class="label"><fmt:message key="jsp.general.countryofbirth" /></td>
          <td><spring:bind path="command.countryOfBirthCode">
        <c:forEach var="country" items="${allCountries}">
	        <c:choose>
               <c:when test="${((countryOfBirthCode == null || countryOfBirthCode == '') && country.code == status.value) || ((countryOfBirthCode != null && countryOfBirthCode != '') && country.code == countryOfBirthCode)}">
                   ${country.description}
               </c:when>
             </c:choose>
		</c:forEach> 
		      </spring:bind>
		      </td>
	</tr>
    <tr>
        <td class="label"><fmt:message key="jsp.general.provinceofbirth" /></td>
        <td><spring:bind path="command.provinceOfBirthCode">
            <c:forEach var="provinceOfBirth" items="${allProvincesOfBirth}">
               <c:choose>
                <c:when test="${((provinceOfBirthCode == null || provinceOfBirthCode == '') && provinceOfBirth.code == status.value) ||((provinceOfBirthCode != null && provinceOfBirthCode != '') && provinceOfBirth.code == provinceOfBirthCode) }">
                    ${provinceOfBirth.description}
                </c:when>
               </c:choose>
            </c:forEach> 
      </spring:bind>
      </td>
    </tr>
    <tr>
        <td class="label"><fmt:message key="jsp.general.districtofbirth" /></td>
        <td><spring:bind path="command.districtOfBirthCode">
            <c:forEach var="districtOfBirth" items="${allDistrictsOfBirth}">
               <c:choose>
                <c:when test="${((districtOfBirthCode == null || districtOfBirthCode == '') && districtOfBirth.code == status.value) || ((districtOfBirthCode != null && districtOfBirthCode != '') && districtOfBirth.code == districtOfBirthCode)}">
                    ${districtOfBirth.description}
                </c:when>
               </c:choose>
            </c:forEach> 
      </spring:bind>
      </td>
    </tr>
      <tr>
             <td class="label"><fmt:message key="jsp.general.placeofbirth" /></td>
             <td><spring:bind path="command.placeOfBirth">
      ${status.value}
     </spring:bind>
     </td>
         </tr>

          <tr>
              <td class="label"><fmt:message key="jsp.general.identificationtype" /></td>
              <td><spring:bind path="command.identificationTypeCode">
                  <c:forEach var="identificationType" items="${allIdentificationTypes}">
                     <c:choose>
                      <c:when test="${identificationType.code == status.value}">
                          ${identificationType.description}
                      </c:when>
                     </c:choose>
                  </c:forEach>
            </spring:bind>
            </td>
          </tr>
          <tr>
            <td class="label"><fmt:message key="jsp.general.identificationnumber" /></td>
     <td><spring:bind path="command.identificationNumber">
      ${status.value}
     </spring:bind>
     </td>
  </tr>
  <tr>
      <td class="label"><fmt:message key="jsp.general.placeofissue" /></td>
      <td><spring:bind path="command.identificationPlaceOfIssue">
      ${status.value}
     </spring:bind>
     </td>
  </tr>
  <tr>
      <td class="label"><fmt:message key="jsp.general.dateofissue" /></td>
      <td><spring:bind path="command.identificationDateOfIssue">
      <table>
          <tr>
            <td>${fn:substring(status.value,8,10)}</td>
            <td>${fn:substring(status.value,5,7)}</td>
            <td>${fn:substring(status.value,0,4)}</td>
        </tr>
      </table>
    </spring:bind>
    </td>
  </tr>
  <tr>
      <td class="label"><fmt:message key="jsp.general.dateofexpiration" /></td>
      <td><spring:bind path="command.identificationDateOfExpiration">
      <table>
          <tr>
            <td>${fn:substring(status.value,8,10)}</td>
            <td>${fn:substring(status.value,5,7)}</td>
            <td>${fn:substring(status.value,0,4)}</td>
        </tr>
      </table>
    </spring:bind>
    </td>
   </tr>
   <tr>
        <td class="label"><fmt:message key="jsp.general.professiondescription" /></td>
        <td>
        <spring:bind path="command.professionDescription">
      ${status.value}
     </spring:bind>
     </td>
    </tr>
    <tr>
     <td class="label"><fmt:message key="jsp.general.active" /></td>
     <td>
        <fmt:message key="${stringToYesNoMap[command.active]}"/>
     </td>
     </tr>
   <tr>
        <td class="label"><fmt:message key="jsp.general.remarks" /></td>
        <td>
        <spring:bind path="command.remarks"> 
        ${status.value}
        </spring:bind>
        </td>
    </tr> 
    
    <tr><td colspan="2">&nbsp;</td></tr>

    <tr>
        <td class="label"><fmt:message key="jsp.general.scholarship.appliedfor" /></td>
        <c:choose>
            <c:when test="${updateScholarshipFlag}">
                <spring:bind path="command.scholarship">
                    <td>
                       <select name="${status.expression}" id="${status.expression}">
                          <c:choose>
                              <c:when test="${'Y' == status.value}">
                                  <option value="Y" selected="selected"><fmt:message key="jsp.general.yes" /></option>
                                  <option value="N"><fmt:message key="jsp.general.no" /></option>
                              </c:when>
                              <c:otherwise>
                                  <option value="Y"><fmt:message key="jsp.general.yes" /></option>
                                  <option value="N" selected="selected"><fmt:message key="jsp.general.no" /></option>
                              </c:otherwise>
                             </c:choose>
                      </select>
                    </td>
                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                </spring:bind>
            </c:when>
            <c:otherwise>
                <td>
                    <fmt:message key="${stringToYesNoMap[status.value]}"/>
                </td>
            </c:otherwise>
        </c:choose>
    </tr>
     
        
            <tr>
            <td>&nbsp;</td>
            <td>
                <input type="button" name="submitpersonaldata" value="<fmt:message key="jsp.button.submit" />" 
                        onclick="javascript:checkScholarshipAppliedFor(document.getElementById('scholarship').value,'${deleteScholarshipDataText}');document.personaldata.submit();" />
            </td>
        </tr>   
    </table>

</form>

