<%--
***** BEGIN LICENSE BLOCK *****
Version: MPL 1.1/GPL 2.0/LGPL 2.1

The contents of this file are subject to the Mozilla Public License Version
1.1 (the "License"); you may not use this file except in compliance with
the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
for the specific language governing rights and limitations under the
License.

The Original Code is Opus-College college module code.

The Initial Developer of the Original Code is
Center for Information Services, Radboud University Nijmegen.
Portions created by the Initial Developer are Copyright (C) 2008
the Initial Developer. All Rights Reserved.

Contributor(s):
  For Java files, see Javadoc @author tags.

Alternatively, the contents of this file may be used under the terms of
either the GNU General Public License Version 2 or later (the "GPL"), or
the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
in which case the provisions of the GPL or the LGPL are applicable instead
of those above. If you wish to allow use of your version of this file only
under the terms of either the GPL or the LGPL, and not to allow others to
use your version of this file under the terms of the MPL, indicate your
decision by deleting the provisions above and replace them with the notice
and other provisions required by the GPL or the LGPL. If you do not delete
the provisions above, a recipient may use your version of this file under
the terms of any one of the MPL, the GPL or the LGPL.

***** END LICENSE BLOCK *****
--%>

<%@ include file="../includes/standardincludes.jsp"%>

<c:set var="screentitlekey">jsp.lookuptable.${lookupTable}.label2</c:set>
<%@ include file="../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../menu.jsp"%>

    
    <div id="tabcontent">
 <fieldset>
 <legend>
    <a href="<c:url value='/college/lookuptables.view?currentPageNumber=${overviewPageNumber}&amp;institutionTypeCode=3'/>">
    <fmt:message key="jsp.lookuptables.header"/></a> >
    <fmt:message key="jsp.lookuptable.${lookupTable}.label2" />
    </legend>
        
        <%--
        	Only show language dropwdown if there is more than a language installed
         --%>
        <c:if test="${fn:length(availableLanguages) > 1}">
        <form name="languageForm" method="get" style="padding:10px">
            
            <input type="hidden" name="lookupTable" value="${lookupTable}">
            
            <table>
                 <tr>
                    <td class="label">
                    	<fmt:message key="jsp.general.language" />
                    </td>
                    
                    <td width="700" align="left">
                    	<%@ include file="../includes/languageSelect.jsp"%>
                    </td>
                </tr>
            </table>
        </form>
        </c:if>
        
         <form name="searchform" id="searchform" method="get" style="padding:10px">
         <input type="hidden" name="lookupTable" value="${lookupTable}" />
         <input type="hidden" name="selectedLanguages" value="${selectedLanguages}" />
                <table>
                    <tr>
                    <td class="label"><fmt:message key="jsp.general.search" /></td>
                        <td width="700" align="left">
                           <img src="<c:url value='/images/trans.gif' />" width="10" alt='<fmt:message key="jsp.general.search"/>'/>            
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
            
        <a class="button" href="<c:url value='/college/${fn:toLowerCase(lookupType)}.view?lookupTable=${lookupTable}&amp;currentPageNumber=${currentPageNumber}&amp;newForm=true'/>">
            <fmt:message key="jsp.href.add" />
        </a>
           <c:choose>
                <c:when test="${(not empty showError)}">             
                    <p align="left" class="errorwide">
                        <fmt:message key="jsp.lookup.delete.error.arg">
                            <fmt:param><c:out value="${description}"/></fmt:param>
                            <fmt:param><c:out value="${dependenttable}"/></fmt:param>
                        </fmt:message>                        
                    </p>
                </c:when>
            </c:choose>
     </fieldset>
        <c:set var="allEntities" value="${primaryLookups}" scope="page" />
        <c:set var="redirView" value="lookups" scope="page" />
        <c:set var="params" value="lookupTable=${lookupTable}" scope="page" />
        <c:set var="entityNumber" value="0" scope="page" />
        <c:set var="index" value="${entityNumber}" scope="page" />

        <%@ include file="../includes/pagingHeader.jsp"%>
         
        <table class="tabledata" id="TblData">
            <%@ include file="../includes/lookupLanguageHeader.jsp"%>
            <tr>
            <%@ include file="../includes/lookupHeaders.jsp"%>
            
            <!-- 
                 if only a language was selected then display only a column for that
                 language , otherwise display two
            
            -->
            <c:choose>
               <c:when test="${secondaryLanguage != primaryLanguage}"> 
                    <th>&nbsp;&nbsp;&nbsp;</th>
                    <%@ include file="../includes/lookupHeaders.jsp"%>
               </c:when>
           </c:choose>
            <!-- button cell-->
            <th>&nbsp;</th>
            </tr>
            
            <c:forEach var="primaryLookup" items="${primaryLookups}">
            <!-- This variable will be used with lookupCells.jsp file -->
            <c:set var="lookup" scope="page" value="${primaryLookup}"/>
                <c:set var="entityNumber" value="${entityNumber + 1}" scope="page" />
                <c:set var="index" value="${entityNumber - 1}" scope="page" />
                <c:choose>
                    <c:when test="${(entityNumber < (currentPageNumber*initParam.iPaging) + 1) && (entityNumber > ((currentPageNumber*initParam.iPaging) - initParam.iPaging)) }" >
                        <tr>
                           <!-- <td width="4%">
                                <c:choose>
                                    <c:when test="${not empty primaryLookup}">
                                    ${primaryLookup.code}
                                    </c:when>
                                    <c:otherwise>
                                    ${secondaryLookups[index].code}
                                    </c:otherwise>
                                </c:choose>
                                
                               &nbsp; 
                           </td>-->
                           <td>
                           <!-- print first language version of this lookup -->
                           
                                    <a href="
                                    <c:url value='/college/${fn:toLowerCase(lookupType)}.view?lookupCode=${primaryLookup.code}&amp;lookupTable=${lookupTable}&amp;currentPageNumber=${currentPageNumber}'/>">
                                    <c:out value="${primaryLookup.description}"/>
                                    </a>
                                    &nbsp;
                           </td>
                           <%@ include file="../includes/lookupCells.jsp"%>
                           <!-- 
                            if only a language was selected then display only a single column in the table
                            otherwise display two columns , one for each language
                            -->
                           <c:choose>
                            <c:when test="${secondaryLanguage != primaryLanguage}">

                           <c:set var="secondaryLookup" scope="page" value="${secondaryLookups[index]}"/>

                           <c:set var="lookup" scope="page" value="${secondaryLookup}"/>  
                            <!-- print secondary version of this lookup -->
                             
                             <td style="width:2%; background-color:inherit; border:none;">&nbsp;</td>
                             <td>
                                <c:set var="lookup" scope="page" value="${secondaryLookup}"/>
                                                                     
                                    <a href="
                                    <c:url value='/college/${fn:toLowerCase(lookupType)}.view?lookupCode=${secondaryLookup.code}&amp;lookupTable=${lookupTable}&amp;currentPageNumber=${currentPageNumber}'/>">
                                    <c:out value="${secondaryLookup.description}"/>
                                    </a>
                                 
                            <!-- the space "&nbsp;" ensures that the cell will displayed when the lookup lacks
                            a description
                             -->
                            &nbsp;
                            </td>
                               <%@ include file="../includes/lookupCells.jsp"%>




                            </c:when>
                            </c:choose>
                          
                            <td class="buttonsCell" style="width:7%">
                                <c:choose>
                                    <c:when test="${(
                                        opusUserRole.role != 'teacher'
                                        && opusUserRole.role != 'student' 
                                        && opusUserRole.role != 'guest'
                                        && opusUserRole.role != 'staff'
                                        )}">
                                        
                                    <c:choose>
                                    <%-- 
                                        If a primarylookup is empty , then is the details in the second lookup 
                                    
                                    --%>
                                    <c:when test="${not empty primaryLookup}">
                                        <c:set var="lookupToUse" value="${primaryLookup}" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="lookupToUse" value="${secondaryLookup}" />
