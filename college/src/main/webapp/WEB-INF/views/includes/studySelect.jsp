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

          <!-- <fmt:message key="jsp.general.study" />
           <form name="studies" action="<c:url value='${action}'/>" method="post" target="_self" onchange="document.studies.submit();">
                <input type="hidden" name="institutionId" value="${institutionId}" />
                <input type="hidden" name="branchId" value="${branchId}" />
                <input type="hidden" name="organizationalUnitid" value="${organizationalUnitid}" />
                <input type="hidden" name="studyGradeTypeId" value="0" />
                <input type="hidden" name="studyYearId" value="0" />
                <input type="hidden" name="yearNumber" value="0" />
                <input type="hidden" id="searchValue" name="searchValue" value="" />
                
                        <select id="studyId" name="primaryStudyId" onchange="document.getElementById('searchValue').value='';document.studies.submit();">
                        -->
                        <select id="studyId" name="primaryStudyId" onchange="this.form.submit();">
                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                            <c:forEach var="oneStudy" items="${allStudies}">
                                <c:choose>
                                <c:when test="${(primaryStudyId != null && primaryStudyId != 0) }"> 
                                    <c:choose>
                                        <c:when test="${oneStudy.id == primaryStudyId}"> 
                                            <option value="${oneStudy.id}" selected="selected">${oneStudy.studyDescription}</option>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="${oneStudy.id}">${oneStudy.studyDescription}</option>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <option value="${oneStudy.id}">${oneStudy.studyDescription}</option>
                               </c:otherwise>
                               </c:choose>
                            </c:forEach>
                        </select>
                                     
                <!-- </form>-->