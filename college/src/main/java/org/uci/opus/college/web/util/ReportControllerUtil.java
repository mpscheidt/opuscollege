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

package org.uci.opus.college.web.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.context.MessageSource;
import org.uci.opus.college.domain.ReportProperty;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExpression;
import net.sf.jasperreports.engine.JRParameter;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.util.JRLoader;

/**
 * @author Stelio Macumbe - 16 September , 2008 This class has useful methods
 *         for *ReportControllers. The methods in this class are just a
 *         compilation of code that was highly repeated in most (if not every)
 *         controller within the report module
 */
public class ReportControllerUtil {

    // not to be instantiated
    private ReportControllerUtil() {
    }

    /**
     * Builds a parameter map with usual required parameters , institutionId ,
     * branchId , primaryStudyId , etc.
     * 
     * @param institutionId
     * @param branchId
     * @param organizationalUnitId
     * @param primaryStudyId
     * @param studyGradeTypeId
     * @param studyYearId
     * @param academicYearId
     * @param registrationYear
     * @param additionalParams
     * @return map with parameters
     */
    public static Map<String, Object> makeParameterMap(int institutionId, int branchId,
            int organizationalUnitId, int primaryStudyId, int studyGradeTypeId,
            //int studyYearId, 
            int academicYearId, String registrationYear,
            Map<String, Object> additionalParams) {

        Map<String, Object> parameterMap = new HashMap<String, Object>();
        if (institutionId != 0) {
            parameterMap.put("institutionId", institutionId);
        }
        if (branchId != 0) {
            parameterMap.put("branchId", branchId);
        }
        if (organizationalUnitId != 0) {
            parameterMap.put("organizationalUnitId", organizationalUnitId);
        }
        if (primaryStudyId != 0) {
            parameterMap.put("studyId", primaryStudyId);
        }
        if (studyGradeTypeId != 0) {
            parameterMap.put("studyGradeTypeId", studyGradeTypeId);
        }
        //  if (studyYearId != 0)
        //      parameterMap.put("studyYearId", studyYearId);
        if (academicYearId != 0) {
            parameterMap.put("academicYearId", academicYearId);
        }
        if ((!registrationYear.equals("0"))
                && (!registrationYear.equalsIgnoreCase("all"))) {
            parameterMap.put("registrationYear", registrationYear.trim());
        }

        if (additionalParams != null) {
            parameterMap.putAll(additionalParams);
        }

        return parameterMap;
    }

    public static Map<String, Object> loadAndMakeParameterMap() {
        Map<String, Object> parameterMap = new HashMap<String, Object>();

        return parameterMap;
    }
    
