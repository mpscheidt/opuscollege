/*
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version 
 * 1.1 (the "License"); you may not use this file except in compliance with 
 * the License. You may obtain a copy of the License at 
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College report module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen
 * and Universidade Catolica de Mocambique.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 *   For Java files, see Javadoc @author tags.
 * 
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * 
 * ***** END LICENSE BLOCK *****
 */

package org.uci.opus.college.web.flow.report;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.ReportProperty;
import org.uci.opus.college.persistence.ReportPropertyMapper;
import org.uci.opus.config.OpusConstants;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExpression;
import net.sf.jasperreports.engine.JRParameter;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.util.JRLoader;

/**
 * @author smacumbe Feb 10, 2009
 */
@Controller
@RequestMapping(value = "/college/report/reportproperties.view")
public class ReportPropertiesController {

	private static Logger log = LoggerFactory.getLogger(ReportPropertiesController.class);

	@Autowired private SecurityChecker securityChecker;
	@Autowired private ReportPropertyMapper reportPropertyMapper;
	@Autowired private MessageSource messageSource;

	private String viewName;

	/**
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public ReportPropertiesController() {
		super();
		this.viewName = "admin/reportproperties";
	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws JRException {

		// declare variables
		HttpSession session = request.getSession(false);

		/*
		 * perform session-check. If wrong, this throws an Exception towards
		 * ErrorController
		 */
		securityChecker.checkSessionValid(session);

		/* set menu to admin */
		session.setAttribute("menuChoice", "admin");		
		
		ServletUtil.getParamSetAttrAsInt(request, "currentPageNumber", 1);
		ServletUtil.getParamSetAttrAsString(request, "institutionTypeCode",
				OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION);
		String searchValue = ServletUtil.getParamSetAttrAsString(request,
				"searchValue", "");
		
		String reportName = ServletUtil.getParamSetAttrAsString(request, "reportName", "");
		String reportPath = ServletUtil.getParamSetAttrAsString(request, "reportPath", "");
        ServletUtil.getParamSetAttrAsString(request, "titleKey", "jsp.general.report");
		

		String reportDir = session.getServletContext().getRealPath(
				"/WEB-INF/reports/jasper/");

		JasperReport report = (JasperReport) JRLoader
				.loadObjectFromFile(reportDir + System.getProperty("file.separator") +
						reportPath + reportName + ".jasper");

		JRParameter[] parameters = report.getParameters();
		List<ReportProperty> allProperties = reportPropertyMapper.findPropertiesByName(reportName, searchValue);
		List<ReportProperty> properties = new ArrayList<ReportProperty>();

		Locale currentLoc = RequestContextUtils.getLocale(request);

		for (JRParameter parameter : parameters) {

			if (!parameter.isSystemDefined()) {
				if (isUserParameter(parameter.getName())) {

					JRExpression expression = parameter
							.getDefaultValueExpression();
					String expressionStr = null;
					String parameterType = null;
					String defaultValue = null;

					parameterType = getLabelForType(parameter
							.getValueClassName());
					
					if (expression != null) {
						// gets this parameter default value expression in a
						// String (not as a string)
						expressionStr = expression.getText();
					

						if ("text".equalsIgnoreCase(parameterType)) {
							// removes the $R{} from a text property
							// as this is not present in the messages file

							//if expression is a i18n string take its key
							// so the value can be displayed to the user
							if(expressionStr.startsWith("$R{")){
							String key = expressionStr.substring(3,
									expressionStr.length() - 1);
							defaultValue = messageSource.getMessage(key, null,
									currentLoc);
							}

						} else if ("image".equalsIgnoreCase(parameterType)) {

							/*
							 * Generally reports images should have this format
							 * new javax.swing.ImageIcon($P{image_dir} +
							 * "/report-logo.gif").getImage()
							 * net.sf.jasperreports
							 * .engine.JRImageRenderer.getInstance($P{image_dir}
							 * + "/report-logo.gif") Following statement will
							 * extract the image name so defaultValue =
							 * "report-logo.gif"
							 */

							defaultValue = expressionStr.substring(
									expressionStr.indexOf('\"') + 2,
									expressionStr.lastIndexOf('\"'));

							String extension = defaultValue
									.substring(defaultValue.lastIndexOf(".") + 1);
							parameterType = parameterType + "/" + extension;
						}
					}

					properties.add(getProperty(parameter.getName(), reportName,
							parameterType, defaultValue, allProperties));

				}
			}
		}

		request.setAttribute("properties", properties);
		request.setAttribute("formaction", "formdata");

		return new ModelAndView(viewName);
	}

	/**
	 * Checks is a property exists in a database , if does return it, if does
	 * not returns a new property based in the correspondent parameter extracted
	 * from the report.
	 * 
	 * @param name
	 * @param reportName
	 * @param type
	 * @param defaultValue
	 * @param properties
	 * @return
	 */
	private ReportProperty getProperty(String name, String reportName,
			String type, String defaultValue, List<ReportProperty> properties) {
		ReportProperty property = null;
		for (Iterator<ReportProperty> iterator = properties.iterator(); iterator
				.hasNext();) {
			ReportProperty reportProperty = (ReportProperty) iterator.next();

			if (reportProperty.getName().equals(name)) {
				property = reportProperty;
				break;
			}
		}

		// if property is not set in the database than create one with default
		// values from the report file
		if (property == null) {
			property = new ReportProperty();
			property.setId(0);
			property.setReportName(reportName);
			property.setName(name);
			property.setType(type);
			property.setVisible(true);

			// property.setText(imgDir + System.getProperty("file.separator") +
			// defaultValue);
			// if property is a file then the text will the path to the file
			property.setText(defaultValue);
		}

		return property;
	}

	/**
	 * Gets a user frindley parameter type to display 
	 * @param type
	 * @return
	 */
	private String getLabelForType(String type) {

		String label = null;

		if ("java.lang.String".equals(type)) {
			label = "text";
		} else if ("java.awt.Image".equals(type)
				|| "net.sf.jasperreports.engine.JRRenderable".equals(type)) {
			label = "image";
		} else if ("java.io.File".equals(type)) {
			label = "file";
		} else if ("java.util.Date".equals(type)) {
			label = "date";
		}

		return label;
	}

	/**
	 * Checks if a parameter may be visible for the user.
	 * 
	 * @param name
	 * @return
	 */
	private boolean isUserParameter(String name) {
		boolean isUserParameter = false;
		String[] knownParameters = { "reportLogo",
				"studentCardBackgroundImage", "reportTitle" };

		for (String parameter : knownParameters) {
			if (parameter.equalsIgnoreCase(name)) {
				isUserParameter = true;
				break;
			}
		}

		// parameters prefixed with "report" are report parameters
		// this will be changed to user
		if (name.startsWith("report"))
			isUserParameter = true;

		return isUserParameter;
	}

}
