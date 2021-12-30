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
 * The Original Code is Opus-College college module code.
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
*/

package org.uci.opus.college.web.flow;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.persistence.InstitutionMapper;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.validator.InstitutionValidator;
import org.uci.opus.college.web.form.org.InstitutionForm;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.ServletUtil;
import org.uci.opus.util.StringUtil;

@Controller
@RequestMapping("/college/institution")
@SessionAttributes({ InstitutionEditController.FORM_OBJECT })
public class InstitutionEditController {

    public static final String FORM_OBJECT = "institutionForm";
    private static final String FORM_VIEW = "college/organization/institution";

    private static Logger log = LoggerFactory.getLogger(InstitutionEditController.class);

    private InstitutionValidator validator = new InstitutionValidator();

    @Autowired
    private LookupCacher lookupCacher;

    @Autowired
    private InstitutionManagerInterface institutionManager;

    @Autowired
    private InstitutionMapper institutionMapper;

    public InstitutionEditController() {
        super();
    }

    /**
     * Creates a form backing object. If the request parameter "id" (of the organizationalUnit) is
     * set, the specified institution is read. Otherwise a new one is created.
     */
    @RequestMapping(method = RequestMethod.GET)
    public String setupForm(HttpServletRequest request, ModelMap model, Locale locale) {

        InstitutionForm form = new InstitutionForm();
        model.put(FORM_OBJECT, form);
        
        // declare variables
        String institutionTypeCode = request.getParameter("institutionTypeCode");

        /* get preferred Language from request or else session and save it in the request */
        String preferredLanguage = locale.getLanguage();

        // get the institutionId if it exists
        int institutionId = ServletUtil.getIntParam(request, "institutionId", 0);
        
        // GET THE INSTITUTION OR CREATE A NEW ONE

        Institution institution;
        
        if (institutionId != 0) {
            // EXISTING INSTITUTION

            institution = institutionManager.findInstitution(institutionId);

        } else {
            // NEW INSTITUTION
            
            institution = new Institution();
            institution.setInstitutionTypeCode(institutionTypeCode);
            institution.setActive("Y");

            /* generate institutionCode */
            Double tmpDouble = Math.random();
            Integer tmpInteger = tmpDouble.intValue();
            String strRandomCode = tmpInteger.toString();
            String institutionCode = StringUtil.createUniqueCode("I", strRandomCode);
            institution.setInstitutionCode(institutionCode);

        }
        form.setInstitution(institution);

        // lookups
        form.setAllCountries(lookupCacher.getAllCountries(preferredLanguage));
        fillAllProvinces(form, preferredLanguage);
        form.setAllInstitutionTypes(lookupCacher.getAllInstitutionTypes(preferredLanguage));
        form.setInstitutionTypeCode(institutionTypeCode);
        
        int currentPageNumber = ServletUtil.getIntParam(request, "currentPageNumber", 0);
        form.setCurrentPageNumber(currentPageNumber);

        return FORM_VIEW;
    }

    @RequestMapping(method=RequestMethod.POST, params="submitter=institution.countryCode")
    public String countryOfBirthChanged(@ModelAttribute(FORM_OBJECT) InstitutionForm form, Locale locale) {

        fillAllProvinces(form, locale.getLanguage());
        return FORM_VIEW;
    }

    private void fillAllProvinces(InstitutionForm form, String language) {
        String countryCode = form.getInstitution().getCountryCode();
        form.setAllProvinces(lookupCacher.getAllProvinces(countryCode, language));
    }

    @RequestMapping(method = RequestMethod.POST)
    public String processSubmit(@ModelAttribute(FORM_OBJECT) InstitutionForm form, BindingResult result) {

        Institution institution = form.getInstitution();

        result.pushNestedPath("institution");
        validator.validate(institution, result);
        result.popNestedPath();
        
        if (result.hasErrors()) {
            return FORM_VIEW;
        }

        /* test if the combination already exists */
        if (institutionMapper.existsDuplicate(institution.getInstitutionCode(), institution.getId()) != null) {
            result.rejectValue("institution.institutionCode", "jsp.error.general.alreadyexists");
            return FORM_VIEW;
        }
        
        // if empty, create unique institutionCode
        if (StringUtil.isNullOrEmpty(institution.getInstitutionCode(), true)) {
            Double tmpDouble = Math.random();
            Integer tmpInteger = tmpDouble.intValue();
            String strRandomCode = tmpInteger.toString();
            String institutionCode = StringUtil.createUniqueCode("I", strRandomCode);
            institution.setInstitutionCode(institutionCode);
        }

        if (institution.getId() == 0) {
            // NEW institution
            log.info("adding " + institution);
            institutionManager.addInstitution(institution);
        } else {
            
            // UPDATE institution
            log.info("updating " + institution);
            institutionManager.updateInstitution(institution);
        }

        return "redirect:/college/institutions.view?newForm=true&institutionTypeCode=" + institution.getInstitutionTypeCode()
                 + "&currentPageNumber=" + form.getCurrentPageNumber();
    }

}
