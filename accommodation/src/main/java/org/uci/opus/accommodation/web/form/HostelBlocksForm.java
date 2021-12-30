package org.uci.opus.accommodation.web.form;

import java.util.List;

import org.uci.opus.accommodation.domain.Hostel;
import org.uci.opus.accommodation.domain.HostelBlock;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.web.form.NavigationSettings;

public class HostelBlocksForm {

    private NavigationSettings navigationSettings;
    private List<HostelBlock> allHostelBlocks;
    private List<Lookup> allHostelTypes;
    private List<Hostel> allHostels;
    private String hostelTypeCode;
    private int hostelId;
    
    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }
    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }
    public List<HostelBlock> getAllHostelBlocks() {
        return allHostelBlocks;
    }
    public void setAllHostelBlocks(List<HostelBlock> allHostelBlocks) {
        this.allHostelBlocks = allHostelBlocks;
    }
    public void setAllHostelTypes(List<Lookup> allHostelTypes) {
        this.allHostelTypes = allHostelTypes;
    }
    public List<Lookup> getAllHostelTypes() {
        return allHostelTypes;
    }
    public void setAllHostels(List<Hostel> allHostels) {
        this.allHostels = allHostels;
    }
    public List<Hostel> getAllHostels() {
        return allHostels;
    }
    public String getHostelTypeCode() {
        return hostelTypeCode;
    }
    public void setHostelTypeCode(String hostelTypeCode) {
        this.hostelTypeCode = hostelTypeCode;
    }
    public int getHostelId() {
        return hostelId;
    }
    public void setHostelId(int hostelId) {
        this.hostelId = hostelId;
    }
    

}
