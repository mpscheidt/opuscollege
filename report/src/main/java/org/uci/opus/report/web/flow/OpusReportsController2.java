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
import javax.servlet.http.HttpSession;
import javax.swing.ImageIcon;

import org.springframework.beans.factory.annotation.Autowired;
import org.uci.opus.college.domain.ReportProperty;
import org.uci.opus.college.persistence.ReportPropertyMapper;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
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
 * @author Stelio Macumbe Template controller for report controllers the methods and fields in this class should be present in every report
 *         controller
 *
 */
public abstract class OpusReportsController2 {

    private String viewName;
  
    @Autowired
    private SecurityChecker securityChecker;
    
    @Autowired
    private OpusMethods opusMethods;
    
    @Autowired
    private StudyManagerInterface studyManager;
    
    @Autowired
    private LookupCacher lookupCacher;
    
    @Autowired
    private StudentManagerInterface studentManager;
    
    @Autowired
    private AcademicYearManagerInterface academicYearManager;
    
    @Autowired
    protected ReportPropertyMapper reportPropertyMapper;

    @Autowired
    protected ReportController reportController;

    @Autowired
    private OrganizationalUnitManagerInterface organizationalUnitManager;
    
    private int institutionId;
    private int branchId;
    private int organizationalUnitId;
    private int primaryStudyId;
    private int studyGradeTypeId;
    private int studyYearId;
    private int registrationYear;
    private int academicYearId;
    private int subjectBlockId;

    /**
     * Builds a parameter map with usual required parameters , institutionId , branchId , primaryStudyId , etc. Ignores parameters which
     * value is zero
     * 
     * @return map with parameters
     */
    public static Map<String, Object> makeParameterMap(int institutionId, int branchId, List<Integer> organizationalUnitIds, int primaryStudyId,
            int studyGradeTypeId, int academicYearId, int subjectBlockId) {

        Map<String, Object> parameterMap = new HashMap<>();
        if (institutionId != 0) {
            parameterMap.put("institutionId", institutionId);
        }
        if (branchId != 0) {
            parameterMap.put("branchId", branchId);
        }
        if (organizationalUnitIds != null && !organizationalUnitIds.isEmpty()) {
            parameterMap.put("organizationalUnitIds", organizationalUnitIds);
        }
        if (primaryStudyId != 0) {
            parameterMap.put("studyId", primaryStudyId);
        }
        if (studyGradeTypeId != 0) {
            parameterMap.put("studyGradeTypeId", studyGradeTypeId);
        }
        if (academicYearId != 0) {
            parameterMap.put("academicYearId", academicYearId);
        }
        if (subjectBlockId != 0) {
            parameterMap.put("subjectBlockId", subjectBlockId);
        }

        return parameterMap;
    }

    public Map<String, Object> loadAndMakeParameterMap(StudentFilterBuilder fb, HttpServletRequest request, HttpSession session,
            Map<String, Object> additionalFindParams) {

        Map<String, Object> parameterMap;

        fb.initChosenValues(true); // this remembers all filter selections in the session
        fb.doLookups();
        fb.loadStudies(additionalFindParams);
        fb.loadStudyGradeTypes(additionalFindParams, true);
        fb.loadSubjectBlocks(additionalFindParams);

        institutionId = fb.getInstitutionId();
        branchId = fb.getBranchId();
        organizationalUnitId = fb.getOrganizationalUnitId();
        primaryStudyId = fb.getPrimaryStudyId();
        academicYearId = fb.getAcademicYearId();
        studyGradeTypeId = fb.getStudyGradeTypeId();
        subjectBlockId = fb.getSubjectBlockId();

        fb.loadInstitutionBranchOrgUnit();

        String gradeTypeCode = ServletUtil.getStringValue(session, request, "gradeTypeCode");
        String progressStatusCode = ServletUtil.getStringValue(session, request, "progressStatusCode");
        String studyPlanStatusCode = ServletUtil.getStringValue(session, request, "studyPlanStatusCode");
        String genderCode = ServletUtil.getStringValue(session, request, "genderCode");

        int cardinalTimeUnitNumber = ServletUtil.getIntParam(request, "cardinalTimeUnitNumber", 0);

        request.setAttribute("allAcademicYears", academicYearManager.findAllAcademicYears());

        academicYearId = ServletUtil.getParamSetAttrAsInt(request, "academicYearId", 0);
        
        // performance: pre-fetch tree of organizationalUnitIds to avoid crawl-tree "thousands of times", ie. once per student
        List<Integer> organizationalUnitIds = null;
        if (organizationalUnitId != 0) {
            organizationalUnitIds = organizationalUnitManager.findTreeOfOrganizationalUnitIds(organizationalUnitId);
        }

        parameterMap = makeParameterMap(institutionId, branchId, organizationalUnitIds, primaryStudyId, studyGradeTypeId, academicYearId,
                subjectBlockId);
        // registration years and academic years are loaded according the values of institution , branch ...

        // some queries use language and some use preferredLanguage
        parameterMap.put("lang", OpusMethods.getPreferredLanguage(request));
        parameterMap.put("preferredLanguage", OpusMethods.getPreferredLanguage(request));
        parameterMap.put("institutionTypeCode", OpusMethods.getInstitutionTypeCode(request));

        if (cardinalTimeUnitNumber != 0)
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

    /**
     * Gets custom properties logos , images , text, etc from the database for the specified report.
     * 
     * @param reportName
     *            - The report for loading properties. The search for the report is case insensitive
     * @return
     * @throws JRException
     */
    protected Map<String, Object> getUserProperties(String reportName) throws JRException {

        Map<String, Object> map = new HashMap<>();

        List<ReportProperty> properties = reportPropertyMapper.findPropertiesForReport(reportName);

        for (Iterator<ReportProperty> iterator = properties.iterator(); iterator.hasNext();) {
            ReportProperty property = (ReportProperty) iterator.next();
            String propertyName = property.getName();

            // if it is a file property
            if (!property.getType().equalsIgnoreCase("text")) {

                if (property.isVisible()) {
                    if ((property.getFile().length == 0)) {
                        // reportController.putModelParameter(mav, "reportLogo", new ImageIcon().getImage());
                        map.put(propertyName, new ImageIcon().getImage());
                    } else {

                        // choose a different renderer for SVG images
                        if ("image/svg+xml".equals(property.getType())) {
                            map.put(propertyName, BatikRenderer.getInstance(property.getFile()));
                        } else {
                            map.put(propertyName, JRImageRenderer.getInstance(property.getFile()));
                        }
                    }
                } else {
                    map.put(propertyName, new ImageIcon().getImage());
                }

                // if it is text property
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
