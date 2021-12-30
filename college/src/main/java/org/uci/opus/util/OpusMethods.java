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

package org.uci.opus.util;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.stream.Collectors;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.LocaleEditor;
import org.springframework.context.MessageSource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.MailParseException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.ui.ModelMap;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.uci.opus.college.domain.AppConfigAttribute;
import org.uci.opus.college.domain.AppVersion;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.domain.Lookup9;
import org.uci.opus.college.domain.OpusPrivilege;
import org.uci.opus.college.domain.OpusUser;
import org.uci.opus.college.domain.OrganizationAuthorization;
import org.uci.opus.college.domain.OrganizationalUnit;
import org.uci.opus.college.domain.SecondarySchoolSubject;
import org.uci.opus.college.domain.SecondarySchoolSubjectGroup;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.domain.Study;
import org.uci.opus.college.domain.StudyGradeType;
import org.uci.opus.college.domain.Subject;
import org.uci.opus.college.module.Module;
import org.uci.opus.college.net.OpusMailSender;
import org.uci.opus.college.service.AcademicYearManagerInterface;
import org.uci.opus.college.service.AppConfigManagerInterface;
import org.uci.opus.college.service.AppVersionAccessor;
import org.uci.opus.college.service.BranchManagerInterface;
import org.uci.opus.college.service.GeneralManagerInterface;
import org.uci.opus.college.service.InstitutionManagerInterface;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.OrganizationalUnitManagerInterface;
import org.uci.opus.college.service.StudyManagerInterface;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.college.web.form.Organization;
import org.uci.opus.college.web.form.StudySettings;
import org.uci.opus.config.OpusConstants;

/**
 * general methods.
 */
public class OpusMethods {

    private static final String READ_BRANCHES = OpusPrivilege.READ_BRANCHES;
    private static final String READ_INSTITUTIONS = OpusPrivilege.READ_INSTITUTIONS;
    private static final String READ_ORG_UNITS = OpusPrivilege.READ_ORG_UNITS;

    private static final String UPDATE_BRANCHES = OpusPrivilege.UPDATE_BRANCHES;
    private static final String UPDATE_INSTITUTIONS = OpusPrivilege.UPDATE_INSTITUTIONS;
    private static final String UPDATE_ORG_UNITS = OpusPrivilege.UPDATE_ORG_UNITS;

    private static Logger log = LoggerFactory.getLogger(OpusMethods.class);
    private StudyManagerInterface studyManager;
    private InstitutionManagerInterface institutionManager;

    @Autowired
    private AcademicYearManagerInterface academicYearManager;
    
    @Autowired
    BranchManagerInterface branchManager;
    
    private OrganizationalUnitManagerInterface organizationalUnitManager;
    private MessageSource messageSource;
    private LookupManagerInterface lookupManager;
    
    @Autowired
    private GeneralManagerInterface generalManager;
    
    @Autowired
    private AppConfigManagerInterface appConfigManager;
    
    @Autowired
    private SecurityChecker securityChecker;
    
    @Autowired
    private OpusInit opusInit;

    @Autowired
    private List<AppVersionAccessor> appVersionAccessors;

    public void setMessageSource(final MessageSource messageSource) {
        this.messageSource = messageSource;
    }

    /**
     * Gets the language that the user has selected. Note that this is the language part of the current locale only. E.g. Locale "en_ZM"
     * will be reduced to language "en".
     * 
     * @param request
     *            of the action
     * @return the language chosen by the user
     */
    public static String getPreferredLanguage(final HttpServletRequest request) {

        Locale locale = RequestContextUtils.getLocale(request);
        return locale.getLanguage();
    }

    /**
     * Get the default system-wide language. This is the first language in web.xml's appLanguages. On the language part is returned, not the
     * entire locale.
     * 
     * @return
     */
    public String getPreferredLanguage() {
        String locale = appConfigManager.getAppLanguages().get(0);
        int idx = locale.indexOf('_');
        String language = idx == -1 ? locale : locale.substring(0, idx);
        return language;
    }

    /**
     * Get the currently selected locale. Note that this includes country specific information. E.g. Locale "en_ZM" will retain the Zambia
     * country information.
     * 
     * @param request
     * @return
     */
    public static Locale getPreferredLocale(HttpServletRequest request) {
        return RequestContextUtils.getLocale(request);
    }

    public AppVersion getCoreModule() {
        return lookupManager.getCoreModule();
    }

    public List<AppVersion> getAppVersions() {

        List<AppVersion> appVersions = new ArrayList<>();
        for (AppVersionAccessor ava : this.appVersionAccessors) {
            try {
                appVersions.addAll(ava.getAppVersions());
            } catch (Exception e) {
                log.warn(
                        "Cannot read appVersions. This is fine only on first startup of a new module that hasn't yet created any tables (including the apversions table) and hence throws an error");
                if (log.isDebugEnabled()) {
                    log.debug("Cannot read appVersions", e);
                }
            }
        }
        return appVersions;
    }

    public List<AppConfigAttribute> getAppConfig() {

        List<AppConfigAttribute> appConfig = null;

        appConfig = appConfigManager.getAppConfig();

        return appConfig;
    }

    public static void setCurrentLocale(final HttpServletRequest request, final HttpServletResponse response, final String newLocale) {

        // the locale string needs to be parsed and split
        // into language, country and variation
        LocaleResolver localeResolver = RequestContextUtils.getLocaleResolver(request);
        LocaleEditor localeEditor = new LocaleEditor();
        localeEditor.setAsText(newLocale);
        localeResolver.setLocale(request, response, (Locale) localeEditor.getValue());
    }

    /*
     * find the institutionTypeCode; for now studies tec. are only registered for universities; if in the future this should change, it will
     * be easier to alter the code
     */
    public static String getInstitutionTypeCode(final HttpServletRequest request) {
        String institutionTypeCode = "";

        if (request.getParameter("institutionTypeCode") != null) {
            institutionTypeCode = request.getParameter("institutionTypeCode");
        } else {
            // for now it's always the university typeCode
            institutionTypeCode = OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION;
        }

        return institutionTypeCode;
    }

    /**
     * Gets languages on session
     * 
     * @param ignoreRegion
     *            when set to true regions are ignored causing different variation of the same language to be discarded e.g. en_zm,
     *            en_US,en_ZM will be considered "en" . pt_PT,pt_BR will be considered "pt"
     * @return
     */
    public List<String> getAppLanguages(boolean ignoreRegion) {

        List<String> languages = appConfigManager.getAppLanguages();

        if (ignoreRegion) {

            // NB: First steps in JAVA 8: Refactored to use stream and lambda

            // Map<String, Object> map = new HashMap<>();

            // ensure uniqueness (e.g. consider en_zm, en_us,pt_PT,pt_BR)
            // for(String lang : languages)
            // map.put(lang.split("_")[0], "");

            // languages = new ArrayList<>();
            // languages.addAll(map.keySet());

            // ensure uniqueness (e.g. consider en_zm, en_us,pt_PT,pt_BR)
            Set<String> s = languages.stream().map(lang -> lang.split("_")[0]).collect(Collectors.toSet());
            languages = new ArrayList<>(s);

        }

        return languages;

    }

    /**
     * Utility method that a) returns the institution type code via getInstitutionTypeCode(request), and b) sets it also as an attribute to
     * the request. These two steps are done frequently in many controllers.
     * 
     * @param request
     * @return education type code
     */
    public static String getInstitutionTypeCodeAndSetAttr(final HttpServletRequest request) {
        String institutionTypeCode = getInstitutionTypeCode(request);
        request.setAttribute("institutionTypeCode", institutionTypeCode);
        return institutionTypeCode;
    }

    public static int getInstitutionId(final HttpSession session, final HttpServletRequest request) {
        int institutionId = 0;

        if (request.getParameter("institutionId") != null) {
            institutionId = Integer.parseInt(request.getParameter("institutionId"));
        } else {
            if (request.getAttribute("institutionId") != null) {
                institutionId = Integer.parseInt((String) request.getAttribute("institutionId"));
            } else {
                if (session.getAttribute("institutionId") != null) {
                    institutionId = ((Integer) session.getAttribute("institutionId"));
                } else {
                    Institution institution = getInstitutionForLoggedInUser(session);
                    institutionId = institution.getId();
                }
            }
        }
        return institutionId;
    }

    /**
     * Utility method that a) returns the institutionId via getInstitutionId(session, request), and b) sets it also as an attribute to the
     * session. These two steps are done frequently in many controllers.
     * 
     * @param session
     * @param request
     * @return institutionId
     */
    public static int getInstitutionIdAndSetAttr(final HttpSession session, final HttpServletRequest request) {
        final int institutionId = getInstitutionId(session, request);
        session.setAttribute("institutionId", institutionId);
        return institutionId;
    }

