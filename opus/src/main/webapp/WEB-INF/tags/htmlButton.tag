<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%-- This tag displays an <a href=.../> link, either with an image (if set) or with text.
     The tag accepts a htmlButton parameter of type HtmlButtonExtPoint
--%>
<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ attribute name="htmlButton" required="true" type="org.uci.opus.college.web.extpoint.HtmlButtonExtPoint" %>

<sec:authorize access="${htmlButton.access}">

    <%-- Put the URL together --%>
    <spring:url value="${htmlButton.url}" var="resourceUrl">
        <c:forEach var="urlParam" items="${htmlButton.urlParams}">
            <spring:param name="${urlParam.key}"><spring:eval expression="${urlParam.value}"/></spring:param>
        </c:forEach>
    </spring:url>
    
    <%-- Add the link (with or without image) --%>
    <c:choose>
        <c:when test="${not empty htmlButton.iconName}">
            <a href="${resourceUrl}" target="otherwindow" ><img src="<c:url value='${htmlButton.iconName}' />" alt="<fmt:message key="${htmlButton.titleKey}" />" title="<fmt:message key="${htmlButton.titleKey}" />" /></a>
        </c:when>
        <c:otherwise>
            <a href="${resourceUrl}" target="otherwindow" title="<fmt:message key='${htmlButton.descriptionKey}' />" ><fmt:message key="${htmlButton.titleKey}" /></a>
        </c:otherwise>
    </c:choose>
</sec:authorize>
