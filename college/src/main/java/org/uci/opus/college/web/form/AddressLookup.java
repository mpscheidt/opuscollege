package org.uci.opus.college.web.form;

import java.util.List;

import org.uci.opus.college.domain.Lookup2;
import org.uci.opus.college.domain.Lookup3;
import org.uci.opus.college.domain.Lookup4;
import org.uci.opus.college.domain.Lookup5;

/**
 * Data that needs to be dynamically loaded, such lists of provinces and districts.
s * 
 * @author Markus Pscheidt
 *
 */
public class AddressLookup {

    private String lang;
    
    private List<Lookup3> allCountries;
    private List<Lookup5> allProvinces;
    private List<Lookup2> allDistricts;
    private List<Lookup4> allAdministrativePosts;

    public AddressLookup(String lang) {
        this.lang = lang;
    }

    public List<Lookup3> getAllCountries() {
        return allCountries;
    }

    public void setAllCountries(List<Lookup3> allCountries) {
        this.allCountries = allCountries;
    }

    public List<Lookup5> getAllProvinces() {
        return allProvinces;
    }

    public void setAllProvinces(List<Lookup5> allProvinces) {
        this.allProvinces = allProvinces;
    }

    public List<Lookup2> getAllDistricts() {
        return allDistricts;
    }

    public void setAllDistricts(List<Lookup2> allDistricts) {
        this.allDistricts = allDistricts;
    }

    public List<Lookup4> getAllAdministrativePosts() {
        return allAdministrativePosts;
    }

    public void setAllAdministrativePosts(List<Lookup4> allAdministrativePosts) {
        this.allAdministrativePosts = allAdministrativePosts;
    }

    public String getLang() {
        return lang;
    }

    public void setLang(String lang) {
        this.lang = lang;
    }

}
