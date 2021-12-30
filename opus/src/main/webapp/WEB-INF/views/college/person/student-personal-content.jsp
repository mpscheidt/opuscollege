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

<%@ include file="../../includes/standardincludes.jsp"%>

<c:set var="form" value="${studentForm}" />

<c:set var="organization" value="${form.organization}" scope="page" />

<c:set var="foreignStudent" value="${student.foreignStudent}" />
<c:set var="relativeOfStaffMember" value="${student.relativeOfStaffMember}" />
<c:set var="ruralAreaOrigin" value="${student.ruralAreaOrigin}" />
<c:set var="studentActivities" value="${student.studentActivities}" scope="page" />
<c:set var="studentCareers" value="${student.studentCareers}" scope="page" />
<c:set var="studentPlacements" value="${student.studentPlacements}" scope="page" />
<c:set var="studentCounselings" value="${student.studentCounselings}" scope="page" />

<div class="AccordionPanel">
    <div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.general.details" /></div>
    <div class="AccordionPanelContent">

        <c:if test="${editPersonalData}">
            <form:form modelAttribute="studentForm" method="post">
                <%@ include file="../../includes/organization.jsp"%> 
            </form:form>
        </c:if>

        <form:form modelAttribute="studentForm.studentFormShared" method="post">
            <%-- navigationsettings.tab/panel should be in the one and only global form --%>
            <input type="hidden" name="studentFormShared.navigationSettings.tab" value="${accordion}" />
            <input type="hidden" name="studentFormShared.navigationSettings.panel" value="0" />

            <table>
<%--                                     <spring:bind path="student.primaryStudyId"> --%>
<%-- instead of the following unitStudyDescription, better start with showing read-only institution/branch/org-unit if privileges are missing for combobox selection
                                        <tr>
                                            <td class="label">
                                                <b>
                                                    <fmt:message key="jsp.general.organizationalunit" />
                                                    <fmt:message key="jsp.general.of" />
                                                    <fmt:message key="jsp.general.primarystudy" />
                                                </b>
                                            </td>
                                            <td>${unitStudyDescription}</td>
                                        </tr>
                                        <tr><td colspan="2">&nbsp;</td></tr>
--%>
                <tr>
                    <td class="label"><b><fmt:message key="jsp.general.primarystudy" /></b></td>
                    <c:if test="${editPersonalData}">
                        <td class="required">
                            <form:select path="student.primaryStudyId">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <c:forEach var="oneStudy" items="${studentForm.allStudies}">
                                    <c:set var="optionText"><c:out value="${oneStudy.studyDescription} (${studentForm.idToOrganizationalUnitMap[oneStudy.organizationalUnitId].organizationalUnitDescription})"/></c:set>
                                    <form:option value="${oneStudy.id}">${optionText}</form:option>
                                </c:forEach>
                            </form:select>
                        </td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <td>
                            <c:forEach var="oneStudy" items="${studentForm.allStudies}">
                                <c:if test="${oneStudy.id == student.primaryStudyId}">
                                    <c:out value="${oneStudy.studyDescription}"/>
                                </c:if>
                            </c:forEach>
                        </td>
                    </c:if>
                    <td><form:errors cssClass="error" path="student.primaryStudyId"/></td>
                </tr>
                <!-- select secondaryStudyId -->
                <c:if test='${(initParam.iSecondStudy == "Y")}'>
                    <tr>
                        <td class="label"><b><fmt:message key="jsp.general.secondarystudy" /></b></td>
                        <td>
                            <c:if test="${editPersonalData}">
                                <form:select path="student.secondaryStudyId">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <c:forEach var="oneSecondaryStudy" items="${form.allSecondaryStudies}">
                                    <c:set var="optionText"><c:out value="${oneSecondaryStudy.studyDescription} (${studentForm.idToOrganizationalUnitMap[oneSecondaryStudy.organizationalUnitId].organizationalUnitDescription})"/></c:set>
                                    <form:option value="${oneStudy.id}">${optionText}</form:option>
<%--                                                             <c:choose> --%>
<%--                                                                 <c:when test="${oneSecondaryStudy.id == status.value}"> --%>
<%--                                                                     <option value="${oneSecondaryStudy.id}" title="${optionText}" selected="selected">${optionText}</option> --%>
<%--                                                                 </c:when> --%>
<%--                                                                 <c:otherwise> --%>
<%--                                                                     <option value="${oneSecondaryStudy.id}" title="${optionText}">${optionText}</option> --%>
<%--                                                                 </c:otherwise> --%>
<%--                                                             </c:choose> --%>
                                </c:forEach>
                                </form:select>
                            </c:if>
                            <c:if test="${showPersonalData}">
                                <c:forEach var="oneSecondaryStudy" items="${form.allSecondaryStudies}">
                                    <c:if test="${oneSecondaryStudy.id == student.secondaryStudyId}">
                                        <c:out value="${oneSecondaryStudy.studyDescription}"/>
                                    </c:if>
                                </c:forEach>
                             </c:if>
                        </td> 
                        <td><form:errors cssClass="error" path="student.secondaryStudyId"/></td>
                    </tr>
                </c:if>

                <tr>
                    <td class="label"><fmt:message key="jsp.general.foreignstudent" /></td>
                    <c:if test="${editPersonalData}">
                        <td>
                            <form:select path="student.foreignStudent">
                                <form:option value="Y"><fmt:message key="jsp.general.yes" /></form:option>
                                <form:option value="N"><fmt:message key="jsp.general.no" /></form:option>
                            </form:select>
                        </td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <td><fmt:message key="${stringToYesNoMap[student.foreignStudent]}"/></td>
                    </c:if>
                    <td><form:errors cssClass="error" path="student.foreignStudent"/></td>
                </tr>
            
                <c:if test="${student.foreignStudent == 'Y'}">
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.nationalitygroup" /></td>
                        <td>
                            <form:select path="student.nationalityGroupCode">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <form:options items="${webLookups.allNationalityGroups}" itemValue="code" itemLabel="description" />
                            </form:select>
                        </td>
                    </tr>
                </c:if>

            <c:choose>
                <c:when test="${showStudentError != null && showStudentError != ''}">
                    <tr><td colspan="3" class="error">${showStudentError}</td></tr>
                </c:when>
            </c:choose>


            <spring:bind path="student.studentCode">
                <tr>
                    <td class="label"><fmt:message key="jsp.general.studentcode" /></td>
                    <c:if test="${editPersonalData}">
                        <td>
                           <input type="text" name="${status.expression}" id="${status.expression}" value="<c:out value="${status.value}" />" size="40" />
                        </td>
                        <td>
                            <c:if test="${studentForm.studentCodeWillBeGenerated}">
                                <fmt:message key="jsp.general.message.codegenerated" />&nbsp;
                            </c:if>
                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                        </td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <td><c:out value="${status.value}"/></td>
                        <td></td>
                    </c:if>
                </tr>
            </spring:bind>

             
<%--             <spring:bind path="student.relativeOfStaffMember"> --%>
               <tr>
                    <td class="label"><fmt:message key="jsp.general.relativeofstaffmember" /></td>
                    <c:if test="${editPersonalData}">
                        <td>
                            <form:select path="student.relativeOfStaffMember">
                                <form:option value="Y"><fmt:message key="jsp.general.yes" /></form:option>
                                <form:option value="N"><fmt:message key="jsp.general.no" /></form:option>
                            </form:select>
<%--                             <select name="${status.expression}" onchange="this.form.submit();"> --%>
<%--                                 <c:choose> --%>
<%--                                     <c:when test="${'Y' == status.value}"> --%>
<%--                                         <option value="Y" selected="selected"><fmt:message key="jsp.general.yes" /></option> --%>
<%--                                         <option value="N"><fmt:message key="jsp.general.no" /></option> --%>
<%--                                     </c:when> --%>
<%--                                     <c:otherwise> --%>
<%--                                         <option value="Y"><fmt:message key="jsp.general.yes" /></option> --%>
<%--                                         <option value="N" selected="selected"><fmt:message key="jsp.general.no" /></option> --%>
<%--                                     </c:otherwise> --%>
<%--                                 </c:choose> --%>
<%--                             </select> --%>
                        </td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                            <td><fmt:message key="${stringToYesNoMap[student.relativeOfStaffMember]}"/></td>
<%--                         <c:choose> --%>
<%--                              <c:when test="${'Y' == status.value}"> --%>
<%--                                 <td><fmt:message key="jsp.general.yes" /></td> --%>
<%--                             </c:when> --%>
<%--                             <c:otherwise> --%>
<%--                                 <td><fmt:message key="jsp.general.no" /></td> --%>
<%--                             </c:otherwise> --%>
<%--                         </c:choose> --%>
                        <td></td>
                    </c:if>
                    <td><form:errors cssClass="error" path="student.relativeOfStaffMember"/></td>
<%--                     <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td> --%>
                </tr>
<%--            </spring:bind> --%>

            <c:if test="${relativeOfStaffMember == 'Y'}">
                <tr>
                    <td class="label"><fmt:message key="jsp.general.staffmembercode" /></td>
                    <c:if test="${editPersonalData}">
                        <spring:bind path="student.employeeNumberOfRelative">
                            <td>
                                <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
                            </td>
                        </spring:bind>
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <td><c:out value="${student.employeeNumberOfRelative}"/></td>
                    </c:if>
                </tr>
            </c:if>

