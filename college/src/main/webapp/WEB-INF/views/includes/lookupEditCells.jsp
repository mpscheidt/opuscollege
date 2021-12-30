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
Checks the lookup type and add the needed values 
in cells according the lookup type
--%>

<c:choose>

    <c:when test="${lookupType == 'Lookup1'}">
        <tr>
        <th><fmt:message key="jsp.general.lookup.shortdescription" /></th>
        <td>
        <input type="text" name="descriptionShort_${appLanguage}"  id="descriptionShort_${appLanguage}" value="<c:out value="${lookupObject.descriptionShort}" />" maxlength="2"/>
        </td></tr>
    </c:when>
    
    <c:when test="${lookupType == 'Lookup3'}">
         <tr>
         <th><fmt:message key="jsp.general.lookup.short2" /></th>
            <td>
                <input type="text" name="short2_${appLanguage}" id="short2_${appLanguage}" value="<c:out value="${lookupObject.short2}" />" maxlength="2"/>
            </td>
        </tr>
         <tr>
         <th><fmt:message key="jsp.general.lookup.short3" /></th>
            <td>
                <input type="text" name="short3_${appLanguage}"  id="short3_${appLanguage}" value="<c:out value="${lookupObject.short3}" />" maxlength="3"/>
            </td>
          </tr>
    </c:when>

    
    
    <c:when test="${lookupType == 'Lookup6'}">
        <tr>
        <th><fmt:message key="jsp.general.title" /></th>
            <td>
              <input type="text" name="title_${appLanguage}" id="title_${appLanguage}" value="<c:out value="${lookupObject.title}" />"/>
            </td>
       </tr>
    </c:when>

    <c:when test="${lookupType == 'Lookup7'}">
        <tr>
         <th><fmt:message key="jsp.general.lookup.continuing" /></th>
            <td>
                <input type="text" name="continuing_${appLanguage}" id="continuing_${appLanguage}" value="<c:out value="${lookupObject.continuing}" />" maxlength="1"/>
            </td>
        </tr>
         <tr>
         <th><fmt:message key="jsp.general.lookup.increment" /></th>
            <td>
                <input type="text" name="increment_${appLanguage}"  id="increment_${appLanguage}" value="<c:out value="${lookupObject.increment}" />" maxlength="3"/>
            </td>
         </tr>
         <tr>
         <th><fmt:message key="jsp.general.lookup.graduating" /></th>
            <td>
                <input type="text" name="graduating_${appLanguage}"  id="graduating_${appLanguage}" value="<c:out value="${lookupObject.graduating}" />" maxlength="3"/>
            </td>
         </tr>
         <tr>
         <th><fmt:message key="jsp.general.lookup.carrying" /></th>
            <td>
                <input type="text" name="carrying_${appLanguage}"  id="carrying_${appLanguage}" value="<c:out value="${lookupObject.carrying}" />" maxlength="3"/>
            </td>
         </tr>
    </c:when>

    <c:when test="${lookupType == 'Lookup8'}">
        <tr>
        <th><fmt:message key="jsp.general.numberofunitsperyear" /></th>
            <td>
              <input type="text" name="nrOfUnitsPerYear_${appLanguage}" id="nrOfUnitsPerYear_${appLanguage}" value="<c:out value="${lookupObject.nrOfUnitsPerYear}" />"/>
            </td>
       </tr>
    </c:when>
    
</c:choose>
