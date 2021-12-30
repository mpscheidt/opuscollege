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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://jawr.net/tags" prefix="jwr" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<%-- AUTHORIZATIONS --%>

<sec:authorize access="hasRole('READ_STUDENT_MEDICAL_DATA')">
    <c:set var="readMedicalData" value="${true}"/>
</sec:authorize>

<sec:authorize access="hasRole('UPDATE_STUDENT_MEDICAL_DATA')">
    <c:set var="updateMedicalData" value="${true}"/>
</sec:authorize>

<sec:authorize access="hasAnyRole('CREATE_IDENTIFICATION_DATA','UPDATE_IDENTIFICATION_DATA') or ${personId == opusUser.personId}">
    <c:set var="editIdentificationData" value="${true}"/>
</sec:authorize>

<c:if test="${not editIdentificationData}">
    <sec:authorize access="hasRole('READ_IDENTIFICATION_DATA')">
        <c:set var="showIdentificationData" value="${true}"/>
    </sec:authorize>
</c:if>

<div class="AccordionPanel">
 <div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.general.details" /></div>
 <div class="AccordionPanelContent">

    <%@ include file="organization.jsp"%> 

    <table>

        <tr>
            <td class="label"><fmt:message key="jsp.general.staffmembercode" /></td>
            <spring:bind path="staffMember.staffMemberCode">
            <td><input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}"/>" /></td>
            <td>
                <fmt:message key="jsp.general.message.codegenerated" />
                <c:forEach var="error" items="${status.errorMessages}"><span class="error"><c:out value="${error}"/></span></c:forEach>
            </td>
            </spring:bind>
        </tr>

        <c:choose>
            <c:when test="${showStaffMemberError != null && showStaffMemberError != ''}">
               <tr>
                   <td colspan="3" class="error">
                       <c:out value="${showStaffMemberError}"/>
                   </td>
               </tr>
           </c:when>
        </c:choose>

        <spring:bind path="staffMember.surnameFull">
             <tr>
                <td class="label"><fmt:message key="jsp.general.surname" /></td>
                <c:if test="${editPersonalData}">
                    <td class="required"><input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
                </c:if>
                <c:if test="${showPersonalData}">
                    <td><c:out value="${status.value}"/></td>
                </c:if>
                <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
            </tr>
        </spring:bind>
 
        <%--  not needed in Mozambique, but left in the system<tr>
             <td class="label"><fmt:message key="jsp.general.aliassurname" /></td>
             <td><spring:bind path="staffMember.surnameAlias"><input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
             <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></spring:bind></td>
         </tr> --%>
        <spring:bind path="staffMember.firstnamesFull">
            <tr>
                <td class="label"><fmt:message key="jsp.general.firstnames" /></td>
                <c:if test="${editPersonalData}">
                      <td class="required"><input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
                </c:if>
                <c:if test="${showPersonalData}">
                    <td><c:out value="${status.value}"/></td>
                </c:if>
                <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
            </tr>
        </spring:bind>


        <spring:bind path="staffMember.firstnamesAlias">
            <tr>
                <td class="label"><fmt:message key="jsp.general.aliasfirstnames" /></td>
                <c:if test="${editPersonalData}">
                    <td><input type="text" name="${status.expression}" size="40" value='<c:out value="${status.value}"/>' /></td>
                </c:if>
                <c:if test="${showPersonalData}">
                    <td><c:out value="${status.value}"/></td>
                </c:if>
                <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
            </tr>
        </spring:bind>

        <spring:bind path="staffMember.nationalRegistrationNumber">
            <tr>
              <td class="label"><fmt:message key="jsp.general.nationalregistrationnumber" /></td>
              <c:if test="${editIdentificationData}">
                <td><input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
                <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
              </c:if>
              <c:if test="${showIdentificationData}">
                <td><c:out value="${status.value}"/></td>
              </c:if>
            </tr>
        </spring:bind>

<%--        <spring:bind path="staffMember.civilTitleCode">
            <% request.setAttribute("label", "jsp.general.civiltitle"  ); %>
            <% request.setAttribute("allLookups", request.getAttribute("allCivilTitles") ); %>
            <jsp:include page="/WEB-INF/views/includes/dropdown.jsp" flush="true" />
        </spring:bind> --%>

        <tr>
            <td class="label"><fmt:message key="jsp.general.civiltitle" /></td>
            <c:if test="${editPersonalData}">
                <td>
                    <form:select path="staffMember.civilTitleCode">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <form:options items="${staffMemberForm.allCivilTitles}" itemValue="code" itemLabel="description"/>
                    </form:select>
                </td>
                <td><form:errors path="staffMember.civilTitleCode" cssClass="error"/></td>
            </c:if>
            <c:if test="${showPersonalData}">
                <td>
                    <c:out value="${staffMemberForm.codeToCivilTitleMap[staffMemberForm.staffMember.civilTitleCode].description}"/>
                </td>
            </c:if>
        </tr>

        <spring:bind path="staffMember.gradeTypeCode">
            <tr>
                <td class="label"><fmt:message key="jsp.general.academictitle" /></td>
                <c:if test="${editPersonalData}">
                   <td>
                        <select name="${status.expression}">
                            <option value="0"><fmt:message key="jsp.selectbox.choose.ifapplicable" /></option>
                            <c:forEach var="gradeType" items="${staffMemberForm.allGradeTypes}">
                                <c:choose>
                                 <c:when test="${gradeType.code == status.value && gradeType.title != ''}">
                                     <option value="${gradeType.code}" selected="selected"><c:out value="${gradeType.title}"/></option>
                                 </c:when>
                                 <c:otherwise>
                                    <c:choose>
                                        <c:when test="${gradeType.title != ''}">
                                            <option value="${gradeType.code}"><c:out value="${gradeType.title}"/></option>
                                        </c:when>
                                    </c:choose>
                                 </c:otherwise>
                                </c:choose>
                             </c:forEach>
                        </select>
                    </td>
                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
               </c:if>
               <c:if test="${showPersonalData}">
                    <c:forEach var="gradeType" items="${staffMemberForm.allGradeTypes}">
                        <c:choose>
                            <c:when test="${gradeType.code == status.value && gradeType.title != ''}">
                                <td><c:out value="${gradeType.title}"/></td>
                            </c:when>
                        </c:choose>
                    </c:forEach>
                    <td></td>
                </c:if>
                
            </tr>
        </spring:bind>

