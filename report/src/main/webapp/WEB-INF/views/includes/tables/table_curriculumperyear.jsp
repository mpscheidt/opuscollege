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

<%--<c:set var="allEntities" value="${ctus}"/> --%>
<c:choose>
<c:when test="${empty ctus}">
    <h2 align="center"><fmt:message key="jsp.results.noitemsfound"/></h2>
    <script type="text/javascript">
      setEnabled("#reportButton" , false);
      setEnabled(".reportFormat" , false);
    </script>
</c:when>
</c:choose>
<c:choose>
    <c:when test="${(fn:length(ctus) lt MAX_DISPLAY_ITEMS) || (showAll == true)}">

            <%-- Header with no navigational buttons--%>
        <div id="abc">&nbsp;</div>
        <table class="tabledata" id="TblData">
          <tr>
          <th style="width:5%"><input type="checkbox" id="checker" checked="checked" onclick="javascript:checkAll('where.studyGradeType.id.and.cardinaltimeunitnumber');"/><fmt:message key='jsp.general.all' /></th>
            <th><fmt:message key="jsp.general.studygradetype" /></th>
            <th><fmt:message key="jsp.general.timeunit" /></th>
            <th><fmt:message key="jsp.general.academicyear" /></th>
            
          </tr>
            <c:forEach var="ctu" items="${ctus}">
                    <tr>
                       <td align="center">
                           <input type="checkbox" 
                                   name="where.studyGradeType.id.and.cardinaltimeunitnumber" 
                                   checked="checked"
                                   paramGroup="reportParam"
                                   value="${ctu.studygradetypeid}|${ctu.cardinaltimeunitnumber}" />
                       </td>
                       <td>
                         ${ctu.studygradedescription}
                       </td>
                        <td>
                         <a href="#" name="${ctu.id}" class="reportLink" target="_self"
                         onclick='createReport("<c:url value="/report/curriculaperyear.view" />" 
                                                , "where.studyGradeType.id=" + ${ctu.studygradetypeid} + 
                                                "&where.cardinaltimeunitnumber=${ctu.cardinaltimeunitnumber}"  +
                                                "&" +  buildQueryString("reportFormat"));
                                                
                                                return false;'>
                           ${ctu.cardinaltimeunitdescription} ${ctu.cardinaltimeunitnumber}
                       </a>
                       </td> 
                       <td>
                           ${ctu.academicyear}
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
                     ${fn:length(ctus)}
            </fmt:param>
            </fmt:message>
            <fmt:message key="jsp.results.refinesearch" />

            <a target="_self" href="<c:url value='/report/curriculaperyear.view'/>?showAll=true&<%=request.getQueryString() %>">          
<%--            <a onclick="loadPage(this.href , 'tableDiv');return false;"
                target="_self"
                href="<c:url value='/report/curriculaperyear.view'/>?<%=request.getQueryString() %>&showAll=true"> --%>
                <fmt:message key="jsp.results.showall" />
            </a>
        </h2>
        <script type="text/javascript">
            setEnabled("#reportButton" , false);
            setEnabled(".reportFormat" , false);
        </script>
    </c:otherwise>
</c:choose>
