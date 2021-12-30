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
    <tr>
        <td class="label"><fmt:message key="jsp.general.nationality" /></td>
        <td>
            <form:select path="student.nationalityCode">
                <form:option value="0">
                    <fmt:message key="jsp.selectbox.choose" />
                </form:option>
                <form:options items="${allNationalities}" itemValue="code" itemLabel="description" />
            </form:select>
        </td>
    </tr>
    <tr>
        <td class="label"><fmt:message key="jsp.general.countryofbirth" /></td>
        <td>
            <form:select path="student.countryOfBirthCode" onchange="document.getElementById('navigationSettings.panel').value='2';document.formdata.submit();">
                <form:option value="0">
                    <fmt:message key="jsp.selectbox.choose" />
                </form:option>
                <form:options items="${allCountries}" itemValue="code" itemLabel="description" />
            </form:select>
        </td>
    </tr>
    
    <tr>
        <td class="label"><fmt:message key="jsp.general.provinceofbirth" /></td>
        <td>
            <form:select path="student.provinceOfBirthCode" onchange="document.getElementById('navigationSettings.panel').value='2';document.formdata.submit();">
                <form:option value="0">
                    <fmt:message key="jsp.selectbox.choose" />
                </form:option>
                <form:options items="${allProvincesOfBirth}" itemValue="code" itemLabel="description" />
            </form:select>
        </td>
    </tr>
    
    <tr>
        <td class="label"><fmt:message key="jsp.general.districtofbirth" /></td>
        <td>
            <form:select path="student.districtOfBirthCode">
                <form:option value="0">
                    <fmt:message key="jsp.selectbox.choose" />
                </form:option>
                <form:options items="${allDistrictsOfBirth}" itemValue="code" itemLabel="description" />
            </form:select>
        </td>
    </tr>

    <tr>
        <td class="label"><fmt:message key="jsp.general.placeofbirth" /></td>
        <td><input type="text" name="student.placeOfBirth" size="40" value="<c:out value="${student.placeOfBirth}" />" /></td>
    </tr>

    <tr>
        <td class="label"><fmt:message key="jsp.general.countryoforigin" /></td>
        <td>
            <form:select path="student.countryOfOriginCode" onchange="document.getElementById('navigationSettings.panel').value='2';document.formdata.submit();">
                <form:option value="0">
                    <fmt:message key="jsp.selectbox.choose" />
                </form:option>
                <form:options items="${allCountries}" itemValue="code" itemLabel="description" />
            </form:select>
        </td>
    </tr>
    <tr>
        <td class="label"><fmt:message key="jsp.general.provinceoforigin" /></td>
        <td>
            <form:select path="student.provinceOfOriginCode" onchange="document.getElementById('navigationSettings.panel').value='2';document.formdata.submit();">
                <form:option value="0">
                    <fmt:message key="jsp.selectbox.choose" />
                </form:option>
                <form:options items="${allProvincesOfOrigin}" itemValue="code" itemLabel="description" />
            </form:select>
        </td>
    </tr>

    <tr>
        <td class="label"><fmt:message key="jsp.general.districtoforigin" /></td>
        <td>
           <form:select path="student.districtOfOriginCode">
                <form:option value="0">
                    <fmt:message key="jsp.selectbox.choose" />
                </form:option>
                <form:options items="${allDistrictsOfOrigin}" itemValue="code" itemLabel="description" />
            </form:select>
        </td>
    </tr>
    
    <tr>
        <td class="label"><fmt:message key="jsp.general.cityoforigin" /></td>
        <td><input type="text" name="student.cityOfOrigin" size="40" value="<c:out value="${student.cityOfOrigin}" />" /></td>
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
         
                
   