<%--        <spring:bind path="staffMember.genderCode">
            <% request.setAttribute("label", "jsp.general.gender"  ); %>
            <% request.setAttribute("allLookups", request.getAttribute("allGenders") ); %>
            <jsp:include page="/WEB-INF/views/includes/dropdownRequired.jsp" flush="true" />
        </spring:bind> --%>
        
        <tr>
            <td class="label"><fmt:message key="jsp.general.gender" /></td>
            <c:if test="${editPersonalData}">
                <td class="required">
                    <form:select path="staffMember.genderCode">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <form:options items="${staffMemberForm.allGenders}" itemValue="code" itemLabel="description"/>
                    </form:select>
                </td>
                <td><form:errors path="staffMember.genderCode" cssClass="error"/></td>
            </c:if>
            <c:if test="${showPersonalData}">
                <td>
                    <c:out value="${staffMemberForm.codeToGenderMap[staffMemberForm.staffMember.genderCode].description}"/>
                </td>
            </c:if>
        </tr>

        <spring:bind path="staffMember.birthdate">
            <tr>
                <td class="label"><fmt:message key="jsp.general.birthdate" /></td>
                <td class="required">
                    <table>
                    <tr>
                        <td><fmt:message key="jsp.general.day" /></td>
                        <td><fmt:message key="jsp.general.month" /></td>
                        <td><fmt:message key="jsp.general.year" /></td>
                    </tr>
                    <c:if test="${editPersonalData || personId == opusUser.personId}">
                        <tr>
                            <td><input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                                <input class="numericField" type="text" id="birth_day" name="birth_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />"  onchange="updateFullDate('staffMember.birthdate','day',document.getElementById('birth_day').value);"  /></td>
                            <td><input class="numericField" type="text" id="birth_month" name="birth_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('staffMember.birthdate','month',document.getElementById('birth_month').value);" /></td>
                            <td><input class="numericField" type="text" id="birth_year" name="birth_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />"  onchange="updateFullDate('staffMember.birthdate','year',document.getElementById('birth_year').value);" /></td>
                        </tr>
                    </c:if>
                    <c:if test="${showPersonalData && personId != opusUser.personId}">
                        <tr>
                            <td>${fn:substring(status.value,8,10)}</td>
                            <td>${fn:substring(status.value,5,7)}</td>
                            <td>${fn:substring(status.value,0,4)}</td>
                        </tr>
                    </c:if>
                    </table>
                </td>
                <c:if test="${editPersonalData || personId == opusUser.personId}">
                    <td>
                        <fmt:message key="jsp.general.message.dateformat" />
                        <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                    </td>
                </c:if>
                <c:if test="${showPersonalData && personId != opusUser.personId}">
                    <td>&nbsp;</td>
                </c:if>
            </tr>
        </spring:bind>

<%--        <spring:bind path="staffMember.civilStatusCode">
            <% request.setAttribute("label", "jsp.general.civilstatus"  ); %>
            <% request.setAttribute("allLookups", request.getAttribute("allCivilStatuses") ); %>
            <jsp:include page="/WEB-INF/views/includes/dropdown.jsp" flush="true" />
        </spring:bind> --%>

        <tr>
            <td class="label"><fmt:message key="jsp.general.civilstatus" /></td>
            <c:if test="${editPersonalData}">
                <td>
                    <form:select path="staffMember.civilStatusCode">
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <form:options items="${staffMemberForm.allCivilStatuses}" itemValue="code" itemLabel="description"/>
                    </form:select>
                </td>
                <td><form:errors path="staffMember.civilStatusCode" cssClass="error"/></td>
            </c:if>
            <c:if test="${showPersonalData}">
                <td>
                    <c:out value="${staffMemberForm.codeToCivilStatusMap[staffMemberForm.staffMember.civilStatusCode].description}"/>
                </td>
            </c:if>
        </tr>

        <spring:bind path="staffMember.housingOnCampus">
            <tr>
                <td class="label"><fmt:message key="jsp.general.housingoncampus" /></td>
                <c:if test="${editPersonalData}">
                    <td>
                        <select name="${status.expression}">
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
                </c:if>
                <c:if test="${showPersonalData}">
                    <c:choose>
                        <c:when test="${'Y' == status.value}">
                            <td><fmt:message key="jsp.general.yes" /></td>
                        </c:when>
                        <c:otherwise>
                            <td><fmt:message key="jsp.general.no" /></td>
                        </c:otherwise>
                    </c:choose>
                    <td></td>
                </c:if>
            </tr>
        </spring:bind>

        <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>
            <c:if test="${editPersonalData || personId == opusUser.personId}">
<%--                 <input type="button" name="submitpersonaldata" value="<fmt:message key="jsp.button.submit" />" onclick="document.getElementById('submitFormObject_personaldata').value='true';document.formdata.submit();" /> --%>
                <input type="submit" name="submitpersonaldata" value="<fmt:message key="jsp.button.submit" />" />
            </c:if>
            </td>
        </tr>
   </table>
<%--        </form> --%>
 </div> <!-- end accordionpanelcontent -->
</div> <!-- end accordionpanel -->

<!--  background -->
<!--  show when person already exists, not while new -->
<c:choose>
    <c:when test="${(staffMemberName != null && staffMemberName != '') || (studentName != null && studentName != '')}">
        <div class="AccordionPanel">
         <div class="AccordionPanelTab"><fmt:message key="jsp.general.background" /></div>
         <div class="AccordionPanelContent">