    public static int getBranchId(final HttpSession session, final HttpServletRequest request) {
        int branchId = 0;

        if (StringUtils.isNotBlank(request.getParameter("branchId"))) {
            branchId = Integer.parseInt(request.getParameter("branchId"));
        } else {
            if (request.getAttribute("branchId") != null) {
                branchId = Integer.parseInt((String) request.getAttribute("branchId"));
            } else {
                if (session.getAttribute("branchId") != null) {
                    branchId = ((Integer) session.getAttribute("branchId"));
                } else {
                    Branch branch = (Branch) session.getAttribute("branch");
                    branchId = branch.getId();
                }
            }
        }
        return branchId;

    }

    /**
     * Utility method that a) returns the branchId via getBranchId(session, request), and b) sets it also as an attribute to the session.
     * These two steps are done frequently in many controllers.
     * 
     * @param session
     * @param request
     * @return branchId
     */
    public static int getBranchIdAndSetAttr(final HttpSession session, final HttpServletRequest request) {
        final int branchId = getBranchId(session, request);
        session.setAttribute("branchId", branchId);
        return branchId;
    }

    public static int getOrganizationalUnitId(final HttpSession session, final HttpServletRequest request, final OrganizationalUnit organizationalUnit) {
        int organizationalUnitId = 0;

        if (request.getParameter("organizationalUnitId") != null) {
            organizationalUnitId = Integer.parseInt(request.getParameter("organizationalUnitId"));
        } else {
            if (request.getAttribute("organizationalUnitId") != null) {
                organizationalUnitId = Integer.parseInt((String) request.getAttribute("organizationalUnitId"));
            } else {
                if (session.getAttribute("organizationalUnitId") != null) {
                    organizationalUnitId = ((Integer) session.getAttribute("organizationalUnitId"));
                } else {
                    organizationalUnitId = organizationalUnit.getId();
                }
            }
        }
        return organizationalUnitId;
    }

    public static int getOrganizationalUnitId2(final HttpSession session, final HttpServletRequest request) {
        int organizationalUnitId = 0;

        if (request.getParameter("organizationalUnitId") != null) {
            organizationalUnitId = Integer.parseInt(request.getParameter("organizationalUnitId"));
        } else {
            if (request.getAttribute("organizationalUnitId") != null) {
                organizationalUnitId = Integer.parseInt((String) request.getAttribute("organizationalUnitId"));
            } else {
                if (session.getAttribute("organizationalUnitId") != null) {
                    organizationalUnitId = ((Integer) session.getAttribute("organizationalUnitId"));
                }
            }
        }
        return organizationalUnitId;
    }

    public static int getOrganizationalUnitIdNew(final HttpSession session, final HttpServletRequest request) {
        int organizationalUnitId = 0;

        if (request.getParameter("organization.organizationalUnitId") != null) {
            organizationalUnitId = Integer.parseInt(request.getParameter("organization.organizationalUnitId"));
        } else {
            if (request.getAttribute("organization.organizationalUnitId") != null) {
                organizationalUnitId = Integer.parseInt((String) request.getAttribute("organization.organizationalUnitId"));
            } else {
                if (session.getAttribute("organizationalUnitId") != null) {
                    organizationalUnitId = ((Integer) session.getAttribute("organizationalUnitId"));
                }
            }
        }
        return organizationalUnitId;
    }

    /**
     * Utility method that a) returns the organizationalUnitId via getOrganizationalUnitId(session, request), and b) sets it also as an
     * attribute to the session. These two steps are done frequently in many controllers.
     * 
     * @param session
     * @param request
     * @return organizationalUnitId
     */
    public static int getOrganizationalUnitIdAndSetAttr(final HttpSession session, final HttpServletRequest request) {
        final int organizationalUnitId = getOrganizationalUnitId2(session, request);
        session.setAttribute("organizationalUnitId", organizationalUnitId);
        return organizationalUnitId;
    }

    public static int getStudyId(final HttpSession session, final HttpServletRequest request) {
        int studyId = 0;

        if (request.getParameter("studyId") != null) {
            studyId = Integer.parseInt(request.getParameter("studyId"));
        } else {
            if (request.getAttribute("studyId") != null) {
                studyId = Integer.parseInt((String) request.getAttribute("studyId"));
            } else {
                if (session.getAttribute("studyId") != null) {
                    studyId = ((Integer) session.getAttribute("studyId"));
                }
            }
        }

        return studyId;
    }

    public static int getStudyGradeTypeId(final HttpSession session, final HttpServletRequest request) {
        int studyGradeTypeId = 0;

        if (request.getParameter("studyGradeTypeId") != null) {
            studyGradeTypeId = Integer.parseInt(request.getParameter("studyGradeTypeId"));
        } else {
            if (request.getAttribute("studyGradeTypeId") != null) {
                studyGradeTypeId = Integer.parseInt((String) request.getAttribute("studyGradeTypeId"));
            } else {
                if (session.getAttribute("studyGradeTypeId") != null) {
                    studyGradeTypeId = ((Integer) session.getAttribute("studyGradeTypeId"));
                }
            }
        }

        return studyGradeTypeId;
    }

    public int getPrimaryStudyId(final HttpSession session, final HttpServletRequest request) {
        int primaryStudyId = 0;

        if (request.isUserInRole("student")) {
            OpusUser opusUser = this.getOpusUser();
            Student student = opusUser.getStudent();
            primaryStudyId = student.getPrimaryStudyId();
        } else {
            if (request.getParameter("primaryStudyId") != null) {
                primaryStudyId = Integer.parseInt(request.getParameter("primaryStudyId"));
            } else {
                if (request.getAttribute("primaryStudyId") != null) {
                    primaryStudyId = ((Integer) request.getAttribute("primaryStudyId"));
                } else {
                    if (session.getAttribute("primaryStudyId") != null) {
                        primaryStudyId = ((Integer) session.getAttribute("primaryStudyId"));
                    }
                }
            }
        }
        return primaryStudyId;
    }

    public List<? extends Study> getAllStudies(final HttpSession session, final HttpServletRequest request) {

        List<? extends Study> allStudies = null;
        int organizationalUnitId = 0;
        int branchId = 0;
        int institutionId = 0;
        OrganizationalUnit organizationalUnit = (OrganizationalUnit) session.getAttribute("organizationalUnit");

        organizationalUnitId = getOrganizationalUnitId(session, request, organizationalUnit);
        branchId = getBranchId(session, request);
        institutionId = getInstitutionId(session, request);

        if (request.isUserInRole("student")) {
            OpusUser opusUser = this.getOpusUser();
            Student student = opusUser.getStudent();
            Study study = studyManager.findStudy(student.getPrimaryStudyId());
            List<Study> list = new ArrayList<>();
            list.add(study);
            allStudies = (List<? extends Study>) list;
        } else {
            if (organizationalUnitId == 0) {
                if (branchId == 0) {
                    if (institutionId == 0) {
                        if (request.isUserInRole(READ_INSTITUTIONS) || request.isUserInRole(READ_BRANCHES)) {
                            allStudies = studyManager.findAllStudiesForUniversities();
                        } else {
                            OrganizationalUnit ou = (OrganizationalUnit) session.getAttribute("organizationalunit");
                            allStudies = studyManager.findAllStudiesForOrganizationalUnit(ou.getId());
                        }
                    } else {
                        allStudies = studyManager.findAllStudiesForInstitution(institutionId);

                    }
                } else {
                    allStudies = studyManager.findAllStudiesForBranch(branchId);
                }
            } else {
                allStudies = studyManager.findAllStudiesForOrganizationalUnit(organizationalUnitId);
            }
        }
        return allStudies;
    }

    public List<? extends StudyGradeType> getAllStudyGradeTypes(final HttpSession session, final HttpServletRequest request) {

        List<? extends StudyGradeType> allStudyGradeTypes = null;
        String preferredLanguage = (String) session.getAttribute("preferredLanguage");

        if (request.isUserInRole("student")) {
            OpusUser opusUser = this.getOpusUser();
            Student student = opusUser.getStudent();
            Map<String, Object> findGradeTypesForStudyMap = new HashMap<>();
            findGradeTypesForStudyMap.put("preferredLanguage", preferredLanguage);
            findGradeTypesForStudyMap.put("studyId", student.getPrimaryStudyId());
            allStudyGradeTypes = studyManager.findAllStudyGradeTypesForStudy(findGradeTypesForStudyMap);
        } else {
            allStudyGradeTypes = studyManager.findAllStudyGradeTypes();
        }
        return allStudyGradeTypes;
    }

