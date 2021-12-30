
<%@ include file="../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../menu.jsp"%>

    
    <div id="tabcontent">
 <fieldset>
 <legend>
    <a href="<c:url value='/college/report/reports.view'/>?newForm=true&viewName=${reportsForm.overviewPage}">
    <fmt:message key="jsp.general.backtooverview" /> </a> &nbsp; > &nbsp;
    <fmt:message key="${titleKey}"/>
    </legend>
        <br />
         <form name="searchform" id="searchform" method="get" action="<c:url value='/college/report/reportproperties.view'/>">
         <input type="hidden" name="reportName" value="${reportName}" />
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
            <!-- 
        <a href="<c:url value='/report/property.view?reportName=${reportName}'/>">
            <img src="<c:url value='/images/add.gif' />" 
            alt="<fmt:message key="jsp.link.addproperty" />" 
            title="<fmt:message key="jsp.link.addproperty" />"
         />
        </a>-->
           
     </fieldset>      
        <c:set var="allEntities" value="${properties}" scope="page" />
        <c:set var="redirView" value="report" scope="page" />
        <c:set var="params" value="report=${report}" scope="page" />
        <c:set var="entityNumber" value="0" scope="page" />
        <c:set var="index" value="${entityNumber}" scope="page" />

        <%@ include file="../includes/pagingHeader.jsp"%>
         
        <table class="tabledata" id="TblData">
          
            <!-- button cell-->
            <th><fmt:message key="jsp.general.name" /></th>
            <th style="text-align: center"><fmt:message key="jsp.general.type" /></th>
            <th><fmt:message key="jsp.general.description" /></th>
            <th style="width:4px;text-align: center"><fmt:message key="jsp.general.visible" /></th>
            <th><!-- buttons cell --></th>
            
                <c:forEach var="property" items="${properties}">
                <c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
                <c:set var="index" value="${entityNumber - 1}" scope="page" />
                <c:choose>
                    <c:when test="${(entityNumber < (currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
                        <tr>
                            
                            <td>                            
                                <a href="<c:url value='/college/report/reportproperty.view?reportName=${reportName}&reportPath=${reportPath}&propertyId=${property.id}&propertyName=${property.name}&propertyType=${property.type}&propertyText=${fn:escapeXml(property.text)}'/>">
                                    <fmt:message key="jsp.report.${fn:toLowerCase(property.name)}" />
                                </a>                     
                            </td>
                            
                            <td style="text-align: center">
                                        ${property.type} 
                            </td>
                            <td style="text-align: center">
                                <c:choose>
                                    <c:when test="${property.type == 'text'}">
                                    	<span title="${fn:escapeXml(property.text)}">
                                    	<c:choose>
                                    	<%-- show only the 30 first characters, so it doesn't take to much space on screen --%>
                                    		<c:when test="${fn:length(property.text) > 30}">
                                    			${fn:substring(fn:escapeXml(property.text), 0, 30)}...
                                    		</c:when>
                                    		<c:otherwise>
                                    			${fn:escapeXml(property.text)}                      			
                                    		</c:otherwise>
                                       </c:choose>
                                       </span>
                                    </c:when>
                                    <c:otherwise>
                                    <c:choose>
                                        <c:when test="${property.id == 0}">
                                            <%-- 
                                                When a property id equals zero it means that it is not
                                                present in the database but is in the report.
                                                In order to know what is the image name of the property
                                                the image name is temporally stored in the text attribute.
                                                However the text attribute will be ignored when the image is 
                                                being added to the database. 
                                            
                                            --%>
                                            <img src="<c:url value='/images/report/${property.text}' />"
                                                 width="100"
                                            />    
                                        </c:when>

                                        <c:otherwise>
                                          <c:choose>
                                            <c:when test="${property.type == 'image/svg+xml'}">
                                            
                                            <object data="<c:url value='/college/report/filedisplay.view?propertyId=${property.id}&currentPageNumber=${currentPageNumber}'/>" type="image/svg+xml"></object>
<%-- embed tag replaced by object tag
                                             <embed src="<c:url 
                                                 value='/college/report/filedisplay.view?propertyId=${property.id}
                                                  &currentPageNumber=${currentPageNumber}'/>"
                                                width="200" height="100"
                                                type="image/svg+xml"
                                                pluginspage="http://www.adobe.com/svg/viewer/install/" />
--%>                                                 
                                            </c:when>
                                            <c:when test="${fn:startsWith(property.type, 'image/')}">
                                             <img src="<c:url 
                                                 value='/college/report/filedisplay.view?propertyId=${property.id}
                                                  &currentPageNumber=${currentPageNumber}'/>" 
                                                  width="100" 
                                                   title="${property.name}" /> 
                                            </c:when>
                                           </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                        
                                    </c:otherwise>
                                </c:choose>
                                                         
                                   &nbsp;
                            </td>
                            <td style="width:4px;text-align: center">
                            <c:choose>
                                <c:when test="${property.visible == true}">
                                    <fmt:message key="jsp.general.yes" />
                                </c:when>
                                <c:otherwise>
                                    <fmt:message key="jsp.general.no" />
                                </c:otherwise>
                            </c:choose>
                        </td>
                            <td class="buttonsCell" style="width:14%;text-align: center">                                
                                   <a href="<c:url value='/college/report/reportproperty.view?reportName=${reportName}&reportPath=${reportPath}&propertyId=${property.id}&propertyName=${property.name}&propertyType=${property.type}&propertyText=${fn:escapeXml(property.text)}'/>">
                                        <img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" />
                                    </a>      
                                    <%-- only show reset link if property has a custom value --%>                              
                                    <c:if test="${property.id != 0}">
                                    	&nbsp;&nbsp;
                                    	<a href="<c:url value='/college/report/reportproperty_delete.view?reportName=${reportName}&reportPath=${reportPath}&propertyId=${property.id}&currentPageNumber=${currentPageNumber}&institutionTypeCode=${institutionTypeCode}'/>"
                                    		onclick='return confirm("<fmt:message key="jsp.general.reset.confirm.arg" ><fmt:param><fmt:message key="jsp.report.${fn:toLowerCase(property.name)}" /></fmt:param></fmt:message>")'>
                                    		<fmt:message key="jsp.general.reset" />
                                    </a>                             
                                    </c:if>             
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