<%--        <form name="backgrounddata" method="post">
            <input type="hidden" name="tab_personaldata" value="0" /> 
            <input type="hidden" name="panel_background" value="1" />
            <input type="hidden" name="submitFormObject_backgrounddata" id="submitFormObject_backgrounddata" value="" /> --%>

            <table>
                <tr>
                    <spring:bind path="staffMember.nationalityCode">
                        <td class="label"><fmt:message key="jsp.general.nationality" /></td>
                        <td>
                            <c:if test="${editPersonalData}">
                                <select name="${status.expression}">
                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                    <c:forEach var="nationality" items="${staffMemberForm.allNationalities}">
                                        <c:choose>
                                            <c:when test="${status.value != null && status.value != '' && nationality.code == status.value}">
                                                <option value="${nationality.code}" selected="selected"><c:out value="${nationality.description}"/></option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="${nationality.code}"><c:out value="${nationality.description}"/></option>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </select>
                            </c:if>
                            <c:if test="${showPersonalData}">
                                <c:forEach var="nationality" items="${staffMemberForm.allNationalities}">
                                    <c:choose>
                                        <c:when test="${status.value != null && status.value != '' && nationality.code == status.value}">
                                            <c:out value="${nationality.description}"/>
                                        </c:when>
                                    </c:choose>
                                </c:forEach>
                            </c:if>
                        </td>
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                    </spring:bind>
                </tr>

                <tr>
                    <spring:bind path="staffMember.countryOfBirthCode">
                        <td class="label"><fmt:message key="jsp.general.countryofbirth" /></td>
                        <c:if test="${editPersonalData}">
                            <td>
                                <select name="${status.expression}" id="${status.expression}" onchange="document.getElementById('submitter').value=this.id;this.form.submit();">
                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                    <c:forEach var="country" items="${staffMemberForm.allCountries}">
                                        <c:choose>
                                            <c:when test="${status.value != null && status.value != '' && country.code == status.value}">
                                                    <option value="${country.code}" selected="selected"><c:out value="${country.description}"/></option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="${country.code}"><c:out value="${country.description}"/></option>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach> 
                                </select>
                            </td>
                        </c:if>
                        <c:if test="${showPersonalData}">
                            <c:forEach var="country" items="${staffMemberForm.allCountries}">
                                <c:choose>
                                    <c:when test="${status.value != null && status.value != '' && country.code == status.value}">
                                        <td><c:out value="${country.description}"/></td>
                                    </c:when>
                                </c:choose>
                            </c:forEach> 
                         </c:if>
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                    </spring:bind>
                </tr>

                <tr>  
                    <spring:bind path="staffMember.provinceOfBirthCode">
                        <td class="label"><fmt:message key="jsp.general.provinceofbirth" /></td>
                        <c:if test="${editPersonalData}">
                            <td>
                            <select name="${status.expression}" id="${status.expression}" onchange="document.getElementById('submitter').value=this.id;this.form.submit();">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <c:forEach var="provinceOfBirth" items="${staffMemberForm.allProvincesOfBirth}">
                                    <c:choose>
                                    <c:when test="${((provinceOfBirthCode == null || provinceOfBirthCode == '') && provinceOfBirth.code == status.value) ||((provinceOfBirthCode != null && provinceOfBirthCode != '') && provinceOfBirth.code == provinceOfBirthCode) }">
                                        <option value="${provinceOfBirth.code}" selected="selected"><c:out value="${provinceOfBirth.description}"/></option>
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${((provinceOfBirthCode == null || provinceOfBirthCode == '') && provinceOfBirth.code != status.value) ||((provinceOfBirthCode != null && provinceOfBirthCode != '') && provinceOfBirth.code != provinceOfBirthCode) }">
                                                <option value="${provinceOfBirth.code}"><c:out value="${provinceOfBirth.description}"/></option>
                                            </c:when>
                                        </c:choose>
                                    </c:otherwise>
                                    </c:choose>
                                </c:forEach> 
                            </select>
                            </td>
                        </c:if>
                        <c:if test="${showPersonalData}">
                            <c:forEach var="provinceOfBirth" items="${staffMemberForm.allProvincesOfBirth}">
                                <c:choose>
                                <c:when test="${((provinceOfBirthCode == null || provinceOfBirthCode == '') && provinceOfBirth.code == status.value) ||((provinceOfBirthCode != null && provinceOfBirthCode != '') && provinceOfBirth.code == provinceOfBirthCode) }">
                                    <td><c:out value="${provinceOfBirth.description}"/></td>
                                </c:when>
                                </c:choose>
                            </c:forEach> 
                        </c:if>
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                    </spring:bind>
                </tr>

                <tr>
                    <spring:bind path="staffMember.districtOfBirthCode">
                        <td class="label"><fmt:message key="jsp.general.districtofbirth" /></td>
                        <c:if test="${editPersonalData}">
                           <td>
                            <select name="${status.expression}" id="${status.expression}" onchange="this.form.submit();">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <c:forEach var="districtOfBirth" items="${staffMemberForm.allDistrictsOfBirth}">
                                    <c:choose>
                                    <c:when test="${((districtOfBirthCode == null || districtOfBirthCode == '') && districtOfBirth.code == status.value) || ((districtOfBirthCode != null && districtOfBirthCode != '') && districtOfBirth.code == districtOfBirthCode)}">
                                        <option value="${districtOfBirth.code}" selected="selected"><c:out value="${districtOfBirth.description}"/></option>
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${((districtOfBirthCode == null || districtOfBirthCode == '') && districtOfBirth.code != status.value) || ((districtOfBirthCode != null && districtOfBirthCode != '') && districtOfBirth.code != districtOfBirthCode)}">
                                                <option value="${districtOfBirth.code}"><c:out value="${districtOfBirth.description}"/></option>
                                            </c:when>
                                        </c:choose>
                                    </c:otherwise>
                                    </c:choose>
                                </c:forEach> 
                            </select>
                            </td>
                         </c:if>
                        <c:if test="${showPersonalData}">
                            <c:forEach var="districtOfBirth" items="${staffMemberForm.allDistrictsOfBirth}">
                                <c:choose>
                                <c:when test="${((districtOfBirthCode == null || districtOfBirthCode == '') && districtOfBirth.code == status.value) || ((districtOfBirthCode != null && districtOfBirthCode != '') && districtOfBirth.code == districtOfBirthCode)}">
                                    <td><c:out value="${districtOfBirth.description}"/></td>
                                </c:when>
                                </c:choose>
                            </c:forEach> 
                        </c:if>
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                    </spring:bind>
                </tr>

                <tr>                
                    <spring:bind path="staffMember.placeOfBirth">
                        <td class="label"><fmt:message key="jsp.general.placeofbirth" /></td>
                        <c:if test="${editPersonalData}">
                            <td><input type="text" name="${status.expression}" size="40" value='<c:out value="${status.value}"/>' /></td>
                        </c:if>
                        <c:if test="${showPersonalData}">
                            <td><c:out value="${status.value}"/></td>
                        </c:if>
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                    </spring:bind>
                </tr>

                <tr>
                    <spring:bind path="staffMember.countryOfOriginCode">
                        <td class="label"><fmt:message key="jsp.general.countryoforigin" /></td>
                        <c:if test="${editPersonalData}">
                            <td>
                            <select name="${status.expression}" id="${status.expression}" onchange="document.getElementById('submitter').value=this.id;this.form.submit();">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <c:forEach var="country" items="${staffMemberForm.allCountries}">
                                    <c:choose>
                                    <c:when test="${status.value != null && status.value != '' && country.code == status.value}">
                                            <option value="${country.code}" selected="selected"><c:out value="${country.description}"/></option>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="${country.code}"><c:out value="${country.description}"/></option>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach> 
                            </select>
                            </td>
                       </c:if>
                        <c:if test="${showPersonalData}">
                            <c:forEach var="country" items="${staffMemberForm.allCountries}">
                                <c:choose>
                                    <c:when test="${status.value != null && status.value != '' && country.code == status.value}">
                                        <td><c:out value="${country.description}"/></td>
                                    </c:when>
                                </c:choose>
                            </c:forEach> 
                        </c:if>
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                    </spring:bind>
                </tr>

                <tr>                  
                    <spring:bind path="staffMember.provinceOfOriginCode">
                        <td class="label"><fmt:message key="jsp.general.provinceoforigin" /></td>
                        <c:if test="${editPersonalData}">
                            <td>
                            <select name="${status.expression}" id="${status.expression}" onchange="document.getElementById('submitter').value=this.id;this.form.submit();">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <c:forEach var="provinceOfOrigin" items="${staffMemberForm.allProvincesOfOrigin}">
                                    <c:choose>
                                        <c:when test="${((provinceOfOriginCode == null || provinceOfOriginCode == '') && provinceOfOrigin.code == status.value) ||((provinceOfOriginCode != null && provinceOfOriginCode != '') && provinceOfOrigin.code == provinceOfOriginCode) }">
                                            <option value="${provinceOfOrigin.code}" selected="selected"><c:out value="${provinceOfOrigin.description}"/></option>
                                        </c:when>
                                        <c:otherwise>
                                        <c:choose>
                                            <c:when test="${((provinceOfOriginCode == null || provinceOfOriginCode == '') && provinceOfOrigin.code != status.value) ||((provinceOfOriginCode != null && provinceOfOriginCode != '') && provinceOfOrigin.code != provinceOfOriginCode) }">
                                                <option value="${provinceOfOrigin.code}"><c:out value="${provinceOfOrigin.description}"/></option>
                                            </c:when>
                                        </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </select>
                            </td>
                        </c:if>
                        <c:if test="${showPersonalData}">
                            <c:forEach var="provinceOfOrigin" items="${staffMemberForm.allProvincesOfOrigin}">
                                <c:choose>
                                    <c:when test="${((provinceOfOriginCode == null || provinceOfOriginCode == '') && provinceOfOrigin.code == status.value) ||((provinceOfOriginCode != null && provinceOfOriginCode != '') && provinceOfOrigin.code == provinceOfOriginCode) }">
                                        <td><c:out value="${provinceOfOrigin.description}"/></td>
                                    </c:when>
                                </c:choose>
                            </c:forEach>
                        </c:if>
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                    </spring:bind>
                </tr>

                <tr>              
                    <spring:bind path="staffMember.districtOfOriginCode">
                        <td class="label"><fmt:message key="jsp.general.districtoforigin" /></td>
                        <c:if test="${editPersonalData}">
                            <td>
                                <select name="${status.expression}" id="${status.expression}" onchange="document.getElementById('submitter').value=this.id;this.form.submit();">
                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                    <c:forEach var="districtOfOrigin" items="${staffMemberForm.allDistrictsOfOrigin}">
                                        <c:choose>
                                            <c:when test="${((districtOfOriginCode == null || districtOfOriginCode == '') && districtOfOrigin.code == status.value) || ((districtOfOriginCode != null && districtOfOriginCode != '') && districtOfOrigin.code == districtOfOriginCode)}">
                                                <option value="${districtOfOrigin.code}" selected="selected"><c:out value="${districtOfOrigin.description}"/></option>
                                            </c:when>
                                            <c:otherwise>
                                            <c:choose>
                                                <c:when test="${((districtOfOriginCode == null || districtOfOriginCode == '') && districtOfOrigin.code != status.value) || ((districtOfOriginCode != null && districtOfOriginCode != '') && districtOfOrigin.code != districtOfOriginCode)}">
                                                    <option value="${districtOfOrigin.code}"><c:out value="${districtOfOrigin.description}"/></option>
                                                </c:when>
                                            </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach> 
                                </select>
                            </td>
                        </c:if>
                        <c:if test="${showPersonalData}">
                            <c:forEach var="districtOfOrigin" items="${staffMemberForm.allDistrictsOfOrigin}">
                                <c:choose>
                                    <c:when test="${((districtOfOriginCode == null || districtOfOriginCode == '') && districtOfOrigin.code == status.value) || ((districtOfOriginCode != null && districtOfOriginCode != '') && districtOfOrigin.code == districtOfOriginCode)}">
                                        <td><c:out value="${districtOfOrigin.description}"/></td>
                                    </c:when>
                                </c:choose>
                            </c:forEach> 
                        </c:if>
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                      </spring:bind>
                  </tr>

                <tr>                
                    <spring:bind path="staffMember.cityOfOrigin">
                        <td class="label"><fmt:message key="jsp.general.cityoforigin" /></td>
                            <c:if test="${editPersonalData}">
                                <td><input type="text" name="${status.expression}" size="40" value='<c:out value="${status.value}"/>' /></td>
                             </c:if>
                             <c:if test="${showPersonalData}">
                                <td><c:out value="${status.value}"/></td>
                            </c:if>
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                    </spring:bind>
                </tr>

                <tr>
                    <td class="label">&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>
                    <c:if test="${editPersonalData}">
