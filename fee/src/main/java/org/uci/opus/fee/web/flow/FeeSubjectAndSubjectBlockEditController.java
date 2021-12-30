/*******************************************************************************
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
 * The Original Code is Opus-College fee module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen.
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
 ******************************************************************************/
package org.uci.opus.fee.web.flow;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.domain.SubjectBlock;
import org.uci.opus.college.domain.SubjectBlockStudyGradeType;
import org.uci.opus.college.domain.SubjectStudyGradeType;
import org.uci.opus.college.persistence.SubjectBlockMapper;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.service.SubjectManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.fee.config.FeeConstants;
import org.uci.opus.fee.domain.Fee;
import org.uci.opus.fee.service.FeeManagerInterface;
import org.uci.opus.fee.validators.FeeSubjectAndSubjectBlockValidator;
import org.uci.opus.fee.web.form.FeeSubjectAndSubjectBlockForm;
import org.uci.opus.util.OpusMethods;
import org.uci.opus.util.SecurityChecker;
import org.uci.opus.util.ServletUtil;


@Controller
@SessionAttributes({"feeSubjectAndSubjectBlockForm"})
public class FeeSubjectAndSubjectBlockEditController  {

    private static Logger log = LoggerFactory.getLogger(FeeSubjectAndSubjectBlockEditController.class);

    private String formView = "fee/fee/feeSubjectAndSubjectBlock";
    
    @Autowired private SecurityChecker securityChecker;    
    @Autowired private FeeManagerInterface feeManager;
    @Autowired private StudyManagerInterface studyManager;
    @Autowired private SubjectManagerInterface subjectManager;
    @Autowired private OpusMethods opusMethods;
    @Autowired private LookupManagerInterface lookupManager;
    @Autowired private AcademicYearManagerInterface academicYearManager;

    @Autowired
    private SubjectBlockMapper subjectBlockMapper;