<%--                                        <a class="imageLink" href="<c:url value='/college/${fn:toLowerCase(lookupType)}.view?lookupCode=${secondaryLookup.code}&amp;lookupTable=${lookupTable}&amp;operation=edit&amp;language=${secondaryLookup.lang}&amp;code=${secondaryLookup.code}&amp;currentPageNumber=${currentPageNumber}&amp;institutionTypeCode=${institutionTypeCode}'/>">
                                            <img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" />
                                        </a>
                                        <a class="imageLinkPaddingLeft" href="<c:url value='/college/lookupdelete.view?lookupTable=${lookupTable}&amp;code=${secondaryLookup.code}&amp;currentPageNumber=${currentPageNumber}&amp;institutionTypeCode=${institutionTypeCode}&amp;description=<c:out value="${secondaryLookup.description}"/>&amp;lookupType=${lookupType}'/>"
                                            onclick='return confirm("<fmt:message key="jsp.general.delete.confirm.arg" ><fmt:param><c:out value="${secondaryLookup.description}"/></fmt:param></fmt:message>")'>
                                            <img src="<c:url value='/images/delete.gif' />" alt="<fmt:message key='jsp.href.delete'/>" title="<fmt:message key='jsp.href.delete' />" />
                                        </a> --%>
                                    </c:otherwise>
                                    </c:choose>
                                    <a class="imageLink" href="<c:url value='/college/${fn:toLowerCase(lookupType)}.view?lookupCode=${lookupToUse.code}&amp;lookupTable=${lookupTable}&amp;currentPageNumber=${currentPageNumber}&amp;institutionTypeCode=${institutionTypeCode}'/>">
                                        <img src="<c:url value='/images/edit.gif' />" alt="<fmt:message key="jsp.href.edit" />" title="<fmt:message key="jsp.href.edit" />" />
                                    </a>
                                    <c:url var="deleteURL" value='/college/lookupdelete.view'>
                                        <c:param name="lookupCode" value="${lookupToUse.code}"/>
                                        <c:param name="lookupTable" value="${lookupTable}"/>
                                        <c:param name="code" value="${lookupToUse.code}"/>
                                        <c:param name="currentPageNumber" value="${currentPageNumber}"/>
                                        <c:param name="institutionTypeCode" value="${institutionTypeCode}"/>
                                        <c:param name="description" value="${lookupToUse.description}"/>
                                    </c:url>
                                    <c:set var="confirmMessage"><fmt:message key="jsp.general.delete.confirm.arg" ><fmt:param>${lookupToUse.description}</fmt:param></fmt:message></c:set>
                                    <a class="imageLinkPaddingLeft" href='<c:out value="${deleteURL}"/>' onclick="return confirm('<c:out value="${confirmMessage}"/>');" >
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