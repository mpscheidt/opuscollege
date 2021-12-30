package org.uci.opus.accommodation.web.form;

import java.util.List;

import org.uci.opus.accommodation.domain.Hostel;
import org.uci.opus.accommodation.domain.HostelBlock;
import org.uci.opus.accommodation.domain.Room;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.web.form.NavigationSettings;
import org.uci.opus.util.CodeToLookupMap;

public class RoomsForm {

    private String hostelTypeCode;
    private int hostelId;
    private int hostelBlockId;
    private String roomTypeCode;
    private CodeToLookupMap codeToRoomTypeMap;
    
    private NavigationSettings navigationSettings;
    private List<Lookup> allHostelTypes;
    private List<Hostel> allHostels;
    private List<HostelBlock> allHostelBlocks;
    private List<Lookup> allRoomTypes;
    private List<Room> allRooms;
    
    private boolean useHostelBlock;

    public List<Lookup> getAllHostelTypes() {
        return allHostelTypes;
    }
    public void setAllHostelTypes(List<Lookup> allHostelTypes) {
        this.allHostelTypes = allHostelTypes;
    }
    public List<Hostel> getAllHostels() {
        return allHostels;
    }
    public void setAllHostels(List<Hostel> allHostels) {
        this.allHostels = allHostels;
    }
    public List<HostelBlock> getAllHostelBlocks() {
        return allHostelBlocks;
    }
    public void setAllHostelBlocks(List<HostelBlock> allHostelBlocks) {
        this.allHostelBlocks = allHostelBlocks;
    }
    public void setAllRoomTypes(List<Lookup> allRoomTypes) {
        this.allRoomTypes = allRoomTypes;
    }
    public List<Lookup> getAllRoomTypes() {
        return allRoomTypes;
    }
    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }
    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }
    public void setAllRooms(List<Room> allRooms) {
        this.allRooms = allRooms;
    }
    public List<Room> getAllRooms() {
        return allRooms;
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
    public int getHostelBlockId() {
        return hostelBlockId;
    }
    public void setHostelBlockId(int hostelBlockId) {
        this.hostelBlockId = hostelBlockId;
    }
    public String getRoomTypeCode() {
        return roomTypeCode;
    }
    public void setRoomTypeCode(String roomTypeCode) {
        this.roomTypeCode = roomTypeCode;
    }
    public void setCodeToRoomTypeMap(CodeToLookupMap codeToRoomTypeMap) {
        this.codeToRoomTypeMap = codeToRoomTypeMap;
    }
    public CodeToLookupMap getCodeToRoomTypeMap() {
        return codeToRoomTypeMap;
    }
    public void setUseHostelBlock(boolean useHostelBlock) {
        this.useHostelBlock = useHostelBlock;
    }
    public boolean isUseHostelBlock() {
        return useHostelBlock;
    }

}