<%--             <spring:bind path="student.ruralAreaOrigin"> --%>
               <tr>
                    <td class="label"><fmt:message key="jsp.general.ruralareaorigin" /></td>
                    <c:if test="${editPersonalData}">
                        <td>
                            <form:select path="student.ruralAreaOrigin">
                                <form:option value="Y"><fmt:message key="jsp.general.yes" /></form:option>
                                <form:option value="N"><fmt:message key="jsp.general.no" /></form:option>
                            </form:select>
<%--                             <select name="${status.expression}"> --%>
<%--                                 <c:choose> --%>
<%--                                     <c:when test="${'Y' == status.value}"> --%>
<%--                                         <option value="Y" selected="selected"><fmt:message key="jsp.general.yes" /></option> --%>
<%--                                         <option value="N"><fmt:message key="jsp.general.no" /></option> --%>
<%--                                     </c:when> --%>
<%--                                     <c:otherwise> --%>
<%--                                         <option value="Y"><fmt:message key="jsp.general.yes" /></option> --%>
<%--                                         <option value="N" selected="selected"><fmt:message key="jsp.general.no" /></option> --%>
<%--                                     </c:otherwise> --%>
<%--                                 </c:choose> --%>
<%--                             </select> --%>
                        </td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <td><fmt:message key="${stringToYesNoMap[student.ruralAreaOrigin]}"/></td>
<%--                         <c:choose> --%>
<%--                              <c:when test="${'Y' == status.value}"> --%>
<%--                                 <td><fmt:message key="jsp.general.yes" /></td> --%>
<%--                             </c:when> --%>
<%--                             <c:otherwise> --%>
<%--                                 <td><fmt:message key="jsp.general.no" /></td> --%>
<%--                             </c:otherwise> --%>
<%--                         </c:choose> --%>
                        <td></td>
                    </c:if>
                    <td><form:errors cssClass="error" path="student.ruralAreaOrigin"/></td>
<%--                     <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td> --%>
                </tr>
<%--             </spring:bind> --%>

                                    
            <sec:authorize access="hasRole('READ_STUDENT_MEDICAL_DATA')">
                <c:set var="readMedicalData" value="${true}"/>
            </sec:authorize>
        
            <sec:authorize access="hasRole('UPDATE_STUDENT_MEDICAL_DATA')">
                <c:set var="updateMedicalData" value="${true}"/>
            </sec:authorize>
        
            <spring:bind path="student.surnameFull">
                     <tr>
                        <td class="label"><fmt:message key="jsp.general.surname" /></td>
                        <c:if test="${editPersonalData}">
                            <td class="required"><input type="text" name="${status.expression}" size="40" value='<c:out value="${status.value}"/>' /></td>
                        </c:if>
                        <c:if test="${showPersonalData}">
                            <td><c:out value="${status.value}"/></td>
                        </c:if>
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                    </tr>
            </spring:bind>
         
            <%--  not needed in Mozambique, but left in the system<tr>
                 <td class="label"><fmt:message key="jsp.general.aliassurname" /></td>
                 <td><spring:bind path="student.surnameAlias"><input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
                 <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></spring:bind></td>
             </tr> --%>
            <spring:bind path="student.firstnamesFull">
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
        
            <spring:bind path="student.firstnamesAlias">
                <tr>
                    <td class="label"><fmt:message key="jsp.general.aliasfirstnames" /></td>
                    <c:if test="${editPersonalData}">
                        <td><input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <td><c:out value="${status.value}"/></td>
                    </c:if>
                    <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                </tr>
            </spring:bind>

            <spring:bind path="student.nationalRegistrationNumber">
                <tr>
                    <td class="label"><fmt:message key="jsp.general.nationalregistrationnumber" /></td>
                    <c:if test="${editIdentificationData}">
                        <td><input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                    </c:if>
                    <c:if test="${showIdentificationData}">
                        <td><c:out value="${student.nationalRegistrationNumber}"/></td>
                    </c:if>
                    <c:if test="${not editIdentificationData and not showIdentificationData}">
                        <td>(<fmt:message key="jsp.general.hidden"/>)</td>
                    </c:if>
                </tr>
            </spring:bind>

            <tr>
                <td class="label"><b><fmt:message key="jsp.general.civiltitle" /></b></td>
                <c:if test="${editPersonalData}">
                    <td>
                        <form:select path="student.civilTitleCode">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="civilTitle" items="${studentForm.allCivilTitles}">
                                <form:option value="${civilTitle.code}">${civilTitle.description}</form:option>
                            </c:forEach>
                        </form:select>
                    </td>
                </c:if>
                    
                <c:if test="${showPersonalData}">
                    <td>
                        <c:out value="${studentForm.codeToCivilTitleMap[student.civilTitleCode].description }"></c:out>
<%--                         <c:forEach var="civilTitle" items="${allCivilTitles}"> --%>
<%--                             <c:if test="${civilTitle.code == student.civilTitleCode}"> --%>
<%--                                 <c:out value="${civilTitle.description}"/> --%>
<%--                             </c:if> --%>
<%--                         </c:forEach> --%>
                    </td>
                </c:if>
                <td><form:errors cssClass="error" path="student.civilTitleCode"/></td>
            </tr>
<%--             <spring:bind path="student.civilTitleCode"> --%>
<%--                 <% request.setAttribute("label", "jsp.general.civiltitle"  ); %> --%>
<%--                 <% request.setAttribute("allLookups", request.getAttribute("allCivilTitles") ); %> --%>
<%--                 <jsp:include page="/WEB-INF/views/includes/dropdown.jsp" flush="true" /> --%>
<%--             </spring:bind> --%>

<%--             <spring:bind path="student.gradeTypeCode"> --%>
            <tr>
                <td class="label"><fmt:message key="jsp.general.academictitle" /></td>
                <c:if test="${editPersonalData}">
                   <td>
<%--                             <select name="${status.expression}"> --%>
<%--                                 <option value="0"><fmt:message key="jsp.selectbox.choose.ifapplicable" /></option> --%>
<%--                                 <c:forEach var="gradeType" items="${allGradeTypes}"> --%>
<%--                                     <c:choose> --%>
<%--                                      <c:when test="${gradeType.code == status.value && gradeType.title != ''}"> --%>
<%--                                          <option value="${gradeType.code}" selected="selected"><c:out value="${gradeType.title}"/></option> --%>
<%--                                      </c:when> --%>
<%--                                      <c:otherwise> --%>
<%--                                         <c:choose> --%>
<%--                                             <c:when test="${gradeType.title != ''}"> --%>
<%--                                                 <option value="${gradeType.code}"><c:out value="${gradeType.title}"/></option> --%>
<%--                                             </c:when> --%>
<%--                                         </c:choose> --%>
<%--                                      </c:otherwise> --%>
<%--                                     </c:choose> --%>
<%--                                  </c:forEach> --%>
<%--                             </select> --%>
                        <form:select path="student.gradeTypeCode">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="gradeType" items="${studentForm.allGradeTypes}">
                                <form:option value="${gradeType.code}">${gradeType.description}</form:option>
                            </c:forEach>
                        </form:select>
                    </td>
                    <td><form:errors cssClass="error" path="student.gradeTypeCode"/></td>
<%--                     <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td> --%>
               </c:if>
               <c:if test="${showPersonalData}">
                    <td><c:out value="${studentForm.codeToGradeTypeMap[student.gradeTypeCode].description }"/></td>
<%--                     <c:forEach var="gradeType" items="${allGradeTypes}"> --%>
<%--                         <c:choose> --%>
<%--                             <c:when test="${gradeType.code == status.value && gradeType.title != ''}"> --%>
<%--                                 <td><c:out value="${gradeType.title}"/></td> --%>
<%--                             </c:when> --%>
<%--                         </c:choose> --%>
<%--                     </c:forEach> --%>
<!--                     <td></td> -->
                </c:if>
                
            </tr>
<%--             </spring:bind> --%>
        
            <tr>
                <td class="label"><b><fmt:message key="jsp.general.gender" /></b></td>
                <c:if test="${editPersonalData}">
                    <td class="required">
                        <form:select path="student.genderCode">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="gender" items="${studentForm.allGenders}">
                                <form:option value="${gender.code}">${gender.description}</form:option>
                            </c:forEach>
                        </form:select>
                    </td>
                </c:if>
                    
                <c:if test="${showPersonalData}">
                    <td>
                        <c:out value="${studentForm.codeToGenderMap[student.genderCode].description }"></c:out>
                    </td>
                </c:if>
                <td><form:errors cssClass="error" path="student.genderCode"/></td>
            </tr>
<%--             <spring:bind path="student.genderCode"> --%>
<%--                 <% request.setAttribute("label", "jsp.general.gender"  ); %> --%>
<%--                 <% request.setAttribute("allLookups", request.getAttribute("allGenders") ); %> --%>
<%--                 <jsp:include page="/WEB-INF/views/includes/dropdownRequiredStudent.jsp" flush="true" /> --%>
<%--             </spring:bind> --%>
        
            <spring:bind path="student.birthdate">
                <tr>
                    <td class="label"><fmt:message key="jsp.general.birthdate" /></td>
                    <c:if test="${editPersonalData}">
                        <td class="required">
                            <table>
                            <tr>
                                <td><fmt:message key="jsp.general.day" /></td>
                                <td><fmt:message key="jsp.general.month" /></td>
                                <td><fmt:message key="jsp.general.year" /></td>
                            </tr>
                            <tr>
                                <td><input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}"/>" />
                                    <input class="numericField" type="text" id="birth_day" name="birth_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />"  onchange="updateFullDate('studentFormShared.student.birthdate','day',document.getElementById('birth_day').value);"  /></td>
                                <td><input class="numericField" type="text" id="birth_month" name="birth_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('studentFormShared.student.birthdate','month',document.getElementById('birth_month').value);" /></td>
                                <td><input class="numericField" type="text" id="birth_year" name="birth_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />"  onchange="updateFullDate('studentFormShared.student.birthdate','year',document.getElementById('birth_year').value);" /></td>
                            </tr>
                            </table>
                        </td>
                        <td>
                            <fmt:message key="jsp.general.message.dateformat" />
                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                        </td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <td>
                            ${fn:substring(status.value,8,10)}
                            ${fn:substring(status.value,5,7)}
                            ${fn:substring(status.value,0,4)}
                        </td>
                    </c:if>
