<%--
 * Copyright (c) 2007 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
--%>

<%@ include file="../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../menu.jsp"%>

    
    <div id="tabcontent">
 <fieldset>
 <legend>
    <a href="<c:url value='/report/reports.view?currentPageNumber=${overviewPageNumber}&institutionTypeCode=${educationType}'/>">
    <fmt:message key="jsp.general.backtooverview" /> </a> &nbsp; > &nbsp;
    <fmt:message key="jsp.report.${fn:toLowerCase(report.name)}" />
    </legend>
        <br />
         <form name="searchform" id="searchform" method="get">
                <table>
                    <tr>
                    <td class="label"><fmt:message key="jsp.general.search" /></td>
                        <td width="700" align="left">
                           <img src="<c:url value='/images/trans.gif' />" width="10"/>            
                            <input type="text" name="searchValue" id="searchValue"  value="${searchValue}"/>&nbsp;
                            <!-- input type="submit" name="search" value="search" /-->
                           <img src="<c:url value='/images/search.gif'/>" 
                           alt="<fmt:message key='jsp.general.search'/>"
                           title="<fmt:message key='jsp.general.search'/>"
                           style="cursor:pointer; cursor:hand;"
                            onclick="document.searchform.submit()"/>
                        </td>
                    <td>
                    
                    </td>
                    </tr>
                </table>
            </form>
            
        <a href="<c:url value='/report/property.view?reportId=${command.id}'/>">
            <img src="<c:url value='/images/add.gif' />" 
            alt="<fmt:message key="jsp.link.addproperty" />" 
            title="<fmt:message key="jsp.link.addproperty" />"
         />
        </a>
           
     </fieldset>      
        <c:set var="allEntities" value="${command.properties}" scope="page" />
        <c:set var="redirView" value="report" scope="page" />
        <c:set var="params" value="report=${report}" scope="page" />
        <c:set var="entityNumber" value="0" scope="page" />
        <c:set var="index" value="${entityNumber}" scope="page" />

        <%@ include file="../includes/pagingHeader.jsp"%>
         
        <table class="tabledata" id="TblData">
          
            <!-- button cell-->
            <th><fmt:message key="jsp.general.name" /></th>
            <th><fmt:message key="jsp.general.type" /></th>
            <th><fmt:message key="jsp.general.description" /></th>
            <th><!-- buttons cell --></th>
            
                <c:forEach var="property" items="${command.properties}">
                <c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
                <c:set var="index" value="${entityNumber - 1}" scope="page" />
                <c:choose>
                    <c:when test="${(entityNumber < (currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
                        <tr>
                            
                            <td>
                            <c:choose>
                                <c:when test="${opusUser.personId == student.personId
                                 || (opusUserRole.role != 'student' 
                                 && opusUserRole.role != 'guest'
                                 && opusUserRole.role != 'staff'
                                )}">
                                <a href="<c:url value='/report/property.view?reportId=${command.id}&propertyId=${property.id}'/>">
                                    ${property.name}
                                </a>
                                </c:when>
                                <c:otherwise>
                                    ${property.name}
                                </c:otherwise>
                            </c:choose>
                            </td>
                            
                            <td>
                                <c:choose>
                                    <c:when test="${propertyType == 'unknown'}">
                                       <i> <fmt:message key="jsp.general.unknown" /></i>
                                    </c:when>
                                    <c:otherwise>
                                        ${property.type}
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${property.type == 'text'}">
                                       ${property.value}
                                    </c:when>
                                    <c:otherwise>
                                        <img src="<c:url 
                                value='/report/filedisplay.view?propertyId=${property.id}
                                &currentPageNumber=${currentPageNumber}'/>" 
                                width="100" 
                                title="${property.name}" />
                                    </c:otherwise>
                                </c:choose>
                                                         
                                   &nbsp;
                            </td>
                            <td class="buttonsCell" style="width:7%">
                                <c:choose>
                                    <c:when test="${(
                                        opusUserRole.role != 'teacher'
                                        && opusUserRole.role != 'student' 
                                        && opusUserRole.role != 'guest'
                                        && opusUserRole.role != 'staff'
                                        )}">
                                    <a class="imageLink" href="<c:url value='/report/property.view?reportId=${command.id}&propertyId=${property.id}'/>"><img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" /></a>
                                    <c:set var="confirmMessage"><fmt:message key="jsp.general.delete.confirm.arg" ><fmt:param>${property.name}</fmt:param></fmt:message></c:set>
                                    <a class="imageLinkPaddingLeft" href="<c:url value='/report/property_delete.view?reportId=${command.id}&propertyId=${property.id}&currentPageNumber=${currentPageNumber}&institutionTypeCode=${institutionTypeCode}'/>"
                                        onclick="return confirm('<c:out value="${confirmMessage}"/>');">
                                        <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key="jsp.href.delete" />" title="<fmt:message key="jsp.href.delete" />" />
                                    </a>
                                    </c:when>
                                </c:choose>       
                            </td>
                        </tr>
                    </c:when>
                </c:choose>
            </c:forEach>
        </table>
        <script type="text/javascript">alternate('TblData',true)</script>

        <%@ include file="../includes/pagingFooter.jsp"%>

        <br /><br />
    </div>
    
</div>

<%@ include file="../footer.jsp"%>