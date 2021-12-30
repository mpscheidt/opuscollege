package org.uci.opus.accommodation.web.form;

import java.util.List;

import org.uci.opus.accommodation.domain.Hostel;
import org.uci.opus.accommodation.domain.HostelBlock;
import org.uci.opus.college.web.form.NavigationSettings;

public class HostelBlockForm {

    private NavigationSettings navigationSettings;
    private HostelBlock hostelBlock;
    private List<Hostel> allHostels;
    
    
    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }
    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }
    public HostelBlock getHostelBlock() {
        return hostelBlock;
    }
    public void setHostelBlock(HostelBlock block) {
        this.hostelBlock = block;
    }
    public void setAllHostels(List<Hostel> allHostels) {
        this.allHostels = allHostels;
    }
    public List<Hostel> getAllHostels() {
        return allHostels;
    }

}