<%--                      <c:if test="${showPersonalData && personId != opusUser.personId}">      not sure what this is for --%>
<%--                         <td>&nbsp;</td> --%>
<%--                      </c:if> --%>
                </tr>
            </spring:bind>

            <tr>
                <td class="label"><b><fmt:message key="jsp.general.civilstatus" /></b></td>
                <c:if test="${editPersonalData}">
                    <td>
                        <form:select path="student.civilStatusCode">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="civilStatus" items="${studentForm.allCivilStatuses}">
                                <form:option value="${civilStatus.code}">${civilStatus.description}</form:option>
                            </c:forEach>
                        </form:select>
                    </td>
                </c:if>

                <c:if test="${showPersonalData}">
                    <td>
                        <c:out value="${studentForm.codeToCivilStatusMap[student.civilStatusCode].description }"></c:out>
                    </td>
                </c:if>
                <td><form:errors cssClass="error" path="student.civilStatusCode"/></td>
            </tr>

             <tr>
                 <td class="label"><form:label for="student.sourceOfFunding" path="student.sourceOfFunding"><fmt:message key="jsp.general.sourceOfFunding" /></form:label></td>
                 <!-- <td><form:radiobutton label="Autofinanciamento" value="Autofinanciamento" path="student.sourceOfFunding"/></td>-->
                 <!-- <td><form:radiobutton label="Bolsa" value="Bolsa" path="student.sourceOfFunding"/></td>  -->  
                 <td><form:errors path="student.sourceOfFunding" cssClass="error"/>
	                <form:select path="student.sourceOfFunding">
	                  <form:option value="Autofinanciamento"><fmt:message key="jsp.general.selffunding" /></form:option>
	                  <form:option value="Bolsa"><fmt:message key="jsp.general.scholarship" /></form:option>
	                </form:select>
                </td>
            </tr>

<%--             <spring:bind path="student.civilStatusCode"> --%>
<%--                 <% request.setAttribute("label", "jsp.general.civilstatus"  ); %> --%>
<%--                 <% request.setAttribute("allLookups", request.getAttribute("allCivilStatuses") ); %> --%>
<%--                 <jsp:include page="/WEB-INF/views/includes/dropdown.jsp" flush="true" /> --%>
<%--             </spring:bind> --%>
        
<%--             <spring:bind path="student.housingOnCampus"> --%>
                  <tr>
                    <td class="label"><fmt:message key="jsp.general.housingoncampus" /></td>
                    <c:if test="${editAccommodationData}">
                        <td>
                            <form:select path="student.housingOnCampus">
                                <form:option value="Y"><fmt:message key="jsp.general.yes" /></form:option>
                                <form:option value="N"><fmt:message key="jsp.general.no" /></form:option>
                            </form:select>
<%--                                 <select name="${status.expression}"> --%>
<%--                                     <c:choose> --%>
<%--                                         <c:when test="${'Y' == status.value}"> --%>
<%--                                             <option value="Y" selected="selected"><fmt:message key="jsp.general.yes" /></option> --%>
<%--                                             <option value="N"><fmt:message key="jsp.general.no" /></option> --%>
<%--                                         </c:when> --%>
<%--                                         <c:otherwise> --%>
<%--                                             <option value="Y"><fmt:message key="jsp.general.yes" /></option> --%>
<%--                                             <option value="N" selected="selected"><fmt:message key="jsp.general.no" /></option> --%>
<%--                                         </c:otherwise> --%>
<%--                                     </c:choose> --%>
<%--                                 </select> --%>
                                &nbsp;&nbsp;&nbsp;
                                <b>
                                <c:choose>
                                    <c:when test="${modules != null && modules != ''}">
                                        <c:forEach var="module" items="${modules}">
                                            <c:choose>
                                                <c:when test="${fn:toLowerCase(module.module) == 'accommodation'}">
                                                    <c:set var="accommodationModulePresent" value="Y" scope="page" />
                                                    <a href="<c:url value='/accommodation/student.view.view?newForm=true&tab=0&panel=0&studentId=${studentId}'/>"><fmt:message key="jsp.general.edit" /> <fmt:message key="jsp.general.accommodation" /></a>
                                                </c:when>
                                            </c:choose>
                                        </c:forEach>
                                    </c:when>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${accommodationModulePresent != 'Y'}">
                                        <fmt:message key="jsp.general.alter.accommodation" />:<br /><fmt:message key="jsp.general.implement.accommodationmodule" /> (<fmt:message key="jsp.general.contact.administrator" />)
                                    </c:when>
                                </c:choose>
                               </b>
                            </td>
                            <td><form:errors cssClass="error" path="student.housingOnCampus"/></td>
<%--                             <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td> --%>
                        </c:if>
                        <c:if test="${showAccommodationData}">
                            <td><fmt:message key="${stringToYesNoMap[student.housingOnCampus]}"/></td>
<%--                             <c:choose> --%>
<%--                                 <c:when test="${'Y' == status.value}"> --%>
<%--                                     <td><fmt:message key="jsp.general.yes" /></td> --%>
<%--                                 </c:when> --%>
<%--                                 <c:otherwise> --%>
<%--                                     <td><fmt:message key="jsp.general.no" /></td> --%>
<%--                                 </c:otherwise> --%>
<%--                             </c:choose> --%>
                            <td></td>
                        </c:if>
                    </tr>
<%--             </spring:bind> --%>
            <tr>
                <td class="label"><fmt:message key="jsp.general.motivation"/></td>
                <td>
                    <c:if test="${editPersonalData}">
                        <form:textarea rows="6" cols="25" path="student.motivation" />
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <c:out value="${student.motivation}" />
                    </c:if>
                </td>
                <td>&nbsp;</td>
            </tr>
            <spring:bind path="student.missingDocuments">
                <c:if test="${editPersonalData}">
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.missingdocuments"/></td>
                        <td>
                        <input type="checkbox" class="checks"  name="x1" onclick="copiar()" value="<fmt:message key="jsp.general.certifiedcopy"/>"><fmt:message key="jsp.general.certifiedcopy"/></input>
                		<input type="checkbox" class ="checks" name="x2" onclick="copiar()" value="<fmt:message key="jsp.general.certifiedcopyidcard"/>"><fmt:message key="jsp.general.certifiedcopyidcard"/></input>
                		<input type="checkbox" class ="checks" name="x3" onclick="copiar()" value="<fmt:message key="jsp.general.photos"/>"><fmt:message key="jsp.general.photos"/></input>
                		<input type="checkbox" class ="checks" name="x4" onclick="copiar()" value="<fmt:message key="jsp.general.equivalencecertificate"/>"><fmt:message key="jsp.general.equivalencecertificate"/></input>
                		<input type="checkbox" class ="checks" name="x5" onclick="copiar()" value="<fmt:message key="jsp.general.statementmilitaryservice"/>"><fmt:message key="jsp.general.statementmilitaryservice"/></input>
                		</td>
                    </tr>
                    <tr>
                        <td class="label"></td>
                        	<td>
                            <textarea id="cc" rows="4" cols="25" name="${status.expression}"><c:out value="${status.value}"/></textarea>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                </c:if>
                <c:if test="${showPersonalData}">
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.missingdocuments"/></td>
                        <td><c:out value="${status.value}" /></td>
                    </tr>
                </c:if>                
            </spring:bind>
        
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>
                    <c:if test="${editPersonalData}">
                        <input type="button" name="submitpersonaldata" value="<fmt:message key="jsp.button.submit" />" onclick="this.form.submit();" />
                    </c:if>
                </td>
            </tr>
           </table>
        </form:form>
    </div> <!-- einde accordionpanelcontent -->
</div> <!-- einde accordionpanel -->


<!-- background -->
<c:if test="${studentName != null && studentName != ''}">
<div class="AccordionPanel">
    <div class="AccordionPanelTab"><fmt:message key="jsp.general.background" /></div>
    <div class="AccordionPanelContent">
        <form:form modelAttribute="studentForm.studentFormShared" method="post">
            <%-- can be removed once there is a global form --%>
            <input type="hidden" name="studentFormShared.navigationSettings.tab" value="${accordion}" />
            <input type="hidden" name="studentFormShared.navigationSettings.panel" value="1" />

            <table>
                <tr>
                    <td class="label"><fmt:message key="jsp.general.nationality" /></td>
                    <td>
                        <c:if test="${editPersonalData}">
                            <form:select path="student.nationalityCode">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <c:forEach var="nationality" items="${studentForm.allNationalities}">
                                    <form:option value="${nationality.code}" label="${nationality.description}"></form:option>
                                </c:forEach>
                            </form:select>
                        </c:if>
                        <c:if test="${showPersonalData}">
                            <c:out value="${studentForm.codeToNationalityMap[student.nationalityCode].description }"></c:out>
