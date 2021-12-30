package org.uci.opus.accommodation.web.form;

import java.util.List;

import org.uci.opus.accommodation.domain.Hostel;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.CodeToLookupMap;

public class HostelsForm {

    private String hostelTypeCode;
    private NavigationSettings navigationSettings;
    private List<Hostel> allHostels;
    private List<Lookup> allHostelTypes;
    private CodeToLookupMap codeToHostelTypeMap;
    

    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setAllHostels(List<Hostel> allHostels) {
        this.allHostels = allHostels;
    }

    public List<Hostel> getAllHostels() {
        return allHostels;
    }

    public void setAllHostelTypes(List<Lookup> allHostelTypes) {
        this.allHostelTypes = allHostelTypes;
    }

    public List<Lookup> getAllHostelTypes() {
        return allHostelTypes;
    }

    public void setCodeToHostelTypeMap(CodeToLookupMap codeToHostelTypeMap) {
        this.codeToHostelTypeMap = codeToHostelTypeMap;
    }

    public CodeToLookupMap getCodeToHostelTypeMap() {
        return codeToHostelTypeMap;
    }

    public void setHostelTypeCode(String hostelTypeCode) {
        this.hostelTypeCode = hostelTypeCode;
    }

    public String getHostelTypeCode() {
        return hostelTypeCode;
    }

}