    public static String getCountryCode(final HttpSession session, final HttpServletRequest request) {
        String countryCode = "0";

        if (request.getParameter("countryCode") != null) {
            countryCode = request.getParameter("countryCode");
        } else {
            if (request.getAttribute("countryCode") != null) {
                countryCode = (String) request.getAttribute("countryCode");
            } else {
                if (session.getAttribute("countryCode") != null) {
                    countryCode = (String) session.getAttribute("countryCode");
                }
            }
        }

        if (countryCode == null) {
            countryCode = "0";
        }
        return countryCode;

    }

    public static String getProvinceCode(final HttpSession session, final HttpServletRequest request) {
        String provinceCode = "0";

        if (request.getParameter("provinceCode") != null) {
            provinceCode = request.getParameter("provinceCode");
        } else {
            if (request.getAttribute("provinceCode") != null) {
                provinceCode = (String) request.getAttribute("provinceCode");
            } else {
                if (session.getAttribute("provinceCode") != null) {
                    provinceCode = (String) session.getAttribute("provinceCode");
                }
            }
        }

        if (provinceCode == null) {
            provinceCode = "0";
        }
        return provinceCode;

    }

    public static String getDistrictCode(final HttpSession session, final HttpServletRequest request) {
        String districtCode = "0";

        if (request.getParameter("districtCode") != null) {
            districtCode = request.getParameter("districtCode");
        } else {
            if (request.getAttribute("districtCode") != null) {
                districtCode = (String) request.getAttribute("districtCode");
            } else {
                if (session.getAttribute("districtCode") != null) {
                    districtCode = (String) session.getAttribute("districtCode");
                }
            }
        }

        if (districtCode == null) {
            districtCode = "0";
        }
        return districtCode;
    }

    public static String getAdministrativePostCode(final HttpSession session, final HttpServletRequest request) {
        String administrativePostCode = "0";

        if (request.getParameter("administrativePostCode") != null) {
            administrativePostCode = request.getParameter("administrativePostCode");
        } else {
            if (request.getAttribute("administrativePostCode") != null) {
                administrativePostCode = (String) request.getAttribute("administrativePostCode");
            } else {
                if (session.getAttribute("administrativePostCode") != null) {
                    administrativePostCode = (String) session.getAttribute("administrativePostCode");
                }
            }
        }
        if (administrativePostCode == null) {
            administrativePostCode = "0";
        }
        return administrativePostCode;

    }

