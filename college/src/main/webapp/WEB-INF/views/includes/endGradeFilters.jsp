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

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://jawr.net/tags" prefix="jwr" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

                       <table>
                       	<tr>
                       		<td>
                       			<fmt:message key="jsp.general.academicyear"/>
                       		</td>
                       		<td>
                       			<form:select  path="academicYearId" onchange="this.form.submit();">
                                    <form:option value="0"><fmt:message key='jsp.selectbox.choose' /></form:option>
<%--                             			<option value="0"><fmt:message key="jsp.selectbox.choose" /></option>                            --%>
                                    <c:forEach var="academicYear" items="${endGradesForm.academicYears}">
                                        <form:option value="${academicYear.id}" >
                                            <c:out value="${academicYear.description}"/>
                                        </form:option>
<%--                                         <c:choose> --%>
<%--                                             <c:when test="${academicYear.id == academicYearId}"> --%>
<%--                                                 <option value="${academicYear.id}" selected="selected"><c:out value="${academicYear.description}"/></option> --%>
<%--                                              </c:when> --%>
<%--                                             <c:otherwise> --%>
<%--                                                 <option value="${academicYear.id}"><c:out value="${academicYear.description}"/></option>                             --%>
<%--                                             </c:otherwise> --%>
<%--                                         </c:choose> --%>
                                    </c:forEach>
                        		</form:select>
                       		</td>
                       	</tr>
                       	
                       	<tr>
                       		<td>
                       			<fmt:message key="general.type"/>
                       		</td>
                       		<td>
                       			<select  name="endGradeTypeCode" id="endGradeTypeCode" onchange="this.form.submit();">
                            			<option value=""><fmt:message key="jsp.selectbox.choose" /></option>                           
                                        <c:forEach var="endGradeType" items="${endGradesForm.endGradeTypes}">                          
                                            <c:choose>
                                                <c:when test="${endGradeType.code == endGradeTypeCode}">
                                                    <option value="${endGradeType.code}" selected="selected"><c:out value="${endGradeType.description}"/></option>
                                                 </c:when>
                                                <c:otherwise>
                                                    <option value="${endGradeType.code}"><c:out value="${endGradeType.description}"/></option>                            
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
	                        		</select>
                       		</td>
                       	</tr>
                       	<tr>
                       		<td>
                       			<fmt:message key="jsp.general.active"/>
                       		</td>
                       		<td>
                       			<c:set var="activeOpts">yes,no</c:set>
                       			<select  name="active" id="active" onchange="this.form.submit();">
                           			<option value=""><fmt:message key="jsp.selectbox.choose" /></option>                           
									
									<c:forTokens var="opt" items="${activeOpts}" delims=",">
                                        <c:choose>
                                                <c:when test="${fn:substring(opt,0,1) == active}">
                                                    <option value="${fn:substring(opt,0,1)}" selected="selected"><fmt:message key="jsp.general.${opt}"/></option>
                                                 </c:when>
                                                <c:otherwise>
                                                    <option value="${fn:substring(opt,0,1)}"><fmt:message key="jsp.general.${opt}"/></option>                            
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forTokens>
	                        		</select>
                       		</td>
                       	</tr>
                       
                       </table>
                        
    
                        <!-- </form>-->
           