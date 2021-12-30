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

The Original Code is Opus-College report module code.

The Initial Developer of the Original Code is
Center for Information Services, Radboud University Nijmegen
and Universidade Catolica de Mocambique.
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

<%@ include file="../ajax_imports.jsp"%>
<c:set var="allEntities" value="${items}"/>
<c:choose>
<c:when test="${empty items}">
    <h2 align="center"><fmt:message key="jsp.results.noitemsfound"/></h2>
    <script type="text/javascript">
      setEnabled("#reportButton" , false);
      setEnabled(".reportFormat" , false);
    </script>
</c:when>
</c:choose>
<c:choose>
    <c:when test="${(fn:length(items) lt MAX_DISPLAY_ITEMS) || (showAll == true)}">

                     <%-- Header with no navigational buttons--%>
        <div id="abc">&nbsp;</div>

              <table class="tabledata" id="TblData">

            <tr>
                <th>
                    <c:if test="${multiSelect}">
                        <input type="checkbox" name="checker" id="checker" onclick="javascript:checkAll('where.studyPlanCardinalTimeUnit.id');"/><fmt:message key='jsp.general.all' />
                    </c:if>
                </th>

                <th><fmt:message key="jsp.general.studentcode" /></th>            
                <th><fmt:message key="jsp.general.firstnames" /></th>
                <th><fmt:message key="jsp.general.surname" /></th>
                <th><fmt:message key="jsp.general.study" /></th>
                <th><fmt:message key="jsp.general.timeunit" /></th>
                <th><fmt:message key="jsp.general.active" /></th>
            </tr>
            <c:forEach var="student" items="${items}">
                <tr>
                    <td align="center">
                        <c:choose>
                            <c:when test="${multiSelect}">
                                <input type="checkbox" paramGroup="where.studyPlanCardinalTimeUnit.id" name="where.studyPlanCardinalTimeUnit.id" value="${student.studyPlanCardinalTimeUnitId}">
                            </c:when>
                            <c:otherwise>
                                <input type="radio" paramGroup="where.studyPlanCardinalTimeUnit.id" name="where.studyPlanCardinalTimeUnit.id" value="${student.studyPlanCardinalTimeUnitId}">
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        ${student.studentcode}
                    </td>                        
                    <td>${student.firstnamesfull}</td>
                    <td>
                        <c:choose>
                            <c:when test="${opusUser.personId == student.personid
                             || (opusUserRole.role != 'student' 
                             && opusUserRole.role != 'guest')
                            }">
                            <a href="#" 
                                class="reportLink" 
                                target="_self"
                                onclick='createReport("<c:url value="/report/studyplancardinaltimeunitreport.view" />" 
                                            , "where.studyPlanCardinalTimeUnit.id=${student.studyPlanCardinalTimeUnitId}&downloadFileName=<fmt:message key="${titleKey}"/>_${student.firstnamesfull}_${student.surnamefull}" +  buildQueryStringByClass("reportParam"));return false;'
                                >
                                ${student.surnamefull}</a>
                            </c:when>
                            <c:otherwise>
                                ${student.surnamefull}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        ${student.studydescription} - ${student.gradetypedescription}
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${opusUser.personId == student.personid
                             || (opusUserRole.role != 'student' 
                             && opusUserRole.role != 'guest')
                            }">
                            <a href="#" 
                                class="reportLink" 
                                target="_self"
                                onclick='createReport("<c:url value="/report/studyplancardinaltimeunitreport.view" />" 
                                            , "where.studyPlanCardinalTimeUnit.id=${student.studyPlanCardinalTimeUnitId}&downloadFileName=<fmt:message key="${titleKey}"/>_${student.firstnamesfull}_${student.surnamefull}" +  buildQueryStringByClass("reportParam"));return false;'
                                >
                                ${student.cardinaltimeunitdescription} ${student.cardinaltimeunitnumber}</a>
                            </c:when>
                            <c:otherwise>
                                ${student.cardinaltimeunitdescription} ${student.cardinaltimeunitnumber}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td align="center" width="2%">
                        <c:choose>
                            <c:when test="${student.active == 'Y'}">
                                <fmt:message key="jsp.general.yes" />
                            </c:when>
                            <c:otherwise>
                                <fmt:message key="jsp.general.no" />
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </table>
              </form>
        <script type="text/javascript">
         setEnabled("#reportButton" , true);
         setEnabled(".reportFormat" , true);
         alternate('TblData',true);
        </script>
        <%@ include file="../report_pagingFooter.jsp"%>

    </c:when>
    <c:otherwise>
         <h2>
        <fmt:message key="jsp.results.itemsfound">
            <fmt:param>
                     ${fn:length(items)}
            </fmt:param>
        </fmt:message>
        <fmt:message key="jsp.results.refinesearch" />
 
        <a href="<c:url value='/report/studyplancardinaltimeunitreport.view'/>?<%=request.getQueryString() %>&showAll=true">
          <fmt:message key="jsp.results.showall" />
        </a>
        </h2>
       <script type="text/javascript">
        setEnabled("#reportButton" , false);
        setEnabled(".reportFormat" , false);
    </script>
    </c:otherwise>
</c:choose>