    /**
     * Get academicYearId from request or session. If not found, the current academic year is returned.
     * 
     * @param request
     * @return
     */
    public int getAcademicYearId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Integer academicYearId = ServletUtil.getIntObject(session, request, "academicYearId");
        if (academicYearId == null) {
            // default: current academic year
            academicYearId = academicYearManager.getCurrentAcademicYear().getId();
        }
        return academicYearId;
    }

    public int getAcademicYearIdSetOnSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        int academicYearId = getAcademicYearId(request);
        session.setAttribute("academicYearId", academicYearId);
        return academicYearId;
    }

    public void setAcademicYearOnSession(HttpServletRequest request, Integer academicYearId) {
        HttpSession session = request.getSession(false);
        session.setAttribute("academicYearId", academicYearId);
    }

    /**
     * Shall not be used, since both html tags (<br/>
     * ) as well as username and password are coded into the string. This makes it impossible to properly html encode for safe output,
     * because html tags will be output as regular text instead.
     * 
     * @param currentLoc
     * @param opusUser
     * @param unencryptedPassword
     * @return
     */
    @Deprecated
    public String generatePWText(final Locale currentLoc, final OpusUser opusUser, final String unencryptedPassword) {

        // create text for text file
        String tmpPhrase = "";
        String endPhrases = "";

        // opening text
        tmpPhrase = messageSource.getMessage("pw.statictext.introduction", null, currentLoc);
        endPhrases = endPhrases + tmpPhrase;

        // username
        tmpPhrase = messageSource.getMessage("jsp.login.username", null, currentLoc) + ": " + opusUser.getUserName();
        endPhrases = endPhrases + "<BR /><BR />" + tmpPhrase;

        // password
        tmpPhrase = messageSource.getMessage("jsp.login.password", null, currentLoc) + ": " + unencryptedPassword;
        endPhrases = endPhrases + "<BR /><BR />" + tmpPhrase;

        // concluding text
        tmpPhrase = messageSource.getMessage("pw.statictext.conclusion", null, currentLoc);
        endPhrases = endPhrases + "<BR /><BR />" + tmpPhrase;

        return endPhrases;
    }

    public String generateAdmittedText(final Locale currentLoc, final OpusUser opusUser, String unencryptedPassword, int applicationNumber,
            HttpSession session) {

        // create text for text file
        String tmpPhrase = "";
        String endPhrases = "";

        // opening text
        tmpPhrase = messageSource.getMessage("registered.statictext.introduction", null, currentLoc);
        endPhrases = endPhrases + tmpPhrase;

        // username
        tmpPhrase = messageSource.getMessage("jsp.login.username", null, currentLoc) + ": " + opusUser.getUserName();
        endPhrases = endPhrases + "<BR /><BR />" + tmpPhrase;

        // password
        tmpPhrase = messageSource.getMessage("jsp.login.password", null, currentLoc) + ": " + unencryptedPassword;
        endPhrases = endPhrases + "<BR /><BR />" + tmpPhrase;

        // if applicationnumber is available, show too:
        if (applicationNumber != 0 && "Y".equals(opusInit.getApplicationNumber())) {
            tmpPhrase = messageSource.getMessage("registered.applicationnumber", null, currentLoc) + ": " + applicationNumber;
            endPhrases = endPhrases + "<BR /><BR />" + tmpPhrase;
        }

        // concluding text
        tmpPhrase = messageSource.getMessage("registered.statictext.conclusion", null, currentLoc);
        endPhrases = endPhrases + "<BR /><BR />" + tmpPhrase;

        return endPhrases;
    }

    /*
     * public HttpServletResponse openTextFile(HttpServletResponse response , final String endPhrases, final String fileName) { // without
     * reset() it doesn't work in IE response.reset(); response.setContentType("application/txt"); response.setHeader("Content-Disposition",
     * "attachment;filename=" + fileName); ServletOutputStream out = null;
     * 
     * try { out = response.getOutputStream(); // write the complete text out.print(endPhrases); out.close(); } catch (IOException e) {
     * e.printStackTrace(); }
     * 
     * return response;
     * 
     * }
     */

    /**
     * Gets institutionTypeCode, instituionId, branchId and organizationalUnitId from the organization object and calls
     * {@link #getInstitutionBranchOrganizationalUnitSelect(Organization, HttpSession, HttpServletRequest, String, int, int, int).
     * 
     * @param organization
     * @param request
     */
    public void getInstitutionBranchOrganizationalUnitSelect(Organization organization, HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        getInstitutionBranchOrganizationalUnitSelect(organization, session, request, organization.getInstitutionTypeCode(), organization.getInstitutionId(),
                organization.getBranchId(), organization.getOrganizationalUnitId());
    }

    /**
     * After calling {@link #getInstitutionBranchOrganizationalUnitSelect(HttpSession, HttpServletRequest, String, int, int, int)} the lists
     * are set into the provided organization object.
     * 
     * @param organization
     * @param session
     * @param request
     * @param institutionTypeCode
     * @param institutionId
     * @param branchId
     * @param organizationalUnitId
     */
    @SuppressWarnings("unchecked")
    public void getInstitutionBranchOrganizationalUnitSelect(Organization organization, final HttpSession session, HttpServletRequest request,
            String institutionTypeCode, final int institutionId, final int branchId, int organizationalUnitId) {

        getInstitutionBranchOrganizationalUnitSelect(session, request, institutionTypeCode, institutionId, branchId, organizationalUnitId);
        organization.setAllInstitutions((List<Institution>) request.getAttribute("allInstitutions"));
        organization.setAllBranches((List<Branch>) request.getAttribute("allBranches"));
        organization.setAllOrganizationalUnits((List<OrganizationalUnit>) request.getAttribute("allOrganizationalUnits"));
    }

    /**
     * This method retrieves 3 lists: a list of institutions, branches and orgnizationalUnits. Whenever the combination of pulldowns of
     * institution, branch and organizationalUnit is shown, they can be filled using this method (see
     * institutionBranchOrganizationalUnitSelect.jsp).
     * 
     * @param session
     *            of the user
     * @param request
     *            that is done
     * @param institutionTypeCode
     *            determines the type of education: university, other higher education or secondary school
     * @param institutionId
     *            if not 0, the branches of that institution are retrieved
     * @param branchId
     *            if not 0, the organizationalUnits of that branch are retrieved
     * @param organizationalUnitId
     *            if not 0, the organizationalUnit and its subunits are retrieved
     */
    public void getInstitutionBranchOrganizationalUnitSelect(final HttpSession session, HttpServletRequest request, String institutionTypeCode,
            final int institutionId, final int branchId, int organizationalUnitId) {

        /*
         * find a LIST OF INSTITUTIONS of the correct educationtype: set first the institutionTypeCode; for now studies, and therefore
         * subjects, are only registered for universities; if in the future this should change, it will be easier to alter the code
         */
        if (StringUtil.isNullOrEmpty(institutionTypeCode, true)) {
            institutionTypeCode = OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION;
        }
        request.setAttribute("institutionTypeCode", institutionTypeCode);

        // get the institutions of the correct educationType
        List<? extends Institution> allInstitutions = null;
        if (request.isUserInRole(READ_INSTITUTIONS)) {
            Map<String, Object> map = new HashMap<>();
            map.put("institutionTypeCode", institutionTypeCode);
            allInstitutions = institutionManager.findInstitutions(map);
        }
        request.setAttribute("allInstitutions", allInstitutions);
        // session.setAttribute("allInstitutions", allInstitutions);

        // LIST OF BRANCHES
        List<? extends Branch> allBranches = null;
        if (request.isUserInRole(READ_INSTITUTIONS) || request.isUserInRole(READ_BRANCHES)) {
            // allBranches = getAllBranches(institutionId);
            allBranches = branchManager.findBranches(institutionId);
        }
        request.setAttribute("allBranches", allBranches);
        // session.setAttribute("allBranches", allBranches);

        // LIST OF ORGANIZATIONALUNITS
        List<? extends OrganizationalUnit> allOrganizationalUnits = null;

        // admin, admin-C and admin-B: don't give the organizationalUnitId, otherwise
        // the list will be limited to that unit plus its underlying units.
        // TODO: admin-B for now is made equal to admin-D; needs to be changed.
        if (request.isUserInRole(READ_INSTITUTIONS) || request.isUserInRole(READ_BRANCHES) || request.isUserInRole(READ_ORG_UNITS)) {
            if (branchId != 0) {
                allOrganizationalUnits = organizationalUnitManager.findOrganizationalUnits(branchId);
            }
            // for admin-D; get the unit it is authorized for plus the underlying units
        } else if (request.isUserInRole("READ_PRIMARY_AND_CHILD_ORG_UNITS") || request.isUserInRole("teacher") || request.isUserInRole("student")) {
            OrganizationalUnit organizationalUnit = (OrganizationalUnit) session.getAttribute("organizationalUnit");
            organizationalUnitId = organizationalUnit.getId();

            Map<String, Object> findOrganizationalUnitsMap = new HashMap<>();
            findOrganizationalUnitsMap.put("institutionTypeCode", institutionTypeCode);
            findOrganizationalUnitsMap.put("institutionId", institutionId);
            findOrganizationalUnitsMap.put("branchId", branchId);
            findOrganizationalUnitsMap.put("organizationalUnitId", organizationalUnitId);
            allOrganizationalUnits = organizationalUnitManager.findOrganizationalUnits(findOrganizationalUnitsMap);

            // for teachers and students: get only the unit they are authorized for; they are not
            // allowed to change their unit.
        } else {
            OrganizationalUnit organizationalUnit = (OrganizationalUnit) session.getAttribute("organizationalUnit");
            /* teachers / students: only show logged in organizational unit */
            List<OrganizationalUnit> list = new ArrayList<>();
            list.add(organizationalUnit);
            allOrganizationalUnits = (List<? extends OrganizationalUnit>) list;

            request.setAttribute("allInstitutions", null);
            request.setAttribute("allBranches", null);
        }
        request.setAttribute("allOrganizationalUnits", allOrganizationalUnits);
    }

    /**
     * Load the branches that match the current organization.institutionId and set organiation.allBranches.
     * 
     * @param organization
     */
    public void loadBranches(Organization organization) {

        int institutionId = organization.getInstitutionId();
        if (institutionId == 0) {
            organization.clearBranches();
        } else {
            organization.setAllBranches(branchManager.findBranches(institutionId));
        }

        organization.clearOrganizationalUnits();

        // reset branchId and organizationalUnitId
        organization.setBranchId(0);
        organization.setOrganizationalUnitId(0);
    }

    /**
     * Load the organizational units that match the current organization.branchId and set organiation.allOrganizationalUnits.
     * 
     * @param organization
     */
    public void loadOrganizationalUnits(Organization organization) {
        int branchId = organization.getBranchId();
        if (branchId == 0) {
            organization.clearOrganizationalUnits();
        } else {
            organization.setAllOrganizationalUnits(organizationalUnitManager.findOrganizationalUnits(branchId));
        }

        // reset organizationalUnitId
        organization.setOrganizationalUnitId(0);
    }

    /**
     * Check if entering a new form. Used to decide whether or not an objectForm should be removed from the session. Is true when adding an
     * new object. This method is called in the StudyEditController.
     * 
     * @param request
     *            of the user
     * @return true or false
     */
    public boolean isNewForm(HttpServletRequest request) {
        boolean newForm = false;
        if (!StringUtil.isNullOrEmpty(request.getParameter("newForm")) && "true".equalsIgnoreCase(request.getParameter("newForm"))) {
            newForm = true;
        }
        return newForm;
    }

    /**
     * Using the @SessionAttributes(objectName) annotation, the given object is set on the session. After setting status.setComplete();, the
     * object is destroyed. However, when exiting a form without submitting, there is no way to check whether the object should be removed
     * from the session. Therefore whenever a menu item is clicked (so a new form is entered), all objects named domainObjectName"Form"
     * should be removed. So this method should be called in every controller. NOTE: in the editControllers, it is not possible to determine
     * whether it concerns a new objectForm or an existing one. This is solved by adding the parameter newForm=true to the "add" items in
     * the menu.
     * 
     * This method is deprecated. Use removeSessionFormObject(String, HttpSession, boolean) to remove specific session object. Removing all
     * session objects may have unintended side effects on other screens.
     * 
     * @param session
     *            of the user
     * @param newForm
     *            if true, destroy all objects with the name domainObjectName"Form"
     */
    @Deprecated
    public void removeSessionFormObjects(HttpSession session, final boolean newForm) {

        if (newForm) {
            // get the session attributes and loop through them, remove the ones with 'Form'
            Enumeration<String> e = session.getAttributeNames();
            while (e.hasMoreElements()) {
                String name = (String) e.nextElement();
                if (name.endsWith("Form")) {
                    session.removeAttribute(name);
                }
            }
        }
    }

    /**
     * Remove the form object with the given name
     * 
     * @param formObjectName
     * @param session
     * @param newForm
     * @deprecated use {@link #removeSessionFormObject(String, HttpSession, ModelMap, boolean)}
     */
    @Deprecated
    public void removeSessionFormObject(String formObjectName, HttpSession session, final boolean newForm) {

        removeSessionFormObject(formObjectName, session, null, newForm);
    }

    /**
     * Remove the form object with the given name from both session and modelMap (if modelMap not-null)
     * 
     * @param formObjectName
     * @param modelMap
     * @param session
     * @param newForm
     */
    public void removeSessionFormObject(String formObjectName, HttpSession session, ModelMap modelMap, final boolean newForm) {

        if (newForm) {
            session.removeAttribute(formObjectName);
            if (modelMap != null)
                modelMap.remove(formObjectName);
        }
    }

    /**
     * Fill given organization object with given values.
     * 
     * @param session
     * @param request
     * @param organization
     * @param organizationalUnitId
     * @param branchId
     * @param institutionId
     * @return
     */
    public Organization fillOrganization(HttpSession session, HttpServletRequest request, final Organization organization, final int organizationalUnitId,
            final int branchId, final int institutionId) {

        organization.setOrganizationalUnitId(organizationalUnitId);
        organization.setBranchId(branchId);
        organization.setInstitutionId(institutionId);
        organization.setInstitutionTypeCode(getInstitutionTypeCode(request));
        return organization;
    }

    /**
     * Fill given organization object with values from request or session.
     * 
     * @param session
     * @param request
     * @param organization
     */
    public void fillOrganization(HttpSession session, HttpServletRequest request, final Organization organization) {

        int institutionId = OpusMethods.getInstitutionId(session, request);
        int branchId = OpusMethods.getBranchId(session, request);
        int organizationalUnitId = OpusMethods.getOrganizationalUnitId2(session, request);
        fillOrganization(session, request, organization, organizationalUnitId, branchId, institutionId);
    }

    public Organization createAndFillOrganization(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return createAndFillOrganization(session, request);
    }

    public Organization createAndFillOrganization(HttpSession session, HttpServletRequest request) {
        Organization organization = new Organization();
        this.fillOrganization(session, request, organization);
        return organization;
    }

    /**
     * Set the values of the given organization object into the session.
     * 
     * @param session
     * @param organization
     */
    public void rememberOrganization(HttpSession session, final Organization organization) {

        session.setAttribute("institutionId", organization.getInstitutionId());
        session.setAttribute("branchId", organization.getBranchId());
        session.setAttribute("organizationalUnitId", organization.getOrganizationalUnitId());

    }

    /**
     * Create and fill navigation settings.
     */
    public NavigationSettings createAndFillNavigationSettings(HttpServletRequest request) {
        NavigationSettings navigationSettings = new NavigationSettings();
        fillNavigationSettings(request, navigationSettings);
        return navigationSettings;
    }

    public void fillNavigationSettings(HttpServletRequest request, NavigationSettings navigationSettings) {
        fillNavigationSettings(request, navigationSettings, null);
    }

    public void fillNavigationSettings(HttpServletRequest request, NavigationSettings navigationSettings, String action) {
        Integer tab = ServletUtil.getIntObject(request, "tab");
        if (tab != null) {
            navigationSettings.setTab(tab);
        }
        Integer panel = ServletUtil.getIntObject(request, "panel");
        if (panel != null) {
            navigationSettings.setPanel(panel);
        }
        // default currentPageNumber should never be 0, but 1
        Integer currentPageNumber = ServletUtil.getIntObject(request, "currentPageNumber");
        if (currentPageNumber != null && currentPageNumber != 0) {
            navigationSettings.setCurrentPageNumber(currentPageNumber);
        }
        String searchValue = request.getParameter("searchValue");
        if (!StringUtil.isNullOrEmpty(searchValue)) {
            navigationSettings.setSearchValue(searchValue);
        }
        navigationSettings.setAction(action);
    }

    /**
     * Fill given study settings with values from request only.
     * 
     * @param request
     * @param studySettings
     * @return
     */
    public StudySettings fillStudySettings(HttpServletRequest request, final StudySettings studySettings) {
        if (!StringUtil.isNullOrEmpty(request.getParameter("studyId"))) {
            studySettings.setStudyId(Integer.parseInt(request.getParameter("studyId")));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("studyGradeTypeId"))) {
            studySettings.setStudyGradeTypeId(Integer.parseInt(request.getParameter("studyGradeTypeId")));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("cardinalTimeUnitNumber"))) {
            studySettings.setCardinalTimeUnitNumber(Integer.parseInt(request.getParameter("cardinalTimeUnitNumber")));
        }
        if (!StringUtil.isNullOrEmpty(request.getParameter("academicYearId"))) {
            studySettings.setAcademicYearId(Integer.parseInt(request.getParameter("academicYearId")));
        }

        return studySettings;
    }

    /**
     * Fill given study settings with values from session or request.
     * 
     * @param session
     * @param request
     * @param studySettings
     */
    public void fillStudySettings(HttpSession session, HttpServletRequest request, final StudySettings studySettings) {
        Integer primaryStudyId = ServletUtil.getIntObject(session, request, "primaryStudyId");
        if (primaryStudyId != null) {
            studySettings.setStudyId(primaryStudyId);
        }

        Integer academicYearId = ServletUtil.getIntObject(session, request, "academicYearId");
        if (academicYearId != null) {
            studySettings.setAcademicYearId(academicYearId);
        }

        Integer studyGradeTypeId = ServletUtil.getIntObject(session, request, "studyGradeTypeId");
        if (studyGradeTypeId != null) {
            studySettings.setStudyGradeTypeId(studyGradeTypeId);
        }

        Integer cardinalTimeUnitNumber = ServletUtil.getIntObject(session, request, "cardinalTimeUnitNumber");
        if (cardinalTimeUnitNumber != null) {
            studySettings.setCardinalTimeUnitNumber(cardinalTimeUnitNumber);
        }

    }

    /**
     * Set the values of the given studySettings object into the session.
     * 
     * @param session
     * @param studySettings
     */
    public void rememberStudySettings(HttpSession session, final StudySettings studySettings) {

        session.setAttribute("primaryStudyId", studySettings.getStudyId());
        session.setAttribute("academicYearId", studySettings.getAcademicYearId());
        session.setAttribute("studyGradeTypeId", studySettings.getStudyGradeTypeId());
        session.setAttribute("cardinalTimeUnitNumber", studySettings.getCardinalTimeUnitNumber());
    }

    public Map<String, Object> fillOrganizationMapForOrganizationsAuthorization(HttpServletRequest request, final Organization organization) {

        Map<String, Object> map = new HashMap<>();

        if (request.isUserInRole(READ_ORG_UNITS)) {
            map.put("institutionId", organization.getInstitutionId());
            map.put("branchId", organization.getBranchId());
            map.put("organizationalUnitId", 0);
        } else {
            map.put("institutionId", organization.getInstitutionId());
            map.put("branchId", organization.getBranchId());
            map.put("organizationalUnitId", organization.getOrganizationalUnitId());
        }

        return map;
    }

    public Map<String, Object> fillOrganizationMapForReadAuthorization(HttpServletRequest request, final Organization organization) {
        /* MoVe - altered 20-12-2011 : use values from institution, branch, org unit if present */
        Map<String, Object> map = new HashMap<>();

        if (request.isUserInRole(READ_INSTITUTIONS)) {
            map.put("institutionId", organization.getInstitutionId());
            map.put("branchId", organization.getBranchId());
            map.put("organizationalUnitId", organization.getOrganizationalUnitId());
        } else {
            // if admin-C: do not specify branch,orgunit since there might be subjectblocks from other studies:
            if (request.isUserInRole(READ_BRANCHES)) {
                map.put("institutionId", organization.getInstitutionId());
                map.put("branchId", organization.getBranchId());
                map.put("organizationalUnitId", organization.getOrganizationalUnitId());
            } else {
                // if admin-B: do not specifiy orgunit,since there might be subjectblocks from other studies:
                if (request.isUserInRole(READ_ORG_UNITS)) {
                    map.put("institutionId", organization.getInstitutionId());
                    map.put("branchId", organization.getBranchId());
                    map.put("organizationalUnitId", organization.getOrganizationalUnitId());
                } else {
                    map.put("institutionId", organization.getInstitutionId());
                    map.put("branchId", organization.getBranchId());
                    map.put("organizationalUnitId", organization.getOrganizationalUnitId());
                }
            }
        }
        return map;
    }

    public Map<String, Object> fillOrganizationMapForReadStudyPlanAuthorization(HttpServletRequest request, final Organization organization) {

        Map<String, Object> map = new HashMap<>();
        HttpSession session = request.getSession(false);
        OrganizationAuthorization auth = (OrganizationAuthorization) session.getAttribute("organizationAuthorizationForRead");
        
            map.put("institutionId", auth.getInstitutionId());
            map.put("branchId", auth.getBranchId());
            map.put("organizationalUnitId", auth.getOrganizationalUnitId());
            
        return map;
    }

