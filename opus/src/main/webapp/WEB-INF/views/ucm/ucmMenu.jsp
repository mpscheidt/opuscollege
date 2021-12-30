<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

    <li>
        <sec:authorize access="hasAnyRole('ADMIN_UCM')"> 
        
            <c:choose>
                <c:when test="${menuChoice == 'ucm'}">
                    <a href="#" class="MenuBarItemActive">UCM&nbsp;&nbsp;|</a>
                </c:when>
                <c:otherwise>
                    <a href="#" class="MenuBarItem">UCM&nbsp;&nbsp;|</a>
                </c:otherwise>
            </c:choose>
            <ul>
                <sec:authorize access="hasRole('ADMIN_UCM')"> 
                    <li><a href="#" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.admin" /></a>
                    <ul>
                        <li><a href="<c:url value='/ucm/exportoverview.view'/>?newForm=true" class="MenuBarItemSubmenu"><fmt:message key="jsp.menu.export" /></a></li>
                    </ul>
                    </li>
                </sec:authorize>
                
                <sec:authorize access="hasRole('ADMIN_UCM')">
                <li><a href="<c:url value='/ucm/moodleoverview.view'/>?newForm=true" class="MenuBarItemSubmenu">Moodle</a></li>
                </sec:authorize>
                
                <sec:authorize access="hasRole('ADMIN_UCM')">
                <li><a href="<c:url value='/ucm/gmailoverview.view'/>?newForm=true" class="MenuBarItemSubmenu">GMail</a></li>
		<%--
                <li>
                	<a href="<c:url value='/ucm/subjectresults.view'/>?newForm=true&" class="MenuBarItemSubmenu">
                		<fmt:message key="jsp.menu.importsubjectresults" />
                	</a>
                </li>
            --%>
                <li>
                	<a href="<c:url value='/ucm/importcedstudentsresults.view'/>?newForm=true&" class="MenuBarItemSubmenu">
                		 		<fmt:message key="jsp.menu.importsubjectresults" /> 
                	</a>
                </li>
                <%-- 
                <li>
                	<a href="<c:url value='/ucm/importresults.view'/>?newForm=true&studyId=29&studyGradeTypeId=&subjectId=19310&currentPageNumber=1&tab=0&panel=0" class="MenuBarItemSubmenu">
                		<fmt:message key="jsp.menu.importsubjectresults" />
                	</a>
                </li>
                --%>
                </sec:authorize> 
             
            </ul>
        </sec:authorize> 
     </li>
