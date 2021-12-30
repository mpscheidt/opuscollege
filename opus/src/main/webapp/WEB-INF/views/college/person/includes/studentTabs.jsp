<%@ include file="../../../includes/standardincludes.jsp"%>


            <ul class="TabbedPanelsTabGroup">
                <c:set var="tab">0</c:set>
                <li class="TabbedPanelsTab compulsoryTab">

                    <%-- link or not? --%>
                    <c:choose>
                        <c:when test="${navigationSettings.tab == tab}">
                            <fmt:message key="jsp.general.personaldata" />
                        </c:when>
                        <c:otherwise>
                            <a href="<c:url value='/college/student/personal.view?studentId=${studentId}&amp;tab=0&amp;panel=0&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.personaldata" /></a>
                        </c:otherwise>
                    </c:choose>
                </li>
                <c:choose>
                    <c:when test="${(showOpusUserData || editOpusUserData) && '' != studentId && 0 != studentId}">
                        <c:set var="tab">${tab + 1}</c:set>
                        <li class="TabbedPanelsTab compulsoryTab">

                            <%-- link or not? --%>
                            <c:choose>
                                <c:when test="${navigationSettings.tab == tab}">
                                    <fmt:message key="jsp.general.opususerdata" />
                                </c:when>
                                <c:otherwise>
                                    <a href="<c:url value='/college/student-opususer.view?studentId=${studentId}&amp;tab=${tab}&amp;panel=0&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.opususerdata" /></a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </c:when>
                </c:choose>
                <c:choose>
                    <c:when test="${(showSubscriptionData || editSubscriptionData) && '' != studentId && 0 != studentId}">
                        <c:set var="tab">${tab + 1}</c:set>
                        <li class="TabbedPanelsTab compulsoryTab">
                            <%-- link or not? --%>
                            <c:choose>
                                <c:when test="${navigationSettings.tab == tab}">
                                    <fmt:message key="jsp.general.subscriptiondata" />
                                </c:when>
                                <c:otherwise>
                                    <a href="<c:url value='/college/student/subscription.view?studentId=${studentId}&amp;tab=${tab}&amp;panel=0&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.subscriptiondata" /></a>
                                </c:otherwise>
                            </c:choose>
                        </li>       
                    </c:when>
                </c:choose>
                <c:choose>
                    <c:when test="${(showAbsences || editAbsences) && '' != studentId && 0 != studentId}">
                        <c:set var="tab">${tab + 1}</c:set>
                        <li class="TabbedPanelsTab">
                            <%-- link or not? --%>
                            <c:choose>
                                <c:when test="${navigationSettings.tab == tab}">
                                    <fmt:message key="jsp.general.anomalies" />
                                </c:when>
                                <c:otherwise>
                                    <a href="<c:url value='/college/student-absences.view?studentId=${studentId}&amp;tab=${tab}&amp;panel=0&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.anomalies" /></a>
                                </c:otherwise>
                            </c:choose>
                        </li>       
                    </c:when>
                </c:choose>
                <c:choose>
                    <c:when test="${(showAddresses || editAddresses) && '' != studentId && 0 != studentId}">
                        <c:set var="tab">${tab + 1}</c:set>
                        <li class="TabbedPanelsTab">
                            <%-- link or not? --%>
                            <c:choose>
                                <c:when test="${navigationSettings.tab == tab}">
                                    <fmt:message key="jsp.general.addresses" />
                                </c:when>
                                <c:otherwise>
                                    <a href="<c:url value='/college/student-addresses.view?studentId=${studentId}&amp;tab=${tab}&amp;panel=0&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.addresses" /></a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </c:when>
                </c:choose>
                <c:choose>
                    <c:when test="${(showClassgroups || editClassgroups) && '' != studentId && 0 != studentId}">
                        <c:set var="tab">${tab + 1}</c:set>
                        <li class="TabbedPanelsTab">
                            <%-- link or not? --%>
                            <c:choose>
                                <c:when test="${navigationSettings.tab == tab}">
                                    <fmt:message key="general.classgroups" />
                                </c:when>
                                <c:otherwise>
                                    <a href="<c:url value='/college/student-classgroups.view?studentId=${studentId}&amp;tab=${tab}&amp;panel=0&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="general.classgroups" /></a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </c:when>
                </c:choose>

                <c:if test="${'' != studentId && 0 != studentId}">
                    <c:forEach var="studentTab" items="${collegeWebExtensions.studentTabs}">
                        <c:set var="tab">${tab + 1}</c:set>
                        
                        <li class="TabbedPanelsTab">
                            <%-- link or not? --%>
                            <c:choose>
                                <c:when test="${navigationSettings.tab == tab}">
                                    <fmt:message key="${studentTab.titleKey}" />
                                </c:when>
                                <c:otherwise>
                                    <c:url var="safeUrl" value="${studentTab.href}">
                                        <c:param name="studentId">${studentId}</c:param>
                                        <c:param name="tab">${tab}</c:param>
                                        <c:param name="currentPageNumber">${navigationSettings.currentPageNumber}</c:param>
                                    </c:url>
                                    <a href="<c:out value='${safeUrl}'/>"><fmt:message key="${studentTab.titleKey}" /></a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </c:forEach>
                </c:if>
            </ul>

