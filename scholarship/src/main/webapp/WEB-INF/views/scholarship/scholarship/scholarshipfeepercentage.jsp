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

<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

	<spring:bind path="scholarshipFeePercentageForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>
    
    <div id="tabcontent">
    
    <fieldset>
    	<legend>
        	<a href="<c:url value='/scholarship/scholarships.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
        	
        	<a href="<c:url value='/scholarship/scholarship.view?newForm=true&tab=1&panel=0&scholarshipId=${scholarshipFeePercentageForm.scholarshipFeePercentage.scholarshipId}&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
        		<fmt:message key="jsp.general.scholarship"/>
        	</a>
        	&nbsp;>&nbsp;
        	 <c:choose>
                    <c:when test="${scholarshipFeePercentageForm.scholarshipFeePercentage.id != 0}" >
                    		<fmt:message key="general.percentage"/>&nbsp;>&nbsp;
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="jsp.href.new" />
                    </c:otherwise>
                </c:choose>
        	
    	</legend>
 	</fieldset>

 <form:form method="POST" commandName="scholarshipFeePercentageForm" cssStyle="padding-top:20px">
        <form:hidden path="scholarshipFeePercentage.id"/>
        <form:hidden path="scholarshipFeePercentage.scholarshipId"/>
        <form:hidden path="scholarshipFeePercentage.writeWho"/>
        
	<table cellspacing="5">        
        
        <tr>
        	<td>
        		<label>
        			<fmt:message key="general.feecategory"/>
        		</label>
        	</td>
        	<td class="required">
       			<form:select path="scholarshipFeePercentage.feeCategoryCode">
       				<form:option value=""><fmt:message key="jsp.selectbox.choose" /></form:option>
       				
       				<c:forEach items="${scholarshipFeePercentageForm.feeCategories}" var="feeCategory">
       					<%--disable categories which scholarship already has --%>
       					<c:choose>
       						<c:when test="${fn:contains(scholarshipFeePercentageForm.scholarshipFeeCategories, feeCategory.code) }">
       							<form:option value="${feeCategory.code}" disabled="true">${feeCategory.description}</form:option>		
       						</c:when>
       						<c:otherwise>
       							<form:option value="${feeCategory.code}">${feeCategory.description}</form:option>
       						</c:otherwise>
       					</c:choose>
       					
       				</c:forEach>
       				
       			</form:select>
        	</td>
        	<form:errors path="scholarshipFeePercentage.feeCategoryCode" cssClass="error" element="td"/>
        </tr>
        
        <tr>
        	<td>
        		<label>
        			<fmt:message key="general.percentage"/>
        		</label>
        	</td>
        	<td class="required">
       			<form:input path="scholarshipFeePercentage.percentage" size="50" maxlength="3" cssClass="numericField" />
        	</td>
        	<form:errors path="scholarshipFeePercentage.percentage" cssClass="error" element="td"/>
        </tr>
        
        <tr>
		<td>
			<label>
        		<fmt:message key="jsp.general.active"/>
        	</label>
			</td>        	
        	<td>
          		<form:select path="scholarshipFeePercentage.active">
             		<form:option value="Y"><fmt:message key="jsp.general.yes"/></form:option>
             		<form:option value="N"><fmt:message key="jsp.general.no"/></form:option>                    
          		</form:select>
         	</td>
             <form:errors path="scholarshipFeePercentage.active" cssClass="error" element="td"/>	
             
         </tr>
         
         <tr>
         	<td colspan="4" align="center">
         		<input type="submit" value="<fmt:message key='jsp.button.submit'/>">
         	</td>
         </tr>
     </table>
</form:form>
    
   
    </div><%--tabcontent --%>
</div><%--tabwrapper --%>

<%@ include file="../../footer.jsp"%>
