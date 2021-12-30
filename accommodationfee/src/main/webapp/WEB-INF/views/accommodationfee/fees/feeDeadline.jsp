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

<%--
 * Copyright (c) 2007 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
--%>

<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

    <%@ include file="../../menu.jsp"%>

	<spring:bind path="feeDeadlineForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>
    
    <div id="tabcontent">

			<fieldset>
    			<legend>
					<legend>
						<a href="<c:url value='/accommodation/fees/fees.view?newForm=true&currentPageNumber=${navigationSettings.currentPageNumber}'/>">
							<fmt:message key="jsp.general.backtooverview" />
						</a> 
						 &nbsp; &gt; &nbsp;
						<a href="<c:url value='/accommodation/fees/fee.view?newForm=true&accommodationFeeId=${feeDeadlineForm.accommodationFeeId}&fromView=fees.view&currentPageNumber=${navigationSettings.currentPageNumber}&tab=${navigationSettings.tab}'/>">
							<fmt:message key="jsp.general.fee" />
						</a> 
						 &nbsp; &gt; &nbsp;
	 	        	 <c:choose>
	                    <c:when test="${feeDeadlineForm.feeDeadline.id != 0}" >
                    		<fmt:message key="general.deadline"/>
    	                </c:when>
        	            <c:otherwise>
            	            <fmt:message key="jsp.href.new" />
                	    </c:otherwise>
					</c:choose>
					</legend>
				</legend>
			</fieldset>

 <form:form method="POST" commandName="feeDeadlineForm.feeDeadline">
        <form:hidden path="id"/>
        <form:hidden path="feeId"/>
        <form:hidden path="writeWho"/>
        <input type="hidden" name="task" id="task" value="submitFormObject"/>
        
	<table cellspacing="5">        
                <tr>
        	<td>
        		<label>
        			<fmt:message key="jsp.general.cardinaltimeunit"/>
        		</label>
        	</td>
        	<td class="required">
       			<form:select path="cardinalTimeUnitCode" onchange="this.form.task.value='updateFormObject'; this.form.submit();">
             		<form:option value=""><fmt:message key="jsp.selectbox.choose"/></form:option>
        
             		<c:forEach items="${feeDeadlineForm.cardinalTimeUnits}" var="cardinalTimeUnit">
             			<form:option value="${cardinalTimeUnit.code}"><c:out value='${cardinalTimeUnit.description}'/></form:option>
             		</c:forEach>
		                    
          		</form:select>
        	</td>
        	<form:errors path="cardinalTimeUnitCode" cssClass="error" element="td"/>
        </tr>
        
        <tr>
        	<td>
        		<label>
        			<fmt:message key="jsp.general.cardinaltimeunit.number"/>
        		</label>
        	</td>
        	<td class="required">
       			<form:select path="cardinalTimeUnitNumber">
             		<form:option value="0"><fmt:message key="jsp.selectbox.choose"/></form:option>
             		<c:forEach begin="1" end="${feeDeadlineForm.cardinalTimeUnit.nrOfUnitsPerYear}" var="unit">
             			<form:option value="${unit}"><c:out value='${unit}'/></form:option>
             		</c:forEach>
          		</form:select>
        	</td>
        	<form:errors path="cardinalTimeUnitNumber" cssClass="error" element="td"/>
        </tr>
        <tr>
        	<td>
        		<label>
        			<fmt:message key="general.deadline"/>
        		</label>
        	</td>
        	<td class="required">
       			<form:input path="deadline" size="10"  cssClass="datePicker" />
        	</td>
        	<td>(dd/MM/yyyy)</td>
        	<form:errors path="deadline" cssClass="error" element="td"/>
        </tr>
        
        <tr>
		<td>
			<label>
        		<fmt:message key="jsp.general.active"/>
        	</label>
			</td>        	
        	<td>
          		<form:select path="active">
             		<form:option value="Y"><fmt:message key="jsp.general.yes"/></form:option>
             		<form:option value="N"><fmt:message key="jsp.general.no"/></form:option>                    
          		</form:select>
         	</td>
             <form:errors path="active" cssClass="error" element="td"/>	
             
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
