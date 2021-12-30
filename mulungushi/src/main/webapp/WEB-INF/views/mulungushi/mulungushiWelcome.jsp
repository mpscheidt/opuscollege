<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://jawr.net/tags" prefix="jwr" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<p>
    <b><fmt:message key="jsp.start.welcome"/> <fmt:message key="jsp.start.applicationname"/></b>
</p>

<table>
<tr>
<td width="300">
     <p>
    <c:choose>
        <c:when test="${modules != null && modules != ''}">
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
        </c:when>
    </c:choose>
    </p>
</td>
<td width="300">
<p>
<img src='<c:url value="/images/mulungushi-logo.png" />' alt='Mulungushi logo' title='Mulungushi logo' />
</p>

<p>
<img src='<c:url value="/images/mulungushi-main-entrance.jpg" />' alt='Mulungushi main entrance' title='Mulungushi main entrance' />
</p>
</td>
</tr>
</table>