    public static HashMap<String, Object> loadAndMakeParameterMap(StudentFilterBuilder fb , 
            HttpServletRequest request , 
            HttpSession session ,
            Map additionalFindParams) {
        HashMap<String, Object> parameterMap;

        fb.initChosenValues(true);      // this remembers all filter selections in the session
        fb.doLookups();
        fb.loadStudies(additionalFindParams);        
        fb.loadStudyGradeTypes(additionalFindParams, true);
        fb.loadSubjectBlocks(additionalFindParams);
        
        int institutionId = fb.getInstitutionId();
        int  branchId = fb.getBranchId();
        int organizationalUnitId = fb.getOrganizationalUnitId();
        int primaryStudyId = fb.getPrimaryStudyId();
        int academicYearId = fb.getAcademicYearId();
        int studyGradeTypeId = fb.getStudyGradeTypeId();
        int subjectBlockId = fb.getSubjectBlockId();

        fb.loadInstitutionBranchOrgUnit();        
        
        String gradeTypeCode = ServletUtil.getStringValue(session, request, "gradeTypeCode");
        String progressStatusCode = ServletUtil.getStringValue(session, request, "progressStatusCode");
        String studyPlanStatusCode = ServletUtil.getStringValue(session, request, "studyPlanStatusCode");
        String genderCode = ServletUtil.getStringValue(session, request, "genderCode");
        
        int cardinalTimeUnitNumber = ServletUtil.getIntParam(request, "cardinalTimeUnitNumber", 0);
        
        //request.setAttribute("allAcademicYears", academicYearManager.findAllAcademicYears());
        
        academicYearId = ServletUtil.getParamSetAttrAsInt(request, "academicYearId", 0);

        parameterMap = makeParameterMap(institutionId, branchId, organizationalUnitId, primaryStudyId, studyGradeTypeId, academicYearId, subjectBlockId);
        //registration years and academic years are loaded according the values of institution , branch ...

        //some queries use language and some use preferredLanguage
        parameterMap.put("lang", OpusMethods.getPreferredLanguage(request));
        parameterMap.put("preferredLanguage", OpusMethods.getPreferredLanguage(request));
        parameterMap.put("institutionTypeCode", OpusMethods.getInstitutionTypeCode(request));

        if(cardinalTimeUnitNumber != 0)
        	parameterMap.put("cardinalTimeUnitNumber", cardinalTimeUnitNumber);
        
        if (!StringUtil.isNullOrEmpty(gradeTypeCode, true) && !"0".equals(gradeTypeCode)) {
            parameterMap.put("gradeTypeCode", gradeTypeCode);
            request.setAttribute("gradeTypeCode", gradeTypeCode);
            session.setAttribute("gradeTypeCode", gradeTypeCode);
        }
        
        if (!StringUtil.isNullOrEmpty(progressStatusCode, true) && !"0".equals(progressStatusCode)) {
            parameterMap.put("progressStatusCode", progressStatusCode);
            request.setAttribute("progressStatusCode", progressStatusCode);            
        }
        
        if (!StringUtil.isNullOrEmpty(studyPlanStatusCode, true) && !"0".equals(studyPlanStatusCode)) {
            parameterMap.put("studyPlanStatusCode", studyPlanStatusCode);
            request.setAttribute("studyPlanStatusCode", studyPlanStatusCode);            
        }
        
        if (!StringUtil.isNullOrEmpty(genderCode, true) && !"0".equals(genderCode)) {
            parameterMap.put("genderCode", genderCode);
            request.setAttribute("genderCode", genderCode);            
        }

        if ((additionalFindParams != null) && (!additionalFindParams.isEmpty())) {
            parameterMap.putAll(additionalFindParams);
        }

        return parameterMap;
    }
    
    public static HashMap<String, Object> makeParameterMap(int institutionId , int branchId , int organizationalUnitId ,
            int primaryStudyId , int studyGradeTypeId ,
            int academicYearId , int subjectBlockId) {

        HashMap<String, Object> parameterMap = new HashMap<String, Object>(); 
        if (institutionId != 0) {
            parameterMap.put("institutionId" , institutionId);
        }
        if (branchId != 0) {
            parameterMap.put("branchId" , branchId);
        }
        if (organizationalUnitId != 0) {
            parameterMap.put("organizationalUnitId" , organizationalUnitId);
        }
        if (primaryStudyId != 0) {
            parameterMap.put("studyId" , primaryStudyId);
        }
        if (studyGradeTypeId != 0) {
            parameterMap.put("studyGradeTypeId" , studyGradeTypeId);
        }
        if (academicYearId != 0) {
            parameterMap.put("academicYearId", academicYearId);
        }
        if (subjectBlockId != 0) {
            parameterMap.put("subjectBlockId", subjectBlockId);
        }

        return parameterMap;
    }


    /**
     * Generates and order by label, to be used with the most common order by
     * select.
     * 
     * @param orderBy
     * @return orderBy label
     */
    public static String generateOrderByLabel(String orderBy) {
        Map<String, String> map = new HashMap<String, String>();

        map.put("person_surnamefull", "Alphabetically on surname");
        map.put("gender_description , person_surnamefull", "Gender");
        map.put("province_description , person_surnamefull",
        "Province of origin");
        map.put("province_description , gender_description,person_surnamefull",
        "Province and gender");
        /**
         * //choose what label to put in "order by" field of the report
         * if(orderBy.equalsIgnoreCase("person_surnamefull")){ orderBy =
         * "Alphabetically on surname"; } else if(orderBy.equalsIgnoreCase(
         * "gender_description , person_surnamefull")){ orderBy = "Gender"; }
         * else if(orderBy.equalsIgnoreCase(
         * "province_description , person_surnamefull")){ orderBy =
         * "Province of origin"; } else if(orderBy.equalsIgnoreCase(
         * "province_description , gender_description,person_surnamefull")){
         * orderBy = "Province and gender"; }
         **/
        return generateOrderByLabel(map, orderBy);
    }

