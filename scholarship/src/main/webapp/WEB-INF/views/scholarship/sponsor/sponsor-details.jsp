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

The Original Code is Opus-College scholarship module code.

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

<div class="Accordion" id="Accordion0" tabindex="0">
	<div class="AccordionPanel">
		<div class="AccordionPanelTab compulsoryPanel"><fmt:message key="jsp.general.details" /></div>
			<div class="AccordionPanelContent">


	<form:form method="POST" commandName="sponsorForm" cssStyle="padding-top:20px">
        <form:hidden path="sponsor.id"/>
	<table cellspacing="5">        

        <tr>
            <td class="label"><fmt:message key="jsp.general.academicyear" /></td>
            <td class="required">
                <form:select path="sponsor.academicYearId">
                    <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
                    <form:options items="${sponsorForm.allAcademicYears}" itemValue="id" itemLabel="description"/>
                </form:select>
            </td>
            <form:errors path="sponsor.academicYearId" cssClass="error" element="td"/>
        </tr>

        <tr>
        	<td>
        		<label>
        			<fmt:message key="jsp.general.code"/>
        		</label>
        	</td>
        	<td class="required">
       			<form:input path="sponsor.code" size="50"/>
        	</td>
        	<form:errors path="sponsor.code" cssClass="error" element="td"/>
        </tr>
        
        <tr>
        	<td>
        		<label>
        			<fmt:message key="jsp.general.name"/>
        		</label>
        	</td>
        	<td class="required">
        		<form:input path="sponsor.name" size="50"/>
        	</td>
        	<form:errors path="sponsor.name" cssClass="error" element="td"/>
        </tr>
        
        <tr>
        	<td>
        		<label>
        			<fmt:message key="jsp.general.type"/>
        		</label>
        	</td>
        	<td>
        	<form:select path="sponsor.sponsorTypeCode">
        		<form:option value=""><fmt:message key="jsp.selectbox.choose"/></form:option>
        		
        		<c:forEach items="${sponsorForm.sponsorTypes}" var="sponsorType">
       					<form:option value="${sponsorType.code}">
       						${sponsorType.description}  (${sponsorType.title})
       					</form:option>
       			</c:forEach>
       			
        	</form:select>
        	</td>
        	<form:errors path="sponsor.sponsorTypeCode" cssClass="error" element="td"/>
        </tr>
        
        <tr>
    		<td>
    			<label>
            		<fmt:message key="jsp.general.active"/>
            	</label>
    		</td>
    		<td>
              <form:select path="sponsor.active">
                 <form:option value="Y"><fmt:message key="jsp.general.yes"/></form:option>
                 <form:option value="N"><fmt:message key="jsp.general.no"/></form:option>                    
              </form:select>
            </td>
            <form:errors path="sponsor.active" cssClass="error" element="td"/>
		</tr>
        
        	<tr>
        		<td colspan="4" align="center" style="padding:20px">
        			<input type="submit" value="<fmt:message key="jsp.button.submit" />" />
        		</td>
        	</tr>
        </table>
    </form:form>
    
    
		</div><%-- AccordionPanelContent --%>
	</div><%-- AccordionPanel --%>
</div><%-- Accordion0 --%>

 <script type="text/javascript">
                        var Accordion${accordion} = new Spry.Widget.Accordion("Accordion0",
                              {defaultPanel: 0,
                              useFixedPanelHeights: false,
                              nextPanelKeyCode: 78 /* n key */,
                              previousPanelKeyCode: 80 /* p key */
                             });
                        
</script>