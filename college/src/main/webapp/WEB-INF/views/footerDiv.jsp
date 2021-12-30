<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div id="footer">

    <%-- If a custom footer is configured (in university specific web.xml settings), use that one, otherwise show the default footer --%>

    <c:choose>
        <c:when test="${not empty initParam.initFooterScreen}">
            <jsp:include page="${initParam.initFooterScreen}" flush="true"/>
        </c:when>
        <c:otherwise>
            <a class="white" href="http://www.opuscollege.net" target="_blank"><fmt:message key="jsp.footer.poweredby" /> <fmt:message key="jsp.footer.ru" /> 
            <br />&amp; <fmt:message key="jsp.footer.ucm" /> &amp; <fmt:message key="jsp.footer.cbu" /> &amp; <fmt:message key="jsp.footer.mulungushi" />
            </a>
        </c:otherwise>
    </c:choose>
</div>
