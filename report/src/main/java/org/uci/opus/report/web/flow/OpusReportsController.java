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

package org.uci.opus.report.web.flow;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.swing.ImageIcon;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.ReportProperty;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.persistence.ReportPropertyMapper;
import org.uci.opus.college.service.StudentManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.util.ReportController;
import org.uci.opus.college.web.util.StudentFilterBuilder;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRImageRenderer;
import net.sf.jasperreports.renderers.BatikRenderer;

/**
 * @author Stelio Macumbe 
 * Template controller for report controllers the methods and fields
 * in this class should be present in every report controller
 *
 */
public abstract class OpusReportsController extends AbstractController {

    private String viewName;
    @Autowired private SecurityChecker securityChecker;
    @Autowired private OpusMethods opusMethods;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private LookupCacher lookupCacher;
    @Autowired private StudentManagerInterface studentManager;
    @Autowired protected ReportPropertyMapper reportPropertyMapper;
    @Autowired protected ReportController reportController;

    private int institutionId;
    private int branchId;
    private int organizationalUnitId;
    private int primaryStudyId;
    private int studyGradeTypeId;
    private int studyYearId;
    private int registrationYear;
    private int academicYearId;
    private int subjectBlockId;
//    private Map parametersMap;

    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest arg0,
            HttpServletResponse arg1) throws Exception {
        return null;
    }

//    private void loadCommnonValues(HttpServletRequest request , HttpSession session) {
//
//        ServletUtil.getParamSetAttrAsString(request, "reportFormat", "pdf");
//
//    }

    /**
     * Builds a parameter map with usual required parameters , institutionId , branchId , primaryStudyId , etc. 
     * Ignores parameters which value is zero
     * @return map with parameters
     */
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

    public HashMap<String, Object> loadAndMakeParameterMap(StudentFilterBuilder fb , 
            HttpServletRequest request , 
            HttpSession session ,
            Map<String, Object> additionalFindParams) {
        HashMap<String, Object> parameterMap;

        fb.initChosenValues(true);      // this remembers all filter selections in the session
        fb.doLookups();
        fb.loadStudies(additionalFindParams);
        fb.loadAcademicYears();
        fb.loadStudyGradeTypes(additionalFindParams, true);
        fb.loadSubjectBlocks(additionalFindParams);

        institutionId = fb.getInstitutionId();
        branchId = fb.getBranchId();
        organizationalUnitId = fb.getOrganizationalUnitId();
        primaryStudyId = fb.getPrimaryStudyId();
        academicYearId = fb.getAcademicYearId();
        studyGradeTypeId = fb.getStudyGradeTypeId();
        subjectBlockId = fb.getSubjectBlockId();
//        studyYearId = fb.getStudyYearId();
//        academicYear = ServletUtil.getParamSetAttrAsString(request,
//                "academicYear", "0");
//        int academicYearId = ServletUtil.getParamSetAttrAsInt(request,
//                "academicYearId", 0);
//        registrationYear = ServletUtil.getParamSetAttrAsInt(request,
//                "registrationYear", 0);

        fb.loadInstitutionBranchOrgUnit(); 

        String gradeTypeCode = ServletUtil.getStringValue(session, request, "gradeTypeCode");
        String progressStatusCode = ServletUtil.getStringValue(session, request, "progressStatusCode");
        int cardinalTimeUnitNumber = ServletUtil.getIntParam(request, "cardinalTimeUnitNumber", 0);


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

        if ((additionalFindParams != null) && (!additionalFindParams.isEmpty())) {
            parameterMap.putAll(additionalFindParams);
        }

        return parameterMap;
    }


    /**
     * Gets custom properties logos , images , text, etc from the database for the specified report. 
     * @param reportName - The report for loading properties.
     * The search for the report is case insensitive
     * @return
     * @throws JRException 
     */
    protected Map<String, Object> getUserProperties(String reportName) throws JRException {

        Map<String, Object> map = new HashMap<>();

        List<ReportProperty> properties = reportPropertyMapper.findPropertiesForReport(reportName);

        for (Iterator<ReportProperty> iterator = properties.iterator(); iterator.hasNext();) {
            ReportProperty property = iterator.next();
            String propertyName = property.getName();

            //if it is a file property
            if (!property.getType().equalsIgnoreCase("text")) {

                if (property.isVisible()) {
                    if ((property.getFile().length == 0)) {
                        //reportController.putModelParameter(mav, "reportLogo", new ImageIcon().getImage());
                        map.put(propertyName, new ImageIcon().getImage());
                    } else {

                        //choose a different renderer for SVG images
                        if ("image/svg+xml".equals(property.getType())) {
                            map.put(propertyName, BatikRenderer.getInstance(property.getFile()));
                        } else {
                            map.put(propertyName, JRImageRenderer.getInstance(property.getFile()));  
                        }
                    }
                } else {
                    map.put(propertyName, new ImageIcon().getImage());
                }

                //if it is text property
            } else {

                if (property.isVisible()) {
                    map.put(propertyName, property.getText());
                } else {
                    map.put(propertyName, "");
                }
            }
        }

        return map;
    }

    public List<?> loadSelectData(HttpServletRequest request,
            StudentFilterBuilder fb) {

        List<?> data = null;
        String select = request.getParameter("select");
//        String value = request.getParameter("value");

        fb.initChosenValues();
        fb.loadInstitutionBranchOrgUnit();

        if (select.equals("institutionId")) {
            data = (List<Branch>) request.getAttribute("allBranches");

        } else if (select.equals("branchId")) {

            data = (List<OrganizationalUnit>) request
            .getAttribute("allOrganizationalUnits");

        } else if (select.equals("organizationalUnitId")) {

            fb.loadStudies();
            data = (List<Study>) request.getAttribute("allStudies");

        } else if (select.equals("studyId") || select.equals("primaryStudyId")) {

            fb.loadAcademicYears();
            data = (List) request.getAttribute("allAcademicYears");

        } else if (select.equals("academicYearId")) {

            fb.loadStudyGradeTypes();
            data = (List<StudyGradeType>) request
            .getAttribute("allStudyGradeTypes");

        } else if (select.equals("studyGradeTypeId")) {
//            fb.loadStudyYears();
//            data = (List<StudyGradeType>) request.getAttribute("allStudyYears");
            fb.loadSubjectBlocks();
            data = (List<StudyGradeType>) request.getAttribute("allSubjectBlocks");
        }

        return data;

    }