<%--                     <input type="button" name="submitbackgrounddata" value="<fmt:message key="jsp.button.submit" />" onclick="document.getElementById('submitFormObject_backgrounddata').value='true';document.backgrounddata.submit();" /> --%>
                    <input type="submit" id="submitbackgrounddata" name="submitbackgrounddata" value="<fmt:message key="jsp.button.submit" />" />
                    </c:if>
                    </td>
                </tr>
            </table>
<%--          </form> --%>
         </div> <!-- einde accordionpanelcontent -->
        </div> <!-- einde accordionpanel -->
    </c:when>
</c:choose>


<!-- identification -->
<c:if test="${(staffMemberName != null && staffMemberName != '')}">
    <div class="AccordionPanel">
     <div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.general.identification" /></div>
     <div class="AccordionPanelContent">
<%--           <form name="identificationdata" method="post">
               <input type="hidden" name="tab_personaldata" value="0" /> 
               <input type="hidden" name="panel_identification" value="2" />
               <input type="hidden" name="submitFormObject_identificationdata" id="submitFormObject_identificationdata" value="" /> --%>
            
        <table>
            <c:if test="${editIdentificationData}">
<%--                <spring:bind path="staffMember.identificationTypeCode">
                    <% request.setAttribute("label", "jsp.general.identificationtype"  ); %>
                    <% request.setAttribute("allLookups", request.getAttribute("allIdentificationTypes") ); %>
                    <jsp:include page="/WEB-INF/views/includes/dropdownRequired.jsp" flush="true" />
                </spring:bind> --%>

                <tr>
                    <td class="label"><fmt:message key="jsp.general.identificationtype" /></td>
                    <c:if test="${editPersonalData}">
                        <td class="required">
                            <form:select path="staffMember.identificationTypeCode">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <form:options items="${staffMemberForm.allIdentificationTypes}" itemValue="code" itemLabel="description"/>
                            </form:select>
                        </td>
                        <td><form:errors path="staffMember.identificationTypeCode" cssClass="error"/></td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <td>
                            <c:out value="${staffMemberForm.codeToIdentificationTypeMap[staffMemberForm.staffMember.identificationTypeCode].description}"/>
                        </td>
                    </c:if>
                </tr>

                <spring:bind path="staffMember.identificationNumber">
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.identificationnumber" /></td>
                        <td class="required">
                            <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
                        </td>
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                   </tr>
                </spring:bind>

                <spring:bind path="staffMember.identificationPlaceOfIssue">
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.placeofissue" /></td>
                        <td><input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                    </tr>
                </spring:bind>

                <spring:bind path="staffMember.identificationDateOfIssue">
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.dateofissue" /></td>
                        <td>
                            <table>
                                <tr>
                                    <td><fmt:message key="jsp.general.day" /></td>
                                    <td><fmt:message key="jsp.general.month" /></td>
                                    <td><fmt:message key="jsp.general.year" /></td>
                                </tr>
                                <tr>
                                    <td><input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}" />" />
                                        <input type="text" id="identification_issue_day" name="identification_issue_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('identificationDateOfIssue','day',document.getElementById('identification_issue_day').value);" /></td>
                                    <td><input type="text" id="identification_issue_month" name="identification_issue_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('identificationDateOfIssue','month',document.getElementById('identification_issue_month').value);" /></td>
                                    <td><input type="text" id="identification_issue_year" name="identification_issue_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('identificationDateOfIssue','year',document.getElementById('identification_issue_year').value);" /></td>
                                </tr>
                            </table>
                        </td>
                        <td>
                            <fmt:message key="jsp.general.message.dateformat" />
                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                        </td>
                    </tr>
                </spring:bind>

                <spring:bind path="staffMember.identificationDateOfExpiration">
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.dateofexpiration" /></td>
                        <td>
                            <table>
                                <tr>
                                    <td><fmt:message key="jsp.general.day" /></td>
                                    <td><fmt:message key="jsp.general.month" /></td>
                                    <td><fmt:message key="jsp.general.year" /></td>
                                </tr>
                                <tr>
                                    <td><input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}"/>" />
                                        <input type="text" id="identification_expiration_day" name="identification_expiration_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('identificationDateOfExpiration','day',document.getElementById('identification_expiration_day').value);" /></td>
                                    <td><input type="text" id="identification_expiration_month" name="identification_expiration_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('identificationDateOfExpiration','month',document.getElementById('identification_expiration_month').value);" /></td>
                                    <td><input type="text" id="identification_expiration_year" name="identification_expiration_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('identificationDateOfExpiration','year',document.getElementById('identification_expiration_year').value);" /></td>
                                </tr>
                            </table>
                        </td>
                        <td>
                          <fmt:message key="jsp.general.message.dateformat" />
                          <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                        </td>
                    </tr>
                </spring:bind>

                <tr>
                    <td class="label">&nbsp;</td>
                    <td>&nbsp;</td>
