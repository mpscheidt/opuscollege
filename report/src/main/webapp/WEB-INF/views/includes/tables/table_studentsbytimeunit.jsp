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
	
	    <script type="text/javascript">
	      setEnabled("#reportButton" , false);
	      setEnabled(".reportFormat" , false);
	    </script>

	    <c:if test="${ITEM_COUNT != 0}">
	        <h2>
	            <fmt:message key="jsp.results.itemsfound">
	                <fmt:param>${ITEM_COUNT}</fmt:param>
	            </fmt:message>
	            <fmt:message key="jsp.results.refinesearch" />
	
	            <a target="_self" href="<c:url value='/report/studentsByTimeUnit.view'/>?showAll=true&<%=request.getQueryString() %>">          
	                <fmt:message key="jsp.results.showall" />
	            </a>
	        </h2>
	    </c:if>
	
	    <c:if test="${ITEM_COUNT == 0}">
		    <h2 align="center"><fmt:message key="jsp.results.noitemsfound"/></h2>
	    </c:if>

	</c:when>
	<c:otherwise>
            <%-- Header with no navigational buttons--%>
        <div id="abc">&nbsp;</div>
        <table class="tabledata" id="TblData">
            <tr>
                <th style="width:5%">
                    <c:if test="${multiSelect}">
                        <input type="checkbox" id="checker" onclick="javascript:checkAll('where.studyGradeType.id.and.studyplancardinaltimeunit.cardinaltimeunitnumber');"/><fmt:message key='jsp.general.all' />
                    </c:if>
                </th>
                <th><fmt:message key="jsp.general.studygradetype" /></th>
                <th><fmt:message key="jsp.general.academicyear" /></th>
                <th><fmt:message key="jsp.general.timeunit" /></th>
                <th><fmt:message key="jsp.table.header.numberofstudents" /></th>
            </tr>
            <c:forEach var="item" items="${items}">
                <tr>
                    <td align="center">
                        <c:choose>
                            <c:when test="${multiSelect}">
                                <input type="checkbox" 
                                       name="where.studyGradeType.id.and.studyplancardinaltimeunit.cardinaltimeunitnumber" 
                                       paramGroup="where.studyGradeType.id"
                                       value="${item.studygradetypeid}|${item.cardinaltimeunitnumber}" />
                           </c:when>
                           <c:otherwise>
                                <input type="radio" 
                                       name="where.studyGradeType.id.and.studyplancardinaltimeunit.cardinaltimeunitnumber" 
                                       paramGroup="where.studyGradeType.id"
                                       value="${item.studygradetypeid}|${item.cardinaltimeunitnumber}" />
                           </c:otherwise>
                       </c:choose>
                    </td>
                    <td>
                        ${item.studygradedescription} - ${item.studyformdescription } - ${item.studytimedescription }
                    </td>
                    <td style="text-align: center">
                        ${item.academicyear}
                    </td> 
                    <td style="text-align: center">
                     <a href="#" 
                     name="${item.id}" class="reportLink" target="_blank"
                     onclick='createReport("<c:url value="/report/studentsByTimeUnit.view" />" 
                                            , "where.studyGradeType.id=${item.studygradetypeid}&where.studyplancardinaltimeunit.cardinaltimeunitnumber=${item.cardinaltimeunitnumber}&reportName=${reportName}&titleKey=${titleKey}&" +  buildQueryStringByClass("reportFlavour"));return false;'>
                            ${item.cardinaltimeunitdescription} ${item.cardinaltimeunitnumber}
                        </a>
                   </td>
                   <td style="text-align: center">
                       ${item.count}
                   </td>
                </tr>
            </c:forEach>
        </table>

        <script type="text/javascript">
         setEnabled("#reportButton" , true);
         setEnabled(".reportFormat" , true);
         alternate('TblData',true);
        </script>

        <%@ include file="../report_pagingFooter.jsp"%>

    </c:otherwise>
</c:choose>
