<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<sec:authorize access="hasAnyRole('CREATE_SCHOLARSHIPS','READ_SCHOLARSHIPS','UPDATE_SCHOLARSHIPS','DELETE_SCHOLARSHIPS')"> 
    <li>
    <c:choose>
        <c:when test="${menuChoice == 'scholarship'}">
            <a href="#" class="MenuBarItemActive"><fmt:message key="jsp.menu.scholarships" />&nbsp;&nbsp;|</a>
        </c:when>
        <c:otherwise>
            <a href="#" class="MenuBarItem"><fmt:message key="jsp.menu.scholarships" />&nbsp;&nbsp;|</a>
        </c:otherwise>
    </c:choose>
    <ul>
        <li><a href="#" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.sponsors" /></a>
            <ul>
                <li><a href="<c:url value='/scholarship/sponsors.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /></a></li>
                <li><a href="<c:url value='/scholarship/sponsor.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.add" /></a></li>
                <li><a href="<c:url value='/scholarship/sponsorinvoices.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.sponsorinvoices" /></a></li>
                <li><a href="<c:url value='/scholarship/sponsorpayments.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.sponsorpayments" /></a></li>
            </ul>
        </li>
        <li><a href="#" class="MenuBarItemSubmenu"><fmt:message key="jsp.general.scholarships" /></a>
            <ul>
                <li><a href="<c:url value='/scholarship/scholarships.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /></a></li>
                <li><a href="<c:url value='/scholarship/scholarship.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.add" /></a></li>
            </ul>
        </li>
        <li><a href="<c:url value='/scholarship/students.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /> <fmt:message key="jsp.general.students" /></a></li>
        <li><a href="<c:url value='/scholarship/scholarshipapplications.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /> <fmt:message key="jsp.general.scholarshipapplications" /></a></li>
        <c:if test="${appUseOfSubsidies == 'Y'}">
            <li><a href="<c:url value='/scholarship/subsidies.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /> <fmt:message key="jsp.general.subsidies" /></a></li>
        </c:if>
        <li><a href="<c:url value='/scholarship/complaints.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /> <fmt:message key="jsp.general.complaints" /></a></li>
<%--        <li><a href="#" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.banks" /></a>
            <ul>
                <li><a href="<c:url value='/scholarship/banks.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /></a></li>
                <li><a href="<c:url value='/scholarship/bank.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.add" /></a></li>
            </ul>
        </li> --%>
        <%-- <li><a href="<c:url value='/scholarship/scholarshipreports.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.reports" /></a></li>
            --%>

    </ul>
    </li>
</sec:authorize>
