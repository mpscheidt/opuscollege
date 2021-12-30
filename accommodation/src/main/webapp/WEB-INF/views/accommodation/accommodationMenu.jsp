<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>

<sec:authorize
	access="hasAnyRole('CREATE_ACCOMMODATION_DATA','READ_ACCOMMODATION_DATA','UPDATE_ACCOMMODATION_DATA','DELETE_ACCOMMODATION_DATA'
                     , 'APPLY_FOR_ACCOMMODATION')">
	<li><c:choose>
			<c:when test="${menuChoice == 'accommodation'}">
				<a href="#" class="MenuBarItemActive"><fmt:message
						key="jsp.menu.accommodation" />&nbsp;&nbsp;|</a>
			</c:when>
			<c:otherwise>
				<a href="#" class="MenuBarItem"><fmt:message
						key="jsp.menu.accommodation" />&nbsp;&nbsp;|</a>
			</c:otherwise>
		</c:choose>

		<ul>
            <sec:authorize access="hasRole('APPLY_FOR_ACCOMMODATION')">
				<li><a
					href="<c:url value='/accommodation/application.view?task=application'/>"
					class="MenuBarItemSubmenu"><fmt:message
							key="jsp.accommodation.application" /></a></li>

				<li><a
					href="<c:url value='/accommodation/application.view?task=overview'/>"
					class="MenuBarItemSubmenu"><fmt:message
							key="jsp.accommodation.overview" /></a></li>
            </sec:authorize>
            <sec:authorize
                access="hasAnyRole('CREATE_ACCOMMODATION_DATA','READ_ACCOMMODATION_DATA','UPDATE_ACCOMMODATION_DATA','DELETE_ACCOMMODATION_DATA')">
                    <li>
                        <a href="#" class="MenuBarItemSubmenu"><fmt:message
								key="jsp.accommodation.hostels" /></a>
						<ul>
							<li><a
								href="<c:url value='/accommodation/hostels.view?newForm=true'/>"
								class="MenuBarItemSubmenu">Overview</a></li>
                            <sec:authorize access="hasRole('CREATE_ACCOMMODATION_DATA')">
    							<li><a
    								href="<c:url value='/accommodation/hostel.view?task=add&newForm=true'/>"
    								class="MenuBarItemSubmenu"><fmt:message
    										key="jsp.accommodation.addHostel" /></a>
                                </li>
                            </sec:authorize>

<%--							<li><a href="#" class="MenuBarItemSubmenu"><fmt:message
										key="jsp.accommodation.hostelType" /></a>
								<ul>
									<li><a
										href="<c:url value='/accommodation/hostels/hosteltype.view?task=overview'/>"
										class="MenuBarItemSubmenu"><fmt:message
												key="jsp.accommodation.overview" /></a></li>
									<li><a
										href="<c:url value='/accommodation/hostels/hosteltype.view?task=add'/>"
										class="MenuBarItemSubmenu"><fmt:message
												key="jsp.accommodation.addHostelType" /></a></li>
								</ul></li> --%>
						</ul>
                    </li>
                    <c:forEach var="appConfigAttribute" items="${appConfig}">
                        <c:if
                            test="${appConfigAttribute.appConfigAttributeName=='USE_HOSTELBLOCKS' && appConfigAttribute.appConfigAttributeValue=='Y'}">
                            <li><a href="#" class="MenuBarItemSubmenu"><fmt:message
                                        key="jsp.accommodation.block" /></a>
                                <ul>
                                    <li><a
                                        href="<c:url value='/accommodation/hostelBlocks.view?newForm=true'/>"
                                        class="MenuBarItemSubmenu"><fmt:message
                                                key="jsp.accommodation.overview" /></a>
                                    </li>
                                    <sec:authorize access="hasRole('CREATE_ACCOMMODATION_DATA')">
                                        <li><a
                                            href="<c:url value='/accommodation/hostelBlock.view?newForm=true'/>"
                                            class="MenuBarItemSubmenu"><fmt:message
                                                    key="jsp.accommodation.addBlock" /></a>
                                        </li>
                                    </sec:authorize>
                                </ul>
                            </li>
                        </c:if>
                    </c:forEach>
					<li><a href="#" class="MenuBarItemSubmenu"><fmt:message
								key="jsp.accommodation.rooms" /></a>
						<ul>
							<li><a
								href="<c:url value='/accommodation/hostels/rooms.view?newForm=true'/>"
								class="MenuBarItemSubmenu"><fmt:message
										key="jsp.accommodation.overview" /></a>
                            </li>
							<sec:authorize access="hasRole('CREATE_ACCOMMODATION_DATA')">
								<li><a
									href="<c:url value='/accommodation/hostels/room.view?newForm=true'/>"
									class="MenuBarItemSubmenu"><fmt:message
											key="jsp.accommodation.addRoom" /></a>
                                </li>
							</sec:authorize>
						</ul>
                    </li>
					
					<li><a href="#" class="MenuBarItemSubmenu"><fmt:message
								key="jsp.accommodation.students" /></a>
						<ul>
							<li><a
								href="<c:url value='/accommodation/applicants.view?task=overview&newForm=true'/>"
								class="MenuBarItemSubmenu"><fmt:message
										key="jsp.accommodation.applicants" /></a>
                            </li>
										
							<sec:authorize access="hasRole('ALLOCATE_ROOM')"> 
							    <li><a
                                href="<c:url value='/accommodation/allocations.view?task=overview&newForm=true'/>"
                                class="MenuBarItemSubmenu"><fmt:message
                                        key="jsp.menu.allocations" /></a></li>
<%-- underwater for now								<li><a
									href="<c:url value='/accommodation/multiplereallocation.view?task=overview'/>"
									class="MenuBarItemSubmenu"><fmt:message
											key="jsp.accommodation.multipleReallocation" /></a></li>
								<li><a
									href="<c:url value='/accommodation/multipledeallocation.view?task=overview'/>"
									class="MenuBarItemSubmenu"><fmt:message
											key="jsp.accommodation.multipleUnallocation" /></a></li> --%>
							</sec:authorize>
						</ul>
                    </li>
            </sec:authorize>
<%--				</c:otherwise>
			</c:choose> --%>

            <c:forEach var="subMenuExtension" items="${accommodationWebExtensions.accommodationSubMenus}">
                <jsp:include page="${subMenuExtension.subMenu}" flush="true"/>
            </c:forEach>
		</ul>
    </li>
</sec:authorize>