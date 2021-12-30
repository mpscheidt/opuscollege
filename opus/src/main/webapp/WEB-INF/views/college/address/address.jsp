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

<%@ include file="../../includes/standardincludes.jsp"%>

<c:set var="screentitlekey">jsp.general.address</c:set>
<%@ include file="../../header.jsp"%>

<body>

<div id="tabwrapper">

	<%@ include file="../../menu.jsp"%>

	<spring:bind path="addressForm.address">
        <c:set var="address" value="${status.value}" scope="page" />
    </spring:bind>
    
    <!-- necessary spring binds for organization and navigationSettings
		 regarding form handling through includes -->
    <spring:bind path="addressForm.organization">
        <c:set var="organization" value="${status.value}" scope="page" />
    </spring:bind>  
    <spring:bind path="addressForm.navigationSettings">
        <c:set var="navigationSettings" value="${status.value}" scope="page" />
    </spring:bind>  

	<div id="tabcontent">
    	<form>
    		<fieldset>
    			<legend>
    			<c:choose>
    				<c:when test="${addressForm.staffMember != null}" >
                        <a href="<c:url value='/college/staffmembers.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
   						<a href="<c:url value='/college/staffmember.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;staffMemberId=${addressForm.staffMember.staffMemberId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
        					<c:set var="staffMemberName" value="${addressForm.staffMember.surnameFull}, ${addressForm.staffMember.firstnamesFull}" scope="page" />
        					<c:out value="${fn:substring(staffMemberName,0,initParam.iTitleLength)}"/>
   						</a>
    				</c:when>
    				<c:when test="${addressForm.student != null}" >
                        <a href="<c:url value='/college/students.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
   						    <a href="<c:url value='/college/student-addresses.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;studentId=${addressForm.student.studentId}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
        					<c:set var="studentName" value="${addressForm.student.surnameFull}, ${addressForm.student.firstnamesFull}" scope="page" />
        					<c:out value="${fn:substring(studentName,0,initParam.iTitleLength)}"/>
   						</a>
    				</c:when>
    				<c:when test="${addressForm.study != null}" >
                        <a href="<c:url value='/college/studies.view?currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
   						<a href="<c:url value='/college/study.view?newForm=true&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;studyId=${addressForm.study.id}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
        					<c:out value="${fn:substring(addressForm.study.studyDescription,0,initParam.iTitleLength)}"/>
   						</a>
    				</c:when>
    				<c:when test="${addressForm.organizationalUnit != null}" >
                        <a href="<c:url value='/college/organizationalunits.view?institutionTypeCode=${organization.institutionTypeCode}&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>"><fmt:message key="jsp.general.backtooverview" /></a>&nbsp;>&nbsp;
   						<a href="<c:url value='/college/organizationalunit.view?newForm=true&amp;organizationalUnitId=${addressForm.organizationalUnit.id}&amp;from=organizationalunit&amp;tab=${navigationSettings.tab}&amp;panel=${navigationSettings.panel}&amp;institutionTypeCode=${organization.institutionTypeCode }&amp;currentPageNumber=${navigationSettings.currentPageNumber}'/>">
        					<c:out value="${fn:substring(addressForm.organizationalUnit.organizationalUnitDescription,0,initParam.iTitleLength)}"/>
   						</a>
    				</c:when>
				</c:choose>
				&nbsp;&gt;&nbsp;<fmt:message key="jsp.general.add" />/<fmt:message key="jsp.general.edit" />&nbsp;<fmt:message key="jsp.general.address" /> 
				</legend>
			</fieldset>
		</form>

	  	<div id="tp1" class="TabbedPanel">
		    <ul class="TabbedPanelsTabGroup">
		      <li class="TabbedPanelsTab"><fmt:message key="jsp.general.addresses" /></li>  		       
		    </ul>

		    <div class="TabbedPanelsContentGroup">   
		        <div class="TabbedPanelsContent">
		            <div class="Accordion" id="Accordion0" tabindex="0">
				        <div class="AccordionPanel">
		                    <div class="AccordionPanelTab"><fmt:message key="jsp.general.address" /></div>
					        <div class="AccordionPanelContent">
			            
				                <form name="formdata" method="post">
									<input type="hidden" name="navigationSettings.tab" value="<c:out value="${navigationSettings.tab}" />" />
									<input type="hidden" name="navigationSettings.panel" value="<c:out value="${navigationSettings.panel}" />" />
									<input type="hidden" name="navigationSettings.currentPageNumber" value="<c:out value="${navigationSettings.currentPageNumber}" />" />
									<input type="hidden" name="submitFormObject" id="submitFormObject" value="" />
			                        <input type="hidden" name="addressForm.from" id="addressForm.from" value="<c:out value="${addressForm.from}" />" />
			            			<table>
			                        <tr>
			                          <td class="label"><fmt:message key="jsp.general.address.type" /></td>
			                          <spring:bind path="addressForm.address.addressTypeCode">
			                          <c:choose>
			                          <c:when test="${addressForm.from == 'organizationalunit' || addressForm.from == 'study'}">
			    	                      <td>
			    	                      	<c:forEach var="addressType" items="${allAddressTypes}">
			    	                      	<c:choose>
			                                    <c:when test="${status.value == null || addressType.code == status.value}">
			                                        <c:out value="${addressType.description}"/>
			                                    </c:when>
			                                    </c:choose>
			    	                      	</c:forEach>
			    	                      </td>
			                          </c:when>
			                          <c:otherwise>
			                                    
			                          <td class="required">
			                            <select name="${status.expression}">
			                                <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
			                                <c:forEach var="addressType" items="${addressForm.allAddressTypesForEntity}">
			                                <c:choose>
			                                    <c:when test="${addressType.code == status.value}">
			                                        <option value="${addressType.code}" selected="selected"><c:out value="${addressType.description}"/></option>
			                                    </c:when>
			                                    <c:otherwise>
			                                        <option value="${addressType.code}"><c:out value="${addressType.description}"/></option>
			                                    </c:otherwise>
			                                    </c:choose> 
			                               </c:forEach>
			                            </select>
			                          </td>
				                    </c:otherwise>
			                      </c:choose> 
			                            
			                      <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
			                      </spring:bind>
			                    </tr>
			                     <tr>
			                      <td class="label"><fmt:message key="jsp.general.country" /></td>
			                      <spring:bind path="addressForm.address.countryCode">
			                      <td class="required">
			                          <select name="${status.expression}" onchange="updateEmptyNumber('address.number','0');document.getElementById('address.provinceCode').value='0';document.getElementById('address.districtCode').value='0';document.getElementById('address.administrativePostCode').value='0';document.formdata.submit();">
			                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
			                             <c:forEach var="country" items="${allCountries}">
		                                	<c:choose>
		                                        <c:when test="${country.code == status.value}">
		                                    		<option value="${country.code}" selected="selected"><c:out value="${country.description}"/></option>
		                                		</c:when>
		                                		<c:otherwise>
		                                    		<option value="${country.code}"><c:out value="${country.description}"/></option>
		                                		</c:otherwise>
		                                	</c:choose>
			                            </c:forEach> 
			                        </select>
			                      </td>
			                      <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
			                      </spring:bind>
			                    </tr>
			                    <tr>
			                      <td class="label"><fmt:message key="jsp.general.province" /></td>
			                      <spring:bind path="addressForm.address.provinceCode">
			                      <td class="required">
			                          <select id="${status.expression}" name="${status.expression}" onchange="updateEmptyNumber('address.number','0');document.getElementById('address.administrativePostCode').value='0';document.getElementById('address.districtCode').value='0';document.formdata.submit();">
			                           <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
			                           <c:forEach var="province" items="${allProvinces}">
			                               <c:choose>
			                                <c:when test="${province.code == status.value}">
			                                    <option value="${province.code}" selected="selected"><c:out value="${province.description}"/></option>
			                                </c:when>
			                                <c:otherwise>
			                                    <option value="${province.code}"><c:out value="${province.description}"/></option>
			                                </c:otherwise>
			                               </c:choose>
			                            </c:forEach> 
			                        </select>
			                      </td>
			                      <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
			                      </spring:bind>
			                    </tr>
			                    <tr>
			                      <td class="label"><fmt:message key="jsp.general.district" /></td>
			                      <spring:bind path="addressForm.address.districtCode">
			                      <td>
			                        <select id="${status.expression}" name="${status.expression}" onchange="updateEmptyNumber('address.number','0');document.getElementById('address.administrativePostCode').value='0';document.formdata.submit();">
			                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
			                            <c:forEach var="district" items="${allDistricts }">
			                               <c:choose>
			                                <c:when test="${district.code == status.value}">
			                                    <option value="${district.code}" selected="selected"><c:out value="${district.description}"/></option>
			                                </c:when>
			                                <c:otherwise>
			                                    <option value="${district.code}"><c:out value="${district.description}"/></option>
			                                </c:otherwise>
			                               </c:choose>
			                            </c:forEach> 
			                        </select>
			                      </td>
			                      <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
			                      </spring:bind>
			                    </tr>
			                    <tr>
			                      <td class="label"><fmt:message key="jsp.general.address.administrativepost" /></td>
			                      <spring:bind path="addressForm.address.administrativePostCode">
			                      <td>
			                        <select id="${status.expression}" name="${status.expression}"  onchange="updateEmptyNumber('address.number','0');document.formdata.submit();">
			                            <option value="0"><fmt:message key="jsp.selectbox.choose" /></option>
			                            <c:forEach var="administrativePost" items="${allAdministrativePosts}">
			                               <c:choose>
			                                <c:when test="${administrativePost.code == status.value}">
			                                    <option value="${administrativePost.code}" selected="selected"><c:out value="${administrativePost.description}"/></option>
			                                </c:when>
			                                <c:otherwise>
			                                    <option value="${administrativePost.code}"><c:out value="${administrativePost.description}"/></option>
			                                </c:otherwise>
			                               </c:choose>
			                            </c:forEach> 
			                        </select>
			                      </td>
			                      <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
			                      </spring:bind>
			                    </tr>
			                    <tr>
			                      <td class="label"><fmt:message key="jsp.general.city" /></td>
			                      <spring:bind path="addressForm.address.city">
			                      <td  class="required">
			                          <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
			                      </td>
			                      <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
			                      </spring:bind>
			                 </tr>
			                 
			                 <tr><td colspan="3">&nbsp;</td></tr>
			                 <tr>
						        <td colspan="3" class="label">
						            <fmt:message key="jsp.streetpobox.address.header" />
						        </td>
						    </tr>
			                <tr>
			                    <td colspan="2">
                                    <table>
                                       <spring:bind path="addressForm.address.street">
    					                   <tr>
    					                      <td class="label"><fmt:message key="jsp.general.address.street" /></td>
    					                      <td>
    					                          <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
    					                      </td>
    					                    </tr>
    					                    <tr>
    					                      <td colspan="2"><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
    					                    </tr>
                                        </spring:bind>
					                    <tr>
					                      <td class="label"><fmt:message key="jsp.general.address.numberextension" /></td>
					                      <td>
                                            <spring:bind path="addressForm.address.number">
					                           	<input type="text" id="${status.expression}" name="${status.expression}" size="3" value="<c:out value="${status.value}" />" />
                                                <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                            </spring:bind>
				                      		<spring:bind path="addressForm.address.numberExtension">
				                          		&nbsp;&nbsp;<input type="text" name="${status.expression}" size="10" value="<c:out value="${status.value}" />" />
                                                <c:set var="numberExtensionErrors">${status.errorMessages}</c:set>
                                                <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach>
                                            </spring:bind>
                                          </td>
					                      </tr>
					                      <tr>
                                            <td colspan="2">
                                            </td>
					                    </tr>
                                      <spring:bind path="addressForm.address.zipCode">
					                    <tr>
					                      <td class="label"><fmt:message key="jsp.general.address.zipcode" /></td>
					                      <td>
					                          <input type="text" name="${status.expression}" size="15" maxlength="15" value="<c:out value="${status.value}" />" />
					                      </td>
					                      </tr>
					                      <tr>
					                      <td colspan="2"><fmt:message key="jsp.message.format.zipcode" />
					                      <br /><a href="http://www.geopostcodes.com/" target="_blank"><fmt:message key="jsp.general.address.zipcode.url" /></a>&nbsp;
                                          <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
					                    </tr>
                                      </spring:bind>
					                </table>
					             </td>
					             <td>
					             <table>
                                      <spring:bind path="addressForm.address.POBox">
					                    <tr>
					                      <td class="label"><fmt:message key="jsp.general.or" /> <fmt:message key="jsp.general.address.POBox" /></td>
					                      <td>
					                          <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
					                      </td>
					                     </tr>
					                     <tr>
					                      <td colspan="2">
					                      <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
					                    </tr>
                                      </spring:bind>
					                </table>
					              </td>
					            </tr>
					            <tr><td colspan="3">&nbsp;</td></tr>
			                    <tr>
			                      <td class="label"><fmt:message key="jsp.general.telephone" /></td>
			                      <spring:bind path="addressForm.address.telephone">
			                      <td>
			                          <input type="text" name="${status.expression}" size="20" maxlength="15" value="<c:out value="${status.value}" />" />
			                      </td>
			                      <td><fmt:message key="jsp.message.format.telephone" />&nbsp;
			                      <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
			                      </spring:bind>
			                    </tr>
			                    <tr>
			                      	<td class="label"><fmt:message key="jsp.general.mobile" /></td>
			                      	<spring:bind path="addressForm.address.mobilePhone">
		                      		<c:choose>
					        			<c:when test="${initParam. iMobilePhoneRequired && address.addressTypeCode != '4' 
					        					&& address.addressTypeCode != '5'}">
					             			<td class="required">
					             		</c:when>
					             		<c:otherwise>
					             			<td>
					             		</c:otherwise>
					             	</c:choose>
		                          	<input type="text" name="${status.expression}" size="20" maxlength="15" value="<c:out value="${status.value}" />" />
		                      		</td>
			                      <td><fmt:message key="jsp.message.format.mobilephone" />&nbsp;
			                      <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
			                      </spring:bind>
			                    </tr>
			                    <tr>
			                      <td class="label"><fmt:message key="jsp.general.fax" /></td>
			                      <spring:bind path="addressForm.address.faxNumber">
			                      <td>
			                          <input type="text" name="${status.expression}" size="20" maxlength="15" value="<c:out value="${status.value}" />" />
			                      </td>
			                      <td><fmt:message key="jsp.message.format.telephone" />&nbsp;
			                         <c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
			                      </spring:bind>
			                    </tr>
			                    <tr>
			                      <td class="label"><fmt:message key="jsp.general.email" /></td>
			                      <spring:bind path="addressForm.address.emailAddress">
		                      		<c:choose>
					        			<c:when test="${initParam.iEmailAddressRequired && address.addressTypeCode != '4' 
					        					&& address.addressTypeCode != '5'}">
					             			<td class="required">
					             		</c:when>
					             		<c:otherwise>
					             			<td>
					             		</c:otherwise>
					             	</c:choose>
			                          <input type="text" name="${status.expression}" size="40" value="<c:out value="${status.value}" />" />
			                      </td>
			                      <td><c:forEach var="error" items="${status.errorMessages}"><span class="error">${error}</span></c:forEach></td>
			                      </spring:bind>
			                    </tr>
			                    <tr><td class="label">&nbsp;</td>
			                    <td>
			                    <input type="button" name="submitformdata" value="<fmt:message key="jsp.button.submit" />" onclick="updateEmptyNumber('address.number','0');document.getElementById('submitFormObject').value='true';document.formdata.submit();" />
			                    </td></tr>
							</table>
			            </form>
			            
							</div> <!-- AccordionPanelContent -->
						</div>  <!-- AccordionPanel -->
                	</div>   <!-- Accordion1 -->                 
					<script type="text/javascript">
	      		  		var Accordion0 = new Spry.Widget.Accordion("Accordion0",
	                            {defaultPanel: 0,
	                            useFixedPanelHeights: false,
	                            nextPanelKeyCode: 78 /* n key */,
	                            previousPanelKeyCode: 80 /* p key */
	                           });
	                
	  				</script>
				</div> <!-- Accordion0, is: TabbedPanelsContent -->                     
            </div>
        </div>
    </div>
    <script type="text/javascript">
        var tp1 = new Spry.Widget.TabbedPanels("tp1");
        tp1.showPanel(${navigationSettings.tab});
        
    </script>
</div>

<%@ include file="../../footer.jsp"%>

