<%--
 * Copyright (c) 2009 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
--%>

<%@ include file="../header.jsp"%>

<%-- date picker --%>
<jwr:script src="/bundles/jquerycomp.js" />

<body>

    <div id="tabwrapper">

        <%@ include file="../menu.jsp"%>

        <c:set var="reportProperty" value="${reportPropertyForm.reportProperty}" />

        <div id="tabcontent">
            <spring:htmlEscape defaultHtmlEscape="true"></spring:htmlEscape>
            <fieldset>
                <legend>
                    &nbsp; <a href="<c:url value='/college/report/reports.view?newForm=true&viewName=${reportsForm.overviewPage}'/>"> <fmt:message key="jsp.general.backtooverview" />
                    </a> &nbsp; > &nbsp; <a
                        href="<c:url value='/college/report/reportproperties.view?reportName=${reportPropertyForm.reportProperty.reportName}&reportPath=${reportPropertyForm.reportPath}&currentPageNumber=${currentPageNumber}&institutionTypeCode=${institutionTypeCode}'/>">
                        <fmt:message key="jsp.report.${fn:toLowerCase(reportProperty.reportName)}" />
                    </a> &nbsp; > &nbsp;
                    <fmt:message key="jsp.report.${fn:toLowerCase(reportProperty.name)}" />
                    /
                    <fmt:message key="jsp.general.edit" />

                    &nbsp;
                </legend>


                <form:form modelAttribute="reportPropertyForm" ENCTYPE='multipart/form-data' method="post">
                    <spring:bind path="reportProperty.type">
                        <input type="hidden" name="${status.expression}" value="${status.value}" />
                    </spring:bind>
                    <spring:bind path="reportProperty.reportName">
                        <input type="hidden" name="${status.expression}" value="${status.value}" />
                    </spring:bind>
                    <table>
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>
                                <table>
                                    <c:choose>
                                        <c:when test="${reportProperty.name == 'reportLetterContent'}">
                                            <tr>
                                                <td classs="label"><fmt:message key="jsp.report.${fn:toLowerCase(reportProperty.name)}" /> :</td>
                                                <td><spring:bind path="reportProperty.text">
                                                        <textarea id="editor" name="${status.expression}" style="width: 700px; height: 300px; border: 1px solid gray">${status.value}</textarea>
                                                        <script>
                                                        CKEDITOR.replace('editor', { height : 280 });
                                                        </script>
                                                    </spring:bind></td>
                                            </tr>
                                        </c:when>
                                        <c:when test="${fn:startsWith(reportProperty.type, 'image/')}">
                                            <tr>
                                                <td class="label"><fmt:message key="jsp.report.${fn:toLowerCase(reportProperty.name)}" /> :</td>
                                                <td><form:input path="multipartFile" type="file" /></td>
                                            </tr>
                                        </c:when>
                                        <c:when test="${reportProperty.type == 'date'}">
                                            <tr>
                                                <td class="label"><fmt:message key="jsp.report.${fn:toLowerCase(reportProperty.name)}" /> :</td>
                                                <td><spring:bind path="reportProperty.text">
                                                        <input type="text" name="${status.expression}" value="${status.value}" class="datePicker" />
                                                    </spring:bind></td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td class="label"><fmt:message key="jsp.report.${fn:toLowerCase(reportProperty.name)}" /> :</td>
                                                <td><spring:bind path="reportProperty.text">
                                                        <input type="text" name="${status.expression}" value="${status.value}" />
                                                    </spring:bind></td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                    <tr>
                                        <td></td>
                                        <form:errors path="reportProperty.name" cssClass="error" element="td"/>
                                    </tr>
                                    
                                    <tr>
                                        <td><fmt:message key="jsp.general.show" /></td>
                                        <td>
                                            <form:checkbox path="reportProperty.visible"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center"><input type="submit" value="<fmt:message key='jsp.button.submit' />" /></td>
                                    </tr>
                                
                                </table>
                            </td>
                            <td>
                                <table>
                                    <tr>
                                        <td><c:choose>
                                                <%-- handle svg properties --%>
                                                <c:when test="${reportProperty.type == 'image/svg+xml'}">
                                                    <fieldset>
                                                        <legend>${reportProperty.name}</legend>
                                                        <c:choose>
                                                            <c:when test="${reportProperty.id == 0}">
                                                                <input type="hidden" name="imgPath" value="${reportProperty.text}" />
                                                                <img src="<c:url value='/images/report/${reportProperty.text}' />" />
            
                                                                <embed src="<c:url value='/images/report/${reportProperty.text}' />" width="200" height="100" type="image/svg+xml"
                                                                    pluginspage="http://www.adobe.com/svg/viewer/install/" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <embed
                                                                    src="<c:url 
                                                            value='/college/report/filedisplay.view?propertyId=${reportProperty.id}
                                                                   &currentPageNumber=${currentPageNumber}'/>"
                                                                    width="200" height="100" type="image/svg+xml" pluginspage="http://www.adobe.com/svg/viewer/install/" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </fieldset>
                                                </c:when>
            
                                                <%-- handle image properties --%>
                                                <c:when test="${fn:startsWith(reportProperty.type, 'image/')}">
                                                    <fieldset>
                                                        <legend>${reportProperty.name}</legend>
                                                        <c:choose>
                                                            <c:when test="${reportProperty.id == 0}">
                                                                <input type="hidden" name="imgPath" value="${reportProperty.text}" />
                                                                <img src="<c:url value='/images/report/${reportProperty.text}' />" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="<c:url value='/college/report/filedisplay.view?propertyId=${reportProperty.id}&currentPageNumber=${currentPageNumber}'/>" width="100"
                                                                    title="${reportProperty.name}" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </fieldset>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <spring:bind path="reportProperty.file">
                        <c:forEach var="error" items="${status.errorMessages}">
                            <span class="error">${error}</span>
                        </c:forEach>
                    </spring:bind>
                </form:form>
        </div>
        <!-- tabcontent -->
    </div>
    <!-- tabwrapper -->

    <%@ include file="../footer.jsp"%>