<%--                     <td><input type="button" name="submitidentificationdata" value="<fmt:message key="jsp.button.submit" />" onclick="document.getElementById('submitFormObject_identificationdata').value='true';document.identificationdata.submit();" /></td> --%>
                    <td><input type="submit" name="submitidentificationdata" value="<fmt:message key="jsp.button.submit" />" /></td>
                </tr>
            </c:if>
            
            <c:if test="${showIdentificationData}">
                <tr><td colspan="2">&nbsp;</td></tr>
<%--                <spring:bind path="staffMember.identificationTypeCode">
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.identificationtype" /></td>
                        <c:forEach var="identificationType" items="${allIdentificationTypes}">
                            <c:choose>
                                <c:when test="${identificationType.code == status.value}">
                                    <td>${identificationType.description}</td>
                                </c:when>
                            </c:choose>
                        </c:forEach>
                    </tr>
                </spring:bind> --%>

                <spring:bind path="staffMember.identificationNumber">
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.identificationnumber" /></td>
                        <td><c:out value="${status.value}"/></td>
                    </tr>
                </spring:bind>

                <spring:bind path="staffMember.identificationPlaceOfIssue">
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.placeofissue" /></td>
                        <td><c:out value="${status.value}"/></td>
                    </tr>
                </spring:bind>
                
                <spring:bind path="staffMember.identificationDateOfIssue">
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.dateofissue" /></td>
                        <td>
                            <table>
                                <tr>
                                    <td>${fn:substring(status.value,8,10)}&nbsp;-</td>
                                    <td>${fn:substring(status.value,5,7)}&nbsp;-</td>
                                    <td>${fn:substring(status.value,0,4)}</td>
                                    <td><fmt:message key="jsp.general.dateformat" /></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </spring:bind>

                <spring:bind path="staffMember.identificationDateOfExpiration">
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.dateofexpiration" /></td>
                        <td>
                            <table>
                                <tr>
                                    <td>${fn:substring(status.value,8,10)}&nbsp;-</td>
                                    <td>${fn:substring(status.value,5,7)}&nbsp;-</td>
                                    <td>${fn:substring(status.value,0,4)}</td>
                                    <td><fmt:message key="jsp.general.dateformat" /></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </spring:bind>
                <tr><td colspan="2">&nbsp;</td></tr>
            </c:if>
            <c:if test="${not showIdentificationData and not editIdentificationData}">
                <tr><td><fmt:message key="general.noprivilege.toview"/></td></tr>
            </c:if>
        </table>
