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

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://jawr.net/tags" prefix="jwr" %>

<!-- isELIgnored="false" -->
<%--
 * Copyright (c) 2007 Universitair Centrum Informatievoorziening Radboud University Nijmegen.
--%>

<%
ServletContext context = this.getServletContext();
//String initLang = context.getInitParameter("javax.servlet.jsp.jstl.fmt.fallbackLocale"); 
String initLocale = "pt";
%>

<fmt:setLocale value="<%= initLocale %>" />

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>opus</title>
    <!-- javascript includes changed to jawr-bundle: 
    <link rel="STYLESHEET" href="<c:url value='/css/login.css' />" type="text/css" />
    -->
    <jwr:style src="/styles/login.css" />   
    <jwr:style src="/styles/login1024.css" /> 
</head>

<body>

<div id="page">

    <div id="HeaderLogin">&nbsp;
        <p id="Language">
            | <a href="#"><fmt:message key="jsp.general.message.help" /></a>
            |
        </p>
    </div>

    <div id="LoginContent">

    	<div id="login">
            <img src="<c:url value='/images/logo_b.gif' />" alt="OPUS College" align="left" hspace="10" />
         	<p><a href="<c:url value='/college/start.view'/>"><fmt:message key="jsp.login.error.tryagain" /></a></p>
		</div>
		
    </div>

    <div id="footer">
        <a class="white" href="http://www.opuscollege.net" target="_blank"><fmt:message key="jsp.footer.poweredby" /> <fmt:message key="jsp.footer.ru" /> &amp; <fmt:message key="jsp.footer.mec" />
            <br />&amp; <fmt:message key="jsp.footer.ucm" /> &amp; <fmt:message key="jsp.footer.cbu" /> &amp; <fmt:message key="jsp.footer.unza" />
        </a>
    </div>

</div>


</body>
</html>
