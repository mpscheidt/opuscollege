<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>


<sec:authorize access="hasAnyRole('READ_FINANCE','CREATE_FINANCE','UPDATE_FINANCE','DELETE_FINANCE')"> 
    <li>
        <c:choose>
            <c:when test="${menuChoice == 'unza'}">
                 <a href="#" class="MenuBarItemActive"><fmt:message key="jsp.menu.unza" />&nbsp;&nbsp;|</a>
            </c:when>
            <c:otherwise>
                <a href="#" class="MenuBarItem"><fmt:message key="jsp.menu.unza" />&nbsp;&nbsp;|</a>
            </c:otherwise>
        </c:choose>
        <ul>
            <li><a href="<c:url value='/unza/financialRequests.view?newForm=true&searchValue='/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.financialrequests" /></a></li>
        </ul>
    </li>
</sec:authorize>     
            