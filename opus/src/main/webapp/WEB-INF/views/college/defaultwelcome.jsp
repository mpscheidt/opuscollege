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
<td width="500">

    <c:if test="${not empty tenantTxt}">
        <div class="tenanttxt">
            <c:out value="${tenantTxt}"/>
        </div>
    </c:if>
    
    <br/>
    <p>
        <b><fmt:message key="jsp.start.welcome"/> <fmt:message key="jsp.start.applicationname"/></b>
    </p>
    
    <sec:authorize access="hasRole('ADMINISTER_SYSTEM')">
    <table>
        <tr>
            <td><fmt:message key="jsp.start.numberofactivestudyplans" />:&nbsp;</td>
            <td><c:out value="${numberOfActiveStudyPlans}"/></td>
        </tr>
        <tr>
            <td><fmt:message key="jsp.start.totalnumberofstudyplans" />:</td>
            <td><c:out value="${totalNumberOfStudyPlans}"/></td>
        </tr>
    </table>
    </sec:authorize>
    
    <p>
        <c:if test="${modules != null && modules != ''}">
            <c:forEach var="module" items="${modules}">
                <br /><br />
                <b><fmt:message key="jsp.start.${fn:toLowerCase(module.module)}" /></b>
                <br />
                <fmt:message key="jsp.start.version" /> <fmt:message key="jsp.start.module" />: 
                ${module.moduleVersion}
                <c:choose>
                    <c:when test="${appVersions != null && appVersions != ''}">
                        <c:forEach var="appVersion" items="${appVersions}">
                            <c:choose>
                                <c:when test="${fn:toLowerCase(appVersion.module) == fn:toLowerCase(module.module)}">
                                    <c:choose>
                                        <c:when test="${appVersion.db == 'Y'}">
                                            <br />
                                            <fmt:message key="jsp.start.version" /> <fmt:message key="jsp.start.database.module" />: ${appVersion.dbVersion}
                                        </c:when>
                                    </c:choose>
                                </c:when>
                            </c:choose>
                        </c:forEach>
                    </c:when>
                </c:choose>
            </c:forEach>
        </c:if>
    </p> 
</td>
<td width="500">
    <p align="center">
        <img src='<c:url value="/images/graduate-small.png" />' alt='Welcome screen logo' title='Welcome screen logo' /> 
    </p>
<%--
    <sec:authorize access="hasRole('ADMINISTER_SYSTEM')">
    <p>
       <br /><br />
       <b><fmt:message key="jsp.start.appconfig" /></b>
       <br /><br />
       <c:forEach var="appConfigAttribute" items="${appConfig}">
           ${appConfigAttribute.appConfigAttributeName}: ${appConfigAttribute.appConfigAttributeValue}
           <br /><br />
       </c:forEach>
    </p>
    </sec:authorize>
 --%>
</td>
</tr>
</table>

<p>
    <fmt:message key="jsp.start.message" />: <a href="mailto:${administratorMailAddress}">${administratorMailAddress}</a> 
</p>

<br /><br />