<%--                             <c:forEach var="nationality" items="${allNationalities}"> --%>
<%--                                 <c:choose> --%>
<%--                                     <c:when test="${nationality.code == student.nationalityCode}"> --%>
<%--                                         <c:out value="${nationality.description}"/> --%>
<%--                                     </c:when> --%>
<%--                                 </c:choose> --%>
<%--                             </c:forEach> --%>
                        </c:if>
                    </td>
                    <td><form:errors cssClass="error" path="student.nationalityCode"/></td>
                </tr>

                <tr>
                    <td class="label"><fmt:message key="jsp.general.countryofbirth" /></td>
                    <c:if test="${editPersonalData}">
                        <td>
                            <form:select path="student.countryOfBirthCode" onchange="this.form.submit();">
                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                <c:forEach var="country" items="${studentForm.allCountries}">
                                    <form:option value="${country.code}" label="${country.description}"></form:option>
                                </c:forEach> 
                            </form:select>
                        </td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <c:out value="${studentForm.codeToCountryMap[student.countryOfBirthCode].description }"></c:out>
<%--                         <c:forEach var="country" items="${allCountries}"> --%>
<%--                             <c:choose> --%>
<%--                                 <c:when test="${country.code == student.countryOfBirthCode}"> --%>
<%--                                     <td><c:out value="${country.description}"/></td> --%>
<%--                                 </c:when> --%>
<%--                             </c:choose> --%>
<%--                         </c:forEach>  --%>
                     </c:if>
                    <td><form:errors cssClass="error" path="student.countryOfBirthCode"/></td>
                </tr>
       
                <tr>
                    <td class="label"><fmt:message key="jsp.general.provinceofbirth" /></td>
                    <c:if test="${editPersonalData}">
                        <td>
                        <form:select path="student.provinceOfBirthCode" onchange="this.form.submit();">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="provinceOfBirth" items="${allProvincesOfBirth}">
                                <form:option value="${provinceOfBirth.code}" label="${provinceOfBirth.description}"></form:option>
                            </c:forEach> 
                        </form:select>
                        </td>
                   </c:if>
                    <c:if test="${showPersonalData}">
                        <c:forEach var="provinceOfBirth" items="${allProvincesOfBirth}">
                            <c:choose>
                            <c:when test="${provinceOfBirth.code == student.provinceOfBirthCode}">
                                <td><c:out value="${provinceOfBirth.description}"/></td>
                            </c:when>
                            </c:choose>
                        </c:forEach> 
                    </c:if>
                    <td><form:errors cssClass="error" path="student.provinceOfBirthCode"/></td>
                </tr>

                <tr>
                    <td class="label"><fmt:message key="jsp.general.districtofbirth" /></td>
                    <c:if test="${editPersonalData}">
                       <td>
                        <form:select path="student.districtOfBirthCode" onchange="this.form.submit();">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="districtOfBirth" items="${allDistrictsOfBirth}">
                                <form:option value="${districtOfBirth.code}" label="${districtOfBirth.description}"></form:option>
                            </c:forEach> 
                        </form:select>
                        </td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <c:forEach var="districtOfBirth" items="${allDistrictsOfBirth}">
                            <c:choose>
                            <c:when test="${districtOfBirth.code == student.districtOfBirthCode}">
                                <td><c:out value="${districtOfBirth.description}"/></td>
                            </c:when>
                            </c:choose>
                        </c:forEach> 
                    </c:if>
                    <td><form:errors cssClass="error" path="student.districtOfBirthCode"/></td>
                </tr>

                <tr>
                    <td class="label"><fmt:message key="jsp.general.placeofbirth" /></td>
                    <c:if test="${editPersonalData}">
                        <td><form:input path="student.placeOfBirth" size="40"/></td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <td><c:out value="${student.placeOfBirth}"/></td>
                    </c:if>
                    <td><form:errors cssClass="error" path="student.placeOfBirth"/></td>
                </tr>

                <tr>
                    <td class="label"><fmt:message key="jsp.general.countryoforigin" /></td>
                    <c:if test="${editPersonalData}">
                        <td>
                        <form:select path="student.countryOfOriginCode" onchange="this.form.submit();">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="country" items="${studentForm.allCountries}">
                                <form:option value="${country.code}" label="${country.description}"></form:option>
                            </c:forEach> 
                        </form:select>
                        </td>
                   </c:if>
                    <c:if test="${showPersonalData}">
                        <c:out value="${studentForm.codeToCountryMap[student.countryOfOriginCode].description }"></c:out>
<%--                         <c:forEach var="country" items="${allCountries}"> --%>
<%--                             <c:choose> --%>
<%--                                 <c:when test="${country.code == student.countryOfOriginCode}"> --%>
<%--                                     <td><c:out value="${country.description}"/></td> --%>
<%--                                 </c:when> --%>
<%--                             </c:choose> --%>
<%--                         </c:forEach>  --%>
                    </c:if>
                    <td><form:errors cssClass="error" path="student.countryOfOriginCode"/></td>
            </tr>

            <tr>
                 <td class="label"><fmt:message key="jsp.general.provinceoforigin" /></td>
                    <c:if test="${editPersonalData}">
                        <td>
                        <form:select path="student.provinceOfOriginCode" onchange="this.form.submit();">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="provinceOfOrigin" items="${allProvincesOfOrigin}">
                                <form:option value="${provinceOfOrigin.code}" label="${provinceOfOrigin.description}"></form:option>
                            </c:forEach>
                        </form:select>
                        </td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <c:forEach var="provinceOfOrigin" items="${allProvincesOfOrigin}">
                            <c:choose>
                                <c:when test="${provinceOfOrigin.code == student.provinceOfOriginCode}">
                                    <td><c:out value="${provinceOfOrigin.description}"/></td>
                                </c:when>
                            </c:choose>
                        </c:forEach>
                    </c:if>
                    <td><form:errors cssClass="error" path="student.provinceOfOriginCode"/></td>
                </tr>

                <tr>
                    <td class="label"><fmt:message key="jsp.general.districtoforigin" /></td>
                    <c:if test="${editPersonalData}">
                        <td>
                        <form:select path="student.districtOfOriginCode" onchange="this.form.submit();">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="districtOfOrigin" items="${allDistrictsOfOrigin}">
                                <form:option value="${districtOfOrigin.code}" label="${districtOfOrigin.description}"></form:option>
                            </c:forEach>
                        </form:select>
                        </td>
                     </c:if>
                     <c:if test="${showPersonalData}">
                        <c:forEach var="districtOfOrigin" items="${allDistrictsOfOrigin}">
                            <c:choose>
                                <c:when test="${districtOfOrigin.code == student.districtOfOriginCode}">
                                    <td><c:out value="${districtOfOrigin.description}"/></td>
                                </c:when>
                            </c:choose>
                        </c:forEach> 
                    </c:if>
                    <td><form:errors cssClass="error" path="student.districtOfOriginCode"/></td>
                </tr>

                <tr>
                    <td class="label"><fmt:message key="jsp.general.cityoforigin" /></td>
                    <c:if test="${editPersonalData}">
                        <td><form:input path="student.cityOfOrigin" size="40"/></td>
                     </c:if>
                     <c:if test="${showPersonalData}">
                        <td><c:out value="${student.cityOfOrigin}"/></td>
                    </c:if>
                    <td><form:errors cssClass="error" path="student.cityOfOrigin"/></td>
               </tr>

                <tr>
                    <td class="label">&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>
                    <c:if test="${editPersonalData}">
                        <input type="button" name="submitbackgrounddata" value="<fmt:message key="jsp.button.submit" />" onclick="this.form.submit();" />
                    </c:if>
                    </td>
                </tr>
            </table>
          </form:form>
      </div> <!-- einde accordionpanelcontent -->
  </div> <!-- einde accordionpanel -->
</c:if>

<!-- IDENTIFICATION -->
<c:if test="${studentName != null && studentName != ''}">
    <div class="AccordionPanel">
      <div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.general.identification" /></div>
      <div class="AccordionPanelContent">
<!--            <form name="identificationdata" id="identificationdata" method="post"> -->
        <form:form modelAttribute="studentForm.studentFormShared" method="post">
            <%-- can be removed once there is a global form --%>
            <input type="hidden" name="studentFormShared.navigationSettings.tab" value="${accordion}" />
            <input type="hidden" name="studentFormShared.navigationSettings.panel" value="2" />

            <table>
                <c:if test="${not editIdentificationData and not showIdentificationData}">
                    <tr><td>(<fmt:message key="jsp.general.hidden"/>)</td></tr>
                </c:if>

            <!--  EDIT -->
            <c:if test="${editIdentificationData}">
<%--                 <spring:bind path="student.identificationTypeCode"> --%>
<%--                     <% request.setAttribute("label", "jsp.general.identificationtype"  ); %> --%>
<%--                     <% request.setAttribute("allLookups", request.getAttribute("allIdentificationTypes") ); %> --%>
<%--                     <jsp:include page="/WEB-INF/views/includes/dropdownRequiredStudent.jsp" flush="true" /> --%>
<%--                 </spring:bind> --%>

                <tr>
                    <td class="label"><fmt:message key="jsp.general.identificationtype" /></td>
                    <td class="required">
                        <form:select path="student.identificationTypeCode">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <form:options items="${allIdentificationTypes}" itemLabel="description" itemValue="code"/>
                        </form:select>
                    </td>
                    <td><form:errors cssClass="error" path="student.identificationTypeCode"/></td>
                </tr>

