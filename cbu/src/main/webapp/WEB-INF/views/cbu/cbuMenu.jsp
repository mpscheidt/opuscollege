<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>


<%--<sec:authorize access="hasAnyRole('READ_FINANCE','CREATE_FINANCE','UPDATE_FINANCE','DELETE_FINANCE')"> 
    <li>
        <c:choose>
            <c:when test="${menuChoice == 'cbu'}">
                 <a href="#" class="MenuBarItemActive"><fmt:message key="jsp.menu.cbu" />&nbsp;&nbsp;|</a>
            </c:when>
            <c:otherwise>
                <a href="#" class="MenuBarItem"><fmt:message key="jsp.menu.cbu" />&nbsp;&nbsp;|</a>
            </c:otherwise>
        </c:choose>
    </li>
</sec:authorize>     
 --%>