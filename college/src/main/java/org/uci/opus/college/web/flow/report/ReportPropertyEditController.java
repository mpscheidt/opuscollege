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

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;

import javax.imageio.stream.FileImageInputStream;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.support.ByteArrayMultipartFileEditor;
import org.uci.opus.college.domain.ReportProperty;
import org.uci.opus.college.persistence.ReportPropertyMapper;
import org.uci.opus.college.validator.ReportPropertyValidator;
import org.uci.opus.college.web.flow.ReportPropertyForm;
import org.uci.opus.college.web.util.ReportControllerUtil;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.ServletUtil;

/**
 * @author smacumbe Feb 11, 2009
 */
@Controller
@RequestMapping("/college/report/reportproperty")
@SessionAttributes({ ReportPropertyEditController.FORM_OBJECT })
public class ReportPropertyEditController {

    private static final String REPORT_PROPERTY = "reportProperty";
    public static final String FORM_OBJECT = "reportPropertyForm";
    private static final String FORM_VIEW = "admin/reportproperty";

    private static Logger log = LoggerFactory.getLogger(ReportPropertyEditController.class);

    private ReportPropertyValidator validator = new ReportPropertyValidator();

    @Autowired
    private OpusMethods opusMethods;

    @Autowired
    private ReportPropertyMapper reportPropertyMapper;

    @Autowired
    ServletContext servletContext;

    public ReportPropertyEditController() {
    }

    @InitBinder
    public void initBinder(ServletRequestDataBinder binder) {

        binder.registerCustomEditor(byte[].class, new ByteArrayMultipartFileEditor());
    }

    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model) {

        ReportPropertyForm reportPropertyForm = new ReportPropertyForm();
        model.put(FORM_OBJECT, reportPropertyForm);

        reportPropertyForm.setNavigationSettings(opusMethods.createAndFillNavigationSettings(request));

        String propertyName = request.getParameter("propertyName");
        String propertyType = request.getParameter("propertyType");
        // if property is an image or file the text will the path to the image
        String propertyText = request.getParameter("propertyText");

//        ServletUtil.getParamSetAttrAsInt(request, "currentPageNumber", 1);
//        ServletUtil.getParamSetAttrAsString(request, "institutionTypeCode", OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION);

        String reportName = ServletUtil.getParamSetAttrAsString(request, "reportName", "");
        reportPropertyForm.setReportPath(request.getParameter("reportPath"));

        int propertyId = ServletUtil.getIntParam(request, "propertyId", 0);
        ReportProperty property;

        if (propertyId != 0) {
            property = reportPropertyMapper.findOne(propertyId);
        } else {
            property = new ReportProperty();
            property.setId(propertyId);
            property.setReportName(reportName);
            property.setName(propertyName);
            property.setText(propertyText);
            property.setType(propertyType);
            property.setVisible(true);
        }
        reportPropertyForm.setReportProperty(property);

        return FORM_VIEW;
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(HttpServletRequest request, @ModelAttribute(FORM_OBJECT) ReportPropertyForm reportPropertyForm, BindingResult result) throws IOException {

        ReportProperty property = reportPropertyForm.getReportProperty();
        
        result.pushNestedPath(REPORT_PROPERTY);
        validator.validate(property, result);
        result.popNestedPath();

        if (result.hasErrors()) {
            return FORM_VIEW;
        }

        // property id is set on this controller formBackingObject method
        int propertyId = property.getId();
        byte[] file = property.getFile();

//        MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
//        CommonsMultipartFile commonsfile = (CommonsMultipartFile) multipartRequest.getFile("file");
        MultipartFile multipartFile = reportPropertyForm.getMultipartFile();

        String type = null;
        if (multipartFile != null) {
            type = multipartFile.getContentType();
        }

        boolean isValidImage = ReportControllerUtil.isValidImage(servletContext, type);

        // tests if there is already a property with this name for the report
        // ReportProperty testProperty = reportManager.findPropertyByName(property.getName(),
        // property.getReportName());
        // property type is only known after file type is determined
        // or after verification that text has been specified
        // property.setType("unknown");

        // if property is of type text then no file is needed
        // else no text is needed
        if (property.getType().equals("text")) {
            property.setFile(null);
        } else {
            property.setText(null);
        }

        // checks if the user has uploaded for a file
        // if not leave the current file for this property intact
        if (((file == null) || (file.length == 0)) && (propertyId != 0)) {
            // when file is set to null means that the actually file
            // will not be replaced
            property.setFile(null);

            // if the user is editing a a property with default values and
            // does not upload a file
        } else if (((file == null) || (file.length == 0)) && (propertyId == 0) && !property.getType().equals("text")) {
            // the parameter "imgPath" contains the name of the image in the images/report folder
            String imgName = request.getParameter("imgPath");
            String extension = imgName.substring(imgName.lastIndexOf(".") + 1);

            file = getFileSystemImage(imgName);
            type = "image/" + extension;

            property.setFile(file);
            property.setType(type);

            isValidImage = true;
        }

        // if there is a file being uploaded
        if (((file != null) && (file.length != 0))) {
            if (isValidImage) {
                property.setType(type);
                property.setFile(multipartFile.getBytes());
                // if is not a valid image or document
            } else {
                // TODO this validation should be moved to the validator
                result.pushNestedPath(REPORT_PROPERTY);
                result.rejectValue("name", "jsp.report.error.invalidfile");
                result.popNestedPath();
            }
        }

        if (result.hasErrors()) {
            return FORM_VIEW;
        }

        int currentPageNumber = reportPropertyForm.getNavigationSettings().getCurrentPageNumber();

        // if there is no error then go to the normal view
        String view;
        // if (StringUtil.isNullOrEmpty(showError, true)) {
        String reportPath = reportPropertyForm.getReportPath();
        view = "redirect:/college/report/reportproperties.view?reportName=" + property.getReportName() + "&reportPath=" + reportPath + "&currentPageNumber=" + currentPageNumber;

        // add new property
        if (propertyId == 0) {
            log.info("adding " + property);
            reportPropertyMapper.add(property);
            // update property
        } else {
            log.info("updating " + property);
            reportPropertyMapper.update(property);
        }
        //
        // } else {
        //
        // view = "redirect:/college/report/reportproperty.view?reportName=" +
        // property.getReportName() + "&reportPath=" + reportPath + "&propertyId=" + propertyId
        // + "&institutionTypeCode=" + institutionTypeCode + "&currentPageNumber=" +
        // currentPageNumber + "&propertyName=" + property.getName();
        // }

        return view;

    }

    /**
     * Fetches image from images/report folder and convert it to an array of byte so it can be put
     * in the database.
     * 
     * @param imgName
     * @return
     * @throws IOException
     */
    private byte[] getFileSystemImage(String imgName) throws IOException {

        String imageDir = servletContext.getRealPath("/images/report");

        byte[] buffer = new byte[1024];

        imgName = imageDir + System.getProperty("file.separator") + imgName;

        FileImageInputStream inputStream = new FileImageInputStream(new File(imgName));
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        while (inputStream.read(buffer) != -1) {
            out.write(buffer);
        }

        inputStream.close();

        return out.toByteArray();
    }

}
