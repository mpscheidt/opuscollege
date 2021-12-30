package org.uci.opus.accommodation.web.form;

import java.util.List;

import org.uci.opus.accommodation.domain.Hostel;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.web.form.NavigationSettings;

public class HostelForm {

    private NavigationSettings navigationSettings;
    private Hostel hostel;
    private List<Lookup> allHostelTypes;


    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setHostel(Hostel hostel) {
        this.hostel = hostel;
    }

    public Hostel getHostel() {
        return hostel;
    }

    public void setAllHostelTypes(List<Lookup> allHostelTypes) {
        this.allHostelTypes = allHostelTypes;
    }

    public List<Lookup> getAllHostelTypes() {
        return allHostelTypes;
    }


}