<%--                 <spring:bind path="student.identificationNumber"> --%>
                <tr>
                    <td class="label"><fmt:message key="jsp.general.identificationnumber" /></td>
                    <td class="required">
                        <form:input path="student.identificationNumber" size="40"/>
<%--                         <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" /> --%>
                    </td>
                    <td><form:errors cssClass="error" path="student.identificationNumber"/></td>
               </tr>
<%--                 </spring:bind> --%>

<%--                 <spring:bind path="student.identificationPlaceOfIssue"> --%>
                <tr>
                    <td class="label"><fmt:message key="jsp.general.placeofissue" /></td>
                    <td>
<%--                         <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" /> --%>
                        <form:input path="student.identificationPlaceOfIssue" size="40"/>
                    </td>
                    <td><form:errors cssClass="error" path="student.identificationPlaceOfIssue"/></td>
                </tr>
<%--                 </spring:bind> --%>

                <spring:bind path="student.identificationDateOfIssue">
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
                                    <td><input type="hidden" id="${status.expression}" name="${status.expression}" value="<c:out value="${status.value}"/>" />
                                        <input type="text" id="identification_issue_day" name="identification_issue_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('studentFormShared.student.identificationDateOfIssue','day',document.getElementById('identification_issue_day').value);" /></td>
                                    <td><input type="text" id="identification_issue_month" name="identification_issue_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('studentFormShared.student.identificationDateOfIssue','month',document.getElementById('identification_issue_month').value);" /></td>
                                    <td><input type="text" id="identification_issue_year" name="identification_issue_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('studentFormShared.student.identificationDateOfIssue','year',document.getElementById('identification_issue_year').value);" /></td>
                                </tr>
                            </table>
                        </td>
                        <td>
                            <fmt:message key="jsp.general.message.dateformat" />
                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                        </td>
                    </tr>
                </spring:bind>

                <spring:bind path="student.identificationDateOfExpiration">
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
                                        <input type="text" id="identification_expiration_day" name="identification_expiration_day" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,8,10)}" />" onchange="updateFullDate('studentFormShared.student.identificationDateOfExpiration','day',document.getElementById('identification_expiration_day').value);" /></td>
                                    <td><input type="text" id="identification_expiration_month" name="identification_expiration_month" size="2" maxlength="2" value="<c:out value="${fn:substring(status.value,5,7)}" />" onchange="updateFullDate('studentFormShared.student.identificationDateOfExpiration','month',document.getElementById('identification_expiration_month').value);" /></td>
                                    <td><input type="text" id="identification_expiration_year" name="identification_expiration_year" size="4" maxlength="4" value="<c:out value="${fn:substring(status.value,0,4)}" />" onchange="updateFullDate('studentFormShared.student.identificationDateOfExpiration','year',document.getElementById('identification_expiration_year').value);" /></td>
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
                    <td><input type="button" name="submitidentificationdata" value="<fmt:message key="jsp.button.submit" />" onclick="this.form.submit();" /></td>
                </tr>
            </c:if>

            <!--  SHOW -->
            <c:if test="${showIdentificationData}">
                <tr><td colspan="2">&nbsp;</td></tr>
<%--                 <spring:bind path="student.identificationTypeCode"> --%>
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.identificationtype" /></td>
                        <c:forEach var="identificationType" items="${allIdentificationTypes}">
                            <c:choose>
                                <c:when test="${identificationType.code == student.identificationTypeCode}">
                                    <td><c:out value="${identificationType.description}"/></td>
                                </c:when>
                            </c:choose>
                        </c:forEach>
                    </tr>
<%--                 </spring:bind> --%>
        
<%--                 <spring:bind path="student.identificationNumber"> --%>
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.identificationnumber" /></td>
                        <td><c:out value="${student.identificationNumber}"/></td>
                    </tr>
<%--                 </spring:bind> --%>

<%--                 <spring:bind path="student.identificationPlaceOfIssue"> --%>
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.placeofissue" /></td>
                        <td><c:out value="${student.identificationPlaceOfIssue}"/></td>
                    </tr>
<%--                 </spring:bind> --%>

<%--                 <spring:bind path="student.identificationDateOfIssue"> --%>
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.dateofissue" /></td>
                        <td>
                            <table>
                                <tr>
                                    <td>${fn:substring(student.identificationDateOfIssue,8,10)}&nbsp;-</td>
                                    <td>${fn:substring(student.identificationDateOfIssue,5,7)}&nbsp;-</td>
                                    <td>${fn:substring(student.identificationDateOfIssue,0,4)}</td>
                                    <td><fmt:message key="jsp.general.dateformat" /></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
<%--                 </spring:bind> --%>

<%--                 <spring:bind path="student.identificationDateOfExpiration"> --%>
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.dateofexpiration" /></td>
                        <td>
                            <table>
                                <tr>
                                    <td>${fn:substring(student.identificationDateOfExpiration,8,10)}&nbsp;-</td>
                                    <td>${fn:substring(student.identificationDateOfExpiration,5,7)}&nbsp;-</td>
                                    <td>${fn:substring(student.identificationDateOfExpiration,0,4)}</td>
                                    <td><fmt:message key="jsp.general.dateformat" /></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
<%--                 </spring:bind> --%>
                <tr><td colspan="2">&nbsp;</td></tr>
            </c:if>
            </table>
        </form:form>
    </div>
</div>
</c:if>

<c:if test="${studentName != null && studentName != ''}">
    <div class="AccordionPanel">
    <div class="AccordionPanelTab"><fmt:message key="jsp.general.miscellaneous" /></div>
    <div class="AccordionPanelContent">
