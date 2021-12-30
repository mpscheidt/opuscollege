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

<%@ include file="standardincludes.jsp"%>

		<div id="abc2">
            <span id="paging">
                <fmt:message key="jsp.general.totalnumberof" /> <fmt:message key="jsp.menu.${redirView}" />: ${countAllEntities}&nbsp;
                <fmt:message key="jsp.general.page" />
                <c:choose>
                    <c:when test="${totalNumberOfPages == 0}">
                        ${totalNumberOfPages}
                    </c:when>
                    <c:otherwise>
                        ${currentPageNumber}
                    </c:otherwise>
                </c:choose>
                <fmt:message key="jsp.general.of" /> ${totalNumberOfPages}

                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

                <c:choose>
				    <c:when test="${currentPageNumber > 1}">
					   <c:forEach begin="1" end="${currentPageNumber-1}" var="current1"> 
						  &nbsp;<a href="${redirView}.view?currentPageNumber=${current1}&institutionTypeCode=${institutionTypeCode}&${params}">${current1}</a> 
					   </c:forEach>
				    </c:when>
			     </c:choose>
			     &nbsp;${currentPageNumber}	
			     <c:choose>
				    <c:when test="${totalNumberOfPages > currentPageNumber}">
					   <c:forEach begin="${currentPageNumber+1}" end="${totalNumberOfPages}" var="current2"> 
						  &nbsp;<a href="${redirView}.view?currentPageNumber=${current2}&institutionTypeCode=${institutionTypeCode}&${params}">${current2}</a> 
					   </c:forEach>
				    </c:when>
			     </c:choose>
            </span>
		    <span id="prevnext">
		    	<c:choose>
		    		<c:when test="${currentPageNumber > 1}">
		        		<a href="${redirView}.view?currentPageNumber=${currentPageNumber-1}&institutionTypeCode=${institutionTypeCode}&${params}"><img src="<c:url value='/images/previous.gif' />" width="11" height="11" alt="<fmt:message key="jsp.button.previous" />" title="<fmt:message key="jsp.button.previous" />" /></a>
		    		</c:when>
		    		<c:otherwise>
		        		<img src="<c:url value='/images/previous_d.gif' />" width="11" height="11" alt="<fmt:message key="jsp.button.previous" />" title="<fmt:message key="jsp.button.previous" />" />
		    		</c:otherwise>
		    	</c:choose>
		        <img src="<c:url value='/images/trans.gif' />" width="11" height="1" alt="" />
		    	<c:choose>
		    		<c:when test="${currentPageNumber < totalNumberOfPages}">
		        		<a href="${redirView}.view?currentPageNumber=${currentPageNumber+1}&institutionTypeCode=${institutionTypeCode}&${params}"><img src="<c:url value='/images/next.gif' />" width="11" height="11" alt="<fmt:message key="jsp.button.next" />" title="<fmt:message key="jsp.button.next" />" /></a>
		    		</c:when>
		    		<c:otherwise>
		        		<img src="<c:url value='/images/next_d.gif' />" width="11" height="11" alt="<fmt:message key="jsp.button.next" />" title="<fmt:message key="jsp.button.next" />" />
		    		</c:otherwise>
		    	</c:choose>
		    </span>
		</div>