    /**
     * Generates and order by label for report , this methods allows custom
     * labels and sql fields The keys in the map are the fields specified in a
     * sql order clause e.g name - name , surname -etc The values in the map are
     * the labels that should be displayed in the report for a specific sql
     * field or set of sql fields e.g. map.put("surnameFull , Surname");
     * ServletUtil.generateOrderByLabel(map , "surnameFull"); Will return the
     * label "Surname" if the chosen order by field is surnameFull
     * 
     * @param map
     *            map - sql order field - report label pair value
     * @param input
     *            - sql order field to be searched for
     * @return outputLabel - label that will be returned according the selected
     *         input field
     */
    public static String generateOrderByLabel(Map<String, String> map,
            String input) {

        String outputLabel = null;
        for (Iterator it = map.entrySet().iterator(); it.hasNext();) {
            Map.Entry entry = (Map.Entry) it.next();
            String inputLabel = (String) entry.getKey();

            if (input.equals(inputLabel)) {
                outputLabel = (String) entry.getValue();
                break;
            }
        }

        return outputLabel;
    }

    /**
     * Checks if the uploaded image is supported.
     * 
     * @param fileType
     * @return
     */
    public static boolean isValidImage(ServletContext context, String fileType) {

        String imagetypes = context.getInitParameter("image_mime");
        String[] imagetypeslist = imagetypes.split(",");
        boolean isImage = false;

        /* see if mimetype is ok */
        for (int i = 0; i < imagetypeslist.length; i++) {
            String onetype = imagetypeslist[i].trim();
            if (onetype != null && onetype.equals(fileType)) {
                isImage = true;
                break;
            }
        }
        return isImage;
    }

    /**
     * Checks is the upload document is supported.
     * 
     * @param fileType
     * @return
     */
    public static boolean isValidDocument(ServletContext context,
            String fileType) {

        String doctypes = context.getInitParameter("doc_mime");
        String[] doctypeslist = doctypes.split(",");
        boolean isDoc = false;

        /* see if mimetype is ok */
        for (int i = 0; i < doctypeslist.length; i++) {
            String onetype = doctypeslist[i].trim();
            if (onetype != null && onetype.equals(fileType)) {
                isDoc = true;
                break;
            }
        }

        return isDoc;
    }
    
 public static String getDownloadFileName(HttpServletRequest request, String def){
    
	 String downloadFileName =
		 ServletUtil.getParamSetAttrAsString(request, "downloadFileName", def);
    
     //spaces cause the name to be incomplete
     downloadFileName = downloadFileName.replaceAll("\\s+", "_")
     	.replaceAll("/", "-");

    	return downloadFileName;
    }
 
 public static List<ReportProperty> getReportPropertiesFromFile(String reportPath, String reportName, MessageSource messageSource, Locale currentLocale) throws JRException {
	 
	 List<ReportProperty> properties = new ArrayList<>();
	 
		JasperReport report = (JasperReport) JRLoader
				.loadObjectFromFile(reportPath);

		JRParameter[] parameters = report.getParameters();
		

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
									currentLocale);
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

					ReportProperty property = new ReportProperty();
					
					property.setId(0);
					property.setReportName(reportName);
					property.setName(parameter.getName());
					property.setType(parameterType);
					property.setVisible(true);
					property.setText(defaultValue);
					
					properties.add(property);

				}
			}
		}

	 
	 return properties;
 
 }
		
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
		private static String getLabelForType(String type) {

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
		private static boolean isUserParameter(String name) {
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