<%--        </form> --%>
     </div>
    </div>
</c:if>

<c:if test="${staffMemberName != null && staffMemberName != ''}">
    <div class="AccordionPanel">
     <div class="AccordionPanelTab"><fmt:message key="jsp.general.miscellaneous" /></div>
     <div class="AccordionPanelContent">
<%--        <form name="miscellaneousdata" method="post">
            <input type="hidden" name="tab_personaldata" value="0" /> 
            <input type="hidden" name="panel_miscellaneous" value="3" />
            <input type="hidden" name="submitFormObject_miscellaneousdata" id="submitFormObject_miscellaneousdata" value="" /> --%>
            
        <table>
                <%-- <tr>
                    <td class="label"><fmt:message key="jsp.general.profession" /></td>
                    <td><spring:bind path="staffMember.professionCode">
                    <select name="${status.expression}" id="${status.expression}" onchange="alterPofessionFields();" >
                        <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                        <c:forEach var="profession" items="${allProfessions}">
                           <c:choose>
                            <c:when test="${profession.code == status.value}">
                                <option value="${profession.code}" selected="selected">${profession.description}</option>
                            </c:when>
                            <c:otherwise>
                                <option value="${profession.code}">${profession.description}</option>
                            </c:otherwise>
                           </c:choose>
                        </c:forEach>
                    </select>
                    </td> 
                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                    </spring:bind>
                    </td>
                </tr>--%>
            <spring:bind path="staffMember.professionDescription">
                <tr>
                    <td class="label"><fmt:message key="jsp.general.professiondescription" /></td>
                    <c:if test="${editPersonalData}">
                        <td>
                            <input type="text" name="${status.expression}" id="${status.expression}" value="<c:out value="${status.value}" />" size="40" />
                        </td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <td><c:out value="${status.value}"/></td>
                    </c:if>
                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                </tr>
            </spring:bind>

            <spring:bind path="staffMember.languageFirstCode">
                <tr>
                    <td class="label"><fmt:message key="jsp.general.firstlanguage" /></td>
                    <c:if test="${editPersonalData}">
                         <td>
                            <select name="${status.expression}">
                                <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                <c:forEach var="language" items="${staffMemberForm.allLanguages}">
                                    <c:choose>
                                        <c:when test="${status.value != null && status.value != '' && language.code == status.value}">
                                            <option value="${language.code}" selected="selected"><c:out value="${language.description}"/></option>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="${language.code}"><c:out value="${language.description}"/></option>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </select>
                        </td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                         <c:forEach var="language" items="${staffMemberForm.allLanguages}">
                            <c:choose>
                                <c:when test="${status.value != null && status.value != '' && language.code == status.value}">
                                    <td><c:out value="${language.description}"/></td>
                                </c:when>
                            </c:choose>
                        </c:forEach>
                    </c:if>
                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                </tr>
            </spring:bind>

<%--            <spring:bind path="staffMember.languageFirstMasteringLevelCode">
                <% request.setAttribute("label", "jsp.general.firstlanguage.masteringlevel"  ); %>
                <% request.setAttribute("allLookups", request.getAttribute("allMasteringLevels") ); %>
                <jsp:include page="/WEB-INF/views/includes/dropdown.jsp" flush="true" />
            </spring:bind> --%>

            <tr>
                <td class="label"><fmt:message key="jsp.general.firstlanguage.masteringlevel" /></td>
                <c:if test="${editPersonalData}">
                    <td>
                        <form:select path="staffMember.languageFirstMasteringLevelCode">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <form:options items="${staffMemberForm.allMasteringLevels}" itemValue="code" itemLabel="description"/>
                        </form:select>
                    </td>
                    <td><form:errors path="staffMember.languageFirstMasteringLevelCode" cssClass="error"/></td>
                </c:if>
                <c:if test="${showPersonalData}">
                    <td>
                        <c:out value="${staffMemberForm.codeToMasteringLevelMap[staffMemberForm.staffMember.languageFirstMasteringLevelCode].description}"/>
                    </td>
                </c:if>
            </tr>

            <spring:bind path="staffMember.languageSecondCode">
                <tr>
                    <td class="label"><fmt:message key="jsp.general.secondlanguage" /></td>
                    <c:if test="${editPersonalData}">
                        <td>
                            <select name="${status.expression}">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <c:forEach var="language" items="${staffMemberForm.allLanguages}">
                                    <c:choose>
                                        <c:when test="${status.value != null && status.value != '' && language.code == status.value}">
                                            <option value="${language.code}" selected="selected"><c:out value="${language.description}"/></option>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="${language.code}"><c:out value="${language.description}"/></option>
                                        </c:otherwise>
                                    </c:choose>
                                 </c:forEach>
                            </select>
                        </td> 
                    </c:if>
                    <c:if test="${showPersonalData}">
                       <c:forEach var="language" items="${staffMemberForm.allLanguages}">
                        <c:choose>
                            <c:when test="${status.value != null && status.value != '' && language.code == status.value}">
                                <td><c:out value="${language.description}"/></td>
                            </c:when>
                        </c:choose>
                     </c:forEach>
                    </c:if>
                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                </tr>
            </spring:bind>

