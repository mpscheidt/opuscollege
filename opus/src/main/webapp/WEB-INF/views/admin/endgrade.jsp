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

<c:set var="screentitlekey">jsp.general.endgrade</c:set>
<%@ include file="../header.jsp"%>

<body>

<div id="tabwrapper">

<%@ include file="../menu.jsp"%>

<div id="tabcontent">

<fieldset>
	<legend>
		<a href="<c:url value='/college/endgrades.view?currentPageNumber=${endGradeForm.navigationSettings.currentPageNumber}'/>">
			<fmt:message key="jsp.general.backtooverview" /> </a> &nbsp; > &nbsp;
		<c:out value="${endGradeForm.modelEndGrade.code}"/>
			
	</legend>
</fieldset>      

<c:choose>        
    <c:when test="${ not empty endGradeForm.txtErr }">       
       <p align="left" class="error">
            <c:out value="${endGradeForm.txtErr}"/>
       </p>
    </c:when>
</c:choose>

<form:form name="formdata" method="post" commandName="endGradeForm">		

	<c:forEach items="${endGradeForm.endGrades}" varStatus="row" var="endGrade">

    	<form:hidden path="endGrades[${row.index}].lang"/>
    	<form:hidden path="endGrades[${row.index}].id"/>
    	<form:hidden path="endGrades[${row.index}].code"/>

    	<%--only edit endGrades for language currently installed --%>
        <c:set var="containsLanguage" value="false" />
        <c:forEach var="item" items="${endGradeForm.appLanguagesShort}">
            <c:if test="${item eq fn:trim(endGrade.lang)}">
                <c:set var="containsLanguage" value="true" />
            </c:if>
        </c:forEach>

        <c:choose>
        	<c:when test="${containsLanguage 
                            && (endGrade.id == 0 || (endGrade.id != 0 && fn:trim(endGrade.lang) == fn:trim(endGradeForm.modelEndGrade.lang)) )}">
            	<fieldset>
            		<legend>
            			<fmt:message key="jsp.language.${fn:trim(endGradeForm.endGrades[row.index].lang)}"/>
            		</legend>        
                	<table>
                    	<tr>
                    		<td>
                    			<label>
                    				<fmt:message key="jsp.general.description"/>
                    			</label>
                    		</td>
                    		<td>
                    			<form:input path="endGrades[${row.index}].description" size="50"/>
                    		</td>
                    	</tr>
                    	
                        <tr>
                    		<td>
                    			<label>
                    				<fmt:message key="jsp.general.comment"/>
                    			</label>
                    		</td>
                    		<td class="required">
                    			<form:input path="endGrades[${row.index}].comment" size="50"/>
                    		</td>
                            <form:errors path="endGrades[${row.index}].comment" cssClass="error" element="td"/>
                        </tr>
                    </table>
                </fieldset>  	
          
        	</c:when>
        	<c:otherwise>
        		<form:hidden path="endGrades[${row.index}].description"/>   
        	</c:otherwise>
    	</c:choose>
	</c:forEach>

    <table>
    	<tr>
    		<td >
    			<label>
            		<fmt:message key="jsp.general.code"/>
            	</label>
    		</td>		
    		<td class="required">
    			<form:input path="modelEndGrade.code"/>
    		</td>
    		<form:errors path="modelEndGrade.code" cssClass="error" element="td"/>
    	</tr>
    	<tr>
    		<td>
    			<label>
            		<fmt:message key="general.type"/>
            	</label>
    		</td>		
    		<td class="required">
    		<form:select path="modelEndGrade.endGradeTypeCode">
                    <form:option value=""><fmt:message key="jsp.selectbox.choose" /></form:option>
                    <form:options items="${endGradeForm.endGradeTypes}" itemValue="code" itemLabel="description" />
                </form:select>		
    					
    		</td>
    		<form:errors path="modelEndGrade.endGradeTypeCode" cssClass="error" element="td"/>
    	</tr>
    	<tr>
    		<td>
    			<label>
            		<fmt:message key="jsp.general.gradepoint"/>
            	</label>
    		</td>		
    		<td>
    			<form:input path="modelEndGrade.gradePoint"/>		
    		</td>
    		<form:errors path="modelEndGrade.gradePoint" cssClass="error" element="td"/>
    	</tr>
    	<tr>
    		<td>
    			<label>
            		<fmt:message key="general.percentagemin"/>
            	</label>
    		</td>		
    		<td>
    			<form:input path="modelEndGrade.percentageMin"/>		
    		</td>
    		<form:errors path="modelEndGrade.percentageMin" cssClass="error" element="td"/>
    	</tr>
    	<tr>
    		<td>
    			<label>
            		<fmt:message key="general.percentagemax"/>
            	</label>
    		</td>		
    		<td>
    			<form:input path="modelEndGrade.percentageMax"/>		
    		</td>
    		<form:errors path="modelEndGrade.percentageMax" cssClass="error" element="td"/>
    	</tr>
    	<tr>
    		<td>
    			<label>
            		<fmt:message key="general.temporarygrade"/>
            	</label>
    		</td>		
    		<td>
    			<form:select path="modelEndGrade.temporaryGrade">
                 <form:option value="Y"><fmt:message key="jsp.general.yes"/></form:option>
                 <form:option value="N"><fmt:message key="jsp.general.no"/></form:option>                    
              </form:select>		
    		</td>
    		<form:errors path="modelEndGrade.temporaryGrade" cssClass="error" element="td"/>
    	</tr>
    	<tr>
    		<td>
    			<label>
            		<fmt:message key="jsp.general.academicyear"/>
            	</label>
    		</td>		
    		<td class="required">
    			<form:select path="modelEndGrade.academicYearId">
                    <form:option value="0"><fmt:message key="jsp.selectbox.choose" /></form:option>
                    <form:options items="${endGradeForm.academicYears}" itemValue="id" itemLabel="description" />
                </form:select>		
    		</td>
    		<form:errors path="modelEndGrade.academicYearId" cssClass="error" element="td"/>
    	</tr>
    	<tr>
    		<td>
    			<label>
            		<fmt:message key="jsp.general.passed"/>
            	</label>
    		</td>
    		<td>
              <form:select path="modelEndGrade.passed">
                 <form:option value="Y"><fmt:message key="jsp.general.yes"/></form:option>
                 <form:option value="N"><fmt:message key="jsp.general.no"/></form:option>                    
              </form:select>
             </td>
                 <form:errors path="modelEndGrade.passed" cssClass="error" element="td"/>
    		</tr>
    	<tr>
    		<td>
    			<label>
            		<fmt:message key="jsp.general.active"/>
            	</label>
    		</td>
    		<td>
                <form:select path="modelEndGrade.active">
                    <form:option value="Y"><fmt:message key="jsp.general.yes"/></form:option>
                    <form:option value="N"><fmt:message key="jsp.general.no"/></form:option>                    
                </form:select>
             </td>
             <form:errors path="modelEndGrade.active" cssClass="error" element="td"/>
		</tr>

		<tr>
    		<td colspan="3" align="center">
    			<p>&nbsp;</p>
        		<input type="submit" value="<fmt:message key="jsp.button.submit" />" />
    		</td>
		</tr>    
	</table>

		
</form:form>
			
</div><!-- tabcontent -->    
</div><!-- tabwrapper -->

<%@ include file="../footer.jsp"%>