<%--         <form name="miscellaneousdata" id="miscellaneousdata" method="post"> --%>
        <form:form modelAttribute="studentForm.studentFormShared" method="post">
            <%-- navigationsettings.tab/panel should be in the one and only global form --%>
            <input type="hidden" name="studentFormShared.navigationSettings.tab" value="${accordion}" />
            <input type="hidden" name="studentFormShared.navigationSettings.panel" value="3" />

            <table>
            <spring:bind path="student.professionDescription">
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

            <spring:bind path="student.languageFirstCode">
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.firstlanguage" /></td>
                        <c:if test="${editPersonalData}">
                             <td>
                                <select name="${status.expression}">
                                    <option value=""><fmt:message key="jsp.selectbox.choose" /></option>
                                    <c:forEach var="language" items="${allLanguages}">
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
                             <c:forEach var="language" items="${allLanguages}">
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

            <tr>
                <td class="label"><b><fmt:message key="jsp.general.firstlanguage.masteringlevel" /></b></td>
                <c:if test="${editPersonalData}">
                    <td class="required">
                        <form:select path="student.languageFirstMasteringLevelCode">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="masteringLevel" items="${studentForm.allMasteringLevels}">
                                <form:option value="${masteringLevel.code}">${masteringLevel.description}</form:option>
                            </c:forEach>
                        </form:select>
                    </td>
                </c:if>

                <c:if test="${showPersonalData}">
                    <td>
                        <c:out value="${studentForm.codeToMasteringLevelMap[student.languageFirstMasteringLevelCode].description }"></c:out>
                    </td>
                </c:if>
                <td><form:errors cssClass="error" path="student.languageFirstMasteringLevelCode"/></td>
            </tr>

            <spring:bind path="student.languageSecondCode">
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.secondlanguage" /></td>
                        <c:if test="${editPersonalData}">
                            <td>
                                <select name="${status.expression}">
                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                    <c:forEach var="language" items="${allLanguages}">
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
                           <c:forEach var="language" items="${allLanguages}">
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
        
            <tr>
                <td class="label"><b><fmt:message key="jsp.general.secondlanguage.masteringlevel" /></b></td>
                <c:if test="${editPersonalData}">
                    <td >
                        <form:select path="student.languageSecondMasteringLevelCode">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="masteringLevel" items="${studentForm.allMasteringLevels}">
                                <form:option value="${masteringLevel.code}">${masteringLevel.description}</form:option>
                            </c:forEach>
                        </form:select>
                    </td>
                </c:if>

                <c:if test="${showPersonalData}">
                    <td>
                        <c:out value="${studentForm.codeToMasteringLevelMap[student.languageSecondMasteringLevelCode].description }"></c:out>
                    </td>
                </c:if>
                <td><form:errors cssClass="error" path="student.languageSecondMasteringLevelCode"/></td>
            </tr>
        
             <spring:bind path="student.languageThirdCode">
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.thirdlanguage" /></td>
                        <c:if test="${editPersonalData}">
                            <td>
                                <select name="${status.expression}">
                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                    <c:forEach var="language" items="${allLanguages}">
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
                            <c:forEach var="language" items="${allLanguages}">
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
                <td class="label"><b><fmt:message key="jsp.general.thirdlanguage.masteringlevel" /></b></td>
                <c:if test="${editPersonalData}">
                    <td>
                        <form:select path="student.languageThirdMasteringLevelCode">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="masteringLevel" items="${studentForm.allMasteringLevels}">
                                <form:option value="${masteringLevel.code}">${masteringLevel.description}</form:option>
                            </c:forEach>
                        </form:select>
                    </td>
                </c:if>

                <c:if test="${showPersonalData}">
                    <td>
                        <c:out value="${studentForm.codeToMasteringLevelMap[student.languageThirdMasteringLevelCode].description }"></c:out>
                    </td>
                </c:if>
                <td><form:errors cssClass="error" path="student.languageThirdMasteringLevelCode"/></td>
            </tr>

            <spring:bind path="student.contactPersonEmergenciesName">
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.contactice" /></td>
                        <c:if test="${editPersonalData}">
                             <td><input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" /></td>
                        </c:if>
                        <c:if test="${showPersonalData}">
                            <td><c:out value="${status.value}"/></td>
                        </c:if>
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                    </tr>
            </spring:bind>
 
            <spring:bind path="student.contactPersonEmergenciesTelephoneNumber">
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

            <tr>
                <td class="label"><b><fmt:message key="jsp.general.bloodtype" /></b></td>
                <c:if test="${editPersonalData}">
                    <td>
                        <form:select path="student.bloodTypeCode">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="bloodType" items="${studentForm.allBloodTypes}">
                                <form:option value="${bloodType.code}">${bloodType.description}</form:option>
                            </c:forEach>
                        </form:select>
                    </td>
                </c:if>

                <c:if test="${showPersonalData}">
                    <td>
                        <c:out value="${studentForm.codeToBloodTypeMap[student.bloodTypeCode].description }"/>
                    </td>
                </c:if>
                <td><form:errors cssClass="error" path="student.bloodTypeCode"/></td>
            </tr>

            <c:choose>
                <c:when test="${readMedicalData}">
                    <spring:bind path="student.healthIssues">
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

                <tr>
                    <td class="label"><fmt:message key="jsp.general.active" /></td>
                    <c:if test="${editPersonalData}">
                        <td>
                            <form:select path="student.active">
                                <form:option value="Y"><fmt:message key="jsp.general.yes" /></form:option>
                                <form:option value="N"><fmt:message key="jsp.general.no" /></form:option>
                            </form:select>
                        </td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <td><fmt:message key="${stringToYesNoMap[student.active]}"/></td>
                    </c:if>
                    <td><form:errors cssClass="error" path="student.active"/></td>
                </tr>

                <tr>
                    <td class="label"><fmt:message key="jsp.general.publichomepage" /></td>
                    <c:if test="${editPersonalData}">
                        <td>
                            <form:select path="student.publicHomepage">
                                <form:option value="Y"><fmt:message key="jsp.general.yes" /></form:option>
                                <form:option value="N"><fmt:message key="jsp.general.no" /></form:option>
                            </form:select>
                        </td>
                    </c:if>
                    <c:if test="${showPersonalData}">
                        <td><fmt:message key="${stringToYesNoMap[student.publicHomepage]}"/></td>
                    </c:if>
                    <td><form:errors cssClass="error" path="student.publicHomepage"/></td>
                </tr>

            <spring:bind path="student.socialNetworks">
                     <tr>
                        <td class="label"><fmt:message key="jsp.general.socialnetworks" /></td>
                        <c:if test="${editPersonalData}">
                            <td>
                                <textarea cols="30" rows="10" name="${status.expression}" ><c:out value="${status.value}"/></textarea>
                            </td>
                        </c:if>
                        <c:if test="${showPersonalData}">
                                <td><c:out value="${status.value}"/></td>
                        </c:if>
                        <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
                    </tr>
            </spring:bind>

            <spring:bind path="student.hobbies">
                    <tr>
                         <td class="label"><fmt:message key="jsp.general.hobbies" /></td>
                         <c:if test="${editPersonalData}">
                           <td>
                                <textarea cols="30" rows="10" name="${status.expression}" ><c:out value="${status.value}"/></textarea>
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
                    <input type="button" name="submitmiscellaneousdata" value="<fmt:message key="jsp.button.submit" />" onclick="this.form.submit();" />
                </c:if>        
            </td>
        </tr>
    </table>
</form:form>
     </div> <!--  end accordionpanelcontent -->
 </div> <!--  end accordionpanel -->
</c:if>

<c:if test="${studentName != null && studentName != ''}">

    <spring:bind path="student.hasPhoto">
        <c:set var="hasPhoto" value="${status.value}" scope="page" />
    </spring:bind>

    <div class="AccordionPanel">
        <div class="AccordionPanelTab"><fmt:message key="jsp.general.photograph" /></div>
        <div class="AccordionPanelContent">

            <table>
                <tr>
                    <td/>
                
                    <td valign="top">     
                        <script type="text/javascript">
                            function deletePhotograph() {
                                document.photographdata.deletephoto.value = "true";
                                document.photographdata.submit();
                            }
                        </script>
                        <!-- getter in Person-class, showing whether person has photo or not -->        
                        <c:if test="${hasPhoto}">
                            <spring:bind path="student.id">
                                &nbsp;&nbsp;&nbsp;
                                <img src="<c:url value='/college/photographview.view?personId=${status.value}&tab=0&panel=4&currentPageNumber=${navigationSettings.currentPageNumber}'/>" width="100" alt="photo_${status.value}" title="photo_${status.value}" />
                                <c:if test="${editPersonalData}">
                                    <a href="JavaScript:deletePhotograph()" onclick="return confirm('<fmt:message key="jsp.photograph.delete.confirm" />')">
                                        <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                    </a>
                                </c:if>
                            </spring:bind>
                        </c:if>
                    </td>
                    <td>
                        <c:if test="${hasPhoto}">
                            <table>
                                <tr><td width="80"><fmt:message key="jsp.general.width"/>:</td><td>${studentForm.photographProperties.width}</td></tr>
                                <tr><td><fmt:message key="jsp.general.height"/>:</td><td>${studentForm.photographProperties.height}</td></tr>
                                <tr><td><fmt:message key="jsp.general.size"/>:</td><td>${studentForm.photographProperties.size}</td></tr>
                                <tr><td><fmt:message key="jsp.general.type"/>:</td><td><c:out value="${studentForm.photographProperties.type}"/></td></tr>
                            </table>
    <%--                        <fmt:message key="jsp.general.width"/>: <fmt:formatNumber value="${studentForm.photographProperties.width}" /> <br />
                            <fmt:message key="jsp.general.height"/>: <fmt:formatNumber value="${studentForm.photographProperties.height}" /> <br />
                            <fmt:message key="jsp.general.size"/>: <fmt:formatNumber value="${studentForm.photographProperties.size}" /><br />
                            <fmt:message key="jsp.general.type"/>: ${studentForm.photographProperties.type}<br /> --%>
                        </c:if>
                    </td>
                </tr>

                <tr><td colspan="2">&nbsp;</td></tr>
                <c:if test="${editPersonalData}">
                     <c:choose>        
                        <c:when test="${ not empty showPhotoTypeError }">       
                            <tr>
                                <td align="left" colspan="2">
                                    <p class="errorwide">
                                        <c:out value="${showPhotoTypeError}"/>
                                    </p>
                                </td>
                            </tr>
                        </c:when>
                    </c:choose>

                    <form name="photographdata" id="photographdata" action="<c:url value='/college/photographdata.view'/>" enctype='multipart/form-data' method="post">
<%--                        <input type="hidden" name="tab_personaldata" value="${accordion}" />
                        <input type="hidden" name="panel_photograph" value="4" />
                        <input type="hidden" name="submitFormObject_photographdata" id="submitFormObject_photographdata" value="" /> --%>
                        <input type="hidden" id="navigationSettings.tab" name="navigationSettings.tab" value="${accordion}" />
                        <input type="hidden" id="navigationSettings.panel" name="navigationSettings.panel" value="4" />

                        <%-- For the FileUploadController: tab, panel etc. --%>
                        <input type="hidden" name="tab" value="${accordion}" />
                        <input type="hidden" name="panel" value="4" />

                        <tr>
                            <c:choose>
                                <c:when test="${studentName != null && studentName != ''}">
                                    <input type="hidden" name="from" value="student" />
                                </c:when>
                            </c:choose>
                            <spring:bind path="student.personId"> 
                               <input type="hidden" name="personId" value="<c:out value="${status.value}" />" />
                            </spring:bind>
                            <input type="hidden" name="deletephoto" value="false" />
                            <td class="label">
                                <spring:bind path="student.hasPhoto"> 
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
                                <input type="file" name="file" />                                   
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="right"><input type="button" name="submitphotographdata" value="<fmt:message key="jsp.button.submit" />" onclick="document.photographdata.submit();" /><br /><br /></td>
                        </tr>
                    </form>
                </c:if>

            </table>

        </div> <!--  end accordionpanelcontent -->
    </div>  <!--  end accordionpanel -->
</c:if>

<c:if test="${studentName != null && studentName != ''}">
        
    <div class="AccordionPanel">
        <div class="AccordionPanelTab"><fmt:message key="jsp.general.remarks" /></div>
        <div class="AccordionPanelContent">
