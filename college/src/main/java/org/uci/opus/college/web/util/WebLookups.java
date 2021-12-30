package org.uci.opus.college.web.util;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.Lookup10;
import org.uci.opus.college.domain.Lookup3;
import org.uci.opus.college.domain.Lookup5;
import org.uci.opus.college.domain.Lookup7;
import org.uci.opus.college.domain.Lookup9;
import org.uci.opus.util.LookupCacher;
import org.uci.opus.util.LookupLists;
import org.uci.opus.util.LookupMaps;
import org.uci.opus.util.OpusMethods;

/**
 * Provide access to lookups, taking into account the language of the logged in user.
 * 
 * @author Markus Pscheidt
 *
 */
@Service
@Scope("request")
public class WebLookups {

    private LookupCacher lookupCacher;

    /**
     * With the bean "request" scope, we can auto-wire the current user's request. Nice.
     */
    @Autowired
    private HttpServletRequest request;

    @Autowired
    public WebLookups(LookupCacher lookupCacher) {
        this.lookupCacher = lookupCacher;
    }

    private String getLang() {
        return OpusMethods.getPreferredLanguage(request);
    }
    
    public LookupLists getList() {
        return lookupCacher.getLookupLists(getLang());
    }

    public LookupMaps getMap() {
        return lookupCacher.getLookupMaps(getLang());
    }

    // --
    // -- the following are just for convenience, prefer getList() and getMap() for all lookups!
    // --
    
    public List<Lookup> getAllAcademicFields() {
        return lookupCacher.getAllAcademicFields(getLang());
    }

    public List<Lookup> getAllAddressTypes() {
        return lookupCacher.getAllAddressTypes(getLang());
    }

    public List<Lookup> getAllCardinalTimeUnitStatuses() {
        return lookupCacher.getAllCardinalTimeUnitStatuses(getLang());
    }

    public List<Lookup3> getAllCountries() {
        return lookupCacher.getAllCountries(getLang());
    }

    public List<Lookup> getAllEducationAreas() {
        return lookupCacher.getAllEducationAreas(getLang());
    }

    public List<Lookup> getAllEducationLevels() {
        return lookupCacher.getAllEducationLevels(getLang());
    }

    public List<Lookup10> getAllExaminationTypes() {
        return lookupCacher.getAllExaminationTypes(getLang());
    }

    public List<Lookup9> getAllGradeTypes() {
        return lookupCacher.getAllGradeTypes(getLang());
    }

    public List<Lookup> getAllImportanceTypes() {
        return lookupCacher.getAllImportanceTypes(getLang());
    }

    public List<Lookup> getAllLevelsOfEducation() {
        return lookupCacher.getAllLevelsOfEducation(getLang());
    }

    public List<Lookup> getAllNationalityGroups() {
        return lookupCacher.getAllNationalityGroups(getLang());
    }

    public List<Lookup7> getAllProgressStatuses() {
        return lookupCacher.getAllProgressStatuses(getLang());
    }

    public List<Lookup5> getAllProvinces() {
        return lookupCacher.getAllProvinces(getLang());
    }

    public List<Lookup> getAllRigidityTypes() {
        return lookupCacher.getAllRigidityTypes(getLang());
    }

    public List<Lookup> getAllStudyForms() {
        return lookupCacher.getAllStudyForms(getLang());
    }

    public List<Lookup> getAllStudentStatuses() {
        return lookupCacher.getAllStudentStatuses(getLang());
    }

    public List<Lookup> getAllStudyIntensities() {
        return lookupCacher.getAllStudyIntensities(getLang());
    }

    public List<Lookup> getAllStudyPlanStatuses() {
        return lookupCacher.getAllStudyPlanStatuses(getLang());
    }

    public List<Lookup> getAllStudyTimes() {
        return lookupCacher.getAllStudyTimes(getLang());
    }

    public List<Lookup> getAllInstitutionTypes() {
        return lookupCacher.getAllInstitutionTypes(getLang());
    }

    public List<Lookup> getAllUnitAreas() {
        return lookupCacher.getAllUnitAreas(getLang());
    }

    public List<Lookup> getAllUnitTypes() {
        return lookupCacher.getAllUnitTypes(getLang());
    }

}
