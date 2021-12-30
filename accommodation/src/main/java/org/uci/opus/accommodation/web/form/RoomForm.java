package org.uci.opus.accommodation.web.form;

import java.util.List;

import org.uci.opus.accommodation.domain.Hostel;
import org.uci.opus.accommodation.domain.HostelBlock;
import org.uci.opus.accommodation.domain.Room;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.web.form.NavigationSettings;

public class RoomForm {

    private NavigationSettings navigationSettings;
    private Room room;
    private List<Hostel> allHostels;
    private boolean useHostelBlock;
    private List<HostelBlock> allHostelBlocks;
    private List<Lookup> allRoomTypes;


    public void setRoom(Room room) {
        this.room = room;
    }

    public Room getRoom() {
        return room;
    }

    public void setAllHostels(List<Hostel> allHostels) {
        this.allHostels = allHostels;
    }

    public List<Hostel> getAllHostels() {
        return allHostels;
    }

    public void setUseHostelBlock(boolean useHostelBlock) {
        this.useHostelBlock = useHostelBlock;
    }

    public boolean isUseHostelBlock() {
        return useHostelBlock;
    }

    public List<HostelBlock> getAllHostelBlocks() {
        return allHostelBlocks;
    }

    public void setAllHostelBlocks(List<HostelBlock> allHostelBlocks) {
        this.allHostelBlocks = allHostelBlocks;
    }

    public List<Lookup> getAllRoomTypes() {
        return allRoomTypes;
    }

    public void setAllRoomTypes(List<Lookup> allRoomTypes) {
        this.allRoomTypes = allRoomTypes;
    }

    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }
    
}