    /**
     * Adds a property editor for dates to the binder.
     */
    @InitBinder
    protected void initBinder(HttpServletRequest request, ServletRequestDataBinder binder)
    throws Exception {
        /* custom date editor */
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);
        binder.registerCustomEditor(Date.class, null, new CustomDateEditor(df, true));
    }

    @RequestMapping(value="/fee/feeSubjectAndSubjectBlock.view", method=RequestMethod.GET)
    public String setUpForm(ModelMap model, HttpServletRequest request) 
            throws Exception {
    
    	FeeSubjectAndSubjectBlockForm feeSubjectAndSubjectBlockForm = null;
         
         NavigationSettings navigationSettings = null;
         
         HttpSession session = request.getSession(false);
         
         /* perform session-check. If wrong, this throws an Exception towards ErrorController */
         securityChecker.checkSessionValid(session);
         
         // if adding a new feeSubjectAndSubjectBlockForm, destroy any existing one on the session
         opusMethods.removeSessionFormObject("feeSubjectAndSubjectBlockForm", session, opusMethods.isNewForm(request));

         /* set menu to fee */
         session.setAttribute("menuChoice", "fee");

         int branchId = ServletUtil.getIntValueSetOnSession(session, request, "branchId", OpusMethods.getBranchId(session, request));
         int feeId = ServletRequestUtils.getIntParameter(request, "feeId", 0); 
         int institutionId = 0;
         int organizationalUnitId = 0;
         int studyId = ServletRequestUtils.getIntParameter(request, "studyId", 0);;
         
         String preferredLanguage = OpusMethods.getPreferredLanguage(request);
         String institutionTypeCode = OpusMethods.getInstitutionTypeCode(request);

         Subject subject = null;
         SubjectBlock subjectBlock = null;
         SubjectStudyGradeType subjectStudyGradeType = null;
         SubjectBlockStudyGradeType subjectBlockStudyGradeType = null;
         
         Fee fee = null;
         
         // retrieve LISTS OF INSTITUTIONS, BRANCHES AND ORGANIZATIONAL UNITS to fill pulldowns
         opusMethods.getInstitutionBranchOrganizationalUnitSelect(
                 session, request, institutionTypeCode, institutionId
                 , branchId, organizationalUnitId);

         
         /* FeeSubjectAndSubjectBlockForm - fetch or create the form object and fill it with secondarySchool */
         if ((FeeSubjectAndSubjectBlockForm) session.getAttribute("feeSubjectAndSubjectBlockForm") != null) {
             feeSubjectAndSubjectBlockForm = (FeeSubjectAndSubjectBlockForm) session.getAttribute("feeSubjectAndSubjectBlockForm");
         } else {
             feeSubjectAndSubjectBlockForm = new FeeSubjectAndSubjectBlockForm();
         }

         if(feeId != 0) {
        	 
        	 fee = feeManager.findFee(feeId);

        	 Map<String, Object> findDeadlinesMap = new HashMap<>();
        	 findDeadlinesMap.put("feeId", feeId);
        	 findDeadlinesMap.put("lang", preferredLanguage);
        	 
        	 feeSubjectAndSubjectBlockForm.setFeeDeadlines(feeManager.findFeeDeadlinesAsMaps(findDeadlinesMap));
        	 
         } else {
        	 
        	   fee = new Fee();
               fee.setActive("Y");
               fee.setFeeDue(BigDecimal.valueOf(0.00));
         }

         if (fee.getSubjectBlockStudyGradeTypeId() != 0) {
             subjectBlockStudyGradeType = subjectBlockMapper.findSubjectBlockStudyGradeType(fee.getSubjectBlockStudyGradeTypeId(), preferredLanguage);
             subjectBlock = subjectBlockMapper.findSubjectBlock(subjectBlockStudyGradeType.getSubjectBlock().getId());
         }

         feeSubjectAndSubjectBlockForm.setSubjectBlock(subjectBlock);

         if (fee.getSubjectStudyGradeTypeId() != 0) {
             subjectStudyGradeType = subjectManager.findSubjectStudyGradeType(preferredLanguage,fee.getSubjectStudyGradeTypeId());
             subject = subjectManager.findSubject(subjectStudyGradeType.getSubject().getId());
         }

         feeSubjectAndSubjectBlockForm.setSubject(subject);
         
         
         feeSubjectAndSubjectBlockForm.setStudy(studyManager.findStudy(studyId));
         
         feeSubjectAndSubjectBlockForm.setFee(fee);
         feeSubjectAndSubjectBlockForm.setFeeCategories(lookupManager.findAllRows(preferredLanguage, "fee_feecategory"));
         feeSubjectAndSubjectBlockForm.setAllAcademicYears(academicYearManager.findAllAcademicYears());
         feeSubjectAndSubjectBlockForm.setAllStudyForms(lookupManager.findAllRows(preferredLanguage, "studyForm"));
         feeSubjectAndSubjectBlockForm.setAllStudyTimes(lookupManager.findAllRows(preferredLanguage, "studyTime"));

         
         Map<String, Object> findSubjectBlockStudyGradeTypesMap = new HashMap<>();
         
         findSubjectBlockStudyGradeTypesMap.put("institutionId", institutionId);
         findSubjectBlockStudyGradeTypesMap.put("branchId", branchId);
         findSubjectBlockStudyGradeTypesMap.put("organizationalUnitId", organizationalUnitId);
     
         findSubjectBlockStudyGradeTypesMap.put("studyId", studyId);
         findSubjectBlockStudyGradeTypesMap.put("gradeTypeCode", null);
         findSubjectBlockStudyGradeTypesMap.put("institutionTypeCode", institutionTypeCode);
         findSubjectBlockStudyGradeTypesMap.put("active", "");
         
         feeSubjectAndSubjectBlockForm.setAllSubjectBlockStudyGradeTypesWithoutFees(feeManager.findSubjectBlockStudyGradeTypesWithoutFee(findSubjectBlockStudyGradeTypesMap));
         feeSubjectAndSubjectBlockForm.setAllSubjectBlockStudyGradeTypes(subjectBlockMapper.findSubjectBlockStudyGradeTypes2(findSubjectBlockStudyGradeTypesMap));

         
         Map<String, Object> findSubjectStudyGradeTypesMap = new HashMap<>();
         findSubjectStudyGradeTypesMap.put("institutionId", institutionId);
         findSubjectStudyGradeTypesMap.put("branchId", branchId);
         findSubjectStudyGradeTypesMap.put("organizationalUnitId", organizationalUnitId);
       
         findSubjectStudyGradeTypesMap.put("studyId", studyId);
         findSubjectStudyGradeTypesMap.put("institutionTypeCode", institutionTypeCode);
         findSubjectStudyGradeTypesMap.put("preferredLanguage", preferredLanguage);
         
         feeSubjectAndSubjectBlockForm.setAllSubjectStudyGradeTypesWithoutFees(feeManager.findSubjectStudyGradeTypesWithoutFee(findSubjectStudyGradeTypesMap));
         feeSubjectAndSubjectBlockForm.setAllSubjectStudyGradeTypes(subjectManager.findSubjectStudyGradeTypes2(findSubjectStudyGradeTypesMap));

         feeSubjectAndSubjectBlockForm.setAllAcademicYears(academicYearManager.findAllAcademicYears());
         
         /* FeeSubjectAndSubjectBlockForm.NAVIGATIONSETTINGS - fetch or create the object */
         if (feeSubjectAndSubjectBlockForm.getNavigationSettings() != null) {
        	 
         	navigationSettings = feeSubjectAndSubjectBlockForm.getNavigationSettings();
         	
         } else {
        	 
         	navigationSettings = new NavigationSettings();
            opusMethods.fillNavigationSettings(request, navigationSettings, null);
         }
         
         feeSubjectAndSubjectBlockForm.setNavigationSettings(navigationSettings);
         
         model.addAttribute("currentDate", new Date());
         model.addAttribute("feeSubjectAndSubjectBlockForm", feeSubjectAndSubjectBlockForm);        

    	
    	return formView;   	
    }
    
    
    @RequestMapping(value="/fee/feeSubjectAndSubjectBlock.view", method=RequestMethod.POST)
	public String processSubmit(
			@ModelAttribute("feeSubjectAndSubjectBlockForm") FeeSubjectAndSubjectBlockForm feeSubjectAndSubjectBlockForm,
			BindingResult result, SessionStatus status,
			HttpServletRequest request) {

		HttpSession session = request.getSession();
        securityChecker.checkSessionValid(session);
		
		Fee fee = feeSubjectAndSubjectBlockForm.getFee();

		
		result.pushNestedPath("fee");

		new FeeSubjectAndSubjectBlockValidator().validate(fee, result);

		result.popNestedPath();

		if (result.hasErrors()) {

			return formView;

		} else {
		
			fee.setWriteWho(opusMethods.getWriteWho(request));
			fee.setFeeUnitCode(FeeConstants.FEE_UNIT_NONE);

			if (fee.getId() == 0) {
				feeManager.addFee(fee);
			} else {
				feeManager.updateFee(fee);
			}
			
			status.setComplete();
		}

		/*
		return "redirect:/fee/feesstudy.view?tab=" + navigationSettings.getTab()
		+ "&panel="+ navigationSettings.getPanel()
		+ "&currentPageNumber=" +  navigationSettings.getCurrentPageNumber()
		+ "&studyId=" + feeSubjectAndSubjectBlockForm.getStudy().getId();*/
		
		return formView;
	}

    @RequestMapping(value="/fee/feeSubjectAndSubjectBlockDeadline_delete.view", method=RequestMethod.GET)
    public String deleteFeeDeadline(@RequestParam("feeDeadlineId") int feeDeadlineId
            , @RequestParam("feeId") int feeId
            , @RequestParam("studyId") int studyId
            , ModelMap model, HttpServletRequest request){

        HttpSession session = request.getSession(false);        

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

        FeeSubjectAndSubjectBlockForm feeSubjectAndSubjectBlockForm = (FeeSubjectAndSubjectBlockForm) session.getAttribute("feeSubjectAndSubjectBlockForm");

        NavigationSettings navigationSettings = feeSubjectAndSubjectBlockForm.getNavigationSettings();

        feeManager.deleteFeeDeadline(feeDeadlineId, opusMethods.getWriteWho(request));

        return "redirect:/fee/feeStudyGradeType.view?newForm=true" 
        + "&feeId=" + feeId 
        + "&studyId=" + studyId
        + "&currentPageNumber="	+ navigationSettings.getCurrentPageNumber()
        + "&tab=1"
        + "&panel=0"
        ;

    }

}