<%--            <spring:bind path="staffMember.languageSecondMasteringLevelCode">
                <% request.setAttribute("label", "jsp.general.secondlanguage.masteringlevel"  ); %>
                <% request.setAttribute("allLookups", request.getAttribute("allMasteringLevels") ); %>
                <jsp:include page="/WEB-INF/views/includes/dropdown.jsp" flush="true" />
            </spring:bind> --%>

            <tr>
                <td class="label"><fmt:message key="jsp.general.secondlanguage.masteringlevel" /></td>
                <c:if test="${editPersonalData}">
                    <td>
                        <form:select path="staffMember.languageSecondMasteringLevelCode">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <form:options items="${staffMemberForm.allMasteringLevels}" itemValue="code" itemLabel="description"/>
                        </form:select>
                    </td>
                    <td><form:errors path="staffMember.languageSecondMasteringLevelCode" cssClass="error"/></td>
                </c:if>
                <c:if test="${showPersonalData}">
                    <td>
                        <c:out value="${staffMemberForm.codeToMasteringLevelMap[staffMemberForm.staffMember.languageSecondMasteringLevelCode].description}"/>
                    </td>
                </c:if>
            </tr>

            <spring:bind path="staffMember.languageThirdCode">
                <tr>
                    <td class="label"><fmt:message key="jsp.general.thirdlanguage" /></td>
                    <c:if test="${editPersonalData}">
                        <td>
                            <select name="${status.expression}">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <c:forEach var="language" items="${staffMemberForm.allLanguages}">
                                    <c:choose>
                                        <c:when test="${status.value != null && status.value != '' && language.code == status.value}">
                                            <option value="${language.code}" selected="selected"><c:out value="${language.description}"/></option>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="${language.code}"><c:out value="${language.description}"/></option>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>  
                            </select>
                        </td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <c:forEach var="language" items="${staffMemberForm.allLanguages}">
                            <c:choose>
                                <c:when test="${language.code == status.value}">
                                    <td><c:out value="${language.description}"/></td>
                                </c:when>
                            </c:choose>
                        </c:forEach>
                    </c:if>
                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                </tr>
            </spring:bind>

            <tr>
                <td class="label"><fmt:message key="jsp.general.thirdlanguage.masteringlevel" /></td>
                <c:if test="${editPersonalData}">
                    <td>
                        <form:select path="staffMember.languageThirdMasteringLevelCode">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <form:options items="${staffMemberForm.allMasteringLevels}" itemValue="code" itemLabel="description"/>
                        </form:select>
                    </td>
                    <td><form:errors path="staffMember.languageThirdMasteringLevelCode" cssClass="error"/></td>
                </c:if>
                <c:if test="${showPersonalData}">
                    <td>
                        <c:out value="${staffMemberForm.codeToMasteringLevelMap[staffMemberForm.staffMember.languageThirdMasteringLevelCode].description}"/>
                    </td>
                </c:if>
            </tr>

            <spring:bind path="staffMember.contactPersonEmergenciesName">
                <tr>
                    <td class="label"><fmt:message key="jsp.general.contactice" /></td>
                    <c:if test="${editPersonalData}">
                         <td><input type="text" name="${status.expression}" size="40" value='<c:out value="${status.value}"/>' /></td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <td><c:out value="${status.value}"/></td>
                    </c:if>
                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                </tr>
            </spring:bind>
 
            <spring:bind path="staffMember.contactPersonEmergenciesTelephoneNumber">
                <tr>
                    <td class="label"><fmt:message key="jsp.general.contactice.telephone" /></td>
                    <c:if test="${editPersonalData}">
                        <td><input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <td><c:out value="${status.value}"/></td>
                    </c:if>
                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                </tr>
            </spring:bind>

<%--            <spring:bind path="staffMember.bloodTypeCode">
                <% request.setAttribute("label", "jsp.general.bloodtype"  ); %>
                <% request.setAttribute("allLookups", request.getAttribute("allBloodTypes") ); %>
                <jsp:include page="/WEB-INF/views/includes/dropdown.jsp" flush="true" />
            </spring:bind> --%>

            <tr>
                <td class="label"><fmt:message key="jsp.general.bloodtype" /></td>
                <c:if test="${editPersonalData}">
                    <td>
                        <form:select path="staffMember.bloodTypeCode">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <form:options items="${staffMemberForm.allBloodTypes}" itemValue="code" itemLabel="description"/>
                        </form:select>
                    </td>
                    <td><form:errors path="staffMember.bloodTypeCode" cssClass="error"/></td>
                </c:if>
                <c:if test="${showPersonalData}">
                    <td>
                        <c:out value="${staffMemberForm.codeToBloodTypeMap[staffMemberForm.staffMember.bloodTypeCode].description}"/>
                    </td>
                </c:if>
            </tr>

            <c:choose>
                <c:when test="${readMedicalData}">
                    <spring:bind path="staffMember.healthIssues">
                        <tr>
                            <td class="label"><fmt:message key="jsp.general.healthissues"/></td>
                            <c:choose>
                                <c:when test="${updateMedicalData}">
                                    <td><textarea cols="30" rows="10" name="${status.expression}"><c:out value="${status.value}"/></textarea></td>
                                </c:when>
                                <c:otherwise>
                                    <td><c:out value="${status.value}"/></td>
                                </c:otherwise>
                            </c:choose>
                            <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                        </tr>
                    </spring:bind>
                </c:when>
            </c:choose>

            <spring:bind path="staffMember.active">
                <tr>
                    <td class="label"><fmt:message key="jsp.general.active" /></td>
                    <c:if test="${editPersonalData}">
                        <td>
                            <select name="${status.expression}">
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
                    </c:if>
                    <c:if test="${showPersonalData}">
                          <c:choose>
                            <c:when test="${'Y' == status.value}">
                                <td><fmt:message key="jsp.general.yes" /></td>
                            </c:when>
                            <c:otherwise>
                                <td><fmt:message key="jsp.general.no" /></td>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                </tr>
            </spring:bind>

            <spring:bind path="staffMember.publicHomepage">
                <tr>
                    <td class="label"><fmt:message key="jsp.general.publichomepage" /></td>
                    <c:if test="${editPersonalData}">
                        <td>
                            <select name="${status.expression}">
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
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <c:choose>
                            <c:when test="${'Y' == status.value}">
                                <td><fmt:message key="jsp.general.yes" /></td>
                            </c:when>
                            <c:otherwise>
                                <td><fmt:message key="jsp.general.no" /></td>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                </tr>
            </spring:bind>

            <spring:bind path="staffMember.socialNetworks">
                 <tr>
                    <td class="label"><fmt:message key="jsp.general.socialnetworks" /></td>
                    <c:if test="${editPersonalData}">
                        <td>
                            <textarea cols="30" rows="10" name="${status.expression}"><c:out value="${status.value}"/></textarea>
                        </td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                            <td><c:out value="${status.value}"/></td>
                    </c:if>
                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                </tr>
            </spring:bind>

            <spring:bind path="staffMember.hobbies">
                <tr>
                     <td class="label"><fmt:message key="jsp.general.hobbies" /></td>
                     <c:if test="${editPersonalData}">
                       <td>
                            <textarea cols="30" rows="10" name="${status.expression}"><c:out value="${status.value}"/></textarea>
                        </td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <td><c:out value="${status.value}"/></td>
                    </c:if>
                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                </tr>
            </spring:bind>

            <tr>
                <td class="label">&nbsp;</td>
                <td>&nbsp;</td>
                <td>
                    <c:if test="${editPersonalData}">