<%--             <form name="remarksdata" id="remarksdata" method="post"> --%>
        <form:form modelAttribute="studentForm.studentFormShared" method="post">
            <%-- navigationsettings.tab/panel should be in the one and only global form --%>
            <input type="hidden" name="studentFormShared.navigationSettings.tab" value="${accordion}" />
            <input type="hidden" name="studentFormShared.navigationSettings.panel" value="5" />

            <table>
                <spring:bind path="student.remarks">
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.remarks" /></td>
                        <td>
                            <c:if test="${editPersonalData}">
                                <textarea cols="30" rows="10" name="${status.expression}" ><c:out value="${status.value}"/></textarea>
                            </c:if>
                            <c:if test="${showPersonalData}">
                                <c:out value="${status.value}"/>
                            </c:if>
                        </td>
                        <td>
                            <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                        </td>
                    </tr>
                    <c:if test="${editPersonalData}">
                        <tr>
                            <td class="label">&nbsp;</td>
                            <td>&nbsp;</td>
                            <td><input type="button" name="submitremarksdata" value="<fmt:message key="jsp.button.submit" />" onclick="this.form.submit();" /></td>
                        </tr>
                    </c:if>
                </spring:bind>

                </table>
            </form:form>
         </div> <!--  end of accordionpanelcontent -->
    </div> <!--  end of accordionpanel -->   
</c:if>
                                    
<c:choose>
<c:when test="${studentName != null && studentName != ''}">
    <div class="AccordionPanel">
        <div class="AccordionPanelTab"><fmt:message key="jsp.general.family" /></div>
        <div class="AccordionPanelContent">

<%--             <form name="familydata"  id="familydata" method="post"> --%>
        <form:form modelAttribute="studentForm.studentFormShared" method="post">
            <%-- navigationsettings.tab/panel should be in the one and only global form --%>
            <input type="hidden" name="studentFormShared.navigationSettings.tab" value="${accordion}" />
            <input type="hidden" name="studentFormShared.navigationSettings.panel" value="6" />

                <table>

                    <tr>
                        <td class="label"><fmt:message key="jsp.general.fatherfullname" /></td>
                        <c:if test="${editPersonalData}">
                            <td><form:input path="student.fatherFullName" size="40"/></td>
                        </c:if>
                        <c:if test="${showPersonalData}">
                            <td><c:out value="${student.fatherFullName}"/></td>
                        </c:if>
                        <td><form:errors cssClass="error" path="student.fatherFullName"/></td>
                    </tr>
<%--                     <spring:bind path="student.fatherFullName"> --%>
<%--                         <% request.setAttribute("label", "jsp.general.fatherfullname"  ); %> --%>
<%--                         <jsp:include page="../../includes/inputField.jsp" flush="true" /> --%>
<%--                     </spring:bind> --%>

                    <!-- telephone number father -->
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.fathertelephone" /></td>
                        <c:if test="${editPersonalData}">
                            <td><form:input path="student.fatherTelephone" size="40"/></td>
                        </c:if>
                        <c:if test="${showPersonalData}">
                            <td><c:out value="${student.fatherTelephone}"/></td>
                        </c:if>
                        <td>
                            <c:if test="${editPersonalData}"><fmt:message key="jsp.message.format.telephone"/></c:if>
                            <form:errors cssClass="error" path="student.fatherTelephone"/>
                        </td>
                    </tr>
<%--                     <c:if test="${editPersonalData || showPersonalData}"> --%>
<%--                         <spring:bind path="student.fatherTelephone"> --%>
<%--                            <% request.setAttribute("label", "jsp.general.fathertelephone"  ); %> --%>
<%--                             <jsp:include page="../../includes/inputFieldTelephone.jsp" flush="true" /> --%>
<%--                         </spring:bind> --%>
<%--                     </c:if> --%>

                    <tr>
                        <td class="label"><fmt:message key="jsp.general.fathereducation" /></td>
                        <c:if test="${editPersonalData}">
                            <td>
                                <form:select path="student.fatherEducationCode">
                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                    <form:options items="${webLookups.list['levelOfEducation']}" itemValue="code" itemLabel="description" />
                                </form:select>
                            </td>
                        </c:if>
                        <c:if test="${showPersonalData}">
                            <td><c:out value="${webLookups.map['levelOfEducation'][student.fatherEducationCode].description}"/></td>
                        </c:if>
                        <td><form:errors cssClass="error" path="student.fatherEducationCode"/></td>
                    </tr>
<%--                     <spring:bind path="student.fatherEducationCode"> --%>
<%--                         <% request.setAttribute("label", "jsp.general.fathereducation"  ); %> --%>
<%--                         <% request.setAttribute("allLookups", request.getAttribute("allLevelsOfEducation") ); %> --%>
<%--                         <jsp:include page="../../includes/dropdown.jsp" flush="true" /> --%>
<%--                     </spring:bind> --%>

                    <tr>
                        <td class="label"><fmt:message key="jsp.general.fatherprofession" /></td>
                        <c:if test="${editPersonalData}">
                            <td><form:input path="student.fatherProfessionDescription" size="40"/></td>
                        </c:if>
                        <c:if test="${showPersonalData}">
                            <td><c:out value="${student.fatherProfessionDescription}"/></td>
                        </c:if>
                        <td><form:errors cssClass="error" path="student.fatherProfessionDescription"/></td>
                    </tr>
<%--                     <spring:bind path="student.fatherProfessionDescription"> --%>
<%--                         <% request.setAttribute("label", "jsp.general.fatherprofession"  ); %> --%>
<%--                         <jsp:include page="../../includes/inputField.jsp" flush="true" /> --%>
<%--                     </spring:bind> --%>

                    <tr>
                        <td class="label"><fmt:message key="jsp.general.motherfullname" /></td>
                        <c:if test="${editPersonalData}">
                            <td><form:input path="student.motherFullName" size="40"/></td>
                        </c:if>
                        <c:if test="${showPersonalData}">
                            <td><c:out value="${student.motherFullName}"/></td>
                        </c:if>
                        <td><form:errors cssClass="error" path="student.motherFullName"/></td>
                    </tr>
<%--                     <spring:bind path="student.motherFullName"> --%>
<%--                         <% request.setAttribute("label", "jsp.general.motherfullname"  ); %> --%>
<%--                         <jsp:include page="../../includes/inputField.jsp" flush="true" /> --%>
<%--                     </spring:bind> --%>

                    <!-- telephone number mother -->
                    <tr>
                        <td class="label"><fmt:message key="jsp.general.mothertelephone" /></td>
                        <c:if test="${editPersonalData}">
                            <td><form:input path="student.motherTelephone" size="40"/></td>
                        </c:if>
                        <c:if test="${showPersonalData}">
                            <td><c:out value="${student.motherTelephone}"/></td>
                        </c:if>
                        <td>
                            <c:if test="${editPersonalData}"><fmt:message key="jsp.message.format.telephone"/></c:if>
                            <form:errors cssClass="error" path="student.motherTelephone"/>
                        </td>
                    </tr>
<%--                     <c:if test="${editPersonalData || showPersonalData}"> --%>
<%--                         <spring:bind path="student.motherTelephone"> --%>
<%--                            <% request.setAttribute("label", "jsp.general.mothertelephone"  ); %> --%>
<%--                             <jsp:include page="../../includes/inputFieldTelephone.jsp" flush="true" /> --%>
<%--                         </spring:bind> --%>
<%--                     </c:if> --%>

                    <tr>
                        <td class="label"><fmt:message key="jsp.general.mothereducation" /></td>
                        <c:if test="${editPersonalData}">
                            <td>
                                <form:select path="student.motherEducationCode">
                                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                    <form:options items="${webLookups.list['levelOfEducation']}" itemValue="code" itemLabel="description" />
                                </form:select>
                            </td>
                        </c:if>
                        <c:if test="${showPersonalData}">
                            <td><c:out value="${webLookups.map['levelOfEducation'][student.motherEducationCode].description}"/></td>
                        </c:if>
                        <td><form:errors cssClass="error" path="student.motherEducationCode"/></td>
                    </tr>
<%--                     <spring:bind path="student.motherEducationCode"> --%>
<%--                         <% request.setAttribute("label", "jsp.general.mothereducation"  ); %> --%>
<%--                         <% request.setAttribute("allLookups", request.getAttribute("allLevelsOfEducation") ); %> --%>
<%--                         <jsp:include page="../../includes/dropdown.jsp" flush="true" /> --%>
<%--                     </spring:bind> --%>

                    <tr>
                        <td class="label"><fmt:message key="jsp.general.motherprofession" /></td>
                        <c:if test="${editPersonalData}">
                            <td><form:input path="student.motherProfessionDescription" size="40"/></td>
                        </c:if>
                        <c:if test="${showPersonalData}">
                            <td><c:out value="${student.motherProfessionDescription}"/></td>
                        </c:if>
                        <td><form:errors cssClass="error" path="student.motherProfessionDescription"/></td>
                    </tr>
<%--                     <spring:bind path="student.motherProfessionDescription"> --%>
<%--                         <% request.setAttribute("label", "jsp.general.motherprofession"  ); %> --%>
<%--                         <jsp:include page="../../includes/inputField.jsp" flush="true" /> --%>
<%--                     </spring:bind> --%>

                    <tr>
                        <td class="label"><fmt:message key="jsp.general.financialguardianfullname" /></td>
                        <c:if test="${editPersonalData}">
                            <td><form:input path="student.financialGuardianFullName" size="40"/></td>
                        </c:if>
                        <c:if test="${showPersonalData}">
                            <td><c:out value="${student.financialGuardianFullName}"/></td>
                        </c:if>
                        <td><form:errors cssClass="error" path="student.financialGuardianFullName"/></td>
                    </tr>