//        if (request.isUserInRole("READ_STUDY_PLANS")
//                || request.isUserInRole("READ_STUDYPLAN_RESULTS")
//                || request.isUserInRole("READ_OWN_STUDYPLAN_RESULTS")
//                ) {
//            // setting to 0 is treated the same as not specifying at all (ie. null)
//            // 0 or null: no limitation
//            map.put("institutionId", 0);
//            map.put("branchId", 0);
//            map.put("organizationalUnitId", 0);
//        } else {
//            // if admin-C: do not specify branch,orgunit since there might be subjectblocks from other studies:
//            if (request.isUserInRole("READ_BRANCHES")) {
//                map.put("institutionId", organization.getInstitutionId());
//                map.put("branchId", 0);
//                map.put("organizationalUnitId", 0);
//            } else {
//                // if admin-B: do not specifiy orgunit,since there might be subjectblocks from other studies:
//                if (request.isUserInRole("READ_ORG_UNITS")) {
//                    map.put("institutionId", organization.getInstitutionId());
//                    map.put("branchId", organization.getBranchId());
//                    map.put("organizationalUnitId", 0);
//                } else {
//                    map.put("institutionId", organization.getInstitutionId());
//                    map.put("branchId", organization.getBranchId());
//                    map.put("organizationalUnitId", organization.getOrganizationalUnitId());
//                }
//            }
//        }

    public Map<String, Object> fillOrganizationMapForWriteStudyPlanAuthorization(HttpServletRequest request, final Organization organization) {

        Map<String, Object> map = new HashMap<>();

        if (request.isUserInRole("CREATE_FOREIGN_STUDYPLANDETAILS") || request.isUserInRole("UPDATE_FOREIGN_STUDYPLANDETAILS")
                || request.isUserInRole("CREATE_OWN_STUDYPLANDETAILS") || request.isUserInRole("UPDATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL")
                || request.isUserInRole("CREATE_FOREIGN_STUDYPLAN_RESULTS") || request.isUserInRole("UPDATE_FOREIGN_STUDYPLAN_RESULTS")
                || request.isUserInRole("UPDATE_OWN_STUDYPLAN_RESULTS_PENDING_APPROVAL")) {
            map.put("institutionId", 0);
            map.put("branchId", 0);
            map.put("organizationalUnitId", 0);
        } else {
            // if admin-C: do not specify branch,orgunit since there might be subjectblocks from other studies:
            if (request.isUserInRole(READ_BRANCHES)) {
                map.put("institutionId", organization.getInstitutionId());
                map.put("branchId", 0);
                map.put("organizationalUnitId", 0);
            } else {
                // if admin-B: do not specify orgunit,since there might be subjectblocks from other studies:
                if (request.isUserInRole(READ_ORG_UNITS)) {
                    map.put("institutionId", organization.getInstitutionId());
                    map.put("branchId", organization.getBranchId());
                    map.put("organizationalUnitId", 0);
                } else {
                    map.put("institutionId", organization.getInstitutionId());
                    map.put("branchId", organization.getBranchId());
                    map.put("organizationalUnitId", organization.getOrganizationalUnitId());
                }
            }
        }
        return map;
    }
    
    /**
     * Fill the authorization object to represent to parts of the organizational hierarchy the user has READ access.
     * 
     * @param request
     *            servlet request
     * @return filled {@link OrganizationAuthorization} object
     */
    public OrganizationAuthorization fillOrganizationAuthorizationForRead(HttpServletRequest request) {
        OrganizationAuthorization auth = new OrganizationAuthorization();
        HttpSession session = request.getSession(false);

        if (!request.isUserInRole(READ_INSTITUTIONS)) {
            auth.setInstitutionId(getInstitutionIdForLoggedInUser(session));
        }

        if (!request.isUserInRole(READ_BRANCHES)) {
            auth.setBranchId(getBranchIdForLoggedInUser(session));
        }

        if (!request.isUserInRole(READ_ORG_UNITS)) {
            auth.setOrganizationalUnitId(getOrganizationalUnitIdForLoggedInUser(session));
        }

        return auth;
    }

    /**
     * Fill the authorization object to represent to parts of the organizational hierarchy the user has UPDATE access.
     * 
     * @param request
     *            servlet request
     * @return filled {@link OrganizationAuthorization} object
     */
    public OrganizationAuthorization fillOrganizationAuthorizationForUpdate(HttpServletRequest request) {
        OrganizationAuthorization auth = new OrganizationAuthorization();
        HttpSession session = request.getSession(false);

        if (!request.isUserInRole(UPDATE_INSTITUTIONS)) {
            auth.setInstitutionId(getInstitutionIdForLoggedInUser(session));
        }

        if (!request.isUserInRole(UPDATE_BRANCHES)) {
            auth.setBranchId(getBranchIdForLoggedInUser(session));
        }

        if (!request.isUserInRole(UPDATE_ORG_UNITS)) {
            auth.setOrganizationalUnitId(getOrganizationalUnitIdForLoggedInUser(session));
        }

        return auth;
    }

    public static Institution getInstitutionForLoggedInUser(HttpSession session) {
        return (Institution) session.getAttribute("institution");
    }

    public static int getInstitutionIdForLoggedInUser(HttpSession session) {
        // take "institution", not "institutionId" from session, because the latter may change
        Institution institution = getInstitutionForLoggedInUser(session);
        return institution.getId();
    }

    public static Branch getBranchForLoggedInUser(HttpSession session) {
        return (Branch) session.getAttribute("branch");
    }

    public static int getBranchIdForLoggedInUser(HttpSession session) {
        // take "branch", not " branchId" from session, because the latter may change
        Branch branch = getBranchForLoggedInUser(session);
        return branch.getId();
    }

    public static OrganizationalUnit getOrganizationalUnitForLoggedInUser(HttpSession session) {
        return (OrganizationalUnit) session.getAttribute("organizationalUnit");
    }

    public static int getOrganizationalUnitIdForLoggedInUser(HttpSession session) {
        // take "organizationalUnit", not "organizationalUnitId" from session, because the latter may change
        OrganizationalUnit organizationalUnit = getOrganizationalUnitForLoggedInUser(session);
        return organizationalUnit.getId();
    }

    public String getBrsPassingSubject(final Subject subject, final Study study, final Locale currentLoc) {
        String brsPassing = "";
        String endGradesPerGradeType = null;

        if (subject != null && subject.getBrsPassingSubject() != null && !"".equals(subject.getBrsPassingSubject())) {
            brsPassing = subject.getBrsPassingSubject();
        } else {
            if (subject != null) {
                endGradesPerGradeType = studyManager.findEndGradeType(subject.getCurrentAcademicYearId());
            }
            if (endGradesPerGradeType == null || "".equals(endGradesPerGradeType)) {
                if (study.getBRsPassingSubject() != null && !"".equals(study.getBRsPassingSubject())) {
                    brsPassing = study.getBRsPassingSubject();
                }
            } else {
                brsPassing = messageSource.getMessage("jsp.msg.endgrade.studygradetype.defined", null, currentLoc);
            }
        }
        return brsPassing;

    }

    /**
     * @param newStudyManager
     */
    public void setStudyManager(final StudyManagerInterface newStudyManager) {
        studyManager = newStudyManager;
    }

    /**
     * @param newInstitutionManager
     */
    public void setInstitutionManager(final InstitutionManagerInterface newInstitutionManager) {
        institutionManager = newInstitutionManager;
    }

    /**
     * @param newOrganizationalUnitManager
     */
    public void setOrganizationalUnitManager(final OrganizationalUnitManagerInterface newOrganizationalUnitManager) {
        organizationalUnitManager = newOrganizationalUnitManager;
    }

    public void setLookupManager(LookupManagerInterface lookupManager) {
        this.lookupManager = lookupManager;
    }

    public void setWriteWhoWhen(Object domainObj, HttpSession session) {
        OpusUser opusUser = this.getOpusUser();
        try {
            // TODO make a Domain interface with writeWho and writeWhen setters, instead of using setSimpleProperty
            PropertyUtils.setSimpleProperty(domainObj, "writeWho", opusUser.getUsername() + ":" + opusUser.getId());
            PropertyUtils.setSimpleProperty(domainObj, "writeWhen", new Date());
        } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Converts object to map
     * 
     * @throws IllegalAccessException
     * @throws IllegalArgumentException
     */
    public static <T> Map<String, Object> toMap(T obj) throws IllegalArgumentException, IllegalAccessException {

        Field[] classFields = obj.getClass().getDeclaredFields();
        Field[] superClassfields = obj.getClass().getSuperclass().getDeclaredFields();

        ArrayList<Field> allFields = new ArrayList<>();

        Map<String, Object> mappedObject = new HashMap<>();

        for (Field field : classFields) {
            allFields.add(field);
        }

        for (Field field : superClassfields) {
            allFields.add(field);
        }

        // add fields and reespective values to map
        for (Field field : allFields) {
            mappedObject.put(field.getName(), field.get(obj));
        }

        return mappedObject;

    }

    public List<Module> getModules(WebApplicationContext webContext) {
        Map<String, Module> moduleMap = webContext.getBeansOfType(Module.class);
        List<Module> modules = new ArrayList<>((Collection<Module>) moduleMap.values());
        return modules;
    }

    /**
     * 
     */
    public HttpSession setInitParams(WebApplicationContext webContext, ServletContext context, HttpSession session) {

        if (log.isDebugEnabled()) {
            log.debug("Opusmethods.setInitParams entered...");
        }

        String iMaxCardinalTimeUnits = context.getInitParameter("init.maxcardinaltimeunits");
        session.setAttribute("iMaxCardinalTimeUnits", iMaxCardinalTimeUnits);
        if (log.isDebugEnabled()) {
            log.debug("Opusmethods.setInitParams iMaxCardinalTimeUnits = " + session.getAttribute("iMaxCardinalTimeUnits"));
        }
        String iMaxSubjectsPerCardinalTimeUnit = context.getInitParameter("init.maxsubjectspercardinaltimeunit");
        session.setAttribute("iMaxSubjectsPerCardinalTimeUnit", iMaxSubjectsPerCardinalTimeUnit);
        String iMaxFailedSubjectsPerCardinalTimeUnit = context.getInitParameter("init.maxfailedsubjectspercardinaltimeunit");
        session.setAttribute("iMaxFailedSubjectsPerCardinalTimeUnit", iMaxFailedSubjectsPerCardinalTimeUnit);

        String iFeeDiscountPercentages = context.getInitParameter("init.feediscountpercentages");
        session.setAttribute("iFeeDiscountPercentages", iFeeDiscountPercentages);

        String iUseOfPartTimeStudyGradeTypes = context.getInitParameter("init.useofparttimestudygradetypes");
        session.setAttribute("iUseOfPartTimeStudyGradeTypes", iUseOfPartTimeStudyGradeTypes);

        String imageMime = context.getInitParameter("image_mime");
        session.setAttribute("imageMime", imageMime);
        String docMime = context.getInitParameter("doc_mime");
        session.setAttribute("docMime", docMime);

        return session;

    }

    public static List<String> getImageMimeTypes(HttpSession session) {
        String imagetypes = (String) session.getAttribute("imageMime");
        String[] imagetypeslist = imagetypes.split(",\\s*");
        return Arrays.asList(imagetypeslist);
    }

    public static List<String> getDocMimeTypes(HttpSession session) {
        String doctypes = (String) session.getAttribute("docMime");
        String[] doctypeslist = doctypes.split(",\\s*");
        return Arrays.asList(doctypeslist);
    }

    /**
     * The string that shall be written into the writeWho column for database operations.
     * 
     * NB: If there is no logged in user (like in admission of a new student), the writeWho will be read from the "writeWho" attribute on
     * the HttpServletRequest. The "writeWho" attribute needs to be put on the request manually.
     * 
     * @param request
     * @return
     */
    public String getWriteWho(HttpServletRequest request) {

        // For pages where no user is logged, e.g. admission: writeWho needs to be put on the request
        String writeWho = (String) request.getAttribute("writeWho");

        // Just be on the safe side: also check Spring's RequestContextHolder
        if (writeWho == null) {
            HttpServletRequest request2 = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
            writeWho = (String) request2.getAttribute("writeWho");
        }

        // For all other pages: get the logged in user information
        if (writeWho == null) {
            OpusUser opusUser = this.getOpusUser();
            writeWho = opusUser.getUsername() + ":" + opusUser.getId();
        }
        return writeWho;
    }

    public boolean checkTotalNumberOfSubjects(List<SecondarySchoolSubjectGroup> secondarySchoolSubjectGroups, int numberOfSubjectsToGrade) {
        int counter = 0;
        for (SecondarySchoolSubjectGroup group : secondarySchoolSubjectGroups) {
            List<SecondarySchoolSubject> subjects = group.getSecondarySchoolSubjects();
            counter = counter + subjects.size();
        }
        if (counter >= numberOfSubjectsToGrade) {
            return true;
        }
        return false;
    }

    public boolean checkNumberOfSubjectsInGroup(final SecondarySchoolSubjectGroup group) {
        int maxToGrade = group.getMaxNumberToGrade();
        List<SecondarySchoolSubject> subjects = group.getSecondarySchoolSubjects();
        if (subjects.size() >= maxToGrade) {
            return true;
        } else {
            return false;
        }
    }

    public void sendBulkMail(String[] recipients, String msgType, String extendedMsg, String preferredLanguage, String fileName) {

        boolean debug = false;
        String msgSubject = "";
        String msgBody = "";
        String msgSender = "";
        String attachmentDir = System.getProperty("basedir", ".") + "/" + "attachments" + "/";
        String fullFileName = null;

        // Set the host smtp address
        Properties props = new Properties();
        String smtpBulkServerAddress = null;

        List<? extends AppConfigAttribute> appConfig = getAppConfig();
        for (int i = 0; i < appConfig.size(); i++) {
            if ("smtpBulkServerAddress".equals(appConfig.get(i).getAppConfigAttributeName())) {
                smtpBulkServerAddress = appConfig.get(i).getAppConfigAttributeValue();
                break;
            }
        }
        props.put("mail.smtp.host", smtpBulkServerAddress);

        msgSubject = generalManager.findMailConfigProperty(msgType, "msgSubject", preferredLanguage);
        msgBody = generalManager.findMailConfigProperty(msgType, "msgBody", preferredLanguage);
        if (extendedMsg != null) {
            msgBody = msgBody + "<br/><br/>" + extendedMsg;
        }
        msgSender = generalManager.findMailConfigProperty(msgType, "msgSender", preferredLanguage);

        // create some properties and get the default Session
        Session session = Session.getDefaultInstance(props, null);
        session.setDebug(debug);

        // create a message
        Message msg = new MimeMessage(session);

        // Compose the message
        InternetAddress addressFrom;
        try {
            addressFrom = new InternetAddress(msgSender);
            msg.setFrom(addressFrom);

            InternetAddress[] addressTo = new InternetAddress[recipients.length];
            for (int i = 0; i < recipients.length; i++) {
                addressTo[i] = new InternetAddress(recipients[i]);
            }
            msg.setRecipients(Message.RecipientType.TO, addressTo);

            // Optional : You can also set your custom headers in the Email if you Want
            msg.addHeader("MyHeaderName", "opusMail");

            // Setting the Subject and Content Type
            msg.setSubject(msgSubject);

            // make distinction between just a text-message or with file attachment:
            if (fileName == null) {
                if (log.isDebugEnabled()) {
                    log.debug("OpusMethods.sendBulkMail: mail in plain text, msgType: " + msgType);
                }
                // Setting the Content Type
                msg.setContent(msgBody, "text/plain");
            } else {
                fullFileName = attachmentDir + fileName;
                if (log.isDebugEnabled()) {
                    log.debug("OpusMethods.sendBulkMail: mail with attachment, msgType: " + msgType + ", fullFileName =" + fullFileName);
                }

                // create the message part
                MimeBodyPart messageBodyPart = new MimeBodyPart();

                // fill message
                messageBodyPart.setText(msgBody);

                Multipart multipart = new MimeMultipart();
                multipart.addBodyPart(messageBodyPart);

                // Part two is attachment
                messageBodyPart = new MimeBodyPart();
                DataSource source = new FileDataSource(fullFileName);

                messageBodyPart.setDataHandler(new DataHandler(source));
                messageBodyPart.setFileName(fullFileName);
                multipart.addBodyPart(messageBodyPart);

                // Put parts in message
                msg.setContent(multipart);
            }

        } catch (MessagingException m) {
            log.error("Composing bulk message not succeeded: " + m.getMessage());
            generalManager.logMailError(recipients, msgSubject, msgSender, m.getMessage());
        }

        // Send the message
        try {
            Transport.send(msg);
        } catch (MessagingException m) {
            log.error("Sending bulk message not succeeded: " + m.getMessage());
            generalManager.logMailError(recipients, msgSubject, msgSender, m.getMessage());
        }

    }

    public void sendMail(String[] recipients, String msgType, String preferredLanguage, String extendedMsg, String fileName) {

        boolean debug = false;
        String msgSubject = "";
        String msgBody = "";
        String msgSender = "";
        String attachmentDir = System.getProperty("basedir", ".") + "/" + "attachments" + "/";
        String fullFileName = null;

        if (log.isDebugEnabled()) {
            log.debug("OpusMethods.sendMail reached with :" + recipients.toString() + ", " + msgType + ", " + preferredLanguage);
        }
        // Set the host smtp address
        Properties props = new Properties();
        String smtpServerAddress = null;

        List<? extends AppConfigAttribute> appConfig = getAppConfig();
        for (int i = 0; i < appConfig.size(); i++) {
            if ("smtpServerAddress".equals(appConfig.get(i).getAppConfigAttributeName())) {
                smtpServerAddress = appConfig.get(i).getAppConfigAttributeValue();
                break;
            }
        }
        props.put("mail.smtp.host", smtpServerAddress);

        msgSubject = generalManager.findMailConfigProperty(msgType, "msgSubject", preferredLanguage);
        msgBody = generalManager.findMailConfigProperty(msgType, "msgBody", preferredLanguage);
        if (extendedMsg != null) {
            msgBody = msgBody + "<br/><br/>" + extendedMsg;
        }
        msgSender = generalManager.findMailConfigProperty(msgType, "msgSender", preferredLanguage);

        // create some properties and get the default Session
        Session session = Session.getDefaultInstance(props, null);
        session.setDebug(debug);

        // create a message
        Message msg = new MimeMessage(session);

        // Compose the message
        InternetAddress addressFrom;
        try {
            addressFrom = new InternetAddress(msgSender);
            msg.setFrom(addressFrom);

            InternetAddress[] addressTo = new InternetAddress[recipients.length];
            for (int i = 0; i < recipients.length; i++) {
                addressTo[i] = new InternetAddress(recipients[i]);
            }
            msg.setRecipients(Message.RecipientType.TO, addressTo);

            // Optional : You can also set your custom headers in the Email if you Want
            msg.addHeader("MyHeaderName", "opusMail");

            // Setting the Subject
            msg.setSubject(msgSubject);

            // make distinction between just a text-message or with file attachment:
            if (fileName == null) {
                if (log.isDebugEnabled()) {
                    log.debug("OpusMethods.sendBulkMail: mail in plain text, msgType: " + msgType);
                }
                // Setting the Content Type
                msg.setContent(msgBody, "text/plain");
            } else {
                fullFileName = attachmentDir + fileName;

                if (log.isDebugEnabled()) {
                    log.debug("OpusMethods.sendMail: mail with attachment, msgType: " + msgType + ", fullFileName =" + fullFileName);
                }

                // create the message part
                MimeBodyPart messageBodyPart = new MimeBodyPart();

                // fill message
                messageBodyPart.setText(msgBody);

                Multipart multipart = new MimeMultipart();
                multipart.addBodyPart(messageBodyPart);

                // Part two is attachment
                messageBodyPart = new MimeBodyPart();
                DataSource source = new FileDataSource(fullFileName);
                messageBodyPart.setDataHandler(new DataHandler(source));
                messageBodyPart.setFileName(fileName);
                multipart.addBodyPart(messageBodyPart);

                // Put parts in message
                msg.setContent(multipart);
            }
        } catch (MessagingException m) {
            log.error("Composing message not succeeded: " + m.getMessage());
            generalManager.logMailError(recipients, msgSubject, msgSender, m.getMessage());
        }

        // Send the message
        try {
            Transport.send(msg);
        } catch (MessagingException m) {
            log.error("Sending message not succeeded: " + m.getMessage());
            generalManager.logMailError(recipients, msgSubject, msgSender, m.getMessage());
        }

    }

    /**
     * Sends simple mail message
     * 
     * @param mailSender
     *            - object encapsulating mail settings
     * @param sender
     *            - the email address of that sending the email e.g stelio.macumbe@gmail.com
     * @param recipients
     *            - list of email addresses of recipients
     * @param subject
     *            - subject of email message
     * @param text
     *            - content text of the email
     */
    public void sendMail(OpusMailSender mailSender, String sender, String[] recipients, String subject, String text) {

        SimpleMailMessage simpleMailMessage = new SimpleMailMessage();

        simpleMailMessage.setFrom(sender);
        simpleMailMessage.setTo(recipients);
        simpleMailMessage.setSubject(subject);
        simpleMailMessage.setText(text);

        mailSender.send(simpleMailMessage);

    }

    /**
     * Sends mail with attachments
     * 
     * @param mailSender
     *            - object encapsulating mail settings
     * @param sender
     *            - the email address of that sending the email e.g stelio.macumbe@gmail.com
     * @param recipients
     *            - list of email addresses of recipients
     * @param subject
     *            - subject of email message
     * @param text
     *            - content text of the email
     * @param fileNames
     *            - list of full path of files to attach
     */
    public void sendMail(OpusMailSender mailSender, String sender, String[] recipients, String subject, String text, String[] fileNames) {

        MimeMessage message = mailSender.createMimeMessage();

        try {

            MimeMessageHelper helper = new MimeMessageHelper(message, true);

            helper.setFrom(sender);
            helper.setTo(recipients);
            helper.setSubject(subject);
            helper.setText(text);

            if ((fileNames != null) && (fileNames.length > 0)) {

                for (String fileName : fileNames) {

                    FileSystemResource file = new FileSystemResource(fileName);
                    helper.addAttachment(file.getFilename(), file);
                }

            }

        } catch (MessagingException e) {

            throw new MailParseException(e);
        }

        mailSender.send(message);

    }

    /**
     * Send an institution mail, the difference between this method and sendMail is that the host settings and messages details are
     * retrieved from the app configuration , ie. red from the database
     * 
     * @param mailSender
     * @param msgType
     * @param recipients
     * @param preferredLanguage
     * @param extendedMsg
     * @param fileNames
     */
    public void sendOpusMail(OpusMailSender mailSender, String msgType, String[] recipients, String preferredLanguage, String extendedMsg, String[] fileNames) {

        List<? extends AppConfigAttribute> appConfig = getAppConfig();
        for (int i = 0; i < appConfig.size(); i++) {
            if ("smtpServerAddress".equals(appConfig.get(i).getAppConfigAttributeName())) {
                mailSender.setHost(appConfig.get(i).getAppConfigAttributeValue());
                break;
            }
        }

        String msgSubject = generalManager.findMailConfigProperty(msgType, "msgSubject", preferredLanguage);
        String msgBody = generalManager.findMailConfigProperty(msgType, "msgBody", preferredLanguage);
        String msgSender = generalManager.findMailConfigProperty(msgType, "msgSender", preferredLanguage);

        if (extendedMsg != null) {
            msgBody = msgBody + "<br/><br/>" + extendedMsg;
        }

        sendMail(mailSender, msgSender, recipients, msgSubject, msgBody, fileNames);
    }

    /**
     * check if a given grade type is a bachelor
     * 
     * @param gradeTypeCode
     *            code of the grade type to check
     * @return if the grade type is a bachelor return true, otherwise return false
     */
    public boolean isGradeTypeIsBachelor(final String preferredLanguage, final String gradeTypeCode) {

        Lookup9 gradeType = tryToGetGradeType(preferredLanguage, gradeTypeCode);
        if (gradeType == null) {
            return false;
        }

        if (OpusConstants.GRADE_TYPE_BACHELOR.equals(gradeType.getEducationLevelCode())) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * check if a given grade type is a master
     * 
     * @param gradeTypeCode
     *            code of the grade type to check
     * @return if the grade type is a master return true, otherwise return false
     */
    public boolean isGradeTypeIsMaster(final String preferredLanguage, final String gradeTypeCode) {

        Lookup9 gradeType = tryToGetGradeType(preferredLanguage, gradeTypeCode);
        if (gradeType == null) {
            return false;
        }

        if (OpusConstants.GRADE_TYPE_MASTER.equals(gradeType.getEducationLevelCode())) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * Warns if the given gradeTypeCode is invalid.
     * 
     * @return null if no gradeType found
     */
    private Lookup9 tryToGetGradeType(final String preferredLanguage, final String gradeTypeCode) {
        if (gradeTypeCode == null) {
            return null;
        }

        Lookup9 gradeType = (Lookup9) lookupManager.findLookup(preferredLanguage, gradeTypeCode, "gradeType");
        if (gradeType == null) {
            log.warn("Unknown gradetypecode for which no gradetype record exists: " + gradeTypeCode);
            return null;
        }
        return gradeType;
    }

    /**
     * Set session variables such as appVersions and appConfig.
     * 
     * @param request
     */
    public void fillParamsAtStartUp(HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        ServletContext context = session.getServletContext();

        session.removeAttribute("menuChoice");

        // set all module app + db-versions on session:
        session.setAttribute("appVersions", this.getAppVersions());

        // set all configuration attributes on session:
        List<AppConfigAttribute> appConfig = null;
        appConfig = this.getAppConfig();
        session.setAttribute("appConfig", appConfig);

        // Important: No provision yet for branchId
        // The map should automatically look at the branchId of the logged-in user and take the appConfig value for the branchId
        Map<String, Object> appConfigMap = new HashMap<>();
        for (AppConfigAttribute i : appConfig) {
            if (i.getBranchId() == null) {
                appConfigMap.put(i.getAppConfigAttributeName(), i.getAppConfigAttributeValue());
            }
        }
        session.setAttribute("appConfigMap", appConfigMap);

        WebApplicationContext webContext = WebApplicationContextUtils.getWebApplicationContext(context);

        this.setInitParams(webContext, context, session);

        /* perform session-check. If wrong, this throws an Exception towards ErrorController */
        securityChecker.checkSessionValid(session);

    }

    public OpusUser getOpusUser() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return (OpusUser) principal;
    }

    public boolean isStudent() {
        OpusUser opusUser = getOpusUser();
        boolean isStudent = opusUser.getStudent() != null;
        return isStudent;
    }

    public boolean isStaffMember() {
        OpusUser opusUser = getOpusUser();
        boolean isStaffMember = opusUser.getStaffMember() != null;
        return isStaffMember;
    }

}