<%--                         <input type="button" name="submitmiscellaneousdata" value="<fmt:message key="jsp.button.submit" />" onclick="document.getElementById('submitFormObject_miscellaneousdata').value='true';document.miscellaneousdata.submit();" /> --%>
                        <input type="submit" name="submitmiscellaneousdata" value="<fmt:message key="jsp.button.submit" />" />
                    </c:if>        
                </td>
            </tr>
        </table>
<%--</form> --%>
     </div> <!--  einde accordionpanelcontent -->
    </div> <!--  einde accordionpanel -->
</c:if>

<c:if test="${staffMemberName != null && staffMemberName != ''}">

    <%-- getter in Person-class, showing whether person has photo or not --%>        
    <c:set var="hasPhoto" value="${staffMemberForm.staffMember.hasPhoto}" scope="page" />

    <div class="AccordionPanel">
     <div class="AccordionPanelTab"><fmt:message key="jsp.general.photograph" /></div>
     <div class="AccordionPanelContent">

        <table>
            <tr>
                <td/>
                <td valign="top">
                    <c:if test="${hasPhoto}">
                        <c:url var="photographLink" value='/college/photographview.view?personId=${staffMemberForm.staffMember.id}&currentPageNumber=${navigationSettings.currentPageNumber}' />
                        <img src="<c:out value='${photographLink}'/>" width="100" alt="photo_${staffMemberForm.staffMember.id}" title="photo_${staffMemberForm.staffMember.id}" />
                        <c:if test="${editPersonalData or personId == opusUser.personId}">
                            <a href="<c:url value='/college/staffmember.view?deletePhotograph=true&amp;panel=4'/>"  <%-- panel needs to be set for GET method (POST works automatically --%>
                                        onclick="return confirm('<fmt:message key="jsp.photograph.delete.confirm" />')">
                                <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                            </a>
                        </c:if>
                    </c:if>
                </td>
                <td>
                    <c:if test="${hasPhoto}">
                        <table>
                            <tr><td width="80"><fmt:message key="jsp.general.width"/>:</td><td>${staffMemberForm.photographProperties.width}</td></tr>
                            <tr><td><fmt:message key="jsp.general.height"/>:</td><td>${staffMemberForm.photographProperties.height}</td></tr>
                            <tr><td><fmt:message key="jsp.general.size"/>:</td><td>${staffMemberForm.photographProperties.size}</td></tr>
                            <tr><td><fmt:message key="jsp.general.type"/>:</td><td>${staffMemberForm.photographProperties.type}</td></tr>
                        </table>
                    </c:if>
                </td>
                
            </tr>
                
            <tr><td colspan="2">&nbsp;</td></tr>
            <c:if test="${editPersonalData or personId == opusUser.personId}">
                <form:errors path="staffMember.photograph" cssClass="errorwide" element="p"/>
                
                <tr>
                    <td class="label">
                        <spring:bind path="staffMember.hasPhoto"> 
                            <c:choose>
                                <c:when test="${status.value}">
                                    <fmt:message key="jsp.href.edit" />
                                </c:when>
                                <c:otherwise>
                                     <fmt:message key="jsp.href.add" />
                                </c:otherwise>
                            </c:choose>
                        </spring:bind>
                    </td>
                    <td>
                        <form:input path="photograph" type="file"/>                                   
                    </td>
                </tr>
                <tr>
<%--                     <td colspan=2 align="right"><input type="button" name="submitphotographdata" value="<fmt:message key="jsp.button.submit" />" onclick="document.getElementById('submitFormObject_photographdata').value='true';document.photographdata.submit();" /><br /><br /></td> --%>
                    <td colspan=2 align="right"><input type="submit" name="submitphotographdata" value="<fmt:message key="jsp.button.submit" />" /><br /><br /></td>
                </tr>
<%--                </form> --%>
            </c:if>
        </table>
     </div> <!--  einde accordionpanelcontent -->
    </div>  <!--  einde accordionpanel -->
</c:if>

<c:if test="${staffMemberName != null && staffMemberName != ''}">
        
    <div class="AccordionPanel">
     <div class="AccordionPanelTab"><fmt:message key="jsp.general.remarks" /></div>
     <div class="AccordionPanelContent">
<%--        <form name="remarksdata" method="post">
            <input type="hidden" name="tab_personaldata" value="0" /> 
            <input type="hidden" name="panel_remarks" value="5" />
            <input type="hidden" name="submitFormObject_remarksdata" id="submitFormObject_remarksdata" value="" /> --%>
            
        <table>
            <spring:bind path="staffMember.remarks">
                <tr>
                    <td class="label"><fmt:message key="jsp.general.remarks" /></td>
                    <td>
                       <c:if test="${editPersonalData}">
                            <textarea cols="30" rows="10" name="${status.expression}"><c:out value="${status.value}"/></textarea>
                       </c:if>
                       <c:if test="${showPersonalData}">
                            <c:out value="${status.value}"/>
                        </c:if>
                    </td>
                    <td>
                        <c:forEach var="error" items="${status.errorMessages}">
                        <span class="error">${error}</span></c:forEach>
                    </td>
                </tr>
                <c:if test="${editPersonalData}">
                    <tr>
                        <td class="label">&nbsp;</td>
                        <td>&nbsp;</td>
<%--                         <td><input type="button" name="submitremarksdata" value="<fmt:message key="jsp.button.submit" />" onclick="document.getElementById('submitFormObject_remarksdata').value='true';document.remarksdata.submit();" /></td> --%>
                        <td><input type="submit" name="submitremarksdata" value="<fmt:message key="jsp.button.submit" />" /></td>
                    </tr>
                </c:if>
            </spring:bind>

        </table>
<%--        </form> --%>
     </div> <!--  end of accordionpanelcontent -->
    </div> <!--  end of accordionpanel -->   
</c:if>