<%--                     <spring:bind path="student.financialGuardianFullName"> --%>
<%--                         <% request.setAttribute("label", "jsp.general.financialguardianfullname"  ); %> --%>
<%--                         <jsp:include page="../../includes/inputField.jsp" flush="true" /> --%>
<%--                     </spring:bind> --%>

                    <tr>
                        <td class="label"><fmt:message key="jsp.general.financialguardianrelation" /></td>
                        <c:if test="${editPersonalData}">
                            <td><form:textarea path="student.financialGuardianRelation"/></td>
                        </c:if>
                        <c:if test="${showPersonalData}">
                            <td><c:out value="${student.financialGuardianRelation}"/></td>
                        </c:if>
                        <td><form:errors cssClass="error" path="student.financialGuardianRelation"/></td>
                    </tr>
<%--                     <spring:bind path="student.financialGuardianRelation"> --%>
<%--                         <% request.setAttribute("label", "jsp.general.financialguardianrelation"  ); %> --%>
<%--                         <jsp:include page="../../includes/textareaAuto.jsp" flush="true" /> --%>
<%--                     </spring:bind> --%>

                    <tr>
                        <td class="label"><fmt:message key="jsp.general.financialguardianprofession" /></td>
                        <c:if test="${editPersonalData}">
                            <td><form:textarea path="student.financialGuardianProfession"/></td>
                        </c:if>
                        <c:if test="${showPersonalData}">
                            <td><c:out value="${student.financialGuardianProfession}"/></td>
                        </c:if>
                        <td><form:errors cssClass="error" path="student.financialGuardianProfession"/></td>
                    </tr>
<%--                     <spring:bind path="student.financialGuardianProfession"> --%>
<%--                         <% request.setAttribute("label", "jsp.general.financialguardianprofession"  ); %> --%>
<%--                         <jsp:include page="../../includes/textareaAuto.jsp" flush="true" /> --%>
<%--                     </spring:bind> --%>

                    <tr>
                        <td class="label">&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>
                            <c:if test="${editPersonalData}">
                                <input type="button" name="submitfamilydata" value="<fmt:message key="jsp.button.submit" />" onclick="this.form.submit();" />
                            </c:if>
                        </td>
                    </tr>
                </table>
            </form:form>
        </div> <!--  end accordionpanelcontent -->
    </div> <!--  end accordionpanel -->

    <!-- NOTES ON: student activities, career preferences, counseling and placements -->
    <c:if test="${editStudentNotes || showStudentNotes || editCounseling || showCounseling}">
    <div class="AccordionPanel">
        <div class="AccordionPanelTab"><fmt:message key="jsp.general.studentnotes" /></div>
        <div class="AccordionPanelContent">
            <form name="studentnotes" id="studentnotes" method="post">
                <input type="hidden" name="tab_personaldata" value="0" /> 
                <input type="hidden" name="panel_studentnotes" value="7" />
                <c:if test="${editStudentNotes || showStudentNotes}">
                    <table>

                    <!-- activities -->
                    <tr>
                        <td colspan="2" class="header">
                            <fmt:message key="jsp.general.studentactivities" />
                        </td>
                        <c:if test="${editStudentNotes}">
                            <td align="right">
                                <a class="button" href="<c:url value='/college/note.view?noteType=A&amp;tabtext=jsp.general.studentactivities&amp;paneltext=jsp.general.studentactivity&amp;tab=${accordion}&amp;panel=7&amp;studentId=${studentId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                            </td>
                        </c:if>
                    </tr>
                    <tr><td colspan="3">&nbsp;</td></tr>
                    <c:forEach var="studentActivity" items="${studentActivities}">
                        <tr>
                            <td>&nbsp;</td>
                            <td width="400"><c:out value="${studentActivity.description}"/></td>
                            <td align="right">
                                <c:if test="${editStudentNotes}">
                                <%-- = OpusConstants.NOTETYPE_ACTIVITY_SHORT --%>
                                    <a class="imageLink" href="<c:url value='/college/note.view?noteType=A&amp;tabtext=jsp.general.studentactivities&amp;paneltext=jsp.general.studentactivity&amp;tab=${accordion}&amp;panel=7&amp;studentId=${studentId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}&amp;noteId=${studentActivity.id}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                    <a href="<c:url value='/college/note_delete.view?noteType=A&amp;tab=${accordion}&amp;panel=7&amp;studentId=${studentId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}&amp;noteId=${studentActivity.id}'/>" onclick="return confirm('<fmt:message key="jsp.studentactivity.delete.confirm" />')">
                                    <img class="imageLinkPaddingLeft" src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>

                    <!-- career -->
                    <tr><td colspan="3">&nbsp;</td></tr>
                    <tr>
                        <td colspan="2" class="header">
                            <fmt:message key="jsp.general.studentcareers" />
                        </td>
                        <c:if test="${editStudentNotes}">
                            <td align="right">
                                <a class="button" href="<c:url value='/college/note.view?noteType=C&amp;tabtext=jsp.general.studentcareers&amp;paneltext=jsp.general.studentcareer&amp;tab=${accordion}&amp;panel=7&amp;studentId=${studentId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                            </td>
                        </c:if>
                    </tr>
                    <tr><td colspan="3">&nbsp;</td></tr>
                    
                    <c:forEach var="studentCareer" items="${studentCareers}">
                        <tr>
                            <td>&nbsp;</td>
                            <td width="400"><c:out value="${studentCareer.description}"/></td>
                            <td align="right">
                                <c:if test="${editStudentNotes}">
                                    <a class="imageLink" href="<c:url value='/college/note.view?noteType=C&amp;tabtext=jsp.general.studentcareers&amp;paneltext=jsp.general.studentcareer&amp;tab=${accordion}&amp;panel=7&amp;studentId=${studentId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}&amp;noteId=${studentCareer.id}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                    <a class="imageLinkPaddingLeft" href="<c:url value='/college/note_delete.view?noteType=C&amp;tab=${accordion}&amp;panel=7&amp;studentId=${studentId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}&amp;noteId=${studentCareer.id}'/>" onclick="return confirm('<fmt:message key="jsp.studentcareer.delete.confirm" />')">
                                        <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>                                            
                    
                    <!-- placements -->
                    <tr><td colspan="3">&nbsp;</td></tr>
                    <tr>
                        <td colspan="2" class="header">
                            <fmt:message key="jsp.general.studentplacements" />
                        </td>
                        <c:if test="${editStudentNotes}">
                            <td align="right">
                                <a class="button" href="<c:url value='/college/note.view?noteType=P&amp;tabtext=jsp.general.studentplacements&amp;paneltext=jsp.general.studentplacement&amp;tab=${accordion}&amp;panel=7&amp;studentId=${studentId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                            </td>
                        </c:if>
                    </tr>
                    <tr><td colspan="3">&nbsp;</td></tr>
                    
                    <c:forEach var="studentPlacement" items="${studentPlacements}">
                        <tr>
                            <td>&nbsp;</td>
                            <td width="400"><c:out value="${studentPlacement.description}"/></td>
                            <td align="right">
                                <c:if test="${editStudentNotes}">
                                    <a class="imageLink" href="<c:url value='/college/note.view?noteType=P&amp;tabtext=jsp.general.studentplacements&amp;paneltext=jsp.general.studentplacement&amp;tab=${accordion}&amp;panel=7&amp;studentId=${studentId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}&amp;noteId=${studentPlacement.id}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                    <a class="imageLinkPaddingLeft" href="<c:url value='/college/note_delete.view?noteType=P&amp;tab=${accordion}&amp;panel=7&amp;studentId=${studentId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}&amp;noteId=${studentPlacement.id}'/>" onclick="return confirm('<fmt:message key="jsp.studentplacement.delete.confirm" />')">
                                        <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <!-- counseling -->
                     <c:if test="${editStudentCounseling || showStudentCounseling}">
                        <tr><td colspan="3">&nbsp;</td></tr>
                        <tr>
                            <td colspan="2" class="header">
                                <fmt:message key="jsp.general.studentcounselings" />
                            </td>
                            <c:if test="${editStudentCounseling}">
                                <td align="right">
                                    <a class="button" href="<c:url value='/college/note.view?noteType=O&amp;tabtext=jsp.general.studentcounselings&amp;paneltext=jsp.general.studentcounseling&amp;tab=${accordion}&amp;panel=7&amp;studentId=${studentId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.href.add" /></a>
                                </td>
                            </c:if>
                        </tr>
                        <tr><td colspan="3">&nbsp;</td></tr>
                        
                        <c:forEach var="studentCounseling" items="${studentCounselings}">
                            <tr>
                                <td>&nbsp;</td>
                                <td width="400"><c:out value="${studentCounseling.description}"/></td>
                                <td align="right">
                                    <c:if test="${editStudentCounseling}">
                                        <a class="imageLink" href="<c:url value='/college/note.view?noteType=O&amp;tabtext=jsp.general.studentcounselings&amp;paneltext=jsp.general.studentcounseling&amp;tab=${accordion}&amp;panel=7&amp;studentId=${studentId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}&amp;noteId=${studentCounseling.id}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                        <a class="imageLinkPaddingLeft" href="<c:url value='/college/note_delete.view?noteType=O&amp;tab=${accordion}&amp;panel=7&amp;studentId=${studentId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}&amp;noteId=${studentCounseling.id}'/>" onclick="return confirm('<fmt:message key="jsp.studentcounseling.delete.confirm" />')">
                                        <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                        </a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>                                            
                    </c:if>
                    
                    </table>
                </c:if>
            </form>
        </div> <!--  end accordionpanelcontent -->
    </div> <!--  end accordionpanel -->
    </c:if>
</c:when>
</c:choose>
