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
<div class="AccordionPanel">
    <div class="AccordionPanelTab"><fmt:message key="jsp.general.previousinstitution.information" /></div>
    <div class="AccordionPanelContent">
        <input type="hidden" name="tab_studyplan" value="<c:out value='${accordion}'/>" /> 
        <input type="hidden" name="panel_previousinstitutiondata" value="1" />

        <table>
            <tr>
                <td class="label"><fmt:message key="jsp.general.previousinstitution" /></td>
                <td>
                   <form:select path="student.previousInstitutionId">
                        <form:option value="0"><fmt:message key="jsp.selectbox.choose" /></form:option>
                        <form:options items="${requestAdmissionForm.allPreviousInstitutions}" itemValue="id" itemLabel="institutionDescription" />
                    </form:select>
                </td> 
            </tr>
            <tr>
                <td class="label"></td>
                <td colspan="2">
                    <table>
                        <tr><td class="label" colspan="2"><fmt:message key="jsp.general.message.previousinstitution" /></td></tr>
                        <tr>
                            <td><fmt:message key="jsp.general.previousinstitutionname" /></td>
                            <td><form:input path="student.previousInstitutionName" size="40" /></td>
                        </tr>
                        <tr>
                            <td><fmt:message key="jsp.general.previousinstitutioncountry" /></td>
                            <td><spring:bind path="requestAdmissionForm.student.previousInstitutionCountryCode">
        
                                <select id="${status.expression}" name="${status.expression}" onchange="
                                                        document.getElementById('navigationSettings.panel').value='4';
                                                        document.getElementById('student.previousInstitutionProvinceCode').value='0';
                                                        document.getElementById('student.previousInstitutionDistrictCode').value='0';
                                                        document.formdata.submit();"> <!--  -->
                                     <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                                     <c:forEach var="previousInstitutionCountry" items="${allCountriesForPreviousInstitution}">
                                        <c:choose>
                                            <c:when test="${previousInstitutionCountry.code == status.value}">
                                                <option value="<c:out value='${previousInstitutionCountry.code}'/>" selected="selected"><c:out value='${previousInstitutionCountry.description}'/></option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="<c:out value='${previousInstitutionCountry.code}'/>"><c:out value='${previousInstitutionCountry.description}'/></option>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach> 
                                </select>
                            </td>
                            <td><%@ include file="../includes/errorMessages.jsp" %></td>
                            </spring:bind></td>
                        </tr>
                        <tr>
                            <td><fmt:message key="jsp.general.previousinstitutionprovince" /></td>
                            <td>
                                <form:select path="student.previousInstitutionProvinceCode" onchange="document.getElementById('navigationSettings.panel').value='4';
                                                                                                document.getElementById('student.previousInstitutionDistrictCode').value='0';
                                                                                                document.formdata.submit();">
                                    <form:option value="0"><fmt:message key="jsp.selectbox.choose" /></form:option>
                                    <form:options items="${allProvincesForPreviousInstitution}" itemValue="code" itemLabel="description" />
                                </form:select>
                            </td>
                        </tr>
                        <tr>
                            <td><fmt:message key="jsp.general.previousinstitutiondistrict" /></td>
                            <td>
                                <form:select path="student.previousInstitutionDistrictCode">
                                    <form:option value="0"><fmt:message key="jsp.selectbox.choose" /></form:option>
                                    <form:options items="${allDistrictsForPreviousInstitution}" itemValue="code" itemLabel="description" />
                                </form:select>
                            </td>
                        </tr>
                        <tr>
                            <td><fmt:message key="jsp.general.previousinstitutioneducationtype" /></td>
                            <td>
                                <form:select path="student.previousInstitutionTypeCode">
                                    <form:option value="0"><fmt:message key="jsp.selectbox.choose" /></form:option>
                                    <form:options items="${allEducationTypes}" itemValue="code" itemLabel="description" />
                                </form:select>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="label"><fmt:message key="jsp.general.previousinstitutionfinalgradetype" /></td>
                <td>
                    <form:select path="student.previousInstitutionFinalGradeTypeCode">
                        <form:option value="0"><fmt:message key="jsp.selectbox.choose" /></form:option>
                        <form:options items="${requestAdmissionForm.allGradeTypes}" itemValue="code" itemLabel="description" />
                    </form:select>
                </td>
            </tr>
            <tr>
                <td class="label"><fmt:message key="jsp.general.previousinstitutionphotographremarks" /></td>
                <td><form:textarea path="student.previousInstitutionDiplomaPhotographRemarks" cols="25" rows="6" /></td>
            </tr>
        </table>
    
        <table>
            <tr><td colspan="3">&nbsp;</td></tr>
            <spring:bind path="requestAdmissionForm.student.previousInstitutionDiplomaPhotograph">
            <tr>
                <td class="label"><fmt:message key="jsp.general.previousinstitutiondiplomaphotograph" /></td>
                <td colspan="2">
                <fmt:message key="jsp.general.formats" />: jpg, jpeg, pdf, doc, rtf
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <input type="file" name="previousDiplomaFile"/>
                </td>
                <td><%@ include file="../includes/errorMessages.jsp" %></td>
            </tr>
            </spring:bind>
        </table>
    </div>  <!--  end accordionpanelcontent -->
</div> <!--  end accordionpanel -->