//    public String toJSON(Object object) {
//        return new Gson().toJson(object);
//    }


//    public String toJSONList(List data) {
//
//        StringBuffer jsonList = new StringBuffer("[");
//        Gson gSon = new Gson();
//        for (Iterator it = data.iterator(); it.hasNext();) {
//            String json = gSon.toJson(it.next());
//            jsonList.append(json);
//            if (it.hasNext()) {
//                jsonList.append(",");
//            }
//        }
//
//        jsonList.append("]");
//        return jsonList.toString();
//    }


    /**
     * Builds a JSON object with additional information to the script which will
     * handle the AJAX response.
     * 
     * @param responseParameters
     * @return
     */
//    public String buildJSONResponse(Map responseParameters , List items) {
//
//        StringBuffer responseObject = new StringBuffer("");
//        StringBuffer jsonResponse = new StringBuffer("{");
//        Gson gson = new Gson();
//
//        if ((responseParameters != null) && (!responseParameters.isEmpty())) {
//            for (Iterator<Map.Entry> it = responseParameters.entrySet().iterator(); it.hasNext();) {
//                Map.Entry entry = it.next();
//
//                jsonResponse.append("\"" + entry.getKey() + "\"" + " : " + "\""
//                        + gson.toJson(entry.getValue()) + "\"");
//
//                if (it.hasNext()) {
//                    jsonResponse.append(",");
//                }
//            }
//        }
//        jsonResponse.append("}");
//
//        responseObject.append("({");
//        responseObject.append("parameters:").append(jsonResponse);
//        responseObject.append(",");
//
//        if ((items != null) && (!items.isEmpty())) {
//            responseObject.append("items:").append(toJSONList(items));
//        } else {
//            responseObject.append("items:").append("[]");
//        }
//
//        responseObject.append("})");
//
//
//        return responseObject.toString();
//    }

    public String getViewName() {
        return viewName;
    }

    public void setViewName(String viewName) {
        this.viewName = viewName;
    }

    public SecurityChecker getSecurityChecker() {
        return securityChecker;
    }

    public void setSecurityChecker(SecurityChecker securityChecker) {
        this.securityChecker = securityChecker;
    }

    public OpusMethods getOpusMethods() {
        return opusMethods;
    }

    public void setOpusMethods(OpusMethods opusMethods) {
        this.opusMethods = opusMethods;
    }

    public StudyManagerInterface getStudyManager() {
        return studyManager;
    }

    public void setStudyManager(StudyManagerInterface studyManager) {
        this.studyManager = studyManager;
    }

    public LookupCacher getLookupCacher() {
        return lookupCacher;
    }

    public void setLookupCacher(LookupCacher lookupCacher) {
        this.lookupCacher = lookupCacher;
    }

    public StudentManagerInterface getStudentManager() {
        return studentManager;
    }

    public void setStudentManager(StudentManagerInterface studentManager) {
        this.studentManager = studentManager;
    }

    public int getInstitutionId() {
        return institutionId;
    }

    public void setInstitutionId(int institutionId) {
        this.institutionId = institutionId;
    }

    public int getBranchId() {
        return branchId;
    }

    public void setBranchId(int branchId) {
        this.branchId = branchId;
    }

    public int getOrganizationalUnitId() {
        return organizationalUnitId;
    }

    public void setOrganizationalUnitId(int organizationalUnitId) {
        this.organizationalUnitId = organizationalUnitId;
    }

    public int getPrimaryStudyId() {
        return primaryStudyId;
    }

    public void setPrimaryStudyId(int primaryStudyId) {
        this.primaryStudyId = primaryStudyId;
    }

    public int getStudyGradeTypeId() {
        return studyGradeTypeId;
    }

    public void setStudyGradeTypeId(int studyGradeTypeId) {
        this.studyGradeTypeId = studyGradeTypeId;
    }

    public int getStudyYearId() {
        return studyYearId;
    }

    public void setStudyYearId(int studyYearId) {
        this.studyYearId = studyYearId;
    }

    public int getRegistrationYear() {
        return registrationYear;
    }

    public void setRegistrationYear(int registrationYear) {
        this.registrationYear = registrationYear;
    }

}
