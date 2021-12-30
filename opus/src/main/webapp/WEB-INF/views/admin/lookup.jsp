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

<c:set var="screentitlekey">jsp.lookuptable.${lookupForm.lookupTable}.label1</c:set>
<%@ include file="../header.jsp"%>

<body>

<div id="tabwrapper"><%@ include file="../menu.jsp"%>


    <spring:bind path="lookupForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>  

<div id="tabcontent">

<fieldset>
<legend>
<a href="<c:url value='/college/lookuptables.view?currentPageNumber=${overviewPageNumber}&amp;institutionTypeCode=3'/>">
    <fmt:message key="jsp.general.backtooverview" /> </a> &nbsp; > &nbsp;

<a href="<c:url value='/college/lookups.view?lookupTable=${lookupForm.lookupTable}&amp;operation=edit&amp;language=${primaryLookup.lang}&amp;lookupCode=${primaryLookup.code}&amp;currentPageNumber=${lookupForm.navigationSettings.currentPageNumber}&amp;institutionTypeCode=${institutionTypeCode}'/>">
    <fmt:message key="jsp.lookuptable.${fn:toLowerCase(lookupForm.lookupTable)}.label2" /> </a> &nbsp; > &nbsp;    
     <fmt:message key="jsp.lookuptable.${fn:toLowerCase(lookupForm.lookupTable)}.label1" />/
     
     <c:choose>
        <c:when test="${not empty lookupForm.lookupCode}">
            <fmt:message key="jsp.general.edit" />       
        </c:when>
        <c:otherwise>
            <fmt:message key="jsp.href.new" />       
        </c:otherwise>
     </c:choose>
     
    </legend>

<!-- <p><strong><fmt:message key="jsp.lookuptables.newtimeunit"/></strong></p>-->
<form:form method="post" commandName="lookupForm">
        
    <c:forEach items="${lookupForm.lookups}" varStatus="row" var="lookup">
    	<form:hidden path="lookups[${row.index}].lang"/>
    	<form:hidden path="lookups[${row.index}].id"/>
    	<form:hidden path="lookups[${row.index}].code"/>
    
        <%--only edit lookups for language currently installed --%>
        <c:set var="containsLanguage" value="false" />
        <c:forEach var="item" items="${lookupForm.appLanguagesShort}">
            <c:if test="${item eq fn:trim(lookup.lang)}">
                <c:set var="containsLanguage" value="true" />
            </c:if>
        </c:forEach>
        <c:choose>
        	<c:when test="${containsLanguage}">    
            	<fieldset>
            		<legend>
            			<fmt:message key="jsp.language.${fn:trim(lookupForm.lookups[row.index].lang)}"/>
            		</legend>        
            	    <table>
                    	<tr>
                    		<td>
                    			<label>
                    				<fmt:message key="jsp.general.description"/>
                    			</label>
                    		</td>
                    		<td>
                    			<form:input path="lookups[${row.index}].description" size="50"/>
                    		</td>
                    		<form:errors path="lookups[${row.index}].description" cssClass="error" element="td"/>
                    	</tr>
                    </table>
                </fieldset>  	
        	</c:when>
    	<c:otherwise>
    		<form:hidden path="lookups[${row.index}].description"/>   
    	</c:otherwise>
    	</c:choose>
	</c:forEach>
 		
 		            
	<table>
		<tr>
		<td>
			<label>
        		<fmt:message key="jsp.general.active"/>
        	</label>
		</td>
		<td>
          <form:select path="lookupActive">
             <form:option value="Y"><fmt:message key="jsp.general.yes"/></form:option>
             <form:option value="N"><fmt:message key="jsp.general.no"/></form:option>                    
          </form:select>
         </td>
             <form:errors path="lookupActive" cssClass="error" element="td"/>
		</tr>
		<tr>
    		<td colspan="3" align="center">
    			<p>&nbsp;</p>
        		<input type="submit" value="<fmt:message key="jsp.button.submit" />" />
    		</td>
		</tr>    
	</table>

</form:form>
</fieldset>
<br />
<br />
</div>

</div>

<%@ include file="../footer.jsp"%>