<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>


<sec:authorize access="hasAnyRole('READ_FEES','UPDATE_FEES','DELETE_FEES', 'CREATE_FEE_PAYMENTS', 'UPDATE_FEE_PAYMENTS', 'READ_FEE_PAYMENTS', 'DELETE_FEE_PAYMENTS', 'student')"> 
    <li>
        <c:choose>
            <c:when test="${menuChoice == 'fee'}">
                <a href="#" class="MenuBarItemActive"><fmt:message key="jsp.menu.fees" />&nbsp;&nbsp;|</a>
            </c:when>
            <c:otherwise>
                <a href="#" class="MenuBarItem"><fmt:message key="jsp.menu.fees" />&nbsp;&nbsp;|</a>
            </c:otherwise>
        </c:choose>
        <ul>
        	<sec:authorize access="hasAnyRole('READ_FEES','UPDATE_FEES','DELETE_FEES')">
            	<li><a href="<c:url value='/fee/feebranches.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /> <fmt:message key="jsp.menu.educationareas" /></a></li>
            	<li><a href="<c:url value='/fee/feesstudies.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /> <fmt:message key="jsp.menu.studies" /></a></li>
			</sec:authorize>

			<sec:authorize access="hasAnyRole('UPDATE_FEE_PAYMENTS', 'READ_FEE_PAYMENTS', 'DELETE_FEE_PAYMENTS')">        
            	<li><a href="<c:url value='/fee/paymentsstudents.view?newForm=true'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /> <fmt:message key="jsp.general.students" /></a></li>
 			</sec:authorize>
 			
 			<sec:authorize access="hasAnyRole('student')">
            	<li><a href="<c:url value='/fee/paymentsstudent.view?newForm=true&personId=${opusUser.personId}&currentPageNumber=1&tab=0&panel=0'/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.overview" /></a></li>
 			</sec:authorize>              

            <sec:authorize access="hasAnyRole('READ_FINANCE','CREATE_FINANCE','UPDATE_FINANCE','DELETE_FINANCE')">
                <li>
                    <a href="#" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.finance" /></a>
                    <ul>
                        <li><a href="<c:url value='/finance/financialTransactions.view?newForm=true&searchValue='/>" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.financialtransactions" /></a></li>
                     </ul>
                </li>
            </sec:authorize>
        </ul>
    </li>
</sec:authorize>     
