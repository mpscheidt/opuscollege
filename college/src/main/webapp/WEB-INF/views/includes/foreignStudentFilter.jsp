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
                    <td class="label"><fmt:message key="jsp.general.foreignstudent" /></td>
                    <td width="200">
                    <select name="foreignStudent" id="foreignStudent" onchange="
                            document.getElementById('navigationSettings.currentPageNumber').value='1';
                            document.organizationandnavigation.submit();">
                        <c:set var="allFSelected" value="selected" scope="page" />
                        <c:set var="yesFSelected" value="" scope="page" />
                        <c:set var="noFSelected" value="" scope="page" />
                        <c:if test="${'Y' == foreignStudent}">
                            <c:set var="allFSelected" value="" scope="page" />
                            <c:set var="yesFSelected" value="selected" scope="page" />
                        </c:if>
                        <c:if test="${'N' == foreignStudent}">
                                <c:set var="allFSelected" value="" scope="page" />
                                <c:set var="noFSelected" value="selected" scope="page" />
                        </c:if>
                        
                        <option value="" ${allFSelected}><fmt:message key="jsp.selectbox.choose" /></option>
                        <option value="Y" ${yesFSelected}><fmt:message key="jsp.general.yes" /></option>
                        <option value="N" ${noFSelected}><fmt:message key="jsp.general.no" /></option>
                 
                    </select>
                    </td> 
                    <td></td>
               </tr>
            </table>
